
var tabobject = null;
var isPopulationChecked = false;
var _reinitializeTabs = false;

function StoreTabstripClientObject(sender) {

    tabobject = sender;
}

//function AddEventHandlers() {
//    try {
//        

//        if ($.xmlDOM(AutoSaveXMLDom[0].xml).find("DocumentVersionId").text() != "-1-1" && $.xmlDOM(AutoSaveXMLDom[0].xml).find("DocumentVersionId").text() != "") {

//            if ($('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialSafetyPlan_Y').attr('checked')) {
//                $('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialSafetyPlan_Y').attr('disabled', 'disabled')
//                $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N").attr('checked', 'checked');
//            }
//            if ($('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialSafetyPlan_N').attr('checked')) {
//                $('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialSafetyPlan_N').attr('disabled', 'disabled')
//                $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y").attr('checked', 'checked');
//            }
//            if ($('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialCrisisPlan_Y').attr('checked')) {
//                $('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialCrisisPlan_Y').attr('disabled', 'disabled')
//            }
//            if ($('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialCrisisPlan_N').attr('checked')) {
//                $('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialCrisisPlan_N').attr('disabled', 'disabled')
//            }

//        }
//        else {
//            if ($('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialSafetyPlan_Y').attr('checked')) {
//                $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N").attr('checked', 'checked');
//            }
//            if ($('#RadioButton_CustomDocumentStandAloneSafetyCrisisPlans_InitialSafetyPlan_N').attr('checked')) {
//                $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y").attr('checked', 'checked');
//            }
//        }
//        InitCustomDocumentSafetyCrisisPlans();
//        var CrisisPlan = tabobject.findTabByText('Crisis Plan');
//        var SafetyPlan = tabobject.findTabByText('Safety Plan');

//        var ClientHasCurrentCrisis = AutoSaveXMLDom.find("CustomDocumentStandAloneSafetyCrisisPlans:first ClientHasCurrentCrisis").text();
//        if (ClientHasCurrentCrisis) {
//            if (ClientHasCurrentCrisis == 'Y') {
//                ShowHideCrisisPlan(CrisisPlan, true);
//            }
//            else {
//                ShowHideCrisisPlan(CrisisPlan, false);
//            }
//        }
//        else {
//            ShowHideCrisisPlan(CrisisPlan, false);
//        }
//    }
//    catch (err) {
//        LogClientSideException(err, 'SafetyCrisisPlan');
//    }
//}



function ClientTabSelectingHandler(sender, eventArgs) {
    var tabStrip = sender;
    var tab = eventArgs._tab;
    if (ParentUserControlName == "HRMNeedList") {

        return true;
        //}

    }
    return true;
}

function GetXMLParentNodeByTable(tableName, xmlDom) {
    var expression = tableName;
    return $(expression, xmlDom);
}
function GetXMLParentNodeByColname(colname, xmlDom) {
    var expression = colname;
    return $(expression, xmlDom).parent();
}

showCurrentCrisis = (function(obj) {

    var CrisisPlan = tabobject.findTabByText('Crisis Plan');
    if (obj.checked) {
        ShowHideCrisisPlan(CrisisPlan, true);
        CreateAutoSaveXml('CustomDocumentStandAloneSafetyCrisisPlans', 'ClientHasCurrentCrisis', 'Y');
    }
    else {
        ShowHideCrisisPlan(CrisisPlan, false);
        CreateAutoSaveXml('CustomDocumentStandAloneSafetyCrisisPlans', 'ClientHasCurrentCrisis', 'N');
    }
});

function ShowHideCrisisPlan(tabInstance, showTab) {

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
function ChangeDomObject(action) {
    if (action == pageActionEnum.TabRequest)
        return AutoSaveXMLDom;

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
        OpenPage(5761, 3, 'ClientID=' + objectPageResponse.ClientId, null, GetRelativePath(), null, null, null, 2, null, null);
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
        $('#HiddenField_CustomSafetyCrisisPlanReviews_DocumentVersionId').val(AutoSaveXMLDom.find("CustomDocumentStandAloneSafetyCrisisPlans:first DocumentVersionId").text());

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
            if (parseInt($("[id$=TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays]").val().trim()) > 0 && parseInt($("[id$=TextBox_CustomSafetyCrisisPlanReviews_ReviewEveryXDays]").val().trim()) < 15) {
                ShowHideErrorMessage('“Review Every” number must be between 1 and 14', 'false');
            }
            else {
                ShowHideErrorMessage('“Review Every” number must be between 1 and 14', 'true');
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

    $('#HiddenField_CustomCrisisPlanMedicalProviders_DocumentVersionId').val(AutoSaveXMLDom.find("CustomDocumentStandAloneSafetyCrisisPlans:first DocumentVersionId").text());
    //$('#HiddenField_CustomCrisisPlanMedicalProviders_AddressTypeText').val($('[id$=DropDownList_CustomCrisisPlanMedicalProviders_AddressType] :selected').text());
    var validatecount = 0;
    if ($('#TextBox_CustomCrisisPlanMedicalProviders_Name').val().trim().length == 0)
        validatecount++;
    if ($('[id$=DropDownList_CustomCrisisPlanMedicalProviders_AddressType] :selected').val().trim().length == 0)
        validatecount++;
    if ($('#Textbox_CustomCrisisPlanMedicalProviders_Address').val().trim().length == 0)
        validatecount++;
    if ($('#Textbox_CustomCrisisPlanMedicalProviders_Phone').val().trim().length == 0)
        validatecount++;
    if (validatecount == 4)
        return false;

    InsertGridData('TableChildControl_CustomCrisisPlanMedicalProviders', 'InsertGrid_CustomCrisisPlanMedicalProviders', 'CustomGrid_CustomCrisisPlanMedicalProviders', $('#TableChildControl_CustomCrisisPlanMedicalProviders_ButtonInsert')[0]);
}

function InsertCrisisPlanNetworkProviders() {
    $('#HiddenField_CustomCrisisPlanNetworkProviders_DocumentVersionId').val(AutoSaveXMLDom.find("CustomDocumentStandAloneSafetyCrisisPlans:first DocumentVersionId").text());
    //$('#HiddenField_CustomCrisisPlanNetworkProviders_AddressTypeText').val($('[id$=DropDownList_CustomCrisisPlanNetworkProviders_AddressType] :selected').text());
    var validatecount = 0;
    if ($('#TextBox_CustomCrisisPlanNetworkProviders_Name').val().trim().length == 0)
        validatecount++;
    if ($('[id$=DropDownList_CustomCrisisPlanNetworkProviders_AddressType] :selected').val().trim().length == 0)
        validatecount++;
    if ($('#TextBox_CustomCrisisPlanNetworkProviders_Address').val().trim().length == 0)
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

        if ($(obj).attr('checked') && $(obj).attr('id') == "CheckBox_CustomDocumentStandAloneSafetyCrisisPlans_ThreeMonths") {
            if ($('#CheckBox_CustomDocumentStandAloneSafetyCrisisPlans_TwelveMonths').attr('checked')) {
                filtermode = '12months';
            }
        }
        else if ($(obj).attr('checked') == false && $(obj).attr('id') == "CheckBox_CustomDocumentStandAloneSafetyCrisisPlans_ThreeMonths") {
            filtermode = '';
            if ($('#CheckBox_CustomDocumentStandAloneSafetyCrisisPlans_TwelveMonths').attr('checked')) {
                filtermode = '12months';
            }
        }
        else if ($(obj).attr('checked') == false && $(obj).attr('id') == "CheckBox_CustomDocumentStandAloneSafetyCrisisPlans_TwelveMonths") {
            filtermode = '';
            if ($('#CheckBox_CustomDocumentStandAloneSafetyCrisisPlans_ThreeMonths').attr('checked')) {
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

function InitCustomDocumentSafetyCrisisPlans() {
    var _documentversionid;
    var _createdby;
    var _createddate;
    var _modifiedby;
    var _modifieddate;

    var TableLength = AutoSaveXMLDom.find("CustomDocumentStandAloneSafetyCrisisPlans").length;
    if (TableLength == 0) {
        var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomDocumentStandAloneSafetyCrisisPlans')); //Add Table
        _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
        _documentversionid.text = AutoSaveXMLDom.find("CustomDocumentStandAloneSafetyCrisisPlans:first DocumentVersionId").text();
        _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
        _createdby.text = objectPageResponse.LoggedInUserCode;
        _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
        _createddate.text = ISODateString(new Date());
        _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
        _modifiedby.text = objectPageResponse.LoggedInUserCode;
        _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
        _modifieddate.text = ISODateString(new Date());
    }
    AddToUnsavedTables("CustomDocumentStandAloneSafetyCrisisPlans");
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

function deleteSupport(deleteSection, tableName, columnName, primaryKey, pkkeyValue, changeVal) {
    ShowMsgBox('Are you sure want to remove this Support?', ConfirmationMessageCaption, MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'deleteSupportOnOkOption(\'' + deleteSection + '\',\'' + tableName + '\',\'' + columnName + '\',\'' + primaryKey + '\',\'' + pkkeyValue + '\',\'' + changeVal + '\');');
}

function ReInitializeSafetyPlan(ControlID) {

    
    documentRowFilterCheckBoxDom = 'InitialSafetyPlan';
    var SafetyInitialorReview;
    parent.PopupProcessing();
    if (ControlID == 'Y') {
        SafetyInitialorReview = 'SafetyInitialorReview=Y';
        CreateAutoSaveXml('CustomDocumentStandAloneSafetyCrisisPlans', 'InitialSafetyPlan', 'Y');
        $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_N").attr('checked', 'checked');
    }
    else if (ControlID == 'N') {
        SafetyInitialorReview = 'SafetyInitialorReview=N';
        $("#RadioButton_CustomSafetyCrisisPlanReviews_SafetyCrisisPlanReviewed_Y").attr('checked', 'checked');
        CreateAutoSaveXml('CustomDocumentStandAloneSafetyCrisisPlans', 'InitialSafetyPlan', 'N');
    }
    var _filterData = "UnsavedChangeId=" + UnsavedChangeId;

    _filterData = _filterData + '^' + SafetyInitialorReview + '^ReIntialization=Y';
    _reinitializeTabs = true;
    LoadDocument(GetCurrentScreenID(), 5763, _filterData, CurrentHistoryId, GetRelativePath(), pageActionEnum.New, null, false, globalCurrentScreenTabIndex);
    CreateInitializationImages(AutoSaveXMLDom);
}
function ReInitializeCrisisPlan(ControlID) {

    documentRowFilterCheckBoxDom = 'InitialSafetyPlan';
    var CrisisInitialorReview;
    parent.PopupProcessing();
    if (ControlID == 'Y') {
        CrisisInitialorReview = 'CrisisInitialorReview=Y';
        CreateAutoSaveXml('CustomDocumentStandAloneSafetyCrisisPlans', 'InitialCrisisPlan', 'Y');


    }
    else if (ControlID == 'N') {
        CrisisInitialorReview = 'CrisisInitialorReview=N';
        CreateAutoSaveXml('CustomDocumentStandAloneSafetyCrisisPlans', 'InitialCrisisPlan', 'N');

    }
    var _filterData = "UnsavedChangeId=" + UnsavedChangeId;

    _filterData = _filterData + '^' + CrisisInitialorReview + '^ReIntialization=Y';
    _reinitializeTabs = true;
    LoadDocument(GetCurrentScreenID(), 5763, _filterData, CurrentHistoryId, GetRelativePath(), pageActionEnum.New, null, false, 1);
    CreateInitializationImages(AutoSaveXMLDom);
}

