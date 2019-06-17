var tabobject = null;
var Incident_Tab = null;
var Fall_Tab = null;
var Seizure_Tab = null;
var _SignSection;
var SaveSucess = null;
var signOnCallBack = false;
var ButtonClicked;

function ManageToolbarItems() {
    ShowToolbarItems('Print');
}

function SetCurrentTab(sender, e) {
    try {
        TabIndex = sender.activeTabIndex;
    }
    catch (err) { }
}

function onTabSelectedClient(sender, args) {
    onTabSelected(sender, args, false);
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
    ShowHideTextBox();
    if (TabIndex == 0 || dom.find("CustomIncidentReports: IncidentReportId").text() != -1) {
        SetIncidentCategory(dom, action);
    }
    //SetTabsSecondaryCategory();
    HideDropDown();
    IncidentSectionsShowHide();
    if (dom.find("CustomIncidentReportGenerals: IncidentReportId").text() == -1) {
        $('#TextBoxTime_CustomIncidentReportGenerals_GeneralDateOfIncident').val('');
        $('#TextBoxTime_CustomIncidentReportGenerals_GeneralDateStaffNotified').val('');
    }
    var SignedBy;
    var SignedDate;
    var _LoggedInUserId = objectPageResponse.LoggedInUserId;

    var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
    if (CurStatus == 22) {
        //  $('#GeneralTable').find("input,textarea,select").attr("disabled", "disabled");
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory]").attr("disabled", "disabled");
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").attr("disabled", "disabled");
    }
    if (CurStatus != 22) {
        $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
        $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
        $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
    }
    if (TabIndex == 1) {
        var CurFallStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails", "CurrentStatus");
        if (CurFallStatus != 22) {
            $('#ButtonFallFollowUpIndividualStatusSign').attr("disabled", "disabled");
            $('#ButtonFallSupervisorFollowUpSign').attr("disabled", "disabled");
            $('#ButtonFallAdministratorReviewSign').attr("disabled", "disabled");
        }
    }
    if (TabIndex == 2) {
        var CurSeizureStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails", "CurrentStatus");
        if (CurSeizureStatus != 22) {
            $('#ButtonSeizureFollowUpIndividualStatusSign').attr("disabled", "disabled");
            $('#ButtonSeizureSupervisorFollowUpSign').attr("disabled", "disabled");
            $('#ButtonSeizureAdministratorReviewSign').attr("disabled", "disabled");
        }
    }
    var InStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "InProgressStatus");
    if (InStatus == 22) {
        $('#ButtonDetailsSign').val("Edit");
        $('#DetailsTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonDetailsSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "SignedDate");

        $('#Span_SignedBy').text(SignedBy);
        $('#Span_DateSigned').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatus == 21) {
        $('#DetailsTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonDetailsSign').attr("disabled", "disabled");
        }
        $('#Span_SignedBy').text(SignedBy);
        $('#Span_DateSigned').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusCustomIncidentReportFollowUpOfIndividualStatuses = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFollowUpOfIndividualStatuses", "InProgressStatus");
    if (InStatusCustomIncidentReportFollowUpOfIndividualStatuses == 22) {
        $('#ButtonFollowUpIndividualStatusSign').val("Edit");
        $('#IncidentFollowUPTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFollowUpOfIndividualStatuses ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonFollowUpIndividualStatusSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFollowUpOfIndividualStatuses", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFollowUpOfIndividualStatuses", "SignedDate");

        $('#Span_SignedByIndividualStatus').text(SignedBy);
        $('#Span_DateSignedIndividualStatus').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusCustomIncidentReportFollowUpOfIndividualStatuses == 21) {
        $('#IncidentFollowUPTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFollowUpOfIndividualStatuses", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFollowUpOfIndividualStatuses", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFollowUpOfIndividualStatuses ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
        }

        $('#Span_SignedByIndividualStatus').text(SignedBy);
        $('#Span_DateSignedIndividualStatus').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusSupervisorFollowUp = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSupervisorFollowUps", "InProgressStatus");
    if (InStatusSupervisorFollowUp == 22) {
        $('#ButtonSupervisorFollowUpSign').val("Edit");
        $('#SupervisorFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSupervisorFollowUps ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonSupervisorFollowUpSign').removeAttr("disabled");
        }
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSupervisorFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSupervisorFollowUps", "SignedDate");

        $('#Span_SignedBySupervisorFollow').text(SignedBy);
        $('#Span_DateSignedSupervisorFollow').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusSupervisorFollowUp == 21) {
        $('#SupervisorFollowUpTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSupervisorFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSupervisorFollowUps", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSupervisorFollowUps ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
        }

        $('#Span_SignedBySupervisorFollow').text(SignedBy);
        $('#Span_DateSignedSupervisorFollow').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusManagerFollowUp = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportManagerFollowUps", "InProgressStatus");
    if (InStatusManagerFollowUp == 22) {
        $('#ButtonIncidentReportManagerFollowUpSign').val("Edit");
        $('#IncidentManagerFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportManagerFollowUps", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonIncidentReportManagerFollowUpSign').removeAttr("disabled");
        }
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportManagerFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportManagerFollowUps", "SignedDate");

        $('#SpanSignedByIncidentReportManagerFollowUp').text(SignedBy);
        $('#Span_DateSignedIncidentReportManagerFollowUp').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusManagerFollowUp == 21) {
        $('#IncidentManagerFollowUpTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportManagerFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportManagerFollowUps", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportManagerFollowUps", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonIncidentReportManagerFollowUpSign').attr("disabled", "disabled");
        }
        $('#SpanSignedByIncidentReportManagerFollowUp').text(SignedBy);
        $('#Span_DateSignedIncidentReportManagerFollowUp').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusAdministratorReview = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportAdministratorReviews", "InProgressStatus");
    if (InStatusAdministratorReview == 22) {
        $('#ButtonAdministratorReviewsSign').val("Edit");
        $('#IncidentAdministratorTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportAdministratorReviews ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonAdministratorReviewsSign').removeAttr("disabled");
        }
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportAdministratorReviews", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportAdministratorReviews", "SignedDate");

        $('#Span_SignedByAdministratorReview').text(SignedBy);
        $('#Span_DateSignedAdministratorReview').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusAdministratorReview == 21) {
        $('#IncidentAdministratorTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportAdministratorReviews", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportAdministratorReviews", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportAdministratorReviews ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
        }
        $('#Span_SignedByAdministratorReview').text(SignedBy);
        $('#Span_DateSignedAdministratorReview').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusFallDetails = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails", "InProgressStatus");
    if (InStatusFallDetails == 22) {
        $('#ButtonFallDetailsSign').val("Edit");
        $('#FallDetailsTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonFallDetailsSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails", "SignedDate");

        $('#SpanSignedByFallDetails').text(SignedBy);
        $('#Span_DateSignedFallDetails').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusFallDetails == 21) {
        $('#FallDetailsTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonFallDetailsSign').attr("disabled", "disabled");
        }

        $('#SpanSignedByFallDetails').text(SignedBy);
        $('#Span_DateSignedFallDetails').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }

    var InStatusFallIndividualStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallFollowUpOfIndividualStatuses", "InProgressStatus");
    if (InStatusFallIndividualStatus == 22) {
        $('#ButtonFallFollowUpIndividualStatusSign').val("Edit");
        $('#FallIndividualStatusTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallFollowUpOfIndividualStatuses ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonFallFollowUpIndividualStatusSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallFollowUpOfIndividualStatuses", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallFollowUpOfIndividualStatuses", "SignedDate");

        $('#SpanSignedByFallIndividual').text(SignedBy);
        $('#Span_DateSignedFallIndividual').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusFallIndividualStatus == 21) {
        $('#FallIndividualStatusTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallFollowUpOfIndividualStatuses", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallFollowUpOfIndividualStatuses", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallFollowUpOfIndividualStatuses ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonFallFollowUpIndividualStatusSign').attr("disabled", "disabled");
        }

        $('#SpanSignedByFallIndividual').text(SignedBy);
        $('#Span_DateSignedFallIndividual').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }

    var InStatusFallSupervisorFollowUp = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallSupervisorFollowUps", "InProgressStatus");
    if (InStatusFallSupervisorFollowUp == 22) {
        $('#ButtonFallSupervisorFollowUpSign').val("Edit");
        $('#FallSupervisorFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallSupervisorFollowUps ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonFallSupervisorFollowUpSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallSupervisorFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallSupervisorFollowUps", "SignedDate");

        $('#SpanSignedByFallSupervisor').text(SignedBy);
        $('#Span_DateSignedFallSupervisor').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusFallSupervisorFollowUp == 21) {
        $('#FallSupervisorFollowUpTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallSupervisorFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallSupervisorFollowUps", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallSupervisorFollowUps ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonFallSupervisorFollowUpSign').attr("disabled", "disabled");
        }

        $('#SpanSignedByFallSupervisor').text(SignedBy);
        $('#Span_DateSignedFallSupervisor').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusFallManagerFollowUp = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallManagerFollowUps", "InProgressStatus");
    if (InStatusFallManagerFollowUp == 22) {
        $('#ButtonCustomIncidentReportFallManagerFollowUpSign').val("Edit");
        $('#FallManagerFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallManagerFollowUps", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonCustomIncidentReportFallManagerFollowUpSign').removeAttr("disabled");
        }
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallManagerFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallManagerFollowUps", "SignedDate");

        $('#SpanSignedByIncidentReportFallManagerFollowUp').text(SignedBy);
        $('#Span_DateSignedIncidentReportFallManagerFollowUp').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusManagerFollowUp == 21) {
        $('#FallManagerFollowUpTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallManagerFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallManagerFollowUps", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallManagerFollowUps", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonCustomIncidentReportFallManagerFollowUpSign').attr("disabled", "disabled");
        }
        $('#SpanSignedByIncidentReportFallManagerFollowUp').text(SignedBy);
        $('#Span_DateSignedIncidentReportFallManagerFollowUp').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusFallAdministrators = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallAdministratorReviews", "InProgressStatus");
    if (InStatusFallAdministrators == 22) {
        $('#ButtonFallAdministratorReviewSign').val("Edit");
        $('#FallAdministrator').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallAdministratorReviews ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonFallAdministratorReviewSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallAdministratorReviews", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallAdministratorReviews", "SignedDate");

        $('#SpanSignedByFallAdministrator').text(SignedBy);
        $('#Span_DateSignedFallAdministrator').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusFallAdministrators == 21) {
        $('#FallAdministrator').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallAdministratorReviews", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallAdministratorReviews", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallAdministratorReviews ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonFallAdministratorReviewSign').attr("disabled", "disabled");
        }
        $('#SpanSignedByFallAdministrator').text(SignedBy);
        $('#Span_DateSignedFallAdministrator').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusSeizureDetails = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails", "InProgressStatus");
    if (InStatusSeizureDetails == 22) {
        $('#ButtonSDetailsSign').val("Edit");
        $('#SeizureDetailsTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonSDetailsSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails", "SignedDate");

        $('#SpanSignedBySeizureDetails').text(SignedBy);
        $('#Span_DateSignedSeizureDetails').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusSeizureDetails == 21) {
        $('#SeizureDetailsTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonSDetailsSign').attr("disabled", "disabled");
        }
        $('#SpanSignedBySeizureDetails').text(SignedBy);
        $('#Span_DateSignedSeizureDetails').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusSeizureIndividualStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "InProgressStatus");
    if (InStatusSeizureIndividualStatus == 22) {
        $('#ButtonSeizureFollowUpIndividualStatusSign').val("Edit");
        $('#SeizureIndividualStatusTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureFollowUpOfIndividualStatuses ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonSeizureFollowUpIndividualStatusSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "SignedDate");

        $('#SpanSignedBySeizureIndividual').text(SignedBy);
        $('#Span_DateSignedSeizureIndividual').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusSeizureIndividualStatus == 21) {
        $('#SeizureIndividualStatusTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureFollowUpOfIndividualStatuses ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonSeizureFollowUpIndividualStatusSign').attr("disabled", "disabled");
        }

        $('#SpanSignedBySeizureIndividual').text(SignedBy);
        $('#Span_DateSignedSeizureIndividual').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusSeizureSupervisorFollowUp = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureSupervisorFollowUps", "InProgressStatus");
    if (InStatusSeizureSupervisorFollowUp == 22) {
        $('#ButtonSeizureSupervisorFollowUpSign').val("Edit");
        $('#SeizureSupervisorFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureSupervisorFollowUps ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonSeizureSupervisorFollowUpSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureSupervisorFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureSupervisorFollowUps", "SignedDate");

        $('#SpanSignedBySeizureSupervisor').text(SignedBy);
        $('#Span_DateSignedSeizureSupervisor').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusSeizureIndividualStatus == 21) {
        $('#SeizureSupervisorFollowUpTable').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureSupervisorFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureSupervisorFollowUps", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureSupervisorFollowUps ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonSeizureSupervisorFollowUpSign').attr("disabled", "disabled");
        }

        $('#SpanSignedBySeizureSupervisor').text(SignedBy);
        $('#Span_DateSignedSeizureSupervisor').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusSeizurelManagerFollowUp = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureManagerFollowUps", "InProgressStatus");
    if (InStatusSeizurelManagerFollowUp == 22) {
        $('#ButtonSeizuretManagerFollowUpSign').val("Edit");
        $('#TableSeizuretManagerFollowUp').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureManagerFollowUps", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonSeizuretManagerFollowUpSign').removeAttr("disabled");
        }
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureManagerFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureManagerFollowUps", "SignedDate");

        $('#SpanSignedBySeizuretManagerFollowUp').text(SignedBy);
        $('#Span_DateSignedSeizuretManagerFollowUp').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusManagerFollowUp == 21) {
        $('#TableSeizuretManagerFollowUp').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureManagerFollowUps", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureManagerFollowUps", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureManagerFollowUps", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonSeizuretManagerFollowUpSign').attr("disabled", "disabled");
        }
        $('#SpanSignedBySeizuretManagerFollowUp').text(SignedBy);
        $('#Span_DateSignedSeizuretManagerFollowUp').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    var InStatusSeizureAdministrators = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureAdministratorReviews", "InProgressStatus");
    if (InStatusSeizureAdministrators == 22) {
        $('#ButtonSeizureAdministratorReviewSign').val("Edit");
        $('#SeizureAdministrator').find("input,textarea,select").attr("disabled", "disabled");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureAdministratorReviews ", "SignedBy");
        if (_LoggedInUserId == _SignedBy) {
            $('#ButtonSeizureAdministratorReviewSign').removeAttr("disabled");
        }

        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureAdministratorReviews", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureAdministratorReviews", "SignedDate");

        $('#SpanSignedBySeizureAdministrator').text(SignedBy);
        $('#Span_DateSignedSeizureAdministrator').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
    else if (InStatusSeizureAdministrators == 21) {
        $('#SeizureAdministrator').find("input,textarea,select").removeAttr("disabled");
        SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureAdministratorReviews", "StaffName");
        SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureAdministratorReviews", "SignedDate");
        var _SignedBy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureAdministratorReviews ", "SignedBy");
        if (_LoggedInUserId != _SignedBy) {
            $('#ButtonSeizureAdministratorReviewSign').attr("disabled", "disabled");
        }

        $('#SpanSignedBySeizureAdministrator').text(SignedBy);
        $('#Span_DateSignedSeizureAdministrator').text(formatDate(SignedDate, "MM/dd/yyyy"));
    }
}

function SameDT() {
    if ($('#CheckBox_CustomIncidentReportGenerals_GeneralSame').attr('checked')) {
        $('#TextBox_CustomIncidentReportGenerals_GeneralDateStaffNotified').val($('#TextBox_CustomIncidentReportGenerals_GeneralDateOfIncident').val());
        $('#TextBox_CustomIncidentReportGenerals_GeneralTimeStaffNotified').val($('#TextBox_CustomIncidentReportGenerals_GeneralTimeOfIncident').val());
        CreateAutoSaveXml("CustomIncidentReportGenerals", "GeneralDateStaffNotified", $('#TextBox_CustomIncidentReportGenerals_GeneralDateStaffNotified').val());
        CreateAutoSaveXml("CustomIncidentReportGenerals", "GeneralTimeStaffNotified", $('#TextBox_CustomIncidentReportGenerals_GeneralTimeStaffNotified').val());
    }
    else {
        $('#TextBox_CustomIncidentReportGenerals_GeneralDateStaffNotified').val('');
        $('#TextBox_CustomIncidentReportGenerals_GeneralTimeStaffNotified').val('');
        CreateAutoSaveXml("CustomIncidentReportGenerals", "GeneralDateStaffNotified", $('#TextBox_CustomIncidentReportGenerals_GeneralDateStaffNotified').val());
        CreateAutoSaveXml("CustomIncidentReportGenerals", "GeneralTimeStaffNotified", $('#TextBox_CustomIncidentReportGenerals_GeneralTimeStaffNotified').val());
    }
}

function SameManagerDT() {
    if ($('#RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerNotified_Y').attr('checked')) {
        $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val($('#TextBox_CustomIncidentReportGenerals_GeneralDateOfIncident').val());
        $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val($('#TextBox_CustomIncidentReportGenerals_GeneralTimeOfIncident').val());
        CreateAutoSaveXml("CustomIncidentReportSupervisorFollowUps", "SupervisorFollowUpManagerDateOfNotification", $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val());
        CreateAutoSaveXml("CustomIncidentReportSupervisorFollowUps", "SupervisorFollowUpManagerTimeOfNotification", $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val());
    }
    else {
        $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val('');
        $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val('');
        CreateAutoSaveXml("CustomIncidentReportSupervisorFollowUps", "SupervisorFollowUpManagerDateOfNotification", $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val());
        CreateAutoSaveXml("CustomIncidentReportSupervisorFollowUps", "SupervisorFollowUpManagerTimeOfNotification", $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val());
    }
}


function ChangeTimeFormat(value) {
    if (value == "") {
        return "";
    }
    if (value.indexOf("T") > 0) {

        var splittedStr = value.split('T');


        return new Date(splittedStr[0].replace(/-/g, "/") + ' ' + splittedStr[1].substring(0, 8)).format("h:mm tt");
        //return new Date(timePart).format("h:mmtt");
    }
    else {
        var datePattern = /am|AM|pm|PM/;
        if (datePattern.test(value)) {
            return value;
        }
        else {
            return new Date(value.replace(/-/g, "/")).format("h:mm tt");
        }
    }

}

function SameManagerDTFall() {
    if ($('#RadioButton_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerNotified_Y').attr('checked')) {
        var date = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportGenerals", "GeneralDateOfIncident");

        var time = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportGenerals", "GeneralTimeOfIncident");
        time = ChangeTimeFormat(time);
        $('#TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val(formatDate(date, "MM/dd/yyyy"));
        $('#TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val(time);
        CreateAutoSaveXml("CustomIncidentReportFallSupervisorFollowUps", "SupervisorFollowUpManagerDateOfNotification", $('#TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val());
        CreateAutoSaveXml("CustomIncidentReportFallSupervisorFollowUps", "SupervisorFollowUpManagerTimeOfNotification", $('#TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val());
    }
    else {
        $('#TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val('');
        $('#TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val('');
        CreateAutoSaveXml("CustomIncidentReportFallSupervisorFollowUps", "SupervisorFollowUpManagerDateOfNotification", $('#TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val());
        CreateAutoSaveXml("CustomIncidentReportFallSupervisorFollowUps", "SupervisorFollowUpManagerTimeOfNotification", $('#TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val());
    }
}

function SameManagerDTSezuire() {
    if ($('#RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerNotified_Y').attr('checked')) {
        var date = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportGenerals", "GeneralDateOfIncident");
        var time = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportGenerals", "GeneralTimeOfIncident");
        time = ChangeTimeFormat(time);
        $('#TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val(formatDate(date, "MM/dd/yyyy"));
        $('#TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val(time);
        CreateAutoSaveXml("CustomIncidentReportSeizureSupervisorFollowUps", "SupervisorFollowUpManagerDateOfNotification", $('#TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val());
        CreateAutoSaveXml("CustomIncidentReportSeizureSupervisorFollowUps", "SupervisorFollowUpManagerTimeOfNotification", $('#TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val());
    }
    else {
        $('#TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val('');
        $('#TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val('');
        CreateAutoSaveXml("CustomIncidentReportSeizureSupervisorFollowUps", "SupervisorFollowUpManagerDateOfNotification", $('#TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification').val());
        CreateAutoSaveXml("CustomIncidentReportSeizureSupervisorFollowUps", "SupervisorFollowUpManagerTimeOfNotification", $('#TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification').val());
    }
}


function ShowHideTextBox() {
    var LocationDetailText = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralLocationDetails] :selected").attr('Code')
    var CauseOfIncidentCode = $("select[id$=DropDownList_CustomIncidentReportFallDetails_FallDetailsCauseOfIncident] :selected").attr('Code')
    if (LocationDetailText == "OTHER" || LocationDetailText == "COMMUNITY") {
        $('#TextBox_CustomIncidentReportGenerals_GeneralLocationDetailsText').show();
    }
    else {
        $('#TextBox_CustomIncidentReportGenerals_GeneralLocationDetailsText').hide();
    }
    if (CauseOfIncidentCode == "SLIPPED" || CauseOfIncidentCode == "EQUIPMENTMALFUNCTION" || CauseOfIncidentCode == "ENVIRONMENTALFACTOR" || CauseOfIncidentCode == "OTHER") {
        $('#TextBox_CustomIncidentReportFallDetails_FallDetailsCauseOfIncidentText').show();
    }
    else {
        $('#TextBox_CustomIncidentReportFallDetails_FallDetailsCauseOfIncidentText').hide();
    }
    //Personal/Safety Protective Device(s) Used at Time of Incident Other
    if ($('#CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOther').attr('checked')) {
        $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOtherComments').show();
    }
    else {
        $('#TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpOtherComments').hide();
    }
    //Personal/Safety Protective Device(s) Used at Time of Incident Other
    if ($('#CheckBox_CustomIncidentReportFallDetails_FallDetailsOther').attr('checked')) {
        $('#TextBox_CustomIncidentReportFallDetails_FallDetailsOtherText').show();
    }
    else {
        $('#TextBox_CustomIncidentReportFallDetails_FallDetailsOtherText').hide();
    }
    //Personal/Safety Protective Device(s) Used at Time of Incident Further Description
    if ($('#CheckBox_CustomIncidentReportFallDetails_FallDetailsFurtherDescription').attr('checked')) {
        $('#TextBox_CustomIncidentReportFallDetails_FallDetailsFurtherDescriptiontext').show();
    }
    else {
        $('#TextBox_CustomIncidentReportFallDetails_FallDetailsFurtherDescriptiontext').hide();
    }
    //Personal/Safety Protective Device(s) Used at Time of Incident Alarm Other Description
    if ($('#CheckBox_CustomIncidentReportFallDetails_FallDetailsTypeOfAlarmOtherText').attr('checked')) {
        $('#TextBox_CheckBox_CustomIncidentReportFallDetails_FallDetailsTypeOfAlarmOther').show();
    }
    else {
        $('#TextBox_CheckBox_CustomIncidentReportFallDetails_FallDetailsTypeOfAlarmOther').hide();
    }
    //Fall Follow Up of Individual Status Other
    if ($('#CheckBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusOther').attr('checked')) {
        $('#TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusOtherText').show();
    }
    else {
        $('#TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusOtherText').hide();
    }
    //Seizure O2 CheckBox
    if ($('#CheckBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsO2Given').attr('checked')) {
        $('#TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsLiterMin').removeAttr('disabled');
    }
    else {
        $('#TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsLiterMin').attr('disabled', 'disabled');
    }
}

function ShowHideIncidentReportTab(tabInstance, showTab) {
    if (tabInstance != null) {
        if (showTab == true) {
            tabInstance.show();
            tabInstance.set_visible(true);
        }
        else {
            tabInstance.hide();
            tabInstance.set_visible(false);
        }
    }
}

function SetTabsIncidentCategory(dom, action) {
    Incident_Tab = tabobject.findTabByText('Incident');
    Fall_Tab = tabobject.findTabByText('Fall');
    Seizure_Tab = tabobject.findTabByText('Seizure');
    //var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
    var IncidentCategoryText = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory] :selected").text();
    var IncidentCategoryValue = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory] :selected").val();
    var IncidentCategoryCode = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory] :selected").attr('Code');
    if (IncidentCategoryCode == "INCIDENT") {
        BindSecondaryIncident(IncidentCategoryValue);
        ShowHideIncidentReportTab(Fall_Tab, false);
        ShowHideIncidentReportTab(Seizure_Tab, false);
        $('#IncidentReportTable :input').removeAttr('disabled');
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").removeAttr("disabled");
        var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
        if (CurStatus != 22) {
            $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
            $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
            $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
        }
    }
    else if (IncidentCategoryCode == "INCIDENTFALL") {
        ShowHideIncidentReportTab(Seizure_Tab, false);
        ShowHideIncidentReportTab(Fall_Tab, true);
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").attr("disabled", "disabled");
        BindSecondaryIncident(IncidentCategoryValue);
    }
    else if (IncidentCategoryCode == "INCIDENTSEIZURE") {
        ShowHideIncidentReportTab(Fall_Tab, false);
        ShowHideIncidentReportTab(Seizure_Tab, true);
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").attr("disabled", "disabled");
        BindSecondaryIncident(IncidentCategoryValue);
    }
    else {
        ShowHideIncidentReportTab(Fall_Tab, true);
        ShowHideIncidentReportTab(Seizure_Tab, true);
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").attr("disabled", "disabled");
        var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
        if (CurStatus != 22) {
            $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
            $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
            $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
        }
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").empty();
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
    }
}

function SetTabsSecondaryCategory(dom, action) {
    Incident_Tab = tabobject.findTabByText('Incident');
    Fall_Tab = tabobject.findTabByText('Fall');
    Seizure_Tab = tabobject.findTabByText('Seizure');
    var IncidentCategoryCode = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory] :selected").attr('Code');
    var SecondCategoryCode = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory] :selected").attr('Code');
    var SecondaryCategoryText = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory] :selected").text();
    var SecondaryCategoryValue = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory] :selected").val();
    if (IncidentCategoryCode == undefined) {
        IncidentCategoryCode = dom.find("CustomIncidentReportGenerals:first GeneralIncidentCategoryCode").text();
    }
    if (SecondCategoryCode == undefined) {
        if (dom != undefined) {
            SecondCategoryCode = dom.find("CustomIncidentReportGenerals:first GeneralSecondaryCategoryCode").text();
        }
    }

    if (IncidentCategoryCode == "INCIDENT") {
        if (SecondCategoryCode == "FALL") {
            ShowHideIncidentReportTab(Incident_Tab, true);
            ShowHideIncidentReportTab(Seizure_Tab, false);
            ShowHideIncidentReportTab(Fall_Tab, true);
        }
        else if (SecondCategoryCode == "SEIZURE") {
            ShowHideIncidentReportTab(Incident_Tab, true);
            ShowHideIncidentReportTab(Seizure_Tab, true);
            ShowHideIncidentReportTab(Fall_Tab, false);
        }
        else if (SecondCategoryCode == "FALLSEIZURE") {
            ShowHideIncidentReportTab(Incident_Tab, true);
            ShowHideIncidentReportTab(Seizure_Tab, true);
            ShowHideIncidentReportTab(Fall_Tab, true);
        }
        else {
            ShowHideIncidentReportTab(Fall_Tab, false);
            ShowHideIncidentReportTab(Seizure_Tab, false);
            $('#IncidentReportTable :input').removeAttr('disabled');
            var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
            if (CurStatus != 22) {
                $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
                $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
                $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
            }
        }
    }
    else if (IncidentCategoryCode == "INCIDENTOTHER") {

        ShowHideIncidentReportTab(Fall_Tab, true);
        ShowHideIncidentReportTab(Seizure_Tab, true);
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
        var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
        if (CurStatus != 22) {
            $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
            $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
            $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
        }

    }
    else if (IncidentCategoryCode == "INCIDENTFALL") {

        if (SecondCategoryCode == "SEIZURE") {
            ShowHideIncidentReportTab(Seizure_Tab, true);
            ShowHideIncidentReportTab(Fall_Tab, true);
            $('#IncidentReportTable :input').attr('disabled', 'disabled');
        }
        else if (SecondCategoryCode == "OTHER") {
            ShowHideIncidentReportTab(Seizure_Tab, false);
            $('#IncidentReportTable :input').removeAttr('disabled');
            var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
            if (CurStatus != 22) {
                $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
                $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
                $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
            }
        }
        else if (SecondCategoryCode == "SEIZUREOTHER") {
            ShowHideIncidentReportTab(Seizure_Tab, true);
            ShowHideIncidentReportTab(Fall_Tab, true);
            $('#IncidentReportTable :input').removeAttr('disabled');
            var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
            if (CurStatus != 22) {
                $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
                $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
                $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
            }
        }
        else {
            ShowHideIncidentReportTab(Seizure_Tab, false);
            ShowHideIncidentReportTab(Fall_Tab, true);
            $('#IncidentReportTable :input').attr('disabled', 'disabled');
        }
    }
    else if (IncidentCategoryCode == "INCIDENTSEIZURE") {
        if (SecondCategoryCode == "FALL") {
            ShowHideIncidentReportTab(Seizure_Tab, true);
            ShowHideIncidentReportTab(Fall_Tab, true);
            $('#IncidentReportTable :input').attr('disabled', 'disabled');
        }
        else if (SecondCategoryCode == "OTHER") {
            ShowHideIncidentReportTab(Fall_Tab, false);
            $('#IncidentReportTable :input').removeAttr('disabled');
            var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
            if (CurStatus != 22) {
                $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
                $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
                $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
            }
        }
        else if (SecondCategoryCode == "FALLOTHER") {
            ShowHideIncidentReportTab(Seizure_Tab, true);
            ShowHideIncidentReportTab(Fall_Tab, true);
            $('#IncidentReportTable :input').removeAttr('disabled');
            var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
            if (CurStatus != 22) {
                $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
                $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
                $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
            }
        }
        else {
            ShowHideIncidentReportTab(Fall_Tab, false);
            ShowHideIncidentReportTab(Seizure_Tab, true);
            $('#IncidentReportTable :input').attr('disabled', 'disabled');
        }

    }
}

function BindSecondaryIncident(GlobalCodeId) {
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
}

function InsertGridDataSeizures(TableChildControl, InsertGrid, CustomGrid, obj) {
    var NoOfSeizure;
    var DurationOfSeizure;
    var SetMin;
    var SetSec;
    if ($('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val() > 1) { SetMin = 'minutes'; }
    else { SetMin = 'minute'; }
    if ($('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val() > 1) { SetSec = 'seconds'; }
    else { SetSec = 'second'; }
    if ($('#TextBox_CustomIncidentReportSeizures_TimeOfSeizure').val() != "") {
        if (($('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val() == "" &&
       $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val() == "") || ($('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val() == 0
            && $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val() == 0)) {
            ShowHideErrorMessage('Duration of seizure is required in either minutes or seconds', 'true');
            return false;
        }
        else {
            ShowHideErrorMessage(' Duration of seizure is required in either minutes or seconds', 'false');
            if ($('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val() == "") {
                $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val(0);
            }
            else if ($('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val() == "") {
                $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val(0);
            }
        }
    }
    DurationOfSeizure = $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val() + ' ' + SetMin + ' ' + $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val() + ' ' + SetSec;
    $('#HiddenField_CustomIncidentReportSeizures_DurationOfSeizure').val(DurationOfSeizure);
    InsertGridData(TableChildControl, InsertGrid, CustomGrid, obj);
}

function AddParentChildEventHandler(gridTableName) {
    $("#TableChildControl_CustomIncidentReportSeizures_ButtonInsert").val('Add');
}

function HideDropDown() {
    var ProgramText = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralProgram] :selected").text();
    var ProgramId = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralProgram] :selected").val();
    if (ProgramText != "") {
        if (ProgramText == "Brain's House" || ProgramText == "Allies" || ProgramText == "Brian’s House") {
            $("select[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]").attr('disabled', 'disabled');
        }
        else {
            $("select[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]").removeAttr('disabled');
        }

        CreateAutoSaveXml("CustomIncidentReportGenerals", "GeneralProgram", $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralProgram] :selected").val());
    }
    var PrimaryKey = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportGenerals", "IncidentReportId");
    if (ProgramId != "" && PrimaryKey == "-1") {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/IncidentReport/DetailPage/WebPages/IncidentReport.aspx?functionName=GetStaff",
            data: "ProgramId=" + ProgramId,
            async: false,
            success: function (result) {
                if (result != "")
                    FillStaffNotificationinjury(result);
            }
        });
    }
}
function FillStaffNotificationinjury(result) {
    //Incident Tab
    $("[id$=DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury]");
            $.xmlDOM(result).find("StaffPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId]");
            $.xmlDOM(result).find("StaffSupervisorPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]");
            $.xmlDOM(result).find("StaffPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]");
            });
        }
    }
    //$("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]").val(AutoSaveXMLDom.find("CustomIncidentReportFollowUpOfIndividualStatuses:first FollowUpIndividualStatusNurseStaffEvaluating").text());
    $("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification]");
            $.xmlDOM(result).find("AllStaff").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSupervisorName]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSupervisorName]");
            $.xmlDOM(result).find("StaffSupervisorPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSupervisorName]");
            });
        }
    }
    //$("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]").val(AutoSaveXMLDom.find("CustomIncidentReportSupervisorFollowUps:first SupervisorFollowUpSupervisorName").text());
    $("[id$=DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification]");
            $.xmlDOM(result).find("AllStaff").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManager]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManager]");
            $.xmlDOM(result).find("Managers").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManager]");
            });
        }
    }

    $("[id$=DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpManagerId]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpManagerId]");
            $.xmlDOM(result).find("Managers").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpManagerId]");
            });
        }
    }

    //Fall Tab
    $("[id$=DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury]");
            $.xmlDOM(result).find("StaffPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportFallDetails_FallDetailsSupervisorFlaggedId]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFallDetails_FallDetailsSupervisorFlaggedId]");
            $.xmlDOM(result).find("StaffSupervisorPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFallDetails_FallDetailsSupervisorFlaggedId]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating]");
            $.xmlDOM(result).find("StaffPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification]");
            $.xmlDOM(result).find("AllStaff").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpSupervisorName]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpSupervisorName]");
            $.xmlDOM(result).find("StaffSupervisorPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpSupervisorName]");
            });
        }
    }
    //$("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]").val(AutoSaveXMLDom.find("CustomIncidentReportSupervisorFollowUps:first SupervisorFollowUpSupervisorName").text());
    $("[id$=DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification]");
            $.xmlDOM(result).find("AllStaff").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification]");
            });
        }
    }

    $("[id$=DropDownList_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManager]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManager]");
            $.xmlDOM(result).find("Managers").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManager]");
            });
        }
    }

    $("[id$=DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpManagerId]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpManagerId]");
            $.xmlDOM(result).find("Managers").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpManagerId]");
            });
        }
    }


    //Seizure Tab
    $("[id$=DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury]");
            $.xmlDOM(result).find("StaffPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsSupervisorFlaggedId]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsSupervisorFlaggedId]");
            $.xmlDOM(result).find("StaffSupervisorPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsSupervisorFlaggedId]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating]");
            $.xmlDOM(result).find("StaffPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification]");
            $.xmlDOM(result).find("AllStaff").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification]");
            });
        }
    }
    $("[id$=DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpSupervisorName]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpSupervisorName]");
            $.xmlDOM(result).find("StaffSupervisorPrograms").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpSupervisorName]");
            });
        }
    }
    //$("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]").val(AutoSaveXMLDom.find("CustomIncidentReportSupervisorFollowUps:first SupervisorFollowUpSupervisorName").text());
    $("[id$=DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification]");
            $.xmlDOM(result).find("AllStaff").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification]");
            });
        }
    }

    $("[id$=DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManager]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManager]");
            $.xmlDOM(result).find("Managers").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManager]");
            });
        }
    }

    $("[id$=DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpManagerId]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=" + '' + ">" + '' + "</option>").prependTo("[id$=DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpManagerId]");
            $.xmlDOM(result).find("Managers").each(function () {
                $("<option value=" + $(this).find('StaffId').text() + ">" + $(this).find('DisplayAs').text() + "</option>").appendTo("[id$=DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpManagerId]");
            });
        }
    }

}
function IncidentSectionsShowHide() {
    //Follow Up of Individual Status
    //if ($('#CheckBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpInjury').attr('checked')) {
    //    $('#IncidentFollowUPTable').show();
    //    HideDropDown();
    //}
    //else {
    //    $('#IncidentFollowUPTable').hide()
    //}
    //Administrator Review
    if ($('#RadioButton_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministratorNotified_Y').attr('checked') || $('#RadioButton_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministratorNotified_Y').attr('checked')) {
        $('#IncidentAdministratorTable').show();
    }
    else {
        $('#IncidentAdministratorTable').hide();
    }
    //Fall Details Wheels
    var IncidentOccurredWhileText = $("select[id$=DropDownList_CustomIncidentReportFallDetails_FallDetailsIncidentOccurredWhile] :selected").attr('Code')
    if (IncidentOccurredWhileText == "GETTINGUPFROMWHEELCHAIR") {
        $('.WheelsSections').show();
    }
    else {
        $('.WheelsSections').hide();
    }
    if (IncidentOccurredWhileText == "GETTINGINOUTBED") {
        $('.RailsPresent').show();
    }
    else {
        $('.RailsPresent').hide();
    }
    //Fall Alarm
    if ($('#RadioButton_CustomIncidentReportFallDetails_FallDetailsWasAnAlarmPresent_Y').attr('checked')) {
        $('.TypeofAlarm').show();
    }
    else {
        $('.TypeofAlarm').hide();
    }
    if ($('#RadioButton_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministratorNotified_Y').attr('checked') || $('#RadioButton_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministratorNotified_Y').attr('checked')) {
        $('#FallAdministrator').show();
    }
    else {
        $('#FallAdministrator').hide();
    }
    if ($('#RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSeizureSupervisorFollowUpAdministratorNotified_Y').attr('checked') || $('#RadioButton_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministratorNotified_Y').attr('checked')) {
        $('#SeizureAdministrator').show();
    }
    else {
        $('#SeizureAdministrator').hide();
    }
}

function SetIncidentCategory(dom, action) {
    Incident_Tab = tabobject.findTabByText('Incident');
    Fall_Tab = tabobject.findTabByText('Fall');
    Seizure_Tab = tabobject.findTabByText('Seizure');
    var IncidentCategoryText = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory] :selected").text();
    var IncidentCategoryValue = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory] :selected").val();
    var IncidentCategoryCode = $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory] :selected").attr('Code');
    if (dom.find("CustomIncidentReports:first IncidentReportId").text() == -1 && tabobject.get_selectedTab().get_text() == "Incident") {
        ShowHideIncidentReportTab(Fall_Tab, false);
        ShowHideIncidentReportTab(Seizure_Tab, false);
    }
    if (IncidentCategoryCode == undefined) {
        IncidentCategoryCode = dom.find("CustomIncidentReportGenerals:first GeneralIncidentCategoryCode").text();
    }
    if (IncidentCategoryCode == "INCIDENTOTHER") {
        if (TabIndex != 0) {
            if (TabIndex != 1) {
                ShowHideIncidentReportTab(Fall_Tab, true);
            }
            if (TabIndex != 2) {
                ShowHideIncidentReportTab(Seizure_Tab, true);
            }

        }
        ShowHideIncidentReportTab(Fall_Tab, true);
        ShowHideIncidentReportTab(Seizure_Tab, true);
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").attr("disabled", "disabled");
        var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
        if (CurStatus != 22) {
            $('#ButtonFollowUpIndividualStatusSign').attr("disabled", "disabled");
            $('#ButtonSupervisorFollowUpSign').attr("disabled", "disabled");
            $('#ButtonAdministratorReviewsSign').attr("disabled", "disabled");
        }
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").empty();
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
        SetTabsSecondaryCategory(dom, action);
    }
    else if (IncidentCategoryCode == "INCIDENTFALL") {
        if (TabIndex != 2) {
            ShowHideIncidentReportTab(Seizure_Tab, false);
        }
        ShowHideIncidentReportTab(Fall_Tab, true);
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
        SetTabsSecondaryCategory(dom, action);
    }
    else if (IncidentCategoryCode == "INCIDENTSEIZURE") {
        if (TabIndex != 1) {
            ShowHideIncidentReportTab(Fall_Tab, false);
        }
        ShowHideIncidentReportTab(Seizure_Tab, true);
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
        SetTabsSecondaryCategory(dom, action);
    }
    else if (IncidentCategoryCode == "INCIDENT") {

        SetTabsSecondaryCategory(dom, action);
    }
    else {
        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").empty();
        $('#IncidentReportTable :input').attr('disabled', 'disabled');
    }
}
function TimeNotified(obj) {
    FormatTimeatClientSide($(obj)[0]);
    if (obj.id == 'TextBox_CustomIncidentReportGenerals_GeneralTimeOfIncident') {
        CreateAutoSaveXml("CustomIncidentReportGenerals", "GeneralTimeOfIncident", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportGenerals_GeneralTimeStaffNotified') {
        CreateAutoSaveXml("CustomIncidentReportGenerals", "GeneralTimeStaffNotified", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportDetails_DetailsTimestaffNotified') {
        CreateAutoSaveXml("CustomIncidentReportDetails", "DetailsTimestaffNotified", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportFollowUpOfIndividualStatuses", "FollowUpIndividualStatusTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdminTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportSupervisorFollowUps", "SupervisorFollowUpAdminTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportSupervisorFollowUps", "SupervisorFollowUpManagerTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpFGCTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportSupervisorFollowUps", "SupervisorFollowUpFGCTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdminTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportManagerFollowUps", "ManagerFollowUpAdminTimeOfNotification", $(obj).val());
    }
        //Fall
    else if (obj.id == 'TextBox_CustomIncidentReportFallDetails_FallDetailsTimestaffNotified') {
        CreateAutoSaveXml("CustomIncidentReportFallDetails", "FallDetailsTimestaffNotified", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportFallFollowUpOfIndividualStatuses", "FallFollowUpIndividualStatusTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdminTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportFallSupervisorFollowUps", "FallSupervisorFollowUpAdminTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpFGCTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportFallSupervisorFollowUps", "FallSupervisorFollowUpFGCTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportFallSupervisorFollowUps", "SupervisorFollowUpManagerTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdminTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportFallManagerFollowUps", "ManagerFollowUpAdminTimeOfNotification", $(obj).val());
    }

        //Seizre
    else if (obj.id == 'TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsTimeStaffNotified') {
        CreateAutoSaveXml("CustomIncidentSeizureDetails", "IncidentSeizureDetailsTimeStaffNotified", $(obj).val());
    }
    else if (obj.id == 'TextBoxTime_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "SeizureFollowUpIndividualStatusTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdminTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportSeizureSupervisorFollowUps", "SeizureSupervisorFollowUpAdminTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFGCTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportSeizureSupervisorFollowUps", "SeizureSupervisorFollowUpFGCTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportSeizureSupervisorFollowUps", "SupervisorFollowUpManagerTimeOfNotification", $(obj).val());
    }
    else if (obj.id == 'TextBox_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdminTimeOfNotification') {
        CreateAutoSaveXml("CustomIncidentReportSeizureManagerFollowUps", "ManagerFollowUpAdminTimeOfNotification", $(obj).val());
    }

}

function SetFilterParameterValueOnSave() {
    var ButtonClickedval = ButtonClicked;
    if (ButtonClicked == undefined || ButtonClicked == "")
        CustomFlag = false;
    ButtonClicked = "";
    return "ButtonClicked=" + ButtonClickedval;
}

function DetailsSignDocument(SignSection) {
    _SignSection = SignSection;
    var _LoggedInUserId = 0;
    var _LoggedInUserName = $("[id$=HiddenField_LoggedInUserName]").val();
    var _SignedBy;

    if (SignSection == 'Details') {
        var buttonstatus = $('#ButtonDetailsSign').val();
        if (buttonstatus == "Edit") {
            $('#DetailsTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonDetailsSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportDetails", "InProgressStatus", 21);
        }

        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'IndividualStatus') {
        var buttonstatus = $('#ButtonFollowUpIndividualStatusSign').val();
        if (buttonstatus == "Edit") {
            $('#IncidentFollowUPTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonFollowUpIndividualStatusSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportFollowUpOfIndividualStatuses", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'SupervisorFollowUp') {
        var buttonstatus = $('#ButtonSupervisorFollowUpSign').val();
        if (buttonstatus == "Edit") {
            $('#SupervisorFollowUpTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonSupervisorFollowUpSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportSupervisorFollowUps", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'IncidentReportManagerFollowUp') {
        var buttonstatus = $('#ButtonIncidentReportManagerFollowUpSign').val();
        if (buttonstatus == "Edit") {
            $('#IncidentManagerFollowUpTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonIncidentReportManagerFollowUpSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportManagerFollowUps", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'AdministratorReview') {
        var buttonstatus = $('#ButtonAdministratorReviewsSign').val();
        if (buttonstatus == "Edit") {
            $('#IncidentAdministratorTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonAdministratorReviewsSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportAdministratorReviews", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'FallDetails') {
        var buttonstatus = $('#ButtonFallDetailsSign').val();
        if (buttonstatus == "Edit") {
            $('#FallDetailsTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonFallDetailsSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportFallDetails", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'FallIndividualStatus') {
        var buttonstatus = $('#ButtonFallFollowUpIndividualStatusSign').val();
        if (buttonstatus == "Edit") {
            $('#FallIndividualStatusTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonFallFollowUpIndividualStatusSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportFallFollowUpOfIndividualStatuses", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'FallSupervisorFollowUp') {
        var buttonstatus = $('#ButtonFallSupervisorFollowUpSign').val();
        if (buttonstatus == "Edit") {
            $('#FallSupervisorFollowUpTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonFallSupervisorFollowUpSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportFallSupervisorFollowUps", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'FallManagerFollowUp') {
        var buttonstatus = $('#ButtonCustomIncidentReportFallManagerFollowUpSign').val();
        if (buttonstatus == "Edit") {
            $('#FallManagerFollowUpTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonCustomIncidentReportFallManagerFollowUpSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportFallManagerFollowUps", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'FallAdministrators') {
        var buttonstatus = $('#ButtonFallAdministratorReviewSign').val();
        if (buttonstatus == "Edit") {
            $('#FallAdministrator').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonFallAdministratorReviewSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportFallAdministratorReviews", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'SeizureDetails') {
        var buttonstatus = $('#ButtonSDetailsSign').val();
        if (buttonstatus == "Edit") {
            $('#SeizureDetailsTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonSDetailsSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentSeizureDetails", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'SeizureIndividualStatus') {
        var buttonstatus = $('#ButtonSeizureFollowUpIndividualStatusSign').val();
        if (buttonstatus == "Edit") {
            $('#SeizureIndividualStatusTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonSeizureFollowUpIndividualStatusSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'SeizureSupervisorFollowUp') {
        var buttonstatus = $('#ButtonSeizureSupervisorFollowUpSign').val();
        if (buttonstatus == "Edit") {
            $('#SeizureSupervisorFollowUpTable').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonSeizureSupervisorFollowUpSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportSeizureSupervisorFollowUps", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'SeizuretManagerFollowUp') {
        var buttonstatus = $('#ButtonSeizuretManagerFollowUpSign').val();
        if (buttonstatus == "Edit") {
            $('#TableSeizuretManagerFollowUp').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonSeizuretManagerFollowUpSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportSeizureManagerFollowUps", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
    if (SignSection == 'SeizureAdministrators') {
        var buttonstatus = $('#ButtonSeizureAdministratorReviewSign').val();
        if (buttonstatus == "Edit") {
            $('#SeizureAdministrator').find("input,textarea,select").removeAttr("disabled");
            $('#ButtonSeizureAdministratorReviewSign').val("Sign");
            CreateAutoSaveXml("CustomIncidentReportSeizureAdministratorReviews", "InProgressStatus", 21);
        }
        if (buttonstatus != "Edit") {
            signOnCallBack = true; CustomFlag = true;
            ButtonClicked = SignSection;
            SaveSucess = SavePageData();
        }
    }
}

function BeforeDocumentSignedHandler(documentId, screenId, signType, clientSignedPaper, userPassword, signatureString, signerId, signatureId, signerType, DocumentVersionId, CredentialString, delimeter) {
    var SignedBy;
    var SignedDate;
    var _RetFalse = false;
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/IncidentReport/DetailPage/WebPages/IncidentReport.aspx?functionName=GetSignRecord",
            data: 'SignSection=' + _SignSection + "&signType=" + signType + "&signatureString=" + signatureString,
            async: false,
            success: function (result) {
                AutoSaveXMLDom = $.xmlDOM(result);
                if (AutoSaveXMLDom[0].childNodes[0].getAttribute("xmlns:xsi") == null) {
                    AutoSaveXMLDom[0].childNodes[0].setAttribute("xmlns:xsi", 'http://www.w3.org/2001/XMLSchema-instance')
                }
                // trigger the xml update event
                $(document).triggerHandler('xmlchange');
                if (_SignSection == 'Details') {
                    $('#ButtonDetailsSign').val("Edit");
                    $('#DetailsTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonDetailsSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "SignedDate");

                    $('#Span_SignedBy').text(SignedBy);
                    $('#Span_DateSigned').text(formatDate(SignedDate, "MM/dd/yyyy"));
                    var CurStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportDetails", "CurrentStatus");
                    if (CurStatus == 22) {
                        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory]").attr("disabled", "disabled");
                        $("select[id$=DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory]").attr("disabled", "disabled");
                        // $('#GeneralTable').find("input,textarea,select").attr("disabled", "disabled");
                        $('#ButtonFollowUpIndividualStatusSign').removeAttr("disabled");
                        $('#ButtonSupervisorFollowUpSign').removeAttr("disabled");
                        $('#ButtonAdministratorReviewsSign').removeAttr("disabled");
                    }
                }
                if (_SignSection == 'IndividualStatus') {
                    $('#ButtonFollowUpIndividualStatusSign').val("Edit");
                    $('#IncidentFollowUPTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonFollowUpIndividualStatusSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFollowUpOfIndividualStatuses", "SignedDate");

                    $('#Span_SignedByIndividualStatus').text(SignedBy);
                    $('#Span_DateSignedIndividualStatus').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'SupervisorFollowUp') {
                    $('#ButtonSupervisorFollowUpSign').val("Edit");
                    $('#SupervisorFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonSupervisorFollowUpSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSupervisorFollowUps", "SignedDate");

                    $('#Span_SignedBySupervisorFollow').text(SignedBy);
                    $('#Span_DateSignedSupervisorFollow').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'IncidentReportManagerFollowUp') {
                    $('#ButtonIncidentReportManagerFollowUpSign').val("Edit");
                    $('#IncidentManagerFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonIncidentReportManagerFollowUpSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportManagerFollowUps", "SignedDate");

                    $('#SpanSignedByIncidentReportManagerFollowUp').text(SignedBy);
                    $('#Span_DateSignedIncidentReportManagerFollowUp').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'AdministratorReview') {
                    $('#ButtonAdministratorReviewsSign').val("Edit");
                    $('#IncidentAdministratorTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonAdministratorReviewsSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportAdministratorReviews", "SignedDate");

                    $('#Span_SignedByAdministratorReview').text(SignedBy);
                    $('#Span_DateSignedAdministratorReview').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'FallDetails') {
                    $('#ButtonFallDetailsSign').val("Edit");
                    $('#FallDetailsTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonFallDetailsSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails", "SignedDate");

                    $('#SpanSignedByFallDetails').text(SignedBy);
                    $('#Span_DateSignedFallDetails').text(formatDate(SignedDate, "MM/dd/yyyy"));

                    var CurFallStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallDetails", "CurrentStatus");
                    if (CurFallStatus == 22) {
                        $('#ButtonFallFollowUpIndividualStatusSign').removeAttr("disabled");
                        $('#ButtonFallSupervisorFollowUpSign').removeAttr("disabled");
                        $('#ButtonFallAdministratorReviewSign').removeAttr("disabled");
                    }
                }
                if (_SignSection == 'FallIndividualStatus') {
                    $('#ButtonFallFollowUpIndividualStatusSign').val("Edit");
                    $('#FallIndividualStatusTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonFallFollowUpIndividualStatusSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallFollowUpOfIndividualStatuses", "SignedDate");

                    $('#SpanSignedByFallIndividual').text(SignedBy);
                    $('#Span_DateSignedFallIndividual').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'FallSupervisorFollowUp') {
                    $('#ButtonFallSupervisorFollowUpSign').val("Edit");
                    $('#FallSupervisorFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonFallSupervisorFollowUpSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallSupervisorFollowUps", "SignedDate");

                    $('#SpanSignedByFallSupervisor').text(SignedBy);
                    $('#Span_DateSignedFallSupervisor').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'FallManagerFollowUp') {
                    $('#ButtonCustomIncidentReportFallManagerFollowUpSign').val("Edit");
                    $('#FallManagerFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonCustomIncidentReportFallManagerFollowUpSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallManagerFollowUps", "SignedDate");

                    $('#SpanSignedByIncidentReportFallManagerFollowUp').text(SignedBy);
                    $('#Span_DateSignedIncidentReportFallManagerFollowUp').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'FallAdministrators') {
                    $('#ButtonFallAdministratorReviewSign').val("Edit");
                    $('#FallAdministrator').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonFallAdministratorReviewSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportFallAdministratorReviews", "SignedDate");

                    $('#SpanSignedByFallAdministrator').text(SignedBy);
                    $('#Span_DateSignedFallAdministrator').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'SeizureDetails') {
                    $('#ButtonSDetailsSign').val("Edit");
                    $('#SeizureDetailsTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonSDetailsSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails", "SignedDate");

                    $('#SpanSignedBySeizureDetails').text(SignedBy);
                    $('#Span_DateSignedSeizureDetails').text(formatDate(SignedDate, "MM/dd/yyyy"));
                    var CurSeizureStatus = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentSeizureDetails", "CurrentStatus");
                    if (CurSeizureStatus == 22) {
                        $('#ButtonSeizureFollowUpIndividualStatusSign').removeAttr("disabled");
                        $('#ButtonSeizureSupervisorFollowUpSign').removeAttr("disabled");
                        $('#ButtonSeizureAdministratorReviewSign').removeAttr("disabled");
                    }
                }
                if (_SignSection == 'SeizureIndividualStatus') {
                    $('#ButtonSeizureFollowUpIndividualStatusSign').val("Edit");
                    $('#SeizureIndividualStatusTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonSeizureFollowUpIndividualStatusSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "SignedDate");

                    $('#SpanSignedBySeizureIndividual').text(SignedBy);
                    $('#Span_DateSignedSeizureIndividual').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'SeizureSupervisorFollowUp') {
                    $('#ButtonSeizureSupervisorFollowUpSign').val("Edit");
                    $('#SeizureSupervisorFollowUpTable').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonSeizureSupervisorFollowUpSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureSupervisorFollowUps", "SignedDate");

                    $('#SpanSignedBySeizureSupervisor').text(SignedBy);
                    $('#Span_DateSignedSeizureSupervisor').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }

                if (_SignSection == 'SeizuretManagerFollowUp') {
                    $('#ButtonSeizuretManagerFollowUpSign').val("Edit");
                    $('#TableSeizuretManagerFollowUp').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonSeizuretManagerFollowUpSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureManagerFollowUps", "SignedDate");

                    $('#SpanSignedBySeizuretManagerFollowUp').text(SignedBy);
                    $('#Span_DateSignedSeizuretManagerFollowUp').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                if (_SignSection == 'SeizureAdministrators') {
                    $('#ButtonSeizureAdministratorReviewSign').val("Edit");
                    $('#SeizureAdministrator').find("input,textarea,select").attr("disabled", "disabled");
                    $('#ButtonSeizureAdministratorReviewSign').removeAttr("disabled");

                    SignedBy = $("[id$=HiddenField_LoggedInUserName]").val();
                    SignedDate = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomIncidentReportSeizureAdministratorReviews", "SignedDate");

                    $('#SpanSignedBySeizureAdministrator').text(SignedBy);
                    $('#Span_DateSignedSeizureAdministrator').text(formatDate(SignedDate, "MM/dd/yyyy"));
                }
                return false;
            }
        });
        return _RetFalse;
    }
    catch (err) {
        LogClientSideException(err, 'IncidentReport-BeforeDocumentSignedHandler');
    }
}
///This is used for open client search POP up
function OpenClientSearchPopUpIRDetail(List) {
    OpenClientSearchPopUp(GetRelativePath(), "IR");
}

// to open Client Pop up when user open this screen from 'Office Tab'
function DetailScreenCallbackComplete() {
    var _LoggedInUserId = 0;
    var _LoggedInUserName = $("[id$=HiddenField_LoggedInUserName]").val();
    _LoggedInUserId = objectPageResponse.LoggedInUserId;
    if (CustomFlag == true) {
        if (objectPageResponse.ValidationInfoHTML == null) {
            CustomFlag = false;
            OpenPage(5765, 61, "screenId=" + GetCurrentScreenID() + "^signerID=" + _LoggedInUserId + "^signerType=S" + "^signatureId=0" + "^signerName=" + _LoggedInUserName + "^PageTitle=" + PageTitle, null, GetRelativePath(), 'T', "dialogHeight:400px; dialogWidth: 540px;dialogTitle:Signature Page");
        }
    }
    if (objectPageResponse.UnsavedChangeId == 0 && $("CustomIncidentReports IncidentReportId", objectPageResponse.ScreenDataSetXml).text() == "-1" && ($("CustomIncidentReports ClientId", objectPageResponse.ScreenDataSetXml).text() == '' || $("CustomIncidentReports ClientId", objectPageResponse.ScreenDataSetXml).text() == '0')) {
        if (($('[id$=Span_CustomIncidentReports_ClientId]').html()) == 0)
            OpenClientSearchPopUpIRDetail();
    }
}



function GetClientDOB(ClientIdForDOB) {
    var ClientId = ClientIdForDOB;
    try {
        $.ajax({
            type: "POST",
            url: "../Custom/IncidentReport/DetailPage/WebPages/IncidentReport.aspx?FunctionName=GetClientDOB",
            data: 'ClientId=' + ClientId,
            asyn: false,
            success: function (result) {
                var formatDOM = ISODateString(result);
                $('[id$=Span_CustomIncidentReports_DOB]').html(formatDOM);
            }

        });
    }

    catch (err) {
        LogClientSideException(err, 'CustomRegistrations-BindReferralSubtype');
    }

}


function LoadProgram(sender) {
    var ClientId = sender;
    if (ClientId != '') {
        $.post(GetRelativePath() + "Custom/IncidentReport/DetailPage/WebPages/IncidentReport.aspx?FunctionName=FillProgramDropDown&ClientId=" + ClientId, null, FillProgramDropDown);
    }
}

function FillProgramDropDown(result) {
    try {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            $("[id$=DropDownList_CustomIncidentReportGenerals_GeneralProgram]").html(pageResponse);
            //HidePopupProcessing();
        }
    }
    catch (err) {
        LogClientSideException(err, 'IncidentReport');
    }
}

function ISODateString(dateIn) {
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
    return (d.getMonth() + 1) + '/' + pad(d.getDate() + 1) + '/' + pad(d.getFullYear()) + '';
}

function GetSuffix(obj) {
    var staffid = obj.value;
    if (staffid != "") {
        try {
            $.ajax({
                type: "POST",
                url: GetRelativePath() + "Custom/IncidentReport/DetailPage/WebPages/IncidentReport.aspx?functionName=GetSignSuffix",
                data: 'StaffId=' + staffid,
                async: false,
                success: function (result) {
                    if (result != null) {
                        if (obj.id == $("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]").attr("id")) {
                            $('#TextBoxTime_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusCredentialTitle').val(result);
                            CreateAutoSaveXml("CustomIncidentReportFollowUpOfIndividualStatuses", "FollowUpIndividualStatusCredentialTitle", $('#TextBoxTime_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusCredentialTitle').val());

                        }
                        else if (obj.id == $("[id$=DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating]").attr("id")) {
                            $('#TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusCredentialTitle').val(result);
                            CreateAutoSaveXml("CustomIncidentReportFallFollowUpOfIndividualStatuses", "FallFollowUpIndividualStatusCredentialTitle", $('#TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusCredentialTitle').val());
                        }
                        else if (obj.id == $("[id$=DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating]").attr("id")) {
                            $('#TextBoxTime_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusCredentialTitle').val(result);
                            CreateAutoSaveXml("CustomIncidentReportSeizureFollowUpOfIndividualStatuses", "SeizureFollowUpIndividualStatusCredentialTitle", $('#TextBoxTime_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusCredentialTitle').val());
                        }
                    }
                }
            });
        }
        catch (err) {
            LogClientSideException(err, 'RestrictiveProcedure Ajax Error');
        }
    }
    else {
        if (obj.id == $("[id$=DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating]").attr("id")) {
            $('#TextBoxTime_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusCredentialTitle').val('');
        }
        else if (obj.id == $("[id$=DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating]").attr("id")) {
            $('#TextBox_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusCredentialTitle').val('');
        }
        else if (obj.id == $("[id$=DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating]").attr("id")) {
            $('#TextBoxTime_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusCredentialTitle').val('');
        }
        return false;
    }
}
function SetClientDetailsinXML(senders) {
    var ClientId = senders;
    try {
        $.ajax({
            type: "POST",
            url: "../Custom/IncidentReport/DetailPage/WebPages/IncidentReport.aspx?FunctionName=GetClientDetailsinXML",
            data: 'ClientId=' + ClientId,
            asyn: false,
            success: function (result) {
                AutoSaveXMLDom = $.xmlDOM(result);
                //                if (AutoSaveXMLDom[0].childNodes[0].getAttribute("xmlns:xsi") == null) {
                //                    AutoSaveXMLDom[0].childNodes[0].setAttribute("xmlns:xsi", 'http://www.w3.org/2001/XMLSchema-instance')
                //                }
                // trigger the xml update event
                //                $(document).triggerHandler('xmlchange');
            }
        });
    }
    catch (err) {
        LogClientSideException(err, 'resrtictive procedures');
    }

}

function NotZero() {
    if ($('#TextBox_CustomIncidentReportSeizureDetails_SeizureDetailsNumberOfSwipes').val() == "0") {
        ShowHideErrorMessage('Number of swipes cannot be zero', 'true');
        $('#TextBox_CustomIncidentReportSeizureDetails_SeizureDetailsNumberOfSwipes').val('');
        return false;
    }
    else {
        ShowHideErrorMessage('Number of swipes cannot be zero', 'false');
        return true;
    }
}

function ValidateDataForParentChildGridEventHandler() {
    if ($('#TextBox_CustomIncidentReportSeizures_TimeOfSeizure').val() == "" &&
       $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val() == "" &&
       $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val() == "") {
        ShowHideErrorMessage('Please Enter Data', 'true');
        return false;
    }
    else {
        if ($('#TextBox_CustomIncidentReportSeizures_TimeOfSeizure').val() == "") {
            ShowHideErrorMessage('Time of seizure is required', 'true');
            return false;
        }
        else if ($('#TextBox_CustomIncidentReportSeizures_TimeOfSeizure').val() != "") {
            if ($('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val() == "" &&
           $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val() == "") {
                ShowHideErrorMessage('Duration of seizure is required in either minutes or seconds', 'true');
                return false;
            }
            else {
                ShowHideErrorMessage(' Duration of seizure is required in either minutes or seconds', 'false');
                if ($('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val() == "") {
                    $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin').val(0);
                    return true;
                }
                else if ($('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val() == "") {
                    $('#TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec').val(0);
                    return true;
                }
            }

        }
        return true;
    }
}
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