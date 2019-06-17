


function AddEventHandlers() {
    EnableDisableControls();
//    CalculateTotalScore();
}


function EnableDisableControls() {
    try {      


        if ($("#CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacement").attr('checked')) {
            $("select[Id*=DropDownList_CustomAcuteServicesPrescreens_ActionTakenPsychiatricPlacementHospital]").removeAttr("disabled");
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementVoluntary_Y").attr('disabled', false)
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementInVoluntary_Y").attr('disabled', false)
        }
        else {
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementVoluntary_Y").attr('disabled', true)
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementInVoluntary_Y").attr('disabled', true)
            $('#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementVoluntary_Y').attr("Checked", false);
            $('#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementInVoluntary_Y').attr("Checked", false);
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementVoluntary_Y").removeAttr('checked');
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenPsychiatricPlacementInVoluntary_Y").removeAttr('checked');
            $("select[Id*=DropDownList_CustomAcuteServicesPrescreens_ActionTakenPsychiatricPlacementHospital]").attr("disabled", "disabled");
            $('[id$=DropDownList_CustomAcuteServicesPrescreens_ActionTakenPsychiatricPlacementHospital]').val('');
        }

        if ($("#CheckBox_CustomAcuteServicesPrescreens_RiskActionSecureTransport").attr('checked')) {
            $("#TextBox_CustomAcuteServicesPrescreens_RiskActionSecureTransportCompanyName").attr('disabled', false);

        }
        else {
            $("#TextBox_CustomAcuteServicesPrescreens_RiskActionSecureTransportCompanyName").attr('disabled', true);
            $("#TextBox_CustomAcuteServicesPrescreens_RiskActionSecureTransportCompanyName").val(" ");
        }

        if ($("#CheckBox_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBed").attr('checked')) {
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithPsych_Y").attr('disabled', false)
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithoutPsych_Y").attr('disabled', false)
        }
        else {
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithPsych_Y").attr('disabled', true)
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithoutPsych_Y").attr('disabled', true)
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithPsych_Y").removeAttr('checked');
            $("#RadioButton_CustomAcuteServicesPrescreens_RiskActionTakenCrisisRespiteBedWithoutPsych_Y").removeAttr('checked');
        }

        if ($("#CheckBox_CustomAcuteServicesPrescreens_RiskReferedToPrivateProvider").attr('checked')) {
            $("#TextBox_CustomAcuteServicesPrescreens_RiskReferedToPrivateProviderName").attr('disabled', false);

        }
        else {
            $("#TextBox_CustomAcuteServicesPrescreens_RiskReferedToPrivateProviderName").attr('disabled', true);
            $("#TextBox_CustomAcuteServicesPrescreens_RiskReferedToPrivateProviderName").val(" ");
        }

        if ($("#CheckBox_CustomAcuteServicesPrescreens_RiskReferedToOther").attr('checked')) {
            $("#TextBox_CustomAcuteServicesPrescreens_RiskReferedToOtherSpecify").attr('disabled', false);

        }
        else {
            $("#TextBox_CustomAcuteServicesPrescreens_RiskReferedToOtherSpecify").attr('disabled', true);
            $("#TextBox_CustomAcuteServicesPrescreens_RiskReferedToOtherSpecify").val(" ");
        }


    }
    catch (err) {
        LogClientSideException(err);
    }
}


function CalculateTotalScore() {
    try {
        var Total = 0;
        var ReceivingProgram = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanDetails] :selected").text();
        if (ReceivingProgram != '') {
            var array0 = parseInt(ReceivingProgram.charAt(0));
            Total = Total + array0;
        }

        var RiskSuicideHomicidePlanAvailability = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanAvailability] :selected").text();
        if (RiskSuicideHomicidePlanAvailability != '') {
            var array1 = parseInt(RiskSuicideHomicidePlanAvailability.charAt(0));
            Total = Total + array1;
        }

        var RiskSuicideHomicidePlanTime = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanTime] :selected").text();
        if (RiskSuicideHomicidePlanTime != '') {
            var array2 = parseInt(RiskSuicideHomicidePlanTime.charAt(0));
            Total = Total + array2;
        }

        var RiskSuicideHomicidePlanLethalityMethod = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomicidePlanLethalityMethod] :selected").text();
        if (RiskSuicideHomicidePlanLethalityMethod != '') {
            var array3 = parseInt(RiskSuicideHomicidePlanLethalityMethod.charAt(0));
            Total = Total + array3;
        }

        var RiskSuicideHomisideAttempts = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttempts] :selected").text();
        if (RiskSuicideHomisideAttempts != '') {
            var array4 = parseInt(RiskSuicideHomisideAttempts.charAt(0));
            Total = Total + array4;
        }

        var RiskSuicideHomisideIsolation = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideIsolation] :selected").text();
        if (RiskSuicideHomisideIsolation != '') {
            var array5 = parseInt(RiskSuicideHomisideIsolation.charAt(0));
            Total = Total + array5;
        }

        var RiskSuicideHomisideProbabilityTiming = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideProbabilityTiming] :selected").text();
        if (RiskSuicideHomisideProbabilityTiming != '') {
            var array6 = parseInt(RiskSuicideHomisideProbabilityTiming.charAt(0));
            Total = Total + array6;
        }

        var RiskSuicideHomisidePrecaution = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisidePrecaution] :selected").text();
        if (RiskSuicideHomisidePrecaution != '') {
            var array7 = parseInt(RiskSuicideHomisidePrecaution.charAt(0));
            Total = Total + array7;
        }

        var RiskSuicideHomisideActingToGetHelp = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActingToGetHelp] :selected").text();
        if (RiskSuicideHomisideActingToGetHelp != '') {
            var array8 = parseInt(RiskSuicideHomisideActingToGetHelp.charAt(0));
            Total = Total + array8;
        }

        var RiskSuicideHomisideFinalAct = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideFinalAct] :selected").text();
        if (RiskSuicideHomisideFinalAct != '') {
            var array9 = parseInt(RiskSuicideHomisideFinalAct.charAt(0));
            Total = Total + array9;
        }

        var RiskSuicideHomisideActiveForAttempt = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideActiveForAttempt] :selected").text();
        if (RiskSuicideHomisideActiveForAttempt != '') {
            var array10 = parseInt(RiskSuicideHomisideActiveForAttempt.charAt(0));
            Total = Total + array10;
        }

        var RiskSuicideHomisideSucideNote = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSucideNote] :selected").text();
        if (RiskSuicideHomisideSucideNote != '') {
            var array11 = parseInt(RiskSuicideHomisideSucideNote.charAt(0));
            Total = Total + array11;
        }

        var RiskSuicideHomisideOvertCommunication = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideOvertCommunication] :selected").text();
        if (RiskSuicideHomisideOvertCommunication != '') {
            var array12 = parseInt(RiskSuicideHomisideOvertCommunication.charAt(0));
            Total = Total + array12;
        }

        var RiskSuicideHomisideAllegedPurposed = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAllegedPurposed] :selected").text();
        if (RiskSuicideHomisideAllegedPurposed != '') {
            var array13 = parseInt(RiskSuicideHomisideAllegedPurposed.charAt(0));
            Total = Total + array13;
        }

        var RiskSuicideHomisideExpectationFatality = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideExpectationFatality] :selected").text();
        if (RiskSuicideHomisideExpectationFatality != '') {
            var array14 = parseInt(RiskSuicideHomisideExpectationFatality.charAt(0));
            Total = Total + array14;
        }

        var RiskSuicideHomisideConceptionOfMethod = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptionOfMethod] :selected").text();
        if (RiskSuicideHomisideConceptionOfMethod != '') {
            var array15 = parseInt(RiskSuicideHomisideConceptionOfMethod.charAt(0));
            Total = Total + array15;
        }

        var RiskSuicideHomisideSeriousnessOfAttempt = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideSeriousnessOfAttempt] :selected").text();
        if (RiskSuicideHomisideSeriousnessOfAttempt != '') {
            var array16 = parseInt(RiskSuicideHomisideSeriousnessOfAttempt.charAt(0));
            Total = Total + array16;
        }

        var RiskSuicideHomisideAttitudeLivingDying = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideAttitudeLivingDying] :selected").text();
        if (RiskSuicideHomisideAttitudeLivingDying != '') {
            var array17 = parseInt(RiskSuicideHomisideAttitudeLivingDying.charAt(0));
            Total = Total + array17;
        }

        var RiskSuicideHomisideConceptMedicalRescue = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideConceptMedicalRescue] :selected").text();
        if (RiskSuicideHomisideConceptMedicalRescue != '') {
            var array18 = parseInt(RiskSuicideHomisideConceptMedicalRescue.charAt(0));
            Total = Total + array18;
        }

        var RiskSuicideHomisideDegreePremeditation = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDegreePremeditation] :selected").text();
        if (RiskSuicideHomisideDegreePremeditation != '') {
            var array19 = parseInt(RiskSuicideHomisideDegreePremeditation.charAt(0));
            Total = Total + array19;
        }

        var RiskSuicideHomisideStress = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideStress] :selected").text();
        if (RiskSuicideHomisideStress != '') {
            var array20 = parseInt(RiskSuicideHomisideStress.charAt(0));
            Total = Total + array20;
        }

        var RiskSuicideHomisideCopingBehavior = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideCopingBehavior] :selected").text();
        if (RiskSuicideHomisideCopingBehavior != '') {
            var array21 = parseInt(RiskSuicideHomisideCopingBehavior.charAt(0));
            Total = Total + array21;
        }

        var RiskSuicideHomisideDepression = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideDepression] :selected").text();
        if (RiskSuicideHomisideDepression != '') {
            var array22 = parseInt(RiskSuicideHomisideDepression.charAt(0));
            Total = Total + array22;
        }

        var RiskSuicideHomisideResource = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideResource] :selected").text();
        if (RiskSuicideHomisideResource != '') {
            var array23 = parseInt(RiskSuicideHomisideResource.charAt(0));
            Total = Total + array23;
        }

        var RiskSuicideHomisideLifeStyle = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideLifeStyle] :selected").text();
        if (RiskSuicideHomisideLifeStyle != '') {
            var array24 = parseInt(RiskSuicideHomisideLifeStyle.charAt(0));
            Total = Total + array24;
        }

        var RiskSuicideHomisideMedicalStatus = $("select[id$=DropDownList_CustomAcuteServicesPrescreens_RiskSuicideHomisideMedicalStatus] :selected").text();
        if (RiskSuicideHomisideMedicalStatus != '') {
            var array25 = parseInt(RiskSuicideHomisideMedicalStatus.charAt(0));
            Total = Total + array25;
        }

        $('#TextBox_CustomAcuteServicesPrescreens_RiskSuicideHomisideTotalScore').val(Total);
        CreateAutoSaveXml('CustomAcuteServicesPrescreens', 'RiskSuicideHomisideTotalScore', Total);

    }
    catch (err) {
        LogClientSideException(err);
    }

}

function SetScreenSpecificValues() {
    try {
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
                                background: "white",
                                color: "black",
                                padding: "1px,1px,10px,1px",
                                top: "5px",
                                width:"20%" 
                            }
                        });

                    });
                }
            });
        });

    }

    catch (err) {
        LogClientSideException(err);
    }


}