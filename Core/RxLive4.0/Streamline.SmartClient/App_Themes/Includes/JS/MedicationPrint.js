var returnValue=false;

function EnablesDisable(buttonOrderID, RadioButtonFaxToPharmacyID, RadioButtonPrintScriptID, CheckBoxFaxIncludeChartCopy, CheckBoxFaxDrugInformation, RadioButtonPrintChartCopy) {
    try {
        var objectButtonOrder;
        var objectCheckBoxFaxDrug;
        objectButtonOrder = document.getElementById(buttonOrderID);
        objectCheckBoxFaxDrug = document.getElementById(CheckBoxFaxDrugInformation);


        if ((document.getElementById(RadioButtonFaxToPharmacyID).checked == true) || (document.getElementById(RadioButtonPrintScriptID).checked == true) || (document.getElementById(RadioButtonPrintChartCopy).checked == true)) {
            objectButtonOrder.disabled = false;
        }
        else {
            objectButtonOrder.disabled = true;
        }

        if ((document.getElementById(RadioButtonFaxToPharmacyID).checked == true) && (document.getElementById(CheckBoxFaxIncludeChartCopy).checked == true)) {
            objectCheckBoxFaxDrug.disabled = false;
        }
        else {
            objectCheckBoxFaxDrug.disabled = true;
        }
        if (document.getElementById(RadioButtonFaxToPharmacyID).checked == true) {
            $("[id$=HiddenFieldReprintAllowed]").val('F');
        }
        if (document.getElementById(RadioButtonPrintScriptID).checked == true) {
            $("[id$=HiddenFieldReprintAllowed]").val('P');
        }
        if (document.getElementById(RadioButtonPrintChartCopy).checked == true) {
            $("[id$=HiddenFieldReprintAllowed]").val('C');
        }

    }
    catch (Err) {
        var msg = Err.message;
        //     alert(Err.message);
    }

}


function ValidateInputsPrint(DropDownListPharmaciesID, RadioButtonFaxToPharmacyID, RadioButtonPrintScriptID, DropDownListScriptReasonsID, RadioButtonPrintChartCopy) {
    try {
        ShowError('', false);
        if ((document.getElementById(RadioButtonFaxToPharmacyID).checked == false) && (document.getElementById(RadioButtonPrintScriptID).checked == false) && (document.getElementById(RadioButtonPrintChartCopy).checked == false)) {
            ShowError('Please select either Print or Fax to Pharmacy', true);
            return false;
        }
        //Confirm if Fax to Pharmacy is selected then user had selected Pharmacy also
        if (document.getElementById(RadioButtonFaxToPharmacyID).checked == true) {
            if ((document.getElementById(DropDownListPharmaciesID).selectedIndex <= 0)) {
                ShowError('Please select Pharmacy', true);
                return false;
            }
        }
        //Confirm that Script Reason is selected
        if ((document.getElementById(DropDownListScriptReasonsID).selectedIndex == 0) || (document.getElementById(DropDownListScriptReasonsID).selectedIndex == -1)) {
            ShowError('Please Select Script Reason', true);
            return false;
        }
        else {
            //Added by Loveena in ref to Task#3233-2.3 Order Details / Print Medication Order Dialog Changes
            var ClientMedicationScriptId = 0;
            var Method = '';
            if ($("[id$=HiddenFieldLatestClientMedicationScriptId]").val() != "")
                ClientMedicationScriptId = $("[id$=HiddenFieldLatestClientMedicationScriptId]").val();
            if ($("[id$=HiddenFieldReprintAllowed]").val() != "")
                Method = $("[id$=HiddenFieldReprintAllowed]").val();                            
            Streamline.SmartClient.WebServices.ClientMedications.ReprintAllowed(ClientMedicationScriptId, Method, OnSuccessReprintAllowed, onFailure);
//            fnShow1();
            //            return true;            
            return false;
        }

    }
    catch (Err) {
        alert(Err.message());

    }

}
//Added by Loveena in ref to Task#3233-2.3 Order Details / Print Medication Order Dialog Changes
function OnSuccessReprintAllowed(result) {
    $("[id$=LabelDenialReason]")[0].innerText = '';
    if (result.tables[0].rows[0]["ReprintAllowed"].toString() == "Y") {
        $("[id$=anchorOk]")[0].click();       
    }
    else if (result.tables[0].rows[0]["ReprintAllowed"].toString() == "N") {
    $("[id$=LabelDenialReason]")[0].innerText = result.tables[0].rows[0]["ReprintDeniedReason"].toString();
    }
}

function ShowError(ShowMessage, ShowImage) {
    try {
        if (ShowImage == true) {
            document.getElementById('ImgError').style.visibility = 'visible';
            document.documentElement.scrollTop = 0;
        }
        else {
            document.getElementById('ImgError').style.visibility = 'hidden';
        }
        document.getElementById('LabelError').innerText = ShowMessage;

    }
    catch (Err) {

        document.getElementById('ImgError').style.visibility = 'visible';
        document.getElementById('LabelError').innerText = 'An Error Occured, Please Contact your System Administrator';
        return false;
    }
}

function closeDiv() {
    try {
        parent.$("#DivSearch").css('display', 'none');
        fnHideParda();
        parent.window.FillGridScriptHistory();
    }
    catch (ex) {
        alert(ex.message);
    }
}
//Description:Used to check/uncheck faxtopharmacy radio button as per task#2640
//Author:Pradeep
//CreatedOn:25 Nov 2009
function CheckUncheckFaxToPharmaciesRadioButton(DropDownListPharmacies, RadioFaxToPharmacies, RadioPrint) {
    try {
        var dropDownListPharmacies = document.getElementById(DropDownListPharmacies);
        var radioFaxToPharmacies = document.getElementById(RadioFaxToPharmacies);
        var radioPrint = document.getElementById(RadioPrint);
        var selectedIndex = dropDownListPharmacies.selectedIndex;
        if (selectedIndex == 0 || selectedIndex == -1) {
            radioFaxToPharmacies.checked = false;
            radioPrint.checked = true;
        }
        else {
            radioFaxToPharmacies.checked = true;
            radioPrint.checked = false;
            //Ref to Task#2647
            document.getElementById('ButtonOk').disabled = false;
        }

    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function fnHideParda() {
    
}