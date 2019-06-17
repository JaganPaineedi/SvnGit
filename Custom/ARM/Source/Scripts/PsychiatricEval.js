var FolderUrl = '';
var tabobject = null;
var clientAge;
//Function to Bind need list data on updating need list .
function SetScreenSpecificValues(dom, action) {
    try {

        if (typeof SetAssessedNeedReferral == 'function')
            SetAssessedNeedReferral();

        //Code added : Maninder
        EnableDisableTextArea(dom, action);
        BindClickOnAbuseNotApplicable(dom, action);
        //Code ends      
        //SetAssessedNeedTransfer(dom);
        //            }
        //        }
        //Code added : Jagdeep
        if (action != 'TabRequest') {
            GetClientAge(dom);
        }
        GetFolderReferralUrl();
        if (typeof SetDiagnosisIAndIIHiddenOrderField == 'function') {
            SetDiagnosisIAndIIHiddenOrderField(dom);
        }
    }
    catch (err) {
        LogClientSideException(err, 'PsychiatricEval: SetScreenSpecificValues');
    }
}

function AddEventHandlers() {

    try {
        var serviceEval = $('select[id$=DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended]');
        if (serviceEval.length > 0) {
            serviceEval.bind("change", function() { setUnitType(); });
        
        }
        $('#CheckBox_CustomDocumentPsychiatricEvaluations_SleepHygieneOther').click(function() {
            if ($('#CheckBox_CustomDocumentPsychiatricEvaluations_SleepHygieneOther').is(":checked")) {
                $('#TextArea_CustomDocumentPsychiatricEvaluations_SleepHygieneComment').attr('disabled', false);
            }
            else {
                $('#TextArea_CustomDocumentPsychiatricEvaluations_SleepHygieneComment').attr('disabled', true);

            }
        })

    }
    catch (err) {
        LogClientSideException(err, 'Events');
    }
}

//Function is added to refresh contents on tab click
function RefreshTabPageContents(tabControl, selectedTabTitle) {

    try {

        GetFolderReferralUrl();
    }
    catch (err) {
        LogClientSideException(err, 'Refresh TabPage');
    }
}

function GetFolderReferralUrl()
{
    try {

        var _folderName = $("input[id$=hiddenFieldReferralTransferReferenceURL]").val();
        if ($("#imgFolderReferral").length > 0) {
            $("#imgFolderReferral").unbind('click');
            $("#imgFolderReferral").bind('click', function() {
                window.open(_folderName, null, "status=yes,toolbar=no,menubar=no,location=no,resizable=yes,width=600,height=500");
            });
        }
    }
    catch (err) {
        LogClientSideException(err, 'GetFolderReferralUrl');
    }
}

function PullMedicationNoteAjax() {
    //OpenPage(5763, 10673, 'action=pullmedicationnote', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    //Added By: Amit Kumar Srivastava, #47, Harbor Development, Med Review Note and Psych Eval Pull Medications, for passing DOS
    var DOB = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService");
    var timeOfService = null;
    timeOfService = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "StartTimeDateOfService");
    if (DOB != null) {
        if (DOB != "") {
            DOB = ChangeDateFormat(GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService"));
        }
        if (timeOfService != null && timeOfService != "") {
            DOB = DOB + " " + timeOfService;
        }
    }
    $.ajax({
        url: GetRelativePath() + "ActivityPages/Client/Detail/ServiceNote/ServiceNoteAjaxScript.aspx",
        type: "POST",
        data: "action=pullmedicationnote&DOS=" + DOB,
        success: function(result) { CustomAjaxRequestCallback(result); }

    });

}

function CustomAjaxRequestCallback(result) {
    if (result.toString() != '') {
        $('#TextArea_CustomDocumentPsychiatricEvaluations_MedicationsPrescribed').text(result);
        CreateAutoSaveXml('CustomDocumentPsychiatricEvaluations', 'MedicationsPrescribed', result);
    }
}

//function to enable/disable checkbox based on corresponding checkbox
function EnableDisableTextArea(dom, action) {
    if ($('#RadioButton_CustomDocumentPsychiatricEvaluations_CurrentBirthControlMedications_A').length > 0) {
        if ($('CustomDocumentPsychiatricEvaluations > ClientGender', dom).length > 0 && $.trim($('CustomDocumentPsychiatricEvaluations > ClientGender', dom).text()) == 'M' && $.trim($('CustomDocumentPsychiatricEvaluations > CurrentBirthControlMedications', dom).text()) == '') {
            $('#RadioButton_CustomDocumentPsychiatricEvaluations_CurrentBirthControlMedications_A').attr("checked", true);

            //Wasif Butt - Commented out causing errors when there is no CustomDocumentPsychiatricEvaluations in AutoSaveXML
            //CreateAutoSaveXml('CustomDocumentPsychiatricEvaluations', 'CurrentBirthControlMedications', 'A');

            SetColumnValueInXMLNodeByKeyValue("CustomDocumentPsychiatricEvaluations", "DocumentVersionId", $.trim($('CustomDocumentPsychiatricEvaluations > DocumentVersionId', dom).text()), "CurrentBirthControlMedications", 'A', AutoSaveXMLDom[0]);
        
        }
    }



    if ($('#CheckBox_CustomDocumentPsychiatricEvaluations_SleepHygieneOther').length > 0) {
        if ($('CustomDocumentPsychiatricEvaluations > SleepHygieneOther', dom).length > 0 && $.trim($('CustomDocumentPsychiatricEvaluations > SleepHygieneOther', dom).text()) == 'Y') {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_SleepHygieneComment').attr('disabled', false);
        }
        else {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_SleepHygieneComment').attr('disabled', true);

        }
    }

    if ($('#CheckBox_CustomDocumentPsychiatricEvaluations_ChildPhyscicalAppearanceOther').length > 0) {
        if ($('CustomDocumentPsychiatricEvaluations > ChildPhyscicalAppearanceOther', dom).length > 0 && $.trim($('CustomDocumentPsychiatricEvaluations > ChildPhyscicalAppearanceOther', dom).text()) == 'Y') {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildPhyscicalAppearanceOtherComment').attr('disabled', false);
        }
        else {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildPhyscicalAppearanceOtherComment').attr('disabled', true);
        }
    }

    if ($('#CheckBox_CustomDocumentPsychiatricEvaluations_ChildInteractionOther').length > 0) {
        if ($('CustomDocumentPsychiatricEvaluations > ChildInteractionOther', dom).length > 0 && $.trim($('CustomDocumentPsychiatricEvaluations > ChildInteractionOther', dom).text()) == 'Y') {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildInteractionOtherComment').attr('disabled', false);
        }
        else {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildInteractionOtherComment').attr('disabled', true);
        }
    }

    if ($('#CheckBox_CustomDocumentPsychiatricEvaluations_ChildVerbalOther').length > 0) {
        if ($('CustomDocumentPsychiatricEvaluations > ChildVerbalOther', dom).length > 0 && $.trim($('CustomDocumentPsychiatricEvaluations > ChildVerbalOther', dom).text()) == 'Y') {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildVerbalOtherComment').attr('disabled', false);
        }
        else {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildVerbalOtherComment').attr('disabled', true);
        }
    }

    if ($('#CheckBox_CustomDocumentPsychiatricEvaluations_ChildNonVerbalOther').length > 0) {
        if ($('CustomDocumentPsychiatricEvaluations > ChildNonVerbalOther', dom).length > 0 && $.trim($('CustomDocumentPsychiatricEvaluations > ChildNonVerbalOther', dom).text()) == 'Y') {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildNonVerbalOtherComment').attr('disabled', false);
        }
        else {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildNonVerbalOtherComment').attr('disabled', true);
        }
    }

    if ($('#CheckBox_CustomDocumentPsychiatricEvaluations_ChildEaseOfSeperationOther').length > 0) {
        if ($('CustomDocumentPsychiatricEvaluations > ChildEaseOfSeperationOther', dom).length > 0 && $.trim($('CustomDocumentPsychiatricEvaluations > ChildEaseOfSeperationOther', dom).text()) == 'Y') {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildEaseOfSeperationOtherComment').attr('disabled', false);
        }
        else {
            $('#TextArea_CustomDocumentPsychiatricEvaluations_ChildEaseOfSeperationOtherComment').attr('disabled', true);
        }
    }

    if ($('#CheckBox_CustomDocumentPsychiatricEvaluations_AbuseNotApplicable').length > 0) {
        if ($('CustomDocumentPsychiatricEvaluations > AbuseNotApplicable', dom).length > 0 && $.trim($('CustomDocumentPsychiatricEvaluations > AbuseNotApplicable', dom).text()) == 'Y') {
            $('[type=checkbox]', $('#SectionGroup702>tbody>tr:eq(1)')).each(function() {

                $(this).attr('disabled', true);

            });
        }

    }



}

//function to invert the behavior of GroupCheckbox click
function BindClickOnAbuseNotApplicable(dom, action) {
    var chkAbuseNotApplicable = $('#CheckBox_CustomDocumentPsychiatricEvaluations_AbuseNotApplicable')
    if ($('CustomDocumentPsychiatricEvaluations', dom).length > 0 && chkAbuseNotApplicable.length > 0) {
        chkAbuseNotApplicable.unbind('click');
        try {

            if (chkAbuseNotApplicable[0].onclick != null && typeof chkAbuseNotApplicable[0].onclick != 'undefined')
                $('#CheckBox_CustomDocumentPsychiatricEvaluations_AbuseNotApplicable')[0].onclick = null;
        }
        catch (er) {
        }

        chkAbuseNotApplicable.bind('click', function() {
            if ($(this).is(':checked')) {
                CreateAutoSaveXml('CustomDocumentPsychiatricEvaluations', 'AbuseNotApplicable', 'Y');
                $('[type=checkbox]', $('#SectionGroup702>tbody>tr:eq(1)')).each(function() {
                    $(this).attr('checked', false);
                    $(this).attr('disabled', true);
                    var arrCheckBoxId = $(this).attr('id').split('_');

                    CreateAutoSaveXml('CustomDocumentPsychiatricEvaluations', arrCheckBoxId[2], 'N');
                });
            }
            else {
                $('[type=checkbox]', $('#SectionGroup702>tbody>tr:eq(1)')).each(function() {

                    $(this).attr('disabled', false);


                });
                CreateAutoSaveXml('CustomDocumentPsychiatricEvaluations', 'AbuseNotApplicable', 'N');
            }
        });
    }
}


//Function to Get client age
function GetClientAge(dom) {
    try {
        var xmlDom = $("CustomDocumentPsychiatricEvaluations", dom);
        if (xmlDom.length > 0) {
            var years = $("ClientDOB", dom).text();

            var indexOfYear = years.indexOf('Y');
            clientAge = '';
            if (indexOfYear == 0 || indexOfYear == -1)
                indexOfYear = years.indexOf('M');
            if (indexOfYear > 0) {
                clientAge = years.substring(22, indexOfYear);
            }
            else {
                clientAge = years;
            }
        }
        
        if (clientAge >= 18) {
           
            ShowHideTabs(1, false)
            ShowHideTabs(2, false)

        }
        else {
            ShowHideTabs(1, true)
            ShowHideTabs(2, true)
        }
    }
    catch (ex) {
        LogClientSideException(err, 'GetClientAge');
    }

}

//Function to show/hide tabs
function ShowHideTabs(tabInstance, showTab) {
    try {

        PsychiatricEvaluationsTabPage.GetTab(tabInstance).SetVisible(showTab);
    }
    catch (ex) {

        LogClientSideException(err, 'ShowHideTabs');
    }
}

