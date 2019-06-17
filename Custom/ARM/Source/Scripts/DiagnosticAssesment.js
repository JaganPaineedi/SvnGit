
var tabobject = null;
//Added by Ashwani to Show/Hide Tabs
var DLA_Tab;
var Psychosocial_Tab;
var PsychosocialAdult_Tab;
var PsychosocialEAP_Tab;
var SubstanceUse_Tab;
var RiskAssessment_Tab;
var RiskAssessmentEAP_Tab
var PhysicalHealth_Tab;
var PhysicalHealthEAP_Tab;
var MentalStatusChild_Tab;
var MentalStatusEAP_Tab;
var MentalStatusAdultMinor_Tab;
var NeedsList_Tab;
var NarrativeSummary_Tab;
var InitialTreatmentPlan_Tab;
var DevMilestones_Tab;
var SleepHygiene_Tab;
var FamilyHistory_Tab;
var ChildPsychosocial_Tab;
var EducationHistory_Tab;
var EducationHistoryMinors_Tab;
var Housing_Tab;
var Vocational_Tab;
var Diagnosis_Tab;
var checkForInitialUpdate;
var showTreatmentPlan = true;
var FolderUrl = '';
var clientAge;

var InitialOrUpdate = 0;

//Function to get Tab value when on tab load.
function StoreTabstripClientObject(sender) {


    tabobject = sender;

    //Added by Ashwani to initialize tab variables
    DLA_Tab = tabobject.findTabByText('DLA20');
    Psychosocial_Tab = tabobject.findTabByText('Psychosocial [M]');
    PsychosocialAdult_Tab = tabobject.findTabByText('Psychosocial [A]');
    PsychosocialEAP_Tab = tabobject.findTabByText('Psychosocial [EAP]');
    SubstanceUse_Tab = tabobject.findTabByText('Substance Use');
    RiskAssessment_Tab = tabobject.findTabByText('Risk Assessment');
    RiskAssessmentEAP_Tab = tabobject.findTabByText('Risk Assessment [EAP]');
    PhysicalHealth_Tab = tabobject.findTabByText('Physical Health');
    PhysicalHealthEAP_Tab = tabobject.findTabByText('Physical Health [EAP]');
    MentalStatusChild_Tab = tabobject.findTabByText('Mental Status [C]');
    MentalStatusAdultMinor_Tab = tabobject.findTabByText('Mental Status');
    MentalStatusEAP_Tab = tabobject.findTabByText('Mental Status [EAP]');
    NeedsList_Tab = tabobject.findTabByText('Needs List');
    NarrativeSummary_Tab = tabobject.findTabByText('Recommended Svcs');
    InitialTreatmentPlan_Tab = tabobject.findTabByText('Initial Treatment Plan');
    DevMilestones_Tab = tabobject.findTabByText('Dev Milestones');
    SleepHygiene_Tab = tabobject.findTabByText('Sleep Hygiene');
    FamilyHistory_Tab = tabobject.findTabByText('Family History');
    ChildPsychosocial_Tab = tabobject.findTabByText('Child Psychosocial');
    EducationHistory_Tab = tabobject.findTabByText('Education History-Early Childhood');
    EducationHistoryMinors_Tab = tabobject.findTabByText('Education History-Minors');
    Housing_Tab = tabobject.findTabByText('Housing');
    Vocational_Tab = tabobject.findTabByText('Vocational');
    Diagnosis_Tab = tabobject.findTabByText('Diagnosis');


}

//Function to get Tab value On Tab Selecting  .
function ClientTabSelectingHandler(sender, eventArgs) {
    try {

        var tabStrip = sender;
        var tab = eventArgs._tab;
        //Commented By for To check CustomDocumentAssessmentNeeds table if there is any primary key AssessmentNeedId with less than 0 not on tab click
        //Commented By Amit Kumar Srivastava, #1955, Harbor Go Live Issues, DA Unsaved Changes Issues
        //Added By Minakshi to not allow user to click on TP if UnsavedChangeId > 0
        //        if (tab._text == "Initial Treatment Plan") {
        //            if (UnsavedChangeId > 0) {
        //                ShowHideErrorMessage('Document must be saved before the Initial Treatment Plan can be accessed.', 'true');
        //                eventArgs.set_cancel(true)
        //                StopSpellCheckProcess();
        //                return false;
        //            }
        //        }

        if (ParentUserControlName == "DiagnosticNeedsList") {
            if (CheckForBlankNeed(undefined) == true) {
                ShowHideErrorMessage('Please enter Need name and Need Description before switching to another tab.', 'true');
                eventArgs.set_cancel(true);
                return false;
            }
            else {
                ShowHideErrorMessage('', 'false');
                return true;
            }
        }


        return true;
    }
    catch (err) {
        LogClientSideException(err, 'Diagnostic Needs List');
    }

}


//Added By Ashwani to show validation messages
function ValidateCustomPageEventHandler() {

    var initial = $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").is(":checked");
    var update = $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").is(":checked");


    var AssessmentTypeA = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A").is(":checked");
    var AssessmentTypeM = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M").is(":checked");
    var AssessmentTypeE = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_E").is(":checked");
    var AssessmentTypeC = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C").is(":checked");


    if ($("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").length != 0 && $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").length != 0) {
        if (!(initial || update)) {
            ShowMsgBox('Select Assessment type (Initial, Update).', ConfirmationMessageCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            return false;
            ShowHideErrorMessage('Please select any option from Initial,Update', 'true');
            return false;
        }
    }

    if ($("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A").length != 0 && $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M").length != 0 && $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_E").length != 0 && $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C").length != 0) {
        if (!(AssessmentTypeA || AssessmentTypeM || AssessmentTypeE || AssessmentTypeC)) {
            ShowHideErrorMessage('Please select at least one option from Assessment Type ', 'true');
            return false;
        }
    }

    if (CheckNeeds(AutoSaveXMLDom) == false) {
        //ShowHideErrorMessage('Please enter Need Name and Description for all needs.', 'true');
        ShowHideErrorMessage('Please enter Need Name for all needs.', 'true');
        return false;
    }

    //    if ($('#TextArea_CustomDocumentDiagnosticAssessments_ChildProtectiveServicesReason').length > 0) {
    //        if ($('#TextArea_CustomDocumentDiagnosticAssessments_ChildProtectiveServicesReason').val().length >= 250) {
    //            ShowHideErrorMessage('Please limit the text length of Child Protective Services Reason to 250', 'true');
    //            return false;
    //        }
    //    }
}

//Added By Ashwani to get reinitialize message on initial,update click
function ReInitializeDiagnosticAssessment(ControlID) {
    PopupProcessing(); // Added BY Rakesh-II Task 29  (SmartcareWeb Phase 3 Development) to show Processing (Harbor Go Live Issues)
    var fnName = 'GetPopUpOnInitialUpdate';
    $.post("../AjaxScript.aspx?functionName=" + fnName + "&AssessmentType=" + $("#" + ControlID).val(), function (result) { onSuccessPopUp(result, ControlID); }
    );

}
function onSuccessPopUp(result, ControlID) {
    HidePopupProcessing(); // Added by jagdeep as per task #1791 Diagnoistic Assessment: Application get hangs out
    var UpdateAssessmentText = result;
    var action = "Reinitilize";
    //Below line commneted&  Added new one BY Rakesh-II Task 29  (SmartcareWeb Phase 3 Development) to show Processing 
    //value = ShowMsgBox(UpdateAssessmentText, ConfirmationMessageCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'ConfirmMessageForDiagnosticCompleteDocumentOnOK(\'' + action + '\')', 'ConfirmMessageForDiagnosticCompleteDocumentOnCancel(\'' + ControlID + '\')');
    value = ShowMsgBox(UpdateAssessmentText, ConfirmationMessageCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'ConfirmMessageForDiagnosticCompleteDocumentOnOK(\'' + action + '\')', 'ConfirmMessageForDiagnosticCompleteDocumentOnCancel(\'' + ControlID + '\')', null, null, null, true, null);
}
//Purpose :Implement the custom message box
function ConfirmMessageForDiagnosticCompleteDocumentOnCancel(ControlID) {
    try {
        $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").attr("checked", false);
        $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").attr("checked", false);

        switch (InitialOrUpdate) {
            case 'I':
                $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").attr("checked", true);
                ShowHideUpdateReason(false);
                isUpdate = false;
                showTreatmentPlan = true;
                break;
            case 'U':
                $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").attr("checked", true);
                ShowHideUpdateReason(true);
                isUpdate = true;
                showTreatmentPlan = false;
                break;
            default: ShowHideUpdateReason(false);
        }
        var ControlObject = $("#" + ControlID)
        if (InitialOrUpdate != 0)//Only when there is any value in it
            SaveAutoSaveXMLDom(ControlObject[0]);
        return false;
    }
    catch (err) {//alert('Error occured in JS function ');}
        LogClientSideException(err, 'Documents');
    }
}
//Purpose :Implement the custom message box
function ConfirmMessageForDiagnosticCompleteDocumentOnOK(action) {
    try {
        var _filterData = "UnsavedChangeId=" + UnsavedChangeId;
        var AssessmentScreenType;
        if ($("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").is(":checked")) {
            AssessmentScreenType = 'AssessmentScreenType=I';
            //$('#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I').attr("checked", true);
        }
        else if ($("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").is(":checked")) {
            AssessmentScreenType = 'AssessmentScreenType=U';
            //$('#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U').attr("checked", true);
        }

        var documentRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("Documents");
        documentRowFilter = 'AuthorId';
        var docummentRowDomFilter = $(documentRowFilter, documentRow[0]);

        var _currentAuthorId = -1;
        if (docummentRowDomFilter.length > 0) {
            _currentAuthorId = documentRow[0].selectNodes("AuthorId")[0].text;
        }

        _filterData = _filterData + '^' + AssessmentScreenType + '^ReIntialization=Y' + '^CurrentAuthorId=' + _currentAuthorId;
        _reinitializeTabs = true;
        parent.PopupProcessing();  //Added  By Rakesh-II Task 29  (SmartcareWeb Phase 3 Development) to show Processing 
        LoadDocument(GetCurrentScreenID(), 5763, _filterData, CurrentHistoryId, GetRelativePath(), pageActionEnum.New, null, false, globalCurrentScreenTabIndex);
        CreateInitializationImages(AutoSaveXMLDom);
        //parent.PopupProcessing();

    }
    catch (err) {
        LogClientSideException(err, 'Documents');
    }
}



//Function to Bind need list data on updating need list .
function SetScreenSpecificValues(dom, action) {
    
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
            //Modify by jagdeep as per task #1793-Harbor Go Live Issues
            var tabStrip = $find("RadTabStrip1");
            StoreTabstripClientObject(tabStrip);

            //  setTimeout(function() { SetScreenSpecificValues(dom, action); }, 50);
        }
        //  {
        $('table#TableDiagnosticTabContainer').show(); //TableDiagnosticTabContainer is shown when tabobject is initialized properly.
        if (action == pageActionEnum.None) {
            if (tabobject != null) {
                ParentUserControlName = tabobject.get_selectedTab()._attributes.getAttribute("UcName");
                if ((AutoSaveXMLDom != undefined) && (CheckForBlankNeed(true) == true)) {
                }
            }
        }

        if ((action == pageActionEnum.Update || action == pageActionEnum.None) && tabobject != null) {
            if (tabobject != null && tabobject.get_selectedTab().get_text().indexOf('Needs') >= 0)
                BindNeedList(dom);
            //added for substance use
            if (tabobject != null && tabobject.get_selectedTab().get_text().indexOf('Substance') >= 0) {

                ShowHideSubstance(dom);
            }
            if (tabobject != null && tabobject.get_selectedTab().get_text().indexOf('Recommended Svcs') >= 0) {
                SetReceivingStaffValue(dom);
                SetAssessedNeedReferral();
                //SetAssessedNeedTransfer(dom); //Comment By Sudhir Singh as per Task#1838 in Harbor Go Live Issues
            }
            
            //show/hide Checkboxes for Update/initial after Save/Update
            ShowHideCheckBoxForInitialUpdate(tabobject.get_selectedTab().get_text());
        }
     
        //show/hide Reason for Update
        ShowHideReasonForUpdate(dom, action);

        if (action != 'TabRequest') {
            //Show Hide Tab Logic - Ashwani 
            ShowHideTabs(dom, action);
        }

        //Disable RadioButtons if saved
        DisableRadioButtons(dom);

        var ReasonUpdate = $('tr[updateReason]');
        if (ReasonUpdate.length > 0) {
            ReasonUpdate.hide();
        }
        //}

        // added by 10-Nov-2011 Priyanka task#16 in HArbor Development
        var clientDidNotParticipate = $('CustomTreatmentPlans ClientDidNotParticipate', dom);

        if (clientDidNotParticipate.length > 0) {
            if (clientDidNotParticipate.text() == 'Y') {

                $('#TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment').removeAttr('readonly');
            }
        }
        //Modify by :RohitK/maninder,on 06-19-2012,1796, Item#471 Diagnostic  Assessment,Harbor Go Live Issues
        try {
            SetDiagnosisIAndIIHiddenOrderField(dom);
        }
        catch (ex) {
        }

        if ($("[id$=PanelDocumentUserControl]").length > 0) {
            $("[id$=PanelDocumentUserControl]").children().removeAttr("style");
        }
        if ($('#divPreviousDiagnosis').length > 0 && ShowInViewMode != true) {
            if (objectPageResponse.ObjectDocumentInformation != null && objectPageResponse.ObjectDocumentInformation.DocumentMode != 'view')
            OpenPage(5763, 10665, 'CustomAjaxRequestType=GetCurrentDiagnosis', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
        }
        if ($('#TextArea_CustomDocumentDiagnosticAssessments_DiagnosticImpressionsSummary').length > 0) {
            $('#TextArea_CustomDocumentDiagnosticAssessments_DiagnosticImpressionsSummary').attr("rows", "15");
        }

        if (tabobject != null && tabobject.get_selectedTab().get_text().indexOf('Recommended Svcs') >= 0) {
            if (GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentDiagnosticAssessments", "PrimaryClinicianTransfer") == 'Y')
                {
                    $('#TableTransfer').show();
                }
                else {
                    $('#TableTransfer').hide();
                }
        }
    }
   


//function added to show/hide reason on basis of initial/update selected
function ShowHideReasonForUpdate(dom, action) {
    try {
        var isUpdate = false;
        var xmlDiagnosticAssessmentRow = null;
        if (dom.length > 0) {
            if (dom != null || dom != 'undefined') {
                xmlDiagnosticAssessmentRow = dom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments");
                if (xmlDiagnosticAssessmentRow.length > 0) {
                    if (xmlDiagnosticAssessmentRow[0].selectNodes("InitialOrUpdate").length > 0) {
                        var checkInitialUpdate = $("InitialOrUpdate", xmlDiagnosticAssessmentRow[0]).text();
                        InitialOrUpdate = checkInitialUpdate;
                        switch (checkInitialUpdate) {
                            case 'I':
                                $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").attr("checked", true);
                                ShowHideUpdateReason(false);
                                isUpdate = false;
                                showTreatmentPlan = true;
                                break;
                            case 'U':
                                $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").attr("checked", true);
                                ShowHideUpdateReason(true);
                                isUpdate = true;
                                showTreatmentPlan = false;
                                break;
                            default: ShowHideUpdateReason(false);
                        }
                    }
                }
            }
            if ((isUpdate == false)) {
                ShowHideUpdateReason(false);
            }
            if (showTreatmentPlan == false) {
                if (InitialTreatmentPlan_Tab != null) {
                    ShowHideDiagnosticAssessmentTab(InitialTreatmentPlan_Tab, false);
                }
            }
        }
    }
    catch (ex) {
        LogClientSideException(err, 'ShowHideReason');
    }
}

//Function to show/hide tabs
function ShowHideTabs(dom, action) {
    try {
        getClientAge(dom);
        var adult = false;
        var minor = false;
        var EAP = false;
        var child = false;
        var AssessmentType = 'N';
        var xmlDiagnosticAssessmentRow = null;
        if (dom != null || dom != 'undefined') {
            xmlDiagnosticAssessmentRow = dom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments");
            if (xmlDiagnosticAssessmentRow.length > 0) {
                if (xmlDiagnosticAssessmentRow[0].selectNodes("TypeOfAssessment").length > 0) {
                    AssessmentType = xmlDiagnosticAssessmentRow[0].selectNodes("TypeOfAssessment")[0].text;
                }
            }
        }

        if (AssessmentType != 'N') {
            SetTabsForType(dom, action);
        }
        else {
            HideTabs(tabobject);
        }


    }
    catch (ex) {
        LogClientSideException(err, 'Set Tabs');
    }

}

//Function is added by Ashwani to Show/Hide tabs based on Assessment Type selected
function SetTabsForType(dom, action) {
    try {
        //Housing
        if ((action != undefined && (action == "update")) && tabobject.get_selectedTab()._text == "Housing") {
            if (Housing_Tab != null) {
                ShowHideDiagnosticAssessmentTab(Housing_Tab, true);
            }
        }
        else
            AddHousingTab(dom, 'N');
        //Vocational
        if ((action != undefined && (action == "update")) && tabobject.get_selectedTab()._text == "Vocational") {
            if (Vocational_Tab != null) {
                ShowHideDiagnosticAssessmentTab(Vocational_Tab, true);
            }
        }
        else
            AddVocationalTab(dom, 'N');

        DiagnosticAssessmentType(dom);
        if (AssessmentTypeA.checked) {
            ShowHideAdultBehavioralTabsEvent();
        }
        if (AssessmentTypeM.checked) {
            ShowHideMinorBehavioralTabsEvent();
        }
        if (AssessmentTypeE.checked) {
            ShowHideEAPTabsEvent();
        }
        if (AssessmentTypeC.checked) {
            ShowHideChildhoodTabsEvent();
        }

        ResizeScreenAfterContainerResize();
    }
    catch (ex) {
        LogClientSideException(err, 'SetTabsForType');
    }
}

//Function is added by Ashwani to get AssessmentType
function DiagnosticAssessmentType(dom) {
    try {
        AssessmentTypeA = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A");
        AssessmentTypeM = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M");
        AssessmentTypeE = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_E");
        AssessmentTypeC = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C");
        if (dom == undefined) {
            if (AssessmentTypeA.is(":checked"))
                AssessmentTypeA.checked = true;

            if (AssessmentTypeM.is(":checked"))
                AssessmentTypeM.checked = true;

            if (AssessmentTypeE.is(":checked"))
                AssessmentTypeE.checked = true;

            if (AssessmentTypeC.is(":checked"))
                AssessmentTypeC.checked = true;

        }
        else {
            if (dom != "" && dom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments").length > 0) {
                xmlAssessmentType = dom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments");
                var AssessmentType = xmlAssessmentType[0].selectNodes("TypeOfAssessment")[0].text;
                if (AssessmentType == 'A') {
                    AssessmentTypeA.checked = true;
                }
                if (AssessmentType == 'M') {
                    AssessmentTypeM.checked = true;
                }
                if (AssessmentType == 'E') {
                    AssessmentTypeE.checked = true;
                }
                if (AssessmentType == 'C') {
                    AssessmentTypeC.checked = true;
                }
            }
        }
    }
    catch (ex) {
        LogClientSideException(err, 'DiagnosticAssessmentType');
    }
}

//function to show/hide Housing Tab if housing checkbox is selected on psychosocial Tab
function AddHousingTab(dom, EventCheck) {
    try {
        //        var _eventCalled = EventCheck;
        //        if (EventCheck == undefined)
        //            _eventCalled = "";

        // Code for Housing Tab Visibility From Code.
        //if (_eventCalled != "" && EventCheck != "N") {
        if (EventCheck != undefined && EventCheck != "N") {
            if ($("#CheckBox_CustomDocumentDiagnosticAssessments_IncludeHousingAssessment").attr("checked") == true) {
                if (Housing_Tab != null) {
                    ShowHideDiagnosticAssessmentTab(Housing_Tab, true);
                }
                return;
            }
        }

        if (dom == undefined)
            dom = AutoSaveXMLDom;
        var xmlDiagnosticAssessmentRow = null;

        if ((dom != "" && dom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments").length > 0)) {
            xmlDiagnosticAssessmentRow = dom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments");
        }

        //Housing
        if ((xmlDiagnosticAssessmentRow[0].selectNodes("IncludeHousingAssessment").length > 0 && xmlDiagnosticAssessmentRow[0].selectNodes("IncludeHousingAssessment")[0].text.trim() == 'Y')) {
            if (Housing_Tab != null) {
                ShowHideDiagnosticAssessmentTab(Housing_Tab, true);
            }

        }
        else {
            ShowHideDiagnosticAssessmentTab(Housing_Tab, false);

        }

    }
    catch (err) {
        LogClientSideException(err, 'AddHousingTab');
    }
}
//function to show/hide Vocational Tab if vocational checkbox is selected on psychosocial Tab
function AddVocationalTab(dom, EventCheck) {
    try {
        //        var _eventCalled = EventCheck;
        //        if (EventCheck == undefined)
        //            _eventCalled = "";

        // Code for Vocational Tab Visibility From Code.
        //if (_eventCalled != "" && EventCheck != "N") {
        if (EventCheck != undefined && EventCheck != "N") {
            if ($("#CheckBox_CustomDocumentDiagnosticAssessments_IncludeVocationalAssessment").attr("checked") == true) {
                if (Vocational_Tab != null) {
                    ShowHideDiagnosticAssessmentTab(Vocational_Tab, true);
                }

                return;
            }
        }

        if (dom == undefined)
            dom = AutoSaveXMLDom;
        var xmlDiagnosticAssessmentRow = null;

        if ((dom != "" && dom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments").length > 0)) {
            xmlDiagnosticAssessmentRow = dom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments");
        }

        if ((xmlDiagnosticAssessmentRow[0].selectNodes("IncludeVocationalAssessment").length > 0 && xmlDiagnosticAssessmentRow[0].selectNodes("IncludeVocationalAssessment")[0].text.trim() == 'Y')) {
            if (Vocational_Tab != null) {
                ShowHideDiagnosticAssessmentTab(Vocational_Tab, true);
            }
        }
        else {
            ShowHideDiagnosticAssessmentTab(Vocational_Tab, false);

        }

    }
    catch (err) {
        LogClientSideException(err, 'AddVocationalTab');
    }
}


//Functions to Disable Radio Buttons
function DisableRadioButtons(dom) {
    var diagnosticAssessmentDocumentId;
    var xmlDocumentsRow = null;
    if (dom != null || dom != 'undefined') {
        if ((dom != "" && dom[0].childNodes[0].selectNodes("Documents").length > 0)) {
            var xmlDocumentsRow = dom[0].childNodes[0].selectNodes("Documents");
            diagnosticAssessmentDocumentId = parseInt(xmlDocumentsRow[0].selectNodes("DocumentId")[0].text.trim());
            if (diagnosticAssessmentDocumentId > 0) {
                DisableDiagnosticAssessmentType(true);
            }
            else
                DisableDiagnosticAssessmentType(false);
        }
    }
}

//Function Added by Ashwani in ref to Task#23  - Diagnostic Assessment:Initial Tab
//to enable/disable Assessment Type Radio Buttons
function DisableDiagnosticAssessmentType(disableScreenType) {
    if (disableScreenType == true) {

        $('#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A').attr("disabled", true);
        $('#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M').attr("disabled", true);
        $('#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_E').attr("disabled", true);
        $('#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C').attr("disabled", true);
        $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").attr("disabled", true);
        $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").attr("disabled", true);
    }
    else {
        $('#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A').attr("disabled", false);
        $('#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M').attr("disabled", false);
        $('#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_E').attr("disabled", false);
        $('#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C').attr("disabled", false);
        $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").attr("disabled", false);
        $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").attr("disabled", false);
    }
}

//Function Added by Ashwani in ref to Task#23  - Diagnostic Assessment:Initial Tab
//to handle click events (Show/Hide Tabs) of Adult Behavioral Health radio button
function ShowHideAdultBehavioralTabsEvent() {
    //Show Tabs
    if (PsychosocialAdult_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialAdult_Tab, true);
    }
    if (SubstanceUse_Tab != null) {
        ShowHideDiagnosticAssessmentTab(SubstanceUse_Tab, true);
    }
    if (RiskAssessment_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessment_Tab, true);
    }
    if (PhysicalHealth_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealth_Tab, true);
    }
    if (NeedsList_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NeedsList_Tab, true);
    }
    if (NarrativeSummary_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NarrativeSummary_Tab, true);
    }
    if (showTreatmentPlan == true) {
        if (InitialTreatmentPlan_Tab != null) {
            ShowHideDiagnosticAssessmentTab(InitialTreatmentPlan_Tab, true);
        }
    }
    if (MentalStatusAdultMinor_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusAdultMinor_Tab, true);
    }

    if (Diagnosis_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Diagnosis_Tab, true);
    }
    //Hide Tabs
    if (DLA_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DLA_Tab, false);
    }

    if (Psychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Psychosocial_Tab, false);
    }
    if (PsychosocialEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialEAP_Tab, false);
    }

    if (RiskAssessmentEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessmentEAP_Tab, false);
    }
    if (PhysicalHealthEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealthEAP_Tab, false);
    }

    if (MentalStatusChild_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusChild_Tab, false);
    }
    if (MentalStatusEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusEAP_Tab, false);
    }
    if (DevMilestones_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DevMilestones_Tab, false);
    }
    if (SleepHygiene_Tab != null) {
        ShowHideDiagnosticAssessmentTab(SleepHygiene_Tab, false);
    }
    if (FamilyHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(FamilyHistory_Tab, false);
    }
    if (ChildPsychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(ChildPsychosocial_Tab, false);
    }
    if (EducationHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistory_Tab, false);
    }
    if (EducationHistoryMinors_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistoryMinors_Tab, false);
    }

    $("#tblEarlyChildHood").attr("style", "display:none");
    $("#tblEPA").attr("style", "display:block");
    $('#TableServicePlan').hide();
    ShowHideSubstanceContent('Adult_Tab'); // Added by Jagdeep for Substance Use
    ShowNarrativeSummaryContent();
}




//Function Added by Ashwani in ref to Task#23  - Diagnostic Assessment:Initial Tab
//to handle click events (Show/Hide Tabs) of Minor Behavioral Health radio button
function ShowHideMinorBehavioralTabsEvent() {

    //Show Tabs

    if (Psychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Psychosocial_Tab, true);
    }
    if (EducationHistoryMinors_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistoryMinors_Tab, true);
    }
    if (DevMilestones_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DevMilestones_Tab, true);
    }

    if (SubstanceUse_Tab != null) {
        ShowHideDiagnosticAssessmentTab(SubstanceUse_Tab, true);
    }
    if (RiskAssessment_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessment_Tab, true);
    }
    if (PhysicalHealth_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealth_Tab, true);
    }

    if (NeedsList_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NeedsList_Tab, true);
    }

    if (NarrativeSummary_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NarrativeSummary_Tab, true);
    }
    if (showTreatmentPlan == true) {
        if (InitialTreatmentPlan_Tab != null) {
            ShowHideDiagnosticAssessmentTab(InitialTreatmentPlan_Tab, true);
        }
    }
    if (MentalStatusAdultMinor_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusAdultMinor_Tab, true);
    }
    if (Diagnosis_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Diagnosis_Tab, true);
    }
    //Hide Tabs
    if (DLA_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DLA_Tab, false);
    }
    if (PsychosocialAdult_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialAdult_Tab, false);
    }
    if (PsychosocialEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialEAP_Tab, false);
    }
    if (RiskAssessmentEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessmentEAP_Tab, false);
    }
    if (PhysicalHealthEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealthEAP_Tab, false);
    }
    if (MentalStatusEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusEAP_Tab, false);
    }
    if (MentalStatusChild_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusChild_Tab, false);
    }
    if (SleepHygiene_Tab != null) {
        ShowHideDiagnosticAssessmentTab(SleepHygiene_Tab, false);
    }
    if (FamilyHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(FamilyHistory_Tab, false);
    }
    if (ChildPsychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(ChildPsychosocial_Tab, false);
    }
    if (EducationHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistory_Tab, false);
    }
    if (Housing_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Housing_Tab, false);
    }
    if (Vocational_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Vocational_Tab, false);
    }

    $("#tblEarlyChildHood").attr("style", "display:none");
    $("#tblEPA").attr("style", "display:block");
    $('#TableServicePlan').hide();
    ShowHideSubstanceContent('Minors_Tab'); // Added by Jagdeep for Substance Use
    ShowNarrativeSummaryContent();
}



//Function Added by Ashwani in ref to Task#23  - Diagnostic Assessment:Initial Tab
//to handle click events (Show/Hide Tabs) of Employee Assistance Programming radio button
function ShowHideEAPTabsEvent() {
    //Show Tabs
    if (PsychosocialEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialEAP_Tab, true);
    }
    if (clientAge < 11) {
        if (SubstanceUse_Tab != null) {
            ShowHideDiagnosticAssessmentTab(SubstanceUse_Tab, false);
        }
    }
    else {
        if (SubstanceUse_Tab != null) {
            ShowHideDiagnosticAssessmentTab(SubstanceUse_Tab, true);
        }
    }
    //    if (SubstanceUse_Tab != null) {
    //        ShowHideDiagnosticAssessmentTab(SubstanceUse_Tab, true);
    //    }
    if (RiskAssessmentEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessmentEAP_Tab, true);
    }
    if (PhysicalHealthEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealthEAP_Tab, true);
    }
    if (MentalStatusEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusEAP_Tab, true);
    }

    if (NarrativeSummary_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NarrativeSummary_Tab, true);
    }

    //Hide Tabs
    if (PsychosocialAdult_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialAdult_Tab, false);
    }
    if (Psychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Psychosocial_Tab, false);
    }

    if (RiskAssessment_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessment_Tab, false);
    }

    if (PhysicalHealth_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealth_Tab, false);
    }
    if (MentalStatusChild_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusChild_Tab, false);
    }
    if (MentalStatusAdultMinor_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusAdultMinor_Tab, false);
    }
    if (EducationHistoryMinors_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistoryMinors_Tab, false);
    }
    if (DevMilestones_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DevMilestones_Tab, false);
    }
    if (NeedsList_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NeedsList_Tab, false);
    }
    if (InitialTreatmentPlan_Tab != null) {
        ShowHideDiagnosticAssessmentTab(InitialTreatmentPlan_Tab, false);
    }

    if (Diagnosis_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Diagnosis_Tab, false);
    }

    if (DLA_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DLA_Tab, false);
    }

    if (SleepHygiene_Tab != null) {
        ShowHideDiagnosticAssessmentTab(SleepHygiene_Tab, false);
    }
    if (FamilyHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(FamilyHistory_Tab, false);
    }
    if (ChildPsychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(ChildPsychosocial_Tab, false);
    }
    if (EducationHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistory_Tab, false);
    }
    if (Housing_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Housing_Tab, false);
    }
    if (Vocational_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Vocational_Tab, false);
    }

    $("#tblEarlyChildHood").attr("style", "display:none");
    $("#tblEPA").attr("style", "display:none");
    $('#TableServicePlan').show();
    ShowHideSubstanceContent('EAP_Tab'); // Added by Jagdeep for Substance Use
    HideNarrativeSummaryContent();
}




//Function Added by Ashwani in ref to Task#23  - Diagnostic Assessment:Initial Tab
//to handle click events (Show/Hide Tabs) of Early Childhood radio button
function ShowHideChildhoodTabsEvent() {
    //Show Tabs
    //    alert(clientAge);
    //    if (clientAge >= 11) {
    //        if (SubstanceUse_Tab != null) {
    //            ShowHideDiagnosticAssessmentTab(SubstanceUse_Tab, true);
    //        }
    //    }
    //    else {
    //        if (SubstanceUse_Tab != null) {
    //            ShowHideDiagnosticAssessmentTab(SubstanceUse_Tab, false);
    //        }
    //    }

    if (SubstanceUse_Tab != null) {
        ShowHideDiagnosticAssessmentTab(SubstanceUse_Tab, true);
    }

    if (RiskAssessment_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessment_Tab, true);
    }
    if (PhysicalHealth_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealth_Tab, true);
    }

    if (NeedsList_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NeedsList_Tab, true);
    }

    if (NarrativeSummary_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NarrativeSummary_Tab, true);
    }
    if (showTreatmentPlan == true) {
        if (InitialTreatmentPlan_Tab != null) {
            ShowHideDiagnosticAssessmentTab(InitialTreatmentPlan_Tab, true);
        }
    }
    if (MentalStatusChild_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusChild_Tab, true);
    }

    if (Diagnosis_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Diagnosis_Tab, true);
    }

    if (SleepHygiene_Tab != null) {
        ShowHideDiagnosticAssessmentTab(SleepHygiene_Tab, true);
    }
    if (FamilyHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(FamilyHistory_Tab, true);
    }
    if (ChildPsychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(ChildPsychosocial_Tab, true);
    }
    if (EducationHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistory_Tab, true);
    }
    //Hide Tabs
    if (RiskAssessmentEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessmentEAP_Tab, false);
    }
    if (PhysicalHealthEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealthEAP_Tab, false);
    }
    if (MentalStatusEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusEAP_Tab, false);
    }
    if (MentalStatusAdultMinor_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusAdultMinor_Tab, false);
    }
    if (Housing_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Housing_Tab, false);
    }
    if (Vocational_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Vocational_Tab, false);
    }

    if (Psychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Psychosocial_Tab, false);
    }
    if (PsychosocialAdult_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialAdult_Tab, false);
    }
    if (PsychosocialEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialEAP_Tab, false);
    }
    if (EducationHistoryMinors_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistoryMinors_Tab, false);
    }
    if (DevMilestones_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DevMilestones_Tab, false);
    }

    if (DLA_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DLA_Tab, false);
    }

    $("#tblEarlyChildHood").attr("style", "display:block");
    $("#tblEPA").attr("style", "display:block");
    $('#TableServicePlan').hide();
    ShowHideSubstanceContent('Childhood_Tab'); // Added by Jagdeep for Substance Use
    ShowNarrativeSummaryContent();
}


//Function Added by Ashwani in ref to Task#23  - Diagnostic Assessment:Initial Tab
//to show/hide Tabs
function ShowHideDiagnosticAssessmentTab(tabInstance, showTab) {
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

// function to Hide Tabs
function HideTabs() {
    if (SubstanceUse_Tab != null) {
        ShowHideDiagnosticAssessmentTab(SubstanceUse_Tab, false);
    }
    if (RiskAssessment_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessment_Tab, false);
    }
    if (PhysicalHealth_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealth_Tab, false);
    }
    if (RiskAssessmentEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(RiskAssessmentEAP_Tab, false);
    }
    if (PhysicalHealthEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PhysicalHealthEAP_Tab, false);
    }
    if (MentalStatusEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusEAP_Tab, false);
    }
    if (NeedsList_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NeedsList_Tab, false);
    }

    if (NarrativeSummary_Tab != null) {
        ShowHideDiagnosticAssessmentTab(NarrativeSummary_Tab, false);
    }
    if (InitialTreatmentPlan_Tab != null) {
        ShowHideDiagnosticAssessmentTab(InitialTreatmentPlan_Tab, false);
    }
    if (MentalStatusChild_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusChild_Tab, false);
    }
    if (MentalStatusAdultMinor_Tab != null) {
        ShowHideDiagnosticAssessmentTab(MentalStatusAdultMinor_Tab, false);
    }
    if (Diagnosis_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Diagnosis_Tab, false);
    }

    if (SleepHygiene_Tab != null) {
        ShowHideDiagnosticAssessmentTab(SleepHygiene_Tab, false);
    }
    if (FamilyHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(FamilyHistory_Tab, false);
    }
    if (ChildPsychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(ChildPsychosocial_Tab, false);
    }
    if (EducationHistory_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistory_Tab, false);
    }

    if (Housing_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Housing_Tab, false);
    }
    if (Vocational_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Vocational_Tab, false);
    }

    if (Psychosocial_Tab != null) {
        ShowHideDiagnosticAssessmentTab(Psychosocial_Tab, false);
    }
    if (PsychosocialAdult_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialAdult_Tab, false);
    }
    if (PsychosocialEAP_Tab != null) {
        ShowHideDiagnosticAssessmentTab(PsychosocialEAP_Tab, false);
    }
    if (EducationHistoryMinors_Tab != null) {
        ShowHideDiagnosticAssessmentTab(EducationHistoryMinors_Tab, false);
    }
    if (DevMilestones_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DevMilestones_Tab, false);
    }

    if (DLA_Tab != null) {
        ShowHideDiagnosticAssessmentTab(DLA_Tab, false);
    }

}

function AddEventHandlers() {
    try {
        $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").click(function () { ShowHideUpdateReason(false) });
        $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").click(function () { ShowHideUpdateReason(true) });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithin30Days_Y").click(function () {
            CheckUncheckSubstanceRadioButtons('AlcoholUseWithinLifetime', true);
        });
        $("#RadioButton_CustomDocumentDiagnosticAssessments_AlcoholUseWithin30Days_N").click(function () {
            CheckUncheckSubstanceRadioButtons('AlcoholUseWithinLifetime', false);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithin30Days_Y").click(function () {
            CheckUncheckSubstanceRadioButtons('CocaineUseWithinLifetime', true);
        });
        $("#RadioButton_CustomDocumentDiagnosticAssessments_CocaineUseWithin30Days_N").click(function () {
            CheckUncheckSubstanceRadioButtons('CocaineUseWithinLifetime', false);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithin30Days_Y").click(function () {
            CheckUncheckSubstanceRadioButtons('SedtativeUseWithinLifetime', true);
        });
        $("#RadioButton_CustomDocumentDiagnosticAssessments_SedtativeUseWithin30Days_N").click(function () {
            CheckUncheckSubstanceRadioButtons('SedtativeUseWithinLifetime', false);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithin30Days_Y").click(function () {
            CheckUncheckSubstanceRadioButtons('HallucinogenUseWithinLifetime', true);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_HallucinogenUseWithin30Days_N").click(function () {
            CheckUncheckSubstanceRadioButtons('HallucinogenUseWithinLifetime', false);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithin30Days_Y").click(function () {
            CheckUncheckSubstanceRadioButtons('StimulantUseWithinLifetime', true);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_StimulantUseWithin30Days_N").click(function () {
            CheckUncheckSubstanceRadioButtons('StimulantUseWithinLifetime', false);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithin30Days_Y").click(function () {
            CheckUncheckSubstanceRadioButtons('NarcoticUseWithinLifetime', true);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_NarcoticUseWithin30Days_N").click(function () {
            CheckUncheckSubstanceRadioButtons('NarcoticUseWithinLifetime', false);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithin30Days_Y").click(function () {
            CheckUncheckSubstanceRadioButtons('MarijuanaUseWithinLifetime', true);
        });
        $("#RadioButton_CustomDocumentDiagnosticAssessments_MarijuanaUseWithin30Days_N").click(function () {
            CheckUncheckSubstanceRadioButtons('MarijuanaUseWithinLifetime', false);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithin30Days_Y").click(function () {
            CheckUncheckSubstanceRadioButtons('InhalantsUseWithinLifetime', true);
        });

        $("#RadioButton_CustomDocumentDiagnosticAssessments_InhalantsUseWithin30Days_N").click(function () {
            CheckUncheckSubstanceRadioButtons('InhalantsUseWithinLifetime', false);
        });
        $("#RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithin30Days_Y").click(function () {
            CheckUncheckSubstanceRadioButtons('OtherUseWithinLifetime', true);
        });
        $("#RadioButton_CustomDocumentDiagnosticAssessments_OtherUseWithin30Days_N").click(function () {
            CheckUncheckSubstanceRadioButtons('OtherUseWithinLifetime', false);
        });
        //$('#TextArea_CustomDocumentDiagnosticAssessments_ChildProtectiveServicesReason').bind('keypress', function() { return imposeMaxLength(this, 248); });
        $("#CheckBox_CustomDocumentDiagnosticAssessments_IncludeVocationalAssessment").click(function () {

            if ($("#CheckBox_CustomDocumentDiagnosticAssessments_IncludeVocationalAssessment").is(":checked")) {
                ShowHideDiagnosticAssessmentTab(Vocational_Tab, true);
            }
            else {
                ShowHideDiagnosticAssessmentTab(Vocational_Tab, false);
            }

        });
        $("#CheckBox_CustomDocumentDiagnosticAssessments_IncludeHousingAssessment").click(function () {

            if ($("#CheckBox_CustomDocumentDiagnosticAssessments_IncludeHousingAssessment").is(":checked")) {
                ShowHideDiagnosticAssessmentTab(Housing_Tab, true);
            }
            else {
                ShowHideDiagnosticAssessmentTab(Housing_Tab, false);
            }

        });
        var serviceEval = $('select[id$=DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended]');
        if (serviceEval.length > 0) {
            serviceEval.bind("change", function () { setUnitType(); });
        }


        $("#imgFolderReferral").click(function () {
            window.open(FolderUrl, null, "status=yes,toolbar=no,menubar=no,location=no,resizable=yes,width=600,height=500");
        })

        $("#imgFolderTransfer").click(function () {
            window.open(FolderUrl, null, "status=yes,toolbar=no,menubar=no,location=no,resizable=yes,width=600,height=500");
        });

        $("#TextArea_CustomDocumentDiagnosticAssessments_ClientStrengths").bind("change", function () {
            if ($('CustomTreatmentPlans DocumentVersionId', AutoSaveXMLDom).length > 0) {
                //alert('Called');
                CreateAutoSaveXml("CustomTreatmentPlans", "ClientStrengths", $(this).val());
            }
        });
    }
    catch (err) {
        LogClientSideException(err, 'Events');
    }
}

//function added to show/hide reason
function ShowHideUpdateReason(_value) {
    try {

        if (_value) {
            $("#TblUpdateReason").attr("style", "display:block");
            showTreatmentPlan = false;
            if (InitialTreatmentPlan_Tab != null) {
                ShowHideDiagnosticAssessmentTab(InitialTreatmentPlan_Tab, false);
            }
        }
        else {
            $("#TblUpdateReason").attr("style", "display:none");

            var AssessmentTypeA = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A")[0];
            var AssessmentTypeM = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M")[0];
            var AssessmentTypeC = $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C")[0];
            if (AssessmentTypeA != null || AssessmentTypeM != null || AssessmentTypeC != null) {
                if ((AssessmentTypeA.checked || AssessmentTypeM.checked || AssessmentTypeC.checked)) {
                    showTreatmentPlan = true;
                    if (InitialTreatmentPlan_Tab != null) {
                        ShowHideDiagnosticAssessmentTab(InitialTreatmentPlan_Tab, true);
                    }

                }
            }
        }

    }
    catch (err) {
        LogClientSideException(err, 'ShowHideUpdateReason');
    }
}


//Function is added by Ashwani to show message if Initial/Update is not selected on AssessmentType RadioButton click
function SetTabsAssessmentType(dom) {
    try {

        var initial = $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").is(":checked");
        var update = $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").is(":checked");

        if (initial || update) {

            SetTabsForType(dom, undefined);
        }
        else {

            $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A").attr("checked", false);
            $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M").attr("checked", false);
            $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_E").attr("checked", false);
            $("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C").attr("checked", false);
            ShowMsgBox('Select Assessment type (Initial, Update).', ConfirmationMessageCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            return;
        }
        ResizeScreenAfterContainerResize();
    }
    catch (ex) {
        LogClientSideException(err, 'Set Tabs Assessment Type');
    }
}

///Added By Sudhir Singh as per issue#1928 in harbor go live issues
function CheckAssessmentsSelected() {
    var initial = $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_I").is(":checked");
    var update = $("#RadioButton_CustomDocumentDiagnosticAssessments_InitialOrUpdate_U").is(":checked");
    if (initial || update) {
        return true;
    }
    ShowMsgBox('Select Assessment type (Initial, Update).', ConfirmationMessageCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
    return false;
}
//End


//Function is added to refresh contents on tab click
function RefreshTabPageContents(tabControl, selectedTabTitle) {
    try {

        if (selectedTabTitle == 'Initial Treatment Plan') {
            if ($('#divPreviousDiagnosis').length > 0) {
                   OpenPage(5763, 10665, 'CustomAjaxRequestType=GetCurrentDiagnosis', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
            }
        }

        if (selectedTabTitle == 'Needs List') {
            BindNeedList(AutoSaveXMLDom);
        }

        ////        if (selectedTabTitle == 'DLA20') {
        ////            RefreshDLATabPage(AutoSaveXMLDom);
        ////        }

        // to show/hide Checkboxes on Update/initial Click
        CheckForInitialUpdate();
        ShowHideCheckBoxForInitialUpdate(selectedTabTitle);

        if (selectedTabTitle == 'Substance Use') {
            ShowHideSubstance(AutoSaveXMLDom);
            //GetAssessmentType();
            if (AssessmentTypeA.checked) {
                ShowHideSubstanceContent('Adult_Tab')
            }
            if (AssessmentTypeM.checked) {
                ShowHideSubstanceContent('Minors_Tab')
            }
            if (AssessmentTypeE.checked) {
                ShowHideSubstanceContent('EAP_Tab')
            }
            if (AssessmentTypeC.checked) {
                ShowHideSubstanceContent('Childhood_Tab')
            }

        }
        //Added by Ashwani to Show/Hide Narrative Summary Contents
        if (selectedTabTitle == 'Recommended Svcs') {
            GetFolderUrl(AutoSaveXMLDom);

            if (AssessmentTypeE.checked) {
                HideNarrativeSummaryContent();
            }
            else {
                ShowNarrativeSummaryContent();
                SetReceivingStaffValue(AutoSaveXMLDom);
                SetAssessedNeedReferral();
                //SetAssessedNeedTransfer(AutoSaveXMLDom);//Comment By Sudhir Singh as per Task#1838 in Harbor Go Live Issues
            }
            if (GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentDiagnosticAssessments", "PrimaryClinicianTransfer") == 'Y') {
                $('#TableTransfer').show();
            }
            else {
                $('#TableTransfer').hide();
            }
        }
        if (selectedTabTitle == 'Presenting Problem') {
            if (AssessmentTypeC.checked) {
                $("#tblEarlyChildHood").attr("style", "display:block");
            }
            else {
                $("#tblEarlyChildHood").attr("style", "display:none");
            }
            if (AssessmentTypeE.checked) {
                $("#tblEPA").attr("style", "display:none");
            }
            else {
                $("#tblEPA").attr("style", "display:block");
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'Refresh TabPage');
    }
}
//Function is added by Ashwani to check is initial or Update RadioButton checked
function CheckForInitialUpdate() {
    if (AutoSaveXMLDom.length > 0) {
        var xmlDiagnosticAssessmentRow = null;
        if (AutoSaveXMLDom != null || AutoSaveXMLDom != 'undefined') {
            xmlDiagnosticAssessmentRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDocumentDiagnosticAssessments");
            if (xmlDiagnosticAssessmentRow.length > 0) {
                if (xmlDiagnosticAssessmentRow[0].selectNodes("InitialOrUpdate").length > 0) {
                    checkForInitialUpdate = $("InitialOrUpdate", xmlDiagnosticAssessmentRow[0]).text();
                }
            }
        }
    }

}
//Function is added by Ashwani to show/hide Checkboxes on Update/initial Click
function ShowHideCheckBoxForInitialUpdate(selectedTabTitle) {
    try {

        if (selectedTabTitle == 'Physical Health' || selectedTabTitle == 'Physical Health [EAP]' || selectedTabTitle == 'Psychosocial [A]' || selectedTabTitle == 'Psychosocial [M]' || selectedTabTitle == 'Psychosocial [EAP]' || selectedTabTitle == 'Housing' || selectedTabTitle == 'Vocational' || selectedTabTitle == 'Risk Assessment' || selectedTabTitle == 'Risk Assessment [EAP]' || selectedTabTitle == 'Sleep Hygiene' || selectedTabTitle == 'Child Psychosocial' || selectedTabTitle == 'Substance Use' || selectedTabTitle == 'Family History' || selectedTabTitle == 'Dev Milestones' || selectedTabTitle == 'Education History-Early Childhood' || selectedTabTitle == 'Education History-Minors') {
            if (checkForInitialUpdate == 'U') {
                $("#Section259").attr("style", "display:block"); //Physical health
                $("#Section258").attr("style", "display:block"); //Physical health EAP
                $("#Section265").attr("style", "display:block"); //Housing

                $("#Section266").attr("style", "display:block"); //Child Psychosocial

                $("#Section256").attr("style", "display:block"); //Risk Assessment
                $("#Section257").attr("style", "display:block"); //Risk Assessment EAP

                $("#Section264").attr("style", "display:block"); //Sleep Hygiene

                $("#Section268").attr("style", "display:block"); //Psychosocial Adult
                $("#Section267").attr("style", "display:block"); //Psychosocial Minor
                $("#Section269").attr("style", "display:block"); //Psychosocial EAP

                $("#tblSubstanceUse").attr("style", "display:block"); //Substance Use
                $("#Section271").attr("style", "display:block"); // Vocational
                $("#Section237").attr("style", "display:block"); // Family History
                $("#Section270").attr("style", "display:block"); // Dev Milestones
                $("#Section273").attr("style", "display:block"); // Education History - Childhood
                $("#Section274").attr("style", "display:block"); // Education History - Minors
            }
            else {
                $("#Section259").attr("style", "display:none"); //Physical health
                $("#Section258").attr("style", "display:none"); //Physical health EAP
                $("#Section265").attr("style", "display:none"); //Housing

                $("#Section266").attr("style", "display:none"); //Child Psychosocial

                $("#Section256").attr("style", "display:none"); //Risk Assessment
                $("#Section257").attr("style", "display:none"); //Risk Assessment EAP

                $("#Section264").attr("style", "display:none"); //Sleep Hygiene

                $("#Section268").attr("style", "display:none"); //Psychosocial Adult
                $("#Section267").attr("style", "display:none"); //Psychosocial Minor
                $("#Section269").attr("style", "display:none"); //Psychosocial EAP

                $("#tblSubstanceUse").attr("style", "display:none"); //Substance Use
                $("#Section271").attr("style", "display:none"); // Vocational
                $("#Section237").attr("style", "display:none"); // Family History
                $("#Section270").attr("style", "display:none"); // Dev Milestones
                $("#Section273").attr("style", "display:none"); // Education History - Childhood
                $("#Section274").attr("style", "display:none"); // Education History - Minors
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'Refresh TabPage');
    }
}

//Show/Hide substance use tab according to ClientAge(empty contents)
function getClientAge(dom) {
    var xmlDom = $("CustomDocumentDiagnosticAssessments", dom);
    if (xmlDom.length > 0) {
        var years = $("clientAge", dom).text();

        var indexOfYear = years.indexOf('Y');
        clientAge = '';
        if (indexOfYear == 0)
            indexOfYear = years.indexOf('M');
        if (indexOfYear > 0) {
            clientAge = years.substring(0, indexOfYear);
        }
        else {
            clientAge = years;
        }

    }
}
//Function overridden to set blank value for AssessedNeedForReferral if saved blank
function CheckColumnValueTobeOverridden(customGridTableName, cloumnName, rowIndex) {
    if (customGridTableName == 'TableChildControl_CustomDocumentAssessmentReferrals' && cloumnName == 'AssessedNeedForReferral')
        return true;
}

function imposeMaxLength(Object, MaxLen) {
    return (Object.value.length <= MaxLen);
}


function ResizeScreenAfterContainerResize() {

    var divControlToResize = $("#DiagnosticPresentingProblem");

    if (divControlToResize.length > 0) {
        var ContentArea = $(window).height();



        if (divControlToResize.position().top > 0) {
            ContentArea = ContentArea - divControlToResize.position().top;
        }

        divControlToResize.height(ContentArea);
    }

}

function CustomAjaxRequestCallback(result, CutomAjaxRequest) {
    if (result.indexOf("###StartCurrentDiagnosisUC###") >= 0) {
        var pageResponse = result;
        var start = pageResponse.indexOf("###StartCurrentDiagnosisUC###") + 29;
        var end = pageResponse.indexOf("###EndCurrentDiagnosisUC###");
        var htmlResponse = pageResponse.substr(start, end - start);
        CreateDiagnosisTable(htmlResponse);
    }
}

function CreateDiagnosisTable(result) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' width='15%'>Type</th>";
    tableHeader += "<th align='left' width='10%'>ICD 9</th>";
    tableHeader += "<th align='left' width='15%'>ICD 10</th>";
    tableHeader += "<th align='left' width='15%'>DSMV</th>";
    tableHeader += "<th align='left' width='30%'>Description</th>";
    tableHeader += "</tr></thead>";
    var result1 = $.xmlDOM(result);
    $(result1).find('DocumentDiagnosisCodes').each(function () {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisType').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD9Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD10Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('DSMVCode').text() + "</td>";

        var dsmDesciption = $(this).find('DSMDescription').text();
        if (dsmDesciption.length > 40)
            dsmDesciption = "<span title='" + dsmDesciption + "'>" + dsmDesciption.substring(0, 40) + "..." + "</span>";
        else
            dsmDesciption = "<span>" + dsmDesciption + "</span>";
        tableBody += "<td align='left'>" + dsmDesciption + "</td>";
        tableBody += "</tr>";
    });
    var tableHeaderAxisIII = "<tr>";
    tableHeaderAxisIII += "<td align='left' colspan='5' style='padding-top:5px;'>Psychosocial, Environmental, and Other Factors</td>";
    tableHeaderAxisIII += "</tr>";
    tableHeaderAxisIII += "<tr>";
    tableHeaderAxisIII += "<td align='left' width='5%' style='padding-top:5px;'>&nbsp;</td>";
    tableHeaderAxisIII += "<td align='left' width='55%' style='padding-top:5px;'>Source</td>";
    tableHeaderAxisIII += "</tr>";
    var result2 = $.xmlDOM(result);
    var tableBodyAxisIII = "";
    $(result2).find('DocumentDiagnosisFactors').each(function () {
        tableBodyAxisIII += "<tr>";
        tableBodyAxisIII += "<td align='left'>&nbsp;</td>";
        tableBodyAxisIII += "<td align='left'>" + $(this).find('Factors').text() + "</td>";
        tableBodyAxisIII += "</tr>";
    });

    var tableHeaderAxisIV = "<tr>";
    tableHeaderAxisIV += "<td align='left' colspan='5' style='padding-top:5px;' >Axis IV</td>";
    tableHeaderAxisIV += "</tr>";
    var result3 = $.xmlDOM(result);
    var tableBodyAxisIV = "";
    $(result3).find('DiagnosesIV').each(function () {
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
    $(result4).find('DocumentDiagnosis').each(function () {
        tableBodyAxisV += "<tr>";
        tableBodyAxisV += "<td align='left' colspan='2'>GAF Score: " + $(this).find('GAFScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='1'>WHODAS Score: " + $(this).find('WHODASScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='2'>CAFAS Score: " + $(this).find('CAFASScore').text() + "</td>";
        tableBodyAxisV += "</tr>";
    });

    //tableBody += "</tbody>";

    var effectiveDate = $.xmlDOM(result).find('EffectiveDate').text();

    var trEffictiveDate = "<table width='100%'><tr><td align='left' width='20%'>Effective Date: " + effectiveDate + "</td></tr></table>";

    var DiagnosisHTML = trEffictiveDate + tableHeader + tableBody + "</tbody>" + endTable;
    $("[id$=divPreviousDiagnosis]").html(DiagnosisHTML);
}


function EnableDisableTransfer(obj) {
    if ($(obj).val() == 'Y') {
        $('#TableTransfer').show();
        $("div", $('#DivMainPageContent')).scrollTop($(document).height());
    }
    else {
        $('#TableTransfer').hide();
    }
}

