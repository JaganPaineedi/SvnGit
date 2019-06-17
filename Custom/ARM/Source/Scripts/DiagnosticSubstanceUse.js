//Author : Jagdeep Hundal
//Purpose : Handel SubstanceUse process For Diagnostic Assessment.

var extractYear;


//Function Added by Jagdeep  in ref to Task#23. TO Check uncheck SubstanceUse radio button.

function CheckUncheckSubstanceRadioButtons(feildName, checked) {

    if (feildName != null) {
        if (checked == true) {
            $('#RadioButton_CustomDocumentDiagnosticAssessments_' + feildName + '_Y').attr("checked", true);
            SetColumnValueInXMLNode(feildName, 'Y');
        }
        else {
            $('#RadioButton_CustomDocumentDiagnosticAssessments_' + feildName + '_N').attr("checked", true);
            SetColumnValueInXMLNode(feildName, 'N');
        }
    }
}

function SetColumnValueInXMLNode(colName, colvalue) {

    var customDocumentDiagnosticAssessments = "";
    customDocumentDiagnosticAssessments = $("CustomDocumentDiagnosticAssessments", AutoSaveXMLDom);

    if (customDocumentDiagnosticAssessments.length > 0) {
        var documentVersionId = $('DocumentVersionId', customDocumentDiagnosticAssessments).text();
        SetColumnValueInXMLNodeByKeyValue('CustomDocumentDiagnosticAssessments', 'DocumentVersionId', documentVersionId, colName, colvalue, AutoSaveXMLDom[0]);
        parent.CreateUnsavedInstanceOnDatasetChange();
    }

}



//Function Added by Jagdeep  in ref to Task#23. TO show/hide SubstanceUse grid.

function ShowHideSubstance(dom) {
   var xmlDom = $("CustomDocumentDiagnosticAssessments", dom);
    if (xmlDom.length > 0) {
        var years = $("clientAge", dom).text();

        var indexOfYear = years.indexOf('Y');
        extractYear = '';
        if (indexOfYear == 0)
            indexOfYear = years.indexOf('M');
        if (indexOfYear > 0) {
            extractYear = years.substring(0, indexOfYear);
        }
        else {
            extractYear = years;
        }

        if (parseInt(extractYear) > 10) {
            $("#Table_HistorySubstanceUse").hide();
            $("#Table_Substance").show();
            $("#Table_SubUseTopSec").show();
            $("#Table_SubUseBotSec").show();
        }
        else {
            $("#Table_HistorySubstanceUse").show();
            $("#Table_Substance").hide();
            $("#Table_SubUseTopSec").show();
            $("#Table_SubUseBotSec").show();
        }
    }
}
//Function Added by Jagdeep  in ref to Task#23. TO show/hide SubstanceUse contents.


function ShowHideSubstanceContent(TabName) {

    if (TabName != null) {
        if (TabName == 'Adult_Tab') {
            ShowHideSubContent("#Table_ClientReportSubstanceUse", true);
            ShowHideSubContent("#Table_HisSubReportResultsTop", true);
            ShowHideSubContent("#Table_HisSubReportResultsBot", true);
            ShowHideSubContent("#TR_HisSuDastScore", true);
            ShowHideSubContent("#Table_HistorySubstanceUse", false);
        }
        else if (TabName == 'Minors_Tab') {
            ShowHideSubContent("#Table_ClientReportSubstanceUse", false);
            ShowHideSubContent("#Table_HisSubReportResultsTop", false); //Modified by Maninder : true to false
            ShowHideSubContent("#Table_HisSubReportResultsBot", false); //Modified by Maninder : true to false
            ShowHideSubContent("#TR_HisSuDastScore", false);
            if (parseInt(extractYear) >=11) {
                ShowHideSubContent("#Table_SubUseTopSec", true);
                ShowHideSubContent("#Table_SubUseBotSec", true);
                ShowHideSubContent("#Table_HistorySubstanceUse", true);   //Added by Maninder
                ShowHideSubContent("#Table_Substance", true); 
            }
            else {
                ShowHideSubContent("#Table_SubUseTopSec", true);
                ShowHideSubContent("#Table_SubUseBotSec", true);
                ShowHideSubContent("#Table_HistorySubstanceUse", true);  //Added by Maninder
                ShowHideSubContent("#Table_Substance", false); 
            }

        }
        else if (TabName == 'Childhood_Tab' || TabName == 'EAP_Tab') {
            if (TabName == 'Childhood_Tab') {
                if (parseInt(extractYear) >= 11) {
                    ShowHideSubContent("#Table_SubUseTopSec", true);
                    ShowHideSubContent("#Table_SubUseBotSec", true);
                    ShowHideSubContent("#Table_HistorySubstanceUse", true);   //Added by Maninder
                    ShowHideSubContent("#Table_Substance", true); 
                }
                else {
                    ShowHideSubContent("#Table_SubUseTopSec", true);
                    ShowHideSubContent("#Table_SubUseBotSec", true);
                    ShowHideSubContent("#Table_HistorySubstanceUse", true);  //Added by Maninder
                    ShowHideSubContent("#Table_Substance", false); 
                }
                //ShowHideSubContent("#Table_Substance", false);
            }
            if (TabName == 'EAP_Tab') {
                ShowHideSubContent("#Table_SubUseTopSec", true); // Modify by jagdeep change false to true as per task #56(Harbor Diagnostic Assessment: EAP Substance Use-	SmartcareWeb Phase 3 Development)
                ShowHideSubContent("#Table_SubUseBotSec", true); // Modify by jagdeep change false to true as per task #56(Harbor Diagnostic Assessment: EAP Substance Use-	SmartcareWeb Phase 3 Development)
                ShowHideSubContent("#Table_HistorySubstanceUse", true); // Modify by jagdeep change false to true as per task #56(Harbor Diagnostic Assessment: EAP Substance Use-	SmartcareWeb Phase 3 Development)
                if (parseInt(extractYear) > 10) {
                    ShowHideSubContent("#Table_Substance", true);   //Added by Maninder
                }
                else {
                    ShowHideSubContent("#Table_Substance", false);  //Added by Maninder
                }
            }
            ShowHideSubContent("#Table_ClientReportSubstanceUse", false);
            ShowHideSubContent("#Table_HisSubReportResultsTop", false);
            ShowHideSubContent("#Table_HisSubReportResultsBot", false);
            ShowHideSubContent("#TR_HisSuDastScore", false);
        }

    }

}

//}
//Function Added by Jagdeep  in ref to Task#23. TO set content value of SubstanceUse.
function ShowHideSubContent(TagName, ShowHide) {

    if (TagName != null) {
        if (ShowHide == true) {
            $(TagName).attr("style", "display:block");
        }
        else {
            $(TagName).attr("style", "display:none");
        }
    }

}

function GetAssessmentType() {
    if ($("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_A").is(":checked")) {
        ShowHideSubstanceContent('Adult_Tab');
    }
    if ($("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_M").is(":checked")) {
        ShowHideSubstanceContent('Minors_Tab');
    }
    if ($("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_E").is(":checked")) {
        ShowHideSubstanceContent('EAP_Tab');
    }
    if ($("#RadioButton_CustomDocumentDiagnosticAssessments_TypeOfAssessment_C").is(":checked")) {
        ShowHideSubstanceContent('Childhood_Tab');
    }
}

