var countDischarge = 0;


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
    //debugger;
    tabobject = sender;
}


function disableTabClick(index, name) {
    subtabindex = index;
}


SetScreenSpecificValues = (function(dom, action) {

    try {
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {
            historytabobject = tabobject._selectedIndex;
            if (historytabobject >= 0) {
                selectedTabText = tabobject.get_selectedTab().get_text();
                if (historytabobject == 0 && selectedTabText == 'General') {

                    //debugger;
                    GetClientProgramsList(action);
                }

                if (historytabobject == 4 && selectedTabText == 'Diagnosis') {
                    if ($('#divPreviousDiagnosis').length > 0) {
                        BindPreviousDiagnosis();
                    }
                }
                if (historytabobject == 3 && selectedTabText == 'Medications') {
                    GetCurrentMedications();
                }
                if (historytabobject == 1 && selectedTabText == 'Progress Review') {
                    BindGoalsObjectives();
                }

            }
        }
        //debugger;
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {
            historytabobject = tabobject._selectedIndex;
            if (historytabobject == 0 && selectedTabText == 'General') {

                Showhidetabs('');
            }

        }
    }
    catch (ex) {

    }
});


function Showhidetabs(mode) {
    try {
        //debugger;
        var IsDischarge = false;
        AutoSaveXMLDom.find("CustomDischargePrograms RecordDeleted").each(function() {
            if (this.text) {
                if (this.text == 'N')
                    IsDischarge = true;
            }
        });

      
        if (mode == 'D') {
           //debugger;
            var ProgressReview_tab = tabobject.findTabByText('Progress Review');
            if (ProgressReview_tab != null && TabIndex != 1) {
                ShowHideTab(ProgressReview_tab, true);
            }
//            var Demographics_tab = tabobject.findTabByText('Demographics');
//            if (Demographics_tab != null && TabIndex != 2) {
//                ShowHideTab(Demographics_tab, true);
//            }

            var Medications_tab = tabobject.findTabByText('Medications');
            if (Medications_tab != null && TabIndex != 2) {
                ShowHideTab(Medications_tab, true);
            }
            var ReferralsDisposition_tab = tabobject.findTabByText('Referrals/Disposition Plan');
            if (ReferralsDisposition_tab != null && TabIndex != 3) {
                ShowHideTab(ReferralsDisposition_tab, true);
            }
        }
//        else {
//            //debugger;
//            var ProgressReview_tab = tabobject.findTabByText('Progress Review');
//            if (ProgressReview_tab != null && TabIndex != 1) {
//                ShowHideTab(ProgressReview_tab, false);
//            }
////            var Demographics_tab = tabobject.findTabByText('Demographics');
////            if (Demographics_tab != null && TabIndex != 2) {
////                ShowHideTab(Demographics_tab, false);
////            }

//            var Medications_tab = tabobject.findTabByText('Medications');
//            if (Medications_tab != null && TabIndex != 2) {
//                ShowHideTab(Medications_tab, false);
//            }
//            var ReferralsDisposition_tab = tabobject.findTabByText('Referrals/Disposition Plan');
//            if (ReferralsDisposition_tab != null && TabIndex != 3) {
//                ShowHideTab(ReferralsDisposition_tab, false);
//            }
//        }
//

        if (countDischarge <= 0 && mode != 'D') {
            //debugger;
            var ProgressReview_tab = tabobject.findTabByText('Progress Review');
            if (ProgressReview_tab != null && TabIndex != 1) {
                ShowHideTab(ProgressReview_tab, false);
            }
//            var Demographics_tab = tabobject.findTabByText('Demographics');
//            if (Demographics_tab != null && TabIndex != 2) {
//                ShowHideTab(Demographics_tab, false);
//            }

            var Medications_tab = tabobject.findTabByText('Medications');
            if (Medications_tab != null && TabIndex != 2) {
                ShowHideTab(Medications_tab, false);
            }
            var ReferralsDisposition_tab = tabobject.findTabByText('Referrals/Disposition Plan');
            if (ReferralsDisposition_tab != null && TabIndex != 3) {
                ShowHideTab(ReferralsDisposition_tab, false);
            }
        }
        
       

           
    }
    catch (Ex) {
    }
}


function BindPreviousDiagnosis() {//debugger;
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/Discharge/WebPages/Discharge.aspx?functionName=GetPreviousDiagnosis",
            data: '',
            success: function(result) { CreateDiagnosisTable(result); }
        });
    }
    catch (err) { }
}

function BindGoalsObjectives() {//debugger;
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/Discharge/WebPages/Discharge.aspx?functionName=GetGoalsObjectives",
            data: '',
            success: function(result) { CreateGoalsObjectives(result); }
        });
    }
    catch (err) { }
}


function CreateGoalsObjectives(result) {
    //debugger;
    try {
        if ($("[id$=DivGoals]").length > 0) {
            var divGoals = $("[id$=DivGoals]");
            if (divGoals.length > 0) {
                if (result.length > 0 && result != '<NewDataSet />') {
                    if (divGoals) {
                        divGoals.html('');
                    }
                    $("[id$=DivGoals]")[0].innerHTML = result
                    $("[id$=DivGoals]")[0].innerHTML = $("[id$=DivGoals]")[0].innerHTML.replace(/\n/g, '<br />');
                }
                else {
                    $("[id$=DivGoals]")[0].innerHTML = 'No Care Plan';
                }
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'CreateGoalsObjectives');
    }
}

















function CreateDiagnosisTable(result) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' colspan='5' style='padding-top:5px;'>Diagnosis List</th>";
    tableHeader += "</tr>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' width='10%'>Order</th>";
    tableHeader += "<th align='left' width='20%'>DSM V/ICD 10</th>";
    tableHeader += "<th align='left' width='20%'>DSM IV/ICD 9</th>";
    tableHeader += "<th align='left' width='20%'>Description</th>";
    tableHeader += "<th align='left' width='15%'>Type</th>";
    tableHeader += "<th align='left' width='15%'>Severity</th>";
    tableHeader += "</tr></thead>";
    var result1 = $.xmlDOM(result);
    $(result1).find('DocumentDiagnosisCodes').each(function() {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisOrder').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD10Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD9Code').text() + "</td>";
        var dsmDesciption = $(this).find('DSMDescription').text();
        if (dsmDesciption.length > 30)
            dsmDesciption = "<span title='" + dsmDesciption + "'>" + dsmDesciption.substring(0, 30) + "..." + "</span>";
        else
            dsmDesciption = "<span>" + dsmDesciption + "</span>";

        tableBody += "<td align='left'>" + dsmDesciption + "</td>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisType').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('Severity').text() + "</td>";
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
    $(result2).find('DocumentDiagnosisFactors').each(function() {
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
    $(result3).find('DiagnosesIV').each(function() {
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
    $(result4).find('DocumentDiagnosis').each(function() {
        tableBodyAxisV += "<tr>";
        tableBodyAxisV += "<td align='left' colspan='2'>GAF Score: " + $(this).find('GAFScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='1'>WHODAS Score: " + $(this).find('WHODASScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='2'>CAFAS Score: " + $(this).find('CAFASScore').text() + "</td>";
        tableBodyAxisV += "</tr>";
    });

    //tableBody += "</tbody>";

    var effectiveDate = $.xmlDOM(result).find('EffectiveDate').text();

    var trEffictiveDate = "<table width='100%'><tr><td align='left' width='20%'>Effective Date: " + effectiveDate + "</td></tr></table>";

    var DiagnosisHTML = trEffictiveDate + tableHeader + tableBody + tableHeaderAxisIII + tableBodyAxisIII + tableHeaderAxisV + tableBodyAxisV + "</tbody>" + endTable;
    $("[id$=divPreviousDiagnosis]").html(DiagnosisHTML);
}





function ClientTabSelectingHandler(sender, eventArgs) {
    var tabStrip = sender;
    var tab = eventArgs._tab;
    if (tab._attributes._data.UcName == 'Medications') {
        if ($("#divCurrentMedicationsLMH").length > 0) {
            $("#divCurrentMedicationsLMH").css("height", 200);
        }
    }
    return true;
}



AddEventHandlers = (function() {
   //debugger;
   
    try {
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {
            historytabobject = tabobject._selectedIndex;
            if (historytabobject >= 0) {
                selectedTabText = tabobject.get_selectedTab().get_text();

                if (historytabobject == 0 && selectedTabText == 'General') {
                    var TypeOfTeamDischarge = $("#RadioButton_CustomDocumentDischarges_DischargeType_P");
                    if (TypeOfTeamDischarge.length > 0) {
                        TypeOfTeamDischarge.change(function() {
                            $('[type=radio]', $('#myTableDischarge')).each(function() {
                                $(this).removeAttr('disabled');
                            });

                            var ReasonForDischargeCode = $('[id$=DropDownList_CustomDocumentDischarges_TransitionDischarge]');
                            if (ReasonForDischargeCode.length > 0) {
                                CallReasonForDischargeCode(this);
                            }
                        });
                    }

                    var TypeOfDischarge = $("#RadioButton_CustomDocumentDischarges_DischargeType_A");
                    if (TypeOfDischarge.length > 0) {
                        TypeOfDischarge.click(function() {
                            $("#RadioButton_CustomDocumentDischarges_DischargeType_P").attr('checked', 'checked');
                            ShowMsgBox('You are about to perform an agency discharge, do you want to continue?', ConfirmationMessageCaption, MessageBoxButton.YesNo, MessageBoxIcon.Question, 'ConfirmSetDischarge(\'yes\')', 'ConfirmSetDischarge(\'no\')');
                        });
                    }
                }

                if (historytabobject == 1 && selectedTabText == 'Progress Review') {
                    try {
                        var DocumentVersionId = AutoSaveXMLDom.find("CustomDocumentDischarges:first DocumentVersionId").text();
                        var Span_Address = $('[id$=Span_Address]').text();
                        var Span_City = $('[id$=Span_City]').text();
                        var Span_State = $('[id$=Span_State]').text();
                        var Span_Zip = $('[id$=Span_Zip]').text();
                        if (!Span_Address)
                            Span_Address = '';
                        if (!Span_City)
                            Span_City = '';
                        if (!Span_State)
                            Span_State = '';
                        if (!Span_Zip)


                            Span_Zip = '';

                        if (Span_Address != '')
                            Span_Address = Span_Address.trim();
                        if (Span_City != '') {
                            if (Span_City.indexOf(',') != -1) {
                                Span_City = Span_City.trim();
                                var lastChar = Span_City.substr(Span_City.length - 1);
                                if (lastChar == ',') {
                                    Span_City = Span_City.substring(0, Span_City.length - 1)
                                }
                            }
                        }
                        if (Span_State != '')
                            Span_State = Span_State.trim();
                        if (Span_Zip != '')
                            Span_Zip = Span_Zip.trim();

                        SetColumnValueInXMLNodeByKeyValue("CustomDocumentDischarges", "DocumentVersionId", DocumentVersionId, "Address", Span_Address, AutoSaveXMLDom[0]);
                        SetColumnValueInXMLNodeByKeyValue("CustomDocumentDischarges", "DocumentVersionId", DocumentVersionId, "City", Span_City, AutoSaveXMLDom[0]);
                        SetColumnValueInXMLNodeByKeyValue("CustomDocumentDischarges", "DocumentVersionId", DocumentVersionId, "State", Span_State, AutoSaveXMLDom[0]);
                        SetColumnValueInXMLNodeByKeyValue("CustomDocumentDischarges", "DocumentVersionId", DocumentVersionId, "Zip", Span_Zip, AutoSaveXMLDom[0]);
                    }
                    catch (ex) {

                    }
                }

                if ($('#Button_GetCurrentMedication').length > 0) {
                    $('#Button_GetCurrentMedication').unbind("click");
                    $('#Button_GetCurrentMedication').bind('click', function() {
                        GetCurrentMedications();
                    });
                }

                $("#divCurrentMedicationsLMH").css("height", 200);

                if (historytabobject == 1 && selectedTabText == 'Progress Review') {
                    //renderGoalsObjective();
                    BindGoalsObjectives();
                }

                if (historytabobject == 3 && selectedTabText == 'Referrals/Disposition Plan') {
                    //debugger;
                    $("[id$=DropDownList_CustomDischargeReferrals_Referral]").unbind('change');
                    $("[id$=DropDownList_CustomDischargeReferrals_Referral]").bind("change", function() {
                        //debugger;
                        // BindReferralSubtype($("[id$=DropDownList_CustomDischargeReferrals_Referral]").val());
                    });
                }
            }
        }
        $('[type=radio]', $('#myTableDischarge')).each(function() {
            //debugger;
            if ($(this)[0].value == 'D') {
                //ShowHideTab(ProgressReview_tab, true);

            }
            //else { ShowHideTab(ProgressReview_tab, false); }

        }); 

    }
    catch (ex) {

    }
});


var SubReferralType = "";
function BindReferralSubtype(GlobalCodeId) {//debugger;
    try {
        //debugger;
        $.ajax({
            type: "POST",
            url: _ApplicationBasePath + "Custom/Discharge/WebPages/Discharge.aspx?functionName=GetReferralSubtypeByGlobalCode",
            data: 'GlobalCodeId=' + GlobalCodeId + "&ClientEpisodeId=" + "&ReferralType=" + $("[id$=DropDownList_CustomDischargeReferrals_Program]").val(),
            asyn: false,
            success: function(result) {
                //debugger;
                UpdateDropDown(result);
                if (SubReferralType) {
                    $('select[id$=DropDownList_CustomDischargeReferrals_Program]').val(SubReferralType);
                    CreateAutoSaveXml('CustomDischargeReferrals', 'Program', SubReferralType);
                    SubReferralType = "";
                }
            }
        });
    }
    catch (err) {
        LogClientSideException(err, 'CustomRegistrations-BindReferralSubtype');
    }
}

function UpdateDropDown(result) {
    $("[id$=DropDownList_CustomDischargeReferrals_Program]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $("<option value=''></option>").appendTo("[id$=DropDownList_CustomDischargeReferrals_Program]");
            $.xmlDOM(result.xml).find("ClientServicesView").each(function() {
                $("<option value=" + this.childNodes[1].text + ">" + this.childNodes[0].text + "</option>").appendTo("[id$=DropDownList_CustomDischargeReferrals_Program]");
            });
            if (!$('select[id$=DropDownList_CustomDischargeReferrals_Program]').val()) {
                CreateAutoSaveXml('CustomDischargeReferrals', 'Program', '');
            }
            else {
                CreateAutoSaveXml('CustomDischargeReferrals', 'Program', $('select[id$=DropDownList_CustomDischargeReferrals_Program]').val());
            }
        }
    }
}




function GetCurrentMedications() {
    try {
        $.ajax({
            type: "POST",
            url: _ApplicationBasePath + "Custom/Discharge/WebPages/Discharge.aspx?functionName=CurrentMedicationsListForLMH",


            success: function(result) {
                if (result != undefined && result != null && result != '') {
                    CustomAjaxRequestCallbackMedications(result);
                }
                else {
                    GetCurrentMedications();
                }
            }
        });
    }
    catch (err) {
        LogClientSideException(err, 'GetCurrentMedications');
    }
}



GetClientProgramsList = (function(action) {
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/Discharge/WebPages/Discharge.aspx?functionName=ClientProgramsList",
            data: '',
            success: function(result) { GetClientProgramsListResult(result, action); }
        });
    }
    catch (err) { }
});


CallReasonForDischargeCode = (function(obj) {
    try {
        var TypeOfDischarge = AutoSaveXMLDom.find("CustomDocumentDischarges:first DischargeType").text();
        if (obj != null) {
            if ($(obj).length > 0 && $(obj).attr('checked')) {
                TypeOfDischarge = 'P';
            }
        }        
    }
    catch (err) {
    }
});



//CheckPrimaryProgramType = (function() {
//    try {
//        var NewPrimaryClientProgramId = AutoSaveXMLDom.find("CustomDocumentDischarges:first NewPrimaryClientProgramId").text();
//        if (NewPrimaryClientProgramId != null && NewPrimaryClientProgramId != undefined && NewPrimaryClientProgramId != '') {
//            $.ajax({
//                type: "POST",
//                url: GetRelativePath() + "Custom/Discharge/WebPages/Discharge.aspx?functionName=CheckPrimaryProgramType",
//                data: 'NewPrimaryClientProgramId=' + NewPrimaryClientProgramId,
//                success: function(result) {
//                    SetReasonForDischargeCode();
//                }
//            });
//        }

//    }
//    catch (err) { }
//});









GetClientProgramsListResult = (function(result, action) {
    //debugger;
    try {
        if (result.toString() != '') {
            var ProgramList = eval(result);
            if (ProgramList.length > 7) {
                $("#divScrollHead").show();
                $("#divNonScrollHead").hide();
            }
            else {
                $("#divScrollHead").hide();
                $("#divNonScrollHead").show();
            }
            $("#myTableDischarge").html('');
            if (ProgramList.length == 0) {
                $("#myTableDischarge").html('<tr class="dxgvDataRow"><td align="center" class="dxgv" style="width: 35%;height:20px; border-left-color: rgb(207, 207, 207); border-left-width: 1px; border-left-style: solid;">Programs not enrolled</td></tr>');
            }
            else {
                $("#clientTemplate").tmpl(ProgramList).appendTo("#myTableDischarge");
                SetRadioFromUnsavedChanges(action);
            }
        }
       // debugger;
        $('[type=radio]', $('#myTableDischarge')).each(function() {
            //debugger;
            if ($(this)[0].value == 'D') {
                if ($(this).attr('checked')) {
                    countDischarge = countDischarge + 1;
                    //debugger;
                    Showhidetabs('D');
                }
            }


        });
    }
    catch (err) { }
});


SetRadioFromUnsavedChanges = (function(action) {
    //debugger;
    try {
        if (action == pageActionEnum.Update || action == pageActionEnum.None || action == pageActionEnum.EditDocument || action == pageActionEnum.New || action == pageActionEnum.TabRequest) {
            $('[type=radio]', $('#myTableDischarge')).each(function() {
                var RecordDeleted = null;
                var CustomDischargePrograms = null;
                var ClientProgramId = null;
                ClientProgramId = $(this)[0].id.toString().substring($(this)[0].id.toString().lastIndexOf("_") + 1, $(this)[0].id.toString().length);
                CustomDischargePrograms = $("CustomDischargePrograms ClientProgramId[text=" + ClientProgramId + "]", AutoSaveXMLDom[0]).parent();
                if (CustomDischargePrograms.length > 0) {
                    RecordDeleted = CustomDischargePrograms.find('RecordDeleted').text()
                    if (RecordDeleted.length > 0) {
                        if (RecordDeleted == 'Y' && $(this)[0].value == 'R') {
                            $(this).attr('checked', true);
                            $("#Checkbox_ClientPrograms_" + ClientProgramId).attr('disabled', false)
                        }
                        else if (RecordDeleted == 'N' && $(this)[0].value == 'D') {
                            $(this).attr('checked', true);
                            $("#Checkbox_ClientPrograms_" + ClientProgramId).attr('disabled', true)
                        }
                    }
                    else {
                        if ($(this)[0].value == 'R') {
                            $(this).attr('checked', true);
                            $("#Checkbox_ClientPrograms_" + ClientProgramId).attr('disabled', false)
                        }
                    }
                }
                else {
                    if ($(this)[0].value == 'R') {
                        $(this).attr('checked', true);
                        $("#Checkbox_ClientPrograms_" + ClientProgramId).attr('disabled', false)
                    }
                }
                var DischargeAction = $("CustomDocumentDischarges", AutoSaveXMLDom[0]).find("DischargeType").text();
                if (DischargeAction == "A") {
                    $(this).attr('disabled', 'disabled');
                    if ($(this)[0].value == 'D') {
                        $(this).attr('checked', true);
                        $(this).trigger('click');
                    }
                }
            });

            $('[type=checkbox]', $('#myTableDischarge')).each(function() {
                //debugger;
                var PrimaryAssignmentNode = null;
                var PrimaryAssignment = null;
                var ClientProgramId = null;
                var DischargeNewClientProgramId = null;
                ClientProgramId = $(this)[0].id.toString().substring($(this)[0].id.toString().lastIndexOf("_") + 1, $(this)[0].id.toString().length);
                PrimaryAssignmentNode = $("ClientPrograms ClientProgramId[text=" + ClientProgramId + "]", AutoSaveXMLDom[0]).parent();
                DischargeNewClientProgramId = $("CustomDocumentDischarges NewPrimaryClientProgramId", AutoSaveXMLDom[0]).text();
                if (PrimaryAssignmentNode.length > 0) {
                    PrimaryAssignment = PrimaryAssignmentNode.find('PrimaryAssignment').text();
                    if (PrimaryAssignment.length > 0) {
                        if ($("CustomDocumentDischarges DocumentVersionId", AutoSaveXMLDom[0]).text() == "-1" && PrimaryAssignment == "Y") {
                            if ($("#Radio_ClientPrograms_D_" + ClientProgramId).attr('checked') == true)
                                $(this).attr('checked', false);
                            else
                                $(this).attr('checked', true);

                        }
                        else if (DischargeNewClientProgramId != null && DischargeNewClientProgramId != "" && $(this).attr('programid') == DischargeNewClientProgramId) {
                        $(this).attr('checked', true);
                        $("#Radio_ClientPrograms_D_" + DischargeNewClientProgramId).attr('disabled', 'disabled');
                        }
                        else {
                            $(this).attr('checked', false);
                            //$("#Radio_ClientPrograms_D_" + DischargeNewClientProgramId).removeAttr('disabled');
                        }
                    }
                }
                else {
                    $(this).attr('checked', false);
                }

            });
        }

    }
    catch (err) { }
});



ConfirmSetDischarge = (function(mode) {
    try {
        if (mode == 'yes') {
            $("#RadioButton_CustomDocumentDischarges_DischargeType_A").attr('checked', 'checked');
            CreateAutoSaveXml('CustomDocumentDischarges', 'DischargeType', 'A');
//            var ReasonForDischargeCode = $('[id$=DropDownList_CustomDocumentDischarges_TransitionDischarge]');
//            if (ReasonForDischargeCode.length > 0) {
//                $("[id$=DropDownList_CustomDocumentDischarges_TransitionDischarge]").html($("[id$=DropDownList_CustomDocumentDischarges_TransitionDischarge1]").html());
//                SetReasonForDischargeCode();
//            }
            SetDischarge();
        }
    }
    catch (err) {
    }
});

SetDischarge = (function() {
   // debugger;
    try {
        $('[type=radio]', $('#myTableDischarge')).each(function() {
            $(this).attr('disabled', 'disabled');
            if ($(this)[0].value == 'D') {
                $(this).attr('checked', true);
                $(this).trigger('click');
            }
        });
    }
    catch (err) {
    }
});


//SetReasonForDischargeCode = (function() {
//    try {
//        var ReasonForDischargeCode = AutoSaveXMLDom.find("CustomDocumentDischarges:first TransitionDischarge").text();
//        if (ReasonForDischargeCode != null && ReasonForDischargeCode != undefined && ReasonForDischargeCode != '') {
//            if ($("[id$=DropDownList_CustomDocumentDischarges_TransitionDischarge] option[value='" + ReasonForDischargeCode + "']").length > 0) {
//                $("[id$=DropDownList_CustomDocumentDischarges_TransitionDischarge]").val(ReasonForDischargeCode);
//            }
//            else {
//                SetColumnValueInXMLNodeByKeyValue("CustomDocumentDischarges", "DocumentVersionId", AutoSaveXMLDom.find("CustomDocumentDischarges:first DocumentVersionId").text(), "ResponseToTreatmentComments", "", AutoSaveXMLDom[0]);
//            }
//        }
//    }
//    catch (err) {
//    }
//});


SetDischargeProgram = (function(ClientProgramId, Status) {
    //debugger;
    try {
        var DischargeProgramId = null;
        var XmlDischargeProgram = null;
        var newDischargeProgramId = null;
        var CustomDischargePrograms_Remove_node = null;
        if (Status == 'D') {
            XmlDischargeProgram = $("CustomDischargePrograms", AutoSaveXMLDom);
            if (XmlDischargeProgram.length == 0) {
                SetDischargeValues("CustomDischargePrograms", "DischargeProgramId", "DocumentVersionId", -1, DocumentVersionId,
                          "DocumentVersionId^ClientProgramId^RecordDeleted", DocumentVersionId + '^' + ClientProgramId + '^N', 0, AutoSaveXMLDom);
            }
            else if (XmlDischargeProgram.length > 0) {
                DischargeProgramId = XmlDischargeProgram[XmlDischargeProgram.length - 1].selectNodes("DischargeProgramId")[0].text;
                newDischargeProgramId = -1;

                if (parseInt(DischargeProgramId) > 0)
                    newDischargeProgramId = -1;
                else
                    newDischargeProgramId = parseInt(DischargeProgramId) - 1;

                SetDischargeValues("CustomDischargePrograms", "DischargeProgramId", "DocumentVersionId", parseInt(newDischargeProgramId), DocumentVersionId,
                          "DocumentVersionId^ClientProgramId^RecordDeleted", DocumentVersionId + '^' + ClientProgramId + '^N', 0, AutoSaveXMLDom);
            }

            $("#Checkbox_ClientPrograms_" + ClientProgramId).attr('disabled', true);
            if ($("#Checkbox_ClientPrograms_" + ClientProgramId).attr('checked')) {
                $("#Checkbox_ClientPrograms_" + ClientProgramId).attr('checked', false);
                CreateAutoSaveXml('CustomDocumentDischarges', 'NewPrimaryClientProgramId', '');
            }

            var checkBoxPrimaryTeam;
            $('[type=checkbox]', $('#myTableDischarge')).each(function() {
                if (($(this).attr('checked') == 'checked') || ($(this).attr('checked') == true)) {
                    checkBoxPrimaryTeam = "true";
                }
            });


            Showhidetabs('D');
        }
        else if (Status == 'R') {

            DischargeProgramId = null;
            CustomDischargePrograms_Remove_node = $("CustomDischargePrograms ClientProgramId[text=" + ClientProgramId + "]", AutoSaveXMLDom[0]).parent();
            $("#Checkbox_ClientPrograms_" + ClientProgramId).attr('disabled', false);

            if (CustomDischargePrograms_Remove_node.length > 0) {
                for (var Count = 0; Count < CustomDischargePrograms_Remove_node.length; Count++) {
                    DischargeProgramId = CustomDischargePrograms_Remove_node.find('DischargeProgramId').text()
                    CustomSetColumnValueInXMLNodeByKeyValue('CustomDischargePrograms', 'DischargeProgramId', DischargeProgramId, 'RecordDeleted', 'Y', AutoSaveXMLDom[0], 'Y');
                }
            }

            var checkBoxPrimaryTeam;
            var ClientProgramId = null;

            $('[type=checkbox]', $('#myTableDischarge')).each(function() {
                if (($(this).attr('checked') == 'checked') || ($(this).attr('checked') == true)) {
                    checkBoxPrimaryTeam = "true";
                    ClientProgramId = $(this)[0].id.toString().substring($(this)[0].id.toString().lastIndexOf("_") + 1, $(this)[0].id.toString().length);

                }
            });
            //debugger;
            var radi_D_Count = 0;
            $("[id$='test']").each(function() {
                radio_D = $(this).find("[id*='Radio_ClientPrograms_D']").attr('checked');
                if (radio_D == true) {
                    radi_D_Count = radi_D_Count + 1;

                }
            });

            if (checkBoxPrimaryTeam == "true") {
                CreateAutoSaveXml('CustomDocumentDischarges', 'NewPrimaryClientProgramId', ClientProgramId);
            }


            if (countDischarge > 0) {
                countDischarge = countDischarge - 1;
            }
            if (countDischarge == 0) {
                countDischarge = radi_D_Count;
            }
            Showhidetabs('');
        }
    }
    catch (err) { }
    CreateUnsavedInstanceOnDatasetChange();
});




SetDischargeValues = (function(tableName, primaryKeyName, ForeignKeyName, primaryKeyValue, ForeignKeyValue, columnName, columnValue, Object, dom) {
    try {
        //debugger;
        columnName = columnName.split('^');
        if (Object == 0) {
        }
        else {
            columnValue = columnValue + '^' + $("#" + Object.id)[0].value;
        }
        columnValue = columnValue.split('^');
        columnValue_Length = columnValue.length;

        var _xmlDom = $("CustomDischargePrograms ClientProgramId[text=" + columnValue[1] + "]", AutoSaveXMLDom[0]).parent();
        if (_xmlDom.length > 0) {
            primaryKeyValue = _xmlDom.find('DischargeProgramId').text();
            var _DocumentVersion = null;
            _DocumentVersion = _xmlDom.find('DocumentVersionId').text();
            if (_DocumentVersion = columnValue[0]) {
                CustomSetColumnValueInXMLNodeByKeyValue("CustomDischargePrograms", "DischargeProgramId", parseInt(primaryKeyValue), 'RecordDeleted', 'N', dom[0], 'Y');
            }
        }
        else {
            var primaryKeySet = false;
            for (var k = 0; k < columnValue_Length; k++) {
                if (primaryKeyValue <= 0) {
                    var fk = ForeignKeyValue;
                    var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'DischargeProgramId', AutoSaveXMLDom[0]);
                    if (_xmlDom.length == 0 && primaryKeySet == false) {
                        AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)); //Add table in the XML Dom
                        var _currentNode = "";
                        _currentNode = AutoSaveXMLDom[0].childNodes[0].lastChild.appendChild(AutoSaveXMLDom[0].createElement(primaryKeyName));
                        _currentNode.text = primaryKeyValue;
                        primaryKeySet = true;
                    }
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, ForeignKeyName, ForeignKeyValue, AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName[k], columnValue[k], AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'ModifiedDate', ISODateString(new Date()), AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'CreatedDate', ISODateString(new Date()), AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'ModifiedBy', objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'CreatedBy', objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0], 'Y');
                }
                else {
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName[k], columnValue[k], AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'ModifiedDate', ISODateString(new Date()), AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'CreatedDate', ISODateString(new Date()), AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'ModifiedBy', objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'CreatedBy', objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0], 'Y');
                }
            }
        }
    }
    catch (err) {
    }
});


CustomSetColumnValueInXMLNodeByKeyValue = (function(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom, CallAutoSave) {
    try {
        SetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom);
    }
    catch (err) {
    }
});


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




SetPrimaryAssignment = (function(ClientProgramId, PrimaryAssignment) {
    try {
        if (PrimaryAssignment) {
            Uncheckcheckbox();
            if ($("#Checkbox_ClientPrograms_" + ClientProgramId).length > 0) {
                $("#Checkbox_ClientPrograms_" + ClientProgramId).attr('checked', true);
                $("#Radio_ClientPrograms_D_" + ClientProgramId).attr('disabled', 'disabled');
            }           
            CreateAutoSaveXml('CustomDocumentDischarges', 'NewPrimaryClientProgramId', ClientProgramId);
        }
        else {
            CreateAutoSaveXml('CustomDocumentDischarges', 'NewPrimaryClientProgramId', '');
            $("#Radio_ClientPrograms_D_" + ClientProgramId).removeAttr('disabled');
        }

        var ReasonForDischargeCode = $('[id$=DropDownList_CustomDocumentDischarges_TransitionDischarge]');
        if (ReasonForDischargeCode.length > 0) {
            CallReasonForDischargeCode(null);
        }
    }
    catch (err) { }
});

Uncheckcheckbox = (function() {
    try {
        $('[type=checkbox]', $('#myTableDischarge')).each(function() {
            var ClientProgramId = null;
            ClientProgramId = $(this)[0].id.toString().substring($(this)[0].id.toString().lastIndexOf("_") + 1, $(this)[0].id.toString().length);
            CreateAutoSaveXml('CustomDocumentDischarges', 'NewPrimaryClientProgramId', '');
            $(this).attr('checked', false);
        });
    }
    catch (err) { }
});


function CustomAjaxRequestCallbackMedications(resultCurrentMedication) {//debugger;
    try {
        if ($("[id$=divCurrentMedicationsLMH]").length > 0) {
            var divCurrentMedications = $("[id$=divCurrentMedicationsLMH]");
            if (divCurrentMedications.length > 0) {
                if (resultCurrentMedication.length > 0 && resultCurrentMedication != '<NewDataSet />') {
                    if (divCurrentMedications) {
                        divCurrentMedications.html('');
                    }
                    divCurrentMedications.html(createTable(resultCurrentMedication, 'M', 'O'));
                }
                else {
                    divCurrentMedications.html('None Reported');
                }
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'LMH-CustomAjaxRequestCallbackMedications');
    }
}

function createTable(result, Type, medGroup) {
    try {
        if (Type == 'M') {
            var tableHeader = "<table width='782px' cellpadding='0' cellspacing='0' border='0'>";
            var tableBody = "";
            var endTable = "</table>";
            var resultClientMedications = $.xmlDOM(result);
            $(resultClientMedications).find('ClientMedications').each(function() {
                tableBody += "<tr valign='top'>";
                tableBody += "<td align='left' width='115px' style='padding-left:5px'>" + $(this).find('MedicationName').text() + "</td>";
                tableBody += "<td align='left' width='245px' style='padding-left:5px'>" + $(this).find('Instructions').text() + "</td>";
                tableBody += "<td align='left' width='107px' style='padding-left:5px'>" + $(this).find('PrescriberName').text() + "</td>";
                if (medGroup === 'O')
                    tableBody += "<td align='left' width='95px' style='padding-left:5px'>" + $(this).find('LastOrdered').text() + "</td>";
                tableBody += "<td align='left' width='95px' style='padding-left:5px'>" + $(this).find('MedicationStartDate').text() + "</td>";
                tableBody += "<td align='left' width='95px' style='padding-left:5px'>" + $(this).find('MedicationEndDate').text() + "</td>";
                tableBody += "</tr>";
            });

            if ($.xmlDOM(result).find('ClientMedications').length == 0) {
                tableBody = "<tr valign='top'><td align='left'>None Reported</td></tr>";
            }

            return tableHeader + tableBody + endTable;
        }
        if (Type == 'A') {
            var tableHeader = "<table width='782px' cellpadding='0' cellspacing='0'>";
            var tableBody = "";
            var endTable = "</table>";
            var resultClientAllergies = $.xmlDOM(result);
            $(resultClientAllergies).find('ClientAllergies').each(function() {
                tableBody += "<tr valign='top'>";
                tableBody += "<td align='left' width='200px' style='padding-bottom:2pxpad;ding-left:5px'>" + $(this).find('Allergies').text() + "</td>";
                tableBody += "<td align='left' width='400px' style='padding-bottom:2px;padding-left:5px'>" + $(this).find('Comments').text() + "</td>";
                tableBody += "</tr>";
            });
            return tableHeader + tableBody + endTable;
        }
        if (Type == 'I') {
            var tableHeader = "<table cellpadding='0' cellspacing='0'>";
            var tableBody = "";
            var endTable = "</table>";
            var resultClientAllergies = $.xmlDOM(result);
            $(resultClientAllergies).find('ClientImmunizations').each(function() {
                tableBody += "<tr valign='top'>";
                tableBody += "<td align='left' style='padding-bottom:2pxpad;ding-left:5px'>" + $(this).find('VaccineName').text() + ', ' + $(this).find('AdministeredDate').text() + "</td>";
                //tableBody += "<td align='left' style='padding-bottom:2px;padding-left:5px'>" + $(this).find('AdministeredDate').text() + "</td>";
                tableBody += "</tr>";
            });
            return tableHeader + tableBody + endTable;
        }
        if (Type == 'D') {
            var tableHeader = "<table cellpadding='0' cellspacing='0'>";
            var tableBody = "";
            var endTable = "</table>";
            var resultDiscontinuedMedication = $.xmlDOM(result);
            $(resultDiscontinuedMedication).find('Medication').each(function() {
                tableBody += "<tr valign='top'>";
                tableBody += "<td align='left' style='padding-bottom:2pxpad;ding-left:5px'>" + resultDiscontinuedMedication.find("Medication:first MedicationHistory").text() + "</td>";
                tableBody += "</tr>";
            });
            return tableHeader + tableBody + endTable;
        }

    }
    catch (err) {
        LogClientSideException(err, 'Medication: createTable');
    }
}





function InsertReferral(TableChildControl, InsertGrid, CustomGrid, obj) {
    if ($("#DropDownList_CustomDischargeReferrals_Referral option:selected").text() == "") {
        ///please select any Referral
        ShowHideErrorMessage("Referrals/Disposition Plan - Referrals - Discharge Referral is required", 'true');
        return false;
    }
    else {
        $('[id$=HiddenField_CustomDischargeReferrals_ReferralText]').val($("#DropDownList_CustomDischargeReferrals_Referral option:selected").text());
        $('[id$=HiddenField_CustomDischargeReferrals_ProgramText]').val($("#DropDownList_CustomDischargeReferrals_Program option:selected").text());
        InsertGridData('TableChildControl_CustomDischargeReferrals', 'InsertGridCustomDischargeReferrals', 'CustomGrid', $("#TableChildControl_CustomDischargeReferrals_ButtonInsert")[0]);
    }
}
function AddEventHandlerAfterInsertGrid() {
    $('[id$=DropDownList_CustomDischargeReferrals_Program]').val(-1);
}



function ShowHideTab(tabInstance, showTab) {
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

