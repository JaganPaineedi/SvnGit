var TPConfirmCaption = 'Confirmation Message';
var TPAlertCaption = 'Message';
var hidScroll = 0;
var scrollPostion = 0;
var scrollFor = '';
//Added By Priya
var SortExpressionProcedure = '';

//Function to get the selected goal Value 
//CreatedOn:04 Sept 2009
//Author: Anuj Tomar
var CountSelectedGoal = 0;
var GoalTextAreaValue;

//function SelectAuthorization(Id) {
//    alert(Id);
//}

function CheckBoxSelectOneGoal(Id) {
    try {
        var CountSelectedCheckBox = $("input[type='checkbox']:checked").length;
        CountSelectedGoal = CountSelectedCheckBox;
        GoalTextAreaValue = document.getElementById(Id.TextAreaId).value;
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
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
        $.post(resolveUrl[0].value + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?quickId=" + quickId, 'action=deletequicktxplan&tableName=' + tableName + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onSuccessAddToQuickTxPlan);

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Function is called on succss of DeleteQuickTxPlan to Recreate Html
//CreatedOn:04 Sept 2009
//Author: Anuj Tomar

//Now this function is called on HRMTpQuickTxPlan Custom Popup On 2 July,2010
function onSuccessAddToQuickTxPlan(result) {
    try {
        // var callBackId = $("#LinkCallBack")[0].id;
        var callBackId = $("[id$=LinkCallBack]")
        __doPostBack(callBackId[0].id, null);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}


//Description:Function to Open HRMTPAssignProcedure
//CreatedOn:04 Sept 2009
//Author: Anuj Tomar
function openHRMTPAssignProcedure() {
    try {
        //Get RelativeURL
        var resolveUrl = $("[id$=HiddenFieldRelativePath]");
        //End
        var myDate = new Date();
        returnValue = window.showModalDialog(resolveUrl[0].value + "ActivityPages/Client/Detail/TreatmentPlanHRM/HRMTPAssignProcedure.aspx?time=" & myDate.getMinutes() + myDate.getSeconds(), "null", "center:yes;resizable:no;dialogHeight=880px;dialogWidth:1000px;scrollbars;no");
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Description:Function to Open AddEditGoal Popup
//CreatedOn:04 Sept 2009
//Author: Vikas Vyas
function OpenModelDialogueEditGoal(needId) {
    try {
        returnValue = window.showModalDialog("../ActivityPages/Client/Detail/TreatmentPlanHRM/HRMTPGoal.aspx?needId=" + needId + "", "null", "center:yes;resizable:no;dialogWidth:830px;dialogHeight:650px;");
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}






//Description:Open HRMTPAssociatedNeeds Pop Up
//CreatedOn:08 Sept 2009
//Author: Vikas Vyas
function OpenModelDialogueforAssociatedObjective(containerId, needId, tpInterventionProcedureId) {
    try {
        //Changes made by Vikas Kasyup-22/Oct/2011 Ref task No. 338- To show processing until the popup open
        PopupProcessing();
        var myDate = new Date();
        OpenPage(5765, 10194, 'needId=' + needId + '^tpInterventionProcedureId=' + tpInterventionProcedureId + '^time=' + myDate.getMinutes() + myDate.getSeconds() + '^containerId=' + containerId, null, GetRelativePath(), 'T', "dialogHeight: 500px; dialogWidth: 480px;dialogTitle:Associated Objectives");

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Author :Mahesh
//Created On : 2 July,2010
//Description : This fucntion is called from HRMTPAssociatedObjectives pop up and set the values in container
function SetsValueOfAssociatedObjective(returnValue, containerId) {
    try {

        if (returnValue != undefined) {
            parent.CreateUnsavedInstanceOnDatasetChange();
            document.getElementById(containerId).innerHTML = returnValue;
        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}
//Method override by Vikas Kasyup-22/Oct/2011 Ref task No. 338- To hide processing after popup open
function PopUpCloseCallBackComplete() {
    HidePopupProcessing();
}


//Description:GetAssociatedObjective Control  HTML 
//CreatedOn:19-Sept-2009
//Author: Vikas Vyas
function ModifyGoalValueInDataSet(keyValue, tableName, fieldName, controlId, actionName, keyFieldName) {
    try {
        
        
        //Changes made by Vikas Kasyup-22/Oct/2011 Ref task No. 338- To show processing until the popup open
        PopupProcessing();

        //var controlId = control.id;
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
                if (returnValue != '' && returnValue != 'Value is null') {

                    cObject.val('');
                    return false;
                }
            }



            if (cObject[0].type == "radio") //Handle Case for  Radio Control 
            {
                cValue = cObject[0].value;
            }
            else if (cObject[0].type == "checkbox")  //Handle Case for CheckBox Control
            {
                if (cObject[0].checked == false) {
                    cValue = "N";
                }
                else {
                    cValue = "Y";
                }
            }
            else {
                //Below code added by Rakesh w.r.f to 398 in SC web phase II bugs/Features to support + sign saves in database Treatment Plan: Intervention text
                cValue = encodeText(cObject.val());
                //cValue = escape(cObject.val());
                //Changes end here
            }
        }

        var siteId = $('[id$=' + controlId + ']').attr("SiteId"); ;


        var selectedGoalNo = $('[id$=' + controlId + ']').attr("goalNo");
        var authCodeId = $('[id$=' + controlId + '] option:selected').val();
        var tpProcedureId = $('[id$=' + controlId + ']').attr("TPProcedureId");
        //var textValue =  $('[id$=' + controlId + '] option:selected').text();

        var args = arguments;

        var myDate = new Date();
        // $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?keyValue=" + keyValue, 'action=' + actionName + '&tableName=' + tableName + '&fieldName=' + fieldName + '&controlValue=' + cValue + '&keyFieldName=' + keyFieldName + '&GoalNo=' + selectedGoalNo + '&AuthCodeId=' + authCodeId + '&TPProcedureId=' + tpProcedureId + '&TextValue=' + textValue + '&time=' + myDate.getMinutes() + myDate.getSeconds(), function(result) { onSuccess(result, controlId, keyValue, keyFieldName); });
         $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?keyValue=" + keyValue, 'action=' + actionName + '&tableName=' + tableName + '&fieldName=' + fieldName + '&controlValue=' + cValue + '&keyFieldName=' + keyFieldName + '&GoalNo=' + selectedGoalNo + '&SiteId=' + siteId + '&AuthCodeId=' + authCodeId + '&TPProcedureId=' + tpProcedureId + '&time=' + myDate.getMinutes() + myDate.getSeconds(), function(result) { onSuccess(result, controlId, keyValue, keyFieldName, args); });
       
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}



//Modified By Damanpreet Kaur
//Used on custom popup HRMViewClientNeeds
//Modified By Rakesh 26-12-2010

function onSuccess(result, controlId, keyValue, keyFieldName, args) {
    //return onSuccess2(result, controlId, keyValue, keyFieldName);
    HidePopupProcessing();
    CreateUnsavedInstanceOnDatasetChange();
    //Added by Mamta Gupta - Ref Task No. 755 - SCWebPhaseII Bugs/Features - To stop open popup in case of siteId -2
    if ('DropDownList_TPInterventionProvider_' + keyValue != controlId) {
        if ($('[Id$=DropDownList_TPInterventionProvider_' + keyValue + ']').length > 0) {
            var Providerval = $('[Id$=DropDownList_TPInterventionProvider_' + keyValue + ']').val();
            if (parseInt(Providerval) == -2) {
                return;
            }
        }
    }
    
    if ((controlId.indexOf("DropDownList_TPInterventionProvider_") == 0) || (controlId.indexOf("DropDownList_TPInterventionService_") == 0)) {
        //        var TPInterventionService;
        //        var Count = AutoSaveXMLDom.find("TPInterventionProcedures TPInterventionProcedureId").length;
        //        var TPInterventionProcedureId = keyValue;
        //        var AuthorizationCodeIds;
        //        var ProviderIds;
        //        var ProviderSelectedVal;
        //        var calledTo;
        //        var SiteName;
        //        var AuthorizationCodeName;
        //        
        //        if (controlId.indexOf("DropDownList_TPInterventionProvider_") != -1) {
        //            ProviderSelectedVal = $('[id=' + controlId + ']').val();
        //            var id = controlId.split("_")[2];
        //            TPInterventionService = $('[id=DropDownList_TPInterventionService_' + id + ']').val();
        //        }
        //        else {
        //            TPInterventionService = $('[id=' + controlId + ']').val();
        //            var id = controlId.split("_")[2];
        //            ProviderSelectedVal = $('[id=DropDownList_TPInterventionProvider_' + id + ']').val();
        //        }
        //        if (TPInterventionService != "") 
        //        {
        //            for (var i = 0; i < Count; i++) {
        //                if (AutoSaveXMLDom.find("TPInterventionProcedures SiteId")[i] != undefined) {
        //                    ProviderIds = AutoSaveXMLDom.find("TPInterventionProcedures SiteId")[i].nodeTypedValue;
        //                    //SiteName = AutoSaveXMLDom.find("TPInterventionProcedures SiteName")[i].nodeTypedValue;
        //                    //CreateAutoSaveXml('TPInterventionProcedures', 'SiteName', SiteName);
        //                }
        //                else {
        //                    ProviderIds = "-1";
        //                    //SiteName = "Summit Pointe";
        //                }
        //                AuthorizationCodeIds = AutoSaveXMLDom.find("TPInterventionProcedures AuthorizationCodeId")[i].nodeTypedValue;
        //                //AuthorizationCodeName = AutoSaveXMLDom.find("TPInterventionProcedures AuthorizationCodeName")[i].nodeTypedValue;
        //                //CreateAutoSaveXml('TPInterventionProcedures', 'AuthorizationCodeName', AuthorizationCodeName);
        //                if (ProviderIds == ProviderSelectedVal && AuthorizationCodeIds == TPInterventionService) {
        //                    calledTo = "SelectAuthorization";
        //                    i = Count;
        //                }
        //                else if (ProviderIds != ProviderSelectedVal && AuthorizationCodeIds != TPInterventionService) {
        //                    calledTo = "FrequencyScopeAndDuration";
        //                }
        //                else if (ProviderIds != ProviderSelectedVal && AuthorizationCodeIds == TPInterventionService) {
        //                    calledTo = "FrequencyScopeAndDuration";
        //                }
        //                else if (ProviderIds == ProviderSelectedVal && AuthorizationCodeIds != TPInterventionService) {
        //                    calledTo = "FrequencyScopeAndDuration";
        //                }
        //            }

        if (controlId.indexOf("DropDownList_TPInterventionProvider_") != 0) {

            var id = controlId.split("_")[2];
            var TPInterventionProcedureId = keyValue;
            var LocID = $("input[id$=HiddenFieldLocID]").val();
            var ProviderSelectedVal = $('[id$=DropDownList_TPInterventionProvider_' + id + ']').val();
            var TPInterventionService = $('[id$=DropDownList_TPInterventionService_' + id + ']').val();
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
    //Modified by sourabh, to display effective end date when we check 'Inactive' checkbox with ref to task#190
    else if (controlId.indexOf("CheckBox_TPProcedures_Inactive") == 0) {

        if ($('#' + controlId).attr('checked')) {
            var CurrentDate = new Date().format("MM/dd/yyyy");
            $('[id*=CheckBox_TPProcedures_Inactive').each(
            function(index) {
                if ($(this).attr('TPProcedureId') == keyValue) {
                    var strSplitId = $(this).attr('id').split('_')[3];
                    $('#Text_TPProcedures_EffectiveEndDate_' + strSplitId).val('');
                    $('#Text_TPProcedures_EffectiveEndDate_' + strSplitId).attr("disabled", "");
                    $(this).attr('checked', 'checked');
                }
            }
           );
        }
        else {
            $('[id*=CheckBox_TPProcedures_Inactive').each(
            function(index) {
                if ($(this).attr('TPProcedureId') == keyValue) {
                    var strSplitId = $(this).attr('id').split('_')[3];
                    $('#Text_TPProcedures_EffectiveEndDate_' + strSplitId).val('');
                    $('#Text_TPProcedures_EffectiveEndDate_' + strSplitId).attr("disabled", "disabled");
                    $(this).attr('checked', false);
                }
            }
           );
        }
    }
    //Modified by sourabh, to display effective for all same TPProcedureId with ref to task#190
    else if (controlId.indexOf("Text_TPProcedures_EffectiveEndDate") == 0) {
    var effectiveEndDate = $('#' + controlId).val();
    $('[id*=Text_TPProcedures_EffectiveEndDate').each(
            function(index) {
                if ($(this).attr('ProcedureId') == keyValue) {

                    var strSplitId = $(this).attr('id').split('_')[3];
                    $('#Text_TPProcedures_EffectiveEndDate_' + strSplitId).val(effectiveEndDate);

                }
            });
    }

}
//Now this function is used on HRMTPAssociatedObjectives popup 
function GetAssociatedObjectiveControlHTML() {
    try {
        var strHTML = "";
        var checkBoxCollection = $("input[type='checkbox']");
        var objectTPInterventionProcedureId = $("[id$=HiddenFieldTPInterventionProcedureId]");
        if (checkBoxCollection.length > 0)  //Perform Check for Length
        {
            for (checkBoxCount = 0; checkBoxCount < checkBoxCollection.length; checkBoxCount++) {
                if (strHTML == "") {
                    strHTML = checkBoxCollection[checkBoxCount].value + "$$" + checkBoxCollection[checkBoxCount].checked;
                }
                else {
                    strHTML = strHTML + "||" + checkBoxCollection[checkBoxCount].value + "$$" + checkBoxCollection[checkBoxCount].checked;
                }
            }
        }

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpInterventionProcedureId=" + objectTPInterventionProcedureId[0].value, 'action=editassociatedobjective&strHTML=' + strHTML + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onAssocitedNeedSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Description:Open HRMTPAssociatedNeeds Pop Up
//CreatedOn:08 Sept 2009
//Author: Vikas Vyas
function OpenModelDialogueforAssociatedNeeds(containerId, needId, needNumber) {
    try {


        var myDate = new Date();
        OpenPage(5765, 10186, "needId=" + needId + '^needNumber=' + needNumber + "^time=" + myDate.getMinutes() + myDate.getSeconds() + "^containerId=" + containerId, null, GetRelativePath(), 'T', "dialogHeight: 530px; dialogWidth: 480px;dialogTitle:");


    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
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


//Description:GetAssociatedNeedControl HTML 
//CreatedOn:09-Sept-2009
//Author: Vikas Vyas

//Now on use HRMTPAssociateds.ascx
function GetAssociatedNeedControlHTML() {
    try {
        var strHTML = "";
        var checkBoxCollection = $("input[type='checkbox']");
        var objectNeedId = $("[id$=HiddenFieldNeedId]");
        if (checkBoxCollection.length > 0)  //Perform Check for Length
        {
            for (checkBoxCount = 0; checkBoxCount < checkBoxCollection.length; checkBoxCount++) {
                if (strHTML == "") {
                    strHTML = checkBoxCollection[checkBoxCount].value + "$$" + checkBoxCollection[checkBoxCount].checked;
                }
                else {
                    strHTML = strHTML + "||" + checkBoxCollection[checkBoxCount].value + "$$" + checkBoxCollection[checkBoxCount].checked;
                }
            }
        }


        //End
        var myDate = new Date();

        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + objectNeedId[0].value, 'action=editassociatedneed&strHTML=' + strHTML + " &time" + myDate.getMinutes() + myDate.getSeconds(), onAssocitedNeedSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Now use on HRMTPAssociatedNeeds
//Now using on sepratly on popups 
function onAssocitedNeedSuccess(result) {
    try {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            window.returnValue = pageResponse; //Assign the Parsed HTML
            Dirty = 'True';
            window.close();
        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
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
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Description:Open HRMTPAddQuickTxPlan Pop Up
//Author:Vikas Vyas
//CreatedOn:10th-Sept-2009
function OpenModelDialogueAddQuickTxPlan(tableName, textBoxGoalText) {
    try {
        //Changes made by Vikas Kasyup-22/Oct/2011 Ref task No. 338- To show processing until the popup open
        PopupProcessing();
        var goalText = $("[id$=" + textBoxGoalText + "]");

        //End
        var myDate = new Date();

        OpenPage(5765, 10189, "tableName=" + tableName + "^goalText=" + escape(goalText[0].value) + "^time=" + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 450px; dialogWidth: 700px;dialogTitle:");

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
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
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tableName=" + objectTableField[0].value, 'action=updatequicktxplan&goalText=' + objectTPElementText[0].value + '&elementTitle=' + objectTPElementTitle[0].value + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onUpdateQuickTxPlanSuccess);

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Now this function is used on HRMAddQuickTxPlan on 2 July,2010
function onUpdateQuickTxPlanSuccess(result) {
    try {
        window.close();
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}




//Added By Anuj Tomar
//CreatedOn:11th-Sept-2009
//This function is used to Fill the Total Units in the Text box
function fillTotalUnits(result) {
    try {
        $('input[type=text][id=TextBox_TPInterventionProcedures_TotalUnits]')[0].value = result;
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Added By Anuj Tomar
//CreatedOn:11th-Sept-2009
//This function is used to check blank values for Total Units to be calculate.
function checkForBlankValues() {
    try {
        if ($('input[type=text][id=TextBox_TPInterventionProcedures_Units]')[0].value != '' &&
    $('input[type=text][id=TextBox_TPInterventionProcedures_StartDate]')[0].value != '' &&
    $('input[type=text][id=TextBox_TPInterventionProcedures_EndDate]')[0].value != '' &&
    $('select[id$=DropDownList_TPInterventionProcedures_FrequencyType]')[0].value > 0) {
            return true;
        }
        else {
            return false;
        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Description:Open HRMQuickTxPlan Common for all (useQuickGoal,useQuickObjective,useQuickIntervention)
//Author:Vikas Vyas
//CreatedOn:10th-Sept-2009
function OpenModelDialogueQuickTxPlan(keyValue, goaltextId, quickTxtableName, tableName) {
    try {
        //Changes made by Vikas Kasyup-22/Oct/2011 Ref task No. 338- To show processing until the popup open
        PopupProcessing();
        var myDate = new Date();
        OpenPage(5765, 10190, "goaltextId=" + goaltextId + "^keyValue=" + keyValue + '^quickTxtableName=' + quickTxtableName + '^tableName=' + tableName + '^time=' + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 570px; dialogWidth: 830px;dialogTitle:");

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}
///Description:Perform check validation for selection / update goaltext in DataSet by ajax call
//Author:Vikas Vyas
//CreatedOn:11th-Sept-2009

//This function is called on HRMTPQUICKTXPLAN .ASCX ON  12 00 am 7 ,JULY,2010
function HandleUseQuickTxPlan() {
    try {


        //Send Key value as parameter
        //Modified by Anuj on 17June,2010 for task ref:540
        var objectTableField = $("input[id$=HiddenFieldTableName]");
        var objectTxTableField = $("input[id$=HiddenFieldTxTableName]");
        var keyTxValue = $("input[type='radio']:checked")[0].keyValue;

        var keyValue = $("input[id$=HiddenFieldKeyValue]");
        var keyFieldName = $("input[id$=HiddenFieldKeyName]");

        var resolveUrl = $("input[id$=HiddenFieldRelativePath]");
        //End
        var myDate = new Date();

        $.post(resolveUrl[0].value + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?keyTxValue=" + keyTxValue, 'action=updateusequicktxplan&tableField=' + objectTableField[0].value + '&txtableField=' + objectTxTableField[0].value + '&keyValue=' + keyValue[0].value + '&keyFieldName=' + keyFieldName[0].value + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onUpdateQuickTxPlanSuccess);
        var txtAreaId = $("input[type='radio']:checked")[0].TextAreaId;
        window.returnValue = $("[id$=" + txtAreaId + "]").val();



    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Created on 7 July,2010 by mahesh , 12 52
//Purpose : set the values from popup HRMTPQUICKTXPLAN .ascx

function SetValueFromHandleUseQuickTxPlan(textId, result) {
    try {

        $("[id$=" + textId + "]").val(result);
        $("[id$=" + textId + "]").focus();
        parent.CreateUnsavedInstanceOnDatasetChange();

    }
    catch (err) {
    }
}

//Description:Method is used to Insert New Row in the TPObjective table
//Author:Vikas Vyas
//CreatedOn:16th-Sept-2009
function AddObjective(needId) {
    try {

        scrollPostion = document.getElementById("TreatmentPlanHRM_C1").scrollTop;
        scrollFor = "AddObjective";
        PopupProcessing();
        var myDate = new Date();
        //$.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=addobjective&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHRMTxPlanControlOnSuccess);
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=addobjective&time=' + myDate.getMinutes() + myDate.getSeconds(), function(result) { onSuccessRecreateObjectives(result, needId); });
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Description:Method is used to Insert New Row in the TPIntervention table
//Author:Vikas Vyas
//CreatedOn:17th-Sept-2009
function AddIntervention(needId) {
    try {

        scrollPostion = document.getElementById("TreatmentPlanHRM_C1").scrollTop;
        scrollFor = "AddIntervention";
        PopupProcessing();
        var myDate = new Date();
        var LocID = $("input[id$=HiddenFieldLocID]").val();
        //$.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=addintervention&time=' + myDate.getMinutes() + myDate.getSeconds() + '&LocID=' + LocID, RecreateHRMTxPlanControlOnSuccess);
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=addintervention&time=' + myDate.getMinutes() + myDate.getSeconds() + '&LocID=' + LocID, function(result) { onSuccessAddIntervention(result, needId); });
    }
    catch (err) {
        HidePopupProcessing();
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description:Call to Recreate  the HRMTxPlan Control
//Author:Vikas Vyas
//CreatedOn:16th-Sept-2009
function RecreateHRMTxPlanControlOnSuccess(result) {
    try {
        //debugger;
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            $('input,textarea', pageResponse).each(function() {
                if (this.innerText != "") this.innerText = unescape(this.innerText);
            });
            if ($("[id$=PanelTxPlanMain]").length > 0) {
                $("[id$=PanelTxPlanMain]")[0].outerHTML = pageResponse;
            }
            SetDivScroll('TreatmentPlanHRM_C1');
            /* Dirty = 'True';*/
            parent.CreateUnsavedInstanceOnDatasetChange(); //Added on 2 July,2010
        }
        var scrollPos = 0;
        switch (scrollFor) {
            case "AddObjective":
                scrollPos = 80;
                break;
            case "AddIntervention":
                scrollPos = 110;
                break;
            case "AddGoal":
                scrollPos = 450;
                break;
        }
        if (scrollPos > 0) document.getElementById("TreatmentPlanHRM_C1").scrollTop = parseInt(document.getElementById("TreatmentPlanHRM_C1").scrollTop) + scrollPos;
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder
    }
    //Added by sourabh with ref to task#519
    HidePopupProcessing();
    //end here
}
//Description:Method is use to Delete objective associated with goal
//Author:Vikas Vyas
//CreatedOn:16th-Sept-2009
function DeleteObjective(needId, objectiveId) {
    try {
        //Modified by sourabh with ref to task#521, to resolve popup processing issue.
        ShowMsgBox('Are you sure you want to remove this Objective?', TPConfirmCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'DeleteObjectiveOkOption(\'' + needId + '\',\'' + objectiveId + '\');',null,null,null,null,true);
        //end here
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

function DeleteObjectiveOkOption(needId, objectiveId) {
    try {
        var myDate = new Date();
        //Added by sourabh with ref to task#519
        PopupProcessing();
        //end here
        //$.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=deleteobjective&objectiveId=' + objectiveId + '&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHRMTxPlanControlOnSuccess);
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=deleteobjective&objectiveId=' + objectiveId + '&time=' + myDate.getMinutes() + myDate.getSeconds(), function(result) { onSuccessDeleteObjective(result, objectiveId, needId) });
    }
    catch (err) {
        //Added by sourabh with ref to task#519
        HidePopupProcessing();
        //end here
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description:Method is used to Deleted Intervention
//Author:Vikas Vyas
//CreatedOn:18th-Sept-2009
function DeleteIntervention(needId, tpInterventionProcedureId, status) {
    try {
        if (status == "true") {
            //Modified by sourabh with ref to task#521, to resolve popup processing issue.
            ShowMsgBox('Are you sure you want to remove this Intervention Procedure?', TPConfirmCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'DeleteInterventionOnOkOption(\'' + needId + '\',\'' + tpInterventionProcedureId + '\');', null, null, null, null, true);
            //end here
        }
        else {
            ShowMsgBox('Intervention Procedure can not be deleted.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            return false;
        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Author : Mahesh
//Created on : 03 July,2010
// Description : split function of delete for using custom message box
function DeleteInterventionOnOkOption(needId, tpInterventionProcedureId) {
    try {
        //debugger;
        var myDate = new Date();
        //Added by sourabh with ref to task#519
        PopupProcessing();
        //end here
        var LocID = $("input[id$=HiddenFieldLocID]").val();
        //$.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=deleteintervention&TPInterventionProcedureId=' + tpInterventionProcedureId + '&time=' + myDate.getMinutes() + myDate.getSeconds() + '&LocID=' + LocID, RecreateHRMTxPlanControlOnSuccess);
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=deleteintervention&TPInterventionProcedureId=' + tpInterventionProcedureId + '&time=' + myDate.getMinutes() + myDate.getSeconds() + '&LocID=' + LocID, function(result) { onSuccessDeleteIntervention(result, tpInterventionProcedureId,needId) });
    }
    catch (err) {
        //Added by sourabh with ref to task#519
        HidePopupProcessing();
        //end here
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description:Method is used to Copy Intervention ( Add new row in TPIntervention Procedure as well as associated tables)
//Author: Vikas Vyas
//CreatedOn:18th-Sept-2009
function QuickCopyIntervention(tpInterventionProcedureId, needId) {
    try {
        var myDate = new Date();
        scrollPostion = document.getElementById("TreatmentPlanHRM_C1").scrollTop;
        scrollFor = "AddIntervention";
        var LocID = $("input[id$=HiddenFieldLocID]").val();
        PopupProcessing();
        //$.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpInterventionProcedureId=" + tpInterventionProcedureId, 'action=quickcopyintervention&time=' + myDate.getMinutes() + myDate.getSeconds() + '&LocID=' + LocID, RecreateHRMTxPlanControlOnSuccess);
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpInterventionProcedureId=" + tpInterventionProcedureId, 'action=quickcopyintervention&time=' + myDate.getMinutes() + myDate.getSeconds() + '&LocID=' + LocID, function(result) {

            //onSuccessQuickCopy(result, tpInterventionProcedureId);
            onSuccessDeleteIntervention(result, tpInterventionProcedureId, needId);
        });
    }
    catch (err) {
        HidePopupProcessing();
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Description:Method is used to open HRMTPGoalrtert
//Author:Vikas Vyas
//CreatedOn:22nd-Sept-2009
function OpenModelDialogueHRMTPGoal(needId, goalTitle) {
    try {
        var myDate = new Date();
        //Changes made by Mamta- SCWebPhaseII Bugs/Features Ref Task 352 7/Dec/2011- To add author name in New goal GoalmoniteredStaffOther field
        var GoalMonitoredStaffOther = $("select[id*=DropDownList_DocumentInformation_AuthorList]").find(":selected").text();
        var GoalMonitoredStaffOtherCheckbox = 'N';
        if (GoalMonitoredStaffOther != '') {
            GoalMonitoredStaffOtherCheckbox = 'Y';
        }
        PopupProcessing();
        //Changes made by Mamta- SCWebPhaseII Bugs/Features Ref Task 352 7/Dec/2011- Two parametes GoalMonitoredStaffOther and GoalMonitoredStaffOtherCheckbox pass to addgoal action
        //$.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=addgoal&time=' + myDate.getMinutes() + myDate.getSeconds() + '&GoalMonitoredStaffOther=' + GoalMonitoredStaffOther + '&GoalMonitoredStaffOtherCheckbox=' + GoalMonitoredStaffOtherCheckbox, RecreateHRMTxPlanControlOnSuccess);
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=addgoal&time=' + myDate.getMinutes() + myDate.getSeconds() + '&GoalMonitoredStaffOther=' + GoalMonitoredStaffOther + '&GoalMonitoredStaffOtherCheckbox=' + GoalMonitoredStaffOtherCheckbox, function(result) { onSuccessAddGoal(result,needId) });
        //  OpenPage(5765, 10191, 'needId=' + needId + '^goalTitle=' + goalTitle + '^time=' + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight:575px; dialogWidth: 830px;dialogTitle:");
    }
    catch (err) {
        HidePopupProcessing();
        LogClientSideException(err, 'HRMTreatmetPlan');
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

//Description:Call Ajax Page and Add/Edit value in DataSet in resepective to their needId
//Author:Vikas Vyas
//CreatedOn:22nd-Sept-2009
//Now this function is used on HRMTPGoal.ascx page
function AddEditGoalValueInDataSet() {
    try {
        //Find all control value
        var needId = $("input[id$=HiddenField_TPNeeds_NeedId]");
        var addEdit = $("input[id$= HiddenField_TPNeeds_AddEdit]");
        var goalText = $("[id$=TextArea_TPNeeds_GoalText]");
        var goalStrengths = $("[id$=TextArea_TPNeeds_GoalStrengths]");
        var goalBarriers = $("[id$=TextArea_TPNeeds_GoalBarriers]");
        var goalActive = $("input[type='radio'][id$=Radio_TPNeeds_GoalActive_Y]");
        var goalActiveValue = "";
        if (goalActive[0].checked == true) {
            goalActiveValue = "Y";
        }
        else {
            goalActiveValue = "N";
        }
        var goalMonitoredStaffOther = $("input[type=text][id^=Text_TPNeeds_GoalMonitoredStaffOther]");
        var goalMonitoredStaffOtherCheckbox = $("input[type=checkbox][id^=Text_TPNeeds_GoalMonitoredStaffOther]");
        var goalMonitoredStaff = $("select[id*=Text_TPNeeds_GoalMonitoredStaff]");
        var goalTargetDate = $("input[type=text][id^=Text_TPNeeds_GoalTargetDate]");
        var goalCreatedDate = $("input[type=text][id^=Text_TPNeeds_GoalStartDate]");  //Text_TPNeeds_GoalStartDate_   
        var stageOfTreatment = $("select[id$=DropDownList_StageOfTreatment]");
        var goalAssociated = $("input[type='checkbox']");
        var naturalSupport = "";
        var goalEmployment = "";
        var goalliviningarragement = "";
        var goalhealthSafety = "";
        var chkGoalMonitoredStaffOtherCheckbox = "";
        if (goalMonitoredStaffOtherCheckbox.attr('checked') == true) {
            chkGoalMonitoredStaffOtherCheckbox = "Y";
        }
        else {
            chkGoalMonitoredStaffOtherCheckbox = "N";
        }
        if (goalAssociated[0].checked == true) {
            naturalSupport = "Y";
        }
        else {
            naturalSupport = "N";
        }
        if (goalAssociated[1].checked == true) {
            goalEmployment = "Y";
        }
        else {
            goalEmployment = "N";
        }
        if (goalAssociated[2].checked == true) {
            goalliviningarragement = "Y";
        }
        else {
            goalliviningarragement = "N";
        }
        if (goalAssociated[3].checked == true) {
            goalhealthSafety = "Y";
        }
        else {
            goalhealthSafety = "N";
        }

        //Get Relative Path
        var resolveUrl = $("input[id$=HiddenFieldRelativePath]");
        //End
        var myDate = new Date();


        if (addEdit[0].value == "Add") {

            //var requestParameterValues = 'action=addgoal&addEdit=' + addEdit[0].value + '&goalText=' + goalText[0].value + '&goalStrengths=' + goalStrengths[0].value + '&goalBarriers=' + goalBarriers[0].value + '&goalActive=' + goalActiveValue + '&goalMonitoredBy=' + goalMonitoredBy[0].value + '&goalTargetDate=' + goalTargetDate[0].value + '&goalCreatedDate=' + goalCreatedDate[0].value + '&stageOfTreatment=' + stageOfTreatment[0].value + '&naturalSupport=' + naturalSupport + '&goalEmployment=' + goalEmployment + '&goalliviningarragement=' + goalliviningarragement + '&goalhealthSafety=' + goalhealthSafety + '&time=' + myDate.getMinutes() + myDate.getSeconds()

            // $.post(resolveUrl[0].value + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId[0].value, 'requestParametersValues=' + requestParameterValues, onAssocitedNeedSuccess);
            //$.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId[0].value, 'action=addgoal&addEdit=' + addEdit[0].value + '&goalText=' + goalText[0].value + '&goalStrengths=' + goalStrengths[0].value + '&goalBarriers=' + goalBarriers[0].value + '&goalActive=' + goalActiveValue + '&goalMonitoredBy=' + goalMonitoredBy[0].value + '&goalTargetDate=' + goalTargetDate[0].value + '&goalCreatedDate=' + goalCreatedDate[0].value + '&stageOfTreatment=' + stageOfTreatment[0].value + '&naturalSupport=' + naturalSupport + '&goalEmployment=' + goalEmployment + '&goalliviningarragement=' + goalliviningarragement + '&goalhealthSafety=' + goalhealthSafety + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onAssocitedNeedSuccess);
            $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId[0].value, 'action=addgoal&addEdit=' + addEdit[0].value + '&goalText=' + goalText[0].value + '&goalStrengths=' + goalStrengths[0].value + '&goalBarriers=' + goalBarriers[0].value + '&goalActive=' + goalActiveValue + '&goalMonitoredStaffOtherCheckbox=' + chkGoalMonitoredStaffOtherCheckbox + '&goalMonitoredStaff=' + goalMonitoredStaff[0].option[goalMonitoredStaff[0].selectedIndex].value + '&goalTargetDate=' + goalTargetDate[0].value + '&goalCreatedDate=' + goalCreatedDate[0].value + '&stageOfTreatment=' + stageOfTreatment[0].value + '&naturalSupport=' + naturalSupport + '&goalEmployment=' + goalEmployment + '&goalliviningarragement=' + goalliviningarragement + '&goalhealthSafety=' + goalhealthSafety + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onAssocitedNeedSuccess);

        }
        if (addEdit[0].value == "Edit") {
            // var requestParameterValues = 'ajaxRequest=true&action=editgoal&addEdit=' + addEdit[0].value + '&goalText=' + goalText[0].value + '&goalStrengths=' + goalStrengths[0].value + '&goalBarriers=' + goalBarriers[0].value + '&goalActive=' + goalActiveValue + '&goalMonitoredBy=' + goalMonitoredBy[0].value + '&goalTargetDate=' + goalTargetDate[0].value + '&goalCreatedDate=' + goalCreatedDate[0].value + '&stageOfTreatment=' + stageOfTreatment[0].value + '&naturalSupport=' + naturalSupport + '&goalEmployment=' + goalEmployment + '&goalliviningarragement=' + goalliviningarragement + '&goalhealthSafety=' + goalhealthSafety + '&time=' + myDate.getMinutes() + myDate.getSeconds()
            // $.post(resolveUrl[0].value + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId[0].value, 'requestParameterValues=' + requestParameterValues, onAssocitedNeedSuccess);
            $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId[0].value, 'action=editgoal&addEdit=' + addEdit[0].value + '&goalText=' + goalText[0].value + '&goalStrengths=' + goalStrengths[0].value + '&goalBarriers=' + goalBarriers[0].value + '&goalActive=' + goalActiveValue + '&goalMonitoredStaffOther=' + goalMonitoredStaffOther[0].value + '&goalMonitoredStaffOtherCheckbox=' + chkGoalMonitoredStaffOtherCheckbox + '&goalMonitoredStaff=' + goalMonitoredStaff[0].option[goalMonitoredStaff[0].selectedIndex].value + '&goalTargetDate=' + goalTargetDate[0].value + '&goalCreatedDate=' + goalCreatedDate[0].value + '&stageOfTreatment=' + stageOfTreatment[0].value + '&naturalSupport=' + naturalSupport + '&goalEmployment=' + goalEmployment + '&goalliviningarragement=' + goalliviningarragement + '&goalhealthSafety=' + goalhealthSafety + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onAssocitedNeedSuccess);
        }

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Function to open ClientNeedList PopUp
//Created By Anuj
//Createde On 23Sep,2009
//ModifiedBy: Vikas Vyas
//ModifiedDate:Nov 09,2009
//Purpose: Add resolve URL as well as myDate and Perform Check Wheather we have open the ViewClientNeed  Pop up or not
function openClientNeed() {
    try {


        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=checkepisodenumber', onOpenClientNeedSuccess);



    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}


//Description:Open ViewClientNeed PopUp if result is true 
//CreatedOn:09 Nov 2009
//Author: Vikas Vyas
function onOpenClientNeedSuccess(result) {

    try {

        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        var responce = pageResponse.trim();
        if (responce != undefined) {
            if (responce.trim() == "fail") {
                // alert("Client needs won't be updated as there is no Client Episode");
                ShowMsgBox('Client needs won\'t be updated as there is no Client Episode.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                return false;
            }
            else {

                // var resolveUrl = $("[id$=HiddenFieldRelativePath]");
                var myDate = new Date();
                //window.showModalDialog(resolveUrl[0].value + "ActivityPages/Client/Detail/TreatmentPlanHRM/HRMViewClientNeeds.aspx?time=" + myDate.getMinutes() + myDate.getSeconds(), "null", "center:yes;resizable:no;dialogHeight=650px;dialogWidth:900px;scrollbars;yes");
                OpenPage(5765, 10185, 'time=' + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 510px; dialogWidth: 900px;dialogTitle:Client Needs");
            }

        }



    }
    catch (err) {

        LogClientSideException(err, 'HRMTreatmetPlan');

    }


}


function SelectedIndexChanged(objeDropdown, dropdownAuthorizationID, spanID, tpInterventionProcedureId, tpProcedureId, authorizationCodeId, disableProcedureProvider) {

    //return SelectedIndexChanged1(objeDropdown, dropdownAuthorizationID, spanID, tpInterventionProcedureId, tpProcedureId, authorizationCodeId, disableProcedureProvider)
    var siteID = -1;
    var LocID;
    //var goalNo = $('[id$=' + dropdownAuthorizationID + ']').attr('goalNo');

    var goalNo = $('[id$=' + objeDropdown.id + ']').attr('goalNo')
    if (objeDropdown.selectedIndex >= 0) {
        siteID = objeDropdown.options[objeDropdown.selectedIndex].value;
        LocID = $("input[id$=HiddenFieldLocID]").val();
    }
    parent.PopupProcessing();
    var myDate = new Date();
    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=fillauthorizationdropdown&time=' + myDate.getMinutes() + myDate.getSeconds() + '&siteID=' + siteID + '&LocID=' + LocID + '&tpInterventionProcedureId=' + tpInterventionProcedureId + '&tpProcedureId=' + tpProcedureId + '&authorizationCodeId=' + authorizationCodeId + '&disableProcedureProvider=' + disableProcedureProvider + '&GoalNo=' + goalNo, function(result) { FillAuthorizationDropdownOnSuccess(result, dropdownAuthorizationID, spanID) });


}



//Function to Add NeedClientList.
//Created By Anuj
//Createde On 23Sep,2009
//ModifiedBy: Vikas Vyas
//ModifiedDate:Nov 10,2009
//Purpose: Add resolve URL as well as myDate and Perform Check Wheather we have open the ViewClientNeed  Pop up or not

//Used on custom popup HRMViewClientNeeds
function addNeedList() {
    try {

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?ClientNeedID=", 'action=addneedlist&time=' + myDate.getMinutes() + myDate.getSeconds(), onSuccessAddToNeedList);

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Function Called on Success of Ajax Call of addNeedList() Function
//Created By Anuj
//Createde On 23Sep,2009

//Used on custom popup HRMViewClientNeeds
function onSuccessAddToNeedList(result) {
    try {

        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            //            $("[id$=PanelClientNeeControl]")[0].innerHTML = pageResponse;
            $("#PanelClientNeeControl").html('');
            $("#PanelClientNeeControl").html(pageResponse);
            $("textarea[setFocus=setFocus]").focus();
            $("textarea[setFocus=setFocus]").focus();

            //            var parentControl = $("#PanelClientNeeControl");
            //            $(":input:not([type='hidden']):not([readOnly]):first", parentControl).html("new val");
            //            $(":input:not([type='hidden']):not([readOnly]):first", parentControl).focus();
            //   $("[setFocus=setFocus]")
            //

        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}

//Function to Delete ClientNeedsList.
//Created By Anuj
//Createde On 24Sep,2009
//ModifiedBy: Vikas Vyas
//ModifiedDate:Nov 10,2009
//Purpose: Add resolve URL as well as myDate and Perform Check wheater this client need is associated or not if associated then deletion can't be possible

//Used on custom popup HRMViewClientNeeds
function DeleteNeedListHTML(ClientNeedId) {
    try {

        var myDate = new Date();

        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?ClientNeedId=" + ClientNeedId, 'action=checkclientneedassociation&time=' + myDate.getMinutes() + myDate.getSeconds(), DeleteNeedListHTMLSuccess);

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}


//Description:Open ViewClientNeed PopUp if result is true 
//CreatedOn:10th Nov 2009
//Author: Vikas Vyas
function DeleteNeedListHTMLSuccess(result) {
    try {

        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        var response = trim(pageResponse);
        if (response != undefined) {
            var outPut = response.split("$$");


            if (outPut[1] == "fail") {
                ShowMsgBox('Intervention Procedure can not be deleted.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                return false;
            }
            else {

                ShowMsgBox('Are you sure you want to delete this Client Need?', TPConfirmCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'DeleteNeedListHTMLSuccessOnOkOption(\'' + outPut[0] + '\');');

            }

        }


    }
    catch (err) {

        LogClientSideException(err, 'HRMTreatmetPlan');

    }

}

//Author : Mahesh
//Created on : 03 July,2010
// Description : split function of delete for using custom message box
function DeleteNeedListHTMLSuccessOnOkOption(ClientNeedId) {
    try {

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?ClientNeedId=" + ClientNeedId, 'action=deleteneedlist&time=' + myDate.getMinutes() + myDate.getSeconds(), onSuccessAddToNeedList);
    }
    catch (err) {

        LogClientSideException(err, 'HRMTreatmetPlan');

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

//Function to update ClientNeedsList.
//Created By Anuj
//Createde On 24Sep,2009
//ModifiedBy: Vikas Vyas
//ModifiedDate:Nov 10,2009
//Purpose: Add resolve URL as well as myDate

//Used on custom popup HRMViewClientNeeds
function UpdateClientNeedList() {
    try {

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?ClientNeedId=", 'action=updateneedlist&time=' + myDate.getMinutes() + myDate.getSeconds(), OnUpdateClientNeedSuccess);
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



//Function to Cancel ClientNeedsList.
//Created By Anuj
//Createde On 24Sep,2009
//ModifiedBy: Vikas Vyas
//ModifiedDate:Nov 10,2009
//Purpose: Add resolve URL as well as myDate 
function CancelClientNeedList() {
    try {

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?ClientNeedId=", 'action=cancelneedlist&time=' + myDate.getMinutes() + myDate.getSeconds(), OnUpdateClientNeedSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }

}

//Function to Delete ClientNeedsList.
//Created By Anuj
//Createde On 24Sep,2009
//Modified By: Vikas Vyas
//Add maxNeedCount Parameter
function DaleteTxPlanGoal(needId, maxNeedCount) {
    var answer = "";

    try {
        if (maxNeedCount == 1) {

            ShowMsgBox('This Goal can not be removed as there is one goal avaliable in TreatmentPlan - HRM', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            return false;
        }
        //Added by sourabh to resolve popup processing issue
        ShowMsgBox('Removing a Goal from a treatment plan will remove the associated  Objectives and Intervention Procedures.Are you sure you want to remove the Goal?', TPConfirmCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'DaleteTxPlanGoalOnOkOption(\'' + needId + '\');', 'DaleteTxPlanGoalOnCloseOption();',null, null, null, true);
        //end here

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Author : Mahesh
//Created on : 03 July,2010
// Description : split function of delete for using custom message box

function DaleteTxPlanGoalOnOkOption(needId) {
    try {
        var myDate = new Date();
        //Added by sourabh with ref to task#519
        PopupProcessing();
        //end here
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?needId=" + needId, 'action=deletegoal&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHRMTxPlanControlOnSuccess);

    }
    catch (err) {
        //Added by sourabh with ref to task#519
        HidePopupProcessing();
        //end here
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
function SetEditedObjectiveVlaueFromPopup(returnValue, objectiveTextId, objectiveTargetDateId, objectiveStatusId) {
    try {
        var objectiveText = $("[id$=" + objectiveTextId + "]");
        var objectiveTargetDate = $("[id$=" + objectiveTargetDateId + "]");
        var objectiveStatus = $("[id$=" + objectiveStatusId + "]");

        if (returnValue != undefined) {
            var result = returnValue.split("$$");
            if (result[1] != "") {
                objectiveText[0].value = result[1];
            }
            else {
                objectiveText[0].value = "";
            }
            if (result[2] != "") {
                objectiveTargetDate[0].value = result[2];
            }
            else {
                objectiveTargetDate[0].value = "";
            }
            if (returnValue[3] != "") {
                objectiveStatus[0].value = result[3].trim();
            }
            else {
                objectiveStatus[0].value = "";
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}

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

        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?objectiveId=" + objectiveId[0].value, 'action=updateobjective&ObjectiveText=' + objectiveText[0].value + '&TargetDate=' + objectiveTargetDate[0].value + '&ObjectiveStatus=' + objectiveStatus[0].value + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onAssocitedNeedSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }

}

//Description:Function used to EditGoal Values
//CreatedOn:04 Sept 2009
//Author: Anuj Tomar
function OpenEditGoalPopUp(needId, GoalDesccriptionId, GoalStrengthId, GoalBarrierId, GoalCreatedId, GoalActiveYId, GoalActiveNId, GoalMoniteredId, GoalTargetId, GoalTreatmentStageId, GoalNaturalSupportId, GoalEmploymentId, GoalLivingArrangementId, GoalClubHouseId, GoalTitle) {

    try {


        var myDate = new Date();
        OpenPage(5765, 10191, "needId=" + needId + "^goalTitle= " + GoalTitle + "^time=" + myDate.getMinutes() + myDate.getSeconds()
        + "^GoalDesccriptionId=" + GoalDesccriptionId + "^GoalStrengthId=" + GoalStrengthId + "^GoalBarrierId=" + GoalBarrierId + "^GoalCreatedId=" + GoalCreatedId
        + "^GoalActiveYId=" + GoalActiveYId + "^GoalActiveNId=" + GoalActiveNId + "^GoalMoniteredId=" + GoalMoniteredId + "^GoalTargetId=" + GoalTargetId
        + "^GoalTreatmentStageId=" + GoalTreatmentStageId + "^GoalNaturalSupportId=" + GoalNaturalSupportId + "^GoalEmploymentId=" + GoalEmploymentId
        + "^GoalLivingArrangementId=" + GoalLivingArrangementId + "^GoalClubHouseId=" + GoalClubHouseId
        , null, GetRelativePath(), 'T', "dialogHeight: 575px; dialogWidth: 830px;dialogTitle:");

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
///Author : Mahesh
// Created on : 2 July,2010
//Functionality : Fill the selected control as [per returned result
function SetEditedVlaueFromPopup(returnValue, GoalDesccriptionId, GoalStrengthId, GoalBarrierId, GoalCreatedId,
        GoalActiveYId, GoalActiveNId, GoalMoniteredId, GoalTargetId, GoalTreatmentStageId, GoalNaturalSupportId
        , GoalEmploymentId, GoalLivingArrangementId, GoalClubHouseId) {
    try {

        if (returnValue != undefined) {
            /*** Region get the objects from IDs*/
            var GoalDesccriptionText = $("[id$=" + GoalDesccriptionId + "]");
            var GoalStrengthText = $("[id$=" + GoalStrengthId + "]");
            var GoalBarrierText = $("[id$=" + GoalBarrierId + "]");
            var GoalStartDateText = $("[id$=" + GoalCreatedId + "]");
            var GoalActiveYValue = $("[id$=" + GoalActiveYId + "]");
            var GoalActiveNValue = $("[id$=" + GoalActiveNId + "]");
            var GoalMoniteredText = $("[id$=" + GoalMoniteredId + "]");
            var GoalTargetText = $("[id$=" + GoalTargetId + "]");
            var GoalTreatmentStage = $("[id$=" + GoalTreatmentStageId + "]");
            var GoalNaturalSupport = $("[id$=" + GoalNaturalSupportId + "]");
            var GoalEmployment = $("[id$=" + GoalEmploymentId + "]");
            var GoalLivingArrangement = $("[id$=" + GoalLivingArrangementId + "]");
            var GoalClubHouse = $("[id$=" + GoalClubHouseId + "]");
            /* End region of get the objects from IDs*/
            /*Dirty = 'True';*/
            parent.CreateUnsavedInstanceOnDatasetChange();
            var result = returnValue.split("$$");
            if (result[1] != "") {
                GoalDesccriptionText[0].value = result[1].trim();
            }
            else {
                GoalDesccriptionText[0].value = "";
            }
            if (result[2] != "") {
                GoalStrengthText[0].value = result[2].trim();
            }
            else {
                GoalStrengthText[0].value = "";
            }
            if (result[3] != "") {
                GoalBarrierText[0].value = result[3].trim();
            }
            else {
                GoalBarrierText[0].value = "";
            }
            if (result[4].trim() == "N") {
                GoalActiveYValue[0].checked = false;
                GoalActiveNValue[0].checked = true;
            }
            else {
                GoalActiveYValue[0].checked = true;
                GoalActiveNValue[0].checked = false;
            }
            if (result[5] != "") {
                GoalMoniteredText[0].value = result[5].trim();
            }
            else {
                GoalMoniteredText[0].value = "";
            }
            if (result[6] != "") {
                GoalTargetText[0].value = result[6].trim();
            }
            else {
                GoalTargetText[0].value = "";
            }
            if (result[7] != "") {
                GoalTreatmentStage[0].value = result[7].trim();
            }
            else {
                GoalTreatmentStage[0].value = "";
            }
            if (result[8] != "") {
                GoalStartDateText[0].value = result[8].trim();
            }
            else {
                GoalStartDateText[0].value = "";
            }
            if (result[9].trim() == "Y") {
                GoalNaturalSupport[0].checked = true;
            }
            else {
                GoalNaturalSupport[0].checked = false;
            }
            if (result[10].trim() == "Y") {
                GoalEmployment[0].checked = true;
            }
            else {
                GoalEmployment[0].checked = false;
            }
            if (result[11].trim() == "Y") {
                GoalLivingArrangement[0].checked = true;
            }
            else {
                GoalLivingArrangement[0].checked = false;
            }
            if (result[12].trim() == "Y") {
                GoalClubHouse[0].checked = true;
            }
            else {
                GoalClubHouse[0].checked = false;
            }
        }
    }
    catch (err) {
    }

}


//Description:Open Renumber Pop Up control
//Author:Vikas Vyas
//CreatedOn:06th Oct,2009
function OpenRenumberTxPlan(tableName, keyFieldName, needNumber, needId) {
    try {
        //Changes made by Vikas Kasyup-22/Oct/2011 Ref task No. 338- To show processing until the popup open
        PopupProcessing();
        var myDate = new Date();
        OpenPage(5765, 10187, "tableName=" + tableName + "^keyFieldName= " + keyFieldName + "^needNumber=" + needNumber + "^needId=" + needId + "^time=" + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 580px; dialogWidth: 480px;dialogTitle:");


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
                else if ((parseInt(control.value) > 0) && (parseInt(control.value) > goalMaxValue[0].value)) {

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
                    else if ((control.value > 0) && (control.value > goalMaxValue[0].value)) {
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
            controlCollection = $("input[type='text'][@renumberText=renumberText][@oldvalue=" + control.value + "]");
        }
        document.getElementById(controlCollection[0].id).value = control.oldValue;
        document.getElementById(controlCollection[0].id).oldValue = control.oldValue;
        if (tableName[0].value == "TPNeeds") {
            document.getElementById(control.id).oldValue = parseInt(control.value);
        }
        else {
            document.getElementById(control.id).oldValue = control.value;
        }
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
                    strHTML = controlCollection[textBoxCount].NeedId + "$$" + controlCollection[textBoxCount].value;
                }
                else {
                    strHTML = strHTML + "||" + controlCollection[textBoxCount].NeedId + "$$" + controlCollection[textBoxCount].value;
                }
            }
        }
        tableName = $("input[id$=HiddenFieldTableName]");
        keyFieldName = $("input[id$=HiddenFieldKeyFieldName]");

        var myDate = new Date();

        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tableName=" + tableName[0].value, 'action=renumbertxplan&strHTML=' + strHTML + '&keyFieldName=' + keyFieldName[0].value + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onAssocitedNeedSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Description:Method is used to Peform CalculateInterventionProcedure using ajax call if success then Open HRMTreatmentPlanProcedure
//Author:Vikas Vyas
//CreatedOn:09 Oct,2009
function AssignProcedure(tpprocedureId) {
    try {

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpprocedureid=" + tpprocedureId, 'action=assignprocedures&time=' + myDate.getMinutes() + myDate.getSeconds(), onAssignProcedureSuccess);
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}
//Description:Method is used to Perform validation success then Open HRMTreatmentPlanProcedure
//Author:Vikas Vyas
//CreatedOn:09 Oct,2009
function onAssignProcedureSuccess(result) {
    try {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        var response = trim(pageResponse);
        if (response != undefined) {
            if (response == "fail") {
                //alert("No Intervention Procedure exists for creating authorization");
                ShowMsgBox('No Intervention Procedure exists for creating authorization.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                return false;
            }
            else {

                var myDate = new Date();
                //returnValue = window.showModalDialog(resolveUrl[0].value + "ActivityPages/Client/Detail/TreatmentPlanHRM/HRMTPAssignProcedure.aspx?time=" + myDate.getMinutes() + myDate.getSeconds(), "null", "center:yes;resizable:no;dialogHeight=800px;dialogWidth:900px;scrollbars:no;");
                OpenPage(5765, 10196, "tpprocedureId=0^time=" + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 580px; dialogWidth: 900px;dialogTitle:HRMTreatment Plan Procedures");



            }

        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}


//Author : Mahesh
//Created on : 04 July,2010
// Description : split function of delete for using custom message box
function setValueAfterOnAssignProcedureSuccess(returnValue) {
    if (returnValue != 'undefined') {
        if (returnValue != "fail") {
            //$("#PanelGridViewProcedure")[0].innerHTML = returnValue;
            // Dirty = 'True';
            parent.CreateUnsavedInstanceOnDatasetChange();

            $("[id$=PanelGridViewProcedure]").html(returnValue);
            var LocID = $("input[id$=HiddenFieldLocID]").val();
            PopupProcessing();
            $.post(resolveUrl[0].value + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=recreatetxplanaftersave&time=' + myDate.getMinutes() + myDate.getSeconds() + '&LocID=' + LocID, RecreateHRMTxPlanControlOnSuccess);

        }
        else {
            return false;
        }

    }
    else {

        return false;
    }
}
var GlobalTPProcedureID = '';
function AssignProcedureClickFromLink(tpprocedureId) {

    GlobalTPProcedureID = tpprocedureId;

    var myDate = new Date();

    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpprocedureid=" + tpprocedureId, 'action=assignprocedures&time=' + myDate.getMinutes() + myDate.getSeconds(), onAssignProcedureClickFromLink);





}


function onAssignProcedureClickFromLink(result) {
    var myDate = new Date();
    OpenPage(5765, 10196, "tpprocedureId=" + GlobalTPProcedureID + "^time=" + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 580px; dialogWidth: 900px;dialogTitle:HRMTreatment Plan Procedures");
}

//Description:
//Author: Not Completed
//CreatedOn:10 Oct,2009
//function GetValueForProcedureGrid(InterventionProvidersId,RequestFrequencyId,RequestStartDateId,RequestEndDateId,RequesTotalUnitId,ApprovedFromDateId,ApprovedToDateId,ApprovedUnitId,ApprovedFrequencyId,StatusId)
//Now this function is called from HRMAssignProcedure pop up
function GetValueForProcedureGrid() {
    try {

        //Perform Do Validate function

        //For ProgramDropDown
        var dropdownProgram = $("select[id$=DropDownList_Programs]");

        if (dropdownProgram[0].selectedIndex == 0) {

            //alert("Please Select Program");
            ShowMsgBox('Please Select Program.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            document.getElementById(dropdownProgram[0].id).focus();
            return false;
        }

        var textBoxTPInterventionProcedure = $("input[type=text][id$=TextBox_TPInterventionProcedures_Units]");
        if (textBoxTPInterventionProcedure[0].value == "") {

            //alert("Please Enter Units Requested");
            ShowMsgBox('Please Enter Units Requested.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            textBoxTPInterventionProcedure[0].focus();
            return false;
        }


        if (textBoxTPInterventionProcedure[0].value != "") {

            if (isNaN(parseInt(textBoxTPInterventionProcedure[0].value)) == true) {
                //alert("Please Enter Valid Unit");
                ShowMsgBox('Please Enter Valid Unit.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                textBoxTPInterventionProcedure[0].focus();
                return false;
            }


            if (textBoxTPInterventionProcedure[0].value == 0 || textBoxTPInterventionProcedure[0].value < 0) {
                //alert("Please Enter Valid Unit");
                ShowMsgBox('Please Enter Valid Unit.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                textBoxTPInterventionProcedure[0].focus();
                return false;
            }

        }


        var dropdownFrequencyType = $("select[id$=DropDownList_TPInterventionProcedures_FrequencyType]");

        if (dropdownFrequencyType[0].value == 0) {

            //alert("Please Select the Frequency Type");
            ShowMsgBox('Please Select the Frequency Type.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            document.getElementById(dropdownFrequencyType[0].id).focus();
            return false;
        }

        // Added Validations by Ankesh        
        var textBoxTPInterventionProcedureStartDate = $('input[type=text][id$=TextBox_TPInterventionProcedures_StartDate]');
        if (textBoxTPInterventionProcedureStartDate[0].value == '') {

            //alert("Please Enter Start Date");
            ShowMsgBox('Please Enter Start Date.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            textBoxTPInterventionProcedureStartDate[0].focus();
            return false;
        }

        var textBoxTPInterventionProcedureEndDate = $('input[type=text][id$=TextBox_TPInterventionProcedures_EndDate]');

        if (textBoxTPInterventionProcedureEndDate[0].value == '') {

            //alert("Please Enter End Date");
            ShowMsgBox('Please Enter End Date.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            textBoxTPInterventionProcedureEndDate[0].focus();
            return false;
        }


        var textBoxTPInterventionProceduresTotalUnits = $('input[type=text][id$=TextBox_TPInterventionProcedures_TotalUnits]');
        if (textBoxTPInterventionProceduresTotalUnits[0].value == '') {

            //alert("Please Enter Total Units");
            ShowMsgBox('Please Enter Total Units.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            textBoxTPInterventionProceduresTotalUnits[0].focus();
            return false;
        }




        if ($("#PanelAssociatedWith").html() == '' || $("#PanelAssociatedWith").html() == '&nbsp;') {
            //alert("Please associate Intervention Procedures with this authorization");
            ShowMsgBox('Please associate Intervention Procedures with this authorization.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
            return false;
        }


        var InterventionProceduerProvider = $("select[id$=DropDownList_Procedure]");
        var RequestFrequency = $("select[id$=DropDownList_TPInterventionProcedures_FrequencyType]");
        var RequestFrequencyName = $("select[id$=DropDownList_TPInterventionProcedures_FrequencyType]");
        var RequestStartDate = $("input[type=text][id$=TextBox_TPInterventionProcedures_StartDate]");
        var RequestEndDate = $("input[type=text][id$=TextBox_TPInterventionProcedures_EndDate]");
        var RequesUnits = $("input[type=text][id$=TextBox_TPInterventionProcedures_Units]");
        var RequesTotalUnit = $("input[type=text][id$=TextBox_TPInterventionProcedures_TotalUnits]");

        var Status = $("[id$=TextBox_TPProcedure_Status]");

        var myDate = new Date();

        var TpprocedureId = $("input[id$=HiddenFieldTPProcedureId]");


        //HiddenFieldTPProcedureId.Value

        var authorizationRequesterComment = $("[id$=TextArea_PeriodicReviews_AuthorizationRequestorComment]");


        if ($("input[type='button'][Id=ButtonInsert]")[0].value == "Modify") {
            $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?interventionProcedureId=", 'action=insertinterventionprocedure&RequestFrequency=' + RequestFrequency[0].value + '&RequestFrequencyName=' + RequestFrequencyName[0][RequestFrequencyName[0].selectedIndex].text + '&RequestStartDate=' + RequestStartDate[0].value + '&RequestEndDate=' + RequestEndDate[0].value + '&RequestTotalUnit=' + RequesTotalUnit[0].value + '&RequesUnits=' + RequesUnits[0].value + '&InterventionProceduerProvider=' + InterventionProceduerProvider[0].value + '&Status=' + Status[0].value + '&tpprocedureId=' + TpprocedureId[0].value + '&program=' + dropdownProgram[0].value + '&requestercomment=' + authorizationRequesterComment[0].value + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onGridbindSuccess);   //InterventionProceduerProvider   

        }
        else {
            $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?interventionProcedureId=", 'action=insertinterventionprocedure&RequestFrequency=' + RequestFrequency[0].value + '&RequestFrequencyName=' + RequestFrequencyName[0][RequestFrequencyName[0].selectedIndex].text + '&RequestStartDate=' + RequestStartDate[0].value + '&RequestEndDate=' + RequestEndDate[0].value + '&RequestTotalUnit=' + RequesTotalUnit[0].value + '&RequesUnits=' + RequesUnits[0].value + '&InterventionProceduerProvider=' + InterventionProceduerProvider[0].value + '&Status=' + Status[0].value + '&tpprocedureId=' + 0 + '&program=' + dropdownProgram[0].value + '&requestercomment=' + authorizationRequesterComment[0].value + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onGridbindSuccess);   //InterventionProceduerProvider   
        }



    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}
//Now this funciton is used on HRM Asignprocedure
function onGridbindSuccess(result) {
    try {

        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            $("#PanelGridView")[0].outerHTML = pageResponse;

            $("input[type='button'][Id=ButtonUpdate]").removeAttr("disabled");
            $("input[type='button'][Id=ButtonInsert]").attr("value", "Insert");
            ClearControlHRMTreatmentPlanProcedure();
            //            //Added by Ankesh
            //            //UnSelect the Radio Button of the Grid on Clear Button
            //            if ($("#RadioButtonTPProcedure")[0].checked == true) {
            //                $("#RadioButtonTPProcedure")[0].checked = false;
            //            }  
        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }
}


//Description:Method is used to Clear Control 
//Author:Vikas Vyas
//CreatedOn:04 Dec,2009

//This function is called on HRMASSIGNPROCEDURE pop up
function ClearControlHRMTreatmentPlanProcedure() {

    try {
        var textBoxTPInterventionProcedure = $("input[type=text][id$=TextBox_TPInterventionProcedures_Units]");
        textBoxTPInterventionProcedure[0].value = "";


        $("select[Id$=DropDownList_TPInterventionProcedures_FrequencyType]").val('0');

        $("select[Id$=DropDownList_Procedure]").val('0');
        $("select[Id$=DropDownList_Programs]").val('0');

        var requestStartDate = $("input[type=text][id$=TextBox_TPInterventionProcedures_StartDate]");
        requestStartDate[0].value = "";
        var requestEndDate = $("input[type=text][id$=TextBox_TPInterventionProcedures_EndDate]");
        requestEndDate[0].value = "";

        var requesUnits = $("input[type=text][id$=TextBox_TPInterventionProcedures_Units]");
        requesUnits[0].value = "";

        var requesTotalUnit = $("input[type=text][id$=TextBox_TPInterventionProcedures_TotalUnits]");

        requesTotalUnit[0].value = "";



        //var authorizationCode  =   $("[id$=Label_TPProcedures_AuthorizationCode]");
        //   authorizationCode[0].value = "";

        //Panel
        $("#PanelAssociatedWith")[0].innerHTML = "&nbsp;";

        //Added by Ankesh
        //UnSelect the Radio Button of the Grid on Clear Button
        //$("[id$=HiddenFieldTPProcedureId]")[0].value = 0;
        var gridViewTPProcedure = $("#GridViewProcedures");
        if (gridViewTPProcedure.length > 0) {
            var gridViewControls = $("input");
            for (i = 0; i < gridViewControls.length; i++) {
                if (gridViewControls[i].type == "radio") {
                    gridViewControls[i].checked = false;
                }
            }
        }


        $("#HiddenFieldTPProcedureId").val(0);

        $("input[type='button'][Id=ButtonUpdate]").removeAttr("disabled");
        $("input[type='button'][Id=ButtonInsert]").attr("value", "Insert");
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan'); //Code added by Devinder 
    }


}




//Description:Method is used to calculate units on the basis of AutorizationCode and SiteId
//Author:Vikas Vyas
//CreatedOn:17 Nov,2009
function CalculateUnits() {
    try {
        var dropDownListProcedure = $("select[id$=DropDownList_Procedure]");

        var myDate = new Date();

        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=displayunits&UnitCount=' + dropDownListProcedure[0].value + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onSuccessProcedureProvider);

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}


function onSuccessProcedureProvider(result) {
    try {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);

        if (pageResponse != undefined) {
            $("#LabelUnitCounter")[0].innerHTML = pageResponse;

        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }

}


//Description:Open HRMTPAssociatedIntervention Pop Up control on Click of Edit Association Intervention click
//Author:Vikas Vyas
//CreatedOn:11th Nov,2009

// 04 July,2010 Now it is used on HRMASSIGNPROCEDURE.ASCX
function openAssociatedIntervention(objectEdit) {


    try {

        var dropDownListProcedure = $("select[id$=DropDownList_Procedure]");

        var tpProcedureId = $("input[id$= HiddenFieldTPProcedureId]");


        var myDate = new Date();

        var tpProcedureIdTemp = $("input[id$= HiddenFieldTPProcedureIDTemporary]");


        if ($("input[type='button'][Id=ButtonInsert]")[0].value == "Modify") {

            OpenPage(5765, 10195, "selectedValue=" + dropDownListProcedure[0].value + "^time=" + myDate.getMinutes() + myDate.getSeconds() + "^tpprocedureId=" + tpProcedureIdTemp[0].value + "^buttontext=Modify", null, GetRelativePath(), 'T', "dialogHeight: 520px; dialogWidth: 480px;dialogTitle:Associated Intervention");

        }
        else {

            OpenPage(5765, 10195, "selectedValue=" + dropDownListProcedure[0].value + "^time=" + myDate.getMinutes() + myDate.getSeconds() + "^tpprocedureId=" + tpProcedureIdTemp[0].value + "^buttontext=Insert", null, GetRelativePath(), 'T', "dialogHeight: 520px; dialogWidth: 480px;dialogTitle:Associated Intervention");
        }


        if (returnValue != undefined) {

            $("[id$= PanelAssociatedWith]").html(returnValue);

        }



    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }

}
//Author : Mahesh
//Created on : 04 July,2010
// Description :  Moved on HRMAssignprocedure set Associsated intervention called from HRMTPAssociatedIntervention Popup
function SetValueAfterAssociatedIntervention(returnValue) {
    try {

        if (returnValue != undefined) {
            //document.getElementById(objectEdit.containerId).innerHTML = returnValue;
            $("[id$= PanelAssociatedWith]").html(returnValue);

        }

    }
    catch (err) {
    }
}


//Description:GetAssociatedIntervention Control  HTML 
//CreatedOn:12th-Nov-2009
//Author: Vikas Vyas

//Now this function is used on HRMTPAssociatedIntervention popup
function GetAssociatedInterventionControlHTML() {
    try {
        var strHTML = "";
        var checkBoxCollection = $("input[type='checkbox']");
        var objectTPProcedureId = $("[id$=HiddenFieldTPProcedureId]");
        var objectHiddenFieldSelectedValue = $("[id$=HiddenFieldSelectedValue]");


        if (checkBoxCollection.length > 0)  //Perform Check for Length
        {
            for (checkBoxCount = 0; checkBoxCount < checkBoxCollection.length; checkBoxCount++) {
                if (strHTML == "") {
                    strHTML = checkBoxCollection[checkBoxCount].value + "$$" + checkBoxCollection[checkBoxCount].checked;
                }
                else {
                    strHTML = strHTML + "||" + checkBoxCollection[checkBoxCount].value + "$$" + checkBoxCollection[checkBoxCount].checked;
                }
            }
        }


        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpProcedureId=" + objectTPProcedureId[0].value, 'action=editassociatedintervention&strHTML=' + strHTML + "&selectedValue=" + objectHiddenFieldSelectedValue[0].value + "&time=" + myDate.getMinutes() + myDate.getSeconds(), onAssocitedNeedSuccess);


    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}



//Description:return created HTML
//CreatedOn:12th-Nov-2009
//Author: Vikas Vyas
function onSuccessGetAssociatedInterventionControlHTML(result) {

    try {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            window.returnValue = pageResponse; //Assign the Parsed HTML
            window.close();
        }

    }
    catch (err) {

        LogClientSideException(err, 'HRMTreatmetPlan');
    }


}



//Description:Calculate units on the basis units, frequency, date from, date to  
//CreatedOn:12th-March-2010
//Author: Vikas Vyas
//This functon is used on HRMAssignProcedure pop ups
function FromDateEndDateValidation(control) {

    try {

        var textBoxTPProcedureStartDate = $('input[type=text][id$=TextBox_TPProcedures_StartDate]');
        var textBoxTPProcedureEndDate = $('input[type=text][id$=TextBox_TPProcedures_EndDate]');

        if (textBoxTPProcedureStartDate.val() == "") {
            textBoxTPProcedureStartDate.val($('input[type=hidden][id$=HiddenField-EffectiveDate]').val());
        }

        if (control.value == "") {
            return false;
        }

        if (control.id == textBoxTPProcedureStartDate[0].id) {

            //            if (ValidateDateValue(textBoxTPInterventionProcedureStartDate[0]) == false) {
            //                alert("Please enter valid Start Date");
            //                textBoxTPInterventionProcedureEndDate[0].focus();
            //                return false;
            //            }

            if (control.attributes("datatype").value == "Date") {
                var returnValue = ValidateDate(textBoxTPProcedureStartDate[0]); //set the date if user enters . as date seprator. /\/\ |<
                //  var returnValue = ValidateDateValue(textBoxTPInterventionProcedureStartDate);
                if (returnValue != true) {
                    textBoxTPProcedureStartDate.val('');
                    return false;
                }
            }


        }
        else if (control.id == textBoxTPProcedureEndDate[0].id) {

            if (control.attributes("datatype").value == "Date") {
                var returnValue = ValidateDate(textBoxTPProcedureEndDate[0]); //set the date if user enters . as date seprator. /\/\ |<
                //  var returnValue = ValidateDateValue(textBoxTPInterventionProcedureStartDate);
                if (returnValue != true) {
                    textBoxTPProcedureEndDate.val('');
                    return false;
                }
            }
        }



        if (textBoxTPProcedureStartDate[0].value != "" && textBoxTPProcedureEndDate[0].value) {
            //Now Perform check from date is less than start date or not

            var date1 = new Date(textBoxTPProcedureStartDate[0].value);
            var date2 = new Date(textBoxTPInterventionProcedureEndDate[0].value);


            if (date1 > date2) {

                //alert("To-Date can not be less then the From-Date");
                ShowMsgBox('To-Date can not be less then the From-Date.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                return false;
            }



        }


        UnitCalculation(control);




    }
    catch (err) {

        LogClientSideException(err, 'HRMTreatmetPlan');
    }


}


//Description:Calculate units on the basis units, frequency, date from, date to  
//CreatedOn:17th-Nov-2009
//Author: Vikas Vyas

//Now this functon is called on HRMASSIGNpUPUP
function UnitCalculation(control) {
    try {

        //If control is not textBoxTPInterventionProcedureUnits

        //In First Step we have to perform validation

        var textBoxTPInterventionProcedureTotalUnits = $("input[type=text][id$=TextBox_TPInterventionProcedures_TotalUnits]");

        var textBoxTPInterventionProcedureUnits = $("input[type=text][id$=TextBox_TPInterventionProcedures_Units]");
        var dropdownFrequencyType = $("select[id$=DropDownList_TPInterventionProcedures_FrequencyType]");
        var textBoxTPInterventionProcedureStartDate = $('input[type=text][id$=TextBox_TPInterventionProcedures_StartDate]');
        var textBoxTPInterventionProcedureEndDate = $('input[type=text][id$=TextBox_TPInterventionProcedures_EndDate]');

        if (control.id == textBoxTPInterventionProcedureTotalUnits[0].id) {

            if (textBoxTPInterventionProcedureUnits[0].value == "") {

                //alert("Please enter Units Requested");
                ShowMsgBox('Please enter Units Requested.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                textBoxTPInterventionProcedureUnits[0].focus();
                return false;
            }



            if (textBoxTPInterventionProcedureUnits[0].value != "") {

                if (isNaN(parseInt(textBoxTPInterventionProcedureUnits[0].value)) == true) {
                    //alert("Please enter Valid Unit");
                    ShowMsgBox('Please enter Valid Unit.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                    textBoxTPInterventionProcedureUnits[0].focus();
                    return false;
                }


                if (textBoxTPInterventionProcedureUnits[0].value == 0 || textBoxTPInterventionProcedureUnits[0].value < 0) {
                    //alert("Please enter Valid Unit");
                    ShowMsgBox('Please enter Valid Unit.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                    textBoxTPInterventionProcedureUnits[0].focus();
                    return false;
                }

            }
            if (dropdownFrequencyType[0].selectedIndex == 0) {

                //alert("Please select Frequency Type");
                ShowMsgBox('Please select Frequency Type.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                document.getElementById(dropdownFrequencyType[0].id).focus();
                return false;
            }





            if (textBoxTPInterventionProcedureStartDate[0].value == '') {

                //alert("Please enter Start Date");
                ShowMsgBox('Please enter Start Date.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                textBoxTPInterventionProcedureStartDate[0].focus();
                return false;
            }
            if (textBoxTPInterventionProcedureStartDate[0].value != '') {
                if (ValidateDateTreatmentPlan(textBoxTPInterventionProcedureStartDate[0]) == false) {
                    //alert("Please enter valid Start Date");
                    ShowMsgBox('Please enter valid Start Date.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                    textBoxTPInterventionProcedureEndDate[0].focus();
                    return false;
                }

            }



            if (textBoxTPInterventionProcedureEndDate[0].value == '') {

                // alert("Please enter End Date");
                ShowMsgBox('Please enter End Date.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                textBoxTPInterventionProcedureEndDate[0].focus();
                return false;
            }



            if (textBoxTPInterventionProcedureEndDate[0].value != '') {
                if (ValidateDateTreatmentPlan(textBoxTPInterventionProcedureEndDate[0]) == false) {
                    //alert("Please enter valid End Date");
                    ShowMsgBox('Please enter valid End Date.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                    textBoxTPInterventionProcedureEndDate[0].focus();
                    return false;
                }

            }


            //Now Perform check from date is less than start date or not

            var date1 = new Date(textBoxTPInterventionProcedureStartDate[0].value);
            var date2 = new Date(textBoxTPInterventionProcedureEndDate[0].value);


            if (date1 > date2) {

                //alert("To-Date can not be less then the From-Date");
                ShowMsgBox('To-Date can not be less then the From-Date.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                return false;
            }

        }
        else {
            if (control.value == "") {
                return false;
            }
            else {
                //check validation for there associated control
                if (control.id == textBoxTPInterventionProcedureUnits[0].id) {
                    if (isNaN(parseInt(textBoxTPInterventionProcedureUnits[0].value)) == true) {
                        // alert("Please enter Valid Unit");
                        ShowMsgBox('Please enter Valid Unit.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                        textBoxTPInterventionProcedureUnits[0].focus();
                        return false;
                    }

                    if (textBoxTPInterventionProcedureUnits[0].value == 0 || textBoxTPInterventionProcedureUnits[0].value < 0) {
                        //alert("Please enter Valid Unit");
                        ShowMsgBox('Please enter Valid Unit.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                        textBoxTPInterventionProcedureUnits[0].focus();
                        return false;
                    }

                }
                else if (control.id == dropdownFrequencyType[0].id) {
                    if (dropdownFrequencyType[0].selectedIndex == 0) {

                        //alert("Please select Frequency Type");
                        ShowMsgBox('Please select Frequency Type.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);
                        document.getElementById(dropdownFrequencyType[0].id).focus();
                        return false;
                    }

                }

            }





        }

        //Check for all values
        if (textBoxTPInterventionProcedureUnits[0].value == "" || dropdownFrequencyType[0].selectedIndex == 0 || textBoxTPInterventionProcedureStartDate[0].value == "" || textBoxTPInterventionProcedureEndDate[0].value == "") {
            return false;
        }


        var myDate = new Date();

        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=unitcalculation&procedureUnits=' + textBoxTPInterventionProcedureUnits[0].value + '&frequencyType=' + dropdownFrequencyType[0].value + '&startDate=' + textBoxTPInterventionProcedureStartDate[0].value + '&endDate=' + textBoxTPInterventionProcedureEndDate[0].value, onSuccessUnitCalculation);

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }

}


//Description:get unit after calculation
//CreatedOn:17th-Nov-2009
//Author: Vikas Vyas
//This popup is used on HRMA    SSIGNPROCEDURE POP UPS
function onSuccessUnitCalculation(result) {

    try {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {

            $('[id=TextBox_TPInterventionProcedures_TotalUnits]')[0].value = trim(pageResponse);

        }

    }
    catch (err) {

        LogClientSideException(err, 'HRMTreatmetPlan');
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
        LogClientSideException(err, 'HRMTreatmetPlan');
    }

}



//Description:update sc
//CreatedOn:18th-Nov-2009
//Author: Vikas Vyas
//This function is now used in HRMAssignProcedure popups 4 July,2010
function UpdateHRMTPAssignProcedure() {

    try {

        var myDate = new Date();

        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=updatehrmtpassignprocedure', onSuccessUpdateHRMTPAssignProcedure);



    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');

    }


}

//Description:get unit after calculation
//CreatedOn:18th-Nov-2009
//Author: Vikas Vyas

//Now this function is used on HRMAssignprodeudere popups 
function onSuccessUpdateHRMTPAssignProcedure(result) {


    var pageResponse = result;
    var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
    var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {
        //commented on 06 July orignal code block :$("#PanelGridView")[0].outerHTML = pageResponse;
        $("div[id$=PanelGridView]")[0].outerHTML = pageResponse;
        //commented on 06 July orignal code block : $("input[type='button'][Id=ButtonUpdate]").attr("disabled", "disabled");
        $("input[type='button'][Id$=ButtonUpdate]").attr("disabled", "disabled");

        //$("input[type='button'][Id=ButtonInsert]").attr("value", "Insert");


    }

}



function CloseHRMTPAssignProcedure(ButtonUpdate, ButtonInsert) {

    try {


        //Perform the check
        //commented on 06 July orignal code block : if ($("input[type='button'][Id=ButtonUpdate]")[0].disabled == false && $("input[type='button'][Id=ButtonInsert]")[0].value != "Modify") {
        if (ButtonUpdate[0].disabled == false && ButtonInsert[0].value != "Modify") {
            ShowMsgBox('Do you want to save this Treatment Plan Procedure?', TPConfirmCaption, MessageBoxButton.YesNoCancel, MessageBoxIcon.Question, 'CloseHRMTPAssignProcedureOKOption();', 'CloseHRMTPAssignProcedureCancelOption()');
        }
        //commented on 06 July orignal code block :else if ($("input[type='button'][Id=ButtonInsert]")[0].value != "Modify") {
        else if (ButtonInsert[0].value != "Modify") {

            var myDate = new Date();
            $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=closehrmtpassignprocedure', onSuccessCloseHRMTPAssignProcedure);
        }
        else {
            parent.CloaseModalPopupWindow();
        }

    }
    catch (err) {

        // LogClientSideException(err,'HRMTreatmetPlan');
    }


}
//Author : Mahesh
//Created on : 03 July,2010
// Description : split function of delete for using custom message box
function CloseHRMTPAssignProcedureOKOption() {
    try {

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?closeon=" + "closeonyes", 'action=closehrmtpassignprocedure', onSuccessCloseHRMTPAssignProcedure);

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}
//Author : Mahesh
//Created on : 03 July,2010
// Description : split function of delete for using custom message box
function CloseHRMTPAssignProcedureCancelOption() {
    try {

        var myDate = new Date();
        $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?closeon=" + "closeonno", 'action=closehrmtpassignprocedure', onSuccessCloseHRMTPAssignProcedure);

    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}

function onSuccessCloseHRMTPAssignProcedure(result) {

    var pageResponse = result;
    var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
    var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined && pageResponse.indexOf("fail") <= -1) {

        var stringToReplace = GetRelativePathTP() + "DXR.axd?r=1_103,1_99,1_68,3_21,3_22,2_13,2_12";
        pageResponse = pageResponse.replace(stringToReplace, "");
        stringToReplace = GetRelativePathTP() + "DXR.axd?r=1_103,1_83";
        pageResponse = pageResponse.replace(stringToReplace, "");
        stringToReplace = GetRelativePathTP() + "DXR.axd?r=1_49,1_27";
        pageResponse = pageResponse.replace(stringToReplace, "");
        stringToReplace = GetRelativePathTP() + "DXR.axd?r=1_49,1_44,1_47,3_7,3_0,2_14,2_13";
        pageResponse = pageResponse.replace(stringToReplace, "");
        stringToReplace = GetRelativePathTP() + "DXR.axd?r=1_49,1_44,1_47,3_6,3_7,2_14,2_13";
        pageResponse = pageResponse.replace(stringToReplace, "");
        //window.returnValue = pageResponse;
        ////commented on 06 July orignal code block : window.returnValue = pageResponse;
        //Newly added
        if (pageResponse != undefined) {
            $("div[id$=PanelGridViewProcedure]").html("");
            //$("#PanelGridViewProcedure")[0].innerHTML = pageResponse;
            $("div[id$=PanelGridViewProcedure]").html(pageResponse);
            parent.CloaseModalPopupWindow();
            var myDate = new Date();
            var LocID = $("input[id$=HiddenFieldLocID]").val();
            PopupProcessing();
            $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=recreatetxplanaftersave&time=' + myDate.getMinutes() + myDate.getSeconds() + '&LocID=' + LocID, RecreateHRMTxPlanControlOnSuccess);

        }
        parent.CloaseModalPopupWindow();

    }
    else {//Added by mahesh on 14 July. B'coz popup is not closing when user just open it and try to close it
        parent.CloaseModalPopupWindow();
    }

    ////commented on 06 July orignal code block : window.close();


}


function GetRelativePathTP() {
    var _relativePath = "";
    _relativePath = $("[id$=HiddenFieldRelativePath]").val();
    return _relativePath;
}



//Description:Method is used to add custom logic
//Author:Vikas Vyas
//CreatedOn:11th Nov,2009
function AddEventHandlers() {
    try {

        var objectradio = $("input[type='radio'][name='RadioButton_TPGeneral_PlanOrAddendum']:checked");

        if (objectradio.length > 0) {
            if (objectradio[0].value == "T") {

                //$("[id$=tablePlanOrAddendum]")[0].style.display = 'none';

                // $("textarea[id='TextArea_TPGeneral_PurposeOfAddendum']").removeAttr("disabled");

                var textBoxTPGeneral_PeriodicReviewFrequencyNumber = $("input[type='text'][id$=TextBox_TPGeneral_PeriodicReviewFrequencyNumber]")

                if (textBoxTPGeneral_PeriodicReviewFrequencyNumber.length > 0) {

                    textBoxTPGeneral_PeriodicReviewFrequencyNumber.removeAttr("disabled");
                }

                //Get tabIndex

                var tabIndexAddendum = $("textarea[id='TextArea_TPGeneral_PurposeOfAddendum']").attr("tabIndex");
                var tabIndexStreagth = $("textarea[id='TextArea_TPGeneral_StrengthsAndPreferences']").attr("tabIndex");


                //Set tabIndex
                $("textarea[id='TextArea_TPGeneral_StrengthsAndPreferences']").attr("tabIndex", tabIndexAddendum);
                $("textarea[id='TextArea_TPGeneral_AreasOfNeed']").attr("tabIndex", tabIndexStreagth);
                //TextArea_TPGeneral_AreasOfNeed


            }
            else if (objectradio[0].value == "A") {
                $("textarea[id='TextArea_TPGeneral_PurposeOfAddendum']").removeAttr("disabled");
                //TextArea_TPGeneral_Participants
                //TextArea_TPGeneral_AreasOfNeed

                var dropdownList_TPGeneral_PeriodicReviewFrequencyUnitType = $("select[id$=DropDownList_TPGeneral_PeriodicReviewFrequencyUnitType]")

                if (dropdownList_TPGeneral_PeriodicReviewFrequencyUnitType.length > 0) {
                    dropdownList_TPGeneral_PeriodicReviewFrequencyUnitType.disabled = true;
                }

                var tabIndexAddendum = $("textarea[id='TextArea_TPGeneral_Participants']").attr("tabIndex");
                var tabIndexStreagth = $("textarea[id='TextArea_TPGeneral_AreasOfNeed']").attr("tabIndex");


                //Set tabIndex
                $("textarea[id='TextArea_TPGeneral_AreasOfNeed']").attr("tabIndex", tabIndexAddendum);
                $("textarea[id='TextArea_TPGeneral_Participants']").attr("tabIndex", tabIndexStreagth);
            }
        }

        var objectCheckBox = $("input[type='checkbox'][id$='CheckBox_TPGeneral_CrisisPlanNotNecessary']:checked")
        if (objectCheckBox.length > 0) {

            $("textarea[id='TextArea_TPGeneral_CrisisPlan']").attr("disabled", "disabled");


        }
        else {

            $("textarea[id='TextArea_TPGeneral_CrisisPlan']").removeAttr("disabled");

        }

        return true;
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}


// Function Modified by Rakesh . For Enable and Disable Tabs on Treatment Plan
function SetScreenSpecificValues(dom, action) {
    try {
        $('input').each(function() {
            $(this).val(unescape($(this).val()));
        });
        $('textarea').each(function() {
            $(this).text(unescape($(this).text()));
        });
        $('#TreatmentPlanHRM_C1').scroll(function() { DivScrollPos(this) });

        TreatmentPlanHRM.GetTab(3).SetVisible(false);
        var myDate = new Date();
        if (dom[0].childNodes[0].selectNodes("TPGeneral").length > 0) {
            if (dom[0].childNodes[0].selectNodes("TPGeneral")[0].selectSingleNode("PlanOrAddendum") != null) {
                var txPlan = dom[0].childNodes[0].selectNodes("TPGeneral")[0].selectSingleNode("PlanOrAddendum").nodeTypedValue;
                if (txPlan == "T") {

                    $("[id=TRAddendum]").remove();
                    $("[id=AreasOfNeed]").attr("style", "height:42px");

                    var textBoxTPGeneral_PeriodicReviewFrequencyNumber = $("input[type='text'][id$=TextBox_TPGeneral_PeriodicReviewFrequencyNumber]")

                    if (textBoxTPGeneral_PeriodicReviewFrequencyNumber.length > 0) {
                        textBoxTPGeneral_PeriodicReviewFrequencyNumber.removeAttr("disabled");

                    }

                }
                else if (txPlan == "A") {


                    // Changes Start here
                    if (action == "new" || action == "") {
                        if ($("AddendumNotifications Notifications", dom).length > 0) {
                            var notificationMessage = $("AddendumNotifications Notifications", dom).text();
                            if (notificationMessage != "" && notificationMessage != null) {
                                if (objectPageResponse.UnsavedChangeId == 0)
                                    ShowMsgBox(notificationMessage, 'Message', MessageBoxButton.OK, MessageBoxIcon.Information);
                            }
                        }
                    }
                    //changes end here


                    var textAreaAddendum = $("textarea[id='TextArea_TPGeneral_PurposeOfAddendum']");
                    if (textAreaAddendum.length > 0) {
                        textAreaAddendum.removeAttr("disabled");
                    }
                    var dropdownList_TPGeneral_PeriodicReviewFrequencyUnitType = $("select[id$=DropDownList_TPGeneral_PeriodicReviewFrequencyUnitType]")

                    if (dropdownList_TPGeneral_PeriodicReviewFrequencyUnitType.length > 0) {
                        dropdownList_TPGeneral_PeriodicReviewFrequencyUnitType[0].disabled = 'disabled';

                    }
                }

                var blankPlan = $("span[id$=ButtonBlankPlan]");
                if (blankPlan.length > 0) {
                    if (dom[0].childNodes[0].selectNodes("TPGeneral").length > 0) {
                        if (dom[0].childNodes[0].selectNodes("TPGeneral")[0].selectSingleNode("PlanOrAddendum") != null) {
                            var txPlan = dom[0].childNodes[0].selectNodes("TPGeneral")[0].selectSingleNode("PlanOrAddendum").nodeTypedValue;
                            if (txPlan == "T") {
                                if (dom[0].childNodes[0].selectNodes("Documents").length > 0) {
                                    if (dom[0].childNodes[0].selectNodes("Documents")[0].selectSingleNode("DocumentId") != null) {
                                        if (dom[0].childNodes[0].selectNodes("Documents")[0].selectSingleNode("DocumentId").nodeTypedValue > 0) {
                                            blankPlan[0].style.display = "block";

                                            DisableSpanButton('ButtonBlankPlan');
                                        }
                                        else {

                                            blankPlan[0].style.display = "block";
                                            EnableSpanButton('ButtonBlankPlan');

                                        }
                                    }
                                    else {
                                        DisableSpanButton('ButtonBlankPlan');
                                    }
                                }
                                else {
                                    DisableSpanButton('ButtonBlankPlan');

                                }

                            }
                            else {
                                blankPlan[0].style.display = "none";
                            }

                        }
                    }
                }

                //Steps 1: check customclientLoc table from dom
                //Steps 2: check the column LocId value from that table and assigned same to the hidden Field
                //$("input[id$=HiddenFieldLocID]").val($('select[id$=DropDownList_CustomClientLOCs_LOCID]').val());
                //End

                if (dom[0].childNodes[0].selectNodes("CustomClientLOCs").length > 0) {
                    if (dom[0].childNodes[0].selectNodes("CustomClientLOCs")[0].selectSingleNode("LOCId") != null) {
                        if ($("input[id$=HiddenFieldLocID]").val() == "")
                            $("input[id$=HiddenFieldLocID]").val(dom[0].childNodes[0].selectNodes("CustomClientLOCs")[0].selectSingleNode("LOCId").nodeTypedValue);
                    }
                }

                if (action != 'TabRequest' && action != 'update') {
                    //Added By Vikas Vyas in ref to Implemented UM Part 2 functionality
                    EnableDisabelTreatmentTabs(dom, action);
                }
            }
        }
        else {
            if (action == "editdocument" || action == "next" || action == "previous") {
                EnableDisabelTreatmentTabs(dom, action);
            }

        }
    }
    catch (ex) {

    }

}
function EnableTabs(obj) {
    if ($('select[id$=DropDownList_TPGeneral_Assigned]').val() == 0 || $('select[id$=DropDownList_CustomClientLOCs_LOCId]').val() == 0) {
        SetTabControlStatus(false);
    }
    else {

        var boolIsEnable = false;
        if ($('Documents EffectiveDate', AutoSaveXMLDom[0].xml).length > 0) {
            if ($('Documents EffectiveDate', AutoSaveXMLDom[0].xml).text() != "")
                boolIsEnable = true;
        }
        if (boolIsEnable == true)
            SetTabControlStatus(true);
        else
            SetTabControlStatus(false);
    }
    $("input[id$=HiddenFieldLocID]").val($('select[id$=DropDownList_CustomClientLOCs_LOCId]').val());

    if (obj.id.indexOf('DropDownList_CustomClientLOCs_LOCId') > -1) {
        if ($('[id*=DropDownList_TPInterventionService]').length > 0) {
            ShowMsgBox('Changing LOC will result in different LCM / CCM caps.  Be sure to review your authorization requests.  Do you wish to continue changing LOC?', 'HRM Treatment Plan', MessageBoxButton.YesNo, MessageBoxIcon.Question, 'ClickYesLOC()', 'ClickNoLOC()');
        }
    }
}

function ClickYesLOC() {

    $('#TreatmentPlanHRM_C1').html('');
    CallAutoSaveProcess();
}

function ClickNoLOC() {
    $('[id$=DropDownList_CustomClientLOCs_LOCId').val($('[id$=DropDownList_CustomClientLOCs_LOCId').attr('oldvalue'));
    $("input[id$=HiddenFieldLocID]").val($('select[id$=DropDownList_CustomClientLOCs_LOCId]').val());
    if ($("CustomClientLOCs LOCId").length > 0) {
        CreateAutoSaveXml('CustomClientLOCs', 'LOCId', $('select[id$=DropDownList_CustomClientLOCs_LOCId]').val());
    }


}
///This is used for enable and disable tabs
function EnableDisabelTreatmentTabs(dom, action) {

    var boolIsEnable = false;
    if ($('Documents EffectiveDate', dom[0].xml).length > 0) {
        if ($('Documents EffectiveDate', dom[0].xml).text() != "")
            boolIsEnable = true;
    }
    if (boolIsEnable) {
        if (dom[0].childNodes[0].selectNodes("CustomClientLOCs").length > 0) {
            var tpgeneralUM = null;
            if (dom[0].childNodes[0].selectNodes("TPGeneral").length > 0 && dom[0].childNodes[0].selectNodes("TPGeneral")[0].selectNodes("Assigned").length > 0)
                tpgeneralUM = dom[0].childNodes[0].selectNodes("TPGeneral")[0].selectSingleNode("Assigned");
            else
                tpgeneralUM = null;
            var tpCustomClientLoc = dom[0].childNodes[0].selectNodes("CustomClientLOCs")[0].selectSingleNode("LOCId");
            //////Disable the Effective Date control
            //$('#TextBox_DocumentInformation_EffectiveDate').attr("disabled", "true");

            if (tpCustomClientLoc.nodeTypedValue != -1)
            //if (tpgeneralUM != null && tpCustomClientLoc != null && tpgeneralUM != "" && tpCustomClientLoc != "")
            {
                if (tpgeneralUM == null || typeof tpgeneralUM.nodeTypedValue == 0)
                //  if (tpgeneralUM.nodeTypedValue == 0 || tpCustomClientLoc.nodeTypedValue == -1)
                {
                    SetTabControlStatus(false);
                }
                else {
                    SetTabControlStatus(true);
                }

            }
            else {
                SetTabControlStatus(false);
            }
        }
        else {
            SetTabControlStatus(false);
        }
    }
    else
        SetTabControlStatus(false);
}










//onSuccessUpdateHRMTPAssignProcedure

function OnSuccessUpdateHRMTPAssignProcedureAfterSave(pageResponse) {

    var pageResponse = result;
    var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
    var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {
        $("#PanelGridViewProcedure").html("");
        //$("#PanelGridViewProcedure")[0].innerHTML = pageResponse;
        $("#PanelGridViewProcedure").html(pageResponse);
    }



}





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



//Now this function is used on HRMAssignProcedure pop up
function radioClickTPProcedure(radio, tpprocedureId, providerSite, units, startDate, endDate, frequencyType, totalUnits, program, authorizationRequesterComment, authorizationId, siteId) {



    var radioCollection = $("[id$=GridViewProcedures]").find("input[type='radio']");

    for (var i = 0; i < radioCollection.length; i++) {

        if (radioCollection[i].id == radio.id) {

            document.getElementById(radioCollection[i].id).checked = true;
        }
        else {
            document.getElementById(radioCollection[i].id).checked = false;
        }

    }


    var textBoxTPInterventionProcedure = $("input[type=text][id$=TextBox_TPInterventionProcedures_Units]");
    textBoxTPInterventionProcedure[0].value = units;

    var dropdownFrequencyType = $("select[id$=DropDownList_TPInterventionProcedures_FrequencyType]");
    dropdownFrequencyType[0].value = parseInt(frequencyType);

    var dropdownInterventionProceduerProvider = $("select[id$=DropDownList_Procedure]");
    dropdownInterventionProceduerProvider[0].value = providerSite;


    var requestStartDate = $("input[type=text][id$=TextBox_TPInterventionProcedures_StartDate]");
    requestStartDate.val(startDate);

    var requestEndDate = $("input[type=text][id$=TextBox_TPInterventionProcedures_EndDate]");
    requestEndDate.val(endDate);
    //requestEndDate[0].value = endDate;
    var requesTotalUnit = $("input[type=text][id$=TextBox_TPInterventionProcedures_TotalUnits]");
    requesTotalUnit.val(totalUnits);
    //requesTotalUnit[0].value = totalUnits;
    var dropdownProgram = $("select[id$=DropDownList_Programs]");

    dropdownProgram[0].value = program;

    $("input[id$=HiddenFieldTPProcedureId]").val(tpprocedureId);

    $("input[type='button'][Id=ButtonInsert]").attr("value", "Modify");



    var myDate = new Date();

    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpProcedureId=" + tpprocedureId, 'action=createeditassociateinterventioncontrol&authorizationCodeId=' + authorizationId + '&siteId=' + siteId + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onradioClickTPProcedureSuccess);


}

//Now this funciton is used on HRMAsignproceduree popup

function onradioClickTPProcedureSuccess(result) {

    try {

        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            $("#PanelAssociatedWith")[0].innerHTML = pageResponse;
        }
    }

    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }

}


//Description:Hadle Delete of HRMTreatmentPlan Procedure Pop Control
//Author:Vikas Vyas
//CreatedOn:5th - Dec-2009

//Now this function is used on HRMTPASSIGNPRODURE POPUP 
function hadleTPProcedureDelete(tpprocedureId) {

    try {

        ShowMsgBox('Are you sure want to remove this Procedure?', TPConfirmCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'hadleTPProcedureDeleteOnOkOption(\'' + tpprocedureId + '\');');

    }
    catch (err) {

        LogClientSideException(err, 'HRMTreatmetPlan');
    }


}
//Author : Mahesh
//Created on : 03 July,2010
// Description : split function of delete for using custom message box
//Now this function used on HRMAssignProcedure popups
function hadleTPProcedureDeleteOnOkOption(tpprocedureId) {

    var myDate = new Date();
    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpProcedureId=" + tpprocedureId, 'action=deletehrmtreatmentplantpprocedures&time=' + myDate.getMinutes() + myDate.getSeconds(), onTPProcedureDeleteSuccess);
}
//Now this function used on HRMAssignProcedure popups
function onTPProcedureDeleteSuccess(result) {


    try {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            $("#PanelGridView")[0].outerHTML = pageResponse;

            if ($("input[type='button'][Id=ButtonInsert]")[0].value == "Insert") {

                $("input[type='button'][Id=ButtonUpdate]").removeAttr("disabled");


            }
            else {

                $("input[type='button'][Id=ButtonUpdate]").removeAttr("disabled");
                $("input[type='button'][Id=ButtonInsert]").attr("value", "Insert");


            }

            ClearControlHRMTreatmentPlanProcedure();

        }



    }
    catch (err) {

        LogClientSideException(err, 'HRMTreatmetPlan');
    }



}

//Description:Function to enable-disable textarea (Used on Summary Tab)
//CreatedOn:12th Nov 2009
//Author: Vikas Vyas
function EnableDisableTextArea(obj) {
    try {
        var crisisPlanId = $("[id$=TextArea_TPGeneral_CrisisPlan]");
        if (obj.checked == true) {
            crisisPlanId[0].disabled = true;
        }
        else {
            crisisPlanId[0].disabled = false;
        }
    }
    catch (err) {
        LogClientSideException(err, 'HRMTreatmetPlan');
    }
}


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
//Added By Priya Ref:Task No:330
//To implement Custom Sorting on Procedure
function SortProcedureRecord(SortColumn) {
    // alert('sorting');
    if (SortExpressionProcedure == '') {
        SortExpressionProcedure = 'Desc';
    }
    else if (SortExpressionProcedure == 'Desc') {
        SortExpressionProcedure = 'Asc';
    }
    else if (SortExpressionProcedure == 'Asc') {
        SortExpressionProcedure = 'Desc';
    }

    var sortString = '';
    sortString = SortColumn + ' ' + SortExpressionProcedure;

    var myDate = new Date();
    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?sortstring=" + sortString, '&action=sortproceduresList' + '&time=' + myDate.getMinutes() + myDate.getSeconds(), onSortSuccess);



}
function onSortSuccess(result) {

    var pageResponse = result;
    // var start = pageResponse.indexOf("##STARTSORTRESPONSEVALUE##") + 26;
    //  var end = pageResponse.indexOf("##ENDSORTRESPONSEVALUE##");
    var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
    var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");

    pageResponse = pageResponse.substr(start, end - start).trim();
    if (pageResponse != undefined) {
        $("div[id$=PanelGridViewProcedure]")[0].innerHTML = pageResponse;
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
function ConfirmMessageForCompleteDocumentOnOK(action) {
    try {
        var _filterData = "UnsavedChangeId=" + UnsavedChangeId;



        _filterData = _filterData + '^ReIntialization=Y';
        _reinitializeTabs = true;
        PopupProcessing();
        LoadDocument(GetCurrentScreenID(), 5763, _filterData, CurrentHistoryId, GetRelativePath(), pageActionEnum.New, null, false, globalCurrentScreenTabIndex);

    }
    catch (err) {//alert('Error occured in JS function ');}
        HidePopupProcessing();
        LogClientSideException(err, 'HRMTreatmetPlan');
    }

}

//Function added by Loveena in ref to New Specs of UM Part II on dropdown change event


function ProcessTxPlanMainInfo(LocId) {
    var myDate = new Date();
    PopupProcessing();
    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=createtxplan&LocId=' + LocId + '&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHRMTxPlanControlOnSuccess);
}


//This function is used for open POP up Stage of Trement on Click  Icon on TxPlan Main Screen - information icon    added by Rakesh Garg
function OpenStageofTreatmentPopUp() {
    var _date = new Date();
    OpenPage(5765, 140, "Time=" + _date.getMinutes() + _date.getSeconds(), 1, GetRelativePathTP(), 'T', "dialogHeight:355px; dialogWidth:460px; dialogtitle:Stage of Treatment;dialogcrossbutton:hide");

}


//This function is used for open POP up Stage of Trement on Click  Icon on TxPlan Main Screen - information icon    added by Rakesh Garg


function FillAuthorizationDropdownOnSuccess(result, dropdownAuthorizationID, spanID) {

    if (result != null && result != "") {
        $("[id$=" + spanID + "]").html(result);
        $("[id$=" + dropdownAuthorizationID + "]").val('');

    }
    parent.HidePopupProcessing();
}



//Desc:Method is used to set the tab control status based on the criteria
//Author:Vikas Vyas
//CreatedOn:11/26/2010
function SetTabControlStatus(truefalse) {
    TreatmentPlanHRM.GetTab(1).SetEnabled(truefalse);
    TreatmentPlanHRM.GetTab(2).SetEnabled(truefalse);
    TreatmentPlanHRM.GetTab(4).SetEnabled(truefalse);
}



//Description:Method is used to insert/update row in the TPProcedures table and update value in TPIntervention 
function SaveFrequencyScopeAndDuration() {


    //Perform validation before proceeding further
    //Basic Validations
    //End

    //IF Provider is external and BillingCode specify is must then 
    //End

    var siteId = $("input[id$=HiddenFieldSiteId]").val();
    var tpprocedureId = $("input[id$=HiddenFieldTPProcedureId]").val();
    var authorizationcodeId = $("input[id$=HiddenFieldAuthorizationCodeId]").val();
    var fromDate = $("input[type=text][id$=TextBox_TPProcedures_StartDate]").val();
    var toDate = $("input[type=text][id$=TextBox_TPProcedures_EndDate]").val();
    var unitReqested = $("input[type=text][id$=TextBox_TPProcedures_Units]").val();
    var totalUnit = $("input[type=text][id$=TextBox_TPProcedures_TotalUnits]").val();
    var frequecyType = $("select[id$=DropDownList_TPProcedures_FrequencyType]")[0].value;
    var requestorComment = $("textarea[id$=TextArea_TPGeneral_AuthorizationRequestorComment]").val();
    var myDate = new Date();
    PopupProcessing();
    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?tpprocedureId=" + tpprocedureId, 'action=updatefrequencyscopeanddurations&authorizationcodeId=' + authorizationcodeId + '&siteId=' + siteId + '&fromDate=' + fromDate + '&toDate=' + toDate + '&unitReqested=' + unitReqested + '&totalUnit=' + totalUnit + '&frequecyType=' + frequecyType + '&requestorComment=' + requestorComment + '&time=' + myDate.getMinutes() + myDate.getSeconds(), RecreateHRMTxPlanControlOnSuccess);

}


//Create popup for stage of treatment

function CreatePopup() {

    var calledTo = $('[id$=ShowPopup]').val();
    var AuthorizationCodeId = $('[id$=AuthorizationCodeId]').val();
    var SiteId = $('[id$=SiteId]').val();
    var TPInterventionProcedureId = $('[id$=TPInterventionProcedureId]').val();
    if (AuthorizationCodeId != "") {
        if (calledTo == "Select") {
            OpenPage(5765, 162, 'AuthorizationCodeId=' + AuthorizationCodeId + '^SiteId=' + SiteId + '^TPInterventionProcedureId=' + TPInterventionProcedureId, null, GetRelativePath(), 'T', "dialogHeight: 250px; dialogWidth: 680px;dialogTitle:Authorizations");
        }
        else {
            OpenPage(5765, 161, 'AuthorizationCodeId=' + AuthorizationCodeId + '^SiteId=' + SiteId + '^TPInterventionProcedureId=' + TPInterventionProcedureId, null, GetRelativePath(), 'T', "dialogHeight: 580px; dialogWidth: 950px;dialogTitle:Frequency Scope And Duration");
        }
    }


}

function CreateTxPlanOnCloseFrequencyAndScope() {
    var myDate = new Date();
    var LocID = $("input[id$=HiddenFieldLocID]").val();
    PopupProcessing();
    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=recreatetxplanaftersave&time=' + myDate.getMinutes() + myDate.getSeconds() + '&LocID=' + LocID, RecreateHRMTxPlanControlOnSuccess);
}


//This function is used for open Frequency and scope duration on Edit Authorization.
function OpenEditAuthorization(TpProcedureId, NeedId, AuthorizationCodeId, LocId, SiteId, TPInterventionProcedureId) {
    //Modified by Mamta Gupta - Ref Task No. 755 - SCWebPhaseII Bugs/Features - To stop open popup in case of siteId -2
    if ($('[Id$=DropDownList_TPInterventionProvider_' + TPInterventionProcedureId + ']').length > 0) {
        var Providerval = $('[Id$=DropDownList_TPInterventionProvider_' + TPInterventionProcedureId + ']').val();
        if (parseInt(Providerval) == -2) {
            return;
        }
    }

    //Changes made by Vikas Kasyup-22/Oct/2011 Ref task No. 338- To show processing until the popup open
    //PopupProcessing();
    var openSelectAuth = false;
    var dropdownID = $('[id$=DropDownList_TPInterventionService_' + TPInterventionProcedureId + ']').val();
    AuthorizationCodeId = dropdownID;

    if ($('[id$=DropDownList_TPInterventionService_' + TPInterventionProcedureId + ']').attr('disabled') != true) {
        $('[id*=DropDownList_TPInterventionService_').each(
    function(index) {

        if ($(this).val() == AuthorizationCodeId) {
             if ($(this).attr('InitializedFromPreviousPlan') != 'Y') {
            var strSplit = $(this).attr('id').split('DropDownList_TPInterventionService_')[1];
            if ($('[id$=DropDownList_TPInterventionProvider_' + strSplit + ']').val() == SiteId && $(this).attr('disabled') == true) {
                openSelectAuth = true;
            }
            }
        }
    }
   );

    }


    if (openSelectAuth == true) {
        //Open Select Authorization
        OpenPage(5765, 162, 'AuthorizationCodeId=' + AuthorizationCodeId + '^SiteId=' + SiteId + '^TPInterventionProcedureId=' + TPInterventionProcedureId + '^LocId=' + LocId, null, GetRelativePath(), 'T', "dialogHeight:250px; dialogWidth: 680px;dialogTitle:Authorizations;dialogcrossbutton:hide");
    }

    else {

        if (AuthorizationCodeId != "" && AuthorizationCodeId != null && AuthorizationCodeId != "0") {

            OpenPage(5765, 161, 'AuthorizationCodeId=' + AuthorizationCodeId + '^SiteId=' + SiteId + '^TPInterventionProcedureId=' + TPInterventionProcedureId + '^TPProcedureId=' + TpProcedureId + '^LocId=' + LocId, null, GetRelativePath(), 'T', "dialogHeight: 580px; dialogWidth: 950px;dialogTitle:Frequency Scope And Duration;dialogcrossbutton:hide");
        }
        else {
            ShowMsgBox('Please select service from dropdown.', TPAlertCaption, MessageBoxButton.OK, MessageBoxIcon.Information);

        }
    }
}





///Open Pop up when user click on new Authorization in Select Authorization Screen
function openFrequencyScope(AuthorizationCodeId, SiteId, tpInterventionProcedureId) {

    try {
        if (AuthorizationCodeId != "" && AuthorizationCodeId != null && AuthorizationCodeId != "0")
            var LocID = $("input[id$=HiddenFieldLocID]").val();
        OpenPage(5765, 161, 'AuthorizationCodeId=' + AuthorizationCodeId + '^SiteId=' + SiteId + '^TPInterventionProcedureId=' + tpInterventionProcedureId + '^LocId=' + LocID, null, GetRelativePath(), 'T', "dialogHeight: 580px; dialogWidth: 950px;dialogTitle:Frequency Scope And Duration;dialogcrossbutton:hide");


    }
    catch (err) {
        LogClientSideException(err, 'TPPopup');
    }
}






///This is used for confirm Clear Authorization.
function MessageBoxConfirmStatus(confirmResult, TpProcedureId, NeedId, TPInterventionProcedureId) {

    switch (confirmResult) {
        case 'yes':
            var myDate = new Date();
            PopupProcessing();
            //$.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=cleartpauthorization&time=' + myDate.getMinutes() + myDate.getSeconds() + '&TpProcedureId=' + TpProcedureId + '&NeedId=' + NeedId + '&TPInterventionProcedureId=' + TPInterventionProcedureId, RecreateHRMTxPlanControlOnSuccess);
            $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx", 'action=cleartpauthorization&time=' + myDate.getMinutes() + myDate.getSeconds() + '&TpProcedureId=' + TpProcedureId + '&NeedId=' + NeedId + '&TPInterventionProcedureId=' + TPInterventionProcedureId, function(result) { onSuccessRecreateInterventionCloseFrequencyAndScope(result, TPInterventionProcedureId); });
            break;
        case 'no':
            break;
    }
}


///This is used for confirm Clear Authorization.
function ClearAuthorization(TpProcedureId, NeedId, AuthorizationCodeId, LocId, SiteId, TPInterventionProcedureId) {
    ShowMsgBox('You are about to remove the selected service and associated authorization.  Are you sure you wish to proceed?', ConfirmationMessageCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'MessageBoxConfirmStatus(\'yes' + '\',\'' + TpProcedureId + '\',\'' + NeedId + '\',\'' + TPInterventionProcedureId + '\')', 'MessageBoxConfirmStatus(\'no' + '\')');

}



//This is used for update TPGeneral Table Field AuthorizationRequestorComment on Pop up Closed.
function ModalPopupWindowClosed(ModelPopupName) {

    if (window.frames["iframeWindowDialog"].length > 0) {
        var textBoxAuthComment = $("[id$=TextArea_TPGeneral_AuthorizationRequestorComment]", window.frames["iframeWindowDialog"].document);
        if (textBoxAuthComment.length > 0) {
            CreateAutoSaveXml('TPGeneral', 'AuthorizationRequestorComment', textBoxAuthComment.val());
        }
    }
    scrollPostion = $('[id$=TreatmentPlanHRM_C1]')[0].scrollTop;
    scrollFor = "AddIntervention";

    if (ModelPopupName.toString().indexOf('strObj') > 0) {
        //Open Frequency Scope and Duration
        eval(ModelPopupName);
        openFrequencyScope(strObj.AuthorizationCodeId, strObj.SiteId, strObj.TPInterventionProcedureId);

    }

    return false;
}


///This is used for enable and disable tabs if effective date enter
function CustomEffectiveDateOnChangeEventHandler(effectiveDate) {

    EnableDisabelTreatmentTabs(AutoSaveXMLDom, "");
    //Maninder: Insert/Update LOCStartDate on change of EffectiveDate
    CreateAutoSaveXml('CustomClientLOCs', 'LOCStartDate', $('#TextBox_DocumentInformation_EffectiveDate').val());

}

function DivScrollPos(val) {

    hidScroll = val.scrollTop;
}


function SetDivScroll(divid) {

    $('#' + divid + '')[0].scrollTop = hidScroll;
}

function EnableDisable_GoalMonitoredStaffOther(obj, NeedId) {

    $('input#TextBox_TPNeeds_GoalMonitoredStaffOther_' + NeedId).attr('disabled', !$(obj).attr('checked'));
    $('select[id$=DropDownList_TPNeeds_GoalMonitoredStaff_' + NeedId + ']').attr('disabled', $(obj).attr('checked'));
    ModifyGoalValueInDataSet(NeedId, 'TPNeeds', 'GoalMonitoredStaffOtherCheckbox', obj.id, 'Edit', 'NeedId');

    if (!$(obj).attr('checked')) {
        $('input#TextBox_TPNeeds_GoalMonitoredStaffOther_' + NeedId).val('');

    }
    else {
        $('select[id$=DropDownList_TPNeeds_GoalMonitoredStaff_' + NeedId + ']').val('');

    }


}

//function ValidateCustomPageEventHandler() {
//    ShowHideErrorMessage('', 'false');
//    var validOrNot = true;
//    $('input[id^=CheckBox_TPNeeds_GoalMonitoredStaffOtherCheckbox_][type=checkbox]').each(function() {
//        
//        
//        var splitArr = $(this).attr('id').split('_');
//        var NeedId = splitArr[3];
//        if ($(this).attr('checked') == true && $('input#TextBox_TPNeeds_GoalMonitoredStaffOther_' + NeedId).val() == '') {

//            ShowHideErrorMessage('Either enter the monitored by staff name in textbox or select it from dropdownlist', 'true');
//            validOrNot = false;
//        }
//        else
//            if ($(this).attr('checked') == false && $('select[id$=DropDownList_TPNeeds_GoalMonitoredStaff_' + NeedId).val() == '') {
//            ShowHideErrorMessage('Either enter the monitored by staff name in textbox or select it from dropdownlist', 'true');
//            validOrNot = false;
//        }

//    }
//    );
//     

//     return validOrNot;
//}

function ChangeOtherFields(obj, NeedId) {
    if (obj.nodeName == "SELECT") {
        $('input#TextBox_TPNeeds_GoalMonitoredStaffOther_' + NeedId).val('');
        $('input#TextBox_TPNeeds_GoalMonitoredStaffOther_' + NeedId).attr('disabled', true);
        $('input#CheckBox_TPNeeds_GoalMonitoredStaffOtherCheckbox_' + NeedId).attr('checked', false);
    }
    else
        if (obj.id == "TextBox_TPNeeds_GoalMonitoredStaffOther_" + NeedId) {
        $('select[id$=DropDownList_TPNeeds_GoalMonitoredStaff_' + NeedId + ']').val('');
        $('select[id$=DropDownList_TPNeeds_GoalMonitoredStaff_' + NeedId + ']').attr('disabled', true);
        $('input#CheckBox_TPNeeds_GoalMonitoredStaffOtherCheckbox_' + NeedId).attr('checked', true);
    }
}


function onSuccessAddIntervention(result, needId) {
    HidePopupProcessing();
    parent.CreateUnsavedInstanceOnDatasetChange();
    var pageResponse = result;
    var start = pageResponse.indexOf("###STARTPAGERESPONSESINGLEINTERVENTION###") + 41;
    var end = pageResponse.indexOf("###ENDPAGERESPONSESINGLEINTERVENTION###");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {

        var InterventionSection = $('table#InterventionSection_' + needId + '>tbody');
        if (InterventionSection.length > 0) {
            InterventionSection.append(pageResponse);
        }
        else {
            $('tr#InterventionRow_' + needId).before(pageResponse);
        }
    }
    EnableDisableRenumberLink("table#InterventionSection_" + needId, 'span#Span_RenumberIntervention_' + needId);  
}

function onSuccessQuickCopy(result,tpInterventionProcedureId) {
    HidePopupProcessing();
    //debugger;
    parent.CreateUnsavedInstanceOnDatasetChange();
    var pageResponse = result;
    var start = pageResponse.indexOf("###STARTPAGERESPONSESINGLEINTERVENTION###") + 41;
    var end = pageResponse.indexOf("###ENDPAGERESPONSESINGLEINTERVENTION###");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {

        var TPInterventionProcedures = $('tr.TPInterventionProcedures_' + tpInterventionProcedureId + ':eq(2)');
        TPInterventionProcedures.after(pageResponse);
        
    }
}

function RecreateInterventionCloseFrequencyAndScope(tpInterventionProcedureId) {
    //debugger;
    parent.CreateUnsavedInstanceOnDatasetChange();
    var myDate = new Date();
    var LocID = $("input[id$=HiddenFieldLocID]").val();
    PopupProcessing();
    $.post(GetRelativePath() + "ActivityPages/Client/Detail/TreatmentPlanHRM/TreatmentPlanHRMAjaxScript.aspx?time=" + myDate.getMinutes() + myDate.getSeconds(), 'action=recreateinterventionclosefrequencyandscope&LocID=' + LocID + '&TPInterventionProcedureId=' + tpInterventionProcedureId, function(result) { onSuccessRecreateInterventionCloseFrequencyAndScope(result, tpInterventionProcedureId) });
}

function onSuccessRecreateInterventionCloseFrequencyAndScope(result, tpInterventionProcedureId) {
    HidePopupProcessing();
    //debugger;
    parent.CreateUnsavedInstanceOnDatasetChange();
    var pageResponse = result;
    var start = pageResponse.indexOf("###STARTPAGERESPONSESINGLEINTERVENTION###") + 41;
    var end = pageResponse.indexOf("###ENDPAGERESPONSESINGLEINTERVENTION###");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {

        var TPInterventionProcedures = $('tr.TPInterventionProcedures_' + tpInterventionProcedureId + '');
        TPInterventionProcedures.eq('0').prev().after(pageResponse);
        TPInterventionProcedures.empty().remove();

    }
}

function onSuccessDeleteIntervention(result, tpInterventionProcedureId, needId) {
    HidePopupProcessing();
//    debugger;
        var pageResponse = result;
        var start = pageResponse.indexOf("###STARTPAGERESPONSESINGLEINTERVENTION###") + 41;
        var end = pageResponse.indexOf("###ENDPAGERESPONSESINGLEINTERVENTION###");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {
        if (pageResponse == "") {
            var InterventionSection = $("table#InterventionSection_" + needId).parent().parent();
            InterventionSection.prev().remove();
            InterventionSection.empty().remove();
        }
        else {
            $("table#InterventionSection_" + needId).html(pageResponse);
            //TPInterventionProcedures.empty().remove();
        }
        EnableDisableRenumberLink("table#InterventionSection_" + needId, 'span#Span_RenumberIntervention_' + needId);  
    //var TPInterventionProcedures = $('tr.TPInterventionProcedures_' + tpInterventionProcedureId + '');
    //TPInterventionProcedures.empty().remove();

    }
}

function onSuccessRecreateObjectives(result, needId) {
    HidePopupProcessing();
    //debugger;
    parent.CreateUnsavedInstanceOnDatasetChange();
    var pageResponse = result;
    var start = pageResponse.indexOf("###STARTPAGERESPONSESINGLEOBJECTIVE###") + 38;
    var end = pageResponse.indexOf("###ENDPAGERESPONSESINGLEOBJECTIVE###");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {

        var TPObjective = $('tr#ObjectiveNeedIdEnd_' + needId + '');
        TPObjective.prev().after(pageResponse);
        //TPInterventionProcedures.empty().remove();

    }
    EnableDisableRenumberLink('tr[class^=ObjectiveRowId_' + needId+']', 'span#Span_RenumberObjective_' + needId);
}

function onSuccessDeleteObjective(result, objectiveId, needId) {
    HidePopupProcessing();
    //debugger;
    parent.CreateUnsavedInstanceOnDatasetChange();
    //debugger;
    var pageResponse = result;
    var start = pageResponse.indexOf("###STARTPAGERESPONSESINGLEOBJECTIVE###") + 38;
    var end = pageResponse.indexOf("###ENDPAGERESPONSESINGLEOBJECTIVE###");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {

        var TPObjectives = $('tr[class^=ObjectiveRowId_' + needId + ']');
        //TPInterventionProcedures.prev().after(pageResponse);
        TPObjectives.empty().remove();
        var TPObjective = $('tr#ObjectiveNeedIdEnd_' + needId + '');
        TPObjective.prev().after(pageResponse);
        onSuccessDeleteIntervention(result, undefined, needId);
    }
    EnableDisableRenumberLink('tr[class^=ObjectiveRowId_' + needId+']', 'span#Span_RenumberObjective_' + needId);
}


function onSuccessAddGoal(result, needId) {
    HidePopupProcessing();
    //debugger;
    parent.CreateUnsavedInstanceOnDatasetChange();
    //debugger;
    var pageResponse = result;
    var start = pageResponse.indexOf("###STARTPAGERESPONSESINGLEGOAL###") + 33;
    var end = pageResponse.indexOf("###ENDPAGERESPONSESINGLEGOAL###");
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {

        var trMainGoal = $('tr#MainGoalEnd_' + needId);
        //TPInterventionProcedures.prev().after(pageResponse);
        var nextTR = trMainGoal.next();
        nextTR.remove();
        trMainGoal.after(pageResponse);
        //TPObjective.prev().after(pageResponse);

    }
}

function EnableDisableRenumberLink(selector, spanId) {

    if ($(selector).length > 0) {
        $(spanId).attr('disabled', false);
        $(spanId).css('cursor', 'pointer');
    }
    else {
        $(spanId).attr('disabled', true);
        $(spanId).css('cursor', 'text');
    }
}