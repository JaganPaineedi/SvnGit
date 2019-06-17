$("document").ready(function() {
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
        alert(val);
        if (val == 'ok') {
            var FirstName = $('#TextBox_CustomInquiries_GuardianFirstName').val();
            var LastName = $('#TextBox_CustomInquiries_GuardianLastName').val();
            var phone = $('#TextBox_CustomInquiries_GuardianPhoneNumber').val();
            //var ddltext = $("#DropDownList_CustomHRMAssessments_GuardianType option:selected").text()
            // var type = $('#DropDownList_CustomHRMAssessments_GuardianType').val();
            retValue = FirstName + " \n" + LastName + " \n" + "Type: " + phone;  //+ " \n" + "Text: " + type
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
    //var newDom = $.xmlDOM(parent.window.AutoSaveXMLDom[0].xml);
    AutoSaveXMLDom = parent.window.AutoSaveXMLDom;
    //    //end here
    //    var xmlCustomInquiriesRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomInquiries");
    //    if (xmlCustomInquiriesRow[0].selectNodes("GuardianFirstName").length > 0 && xmlCustomInquiriesRow[0].selectNodes("GuardianFirstName")[0].text.trim() != '') {
    //        $("input[id$=TextBox_CustomInquiries_GuardianFirstName]").val(xmlHrmAssessmentRow[0].selectNodes("GuardianName")[0].text);

    //    }

    //    if (xmlHrmAssessmentRow[0].selectNodes("GuardianAddress").length > 0 && xmlHrmAssessmentRow[0].selectNodes("GuardianAddress")[0].text.trim() != '') {
    //        $("textarea[id$=TextArea_CustomHRMAssessments_GuardianAddress]").val(xmlHrmAssessmentRow[0].selectNodes("GuardianAddress")[0].text);
    //    }

    //    if (xmlHrmAssessmentRow[0].selectNodes("GuardianPhone").length > 0 && xmlHrmAssessmentRow[0].selectNodes("GuardianPhone")[0].text.trim() != '') {
    //        $("input[id$=TextBox_CustomHRMAssessments_GuardianPhone]").val(xmlHrmAssessmentRow[0].selectNodes("GuardianPhone")[0].text);
    //    }


    //    if (xmlHrmAssessmentRow[0].selectNodes("GuardianType").length > 0 && xmlHrmAssessmentRow[0].selectNodes("GuardianType")[0].text.trim() != '') {
    //        $("select:[id$=DropDownList_CustomHRMAssessments_GuardianType]").val(xmlHrmAssessmentRow[0].selectNodes("GuardianType")[0].text);
    //    }


}


// Checks Max length of address textarea
//UpdateScreen(buttonClicked, isExternalURL, isPopUp)
function CheckAddressMaxLength(buttonClicked, isExternalURL, isPopUp) {
    //    if ($("[id$=TextArea_CustomHRMAssessments_GuardianAddress]").val().length <= 100) {
    //parent.window.AutoSaveXMLDom = $.xmlDOM(AutoSaveXMLDom[0].xml);
    UpdateScreen(buttonClicked, isExternalURL, isPopUp);


    //    }
    //    else {
    //        ShowHideErrorMessage('Address can not be more than 100 characters', 'true');
    //        return;
    //    }
}

function AddEventHandlers() {
    try {
        $("[id$=CheckBox_CustomInquiries_GuardianSameAsCaller]").change(function() {
            //alert($(this).is(':checked'));
            if ($(this).is(':checked')) {
                //alert(parent.$("[id$=TextBox_CustomInquiries_InquirerFirstName]").val());
                var Fname = parent.$("[id$=TextBox_CustomInquiries_InquirerFirstName]");
                var LName = parent.$("[id$=TextBox_CustomInquiries_InquirerLastName]");
                var Phone = parent.$("[id$=TextBox_CustomInquiries_InquirerPhone]");
                ///var DOB = parent.$("[id$=TextBox_CustomInquiries_DateOfBirth]");
                var LinktoMember = parent.$("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]");
                $("[id$=TextBox_CustomInquiries_GuardianFirstName]").val($(Fname).val()).attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_GuardianFirstName]").change();
                $("[id$=TextBox_CustomInquiries_GuardianLastName]").val($(LName).val()).attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_GuardianLastName]").change();
                $("[id$=TextBox_CustomInquiries_GuardianPhoneNumber]").val($(Phone).val()).attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_GuardianPhoneNumber]").change();
                //$("[id$=TextBox_CustomInquiries_GuardianDOB]").val($(DOB).val()).attr('disabled', 'disabled');
                //$("[id$=TextBox_CustomInquiries_GuardianDOB]").change();
                //$("[id$=imgDateOfBirth]").attr('disabled', 'disabled');
                $("[id$=DropDownList_CustomInquiries_GuardianRelation] option").each(function() {
                    //alert($(this).val());
                    if ($(this).val() == $(LinktoMember).val()) {
                        $(this).attr('selected', 'selected');
                    }
                    else {
                        $(this).removeAttr('selected');
                        $(this).change();
                    }
                });

            }
            else {
                $("[id$=TextBox_CustomInquiries_GuardianFirstName]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_GuardianLastName]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_GuardianPhoneNumber]").removeAttr('disabled');
                //$("[id$=TextBox_CustomInquiries_GuardianDOB]").removeAttr('disabled');
                //$("[id$=imgDateOfBirth]").removeAttr('disabled');
            }
        });
        if ($("[id$=CheckBox_CustomInquiries_GuardianSameAsCaller]").is(':checked')) {
            $("[id$=TextBox_CustomInquiries_GuardianFirstName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_GuardianLastName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_GuardianPhoneNumber]").attr('disabled', 'disabled');
            //$("[id$=TextBox_CustomInquiries_GuardianDOB]").attr('disabled', 'disabled');
        }
        $("[id$=DropDownList_CustomInquiries_GuardianRelation]").die().live("change", function() {
            if ($(this).val() == "6781") {
                $("[id$=DropDownList_CustomInquiries_GuardianRelation] option").each(function() {
                    if ($(this).val() == "") {
                        $(this).attr('selected', 'selected');
                    }
                    else {
                        $(this).removeAttr('selected');
                    }
                });
            }
        });

        $('#CheckBox_CustomInquiries_GurdianDPOAStatus').change(function() {
            if ($(this).attr('checked')) {
                var GardianComment = $('#TextArea_CustomInquiries_GardianComment').val();
                if (!/This client has DPOA/i.test(GardianComment)) {
                    $('#TextArea_CustomInquiries_GardianComment').val(GardianComment + ' This client has DPOA').change();
                }

            }
        });
    }
    catch (err) {
        LogClientSideException(err, 'CustomHRMAssessments');
    }
}