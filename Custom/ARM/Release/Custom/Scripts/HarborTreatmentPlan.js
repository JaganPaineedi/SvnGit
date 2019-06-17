var TPConfirmCaption = 'Confirmation Message';
var TPAlertCaption = 'Message';
var hidScroll = 0;
var scrollPostion = 0;
var scrollFor = '';
var SortExpressionProcedure = '';
var CountSelectedGoal = 0;
var GoalTextAreaValue;
var GlobalTPProcedureID = '';


function CheckBoxSelectOneGoal(Id) {
    try {
        var CountSelectedCheckBox = $("input[type='checkbox']:checked").length;
        CountSelectedGoal = CountSelectedCheckBox;
        GoalTextAreaValue = document.getElementById(Id.TextAreaId).value;
    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}
//Function to Delete QuickTxGoal/Objective/Intervention
//CreatedOn:04 Sept 2009
//Author: Anuj Tomar
//Now this function is called on HRMTpQuickTxPlan Custom Popup On 2 July,2010
function DeleteQuickTxPlan(quickId, tableName) {
    try {

        ShowMsgBox('Are you sure you want to remove this Objective?', TPConfirmCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'DeleteQuickTxPlanOnOkOption(\'' + quickId + '\',\'' + tableName + '\');');

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Author : Mahesh
//Created on : 03 July,2010
// Description : split function of delete for using custom message box
function DeleteQuickTxPlanOnOkOption(quickId, tableName) {
    try {
        var resolveUrl = $("[id$=HiddenFieldRelativePath]");
        var myDate = new Date();
        $.post(resolveUrl.val() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?quickId=" + quickId, 'action=deletequicktxplan&tableName=' + tableName + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onSuccessAddToQuickTxPlan);

    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}
//Function is called on succss of DeleteQuickTxPlan to Recreate Html
//CreatedOn:04 Sept 2009
//Author: Anuj Tomar

//Now this function is called on HarborTpQuickTxPlan Custom Popup On 2 July,2010
function onSuccessAddToQuickTxPlan(result) {
    try {
        // var callBackId = $("#LinkCallBack")[0].id;
        var callBackId = $("[id$=LinkCallBack]")
        __doPostBack(callBackId[0].id, null);
    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}



//Description:Open HRMTPAssociatedNeeds Pop Up
//CreatedOn:08 Sept 2009
//Author: Vikas Vyas
function OpenModelDialogueforAssociatedObjective(containerId, needId, tpInterventionProcedureId) {
    try {

        var myDate = new Date();
        OpenPage(5765, 10666, "needId=" + needId + '^needNumber=' + needNumber + "^time=" + myDate.getMinutes() + myDate.getSeconds() + "^containerId=" + containerId, null, GetRelativePath(), 'T', "dialogHeight: 430px; dialogWidth: 600px;dialogTitle:Associate Need");

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description:GetAssociatedObjective Control  HTML 
//CreatedOn:19-Sept-2009
//Author: Vikas Vyas
function ModifyGoalValueInDataSet(keyValue, tableName, fieldName, controlId, actionName, keyFieldName) {
    try {

       
        var cObject = $('[id$=' + controlId + ']');

        var cValue = '';
        if (cObject.length > 0) {

            // Page defined function ValidateDate is changed with ValidateDateTreatmentPlan
            // Because same name clash with applicationCommon funciton /\/\ |<

            //Case of TextBox with Date
            //datatype
            if (cObject.attr("datatype") == 'Date') {
                ValidateDate(cObject[0]); //set the date if user enters . as date seprator. /\/\ |<
                var returnValue = ValidateDateValue(cObject);

                if (returnValue != '') {

                    cObject.val('');
                    //return false;
                }
                if (controlId.indexOf('CustomTPGoals_TargeDate') >= 0) {
                    $('input[id*=Text_CustomTPObjectives_TargetDate_][type=text]', $('table[GoalId=' + keyValue + ']')).val(cObject.val());
                }
            }

            if (cObject.attr('type') == "radio") //Handle Case for  Radio Control 
            {
                cValue = cObject.val();
            }
            else if (cObject.attr('type') == "checkbox")  //Handle Case for CheckBox Control
            {
                if (cObject.attr('checked') == false) {
                    cValue = "N";
                }
                else {
                    cValue = "Y";
                }
            }
            else {
                cValue = escape(cObject.val());


            }
        }

        var siteId = $('[id$=' + controlId + ']').attr("SiteId"); ;


        var selectedGoalNo = $('[id$=' + controlId + ']').attr("goalNo");
        var authCodeId = $('[id$=' + controlId + '] option:selected').val();
        var tpProcedureId = $('[id$=' + controlId + ']').attr("TPProcedureId");

        var args = arguments;

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?keyValue=" + keyValue, 'action=' + actionName + '&tableName=' + tableName + '&fieldName=' + fieldName + '&controlValue=' + cValue + '&keyFieldName=' + keyFieldName + '&GoalNo=' + selectedGoalNo + '&SiteId=' + siteId + '&AuthCodeId=' + authCodeId + '&TPProcedureId=' + tpProcedureId + '&time=' + myDate.getMinutes() + myDate.getSeconds(), function(result) { onSuccessHarborTreatmentPLan(result, controlId, keyValue, keyFieldName, args); });

    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}

function OpenModelDialogueforAssociatedNeeds(containerId, TpGoalId, needNumber) {
    try {


        var myDate = new Date();
        OpenPage(5765, 10666, "TPGoalId=" + TpGoalId + '^needNumber=' + needNumber + "^time=" + myDate.getMinutes() + myDate.getSeconds() + "^containerId=" + containerId, null, GetRelativePath(), 'T', "dialogHeight: 530px; dialogWidth: 480px;dialogTitle:Associated Needs");


    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan');
    }
}

//Description:Enabling and disabling the Comment TextArea 
//CreatedOn:10-Nov-2011
//Author: Priyanka

function EnableDisableCommentTextArea(obj) {
   
    if (obj.id.toString() == 'CheckBox_CustomTreatmentPlans_ClientParticipatedAndIsInAgreement') {
      
        if ($(obj).is(':checked')) {
            $('#CheckBox_CustomTreatmentPlans_ClientParticpatedPreviousDocumentation').removeAttr('checked');
            $('#CheckBox_CustomTreatmentPlans_ClientDidNotParticipate').removeAttr('checked');
            $('#TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment').attr('readonly', 'readonly');
            CreateAutoSaveXml('CustomTreatmentPlans', 'ClientParticpatedPreviousDocumentation', 'N');
            CreateAutoSaveXml('CustomTreatmentPlans', 'ClientDidNotParticipate', 'N');
            CreateAutoSaveXml('CustomTreatmentPlans', 'ClientDidNotParticpateComment', '');
            $('[id$=TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment]').val("");
        }
        
    }
    else if (obj.id.toString() == 'CheckBox_CustomTreatmentPlans_ClientParticpatedPreviousDocumentation') {
                if ($(obj).is(':checked')) {
                    $('#CheckBox_CustomTreatmentPlans_ClientParticipatedAndIsInAgreement').removeAttr('checked');
                    $('#CheckBox_CustomTreatmentPlans_ClientDidNotParticipate').removeAttr('checked');
                    $('#TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment').attr('readonly', 'readonly');
                    CreateAutoSaveXml('CustomTreatmentPlans', 'ClientParticipatedAndIsInAgreement', 'N');
                    CreateAutoSaveXml('CustomTreatmentPlans', 'ClientDidNotParticipate', 'N');
                    CreateAutoSaveXml('CustomTreatmentPlans', 'ClientDidNotParticpateComment', '');
                    $('[id$=TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment]').val("");
                }
               
    }
    else if (obj.id.toString() == 'CheckBox_CustomTreatmentPlans_ClientDidNotParticipate') {
                if ($(obj).is(':checked')) {
                    $('#CheckBox_CustomTreatmentPlans_ClientParticipatedAndIsInAgreement').removeAttr('checked');
                    $('#CheckBox_CustomTreatmentPlans_ClientParticpatedPreviousDocumentation').removeAttr('checked');
                    $('#TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment').removeAttr('readonly');
                    CreateAutoSaveXml('CustomTreatmentPlans', 'ClientParticipatedAndIsInAgreement', 'N');
                    CreateAutoSaveXml('CustomTreatmentPlans', 'ClientParticpatedPreviousDocumentation', 'N');
                }
                else {
                    $('#TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment').attr('readonly', 'readonly');
                }
    }



}


//Author :Mahesh
//Created On : 1 July,2010
//Description : Add the checked needs on container
function SetValueOnAssociatedNeeds(returnValue, containerId) {
    if (returnValue != undefined) {
        // commented  Called autosave function Orignal code line: Dirty = 'True';

        parent.CreateUnsavedInstanceOnDatasetChange();
        document.getElementById(containerId).innerHTML = returnValue;

    }
}

//Description:Use to Close the current pop up control
//Author: Vikas Vyas
//CreatedOn:10th Sept 2009
function HandleCloseEvent() {
    try {
        window.close();
    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}
//Description:Open HRMTPAddQuickTxPlan Pop Up
//Author:Vikas Vyas
//CreatedOn:10th-Sept-2009
function OpenModelDialogueAddQuickTxPlan(tableName, textBoxGoalText) {
    try {
        var goalText = $("[id$=" + textBoxGoalText + "]");

        //End
        var myDate = new Date();

        OpenPage(5765, 10668, "tableName=" + tableName + "^goalText=" + escape(goalText.val()) + "^time=" + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 450px; dialogWidth: 700px;dialogTitle:");

    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}

//Description:This is Common Method Use to Inserts a New Row in the
//TPQuickGoal/TPQuickObjectives/TPQuickInterVention
//Author:Vikas Vyas
//CreatedOn:10th-Sept-2009

//Now this function is used on HRMAddQuickTxPlan on 2 July,2010
function UpdateQuickTxPlan() {
    try {

        var objectTPElementTitle = $("input[type='text'][id$=TextBox_TPQuickGoals_TPElementTitle]");
        var objectTPElementText = $("[id$=TextArea_TPQuickGoals_TPElementText]");
        var objectTableField = $("input[id$=HiddenFieldTableName]");

        //End
        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?tableName=" + objectTableField.val(), 'action=updatequicktxplan&goalText=' + escape(objectTPElementText.val()) + '&elementTitle=' + escape(objectTPElementTitle.val()) + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onUpdateQuickTxPlanSuccess);

    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}
//Now this function is used on HRMAddQuickTxPlan on 2 July,2010
function onUpdateQuickTxPlanSuccess(result) {
    try {
    //Code commented by jagdeep to prevent creation of unsaved instance.
        //parent.CreateUnsavedInstanceOnDatasetChange();
        parent.CloaseModalPopupWindow();
        //window.close();
    }
    catch (err) {
        LogClientSideException(err, 'Harbor Treatment Plan'); //Code added by Devinder 
    }
}

//Description:Open HRMQuickTxPlan Common for all (useQuickGoal,useQuickObjective,useQuickIntervention)
//Author:Vikas Vyas
//CreatedOn:10th-Sept-2009
function OpenModelDialogueQuickTxPlan(keyValue, goaltextId, quickTxtableName, tableName) {
    try {

        var myDate = new Date();
        OpenPage(5765, 10667, "goaltextId=" + goaltextId + "^keyValue=" + keyValue + '^quickTxtableName=' + quickTxtableName + '^tableName=' + tableName + '^time=' + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 570px; dialogWidth: 830px;dialogTitle:");

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}

//Created on 7 July,2010 by mahesh , 12 52
//Purpose : set the values from popup HRMTPQUICKTXPLAN .ascx

function SetValueFromHandleUseQuickTxPlan(textId, result, primaryTable) {
    try {
        var controlObject = $("[id$=" + textId + "]");
        controlObject.val(result);
        controlObject.focus();
        controlObject.change();
        if (primaryTable != undefined && primaryTable == "True") {
            SaveAutoSaveXMLDom(controlObject[0]);
        }
        else {
            parent.CreateUnsavedInstanceOnDatasetChange();
        }

    }
    catch (err) {
    }
}

//Description:Method is used to Insert New Row in the TPObjective table
//Author:Vikas Vyas
//CreatedOn:16th-Sept-2009
function AddObjective(TPGoalId) {
    try {

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?TPGoalId=" + TPGoalId, 'action=addobjective&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHarborTxPlanControlOnSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description:Method is use to Delete objective associated with goal
//Author:Vikas Vyas
//CreatedOn:16th-Sept-2009
function DeleteObjective(TPGoalId, objectiveId) {
    try {

        ShowMsgBox('Are you sure you want to remove this Objective?', 'TPConfirmCaption', MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'DeleteObjectiveOkOption(\'' + TPGoalId + '\',\'' + objectiveId + '\');');
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

function DeleteObjectiveOkOption(TPGoalId, objectiveId) {
    try {
        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?TPGoalId=" + TPGoalId, 'action=deleteobjective&objectiveId=' + objectiveId + '&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHarborTxPlanControlOnSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}




//Description:Method is used to open HRMTPGoalrtert
//Author:Vikas Vyas
//CreatedOn:22nd-Sept-2009
function OpenModelDialogueHRMTPGoal(TpGoalId, goalTitle) {
    try {
        var myDate = new Date();
        //Modified For UM Part2 By Damanpreet Kaur
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?TPGoalId=" + TpGoalId, 'action=addgoal&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHarborTxPlanControlOnSuccess);
        //  OpenPage(5765, 10191, 'needId=' + needId + '^goalTitle=' + goalTitle + '^time=' + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight:575px; dialogWidth: 830px;dialogTitle:");
    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan');
    }
}


//Author : Mahesh
//Created on : 03 July,2010
// Description : This function called from HRMTPGoal.ascx when opened in Add Mode

function SetValueAfterAddNewGoal(returnValue) {
    try {

        scrollPostion = document.getElementById("TreatmentPlanHRM_C1").scrollTop;
        scrollFor = "AddGoal";
        if (returnValue != undefined) {
            $("[id$=PanelTxPlanMain]")[0].innerHTML = null;
            $("[id$=PanelTxPlanMain]")[0].outerHTML = returnValue;

            document.getElementById("TreatmentPlanHRM_C1").scrollTop = parseInt(scrollPostion) + 450;


        }
    }
    catch (err) {
    }
}

function trim(value) {
    try {
        return LTrim(RTrim(value));
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description:On Success Close the ViewClientNeed Pop Up Control
//CreatedOn:10th Nov 2009
//Author: Vikas Vyas

//Used on custom popup HRMViewClientNeeds
function OnUpdateClientNeedSuccess(result) {
    window.close();
}

//Function to Delete ClientNeedsList.
//Created By Anuj
//Createde On 24Sep,2009
//Modified By: Vikas Vyas
//Add maxNeedCount Parameter
function DaleteTxPlanGoal(TPGoalId, maxGoalCount) {
    var answer = "";

    try {
        if (maxGoalCount == 1) {

            ShowMsgBox('This Goal can not be removed as there is one goal avaliable in TreatmentPlan - Harbor', 'TPAlertCaption', MessageBoxButton.OK, MessageBoxIcon.Information);
            return false;
        }

        ShowMsgBox('Removing a Goal from a treatment plan will remove the associated  Objectives and Services.Are you sure you want to remove the Goal?', 'TPConfirmCaption', MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'DaleteTxPlanGoalOnOkOption(\'' + TPGoalId + '\');', 'DaleteTxPlanGoalOnCloseOption();');

    }
    catch (err) {
        LogClientSideException(err, 'Harbor Treatment Plan'); //Code added by Devinder 
    }
}
//Author : Mahesh
//Created on : 03 July,2010
// Description : split function of delete for using custom message box

function DaleteTxPlanGoalOnOkOption(TPGoalId) {
    try {
        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?TPGoalId=" + TPGoalId, 'action=deletegoal&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHarborTxPlanControlOnSuccess);

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');

    }
}

//Author : Mahesh
//Created on : 03 July,2010
// Description : split function of delete for using custom message box

function DaleteTxPlanGoalOnCloseOption() {
    return false;
}

//Description:Open Edit Objective Pop Up
//CreatedOn:25 Sept 2009
//Author: Vikas Vyas
function OpenModelDialogueforEditObjective(objectiveId, objectiveTextId, objectiveTargetDateId, objectiveStatusId) {
    try {


        var myDate = new Date();
        OpenPage(5765, 10193, "objectiveId=" + objectiveId + "^time=" + myDate.getMinutes() + myDate.getSeconds()
        + "^objectiveTextId=" + objectiveTextId + "^objectiveTargetDateId=" + objectiveTargetDateId
        + "^objectiveStatusId=" + objectiveStatusId
        , null, GetRelativePath(), 'T', "dialogHeight: 425px; dialogWidth: 700px;dialogTitle:Edit Objective");

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Description:To update Objective from pop up
//CreatedOn:2 July 2010
//Author: Mahesh Sharma
//function SetEditedObjectiveVlaueFromPopup(returnValue, objectiveTextId, objectiveTargetDateId, objectiveStatusId) {
//    try {
//        var objectiveText = $("[id$=" + objectiveTextId + "]");
//        var objectiveTargetDate = $("[id$=" + objectiveTargetDateId + "]");
//        var objectiveStatus = $("[id$=" + objectiveStatusId + "]");

//        if (returnValue != undefined) {
//            var result = returnValue.split("$$");
//            if (result[1] != "") {
//                objectiveText[0].value = result[1];
//            }
//            else {
//                objectiveText[0].value = "";
//            }
//            if (result[2] != "") {
//                objectiveTargetDate[0].value = result[2];
//            }
//            else {
//                objectiveTargetDate[0].value = "";
//            }
//            if (returnValue[3] != "") {
//                objectiveStatus[0].value = result[3].trim();
//            }
//            else {
//                objectiveStatus[0].value = "";
//            }
//        }
//    }
//    catch (err) {
//        LogClientSideException(err, 'HarborTreatmentPlan');
//    }
//}

//Description:To update Objective Pop Up
//CreatedOn:25 Sept 2009
//Author: Vikas Vyas
//Now this function called on HRMTPObjective custom popup
function UpdateObjective() {
    try {
        var objectiveId = $("input[id$=HiddenField_TPObjectives_ObjectiveId]");
        var objectiveText = $("[id$=TextArea_TPObjectives_ObjectivesText]");
        var objectiveTargetDate = $("input[type=text][id$=TextBox_TPObjectives_TargetDate]");
        var objectiveStatus = $("select[id$=DropDownList_GlobalCodes]");

        var myDate = new Date();

        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?objectiveId=" + objectiveId.val(), 'action=updateobjective&ObjectiveText=' + escape(objectiveText.val()) + '&TargetDate=' + objectiveTargetDate.val() + '&ObjectiveStatus=' + objectiveStatus.val() + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onAssocitedNeedSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }

}




//Description:Open Renumber Pop Up control
//Author:Vikas Vyas
//CreatedOn:06th Oct,2009
function OpenRenumberTxPlan(tableName, keyFieldName, goalNumber, TPGoalId) {
    try {


        var myDate = new Date();
        OpenPage(5765, 10670, "tableName=" + tableName + "^keyFieldName= " + keyFieldName + "^goalNumber=" + goalNumber + "^TPGoalId=" + TPGoalId + "^time=" + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 580px; dialogWidth: 480px;dialogTitle:");


    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Author :Mahesh
//Created On : 1 July,2010
//Description : Add the selected transaction plan on container
function SetValueOnTxPlanMain(returnValue) {

    if (returnValue != undefined) {
        //Dirty = 'True';
        parent.CreateUnsavedInstanceOnDatasetChange();
        $("[id$=PanelTxPlanMain]")[0].innerHTML = null;
        //$("#PanelTxPlanMain")[0].outerHTML = returnValue;
        $("[id$=PanelTxPlanMain]")[0].outerHTML = returnValue;
    }
}


//Description:Swapping logic 
//Author:Vikas Vyas
//CreatedOn:6th Oct,2009

//Now it is used in HRM Renumber Tx Plan.ascx 
//Temp changed the function name
function RenumberGoal(control) {
    var tableName = "";
    try {
        //Perform Validation for valid number
        //Check wheather number entered is numeric or not
        if (control.value == "" || isNaN(control.value)) {
            //alert("Please enter a valid value");
            ShowMsgBox('Please enter a valid value.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            document.getElementById(control.id).value = control.oldValue;
            return false;
        }
        else {
            //Check if number is numeric not exceed than maximum number
            var goalMaxValue = $("input[id$=HiddenFieldMaxNumber]");
            tableName = $("input[id$=HiddenFieldTableName]");
            //Check wheater we go for decimal check or not 
            if (tableName[0].value == "TPNeeds") {
                if (control.value <= 0) {
                    // alert("Please enter a valid value");
                    ShowMsgBox('Please enter a valid value.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                    document.getElementById(control.id).value = control.oldValue;
                    return false;
                }
                else if ((parseInt(control.value) > 0) && (parseInt(control.value) > goalMaxValue.val())) {

                    //alert("Please enter a valid value");
                    ShowMsgBox('Please enter a valid value.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                    document.getElementById(control.id).value = control.oldValue;
                    return false;
                }

            }
            else //case for decimal value
            {
                if (control.value.indexOf(".") == -1) {
                    if ((control.value.length) - (control.value.indexOf(".") + 1) > 2) {
                        //alert("Please enter a valid value");
                        ShowMsgBox('Please enter a valid value.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                        document.getElementById(control.id).value = control.oldValue;
                        return false;
                    }
                    else if (control.value <= 0) {
                        //alert("Please enter a valid value");
                        ShowMsgBox('Please enter a valid value.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                        document.getElementById(control.id).value = control.oldValue;
                        return false;
                    }
                }
                else {
                    if ((control.value.length) - (control.value.indexOf(".") + 1) > 2) {
                        //alert("Please enter a valid value");
                        ShowMsgBox('Please enter a valid value.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                        document.getElementById(control.id).value = control.oldValue;
                        return false;
                    }
                    else if (control.value <= 0) {
                        //alert("Please enter a valid value");
                        ShowMsgBox('Please enter a valid value.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                        document.getElementById(control.id).value = control.oldValue;
                        return false;
                    }
                    else if ((control.value > 0) && (control.value > goalMaxValue.val())) {
                        //alert("Please enter a valid value");
                        ShowMsgBox('Please enter a valid value.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                        document.getElementById(control.id).value = control.oldValue;
                        return false;
                    }
                }
            }
        }
        //Call Ajax Page
        var controlCollection = "";
        if (tableName[0].value == "TPNeeds") {
            controlCollection = $("input[type='text'][@renumberText=renumberText][@oldvalue=" + parseInt(control.value) + "]");
        }
        else {
            controlCollection = $("input[renumberText=renumberText][value=" + control.value + "]");
        }
        if (controlCollection.length > 1) {
            var firstOldValue = $("#" + controlCollection[0].id + "").attr('oldValue');
            var firstControlValue = $("#" + controlCollection[0].id + "").val();

            $("#" + controlCollection[0].id + "").attr('oldValue', $("#" + controlCollection[1].id + "").attr('oldValue'));
            $("#" + controlCollection[0].id + "").val($("#" + controlCollection[1].id + "").attr('oldValue'));

            $("#" + controlCollection[1].id + "").attr('oldValue', firstOldValue);
            $("#" + controlCollection[1].id + "").val(firstOldValue);
        }
        if (controlCollection.length == 1) {
            $("#" + controlCollection[0].id + "").val($("#" + controlCollection[0].id + "").attr('oldValue'));
        }
        //Commented By Rohit Katoch
        //        $.each(controlCollection, function() {
        //            var currentControl = $('input[type=text]', this);
        //            currentControl.val(control.oldValue);
        //            currentControl.attr('oldValue', control.oldValue);
        //        });



        //        document.getElementById(controlCollection[0].id).value = control.oldValue;
        //        document.getElementById(controlCollection[0].id).oldValue = control.oldValue;
        //        if (tableName[0].value == "TPNeeds") {
        //            document.getElementById(control.id).oldValue = parseInt(control.value);
        //        }
        //        else {
        //            document.getElementById(control.id).oldValue = control.value;
        //        }
    }
    catch (err) {
        //alert("Please enter a valid value");
        ShowMsgBox('Please enter a valid value.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
        document.getElementById(control.id).value = control.oldValue;
        return false;
        //LogClientSideException(err,'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description:Update value in DataSet ( TPNeeds table) Renumber logic 
//Author:Vikas Vyas
//CreatedOn:6th Oct,2009
// this function is used on HRMTPRenumberTxPlan
function UpdateRenumberControl() {
    var controlCollection = "";
    var tableName = "";
    var keyFieldName = "";
    var strHTML = "";
    try {
        controlCollection = $("input[type='text'][@renumberText=renumberText]");
        if (controlCollection.length > 0)  //Perform Check for Length
        {
            for (textBoxCount = 0; textBoxCount < controlCollection.length; textBoxCount++) {
                if (strHTML == "") {
                    strHTML = controlCollection[textBoxCount].TPGoalId + "$$" + controlCollection[textBoxCount].value;
                }
                else {
                    strHTML = strHTML + "||" + controlCollection[textBoxCount].TPGoalId + "$$" + controlCollection[textBoxCount].value;
                }
            }
        }
        tableName = $("input[id$=HiddenFieldTableName]");
        keyFieldName = $("input[id$=HiddenFieldKeyFieldName]");

        var myDate = new Date();

        $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?tableName=" + tableName.val(), 'action=renumbertxplan&strHTML=' + strHTML + '&keyFieldName=' + keyFieldName.val() + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onHarborTPRenumberTxPlan);
    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}

//Added By Rohit Katoch
//called on the callback of Renunmber Goals/objectives 
function onHarborTPRenumberTxPlan(result) {
    try {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            parent.CreateUnsavedInstanceOnDatasetChange();
            parent.SetValueOnTxPlanMain(pageResponse);
            parent.CloaseModalPopupWindow();
        }
    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmetPlan'); //Code added by Devinder 
    }
}







































//This function is used on htmassignprocedure pop ups
function ValidateDateTreatmentPlan(input) {
    try {
        var validformat = /^\d{2}\/\d{2}\/\d{4}$/ //Basic check for format validity
        var returnval = false
        var errorMessage = "";
        if (input.value == '') {
            return;
        }
        else {
            var monthfield = input.value.split("/")[0]
            var dayfield = input.value.split("/")[1]
            var yearfield = input.value.split("/")[2]
            var dayobj = new Date(yearfield, monthfield - 1, dayfield)
            if ((dayobj.getMonth() + 1 != monthfield) || (dayobj.getDate() != dayfield) || (dayobj.getFullYear() != yearfield)) {
                errorMessage = "Invalid Day, Month, or Year range detected. Please correct";
            }
            else {
                returnval = true
            }
        }
        if (returnval == false) {
            input.value = '';
            return false;
        }
        else {

            return true;
        }
    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmetPlan');
    }

}











function GetRelativePathTP() {
    var _relativePath = "";
    _relativePath = $("[id$=HiddenFieldRelativePath]").val();
    return _relativePath;
}



//Description:Method is used to add custom logic
//Author:Vikas Vyas
//CreatedOn:11th Nov,2009
//function AddEventHandlers() {
//    try {

//        var objectradio = $("input[type='radio'][name='RadioButton_TPGeneral_PlanOrAddendum']:checked");

//        if (objectradio.length > 0) {
//            if (objectradio[0].value == "T") {

//                //$("[id$=tablePlanOrAddendum]")[0].style.display = 'none';

//                // $("textarea[id='TextArea_TPGeneral_PurposeOfAddendum']").removeAttr("disabled");

//                var textBoxTPGeneral_PeriodicReviewFrequencyNumber = $("input[type='text'][id$=TextBox_TPGeneral_PeriodicReviewFrequencyNumber]")

//                if (textBoxTPGeneral_PeriodicReviewFrequencyNumber.length > 0) {

//                    textBoxTPGeneral_PeriodicReviewFrequencyNumber.removeAttr("disabled");
//                }

//                //Get tabIndex

//                var tabIndexAddendum = $("textarea[id='TextArea_TPGeneral_PurposeOfAddendum']").attr("tabIndex");
//                var tabIndexStreagth = $("textarea[id='TextArea_TPGeneral_StrengthsAndPreferences']").attr("tabIndex");


//                //Set tabIndex
//                $("textarea[id='TextArea_TPGeneral_StrengthsAndPreferences']").attr("tabIndex", tabIndexAddendum);
//                $("textarea[id='TextArea_TPGeneral_AreasOfNeed']").attr("tabIndex", tabIndexStreagth);
//                //TextArea_TPGeneral_AreasOfNeed


//            }
//            else if (objectradio[0].value == "A") {
//                $("textarea[id='TextArea_TPGeneral_PurposeOfAddendum']").removeAttr("disabled");
//                //TextArea_TPGeneral_Participants
//                //TextArea_TPGeneral_AreasOfNeed

//                var dropdownList_TPGeneral_PeriodicReviewFrequencyUnitType = $("select[id$=DropDownList_TPGeneral_PeriodicReviewFrequencyUnitType]")

//                if (dropdownList_TPGeneral_PeriodicReviewFrequencyUnitType.length > 0) {
//                    dropdownList_TPGeneral_PeriodicReviewFrequencyUnitType.disabled = true;
//                }

//                var tabIndexAddendum = $("textarea[id='TextArea_TPGeneral_Participants']").attr("tabIndex");
//                var tabIndexStreagth = $("textarea[id='TextArea_TPGeneral_AreasOfNeed']").attr("tabIndex");


//                //Set tabIndex
//                $("textarea[id='TextArea_TPGeneral_AreasOfNeed']").attr("tabIndex", tabIndexAddendum);
//                $("textarea[id='TextArea_TPGeneral_Participants']").attr("tabIndex", tabIndexStreagth);
//            }
//        }

//        var objectCheckBox = $("input[type='checkbox'][id$='CheckBox_TPGeneral_CrisisPlanNotNecessary']:checked")
//        if (objectCheckBox.length > 0) {

//            $("textarea[id='TextArea_TPGeneral_CrisisPlan']").attr("disabled", "disabled");


//        }
//        else {

//            $("textarea[id='TextArea_TPGeneral_CrisisPlan']").removeAttr("disabled");

//        }

//        return true;
//    }
//    catch (err) {
//        LogClientSideException(err, 'HRMTreatmetPlan');
//    }
//}


// Function Modified by Rakesh . For Enable and Disable Tabs on Treatment Plan

//function EnableTabs(obj) {
//    if ($('select[id$=DropDownList_TPGeneral_Assigned]').val() == 0 || $('select[id$=DropDownList_CustomClientLOCs_LOCId]').val() == 0) {
//        SetTabControlStatus(false);
//    }
//    else {

//        var boolIsEnable = false;
//        if ($('Documents EffectiveDate', AutoSaveXMLDom[0].xml).length > 0) {
//            if ($('Documents EffectiveDate', AutoSaveXMLDom[0].xml).text() != "")
//                boolIsEnable = true;
//        }
//        if (boolIsEnable == true)
//            SetTabControlStatus(true);
//        else
//            SetTabControlStatus(false);
//    }
//    $("input[id$=HiddenFieldLocID]").val($('select[id$=DropDownList_CustomClientLOCs_LOCId]').val());

//    if (obj.id.indexOf('DropDownList_CustomClientLOCs_LOCId') > -1) {
//        if ($('[id*=DropDownList_TPInterventionService]').length > 0) {
//            ShowMsgBox('Changing LOC will result in different LCM / CCM caps.  Be sure to review your authorization requests.  Do you wish to continue changing LOC?', 'HRM Treatment Plan', MessageBoxButton.YesNo, MessageBoxIcon.Question, 'ClickYesLOC()', 'ClickNoLOC()');
//        }
//    }
//}

//function ClickYesLOC() {

//    $('#TreatmentPlanHRM_C1').html('');
//    CallAutoSaveProcess();
//}

//function ClickNoLOC() {
//    $('[id$=DropDownList_CustomClientLOCs_LOCId').val($('[id$=DropDownList_CustomClientLOCs_LOCId').attr('oldvalue'));
//    $("input[id$=HiddenFieldLocID]").val($('select[id$=DropDownList_CustomClientLOCs_LOCId]').val());
//    if ($("CustomClientLOCs LOCId").length > 0) {
//        CreateAutoSaveXml('CustomClientLOCs', 'LOCId', $('select[id$=DropDownList_CustomClientLOCs_LOCId]').val());
//    }


//}
/////This is used for enable and disable tabs
//function EnableDisabelTreatmentTabs(dom, action) {
//    var boolIsEnable = false;
//    if ($('Documents EffectiveDate', dom[0].xml).length > 0) {
//        if ($('Documents EffectiveDate', dom[0].xml).text() != "")
//            boolIsEnable = true;
//    }
//    if (boolIsEnable) {
//       if (dom[0].childNodes[0].selectNodes("CustomClientLOCs").length > 0) {
//            var tpgeneralUM = null;
//            if (dom[0].childNodes[0].selectNodes("TPGeneral").length > 0 && dom[0].childNodes[0].selectNodes("TPGeneral")[0].selectNodes("Assigned").length > 0)
//                tpgeneralUM = dom[0].childNodes[0].selectNodes("TPGeneral")[0].selectSingleNode("Assigned");
//            else
//                tpgeneralUM = null;
//            var tpCustomClientLoc = dom[0].childNodes[0].selectNodes("CustomClientLOCs")[0].selectSingleNode("LOCId");
//            //////Disable the Effective Date control
//            //$('#TextBox_DocumentInformation_EffectiveDate').attr("disabled", "true");
//            alert("if 2:-----" + tpCustomClientLoc.nodeTypedValue); 
//            if (tpCustomClientLoc.nodeTypedValue != -1)
//            //if (tpgeneralUM != null && tpCustomClientLoc != null && tpgeneralUM != "" && tpCustomClientLoc != "")
//            {
//                if (tpgeneralUM == null || typeof tpgeneralUM.nodeTypedValue == 0)
//                //  if (tpgeneralUM.nodeTypedValue == 0 || tpCustomClientLoc.nodeTypedValue == -1)
//                {
//                    SetTabControlStatus(false);
//                }
//                else {
//                    SetTabControlStatus(true);
//                }

//            }
//            else {
//                SetTabControlStatus(false);
//            }
//        }
//        else {
//            SetTabControlStatus(false);
//        }
//    }
//    else
//        SetTabControlStatus(false);
//}










////onSuccessUpdateHRMTPAssignProcedure

//function OnSuccessUpdateHRMTPAssignProcedureAfterSave(pageResponse) {

//    var pageResponse = result;
//    var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
//    var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
//    pageResponse = pageResponse.substr(start, end - start);
//    if (pageResponse != undefined) {
//        $("#PanelGridViewProcedure").html("");
//        //$("#PanelGridViewProcedure")[0].innerHTML = pageResponse;
//        $("#PanelGridViewProcedure").html(pageResponse);
//    }



//}




//
function OnSuccessRecreateTxPlanAfterSave(result) {

    var pageResponse = result;
    var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
    var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {
        $("[id=PanelTxPlanMain]")[0].outerHTML = pageResponse;
    }



    var myDate = new Date();
    var panelGridView = $("#PanelGridViewProcedure");
    if (panelGridView.length > 0) {
        if (panelGridView.html() == "") {
            $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=bindgridviewtpprocedureaftersave&time=' + myDate.getMinutes() + myDate.getSeconds(), OnSuccessUpdateHRMTPAssignProcedureAfterSave);
        }
    }


}



////Now this function is used on HRMAssignProcedure pop up
//function radioClickTPProcedure(radio, tpprocedureId, providerSite, units, startDate, endDate, frequencyType, totalUnits, program, authorizationRequesterComment, authorizationId, siteId) {



//    var radioCollection = $("[id$=GridViewProcedures]").find("input[type='radio']");

//    for (var i = 0; i < radioCollection.length; i++) {

//        if (radioCollection[i].id == radio.id) {

//            document.getElementById(radioCollection[i].id).checked = true;
//        }
//        else {
//            document.getElementById(radioCollection[i].id).checked = false;
//        }

//    }


//    var textBoxTPInterventionProcedure = $("input[type=text][id$=TextBox_TPInterventionProcedures_Units]");
//    textBoxTPInterventionProcedure[0].value = units;

//    var dropdownFrequencyType = $("select[id$=DropDownList_TPInterventionProcedures_FrequencyType]");
//    dropdownFrequencyType[0].value = parseInt(frequencyType);

//    var dropdownInterventionProceduerProvider = $("select[id$=DropDownList_Procedure]");
//    dropdownInterventionProceduerProvider[0].value = providerSite;


//    var requestStartDate = $("input[type=text][id$=TextBox_TPInterventionProcedures_StartDate]");
//    requestStartDate.val(startDate);

//    var requestEndDate = $("input[type=text][id$=TextBox_TPInterventionProcedures_EndDate]");
//    requestEndDate.val(endDate);
//    //requestEndDate[0].value = endDate;
//    var requesTotalUnit = $("input[type=text][id$=TextBox_TPInterventionProcedures_TotalUnits]");
//    requesTotalUnit.val(totalUnits);
//    //requesTotalUnit[0].value = totalUnits;
//    var dropdownProgram = $("select[id$=DropDownList_Programs]");

//    dropdownProgram[0].value = program;

//    $("input[id$=HiddenFieldTPProcedureId]").val(tpprocedureId);

//    $("input[type='button'][Id=ButtonInsert]").attr("value", "Modify");



//    var myDate = new Date();

//    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpProcedureId=" + tpprocedureId, 'action=createeditassociateinterventioncontrol&authorizationCodeId=' + authorizationId + '&siteId=' + siteId + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onradioClickTPProcedureSuccess);


//}

////Now this funciton is used on HRMAsignproceduree popup

//function onradioClickTPProcedureSuccess(result) {

//    try {

//        var pageResponse = result;
//        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
//        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
//        pageResponse = pageResponse.substr(start, end - start);
//        if (pageResponse != undefined) {
//            $("#PanelAssociatedWith")[0].innerHTML = pageResponse;
//        }
//    }

//    catch (err) {
//        LogClientSideException(err, 'HRMTreatmetPlan');
//    }

//}






//Now this function is used on HRPASSIGNMENTPROCEDURE POPUP

function ValidateDateValue(input) {

    try {
        var validformat = /^\d{2}\/\d{2}\/\d{4}$/ //Basic check for format validity
        var errorMessage = "";
        if (input.val() == '') {
            errorMessage = "Value is null";
        }
        else {
            var monthfield = input.val().split("/")[0]

            var dayfield = input.val().split("/")[1]
            var yearfield = input.val().split("/")[2]
            if (monthfield.length != 2) {
                errorMessage = "Value is null";
                return errorMessage;
            }
            if (dayfield.length != 2) {
                errorMessage = "Value is null";
                return errorMessage;
            }

            if (yearfield.length != 4) {
                errorMessage = "Value is null";
                return errorMessage;
            }

            var dayobj = new Date(yearfield, monthfield - 1, dayfield)
            if ((dayobj.getMonth() + 1 != monthfield) || (dayobj.getDate() != dayfield) || (dayobj.getFullYear() != yearfield)) {
                errorMessage = "Invalid Day, Month, or Year range detected. Please correct";
            }
        }
        return errorMessage;
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }



}


//Used to validate the date for TP 
function ValidateDateValueTP(controlId) {

    try {

        var cObject = $('[id$=' + controlId.id + ']');
        var returnValue = ValidateDate(cObject[0]);
        //var returnValue = ValidateDateValue(cObject);
        if (returnValue != true) {
            cObject.val('');
            return false;
        }


    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }



}

// Removes leading whitespaces

function LTrim(value) {
    try {
        var re = /\s*((\S+\s*)*)/;
        return value.replace(re, "$1");
    }
    catch (err) {
        LogClientSideException(err, 'CommonFunctions'); //Code added by Devinder 
    }

}

// Removes ending whitespaces

function RTrim(value) {
    try {
        var re = /((\s*\S+)*)\s*/;
        return value.replace(re, "$1");
    }
    catch (err) {
        LogClientSideException(err, 'CommonFunctions'); //Code added by Devinder 
    }

}


function ClearReInitializeTxPlan() {
    var action = "Clear";
    ShowMsgBox("You have selected 'Blank Plan'. Any changes you have made to this document prior to clicking this button will be lost.", ConfirmationMessageCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Information, 'ConfirmMessageForCompleteDocumentOnOK(\'' + action + '\')', 'ConfirmMessageForCompleteDocumentOnCancel()');
}


// Created By Vikas Vyas 
function ConfirmMessageForCompleteDocumentOnCancel() {
    try {
        return false;
    }
    catch (err) {//alert('Error occured in JS function ');}
        LogClientSideException(err, 'HRMTreatmetPlan');
    }

}



// Createde By Vikas Vyas
//function ConfirmMessageForCompleteDocumentOnOK(action) {
//    try {
//        var _filterData = "UnsavedChangeId=" + UnsavedChangeId;



//        _filterData = _filterData + '^ReIntialization=Y';
//        _reinitializeTabs = true;
//        PopupProcessing();
//        LoadDocument(GetCurrentScreenID(), 5763, _filterData, CurrentHistoryId, GetRelativePath(), pageActionEnum.New, null, false, globalCurrentScreenTabIndex);

//    }
//    catch (err) {//alert('Error occured in JS function ');}
//        HidePopupProcessing();
//        LogClientSideException(err, 'HRMTreatmetPlan');
//    }

//}

//This function is used for open POP up Stage of Trement on Click  Icon on TxPlan Main Screen - information icon    added by Rakesh Garg


function FillAuthorizationDropdownOnSuccess(result, dropdownAuthorizationID, spanID) {

    if (result != null && result != "") {
        $("[id$=" + spanID + "]").html(result);
        $("[id$=" + dropdownAuthorizationID + "]").val('');

    }
    parent.HidePopupProcessing();
}




function DivScrollPos(val) {

    hidScroll = val.scrollTop;
}


function SetDivScroll(divid) {

    $('#' + divid + '')[0].scrollTop = hidScroll;
}

//function EnableDisable_GoalMonitoredStaffOther(obj, NeedId) {


//    $('input#TextBox_TPNeeds_GoalMonitoredStaffOther_' + NeedId).attr('disabled', !$(obj).attr('checked'));
//    $('select#DropDownList_TPNeeds_GoalMonitoredStaff_' + NeedId).attr('disabled', $(obj).attr('checked'));
//    ModifyGoalValueInDataSet(NeedId, 'TPNeeds', 'GoalMonitoredStaffOtherCheckbox', obj.id, 'Edit', 'NeedId');

//    if (!$(obj).attr('checked')) {
//        $('input#TextBox_TPNeeds_GoalMonitoredStaffOther_' + NeedId).val('');

//    }
//    else {
//        $('select#DropDownList_TPNeeds_GoalMonitoredStaff_' + NeedId).val('');

//    }


//}



//Description : To create a new Service
//Author : Rohit Katoch
//Createed on : 8 June 2011
function AddService(TPGoalId) {
    try {

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?TPGoalId=" + TPGoalId, 'action=addservice&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHarborTxPlanControlOnSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description : To Delete a Service
//Author : Rohit Katoch
//Createed on : 8 June 2011
function DeleteService(TPGoalId, serviceId) {
    try {

        ShowMsgBox('Are you sure you want to remove this Service?', 'TPConfirmCaption', MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'DeleteServiceOkOption(\'' + TPGoalId + '\',\'' + serviceId + '\');');
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description : To Delete a Service on ok selection of prompt
//Author : Rohit Katoch
//Createed on : 8 June 2011
function DeleteServiceOkOption(TPGoalId, ServiceId) {
    try {
        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?TPGoalId=" + TPGoalId, 'action=deleteservice&serviceid=' + ServiceId + '&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHarborTxPlanControlOnSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

function CreateNewDocumentPage() {
    try {
        //GetDocumentStatus();
        var DocumentCode = AutoSaveXMLDom[0].childNodes[0].selectNodes("Documents")[0].selectNodes("DocumentCodeId")[0].text;
        if ((DocumentCode.trim() == '1484' || DocumentCode.trim() == '1485') && (DocumentStatusId == 21 || DocumentStatusId == 0)) {
            ShowHideErrorMessage('Document already in Progress. Can not create a new Document', 'true');
            return;
        }
        var screenId = GetCurrentScreenID();
        var filterData = "";


        //Call AutoSave in case of document in inprogress mode
        if (DocumentId > 0) {
            AutoSavePageData();
        }
        //Following added by Sonia ref PA Ticket 561 for CM/PA we need to give prompt to user
        //In case data is not saved and user clicked on new for Documents with Id >0
        if (ApplicationId != undefined && (ApplicationId == 2 || ApplicationId == 1) && (DocumentId > 0) && (Dirty == "True" || UnsavedChangeId != 0)) {
            var _documentAction = pageActionEnum.New;
            ShowMsgBox('Do you want to save the current document?', ConfirmationMessageCaption, MessageBoxButton.YesNoCancel, MessageBoxIcon.Question, 'MessageBoxUnsavedEventConfirm(\'yes\',\'' + _documentAction + '\')', 'MessageBoxUnsavedEventConfirm(\'no\',\'' + _documentAction + '\')');
            return false; //False returned by sonia to Manage History as otherwise new history node is created
        }
        //Changes end here
        //Current screen have unsaved data with document status "New".
        //Open a popup screen to prompt user to saved data.
        if ((DocumentId == 0) && (Dirty == "True" || UnsavedChangeId != 0)) {
            ShowMsgBox('Do you want to save the current document?', ConfirmationMessageCaption, MessageBoxButton.YesNoCancel, MessageBoxIcon.Question, 'MessageBoxUnsavedDocumentConfirm(\'yes\')', 'MessageBoxUnsavedDocumentConfirm(\'no\')');
            return false; //False returned by sonia to Manage History as otherwise new history node is created




            returnValue = window.showModalDialog("../UnsavedDocumentPopup.aspx", "", "center:yes;resizable:no;dialogWidth:450px;dialogHeight:200px;");
            if (returnValue == undefined) {
                return false; //False returned by sonia to Manage History as otherwise new history node is created
            }
            if (returnValue != '' && returnValue != undefined) {

                //If user select "Yes" option. 
                //Save the current screen instance
                //Discard from unsaved list.
                //open the new instance.


                if (returnValue == "Yes") {

                    CallBackAction = pageActionEnum.New;
                    SavePageData();

                }

                if (returnValue == "No") {

                    DeleteUnsavedChangesById(UnsavedChangeId);
                    //If user select "No" option. 
                    //Discard from unsaved list.
                    //open the new instance.
                    PopupProcessing();



                    if (NoteType == -1 && KeyScreenId == 0) {
                        KeyScreenId = screenId;
                    }

                    if (screenId == KeyScreenId) { //Condition Added by Vikas Vyas in ref to implement Service Note/Events Architecture

                        // filterData = "IsServiceNote=true^serviceId=0^documentId=0^DocumentNavigationId=" + DocumentNavigationId + "^DocumentNavigationName=" + DocumentNavigationName;
                        filterData = "NoteType=" + NoteType + "^keyfieldvalue=0^keyscreenid=" + KeyScreenId + "^documentId=0^DocumentNavigationId=" + DocumentNavigationId + "^DocumentNavigationName=" + DocumentNavigationName;

                        $.ajax({
                            type: "POST",
                            url: "../BasePages/Documents.aspx?scId=" + KeyScreenId + '&isExternalURL=' + isExternalURL + "&isPopUp=" + IsPopupWindow,
                            data: 'action=new&ajaxRequest=true&requestParametersValues=' + filterData + '&historyId=' + CurrentHistoryId,
                            success: LoadDocumentCallBack
                        });
                    }
                    else {
                        filterData = "NoteType=" + NoteType + "^DocumentNavigationId=" + DocumentNavigationId + "^DocumentNavigationName=" + DocumentNavigationName;

                        $.ajax({
                            type: "POST",
                            url: "../BasePages/Documents.aspx?scId=" + screenId + '&isExternalURL=' + isExternalURL,
                            data: 'action=new&ajaxRequest=true&historyId=' + CurrentHistoryId + '&requestParametersValues=' + filterData + "&isPopUp=" + IsPopupWindow,
                            success: LoadDocumentCallBack

                        });
                    }


                }

                return false; //False returned by sonia to Manage History as otherwise new history node is created

            }
        }

        //current screen with no unsaved data with document status "New".
        if (Dirty == "False" || DocumentId > 0) {
            PopupProcessing();

            // if (screenId == "29") { //Condition Added by Vikas Vyas in ref to implement Service Note Architecture


            if (NoteType == -1 && KeyScreenId == 0) {
                KeyScreenId = screenId;
            }
            if (screenId == KeyScreenId) { //Condition Added by Vikas Vyas in ref to implement Service Note Architecture

                //   filterData = "IsServiceNote=true^serviceId=0^documentId=0^DocumentNavigationId=" + DocumentNavigationId + "^DocumentNavigationName=" + DocumentNavigationName;
                filterData = "NoteType=" + NoteType + "^keyfieldvalue=0^keyscreenid=" + KeyScreenId + "^documentId=0^DocumentNavigationId=" + DocumentNavigationId + "^DocumentNavigationName=" + DocumentNavigationName;

                $.ajax({
                    type: "POST",
                    url: "../BasePages/Documents.aspx?scId=" + KeyScreenId + '&isExternalURL=' + isExternalURL + "&isPopUp=" + IsPopupWindow,
                    data: 'action=new&ajaxRequest=true&requestParametersValues=' + filterData + '&historyId=' + CurrentHistoryId + "&CurrentBannerTabIndex=" + globalBannerTabIndex,
                    success: LoadDocumentCallBack
                });
            }
            else {

                filterData = "NoteType=" + NoteType + "^DocumentNavigationId=" + DocumentNavigationId + "^DocumentNavigationName=" + DocumentNavigationName;

                $.ajax({
                    type: "POST",
                    url: "../BasePages/Documents.aspx?scId=" + screenId + '&isExternalURL=' + isExternalURL + "&isPopUp=" + IsPopupWindow,
                    data: 'action=new&ajaxRequest=true&requestParametersValues=' + filterData + '&historyId=' + CurrentHistoryId,
                    success: LoadDocumentCallBack
                });
            }

        }

        //For setting div scroll
        SetDivScroll();
        return false; //False returned by sonia to Manage History as otherwise new history node is created

    }
    catch (e) {

    }
}

function onSuccessHarborTreatmentPLan(result, controlId, keyValue, keyFieldName, args) {
    //return onSuccess2(result, controlId, keyValue, keyFieldName);
    CreateUnsavedInstanceOnDatasetChange();

    if ((controlId.indexOf("DropDownList_TPInterventionProvider_") == 0) || (controlId.indexOf("DropDownList_TPInterventionService_") == 0)) {


        if (controlId.indexOf("DropDownList_TPInterventionProvider_") != 0) {

            var id = controlId.split("_")[2];
            var TPInterventionProcedureId = keyValue;
            var LocID = $("input[id$=HiddenFieldLocID]").val();
            var ProviderSelectedVal = $('[id=DropDownList_TPInterventionProvider_' + id + ']').val();
            var TPInterventionService = $('[id=DropDownList_TPInterventionService_' + id + ']').val();
            if (TPInterventionService != "" && TPInterventionService != null) {
                if (result.toString() == "SelectAuthorization") {
                    OpenPage(5765, 162, 'AuthorizationCodeId=' + TPInterventionService + '^SiteId=' + ProviderSelectedVal + '^TPInterventionProcedureId=' + TPInterventionProcedureId + '^LocId=' + LocID, null, GetRelativePath(), 'T', "dialogHeight:250px; dialogWidth: 680px;dialogTitle:Authorizations;dialogcrossbutton:hide");
                }
                else {
                    OpenPage(5765, 161, 'AuthorizationCodeId=' + TPInterventionService + '^SiteId=' + ProviderSelectedVal + '^TPInterventionProcedureId=' + TPInterventionProcedureId + '^LocId=' + LocID, null, GetRelativePath(), 'T', "dialogHeight: 580px; dialogWidth: 950px;dialogTitle:Frequency Scope And Duration;dialogcrossbutton:hide");
                }
            }
        }
        else if (controlId.indexOf("DropDownList_TPInterventionProvider_") == 0) {
            if (args.length > 6) {
                SelectedIndexChanged(args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
            }
        }
    }

}


function OpenModelDialogueQuickTransitonPlans(TextBoxQuickTransitions) {
    var myDate = new Date();
    OpenPage(5765, 10667, "goaltextId=" + TextBoxQuickTransitions + '^quickTxtableName=CustomTPGlobalQuickTransitionPlans^tableName=CustomTreatmentPlans^time=' + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 570px; dialogWidth: 830px;dialogTitle:");
}

function HandleUseQuickTxPlan() {
    try {

        //Send Key value as parameter
        //Modified by Anuj on 17June,2010 for task ref:540
        if ($("input[type='radio']:checked").length > 0) {
            var CountSelectedCheckBox = $("input[type='radio']:checked");
            var txtAreaId = $("input[type='radio']:checked")[0].TextAreaId;
            if (CountSelectedCheckBox.length == 1) {
                //Commented By Devi Dayal 7 July 2011 this function are used to stop the ajax request as per the requirement it is not 
                // required to generate the HTML on click on USE button on For the Popup(Use Quick Objective Popup)
                if (typeof parent.StopAjaxRequest == 'function') {
                    var retVal = parent.StopAjaxRequest($("[id$=" + txtAreaId + "]").val());
                    if (retVal == false)
                        parent.CloaseModalPopupWindow();
                    return false;
                }
                var objectTableField = $("[id$=HiddenFieldTableName]");
                var objectTxTableField = $("[id$=HiddenFieldTxTableName]");
                var keyTxValue = $("input[type='radio']:checked")[0].keyValue;

                var keyValue = $("[id$=HiddenFieldKeyValue]");
                var keyFieldName = $("[id$=HiddenFieldKeyName]");

                var resolveUrl = $("[id$=HiddenFieldRelativePath]");
                //End
                var myDate = new Date();

                $.post(resolveUrl.val() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?keyTxValue=" + keyTxValue, 'action=updateusequicktxplan&tableField=' + objectTableField.val() + '&txtableField=' + objectTxTableField.val() + '&keyValue=' + escape(keyValue.val()) + '&keyFieldName=' + keyFieldName.val() + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onUpdateQuickTransitionsText);
                var PrimaryTable = $("input[id$=HiddenFieldPrimaryTable]").val();
                //parent.document.getElementById(keyValue.val()).value = $("[id$=" + txtAreaId + "]").val();
                //window.returnValue = $("[id$=" + txtAreaId + "]").val();
                parent.SetValueFromHandleUseQuickTxPlan($("input[id$=HiddenFieldgoaltextId]").val(), $("[id$=" + txtAreaId + "]").val(), PrimaryTable);
            }
            else {

                ShowMsgBox('Please select.', 'Message', MessageBoxButton.OK, MessageBoxIcon.Information);

            }
        }

    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}
function onUpdateQuickTransitionsText() {
    parent.CloaseModalPopupWindow();
    parent.CreateUnsavedInstanceOnDatasetChange();
    CreateUnsavedInstanceOnDatasetChange();
}

function OpenModelDialogueAddtoQuickTransitonPlans() {
    parent.CloaseModalPopupWindow();
    parent.CreateUnsavedInstanceOnDatasetChange();
    CreateUnsavedInstanceOnDatasetChange();
}

function OpenModelDialogueAddQuickTransitions(tableName, textBoxTransitionText) {
    try {
        var goalText = $("[id$=" + textBoxTransitionText + "]");

        //End
        var myDate = new Date();

        OpenPage(5765, 10668, "tableName=" + tableName + "^goalText=" + escape(goalText[0].value) + "^time=" + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 450px; dialogWidth: 700px;dialogTitle:");

    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}

//function OnChangeAuthorizationCodes(DropDownAuthorizationCodes) {
//    AuthorizationCodeId = 120;
//    ServiceId = -1;
//    
//    $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?TPServiceId=" + ServiceId + "&AuthorizationCode="+AuthorizationCodeId, 'action=authorizationcodeschange', RecreateHarborTxPlanControlOnSuccess);
//}

//function OnChangeAuthorizationCodesSuccess(result) {
//    CreateUnsavedInstanceOnDatasetChange();
//
//}

/* Commented to preserve tab
function OnChangeAuthorizationCodes(DropDownAuthorizationCodes, ServiceId) {
    AuthorizationCodeId = DropDownAuthorizationCodes.value;
    //ServiceId = -1;

    $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?TPServiceId=" + ServiceId + "&AuthorizationCode=" + AuthorizationCodeId, 'action=authorizationcodeschange', RecreateHarborTxPlanControlOnSuccess);
}

function OnChangeAuthorizationCodesSuccess(result) {
    CreateUnsavedInstanceOnDatasetChange();

}
*/

function OnChangeAuthorizationCodes(DropDownAuthorizationCodes, ServiceId) {
    AuthorizationCodeId = DropDownAuthorizationCodes.value;
    //ServiceId = -1;

    $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx?TPServiceId=" + ServiceId + "&AuthorizationCode=" + AuthorizationCodeId, 'action=authorizationcodeschange', function(result) { OnChangeAuthorizationCodesSuccess(result, AuthorizationCodeId, ServiceId); });
}
function OnChangeAuthorizationCodesSuccess(result, AuthorizationCodeId, ServiceId) {
    if (result != "" && result.toString().indexOf(";")>-1) {
        var arrStr = result.toString().split(";");

        $('input#Text_CustomTPServices_Units_' + ServiceId).val(arrStr[0]);
        $('span#AuthorizationUnitType_' + ServiceId).text(arrStr[1]);
    }
    CreateUnsavedInstanceOnDatasetChange();

}
function RecreateHarborTxPlanControlOnSuccess(result) {
    try {


        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            //$("#PanelTxPlanMain")[0].outerHTML = pageResponse;
            if ($("[id$=PanelTxPlanMain]").length > 0) {
                $("[id$=PanelTxPlanMain]")[0].outerHTML = pageResponse;
            }
            //SetDivScroll('TreatmentPlanHRM_C1');
            /* Dirty = 'True';*/
            parent.CreateUnsavedInstanceOnDatasetChange(); //Added on 2 July,2010
        }

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

function ModifyGoalValueInDataSetCheckInteger(keyValue, tableName, fieldName, controlId, actionName, keyFieldName) {
    try {


        var cObject = $('[id$=' + controlId + ']');

        if (!validateDecimal(cObject[0], 4)) {
            $(cObject).val("");
        }
        //        if (isInteger($(cObject).val()) == false) {
        //            $(cObject).val("");
        //        }
        ModifyGoalValueInDataSet(keyValue, tableName, fieldName, controlId, actionName, keyFieldName)

    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmentPlan'); //Code added by Devinder 
    }
}
