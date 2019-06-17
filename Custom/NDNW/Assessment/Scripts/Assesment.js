// For Initial Assessment Tab

var CheckBoxDDPopulation = null;
var CheckBoxSAPopulation = null;
var CheckBoxMHPopulation = null;
var RadioButtonAdultorChild = null;
var SavetabControl = "";
var flag = 0;
var Uncopeflag = 0;
var Crafftflag = 0;
var _needlistHtml = "";
var _currentSelectedTab = null;
var _ChangeSelectedIndexAfterNeedInsertion = false;
var checkLevelBehavior = "";
var UncopeCheck = false;
var UncopeCountGlobal = 0;
var _DeleteAssessmentHrmNeeds = false;

var AssessmentTypeI = null;
var AssessmentTypeU = null;
var AssessmentTypeA = null;
var AssessmentTypeAutsim = null;
//var AssessmentTypeS = null;
//Added by Loveena in ref to Task#1077 - SC Web - Venture Documents
var NeedName = "";
var NeedDescription = "";

var _reinitializeTabs = false;
var tabobject = null;
var dialogResult = '';
//var CafasUrl = '';
//Ref 919
var executeChangeEventWithScript = null;

var isPopulationChecked = false;
//var DLAFlag = '';
//var CAFASFlag = '';
var previousAssessmentType = '';
var AgencyName = '';
var safetytabindex = 0;
var SafetyCrisisPlanTabIndex = 0;

var GamblingSubtabindex = 0;
var GamblingMainTabIndex = 0;
var LoadGamblingfirsttime = 1;
var LoadSafetyPlanfirsttime = 1;

var HideProcessing = true;



function ValidateCustomPageEventHandler() {
    AssessmentType(AutoSaveXMLDom);

    var DDPopulation = $("#CheckBox_CustomHRMAssessments_ClientInDDPopulation")[0];
    var SAPopulation = $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation")[0];
    var MHPopulation = $("#CheckBox_CustomHRMAssessments_ClientInMHPopulation")[0];
    var AutismPopulation = $("#CheckBox_CustomHRMAssessments_ClientInAutsimPopulation")[0];


    if (AssessmentTypeI.checked || AssessmentTypeU.checked || AssessmentTypeA.checked) {

    }
    else {
        ShowHideErrorMessage('Please select any option from Initial,Update or Annual', 'true');
        return false;
    }

    if (DDPopulation != undefined && SAPopulation != undefined && MHPopulation != undefined && AutismPopulation != undefined) {
        if (DDPopulation.checked || SAPopulation.checked || MHPopulation.checked || AutismPopulation.checked) {

        }
        else {
            ShowHideErrorMessage('Please select at least one option from DD,SUD,MH, Gambling', 'true');
            return false;
        }
    }

    if (TabIndex == SafetyCrisisPlanTabIndex && SafetyCrisisPlanTabIndex > 0) {
        SubTabIndex = safetytabindex;
    }
    else {
        SubTabIndex = 0;
    }

    if (TabIndex == GamblingMainTabIndex && GamblingMainTabIndex > 0) {
        SubTabIndex = GamblingSubtabindex;
    }
    else {
        SubTabIndex = 0;
    }
}

function DiableRadioAfterUpdate(dom) {
    try {

        $('#RadioButton_CustomHRMAssessments_AssessmentType_I').attr("disabled", true);
        $('#RadioButton_CustomHRMAssessments_AssessmentType_U').attr("disabled", true);
        $('#RadioButton_CustomHRMAssessments_AssessmentType_A').attr("disabled", true);
        //        $('#RadioButton_CustomHRMAssessments_AssessmentType_S').attr("disabled", true);
        if (dom.length > 0) {
            var CheckBoxDom = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
            documentRowFilterCheckBoxDom = 'AssessmentType';
            docummentRowDomFilterCheckBoxDom = $(documentRowFilterCheckBoxDom, CheckBoxDom[0]);
            if (docummentRowDomFilterCheckBoxDom.length > 0) {
                var CheckValue = CheckBoxDom[0].selectNodes("AssessmentType")[0].text;
                switch (CheckValue) {
                    case 'I':
                        $('#RadioButton_CustomHRMAssessments_AssessmentType_I').attr("checked", true);
                        break;
                    case 'U':
                        $('#RadioButton_CustomHRMAssessments_AssessmentType_U').attr("checked", true);
                        break;
                    case 'A':
                        $('#RadioButton_CustomHRMAssessments_AssessmentType_A').attr("checked", true);
                        break;
                    //                    case 'S':                                       
                    //                        $('#RadioButton_CustomHRMAssessments_AssessmentType_S').attr("checked", true);                                       
                    //                        break;                                       
                    default:
                }
            }
        }
    }
    catch (ex) {
        throw ex;
    }
}

function SelectCheckBoxExist(dom) {
    // SelectCheckBoxExist1(dom); return;
    try {
        if (dom.length > 0) {
            var CheckBoxDom = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
            documentRowFilterCheckBoxDom = 'AssessmentType';
            docummentRowDomFilterCheckBoxDom = $(documentRowFilterCheckBoxDom, CheckBoxDom[0]);
            if (docummentRowDomFilterCheckBoxDom.length > 0) {
                var CheckValue = CheckBoxDom[0].selectNodes("AssessmentType")[0].text;

                switch (CheckValue) {
                    case 'I':
                        $('#RadioButton_CustomHRMAssessments_AssessmentType_I').attr("checked", true);
                        break;
                    case 'U':
                        $('#RadioButton_CustomHRMAssessments_AssessmentType_U').attr("checked", true);
                        break;
                    case 'A':
                        $('#RadioButton_CustomHRMAssessments_AssessmentType_A').attr("checked", true);
                        break;
                    //                    case 'S':                                        
                    //                        $('#RadioButton_CustomHRMAssessments_AssessmentType_S').attr("checked", true);                                        
                    //                        break;                                        
                    default:
                }
            }
            var CheckBoxDD = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
            documentRowFilterCheckBoxDD = 'ClientInDDPopulation';
            docummentRowDomFilterCheckBoxDD = $(documentRowFilterCheckBoxDD, CheckBoxDD[0]);
            if (docummentRowDomFilterCheckBoxDD.length > 0) {
                var CheckValueDD = CheckBoxDD[0].selectNodes("ClientInDDPopulation")[0].text;
                if (CheckValueDD == 'Y' && $("#CheckBox_CustomHRMAssessments_ClientInDDPopulation").length > 0) {
                    $("#CheckBox_CustomHRMAssessments_ClientInDDPopulation")[0].checked = true;
                }
                flag = 2;

            }

            var CheckBoxAutsim = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
            documentRowFilterCheckBoxAutsim = 'ClientInAutsimPopulation';
            docummentRowDomFilterCheckBoxAutsim = $(documentRowFilterCheckBoxAutsim, CheckBoxAutsim[0]);
            if (docummentRowDomFilterCheckBoxAutsim.length > 0) {
                var CheckBoxAutsim = CheckBoxAutsim[0].selectNodes("ClientInAutsimPopulation")[0].text;
                if (CheckBoxAutsim == 'Y' && $("#CheckBox_CustomHRMAssessments_ClientInAutsimPopulation").length > 0) {
                    $("#CheckBox_CustomHRMAssessments_ClientInAutsimPopulation")[0].checked = true;
                }
                flag = 2;
            }

            var CheckBoxSA = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
            documentRowFilterCheckBoxSA = 'ClientInSAPopulation';
            docummentRowDomFilterCheckBoxSA = $(documentRowFilterCheckBoxSA, CheckBoxSA[0]);
            if (docummentRowDomFilterCheckBoxSA.length > 0) {
                var CheckValueSA = CheckBoxSA[0].selectNodes("ClientInSAPopulation")[0].text;
                if (CheckValueSA == 'Y' && $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation").length > 0) {
                    $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation")[0].checked = true;
                }
                flag = 2;


            }

            var CheckBoxMM = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
            documentRowFilterCheckBoxMM = 'ClientInMHPopulation';
            docummentRowDomFilterCheckBoxMM = $(documentRowFilterCheckBoxMM, CheckBoxMM[0]);
            if (docummentRowDomFilterCheckBoxMM.length > 0) {
                var CheckValueMH = CheckBoxMM[0].selectNodes("ClientInMHPopulation")[0].text;
                if (CheckValueMH == 'Y' && $("#CheckBox_CustomHRMAssessments_ClientInMHPopulation").length > 0) {
                    $("#CheckBox_CustomHRMAssessments_ClientInMHPopulation")[0].checked = true;
                }
                flag = 2;


            }
        }
    }
    catch (ex) {
        throw ex;
    }
}

//Description:Function is used to maintain telerik control tabs
//Author:Sandeep singh
//CreatedOn:04-july-2010

function CheckInitilization(action) {
    //CheckInitilization1()return;
    if (action == pageActionEnum.New || action == "") {

        if (AutoSaveXMLDom.length > 0) {
            var CheckBoxDom = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
            documentRowFilterCheckBoxDom = 'AssessmentType';
            docummentRowDomFilterCheckBoxDom = $(documentRowFilterCheckBoxDom, CheckBoxDom[0]);

            if (docummentRowDomFilterCheckBoxDom.length > 0) {
                var CheckValue = CheckBoxDom[i].selectNodes("AssessmentType")[0].text;
                switch (CheckValue) {
                    case 'I':
                        $('#RadioButton_CustomHRMAssessments_AssessmentType_I').attr("checked", true);
                        break;
                    case 'U':
                        $('#RadioButton_CustomHRMAssessments_AssessmentType_U').attr("checked", true);
                        break;
                    case 'A':
                        $('#RadioButton_CustomHRMAssessments_AssessmentType_A').attr("checked", true);
                        break;
                    //                    case 'S':                                         
                    //                        $('#RadioButton_CustomHRMAssessments_AssessmentType_S').attr("checked", true);                                         
                    //                        break;                                         
                    default:
                }
            }
        }
    }

}

function ModalPopupWindowClosed(ModelPopUpName) {
    if (ModelPopUpName.indexOf('###StartAssociateNeedPopUp###') >= 0) {
        SetFieldValueInCtrl(ModelPopUpName);
    }
    else if (ModelPopUpName.indexOf("###StartAddNeedsPopUp###") >= 0) {
        RefreshNeedsTemplate(ModelPopUpName);

    }
    //if (window.frames[0]._popupUpdateClicked == true) {
    if (window.frames["iframeWindowDialog"]._popupUpdateClicked == true) {
        //if (_popupUpdateClicked == true)
        //dialogResult = window.frames[0].GetScreenXML();
        dialogResult = window.frames["iframeWindowDialog"].GetScreenXML();
    }
    else {
        dialogResult = "";
        return;
    }
}

// Created by sourabh to createAutoSave XML after modal poppup closed (With ref to task#452)
function PopUpCloseCallBackComplete() {
    var guardianName = "", guardianAddress = "", guardianPhone = "", guardianInformation = "", GuardianTypeText = "";
    // Changed by Jitender Kumar Kamboj on 16 August 2010 in ref task no. 890
    if (dialogResult != "") {
        if ($('CustomHRMAssessments', dialogResult).find('GuardianName').length > 0) {
            guardianName = $('CustomHRMAssessments', dialogResult).find('GuardianName').text();
            guardianInformation = guardianName + "\n";
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianName', guardianName);
        }
        else {
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianName', '');
        }
        // Changed by Jitender Kumar Kamboj on 16 August 2010 in ref task no. 890
        //if (GetXMLParentNodeByColumnValue(dialogResult).find("GuardianAddress").length > 0) {
        //guardianAddress = GetXMLParentNodeByColumnValue(dialogResult).find("GuardianAddress")[0].innerText;
        if ($('CustomHRMAssessments', dialogResult).find('GuardianAddress').length > 0) {
            guardianAddress = $('CustomHRMAssessments', dialogResult).find('GuardianAddress').text();
            guardianInformation = guardianInformation + guardianAddress + "\n";
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianAddress', guardianAddress);
        }
        else {
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianAddress', '');
        }
        // Changed by Jitender Kumar Kamboj on 16 August 2010 in ref task no. 890
        //if (GetXMLParentNodeByColumnValue(dialogResult).find("GuardianPhone").length > 0) {
        //guardianPhone = GetXMLParentNodeByColumnValue(dialogResult).find("GuardianPhone")[0].innerText;
        if ($('CustomHRMAssessments', dialogResult).find('GuardianPhone').length > 0) {
            guardianPhone = $('CustomHRMAssessments', dialogResult).find('GuardianPhone').text();
            guardianInformation = guardianInformation + guardianPhone + "\n";
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianPhone', guardianPhone);
        }
        else {
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianPhone', '');
        }
        //Code added with reference to #1014 for Guardian Type Text start
        if ($('CustomHRMAssessments', dialogResult).find('GuardianTypeText').length > 0) {
            GuardianTypeText = $('CustomHRMAssessments', dialogResult).find('GuardianTypeText').text();
            guardianInformation = guardianInformation + GuardianTypeText;
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianTypeText', GuardianTypeText);
        }
        else {
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianTypeText', '');
        }

        if ($('CustomHRMAssessments', dialogResult).find('GuardianType').length > 0) {
            GuardianType = $('CustomHRMAssessments', dialogResult).find('GuardianType').text();
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianType', GuardianType);
        }
        else {
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianType', '');
        }
        //Code added with reference to #1014 for Guardian Type Text start

        $('#TextArea_CustomHRMAssessments_GuardianAddressToDisplayOnly').val(guardianInformation);
    }
}
//end here






//Description:Function is used to Fill current client Values
//Author:Sandeep singh
//CreatedOn:07-April-2010

function callUncope() {
    //Below Code added By Rakesh 
    var SUAssessment_tab = tabobject.findTabByText('Substance Abuse');
    //    if (AssessmentTypeS != undefined && AssessmentTypeS.checked) {
    //        if (SUAssessment_tab != null) {
    //            ShowHideAssessmentHRMTab(SUAssessment_tab, false);
    //            $("#CheckBox_CustomHRMAssessments_UncopeCompleteFullSUAssessment").attr("disabled", true);
    //        }
    //    }
    //Changes end here
    if (Uncopeflag == 0) {
        $('#RadioButton_CustomHRMAssessments_UncopeApplicable_Y').attr("checked", false);
        $('#RadioButton_CustomHRMAssessments_UncopeApplicable_N').attr("checked", false);
        Uncopeflag == 1;
        var UncopeXml = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
        if (UncopeXml.length > 0) {
            var UncopeNode = UncopeXml[0].selectNodes("UncopeApplicable");
            if (UncopeNode.length > 0) {
                var Uncopetext = UncopeXml[0].selectNodes("UncopeApplicable")[0].text;
                if (Uncopetext == 'Y') {
                    $('#RadioButton_CustomHRMAssessments_UncopeApplicable_Y').attr("checked", true);
                    SetEnableDisableUncope('Y', AutoSaveXMLDom);
                    CreateInitializationImages(AutoSaveXMLDom);
                }
                else {
                    $('#RadioButton_CustomHRMAssessments_UncopeApplicable_N').attr("checked", true);
                    SetEnableDisableUncope('N', AutoSaveXMLDom);
                }
            }
        }

    }
}



function BindPsychosocialstepper() {
    try {
        //Changes by Mahesh with reference to ticket #478
        // $("span[class='ui-stepper']").stepper({ start: 0, min: 0, max: 10, step: 1 });
        $("span[class*='ui-stepper']").stepper({ start: 0, min: 0, max: 30, step: 10 });

    }
    catch (ex) {
        throw ex;
    }
}



function ClearReInitializeAssessment(ControlID) {
    if (ValidateClientDateOfBirth() == false) {
        $("#" + ControlID).attr("checked", false);
        CreateAutoSaveXml('CustomHRMAssessments', "AssessmentType", "");
        return false;
    }
    var action = "Clear";
    value = ShowMsgBox('Previous data will be cleared.', ConfirmationMessageCaption, MessageBoxButton.YesNo, MessageBoxIcon.Information, 'ConfirmMessageForCompleteDocumentOnOK(\'' + action + '\')', 'ConfirmMessageForCompleteDocumentOnCancel(\'' + ControlID + '\')');
}


//Modified On 21 May
// Modifeid By Vikas Monga 
//Purpose :Implement the coustom message box
function ConfirmMessageForCompleteDocumentOnCancel(ControlID) {
    try {
        var ControlObject = '';
        //Below If condition added by Rakesh w.rf to task 20 in Assessment Type 1
        if (previousAssessmentType != "" && previousAssessmentType != undefined) {
            ControlObject = $("#" + previousAssessmentType)
            $('#' + previousAssessmentType).attr("checked", true);
        }
        else {
            ControlObject = $("#" + ControlID)
        }
        SaveAutoSaveXMLDom(ControlObject[0]);
        //Added by Rakesh as in case of cancel po processing not hiding
        parent.HidePopupProcessing();
        return false;
    }
    catch (err) {//alert('Error occured in JS function ');}
        LogClientSideException(err, 'Documents');
    }


}

//Modified On 21 May
// Modifeid By Vikas Monga 
//Purpose :Implement the coustom message box
function ConfirmMessageForCompleteDocumentOnOK(action) {
    try {
        var _filterData = "UnsavedChangeId=" + UnsavedChangeId;
        var AssessmentScreenType;
        if ($("#RadioButton_CustomHRMAssessments_AssessmentType_I")[0].checked == true) {
            AssessmentScreenType = 'AssessmentScreenType=I';
        }
        else if ($("#RadioButton_CustomHRMAssessments_AssessmentType_U")[0].checked == true) {
            AssessmentScreenType = 'AssessmentScreenType=U';
        }
        else if ($("#RadioButton_CustomHRMAssessments_AssessmentType_A")[0].checked == true) {
            AssessmentScreenType = 'AssessmentScreenType=A';
        }
        //        else if ($("#RadioButton_CustomHRMAssessments_AssessmentType_S")[0].checked == true) {
        //            AssessmentScreenType = 'AssessmentScreenType=S';
        //        }
        else {
        }
        SetLableOnAssessmentDate();
        //Below Call Function SetPreviousAssessmentType() Added By Rakesh w.rf to task 20 in Assessment1
        SetPreviousAssessmentType();
        //Changes end here
        var documentRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("Documents");
        documentRowFilter = 'AuthorId';
        var docummentRowDomFilter = $(documentRowFilter, documentRow[0]);

        var _currentAuthorId = -1;
        if (docummentRowDomFilter.length > 0) {
            _currentAuthorId = documentRow[0].selectNodes("AuthorId")[0].text;
        }


        if (docummentRowDomFilterCheckBoxDom.length > 0) {
            var _currentAuthorId = documentRow[0].selectNodes("AuthorId")[0].text;

        }
        _filterData = _filterData + '^' + AssessmentScreenType + '^ReIntialization=Y' + '^CurrentAuthorId=' + _currentAuthorId;
        _reinitializeTabs = true;
        LoadDocument(GetCurrentScreenID(), 5763, _filterData, CurrentHistoryId, GetRelativePath(), pageActionEnum.New, null, false, globalCurrentScreenTabIndex);
        CreateInitializationImages(AutoSaveXMLDom);

        //      }
    }
    catch (err) {
        LogClientSideException(err, 'Documents');
    }


}
//Search a value in a array string.
findValueInArray = function(array, val) {
    var flag = false;
    $.each(array, function() {
        if (this == val) {
            flag = true;
        }
    });

    return flag;
}






//Description:Function is used to Call Slider windows
//Author:Sandeep singh
//CreatedOn:07-April-2010

function BindUIstepper1() {
    try {
        $("span[class='ui-stepper']").stepper({ start: 0, min: 0, max: 7, step: 1 });
    }
    catch (ex) {
        throw ex;
    }
}


//Description:hide and show controls.
//Author:Daman
//CreatedOn:04-May-2010

function hideTable() {
    if ($("#CheckBox_CustomHRMAssessments_PrePlanSeparateDocument").is(":checked")) {
        $("#mainTable").hide();

    }
    else {
        //CreateAutoSaveXml('CustomHRMAssessments', 'PrePlanSeparateDocument', 'N');
        $("#mainTable").show();
    }
}


function showGardianInfo() {

    $("#divGardianInfo").show();
}

//Description:Function is used to Initialize medication for PsychosocialChild and PsychosocialAdult
//Author: Daman
//CreatedOn:21-May-2010
function IntializeMedication(radioButton, textArea, divMedication, tableName, colomnName) {
    var colomnValue = GetColumnValueInXMLNodeByKeyValue(tableName, 'DocumentVersionId', DocumentVersionId, colomnName, AutoSaveXMLDom[0]);
    //  ($(radioButton).attr("checked", true));

    $(radioButton, $("#" + ParentUserControlName)).attr("checked", true);


    if (colomnValue == 'Y') {
        $(textArea, $("#" + ParentUserControlName)).attr("disabled", false);
    }
    else {
        $(textArea, $("#" + ParentUserControlName)).attr("disabled", true);
    }
    $(textArea, $("#" + ParentUserControlName)).show();
    $(textArea, $("#" + ParentUserControlName)).val('');
    $('#listMedication').hide();
    $('#tablecomments').show();
    SetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', DocumentVersionId, 'PsMedicationsComment', '', AutoSaveXMLDom[0]);
    $(divMedication, $("#" + ParentUserControlName)).show();
    //Code added by Loveena to call procedure on click of Initialize Medications
    var fnName = 'GetInitializeMedications';
    $.post(GetRelativePath() + "AjaxScript.aspx?functionName=" + fnName, function(result) { onSuccessIntializeMedication(result, textArea); }
       );
}
function AddToPHQ9Total() {
    var PHQ9Total = 0;
    $('select[PHQ9="PHQ9DD"]').each(function() {
        PHQ9Total = PHQ9Total + parseInt(($(this).find('option:selected').text().trim() != '' ? $(this).find('option:selected').text().trim().substr(0, 1) : 0));
    });
    $('td[PHQ9="PHQ9Total"]').html(PHQ9Total);
}
function onSuccessIntializeMedication(result, textArea) {
    //$(textArea).val(result);
    $(textArea, $("#" + ParentUserControlName)).val(result);
    CreateAutoSaveXml('CustomHRMAssessments', 'PsMedicationsComment', result);
}
//Description:Function is used to Initialize medication for PsychosocialChild and PsychosocialAdult
//Author: Daman
//CreatedOn:21-May-2010
function DisappearMedication(textArea, divMedication) {
    $(textArea, $("#" + ParentUserControlName)).removeAttr("disabled", true);
    $(textArea, $("#" + ParentUserControlName)).show();
    $(divMedication, $("#" + ParentUserControlName)).show();
    $('#listMedication').show();
    $('#tablecomments').hide();
}


//Description:Function is used to Initialize medication for PsychosocialChild and PsychosocialAdult
//Author: Daman
//CreatedOn:21-May-2010
function DisableMedication(textArea, divMedication) {
    $(textArea, $("#" + ParentUserControlName)).attr("disabled", true);
    $(textArea, $("#" + ParentUserControlName)).hide();
    $(divMedication, $("#" + ParentUserControlName)).hide();
    $('#listMedication', $("#" + ParentUserControlName)).hide();
    $('#tablecomments').hide();
}


//Description:Function is used to disable MedicationsList in PsychosocialChild and PsychosocialAdult
//Author: Daman
//CreatedOn:21th May 2010
function DisabledMedicationsList(radioButton, textArea) {
    if ($(radioButton, $("#" + ParentUserControlName)).is(":checked")) {
        $(textArea, $("#" + ParentUserControlName)).attr("disabled", true);
    }
    else {
        $(textArea, $("#" + ParentUserControlName)).removeAttr("disabled", true);
    }
}

//Description:Function is used to enable MedicationsList in PsychosocialChild and PsychosocialAdult
//Author: Daman
//CreatedOn:21th May 2010
function EnabledMedicationsList(radioButton, textArea) {
    if ($(radioButton, $("#" + ParentUserControlName)).is(":checked")) {
        $(textArea, $("#" + ParentUserControlName)).removeAttr("disabled", true);
    }
    else {
        $(textArea, $("#" + ParentUserControlName)).attr("disabled", true);
    }
}


//Description:Function is used to Fill current client Values
//Author:Sandeep singh
//CreatedOn:07-April-2010

function DivScaleMessageHide() {
    $('#DivScaleMessage').hide();
}


//Added by Daman on 4 May,2010

//DivFamilyHx

function FamilyHxDetails(DivFamilyHx, i, primaryKey, drugid, drugname, FamilyHistoty) {
    try {
        //Get ButtonId
        // Create structure  for text box
        var FamilyHxtable = "";
        var key = primaryKey;
        var DrudID = drugid;
        var DrugName = drugname;
        // Added by Vineet Tiwari Ref Task #178 Assessment: SU Assessment: family history text
        var txtValue = $('CustomSubstanceUseHistory2 SubstanceUseHistoryId[text=' + primaryKey + ']', AutoSaveXMLDom[0]).siblings('FamilyHistory').text();

        FamilyHxtable += "<table width='100%'>";
        FamilyHxtable += "<tr>";
        FamilyHxtable += "<td >";
        FamilyHxtable += "<table width='100%'>";
        FamilyHxtable += "<tr>";
        FamilyHxtable += "<td width='24%'>";
        FamilyHxtable += "</td>";
        FamilyHxtable += "<td width='15%'>";
        FamilyHxtable += "<span class='form_label'>Comment</span>";
        FamilyHxtable += "</td>";
        FamilyHxtable += "</tr>";
        FamilyHxtable += "</table>";
        FamilyHxtable += "</td>";
        FamilyHxtable += "<td width='61%'>";
        FamilyHxtable += "<textarea ParentChildControls='True' BindAutoSaveEvents='False' id='TextArea_CustomSubstanceUseHistory2_FamilyHistory_" + i + "' name='TextArea_CustomSubstanceUseHistory2_FamilyHistory_" + i + "' spellcheck='True'  datatype='String'";
        // Modfied by Vineet Tiwari Ref Task #178 Assessment: SU Assessment: family history text
        //FamilyHxtable += "rows='4' cols='1' style='width: 412px' onchange=\"javascript:GetFamilyHistoryText(this ," + key + " ," + DrudID + " ,'" + DrugName + "');\" >" + FamilyHistoty + "</textarea> ";
        FamilyHxtable += "rows='4' cols='1' style='width: 412px' onchange=\"javascript:GetFamilyHistoryText(this ," + key + " ," + DrudID + " ,'" + DrugName + "');\" >" + txtValue + "</textarea> ";
        FamilyHxtable += "</td>";
        FamilyHxtable += "</tr>";
        FamilyHxtable += "</table>";
        $("#DivFamilyHx_" + i).html(FamilyHxtable);
    }
    catch (ex) {
        throw ex;
    }
}

function GetFamilyHistoryText(FamilyHistory, primaryKey, drugid, drugname) {
    var key = primaryKey;
    var DrudID = drugid;
    var DrugName = drugname;
    var FamilyText;

    try {
        if (FamilyHistory.outerText == undefined) {
            FamilyText = $("#" + FamilyHistory).val();
        }
        else {
            //Modified by vamsi Ref task # 108 Allegan 3.5 Implementation
            FamilyText = FamilyHistory.value;
        }

        //       if (FamilyText == "") { // Commented if else condtion by Jitender on Dec 16, 2010 in ref task #782 in streamline testing project
        //            return;
        //        }
        //else {
        SetValues('CustomSubstanceUseHistory2', 'FamilyHistory', 'SubstanceUseHistoryId', key, FamilyText, DrudID, DrugName);
        //}


    }
    catch (ex) {
        throw ex;
    }


}

//Added by Daman on 10 May,2010

function GetDrugsDescrption(val) {
    var div = $("#divDrugDescPopUp");
    div[0].style.position = "absolute";
    div[0].style.left = 200; //250
    div[0].style.top = 170;

    $("#divDrugDescPopUp").show();
    $("#SpnDescprition").html(val);
}



//Added by Daman on 10 May,2010
//To Show Help PopUp on Click of RAPQuestion Help
//function GetRAPQuesText(sender, height, width) {
//    var helpMessageText = $(sender).parents("td:first").find("textarea").val();
//    ShowMsgBox(helpMessageText, 'Help', MessageBoxButton.OK, MessageBoxIcon.Information, undefined, undefined, undefined, height, width);
//}

//Added by Daman on 10 May,2010
//To Hide Help PopUp on Click  of RAPQuestion Help
//function DivMoveHide1() {
//    $('#divRAPHelpTextPopUp').hide();
//}

//Added by Daman on 4 May,2010
//Set values for Dom Manipulation in SubstanceUseHistory
function SetValues(tableName, columnName, primaryKey, pkkeyValue, changeVal, drugid, drugname) {
    substanceUseHistory = true;
    var changeValue;
    AddToUnsavedTables(tableName);
    if (changeVal.checked == true || changeVal == true && columnName == 'InitiallyPrescribed') {
        changeValue = changeVal.checked;
        changeValue = 'Y';
    }
    else if (changeVal.checked == false || changeVal == false && columnName == 'InitiallyPrescribed') {
        changeValue = 'N';
    }
    //Added with reference to ticket # 704 start
    else if ((columnName == 'AgeOfFirstUse' || columnName == 'Preference') && changeVal == '') {
        var xmlGetTable = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomSubstanceUseHistory2");
        if (xmlGetTable.length > 0 && GetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, AutoSaveXMLDom[0]) != null) {
            var GetColomnvalue = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, AutoSaveXMLDom[0]);
            if (GetColomnvalue != '') {
                changeValue = changeVal;
            }
            else {
                return false;
            }
        }
        else {
            return false;
        }
    }
    //Added with reference to ticket # 704 end
    else {
        changeValue = changeVal;
    }
    //for new mode
    if (pkkeyValue <= 0) {


        // start set value for FK
        if (DocumentVersionId > 0) {
            fk = DocumentVersionId;
        }
        else {
            // set  DocumentVersionId
            fk = DocumentVersionId
        }
        // end set value for FK  


        //Check nodexml with tablename and primary key
        var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, AutoSaveXMLDom[0]);
        //  var _xmlDom = GetXMLParentNodeByColumnValue(tableName, columnName, changeValue, AutoSaveXMLDom[0])


        if (_xmlDom.length == 0) {

            //create table if not exist in xml
            //CreateAutoSaveXml(tableName, columnName, changeValue);
            var _currentNode = "";
            if (AutoSaveXMLDom[0].childNodes[0].selectSingleNode(tableName) == null) {
                AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)); //Add table in the XML Dom

                //Append column key with value
                _currentNode = AutoSaveXMLDom[0].childNodes[0].selectSingleNode(tableName).appendChild(AutoSaveXMLDom[0].createElement(columnName));


                var columnObject = $(columnName, _currentNode);
                //Handle Null value
                if (changeValue == "") {
                    //datasetXMLDom.childNodes[0].selectSingleNode(tableName).selectSingleNode(columnName).setAttribute("xsi:nil", 'true');
                    columnObject.attr("xsi:nil", 'true');
                }


                _currentNode.text = changeValue;

                //Append PK and FK with values
                _xmlDom = GetXMLParentNodeByTable(tableName, AutoSaveXMLDom[0]);
                if (_xmlDom[0].selectSingleNode('SubstanceUseHistoryId') == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement('SubstanceUseHistoryId'));

                    var nodepk = _xmlDom[0].selectSingleNode('SubstanceUseHistoryId');
                    nodepk.text = pkkeyValue;

                }
                //Set value for DocumentVersionId and append
                if (_xmlDom[0].selectSingleNode('DocumentVersionId') == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId'));

                    var nodefk = _xmlDom[0].selectSingleNode('DocumentVersionId');
                    nodefk.text = fk;

                }

                //append drugid
                if (_xmlDom[0].selectSingleNode('SUDrugId') == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement('SUDrugId'));

                    var nodedrugid = _xmlDom[0].selectSingleNode('SUDrugId');
                    nodedrugid.text = drugid;
                }
                //append drug name
                if (_xmlDom[0].selectSingleNode('DrugName') == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement('DrugName'));

                    var nodedrugname = _xmlDom[0].selectSingleNode('DrugName');
                    nodedrugname.text = drugname;
                }

            }

            else {
                //If table already exist in xml
                //Create other parent node with this table

                //Check column name in this xml
                _xmlDom = GetXMLParentNodeByColumnValue(tableName, primaryKey, pkkeyValue, AutoSaveXMLDom[0]);
                if (_xmlDom != null) {
                    if (_xmlDom.length > 0) {
                        if (_xmlDom[0].selectSingleNode(columnName) == null) {
                            _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement(columnName));
                            var nodecol = _xmlDom[0].selectSingleNode(columnName);

                            var columnObject = $(columnName, _xmlDom);
                            //Handle Null value
                            if (changeValue == "") {
                                //datasetXMLDom.childNodes[0].selectSingleNode(tableName).selectSingleNode(columnName).setAttribute("xsi:nil", 'true');
                                columnObject.attr("xsi:nil", 'true');
                            }

                            nodecol.text = changeValue;


                        }
                        else {
                            var nodecol = _xmlDom[0].selectSingleNode(columnName);

                            var columnObject = $(columnName, _xmlDom);
                            //Handle Null value
                            if (changeValue == "") {
                                //datasetXMLDom.childNodes[0].selectSingleNode(tableName).selectSingleNode(columnName).setAttribute("xsi:nil", 'true');
                                columnObject.attr("xsi:nil", 'true');
                            }

                            nodecol.text = changeValue;
                        }
                    }


                    else {


                        var i = 0;
                        var _currentxml = "";

                        _xmlDom = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)).xml; //Add table in the XML Dom

                        _xmlDom = GetXMLParentNodeByTable(tableName, AutoSaveXMLDom[0]);
                        for (i = 0; i < _xmlDom.length; i++) {

                            _currentxml = GetXMLParentNodeByColname(primaryKey, _xmlDom[i]);
                            if (_currentxml.length == 0) {

                                //append primary key
                                if (_xmlDom[i].selectSingleNode('SubstanceUseHistoryId') == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement('SubstanceUseHistoryId'));
                                    var nodepk = _xmlDom[i].selectSingleNode('SubstanceUseHistoryId');
                                    nodepk.text = pkkeyValue;
                                }


                                //Set value for (FK) DocumentVersionId and append
                                if (_xmlDom[i].selectSingleNode('DocumentVersionId') == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId'));

                                    var nodefk = _xmlDom[i].selectSingleNode('DocumentVersionId');
                                    nodefk.text = fk;

                                }

                                //append drugid
                                if (_xmlDom[i].selectSingleNode('SUDrugId') == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement('SUDrugId'));

                                    var nodedrugid = _xmlDom[i].selectSingleNode('SUDrugId');
                                    nodedrugid.text = drugid;
                                }
                                //append drug name
                                if (_xmlDom[i].selectSingleNode('DrugName') == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement('DrugName'));

                                    var nodedrugname = _xmlDom[i].selectSingleNode('DrugName');
                                    nodedrugname.text = drugname;
                                }

                                //append selected column
                                if (_xmlDom[i].selectSingleNode(columnName) == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement(columnName));
                                    var nodeselected = _xmlDom[i].selectSingleNode(columnName);
                                    var columnObject = $(columnName, _xmlDom);
                                    //Handle Null value
                                    if (changeValue == "") {
                                        //datasetXMLDom.childNodes[0].selectSingleNode(tableName).selectSingleNode(columnName).setAttribute("xsi:nil", 'true');
                                        columnObject.attr("xsi:nil", 'true');
                                    }

                                    nodeselected.text = changeValue;

                                }
                                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, changeValue, AutoSaveXMLDom[0], 'Y');

                            }

                        }
                    }
                }
            }
        }
        else {
            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, changeValue, AutoSaveXMLDom[0], 'Y');

        }
    }

    else {

        CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, changeValue, AutoSaveXMLDom[0], 'Y');

    }
    AddToUnsavedTables(tableName);
}

///get xml by table name

function GetXMLParentNodeByTable(tableName, xmlDom) {

    var expression = tableName;
    return $(expression, xmlDom);
}

///get xml by Column name






//Added by Daman on 7 May,2010
//To show Help Detail for RAP Questions

//function ShowHelpText(Id, RAPQuestionText) {
//    $('#DivOpenURL').html(RAPQuestionText);
//}



//To close Drug description div
function CloseDrugsDescDiv() {
    $("#divDrugDescPopUp").hide();
}


//Added by Daman on  12 May,2010
//Set values for Dom Manipulation [RecordDeleted] in SubstanceUseHistory
function SetValuesforRecordDeleted(tableName, columnName, primaryKey, pkkeyValue, changeVal, sudrugid, drugname) {
    var Count = 0;
    var fk = 0;
    substanceUseHistory = true;

    var drugid = sudrugid;

    //start Set value for RecordDeleted
    //Modified By Rakesh 15 Sep 2011
    //Rakesh(ref task# 236 SC webPhaseII bugs/Features)
    if (changeVal.checked == false) {

        var val_string = (sudrugid - 1);
        var control_val = '';

        var _val = '';
        _val = $("[id$=TextBox_CustomSubstanceUseHistory2_AgeOfFirstUse_" + val_string + "]").val();
        if (_val != undefined)
            control_val = control_val + _val;

        _val = $("[id$=DropDownList_CustomSubstanceUseHistory2_Frequency_" + val_string + "]").val();
        if (_val != undefined)
            control_val = control_val + _val;

        _val = $("[id$=DropDownList_CustomSubstanceUseHistory2_Route_" + val_string + "]").val();
        if (_val != undefined)
            control_val = control_val + _val;

        _val = $("[id$=TextBox_CustomSubstanceUseHistory2_LastUsed_" + val_string + "]").val();
        if (_val != undefined)
            control_val = control_val + _val;

        _val = $("[id$=CheckBox_CustomSubstanceUseHistory2_InitiallyPrescribed_" + val_string + "_N]").val();
        if (_val != undefined)
            control_val = control_val + _val;

        _val = $("[id$=TextBox_CustomSubstanceUseHistory2_Preference_" + val_string + "]").val();
        if (_val != undefined)
            control_val = control_val + _val;

        _val = $("[id$=TextArea_CustomSubstanceUseHistory2_FamilyHistory_" + val_string + "]").val();
        if (_val != undefined)
            control_val = control_val + _val;


        //start Set value for RecordDeleted
        if (control_val == '')
            changeValue = "Y";
        else
        //Modified by vamsi Ref task # 108 Allegan 3.5 Implementation
            changeValue = "Y";
    }
    else if (changeVal.checked == true) {
        changeValue = "N";
    }
    //end Set value for RecordDeleted
    //End Modified By Rakesh 15 Sep 2011
    //end Set value for RecordDeleted


    //Check value of PrimaryKey If PK exists
    if (pkkeyValue > 0) {

        //Update existing node with value
        CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, changeValue, AutoSaveXMLDom[0], 'Y');

    }

    //If PK dosnt exist
    else {

        // start set value for FK      
        if (DocumentVersionId > 0) {
            fk = DocumentVersionId;
        }
        else {
            // set  DocumentVersionId
            fk = DocumentVersionId
        }
        // end set value for FK   

        //Check nodexml with tablename and primary key
        var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, AutoSaveXMLDom[0]);
        //  var _xmlDom = GetXMLParentNodeByColumnValue(tableName, columnName, changeValue, AutoSaveXMLDom[0])


        if (_xmlDom.length == 0) {

            //create table if not exist in xml
            //CreateAutoSaveXml(tableName, columnName, changeValue);
            var _currentNode = "";
            if (AutoSaveXMLDom[0].childNodes[0].selectSingleNode(tableName) == null) {
                AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)); //Add table in the XML Dom

                //Append column key with value
                _currentNode = AutoSaveXMLDom[0].childNodes[0].selectSingleNode(tableName).appendChild(AutoSaveXMLDom[0].createElement(columnName));
                _currentNode.text = changeValue;

                //Append PK and FK with values
                _xmlDom = GetXMLParentNodeByTable(tableName, AutoSaveXMLDom[0]);
                if (_xmlDom[0].selectSingleNode('SubstanceUseHistoryId') == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement('SubstanceUseHistoryId'));

                    var nodepk = _xmlDom[0].selectSingleNode('SubstanceUseHistoryId');
                    nodepk.text = pkkeyValue;

                }
                //Set value for DocumentVersionId and append
                if (_xmlDom[0].selectSingleNode('DocumentVersionId') == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId'));

                    var nodefk = _xmlDom[0].selectSingleNode('DocumentVersionId');
                    nodefk.text = fk;

                }

                //append drugid
                if (_xmlDom[0].selectSingleNode('SUDrugId') == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement('SUDrugId'));

                    var nodedrugid = _xmlDom[0].selectSingleNode('SUDrugId');
                    nodedrugid.text = drugid;
                }
                //append drug name
                if (_xmlDom[0].selectSingleNode('DrugName') == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement('DrugName'));

                    var nodedrugname = _xmlDom[0].selectSingleNode('DrugName');
                    nodedrugname.text = drugname;
                }

            }
            else {

                //Check column name in this xml
                _xmlDom = GetXMLParentNodeByColumnValue(tableName, primaryKey, pkkeyValue, AutoSaveXMLDom[0]);
                if (_xmlDom != null) {
                    if (_xmlDom.length > 0) {
                        if (_xmlDom[0].selectSingleNode(columnName) == null) {
                            _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement(columnName));
                            var nodecol = _xmlDom[0].selectSingleNode(columnName);
                            nodecol.text = changeValue;


                        }
                    }


                    else {

                        //If table already exist in xml
                        //Create other parent node with this table

                        var i = 0;
                        var _currentxml = "";

                        _xmlDom = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)).xml; //Add table in the XML Dom

                        _xmlDom = GetXMLParentNodeByTable(tableName, AutoSaveXMLDom[0]);
                        for (i = 0; i < _xmlDom.length; i++) {

                            _currentxml = GetXMLParentNodeByColname(primaryKey, _xmlDom[i]);
                            //append selected column

                            if (_currentxml.length == 0) {

                                //append primary key
                                if (_xmlDom[i].selectSingleNode('SubstanceUseHistoryId') == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement('SubstanceUseHistoryId'));
                                    var nodepk = _xmlDom[i].selectSingleNode('SubstanceUseHistoryId');
                                    nodepk.text = pkkeyValue;
                                }


                                //Set value for (FK) DocumentVersionId and append
                                if (_xmlDom[i].selectSingleNode('DocumentVersionId') == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId'));

                                    var nodefk = _xmlDom[i].selectSingleNode('DocumentVersionId');
                                    nodefk.text = fk;

                                }

                                //append drugid
                                if (_xmlDom[i].selectSingleNode('SUDrugId') == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement('SUDrugId'));

                                    var nodedrugid = _xmlDom[i].selectSingleNode('SUDrugId');
                                    nodedrugid.text = drugid;
                                }
                                //append selected column
                                if (_xmlDom[i].selectSingleNode(columnName) == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement(columnName));

                                    var nodeselected = _xmlDom[i].selectSingleNode(columnName);
                                    nodeselected.text = changeValue;

                                }
                                //append drug name
                                if (_xmlDom[i].selectSingleNode('DrugName') == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement('DrugName'));

                                    var nodedrugname = _xmlDom[i].selectSingleNode('DrugName');
                                    nodedrugname.text = drugname;
                                }
                            }

                        }
                    }
                }


            }

        }
        //Update esiting row
        else {
            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, changeValue, AutoSaveXMLDom[0], 'Y');

        }


    }
    substanceUseHistory = true;
    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, changeValue, AutoSaveXMLDom[0], 'Y');
    AddToUnsavedTables(tableName);

}


//Description:Function is used enable treatmentSection in Summary
//Author:Daman
//CreatedOn:17thMay 2010


function EnableTreatmentSection() {
    if ($("#RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment_N").is(":checked")) {

        ($("#TableClientTreatment").removeAttr("disabled"));
        // Changes by Mahesh with reference to Ticket #466 start
        //($("#TextArea_CustomHRMAssessments_TreatmentNarrative").attr("disabled", true));
        ($("#TextArea_CustomHRMAssessments_TreatmentNarrative").removeAttr("disabled"));
        // Changes by Mahesh with reference to Ticket #466 end

    }

}
function EnableSummaryTreatmentComment() {

    if ($("#RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided_Y").is(":checked")) {
        ($("#TextArea_CustomHRMAssessments_TreatmentNarrative").removeAttr("disabled"));

    }
}
function DisableSummaryTreatmentComment() {

    if ($("#RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided_N").is(":checked")) {
        ($("#TextArea_CustomHRMAssessments_TreatmentNarrative").attr("disabled", true));

    }
}

//Description:Function is used disable treatmentSection in Summary
//Author:Daman
//CreatedOn:17thMay 2010

function DisableTreatmentSection(dom) {
    // Code for AutoSaveXMLODM
    if (dom != null && dom != '') {
        if (dom[0].childNodes[0].selectNodes("CustomHRMAssessments").length > 0) {
            SavetabControl = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
            if (SavetabControl[0].selectSingleNode('ClientIsAppropriateForTreatment') != null) {
                if (SavetabControl[0].selectSingleNode('ClientIsAppropriateForTreatment').text == 'Y') {
                    $("#RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment_Y").attr("checked", true);
                }
            }
        }
    }

    if ($("#RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment_Y").is(":checked")) {
        $("#TableClientTreatment").attr("disabled", "disabled");
        // Changes by Mahesh with reference to Ticket #466 start
        // $("#TextArea_CustomHRMAssessments_TreatmentNarrative").removeAttr("disabled", false);
        $("#TextArea_CustomHRMAssessments_TreatmentNarrative").attr("disabled", true);
        // Changes by Mahesh with reference to Ticket #466 end
        $("#RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided_Y").attr("checked", false);
        $("#RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided_N").attr("checked", false);
        UpdateAutoSaveXmlNode("CustomHRMAssessments", "SecondOpinionNoticeProvided", '');
    }
}

function SetValuesSuicidality(HRMNeedid) {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomHRMAssessments_SuicideNeedsList").is(":checked") && $("#CheckBox_CustomHRMAssessments_SuicideCurrent").is(":checked") == true) {

        var Identation = $("#Label_CustomHRMAssessments_SuicideIdeation")[0].innerText;
        var Active = $("#Label_CustomHRMAssessments_SuicideActive")[0].innerText;
        var Passive = $("#Label_CustomHRMAssessments_SuicidePassive")[0].innerText;
        var Means = $("#Label_CustomHRMAssessments_SuicideMeans")[0].innerText;
        var Plans = $("#Label_CustomHRMAssessments_SuicidePlan")[0].innerText;

        var NeedName = "Suicidality";
        if ($("#CheckBox_CustomHRMAssessments_SuicideIdeation").is(":checked")) {

            CheckboxlistDesc = Identation;

        }

        if ($("#CheckBox_CustomHRMAssessments_SuicideActive").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + Active;
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + Active;
            }


        }
        if ($("#CheckBox_CustomHRMAssessments_SuicidePassive").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + Passive;
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + Passive;
            }

        }
        if ($("#CheckBox_CustomHRMAssessments_SuicideMeans").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + Means;
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + Means;
            }



        }
        if ($("#CheckBox_CustomHRMAssessments_SuicidePlan").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + Plans;
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + Plans;
            }
        }

    }
    if ($("#CheckBox_CustomHRMAssessments_SuicideNeedsList").is(":checked") && $("#CheckBox_CustomHRMAssessments_SuicidePriorAttempt").is(":checked") && $("#CheckBox_CustomHRMAssessments_SuicideCurrent").is(":checked") == false) {

        CheckboxlistDesc = $("#TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory").val().trim();
    }
    if ($("#CheckBox_CustomHRMAssessments_SuicideNeedsList").is(":checked") && $("#CheckBox_CustomHRMAssessments_SuicidePriorAttempt").is(":checked") == false && $("#CheckBox_CustomHRMAssessments_SuicideCurrent").is(":checked") == false) {

        CheckboxlistDesc = $("#TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory").val().trim();
    }

    return CheckboxlistDesc;
}

function SetValuesHomicidality(HRMNeedid) {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomHRMAssessments_HomicideNeedsList").is(":checked")) {


        //var Identation = $("#Label_CustomHRMAssessments_HomicideIdeation")[0].innerText;
        //var Active = $("#Label_CustomHRMAssessments_HomicideActive")[0].innerText;
        //var Passive = $("#Label_CustomHRMAssessments_HomicidePassive")[0].innerText;
        //var Means = $("#Label_CustomHRMAssessments_HomicideMeans")[0].innerText;
        //var Plans = $("#Label_CustomHRMAssessments_HomicidePlan")[0].innerText;

        var NeedName = "Homicidality";
        //if ($("#CheckBox_CustomHRMAssessments_HomicideIdeation").is(":checked")) {

        //    CheckboxlistDesc = Identation;

        //}

        //if ($("#CheckBox_CustomHRMAssessments_HomicideActive").is(":checked")) {
        //    if (CheckboxlistDesc != "") {
        //        CheckboxlistDesc = CheckboxlistDesc + "," + Active;
        //    }
        //    else {
        //        CheckboxlistDesc = CheckboxlistDesc + Active;
        //    }


        //}
        //if ($("#CheckBox_CustomHRMAssessments_HomicidePassive").is(":checked")) {

        //    if (CheckboxlistDesc != "") {
        //        CheckboxlistDesc = CheckboxlistDesc + "," + Passive;
        //    }
        //    else {
        //        CheckboxlistDesc = CheckboxlistDesc + Passive;
        //    }

        //}
        //if ($("#Checkbox_CustomHRMAssessments_HomicideMeans").is(":checked")) {

        //    if (CheckboxlistDesc != "") {
        //        CheckboxlistDesc = CheckboxlistDesc + "," + Means;
        //    }
        //    else {
        //        CheckboxlistDesc = CheckboxlistDesc + Means;
        //    }

        //}
        //if ($("#CheckBox_CustomHRMAssessments_HomicidePlan").is(":checked")) {
        //    if (CheckboxlistDesc != "") {
        //        CheckboxlistDesc = CheckboxlistDesc + "," + Plans;
        //    }
        //    else {
        //        CheckboxlistDesc = CheckboxlistDesc + Plans;
        //    }


        //}
        //SetValuesNeedList("CustomHRMAssessmentNeeds", "HRMAssessmentNeedId", "DocumentVersionId", -3, -1, "NeedName:NeedDescription:HRMNeedid", NeedName + ':' + CheckboxlistDesc + ':' + HRMNeedid, 0);
    }
    if ($("#CheckBox_CustomHRMAssessments_HomicideNeedsList").is(":checked") && $("#CheckBox_CustomHRMAssessments_HomicidePriorAttempt").is(":checked")) {

        CheckboxlistDesc = $("#TextArea_CustomHRMAssessments_HomicideBehaviorsPastHistory").val().trim();
    }
    if ($("#CheckBox_CustomHRMAssessments_HomicideNeedsList").is(":checked") && $("#CheckBox_CustomHRMAssessments_HomicidePriorAttempt").is(":checked") == false) {

        CheckboxlistDesc = $("#TextArea_CustomHRMAssessments_HomicideBehaviorsPastHistory").val().trim();
    }
    return CheckboxlistDesc;
}


function setValuesMentalStatusAppererance() {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_AppearanceAddToNeedsList").is(":checked")) {
        if ($("#CheckBox_CustomMentalStatuses2_AppearanceNeatClean").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_AppearanceNeatClean").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_AppearancePoorHygiene").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearancePoorHygiene").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearancePoorHygiene").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_AppearanceWellGroomed").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceWellGroomed").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceWellGroomed").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_AppearanceAppropriatelyDressed").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceAppropriatelyDressed").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceAppropriatelyDressed").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_AppearanceYoungerThanStatedAge").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceYoungerThanStatedAge").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceYoungerThanStatedAge").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_AppearanceOlderThanStatedAge").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceOlderThanStatedAge").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceOlderThanStatedAge").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_AppearanceOverweight").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceOverweight").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceOverweight").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_AppearanceUnderweight").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceUnderweight").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceUnderweight").parents("tr:first").find("label").html();
            }


        }
        if ($("#CheckBox_CustomMentalStatuses2_AppearanceEccentric").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceEccentric").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceEccentric").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_AppearanceSeductive").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceSeductive").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceSeductive").parents("tr:first").find("label").html();
            }


        }


        if ($("#CheckBox_CustomMentalStatuses2_AppearanceUnkemptDisheveled").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceUnkemptDisheveled").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceUnkemptDisheveled").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_AppearanceOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AppearanceOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AppearanceOther").parents("tr:first").find("label").html();
            }


        }
    }

    return CheckboxlistDesc;
}


function setValuesMentalStatusIntellActual() {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_IntellectualAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_IntellectualAboveAverage").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_IntellectualAboveAverage").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_IntellectualAverage").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_IntellectualAverage").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_IntellectualAverage").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_IntellectualBelowAverage").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_IntellectualBelowAverage").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_IntellectualBelowAverage").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_IntellectualPossibleMR").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_IntellectualPossibleMR").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_IntellectualPossibleMR").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_IntellectualDocumentedMR").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_IntellectualDocumentedMR").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_IntellectualDocumentedMR").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_IntellectualOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_IntellectualOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_IntellectualOther").parents("tr:first").find("label").html();
            }


        }
    }

    return CheckboxlistDesc;
}


function setValuesMentalStatusCommunication() {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_CommunicationAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_CommunicationNormal").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_CommunicationNormal").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_CommunicationUsesSignLanguage").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_CommunicationUsesSignLanguage").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_CommunicationUsesSignLanguage").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_CommunicationUnableToRead").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_CommunicationUnableToRead").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_CommunicationUnableToRead").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_CommunicationNeedForBraille").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_CommunicationNeedForBraille").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_CommunicationNeedForBraille").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_CommunicationHearingImpaired").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_CommunicationHearingImpaired").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_CommunicationHearingImpaired").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_CommunicationDoesLipReading").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_CommunicationDoesLipReading").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_CommunicationDoesLipReading").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_CommunicationEnglishIsSecondLanguage").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_CommunicationEnglishIsSecondLanguage").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_CommunicationEnglishIsSecondLanguage").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_CommunicationTranslatorNeeded").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_CommunicationTranslatorNeeded").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_CommunicationTranslatorNeeded").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_CommunicationOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_CommunicationOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_CommunicationOther").parents("tr:first").find("label").html();
            }


        }

    }

    return CheckboxlistDesc;
}


function setValuesMentalStatusMood() {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_MoodAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_MoodUnremarkable").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_MoodUnremarkable").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodCooperative").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodCooperative").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodCooperative").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodAnxious").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodAnxious").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodAnxious").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_MoodTearful").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodTearful").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodTearful").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodCalm").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodCalm").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodCalm").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodLabile").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodLabile").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodLabile").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodPessimistic").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodPessimistic").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodPessimistic").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodCheerful").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodCheerful").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodCheerful").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodGuilty").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodGuilty").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodGuilty").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodEuphoric").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodEuphoric").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodEuphoric").parents("tr:first").find("label").html();
            }


        }


        if ($("#CheckBox_CustomMentalStatuses2_MoodDepressed").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodDepressed").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodDepressed").parents("tr:first").find("label").html();
            }


        }


        if ($("#CheckBox_CustomMentalStatuses2_MoodHostile").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodHostile").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodHostile").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodIrritable").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodIrritable").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodIrritable").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodDramatized").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodDramatized").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodDramatized").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodFearful").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodFearful").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodFearful").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodSupicious").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodSupicious").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodSupicious").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MoodOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MoodOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MoodOther").parents("tr:first").find("label").html();
            }


        }
    }

    return CheckboxlistDesc;
}


function SetValueMentalStatusAffect() {

    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_AffectAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_AffectPrimarilyAppropriate").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_AffectPrimarilyAppropriate").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_AffectRestricted").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AffectRestricted").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AffectRestricted").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_AffectBlunted").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AffectBlunted").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AffectBlunted").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_AffectFlattened").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AffectFlattened").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AffectFlattened").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_AffectDetached").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AffectDetached").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AffectDetached").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_AffectPrimarilyInappropriate").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AffectPrimarilyInappropriate").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AffectPrimarilyInappropriate").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_AffectOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_AffectOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_AffectOther").parents("tr:first").find("label").html();
            }


        }
    }

    return CheckboxlistDesc;
}


function SetValueMentalStatusSpeech() {

    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_SpeechAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_SpeechNormal").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_SpeechNormal").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_SpeechLogicalCoherent").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_SpeechLogicalCoherent").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_SpeechLogicalCoherent").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_SpeechTangential").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_SpeechTangential").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_SpeechTangential").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_SpeechSparseSlow").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_SpeechSparseSlow").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_SpeechSparseSlow").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_SpeechRapidPressured").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_SpeechRapidPressured").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_SpeechRapidPressured").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_SpeechSoft").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_SpeechSoft").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_SpeechSoft").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_SpeechCircumstantial").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_SpeechCircumstantial").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_SpeechCircumstantial").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_SpeechLoud").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_SpeechLoud").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_SpeechLoud").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_SpeechRambling").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_SpeechRambling").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_SpeechRambling").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_SpeechOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_SpeechOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_SpeechOther").parents("tr:first").find("label").html();
            }


        }
    }

    return CheckboxlistDesc;
}

function SetValueMentalStatusThought() {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_ThoughtAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtUnremarkable").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_ThoughtUnremarkable").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtParanoid").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtParanoid").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtParanoid").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtGrandiose").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtGrandiose").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtGrandiose").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_ThoughtObsessive").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtObsessive").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtObsessive").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtBizarre").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtBizarre").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtBizarre").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtFlightOfIdeas").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtFlightOfIdeas").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtFlightOfIdeas").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtDisorganized").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtDisorganized").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtDisorganized").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtAuditoryHallucinations").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtAuditoryHallucinations").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtAuditoryHallucinations").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtVisualHallucinations").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtVisualHallucinations").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtVisualHallucinations").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtTactileHallucinations").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtTactileHallucinations").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtTactileHallucinations").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_ThoughtOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_ThoughtOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_ThoughtOther").parents("tr:first").find("label").html();
            }


        }

    }

    return CheckboxlistDesc;
}


function SetValueMentalStatusBehavior() {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_BehaviorAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorNormal").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_BehaviorNormal").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorRestless").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorRestless").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorRestless").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorPoorEyeContact").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorPoorEyeContact").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorPoorEyeContact").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_BehaviorAgitated").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorAgitated").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorAgitated").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorPeculiar").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorPeculiar").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorPeculiar").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorSelfDestructive").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorSelfDestructive").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorSelfDestructive").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorSlowed").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorSlowed").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorSlowed").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorDestructiveToOthers").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorDestructiveToOthers").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorDestructiveToOthers").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorCompulsive").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorCompulsive").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorCompulsive").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorTremors").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorTremors").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorTremors").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_BehaviorOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_BehaviorOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_BehaviorOther").parents("tr:first").find("label").html();
            }


        }

    }

    return CheckboxlistDesc;
}


function SetValueMentalStatusOrientation() {

    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_OrientationAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_OrientationToPersonPlaceTime").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_OrientationToPersonPlaceTime").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_OrientationNotToPerson").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_OrientationNotToPerson").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_OrientationNotToPerson").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_OrientationNotToPlace").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_OrientationNotToPlace").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_OrientationNotToPlace").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_OrientationNotToTime").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_OrientationNotToTime").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_OrientationNotToTime").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_OrientationOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_OrientationOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_OrientationOther").parents("tr:first").find("label").html();
            }


        }

    }

    return CheckboxlistDesc;
}

function SetValueMentalStatusInsight() {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_InsightAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_InsightGood").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_InsightGood").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_InsightFair").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_InsightFair").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_InsightFair").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_InsightPoor").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_InsightPoor").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_InsightPoor").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_InsightLacking").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_InsightLacking").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_InsightLacking").parents("tr:first").find("label").html();
            }



        }

        if ($("#CheckBox_CustomMentalStatuses2_InsightOther").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_InsightOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_InsightOther").parents("tr:first").find("label").html();
            }


        }

        //SetValuesNeedList("CustomHRMAssessmentNeeds", "HRMAssessmentNeedId", "DocumentVersionId", -3, -1, "NeedName:NeedDescription:HRMNeedid", NeedName + ':' + CheckboxlistDesc + ':' + HRMNeedid, 0);
    }

    return CheckboxlistDesc;
}


function SetValueMentalStatusMemory() {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_MemoryAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_MemoryGoodNormal").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_MemoryGoodNormal").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_MemoryImpairedShortTerm").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MemoryImpairedShortTerm").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MemoryImpairedShortTerm").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_MemoryImpairedLongTerm").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MemoryImpairedLongTerm").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MemoryImpairedLongTerm").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_MemoryOther").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_MemoryOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_MemoryOther").parents("tr:first").find("label").html();
            }



        }

        //SetValuesNeedList("CustomHRMAssessmentNeeds", "HRMAssessmentNeedId", "DocumentVersionId", -3, -1, "NeedName:NeedDescription:HRMNeedid", NeedName + ':' + CheckboxlistDesc + ':' + HRMNeedid, 0);
    }

    return CheckboxlistDesc;
}


function SetValueMentalStatusReality() {
    var CheckboxlistDesc = "";
    if ($("#CheckBox_CustomMentalStatuses2_RealityOrientationAddToNeedsList").is(":checked")) {

        if ($("#CheckBox_CustomMentalStatuses2_RealityOrientationIntact").is(":checked")) {
            CheckboxlistDesc = $("#CheckBox_CustomMentalStatuses2_RealityOrientationIntact").parents("tr:first").find("label").html();

        }

        if ($("#CheckBox_CustomMentalStatuses2_RealityOrientationTenuous").is(":checked")) {
            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_RealityOrientationTenuous").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_RealityOrientationTenuous").parents("tr:first").find("label").html();
            }


        }

        if ($("#CheckBox_CustomMentalStatuses2_RealityOrientationPoor").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_RealityOrientationPoor").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_RealityOrientationPoor").parents("tr:first").find("label").html();
            }

        }


        if ($("#CheckBox_CustomMentalStatuses2_RealityOrientationOther").is(":checked")) {

            if (CheckboxlistDesc != "") {
                CheckboxlistDesc = CheckboxlistDesc + "," + $("#CheckBox_CustomMentalStatuses2_RealityOrientationOther").parents("tr:first").find("label").html();
            }
            else {
                CheckboxlistDesc = CheckboxlistDesc + $("#CheckBox_CustomMentalStatuses2_RealityOrientationOther").parents("tr:first").find("label").html();
            }



        }

        //SetValuesNeedList("CustomHRMAssessmentNeeds", "HRMAssessmentNeedId", "DocumentVersionId", -3, -1, "NeedName:NeedDescription:HRMNeedid", NeedName + ':' + CheckboxlistDesc + ':' + HRMNeedid, 0);
    }

    return CheckboxlistDesc;
}



//================================================CODE BY ASHWANI KUMAR ANGRISH================================

function findLatestCustomHRMAssessmentNeedId() {


}


//CREATED ON 25 MAY 2010









//CREATED ON 26 MAY 2010
//SweetyK on 27 Feb,2010
//Set values for Dom Manipulation in SubstanceUseHistory
function SetValuesForNeeds(tableName, columnName, primaryKey, pkkeyValue, changeVal) {

    substanceUseHistory = true;
    var changeValue = changeVal;


    //for new mode
    if (pkkeyValue <= 0) {


        // start set value for FK      
        if (DocumentVersionId > 0) {
            fk = DocumentVersionId;
        }
        else {
            // set  DocumentVersionId
            fk = DocumentVersionId
        }
        // end set value for FK  


        //Check nodexml with tablename and primary key
        var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, AutoSaveXMLDom[0]);
        //  var _xmlDom = GetXMLParentNodeByColumnValue(tableName, columnName, changeValue, AutoSaveXMLDom[0])


        if (_xmlDom.length == 0) {

            //create table if not exist in xml
            //CreateAutoSaveXml(tableName, columnName, changeValue);
            var _currentNode = "";
            if (AutoSaveXMLDom[0].childNodes[0].selectSingleNode(tableName) == null) {
                AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)); //Add table in the XML Dom

                //Append column key with value
                _currentNode = AutoSaveXMLDom[0].childNodes[0].selectSingleNode(tableName).appendChild(AutoSaveXMLDom[0].createElement(columnName));
                _currentNode.text = changeValue;

                //Append PK and FK with values
                _xmlDom = GetXMLParentNodeByTable(tableName, AutoSaveXMLDom[0]);
                if (_xmlDom[0].selectSingleNode(primaryKey) == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement(primaryKey));

                    var nodepk = _xmlDom[0].selectSingleNode(primaryKey);
                    nodepk.text = pkkeyValue;

                }
                //Set value for DocumentVersionId and append
                if (_xmlDom[0].selectSingleNode('DocumentVersionId') == null) {
                    _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId'));

                    var nodefk = _xmlDom[0].selectSingleNode('DocumentVersionId');
                    nodefk.text = fk;

                }




            }

            else {
                //If table already exist in xml
                //Create other parent node with this table

                //Check column name in this xml
                _xmlDom = GetXMLParentNodeByColumnValue(tableName, primaryKey, pkkeyValue, AutoSaveXMLDom[0]);
                if (_xmlDom != null) {
                    if (_xmlDom.length > 0) {
                        if (_xmlDom[0].selectSingleNode(columnName) == null) {
                            _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement(columnName));
                            var nodecol = _xmlDom[0].selectSingleNode(columnName);
                            nodecol.text = changeValue;


                        }
                    }


                    else {


                        var i = 0;
                        var _currentxml = "";

                        _xmlDom = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)).xml; //Add table in the XML Dom

                        _xmlDom = GetXMLParentNodeByTable(tableName, AutoSaveXMLDom[0]);
                        for (i = 0; i < _xmlDom.length; i++) {

                            _currentxml = GetXMLParentNodeByColname(primaryKey, _xmlDom[i]);
                            if (_currentxml.length == 0) {

                                //append primary key
                                if (_xmlDom[i].selectSingleNode(primaryKey) == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement(primaryKey));
                                    var nodepk = _xmlDom[i].selectSingleNode(primaryKey);
                                    nodepk.text = pkkeyValue;
                                }


                                //Set value for (FK) DocumentVersionId and append
                                if (_xmlDom[i].selectSingleNode('DocumentVersionId') == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId'));

                                    var nodefk = _xmlDom[i].selectSingleNode('DocumentVersionId');
                                    nodefk.text = fk;

                                }


                                //append selected column
                                if (_xmlDom[i].selectSingleNode(columnName) == null) {
                                    _xmlDom[i].appendChild(AutoSaveXMLDom[0].createElement(columnName));

                                    var nodeselected = _xmlDom[i].selectSingleNode(columnName);
                                    nodeselected.text = changeValue;

                                }
                            }

                        }
                    }
                }
            }
        }
        else {
            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, changeValue, AutoSaveXMLDom[0], 'Y');

        }
    }

    else {

        CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKey, pkkeyValue, columnName, changeValue, AutoSaveXMLDom[0], 'Y');

    }
    AddToUnsavedTables(tableName);
}


//------------27 May 2010

function GetXmlHRMNeed() {
    alert("GetXmlHRMNeed=" + objectPageResponse.ScreenProperties.CustomHRMNeeds);
}


function CheckGoalAssociated(clientNeedId) {
    var returnValue = false;
    if (AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomClientNeeds").length > 0) {

        if ($(AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomClientNeeds")).find("ClientNeedId[text=" + clientNeedId + "]").parent().find('AssociatedGoalId').text().trim() != "")
            returnValue = true;

    }
    // var xmlNeedsFromTX = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomClientNeeds");     
    //for (var j = 0; j < AutoSaveXMLDom[0].childNdes[0].selectNodes("CustomClientNeeds").length; j++) {
    return returnValue;
}




//function SetPsychosocialAdultDescription(hrmNeedId) {
//    switch (hrmNeedId) {
//        case "75":
//            return SetValuesCurrentHealthIssues();
//            break;
//        case "76":
//            return SetValuesAbuseNeglect();
//            break;
//        case "78":
//            return SetValuesCulturalEthnicity();
//            break;
//        case "79":
//            return SetValuesSpirituality();
//            break;
//        case "135":
//            return SetValuesEducation();
//            break;
//            //Added By Davinder Kumar, Date : Mar 03, 2011.   
//        case "136":
//            return SetValuesAdultMedication();
//            break;
//            //End Comment.  
//        case "72":
//            return SetValuesTraumatic();
//            break;


//        default:
//            return $.xmlDOM($("[id$=HiddenCustomHRMNeedsDataTable]").val()).find("CustomHRMNeeds  HRMNeedId[text=" + hrmNeedId + "]").parent().find("NeedDescription").text();
//    }
//}



//=================================================CODE BY ASHWANI KUMAR ANGRISH



function StoreTabstripClientObject(sender) {
    tabobject = sender;

    //    if (action == pageActionEnum.New) {
    //        alert('Sandeep');
    //    }

    if (flag == 0) {
        if ($("#CheckBox_CustomHRMAssessments_ClientInDDPopulation").length > 0)
            $("#CheckBox_CustomHRMAssessments_ClientInDDPopulation")[0].checked = false;

        if ($("#CheckBox_CustomHRMAssessments_ClientInSAPopulation").length > 0)
            $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation")[0].checked = false;

        if ($("#CheckBox_CustomHRMAssessments_ClientInMHPopulation").length > 0)
            $("#CheckBox_CustomHRMAssessments_ClientInMHPopulation")[0].checked = false;

        flag = 1;

    }

}


// Function Added by Damanpreet 
// created on 4th Feb 2010
function SetEnableDisableUncope(val, dom, autosave) {
    var RadioButtonUncopeQuestionU = $("input[type='radio'][name='RadioButton_CustomHRMAssessments_UncopeQuestionU']")
    var RadioButtonUncopeQuestionN = $("input[type='radio'][name='RadioButton_CustomHRMAssessments_UncopeQuestionN']")
    var RadioButtonUncopeQuestionC = $("input[type='radio'][name='RadioButton_CustomHRMAssessments_UncopeQuestionC']")
    var RadioButtonUncopeQuestionO = $("input[type='radio'][name='RadioButton_CustomHRMAssessments_UncopeQuestionO']")
    var RadioButtonUncopeQuestionP = $("input[type='radio'][name='RadioButton_CustomHRMAssessments_UncopeQuestionP']")
    var RadioButtonUncopeQuestionE = $("input[type='radio'][name='RadioButton_CustomHRMAssessments_UncopeQuestionE']")
    if (val == 'N') {

        RadioButtonUncopeQuestionC.attr("disabled", "disabled");
        RadioButtonUncopeQuestionE.attr("disabled", "disabled");
        RadioButtonUncopeQuestionN.attr("disabled", "disabled");
        RadioButtonUncopeQuestionO.attr("disabled", "disabled");
        RadioButtonUncopeQuestionP.attr("disabled", "disabled");
        RadioButtonUncopeQuestionU.attr("disabled", "disabled");
        //$("#RadioButton_CustomHRMAssessments_UncopeApplicable_Y").attr("checked", false);
        //$("#RadioButton_CustomHRMAssessments_UncopeApplicable_N").attr("checked", true);
    }
    if (val == 'Y') {

        RadioButtonUncopeQuestionC.removeAttr("disabled", "disabled");
        RadioButtonUncopeQuestionE.removeAttr("disabled", "disabled");
        RadioButtonUncopeQuestionN.removeAttr("disabled", "disabled");
        RadioButtonUncopeQuestionO.removeAttr("disabled", "disabled");
        RadioButtonUncopeQuestionP.removeAttr("disabled", "disabled");
        RadioButtonUncopeQuestionU.removeAttr("disabled", "disabled");
        //$("#RadioButton_CustomHRMAssessments_UncopeApplicable_Y").attr("checked", true);
        //$("#RadioButton_CustomHRMAssessments_UncopeApplicable_N").attr("checked", false);
    }
    //Code added by Loveena in ref to Task#984 Assessment->'Is UNCOPE applicable' field as 'Yes' is not retained.
    if (autosave != undefined && autosave == 'N') {
        UpdateAutoSaveXmlNode("CustomHRMAssessments", 'UncopeApplicable', val);
    }
    else {
        CreateAutoSaveXml('CustomHRMAssessments', 'UncopeApplicable', val, dom);
    }
}


///*-------------- Jitender Kumar      ---------------------------*/
/////Author : Jitender Kumar Kamboj
/////Purpose : This function will be called From HRMSummary Page To open ServiceLookup PopUp
/////Date: 04 May,2010

//function OpenServiceLookupPopUp(RelativePath) {
//    try {

//        // OpenPage(11829, 10135, '', null, RelativePath, 'T', "dialogHeight: 400px; dialogWidth: 450px; dialogtitle:Service Lookup;");
//        OpenPage(5765, 54, '', null, RelativePath, 'T', "dialogHeight: 400px; dialogWidth: 450px; dialogtitle:Service Lookup;");

//    }
//    catch (err) {
//        LogClientSideException(err, 'HRMAssesment');
//    }
//}

///Author : Jitender Kumar Kamboj
///Purpose : This function will be called From Risk Assessment Page To open HRMOtherRiskFactors PopUp
///Date: 04 May,2010

function OpenOtherRiskFactorsLookupPopUp(RelativePath) {
    try {
        // OpenPage(11829, 10138, '', null, RelativePath, 'T', "dialogHeight: 400px; dialogWidth: 450px; dialogtitle:Other Risk Factors Lookup;");
        OpenPage(5765, 10057, '', null, RelativePath, 'T', "dialogHeight: 400px; dialogWidth: 450px; dialogtitle:Other Risk Factors Lookup;");

    }
    catch (err) {
        LogClientSideException(err, 'HRMAssesment');
    }
}

///Author : Jitender Kumar Kamboj
///Purpose : This function is used to Split ServiceLookup Details and create XML to bind grid on HRMSummary page
///Date: 04 May,2010

function SplitServiceLookupDetail(ServiceLookupDetail) {
    //var HRMAssessmentLevelOfCareOptionId = $("input[id$=hiddenHRMAssessmentLevelOfCareOptionId]").val();

    var splitIndex = 0;
    var splitArray = new Array();
    var separator = '||';
    var stringArray = ServiceLookupDetail.split(separator);
    var count = stringArray.length;
    var XML = new String("<MainDataSet  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">");
    for (i = 0; i < count; i++) {
        var separatorNew = ':';
        var stringChildArray = stringArray[i].split(separatorNew);
        var HRMLevelOfCareOptionId = stringChildArray[0];
        var serviceChoiceLabel = stringChildArray[1];

        if (HRMLevelOfCareOptionId != "") {
            XML = XML + "<CustomHRMAssessmentLevelOfCareOptions>";
            //if (HRMAssessmentLevelOfCareOptionId == "") {
            XML = XML + "<HRMAssessmentLevelOfCareOptionId>" + HRMLevelOfCareOptionId + " </HRMAssessmentLevelOfCareOptionId>";
            //}
            //else {
            //XML = XML + "<HRMAssessmentLevelOfCareOptionId>" + HRMAssessmentLevelOfCareOptionId + "</HRMAssessmentLevelOfCareOptionId>";
            // }
            XML += "<DocumentVersionId>" + DocumentVersionId + "</DocumentVersionId>";

            XML += "<HRMLevelOfCareOptionId>" + HRMLevelOfCareOptionId + "</HRMLevelOfCareOptionId>";

            XML += "<ServiceChoiceLabel>" + encodeTextForXML(serviceChoiceLabel) + "</ServiceChoiceLabel>";

            XML += "<RecordDeleted>N</RecordDeleted>";

            XML = XML + "</CustomHRMAssessmentLevelOfCareOptions>"
        }
    }
    XML = XML + "</MainDataSet>";
    gridTableName = 'CustomHRMAssessmentLevelOfCareOptions';
    CallAjaxGridControl(XML, '#TableChildControl_CustomHRMAssessmentLevelOfCareOptions', 'InsertGridServiceLookup', 'CustomGridServiceLookup', 'CustomHRMAssessmentLevelOfCareOptions');
}



///Author : Jitender Kumar Kamboj
///Purpose : This function is used to Split OtherRiskFactorsLookup Details and create XML to bind grid on HRMRiskAssessment page
///Date: 04 May,2010

function SplitOtherRiskFactorsLookupDetail(OtherRiskFactorsLookupDetail) {
    var splitIndex = 0;
    var splitArray = new Array();
    var separator = '||';
    var stringArray = OtherRiskFactorsLookupDetail.split(separator);
    var count = stringArray.length;
    var XML = new String("<MainDataSet  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">");
    for (i = 0; i < count; i++) {
        var separatorNew = ':';
        var stringChildArray = stringArray[i].split(separatorNew);
        var otherRiskFactor = stringChildArray[0];
        var codeName = stringChildArray[1];

        if (otherRiskFactor != "") {
            XML = XML + "<CustomOtherRiskFactors>";

            XML = XML + "<OtherRiskFactorId>" + encodeTextForXML(otherRiskFactor) + " </OtherRiskFactorId>";

            XML += "<DocumentVersionId>" + DocumentVersionId + "</DocumentVersionId>";

            XML += "<OtherRiskFactor>" + encodeTextForXML(otherRiskFactor) + "</OtherRiskFactor>";

            XML += "<CodeName>" + encodeTextForXML(codeName) + "</CodeName>";

            XML += "<RecordDeleted>N</RecordDeleted>";

            XML = XML + "</CustomOtherRiskFactors>"
        }

    }
    XML = XML + "</MainDataSet>";
    gridTableName = 'CustomOtherRiskFactors';
    CallAjaxGridControl(XML, '#TableChildControl_CustomOtherRiskFactorsLookup', 'InsertGridOtherRiskFactorsLookup', 'CustomGridOtherRiskFactorsLookup', 'CustomOtherRiskFactors');
}


///Author : Jitender Kumar Kamboj
///Purpose : This function is used to add Support section to HRMSupport page
///Date: 10 May,2010
///Global Variable Index is used to differentiate between controls

var index = 0;
////Changes with ref to 867
///--Date----------Author-----------Purpose-------------------------
//---11Oct2011     Pradeep          Made changes to check XmlhrmSupport.length to avoid errorgeneration as per task#300(Sc Web PhaseII Bugs & Features)
function AddSupport() {
    try {
        //Changes with ref to ticket 867
        var XmlhrmSupport;
        if (AutoSaveXMLDom == undefined || AutoSaveXMLDom == null)
            return;
        XmlhrmSupport = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentSupports2");
        if (XmlhrmSupport == undefined || XmlhrmSupport == null)
            return;
        if (XmlhrmSupport.length > 0) {
            var hRMSupportId = XmlhrmSupport[XmlhrmSupport.length - 1].selectNodes("HRMAssessmentSupportId")[0].text;
        }
        else {
            return;
        }
        var newhRMhRMSupportId = -1;
        if (parseInt(hRMSupportId) > 0)
            newhRMhRMSupportId = -1;
        else
            newhRMhRMSupportId = parseInt(hRMSupportId) - 1;

        index = newhRMhRMSupportId;
        //Changes end here
        if ($("table[supportAtt=common]").length == 0) {

        }
        $.ajax(
        {
            type: "POST",
            url: GetRelativePath() + "Custom/Assessment/WebPages/AjaxHRMSupport.aspx?functionName=GetSupport",
            data: "Support=" + index,
            success: fillSupport
        });

    }
    catch (err) {
        LogClientSideException(err, 'HRMAssesment');
    }
}


/////Author : Jitender Kumar Kamboj
/////Purpose : This function is used to add Support section to HRMSupport page
/////Date: 10 May,2010

function AddSupportSection() {
    try {
        PopupProcessing();
        //Changes with ref to ticket 867
        //Logic of generating Primary Key has to be dependent on maximum HRMAssessmentSupportId
        var XmlhrmSupport;
        XmlhrmSupport = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentSupports2");
        var newhRMhRMSupportId = -1;

        if (XmlhrmSupport != undefined && XmlhrmSupport != null && XmlhrmSupport.length > 0) {
            var hRMSupportId = XmlhrmSupport[XmlhrmSupport.length - 1].selectNodes("HRMAssessmentSupportId")[0].text;
            var newhRMhRMSupportId = -1;
            if (parseInt(hRMSupportId) > 0)
                newhRMhRMSupportId = -1;
            else
                newhRMhRMSupportId = parseInt(hRMSupportId) - 1;
        }

        index = newhRMhRMSupportId;
        //Changes end here
        if ($("table[supportAtt=common]").length == 0) {
            //index = 0;
        }
        else if ($("table[supportAtt=common]").length > 0) {
        }


        $.ajax(
        {
            type: "POST",
            url: GetRelativePath() + "Custom/Assessment/WebPages/AjaxHRMSupport.aspx?functionName=GetSupportSection",
            data: "Support=" + index,
            success: fillSupportSection
        });


    }
    catch (err) {
        HidePopupProcessing();
        LogClientSideException(err, 'HRMAssesment');
    }
}



/////Author : Jitender Kumar Kamboj
/////Purpose : This function is used to fill Support section
/////Date: 12 May,2010
function fillSupport(result) {
    try {
        ///Index is incrementing in function AddSupport() used for unique ids, here we create Support section first time.
        if (index == 1) {
            $('#DivSupport').html(result);
        }
        else {
            $('#DivSupport').append(result);
        }
        ValidationSupport();
        CreateInitializationImages(AutoSaveXMLDom);
    }
    catch (err) {
        LogClientSideException(err, 'HRMAssesment');
    }
}





///get xml by table name
///Added by Jitender Kumar Kamboj
function GetXMLParentNodeByTable(tableName, xmlDom) {
    var expression = tableName;
    return $(expression, xmlDom);
}

///get xml by Column name
///Added by Jitender Kumar Kamboj
function GetXMLParentNodeByColname(colname, xmlDom) {
    var expression = colname;
    return $(expression, xmlDom).parent();
}

///get xml by Column Value
///Added by Jitender Kumar Kamboj
/*function GetXMLParentNodeByColumnValue(tableName, columnName, columnValue, xmlDom) {
var expression = tableName + '>' + columnName + '[text=' + columnValue + ']';
return $(expression, xmlDom).parent();
}*/


///Author : Jitender Kumar Kamboj
///Purpose : This function is used to check and uncheck checkboxes on Support page
///Date: 09 July,2010
//Changes made by Mamta Gupta - Ref Task No. 634- 31/Jan/2012 - primaryKeyValue parameter pass to get CustomHRMAssessmentSupports2 table node accroding to HRMAssessmentSupportId
function UnCheckControls(columnValue, indexCount, primaryKeyValue) {
    //if ($('#RadioButton_CustomSupports2_Current_1_N').attr('checked')) {
    //Changes made by Mamta Gupta - Ref Task No. 634 -31/Jan/2012 - To get parent node according to HRMAssessmentSupportId
    var Parentnode = "";
    var childnode = "";
    if (columnValue == 'Y' || columnValue == 'N') {
        Parentnode = $("CustomHRMAssessmentSupports2 HRMAssessmentSupportId[text=" + primaryKeyValue + "]", AutoSaveXMLDom).parent();
    }
    //Changes end here
    if (columnValue == "Y") {
        //Remove checked attribute code added by Rakesh with ref to task 243 Assessment: Supports Tab: Radio Button Selection Issues in UM Part II
        // Modified by Vikesh : Ref Task Assessment in Allegan Customization issue tracking
        // Add "_" during find control by id
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_ClinicallyRecommended_" + indexCount + "_]").removeAttr('checked');
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_CustomerDesired_" + indexCount + "_]").removeAttr('checked');
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_ClinicallyRecommended_" + indexCount + "_]").attr('disabled', true);
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_CustomerDesired_" + indexCount + "_]").attr('disabled', true);
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_PaidSupport_" + indexCount + "_]").attr('disabled', false);
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_UnpaidSupport_" + indexCount + "_]").attr('disabled', false);
        //Changes made by Mamta Gupta - Ref Task No. 634 -31/Jan/2012 - To change value from 'Y' to 'N' of ClinicallyRecommended and CustomerDesired node if nodes exist.
        childnode = $(Parentnode).find("ClinicallyRecommended");
        if (childnode.length > 0) {
            childnode.text('N');
        }
        childnode = $(Parentnode).find("CustomerDesired");
        if (childnode.length > 0) {
            childnode.text('N');
        }
        //Changes End Here
    }
    else if (columnValue == "N") {
        // Modified by Vikesh : Ref Task Assessment in Allegan Customization issue tracking
        // Add "_" during find control by id
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_ClinicallyRecommended_" + indexCount + "_]").attr('disabled', false);
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_CustomerDesired_" + indexCount + "_]").attr('disabled', false);
        //Remove checked attribute code added by Rakesh with ref to task 243 Assessment: Supports Tab: Radio Button Selection Issues in UM Part II
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_PaidSupport_" + indexCount + "_]").removeAttr('checked');
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_UnpaidSupport_" + indexCount + "_]").removeAttr('checked');
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_PaidSupport_" + indexCount + "_]").attr('disabled', true);
        $("[id^=CheckBox_CustomHRMAssessmentSupports2_UnpaidSupport_" + indexCount + "_]").attr('disabled', true);
        //Changes made by Mamta Gupta - Ref Task No. 634 - 31/Jan/2012 -To change value from 'Y' to 'N' of PaidSupport and UnpaidSupport node if nodes exist.
        childnode = $(Parentnode).find("PaidSupport");
        if (childnode.length > 0) {
            childnode.text('N');
        }
        childnode = $(Parentnode).find("UnpaidSupport");
        if (childnode.length > 0) {
            childnode.text('N');
        }
        //Changes End Here
    }
}


///Author : Jitender Kumar Kamboj
///Purpose : This function is used to do validation on HRMSupport page
///Date: 10 July,2010
function ValidationSupport() {

    if (AutoSaveXMLDom != "" && AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentSupports2").length > 0) {
        var xmlCustomSupports2 = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentSupports2");
        for (var j = 0; j < AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentSupports2").length; j++) {

            if (xmlCustomSupports2[j].selectNodes("Current").length > 0) {
                var currentColumnValue = xmlCustomSupports2[j].selectNodes("Current")[0].text.trim();
                //Changes made by Mamta Gupta - Ref Task No. 634 - 31/Jan/2012 - primarykeyvalue paramerted pass to UnCheckControls method
                UnCheckControls(currentColumnValue, j + 1, "");
            }
        }
    }

}


/*------------------- End here -----------------------------*/

//Added on 09 July,2010
function deleteSupport(deleteSection, tableName, columnName, primaryKey, pkkeyValue, changeVal) {
    ShowMsgBox('Are you sure want to remove this Support?', ConfirmationMessageCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'deleteSupportOnOkOption(\'' + deleteSection + '\',\'' + tableName + '\',\'' + columnName + '\',\'' + primaryKey + '\',\'' + pkkeyValue + '\',\'' + changeVal + '\');');
}


function deleteSupportOnOkOption(deleteSection, tableName, columnName, primaryKey, pkkeyValue, changeVal) {
    var deletingElement = $.find('table[supportDeleteAtt=' + deleteSection + ']');
    $(deletingElement).remove();

    var kount = 1;
    $("[id*=SupportText]").each(function() {
        (this).innerHTML = "Support " + kount;
        kount = kount + 1;
    });

    SetSupportValues(tableName, columnName, primaryKey, pkkeyValue, changeVal, '');

}




// Function to add Level of intensity to Needs list
function CalculateLevelOfIntensity(dom) {
    var XmlHrmNeed;
    var NeedDesc;
    if (dom[0] == null)
        return false;

    var IntensityHealth = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
    if (IntensityHealth.length > 0) {

    }
}




// Function to add Level of intensity to Needs list
function SetEnableDisableControls(selectedTabTitle, dom) {

    if (dom == undefined) {
        dom = AutoSaveXMLDom;
    }
    var IntensityHealth = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
    //commented by Rakesh garg on 17 jan 2013 for ref task # 16 in Newaygo Customizations
    // as They don't require RAP Tabs in DD option in  assessment document

    //    if (IntensityHealth.length > 0) {

    //        if (IntensityHealth[0].selectNodes("RapCiDomainIntensity").length > 0) {
    //            if (selectedTabTitle == 'RAP Community') {
    //                var LevelCommunity = IntensityHealth[0].selectNodes("RapCiDomainIntensity")[0].text;
    //                if (LevelCommunity == 'High') {
    //                    $("#Checkbox_CustomHRMAssessments_RapCiDomainNeedsList").attr("checked", true);
    //                    $("#DivLevelCommunity").attr("disabled", true);
    //                }
    //            }
    //        }

    //        if (IntensityHealth[0].selectNodes("RapCbDomainIntensity").length > 0) {
    //            if (selectedTabTitle == 'RAP Behaviors') {
    //                var LevelBehavior = IntensityHealth[0].selectNodes("RapCbDomainIntensity")[0].text;
    //                checkLevelBehavior = LevelBehavior;

    //                if (LevelBehavior == 'High') {
    //                    $("#Checkbox_CustomHRMAssessments_RapCbDomainNeedsList").attr("checked", true);
    //                    $("#DivLevelBehavior").attr("disabled", true);


    //                }
    //            }
    //        }
    //        if (IntensityHealth[0].selectNodes("RapCaDomainIntensity").length > 0) {
    //            if (selectedTabTitle == 'RAP Abilities') {
    //                var LevelAbility = IntensityHealth[0].selectNodes("RapCaDomainIntensity")[0].text;
    //                if (LevelAbility == 'High') {
    //                    $("#Checkbox_CustomHRMAssessments_RapCaDomainNeedsList").attr("checked", true);
    //                    $("#DivLevelAbilities").attr("disabled", true);

    //                }
    //            }
    //        }

    //        if (IntensityHealth[0].selectNodes("RapHhcDomainIntensity").length > 0) {
    //            if (selectedTabTitle == 'RAP Health') {
    //                var LevelHealth = IntensityHealth[0].selectNodes("RapHhcDomainIntensity")[0].text;
    //                if (LevelHealth == 'High') {
    //                    $("#Checkbox_CustomHRMAssessments_PsCurrentHealthIssuesNeedsList").attr("checked", true);
    //                    $("#DivLevelHealth").attr("disabled", true);


    //                }



    //            }
    //        }
    //    }
}


//Author : Jitender Kumar Kamboj
//Purpose : This function is used to get ServiceChoiceLabel to HRMSummary page
//Date:     04 May,2010

function GetServiceLookupDetail(gridView) {
    var ServiceLookupDetail = "";
    //var grid = $("table[id$=GridViewServiceLookup]");
    var ServiceLookUp = $(window.frames["iframeWindowDialog"].document);
    var grid = ServiceLookUp.find("#" + gridView);
    $("input[type='checkbox']", grid).each(function() {
        if ($(this).attr("checked") == true) {
            ServiceLookupDetail += $(this).parent().find("input[type='hidden']:first").val() + ":";
            ServiceLookupDetail += $(this).parent().find("input[type='hidden']:last").val() + "||";
        }
    });
    ServiceLookupDetail = ServiceLookupDetail.substring(0, ServiceLookupDetail.length - 2);
    ProcessServiceLookupPopUp(ServiceLookupDetail);
}




//function SetRAPScore(tableName, primaryKeyName, ForeignKeyName, primaryKeyValue, ForeignKeyValue, columnName, columnValue, Object, CalledFromAddToNeedList) {
//    if (CalledFromAddToNeedList != undefined || CalledFromAddToNeedList == true) {

//    }
//    else {
//        var drop = $('[id$=' + Object + ']').val();
//        columnValue = columnValue + ':' + $('[id$=' + Object + ']').val();
//    }
//    columnName = columnName.split(':');
//    columnValue = columnValue.split(':');
//    columnValue_Length = columnValue.length;

//    var primaryKeySet = false;
//    for (var k = 0; k < columnValue_Length; k++) {
//        //for new mode
//        if (primaryKeyValue <= 0) {
//            //Start set value for FK
//            //Changes to make RAP Tab in Unsave Changes Area
//            var fk = ForeignKeyValue;
//            // end set value for FK  
//            //Check nodexml with tablename and primary key
//            var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'DocumentVersionId', AutoSaveXMLDom[0]);
//            if (_xmlDom.length == 0 && primaryKeySet == false) {
//                //create table if not exist in xml
//                //Append column key with value
//                AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)); //Add table in the XML Dom
//                var _currentNode = "";
//                _currentNode = AutoSaveXMLDom[0].childNodes[0].lastChild.appendChild(AutoSaveXMLDom[0].createElement(primaryKeyName));
//                _currentNode.text = primaryKeyValue;
//                primaryKeySet = true;
//            }
//            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, ForeignKeyName, ForeignKeyValue, AutoSaveXMLDom[0], 'Y');
//            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName[k], columnValue[k], AutoSaveXMLDom[0], 'Y');
//            //Changes end here                
//        }
//        else {
//            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName[k], columnValue[k], AutoSaveXMLDom[0], 'Y');
//        }
//    }
//}

function RefreshTabPageContents(tabControl, selectedTabTitle) {
    try {
        var _ddSelected = false;
        var _checkBoxClientInDDPopulation = 'N';
        var _checkBoxClientInSAPopulation = 'N';
        var _checkBoxClientInMHPopulation = 'N';
        var _DxTabDisabled = null;

        //added by vithobha, selectedTabTitle in Chrome has new line Character at the end for Allegan 3.5 Implementation: #163 SC 
        selectedTabTitle = selectedTabTitle.trim();

        var xmlHrmAssessmentRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");

        //if ($.trim(selectedTabTitle) == 'DLA-20') {// DLA Tab
        //    RefreshDLATabPage(AutoSaveXMLDom);
        //}
        //if ($.trim(selectedTabTitle) == 'DLA-20 Y') {// DLA Youth Tab
        //    RefreshDLAYouthTabPage(AutoSaveXMLDom);
        //}
        if (tabUserControlName == "Gambling") {
            $('[id$=Gambling]').css('overflow', 'hidden');
        }
        if (tabUserControlName == "HRMNeedList") {
            FillNeedsTabTemplate();
            var DivNeedLists = $("#DivNeedLists");
            var LabelNeedErrorMsg = $("label[id$=LabelNeedErrorMsg]", DivNeedLists);
            if (UnsavedChangeId > 0) {
                if (LabelNeedErrorMsg.length > 0) {
                    LabelNeedErrorMsg.show();
                }
                StopSpellCheckProcess();
            }
            else {
                if (LabelNeedErrorMsg.length > 0) {
                    LabelNeedErrorMsg.hide();
                }
            }
        }
        if (xmlHrmAssessmentRow[0].selectNodes("ClientInDDPopulation").length > 0 && xmlHrmAssessmentRow[0].selectNodes("ClientInDDPopulation")[0].text.trim() == 'Y') {
            _checkBoxClientInDDPopulation = 'Y';
        }

        if (xmlHrmAssessmentRow[0].selectNodes("ClientInSAPopulation").length > 0 && xmlHrmAssessmentRow[0].selectNodes("ClientInSAPopulation")[0].text.trim() == 'Y') {
            _checkBoxClientInSAPopulation = 'Y';
        }
        else if (xmlHrmAssessmentRow[0].selectNodes("ClientInMHPopulation").length > 0 && xmlHrmAssessmentRow[0].selectNodes("ClientInMHPopulation")[0].text.trim() == 'Y') {
            _checkBoxClientInMHPopulation = 'Y';

        }

        if (selectedTabTitle == 'Dx') {

            DxTabEnableDisable(_checkBoxClientInDDPopulation, _checkBoxClientInSAPopulation, _checkBoxClientInMHPopulation, xmlHrmAssessmentRow);
            //SetDiagnosisOrder(AutoSaveXMLDom);
            SetDiagnosisOrder();
        }

        if (selectedTabTitle == 'Psychosocial DD') {
            SetFormValues(AutoSaveXMLDom, tabUserControlName);
            EnableDisabeNeedListCheckBoxex(tabUserControlName);
        }

        if (selectedTabTitle == 'Psychosocial Adult') {
            SetFormValues(AutoSaveXMLDom, tabUserControlName);
            SetMedicationControls(AutoSaveXMLDom);
            EnableDisabeNeedListCheckBoxex(tabUserControlName);
        }

        //if (selectedTabTitle == 'RAP Health') {
        //    SetFormValues(AutoSaveXMLDom, tabUserControlName);
        //    SetMedicationControls(AutoSaveXMLDom);

        //}

        if (selectedTabTitle == 'Psychosocial Child') {

            SetFormValues(AutoSaveXMLDom, tabUserControlName);
            SetMedicationControls(AutoSaveXMLDom);
            EnableDisabeNeedListCheckBoxex(tabUserControlName);
        }

        //if (selectedTabTitle.indexOf('RAP') >= 0) {
        //    SetEnableDisableControls(selectedTabTitle);
        //}

        if (selectedTabTitle == 'UNCOPE') {

            callUncope();
        }
        if (selectedTabTitle == 'CRAFFT') {

            callCRAFFT();
        }


                //if ($.trim(selectedTabTitle) == 'DLA-20') {
                //    RefreshDLATabPage(AutoSaveXMLDom);
                //    //Changes made by Vikas Kashyup- 6/Dec/2011 -Ref Task 485 - To add and remove DLA from need list according to score on tab hide and show
                //    if (DLAFlag != '') {
                //        var DLA_tab = tabobject.findTabByText('DLA');
                //        CalculateDLA(DLA_tab);
                //        var selectedTab = tabobject.findTabByText(DLAFlag);
                //        selectedTab.select();
                //        DLAFlag = '';
                //    }
                //}

        if (selectedTabTitle == 'Initial') {
            SetGuardianInfoControl(AutoSaveXMLDom);
            AgeRadioButtonCheck(AutoSaveXMLDom);
            //Added by Mahesh with refrence to ticket #469
            EnableDusableInitilaSection(AutoSaveXMLDom);

        }

        // Added by Jitender Kumar Kamboj on 16 August 2010 in ref task # 305
        if (selectedTabTitle == 'Risk Assessment') {
            if (!$("#CheckBox_CustomHRMAssessments_SuicideCurrent").is(":checked") && !$("#CheckBox_CustomHRMAssessments_SuicidePriorAttempt").is(":checked")) {

                $("#TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory").attr('LocalDisableFunc', true);
            }

            if (!$("#CheckBox_CustomHRMAssessments_HomicideCurrent").is(":checked") && !$("#CheckBox_CustomHRMAssessments_HomicidePriorAttempt").is(":checked")) {

                $("#TextArea_CustomHRMAssessments_HomicideBehaviorsPastHistory").attr('LocalDisableFunc', true);
            }
            ShowCurrentSuicidalityList('N');
            CheckSuicideActivePassive();
            CheckHomicideActivePassive();

            //ShowCurrentHomicidalityList();
            DisabledHomicidality();
            DisabledSuicidality();
            //changes made by vikas kashyup - 8/Nov/2011- Ref Task 370- to disabled Psychiatric Advance Directives in child case.
            DisabledPsychiatricAdvanceDirectives();
            //Added By Rakesh below function
            EnableDisabeNeedListCheckBoxex(tabUserControlName);
        }

        //        if (selectedTabTitle == 'CAFAS') {
        //            BindPsychosocialstepper();
        //            /* Added by Mahesh with refrence to ticket # 653 */
        //            //Uncomment by sourabh with ref to task#468.
        //            GetCafasUrl(AutoSaveXMLDom);
        //            /* Added by Mahesh with refrence to ticket # 653 */
        //            //CalCulateCafasScore();
        //            //Changes made by Vikas Kashyup- 6/Dec/2011 -Ref Task 485 - To add and remove DLA from need list according to score on tab hide and show
        //            if (CAFASFlag != '') {
        //                var CAFAS_tab = tabobject.findTabByText('CAFAS');
        //                CalculateCafas(CAFAS_tab);
        //                var selectedTab = tabobject.findTabByText(CAFASFlag);
        //                selectedTab.select();
        //                CAFASFlag = '';
        //            }
        //        }
        if (selectedTabTitle == 'Needs List') {

            //    BindNeedList(AutoSaveXMLDom);

        }
        if (selectedTabTitle == 'Pre Plan') {
            hideTable();

        }

        //Code added by Loveena in ref to Task#916 5.7 - HRM Assessment: DD Fields on Mental Status tab missing
        if (selectedTabTitle == 'Mental Status') {
            if (_checkBoxClientInDDPopulation == 'Y') {
                ShowHideMentalStatusDDSection(true);
                if ($("#CheckBox_CustomHRMAssessments_SevereProfoundDisability").is(":checked"))
                    $("#trSevereProfoundDisability").show();
                else
                    $("#trSevereProfoundDisability").hide();
            }

            else if ((_checkBoxClientInMHPopulation == 'Y' || _checkBoxClientInSAPopulation == 'Y') && (_checkBoxClientInDDPopulation == 'N')) {
                ShowHideMentalStatusDDSection(false);

            }
            if (_ChangeSelectedIndexAfterNeedInsertion == true) {
                _ChangeSelectedIndexAfterNeedInsertion = false;
                _currentSelectedTab.set_selected();
            }

            //Added By Rakesh
            EnableDisabeNeedListCheckBoxex(tabUserControlName);

        }
        if (selectedTabTitle == 'Disposition') {
            //added by Saurav Pande
            if (DispositionControl != null) {
                DispositionControl.BindDispositionEvents("divDisposition");
            }
            // Code End herespec

        }
        if (selectedTabTitle == 'Safety/Crisis Plan') {
            if (SafetyCrisisPlanTabIndex == 0) {
                if (tabobject != null && tabobject != undefined) {
                    GetTabIndexOfSafetyCrisisPlan(tabobject);
                }
            }

            if (TabIndex == SafetyCrisisPlanTabIndex && SafetyCrisisPlanTabIndex > 0 || selectedTabTitle == "Safety Plan" || selectedTabTitle == "Crisis Plan") {
                $('[id$=PlanCrisisSafety]').css('overflow', 'hidden');
                UpdateScreenHistoryNode(CurrentHistoryId, CurrentScreenId, "ScreenTabIndex", SafetyCrisisPlanTabIndex.toString());
                tabobject._selectedIndex = SafetyCrisisPlanTabIndex;
                TabIndex = SafetyCrisisPlanTabIndex;
                objectPageResponse.SelectedTabId = SafetyCrisisPlanTabIndex;
            }
        }

        if (selectedTabTitle == 'Gambling') {
            if (GamblingMainTabIndex == 0) {
                if (tabobject != null && tabobject != undefined) {
                    GetTabIndexOfSafetyCrisisPlan(tabobject);
                }
            }

            if (TabIndex == GamblingMainTabIndex && GamblingMainTabIndex > 0) {
                $('[id$=Gambling]').css('overflow', 'hidden');
                UpdateScreenHistoryNode(CurrentHistoryId, CurrentScreenId, "ScreenTabIndex", GamblingMainTabIndex.toString());
                tabobject._selectedIndex = GamblingMainTabIndex;
                TabIndex = GamblingMainTabIndex;
                objectPageResponse.SelectedTabId = GamblingMainTabIndex;
            }
        }

    }
    catch (ex) {
        throw ex;
    }
}

function SetMedicationControls(AutoSaveXMLDom) {

    $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).attr("disabled", "disabled");

    // ($("#TextArea_CustomHRMAssessments_PsMedicationsComment").attr("disabled", "disabled"));

    $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).hide();

    $('#DivMedications', $("#" + ParentUserControlName)).hide();

    //    $("#TextArea_CustomHRMAssessments_PsMedicationsComment").hide();
    //    $("#DivMedications").hide();

    var radioMedicationsListRAPHealthToBeModified = GetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', DocumentVersionId, 'PsMedicationsListToBeModified', AutoSaveXMLDom[0]);
    var radioRAPHealthHealthIssuesMedications = GetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', DocumentVersionId, 'PsMedications', AutoSaveXMLDom[0]);

    if (radioRAPHealthHealthIssuesMedications == 'I') {
        $('#DivMedications', $("#" + ParentUserControlName)).show();
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).attr("disabled", true);
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).show();
    }
    if (radioMedicationsListRAPHealthToBeModified == 'Y' && radioRAPHealthHealthIssuesMedications == 'I') {
        $('#DivMedications', $("#" + ParentUserControlName)).show();
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).attr("disabled", false);
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).show();
    }
    else if (radioMedicationsListRAPHealthToBeModified == 'N') {
        $('#DivMedications', $("#" + ParentUserControlName)).show();
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).attr("disabled", true);
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).show();
    }

    if (radioRAPHealthHealthIssuesMedications == 'L') {
        $('#DivMedications', $("#" + ParentUserControlName)).hide();
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).attr("disabled", false);
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).show();
    }
    else if (radioRAPHealthHealthIssuesMedications == 'N' || radioRAPHealthHealthIssuesMedications == 'U') {
        $('#DivMedications', $("#" + ParentUserControlName)).hide();
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).attr("disabled", true);
        $('#TextArea_CustomHRMAssessments_PsMedicationsComment', $("#" + ParentUserControlName)).hide();
    }

}



//function RefreshDLATabPage(domObject) {
//    if ($.trim($("#DivActivityContent")[0].innerHTML) != "") {
//        return;
//    }
//    var ReturnHtml = CreateDLAControlHtml(domObject);
//    $("#DivActivityContent").html(ReturnHtml)
//    $('.image21').each(function (i, obj) {
//        $(this).wTooltip({ content: $(this).next().val() });
//    });
//    BindUIstepper();
//    CalculateScores();
//    CreateInitializationImages(domObject);
//}

///Author : Jitender Kumar Kamboj
///Purpose : This function is used to fill Support section
///Date: 10 May,2010
function fillSupportSection(result) {
    try {

        var primaryKeyValue;
        //primaryKeyValue = -1 - index;
        primaryKeyValue = index;

        SetSupportValues('CustomHRMAssessmentSupports2', 'RecordDeleted', 'HRMAssessmentSupportId', primaryKeyValue, 'N', '', 'Y');

        ///Index is incrementing in function AddSupportSection() used for unique ids, here we create Support section first time.

        if (index == 1) {
            $('#DivSupport').html(result);
        }
        else {
            $('#DivSupport').append(result);
        }

        var kount = 1;
        $("[id*=SupportText]").each(function() {
            (this).innerHTML = "Support " + kount;
            kount = kount + 1;
        });
        HidePopupProcessing();
    }
    catch (err) {
        HidePopupProcessing();
        LogClientSideException(err, 'HRMAssesment');
    }
}


/////Author : Jitender Kumar Kamboj
/////Purpose : This function is used to set values for Dom Manipulation on HRMSupport page
/////Date: 10 May,2010
//var primaryKeySet = false;
function SetSupportValues(tableName, columnName, primaryKeyName, primaryKeyValue, columnValue, indexCount, newRowCase) {
    if (newRowCase == undefined) {
        newRowCase = 'N';
    }


    if (columnValue == "") {
        return;
    }
    else {
        if (columnValue.checked == true) {
            columnValue = "Y";
        }
        else if (columnValue.checked == false) {
            columnValue = "N";
        }
    }

    // Added by Jitender on 10 July 2010 in ref task # 694
    //&& columnName == "Current" check code added by Rakesh with ref to task 243 Assessment: Supports Tab: Radio Button Selection Issues in UM Part II
    if (indexCount != undefined && indexCount != "" && columnName == "Current") {
        //Changes made by Mamta Gupta - Ref Task No. 634 - 31/Jan/2012 - primarykeyvalue paramerted pass to UnCheckControls method
        UnCheckControls(columnValue, indexCount, primaryKeyValue);
    }
    if (newRowCase == 'Y') {
        //for new mode
        if (parseInt(primaryKeyValue) <= 0) {
            //Start set value for FK
            //Changes to make RAP Tab in Unsave Changes Area
            //var fk = ForeignKeyValue;
            // end set value for FK  
            //Check nodexml with tablename and primary key
            var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName, AutoSaveXMLDom[0]);

            //create table if not exist in xml
            //Append column key with value
            AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)); //Add table in the XML Dom
            var _currentNode = "";
            _currentNode = AutoSaveXMLDom[0].childNodes[0].lastChild.appendChild(AutoSaveXMLDom[0].createElement(primaryKeyName));
            _currentNode.text = primaryKeyValue;
            primaryKeySet = true;
            Dirty = "True";
            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'DocumentVersionId', DocumentVersionId, AutoSaveXMLDom[0], 'Y');
            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'RecordDeleted', 'N', AutoSaveXMLDom[0], 'N');
            //Changes end here       


        }
    }
    else {
        Dirty = "True";
        CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName, columnValue, AutoSaveXMLDom[0], 'Y');
    }
}



//Change column value in a specific Row values based on PrimaryKeyId
function CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom, CallAutoSave) {

    SetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom);
    //Check if need to stop autosave request.
    if (CallAutoSave != undefined && CallAutoSave != 'undefined' && CallAutoSave == 'N') {
        return false;
    }
    else {
        CreateUnsavedInstanceOnDatasetChange();
    }
}



function DisableAssessmentScreenType(disableScreenType) {
    if (disableScreenType == true) {
        $('#RadioButton_CustomHRMAssessments_AssessmentType_I').attr("disabled", true);
        $('#RadioButton_CustomHRMAssessments_AssessmentType_U').attr("disabled", true);
        $('#RadioButton_CustomHRMAssessments_AssessmentType_A').attr("disabled", true);
        //        $('#RadioButton_CustomHRMAssessments_AssessmentType_S').attr("disabled", true);

    }
    else {
        $('#RadioButton_CustomHRMAssessments_AssessmentType_I').attr("disabled", false);
        $('#RadioButton_CustomHRMAssessments_AssessmentType_U').attr("disabled", false);
        $('#RadioButton_CustomHRMAssessments_AssessmentType_A').attr("disabled", false);
        //        $('#RadioButton_CustomHRMAssessments_AssessmentType_S').attr("disabled", false);
    }
}













// Function for select radion button Adult or child according to age.
function AgeRadioButtonCheck(AutoSaveXMLDom) {
    try {
        var CustomHRMAssessments = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
        //code added by Loveena in ref to Task962 Assessment->Assessment type Radio buttons go enabled after saving twice.
        // Code changed by Rakesh Check AutoSaveXMLDom[0].childNodes[0].selectNodes("Documents").length >0 or not with ref to task 527 in SC web other billable
        var _hrmAssessmentDocumentId = 0;
        if (AutoSaveXMLDom[0].childNodes[0].selectNodes("Documents").length > 0) {
            var xmlDocumentsRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("Documents");
            _hrmAssessmentDocumentId = parseInt(xmlDocumentsRow[0].selectNodes("DocumentId")[0].text.trim());
        }
        if (_hrmAssessmentDocumentId > 0) {
            DisableAssessmentScreenType(true);
        }
        else
            DisableAssessmentScreenType(false);
        if (CustomHRMAssessments[0].selectNodes("AdultOrChild").length > 0) {
            var AdultOrChild = CustomHRMAssessments[0].selectNodes("AdultOrChild")[0].text;
            if (AdultOrChild == "") {
            }
            else {
                if (AdultOrChild == 'A') {
                    $("#RadioButton_CustomHRMAssessments_AdultOrChild_A").attr("checked", true);
                    //Commented by Loveena in ref to Task#296 5.10 - HRM Assessment: Initial Tab: Adult/Child Radio buttons
                    //($("#RadioButton_CustomHRMAssessments_AdultOrChild_C").attr("disabled", "disabled"));
                    //CreateAutoSaveXml('CustomHRMAssessments', 'AdultOrChild', 'A');
                }
                else {
                    $("#RadioButton_CustomHRMAssessments_AdultOrChild_C").attr("checked", true);
                    //Commented by Loveena in ref to Task#296 5.10 - HRM Assessment: Initial Tab: Adult/Child Radio buttons
                    //($("#RadioButton_CustomHRMAssessments_AdultOrChild_A").attr("disabled", "disabled"));
                    //CreateAutoSaveXml('CustomHRMAssessments', 'AdultOrChild', 'C');

                }
                ShowHideAdultChildTabsEvent();
            }
        }
    }
    catch (ex) {
        throw ex;
    }
}

function SetTabUcPath() {
    if (ParentUserControlName == "HRMDXDD" || tabobject._selectedIndex == 12) {
        return Path = "/ICD10Diagnosis/Documents/ICDTenDiagnosis.ascx";
    }
    else if (ParentUserControlName == "PlanCrisisSafety" || tabobject._selectedIndex == 15) {
        if (selectedtab.GetText() == "Safety Plan") {
            return Path = "/Custom/Assessment/WebPages/SafetyPlan.ascx";
        }
        else if (selectedtab.GetText() == "Crisis Plan") {
            return Path = "/Custom/Assessment/WebPages/CrisisPlan.ascx";
        }
        else { return ""; }
    }
    else
        return "";

}

function SetFieldsAfterDomInitialized() {


}


function SetScreenSpecificValues(dom, action) {
    if (tabobject != null && tabobject != undefined) {
        GetTabIndexOfSafetyCrisisPlan(tabobject);
    }

  

    if (tabobject.get_selectedTab()._attributes.getAttribute("UcName") == "YDLA20Y") {
        RefreshDLAYouthTabPage(AutoSaveXMLDom);
    }
    if (tabobject.get_selectedTab()._attributes.getAttribute("UcName") == 'DLA20') {// DLA Tab
        RefreshDLATabPage(AutoSaveXMLDom);
    }

    //if ($("input[id$=HiddenClientAge]").val() > 0) {
    //    ClientAge = $("input[id$=HiddenClientAge]").val();
    //}
    //var NoDLA = $('CustomDocumentDLA20s > NoDLA', dom).text();
    //if (NoDLA == "Y")
    //    $("#CheckBox_CustomDocumentDLA20s_NoDLA").attr("checked", true);
    //else
    //    $("#CheckBox_CustomDocumentDLA20s_NoDLA").attr("checked", false);
    //if (ClientAge < 18 || ClientAge == 18) {
    //    ShowHideAssessmentHRMTab(DLA_tabA, false);
    //    RefreshDLAYouthTabPage(dom);
    //}
    //else if (ClientAge > 18) {
    //    RefreshDLATabPage(dom);
    //}

    if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        //Modify by jagdeep as per task #1793-Harbor Go Live Issues
        var tabStrip = $find("RadTabStrip1");
        StoreTabstripClientObject(tabStrip);
    }
    else {
        selectedTabText = tabobject.get_selectedTab().get_text();
        historytabobject = tabobject._selectedIndex;

        if (tabobject.get_selectedTab().get_text().indexOf('Initial') >= 0) {
            SetPreviousAssessmentType();

            var GamblingPopulation = $("#CheckBox_CustomHRMAssessments_ClientInAutsimPopulation")[0];
            var Gambling_tab = tabobject.findTabByText('Gambling');
            if (GamblingPopulation.checked) {
                Gambling_tab.set_visible(true);
            }
            else {
                Gambling_tab.set_visible(false);
            }
        }
        if (selectedTabText == 'Gambling' && LoadGamblingfirsttime == 2) {
            HideProcessing = true;
            HidePopupProcessing();
        }
        if (selectedTabText == 'Gambling' && LoadGamblingfirsttime == 1) {
            if (historytabobject == 1 && GambTabs != null) {
                if (SubTabIndex == undefined) {
                    SubTabIndex = 0;
                }
                if (LoadGamblingfirsttime == 1) {
                    HideProcessing = false;
                    PopupProcessing();
                    GambTabs.RaiseTabClick(SubTabIndex, onTabSelected);
                    GambTabs.SetActiveTab(GambTabs.tabs[SubTabIndex]);
                    LoadGamblingfirsttime = 2;
                }
            }
            
            UpdateScreenHistoryNode(CurrentHistoryId, CurrentScreenId, "ScreenTabIndex", "1");
            tabobject._selectedIndex = 1;
            SubTabIndex = 0;
            TabIndex = 1;
            objectPageResponse.SelectedTabId = 1;
            $('#GambTabs').css('overflow', 'hidden');
            ValidateGamblingTabControls();
        }
        if (selectedTabText == 'Safety/Crisis Plan' && LoadSafetyPlanfirsttime == 2) {
            HideProcessing = true;
            HidePopupProcessing();
        }
        if (selectedTabText == 'Safety/Crisis Plan' && LoadSafetyPlanfirsttime == 1)
        {
            if (historytabobject == 15 && SafetyMultitabCrisis != null) {
                if (SubTabIndex == undefined) {
                    SubTabIndex = 0;
                }
                if (LoadSafetyPlanfirsttime == 1) {
                    PopupProcessing();
                    HideProcessing = false;
                    SafetyMultitabCrisis.RaiseTabClick(SubTabIndex, onTabSelected);
                    SafetyMultitabCrisis.SetActiveTab(SafetyMultitabCrisis.tabs[SubTabIndex]);
                    LoadSafetyPlanfirsttime = 2;
                }
            }
            
            SubTabIndex = 0;
            UpdateScreenHistoryNode(CurrentHistoryId, CurrentScreenId, "ScreenTabIndex", "15");
            tabobject._selectedIndex = 15;
            TabIndex = 15;
            $('#SafetyMultitabCrisis').css('overflow', 'hidden');
        }
    }


    SetLableOnAssessmentDate();

    var _AssistedTreatment = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomSubstanceUseAssessments", "MedicationAssistedTreatment");
    if (_AssistedTreatment == "A") {
        $('[id$=TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason]').val("");
        $('#TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason').attr("disabled", true);
    }
    else {
                if ($('#TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason').is(':disabled')) {
                    $('#TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason').attr("disabled", false);
                }
        }
    //Changes end here
    if ($('input[id=RadioButton_CustomHRMAssessments_ClientIsAppropriateForTreatment_Y]:checked').length > 0) {
        DisableTreatmentSection();
    }
    if ($('input[id=RadioButton_CustomHRMAssessments_SecondOpinionNoticeProvided_N]:checked').length > 0) {
        DisableSummaryTreatmentComment();
    }


    if (action == pageActionEnum.TabRequest) {
        if (tabUserControlName == "HRMPsychosocialAdult" || tabUserControlName == "HRMPsychosocialChild" || tabUserControlName == "HRMDDPsychosocial") {
            SetFormValues(AutoSaveXMLDom, tabUserControlName);
        }

        

        if (tabUserControlName == "HRMUncope") {
            SetFormValues(AutoSaveXMLDom, tabUserControlName);
            //            UncopeSubstanceUseTobacco();
            //            UncopeSubstanceUseIllicit();
            //            UncopeSubstanceUsePrescription();
        }
        if (tabUserControlName == "CrafftAssessment") {
            SetFormValues(AutoSaveXMLDom, tabUserControlName);
            //            UncopeSubstanceUseTobacco();
            //            UncopeSubstanceUseIllicit();
            //            UncopeSubstanceUsePrescription();
        }
        
        if (tabUserControlName == "HRMSummary") {
            ShowHideTextArea();
        }
        return false;
    }
    if (action == pageActionEnum.None) {

        ParentUserControlName = tabobject.get_selectedTab()._attributes.getAttribute("UcName");
        // In below CheckForBlankNeed(true,dom) dom is passed by Rakesh with ref to task 581 in SC web other billable as Notice tab label is "Intial" and content of need list displays.
        if ((AutoSaveXMLDom != undefined) && (CheckForBlankNeed(true, dom) == true)) {
        }
    }
    if (action == "update") {
        var tabName = tabobject.get_selectedTab()._attributes.getAttribute("UcName");
        if (tabName == "HRMNeedList") {
            tabUserControlName = tabName;
        }
    }
    var _hrmAssessmentDocumentId = -1;
    var xmlHrmAssessmentRow = null;
    // Code for  DX tab begin
    var _checkBoxClientInDDPopulation = 'N';
    var _checkBoxClientInSAPopulation = 'N';
    var _checkBoxClientInMHPopulation = 'N';
    var Check = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomHRMAssessments", "AssessmentType");
    xmlHrmAssessmentRow = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");


    if (xmlHrmAssessmentRow[0].selectNodes("ClientInDDPopulation").length > 0 && xmlHrmAssessmentRow[0].selectNodes("ClientInDDPopulation")[0].text.trim() == 'Y') {
        _checkBoxClientInDDPopulation = 'Y';
    }

    if (xmlHrmAssessmentRow[0].selectNodes("ClientInSAPopulation").length > 0 && xmlHrmAssessmentRow[0].selectNodes("ClientInSAPopulation")[0].text.trim() == 'Y') {
        _checkBoxClientInSAPopulation = 'Y';
    }
    else if (xmlHrmAssessmentRow[0].selectNodes("ClientInMHPopulation").length > 0 && xmlHrmAssessmentRow[0].selectNodes("ClientInMHPopulation")[0].text.trim() == 'Y') {
        _checkBoxClientInMHPopulation = 'Y';

    }
    AgeRadioButtonCheck(dom);
    if (objectPageResponse.ScreenProperties.CustomHrmActivities != undefined) {
        $("[id$=HiddenCustomHRMActivitiesDataTable]").val(unescape(objectPageResponse.ScreenProperties.CustomHrmActivities));
    }

    if (objectPageResponse.ScreenProperties.UpdateAsseeementType != undefined) {
        $('#HiddenUpdateAssessmentText').val(objectPageResponse.ScreenProperties.UpdateAsseeementType);
    }

    //    if ((action == pageActionEnum.Update || action == pageActionEnum.None) && tabobject != null) {
    //        if (tabobject.get_selectedTab().get_text().indexOf('DLA') >= 0) {
    //            RefreshDLATabPage(dom);
    //        }
    //    }
    if ((action == pageActionEnum.Update || action == pageActionEnum.None) && tabobject != null) {
        //  if (tabobject.get_selectedTab().get_text().indexOf('Needs') >= 0)
        //  BindNeedList(dom);
    }

    if ((dom != "" && dom[0].childNodes[0].selectNodes("CustomHRMAssessments").length > 0)) {
        if (xmlHrmAssessmentRow[0].selectNodes("ExistLatestSignedDocumentVersion").length > 0) {
            var existLatestSignedDocumentVersionId = xmlHrmAssessmentRow[0].selectNodes("ExistLatestSignedDocumentVersion")[0].text.trim();
            if (existLatestSignedDocumentVersionId == 'N') {
                $("#TdAssessmentTypeUpdate").hide();
                $("#TdAssessmentTypeLabelUpdate").hide();
                $("#TdAssessmentTypeAnnual").hide();
                $("#TdAssessmentTypeLabelAnnual").hide();
            }
            else {
                $("#TdAssessmentTypeUpdate").show();
                $("#TdAssessmentTypeLabelUpdate").show();
                $("#TdAssessmentTypeAnnual").show();
                $("#TdAssessmentTypeLabelAnnual").show();
            }
        }
        if ((objectPageResponse.ScreenProperties != null && objectPageResponse.ScreenProperties.DeleteCustomHrmNeeds == "False") || action == pageActionEnum.TabRequest) {
            _DeleteAssessmentHrmNeeds = false;

        }
        else {
            _DeleteAssessmentHrmNeeds = true;

        }


        if ((dom != "" && dom[0].childNodes[0].selectNodes("Documents").length > 0)) {
            var xmlDocumentsRow = dom[0].childNodes[0].selectNodes("Documents");
            _hrmAssessmentDocumentId = parseInt(xmlDocumentsRow[0].selectNodes("DocumentId")[0].text.trim());
            if (_hrmAssessmentDocumentId > 0) {
                DisableAssessmentScreenType(true);
            }
            else
                DisableAssessmentScreenType(false);
        }

        if (dom != "" && dom[0].childNodes[0].selectNodes("CustomClientNeeds").length > 0) {
            var xmlNeedsFromTX = dom[0].childNodes[0].selectNodes("CustomClientNeeds");
            for (var j = 0; j < dom[0].childNodes[0].selectNodes("CustomClientNeeds").length; j++) {

                var needNameTx = xmlNeedsFromTX[j].selectNodes("NeedName")[0].text.trim();
                var needDescriptionTx = xmlNeedsFromTX[j].selectNodes("NeedDescription")[0].text.trim();
                var clientNeedIdTx = xmlNeedsFromTX[j].selectNodes("ClientNeedId")[0].text.trim();

            }
            // createNeedListHTML(AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentNeeds"));

        }

        $("#DivCurrentSuicidality").hide();
        //Code Added with reference to ticket #325 start

        //$("#DivCurrentHomicidality").hide();
        //Code Added with reference to ticket #325 end


        if (action == pageActionEnum.New || action == pageActionEnum.None) {
            SelectCheckBoxExist(dom);
        }

        if (_hrmAssessmentDocumentId > 0) {
            var uncopeApplicable = xmlHrmAssessmentRow[0].selectNodes("UncopeApplicable");
            if (uncopeApplicable.length > 0 && uncopeApplicable[0].text.trim() == 'Y') {
                SetEnableDisableUncope('Y', dom,'N');
            }
            else if (uncopeApplicable.length > 0 && uncopeApplicable[0].text.trim() == 'N') {
                SetEnableDisableUncope('N', dom,'N');
            }
            //Enable Disable Craff tab Radio based on value
            var _customDocumentCrafftRow = dom[0].childNodes[0].selectNodes("CustomDocumentCRAFFTs");
            if (_customDocumentCrafftRow.length > 0) {
                var crafftApplicable = _customDocumentCrafftRow[0].selectNodes("CrafftApplicable");
                if (crafftApplicable.length > 0 && crafftApplicable[0].text.trim() == 'Y') {
                    SetEnableDisableCrafft('Y', dom);
                }
                else if (crafftApplicable.length > 0 && crafftApplicable[0].text.trim() == 'N') {
                    SetEnableDisableCrafft('N', dom);
                }
            }
        }

        //

      
         
        
      

        //Code added by Loveena in ref to Task
        if (xmlHrmAssessmentRow[0].selectNodes("PrePlanSeparateDocument").length > 0 && xmlHrmAssessmentRow[0].selectNodes("PrePlanSeparateDocument")[0].text.trim() == 'Y') {
            hideTable();
        }
        // Code added with reference to Issue #968 ends.

        SetTelerikControls(action, dom,'Y');
        DisableTreatmentSection(dom);
        EnableSummaryTreatmentComment();
        DisableSummaryTreatmentComment();
        //Added by Mahesh with refrence to ticket #469
        EnableDusableInitilaSection(dom);
        if (tabobject != null) {
            if (tabobject.get_selectedTab().get_text().indexOf('RAP') >= 0) {
                SetEnableDisableControls(tabobject.get_selectedTab()._text, dom);
                SetMedicationControls(dom);
            }
            else if (tabobject.get_selectedTab().get_text().indexOf('Psychosocial Child') >= 0) {
                SetMedicationControls(dom);
                //Added by Rakesh
                EnableDisabeNeedListCheckBoxex(tabobject.get_selectedTab()._properties._data._implPageViewID);
            }
            else if (tabobject.get_selectedTab().get_text().indexOf('Psychosocial Adult') >= 0) {
                SetMedicationControls(dom);
                //Added by Rakesh
                EnableDisabeNeedListCheckBoxex(tabobject.get_selectedTab()._properties._data._implPageViewID);
            }
            else if (tabobject.get_selectedTab().get_text().indexOf('Psychosocial DD') >= 0) {
                EnableDisabeNeedListCheckBoxex(tabobject.get_selectedTab()._properties._data._implPageViewID);
            }
            else if (tabobject.get_selectedTab().get_text().indexOf('Risk Assessment') >= 0) {
                ShowCurrentSuicidalityList();
                CheckSuicideActivePassive();
                CheckHomicideActivePassive();

                //ShowCurrentHomicidalityList();
                DisabledHomicidality(dom);
                DisabledSuicidality();

                //changes made by vikas kashyup - 14/Nov/2011- Ref Task 370- to disabled Psychiatric Advance Directives in child case.
                DisabledPsychiatricAdvanceDirectives();
                //Added by Rakesh
                EnableDisabeNeedListCheckBoxex(tabobject.get_selectedTab()._properties._data._implPageViewID);
            }
            else if (tabobject.get_selectedTab().get_text().indexOf('Mental Status') >= 0) {
                //Hide Section if DD is not selected
                if (_checkBoxClientInDDPopulation == 'Y') {
                    ShowHideMentalStatusDDSection(true);
                    if ($("#CheckBox_CustomHRMAssessments_SevereProfoundDisability").is(":checked"))
                        $("#trSevereProfoundDisability").show();
                    else
                        $("#trSevereProfoundDisability").hide();
                }

                else if ((_checkBoxClientInMHPopulation == 'Y' || _checkBoxClientInSAPopulation == 'Y') && (_checkBoxClientInDDPopulation == 'N')) {
                    ShowHideMentalStatusDDSection(false);

                }
                if (_ChangeSelectedIndexAfterNeedInsertion == true) {
                    _ChangeSelectedIndexAfterNeedInsertion = false;
                    _currentSelectedTab.set_selected();
                }
                //Added by Rakesh
                EnableDisabeNeedListCheckBoxex(tabobject.get_selectedTab()._properties._data._implPageViewID);
            }
            else if (tabobject.get_selectedTab().get_text().indexOf('Dx') >= 0) {
                DxTabEnableDisable(_checkBoxClientInDDPopulation, _checkBoxClientInSAPopulation, _checkBoxClientInMHPopulation, xmlHrmAssessmentRow);
                SetDiagnosisOrder(dom);
            }
            else if (tabobject.get_selectedTab().get_text().indexOf('Disposition') >= 0) {
                //added by Saurav Pande
                if (DispositionControl != null) {
                    DispositionControl.BindDispositionEvents("divDisposition");
                }
                // Code End here
            }
            //Below two conditions added by Rakesh  w.rf to task 658 in Kalmazoo bugs
            else if (tabobject.get_selectedTab().get_text().indexOf('UNCOPE') >= 0) {
                EnableDisableCheckBox();
                //                UncopeSubstanceUseTobacco();
                //                UncopeSubstanceUseIllicit();
                //                UncopeSubstanceUsePrescription();

            }
            else if (tabobject.get_selectedTab().get_text().indexOf('CRAFFT') >= 0) {
                EnableDisableCheckBox();
                //                UncopeSubstanceUseTobacco();
                //                UncopeSubstanceUseIllicit();
                //                UncopeSubstanceUsePrescription();

            }
            else if (tabobject.get_selectedTab().get_text() == 'Safety/Crisis Plan') {
                //PlanCrisisSafety(dom);
            }
            // Changes end here

        }

        //Code for  DX tab End
        SetGuardianInfoControl(dom);

    }
    
    
}

function RefreshDLATabPage(domObject) {

    if ($("#DivActivityContent").length > 0 && ($.trim($("#DivActivityContent")[0].innerHTML) != "")) {
        return;
    }
    var ReturnHtml = CreateDLAControlHtml(domObject);
    $("#DivActivityContent").html(ReturnHtml);
    BindUIstepper();
    CalculateScores();
    $('.hastip').tooltipsy();
    CreateInitializationImages(domObject);
}
function RefreshDLAYouthTabPage(domObject) {
    //$('a.rtsLink').addClass('rtsSelected');
    if ($("#DivActivityContent").length > 0 && ($.trim($("#DivActivityContent")[0].innerHTML) != "")) {
        return;
    }
    var ReturnHtml = SCDLAY.CreateDLAControlHtml(domObject);
    $("#DivActivityContent").html(ReturnHtml);
    BindUIstepper();
    SCDLAY.CalculateScores();
    $('.hastip').tooltipsy();
    CreateInitializationImages(domObject);
}

function ShowHideTextArea() {
    var ReductionInSymptoms = $("#CheckBox_CustomHRMAssessments_ReductionInSymptoms");
    var AttainmentOfHigherFunctioning = $('#CheckBox_CustomHRMAssessments_AttainmentOfHigherFunctioning');
    var TreatmentNotNecessary = $('#CheckBox_CustomHRMAssessments_TreatmentNotNecessary');
    var OtherTransitionCriteria = $('#CheckBox_CustomHRMAssessments_OtherTransitionCriteria');

    var ReductionInSymptomsDescriptionObject = $("textarea[id$=TextArea_CustomHRMAssessments_ReductionInSymptomsDescription]");
    var AttainmentOfHigherFunctioningDescriptionObject = $("textarea[id$=TextArea_CustomHRMAssessments_AttainmentOfHigherFunctioningDescription]");
    var TreatmentNotNecessaryDescriptionObject = $("textarea[id$=TextArea_CustomHRMAssessments_TreatmentNotNecessaryDescription]");
    var OtherTransitionCriteriaDescriptionObject = $("textarea[id$=TextArea_CustomHRMAssessments_OtherTransitionCriteriaDescription]");
    if (ReductionInSymptoms.length > 0 && $(ReductionInSymptomsDescriptionObject).length > 0) {
        if (ReductionInSymptoms.is(":checked")) {
            $(ReductionInSymptomsDescriptionObject).closest("tr").show();
        }
        else {
            $(ReductionInSymptomsDescriptionObject).closest("tr").hide();
        }
    }
    else {
        $(ReductionInSymptomsDescriptionObject).closest("tr").hide();
    }
    if (AttainmentOfHigherFunctioning.length > 0 && $(AttainmentOfHigherFunctioningDescriptionObject).length > 0) {
        if (AttainmentOfHigherFunctioning.is(":checked")) {
            $(AttainmentOfHigherFunctioningDescriptionObject).closest("tr").show();
        }
        else {
            $(AttainmentOfHigherFunctioningDescriptionObject).closest("tr").hide();
        }
    }
    else {
        $(AttainmentOfHigherFunctioningDescriptionObject).closest("tr").hide();
    }
    if (TreatmentNotNecessary.length > 0 && $(TreatmentNotNecessaryDescriptionObject).length > 0) {
        if (TreatmentNotNecessary.is(":checked")) {
            $(TreatmentNotNecessaryDescriptionObject).closest("tr").show();
        }
        else {
            $(TreatmentNotNecessaryDescriptionObject).closest("tr").hide();
        }
    }
    else {
        $(TreatmentNotNecessaryDescriptionObject).closest("tr").hide();

    }
    if (OtherTransitionCriteria.length > 0 && $(OtherTransitionCriteriaDescriptionObject).length > 0) {
        if (OtherTransitionCriteria.is(":checked")) {
            $(OtherTransitionCriteriaDescriptionObject).closest("tr").show();
        }
        else {
            $(OtherTransitionCriteriaDescriptionObject).closest("tr").hide();
        }
    }
    else {
        $(OtherTransitionCriteriaDescriptionObject).closest("tr").hide();
    }
}

//function UncopeSubstanceUseTobacco() {
//    if ($("#RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine_P").attr("checked")) {
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineQuit").attr("disabled", false);
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineTypeOfFrequency").attr("disabled", true);
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineTypeOfFrequency").val('');
//        CreateAutoSaveXml('CustomDocumentAssessmentSubstanceUses', "UseOfTobaccoNicotineTypeOfFrequency", "");
//    }
//    else if ($("#RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotine_T").attr("checked")) {
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineTypeOfFrequency").attr("disabled", false);
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineQuit").attr("disabled", true);
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineQuit").val('');
//        CreateAutoSaveXml('CustomDocumentAssessmentSubstanceUses', "UseOfTobaccoNicotineQuit", "");
//    }

//    else {
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineQuit").attr("disabled", true);
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineTypeOfFrequency").attr("disabled", true);
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineQuit").val('');
//        CreateAutoSaveXml('CustomDocumentAssessmentSubstanceUses', "UseOfTobaccoNicotineQuit", "");
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfTobaccoNicotineTypeOfFrequency").val('');
//        CreateAutoSaveXml('CustomDocumentAssessmentSubstanceUses', "UseOfTobaccoNicotineTypeOfFrequency", "");

//    }
//}

//function UncopeSubstanceUseIllicit() {
//    if ($("#RadioButton_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugs_Y").attr("checked")) {
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugsTypeFrequency").attr("disabled", false);
//    }
//    else {
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugsTypeFrequency").attr("disabled", true);
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_UseOfIllicitDrugsTypeFrequency").val('');
//        CreateAutoSaveXml('CustomDocumentAssessmentSubstanceUses', "UseOfIllicitDrugsTypeFrequency", "");
//    }
//}
//function UncopeSubstanceUsePrescription() {
//    if ($("#RadioButton_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugs_Y").attr("checked")) {
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugsTypeFrequency").attr("disabled", false);
//    }
//    else {
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugsTypeFrequency").attr("disabled", true);
//        $("#TextBox_CustomDocumentAssessmentSubstanceUses_PrescriptionOTCDrugsTypeFrequency").val('');
//        CreateAutoSaveXml('CustomDocumentAssessmentSubstanceUses', "PrescriptionOTCDrugsTypeFrequency", "");
//    }
//}

function ShowHideDxDDSectionInDiagnosis(showDDSection) {
    if (showDDSection == true) {
        $('#TdDxDDSection')[0].visible = true;
        $('#TdDxDDSection')[0].style.display = 'block';
        $('#TdDxDDBottomSection')[0].visible = true;
        $('#TdDxDDBottomSection')[0].style.display = 'block';



    }
    else {
        $('#TdDxDDSection')[0].visible = false;
        $('#TdDxDDSection')[0].style.display = 'none';
        $('#TdDxDDBottomSection')[0].visible = true;
        $('#TdDxDDBottomSection')[0].style.display = 'none';

    }

}

function SetTabsType(Dom) {
    __DeleteAssessmentHrmNeeds = true;
    AssessmentType(Dom);
    if (AssessmentTypeI.checked || AssessmentTypeU.checked || AssessmentTypeA.checked) {
        var SAPopulation = $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation")[0];
        var SUAssessment_tab = tabobject.findTabByText('Substance Abuse');
        if (SAPopulation.checked) {
            SUAssessment_tab.set_visible(true);
        }
        else {
            SUAssessment_tab.set_visible(false);
            if ($("#RadioButton_CustomHRMAssessments_AdultOrChild_A")[0].checked == true) {
                AddExtraTabUncopeEvent();
            }
            else {
                AddExtraTabCrafftEvent();
            }

        }

        var GamblingPopulation = $("#CheckBox_CustomHRMAssessments_ClientInAutsimPopulation")[0];
        var Gambling_tab = tabobject.findTabByText('Gambling');
        if (GamblingPopulation.checked) {
            Gambling_tab.set_visible(true);
        }
        else {
            Gambling_tab.set_visible(false);
        }


    }
    //  SetTabs(Dom, undefined);

    else {
        $("#CheckBox_CustomHRMAssessments_ClientInDDPopulation")[0].checked = false;
        $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation")[0].checked = false;
        $("#CheckBox_CustomHRMAssessments_ClientInMHPopulation")[0].checked = false;
        ShowMsgBox('Select Assessment type (Initial, Update, Annual).', ConfirmationMessageCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
        return;
    }
}

//Function Added by Loveena in ref to Task#296 5.10 - HRM Assessment: Initial Tab: Adult/Child Radio buttons
//to handle click events of Adult and Child radio button
function ShowHideAdultChildTabsEvent() {
    RadioButtonAdultorChild = $("#RadioButton_CustomHRMAssessments_AdultOrChild_A")[0];
    HideAdultChildTabs(RadioButtonAdultorChild);
}


function HideAdultChildTabs(RadioButtonAdultorChild, Dom) {
    var DLA_tabA = tabobject.findTabByText('DLA-20');
    var DLA_tabY = tabobject.findTabByText('DLA-20 Y');
    //var DLA_tab = tabobject.findTabByText('DLA-20');
    //var CAFAS = tabobject.findTabByText('CAFAS');
    var CRAFFT_tab = tabobject.findTabByText('CRAFFT');
    var UNCOPE_tab = tabobject.findTabByText('UNCOPE');
    var SubstanceAbuse = tabobject.findTabByText('Substance Abuse');
    //var PES = tabobject.findTabByText('PES');
    var Child_tab = tabobject.findTabByText('Psychosocial Child');
    var Adult_tab = tabobject.findTabByText('Psychosocial Adult');
    var NeedList_tab = tabobject.findTabByText('Needs List');
    var PsychoDD = tabobject.findTabByText('Psychosocial DD');
    var AssessmentS = "N";
    var Adult = "C";
    AssessmentTypeS = $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation")[0];
    if (AssessmentTypeS == undefined) {
        var AssessmentXml = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
        if (AssessmentXml.length > 0) {
            var SANode = AssessmentXml[0].selectNodes("ClientInSAPopulation");
            if (SANode.length > 0) {
                var SAtext = SANode[0].text;
                if (SAtext == 'Y') {
                    AssessmentS = "Y";
                }
            }
        }
    }
    if (RadioButtonAdultorChild == undefined) {
        var AssessmentXml = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
        if (AssessmentXml.length > 0) {
            var SANode = AssessmentXml[0].selectNodes("AdultOrChild");
            if (SANode.length > 0) {
                var SAtext = SANode[0].text;
                if (SAtext == 'A') {
                    Adult = "A";
                }
            }
        }
    }

    if (TabIndex != 5)
        ShowHideAssessmentHRMTab(SubstanceAbuse, true);

    if (PsychoDD != null) {
        ShowHideAssessmentHRMTab(PsychoDD, false);
    }
    if (NeedList_tab != null) {
        ShowHideAssessmentHRMTab(NeedList_tab, true);
    }

    if ((RadioButtonAdultorChild != undefined && RadioButtonAdultorChild.checked == true) || Adult == "A") {
        //        if (DLA_tab != null) {
        //            ShowHideAssessmentHRMTab(DLA_tab, true);
        //        }
        //        if (CAFAS != null) {
        //            ShowHideAssessmentHRMTab(CAFAS, false);

        //        }
        if (CRAFFT_tab != null) {
            ShowHideAssessmentHRMTab(CRAFFT_tab, false);
            if ($('[id$=CrafftAssessment]').length > 0)
                $('[id$=CrafftAssessment]').html('');
        }
        if (UNCOPE_tab != null) {
            ShowHideAssessmentHRMTab(UNCOPE_tab, true);
            AddExtraTabUncopeEvent();
        }

        //        if (PES != null) {
        //            ShowHideAssessmentHRMTab(PES, true);
        //        }
        if (Child_tab != null) {
            ShowHideAssessmentHRMTab(Child_tab, false);
        }
        if (Adult_tab != null) {
            ShowHideAssessmentHRMTab(Adult_tab, true);
        }


    }
    else {
        //        if (DLA_tab != null) {
        //            ShowHideAssessmentHRMTab(DLA_tab, false);
        //            //if (action != undefined && action == 'new') {
        //            //    DLAFlag = tabobject.get_selectedTab()._text;
        //            //    clickTab(DLA_tab);
        //            //}
        //            //else {
        //            //    CalculateDLA(DLA_tab);
        //            //}
        //        }
        //        if (CAFAS != null) {
        //            ShowHideAssessmentHRMTab(CAFAS, true);
        //            var clientage = $('#Span_CustomHRMAssessments_clientAge');
        //            //Modified by Saurav Pande On 1 Aug 2012, Task# 1866 kalamazoo Bugs Go live, Reduced age for CAFAS from 7 to 5
        //            if (clientage.length > 0 && parseInt(clientage.html().split(' ')[0]) < 5) {
        //                ShowHideAssessmentHRMTab(CAFAS, false);
        //            }
        //            else {
        //                //CAFAS_tab.show();
        //                ShowHideAssessmentHRMTab(CAFAS, true);
        //                //Changes made by Vikas Kashyup- 17/Nov/2011 -Ref Task 305 - To add and remove DLA from need list according to score on tab hide and show
        //                //if (action == 'new') {
        //                //    CAFASFlag = tabobject.get_selectedTab()._text;
        //                //    clickTab(CAFAS);
        //                //}
        //                //else {
        //                //    CalculateCafas(CAFAS);
        //                //}
        //            }
        //        }
        if (CRAFFT_tab != null) {
            ShowHideAssessmentHRMTab(CRAFFT_tab, true);
            AddExtraTabCrafftEvent();
        }
        if (UNCOPE_tab != null) {
            ShowHideAssessmentHRMTab(UNCOPE_tab, false);
            if ($('[id$=HRMUncope]').length > 0)
                $('[id$=HRMUncope]').html('');
        }

        //        if (PES != null) {
        //            ShowHideAssessmentHRMTab(PES, false);
        //        }
        if (Child_tab != null) {
            ShowHideAssessmentHRMTab(Child_tab, true);
        }
        if (Adult_tab != null) {
            ShowHideAssessmentHRMTab(Adult_tab, false);
        }

    }

    var ClientAge = $("input[id$=HiddenClientAge]").val();
    if (ClientAge < 18) {
        ShowHideAssessmentHRMTab(DLA_tabY, true)
    }
    else {
        ShowHideAssessmentHRMTab(DLA_tabY, false)
    }

    if (ClientAge >= 18) {
        ShowHideAssessmentHRMTab(DLA_tabA, true);
    }
    else {
        ShowHideAssessmentHRMTab(DLA_tabA, false);
    }

    if ((AssessmentTypeS != undefined && AssessmentTypeS.checked) || AssessmentS == "Y") {
        if (SubstanceAbuse != null) {
            ShowHideAssessmentHRMTab(SubstanceAbuse, true);
        }
    }
}

function ValidateClientDateOfBirth() {
    var CustomHRMAssessments = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
    if (CustomHRMAssessments[0].selectNodes("ClientDOB").length <= 0) {
        ShowHideErrorMessage('Client DOB Can not be empty', 'true');
        return false;
    }
    else
        return true;


}



function ReInitializeAssessment(ControlID) {
    //Modified by Mamta Gupta - Ref Task No. 687 - 15/Feb/2012 - To show processing while radio button clicked
    parent.PopupProcessing();
    if (ValidateClientDateOfBirth() == false) {
        $("#" + ControlID).attr("checked", false);
        CreateAutoSaveXml('CustomHRMAssessments', "AssessmentType", "");
        return false;
    }

    //Code added by Loveena in ref to Task#922   
    var fnName = 'GetPopUpOnUpdate';
    $.post(GetRelativePath() + "AjaxScript.aspx?functionName=" + fnName + "&AssessmentType=" + $("#" + ControlID).val(), function(result) { onSuccessPopUpOnUpdate(result, ControlID); }
       );
    //Added By Rakesh w.rf to task 20 in Assessment 1
    if (previousAssessmentType == "" || previousAssessmentType == undefined) {
        SetLableOnAssessmentDate();
    }

}


//Function added by Loveena in ref to Task#922
function onSuccessPopUpOnUpdate(result, ControlID) {
    var UpdateAssessmentText = result;
    var action = "Reinitilize";

    //Modified by Mamta Gupta - Ref Task No. 687 - 15/Feb/2012 - To show processing while ajax call
    value = ShowMsgBox(UpdateAssessmentText, ConfirmationMessageCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'ConfirmMessageForCompleteDocumentOnOK(\'' + action + '\')', 'ConfirmMessageForCompleteDocumentOnCancel(\'' + ControlID + '\')', null, null, null, true, null);
    //value = ShowMsgBox(UpdateAssessmentText, ConfirmationMessageCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'ConfirmMessageForCompleteDocumentOnOK(\'' + action + '\')', 'ConfirmMessageForCompleteDocumentOnCancel(\'' + ControlID + '\')');
}
//Description:Function is used for adding extra tab for uncope
//Author:Sandeep singh
//CreatedOn:14-june-2010
function AddExtraTabUncopeEvent() {
    try {
        var SUAssessment_tab = tabobject.findTabByText('Substance Abuse');
        var Count = 0;
        if (SUAssessment_tab != null) {
            //    ShowHideAssessmentHRMTab(SUAssessment_tab, false);
            //    $("#CheckBox_CustomHRMAssessments_UncopeCompleteFullSUAssessment").attr("disabled", true);
            //}
            //else {
            if ($("#RadioButton_CustomHRMAssessments_UncopeQuestionU_Y").length > 0 && $("#RadioButton_CustomHRMAssessments_UncopeQuestionP_Y").length > 0) {
                if ($("#RadioButton_CustomHRMAssessments_UncopeQuestionU_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomHRMAssessments_UncopeQuestionN_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomHRMAssessments_UncopeQuestionC_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomHRMAssessments_UncopeQuestionO_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomHRMAssessments_UncopeQuestionP_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomHRMAssessments_UncopeQuestionE_Y").attr("checked") == true) {
                    Count++;
                }
            }
            else {
                //if the radio buttons are not yet loaded
                var CrafftXml = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
                if (CrafftXml.length > 0) {
                    var CraftNode = CrafftXml[0].selectNodes("UncopeQuestionU");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("UncopeQuestionN");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("UncopeQuestionC");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("UncopeQuestionO");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("UncopeQuestionP");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("UncopeQuestionE");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                }
            }
            if (Count > 2) {
                if (SUAssessment_tab != null) {
                    SUAssessment_tab.show();
                    SUAssessment_tab.set_visible(true);
                }
            }
            else {
                // AssessmentTypeS = $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation")[0];
                if ($("#CheckBox_CustomHRMAssessments_ClientInSAPopulation").length > 0) {
                    if ($("#CheckBox_CustomHRMAssessments_ClientInSAPopulation").attr("checked") != true) {
                        if (SUAssessment_tab != null) {
                            SUAssessment_tab.hide();
                            SUAssessment_tab.set_visible(false);
                        }
                    }
                }
                else if (SUAssessment_tab != null) {
                    SUAssessment_tab.hide();
                    SUAssessment_tab.set_visible(false);
                }
            }


            if ($("#CheckBox_CustomHRMAssessments_UncopeCompleteFullSUAssessment").length > 0) {
                if (($("#CheckBox_CustomHRMAssessments_UncopeCompleteFullSUAssessment").attr("checked") == true) && (Count < 3)) {
                    if (SUAssessment_tab != null) {
                        SUAssessment_tab.show();
                        SUAssessment_tab.set_visible(true);
                    }
                }
            }
        }
    }
    catch (ex) {
        throw ex;
    }
}





function AssessmentType(dom) {
    AssessmentTypeI = $("#RadioButton_CustomHRMAssessments_AssessmentType_I");
    AssessmentTypeU = $("#RadioButton_CustomHRMAssessments_AssessmentType_U");
    AssessmentTypeA = $("#RadioButton_CustomHRMAssessments_AssessmentType_A");


    if (dom == undefined) {
        if ($("#RadioButton_CustomHRMAssessments_AssessmentType_I")[0].checked)
            AssessmentTypeI.checked = true; // = $("#RadioButton_CustomHRMAssessments_AssessmentType_I");

        if ($("#RadioButton_CustomHRMAssessments_AssessmentType_U")[0].checked)
            AssessmentTypeU.checked = true;

        if ($("#RadioButton_CustomHRMAssessments_AssessmentType_A")[0].checked)
            AssessmentTypeA.checked = true;

        //        if ($("#RadioButton_CustomHRMAssessments_AssessmentType_S")[0].checked)
        //            AssessmentTypeS.checked = true;

    }
    else {
        if ((dom != "" && dom[0].childNodes[0].selectNodes("CustomHRMAssessments").length > 0)) {
            xmlAssessmentType = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");

            //Changes made by Mamta Gupta- 9/Dec/2011- Ref Task 479- To remove Type error.
            var AssessmentType = '';
            if (xmlAssessmentType[0].selectNodes("AssessmentType").length > 0)
                AssessmentType = xmlAssessmentType[0].selectNodes("AssessmentType")[0].text;
            if (AssessmentType == 'I') {
                AssessmentTypeI.checked = true;
            }
            if (AssessmentType == 'U') {
                AssessmentTypeU.checked = true;
            }
            if (AssessmentType == 'A') {
                AssessmentTypeA.checked = true;
            }
            //            if (AssessmentType == 'S') {
            //                AssessmentTypeS.checked = true;
            //            }
        }
    }
}

function AddEventHandlers() {
    try {
        if ($("#RadioButton_CustomHRMAssessments_PsMedications_I").is(":checked")) {
            //IntializeMedication('#RadioButton_CustomHRMAssessments_PsMedications_I', '#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications', 'CustomHRMAssessments', 'PsMedicationsListToBeModified');
            var colomnValue = GetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', DocumentVersionId, 'PsMedicationsListToBeModified', AutoSaveXMLDom[0]);
            var radioButton = '#RadioButton_CustomHRMAssessments_PsMedications_I';
            var textArea = '#TextArea_CustomHRMAssessments_PsMedicationsComment';
            var divMedication = '#DivMedications';
            $(radioButton, $("#" + ParentUserControlName)).attr("checked", true);


            if (colomnValue == 'Y') {
                $(textArea, $("#" + ParentUserControlName)).attr("disabled", false);
            }
            else {
                $(textArea, $("#" + ParentUserControlName)).attr("disabled", true);
            }
            $(textArea, $("#" + ParentUserControlName)).show();
            //$(textArea, $("#" + ParentUserControlName)).val('');
            $('#listMedication').hide();
            $('#tablecomments').show();
            //SetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', DocumentVersionId, 'PsMedicationsComment', '', AutoSaveXMLDom[0]);
            $(divMedication, $("#" + ParentUserControlName)).show();
        }

        else if ($("#RadioButton_CustomHRMAssessments_PsMedications_L").is(":checked")) {
            DisappearMedication('#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications');
        }
        else {
            if ($("#RadioButton_CustomHRMAssessments_PsMedications_L").length > 0 && $("#RadioButton_CustomHRMAssessments_PsMedications_L") != undefined) {
                DisableMedication('#TextArea_CustomHRMAssessments_PsMedicationsComment', '#DivMedications');
            }
        }

        if (tabUserControlName == "HRMNeedList") {
            FillNeedsTabTemplate();
            var DivNeedLists = $("#DivNeedLists");

            var LabelNeedErrorMsg = $("label[id$=LabelNeedErrorMsg]", DivNeedLists);
            if (LabelNeedErrorMsg.length > 0) {
                LabelNeedErrorMsg.hide();
            }
        }
        var Gambling_tab = tabobject.findTabByText('Gambling');
        if ($.xmlDOM(AutoSaveXMLDom[0].xml).find("ClientInAutsimPopulation").text() == "Y") {
            Gambling_tab.set_visible(true);
        }
        else {
            Gambling_tab.set_visible(false);
        }

        BindPsychosocialstepper();
        ShowHideTextArea();

        $("#TextBox_DiagnosesIAndII_DiagnosisOrder").each(function() {
            $(this).keyup(function() {
                RetainOrderForDiagnosisIandII(this);
            })
        });

        InitCustomDocumentSafetyCrisisPlans();
        ShowHideAdultChildTabsEvent();


        if (tabUserControlName == "HRMSuAssessment") {
            if ($("#RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_A").is(":checked")) {
                $('#TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason').attr("disabled", true);
            }
        }


        //        AssessmentRecordInitialization();

        if (tabUserControlName == "CSSRSLifeTimeRecentChild") {
            RefreshCSSRSLifeTimeRecentChild();
            $('#Img1').wTooltip({ content: $("input[id$=ActualLethalityMedicalDamage]").val() });
            $('#image_information').wTooltip({ content: $("input[id$=PotentialLethality]").val() });
        }
        if ($.xmlDOM(AutoSaveXMLDom[0].xml).find("DocumentVersionId").text() != "-1-1" && $.xmlDOM(AutoSaveXMLDom[0].xml).find("DocumentVersionId").text() != "") {

            if ($('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_Y').attr('checked')) {
                //$('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_Y').attr('disabled', 'disabled')
                $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N").attr('checked', 'checked');
                $('[section=trSafetyReviewed]').hide();
            }
            if ($('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_N').attr('checked')) {
                //$('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_N').attr('disabled', 'disabled')
                $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y").attr('checked', 'checked');
                $('[section=trSafetyReviewed]').show();
            }
            if ($('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan_Y').attr('checked')) {
                //$('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan_Y').attr('disabled', 'disabled')
            }
            if ($('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan_N').attr('checked')) {
                //$('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialCrisisPlan_N').attr('disabled', 'disabled')
            }

        }
        else {
            if ($('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_Y').attr('checked')) {
                $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N").attr('checked', 'checked');
                $('[section=trSafetyReviewed]').hide();
            }
            if ($('#RadioButton_CustomDocumentSafetyCrisisPlans_InitialSafetyPlan_N').attr('checked')) {
                $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y").attr('checked', 'checked');
                $('[section=trSafetyReviewed]').show();
            }
        }
        var InitialSafetyPlan = AutoSaveXMLDom.find("CustomDocumentSafetyCrisisPlans:first InitialSafetyPlan").text();
        if (InitialSafetyPlan == 'N') {
            $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y").attr('checked', 'checked');
        }
        else {
        }

        var CrisisResolved = AutoSaveXMLDom.find("CustomSafetyCrisisPlanReviews:first CrisisResolved").text();
        if (CrisisResolved == 'N') {
            $("#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialCrisisPlan_N").attr('checked', 'checked');
        }
        else {
        }
    }
    catch (err) {
        LogClientSideException(err, 'MentalStatus');
    }
}

function ChangeDomObject(action) {
    if (action == pageActionEnum.TabRequest)
        return AutoSaveXMLDom;

}



function ClientTabSelectingHandler(sender, eventArgs) {
    var tabStrip = sender;
    var tab = eventArgs._tab;
    if (ParentUserControlName == "HRMNeedList") {


        //if (CheckForBlankNeed(undefined) == true) {
        //    ShowHideErrorMessage('Need name and Need Description is required before switching to another tab.', 'true');
        //    eventArgs.set_cancel(true);
        //    return false;

        //}
        //else {
        //    ShowHideErrorMessage('', 'false');
        //    return true;
        //}

    }
    return true;
}



//Code added by Loveena in ref to Task#916 5.7 - HRM Assessment: DD Fields on Mental Status tab missing
function DisappearSevereProfoundDisability(checkbox, trSevereProfoundDisability) {
    if ($(checkbox).is(":checked")) {
        $(trSevereProfoundDisability).show()
    }
    else
        $(trSevereProfoundDisability).hide();
}




///Author : Jitender Kumar Kamboj
///Purpose : This function is used to set values for Dom Manipulation on HRMSupport page
///Date: 10 May,2010
var primaryKeySet = false;

// Function to call enable disable DX controls
function DxTabEnableDisable(_checkBoxClientInDDPopulation, _checkBoxClientInSAPopulation, _checkBoxClientInMHPopulation, xmlHrmAssessmentRow) {
    var _AdultOrChild = null;
    var _screenType = null;
    if (xmlHrmAssessmentRow[0].selectNodes("AdultOrChild").length > 0 && xmlHrmAssessmentRow[0].selectNodes("AdultOrChild")[0].text.trim() != '') {
        _AdultOrChild = xmlHrmAssessmentRow[0].selectNodes("AdultOrChild")[0].text;
    }
    //Below Code Added BY As iN case of Screen Axis V should appear only Textboxe not Reason in case of Adult 
    if (xmlHrmAssessmentRow[0].selectNodes("AssessmentType").length > 0 && xmlHrmAssessmentRow[0].selectNodes("AssessmentType")[0].text.trim() != '') {
        _screenType = xmlHrmAssessmentRow[0].selectNodes("AssessmentType")[0].text;
    }

    if (_checkBoxClientInDDPopulation == 'Y') {
        if (typeof ShowHideDiagnosesContent == 'function') {
            ShowHideDiagnosesContent('DXDD');
        }
        //ShowHideDxDDSectionInDiagnosis(true);
        if (xmlHrmAssessmentRow[0].selectNodes("DxTabDisabled").length > 0 && xmlHrmAssessmentRow[0].selectNodes("DxTabDisabled")[0].text.trim() == 'Y') {
        }
        else {
            //DisableDXTab("DivDisableDX", '', false);
        }
    }

    else if ((_checkBoxClientInMHPopulation == 'Y' || _checkBoxClientInSAPopulation == 'Y') && (_checkBoxClientInDDPopulation == 'N')) {
        //ShowHideDxDDSectionInDiagnosis(false);
        if (xmlHrmAssessmentRow[0].selectNodes("DxTabDisabled").length > 0 && xmlHrmAssessmentRow[0].selectNodes("DxTabDisabled")[0].text.trim() == 'Y') {
            //DisableDXTab("DivDisableDX", "DivDisabilityEligibility", true);
        }
        else {
            //DisableDXTab("DivDisableDX", '', false);
        }
        if (_AdultOrChild == 'A') {

            if (typeof ShowHideDiagnosesContent == 'function') {
                //Below If Code Added BY As In case of Screen Axis V should appear only Textboxe not Reason in case of Adult 
                if (_screenType != 'S')
                    ShowHideDiagnosesContent('DXSA');
                else
                    ShowHideDiagnosesContent('DXDD');
            }
        }
        else if (_AdultOrChild == 'C') {

            if (typeof ShowHideDiagnosesContent == 'function') {
                ShowHideDiagnosesContent('DXDD');
            }
        }
    }

}


// Function to Enable disable DX controls
function DisableDXTab(DivDisableDX, DivDisabilityEligibility, TF) {
    if (DivDisableDX != "") {
        document.getElementById(DivDisableDX).disabled = document.getElementById(DivDisableDX).disabled ? true : TF;
    }
    if (DivDisabilityEligibility != "")
        document.getElementById(DivDisabilityEligibility).disabled = document.getElementById(DivDisabilityEligibility).disabled ? false : TF;
    if (TF == true) {
        DisableSpanButton('ButtonAxisIV');
        DisableSpanButton('ButtonAxisVRanges');
        DisableSpanButton('ButtonStaffAxisVRanges');
        $("[Id=AddICDCodes]").attr("disabled", true);
        $("[Id=TableChildControl_DiagnosesIAndII_ButtonInsert]").attr("disabled", true);
        $("[Id=ButtonClear]").attr("disabled", true);
        $("[Id=CustomGrid]").attr("disabled", true);
    }
}





//Code added by Loveena in ref to Task#916 5.7 - HRM Assessment: DD Fields on Mental Status tab missing
function DisappearSevereProfoundDisability(checkbox, trSevereProfoundDisability) {
    if ($(checkbox).is(":checked")) {
        $(trSevereProfoundDisability).show()
    }
    else
        $(trSevereProfoundDisability).hide();
}


//Description:To open the gurdian pop up window
//Author:Sandeep Singh
//CreatedOn:05-May-2010
function OpenGuardianInfoPopUp(RelativePath) {
    try {
        var chkbox = $("[id$=CheckBox_CustomHRMAssessments_ClientHasGuardian]");
        if (chkbox.attr('checked')) {
            var _date = new Date();
            OpenPage(5761, 10053, "Time=" + _date.getMinutes() + _date.getSeconds(), 1, RelativePath, 'T', "dialogHeight:300px; dialogWidth:450px;");
            var spanButton = $("#ButtonEditGuardian");
            spanButton.removeAttr("disabled", false);
            spanButton.find("table:first").removeAttr("disabled", false);
        }
        else {

            $("[Id=ButtonEditGuardian]").attr("disabled", true);
            var textArea = $("#TextArea_CustomHRMAssessments_GuardianAddressToDisplayOnly");
            textArea.val("");
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianName', "");
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianAddress', "");
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianPhone', "");
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianType', ""); // Added by Jitender on 16 August 2010 in ref task # 890
            CreateAutoSaveXml('CustomHRMAssessments', 'GuardianTypeText', ""); //Added 19 August 2010 in ref task # 890

        }
    }

    catch (err) {
        LogClientSideException(err, 'CustomHRMAssessments');
    }
}

function ShowHideMentalStatusDDSection(showDDSection) {
    if (showDDSection == true) {
        $('#TableServerProfoundDisability')[0].visible = true;
        $('#TableServerProfoundDisability')[0].style.display = 'block';
    }
    else {
        $('#TableServerProfoundDisability')[0].visible = false;
        $('#TableServerProfoundDisability')[0].style.display = 'none';
        if (AutoSaveXMLDom.find("CustomHRMAssessments:first SevereProfoundDisability").text() != 'N')// Added by vsinha on 4th jan for task #538 New Directions - Support Go Live 
        {
            $("#CheckBox_CustomHRMAssessments_SevereProfoundDisability").attr('checked', false)
            $("#TextArea_CustomHRMAssessments_SevereProfoundDisabilityComment").val('');
            CreateAutoSaveXml('CustomHRMAssessments', 'SevereProfoundDisability', 'N');
        }
    }
}

function SetTelerikControls(action, Dom, fromSetScreen) {
    var DDPopulation = false;
    var SAPopulation = false;
    var MHPopulation = false;
    if (Dom != "") {
        SavetabControl = Dom[0].childNodes[0].selectNodes("CustomHRMAssessments");

        if (SavetabControl[0].selectSingleNode('ClientInDDPopulation') != null) {
            if (SavetabControl[0].selectSingleNode('ClientInDDPopulation').text == 'Y') {

                if (action != pageActionEnum.New) {
                    $("input[type='checkbox'][id$='CheckBox_CustomHRMAssessments_ClientInDDPopulation']").attr("checked", true);
                    DDPopulation = true;

                }
                else if (action == pageActionEnum.New) {
                    //$("input[type='checkbox'][id$='CheckBox_CustomHRMAssessments_ClientInDDPopulation']").attr("checked", true);
                    DDPopulation = true;

                }
                else
                    DDPopulation = false;

            }
            else
                DDPopulation = false;
        }
        else {
            DDPopulation = false;
        }
        if (SavetabControl[0].selectSingleNode('ClientInSAPopulation') != null) {
            if (SavetabControl[0].selectSingleNode('ClientInSAPopulation').text == 'Y') {
                if (action != pageActionEnum.New) {
                    $("input[type='checkbox'][id$='CheckBox_CustomHRMAssessments_ClientInSAPopulation']").attr("checked", true);
                    SAPopulation = true;
                }
                else if (action == pageActionEnum.New) {
                    //$("input[type='checkbox'][id$='CheckBox_CustomHRMAssessments_ClientInDDPopulation']").attr("checked", true);
                    SAPopulation = true;

                }
                else
                    SAPopulation = false;
            }
            else
                SAPopulation = false;
        }
        else {
            SAPopulation = false;
        }
        if (SavetabControl[0].selectSingleNode('ClientInMHPopulation') != null) {
            if (SavetabControl[0].selectSingleNode('ClientInMHPopulation').text == 'Y') {
                if (action != pageActionEnum.New) {
                    $("input[type='checkbox'][id$='CheckBox_CustomHRMAssessments_ClientInMHPopulation']").attr("checked", true);
                    MHPopulation = true;
                }
                else if (action == pageActionEnum.New) {
                    //$("input[type='checkbox'][id$='CheckBox_CustomHRMAssessments_ClientInDDPopulation']").attr("checked", true);
                    MHPopulation = true;

                }
                else
                    MHPopulation = false;

            }
            else
                MHPopulation = false;
        }
        else {
            MHPopulation == false;
        }
    }


    if (CheckBoxDDPopulation == null) {
        CheckBoxDDPopulation = $("input[type='checkbox'][id$='CheckBox_CustomHRMAssessments_ClientInDDPopulation']");
        if (CheckBoxDDPopulation == null) {
            CheckBoxDDPopulation[0].checked = DDPopulation;
        }
    }
    if (CheckBoxSAPopulation == null) {
        CheckBoxSAPopulation = $("input[type='checkbox'][id$='CheckBox_CustomHRMAssessments_ClientInSAPopulation']");
        if (CheckBoxSAPopulation == null) {
            CheckBoxSAPopulation[0].checked = SAPopulation;
        }
    }
    if (CheckBoxMHPopulation == null) {
        CheckBoxMHPopulation = $("input[type='checkbox'][id$='CheckBox_CustomHRMAssessments_ClientInMHPopulation']");
        if (CheckBoxMHPopulation == null) {
            CheckBoxMHPopulation[0].checked = MHPopulation;
        }
    }

    // if (CheckBoxDDPopulation[0].checked == true || CheckBoxSAPopulation[0].checked == true || CheckBoxMHPopulation[0].checked == true) {
    if (DDPopulation == true || SAPopulation == true || MHPopulation == true) {
        //Changes made by vikas kashyup- Ref Task 354 25/Nov/2011- To stop calling settab function in case of action new or none.
        //This method called from DocumentCallbackComplete function after AutoSaveXMLDom intialized.
        isPopulationChecked = true;
        if (action != '' && action != 'new') {
            //  SetTabs(Dom, action);
        }

    }
    else {
        isPopulationChecked = false;
        //  HideTabs(tabobject);
    }
}

//Created by Viaks Kashyup - Ref Task 354- To call SetTabs method after AutoSaveXMLDom intialization in action new and none case.
function DocumentCallbackComplete(objectPageResponse) {
    if (SafetyCrisisPlanTabIndex == 0) {
        if (tabobject != null && tabobject != undefined) {
            GetTabIndexOfSafetyCrisisPlan(tabobject);
        }
    }

    if (TabIndex == SafetyCrisisPlanTabIndex && SafetyCrisisPlanTabIndex > 0) {
        $('[id$=PlanCrisisSafety]').css('overflow', 'hidden');
        PlanCrisisSafety(AutoSaveXMLDom);
    }


    
    
    
    if ((objectPageResponse.Action == pageActionEnum.New || objectPageResponse.Action == '') && isPopulationChecked) {
        // SetTabs(AutoSaveXMLDom, objectPageResponse.Action);
        return false;
    }
}


///Author : Jitender Kumar Kamboj
///Purpose : This function is used to check Active and Passive value on Risk Assessment page
///Date: 16 August,2010
function CheckSuicideActivePassive() {
    //Commented by Davinder Kumar. By ref. ticket #968 in SC Web Production Bugs/New Features
    //$("#CheckBox_CustomHRMAssessments_SuicideActive").change();
    //$("#CheckBox_CustomHRMAssessments_SuicidePassive").change();

    //Changes made by Mamta Gupta - Ref Task No. 640 SCWebPhaseII Bugs/Features - To enable and disable active and passive checkboxes
    if ($("#CheckBox_CustomHRMAssessments_SuicideActive").attr("checked")) {
        $("#CheckBox_CustomHRMAssessments_SuicidePassive").attr("disabled", true);
        $("#CheckBox_CustomHRMAssessments_SuicideActive").attr("disabled", false);
    }
    else if ($("#CheckBox_CustomHRMAssessments_SuicidePassive").attr("checked")) {
        $("#CheckBox_CustomHRMAssessments_SuicideActive").attr("disabled", true);
        $("#CheckBox_CustomHRMAssessments_SuicidePassive").attr("disabled", false);
    }
    else {
        $("#CheckBox_CustomHRMAssessments_SuicidePassive").attr("disabled", false);
        $("#CheckBox_CustomHRMAssessments_SuicideActive").attr("disabled", false);
    }

    //    if (AutoSaveXMLDom != "" && AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments").length > 0) {
    //        var CustomHRMAssessments = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
    //        if (CustomHRMAssessments[0].selectNodes("SuicideActive").length > 0) {
    //            if (CustomHRMAssessments[0].selectNodes("SuicideActive")[0].text == "Y") {
    //                $("#CheckBox_CustomHRMAssessments_SuicidePassive").attr('disabled', 'disabled')

    //            }
    //            else if (CustomHRMAssessments[0].selectNodes("SuicidePassive").length > 0) {
    //                if (CustomHRMAssessments[0].selectNodes("SuicidePassive")[0].text == "Y") {
    //                    $("#CheckBox_CustomHRMAssessments_SuicideActive").attr('disabled', 'disabled');
    //                }
    //            }


    //            else if (CustomHRMAssessments[0].selectNodes("SuicideActive")[0].text == "N") {
    //                $("#CheckBox_CustomHRMAssessments_SuicidePassive").removeAttr('disabled');

    //            }
    //            if (CustomHRMAssessments[0].selectNodes("SuicidePassive").length > 0) {
    //                if (CustomHRMAssessments[0].selectNodes("SuicidePassive")[0].text == "N" && CustomHRMAssessments[0].selectNodes("SuicideActive")[0].text == "N") {
    //                    $("#CheckBox_CustomHRMAssessments_SuicideActive").removeAttr('disabled');
    //                    $("#CheckBox_CustomHRMAssessments_SuicidePassive").removeAttr('disabled');
    //                }
    //                else if (CustomHRMAssessments[0].selectNodes("SuicidePassive")[0].text == "N") {
    //                    $("#CheckBox_CustomHRMAssessments_SuicideActive").removeAttr('disabled');
    //                }
    //            }
    //        }
    //        else if (CustomHRMAssessments[0].selectNodes("SuicidePassive").length > 0) {
    //            if (CustomHRMAssessments[0].selectNodes("SuicidePassive")[0].text == "Y") {
    //                $("#CheckBox_CustomHRMAssessments_SuicideActive").attr('disabled', 'disabled');

    //            }
    //            else if (CustomHRMAssessments[0].selectNodes("SuicideActive").length > 0) {
    //                if (CustomHRMAssessments[0].selectNodes("SuicideActive")[0].text == "Y") {
    //                    $("#CheckBox_CustomHRMAssessments_SuicidePassive").attr('disabled', 'disabled')

    //                }
    //            }
    //            else if (CustomHRMAssessments[0].selectNodes("SuicidePassive")[0].text == "N") {
    //                $("#CheckBox_CustomHRMAssessments_SuicideActive").removeAttr('disabled');
    //            }

    //            if (CustomHRMAssessments[0].selectNodes("SuicideActive").length > 0) {
    //                if (CustomHRMAssessments[0].selectNodes("SuicideActive")[0].text == "N") {
    //                    $("#CheckBox_CustomHRMAssessments_SuicidePassive").removeAttr('disabled');

    //                }
    //            }

    //        }
    //    }
    //Changes end here - Ref Task No. 640- SCwebPhaseII Bugs/Features
}

///Author : Jitender Kumar Kamboj
///Purpose : This function is used to check Active and Passive value on Risk Assessment page
///Date: 17 August,2010
function CheckHomicideActivePassive() {
    //Commented by Davinder Kumar. By ref. ticket #968 in SC Web Production Bugs/New Features
    //$("#CheckBox_CustomHRMAssessments_HomicideActive").change();
    // $("#CheckBox_CustomHRMAssessments_HomicidePassive").change();

    //Changes made by Mamta Gupta - Ref Task No. 640 SCWebPhaseII Bugs/Features - To enable and disable active and passive checkboxes
    if ($("#CheckBox_CustomHRMAssessments_HomicideActive").attr("checked")) {
        $("#CheckBox_CustomHRMAssessments_HomicidePassive").attr("disabled", true);
        $("#CheckBox_CustomHRMAssessments_HomicideActive").attr("disabled", false);
    }
    else if ($("#CheckBox_CustomHRMAssessments_HomicidePassive").attr("checked")) {
        $("#CheckBox_CustomHRMAssessments_HomicideActive").attr("disabled", true);
        $("#CheckBox_CustomHRMAssessments_HomicidePassive").attr("disabled", false);
    }
    else {
        $("#CheckBox_CustomHRMAssessments_HomicidePassive").attr("disabled", false);
        $("#CheckBox_CustomHRMAssessments_HomicideActive").attr("disabled", false);
    }

    //    if (AutoSaveXMLDom != "" && AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments").length > 0) {
    //        var CustomHRMAssessments = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
    //        if (CustomHRMAssessments[0].selectNodes("HomicideActive").length > 0) {
    //            if (CustomHRMAssessments[0].selectNodes("HomicideActive")[0].text == "Y") {
    //                $("#CheckBox_CustomHRMAssessments_HomicidePassive").attr('disabled', 'disabled')

    //            }
    //            else if (CustomHRMAssessments[0].selectNodes("HomicidePassive").length > 0) {
    //                if (CustomHRMAssessments[0].selectNodes("HomicidePassive")[0].text == "Y") {
    //                    $("#CheckBox_CustomHRMAssessments_HomicideActive").attr('disabled', 'disabled');
    //                }
    //            }


    //            else if (CustomHRMAssessments[0].selectNodes("HomicideActive")[0].text == "N") {
    //                $("#CheckBox_CustomHRMAssessments_HomicidePassive").removeAttr('disabled');

    //            }
    //            if (CustomHRMAssessments[0].selectNodes("HomicidePassive").length > 0) {
    //                if (CustomHRMAssessments[0].selectNodes("HomicidePassive")[0].text == "N" && CustomHRMAssessments[0].selectNodes("HomicideActive")[0].text == "N") {
    //                    $("#CheckBox_CustomHRMAssessments_HomicideActive").removeAttr('disabled');
    //                    $("#CheckBox_CustomHRMAssessments_HomicidePassive").removeAttr('disabled');
    //                }
    //                else if (CustomHRMAssessments[0].selectNodes("HomicidePassive")[0].text == "N") {
    //                    $("#CheckBox_CustomHRMAssessments_HomicideActive").removeAttr('disabled');
    //                }
    //            }
    //        }
    //        else if (CustomHRMAssessments[0].selectNodes("HomicidePassive").length > 0) {
    //            if (CustomHRMAssessments[0].selectNodes("HomicidePassive")[0].text == "Y") {
    //                $("#CheckBox_CustomHRMAssessments_HomicideActive").attr('disabled', 'disabled');

    //            }
    //            else if (CustomHRMAssessments[0].selectNodes("HomicideActive").length > 0) {
    //                if (CustomHRMAssessments[0].selectNodes("HomicideActive")[0].text == "Y") {
    //                    $("#CheckBox_CustomHRMAssessments_HomicidePassive").attr('disabled', 'disabled')

    //                }
    //            }
    //            else if (CustomHRMAssessments[0].selectNodes("HomicidePassive")[0].text == "N") {
    //                $("#CheckBox_CustomHRMAssessments_HomicideActive").removeAttr('disabled');
    //            }

    //            if (CustomHRMAssessments[0].selectNodes("HomicideActive").length > 0) {
    //                if (CustomHRMAssessments[0].selectNodes("HomicideActive")[0].text == "N") {
    //                    $("#CheckBox_CustomHRMAssessments_HomicidePassive").removeAttr('disabled');

    //                }
    //            }

    //        }
    //    }
    //Changes end here - Ref Task No. 640- SCwebPhaseII Bugs/Features
}

//Code Added with reference to ticket #325 start
function DisabledHomicidality(dom) {
    var domObject = null;
    if (dom == undefined)
        domObject = AutoSaveXMLDom;
    else
        domObject = dom;

    var xmlDom = $('DocumentInitializationLog', domObject).find('TableName[text=CustomHRMAssessments]').parent().find('ColumnName[text=HomicideBehaviorsPastHistory]');
    var xmlDomParent = xmlDom.parent();
    var xmlDomInit5871 = xmlDomParent.find('InitializationStatus[text=5871]');
    var xmlDomInit5872 = xmlDomParent.find('InitializationStatus[text=5872]');
}

function ShowCurrentHomicidalityList() {
    if ($("#CheckBox_CustomHRMAssessments_HomicideCurrent").is(":checked")) {
        //$("#DivCurrentHomicidality").show();
        //Added by Mahesh with reference to ticket #466 start
        //$("#TableHomicidality").removeAttr("disabled", true);
        //$("#TextArea_CustomHRMAssessments_HomicideBehaviorsPastHistory").removeAttr("disabled", true);
        $("#CheckBox_CustomHRMAssessments_HomicideNotPresent").attr("checked", false);
        //Added by Mahesh with reference to ticket #466 end
    }
    else {
        //$("#DivCurrentHomicidality").hide();
    }
    //Added by Mahesh with reference to ticket #466 start
    var textAreaParent = $("#TextArea_CustomHRMAssessments_HomicideBehaviorsPastHistory").parent();
    var imgControl = textAreaParent.find('img[class=reInitialize]');
    if ($("#CheckBox_CustomHRMAssessments_HomicidePriorAttempt").is(":checked") || $("#CheckBox_CustomHRMAssessments_HomicideCurrent").is(":checked")) {
        var logicEnable = true;
        if (imgControl.length > 0) {
            var nodeExitst = $('DocumentInitializationLog', AutoSaveXMLDom).find('TableName[text=CustomHRMAssessments]').parent().find('ColumnName[text=HomicideBehaviorsPastHistory]');
            if (nodeExitst.length > 0) {
                var nodeParent = nodeExitst.parent();
                var initializeCode = nodeParent.find('InitializationStatus').text();
                if (initializeCode == 5871 || initializeCode == 5872)
                    logicEnable = false;
            }
        }
        if (logicEnable == true) {
            $("#CheckBox_CustomHRMAssessments_HomicideNotPresent").attr("checked", false);
            $("#TableHomicidality").removeAttr("disabled", true);
            $("#TextArea_CustomHRMAssessments_HomicideBehaviorsPastHistory").removeAttr("disabled", true);
            $("#TextArea_CustomHRMAssessments_HomicideBehaviorsPastHistory").removeAttr("LocalDisableFunc", true);
        }
        //Added by Mamta Gupta - Ref Task 204 SCWebPhaseII Bugs/Features-28/Dec/2011 - To change HomicideNotPresent column status in case of HomicidePriorAttempt or HomicideCurrent checkbox checked
        if (AutoSaveXMLDom != null && AutoSaveXMLDom != '' && AutoSaveXMLDom != undefined) {
            CreateAutoSaveXml('CustomHRMAssessments', 'HomicideNotPresent', 'N');
        }
    }
    //Added by Mahesh with reference to ticket #466 end
}


function SetGuardianInfoControl(dom) {
    //  CalculateLevelOfIntensity(dom);
    var guardianName = "", guardianAddress = "", guardianPhone = "", guardianInformation = "", GuardianTypeText = "";
    var ClientHasGuardian = GetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', $('#HiddenField_CustomHRMAssessments_DocumentVersionId').val(), 'ClientHasGuardian', dom[0]);
    //guardianName = GetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'GuardianName', AutoSaveXMLDom[0]);
    guardianName = GetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', $('#HiddenField_CustomHRMAssessments_DocumentVersionId').val(), 'GuardianName', dom[0]);
    guardianAddress = GetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', $('#HiddenField_CustomHRMAssessments_DocumentVersionId').val(), 'GuardianAddress', dom[0]);
    guardianPhone = GetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', $('#HiddenField_CustomHRMAssessments_DocumentVersionId').val(), 'GuardianPhone', dom[0]);
    GuardianTypeText = GetColumnValueInXMLNodeByKeyValue('CustomHRMAssessments', 'DocumentVersionId', $('#HiddenField_CustomHRMAssessments_DocumentVersionId').val(), 'GuardianTypeText', dom[0]);

    //guardianInformation = guardianName + "\n" + guardianAddress + "\n" + guardianPhone;
    if (ClientHasGuardian == 'Y') {
        $("[Id=ButtonEditGuardian]").attr("disabled", false);
        if ((guardianName == "") && (guardianAddress == "") && (guardianPhone == "") && (GuardianTypeText == "")) {
            return;
        }
        else {
            var guardianInformation = guardianName + "\n" + guardianAddress + "\n" + guardianPhone + "\n" + GuardianTypeText;
            $('#TextArea_CustomHRMAssessments_GuardianAddressToDisplayOnly').val(guardianInformation);

        }
    }
    else
        $("[Id=ButtonEditGuardian]").attr("disabled", true);
}

function ShowHideAssessmentHRMTab(tabInstance, showTab) {
    if (tabInstance != null) {
        // var hrmNeeds = tabInstance._attributes.getAttribute("HrmNeeds");
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

//function SetTabs(Dom, action) {
//    var Initial_tab = tabobject.findTabByText('Initial');
//    var DLA_tab = tabobject.findTabByText('DLA');
//    var UNCOPE_tab = tabobject.findTabByText('UNCOPE');
//    var Adult_tab = tabobject.findTabByText('Psychosocial Adult');
//    var Strenghths_tab = tabobject.findTabByText('Supports');
//    var Mental_tab = tabobject.findTabByText('Mental Status');
//    var Risk_tab = tabobject.findTabByText('Risk Assessment');
//    var Summary_tab = tabobject.findTabByText('Summary/Level of Care');
//    var PrePlan_tab = tabobject.findTabByText('Pre Plan');
//    var DxDD_tab = tabobject.findTabByText('Dx');
//    var CAFAS_tab = tabobject.findTabByText('CAFAS');
//    var Child_tab = tabobject.findTabByText('Psychosocial Child');
//    //    var RAP_tab = tabobject.findTabByText('RAP Community');
//    //    var RAP_tab2 = tabobject.findTabByText('RAP Behaviors');
//    //    var RAP_tab3 = tabobject.findTabByText('RAP Abilities');
//    //    var RAP_tab4 = tabobject.findTabByText('RAP Health');
//    var Psychosocial_tab = tabobject.findTabByText('Psychosocial DD');
//    var SUAssessment_tab = tabobject.findTabByText('SU Assessment');
//    //Added by Rakesh
//    var Disposition_tab = tabobject.findTabByText('Disposition');
//    var CRAFFT_tab = tabobject.findTabByText('CRAFFT');
//    // Changes ene here

//    var DDPopulation = null;
//    var SAPopulation = null;
//    var MHPopulation = null;
//    var AutsimPopulation = null;

//    var NeedList_tab = tabobject.findTabByText('Needs List');

//    AssessmentType(Dom);

//    DDPopulation = $("#CheckBox_CustomHRMAssessments_ClientInDDPopulation");
//    SAPopulation = $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation");
//    MHPopulation = $("#CheckBox_CustomHRMAssessments_ClientInMHPopulation");

//    if (Dom == undefined) {

//        if ($("#CheckBox_CustomHRMAssessments_ClientInDDPopulation")[0].checked) {
//            DDPopulation.checked = true;
//        }
//        else {
//            DDPopulation.checked = false;
//        }

//        if ($("#CheckBox_CustomHRMAssessments_ClientInSAPopulation")[0].checked) {
//            SAPopulation.checked = true;
//        }
//        else {
//            SAPopulation.checked = false;
//        }

//        if ($("#CheckBox_CustomHRMAssessments_ClientInMHPopulation")[0].checked) {
//            MHPopulation.checked = true;
//        }
//        else {
//            MHPopulation.checked = false;
//        }

//    }
//    else {
//        if ((Dom != "" && Dom[0].childNodes[0].selectNodes("CustomHRMAssessments").length > 0)) {
//            xmlDDPopulation = Dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
//            if (xmlDDPopulation[0].selectNodes("ClientInDDPopulation").length > 0)
//                var DDType = xmlDDPopulation[0].selectNodes("ClientInDDPopulation")[0].text;

//            if (xmlDDPopulation[0].selectNodes("ClientInSAPopulation").length > 0)
//                var SAType = xmlDDPopulation[0].selectNodes("ClientInSAPopulation")[0].text;

//            if (xmlDDPopulation[0].selectNodes("ClientInMHPopulation").length > 0)
//                var MHType = xmlDDPopulation[0].selectNodes("ClientInMHPopulation")[0].text;

//            if (DDType == 'Y') {
//                DDPopulation.checked = true;
//            }
//            else {
//                DDPopulation.checked = false;
//            }
//            if (SAType == 'Y') {
//                SAPopulation.checked = true;
//            }
//            else {
//                SAPopulation.checked = false;
//            }
//            if (MHType == 'Y') {
//                MHPopulation.checked = true;
//            }
//            else {
//                MHPopulation.checked = false;
//            }
//        }

//    }


//    if (AssessmentTypeI.checked || AssessmentTypeU.checked || AssessmentTypeA.checked) {
//        if (RadioButtonAdultorChild == null) {
//            RadioButtonAdultorChild = $("#RadioButton_CustomHRMAssessments_AdultOrChild_A")
//            if (Dom != undefined) {
//                xmlAdultorChild = Dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
//                if (xmlAdultorChild[0].selectNodes("AdultOrChild").length > 0)
//                    var AdultorChild = xmlAdultorChild[0].selectNodes("AdultOrChild")[0].text;
//                if (AdultorChild == 'A') {
//                    RadioButtonAdultorChild.checked = true;

//                }
//                else {
//                    RadioButtonAdultorChild.checked = false;
//                }
//            }
//            else {
//                if ($("#RadioButton_CustomHRMAssessments_AdultOrChild_A")[0].checked) {
//                    RadioButtonAdultorChild.checked = true;
//                }
//                else {
//                    RadioButtonAdultorChild.checked = false;
//                }

//            }
//        }

//        if ((DDPopulation.checked && SAPopulation.checked && MHPopulation.checked) || (DDPopulation.checked && SAPopulation.checked && MHPopulation.checked == false) || (DDPopulation.checked && MHPopulation.checked && SAPopulation.checked == false) || (DDPopulation.checked && SAPopulation.checked == false && MHPopulation.checked == false)) {

//            HideAdultChildTabs(RadioButtonAdultorChild, Dom);

//            if (DxDD_tab != null) {
//                ShowHideAssessmentHRMTab(DxDD_tab, true);
//            }

//            if (Mental_tab != null) {
//                ShowHideAssessmentHRMTab(Mental_tab, true);
//            }
//            if (Risk_tab != null) {
//                ShowHideAssessmentHRMTab(Risk_tab, true);
//            }
//            if (Summary_tab != null) {
//                ShowHideAssessmentHRMTab(Summary_tab, true);
//            }
//            if (PrePlan_tab != null) {
//                ShowHideAssessmentHRMTab(PrePlan_tab, true);
//            }
//            if (Disposition_tab != null) {
//                ShowHideAssessmentHRMTab(Disposition_tab, true);
//            }
//            // Showing PsychosocialDD tab
//            if (Psychosocial_tab != null) {
//                ShowHideAssessmentHRMTab(Psychosocial_tab, true);
//            }

//        }
//        //SA
//        if ((SAPopulation.checked && MHPopulation.checked && DDPopulation.checked == false) || (SAPopulation.checked && DDPopulation.checked == false && MHPopulation.checked == false) || (MHPopulation.checked && DDPopulation.checked == false && SAPopulation.checked == false)) {

//            if (Psychosocial_tab != null) {
//                ShowHideAssessmentHRMTab(Psychosocial_tab, false);
//            }



//            if (Mental_tab != null) {
//                //Mental_tab.show();
//                ShowHideAssessmentHRMTab(Mental_tab, true);
//            }
//            if (Risk_tab != null) {
//                //Risk_tab.show();
//                ShowHideAssessmentHRMTab(Risk_tab, true);
//            }
//            if (DxDD_tab != null) {
//                //Dx_tab.show();
//                ShowHideAssessmentHRMTab(DxDD_tab, true);
//            }
//            if (Summary_tab != null) {
//                ShowHideAssessmentHRMTab(Summary_tab, true);
//            }
//            if (PrePlan_tab != null) {
//                ShowHideAssessmentHRMTab(PrePlan_tab, true);
//            }
//            if (Disposition_tab != null) {
//                ShowHideAssessmentHRMTab(Disposition_tab, true);
//            }

//            ShowHideAdultChildTabs(RadioButtonAdultorChild, Dom);

//        }

//        //Hide the tabs MH
//        if (SAPopulation.checked == false && MHPopulation.checked == false && DDPopulation.checked == false) {

//            if (Psychosocial_tab != null) {
//                ShowHideAssessmentHRMTab(Psychosocial_tab, false);
//                //Psychosocial_tab.hide();
//            }

//            if (Strenghths_tab != null) {
//                //Strenghths_tab.hide();
//                ShowHideAssessmentHRMTab(Strenghths_tab, false);
//            }
//            if (Mental_tab != null) {
//                //Mental_tab.hide();
//                ShowHideAssessmentHRMTab(Mental_tab, false);
//            }
//            if (Risk_tab != null) {
//                //Risk_tab.hide();
//                ShowHideAssessmentHRMTab(Risk_tab, false);
//            }
//            if (DxDD_tab != null) {
//                //Dx_tab.hide();
//                ShowHideAssessmentHRMTab(DxDD_tab, false);
//            }

//            if (Summary_tab != null) {
//                //Summary_tab.hide();
//                ShowHideAssessmentHRMTab(Summary_tab, false);
//            }
//            if (PrePlan_tab != null) {
//                //PrePlan_tab.hide();
//                ShowHideAssessmentHRMTab(PrePlan_tab, false);
//            }
//            if (UNCOPE_tab != null) {
//                //UNCOPE_tab.hide();
//                ShowHideAssessmentHRMTab(UNCOPE_tab, false);
//            }
//            if (SUAssessment_tab != null) {
//                //SUAssessment_tab.hide();
//                ShowHideAssessmentHRMTab(SUAssessment_tab, false);
//            }
//            //            if ((action != undefined && (action == "update")) && tabobject.get_selectedTab()._text == "SU Assessment") {
//            //            }
//            //            else
//            //                AddExtraTabUncope(Dom, 'N');

//            if (CRAFFT_tab != null) {
//                ShowHideAssessmentHRMTab(CRAFFT_tab, false);
//            }

//            if (Adult_tab != null) {
//                //Adult_tab.hide();
//                ShowHideAssessmentHRMTab(Adult_tab, false);
//            }
//            if (Child_tab != null) {
//                //Child_tab.hide();
//                ShowHideAssessmentHRMTab(Child_tab, false);
//            }
//            if (CAFAS_tab != null) {
//                //CAFAS_tab.hide();
//                ShowHideAssessmentHRMTab(CAFAS_tab, false);
//            }
//            if (DLA_tab != null) {
//                //DLA_tab.hide();
//                ShowHideAssessmentHRMTab(DLA_tab, false);
//            }
//            if (NeedList_tab != null) {
//                //NeedList_tab.hide();
//                ShowHideAssessmentHRMTab(NeedList_tab, false);
//            }
//            if (Disposition_tab != null) {
//                ShowHideAssessmentHRMTab(Disposition_tab, false);
//            }
//        }

//    }
//    else {
//        return;
//    }

//}


//Author:Sandeep singh
//CreatedOn:14-june-2010
function AddExtraTabUncope(dom, EventCheck) {
    try {
        var _eventCalled = EventCheck;
        if (EventCheck == undefined)
            _eventCalled = "";

        // Code for Su Tab Visibility From Code.
        if (_eventCalled != "" && EventCheck != "N") {
            //Call Extra Function
            AddExtraTabUncopeEvent();
            return;
        }

        if (dom == undefined)
            dom = AutoSaveXMLDom;
        var xmlHrmAssessmentRow = null;

        if ((dom != "" && dom[0].childNodes[0].selectNodes("CustomHRMAssessments").length > 0)) {
            xmlHrmAssessmentRow = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
        }
        var SUAssessment_tab = tabobject.findTabByText('Substance Abuse');
        var Count = 0;

        if (xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionU").length > 0 && xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionU")[0].text.trim() == 'Y') {
            Count++;
        }
        if (xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionN").length > 0 && xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionN")[0].text.trim() == 'Y') {

            Count++;
        }
        if (xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionC").length > 0 && xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionC")[0].text.trim() == 'Y') {
            Count++;
        }
        if (xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionO").length > 0 && xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionO")[0].text.trim() == 'Y') {
            Count++;
        }
        if (xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionP").length > 0 && xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionP")[0].text.trim() == 'Y') {
            Count++;
        }
        if (xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionE").length > 0 && xmlHrmAssessmentRow[0].selectNodes("UncopeQuestionE")[0].text.trim() == 'Y') {
            Count++;
        }

        var CheckBoxCompleteFullSUAssessmentValue = xmlHrmAssessmentRow[0].selectNodes("UncopeCompleteFullSUAssessment");
        if ((CheckBoxCompleteFullSUAssessmentValue.length > 0 && CheckBoxCompleteFullSUAssessmentValue[0].text.trim() == 'Y')) {
            if (SUAssessment_tab != null) {
                //SUAssessment_tab.show();
                ShowHideAssessmentHRMTab(SUAssessment_tab, true);
                UncopeCheck = true;
            }
        }
        else if (Count > 2) {
            if (SUAssessment_tab != null) {
                //SUAssessment_tab.show();
                ShowHideAssessmentHRMTab(SUAssessment_tab, true);
            }
        }
        else {

            if (SUAssessment_tab != null) {
                // SUAssessment_tab.hide();
                ShowHideAssessmentHRMTab(SUAssessment_tab, false);
                UncopeCheck = false;
            }

        }
        //Below Code Commented By Rakesh 
        //        if ((CheckBoxCompleteFullSUAssessmentValue.length > 0 && CheckBoxCompleteFullSUAssessmentValue[0].text.trim() == 'Y') && (Count < 3)) {
        //            if (SUAssessment_tab != null) {
        //                //SUAssessment_tab.show();
        //                ShowHideAssessmentHRMTab(SUAssessment_tab, true);
        //                UncopeCheck = true;
        //            }

        //        }
        //        if ((CheckBoxCompleteFullSUAssessmentValue.length > 0 && CheckBoxCompleteFullSUAssessmentValue[0].text.trim() == 'Y')) {
        //            if (SUAssessment_tab != null) {
        //                //SUAssessment_tab.show();
        //                ShowHideAssessmentHRMTab(SUAssessment_tab, true);
        //                UncopeCheck = true;
        //            }

        //        }
        //        else {
        //            UncopeCheck = false;
        //        }

        //        var CheckBoxDD = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
        //        var documentRowFilterCheckBox = 'ClientInDDPopulation';
        //        var flagDDMHSI = 0;
        //        documentRowFilterCheckBox = $(documentRowFilterCheckBox, CheckBoxDD[0]);
        //        if (documentRowFilterCheckBox.length > 0) {
        //            var CheckValueDD = CheckBoxDD[0].selectNodes("ClientInDDPopulation")[0].text;
        //            if (CheckValueDD == 'Y') {
        //                flagDDMHSI = 1;
        //            }


        //        }

        //        var CheckBoxSA = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
        //        documentRowFilterCheckBox = 'ClientInSAPopulation';

        //        documentRowFilterCheckBox = $(documentRowFilterCheckBox, CheckBoxSA[0]);
        //        if (documentRowFilterCheckBox.length > 0) {
        //            var CheckValueSA = CheckBoxSA[0].selectNodes("ClientInSAPopulation")[0].text;
        //            if (CheckValueSA == 'Y') {
        //                flagDDMHSI = 2;
        //            }
        //        }

        //        var CheckValueMH = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
        //        documentRowFilterCheckBox = 'ClientInMHPopulation';
        //        documentRowFilterCheckBox = $(documentRowFilterCheckBox, CheckValueMH[0]);
        //        if (documentRowFilterCheckBox.length > 0) {
        //            var CheckValueMH = CheckValueMH[0].selectNodes("ClientInMHPopulation")[0].text;
        //            if (CheckValueMH == 'Y') {
        //                flagDDMHSI = 3;
        //            }
        //        }
        //        if (flagDDMHSI == 0) {

        //            if (SUAssessment_tab != null) {
        //                ShowHideAssessmentHRMTab(SUAssessment_tab, false);

        //            }

        //        }
        //        if ($("#CheckBox_CustomHRMAssessments_ClientInDDPopulation").is(":checked") || $("#CheckBox_CustomHRMAssessments_ClientInSAPopulation").is(":checked") || $("#CheckBox_CustomHRMAssessments_ClientInMHPopulation").is(":checked")) {
        //        }
        //        else {
        //            if (SUAssessment_tab != null) {
        //                //ShowHideAssessmentHRMTab(SUAssessment_tab, false);

        //            }
        //        }
        UncopeCountGlobal = Count;
    }
    catch (ex) {
        throw ex;
    }
}

//Function added by Mahesh with refrence to ticket #469
function EnableDusableInitilaSection(dom) {

    if (dom != null && dom != '') {
        if (dom[0].childNodes[0].selectNodes("CustomHRMAssessments").length > 0) {
            CheckReasonForUpdate = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
            if (CheckReasonForUpdate[0].selectSingleNode('AssessmentType') != null) {
                var AssessmentType = CheckReasonForUpdate[0].selectSingleNode('AssessmentType').text.trim();
                if (AssessmentType == 'I' || AssessmentType == '') {
                    $("#ReasonforUpdate").hide();
                    $("#SummaryOfProgress").hide();
                }
                else if (AssessmentType == 'U') {
                    $("#ReasonforUpdate").show();
                    $("#SummaryOfProgress").hide();
                    $("#SpanReasonforUpdate").text("Reason For Update");
                }
                else if (AssessmentType == 'A') {
                    $("#SummaryOfProgress").show();
                    $("#ReasonforUpdate").hide();
                    $("#SpanSummaryOfProgress").text("Summary of Progress");
                }

            }
        }
    }
}



function ShowCurrentSuicidalityList(autosave) {
    var Check = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomHRMAssessments", "AssessmentType");
    if ($("#CheckBox_CustomHRMAssessments_SuicideCurrent").is(":checked")) {
        $("#DivCurrentSuicidality").show();
        $("#TableSuicidality").removeAttr("disabled", true);
        $("#CheckBox_CustomHRMAssessments_SuicideNotPresent").attr("checked", false);
    }

    var textAreaParent = $("#TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory").parent();
    var imgControl = textAreaParent.find('img[class=reInitialize]');
    if ($("#CheckBox_CustomHRMAssessments_SuicidePriorAttempt").is(":checked") || $("#CheckBox_CustomHRMAssessments_SuicideCurrent").is(":checked")) {
        var logicEnable = true;
        if (imgControl.length > 0) {
            var nodeExitst = $('DocumentInitializationLog', AutoSaveXMLDom).find('TableName[text=CustomHRMAssessments]').parent().find('ColumnName[text=SuicideBehaviorsPastHistory]');
            if (nodeExitst.length > 0) {
                var nodeParent = nodeExitst.parent();
                var initializeCode = nodeParent.find('InitializationStatus').text();
                if (initializeCode == 5871 || initializeCode == 5872)
                    logicEnable = false;
            }
        }
        if (logicEnable == true) {
            $("#CheckBox_CustomHRMAssessments_SuicideNotPresent").attr("checked", false);
            $("#TableSuicidality").removeAttr("disabled", true);
            $("#TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory").removeAttr("disabled", true);
            $("#TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory").removeAttr("LocalDisableFunc", true);
        }

        if (AutoSaveXMLDom != null && AutoSaveXMLDom != '' && AutoSaveXMLDom != undefined) {
            UpdateAutoSaveXmlNode("CustomHRMAssessments", "SuicideNotPresent", 'N');
        }
    }
}



function DisabledSuicidality(dom) {
    var domObject = null;
    if (dom == undefined)
        domObject = AutoSaveXMLDom;
    else
        domObject = dom;

    var xmlDom = $('DocumentInitializationLog', domObject).find('TableName[text=CustomHRMAssessments]').parent().find('ColumnName[text=SuicideBehaviorsPastHistory]');
    var xmlDomParent = xmlDom.parent();
    var xmlDomInit5871 = xmlDomParent.find('InitializationStatus[text=5871]');
    var xmlDomInit5872 = xmlDomParent.find('InitializationStatus[text=5872]');
    if ($("#CheckBox_CustomHRMAssessments_SuicideNotPresent").is(":checked")) {
        ($("#TableSuicidality").attr("disabled", "disabled"));
        $("#DivCurrentSuicidality").hide();
        ($("#TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory").attr("disabled", "disabled"));
        if (xmlDomInit5871.length == 0 && xmlDomInit5872.length == 0)
            ($("#TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory").val(''));
        $("#CheckBox_CustomHRMAssessments_SuicideCurrent").attr("checked", false);
        $("#CheckBox_CustomHRMAssessments_SuicideIdeation").attr("checked", false);
        $("#CheckBox_CustomHRMAssessments_SuicideActive").attr("checked", false);
        $("#CheckBox_CustomHRMAssessments_SuicidePassive").attr("checked", false);
        $("#CheckBox_CustomHRMAssessments_SuicideMeans").attr("checked", false);
        $("#CheckBox_CustomHRMAssessments_SuicidePlan").attr("checked", false);
        $("#CheckBox_CustomHRMAssessments_SuicideNeedsList").attr("checked", false);
        $("#CheckBox_CustomHRMAssessments_SuicideBehaviorsPastHistory").val('');
        if (AutoSaveXMLDom != null && AutoSaveXMLDom != '' && AutoSaveXMLDom != undefined) {
            if (xmlDomInit5871.length == 0 && xmlDomInit5872.length == 0)
                UpdateAutoSaveXmlNode('CustomHRMAssessments', 'SuicideBehaviorsPastHistory', '');
            UpdateAutoSaveXmlNode('CustomHRMAssessments', 'SuicideNeedsList', '');
        }
        //if (dom != undefined)
        //    DeleteNeedListFromXmlBasedOnHrmNeedId('114', dom);
        //else
        //    DeleteNeedListFromXmlBasedOnHrmNeedId('114', AutoSaveXMLDom);
        $("#CheckBox_CustomHRMAssessments_SuicidePriorAttempt").attr("checked", false);
        if (AutoSaveXMLDom != null && AutoSaveXMLDom != '' && AutoSaveXMLDom != undefined) {

            UpdateAutoSaveXmlNode('CustomHRMAssessments', 'SuicidePriorAttempt', 'N')
            UpdateAutoSaveXmlNode('CustomHRMAssessments', 'SuicideCurrent', 'N');
            UpdateAutoSaveXmlNode('CustomHRMAssessments', 'SuicideIdeation', 'N');
            UpdateAutoSaveXmlNode('CustomHRMAssessments', 'SuicideActive', 'N');
            UpdateAutoSaveXmlNode('CustomHRMAssessments', 'SuicidePassive', 'N');
            UpdateAutoSaveXmlNode('CustomHRMAssessments', 'SuicideMeans', 'N');
            UpdateAutoSaveXmlNode('CustomHRMAssessments', 'SuicidePlan', 'N');
        }
    }
    else {
        $("[id^=TableSuicidality]").removeAttr("disabled");
        if (xmlDomInit5871.length == 0 && xmlDomInit5872.length == 0) {
            $("[id^=TextArea_CustomHRMAssessments_SuicideBehaviorsPastHistory]").removeAttr("disabled");
        }
    }
}

//Created by vikas kashyup - 8/Nov/2011- Ref Task 370- to disabled Psychiatric Advance Directives in child case.
function DisabledPsychiatricAdvanceDirectives(dom) {
    var domObject = null;
    var PsychiatricTable = $("#TablePsychiatricAdvanceDirective");
    //var AdvanceDirectiveTextbox = $("#TextArea_CustomHRMAssessments_AdvanceDirectiveNarrative");
    if (dom == undefined)
        domObject = AutoSaveXMLDom;
    else
        domObject = dom;
    if (domObject != undefined) {
        if ($("CustomHRMAssessments AdultOrChild", AutoSaveXMLDom).text() == 'C') {
            if (PsychiatricTable.length > 0)
                PsychiatricTable.hide();
            //if (AdvanceDirectiveTextbox.length > 0) {
            //    AdvanceDirectiveTextbox.attr("disabled", true);
            //    AdvanceDirectiveTextbox.val('');
            //}
        }
        else {
            if (PsychiatricTable.length > 0)
                PsychiatricTable.show();
            //if (AdvanceDirectiveTextbox.length > 0)
            //    AdvanceDirectiveTextbox.attr("disabled", false);
        }
    }
    else {
        if (PsychiatricTable.length > 0)
            PsychiatricTable.show();
        //if (AdvanceDirectiveTextbox.length > 0)
        //    AdvanceDirectiveTextbox.attr("disabled", false);

    }

}


function SetDiagnosisOrder(dom, action) {
    SetDiagnosisIAndIIHiddenOrderField(dom);
}



function FasProcessUnsaveRequest() {
    return;
}

// Added by Mahesh on 13-oct-2010 to Populate the values of the Custom Cafas Tab through Dom.
//Response received from the Fas Services and the session Data Merge is finally loaded into the Dom for filling the controls.

//function FasServicesCallBack(ResponseXml) {
//    var dom = $.xmlDOM(ResponseXml);
//    AutoSaveXMLDom = dom;
//    if (AutoSaveXMLDom[0].childNodes[0].getAttribute("xmlns:xsi") == null) {
//        AutoSaveXMLDom[0].childNodes[0].setAttribute("xmlns:xsi", 'http://www.w3.org/2001/XMLSchema-instance')
//    }
//    $('[id$=DropDownList_CustomCAFAS2_RaterClinician]')[0].selectedIndex = 0
//    SetFormValues(AutoSaveXMLDom, "HRMCAFAS");
//    CreateUnsavedChangesInstance();
//}



//Created by Sweety Kamboj
//To Show Level of Care description in div
//Modisified By : Shifali
//Modified Date : 22Feb,2011
//Modification Purpose : task# 4 of UM-2 in order to remove ADT Criterion/ Provider Qualifications
function ShowLevelofCareDiv(colname) {
    var height = 100;
    var width = 200;
    var colvalueDeterminDesc = $('#HiddenField_CustomHRMAssessments_DeterminationDescription').val();
    var colvalueLocDesc = $('#HiddenField_CustomHRMAssessments_Description').val();

    if (colname == "Description") {
        if (colvalueLocDesc != "")
            ShowMsgBox(colvalueLocDesc, 'Level of Care Description', MessageBoxButton.OK, MessageBoxIcon.Information, undefined, undefined, undefined, height, width);

    }

    else if (colname == "DeterminationDescription") {
        if (colvalueDeterminDesc != "")
            ShowMsgBox(colvalueDeterminDesc, 'Determination Description', MessageBoxButton.OK, MessageBoxIcon.Information, undefined, undefined, undefined, height, width);

    }

}

//Added By Davinder Kumar, Date : Mar 04, 2011.
function MentalStatusText(idAddToNeedsList) {

    try {
        var returnText = '';
        if (idAddToNeedsList.is(':checked')) {
            var id = idAddToNeedsList.attr('id');
            var blockId = idAddToNeedsList.attr('id').substring(8, id.indexOf('AddToNeedsList'));
            var controlCollection = $('[id*=' + blockId).not(idAddToNeedsList);
            var checkboxOther = 'CheckBox' + blockId + 'Other';

            if (controlCollection.length > 0) {

                controlCollection.each(function() {

                    var control = $(this);
                    if (control.attr('type') == 'checkbox') {
                        if (control.is(":checked") && checkboxOther != control.attr('id')) {

                            var label = control.parent().siblings(':first').find('label');
                            if (label.length > 0) {
                                if (returnText == '') {
                                    returnText = label.text();
                                }
                                else {
                                    returnText += ',' + label.text();
                                }
                            }
                        }
                    }
                    //Modified by vithobha, from .text to .val for Allegan 3.5 Implementation: #164 
                    else if (control.attr('type') == 'textarea') {
                        if (returnText == '') {
                            returnText = control.val();
                        }
                        else if (control.val() != '') {
                            returnText += ',' + control.val();
                        }
                    }
                });
            }
        }

        return returnText;
    }
    catch (err) {

    }
}




function SetValuesSUAssessment() {
    var needText = "";
    if ($("#CheckBox_CustomHRMAssessments_SubstanceUseNeedsList").is(":checked")) {

        if ($("#TextArea_CustomSubstanceUseAssessments_VoluntaryAbstinenceTrial").val() != "") {
            needText = $("#TextArea_CustomSubstanceUseAssessments_VoluntaryAbstinenceTrial").val();
        }

    }

    return needText;
}

function SetValuesRiskAssessmentCrisisPlaning() {
    var needText = "";
    if ($("#CheckBox_CustomHRMAssessments_CrisisPlanningNeedsList").is(":checked")) {

        if ($("#TextArea_CustomHRMAssessments_CrisisPlanningNarrative").val() != "") {
            needText = $("#TextArea_CustomHRMAssessments_CrisisPlanningNarrative").val();
        }

    }

    return needText;
}

function SetValuesRiskAssessmentAdvanceDirective() {
    var needText = "";
    if ($("#CheckBox_CustomHRMAssessments_AdvanceDirectiveNeedsList").is(":checked")) {

        if ($("#TextArea_CustomHRMAssessments_AdvanceDirectiveNarrative").val() != "") {
            needText = $("#TextArea_CustomHRMAssessments_AdvanceDirectiveNarrative").val();
        }

    }

    return needText;
}

//End


//This function added by Rakesh for Crafft tab
function SetEnableDisableCrafft(val, dom) {
    var RadioButtonCrafftQuestionC = $("input[type='radio'][name='RadioButton_CustomDocumentCRAFFTs_CrafftQuestionC']")
    var RadioButtonCrafftQuestionR = $("input[type='radio'][name='RadioButton_CustomDocumentCRAFFTs_CrafftQuestionR']")
    var RadioButtonCrafftQuestionA = $("input[type='radio'][name='RadioButton_CustomDocumentCRAFFTs_CrafftQuestionA']")
    var RadioButtonCrafftQuestionF = $("input[type='radio'][name='RadioButton_CustomDocumentCRAFFTs_CrafftQuestionF']")
    var RadioButtonCrafftQuestionFR = $("input[type='radio'][name='RadioButton_CustomDocumentCRAFFTs_CrafftQuestionFR']")
    var RadioButtonCrafftQuestionT = $("input[type='radio'][name='RadioButton_CustomDocumentCRAFFTs_CrafftQuestionT']")
    if (val == 'N') {
        RadioButtonCrafftQuestionC.attr("disabled", "disabled");
        RadioButtonCrafftQuestionR.attr("disabled", "disabled");
        RadioButtonCrafftQuestionA.attr("disabled", "disabled");
        RadioButtonCrafftQuestionF.attr("disabled", "disabled");
        RadioButtonCrafftQuestionFR.attr("disabled", "disabled");
        RadioButtonCrafftQuestionT.attr("disabled", "disabled");
    }
    if (val == 'Y') {
        RadioButtonCrafftQuestionC.removeAttr("disabled", "disabled");
        RadioButtonCrafftQuestionR.removeAttr("disabled", "disabled");
        RadioButtonCrafftQuestionA.removeAttr("disabled", "disabled");
        RadioButtonCrafftQuestionF.removeAttr("disabled", "disabled");
        RadioButtonCrafftQuestionFR.removeAttr("disabled", "disabled");
        RadioButtonCrafftQuestionT.removeAttr("disabled", "disabled");
    }
    //Code added by Loveena in ref to Task#984 Assessment->'Is UNCOPE applicable' field as 'Yes' is not retained.
    //CreateAutoSaveXml('CustomHRMAssessments', 'UncopeApplicable', val, dom);
}

//This function added by Rakesh for Crafft tab
function AddExtraTabCrafftEvent() {
    try {
        var SUAssessment_tab = tabobject.findTabByText('Substance Abuse');
        var Count = 0;
        //if (AssessmentTypeS != undefined && AssessmentTypeS.checked) {
        if (SUAssessment_tab != null) {
            //    ShowHideAssessmentHRMTab(SUAssessment_tab, false);
            //    $("#CheckBox_CustomDocumentCRAFFTs_CrafftCompleteFullSUAssessment").attr("disabled", true)
            //}
            //}
            //  else {
            if ($("#RadioButton_CustomDocumentCRAFFTs_CrafftQuestionC_Y").length > 0 && $("#RadioButton_CustomDocumentCRAFFTs_CrafftQuestionT_Y").length > 0) {
                if ($("#RadioButton_CustomDocumentCRAFFTs_CrafftQuestionC_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomDocumentCRAFFTs_CrafftQuestionR_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomDocumentCRAFFTs_CrafftQuestionA_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomDocumentCRAFFTs_CrafftQuestionF_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomDocumentCRAFFTs_CrafftQuestionFR_Y").attr("checked") == true) {
                    Count++;
                }
                if ($("#RadioButton_CustomDocumentCRAFFTs_CrafftQuestionT_Y").attr("checked") == true) {
                    Count++;
                }
            }
            else {
                //if the radio buttons are not yet loaded
                var CrafftXml = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDocumentCRAFFTs");
                if (CrafftXml.length > 0) {
                    var CraftNode = CrafftXml[0].selectNodes("CrafftQuestionC");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("CrafftQuestionR");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("CrafftQuestionA");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("CrafftQuestionF");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("CrafftQuestionFR");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                    CraftNode = CrafftXml[0].selectNodes("CrafftQuestionT");
                    if (CraftNode.length > 0) {
                        var Crafttext = CraftNode[0].text;
                        if (Crafttext == 'Y') {
                            Count++;
                        }
                    }
                }
            }


            if (Count > 2) {
                if (SUAssessment_tab != null) {
                    SUAssessment_tab.show();
                    SUAssessment_tab.set_visible(true);
                }
            }
            else {
                if ($("#CheckBox_CustomHRMAssessments_ClientInSAPopulation").length > 0) {
                    if ($("#CheckBox_CustomHRMAssessments_ClientInSAPopulation").attr("checked") != true) {
                        if (SUAssessment_tab != null) {
                            SUAssessment_tab.hide();
                            SUAssessment_tab.set_visible(false);
                        }
                    }
                }
                else if (SUAssessment_tab != null) {
                    SUAssessment_tab.hide();
                    SUAssessment_tab.set_visible(false);
                }
            }

            if ($("#CheckBox_CustomDocumentCRAFFTs_CrafftCompleteFullSUAssessment").length > 0) {
                if (($("#CheckBox_CustomDocumentCRAFFTs_CrafftCompleteFullSUAssessment").attr("checked") == true) && (Count < 3)) {
                    if (SUAssessment_tab != null) {
                        SUAssessment_tab.show();
                        SUAssessment_tab.set_visible(true);
                    }
                }
            }
        }
    }
    catch (ex) {
        throw ex;
    }
}

//This function added by Rakesh for Crafft tab
function callCRAFFT() {
    //Below Code added By Rakesh 
    var SUAssessment_tab = tabobject.findTabByText('Substance Abuse');
    //if (AssessmentTypeS != undefined && AssessmentTypeS.checked) {
    if (SUAssessment_tab != null) {
        //ShowHideAssessmentHRMTab(SUAssessment_tab, false);
        //$("#CheckBox_CustomDocumentCRAFFTs_CrafftCompleteFullSUAssessment").attr("disabled", true)
    }
    //}
    //Changes end here
    if (Crafftflag == 0) {
        $('#RadioButton_CustomDocumentCRAFFTs_CrafftApplicable_Y').attr("checked", false);
        $('#RadioButton_CustomDocumentCRAFFTs_CrafftApplicable_N').attr("checked", false);
        Crafftflag = 1;
        var CrafftXml = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDocumentCRAFFTs");
        if (CrafftXml.length > 0) {
            var CraftNode = CrafftXml[0].selectNodes("CrafftApplicable");
            if (CraftNode.length > 0) {
                var Crafttext = CraftNode[0].text;
                if (Crafttext == 'Y') {
                    $('#RadioButton_CustomDocumentCRAFFTs_CrafftApplicable_Y').attr("checked", true);
                    SetEnableDisableCrafft('Y', AutoSaveXMLDom);
                    CreateInitializationImages(AutoSaveXMLDom);
                }
                else {
                    $('#RadioButton_CustomDocumentCRAFFTs_CrafftApplicable_N').attr("checked", true);
                    SetEnableDisableCrafft('N', AutoSaveXMLDom);
                }
            }
        }

    }

}

//This function added by Rakesh for Crafft tab
function AddExtraTabCrafft(dom, EventCheck) {
    try {
        var _eventCalled = EventCheck;
        if (EventCheck == undefined)
            _eventCalled = "";

        // Code for Su Tab Visibility From Code.
        if (_eventCalled != "" && EventCheck != "N") {
            //Call Extra Function
            AddExtraTabCrafftEvent();
            return;
        }

        if (dom == undefined)
            dom = AutoSaveXMLDom;
        var xmlCustomDocumentCRAFFTsRow = null;
        if ((dom != "" && dom[0].childNodes[0].selectNodes("CustomDocumentCRAFFTs").length > 0)) {
            xmlCustomDocumentCRAFFTsRow = dom[0].childNodes[0].selectNodes("CustomDocumentCRAFFTs");
        }
        var SUAssessment_tab = tabobject.findTabByText('Substance Abuse');
        var Count = 0;

        if (xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionC").length > 0 && xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionC")[0].text.trim() == 'Y') {
            Count++;
        }
        if (xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionR").length > 0 && xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionR")[0].text.trim() == 'Y') {

            Count++;
        }
        if (xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionA").length > 0 && xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionA")[0].text.trim() == 'Y') {
            Count++;
        }
        if (xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionF").length > 0 && xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionF")[0].text.trim() == 'Y') {
            Count++;
        }
        if (xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionFR").length > 0 && xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionFR")[0].text.trim() == 'Y') {
            Count++;
        }
        if (xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionT").length > 0 && xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftQuestionT")[0].text.trim() == 'Y') {
            Count++;
        }

        var CheckBoxCompleteFullSUAssessmentValue = xmlCustomDocumentCRAFFTsRow[0].selectNodes("CrafftCompleteFullSUAssessment");
        if ((CheckBoxCompleteFullSUAssessmentValue.length > 0 && CheckBoxCompleteFullSUAssessmentValue[0].text.trim() == 'Y')) {
            if (SUAssessment_tab != null) {
                //SUAssessment_tab.show();
                ShowHideAssessmentHRMTab(SUAssessment_tab, true);
                UncopeCheck = true;
            }
        }
        else if (Count > 2) {
            if (SUAssessment_tab != null) {
                //SUAssessment_tab.show();
                ShowHideAssessmentHRMTab(SUAssessment_tab, true);
            }
        }
        else {
            if (SUAssessment_tab != null) {
                // SUAssessment_tab.hide();
                ShowHideAssessmentHRMTab(SUAssessment_tab, false);
                UncopeCheck = false;
            }

        }
    }
    catch (ex) {
        throw ex;
    }
}
//This function added by Rakesh for disable checkboxes for all in case screen
function EnableDisabeNeedListCheckBoxex(tabUserControlName) {
    //// if (AssessmentTypeS != undefined && AssessmentTypeS.checked) {
    //if (tabUserControlName == "HRMDDPsychosocial" || tabUserControlName == "HRMPsychosocialChild" || tabUserControlName == "HRMPsychosocialAdult") {
    //    $("input[type='checkbox'][Id$=NeedsList]").attr("disabled", "disabled");
    //}
    //else if (tabUserControlName == "HRMRiskAssessment") {
    //    $("input[type='checkbox'][Id$=NeedsList]").attr("disabled", "disabled");
    //}
    //else if (tabUserControlName == "HRMMentalStatus") {
    //    $("input[type='checkbox'][Id$=AddToNeedsList]").attr("disabled", "disabled");
    //}
    ////}

}

//added by Saurav Pande for Disposition tab
function CustomAjaxRequestCallback(result, CustomAjaxRequest) {
    var response = result;
    if (result.indexOf("###StartDisposition###") >= 0) {
        var start = result.indexOf("###StartDisposition###") + 22;
        var end = result.indexOf("###EndDisposition###");
        var str = result.substr(start, end - start);
        if (DispositionControl != null)
            DispositionControl.FillHTMLToControl(str);
    }
    else
        if (result.indexOf("###StartDispositionHTML###") >= 0) {
        var start = result.indexOf("###StartDispositionHTML###") + 26;
        var end = result.indexOf("###EndDispositionHTML###");
        var str = result.substr(start, end - start);
        if (DispositionControl != null)
            DispositionControl.FillHTMLToDropDowns(str);
    }

    var outputHTML = '';
    var pageDataSetXml = '';
    if (response != null && response != undefined && response != "") {
        if (response.indexOf("^pageDataSetXML=") > 0) {
            var splitPageResponse = response.split("^pageDataSetXML=");
            if (splitPageResponse.length > 0) {
                outputHTML = splitPageResponse[0];
                pageDataSetXml = splitPageResponse[1];

                //update pagedataset xml after custom ajax
                if (pageDataSetXml != "" && pageDataSetXml.indexOf("</DataSetDocumentMaster>") > 0) {

                    pageDataSetXml = pageDataSetXml.substr(0, pageDataSetXml.indexOf("</DataSetDocumentMaster>") + 24);

                    AutoSaveXMLDom = $.xmlDOM(pageDataSetXml);
                    if (AutoSaveXMLDom[0].childNodes[0].getAttribute("xmlns:xsi") == null) {
                        AutoSaveXMLDom[0].childNodes[0].setAttribute("xmlns:xsi", 'http://www.w3.org/2001/XMLSchema-instance')
                    }
                    // trigger the xml update event
                    $(document).triggerHandler('xmlchange');
                }
            }
        }
    }

    if (outputHTML.indexOf("###StartEditNeedDiscription###") >= 0) {
        RefreshNeedsTemplate(outputHTML, CustomAjaxRequest);
    }
    else if (outputHTML.indexOf("###StartDeleteNeedDiscription###") >= 0) {
        RefreshNeedsTemplate(outputHTML, CustomAjaxRequest);
    }
    else if (outputHTML.indexOf("###StartAddNeedsPopUp###") >= 0) {
        CloaseModalPopupWindow(outputHTML);
    }
    else if (outputHTML.indexOf("###StartAssociateNeedPopUp###") >= 0) {
        CloaseModalPopupWindow(outputHTML);
    }
}


function OpenAsamPopup() {
    OpenPage(5761, 10690, '', 2, GetRelativePath(), 'T', 'dialogHeight:570px; dialogWidth:860px;dialogTitle:ASAM;dialogcrossbutton:hide;')
}

/// Function added by Rakesh w.rf to task 20 
function SetPreviousAssessmentType() {
    if ($("#RadioButton_CustomHRMAssessments_AssessmentType_I")[0].checked == true) {
        previousAssessmentType = 'RadioButton_CustomHRMAssessments_AssessmentType_I';
    }
    else if ($("#RadioButton_CustomHRMAssessments_AssessmentType_U")[0].checked == true) {
        previousAssessmentType = 'RadioButton_CustomHRMAssessments_AssessmentType_U';
    }
    else if ($("#RadioButton_CustomHRMAssessments_AssessmentType_A")[0].checked == true) {
        previousAssessmentType = 'RadioButton_CustomHRMAssessments_AssessmentType_A';
    }
    //    else if ($("#RadioButton_CustomHRMAssessments_AssessmentType_S")[0].checked == true) {
    //        previousAssessmentType = 'RadioButton_CustomHRMAssessments_AssessmentType_S';
    //    }
    else {
        previousAssessmentType = "";
    }
}

function SetLableOnAssessmentDate() {
    //Code added by deepak rai
    //    if ($("#RadioButton_CustomHRMAssessments_AssessmentType_S").length > 0 && $("#RadioButton_CustomHRMAssessments_AssessmentType_S")[0].checked == true) {
    //        $("[id$=span_AssessmentDate]").html('Screen Date');
    //    }
    //    else {
    //        $("[id$=span_AssessmentDate]").html('Assessment Date');
    //    }
    // Change end here
}

///Code Added By Rakesh w.rf to task 658 in Kalmazoo bugs
//function EnableDisableCheckBox() {
//    var SUAssessment_tab = tabobject.findTabByText('Substance Abuse');
//    //if (AssessmentTypeS != undefined && AssessmentTypeS.checked) {
//    if (SUAssessment_tab != null) {
//        ShowHideAssessmentHRMTab(SUAssessment_tab, false);
//        $("#CheckBox_CustomHRMAssessments_UncopeCompleteFullSUAssessment").attr("disabled", true);
//        $("#CheckBox_CustomHRMAssessments_UncopeCompleteFullSUAssessment").attr("checked", false);
//    }
//    // }
//}

//function CustomizeToManageGroupForPencilIcon() {
//    return 'RadTabStrip1';
//}
function CustomTableFilterForPencilIcon() {
    if (typeof tabobject != 'undefined' || tabobject != undefined || tabobject != null || tabobject != "") {
        if (tabobject.get_selectedTab())
            var getTableNameAsPerSelectedTab = tabobject.get_selectedTab().get_text();
    }
}

function GetTabIndexOfSafetyCrisisPlan(objecttab) {
    for (var S = 0; S < tabobject.get_tabs()._array.length; S++) {
        if (tabobject.get_tabs()._array[S]._text == 'Safety/Crisis Plan' || tabobject.get_tabs()._array[S]._attributes._data.UcName == "PlanCrisisSafety") {
            SafetyCrisisPlanTabIndex = S;
        }
        if (tabobject.get_tabs()._array[S]._text == 'Gambling' || tabobject.get_tabs()._array[S]._attributes._data.UcName == "Gambling") {
            GamblingMainTabIndex = S;
        }
    }
}

function InitCustomDocumentSafetyCrisisPlans() {
    var _documentversionid;
    var _createdby;
    var _createddate;
    var _modifiedby;
    var _modifieddate;

    var TableLength = AutoSaveXMLDom.find("CustomDocumentSafetyCrisisPlans").length;
    if (TableLength == 0) {
        var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomDocumentSafetyCrisisPlans')); //Add Table
        _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
        _documentversionid.text = AutoSaveXMLDom.find("CustomHRMAssessments:first DocumentVersionId").text();
        _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
        _createdby.text = objectPageResponse.LoggedInUserCode;
        _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
        _createddate.text = ISODateString(new Date());
        _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
        _modifiedby.text = objectPageResponse.LoggedInUserCode;
        _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
        _modifieddate.text = ISODateString(new Date());
    }
    AddToUnsavedTables("CustomDocumentSafetyCrisisPlans");
}

function PlanCrisisSafety(dom) {
    $('[id$=PlanCrisisSafety]').css('overflow', 'hidden');
    var ClientHasCurrentCrisis = dom.find("CustomDocumentSafetyCrisisPlans:first ClientHasCurrentCrisis").text();
    if (ClientHasCurrentCrisis) {
        if (ClientHasCurrentCrisis == 'Y') {
            SafetyMultitabCrisis.GetTab(1).SetVisible(true);
        }
        else {
            SafetyMultitabCrisis.GetTab(1).SetVisible(false);
        }
    }
    else {
        SafetyMultitabCrisis.GetTab(1).SetVisible(false);
    }
}

showCurrentCrisis = (function(obj) {
    if (obj.checked) {
        SafetyMultitabCrisis.GetTab(1).SetVisible(true);
    }
    else {
        SafetyMultitabCrisis.GetTab(1).SetVisible(false);
    }
});

function AddParentChildEventHandler(containerTableName, callBackName) {
    if (containerTableName == 'TableChildControl_CustomSafetyCrisisPlanReviews') {
        $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y").attr('checked', 'checked');
        $('[section=CrisisDisposition]').hide();
    }
}

function AddParentChildRadioClickEventHandler(key, CustomScreenLockedValue, rowIndex, obj, customGridTableName, gridPageName, insertButtonId) {
    if (customGridTableName == 'TableChildControl_CustomSafetyCrisisPlanReviews') {
        if ($("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N").attr('checked')) {
            $('[section=CrisisDisposition]').show();
        }
        else {
            $('[section=CrisisDisposition]').hide();
        }
    }
}

function onChildTabSelected(sender, arg) {
    if (TabIndex == 15 || tabobject._selectedIndex == 15) {
        safetytabindex = selectedtab.index;
        TabIndex = tabobject._selectedIndex;
        onTabSelected(sender, arg, undefined);
    }
    if (TabIndex == 1 || tabobject._selectedIndex == 1) {
        GamblingSubtabindex = selectedtab.index;
        TabIndex = tabobject._selectedIndex;
    }
}

function GridRenderCallBackComplete(action, mode, ParentChildInsertGridName) {
    if (mode == 'GridCallback' && ParentChildInsertGridName == 'InsertGridSupportContacts') {
        $("#TableChildControl_CustomSupportContacts_ButtonInsert").val('Add');
    }
    else if (mode == 'GridCallback' && ParentChildInsertGridName == 'DivCustomGridCustomSafetyCrisisPlanReviews') {
        $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y").attr('checked', 'checked');
        $('[section=CrisisDisposition]').hide();
    }
}

function InsertCustomSupportContactsGridData() {
    if ($("[id$=DropDownList_ClientContactInformation_Name]").val() == '') {
        ShowHideErrorMessage("Please Select the Dropdown Entry before Clicking Add Button!", 'true');
        return false;
    }
    ShowHideErrorMessage("Please Select the Dropdown Entry before Clicking Add Button!", 'false');

    var ContactId = $('[id$=DropDownList_ClientContactInformation_Name] option:selected').val();

    var counter = 0;
    var trobject = $('tr .dxgvDataRow[id*=CustomGridSupportContacts_GridViewInsert_DXDataRow]');
    trobject.each(function() {
        if ($(this).children().eq(14)[0].innerText != "") {
            if (parseInt($(this).children().eq(14)[0].innerText) == parseInt(ContactId)) {
                counter++;
            }
        }
    });

    if (parseInt(counter) > 0) {
        ShowHideErrorMessage('Contact already exists.', 'true');
        return false;
    }
    ShowHideErrorMessage('Contact already exists.', 'false');

    var NewXML = $('[id$=HiddenFieldClientContactInformation]').val();
    var ContactInformation = GetAutoSaveXMLDomNode('ClientContactInformation', $.xmlDOM(NewXML));

    var items = ContactInformation.length > 0 ? $(ContactInformation).XMLExtract() : [];
    if (items.length > 0) {
        var item = ArrayHelpers.GetItem(items, ContactId, 'ClientContactId');

        var ScreenDataSetXmlDom = $.xmlDOM(objectPageResponse.ScreenDataSetXml);

        var tableName = "CustomSupportContacts";
        tableObject = $(tableName, ScreenDataSetXmlDom);
        var maxOrderSetAttributeId = 0;
        if (tableObject.length > 0)
            maxOrderSetAttributeId = parseInt(tableObject[tableObject.length - 1].selectSingleNode("SupportContactId").text);
        if (maxOrderSetAttributeId <= 0) {
            SupportContactId = maxOrderSetAttributeId - 1;
        }
        else {
            SupportContactId = -1;
        }

        XML = new String("<MainDataSet  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">");

        XML = XML + "<CustomSupportContacts>";
        XML = XML + "<SupportContactId>" + SupportContactId + "</SupportContactId>";
        XML = XML + "<DocumentVersionId>" + GetCurrentDocumentVersionID() + "</DocumentVersionId>";
        XML = XML + "<ClientContactId>" + ContactId + "</ClientContactId>";
        if (item.Name != undefined) {
            XML = XML + "<Name>" + item.Name + "</Name>";
        }
        if (item.RelationshipText != undefined) {
            XML = XML + "<Relationship>" + item.RelationshipText + "</Relationship>";
        }
        if (item.Address != undefined) {
            XML = XML + "<Address>" + item.Address + "</Address>";
        }
        if (item.Phone != undefined) {
            XML = XML + "<Phone>" + item.Phone + "</Phone>";
        }
        XML = XML + "</CustomSupportContacts>";
        XML = XML + "</MainDataSet>";

        gridTableName = 'TableChildControl_CustomSupportContacts';

        CallAjaxGridControl(XML, '#TableChildControl_CustomSupportContacts', 'InsertGridSupportContacts', 'CustomGridSupportContacts', 'CustomSupportContacts', 'ButtonInsert', undefined, undefined);
    }
}

function OpenContacts() {
    if (Dirty == "True" || UnsavedChangeId > 0) {
        ShowMsgBox('Please save the existing unsaved record for this screen prior to Open the Contacts', 'Confirmation', MessageBoxButton.OK, MessageBoxIcon.Information);
        return false;
    }
    else {
        OpenPage(5761, 3, 'ClientID=' + ClientID, null, GetRelativePath(), null, null, null, 2, null, null);
    }
}

function showCrisisDisposition(obj) {
    if (obj.checked && obj.value == 'Y') {
        $('[section=CrisisDisposition]').hide();
    }
    else if (obj.checked && obj.value == 'N') {
        $('[section=CrisisDisposition]').show();
    }
}

function CustomCustomSafetyCrisisPlanReviewsInsertGridData() {
    try {
        var Count = 0;
        var trobject = $('tr .dxgvDataRow[id*=CustomGridCustomSafetyCrisisPlanReviews_GridViewInsert_DXDataRow]');
        trobject.each(function() {
            Count = Count + 1;
        });

        if (Count > 0 && $('[id$=TableChildControl_CustomSafetyCrisisPlanReviews_ButtonInsert]').val() == 'Insert') {

            //$("[Id=TableChildControl_CustomSafetyCrisisPlanReviews_ButtonInsert]").attr("disabled", true);
            ShowHideErrorMessage("More than one Saftey/Crisis Plan Review can not be added", 'true');
            return false;
        }
        if (Count > 1 && $('[id$=TableChildControl_CustomSafetyCrisisPlanReviews_ButtonInsert]').val() == 'Modify') {

            //$("[Id=TableChildControl_CustomSafetyCrisisPlanReviews_ButtonInsert]").attr("disabled", true);
            ShowHideErrorMessage("More than one Saftey/Crisis Plan Review can not be added", 'true');
            return false;
        }
        var CrisisResolved = $('[id$=CheckBox_CustomSafetyCrisisPlanReviews_CrisisResolved').attr('checked');
        if (CrisisResolved == true) {

            $("[id$=HiddenField_CustomSafetyCrisisPlanReviews_CrisisResolvedText]").val('Yes');
        }
        else {
            $("[id$=HiddenField_CustomSafetyCrisisPlanReviews_CrisisResolvedText]").val('No')
        }
        $('#HiddenField_CustomSafetyCrisisPlanReviews_DocumentVersionId').val(AutoSaveXMLDom.find("CustomDocumentSafetyCrisisPlans:first DocumentVersionId").text());

        if ($("[id$=TextBox_CustomSafetyCrisisPlanReviews_DateReviewed]").val().trim().length == 0) {
            ShowHideErrorMessage("Safety Plan - Safety Plan Reviewed On - Date Reviewed is required", 'true');
            return false;
        }
        ShowHideErrorMessage("Safety Plan - Safety Plan Reviewed On - Date Reviewed is required", 'false');

        if ($("[id$=TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays]").val().trim().length == 0) {
            ShowHideErrorMessage("Safety Plan – Safety Plan Reviewed On - Review Every X Days is required", 'true');
            return false;
        }
        ShowHideErrorMessage("Safety Plan – Safety Plan Reviewed On - Review Every X Days is required", 'false');

        if ($('#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N').attr('checked')) {
            if (parseInt($("[id$=TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays]").val().trim()) > 0 && parseInt($("[id$=TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays]").val().trim()) < 181) {
                ShowHideErrorMessage('“Review Every” number must be between 1 and 180', 'false');
            }
            else {
                ShowHideErrorMessage('“Review Every” number must be between 1 and 180', 'true');
                return false;
            }
        }

        if ($('#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y').attr('checked')) {
            if (parseInt($("[id$=TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays]").val().trim()) > 0 && parseInt($("[id$=TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays]").val().trim()) < 181) {
                ShowHideErrorMessage('“Review Every” number must be between 1 and 180', 'false');
            }
            else {
                ShowHideErrorMessage('“Review Every” number must be between 1 and 180', 'true');
                return false;
            }
        }

        if ($("[id$=TextArea_CustomSafetyCrisisPlanReviews_DescribePlanReview]").val().trim().length == 0) {
            ShowHideErrorMessage("Safety Plan - Safety/Crisis Plan Reviewed On - Describe Plan Review is required", 'true');
            return false;
        }
        ShowHideErrorMessage("Safety Plan - Safety/Crisis Plan Reviewed On - Describe Plan Review is required", 'false');

        if ($('#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N').attr('checked')) {
            if ($("[id$=TextArea_CustomSafetyCrisisPlanReviews_CrisisDisposition]").val().trim().length == 0) {
                ShowHideErrorMessage("Safety Plan - Safety/Crisis Plan Reviewed On - Crisis Disposition is required", 'true');
                return false;
            }
        }
        ShowHideErrorMessage("Safety Plan - Safety/Crisis Plan Reviewed On - Crisis Disposition is required", 'false');

        if ($('#TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays').val())
            $('#HiddenField_CustomSafetyCrisisPlanReviews_ReviewEveryDaysText').val($('#TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays').val() + ' Days');
        else
            $('#HiddenField_CustomSafetyCrisisPlanReviews_ReviewEveryDaysText').val('');

        InsertGridData('TableChildControl_CustomSafetyCrisisPlanReviews', 'DivCustomGridCustomSafetyCrisisPlanReviews', 'CustomGridCustomSafetyCrisisPlanReviews', $('#TableChildControl_CustomSafetyCrisisPlanReviews_ButtonInsert')[0]);
    }
    catch (ex) {

    }
}

function InsertCrisisPlanMedicalProviders() {
    $('#HiddenField_CustomCrisisPlanMedicalProviders_DocumentVersionId').val(AutoSaveXMLDom.find("CustomHRMAssessments:first DocumentVersionId").text());
    //$('#HiddenField_CustomCrisisPlanMedicalProviders_AddressTypeText').val($('[id$=DropDownList_CustomCrisisPlanMedicalProviders_AddressType] :selected').text());
    var validatecount = 0;
    if ($('#TextBox_CustomCrisisPlanMedicalProviders_Name').val().trim().length == 0)
        validatecount++;
    if ($('[id$=DropDownList_CustomCrisisPlanMedicalProviders_AddressType] :selected').val().trim().length == 0)
        validatecount++;
    if ($('[ID$=Textbox_CustomCrisisPlanMedicalProviders_Address]').val().trim().length == 0)
        validatecount++;
    if ($('#Textbox_CustomCrisisPlanMedicalProviders_Phone').val().trim().length == 0)
        validatecount++;
    if (validatecount == 4)
        return false;

    InsertGridData('TableChildControl_CustomCrisisPlanMedicalProviders', 'InsertGrid_CustomCrisisPlanMedicalProviders', 'CustomGrid_CustomCrisisPlanMedicalProviders', $('#TableChildControl_CustomCrisisPlanMedicalProviders_ButtonInsert')[0]);
}

function InsertCrisisPlanNetworkProviders() {
    $('#HiddenField_CustomCrisisPlanNetworkProviders_DocumentVersionId').val(AutoSaveXMLDom.find("CustomHRMAssessments:first DocumentVersionId").text());
    //$('#HiddenField_CustomCrisisPlanNetworkProviders_AddressTypeText').val($('[id$=DropDownList_CustomCrisisPlanNetworkProviders_AddressType] :selected').text());
    var validatecount = 0;
    if ($('#TextBox_CustomCrisisPlanNetworkProviders_Name').val().trim().length == 0)
        validatecount++;
    if ($('[id$=DropDownList_CustomCrisisPlanNetworkProviders_AddressType] :selected').val().trim().length == 0)
        validatecount++;
    if ($('[ID$=TextBox_CustomCrisisPlanNetworkProviders_Address]').val().trim().length == 0)
        validatecount++;
    if ($('#TextBox_CustomCrisisPlanNetworkProviders_Phone').val().trim().length == 0)
        validatecount++;
    if (validatecount == 4)
        return false;

    InsertGridData('TableChildControl_CustomCrisisPlanNetworkProviders', 'InsertGrid_CustomCrisisPlanNetworkProviders', 'CustomGrid_CustomCrisisPlanNetworkProviders', $('#TableChildControl_CustomCrisisPlanNetworkProviders_ButtonInsert')[0]);
}

function safetyCrisisPlanReviewFilter(obj, mode) {
    try {
        var filtermode = mode;

        if ($(obj).attr('checked') && $(obj).attr('id') == "CheckBox_CustomDocumentSafetyCrisisPlans_ThreeMonths") {
            if ($('#CheckBox_CustomDocumentSafetyCrisisPlans_TwelveMonths').attr('checked')) {
                filtermode = '12months';
            }
        }
        else if ($(obj).attr('checked') == false && $(obj).attr('id') == "CheckBox_CustomDocumentSafetyCrisisPlans_ThreeMonths") {
            filtermode = '';
            if ($('#CheckBox_CustomDocumentSafetyCrisisPlans_TwelveMonths').attr('checked')) {
                filtermode = '12months';
            }
        }
        else if ($(obj).attr('checked') == false && $(obj).attr('id') == "CheckBox_CustomDocumentSafetyCrisisPlans_TwelveMonths") {
            filtermode = '';
            if ($('#CheckBox_CustomDocumentSafetyCrisisPlans_ThreeMonths').attr('checked')) {
                filtermode = '3months';
            }
        }

        if (filtermode != '') {
            $.ajax({
                type: "POST",
                async: false,
                url: _ApplicationBasePath + "Custom/Assessment/WebPages/AjaxHRMSupport.aspx?functionName=SafetyCrisisPlanReviewFilter&FilterMonth=" + filtermode,
                success: function(result) {
                    if (result != "")
                        onSuccessSafetyCrisisPlanReviewFilter("isnull(convert(DateReviewed,'System.DateTime'),'01/01/1900') >= '" + result + "'");
                    else
                        onSuccessSafetyCrisisPlanReviewFilter('');
                }
            });
        }
        else {
            onSuccessSafetyCrisisPlanReviewFilter('');
        }
    }
    catch (err) {
    }
}

function onSuccessSafetyCrisisPlanReviewFilter(result) {
    try {
        RefreshParentChildGrid('SafetyCrisisPlanReviewId', 'DivCustomGridCustomSafetyCrisisPlanReviews', 'CustomGrid', 'CustomSafetyCrisisPlanReviews', 'TableChildControl_CustomSafetyCrisisPlanReviews', result, "CustomGridCustomSafetyCrisisPlanReviews", false);
    }
    catch (err) {
    }
}

function maxCheckLength(field, maxChars) {
    if (field.value.length >= maxChars) {
        event.returnValue = false;
        return false;
    }
}

function maxCheckLengthPaste(field, maxChars) {
    event.returnValue = false;
    if (window.clipboardData != undefined && (field.value.length + window.clipboardData.getData("Text").length) > maxChars) {
        return false;
    }
    event.returnValue = true;
}

function LoadTabPageCallBackComplete(tabClickSender, title, tabUserControlName, selectedTabId, functionname) {
}

function ValidateDataForParentChildGridEventHandler() {
    try {
        if (tabUserControlName == "FamilyHistory") {
            var FamilyMemberType = $('[id$=DropDownList_DocumentFamilyHistory_FamilyMemberType] option:selected').val();

            var counter = 0;
            var trobject = $('tr .dxgvDataRow[id*=CustomGridDocumentFamilyHistory_GridViewInsert_DXDataRow]');
            trobject.each(function() {
                if ($(this).children().eq(15)[0].innerText != "") {
                    if (parseInt($(this).children().eq(15)[0].innerText) == parseInt(FamilyMemberType)) {
                        counter++;
                    }
                }
            });

            if (parseInt(counter) == 0) {
                if ($('[id$=RadioButton_DocumentFamilyHistory_IsLiving_Y]').attr('checked')
        || $('[id$=RadioButton_DocumentFamilyHistory_IsLiving_N]').attr('checked')
        || $('[id$=RadioButton_DocumentFamilyHistory_IsLiving_U]').attr('checked')) {
                    ShowHideErrorMessage('Family Med Hx-Family history -living status is required.', 'false');
                }
                else {
                    ShowHideErrorMessage('Family Med Hx-Family history -living status is required.', 'true');
                    return false;
                }
            }

            if ($('[id$=RadioButton_DocumentFamilyHistory_IsLiving_N]').attr('checked')) {
                if ($('[id$=Textbox_DocumentFamilyHistory_CauseOfDeath]').val() == '') {
                    ShowHideErrorMessage('Family Med Hx-Family history- If Deceased, cause of death is required.', 'true');
                    return false;
                }
                else {
                    ShowHideErrorMessage('Family Med Hx-Family history- If Deceased, cause of death is required.', 'false');

                }
            }
            else {
                ShowHideErrorMessage('Family Med Hx-Family history- If Deceased, cause of death is required.', 'false');
            }

        }
        return true;
    }

    catch (err) {
        LogClientSideException(err);
    }

}
//function InsertCustomFamilyHistoryGridData() {
//    var FamilyMemberType = $('[id$=DropDownList_CustomFamilyHistory_FamilyMemberType] option:selected').val();

//    var counter = 0;
//    var trobject = $('tr .dxgvDataRow[id*=CustomGridCustomFamilyHistory_GridViewInsert_DXDataRow]');
//    trobject.each(function () {
//        if ($(this).children().eq(15)[0].innerText != "") {
//            if (parseInt($(this).children().eq(15)[0].innerText) == parseInt(FamilyMemberType)) {
//                counter++;
//            }
//        }
//    });

//    if (parseInt(counter) == 0) {
//        if ($('[id$=RadioButton_CustomFamilyHistory_IsLiving_Y]').attr('checked')
//        || $('[id$=RadioButton_CustomFamilyHistory_IsLiving_N]').attr('checked')
//        || $('[id$=RadioButton_CustomFamilyHistory_IsLiving_U]').attr('checked')) {
//            ShowHideErrorMessage('Family Med Hx-Family history -living status is required.', 'false');
//        }
//        else {
//            ShowHideErrorMessage('Family Med Hx-Family history -living status is required.', 'true');
//            return false;
//        }
//    }

//    if ($('[id$=RadioButton_CustomFamilyHistory_IsLiving_N]').attr('checked')) {
//        if ($('[id$=Textbox_CustomFamilyHistory_CauseOfDeath]').val() == '') {
//            ShowHideErrorMessage('Family Med Hx-Family history- If Deceased, cause of death is required.', 'true');
//            return false;
//        }
//        else {
//            ShowHideErrorMessage('Family Med Hx-Family history- If Deceased, cause of death is required.', 'false');

//        }
//    }
//    else {
//        ShowHideErrorMessage('Family Med Hx-Family history- If Deceased, cause of death is required.', 'false');
//    }
//    InsertGridData('TableChildControl_CustomFamilyHistory', 'DivCustomGridFamilyHistory', 'CustomGridCustomFamilyHistory', $('#TableChildControl_CustomFamilyHistory_ButtonInsert')[0]);
//}

function EnableDisableTextArea(obj, dom) {
    var ReductionInSymptomsDescriptionObject = $("textarea[id$=TextArea_CustomHRMAssessments_ReductionInSymptomsDescription]");
    var AttainmentOfHigherFunctioningDescriptionObject = $("textarea[id$=TextArea_CustomHRMAssessments_AttainmentOfHigherFunctioningDescription]");
    var TreatmentNotNecessaryDescriptionObject = $("textarea[id$=TextArea_CustomHRMAssessments_TreatmentNotNecessaryDescription]");
    var OtherTransitionCriteriaDescriptionObject = $("textarea[id$=TextArea_CustomHRMAssessments_OtherTransitionCriteriaDescription]");

    if (obj.id.toString() == 'CheckBox_CustomHRMAssessments_ReductionInSymptoms') {
        if ($(ReductionInSymptomsDescriptionObject).length > 0) {
            if ($(obj).is(':checked')) {
                $(ReductionInSymptomsDescriptionObject).closest("tr").show();
            }
            else {
                $(ReductionInSymptomsDescriptionObject).val("");
                CreateAutoSaveXml('CustomHRMAssessments', 'ReductionInSymptomsDescription', '');
                $(ReductionInSymptomsDescriptionObject).closest("tr").hide();
            }
        }
    }
    else if (obj.id.toString() == 'CheckBox_CustomHRMAssessments_AttainmentOfHigherFunctioning') {
        if ($(AttainmentOfHigherFunctioningDescriptionObject).length > 0) {
            if ($(obj).is(':checked')) {
                $(AttainmentOfHigherFunctioningDescriptionObject).closest("tr").show();
            }
            else {
                $(AttainmentOfHigherFunctioningDescriptionObject).val("");
                CreateAutoSaveXml('CustomHRMAssessments', 'AttainmentOfHigherFunctioningDescription', '');
                $(AttainmentOfHigherFunctioningDescriptionObject).closest("tr").hide();
            }
        }
    }
    else if (obj.id.toString() == 'CheckBox_CustomHRMAssessments_TreatmentNotNecessary') {
        if ($(TreatmentNotNecessaryDescriptionObject).length > 0) {
            if ($(obj).is(':checked')) {
                $(TreatmentNotNecessaryDescriptionObject).closest("tr").show();
            }
            else {
                $(TreatmentNotNecessaryDescriptionObject).val("");
                CreateAutoSaveXml('CustomHRMAssessments', 'TreatmentNotNecessaryDescription', '');
                $(TreatmentNotNecessaryDescriptionObject).closest("tr").hide();
            }
        }
    }
    else if (obj.id.toString() == 'CheckBox_CustomHRMAssessments_OtherTransitionCriteria') {
        if ($(OtherTransitionCriteriaDescriptionObject).length > 0) {
            if ($(obj).is(':checked')) {
                $(OtherTransitionCriteriaDescriptionObject).closest("tr").show();
            }
            else {
                $(OtherTransitionCriteriaDescriptionObject).val("");
                CreateAutoSaveXml('CustomHRMAssessments', 'OtherTransitionCriteriaDescription', '');
                $(OtherTransitionCriteriaDescriptionObject).closest("tr").hide();
            }
        }
    }
}

function GotoGetASAM() {
    try {
        PopupProcessing();
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/Assessment/WebPages/AjaxHRMSupport.aspx?functionName=GetASAM",
            data: '',
            success: function(result) {
                HidePopupProcessing();
                if (result != '') {
                    if (result != 'No ASAM') {
                        CreateAutoSaveXml('CustomHRMAssessments', 'ClinicalSummary', result);
                        $("#TextArea_CustomHRMAssessments_ClinicalSummary").val(result);
                    }
                }
                else {
                    GotoGetASAM();
                }
            }
        });
    }
    catch (err) { }
}


function UpdateNeedsXML(needid, value) {
}

function enableTextArea(obj) {
    if (obj.id.toString() == 'RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_Y') {
        if ($(obj).is(':checked')) {
            if ($('#TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason').is(':disabled')) {
                $('#TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason').attr("disabled", false);
            }
        }
    }
    else if (obj.id.toString() == 'RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_N') {
        if ($(obj).is(':checked')) {
            if ($('#TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason').is(':disabled')) {
                $('#TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason').attr("disabled", false);
            }
        }
    }
    else if (obj.id.toString() == 'RadioButton_CustomSubstanceUseAssessments_MedicationAssistedTreatment_A') {
        if ($(obj).is(':checked')) {
            CreateAutoSaveXml('CustomSubstanceUseAssessments', 'MedicationAssistedTreatmentRefferedReason', "");
            $('[id$=TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason]').val("");
            $('#TextArea_CustomSubstanceUseAssessments_MedicationAssistedTreatmentRefferedReason').attr("disabled", true);
        }
    }
    else {
    }
}


ISODateString = (function(dateIn) {
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

function ReInitializeSafetyPlan(ControlID) {


    var AssessmentScreenType;
    //    if ($("#RadioButton_CustomHRMAssessments_AssessmentType_I")[0].checked == true) {
    //        AssessmentScreenType = 'AssessmentScreenType=I';
    //    }
    //    else if ($("#RadioButton_CustomHRMAssessments_AssessmentType_U")[0].checked == true) {
    //        AssessmentScreenType = 'AssessmentScreenType=U';
    //    }
    //    else if ($("#RadioButton_CustomHRMAssessments_AssessmentType_A")[0].checked == true) {
    //        AssessmentScreenType = 'AssessmentScreenType=A';
    //    }
    //    //        else if ($("#RadioButton_CustomHRMAssessments_AssessmentType_S")[0].checked == true) {
    //    //            AssessmentScreenType = 'AssessmentScreenType=S';
    //    //        }
    //    else {
    //    }
    //SetLableOnAssessmentDate();
    //Below Call Function SetPreviousAssessmentType() Added By Rakesh w.rf to task 20 in Assessment1
    //SetPreviousAssessmentType();
    //Changes end here
    //    var documentRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("Documents");
    //    documentRowFilter = 'AuthorId';
    //    var docummentRowDomFilter = $(documentRowFilter, documentRow[0]);

    //    var _currentAuthorId = -1;
    //    if (docummentRowDomFilter.length > 0) {
    //        _currentAuthorId = documentRow[0].selectNodes("AuthorId")[0].text;
    //    }


    //    if (docummentRowDomFilterCheckBoxDom.length > 0) {
    //        var _currentAuthorId = documentRow[0].selectNodes("AuthorId")[0].text;

    //    }
    //documentRowFilterCheckBoxDom = 'InitialSafetyPlan';
    //var SafetyInitialorReview;
    //parent.PopupProcessing();
    if (ControlID == 'Y') {
        SafetyInitialorReview = 'SafetyInitialorReview=Y';
        CreateAutoSaveXml('CustomDocumentSafetyCrisisPlans', 'InitialSafetyPlan', 'Y');
        $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N").attr('checked', 'checked');
        $('[section=trSafetyReviewed]').hide();
    }
    else if (ControlID == 'N') {
        SafetyInitialorReview = 'SafetyInitialorReview=N';
        $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y").attr('checked', 'checked');
        CreateAutoSaveXml('CustomDocumentSafetyCrisisPlans', 'InitialSafetyPlan', 'N');
        $('[section=trSafetyReviewed]').show();
    }
    //    var _filterData = "UnsavedChangeId=" + UnsavedChangeId;

    //    _filterData = _filterData + '^' + AssessmentScreenType + '^' + SafetyInitialorReview + '^ReIntialization=Y' + '^CurrentAuthorId=' + _currentAuthorId;
    //    _reinitializeTabs = true;
    //    LoadDocument(GetCurrentScreenID(), 5763, _filterData, CurrentHistoryId, GetRelativePath(), pageActionEnum.New, null, false, 21);
    //    CreateInitializationImages(AutoSaveXMLDom);
}
function ReInitializeCrisisPlan(ControlID) {

    //    documentRowFilterCheckBoxDom = 'InitialSafetyPlan';
    //    var CrisisInitialorReview;
    //    parent.PopupProcessing();
    if (ControlID == 'Y') {
        CrisisInitialorReview = 'CrisisInitialorReview=Y';
        CreateAutoSaveXml('CustomDocumentSafetyCrisisPlans', 'InitialCrisisPlan', 'Y');


    }
    else if (ControlID == 'N') {
        CrisisInitialorReview = 'CrisisInitialorReview=N';
        CreateAutoSaveXml('CustomDocumentSafetyCrisisPlans', 'InitialCrisisPlan', 'N');

    }
    //var _filterData = "UnsavedChangeId=" + UnsavedChangeId;

    // _filterData = _filterData + '^' + CrisisInitialorReview + '^ReIntialization=Y';
    // _reinitializeTabs = true;
    //LoadDocument(GetCurrentScreenID(), 5763, _filterData, CurrentHistoryId, GetRelativePath(), pageActionEnum.New, null, false, 21);
    // CreateInitializationImages(AutoSaveXMLDom);
}



//Gambling Tab validations

function ValidateGamblingTabControls() {
    var selectedValue;
    if ($("[id*=DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol]").length > 0) {
        selectedValue = $("select[id*=DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForAlcohol] :selected").text().toLowerCase();
        if (selectedValue == "yes") {
            $('#RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD_Y').attr("disabled", false);
            $('#RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD_N').attr("disabled", false);
            $('#RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD_Y').attr("disabled", false);
            $('#RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD_N').attr("disabled", false);

        }
        else {
            $('#RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD_Y').attr("disabled", true);
            $('#RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD_N').attr("disabled", true);
            $('input[name=RadioButton_CustomDocumentGambling_AlcoholInpatientAAndD]').attr('checked', false);
            $('#RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD_Y').attr("disabled", true);
            $('#RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD_N').attr("disabled", true);
            $('input[name=RadioButton_CustomDocumentGambling_AlcoholOutpatientAAndD]').attr('checked', false);

        }

        selectedValue = $("select[id*=DropDownList_CustomDocumentGambling_EnrolledInTreatmentProgramForMentalHealth] :selected").text().toLowerCase();
        if (selectedValue == "yes") {
            $('#RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD_Y').attr("disabled", false);
            $('#RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD_N').attr("disabled", false);
            $('#RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD_Y').attr("disabled", false);
            $('#RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD_N').attr("disabled", false);

        }
        else {
            $('#RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD_Y').attr("disabled", true);
            $('#RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD_N').attr("disabled", true);
            $('input[name=RadioButton_CustomDocumentGambling_MentalHealthInpatientAAndD]').attr('checked', false);
            $('#RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD_Y').attr("disabled", true);
            $('#RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD_N').attr("disabled", true);
            $('input[name=RadioButton_CustomDocumentGambling_MentalHealthOutpatientAAndD]').attr('checked', false);

        }

        selectedValue = $("select[id*=DropDownList_CustomDocumentGambling_EnrolledInAnotherGamblingProgram] :selected").text().toLowerCase();
        if (selectedValue == "yes") {
            $('#RadioButton_CustomDocumentGambling_GamblingInpatientAAndD_Y').attr("disabled", false);
            $('#RadioButton_CustomDocumentGambling_GamblingInpatientAAndD_N').attr("disabled", false);
            $('#RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD_Y').attr("disabled", false);
            $('#RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD_N').attr("disabled", false);

        }
        else {
            $('#RadioButton_CustomDocumentGambling_GamblingInpatientAAndD_Y').attr("disabled", true);
            $('#RadioButton_CustomDocumentGambling_GamblingInpatientAAndD_N').attr("disabled", true);
            $('input[name=RadioButton_CustomDocumentGambling_GamblingInpatientAAndD]').attr('checked', false);
            $('#RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD_Y').attr("disabled", true);
            $('#RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD_N').attr("disabled", true);
            $('input[name=RadioButton_CustomDocumentGambling_GamblingOutpatientAAndD]').attr('checked', false);

        }
    }

}




//Modified the TabNavigate as required in Assessment module.This can be removed once we get the core fix
//Please refer the TabNavigate function from ApplicationCommonFunctions for any future modifications 
function TabNavigate() {
    if (CurrentScreenId != 10018)
    //Core Code to be called on navigate to other screens else custom code
    {
        //EI#564 - Implement Verbose Mode Logging in SmartCare Application
        EventTrap("ApplicationCommonFunctions", "TabNavigate", "");

        var hiddenFieldHistoryXML = $('input[id$=hiddenFieldHistoryXML]');
        var dom = $.xmlDOM(hiddenFieldHistoryXML.val().replace(/&/g, "&amp;"));
        var HisId;
        var HisArray;
        HisId = scrollHistoryId;
        if (HisId != undefined) {
            if (dom.find("History[Id=" + HisId + "] TabTree").text() != '') {
                var jsonTreeObj = $.parseJSON(decodeText(dom.find("History[Id=" + HisId + "] TabTree").text()));
                if (jsonTreeObj.length > 1) {
                    if (CurrentScreenId == 29 && ShowInViewMode != true) {
                        if (($.parseJSON(dom.find("History[Id=" + HisId + "] UnsavedChangeId").text()) > 0 || $('#Span_DocumentInformation_Status').text() != 'New') && $('[id$=DropDownList_Services_ProcedureCodeId]').val() != 0) {
                            $.each(jsonTreeObj, function (index, val) {
                                if (index < 2) {
                                    if (this.TabType == 'DevEx') {
                                        if (objectPageResponse.ServiceStatusConcurrency || objectPageResponse.ServiceCommentConcurrency) {
                                            eval(this.Id).RaiseTabClick(0, onTabSelected);
                                            eval(this.Id).SetActiveTab(eval(this.Id).tabs[0]);
                                        }
                                        else {
                                            eval(this.Id).RaiseTabClick(this.ActiveTabIndex, onTabSelected);
                                            eval(this.Id).SetActiveTab(eval(this.Id).tabs[this.ActiveTabIndex]);
                                        }
                                    }
                                    else {
                                        $find(this.Id).get_allTabs()[this.ActiveTabIndex].click();
                                    }
                                    if (jsonTreeObj[0].ActiveTabIndex != 3) {
                                        TabUcPath = this.Path;
                                    }
                                }
                            });
                        }
                    }
                    else {
                        if (CurrentScreenId != 32 && ShowInViewMode != true) {
                            if (jsonTreeObj[1].TabType == 'DevEx') {
                                eval(jsonTreeObj[1].Id).RaiseTabClick(jsonTreeObj[1].ActiveTabIndex, onTabSelected);
                                eval(jsonTreeObj[1].Id).SetActiveTab(eval(jsonTreeObj[1].Id).tabs[jsonTreeObj[1].ActiveTabIndex]);
                            }
                            else {
                                $find(jsonTreeObj[1].Id).get_allTabs()[jsonTreeObj[1].ActiveTabIndex].click();
                            }
                        }
                    }
                }
                else if (jsonTreeObj.length == 1) {
                    if (CurrentScreenId == 29 && ShowInViewMode != true) {
                        if (($.parseJSON(dom.find("History[Id=" + HisId + "] UnsavedChangeId").text()) > 0 || $('#Span_DocumentInformation_Status').text() != 'New') && $('[id$=DropDownList_Services_ProcedureCodeId]').val() != 0) {
                            $.each(jsonTreeObj, function (index, val) {
                                if (this.TabType == 'DevEx') {
                                    if (objectPageResponse.ServiceStatusConcurrency || objectPageResponse.ServiceCommentConcurrency) {
                                        eval(this.Id).RaiseTabClick(0, onTabSelected);
                                        eval(this.Id).SetActiveTab(eval(this.Id).tabs[0]);
                                    }
                                    else {
                                        eval(this.Id).RaiseTabClick(this.ActiveTabIndex, onTabSelected);
                                        eval(this.Id).SetActiveTab(eval(this.Id).tabs[this.ActiveTabIndex]);
                                    }
                                }
                                else {
                                    $find(this.Id).get_allTabs()[this.ActiveTabIndex].click();
                                }
                                TabUcPath = this.Path;
                            });
                        }
                    }
                }
            }
        }
        //EI#593 - Retain scroll position
        if (HisId == undefined)
            HisId = CurrentHistoryId;
        var scrollPositionWithDivIds = dom.find("History[Id=" + HisId + "] LastOpenedTabScrollPosition").text();
        if (scrollPositionWithDivIds != "") {
            var DivArray = scrollPositionWithDivIds.split('~');
            for (var i = 0; i < DivArray.length; i++) {
                if (DivArray[i] != "") {
                    var divIds = DivArray[i].split('=');
                    var divid = divIds[0];
                    if (divid && divid != "") {
                        var scrollPosition = divIds[1];
                        scrollPosition = scrollPosition ? scrollPosition : 0;
                        if (divid != undefined && divid != "" && scrollPosition > 0) {
                            document.getElementById(divid).scrollTop = scrollPosition;
                        }
                    }
                }
            }
        }
    }

    else {
        var hiddenFieldHistoryXML = $('input[id$=hiddenFieldHistoryXML]');
        var dom = $.xmlDOM(hiddenFieldHistoryXML.val().replace(/&/g, "&amp;"));
        var HisId;
        var HisArray;
        HisId = scrollHistoryId;
        
        if (HisId == undefined)
            HisId = CurrentHistoryId;
        var scrollPositionWithDivIds = dom.find("History[Id=" + HisId + "] LastOpenedTabScrollPosition").text();
        if (scrollPositionWithDivIds != "") {
            var DivArray = scrollPositionWithDivIds.split('~');
            for (var i = 0; i < DivArray.length; i++) {
                if (DivArray[i] != "") {
                    var divIds = DivArray[i].split('=');
                    var divid = divIds[0];
                    if (divid && divid != "") {
                        var scrollPosition = divIds[1];
                        scrollPosition = scrollPosition ? scrollPosition : 0;
                        if (divid != undefined && divid != "" && scrollPosition > 0) {
                            document.getElementById(divid).scrollTop = scrollPosition;
                        }
                    }
                }
            }
        }
    }
}


function HidePopupProcessing() {
    try {
        if (CurrentScreenId != 10018) {
            var PopupBehavior = $find('ModalPopupBehavior');
            if (PopupBehavior != null)
                PopupBehavior.hide();
        }
        else {
            if (!HideProcessing) { return; }

            var PopupBehavior = $find('ModalPopupBehavior');
            if (PopupBehavior != null)
                PopupBehavior.hide();
        }
    }
    catch (Error) { }
}
