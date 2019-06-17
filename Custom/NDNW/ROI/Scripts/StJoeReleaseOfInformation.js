
//Created By: Sanjay Bhardwaj
//Created On: 21Jan2013
//Purpose : SetScreenSpecificValues
function SetScreenSpecificValues(dom, action) {

    var ROIsJsonData = "";
    var ROIsJsonSerializedData = "";
    ROIsJsonData = $('[id$=HiddenField_CentraWellnessROIJSONData]').val();
    ROIsJsonSerializedData = eval('(' + ROIsJsonData + ')');
    if (ROIsJsonData.length > 0) {
        $("#DivROIContentMain").html('');
        $("#ROITemplate").tmpl(ROIsJsonSerializedData.objectListROIs).appendTo("#DivROIContentMain");

    }
    showHideControls();
    AttachOnBlurEvents();
    showHideROI();
}

//Created By: Sanjay Bhardwaj
//Created On: 21Jan2013
//Purpose : To fill newly/existing ROI
function AddNewCentraWellnessROI(NewROISource, ROIId) {
    OpenPage(5763, GetCurrentScreenID(), 'CustomAction=AddNewCentraWellnessROI^NewROISource=' + NewROISource + "^ROIId=" + ROIId, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
}

//Created By:sanjay bhardwaj
//Created On: 22Jan2013
//Purpose : Handle onBlur event for controls on change of any value
function AttachOnBlurEvents() {
    $("select,input[type=radio],input[type=checkbox],input[type=text]", $('#DivROIContentMain')).each(function() {
        this.onchange = function() { UpdateROIsObjectXML(this) };
    });
}

//Created By:sanjay bhardwaj
//Created On: 22Jan2013
//Purpose : Update value in xml
function UpdateROIsObjectXML(ctrl) {

    var nameArray = ctrl.id.split("_");
    var tablename = nameArray[1];
    var primaryKeyColumnName = '';
    if (tablename.toLowerCase().trim() == "customdocumentreleaseofinformations") {
        primaryKeyColumnName = "ReleaseOfInformationId";
    }
    var primaryKeyValue = nameArray[2];
    var columnname = nameArray[nameArray.length - 1];
    var ctrlValue = GetControlValue(ctrl, undefined);


    SetColumnValueInXMLNodeByKeyValue(tablename, primaryKeyColumnName, primaryKeyValue, columnname, ctrlValue, AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();

    SetColumnValueInXMLNodeByKeyValue("customdocumentreleaseofinformations", "ReleaseOfInformationId", primaryKeyValue, "TempRecordDeleted", "", AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();

}
//Created By:sanjay bhardwaj
//Created On: 22Jan2013
//Purpose : Update Radio value in xml
function UpdateRadioObjectXML(ctrlID) {
    //debugger;
    var nameArray = ctrlID.split("_");
    var tablename = nameArray[1];
    var primaryKeyColumnName = '';
    if (tablename.toLowerCase().trim() == "customdocumentreleaseofinformations") {
        primaryKeyColumnName = "ReleaseOfInformationId";
    }
    var primaryKeyValue = nameArray[2];
    var columnname = nameArray[nameArray.length - 1];
    //var ctrlValue = GetControlValue(ctrl, undefined);


    SetColumnValueInXMLNodeByKeyValue(tablename, primaryKeyColumnName, primaryKeyValue, columnname, "", AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();

}
//Created By:sanjay bhardwaj
//Created On: 22Jan2013
//Purpose : Update value in xml for radio button type controls
function UpdateROIsObjectXMLforCheckboxButtons(ctrl) {
    var nameArray = ctrl.id.split("_");
    var tablename = nameArray[1];
    var primaryKeyValue = nameArray[2];
    var columnname = nameArray[nameArray.length - 1];
    var primaryKeyColumnName = '';
    if (tablename.toLowerCase().trim() == "customdocumentreleaseofinformations") {
        primaryKeyColumnName = "ReleaseOfInformationId";
    }
    var ctrlValue = GetControlValue(ctrl);
    SetColumnValueInXMLNodeByKeyValue(tablename, primaryKeyColumnName, primaryKeyValue, columnname, ctrlValue, AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();
}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose: Bind DropDownList in ROI Template
function CustomAjaxRequestCallback(response, CustomAjaxCall) {

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

    if (outputHTML.indexOf("###StartAddNewROI###") >= 0 || outputHTML.indexOf("###StartAddNewROIb###") >= 0) {
        RefreshROITemplate(outputHTML);
    }
    showHideControls();
    showHideROI();
}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose: Show Hide Contacts based on Organisation
function ShowHideContacts(ContactId, ShowHideFlag) {

    if (ShowHideFlag == "O") {
        $('div#div_CentraWellnessROIContact_' + ContactId).slideDown("slow", function() { $('table#Table_CentraWellnessROIContact_' + ContactId).show(); });
        $('#button_CustomDocumentReleaseOfInformations_' + ContactId + '_OpenContacts').attr("disabled", "disabled");
    }
    if (ShowHideFlag == "C") {
        $('div#div_CentraWellnessROIContact_' + ContactId).slideUp("slow", function() { $('table#Table_CentraWellnessROIContact_' + ContactId).hide(); });
        $('#button_CustomDocumentReleaseOfInformations_' + ContactId + '_OpenContacts').removeAttr("disabled");
    }
}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose: Bind DropDownList in ROI Template
function GetDropDownHtmlDropdowns(DropDownType, ROIId, DropDownValue) {
    if (DropDownType == "ReleaseToReceiveFrom") {
        $("select[id$=DropDownList_CustomDocumentReleaseOfInformations_ReleaseToReceiveFrom]").val(DropDownValue);
        return $('select[id$=DropDownList_CustomDocumentReleaseOfInformations_ReleaseToReceiveFrom]').html();
    }
    else if (DropDownType == "ReleaseState") {
        $("select[id$=DropDownList_CustomDocumentReleaseOfInformations_ReleasedState]").val(DropDownValue);
        return $('select[id$=DropDownList_CustomDocumentReleaseOfInformations_ReleasedState]').html();
    }

}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose : To refresh ROI data on adding a new roi
function RefreshROITemplate(response) {
    var startIndex = "";
    var endIndex = "";
    var outputHTML = "";

    if (response.indexOf("###StartAddNewROI###") >= 0) {
        startIndex = response.indexOf("###StartAddNewROI###") + 20;
        endIndex = response.indexOf("###EndAddNewROI###");
        outputHTML = response.substr(startIndex, endIndex - startIndex);
        CreateUnsavedInstanceOnDatasetChange();
        AppendNewROI(outputHTML);
        //}
    }
}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose : Append a new ROI in Jquery Template of ROIs
function AppendNewROI(outputHTML) {
    var ROIsJsonData = "";
    var ROIsJsonSerializedData = "";
    ROIsJsonData = outputHTML;
    ROIsJsonSerializedData = eval('(' + ROIsJsonData + ')');
    if (ROIsJsonData.length > 0) {
        //$("#DivROIContentMain").html('');
        $("#ROITemplate").tmpl(ROIsJsonSerializedData.objectListROIs).appendTo("#DivROIContentMain");
    }
    AttachOnBlurEvents();
    $('[id$=ShowAllROI_1]').text('ALL');
    $("[id^='ClearIndROI_']").hide();
    $('[id$=ClearROI_1]').show();
    $('[id$=MovePrev]').removeAttr("disabled");
    $('[id$=MoveNext]').removeAttr("disabled");
}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose: To show the Client Contacts Screen
function OpenContacts() {
    //Check for unsaved changes
    if (Dirty == "True" || UnsavedChangeId > 0) {
        if (IsNotClientViewingMode) {
            //Changed by sanjayb wrt #494 in Project  	Centrawellness-Bugs/Features ROI: Popup should ask the user to save not close
            //var customMessage = " You have unsaved changes left for this document. Do you really want to close the document?";
            var customMessage = "You have unsaved changes. Would you like to save those changes now?";
            ShowMsgBox(customMessage, "Confirmation Messages", MessageBoxButton.YesNo, MessageBoxIcon.Question, "MessageBoxCloseScreenYesOptionROI()", "MessageBoxCloseScreenNoOptionROI()", "MessageBoxCloseScreenCancelOptionROI()", undefined, undefined, undefined, 10); //'MessageBoxCloseScreenYesOptionROI()', 'MessageBoxCloseScreenNoOptionROI()', 'MessageBoxCloseScreenCancelOptionROI()'
        }
    }
    else {
        PopupProcessing();
        OpenPage(5761, 3, 'ClienID=' + ClientID, 2, GetRelativePath(), null, null, null, 2, null, null);
    }
}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose : save unsaved changes
function MessageBoxCloseScreenYesOptionROI() {
    try {
        //Changed by sanjayb wrt #494 in Project  	Centrawellness-Bugs/Features ROI: Popup should ask the user to save not close
        if (ValidationBeforeUpdate()) {
            SavePageData(true);  //Changed by sanjayb wrt #494 in Project  	Centrawellness-Bugs/Features ROI: Popup should ask the user to save not close
            //DeleteUnsavedChangesById(UnsavedChangeId, 'Y');
            //parent.CloaseModalPopupWindow();
            PopupProcessing();
            OpenPage(5761, 3, 'ClienID=' + ClientID, 2, GetRelativePath(), null, null, null, 2, null, null);
        }
        //#494
    }
    catch (Error) {
    }

}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose : close popup
function MessageBoxCloseScreenNoOptionROI() {
    try {
        //Changed by sanjayb wrt #494 in Project  	Centrawellness-Bugs/Features ROI: Popup should ask the user to save not close
        DeleteUnsavedChangesById(UnsavedChangeId, 'N');
        //parent.CloaseModalPopupWindow();
        PopupProcessing();
        OpenPage(5761, 3, 'ClienID=' + ClientID, 2, GetRelativePath(), null, null, null, 2, null, null);
        //#494
        //        return false;
    }
    catch (Error) {
    }
}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose : cancel popup
function MessageBoxCloseScreenCancelOptionROI() {

}

//Created By:sanjayb
//Created On: 23Jan2013
//Purpose : this is used for show/hide controls
function showHideControls() {

    $("#DivROIContentMain input[type=radio]").each(function(e) {
        var controlChecked = $(this).attr('checked');
        var controlValue = '';
        if (controlChecked)
            controlValue = $(this).val();
        var controlID = $(this).attr('id');
        var nameArray = controlID.split("_");
        var ROIId = nameArray[2];
        var controlName = nameArray[nameArray.length - 1];
        if (controlName == 'ReleaseContactType') {
            ShowHideContacts(ROIId, controlValue);
        }
    });
}
//Created By:sanjayb
//Created On: 23Jan2013
//Purpose : this is used for show/hide ROI based to navigation/page
var ROIArray = new Array();
function showHideROI() {
    var ROIsId; var ROINo = 0; var ROIId; var ROINumber = 0;
    $("table[id^='TableMainCentraWellnessROIMain_']").each(function(e) {
        ROIsId = $(this).attr('id');
        ROIId = $(this);
        var nameArray = ROIsId.split("_");
        ROINo = nameArray[1];
        $('div#div_TableMainCentraWellnessROIMain_' + ROINo).hide();
        ROINumber = ROINumber + 1;
        ROIArray[ROINumber] = ROINo;
    });
    
    ROIsJsonData = $('[id$=HiddenField_CentraWellnessROIJSONData]').val();
    if ($('[id$=ROI_CurrentNumber]').val() == "") {
        $('div#div_TableMainCentraWellnessROIMain_' + ROIArray[1]).show();
        $('[id$=ROI_CurrentNumber]').val(1);
    }
    else {
        $('div#div_TableMainCentraWellnessROIMain_' + ROINo).show();
        $('[id$=ROI_CurrentNumber]').val(ROINumber);
    }
    $('[id$=ROI_TotalNumber]').val(ROINumber);
}
//Created By:sanjayb
//Created On: 15Jan2013
//Purpose : this is used for Clearing current ROI
function ClearROI(ROIID) {
    try {
        var ROIsId; var ROINo = 0; var ROIId; var ROINumber = 0;
        if (ROIID == 0) {
            ROINumber = $('[id$=ROI_CurrentNumber]').val();
            ROINumber = ROIArray[ROINumber];
        }
        else {
            ROINumber = ROIID;
        }
        $('select[id$=DropDownList_CustomDocumentReleaseOfInformations_' + ROINumber + '_ReleasedState').val('');
        UpdateRadioObjectXML("DropDownList_CustomDocumentReleaseOfInformations_" + ROINumber + "_ReleasedState");
        $('select[id$=DropDownList_CustomDocumentReleaseOfInformations_' + ROINumber + '_ReleaseToReceiveFrom').val('');
        UpdateRadioObjectXML("DropDownList_CustomDocumentReleaseOfInformations_" + ROINumber + "_ReleaseToReceiveFrom");
        $("#div_TableMainCentraWellnessROIMain_" + ROINumber + " input").each(function(e) {
            var type = $(this).attr("type");
            var controlChecked; var controlValue;
            if (type != undefined) {
                if (type == "checkbox" || type == "radio") {
                    $(this).removeAttr('checked');
                    UpdateRadioObjectXML($(this).attr('id'));
                }
                if (type == "textarea") {
                    $(this).val("");
                    UpdateRadioObjectXML($(this).attr('id'));
                }
                if (type == "text") {
                    var controlID = $(this).attr('id');
                    var nameArray = controlID.split("_");
                    var controlName = nameArray[3];
                    //if (controlName != 'ReleaseEndDate') {
                    $(this).val("");
                    UpdateRadioObjectXML($(this).attr('id'));
                    //}
                }

            }
        });

        SetColumnValueInXMLNodeByKeyValue("customdocumentreleaseofinformations", "ReleaseOfInformationId", ROINumber, "TempRecordDeleted", "Y", AutoSaveXMLDom[0]);
        CreateUnsavedInstanceOnDatasetChange();

        $('div#div_CentraWellnessROIContact_' + ROINumber).slideUp("slow", function() { $('table#Table_CentraWellnessROIContact_' + ROINumber).hide(); });
    }
    catch (Error) {
    }
}
//Created By:sanjayb
//Created On: 23Jan2013
//Purpose : this is used for show/hide ROI based to navigation/page
function ShowROI(ROINo) {
    var curNo = parseInt($('[id$=ROI_CurrentNumber]').val());
    var totalNo = parseInt($('[id$=ROI_TotalNumber]').val());
    if (ROINo > 0) {
        if (curNo < totalNo) {
            $('div#div_TableMainCentraWellnessROIMain_' + ROIArray[curNo]).hide();
            curNo = parseInt(curNo) + 1;
            $('div#div_TableMainCentraWellnessROIMain_' + ROIArray[curNo]).show();
        }
    }
    else {
        if (curNo > 1) {
            $('div#div_TableMainCentraWellnessROIMain_' + ROIArray[curNo]).hide();
            curNo = curNo - 1;
            $('div#div_TableMainCentraWellnessROIMain_' + ROIArray[curNo]).show();
        }
    }
    $('[id$=ROI_CurrentNumber]').val(curNo);
}
function showALLROI() {

    var curValue = $('[id$=ShowAllROI_1]').text();
    if (curValue == 'ALL') {
        $("table[id^='TableMainCentraWellnessROIMain_']").each(function(e) {
            var ROIsId = $(this).attr('id');
            var nameArray = ROIsId.split("_");
            var ROINo = nameArray[1];
            $('div#div_TableMainCentraWellnessROIMain_' + ROINo).show();
        });
        $('[id$=ShowAllROI_1]').text('Set Paging');
        $("[id^='ClearIndROI_']").show();
        $("[id^='ClearIndROI_']").each(function(e) {
            $(this).attr("style", "visibility: visible;text-decoration: underline;cursor: hand; color: Blue; font-size: 11px");
        });
        $('[id$=ClearROI_1]').hide();
        $('[id$=MovePrev]').attr("disabled", "disabled");
        $('[id$=MoveNext]').attr("disabled", "disabled");
    }
    else {
        $('[id$=ShowAllROI_1]').text('ALL');
        showHideROI();
        $("[id^='ClearIndROI_']").each(function(e) {
            $(this).attr("style", "visibility: hidden;text-decoration: underline;cursor: hand; color: Blue; font-size: 11px");
        });
        $('[id$=ClearROI_1]').show();
        $('[id$=MovePrev]').removeAttr("disabled");
        $('[id$=MoveNext]').removeAttr("disabled");
    }

}
