var PanelMedicationListPrescribePage;

function onDeleteClick(sender, e) {
    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        Streamline.SmartClient.WebServices.ClientMedications.DeleteMedicationFromList(e.MedicationId, MedicationPrescribe.onSuccessfullDeletion, MedicationPrescribe.onFailure, e);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

var MedicationPrescribe = {
    AddItemInPreferredPharmacy: function (PreferredClientPharmacyId) {
        try {
            if (!PreferredClientPharmacyId)  //This is to check when the client Preferred pharmacy is seleted from the Pharmacy search pop up
            {
                PreferredClientPharmacyId = parent.document.getElementById('HiddenFieldPharmacyId').value;
            }
            var outerhtml;
            if ($("[id*=DropDownListPharmacies").length > 0) {
                outerhtml = ($("[id*=DropDownListPharmacies"))[0].outerHTML;
            }
            else {
                outerhtml = parent.$("[id*=DropDownListPharmacies")[0].outerHTML;
            }
            var itemsValues = outerhtml.substring(outerhtml.indexOf("itemsValue=") + 12, outerhtml.indexOf("'];"))

            if (parent.$("[id$=DropDownListPharmacies_I]")[0] != null) {
                //var list = parent.$("select[id*=DropDownListPharmacies]")[0];
                var list = parent.$("[id$=DropDownListPharmacies_I]")[0];
                var pharmacyid = parent.document.getElementById('HiddenFieldPharmacyId').value;
                var pharmacyName = parent.document.getElementById('HiddenFieldPharmacyNameAddress').value;
                var pharmacyFax = parent.document.getElementById('HiddenFieldPharmacyFaxNo').value;

               
                    if (!pharmacyName) {
                        pharmacyName = $("[id$=HiddenField_PharmaciesName]").val()
                    }
                    parent.$("[id$=DropDownListPharmacies_I]").val(pharmacyName);
                    if (PreferredClientPharmacyId > 0) {
                        parent.$("[id$=RadioButtonFaxToPharmacy]")[0].checked = true;
                        parent.$("[id$=RadioButtonPrintScript]")[0].checked = false;
                    }

                    parent.$("[id$=HiddenField_PharmaciesName]").val(pharmacyName);
                    parent.$("input[id*=HiddenFieldPharmacyId]").val(PreferredClientPharmacyId);
                    parent.$("input[id*=HiddenField_PharmaciesId]").val(PreferredClientPharmacyId);
                    if (itemsValues.search(PreferredClientPharmacyId) < 0) {
                    Streamline.SmartClient.WebServices.ClientMedications.SaveClientPharmacies(pharmacyid, MedicationPrescribe.onSaveClientPharmacies, MedicationPrescribe.onFailure)
                }
            }
        } catch (Ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, Ex);
        }
    },
    CloseButtonClick1: function () {
        try {
            parent.document.getElementById('HiddenFieldPharmacyId').value = '';
            Streamline.SmartClient.WebServices.ClientMedications.CloseClick1(MedicationPrescribe.onCloseSucceeded1, MedicationPrescribe.onFailure);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    EnableChartCopyPrinterDeviceLocation: function () {
        try {
            if ($("input[id*=CheckBoxPrintChartCopy]")[0].checked == true) {
                $("[id$=LabelChartCopyPrinter]")[0].style.display = 'block';
                $("[id*=DropDownListChartCopyPrinter]")[0].style.display = 'block';
            } else if ($("input[id*=CheckBoxPrintChartCopy]")[0].checked == false) {
                $("[id$=LabelChartCopyPrinter]")[0].style.display = 'none';
                $("[id*=DropDownListChartCopyPrinter]")[0].style.display = 'none';
            }
        } catch (ex) {
        }
    },
    EnableDisableOrderButton: function (buttonOrderID) {
        try {
            var objectButtonOrder;
            objectButtonOrder = document.getElementById(buttonOrderID);
            objectButtonOrder.disabled = true;
            MedicationPrescribe.ShowError('', false);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    EnablesDisable: function (buttonOrderID, RadioButtonFaxToPharmacyID, RadioButtonPrintScriptID, ObjectHiddenShowError) {
        try {
            var objectButtonOrder;
            objectButtonOrder = document.getElementById(buttonOrderID);

            if (document.getElementById(ObjectHiddenShowError).value != "")
                MedicationPrescribe.ShowError(document.getElementById(ObjectHiddenShowError).value, true);
            else
                MedicationPrescribe.ShowError("", false);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    fnShow1: function () {
        try {
            fnShowParentDiv("Processing...", 150, 25)
        } catch (Exception) {
            MedicationPrescribe.ShowError(Exception.description, true);
        }
    },
    //Below code was added by Vithobha for EPCS: #2 04.A1-Logical Controls of Prescription
    ControlledSubstancesList: function () {
        var strControlledSubstancesListValue = '';
        if ($('[id^=ControlledSubstance]').length > 0) {
          
            if ($('[id^=ControlledSubstance]:visible').length == $('[id^=ControlledSubstance]:checked').length) {

                $('[id^=ControlledSubstance]:checked').each(function () {
                    strControlledSubstancesListValue = $(this).attr('ClientMedicationScriptId') + ',' + strControlledSubstancesListValue;
                    $('[id*=HiddenFieldControlledSubstancesList]').val(strControlledSubstancesListValue);
                });
            }
            else {
                $('[id*=HiddenFieldControlledSubstancesListValidate]').val(0);
            }
        }
    },
    onChangeOrderClick: function () {
        try {
            //fnShow();//By Vikas Vyas On Dated April 04th 2008
            Streamline.SmartClient.WebServices.ClientMedications.PopulateDataOfMedicationList(MedicationPrescribe.onSuccessfullOrderChange, MedicationPrescribe.onFailure);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onChButtonClick: function (sender, e) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            Streamline.SmartClient.WebServices.ClientMedications.PopulateRowDataOfMedicationList(e.MedicationId, e.MethodName, MedicationPrescribe.onSuccessfullPopulation, MedicationPrescribe.onFailure);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },

    dialogForClose: function () {
        var answer = window.showModalDialog('YesNo.aspx?CalledFrom=Prescribe', 'YesNo', 'menubar : no;status : no;dialogHeight:178px;dialogWidth=423px;resizable:no;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
        if (answer == 'Y') {
            CallDeleteMedicationsButton();
            fnShow();
            if ($("input[id*=HiddenPageName]")[0].value == "FromDashBoard") {
                redirectToVerbalOrder('A');
            }
        }
    },

    onCloseSucceeded1: function (result, context) {
        try {

            if (result == true) {
                try {
                    MedicationPrescribe.dialogForClose();
                } catch (e) {
                }

            } else {
                return false;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008 
        }
    },
    onFailure: function (error) {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008 
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        } else {
            alert(error.get_message());
        }
    },
    onSaveClientPharmacies: function (result) {

    },
    onSuccessfullDeletion: function (result, context, methodname) {
        try {
            var table = document.getElementById(context.TableId);
            var row = document.getElementById(context.RowId);
            var exitFlag = false;
            while (row != null) {
                if (row.cells[0].className == "blackLine")
                    exitFlag = true;
                row.style.display = 'none';
                if (exitFlag)
                    break;
                row = table.rows(row.rowIndex + 1);
            }
            document.getElementById('HiddenFieldMedicationCount').value = result;
            if (result == -1 || result == 0)
                DisableOrderButton();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008       
        }
    },
    onSuccessfullPopulation: function (result, context, methodname) {
        try {
            var DrugOrderMethod = document.getElementById("txtButtonValue");
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008 
            redirectToOrderPage(DrugOrderMethod.value, result);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    openPharmacySearchForprint: function (DropDownPharmacies) {
        try {
            pharmacies = document.getElementById(DropDownPharmacies);
            parent.document.getElementById('HiddenPageName').value = 'MedicationsPrescribe';
            var DivSearch = parent.document.getElementById('DivSearch1');
            DivSearch.style.display = 'block';
            var iFrameSearch = parent.document.getElementById('iFrame1');
            iFrameSearch.src = 'PharmacySearch.aspx?';
            iFrameSearch.style.positions = 'absolute';
            iFrameSearch.style.left = '10px';
            iFrameSearch.style.width = '850px';
            iFrameSearch.style.height = '510px';
            iFrameSearch.style.top = '20px';
            iFrameSearch.style.scrollbars = 'yes';
            iFrameSearch.style.display = 'block';
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        return false;
    },
    onRefillPrinterDropDownSucceeded: function (result, context) {
        try {
            var printerDeviceLocationId = result.Second;
            var DropDown = context.DropDown;
            DropDown.innerHTML = "";
            DropDown.options[DropDown.length] = new Option("< Manual Selection >", "0", false, false);
            var table = result.First;
            if (table == null || table.rows == null || !table.rows)
                return;
            for (var i = 0; i < table.rows.length; i++) {
                optionItem = new Option(table.rows[i]["DeviceLabel"], table.rows[i]["PrinterDeviceLocationId"], false, false);
                DropDown.options[DropDown.length] = optionItem;
                if (table.rows[i]["PrinterDeviceLocationId"] == printerDeviceLocationId) {
                    DropDown.value = printerDeviceLocationId;
                }
            }
            document.getElementById('Control_ASP.usercontrols_medicationsprescribe_ascx_HiddenPrinterDeviceLocations').value = printerDeviceLocationId;
        } catch (Ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, Ex);
        }
    },
    onSuccessfullOrderChange: function (result, context, methodname) {
        try {
            
            var DrugOrderMethod = document.getElementById("txtButtonValue");
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008 
            redirectToOrderPage(DrugOrderMethod.value);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    RefillPrinterDropDown: function (DropDownPrinter, DropDownLocation) {
        try {
            var dropDownLocation = document.getElementById(DropDownLocation);
            var dropDownPrinter = document.getElementById(DropDownPrinter);
            var selectedValue = dropDownLocation.options[dropDownLocation.selectedIndex].value;
            $("[id$=HiddenFieldPrescribingLocation]").val(selectedValue);
            var context = new Object();
            context.DropDown = dropDownPrinter;
            context.SelectedValue = selectedValue;
            Streamline.SmartClient.WebServices.ClientMedications.FillPrinterDropDown(selectedValue, MedicationPrescribe.onRefillPrinterDropDownSucceeded, MedicationPrescribe.onFailure, context)
        } catch (Ex) {
        }
    },
    SetPrintChartCopy: function (RadioButtonFaxToPharmacy, CheckBoxPrintChartCopy, _strPrintChartCopy) {
        try {
            if (document.getElementById(RadioButtonFaxToPharmacy).checked == true && _strPrintChartCopy.toUpperCase() == "TRUE") {
                document.getElementById(CheckBoxPrintChartCopy).checked = true;
                MedicationPrescribe.EnableChartCopyPrinterDeviceLocation();
            } else {
                document.getElementById(CheckBoxPrintChartCopy).checked = false;
                MedicationPrescribe.EnableChartCopyPrinterDeviceLocation();
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    SetPrinterDeviceLocationsId: function (DropDownListPrinterDeviceLocations) {
        try {
            var DropDownListPrinterDeviceLocations = document.getElementById(DropDownListPrinterDeviceLocations);
            var printerDeviceLocationId = DropDownListPrinterDeviceLocations.options[DropDownListPrinterDeviceLocations.selectedIndex].value;
            document.getElementById('Control_ASP.usercontrols_medicationsprescribe_ascx_HiddenPrinterDeviceLocations').value = printerDeviceLocationId;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ShowError: function (ShowMessage, ShowImage) {
        var imageError = $('[id$=ImageError]');
        if (imageError.length < 1) imageError = $('[id$=ImgError]');
        var labelError = $('[id$=LabelErrorMessage]');
        if (labelError.length < 1) labelError = $('[id$=LabelError]');
        try {
            if (ShowImage == true) {
                if ($('[id$=tableErrorMessage]').length > 0 && $('[id$=DivErrorMessage]').length > 0) {
                    $('[id$=tableErrorMessage]')[0].style.display = 'block';
                    $('[id$=DivErrorMessage]')[0].style.display = 'block';
                }
                imageError[0].style.visibility = 'visible';
                document.documentElement.scrollTop = 0;
            } else {
                imageError[0].style.display = 'none';
            }
            labelError[0].innerText = ShowMessage;
        } catch (Err) {
            imageError[0].style.display = 'block';
            labelError[0].innerText = 'An Error Occured, Please Contact your System Administrator';
            return false;
        }
    },
    ShowGridErrorMessage: function (error) {
        try {
            var LabelGridErrorMessage = document.getElementById("Control_ASP.usercontrols_medicationsprescribe_ascx_PrescribeGridErrorMessage");
            var ImageGridError = document.getElementById("ImagePrescribeGridError");
            ImageGridError.style.display = 'block';
            ImageGridError.style.visibility = 'visible';
            LabelGridErrorMessage.innerText = error;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ValidInteger: function (control) {
        try {
            control.value = MedicationPrescribe.trim(control.value);
            if (!/\D/.test(control.value) == false) {
                control.value = '';
                control.focus();
            }
        }
        catch (ex) {

        }
    },
    trim: function (str) {
        var i, j, strText;
        i = 0;
        j = str.length - 1;
        str = str.split("");
        while (i < str.length) {
            if (str[i] == " ")
                str[i] = ""
            else
                break;
            i++;
        }
        while (j > 0) {
            if (str[j] == " ")
                str[j] = ""
            else
                break;
            j--;
        }
        return str.join("");
    },
    ValidateInputs: function (DropDownListPharmaciesID, DropDownListLocationsID, RadioButtonFaxToPharmacyID, RadioButtonPrintScriptID, DropDownListPrescriber) {
        try {
            //debugger;
            MedicationPrescribe.ShowError('', false);
            if ($("[id$=OrderHeader]").css('display') != 'none') {
                if ((document.getElementById(RadioButtonFaxToPharmacyID).checked == false) && (document.getElementById(RadioButtonPrintScriptID).checked == false)) {
                    MedicationPrescribe.ShowError('Please select either Print or Send Directly to Pharmacy ', true);
                    return false;
                }
                if (document.getElementById(RadioButtonFaxToPharmacyID).checked == true) {
                    //To check if Pharmacy and prescriber are EPCS
                    if(document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListPharmacies_I').value.indexOf('EPCS') != -1){
                    //if (document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListPharmacies_I').value.includes('EPCS') == true) {
                        $("[id$=HiddenFieldPharmacyPrescriber]").val('EPCS');
                        document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenFieldPharmacyPrescriber').value = 'EPCS';
                    }
                    if (($("[id$=DropDownListPharmacies_I]").length > 0)) {
                        if (($("[id$=DropDownListPharmacies_I]").val() == 'Select Pharmacy')) {
                            if ($("[id$=HiddenFieldRefillPharmacyId]").val() == '') {
                                MedicationPrescribe.ShowError('Please select Pharmacy', true);
                                return false;
                            }
                        }
                    }
                }
            }
            if ((document.getElementById(DropDownListLocationsID).selectedIndex == 0)) {
                //debugger;
                MedicationPrescribe.ShowError('Please select Prescribing Location', true);
                return false;
            }
            if (!$("select[id$=DropDownListDEANumber]").val()) {
                MedicationPrescribe.ShowError('Please select DEA Number', true);
                return false;
            }

            //debugger;
            var DEAState = document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListDEANumber").options[document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListDEANumber").selectedIndex].getAttribute("deastate");
            var PrescriptionState = document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListLocations").options[document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListLocations").selectedIndex].getAttribute("state")
            if (DEAState != PrescriptionState)
            {
                MedicationPrescribe.ShowError('DEA State does not match with Prescribing location State.', true);
                return false;
            }

           

            if (document.getElementById(DropDownListPrescriber).value == "" || document.getElementById(DropDownListPrescriber).value == "0") {
                MedicationPrescribe.ShowError('Please select Prescriber.', true);
                return false;
            } else {
                MedicationPrescribe.fnShow1();
                return true;
            }
            return true;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    }
};




