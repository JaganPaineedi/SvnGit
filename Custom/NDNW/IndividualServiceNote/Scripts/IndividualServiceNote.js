function SetScreenSpecificValues() {
    if (TabIndex == 0) {
   var myDate = new Date();
            $('[id$=divClientInformationNotesLink] > table tr').each(function() { 
                $(this).find('td').each(function() {
                    var obj = $(this).find('span').next();
                    if ($(obj).length > 0) {
                    $.post(GetRelativePath() + "CommonUserControls/AjaxCallForInformationIconToolTip.aspx?ClientInformationNotes=Y&StoredProcedureName=" + $(obj).attr('TooltipSP') + "&Date=" + myDate, function(data) {
                            $(obj).wTooltip({
                                content: data,
                                style: {
                                    border: "1px solid black",
                                    background: "yellow",
                                    color: "black",
                                    padding: "1px,1px,10px,1px",
                                    top: "5px"
                                }
                            });
 
                        });
                    }
                });
            });

        if ($('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_DBT').attr('checked')) {
            IndividualServiceNoteTabPageInstance.GetTab(1).SetVisible(true);
        }
        else {
            IndividualServiceNoteTabPageInstance.GetTab(1).SetVisible(false);
        }
        EnableOrDiableCheckBoxes();
        //EnableOrDiableHarmToOthersCheckBoxes();
        //EnableOrDisableHarmToPropertyCheckBoxes();

    var XMLDiagnosisitems = GetAutoSaveXMLDomNode('CustomIndividualServiceNoteDiagnoses', $.xmlDOM($("[id$=HiddenFieldBillingDiagnosis]").val()));

    var Diagnosisitems = $(XMLDiagnosisitems).XMLExtract();
    var XMLDiagnosisitemsNew = [];
    for (var i = 0; i < Diagnosisitems.length; i++) {
        if (Diagnosisitems[i].RecordDeleted != 'Y') {
            XMLDiagnosisitemsNew.push(Diagnosisitems[i]);
        }
    }

    XMLDiagnosisitemsNew = XMLDiagnosisitemsNew.sort(function(a, b) {
        var aorder = a.Order;
        var border = b.Order;
        if (!aorder) { aorder = 9; }
        if (!border) { border = 9; }
        return [aorder] < [border] ? -1 : 1;
    });
    try {
        var $divDiagnosis = $('#divBillingDiagnosisTemplate');
        $divDiagnosis.html('');
        if (XMLDiagnosisitemsNew != "") {
            $divDiagnosis.html($('#DiagnosisTemplate').render(XMLDiagnosisitemsNew));
        }
    }
    catch (err)
    { }
    
    // Goals and objectives
        var goalsAndObjectives = $("[id$=HiddenFieldGoalsAndObjectives]").val();
        $('#GoalsObj').html(goalsAndObjectives);
        var check = false;
        if ($('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_ShowSelectedItem').attr('checked') == true) {
            $('#GoalsObj input:checkbox:not(:checked)').parent().parent().hide();
            $('#GoalsObj input:text:not(:checked)').parent().parent().hide();
            check = true;
        }
        else {
            $('#GoalsObj input:checkbox:not(:checked)').parent().parent().show();
            $('#GoalsObj input:text:not(:checked)').parent().parent().show();
        }
        var status = $('[#GoalsObj][id=CheckBoxGoal]');
        if (status.length > 0) {
            var count = 0;
            $(status).each(function() {
                var id = $(this).attr('goalidtohide');
                if (check == true) {
                    if ($(this).attr('checked') == true) {
                        if (count == 0) {
                            $('#spanStatus_' + id).show()
                            count = 1;
                        }
                        else {
                            $('#spanStatus_' + id).hide();
                        }
                    }
                }
                else {
                    if (count == 0) {
                        $('#spanStatus_' + id).show()
                        count = 1;
                    }
                    else {
                        $('#spanStatus_' + id).hide();
                    }
                }
            });
        }
    }
}

function CheckBoxJavascript(htmldata, row) {
    var vSelectedContactTable = GetAutoSaveXMLDomNode('CustomIndividualServiceNoteGoals');
    var items = vSelectedContactTable.length > 0 ? $(vSelectedContactTable).XMLExtract() : [];
    var vSelectedContactId = '';
    if (items.length > 0) {
        $(items).each(function() {
            if ($(this)[0].RecordDeleted != 'Y' && $(this)[0].GoalId == htmldata) {
                vSelectedContactId = $(this)[0].IndividualServiceNoteGoalId;
                return false;
            }

        });
    }
    var contactitem = ArrayHelpers.GetItem(items, vSelectedContactId, 'IndividualServiceNoteGoalId');
    //var DropDownListProgramId = parent.$('select[id$=DropDownList_Services_ProgramId]');
    //pgmid = DropDownListProgramId.val();
    if ($(row).attr('checked') == true) {
        chk = "true";
        contactitem["CustomGoalActive"] = "Y";
        //contactitem["ProgramId"] = pgmid;
        uncheckObj(htmldata, "false");
    }
    else {
        contactitem["CustomGoalActive"] = "N";
        uncheckObj(htmldata, "disabled");
    }
    CreateAutoSaveXMLObjArray('CustomIndividualServiceNoteGoals', 'IndividualServiceNoteGoalId', contactitem, false);
}

function uncheckObj(htmldata, type, pNotSaveFlag) {
    $('[#GoalsObj][GoalID=' + htmldata + ']').each(function() {
        if (type == "disabled") {
            $(this).attr("disabled", "disabled");
            $(this).attr("checked", false);
            if (!pNotSaveFlag)
                CheckBoxJavascriptObj($(this).attr('ObjectiveNumber'), this, pNotSaveFlag);
        }
        else {
            $(this).removeAttr("disabled");
        }
    });
    $('[#GoalsObj][ObjGoalID=' + htmldata + ']').each(function() {
        if (type == "disabled") {
            $(this).attr("disabled", "disabled");
        }
        else {
            $(this).removeAttr("disabled");
        }
    });
}

function CheckBoxJavascriptObj(htmldata, chk) {
    var vSelectedContactTable = GetAutoSaveXMLDomNode('CustomIndividualServiceNoteObjectives');
    var items = vSelectedContactTable.length > 0 ? $(vSelectedContactTable).XMLExtract() : [];
    var vSelectedContactId = '';
    //    vSelectedContactId = AutoSaveXMLDom.find("CustomPeerSupportContactNoteObjectives").find('ObjectiveNumber[text=' + htmldata + ']').parent().find("CustomPeerSupportContactNoteObjectiveId").text();
    if (items.length > 0) {
        $(items).each(function() {
            if ($(this)[0].RecordDeleted != 'Y' && $(this)[0].ObjectiveNumber == htmldata) {
                vSelectedContactId = $(this)[0].IndividualServiceNoteObjectiveId;
                return false;
            }

        });
    }
    var contactitem = ArrayHelpers.GetItem(items, vSelectedContactId, 'IndividualServiceNoteObjectiveId');
    if ($(chk).attr('checked') == true) {
        chk = "true";
        contactitem["CustomObjectiveActive"] = "Y";
    }
    else {
        contactitem["CustomObjectiveActive"] = "N";
        contactitem["Status"] = '';
        $('#DropDownList_CustomIndividualServiceNoteObjectives_Status_'+ vSelectedContactId).val('');
    }
    CreateAutoSaveXMLObjArray('CustomIndividualServiceNoteObjectives', 'IndividualServiceNoteObjectiveId', contactitem, false);
}

function ShowCheckedGoalsObjectives(select) {
    var check = false;
    if ($(select).attr('checked') == true) {
        $('#GoalsObj input:checkbox:not(:checked)').parent().parent().hide();
        //$('#GoalsObj input:text:not(:checked)').parent().parent().hide();
        check = true;
    }
    else {
        $('#GoalsObj input:checkbox:not(:checked)').parent().parent().show();
       // $('#GoalsObj input:text:not(:checked)').parent().parent().show();
    }
    
    var status = $('[#GoalsObj][id=CheckBoxGoal]');
    if (status.length > 0) {        
        var count = 0;
        $(status).each(function() {
            var id = $(this).attr('goalidtohide');
            if (check == true) {
                if ($(this).attr('checked') == true) {
                    if (count == 0) {
                        $('#spanStatus_' + id).show()
                        count = 1;
                    }
                    else {
                        $('#spanStatus_' + id).hide();
                    }
                }
            }
            else {
                if (count == 0) {
                    $('#spanStatus_' + id).show()
                    count = 1;
                }
                else {
                    $('#spanStatus_' + id).hide();
                }
            }
        });
    }   
}

//function ChangeOrder(obj) {
//    var XMLDiagnosisitems = GetAutoSaveXMLDomNode('CustomIndividualServiceNoteDiagnoses');
//    var Diagnosisitems = $(XMLDiagnosisitems).XMLExtract();

//    var CurIndividualServiceNoteDiagnosisId = $(obj).attr('IndividualServiceNoteDiagnosisId');
//    $('[id$=DropDownList_CustomIndividualServiceNoteDiagnoses_Order]').each(function() {
//        var IndividualServiceNoteDiagnosisId = $(this).attr('IndividualServiceNoteDiagnosisId');
//        if ($('[id$=DropDownList_CustomIndividualServiceNoteDiagnoses_Order][IndividualServiceNoteDiagnosisId=' + IndividualServiceNoteDiagnosisId + ']').val() == $('[id$=DropDownList_CustomIndividualServiceNoteDiagnoses_Order][IndividualServiceNoteDiagnosisId=' + CurIndividualServiceNoteDiagnosisId + ']').val() && CurIndividualServiceNoteDiagnosisId != IndividualServiceNoteDiagnosisId) {
//            $('[id$=DropDownList_CustomIndividualServiceNoteDiagnoses_Order][IndividualServiceNoteDiagnosisId=' + IndividualServiceNoteDiagnosisId + ']').val(9);
//            SetColumnValueInXMLNodeByKeyValue('CustomIndividualServiceNoteDiagnoses', 'IndividualServiceNoteDiagnosisId', IndividualServiceNoteDiagnosisId, 'Order', '', AutoSaveXMLDom[0]);
//        }
//    });
//    var val = $('[id$=DropDownList_CustomIndividualServiceNoteDiagnoses_Order][IndividualServiceNoteDiagnosisId=' + CurIndividualServiceNoteDiagnosisId + ']').val();
//    var newitem = ArrayHelpers.GetItem(Diagnosisitems, CurIndividualServiceNoteDiagnosisId, 'IndividualServiceNoteDiagnosisId');
//    newitem['Order'] = val;
//    newitem['DiagnosisChanged'] = "Yes";
//    CreateAutoSaveXMLObjArray('CustomIndividualServiceNoteDiagnoses', 'IndividualServiceNoteDiagnosisId', newitem, false);
//    //    SetColumnValueInXMLNodeByKeyValue('CustomIndividualServiceNoteDiagnoses', 'IndividualServiceNoteDiagnosisId', CurIndividualServiceNoteDiagnosisId, 'Order', val, AutoSaveXMLDom[0]);
//}

function UpdateStatus(dropdownId) {
    var objectId = dropdownId.id.split('_');
    //CreateAutoSaveXml('CustomIndividualServiceNoteObjectives', 'DiagnosisAxisIVShowNone', 'N');
    SetColumnValueInXMLNodeByKeyValue('CustomIndividualServiceNoteObjectives', 'IndividualServiceNoteObjectiveId', objectId[3], 'Status', $(dropdownId).val(), AutoSaveXMLDom[0]);
}

function EnableOrDiableSelfHarmCheckBoxes() {
    if ($('#RadioButton_CustomDocumentIndividualServiceNoteGenerals_SelfHarm_Y').attr('checked') == true) {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIdeation').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIntent').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmAttempt').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmMeans').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmPlan').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_selfHarmOther').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmOtherComments').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformed').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformedComments').attr("disabled", "");
    }
    else {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIdeation').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIdeation').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'SelfHarmIdeation', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIntent').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIntent').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'SelfHarmIntent', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmAttempt').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmAttempt').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'SelfHarmAttempt', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmMeans').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmMeans').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'SelfHarmMeans', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmPlan').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmPlan').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'SelfHarmPlan', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_selfHarmOther').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_selfHarmOther').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'selfHarmOther', 'N');
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmOtherComments').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmOtherComments').val('');
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'SelfHarmOtherComments', '');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformed').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformed').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'SelfHarmInformed', 'N');
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformedComments').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformedComments').val('');
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'SelfHarmInformedComments', '');
    }
}

function EnableOrDiableHarmToOthersCheckBoxes() {
    if ($('#RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToOthers_Y').attr('checked') == true) {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIdeation').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIntent').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersAttempt').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersMeans').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersPlan').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOther').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOtherComments').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformed').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformedComments').attr("disabled", "");
    }
    else {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIdeation').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIdeation').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToOthersIdeation', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIntent').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIntent').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToOthersIntent', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersAttempt').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersAttempt').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToOthersAttempt', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersMeans').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersMeans').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToOthersMeans', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersPlan').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersPlan').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToOthersPlan', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOther').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOther').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToOthersOther', 'N');
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOtherComments').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOtherComments').val('');
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToOthersOtherComments', '');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformed').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformed').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToOthersInformed', 'N');
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformedComments').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformedComments').val('');
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToOthersInformedComments', '');
    }
}

function EnableOrDisableHarmToPropertyCheckBoxes() {
    if ($('#RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToProperty_Y').attr('checked') == true) {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIdeation').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIntent').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyAttempt').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyMeans').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyPlan').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOther').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOtherComments').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformed').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformedComments').attr("disabled", "");
    }
    else {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIdeation').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIdeation').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToPropertyIdeation', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIntent').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIntent').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToPropertyIntent', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyAttempt').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyAttempt').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToPropertyAttempt', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyMeans').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyMeans').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToPropertyMeans', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyPlan').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyPlan').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToPropertyPlan', 'N');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOther').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOther').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToPropertyOther', 'N');
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOtherComments').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOtherComments').val('');
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToPropertyOtherComments', '');
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformed').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformed').attr("checked", false);
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToPropertyInformed', 'N');
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformedComments').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformedComments').val('');
        CreateAutoSaveXml('CustomDocumentIndividualServiceNoteGenerals', 'HarmToPropertyInformedComments', '');
    }
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

function EnableOrDisableDBTTab() {
    if ($('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_DBT').attr('checked')) {
        IndividualServiceNoteTabPageInstance.GetTab(1).SetVisible(true);
    }
    else {
        IndividualServiceNoteTabPageInstance.GetTab(1).SetVisible(false);
    }
}

function OpenSafetyCrisisPlan(){
    OpenPage(5763, 40038, 'DocumentNavigationName=Safety/Crisis Plan', 2, GetRelativePath());
}

function EnableOrDiableCheckBoxes() {
    if ($('#RadioButton_CustomDocumentIndividualServiceNoteGenerals_SelfHarm_Y').attr('checked') == true) {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIdeation').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIntent').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmAttempt').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmMeans').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmPlan').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_selfHarmOther').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmOtherComments').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformed').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformedComments').attr("disabled", "");
    }
    else {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIdeation').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmIntent').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmAttempt').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmMeans').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmPlan').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_selfHarmOther').attr("disabled", "disabled");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmOtherComments').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformed').attr("disabled", "disabled");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_SelfHarmInformedComments').attr("disabled", "disabled");
    }

    if ($('#RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToOthers_Y').attr('checked') == true) {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIdeation').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIntent').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersAttempt').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersMeans').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersPlan').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOther').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOtherComments').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformed').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformedComments').attr("disabled", "");
    }
    else {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIdeation').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersIntent').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersAttempt').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersMeans').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersPlan').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOther').attr("disabled", "disabled");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersOtherComments').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformed').attr("disabled", "disabled");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToOthersInformedComments').attr("disabled", "disabled");
    }

    if ($('#RadioButton_CustomDocumentIndividualServiceNoteGenerals_HarmToProperty_Y').attr('checked') == true) {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIdeation').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIntent').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyAttempt').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyMeans').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyPlan').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOther').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOtherComments').attr("disabled", "");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformed').attr("disabled", "");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformedComments').attr("disabled", "");
    }
    else {
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIdeation').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyIntent').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyAttempt').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyMeans').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyPlan').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOther').attr("disabled", "disabled");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyOtherComments').attr("disabled", "disabled");
        $('#CheckBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformed').attr("disabled", "disabled");
        $('#TextBox_CustomDocumentIndividualServiceNoteGenerals_HarmToPropertyInformedComments').attr("disabled", "disabled");
    }
}