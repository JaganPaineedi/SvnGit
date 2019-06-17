var Totalscore = 0;


function CalculateTotalScore(obj, TotalScoreLabelId, ControlGroup) {
    //debugger;
    var Control = $(obj)[0].id.split('_')[0];

    if (Control == "CheckBox" || Control == "RadioButton") {
    }
    else {
        Control = $(obj)[0].id.split('_')[3];
    }


    //For AIMS tab 
    if (ControlGroup == "tableAIMSIdDropDown") {
       // debugger;
        if (Control == "DropDownList" || Control == "RadioButton") {
            Totalscore = 0;
            Totalscore = DropDownScoreCalculation(ControlGroup);
            if ($('#RadioButton_CustomDocumentPsychiatricAIMSs_CurrentProblemsTeeth_Y').is(":checked")) {
                Totalscore = Totalscore + 1;
            }
            if ($('#RadioButton_CustomDocumentPsychiatricAIMSs_DoesPatientWearDentures_Y').is(":checked")) {
                Totalscore = Totalscore + 1;
            }
        }
    }

    $('[id$=' + TotalScoreLabelId + ']').text(Totalscore);
    CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'AIMSTotalScore', Totalscore);
}

function DropDownScoreCalculation(tableId) {
    //debugger;
    $("[id$='" + tableId + "']").find("[id*=DropDownList]").each(function() {
        //debugger;
        var Exclude = $(this).attr('Exclude');
        if (Exclude != "Exclude") {
            var Score = $(this).find('option:selected').text();
            if (Score != "") {
                // debugger;
                Totalscore = parseInt(Totalscore) + parseInt(Score);
            }
        }
    });
    return Totalscore;
}