$("document").ready(function () {
    try {

        SetScreenData();
        return false;

    }
    catch (err) {
        LogClientSideException(err, 'Summary'); ///Code added by Devinder
    }
});




function SetParentReturnValue(val) {
    try {
        if (val == 'ok') {
            var name = $('#TextBox_CustomHRMAssessments_GuardianName').val();
            var address = $('#TextArea_CustomHRMAssessments_GuardianAddress').val();
            var phone = $('#TextBox_CustomHRMAssessments_GuardianPhone').val();
            var ddltext = $("#DropDownList_CustomHRMAssessments_GuardianType option:selected").text()
            var type = $('#DropDownList_CustomHRMAssessments_GuardianType').val();
            retValue = name + " \n" + address + " \n" + "Type: " + ddltext + " \n" + "Phone:  " + phone + " \n" + "Text: " + type
            window.returnValue = retValue;
        }
        else if (val == 'cancel') {
            window.returnValue = "";
        }
        window.close();
    }
    catch (err) {
        LogClientSideException(err, 'GuardianInfo'); //Code added by Damanpreet 
    }
}

function SetScreenData() {
    //Modified by sourabh with ref to task#452
    var newDom = $.xmlDOM(parent.window.AutoSaveXMLDom[0].xml);
    AutoSaveXMLDom = newDom;
    //end here
    var xmlHrmAssessmentRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessments");
    if (xmlHrmAssessmentRow[0].selectNodes("GuardianName").length > 0 && xmlHrmAssessmentRow[0].selectNodes("GuardianName")[0].text.trim() != '') {
        $("input[id$=TextBox_CustomHRMAssessments_GuardianName]").val(xmlHrmAssessmentRow[0].selectNodes("GuardianName")[0].text);

    }

    if (xmlHrmAssessmentRow[0].selectNodes("GuardianAddress").length > 0 && xmlHrmAssessmentRow[0].selectNodes("GuardianAddress")[0].text.trim() != '') {
        $("textarea[id$=TextArea_CustomHRMAssessments_GuardianAddress]").val(xmlHrmAssessmentRow[0].selectNodes("GuardianAddress")[0].text);
    }

    if (xmlHrmAssessmentRow[0].selectNodes("GuardianPhone").length > 0 && xmlHrmAssessmentRow[0].selectNodes("GuardianPhone")[0].text.trim() != '') {
        $("input[id$=TextBox_CustomHRMAssessments_GuardianPhone]").val(xmlHrmAssessmentRow[0].selectNodes("GuardianPhone")[0].text);
    }


    if (xmlHrmAssessmentRow[0].selectNodes("GuardianType").length > 0 && xmlHrmAssessmentRow[0].selectNodes("GuardianType")[0].text.trim() != '') {
        $("select:[id$=DropDownList_CustomHRMAssessments_GuardianType]").val(xmlHrmAssessmentRow[0].selectNodes("GuardianType")[0].text);
    }


}


// Checks Max length of address textarea
//UpdateScreen(buttonClicked, isExternalURL, isPopUp)
function CheckAddressMaxLength(buttonClicked, isExternalURL, isPopUp) {   
    if ($("[id$=TextArea_CustomHRMAssessments_GuardianAddress]").val().length <= 100) {
        UpdateScreen(buttonClicked, isExternalURL, isPopUp);
    }
    else {
        ShowHideErrorMessage('Address can not be more than 100 characters', 'true');
        return;
    }
}

function AddEventHandlers() {
    try {
        $("[id$=DropDownList_CustomHRMAssessments_GuardianType]").change(function () {
            var GuardianTypeText = $("[id$=DropDownList_CustomHRMAssessments_GuardianType] option:selected").text();
            if (GuardianTypeText !== "") {
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianTypeText', GuardianTypeText);
            }
            else
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianTypeText', '');

            var GuardianType = $("[id$=DropDownList_CustomHRMAssessments_GuardianType] option:selected").val();
            if (GuardianType !== "") {
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianType', GuardianType);
            }
            else
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianType', '');
        });

        $("[id$=TextBox_CustomHRMAssessments_GuardianName]").change(function () {
            var GuardianName = $("[id$=TextBox_CustomHRMAssessments_GuardianName]").val();
            if (GuardianName !== "") {
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianName', GuardianName);
            }
            else
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianName', '');
        });

        $("[id$=TextArea_CustomHRMAssessments_GuardianAddress]").change(function () {
            var GuardianAddress = $("[id$=TextArea_CustomHRMAssessments_GuardianAddress]").val();
            if (GuardianAddress !== "") {
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianAddress', GuardianAddress);
            }
            else
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianAddress', '');
        });

        $("[id$=TextBox_CustomHRMAssessments_GuardianPhone]").change(function () {
            PhoneFormatCheck(this);
            var GuardianPhone = $("[id$=TextBox_CustomHRMAssessments_GuardianPhone]").val();
            if (GuardianPhone !== "") {
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianPhone', GuardianPhone);
            }
            else
                CreateAutoSaveXml('CustomHRMAssessments', 'GuardianPhone', '');
        });

    }
    catch (err) {
        LogClientSideException(err, 'CustomHRMAssessments');
    }
}