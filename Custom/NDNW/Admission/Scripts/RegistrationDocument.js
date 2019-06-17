
var _DocumentVersionId = 0;
var _CoverageInfoId = 0;
var data = { emptydetails: [{ RegistrationCoveragePlanId: 0, DocumentVersionId: 0, CoveragePlanId: -1, InsuredId: '', GroupId: '', Comments: ''}] };
var emptydata = data.emptydetails;
var tabAferCareClicked = false;

function SetCurrentTab(sender, e) {
    try {
        TabIndex = sender.activeTabIndex;
    }
    catch (err) { }
}

function onTabSelectedClient(sender, args) {
    onTabSelected(sender, args, false);
}

function StoreTabstripClientObject(sender) {
    tabobject = sender;
}


function disableTabClick(index, name) {
    subtabindex = index;
}

var tabobject = null;
//var Enrollment_Tab;
function StoreTabstripClientObject(sender) {
    try {
        tabobject = sender;
        Enrollment_Tab = tabobject.findTabByText('Program Enrollment');
    }
    catch (err) {
        LogClientSideException(err, 'StoreTabstripClientObject');
    }
}

function CalculateIncome(dropdown) {
    if ($('#' + dropdown.id).val() != '' || $('#' + dropdown.id).val() == null) {
        if (dropdown.id == 'TextBox_CustomDocumentRegistrations_ClientAnnualIncome') {
            var value = $("[id$=TextBox_CustomDocumentRegistrations_ClientAnnualIncome]").val().substring(1, $("[id$=TextBox_CustomDocumentRegistrations_ClientAnnualIncome]").val().length)
            value = value.replace(/\,/g, '');
            var annualincome = parseFloat(value / 12);
            annualincome = parseFloat(annualincome).toFixed(3)
            $("[id$=TextBox_CustomDocumentRegistrations_ClientMonthlyIncome]").val(annualincome);
            CreateAutoSaveXml('CustomDocumentRegistrations', 'ClientMonthlyIncome', annualincome);
        }
        else {
            var value = $("[id$=TextBox_CustomDocumentRegistrations_ClientMonthlyIncome]").val().substring(1, $("[id$=TextBox_CustomDocumentRegistrations_ClientMonthlyIncome]").val().length)
            value = value.replace(/\,/g, '');
            var monthlyincome = parseFloat(value * 12);
            monthlyincome = parseFloat(monthlyincome).toFixed(3)
            $("[id$=TextBox_CustomDocumentRegistrations_ClientAnnualIncome]").val(monthlyincome);
            CreateAutoSaveXml('CustomDocumentRegistrations', 'ClientAnnualIncome', monthlyincome);
        }
    }
}

function CalculateFee() {
    var income = 0;
    var Type;
    if ($("[id$=TextBox_CustomDocumentRegistrations_ClientAnnualIncome]").val() != "") {
        income = $("[id$=TextBox_CustomDocumentRegistrations_ClientAnnualIncome]").val();
        Type = 'A';
    }
    else if ($("[id$=TextBox_CustomDocumentRegistrations_ClientMonthlyIncome]").val() != "") {
        income = $("[id$=TextBox_CustomDocumentRegistrations_ClientMonthlyIncome]").val();
        Type = 'M';
    }
    else {
        ShowHideErrorMessage('Please enter either Annual Income or Monthly Income', 'true');
        return false;
    }
    $.ajax({
        type: "POST",
        url: "../Custom/Admission/WebPages/RegistrationDocumentAjaxScript.aspx?functionName=CalculateIncome",
        data: "Income=" + income + '&Type=' + Type,
        async: false,
        success: function(result) {
            var Income = result.split('/');
            if (Type = 'A') {
                $("[id$=TextBox_CustomDocumentRegistrations_ClientMonthlyIncome]").val(Income[1]);
                CreateAutoSaveXml('CustomDocumentRegistrations', 'ClientMonthlyIncome', Income[1]);
            }
            else {
                $("[id$=TextBox_CustomDocumentRegistrations_ClientAnnualIncome]").val(Income[0]);
                CreateAutoSaveXml('CustomDocumentRegistrations', 'ClientAnnualIncome', Income[0]);
            }

        }
    });
}

function AddEventHandlers() {
    try {
        if (TabIndex == 0) {
            // $('#SectionGroup750>tbody>tr').eq(1).find('table').eq(0).css({ 'line-height': '1px' });
            //  $('#SectionGroup753>tbody>tr').eq(1).find('table').eq(0).css({ 'line-height': '1px' });
            //  $('#SectionGroup752>tbody>tr').eq(1).find('table').eq(0).css({ 'line-height': '1px' });
            //  $('#SectionGroup751>tbody>tr').eq(1).find('table').eq(0).css({ 'line-height': '1px' });
            $("#SectionGroup751").css("margin-top", "-10px");
            $("#SectionGroup752").css("margin-top", "-5px");
            $("#SectionGroup753").css("margin-top", "-5px");
            $("#SectionGroup754").css("margin-top", "-15px");
            if ($("[id$=TextBox_CustomDocumentRegistrations_DateOfBirth]").length > 0) {

                if ($("[id$=TextBox_CustomDocumentRegistrations_DateOfBirth]").val()) {
                    CalculateAge($("[id$=TextBox_CustomDocumentRegistrations_DateOfBirth]").val());
                }

            }

        }
        if (TabIndex == 4) {
            if ($("[id$=DropDownList_CustomDocumentRegistrations_ReferralType]").length > 0) {
                var DropDown_ReferralType = $("[id$=DropDownList_CustomDocumentRegistrations_ReferralType]");
                $("[id$=DropDownList_CustomDocumentRegistrations_ReferralType]").unbind('change');
                $("[id$=DropDownList_CustomDocumentRegistrations_ReferralType]").bind("change", function() {
                    BindReferralSubtype(DropDown_ReferralType.val());
                });

                var DropDown_ReferralSubType = $("[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]");
                $("[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]").unbind('change');
                $("[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]").bind("change", function() {
                    SaveReferralSubtype(DropDown_ReferralSubType.val());
                });
            }
        }

        if (TabIndex == 2) {
            var varPrimaryCarePhysician = $('select[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').val()
            if (varPrimaryCarePhysician != "" && varPrimaryCarePhysician != "-1") {
                $('span[id$=span_modiyProviderReferral]').show();
            }
            $('[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').unbind('change');
            $('[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').change(function() {
                var selectedValueProviderType = $('select[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').val();
                if ($(this).val() == "-1") {
                    AddNewProvider(selectedValueProviderType);
                    $(this).val('');
                    $('span[id$=span_modiyProviderReferral]').hide();
                }
                else if ($(this).val() > 0) {
                    //bindChange = "DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician";
                    //OpenPage(5765, 10500, 'action=ProviderInfo^ExternalReferralProviderId=' + $(this).val(), 2, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
                    $('span[id$=span_modiyProviderReferral]').show();

                    $.ajax({
                        type: "POST",
                        url: "../Custom/Admission/WebPages/RegistrationDocumentAjaxScript.aspx?functionName=UpdateProviderDetails",
                        data: 'ExternalReferralProviderId=' + $(this).val(),
                        asyn: false,
                        success: function(result) {
                            UpdateProviderDetails(result);

                        }
                    });


                } else {
                    $('span[id$=span_modiyProviderReferral]').hide();
                }
            });
            checkAdditionalInfo();
        }

    }
    catch (ex) {
    }
}

function UpdateProviderDetails(result) {
    var ExternalReferralProvider = JSON.parse(result);
    $('span[id$=Span_CustomDocumentRegistrations_Phone]').html(ExternalReferralProvider.PhoneNumber); //.PhoneLog);
    $('span[id$=Span_CustomDocumentRegistrations_PCPEmail]').html(ExternalReferralProvider.Email); //EmailLog);
    $('span[id$=Span_CustomDocumentRegistrations_OrganizationName]').html(ExternalReferralProvider.OrganizationName);

}

function AddNewProvider(obj) {
    var selectedValueProviderType = 8126;
    OpenPage(5761, 700, 'action=' + selectedValueProviderType, 2, $("input[id$=RelativePath]").val(), 'T', 'dialogHeight: 270px; dialogWidth: 600px; dialogCrossButton: hide;dialogTitle:Add New Provider', pageActionEnum.New);

    if ($(obj).val() == "-1") {
        OpenPage(5761, 700, 'action=' + selectedValueProviderType, 2, $("input[id$=RelativePath]").val(), 'T', 'dialogHeight: 270px; dialogWidth: 600px; dialogCrossButton: hide;dialogTitle:Add New Provider', pageActionEnum.New);
        $(obj).val('');
    }
    //else if ($(obj).val() > 0) {
    //action = "DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician";
    //currentScreenId = $('input[id$=hiddenFieldCurrentScreenId]').val();
    //OpenPage(5765, currentScreenId, 'action=ProviderInfo^ExternalReferralProviderId=' + $(obj).val(), 2, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    //}
}


function ModifyProvider(obj) {
    var SelectedProvider = 0;
    if ($(obj).attr('id') == "span_modiyProviderReferral") {
        SelectedProvider = $('select[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').val();
    }
    else {
        SelectedProvider = $('select[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').val();
    }
    if (SelectedProvider > 0) {
        OpenPage(5761, 700, 'ExternalReferralProviderId=' + SelectedProvider, 2, $("input[id$=RelativePath]").val(), 'T', 'dialogHeight: 270px; dialogWidth: 600px; dialogCrossButton: hide;dialogTitle:Add New Provider', '');
    }
}

var SubReferralType = "";
function BindReferralSubtype(GlobalCodeId) {
    try {
        $.ajax({
            type: "POST",
            url: "../Custom/Admission/WebPages/RegistrationDocumentAjaxScript.aspx?functionName=GetReferralSubtypeByGlobalCode",
            data: 'GlobalCodeId=' + GlobalCodeId + "&ClientEpisodeId=" + "&ReferralType=" + $("[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]").val(),
            asyn: false,
            success: function(result) {
                UpdateDropDown(result);
                if (SubReferralType) {
                    $('select[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]').val(SubReferralType);
                    CreateAutoSaveXml('CustomDocumentRegistrations', 'ReferralSubtype', SubReferralType);
                    SubReferralType = "";
                }
            }
        });
    }
    catch (err) {
        LogClientSideException(err, 'CustomRegistrations-BindReferralSubtype');
    }
}


function SaveReferralSubtype() {
    try {
        var ReferralSubType = $('select[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]').val();
        CreateAutoSaveXml('CustomDocumentRegistrations', 'ReferralSubtype', SubReferralType);
    }
    catch (err) {
        LogClientSideException(err, 'CustomRegistrations-BindReferralSubtype');
    }
}


//bind Referal subtype based on referal type
function UpdateDropDown(result) {
    $("[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $.xmlDOM(result.xml).find("ClientServicesView").each(function() {
                $("<option value=" + this.childNodes[1].text + ">" + this.childNodes[0].text + "</option>").appendTo("[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]");
            });
            if (!$('select[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]').val()) {
                CreateAutoSaveXml('CustomDocumentRegistrations', 'ReferralSubtype', '');
            }
            else {
                CreateAutoSaveXml('CustomDocumentRegistrations', 'ReferralSubtype', $('select[id$=DropDownList_CustomDocumentRegistrations_ReferralSubtype]').val());
            }
        }
    }
}

function ScanBtnClick(clientId) {
    if (document.all) {
        /* the following is only available after onLoad */
        w = document.body.clientWidth;
        h = document.body.clientHeight;
    }
    else if (document.layers) {
        w = window.innerWidth;
        h = window.innerHeight;
    } else if (ua == CHROME) {
        w = window.innerWidth;
        h = window.innerHeight;
    }
    var popW = 1000, popH = 600;

    var staffCode = $('[id$=hdnStaffcode]').val();
    var leftPos = (w - popW) / 2, topPos = (h - popH) / 2;
    var taskId = $('CustomDocumentRegistrations DocumentVersionId', AutoSaveXMLDom).text();
    if (taskId != "-1") {
        window.open(GetRelativePath() + 'Scanner/ScanView.aspx?clientId=' + clientId + '&request=new&staff=' + staffCode + "&dummy='" + $.rendom(8) + "'", 'scanner', 'status=1,scrollbars=1,width=' + popW + ',height=' + popH + ',top=' + topPos + ',left=' + leftPos);
    }
    else {
        ShowMsgBox("Please save the task before scanning.", "Translate(MESSAGE, Message)", MessageBoxButton.OK, MessageBoxIcon.Exclamation, '');
    }

}


$.extend({
    rendom: function(length, special) {
        var iteration = 0;
        var password = "";
        var randomNumber;
        if (special == undefined) {
            var special = false;
        }
        while (iteration < length) {
            randomNumber = (Math.floor((Math.random() * 100)) % 94) + 33;
            if (!special) {
                if ((randomNumber >= 33) && (randomNumber <= 47)) { continue; }
                if ((randomNumber >= 58) && (randomNumber <= 64)) { continue; }
                if ((randomNumber >= 91) && (randomNumber <= 96)) { continue; }
                if ((randomNumber >= 123) && (randomNumber <= 126)) { continue; }
            }
            iteration++;
            password += String.fromCharCode(randomNumber);
        }
        return password;
    }
});




function SetScreenSpecificValues(dom, action) {
    try {
        var selectedTabText;
        //historytabobject = tabobject._selectedIndex;
        //        var xmlContent = $('CustomDocumentRegistrations', dom);
        //        if (xmlContent.length > 0) {
        //            //code to Show/Hide Employments tab
        //            var XmlDOB = $('DateOfBirth', xmlContent);
        //            DOB = $.trim(XmlDOB.text());

        //            var now = new Date();
        //            var past = new Date(DOB);
        //            var nowYear = now.getFullYear();
        //            var pastYear = past.getFullYear();
        //            var age = nowYear - pastYear;
        //            $('[id$=span_CustomDocumentRegistrations_Age]').val(age + ' Years');
        //        }
        if (TabIndex == 4) {
            DisableTextArea();
            BindTextAreaInformation();
        }

        //         if (historytabobject >= 0) {

        //             selectedTabText = tabobject.get_selectedTab().get_text();



        if (TabIndex == 6 && $('[id$=divmain_RegistrationFormcomposition]').length > 0) {
            if (typeof renderForComposition == 'function') {
                renderForComposition(null);
            }
        }





        /////  insurance///

        if (TabIndex == 3) {
            if ($.xmlDOM(objectPageResponse.PageDataSetXml).find("CustomRegistrationCoveragePlans").length > 0) {
                emptydata[0].DocumentVersionId = dom.find("CustomRegistrationCoveragePlans:first DocumentVersionId").text();
                _DocumentVersionId = dom.find("CustomRegistrationCoveragePlans:first DocumentVersionId").text();
                dom.find("CustomRegistrationCoveragePlans").each(function() {
                    $(this).children().each(function() {
                        if (this.tagName == "RegistrationCoveragePlanId") {
                            if (parseInt($(this).text()) < 0 && _CoverageInfoId <= 0 && _CoverageInfoId > parseInt($(this).text())) {
                                _CoverageInfoId = parseInt($(this).text());
                            }
                        }
                    });
                });
                if (_DocumentVersionId = 0)
                    _DocumentVersionId = dom.find("CustomRegistrationCoveragePlans:first DocumentVersionId").text();
                if (_DocumentVersionId = 0)
                    _DocumentVersionId = -1;
            }
            else {
                _DocumentVersionId = dom.find("CustomRegistrationCoveragePlans:first DocumentVersionId").text();
            }

            if (tabAferCareClicked == false) {
                tabAferCareClicked = true;
                var appointmentsobjectivestring = $('[id$=HiddenFieldAppointments]').val();
                if (checkjsonstring(appointmentsobjectivestring) == true) {
                    var appointments = $.parseJSON(appointmentsobjectivestring);
                    if (appointments == null) {
                        appointments = '';
                    }
                    if (appointments.length > 0) {
                        var appointmentsobjectivestring1 = $('[id$=HiddenFieldsPlan]').val();
                        var htmlText = "";
                        $.templates('varappointmentHTML',
                      {
                          markup: "#appointmentHTML",
                          allowCode: true
                      });
                        for (var x = 0; x < appointments.length; x++) {
                            var test = $.parseJSON(appointmentsobjectivestring1);
                            for (var p = 0; p < $.parseJSON(appointmentsobjectivestring1).length; p++) {
                                if (test[p].CoveragePlanId == appointments[x].CoveragePlanId) {
                                    test[p].IsSelected = 'Y';
                                    break;
                                }
                            }
                            appointments[x].plansdropdownarray = test;
                        }
                        htmlText = $.render.varappointmentHTML(appointments);

                        //$("#appointmentContainer").append($('#appointmentHTML').render(emptydata));
                        $("#appointmentContainer").append(htmlText);

                        //$("#appointmentContainer").append($('#appointmentHTML').render(appointments));
                    }
                    else {
                        //AddNewCoverageInformation();
                    }
                }
                else {
                    //AddNewCoverageInformation();
                }
            }
        }
        if (TabIndex == 0) {
            DisplayOtherTextBox();
            EnableDisableSSN();
        }
        if (TabIndex == 2) {
            checkAdditionalInfo();
        }

    }
    catch (err) {
        LogClientSideException(err, 'SetScreenSpecificValues');
    }
}


////////////////////
renderForComposition = (function(jsonstring) {

    var jsonvalue = jsonstring == null ? $('[id$=divmain_RegistrationFormcomposition]').next()[0].innerText : jsonstring;
    if (jsonvalue != "") {
        if (typeof checkjsonstring == 'function') {
            if (checkjsonstring(jsonvalue) == true) {
                var objformcomposition = $.parseJSON(jsonvalue);
                if (objformcomposition.length > 0) {
                    $("#divmain_RegistrationFormcomposition").append($('#formCompositionTmpl').render(objformcomposition));

                    $.each(objformcomposition, function(i, item) {
                        $("[id$=DropdownList1_CustomRegistrationFormsAndAgreements_Form]:lt(1) option").clone().appendTo("[id$=DropdownList1_CustomRegistrationFormsAndAgreements_" + item.CustomRegistrationFormAndAgreementId + "_Form]");

                        $("[id$=DropdownList1_CustomRegistrationFormsAndAgreements_" + item.CustomRegistrationFormAndAgreementId + "_Form]").val(item.Form);


                        var FormSelectedText = $("[id$=DropdownList1_CustomRegistrationFormsAndAgreements_" + item.CustomRegistrationFormAndAgreementId + "_Form]").find('option:selected').text();
                        if (FormSelectedText == null || FormSelectedText == undefined)
                            FormSelectedText = '';

                        //                        if (FormSelectedText == 'Other' || FormSelectedText == 'Other(non-related)') {
                        //                            $("#TableRow_" + item.MHASocialRelationshipId + "_FamilyComposition").show();
                        //                        }
                        //                        else {
                        //                            $("#TableRow_" + item.MHASocialRelationshipId + "_FamilyComposition").hide();
                        //                        }
                    });
                }
            }
        }
    }
});


addForm = (function() {

    var _CustomRegistrationFormAndAgreementId = 0;
    AutoSaveXMLDom.find("CustomRegistrationFormsAndAgreements").each(function() {
        $(this).children().each(function() {
            if (this.tagName == "CustomRegistrationFormAndAgreementId") {
                if (parseInt($(this).text()) < 0 && _CustomRegistrationFormAndAgreementId <= 0 && _CustomRegistrationFormAndAgreementId > parseInt($(this).text())) {
                    _CustomRegistrationFormAndAgreementId = parseInt($(this).text());
                }
            }
        });
    });

    if (_CustomRegistrationFormAndAgreementId == 0)
        _CustomRegistrationFormAndAgreementId = -1
    else
        _CustomRegistrationFormAndAgreementId = _CustomRegistrationFormAndAgreementId + (-1);

    var _RegistrationFormid;
    var _createdby;
    var _createddate;
    var _modifiedby;
    var _modifieddate;
    var _documentversionid;





    var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomRegistrationFormsAndAgreements')); //Add Table
    _RegistrationFormid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CustomRegistrationFormAndAgreementId')); //Add Column
    _RegistrationFormid.text = _CustomRegistrationFormAndAgreementId;

    _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
    _createdby.text = objectPageResponse.LoggedInUserCode;

    _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
    _createddate.text = ISODateString(new Date());

    _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
    _modifiedby.text = objectPageResponse.LoggedInUserCode;

    _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
    _modifieddate.text = ISODateString(new Date());

    _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
    _documentversionid.text = AutoSaveXMLDom.find("CustomDocumentRegistrations:first DocumentVersionId").text();
    AddToUnsavedTables("CustomRegistrationFormsAndAgreements");
    var RegistraionForm = "[{ \"CustomRegistrationFormAndAgreementId\": " + _CustomRegistrationFormAndAgreementId + ", \"Form\": -1, \"EnglishForm\": \"\", \"SpanishForm\": \"\", \"NoForm\": \"\", \"DeclinedForm\": \"\", \"NotApplicableForm\": \"\" }]";
    renderForComposition(RegistraionForm);
    CreateUnsavedInstanceOnDatasetChange();
});

deleteForm = (function(RegistrationFormid) {
    var _CustomRegistrationFormAndAgreementId = 0;
    if (RegistrationFormid != null || RegistrationFormid != undefined)
        _CustomRegistrationFormAndAgreementId = RegistrationFormid;
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    $("#divmain_RegistrationFormcomposition").find("#Table_" + _CustomRegistrationFormAndAgreementId + "_FormComposition").remove();
    CreateUnsavedInstanceOnDatasetChange();
});

updateForm = (function(obj, RegistrationFormid, mode) {

    var _CustomRegistrationFormAndAgreementId = 0;
    if (RegistrationFormid != null || RegistrationFormid != undefined)
        _CustomRegistrationFormAndAgreementId = RegistrationFormid;

    var updatevalue = $(obj).val();
    if (updatevalue == null || updatevalue == undefined)
        updatevalue = '';

    if (mode == 'Form') {
        if (updatevalue == '')
            updatevalue = -1;
        SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "Form", updatevalue, AutoSaveXMLDom[0]);


        var FormSelectedText = $(obj).find('option:selected').text();
        if (FormSelectedText == null || FormSelectedText == undefined)
            FormSelectedText = '';

        //        if (FormSelectedText == 'Other' || FormSelectedText == 'Other(non-related)') {
        ////            $("#TableRow_" + _MHASocialRelationshipId + "_FamilyComposition").show();
        //        }
        //        else {
        ////            $("#TableRow_" + _MHASocialRelationshipId + "_FamilyComposition").hide();
        //            $("#TextBox_CustomMHASocialRelationships_" + _MHASocialRelationshipId + "_RelationshipOtherText").val("");
        //            SetColumnValueInXMLNodeByKeyValue("CustomMHASocialRelationships", "MHASocialRelationshipId", _MHASocialRelationshipId, "RelationshipOtherText", "", AutoSaveXMLDom[0]);
        //        }
    }
    //    else if (mode == 'FirstName') {
    //        SetColumnValueInXMLNodeByKeyValue("CustomMHASocialRelationships", "MHASocialRelationshipId", _MHASocialRelationshipId, "FirstName", updatevalue, AutoSaveXMLDom[0]);
    //    }
    //    else if (mode == 'LastName') {
    //        SetColumnValueInXMLNodeByKeyValue("CustomMHASocialRelationships", "MHASocialRelationshipId", _MHASocialRelationshipId, "LastName", updatevalue, AutoSaveXMLDom[0]);
    //    }
    else if (mode == 'EnglishForm_Y') {
        if ($(obj).attr('checked')) {
            SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "EnglishForm", updatevalue, AutoSaveXMLDom[0]);
            if (updatevalue == 'Y') {
                updatevalue = '';
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "SpanishForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NoForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "DeclinedForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NotApplicableForm", updatevalue, AutoSaveXMLDom[0]);
            }
        }
    }


    else if (mode == 'SpanishForm_Y') {
        if ($(obj).attr('checked')) {
            SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "SpanishForm", updatevalue, AutoSaveXMLDom[0]);
            if (updatevalue == 'Y') {
                updatevalue = '';
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "EnglishForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NoForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "DeclinedForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NotApplicableForm", updatevalue, AutoSaveXMLDom[0]);
            }
        }
    }


    else if (mode == 'NoForm_Y') {
        if ($(obj).attr('checked')) {
            SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NoForm", updatevalue, AutoSaveXMLDom[0]);
            if (updatevalue == 'Y') {
                updatevalue = '';
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "SpanishForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "EnglishForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "DeclinedForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NotApplicableForm", updatevalue, AutoSaveXMLDom[0]);
            }
        }
    }


    else if (mode == 'DeclinedForm_Y') {
        if ($(obj).attr('checked')) {
            SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "DeclinedForm", updatevalue, AutoSaveXMLDom[0]);
            if (updatevalue == 'Y') {
                updatevalue = '';
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "SpanishForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NoForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "EnglishForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NotApplicableForm", updatevalue, AutoSaveXMLDom[0]);
            }
        }
    }

    else if (mode == 'NotApplicableForm_Y') {
        if ($(obj).attr('checked')) {
            SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NotApplicableForm", updatevalue, AutoSaveXMLDom[0]);
            if (updatevalue == 'Y') {
                updatevalue = '';
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "SpanishForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "NoForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "DeclinedForm", updatevalue, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "EnglishForm", updatevalue, AutoSaveXMLDom[0]);
            }
        }
    }




    //    else if (mode == 'Status') {
    //        if (updatevalue == '')
    //            updatevalue = -1;
    //        SetColumnValueInXMLNodeByKeyValue("CustomMHASocialRelationships", "MHASocialRelationshipId", _MHASocialRelationshipId, "Status", updatevalue, AutoSaveXMLDom[0]);
    //    }

    //    else if (mode == 'RelationshipOtherText') {
    //        SetColumnValueInXMLNodeByKeyValue("CustomMHASocialRelationships", "MHASocialRelationshipId", _MHASocialRelationshipId, "RelationshipOtherText", updatevalue, AutoSaveXMLDom[0]);
    //    }
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationFormsAndAgreements", "CustomRegistrationFormAndAgreementId", _CustomRegistrationFormAndAgreementId, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();
});


////////////////


function DisableTextArea() {

    if ($('#TextArea_CustomDocumentRegistrations_Information').length > 0) {
        $('#TextArea_CustomDocumentRegistrations_Information').attr('readonly', true);
    }
    var Disposition = $('select[id$=DropDownList_CustomDocumentRegistrations_Disposition]');
    if (Disposition.length > 0) {
        Disposition.attr('disabled', true);
    }

}
//Function used for ajax call to get EpisodeInformation
function BindTextAreaInformation() {


    $.ajax({
        type: "POST",
        url: _ApplicationBasePath + "Custom/Admission/WebPages/RegistrationDocumentAjaxScript.aspx?functionName=EpisodeInformation",
        data: 'Information=Information',
        success: SetInformation
    });
}
//Function used for bind Episode Information value to controls.
function SetInformation(result) {


    try {
        if (result) {
            var successResult = String(result);
            if (successResult != "") {
                if ($('#TextArea_CustomDocumentRegistrations_Information').length > 0) {
                    $('#TextArea_CustomDocumentRegistrations_Information').val(successResult);
                }
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'CustomDocumentRegistrations');
    }

}

function AddNewCoverageInformation() {
    var Planlength = $.xmlDOM(AutoSaveXMLDom[0].xml).find("RegistrationCoveragePlanId").length;
    var PayerType;
    if (Planlength > 0) {
        var RegistrationCoveragePlanId = $.xmlDOM(AutoSaveXMLDom[0].xml).find("RegistrationCoveragePlanId")[Planlength - 1].text;
        var planid = GetColumnValueInXMLNodeByKeyValue('CustomRegistrationCoveragePlans', 'RegistrationCoveragePlanId', RegistrationCoveragePlanId, 'CoveragePlanId', AutoSaveXMLDom);
        //$.xmlDOM(AutoSaveXMLDom[0].xml).find("CoveragePlanId")[Planlength - 1].text;
        if ($('[id$=StreamlineDropDowns1]').length > 0) {
            PayerType = $('[id$=StreamlineDropDowns1]').val();
        }
        var insuredid = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InsuredId")[Planlength - 1].text;
        var GroupId = $.xmlDOM(AutoSaveXMLDom[0].xml).find("GroupId")[Planlength - 1].text;
        var Recorddeleted = GetColumnValueInXMLNodeByKeyValue('CustomRegistrationCoveragePlans', 'RegistrationCoveragePlanId', RegistrationCoveragePlanId, 'RecordDeleted', AutoSaveXMLDom);
        if ((planid == "" && $.trim(insuredid) == "" && $.trim(GroupId) == "") && Recorddeleted != 'Y') {
            ShowHideErrorMessage('Please complete Coverage Details', 'true');
            return false;
        }
        else if ((planid != "" && planid != null) && (($.trim(insuredid) == "" || $.trim(insuredid) == null) && ($.trim(GroupId) != "" || $.trim(GroupId) != null))) {
            ShowHideErrorMessage('Insurance-Coverage information- Insurance ID is required', 'true');
            return false;
        }
        //else if ((planid != "" && planid != null) && (($.trim(insuredid) != "" || $.trim(insuredid) != null) && ($.trim(GroupId) == "" || $.trim(GroupId) == null))) {
        //    ShowHideErrorMessage('Insurance-Coverage information-Group ID is required', 'true');
        //    return false;
        //}
    }


    var xmlDocumentVersionId = AutoSaveXMLDom.find("CustomDocumentRegistrations:first DocumentVersionId").text();
    if (_CoverageInfoId == 0) {
        _CoverageInfoId = -1
        emptydata[0].RegistrationCoveragePlanId = -1;
    }
    else {
        _CoverageInfoId = _CoverageInfoId + (-1);
        emptydata[0].RegistrationCoveragePlanId = _CoverageInfoId;
    }
    emptydata[0].DocumentVersionId = xmlDocumentVersionId;

    var _RegistrationCoveragePlanId;
    var _DocumentVersionId;
    var _plan;
    var _inquirerid;
    var _groupid;
    var _comments;
    var _createdby;
    var _createddate;
    var _modifiedby;
    var _modifieddate;

    var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomRegistrationCoveragePlans')); //Add Table
    _RegistrationCoveragePlanId = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('RegistrationCoveragePlanId')); //Add Column
    _RegistrationCoveragePlanId.text = _CoverageInfoId;
    _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
    _createdby.text = objectPageResponse.LoggedInUserCode;
    _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
    _createddate.text = ISODateString(new Date());
    _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
    _modifiedby.text = objectPageResponse.LoggedInUserCode;
    _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
    _modifieddate.text = ISODateString(new Date());
    _DocumentVersionId = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
    _DocumentVersionId.text = xmlDocumentVersionId;
    //_plan = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CoveragePlanId')); //Add Column
    //_plan.text = -1;
    _inquirerid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('InsuredId')); //Add Column
    _inquirerid.text = '';
    _groupid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('GroupId')); //Add Column
    _groupid.text = '';
    //_appointmenttype = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('AppointmentType')); //Add Column
    //_appointmenttype.text = '';
    _comments = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('Comment')); //Add Column
    _comments.text = '';
    AddToUnsavedTables("CustomRegistrationCoveragePlans");
    $.templates('varappointmentHTML',
                  {
                      markup: "#appointmentHTML",
                      allowCode: true
                  });
    var appointmentsobjectivestring = $('[id$=HiddenFieldsPlan]').val();
    emptydata[0].plansdropdownarray = $.parseJSON(appointmentsobjectivestring);

    var htmlText = $.render.varappointmentHTML(emptydata);

    //$("#appointmentContainer").append($('#appointmentHTML').render(emptydata));
    $("#appointmentContainer").append(htmlText);
    CreateUnsavedInstanceOnDatasetChange();
    return true;

}

function removeCoverageInfo(obj, RegistrationCoveragePlanId) {
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationCoveragePlans", "RegistrationCoveragePlanId", RegistrationCoveragePlanId, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationCoveragePlans", "RegistrationCoveragePlanId", RegistrationCoveragePlanId, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationCoveragePlans", "RegistrationCoveragePlanId", RegistrationCoveragePlanId, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    $(obj).parent().parent().remove();
    CreateUnsavedInstanceOnDatasetChange();
}




/////   Insurance   ////////


function CustomRegistrationCoveragePlans(obj, mode, RegistrationCoveragePlanId) {
    //if (AutoSaveXMLDom.find("CustomRegistrationCoveragePlans").find('RegistrationCoveragePlanId[text=' + RegistrationCoveragePlanId + ']').length == 0) {
    //    addinitialnewcoverage(RegistrationCoveragePlanId);
    //}
    if (mode == 'CoveragePlanId') {
        SetColumnValueInXMLNodeByKeyValue("CustomRegistrationCoveragePlans", "RegistrationCoveragePlanId", RegistrationCoveragePlanId, "CoveragePlanId", $(obj).val(), AutoSaveXMLDom[0]);
    }
    else if (mode == 'InsuredId') {
        SetColumnValueInXMLNodeByKeyValue("CustomRegistrationCoveragePlans", "RegistrationCoveragePlanId", RegistrationCoveragePlanId, "InsuredId", $(obj).val(), AutoSaveXMLDom[0]);
    }
    else if (mode == 'GroupId') {
        SetColumnValueInXMLNodeByKeyValue("CustomRegistrationCoveragePlans", "RegistrationCoveragePlanId", RegistrationCoveragePlanId, "GroupId", $(obj).val(), AutoSaveXMLDom[0]);
    }
    else if (mode == 'Comment') {
        SetColumnValueInXMLNodeByKeyValue("CustomRegistrationCoveragePlans", "RegistrationCoveragePlanId", RegistrationCoveragePlanId, "Comment", $(obj).val(), AutoSaveXMLDom[0]);
    }
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationCoveragePlans", "RegistrationCoveragePlanId", RegistrationCoveragePlanId, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRegistrationCoveragePlans", "RegistrationCoveragePlanId", RegistrationCoveragePlanId, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();
}

function addinitialnewcoverage(_CoverageInfoId) {
    var xmlDocumentVersionId = AutoSaveXMLDom.find("CustomRegistrationCoveragePlans:first DocumentVersionId").text();

    var _RegistrationCoveragePlanId;
    var _DocumentVersionId;
    var _plan;
    var _inquirerid;
    var _groupid;
    var _comments;
    var _createdby;
    var _createddate;
    var _modifiedby;
    var _modifieddate;

    var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomRegistrationCoveragePlans')); //Add Table
    _customstandarddischargesummaryappointmentid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('RegistrationCoveragePlanId')); //Add Column
    _RegistrationCoveragePlanId.text = _CoverageInfoId;
    _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
    _createdby.text = objectPageResponse.LoggedInUserCode;
    _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
    _createddate.text = ISODateString(new Date());
    _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
    _modifiedby.text = objectPageResponse.LoggedInUserCode;
    _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
    _modifieddate.text = ISODateString(new Date());
    _DocumentVersionId = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
    _DocumentVersionId.text = xmlDocumentVersionId;
    //_plan = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CoveragePlanId')); //Add Column
    //_plan.text = '';
    _inquirerid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('InsuredId')); //Add Column
    _inquirerid.text = '';
    _groupid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('GroupId')); //Add Column
    _groupid.text = '';
    //_appointmenttype = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('AppointmentType')); //Add Column
    //_appointmenttype.text = '';
    _comments = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('Comment')); //Add Column
    _comments.text = '';
    AddToUnsavedTables("CustomRegistrationCoveragePlans");
}

function EnableDisableSSN() {
    if ($('input[name=CheckBox_CustomDocumentRegistrations_SSNUnknown]:checked').length > 0) {
        $('[id$=TextBox_CustomDocumentRegistrations_SSN]').attr("disabled", "disabled");
        if ($('[id$=TextBox_CustomDocumentRegistrations_SSN]').val()) {
            $('[id$=TextBox_CustomDocumentRegistrations_SSN]').val('');
            CreateAutoSaveXml('CustomDocumentRegistrations', 'SSN', '');
        }

    }
    else {
        $('[id$=TextBox_CustomDocumentRegistrations_SSN]').removeAttr("disabled");
    }
}

function DisplayOtherTextBox() {
    if ($("[id*='DropDownList_CustomDocumentRegistrations_PrimaryLanguage'] :selected").text() == 'Other') {
        $('[id$=TextBox_CustomDocumentRegistrations_OtherPrimaryLanguage]').css('visibility', 'visible');
    }
    else {
        $('[id$=TextBox_CustomDocumentRegistrations_OtherPrimaryLanguage]').css('visibility', 'hidden');
    }
}



$("#RadioButton_CustomDocumentRegistrations_RegisteredVoter_N").click(function() {
    $('#TextBox_CustomDocumentRegistrations_VotingInformation').attr("disabled", false);
});

$("#RadioButton_CustomDocumentRegistrations_RegisteredVoter_Y").click(function() {
    CreateAutoSaveXml('CustomDocumentRegistrations', 'VotingInformation', "");
    $('[id$=TextBox_CustomDocumentRegistrations_VotingInformation]').val("");
    $('#TextBox_CustomDocumentRegistrations_VotingInformation').attr("disabled", true);
});

function checkAdditionalInfo() {
    if ($("input[name='RadioButton_CustomDocumentRegistrations_RegisteredVoter']:checked").length == 0) {
        $('#TextBox_CustomDocumentRegistrations_VotingInformation').attr("disabled", true);
    }
    if ($("input[name='RadioButton_CustomDocumentRegistrations_RegisteredVoter']:checked").val()) {
        if ($("input[name='RadioButton_CustomDocumentRegistrations_RegisteredVoter']:checked").val() == 'N') {
            $('#TextBox_CustomDocumentRegistrations_VotingInformation').attr("disabled", false);
        }
        else if ($("input[name='RadioButton_CustomDocumentRegistrations_RegisteredVoter']:checked").val() == 'Y') {
            $('#TextBox_CustomDocumentRegistrations_VotingInformation').attr("disabled", true);
            if ($('[id$=TextBox_CustomDocumentRegistrations_VotingInformation]').val()) {
                CreateAutoSaveXml('CustomDocumentRegistrations', 'VotingInformation', "");
                $('[id$=TextBox_CustomDocumentRegistrations_VotingInformation]').val("");
            }
        }
    }
}
function ValidateCustomPageEventHandler() {
    return ValidateCoverageInformation();
}
function ValidateCoverageInformation() {
    var Planlength = $.xmlDOM(AutoSaveXMLDom[0].xml).find("RegistrationCoveragePlanId").length;
    var PayerType;
    if (Planlength > 0) {
        var RegistrationCoveragePlanId = $.xmlDOM(AutoSaveXMLDom[0].xml).find("RegistrationCoveragePlanId")[Planlength - 1].text;
        var planid = GetColumnValueInXMLNodeByKeyValue('CustomRegistrationCoveragePlans', 'RegistrationCoveragePlanId', RegistrationCoveragePlanId, 'CoveragePlanId', AutoSaveXMLDom);
        //$.xmlDOM(AutoSaveXMLDom[0].xml).find("CoveragePlanId")[Planlength - 1].text;
        if ($('[id$=StreamlineDropDowns1]').length > 0) {
            PayerType = $('[id$=StreamlineDropDowns1]').val();
        }
        var insuredid = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InsuredId")[Planlength - 1].text;
        var GroupId = $.xmlDOM(AutoSaveXMLDom[0].xml).find("GroupId")[Planlength - 1].text;
        var Recorddeleted = GetColumnValueInXMLNodeByKeyValue('CustomRegistrationCoveragePlans', 'RegistrationCoveragePlanId', RegistrationCoveragePlanId, 'RecordDeleted', AutoSaveXMLDom);
        if ((planid == "" && $.trim(insuredid) == "" && $.trim(GroupId) == "") && Recorddeleted != 'Y') {
            ShowHideErrorMessage('Please complete Coverage Details', 'true');
            return false;
        }
        else if ((planid != "" && planid != null) && (($.trim(insuredid) == "" || $.trim(insuredid) == null) && ($.trim(GroupId) != "" || $.trim(GroupId) != null))) {
            ShowHideErrorMessage('Insurance-Coverage information- Insurance ID is required', 'true');
            return false;
        }
        //else if ((planid != "" && planid != null) && (($.trim(insuredid) != "" || $.trim(insuredid) != null) && ($.trim(GroupId) == "" || $.trim(GroupId) == null))) {
        //    ShowHideErrorMessage('Insurance-Coverage information-Group ID is required', 'true');
        //    return false;
        //}
    }
}

function CalculateAge(dob) {
    //debugger;
    var date1 = new Date();
    var date2 = new Date(dob);
    var pattern = /^\d{2}\/\d{2}\/\d{4}$/;
    if (pattern.test(dob)) {
        var y1 = date1.getFullYear();
        var y2 = date2.getFullYear();
        var age = y1 - y2;
        var months = date1.getMonth() - date2.getMonth();
        var days = date1.getDate() - date2.getDate();
        if (age == 0 && days > 0) {
            $("[id$=span_CustomDocumentRegistrations_Age]").html('(Age: ' + days + ' Days)');
        }
        else {
            $("[id$=span_CustomDocumentRegistrations_Age]").html("");
            if (months < 0 || (months == 0 && days < 0)) {
                age = parseInt(age) - 1;
                $("[id$=span_CustomDocumentRegistrations_Age]").html('(Age: ' + age + ' Years)');
            }
            else {
                $("[id$=span_CustomDocumentRegistrations_Age]").html('(Age: ' + age + ' Years)');
            }
        }
    }
    else {
        $("[id$=span_CustomDocumentRegistrations_Age]").html('');
    }
}

////

