var thisMedicationRowStrengthId;
var EndDate;
var XmlHttp;
var PanelMedicationListNonOrder = "";
var LabelErrorMessage = "";

//Code Added By Loveena in Ref to Task#72 to move Label Error Messages
var LabelGridErrorMessage = "";

var DigitsAfterDecimal = 2;
var DigitsBeforeDecimal = 10;

/// <summary>
/// Author Rishu Chopra
/// create xmlhttp object
/// </summary>

function CreateXmlHttp() {
    try {
        XmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
        Browser = "IE";
    } catch (e) {
        try {
            XmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            Browser = "IE";
        } catch (oc) {
            XmlHttp = null;
        }
    }
    if (!XmlHttp && typeof XMLHttpRequest != "undefined") {
        XmlHttp = new XMLHttpRequest();
        Browser = "FX";
    }
}

function validateCharacters(strValue) {
    /************************************************
    DESCRIPTION: Validates that a string doesnt have 
    numeric or special characters

    PARAMETERS:
    strValue - String to be tested for validity

    RETURNS:
    True if valid, otherwise false.

    *************************************************/
    //var objRegExp  = /^[\w\.\']{2,}([\s][\w\.\']{2,})+$/;
    //var objRegExp  = /(^-?\d\d*$)/
    //var objRegExp  = /[a-zA-Z]/;
    //[^a-zA-Z]+/; //[^d][a-zA-Z][^d]/

    //    if(validateInteger(strValue)==false)
    //    {
    var NewStrValue = strValue.replace(/[^ a-zA-Z0-9._,&#\''\-()]/g, '');

    //alert('strValue=='+strValue);
    if (NewStrValue != strValue) {
        return false;
    }
    if (NewStrValue.indexOf('<') > 0 || NewStrValue.indexOf('>') > 0 || (NewStrValue.indexOf('&') == 0 && NewStrValue.indexOf('#') == 1) || (NewStrValue.indexOf('&') == 1 && NewStrValue.indexOf('#') == 0) || NewStrValue.indexOf('&&&&') >= 0 || NewStrValue.indexOf('&#') >= 0 || NewStrValue.indexOf('&&') >= 0)
        return false;

    //    }
    //    else
    //        return false;

}

/// <summary>
/// Author Rishu Chopra
/// It is used to close ClientMedicationDrug popup by clicking close button.
/// </summary>

function closeDiv() {
    try {
        $("#DivSearch").css('display', 'none');
        fnHideParda();
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function CalShow(ImgCalID, TextboxID) {
    try {
        Calendar.setup({
            inputField: TextboxID,
            ifFormat: "%m/%d/%Y",
            showsTime: false,
            button: ImgCalID,
            step: 1
        });
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function onDAWClick(sender, e) {
    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        Streamline.SmartClient.WebServices.ClientMedications.UpdateDAW(e.MedicationId, sender.target.checked, ClientMedicationNonOrder.onDAWSucceeded, ClientMedicationNonOrder.onFailure, sender);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function onAcknowledgeClick(sender, e) {
    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        Streamline.SmartClient.WebServices.ClientMedications.AcknowledgeInteraction(e.MedicationId, e.ClickType, ClientMedicationNonOrder.AcknowledgeInteractionSucceeded, ClientMedicationNonOrder.onFailure, sender);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
    return false;
}

function FillRXSource(ddlRXSource) {
    try {
        fnShow();
        var context = ddlRXSource;
        Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.FillRXSource(onObtainedSucceeded, onFailure, context);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function onObtainedSucceeded(result, context, methodname) {
    try {
        context.innerHTML = "";
        if (result == null || result.rows == null || !result.rows)
            return;
        context.options[context.length] = new Option("", "", false, false);
        for (var i = 0; i < result.rows.length; i++) {
            optionItem = new Option(result.rows[i]["CodeName"], result.rows[i]["GlobalCodeId"], false, false);
            context.options[context.length] = optionItem;
        }

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    } finally {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    }
}

function onRXSource() {
    try {
        document.getElementById('buttonInsert').disabled = false;
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function doFillHiddenFieldListRXSource(DropDownListRXSource, HiddenRXSource) {
    document.getElementById(HiddenRXSource).value = DropDownListRXSource.options[DropDownListRXSource.selectedIndex].value;
}

var ClientMedicationNonOrder = {
    ClientMedicationInstructionRow: function () {
        this.StrengthId;
        this.Unit;
        this.Schedule;
        this.Quantity;
        this.StartDate;
        this.EndDate;
        this.Instruction;
        this.RowIdentifierCMI;
        this.StrengthRowIdentifier;
        this.PotencyUnitCode;
        this.NoOfDaysOfWeek;
    },
    ClientMedicationRow: function () {
        this.MedicationNameId;
        this.DrugPurpose;
        this.DSMCode;
        this.DSMNumber;
        this.ClientId;
        this.PrescriberName;
        this.PrescriberId;
        this.SpecialInstructions;
        this.RowIdentifier;
        this.CreatedBy;
        this.CreatedDate;
        this.ModifiedBy;
        this.ModifiedDate;
        this.MedicationName;
        this.DAW;
        this.RowIdentifierCM;
        this.DesiredOutcome;
        this.Comments;
        this.OffLabel;
        this.IncludeCommentOnPrescription; //Modified by Loveena in ref to Task#32
        this.RXSource;
    },
    FillStrength: function (intMedicationNameId, ddlStrength, selectedValue, UnitObject, causeChangeEvent) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            if (intMedicationNameId == null || ddlStrength == null) {
                fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
                return;
            }
            var context = new Object();
            context.DropDown = ddlStrength;
            context.SelectedValue = selectedValue;
            context.Unit = UnitObject;
            context.CauseChangeEvent = causeChangeEvent;
            context.MedicationNameId = intMedicationNameId;
            Streamline.SmartClient.WebServices.ClientMedications.GetMedicationStrength(intMedicationNameId, ClientMedicationNonOrder.onStrengthSucceeded, ClientMedicationNonOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onStrengthSucceeded: function (result, context, methodname) {
        try {
            var DropDown = context.DropDown;
            DropDown.innerHTML = "";
            if (result == null || result.length <= 0)
                return;
            DropDown.options[DropDown.length] = new Option("", "-1");
            for (var i = 0; i < result.length; i++) {
                optionItem = new Option(result[i]["Strength"], result[i]["MedicationId"], false, false);
                optionItem.setAttribute("MedicationId", result[i]["MedicationId"]);
                optionItem.setAttribute("PotencyUnitCode", result[i]["PotencyUnitCode"]);
                optionItem.setAttribute("dir", "ltr");
                DropDown.options[DropDown.length] = optionItem;
            }
            if (context.SelectedValue) {
                DropDown.value = context.SelectedValue;
                if (context.Unit)
                    ClientMedicationNonOrder.FillUnit(DropDown, context.Unit.DropDown.id, context.Unit.SelectedValue);
            }
            if (context.CauseChangeEvent) {
                $(DropDown).change();
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv();
            $(document).trigger("MedicationNonOrderServiceEvent", ["StrengthSucceeded"]); // Added 5/21/2015 by Jason Steczynski, Philhaven - Customization Issues Tracking Task #1285
        }
    },
    CloseButtonClick: function () {
        try {

            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            Streamline.SmartClient.WebServices.ClientMedications.CloseClick(ClientMedicationNonOrder.onCloseSucceeded, ClientMedicationNonOrder.onFailure);

        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    dialogForClose: function () {
        var answer = window.showModalDialog('YesNo.aspx?CalledFrom=Nonorder', 'YesNo', 'menubar : no;status : no;dialogHeight:178px;dialogWidth=423px;resizable:no;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
        if (answer == 'Y') {
            if (LabelErrorMessage.innerText == "") {
                if ($("[id$=HiddenCancelYes]").length > 0)
                    $("[id$=HiddenCancelYes]").val("Yes");
                CallUpdateButton();
            }
        }
        else {
            redirectToManagementPage();
        }
    },
    onCloseSucceeded: function (result, context) {
        try {
            if (result == true) {
                try {
                    ClientMedicationNonOrder.dialogForClose();
                } catch (e) {
                }
            } else {
                redirectToManagementPage();
                return false;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv();
        }
    },
    FillDxPurpose: function (ddlDxPurpose) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008 
            var context = ddlDxPurpose;
            Streamline.SmartClient.WebServices.ClientMedications.FillDxPurpose(ClientMedicationNonOrder.onDxPurposeSucceeded, ClientMedicationNonOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onDxPurposeSucceeded: function (result, context, methodname) {
        try {
            context.innerHTML = "";
            if (result == null || result.rows == null || !result.rows)
                return;
            context.options[context.length] = new Option("", "-1", false, false);
            for (var i = 0; i < result.rows.length; i++) {
                optionItem = new Option(result.rows[i]["DSMDescription"], result.rows[i]["DxId"], false, false);
                optionItem.setAttribute("DSMNumber", result.rows[i]["DSMNumber"]);
                optionItem.setAttribute("DSMCode", result.rows[i]["DSMCode"]);
                context.options[context.length] = optionItem;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    FillPrescriber: function (ddlPrescriber) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var context = ddlPrescriber;
            Streamline.SmartClient.WebServices.ClientMedications.FillPrescriber(ClientMedicationNonOrder.onPrescriberSucceeded, ClientMedicationNonOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onPrescriberSucceeded: function (result, context, methodname) {
        try {
            context.innerHTML = "";
            if (result == null || result.rows == null || !result.rows)
                return;
            context.options[context.length] = new Option("", "", false, false);
            for (var i = 0; i < result.rows.length; i++) {
                optionItem = new Option(result.rows[i]["StaffNameWithDegree"], result.rows[i]["Staffid"], false, false);
                context.options[context.length] = optionItem;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    FillScheduled: function (ddlSchedule, selectedValue) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var context = new Object();
            context.DropDown = ddlSchedule;
            context.SelectedValue = selectedValue;
            Streamline.SmartClient.WebServices.ClientMedications.FillSchedule(ClientMedicationNonOrder.onScheduledSucceeded, ClientMedicationNonOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onScheduledSucceeded: function (result, context, methodname) {
        try {
            var DropDown = context.DropDown;
            DropDown.innerHTML = "";
            if (result == null || result.length <= 0)
                return;
            DropDown.options[DropDown.length] = new Option("", "-1", false, false);
            for (var i = 0; i < result.length; i++) {
                optionItem = new Option(result[i]["CodeName"], result[i]["GlobalCodeId"], false, false);
                optionItem.setAttribute("ExternalCode1", result[i]["ExternalCode1"]);
                DropDown.options[DropDown.length] = optionItem;
            }
            if (context.SelectedValue) {
                DropDown.value = context.SelectedValue;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
            $(document).trigger("MedicationNonOrderServiceEvent", ["ScheduledSucceeded"]); // Added 5/21/2015 by Jason Steczynski, Philhaven - Customization Issues Tracking Task #1285
        }
    },
    FillPotencyUnitCodes: function (medicationNameId, ddlPotencyUnitCodes, selectedValue) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var context = new Object();
            context.DropDown = ddlPotencyUnitCodes;
            context.SelectedValue = selectedValue;
            Streamline.SmartClient.WebServices.ClientMedications.FillPotencyUnitCodes(medicationNameId, ClientMedicationNonOrder.onFillPotencyUnitCodesSucceeded, ClientMedicationNonOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onFillPotencyUnitCodesSucceeded: function (result, context, methodname) {
        try {
            var DropDown = context.DropDown;
            DropDown.innerHTML = "";
            if (result == null || result.length <= 0)
                return;
            DropDown.options[DropDown.length] = new Option("", "-1", false, false);
            for (var i = 0; i < result.length; i++) {
                optionItem = new Option(result[i]["SmartCareRxCode"], result[i]["SureScriptsCode"], false, false);
                DropDown.options[DropDown.length] = optionItem;
            }
            if (context.SelectedValue) {
                DropDown.value = context.SelectedValue;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
            $(document).trigger("MedicationNonOrderServiceEvent", ["FillPotencyUnitCodesSucceeded"]); // Added 5/21/2015 by Jason Steczynski, Philhaven - Customization Issues Tracking Task #1285 
        }

    },
    onDxPurposeChange: function () {
        try {
            document.getElementById('buttonInsert').disabled = false;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onPrescriber: function () {
        try {
            document.getElementById('buttonInsert').disabled = false;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onUnitChange: function (rowIndex) {
        try {
            //Deleted on 5/21/2015 by Jason Steczyski, Philhaven - Customization Issues Tracking Task #1285: button enabled before all services are complete
            //document.getElementById('buttonInsert').disabled = false; 

            var context = new Object();
            context.rowIndex = rowIndex;
            var table = $("[id$=tableMedicationOrder]")[0];
            context.SelectedValue = "";
            var currentRow = table.rows[context.rowIndex];
            var dosage = 0;
            if (currentRow.cells[2].getElementsByTagName("input")[0].value != "")
                dosage = parseFloat(currentRow.cells[2].getElementsByTagName("input")[0].value);
            var schedule = currentRow.cells[4].getElementsByTagName("select")[0].value;           
            if (currentRow.cells[15].getElementsByTagName("input")[0].value == "N") {
                var pharmacyTextComboBox = document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value;
                if (pharmacyTextComboBox != null && pharmacyTextComboBox != "") {
                    context.SelectedValue = pharmacyTextComboBox;
                    $("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
                } else {
                    $("input[id$=HiddenFieldSelectedValue]").val("");
                }
                if (currentRow.cells[1].getElementsByTagName("select")[0].value > 0 && currentRow.cells[2].getElementsByTagName("input")[0].value > 0 && currentRow.cells[4].getElementsByTagName("select")[0].value > 0 && currentRow.cells[7].getElementsByTagName("input")[0].value > 0 && currentRow.cells[3].getElementsByTagName("select")[0].value > 0) {
                    for (j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (rowIndex != j) {
                            if (currentRow.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                if (newRow.cells[2].getElementsByTagName("input")[0].value > 0)
                                    dosage = dosage + parseFloat(newRow.cells[2].getElementsByTagName("input")[0].value);
                                schedule = schedule + "," + newRow.cells[4].getElementsByTagName("select")[0].value;
                            }
                        }
                    }
                    if (currentRow.cells[15].getElementsByTagName("input")[0].value == "Y") {
                        ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                        Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(currentRow.cells[1].getElementsByTagName("select")[0].value, dosage, schedule, currentRow.cells[7].getElementsByTagName("input")[0].value, ClientMedicationNonOrder.onDispenseQuantitySucceeded, onFailure, context);
                    }
                } else {
                    if (currentRow.cells[15].getElementsByTagName("input")[0].value == "Y") {
                        ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                    }
                }
            } else {
                if (currentRow.cells[15].getElementsByTagName("input")[0].value == "Y") {
					$("input[id$=HiddenFieldSelectedValue]").val("");
                    ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
					ClientMedicationNonOrder.callDispenseQntCalculateMethod(currentRow, rowIndex);
                }
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
	
    callDispenseQntCalculateMethod: function (currentRow, rowIndex)
    {
        try {
            var objRow = new Object();
            objRow.MedicationId = currentRow.cells[1].getElementsByTagName("select")[0];
            objRow.rowIndex = rowIndex;
            objRow.Schedule = currentRow.cells[4].getElementsByTagName("select")[0];
            objRow.Quantity = currentRow.cells[2].getElementsByTagName("input")[0];
            if (objRow.Quantity.value != "")
                dosage = parseFloat(objRow.Quantity.value);
            var schedule = objRow.Schedule.value;
            objRow.Units = currentRow.cells[3].getElementsByTagName("select")[0];
            objRow.StartDate = currentRow.cells[5].getElementsByTagName("input")[0];
            objRow.Days = currentRow.cells[7].getElementsByTagName("input")[0];
            objRow.Pharmacy = currentRow.cells[8].getElementsByTagName("input")[0];
            objRow.Sample = currentRow.cells[11].getElementsByTagName("input")[0];
            objRow.Stock = currentRow.cells[12].getElementsByTagName("input")[0];
            objRow.Refills = currentRow.cells[10].getElementsByTagName("input")[0];
            objRow.EndDate = currentRow.cells[13].getElementsByTagName("input")[0];

            //   if (CallingObjectId.indexOf("TextBoxQuantity") > 0 || CallingObjectId.indexOf("DropDownListSchedule") > 0 || CallingObjectId.indexOf("TextBoxDays") > 0)
            if (((Number.parseInvariant(objRow.Days.value) < 1) || (Number.parseInvariant(objRow.Days.value) > 365)) == false)
                ClientMedicationNonOrder.CalculatePharmacy(objRow);
        } catch (e) {
        }
    },
    onUnitBlur: function (Unit) {
        try {
            //Deleted on 5/21/2015 by Jason Steczyski, Philhaven - Customization Issues Tracking Task #1285: button enabled before all services are complete
            //document.getElementById('buttonInsert').disabled = false;
            ClientMedicationNonOrder.ManipulateRowValues(null, Unit);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onScheduleChange: function (rowIndex) {
        try {
            document.getElementById('buttonInsert').disabled = false;
            var context = new Object();
            context.rowIndex = rowIndex;
            var table = $("[id$=tableMedicationOrder]")[0];
            context.SelectedValue = "";
            var currentRow = table.rows[context.rowIndex];
            var dosage = 0;
            if (currentRow.cells[2].getElementsByTagName("input")[0].value != "")
                dosage = parseFloat(currentRow.cells[2].getElementsByTagName("input")[0].value);
            var schedule = currentRow.cells[4].getElementsByTagName("select")[0].value;
            if (currentRow.cells[15].getElementsByTagName("input")[0].value == "Y") {
                $("input[id$=HiddenFieldSelectedValue]").val("");
            }
            if (currentRow.cells[15].getElementsByTagName("input")[0].value == "N") {
                var pharmacyTextComboBox = document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value;
                if (pharmacyTextComboBox != null && pharmacyTextComboBox != "") {
                    context.SelectedValue = pharmacyTextComboBox;
                    $("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
                } else {
                    $("input[id$=HiddenFieldSelectedValue]").val("");
                }
                if (currentRow.cells[1].getElementsByTagName("select")[0].value > 0 && currentRow.cells[2].getElementsByTagName("input")[0].value > 0 && currentRow.cells[4].getElementsByTagName("select")[0].value > 0 && currentRow.cells[7].getElementsByTagName("input")[0].value > 0 && currentRow.cells[3].getElementsByTagName("select")[0].value > 0) {
                    for (j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (rowIndex != j) {
                            if (currentRow.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                if (newRow.cells[2].getElementsByTagName("input")[0].value > 0)
                                    dosage = dosage + parseFloat(newRow.cells[2].getElementsByTagName("input")[0].value);
                                schedule = schedule + "," + newRow.cells[4].getElementsByTagName("select")[0].value;
                            }
                        }
                    }
                    ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                    Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(currentRow.cells[1].getElementsByTagName("select")[0].value, dosage, schedule, currentRow.cells[7].getElementsByTagName("input")[0].value, ClientMedicationNonOrder.onDispenseQuantitySucceeded, ClientMedicationNonOrder.onFailure, context);
                } else {
                    ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                }
            } else {
                ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onStartDate: function (StartDate, rowIndex) {
        try {
            //Deleted on 5/21/2015 by Jason Steczyski, Philhaven - Customization Issues Tracking Task #1285: button enabled before all services are complete
            //document.getElementById('buttonInsert').disabled = false;
            var table = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_tableMedicationOrder');
            var row = table.rows[rowIndex];
            var Category = row.cells[12].getAttribute("MedicationCategory");
            if (Category == "2" && rowIndex > 0) {
                var previousrow = table.rows[0];
                var currentRowStartDate = new Date(row.cells[5].getElementsByTagName("input")[0].value);
                var prevoiusRowStartDate = new Date(previousrow.cells[5].getElementsByTagName("input")[0].value);
                currentRowStartDate = currentRowStartDate.format("MM/dd/yyyy");
                prevoiusRowStartDate = prevoiusRowStartDate.format("MM/dd/yyyy");
                if (currentRowStartDate != prevoiusRowStartDate) {
                    row.cells[5].getElementsByTagName("input")[0].focus();
                    document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_tableErrorMessage').style.display = 'block';
                    document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_DivErrorMessage').style.display = 'block';
                    document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_ImageError').style.display = 'block';
                    document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_ImageError').style.visibility = 'visible';
                    document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_LabelErrorMessage').innerText = "Not allowed to select different start dates for C2 medications";
                    return;
                } else {
                    document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_tableErrorMessage').style.display = 'none';
                    document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_DivErrorMessage').style.display = 'none';
                    document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_ImageError').style.display = 'none';
                }
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onEndDate: function () {
        try {
            //Deleted on 5/21/2015 by Jason Steczyski, Philhaven - Customization Issues Tracking Task #1285: button enabled before all services are complete
            //document.getElementById('buttonInsert').disabled = false;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onStrengthChange: function (obj, unit, unitValue, days, TopStartDate, startDate, textBoxQuantity, rowIndex) {
        try {

            // Added if statement 4/6/2015 change Jason Steczynski
            // Clear all elements in row if the strength is set to blank
            if ($(obj).val() == -1) {
                var $rowElements = $(obj).parent().siblings();
                $rowElements.find("input[type='text']").val("");
                $rowElements.find(".ddlist").val(-1);
            } else {
                var today = new Date();
                var rxStartDate = today.format("MM/dd/yyyy");
                document.getElementById(startDate).value = rxStartDate;
                var context = new Object();
                context.rowIndex = rowIndex;
                var table = $("[id$=tableMedicationOrder]")[0];
                var currentRow = table.rows[context.rowIndex];
                var hiddenDefaultPrescribingQuantity = document.getElementById("HiddenDefaultPrescribingQuantity").value;
                var textboxQuantity = document.getElementById(textBoxQuantity);
                if (textboxQuantity.value == '') {
                    textboxQuantity.value = hiddenDefaultPrescribingQuantity;
                }
                ClientMedicationNonOrder.FillUnit(obj, unit, unitValue);
                if ($get(days).value != "" && $get(days).value != null && $get(days).value != '') {

                } else {
                    $get(days).value = $get(days).getAttribute("MedicationDays");
                }
                ClientMedicationNonOrder.PotencyUnitCodeUpdate(table, rowIndex, "DropDownListStrength");

                //Deleted on 5/21/2015 by Jason Steczyski, Philhaven - Customization Issues Tracking Task #1285: button enabled before all services are complete
                //document.getElementById('buttonInsert').disabled = false;

                Streamline.SmartClient.WebServices.ClientMedications.CalculateAutoCalcAllow(currentRow.cells[1].getElementsByTagName("select")[0].value, ClientMedicationNonOrder.onAutoCalcAllowSucceeded, ClientMedicationNonOrder.onFailure, context);

            }



        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onPotencyUnitCodeChange: function (obj, rowId) {
        ClientMedicationNonOrder.PotencyUnitCodeUpdate($("[id$=tableMedicationOrder]")[0], rowId, "DropDownListPotencyUnitCode");
        return;
    },
    PotencyUnitCodeUpdate: function (htmlTable, currentRowId, event) {
        var pucList = [];
        for (var i = 0; i < htmlTable.rows.length; i++) {
            var potencyUnitCode = "";
            var row = htmlTable.rows[i];
            var sel = row.cells[1].getElementsByTagName("select")[0];
            var selPuc = row.cells[9].getElementsByTagName("select")[0];
            if (sel.selectedIndex > 0) {
                var medId = sel.options[sel.selectedIndex].getAttribute("MedicationId");
                for (var i2 = 0; i2 < pucList.length; i2++) {
                    if (pucList[i2].MedicationId == medId) {
                        potencyUnitCode = pucList[i2].PotencyUnitCode;
                        selPuc.value = potencyUnitCode;
                        selPuc.disabled = true;
                        break;
                    }
                }
                if (potencyUnitCode == "") {
                    selPuc.disabled = false;
                    if (i == currentRowId && event == "DropDownListPotencyUnitCode") {
                        potencyUnitCode = selPuc.value;
                    } else if (i != currentRowId && (event == "DropDownListStrength" || event == "DeleteRow" || event == "RefreshRow")) {
                        potencyUnitCode = selPuc.value;
                    } else {
                        potencyUnitCode = sel.options[sel.selectedIndex].getAttribute("PotencyUnitCode");
                        selPuc.value = potencyUnitCode;
                    }
                    pucList.push({ "MedicationId": medId, "PotencyUnitCode": potencyUnitCode });
                }
            }
        }
    },
    onAutoCalcAllowSucceeded: function (result, context) {
        try {
            var rowIndex = context.rowIndex;
            var table = $("[id$=tableMedicationOrder]")[0];
            var currentRow = table.rows[rowIndex];
            if (result.rows.length > 0) {
                currentRow.cells[15].getElementsByTagName("input")[0].value = result.rows[0]["AutoCalcAllowed"];
                for (var i = 0; i < table.rows.length; i++) {
                    var row = table.rows[i];
                    row.cells[8].getElementsByTagName("input")[0].disabled = false;
                }
                for (var i = 0; i < table.rows.length; i++) {
                    var row = table.rows[i];
                    for (var j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (row.cells[1].getElementsByTagName("select")[0].value != "-1") {
                            if (row.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value && row.cells[15].getElementsByTagName("input")[0].value == "N") {
                                if (j > i) {
                                    row.cells[8].getElementsByTagName("input")[0].disabled = true;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            var newContext = new Object();
            newContext.rowIndex = context.rowIndex;
            newContext.SelectedValue = "";
            var currentRow = table.rows[context.rowIndex];
            var dosage = 0;
            if (currentRow.cells[2].getElementsByTagName("input")[0].value != "")
                dosage = parseFloat(currentRow.cells[2].getElementsByTagName("input")[0].value);
            var schedule = currentRow.cells[4].getElementsByTagName("select")[0].value;         
            if (currentRow.cells[15].getElementsByTagName("input")[0].value == "N") {
                var pharmacyTextComboBox = document.getElementById("ComboBoxPharmacyDD_" + context.rowIndex).value;
                if (pharmacyTextComboBox != null && pharmacyTextComboBox != "") {
                    newContext.SelectedValue = pharmacyTextComboBox;
                    $("input[id$=HiddenFieldSelectedValue]").val(newContext.SelectedValue);
                } else {
                    $("input[id$=HiddenFieldSelectedValue]").val("");
                }
                if (currentRow.cells[1].getElementsByTagName("select")[0].value > 0 && currentRow.cells[2].getElementsByTagName("input")[0].value > 0 && currentRow.cells[4].getElementsByTagName("select")[0].value > 0 && currentRow.cells[7].getElementsByTagName("input")[0].value > 0 && currentRow.cells[1].getElementsByTagName("select")[0].value > 0 && currentRow.cells[3].getElementsByTagName("select")[0].value > 0) {
                    for (j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (rowIndex != j) {
                            if (currentRow.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                if (newRow.cells[2].getElementsByTagName("input")[0].value > 0)
                                    dosage = dosage + parseFloat(newRow.cells[2].getElementsByTagName("input")[0].value);
                                schedule = schedule + "," + newRow.cells[4].getElementsByTagName("select")[0].value;
                            }
                        }
                    }
                    ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + context.rowIndex, "#ComboBoxPharmacyDDList_" + context.rowIndex);
                    Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(currentRow.cells[1].getElementsByTagName("select")[0].value, dosage, schedule, currentRow.cells[7].getElementsByTagName("input")[0].value, ClientMedicationNonOrder.onDispenseQuantitySucceeded, ClientMedicationNonOrder.onFailure, newContext);
                } else {
                    ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + context.rowIndex, "#ComboBoxPharmacyDDList_" + context.rowIndex);
                }
            } else {
			 	$("input[id$=HiddenFieldSelectedValue]").val("");
                ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + context.rowIndex, "#ComboBoxPharmacyDDList_" + context.rowIndex);
				ClientMedicationNonOrder.callDispenseQntCalculateMethod(currentRow, rowIndex);          
            }
        } catch (e) {
        }
    },
    FillUnit: function (ddlStrength, ddlUnit, selectedValue) {
        try {
            if (ddlStrength.selectedIndex == null || ddlStrength.selectedIndex <= 0)
                return;
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var MedicationId = ddlStrength.options[ddlStrength.selectedIndex].getAttribute('MedicationId');
            var context = new Object();
            context.DropDown = document.getElementById(ddlUnit);
            context.SelectedValue = selectedValue;
            Streamline.SmartClient.WebServices.ClientMedications.FillUnit(MedicationId, ClientMedicationNonOrder.onUnitSucceeded, ClientMedicationNonOrder.onFailure, context);
            Streamline.SmartClient.WebServices.ClientMedications.C2C5Drugs(MedicationId, ClientMedicationNonOrder.onC2C5DrugSucceeded, ClientMedicationNonOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onC2C5DrugSucceeded: function (result, context, methodname) {
        try {
            try {
                _Row = context.DropDown.parentNode.parentNode;
                _Row.cells[12].setAttribute("MedicationCategory", "");
            } catch (e) {
            }
            if (result == null || result.rows == null || !result.rows)
                return;
            if (result.rows.length > 0) {
                _Row.cells[12].setAttribute("MedicationCategory", result.rows[0]["Category"]);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    onUnitSucceeded: function (result, context, methodname) {
        try {
            var DropDown = context.DropDown;
            DropDown.innerHTML = "";
            if (result == null || result.length <= 0)
                return;
            DropDown.options[DropDown.length] = new Option("", "-1", false, false);
            for (var i = 0; i < result.length; i++) {
                optionItem = new Option(result[i]["CodeName"], result[i]["GlobalCodeId"], false, false);
                DropDown.options[DropDown.length] = optionItem;
            }
            if (result.length == 1) {
                DropDown.selectedIndex = 1;
            }
            if (context.SelectedValue) {
                DropDown.value = context.SelectedValue;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    onFailure: function (error) {
        fnHideParentDiv();
        if (error.get_message() == "Session Expired" || error.get_message().indexOf('failed') > 0) {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        } else {
            alert(error.get_message());
        }
    },
    DeleateFromList: function (s, e) {
        sessionStorage.setItem('s', JSON.stringify(s));  
        sessionStorage.setItem('e', JSON.stringify(e));        
        var popupWindow = window.showModalDialog('YesNo.aspx?CalledFrom=MedicationListNonOrder', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
        if (popupWindow == 'Y') {
            if (e == undefined) {
                var s = JSON.parse(sessionStorage.s);
                var e = JSON.parse(sessionStorage.e);
            }
            try {
                fnShow(); //By Vikas Vyas On Dated April 04th 2008
                Streamline.SmartClient.WebServices.ClientMedications.DeleteClientMedication(e.MedicationId, ClientMedicationNonOrder.onDeleteButtonSucceeded, ClientMedicationNonOrder.onFailure, e);
            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
            }
        }
    },
    onDeleteButtonSucceeded: function (result, context, methodname) {
        try {
            if (result == true) {
                ClientMedicationNonOrder.GetMedicationList(PanelMedicationListNonOrder);
            }
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    RadioButtonParameters: function (e, TextBoxStartDate, TextboxDrug, TextBoxSpecialInstructions, DropDownListDxPurpose, DropDownListPrescriber, TableName, HiddenRowIdentifier, HiddenMedicationNameId, HiddenMedicationName, CheckBoxDispense, TextBoxDesiredOutcome, TextBoxComments, CheckBoxOffLabel, CheckboxIncludeOnPrescription, HiddenOrderPageCommentLabel, HiddenOrderPageCommentLabelIncludeOnPrescription, LabelCommentText, DropDownListRXSource) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var context = new Object();
            context.DateInitated = TextBoxStartDate;
            context.HiddenOrderPageCommentLabel = HiddenOrderPageCommentLabel;
            context.HiddenOrderPageCommentLabelIncludeOnPrescription = HiddenOrderPageCommentLabelIncludeOnPrescription;
            context.LabelCommentText = LabelCommentText;
            context.Drug = TextboxDrug;
            context.SpecialInstructions = TextBoxSpecialInstructions;
            context.DxPurpose = DropDownListDxPurpose;
            context.Prescriber = DropDownListPrescriber;
            context.Table = TableName;
            context.MedicationNameId = HiddenMedicationNameId;
            context.HiddenRowIdentifier = HiddenRowIdentifier;
            context.MedicationName = HiddenMedicationName;
            context.CheckBoxDispense = CheckBoxDispense;
            context.CheckboxIncludeOnPrescription = CheckboxIncludeOnPrescription;
            context.DesiredOutcome = TextBoxDesiredOutcome;
            context.Comments = TextBoxComments;
            context.CheckBoxOffLabel = CheckBoxOffLabel;
            context.RXSource = DropDownListRXSource;
            Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.RadioButtonClick(e.MedicationId, ClientMedicationNonOrder.onRadioButtonSucceeded, ClientMedicationNonOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onRadioButtonSucceeded: function (result, context, methodname) {
        try {
            if (result.tables[0].rows[0]["MedicationStartDate"] != null)
                document.getElementById(context.DateInitated).value = result.tables[0].rows[0]["MedicationStartDate"].format("MM/dd/yyyy");
            $("#ComboBoxDrugDD").val(result.tables[0].rows[0]["MedicationName"].toString()).attr('opid', result.tables[0].rows[0]["MedicationNameId"]);
            document.getElementById(context.MedicationNameId).value = result.tables[0].rows[0]["MedicationNameId"];
            if (result.tables[0].rows[0]["SpecialInstructions"] != null)
                document.getElementById(context.SpecialInstructions).value = result.tables[0].rows[0]["SpecialInstructions"];
            document.getElementById(context.DxPurpose).value = result.tables[0].rows[0]["DxId"];
            document.getElementById(context.Prescriber).value = result.tables[0].rows[0]["PrescriberId"];
            if (result.tables[0].rows[0]["PrescriberName"] != "" && result.tables[0].rows[0]["PrescriberId"] == null && result.tables[0].rows[0]["PrescriberName"] != null) {
                document.getElementById(context.Prescriber)[0].innerHTML = result.tables[0].rows[0]["PrescriberName"];
                document.getElementById(context.Prescriber)[0].value = result.tables[0].rows[0]["PrescriberName"];
            }
            document.getElementById(context.RXSource).value = result.tables[0].rows[0]["RXSource"];
            document.getElementById(context.HiddenRowIdentifier).value = result.tables[0].rows[0]["RowIdentifier"];
            document.getElementById(context.MedicationName).value = result.tables[0].rows[0]["MedicationName"];
            if (result.tables[0].rows[0]["DesiredOutcomes"] != null)
                document.getElementById(context.DesiredOutcome).value = result.tables[0].rows[0]["DesiredOutcomes"];
            if (result.tables[0].rows[0]["Comments"] != null)
                document.getElementById(context.Comments).value = result.tables[0].rows[0]["Comments"];
            if (result.tables[0].rows[0]["DAW"] == "Y") {
                document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_CheckBoxDispense').checked = true;
            } else {
                document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_CheckBoxDispense').checked = false;
            }
            if (result.tables[0].rows[0]["OffLabel"] == "Y") {
                document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_CheckBoxOffLabel').checked = true;
            } else {
                document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_CheckBoxOffLabel').checked = false;
            }
            if (result.tables[0].rows[0]["IncludeCommentOnPrescription"] == "Y") {

                document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_CheckboxIncludeOnPrescription').checked = true;
                document.getElementById(context.LabelCommentText).innerText = document.getElementById(context.HiddenOrderPageCommentLabelIncludeOnPrescription).value;
            } else {

                document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_CheckboxIncludeOnPrescription').checked = false;
                document.getElementById(context.LabelCommentText).innerText = document.getElementById(context.HiddenOrderPageCommentLabel).value;
            }
            if (result.tables[0].rows[0]["MedicationName"].toString() != "") {
                document.getElementById('ImgSearch').style.display = "block";
            }
            if (document.getElementById(context.DxPurpose).value != "") {
                document.getElementById('ImgSearchIcon').style.display = "block";
            }
            var table1 = document.getElementById(context.Table);
            if (result.tables[1] != undefined) {
                if (result.tables[1].rows.length > table1.rows.length)
                    ClientMedicationNonOrder.AddMedicationSteps('true', result);
                else
                    ClientMedicationNonOrder.FillMedicationRowsOnRadioClick(result);
            } else {
                ClientMedicationNonOrder.FillMedicationRowsOnRadioClick(result);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    ClearDrug: function (TextBoxStartDate, TextboxDrug, TextBoxSpecialInstructions, DropDownListDxPurpose, DropDownListPrescriber, LabelErrorMessage, TextBoxDesiredOutcome, TextBoxComments) {
        try {
            var today = new Date();
            var month = today.getMonth() + 1;
            var day = today.getDate();
            var year = today.getFullYear();
            var s = "/";
            ClientMedicationNonOrder.ClearDrugComboList("#ComboBoxDrugDD", "#ComboBoxDrugDDList");
            document.getElementById(TextBoxSpecialInstructions).value = "";
            document.getElementById(TextBoxDesiredOutcome).value = "";
            document.getElementById(TextBoxComments).value = "";
            document.getElementById(DropDownListDxPurpose).value = "";
            Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.ClearMedicationRow();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ClearTable: function (tbl) {
        try {
            var table = document.getElementById(tbl);
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                ClientMedicationNonOrder.ClearRow(row, true, i);
            }
            Streamline.SmartClient.WebServices.ClientMedications.ClearTemporaryDeletedRowsFlags(ClientMedicationNonOrder.onClearMedicationSucceeded, ClientMedicationNonOrder.onClearMedicationFailure);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onClearMedicationFailure: function (error, context) {
        fnHideParentDiv();
        if (error.get_message() == "Session Expired") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        return false;
    },
    onClearMedicationSucceeded: function (result, context, methodname) {
        try {
        } catch (e) {
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    ClearRow: function (row, clearCombo, rowIndex) {
        try {
            if (clearCombo)
                row.cells[1].getElementsByTagName("select")[0].innerHTML = "";
            else
                row.cells[1].getElementsByTagName("select")[0].value = -1;

            row.cells[2].getElementsByTagName("input")[0].value = "";
            if (clearCombo)
                row.cells[3].getElementsByTagName("select")[0].innerHTML = "";
            else
                row.cells[3].getElementsByTagName("select")[0].value = -1;
            if (clearCombo)
                row.cells[4].getElementsByTagName("select")[0].innerHTML = "";
            else
                row.cells[4].getElementsByTagName("select")[0].value = -1;
            row.cells[5].getElementsByTagName("input")[0].value = "";
            row.cells[7].getElementsByTagName("input")[0].value = "";
            ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
            row.cells[8].getElementsByTagName("input")[0].disabled = false;
            row.cells[9].getElementsByTagName("select")[0].value = -1;
            row.cells[10].getElementsByTagName("input")[0].value = "";
            row.cells[11].getElementsByTagName("input")[0].value = "";
            row.cells[12].getElementsByTagName("input")[0].value = "";
            row.cells[13].getElementsByTagName("input")[0].value = "";
            row.cells[14].getElementsByTagName("span")[0].value = 'undefined';
            row.cells[15].getElementsByTagName("input")[0].value = "";
            row.cells[16].getElementsByTagName("input")[0].value = "";
            row.cells[0].getElementsByTagName("img")[0].removeAttribute("MedicationId");
            row.cells[0].getElementsByTagName("img")[0].removeAttribute("MedicationInstructionId");
            $("input[id$=HiddenFieldSelectedValue]").val("");
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    FillMedicationRow: function (tbl, HiddenMedicationNameId, DropDownListDxPurpose, DropDownListPrescriber, TextBoxSpecialInstructions, HiddenMedicationName, LabelErrorMessage, DivErrorMessage, ImageError, PanelMedicationListNonOrder, HiddenRowIdentifier, TextBoxStartDate, LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, HiddenMedicationDAW, TextBoxDesiredOutcome, TextBoxComments, HiddenMedicationOffLabel, tableErrorrMessage, tableGridErrorMessage, HiddenFieldPrescription, HiddenPermitChangesByOtherUsers, DropDownListRXSource) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var context = new Object();
            context.Panel = PanelMedicationListNonOrder;
            context.tableErrorMessage = tableErrorrMessage;
            context.LabelErrorMessage = LabelErrorMessage;
            context.DivErrorMessage = DivErrorMessage;
            context.ImageError = ImageError;

            var objClientMedicationrow = new ClientMedicationNonOrder.ClientMedicationRow();
            var StartDate = null;
            if (document.getElementById(TextBoxStartDate).value.toString() != '')
                StartDate = document.getElementById(TextBoxStartDate).value;
            var docDropDownDxPurpose = document.getElementById(DropDownListDxPurpose);
            var docDropDownPrescriber = document.getElementById(DropDownListPrescriber);
            var docDropDownRXSource = document.getElementById(DropDownListRXSource);
            objClientMedicationrow.MedicationNameId = document.getElementById(HiddenMedicationNameId).value;
            var MedicationIdValue = objClientMedicationrow.MedicationNameId;
            var parseValue = parseInt(MedicationIdValue);
            objClientMedicationrow.DAW = document.getElementById(HiddenMedicationDAW).value;
            objClientMedicationrow.StartDate = StartDate; //Added By Chandan on 17th March 2008
            if (docDropDownDxPurpose.selectedIndex != "-1") {
                objClientMedicationrow.DrugPurpose = docDropDownDxPurpose.options[docDropDownDxPurpose.selectedIndex].innerText;
                objClientMedicationrow.DSMCode = docDropDownDxPurpose.options[docDropDownDxPurpose.selectedIndex].getAttribute('DSMCode');
                objClientMedicationrow.DxId = docDropDownDxPurpose.value;
            }
            if (docDropDownPrescriber.selectedIndex != "-1") {
                objClientMedicationrow.PrescriberName = docDropDownPrescriber.options[docDropDownPrescriber.selectedIndex].innerText;
                if (docDropDownDxPurpose.selectedIndex != "-1") {
                    objClientMedicationrow.DSMNumber = docDropDownDxPurpose.options[docDropDownDxPurpose.selectedIndex].getAttribute('DSMNumber');
                } else
                    objClientMedicationrow.DSMNumber = 0;
                if (docDropDownPrescriber.selectedIndex != 0)
                    objClientMedicationrow.PrescriberId = docDropDownPrescriber.value;
                else
                    objClientMedicationrow.PrescriberId = 0;
            }
            if (docDropDownRXSource.selectedIndex > 0) {
                objClientMedicationrow.RXSource = docDropDownRXSource.value;
            } else {
                objClientMedicationrow.RXSource = 0;
            }
            objClientMedicationrow.SpecialInstructions = document.getElementById(TextBoxSpecialInstructions).value;
            objClientMedicationrow.DesiredOutcome = document.getElementById(TextBoxDesiredOutcome).value;
            objClientMedicationrow.Comments = document.getElementById(TextBoxComments).value;
            objClientMedicationrow.OffLabel = document.getElementById(HiddenMedicationOffLabel).value;
            objClientMedicationrow.IncludeCommentOnPrescription = document.getElementById(HiddenFieldPrescription).value;
            objClientMedicationrow.MedicationName = document.getElementById(HiddenMedicationName).value;
            if (document.getElementById(HiddenRowIdentifier).value != "")
                objClientMedicationrow.RowIdentifierCM = document.getElementById(HiddenRowIdentifier).value;
            var saveAsTemplate = $('[id$=RadioButtonSaveTemplate]').attr('checked');
            var overrideTemplate = $('[id$=RadioButtonOverrideTemplate]').attr('checked');
            var saveTemplateFlag;
            switch (true) {
                case saveAsTemplate:
                    saveTemplateFlag = 'Save';
                    break;
                case overrideTemplate:
                    saveTemplateFlag = 'Override';
                    break;
                default:
                    saveTemplateFlag = 'None';
                    break;
            }
            objClientMedicationrow.PermitChangesByOtherUsers = document.getElementById(HiddenPermitChangesByOtherUsers).value;
            var arrayobjpushClientMedicationInstructionrow = new Array();
            var ExitLoop = false;
            var ExitInstructionsloop = false;
            var BlankInstructionsCount = 0;
            var LabelErrorMessage = document.getElementById(LabelErrorMessage);
            var DivErrorMessage = document.getElementById(DivErrorMessage);
            var ImageError = document.getElementById(ImageError);
            var tableErrorMessage = document.getElementById(tableErrorrMessage);
            var LabelGridErrorMessage = document.getElementById(LabelGridErrorMessage);
            var DivGridErrorMessage = document.getElementById(DivGridErrorMessage);
            var ImageGridError = document.getElementById(ImageGridError);
            var tableGridErrorMessage = document.getElementById(tableGridErrorMessage);
            var table = document.getElementById(tbl);
            var categoryDrugCounter = 0;
            for (var i = 0; i < table.rows.length; i++) {
                if (ExitLoop == false) {
                    var NextCnt = i;
                    var row = table.rows[i];
                    var Strength = row.cells[1].getElementsByTagName("select")[0].value;
                    var Quantity = row.cells[2].getElementsByTagName("input")[0].value;
                    var Unit = row.cells[3].getElementsByTagName("select")[0].value;
                    var Schedule = row.cells[4].getElementsByTagName("select")[0].value;
                    var StartDate = row.cells[5].getElementsByTagName("input")[0].value;
                    if (row.cells[7].getElementsByTagName("input")[0].value == "")
                        row.cells[7].getElementsByTagName("input")[0].value = 0;
                    var Days = row.cells[7].getElementsByTagName("input")[0].value;
                    if (row.cells[15].getElementsByTagName("input")[0].value == "Y") {
                        var pharmacyTextComboBox = document.getElementById("ComboBoxPharmacyDD_" + i);
                        if (pharmacyTextComboBox != null && pharmacyTextComboBox.value == "") {
                            pharmacyTextComboBox.value = "0";
                        }
                    }
                    var Pharma = document.getElementById("ComboBoxPharmacyDD_" + i).value;
                    if (row.cells[10].getElementsByTagName("input")[0].value == "")
                        row.cells[10].getElementsByTagName("input")[0].value = 0;
                    var Refills = row.cells[10].getElementsByTagName("input")[0].value;
                    if (row.cells[11].getElementsByTagName("input")[0].value == "")
                        row.cells[11].getElementsByTagName("input")[0].value = 0;
                    var Sample = row.cells[11].getElementsByTagName("input")[0].value;
                    if (row.cells[12].getElementsByTagName("input")[0].value == "")
                        row.cells[12].getElementsByTagName("input")[0].value = 0;
                    var Stock = row.cells[12].getElementsByTagName("input")[0].value;
                    var EndDate = row.cells[13].getElementsByTagName("input")[0].value;

                    if (row.cells[3].getElementsByTagName("select")[0].selectedIndex != '-1')
                        var Instruction = row.cells[1].getElementsByTagName("select")[0].options[row.cells[1].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[2].getElementsByTagName("input")[0].value + " " + row.cells[3].getElementsByTagName("select")[0].options[row.cells[3].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[4].getElementsByTagName("select")[0].options[row.cells[4].getElementsByTagName("select")[0].selectedIndex].innerText;
                    if (NextCnt < table.rows.length - 1) {
                        NextCnt = NextCnt + 1;
                        var nextrow = table.rows[NextCnt];
                        var nextStrength = nextrow.cells[1].getElementsByTagName("select")[0].value;
                        if (nextStrength == '-1' || Strength == "") {
                            ExitLoop = true;
                            tableErrorMessage.style.display = 'none';
                            ImageError.style.visibility = 'hidden';
                            ImageError.style.display = 'none';
                            LabelErrorMessage.innerText = '';
                            ImageGridError.style.visibility = 'hidden';
                            ImageGridError.style.display = 'none';
                            LabelGridErrorMessage.innerText = '';
                            tableGridErrorMessage.style.display = 'none';
                        }
                    }
                }

                //If the SystemConfigurationKeys - 'RXAddMedicationFrequencyIsRequiredField' is set to 'Y' only then show the Validation for Frequency/Directions while inserting drug details
                if ($("[id*=HiddenFieldRXAddMedicationFrequencyIsRequiredField]").length > 0) {
                    if ($("[id*=HiddenFieldRXAddMedicationFrequencyIsRequiredField]").val().toLowerCase() == "y") {
                        if ($("[id*=HiddenFieldRXProgramRequireFrequency]").length > 0) {
                            if ($("[id*=HiddenFieldRXProgramRequireFrequency]").val() != "") {
                                if (Schedule == '-1' || Schedule == "") {
                                    tableGridErrorMessage.style.display = 'block';
                                    ImageGridError.style.display = 'block';
                                    //LabelGridErrorMessage.innerText = 'Please select Directions.';
                                    LabelGridErrorMessage.innerText = $("[id*=HiddenFieldRXProgramRequireFrequency]").val() + ' use the MAR, therefore frequency is required.';
                                    return false;
                                }
                            }
                        }
                    }
                }

                if ((Strength == '-1' || Strength == "") && (Quantity == '') && (Unit == '-1' || Unit == "") && (Schedule == '-1' || Schedule == "")) {
                    BlankInstructionsCount = BlankInstructionsCount + 1;
                }
            }
            ExitLoop = false;

            // Changed by Jason Steczynski on 4/2/2015, reference 2015-03-05_0829Rx_modification__partial_duplication_issue
            // added or condition to handle update case where medication strength, dose, unit and directions are removed
            if (BlankInstructionsCount != table.rows.length || (objClientMedicationrow.MedicationName && objClientMedicationrow.MedicationName.length)) {

                for (var i = 0; i < table.rows.length; i++) {
                    var objClientMedicationInstructionrow = new ClientMedicationNonOrder.ClientMedicationInstructionRow();
                    if (ExitLoop == false) {
                        var NextCnt = i;
                        var row = table.rows[i];
                        var Strength = row.cells[1].getElementsByTagName("select")[0].value;
                        var Quantity = row.cells[2].getElementsByTagName("input")[0].value;
                        var Unit = row.cells[3].getElementsByTagName("select")[0].value;
                        var Schedule = row.cells[4].getElementsByTagName("select")[0].value;

                        var StartDate = row.cells[5].getElementsByTagName("input")[0].value;
                        if (row.cells[7].getElementsByTagName("input")[0].value == "")
                            row.cells[7].getElementsByTagName("input")[0].value = 0;
                        var Days = row.cells[7].getElementsByTagName("input")[0].value;

                        if (row.cells[15].getElementsByTagName("input")[0].value == "Y") {
                            var pharmacyTextComboBox = document.getElementById("ComboBoxPharmacyDD_" + i);
                            if (pharmacyTextComboBox != null && pharmacyTextComboBox.value == "") {
                                pharmacyTextComboBox.value = "0";
                            }
                        }
                        var Pharma = document.getElementById("ComboBoxPharmacyDD_" + i).value;
                        if (row.cells[10].getElementsByTagName("input")[0].value == "")
                            row.cells[10].getElementsByTagName("input")[0].value = 0;
                        var Sample = row.cells[10].getElementsByTagName("input")[0].value;
                        if (row.cells[11].getElementsByTagName("input")[0].value == "")
                            row.cells[11].getElementsByTagName("input")[0].value = 0;
                        var Stock = row.cells[11].getElementsByTagName("input")[0].value;
                        if (row.cells[12].getElementsByTagName("input")[0].value == "")
                            row.cells[12].getElementsByTagName("input")[0].value = 0;
                        var Refills = row.cells[12].getElementsByTagName("input")[0].value;
                        var EndDate = row.cells[13].getElementsByTagName("input")[0].value;
                        if (row.cells[3].getElementsByTagName("select")[0].selectedIndex != '-1')
                            var Instruction = row.cells[1].getElementsByTagName("select")[0].options[row.cells[1].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[2].getElementsByTagName("input")[0].value + " " + row.cells[3].getElementsByTagName("select")[0].options[row.cells[3].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[4].getElementsByTagName("select")[0].options[row.cells[4].getElementsByTagName("select")[0].selectedIndex].innerText;
                        if (NextCnt < table.rows.length - 1) {
                            NextCnt = NextCnt + 1;
                            var nextrow = table.rows[NextCnt];
                            var nextStrength = nextrow.cells[1].getElementsByTagName("select")[0].value;

                            if (nextStrength == '-1' || Strength == "") {
                                ExitLoop = true;

                                tableErrorMessage.style.display = 'none';
                                ImageError.style.visibility = 'hidden';
                                ImageError.style.display = 'none';
                                LabelErrorMessage.innerText = '';

                                ImageGridError.style.visibility = 'hidden';
                                ImageGridError.style.display = 'none';
                                LabelGridErrorMessage.innerText = '';

                                tableGridErrorMessage.style.display = 'none';
                            }
                        }
                        if (Quantity < 0) {
                            ImageGridError.style.display = 'block';
                            ImageGridError.style.visibility = 'visible';
                            DivGridErrorMessage.style.display = 'block';
                            tableGridErrorMessage.style.display = 'block';
                            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
                            LabelGridErrorMessage.innerText = 'Dose can not be less than 0.'; //Code Added By Loveena in Ref to Task#72 on 16 Nov 2008 
                            return false;
                        }
                        flag = false;
                        var k = 0;
                        if (row.cells[15].getElementsByTagName("input")[0].value == "N") {
                            for (j = 0; j < table.rows.length; j++) {
                                var newRow = table.rows[j];
                                if (i != j) {
                                    if (row.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                        if (document.getElementById("ComboBoxPharmacyDD_" + j).value == '') {
                                            k = 0;
                                        } else {
                                            k = k + 1;
                                            break;
                                        }
                                    }
                                }
                            }
                            //if (k == 0) {
                            //    if (document.getElementById("ComboBoxPharmacyDD_" + i).value == '') {
                            //        flag = true;
                            //    }
                            //}
                            //if (flag == true) {
                            //    ImageGridError.style.display = 'block';
                            //    ImageGridError.style.visibility = 'visible';
                            //    DivGridErrorMessage.style.display = 'block';
                            //    tableGridErrorMessage.style.display = 'block';
                            //    fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
                            //    LabelGridErrorMessage.innerText = 'Only one dispense quantity is allowed per strength.'; //Code Added By Loveena in Ref to Task#72 on 16 Nov 2008.                                                        
                            //    document.getElementById("ComboBoxPharmacyDD_" + i).value = "";
                            //    document.getElementById("ComboBoxPharmacyDD_" + i).focus();
                            //    return false;
                            //}
                        }
                        var Category = row.cells[12].getAttribute("MedicationCategory");
                        objClientMedicationrow.DrugCategory = Category;
                        if (Category == 2 || Category == 3 || Category == 4 || Category == 5) {
                            categoryDrugCounter++;
                        }
                        objClientMedicationInstructionrow.StrengthId = row.cells[1].getElementsByTagName("select")[0].value;
                        objClientMedicationInstructionrow.Quantity = row.cells[2].getElementsByTagName("input")[0].value;
                        objClientMedicationInstructionrow.Quantity = objClientMedicationInstructionrow.Quantity || 0;
                        objClientMedicationInstructionrow.Unit = row.cells[3].getElementsByTagName("select")[0].value;
                        objClientMedicationInstructionrow.Schedule = row.cells[4].getElementsByTagName("select")[0].value;
                        objClientMedicationInstructionrow.StartDate = row.cells[5].getElementsByTagName("input")[0].value;
                        objClientMedicationInstructionrow.Days = row.cells[7].getElementsByTagName("input")[0].value;
                        objClientMedicationInstructionrow.PotencyUnitCode = row.cells[9].getElementsByTagName("select")[0].value;
                        if (row.cells[15].getElementsByTagName("input")[0].value == "Y")
                            objClientMedicationInstructionrow.Pharmacy = document.getElementById("ComboBoxPharmacyDD_" + i).value;
                        else if (row.cells[15].getElementsByTagName("input")[0].value == "N") {
                            if (document.getElementById("ComboBoxPharmacyDD_" + i).value == "") {
                                objClientMedicationInstructionrow.PharmaText = null;
                            } else {
                                objClientMedicationInstructionrow.PharmaText = document.getElementById("ComboBoxPharmacyDD_" + i).value;
                            }

                        }
                        objClientMedicationInstructionrow.AutoCalcallow = row.cells[15].getElementsByTagName("input")[0].value;
                        objClientMedicationInstructionrow.Sample = row.cells[11].getElementsByTagName("input")[0].value;
                        objClientMedicationInstructionrow.Stock = row.cells[12].getElementsByTagName("input")[0].value;
                        objClientMedicationInstructionrow.Refills = row.cells[10].getElementsByTagName("input")[0].value;

                        objClientMedicationInstructionrow.EndDate = row.cells[13].getElementsByTagName("input")[0].value;

                        if ((row.cells[14].getElementsByTagName("span")[0].value != "") && (row.cells[14].getElementsByTagName("span")[0].value != "undefined"))
                            objClientMedicationInstructionrow.RowIdentifierCMI = row.cells[14].getElementsByTagName("span")[0].value;
                        if ((row.cells[16].getElementsByTagName("input")[0].value != "") && (row.cells[16].getElementsByTagName("input")[0].value != "undefined"))
                            objClientMedicationInstructionrow.StrengthRowIdentifier = row.cells[16].getElementsByTagName("input")[0].value;

                        objClientMedicationInstructionrow.NoOfDaysOfWeek = row.cells[17].getElementsByTagName("input")[0].value;

                        // Changed 4/7/2015 by Jason Steczynski, Task #1252
                        // Added StrengthId > 0 condition
                        if (objClientMedicationInstructionrow.StrengthId > 0) {
                            objClientMedicationInstructionrow.Instruction = row.cells[1].getElementsByTagName("select")[0].options[row.cells[1].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[2].getElementsByTagName("input")[0].value + " " + row.cells[3].getElementsByTagName("select")[0].options[row.cells[3].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[4].getElementsByTagName("select")[0].options[row.cells[4].getElementsByTagName("select")[0].selectedIndex].innerText;
                        } else if (objClientMedicationInstructionrow.Schedule > 0 && objClientMedicationInstructionrow.StrengthId <= 0) {
                            objClientMedicationInstructionrow.Instruction = row.cells[4].getElementsByTagName("select")[0].options[row.cells[4].getElementsByTagName("select")[0].selectedIndex].innerText;
                        }
                        else {
                            objClientMedicationInstructionrow.Instruction = "";
                        }
                        // end of changes
                        arrayobjpushClientMedicationInstructionrow.push(objClientMedicationInstructionrow);
                    }
                }
            }


            if (parseInt(MedicationIdValue).toString() == "NaN") {
                tableErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                LabelErrorMessage.innerText = 'Please Select a Drug.';
                return false;
            }

            //AHN SGL 128 - Removed the validation for controlled medications - Nandita S on Feb 28,2018
            //if (categoryDrugCounter = 1) {
            //    tableErrorMessage.style.display = 'block';
            //    ImageError.style.display = 'block';
            //    LabelErrorMessage.innerText = 'Scheduled medication cannot have more than 1 instruction on an order. Separate order must be completed.';
            //    return false;
            //}

            if (objClientMedicationrow.MedicationNameId != "") //added by Chandan fo task #108 MM build 1.6.5
                Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.SaveMedicationRow(objClientMedicationrow, arrayobjpushClientMedicationInstructionrow, saveTemplateFlag, ClientMedicationNonOrder.onSaveMedicationSucceeded, ClientMedicationNonOrder.onSaveMedicationFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onSaveMedicationFailure: function (error, context) {
        document.getElementById(context.tableErrorMessage).style.display = 'block';
        document.getElementById(context.ImageError).style.display = 'block';
        document.getElementById(context.ImageError).style.visibility = 'visible';
        document.getElementById(context.DivErrorMessage).style.display = 'block';
        document.getElementById(context.LabelErrorMessage).innerText = error.get_message();
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        if (error.get_message() == "Session Expired") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        return false;
    },
    ManipulateRowValues: function (sender, e) {
        try {
            if (e.target === undefined) {
                _Row = e.parentNode.parentNode;
            } else {
                _Row = e.target.parentNode.parentNode;
            }
            if (_Row.cells[7].getElementsByTagName("input")[0].value != '') {
                if (isNaN(parseInt(_Row.cells[7].getElementsByTagName("input")[0].value))) {
                    _Row.cells[7].getElementsByTagName("input")[0].value = '';
                    _Row.cells[13].getElementsByTagName("input")[0].value = _Row.cells[5].getElementsByTagName("input")[0].value;
                    return false;
                }
            }
            if (_Row.cells[10].getElementsByTagName("input")[0].value != '') {
                if (!CommonFunctions.IsNumericValue(_Row.cells[10].getElementsByTagName("input")[0].value)) {
                    _Row.cells[10].getElementsByTagName("input")[0].value = '';
                    return false;
                }
            }
            var context = new Object();
            var objRow = new Object();
            objRow.Schedule = _Row.cells[4].getElementsByTagName("select")[0];
            objRow.Quantity = _Row.cells[2].getElementsByTagName("input")[0];
            objRow.Units = _Row.cells[3].getElementsByTagName("select")[0];
            objRow.StartDate = _Row.cells[5].getElementsByTagName("input")[0];
            objRow.Days = _Row.cells[7].getElementsByTagName("input")[0];
            objRow.Pharmacy = _Row.cells[8].getElementsByTagName("input")[0];
            objRow.Sample = _Row.cells[11].getElementsByTagName("input")[0];
            objRow.Stock = _Row.cells[12].getElementsByTagName("input")[0];
            objRow.Refills = _Row.cells[10].getElementsByTagName("input")[0];
            objRow.EndDate = _Row.cells[13].getElementsByTagName("input")[0];
            objRow.MedicationId = _Row.cells[1].getElementsByTagName("select")[0];
            var rowIndex = _Row.rowIndex;
            objRow.rowIndex = rowIndex;
            context.rowIndex = rowIndex;
            context.SelectedValue = "";
            var table = $("[id$=tableMedicationOrder]")[0];
            var dosage = 0;
            if (objRow.Quantity.value != "")
                dosage = parseFloat(objRow.Quantity.value);
            var schedule = objRow.Schedule.value;
            var CallingObjectId;
            if (e.id == null) {
                CallingObjectId = sender.get_id();
            } else {
                CallingObjectId = e.id;
            }
            if (CallingObjectId.indexOf("TextBoxStartDate") > 0 || CallingObjectId.indexOf("TextBoxRefills") > 0 || CallingObjectId.indexOf("TextBoxDays") > 0) {
                if (((Number.parseInvariant(objRow.Days.value) < 1) || (Number.parseInvariant(objRow.Days.value) > 365)) == false)
                    ClientMedicationNonOrder.CalculateEndDate(objRow.StartDate.id, objRow.Days.id, objRow.Refills.id, objRow.EndDate.id);
            }
            if (CallingObjectId.indexOf("TextBoxQuantity") > 0 || CallingObjectId.indexOf("DropDownListSchedule") > 0 || CallingObjectId.indexOf("TextBoxDays") > 0)
                if (((Number.parseInvariant(objRow.Days.value) < 1) || (Number.parseInvariant(objRow.Days.value) > 365)) == false)
                    if (_Row.cells[15].getElementsByTagName("input")[0].value == "Y") {
                        ClientMedicationNonOrder.CalculatePharmacy(objRow);
                        $("input[id$=HiddenFieldSelectedValue]").val("");
                    } else if ((_Row.cells[15].getElementsByTagName("input")[0].value == "N") && objRow.MedicationId.value > 0 && objRow.Quantity.value > 0 && objRow.Schedule.value > 0 && objRow.Days.value > 0 && objRow.Units.value > 0) {
                        if (document.getElementById("ComboBoxPharmacyDD_" + rowIndex) != null) {
                            if (document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value != undefined && document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value != "")
                                context.SelectedValue = document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value;
                            $("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
                        }
                        for (j = 0; j < table.rows.length; j++) {
                            var newRow = table.rows[j];
                            if (rowIndex != j) {
                                if (_Row.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                    if (newRow.cells[2].getElementsByTagName("input")[0].value > 0)
                                        dosage = dosage + parseFloat(newRow.cells[2].getElementsByTagName("input")[0].value);
                                    schedule = schedule + "," + newRow.cells[4].getElementsByTagName("select")[0].value;
                                }
                            }
                        }
                        ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                        Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(objRow.MedicationId.value, dosage, schedule, objRow.Days.value, ClientMedicationNonOrder.onDispenseQuantitySucceeded, ClientMedicationNonOrder.onFailure, context);
                    } else {
                        ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                    }
            //Deleted on 5/21/2015 by Jason Steczyski, Philhaven - Customization Issues Tracking Task #1285: button enabled before all services are complete
            //document.getElementById('buttonInsert').disabled = false;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    CheckKeyPress: function (rowIndex) {
        try {
            if ($("[id*=HiddenFieldAutoCalcAllowed" + rowIndex + "]").val() == "Y") {
                document.getElementById("ComboBoxPharmacyDD_" + rowIndex).setAttribute("maxLength", "13");
                if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode == 8) || event.keyCode == 46)
                    event.returnValue = true;
                else
                    event.returnValue = false;
            } else if ($("[id*=HiddenFieldAutoCalcAllowed" + rowIndex + "]").val() == "N")
                document.getElementById("ComboBoxPharmacyDD_" + rowIndex).setAttribute("maxLength", "100");
        } catch (e) {
        }
    },
    onDispenseQuantitySucceeded: function (result, context) {
        try {
            ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + context.rowIndex, "#ComboBoxPharmacyDDList_" + context.rowIndex);
            if (result == null || result.rows == null || !result.rows) {
                return;
            }
            ClientMedicationNonOrder.PopulatePharmacyTextList($("#ComboBoxPharmacyDDList_" + context.rowIndex), result);
            document.getElementById("ComboBoxPharmacyDD_" + context.rowIndex).value = $("input[id$=HiddenFieldSelectedValue]").val();
        } catch (ex) {
        }
    },
    CalculateEndDate: function (startDate, days, refill, enddate) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008 
            var Days = document.getElementById(days).value;
            var Refill = document.getElementById(refill).value;
            if (document.getElementById(startDate).value == "")
                return;
            if (Days == "")
                Days = 0;
            if (Refill == "")
                Refill = 0;
            EndDate = document.getElementById(enddate);
            StartDateBox = document.getElementById(startDate);
            if (!Date.parse(document.getElementById(startDate).value)) {
                document.getElementById(startDate).value = "";
                return;
            }
            Streamline.SmartClient.WebServices.CommonService.CalculateEndDate(document.getElementById(startDate).value, Days, Refill, ClientMedicationNonOrder.onSucceeded, ClientMedicationNonOrder.onFailure);
        } catch (e) {
            StartDateBox.innerText = "";
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    onSucceeded: function (result) {
        try {
            if (result == "") {
                StartDateBox.value = "";
                EndDate.value = "";
            } else
                EndDate.value = result;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    CalculatePharmacy: function (objRow) {
        try {

            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var Days = Number.parseInvariant(objRow.Days.value);
            var Quantity = Number.parseInvariant(objRow.Quantity.value);
            var Schedule = Number.parseInvariant(objRow.Schedule.value);
            if (isNaN(Quantity))
                Quantity = 1;
            if (isNaN(Schedule))
                return;
            if (isNaN(Days))
                Days = 1;
            var Sample = Number.parseInvariant(objRow.Sample.value);
            if (isNaN(Sample))
                Sample = 0;
            var Stock = Number.parseInvariant(objRow.Stock.value);
            if (isNaN(Stock))
                Stock = 0;
            var units = Number.parseInvariant(objRow.Units.value);
            if (units != "4926" && units != "4927" && units != "4928")
                Streamline.SmartClient.WebServices.CommonService.CalculatePharmacy(Days, Quantity, Schedule, Sample, Stock, ClientMedicationNonOrder.onSucceededPharmacy, ClientMedicationNonOrder.onFailure, objRow);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        } finally {
            fnHideParentDiv();
        }
    },
    onSucceededPharmacy: function (result, context) {
        try {
            var calculatedQty = result;
            if (calculatedQty > 0 || ((calculatedQty > 0.01) && (calculatedQty < 0.99)))
                calculatedQty = result;
            else
                calculatedQty = 0;
            document.getElementById("ComboBoxPharmacyDD_" + context.rowIndex).value = calculatedQty;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    onScheduleBlur: function (Schedule) {
        try {
            //Deleted on 5/21/2015 by Jason Steczyski, Philhaven - Customization Issues Tracking Task #1285: button enabled before all services are complete
            //document.getElementById('buttonInsert').disabled = false;
            ClientMedicationNonOrder.ManipulateRowValues(null, Schedule);

            var num = Schedule.id.slice(-1);
            var SelectDays = $("[id$=noOfDaysOfWeek" + num + "]").val();
            ClientMedicationNonOrder.clearDaysofWeek();
            if (SelectDays != "")
                ClientMedicationNonOrder.fillDaysofWeek(SelectDays);

            var showpopup = $("[id$=" + "'" + Schedule.id + "'" + "]").find(":Selected").attr("ExternalCode1");
            if (showpopup < 1 && $("[id*=HiddenFieldRXShownoOfDaysOfWeekPopup]").val() == "Y") {
                $('#divSelectDaysOfWeek').show();
                var NoOfDays = 1;
                NoOfDays = parseFloat(showpopup * 7);
                if (Math.floor(NoOfDays) > 1)
                    NoOfDays = Math.floor(NoOfDays);
                else
                    NoOfDays = 1;
                $("[id$=" + "'" + Schedule.id + "'" + "]").attr("NumberofDays", NoOfDays)
                $("#divSelectDaysOfWeek").attr("Scheduleid", Schedule.id)
            }
            else {
                $("[id$=noOfDaysOfWeek" + num + "]").val('');
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    clearDaysofWeek: function () {
        $('.SelectDays:checked').each(function () {
            $(this).attr('checked', false)
        });
    },
    fillDaysofWeek: function (SelectDays) {
        var daysofweek = SelectDays.split(',');

        for (var i = 0; i < daysofweek.length; i++) {
            switch (daysofweek[i]) {
                case "1": $("[id=CheckBox_Sun]").attr('checked', true);
                    break;
                case "2": $("[id=CheckBox_Mon]").attr('checked', true);
                    break;
                case "3": $("[id=CheckBox_Tue]").attr('checked', true);
                    break;
                case "4": $("[id=CheckBox_Wed]").attr('checked', true);
                    break;
                case "5": $("[id=CheckBox_Thr]").attr('checked', true);
                    break;
                case "6": $("[id=CheckBox_Fri]").attr('checked', true);
                    break;
                case "7": $("[id=CheckBox_Sat]").attr('checked', true);
                    break;
            }
        }
    },
    SelectDaysOfWeekClick: function () {
        $("[id=DaysOfWeekError]").css("display", "none");
        var SelectDays = '';
        var count = 0;
        var SelectDaysName = '';
        if ($("[id=CheckBox_Sun]")[0].checked) {
            SelectDays += "1,";
            SelectDaysName = "Sun,";
        }
        if ($("[id=CheckBox_Mon]")[0].checked) {
            SelectDays += "2,";
            SelectDaysName += "Mon,";
        }
        if ($("[id=CheckBox_Tue]")[0].checked) {
            SelectDays += "3,";
            SelectDaysName += "Tue,";
        }
        if ($("[id=CheckBox_Wed]")[0].checked) {
            SelectDays += "4,";
            SelectDaysName += "Wed,";
        }
        if ($("[id=CheckBox_Thr]")[0].checked) {
            SelectDays += "5,";
            SelectDaysName += "Thr,";
        }
        if ($("[id=CheckBox_Fri]")[0].checked) {
            SelectDays += "6,";
            SelectDaysName += "Fri,";
        }
        if ($("[id=CheckBox_Sat]")[0].checked) {
            SelectDays += "7,";
            SelectDaysName += "Sat,";
        }
        SelectDays = SelectDays.substring(0, SelectDays.length - 1);
        SelectDaysName = SelectDaysName.substring(0, SelectDaysName.length - 1);
        if (SelectDaysName == '') {
            SelectDaysName = "Select Days Of Week";
        }
        var id = $("#divSelectDaysOfWeek").attr("Scheduleid");
        var _NumberofDays = $("[id=" + "'" + id + "'" + "]").attr("NumberofDays");
        if (SelectDays.split(',').length == _NumberofDays) {
            var num = id.slice(-1);
            $("[id$=noOfDaysOfWeek" + num + "]").val(SelectDays);
            $("#divSelectDaysOfWeek").attr("Scheduleid", "");
            $('#divSelectDaysOfWeek').hide();
        }
        else if (SelectDays.split(',').length < _NumberofDays) {
            $("[id=DaysOfWeekError]").css("display", "");
            $("[id=DaysOfWeekError]").text("Select " + _NumberofDays + " Day(s) of Week");
        }
        else if (SelectDays.split(',').length > _NumberofDays) {
            $("[id=DaysOfWeekError]").css("display", "");
            $("[id=DaysOfWeekError]").text("Select only " + _NumberofDays + " Day(s) of Week");
        }
    },
    onSaveMedicationSucceeded: function (result, context, methodname) {
        try {
            if (result.length > 0) {
                if (result.indexOf("String was not recognized as a valid DateTime") >= 0) {
                    document.getElementById(context.tableErrorMessage).style.display = 'block';
                    document.getElementById(context.ImageError).style.display = 'block';
                    document.getElementById(context.ImageError).style.visibility = 'visible';
                    document.getElementById(context.DivErrorMessage).style.display = 'block';
                    document.getElementById(context.LabelErrorMessage).innerText = 'Please enter medication Date Initiated.';
                    return false;
                }
                if (result.indexOf("Not allowed to select different start dates for C2 medications") >= 0) {
                    document.getElementById(context.tableErrorMessage).style.display = 'block';
                    document.getElementById(context.ImageError).style.display = 'block';
                    document.getElementById(context.ImageError).style.visibility = 'visible';
                    document.getElementById(context.DivErrorMessage).style.display = 'block';
                    document.getElementById(context.LabelErrorMessage).innerText = 'Not allowed to select different start dates for C2 medications';
                    return false;
                }
                document.getElementById(context.tableErrorMessage).style.display = 'block';
                document.getElementById(context.ImageError).style.display = 'block';
                document.getElementById(context.ImageError).style.visibility = 'visible';
                document.getElementById(context.DivErrorMessage).style.display = 'block';
                document.getElementById(context.LabelErrorMessage).innerText = result;
                return false;
            }
            $("[id$=HiddenInsertClick]").val('Insertclick');
            Clear_Click();
            document.getElementById('buttonInsert').disabled = false;
            document.getElementById('buttonInsert').value = "Insert";
        } catch (e) {
            document.getElementById('buttonInsert').disabled = false;
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    GetMedicationList: function (Panel, SortBy) {
        try {
            if (Panel === undefined || Panel == '') {
                Panel = PanelMedicationListNonOrder;
            }
            if (SortBy === undefined) {
                SortBy = '';
            }
            var method = document.getElementById("txtButtonValue").value;
            wRequest = new Sys.Net.WebRequest();
            wRequest.set_url("AjaxScript.aspx?FunctionId=GetMedicationList&par0=" + SortBy + "&par1=" + method + "&container=ClientMedicationNonOrder");
            wRequest.add_completed(ClientMedicationNonOrder.OnFillMedicationControlCompleted);
            wRequest.set_userContext(Panel);
            wRequest.set_httpVerb("Post");
            var executor = new Sys.Net.XMLHttpExecutor();
            wRequest.set_executor(executor);
            executor.executeRequest();
            var started = executor.get_started();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    OnFillMedicationControlCompleted: function (executor, eventArgs) {
        try {
            if (executor.get_responseAvailable()) {
                var webReq = executor.get_webRequest();
                if (executor.get_statusCode() == 200) {
                    var Panel = document.getElementById(webReq.get_userContext());
                    Panel.innerHTML = "";
                    var data = executor.get_responseData();
                    var indexofdiv = data.indexOf('</div>');
                    if (data.length > 545) {
                        data = data.substring(indexofdiv + 6, data.length);
                        var ScriptStart = data.indexOf('<script');
                        var endOfStart = data.indexOf('>', ScriptStart);
                        var ScriptEnd = data.indexOf('</script>');
                        var Script = data.substring(endOfStart + 1, ScriptEnd);
                        var Rscript = document.createElement('script');
                        Rscript.text = Script;
                        Panel.appendChild(Rscript);
                        Panel.innerHTML = data + Panel.innerHTML;
                        if (typeof RegisterMedicationListControlEvents === "function")
                            RegisterMedicationListControlEvents();
                    }
                }
            } else {
                if (executor.get_timedOut())
                    alert("Timed Out");
                else if (executor.get_aborted())
                    alert("Aborted");
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    DeleteRow: function (sender, e) {
        if (sender.target.getAttribute("MedicationId") != null) {
            ClientMedicationNonOrder.DeleteFromTable(sender);
        } else {
            ClientMedicationNonOrder.ClearRow(sender.target.parentElement.parentElement, false, sender.target.parentElement.parentElement.rowIndex);
        }
    },
    DeleteFromTable: function (object) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var MedicationId = object.target.getAttribute("MedicationId");
            var MedicationInstructionId = object.target.getAttribute("MedicationInstructionId");
            Streamline.SmartClient.WebServices.ClientMedications.DeleteClientMedicationInstructions(MedicationId, MedicationInstructionId, null, ClientMedicationNonOrder.onDeleteFromTableSucceeded, ClientMedicationNonOrder.onFailure, object);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onDeleteFromTableSucceeded: function (result, context, methodname) {
        try {
            if (result == true) {
                ClientMedicationNonOrder.PotencyUnitCodeUpdate($("[id$=tableMedicationOrder]")[0], -1, "DeleteRow");
                ClientMedicationNonOrder.ClearRow(context.target.parentElement.parentElement, false, context.target.parentElement.parentElement.rowIndex);
            }
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onDrugInteractionClick: function (sender, e) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            if (!sender.target.id || sender.target.tagName == "DIV") {
                fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
                return false;
            }
            if ((sender.target.id == "ImgCross") || (sender.target.id == "ImgCross1")) {
                ClientMedicationNonOrder.closeDescDiv(sender.target.id);
                return;
            }
            Streamline.SmartClient.WebServices.ClientMedications.GetDrugInteractionText(e.InteractionId, ClientMedicationNonOrder.onDrugInteractionSucceeded, ClientMedicationNonOrder.onFailure, sender);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }

    },
    onDrugInteractionSucceeded: function (result, context, methodname) {
        try {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
            if (result == null || result.rows == null || !result.rows)
                return;
            var div1 = "";
            var divF = "";
            var NoSeverityRows = false;

            if (!document.getElementById("DivDescriptionContainer")) {
                var x = (screen.availWidth / 2) - 200;
                var y = ((screen.availHeight - 60) / 2) - 100;
                x = (x > 0) ? x : 0;
                y = (y > 0) ? y : 0;
                div1 = document.createElement('div');
                divF = document.createElement('iframe');
                divF.style.zindex = 98;
                divF.id = "IframeDescriptionContainer";
                div1.id = "DivDescriptionContainer";
                div1.className = "drugInteraction";
                div1.style.cursor = "default";
                div1.style.backgroundColor = "#ffffff";
                div1.style.zIndex = 99;
                div1.style.left = x;
                div1.style.top = y;
                div1.style.height = 400;
                divF.style.position = "absolute";
                divF.height = 400;
                div1.style.position = "absolute";
            } else {
                div1 = document.getElementById("DivDescriptionContainer");
                divF = document.getElementById("IframeDescriptionContainer");
            }
            if (result.columns.length <= 1) {
                var TableHTML = [];
                TableHTML.push("<table class='PopUpTitleBar' width='600px'>");
                TableHTML.push("  <tr> <td width='95%' id='topborder' class='TitleBarText' align='left'>");
                TableHTML.push("  Interacting Medications Details</td> <td align='right'> ");
                TableHTML.push("  <img id='ImgCross' class='PopUpTitleBar' onclick='ClientMedicationNonOrder.closeDescDiv(this)' src='App_Themes/Includes/Images/cross.jpg'");
                TableHTML.push("  title='Close' alt='Close' /></td></tr>");
                TableHTML.push("</table> <table width='600px' border='0' cellpadding='0' cellspacing='0'>");
                TableHTML.push("<tbody>");
                TableHTML.push(" <tr> <td class='Label' > <div id='InteractionDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow-Y:auto ;overflow-X:none; height:370px;'></div>  </td></tr></tbody></table> ");
                div1.innerHTML = TableHTML.join('');
                NoSeverityRows = true;
                div1.style.height = 400;
                div1.style.width = 600;
            } else {
                var TableHTML = [];
                TableHTML.push("<table class='PopUpTitleBar' width='400px'>");
                TableHTML.push("  <tr> <td width='95%' id='topborder' class='TitleBarText' align='left'>");
                TableHTML.push("  Interacting Medications Details</td> <td align='right'> ");
                TableHTML.push("  <img id='ImgCross' class='PopUpTitleBar' onclick='ClientMedicationNonOrder.closeDescDiv(this)' src='App_Themes/Includes/Images/cross.jpg'");
                TableHTML.push("  title='Close' alt='Close' /></td></tr>");
                TableHTML.push("</table> <table width='400px'>");
                TableHTML.push("<tbody>");
                TableHTML.push(" <tr> <td class='DescriptionRow'>Severity</td> <td class='DescriptionRow'>Description</td><td></td><td></td></tr>");
                for (i = 0; i < result.rows.length; i++) {
                    TableHTML.push(" <tr> <td> <span class='linkStyle'  onclick='ClientMedicationNonOrder.onShowSeverity(this," + result.rows[i]["Severity"] + ")'>" + result.rows[i]["Severity"] + "</span> </td> <td style='text-align:left;'><span class='linkStyle' style='text-align:left' onclick='ClientMedicationNonOrder.onDrugInteractionDescriptionClick(this," + result.rows[i]["MonoGraphId"] + "," + result.rows[i]["InteractionId"] + ")'>" + result.rows[i]["Description"] + "</span></td><td></td><td></td></tr>");
                }
                TableHTML.push(" </tbody></table> ");
                div1.innerHTML = TableHTML.join('');
                div1.style.height = 200;
                div1.style.width = 400;
            }

            divF.style.height = div1.style.height;
            divF.style.width = div1.style.width;
            divF.style.top = div1.style.top;
            divF.style.left = div1.style.left;
            if (context.target.getElementsByTagName("div").length < 1) {
                context.target.appendChild(div1);
                context.target.appendChild(divF);
            }
            document.getElementById("DivDescriptionContainer").style.display = "block";
            divF.style.display = "block";
            if (NoSeverityRows == true)
                ClientMedicationNonOrder.DisplayMonographDescription(result.rows[0]["Description"], false);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    LoadDrugOrderTemplateForSelectedMedication: function (row, medicationNameId, selectedMedicationId, rowId) {
        var context = {};
        context.row = row;
        context.medicationNameId = medicationNameId;
        context.medicationId = selectedMedicationId;
        context.rowId = rowId;
        var staffId = $('[id$=HiddenFieldLoggedInStaffId]').val();
        ClientMedicationNonOrder.onSuccessLoadDrugOrderTemplate(null, context);
    },
    onSuccessLoadDrugOrderTemplate: function (result, context) {
        try {
            if (result != null && result.rows != null) {
                var Strength = context.row.cells[1].getElementsByTagName("select")[0];
                var Schedule = context.row.cells[4].getElementsByTagName("select")[0];
                var ddlPotencyUnitCode = context.row.cells[9].getElementsByTagName("select")[0];
                ClientMedicationNonOrder.FillPotencyUnitCodes(context.medicationNameId, ddlPotencyUnitCode, result.rows[0]["PotencyUnitCode"]);
                var Unit = new Object();
                Unit.DropDown = context.row.cells[3].getElementsByTagName("select")[0];
                Unit.SelectedValue = result.rows[0]["Unit"];
                ClientMedicationNonOrder.FillStrength(context.medicationNameId, Strength, context.medicationId, Unit, false);
                ClientMedicationNonOrder.FillScheduled(Schedule, result.rows[0]["Schedule"]);
                context.row.cells[2].getElementsByTagName("input")[0].value = result.rows[0]["Quantity"];
                var _startDate = new Date();
                context.row.cells[5].getElementsByTagName("input")[0].value = _startDate.format("MM/dd/yyyy");
                context.row.cells[7].getElementsByTagName("input")[0].value = result.rows[0]["Days"];
                context.row.cells[10].getElementsByTagName("input")[0].value = result.rows[0]["Refills"];
                context.row.cells[15].getElementsByTagName("input")[0].value = result.rows[0]["AutoCalculate"];
                ClientMedicationNonOrder.ManipulateRowValues(null, context.row.cells[7].getElementsByTagName("input")[0]);
                if (result.rows[0]["DispenseQuantityText"] != "") {
                    document.getElementById("ComboBoxPharmacyDD_" + context.rowId).value = result.rows[0]["DispenseQuantityText"];
                } else if (result.rows[0]["DispenseQuantity"] != 0) {
                    document.getElementById("ComboBoxPharmacyDD_" + context.rowId).value = result.rows[0]["DispenseQuantity"];
                }
                $('[id$=TextBoxComments]').val(result.rows[0]["Comment"]);
                if (result.rows[0]["IncludeOnPrescription"] == 'Y') {
                    $('[id$=CheckboxIncludeOnPRescription]').attr('checked', true);
                } else {
                    $('[id$=CheckboxIncludeOnPRescription]').attr('checked', false);
                }
            } else {
                var ddlPotencyUnitCode = context.row.cells[9].getElementsByTagName("select")[0];
                ClientMedicationNonOrder.FillPotencyUnitCodes(context.medicationNameId, ddlPotencyUnitCode, null);
                var Unit = new Object();
                Unit.DropDown = context.row.cells[3].getElementsByTagName("select")[0];
                var Strength = context.row.cells[1].getElementsByTagName("select")[0];
                ClientMedicationNonOrder.FillStrength(context.medicationNameId, Strength, context.medicationId, Unit, true);
                var Schedule = context.row.cells[4].getElementsByTagName("select")[0];
                ClientMedicationNonOrder.FillScheduled(Schedule, null);
                var _startDate = new Date();
                context.row.cells[5].getElementsByTagName("input")[0].value = _startDate.format("MM/dd/yyyy");
                ClientMedicationNonOrder.ClearPharmacyComboList("", "#ComboBoxPharmacyDDList_" + context.rowId);
                ManageOrderTemplate('none');
            }
        } catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    onDrugInteractionDescriptionClick: function (context, MonographId, InteractionId) //Added by Chandan on 19th Nov 2008 Ref Task #82 - added a new parameter InteractionId
    {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            Streamline.SmartClient.WebServices.ClientMedications.getMonographDescription(MonographId, InteractionId, ClientMedicationNonOrder.onDrugInteractionDescriptionSucceeded, ClientMedicationNonOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onDrugInteractionDescriptionSucceeded: function (result, context, methodname) {
        try {
            var divM = "";
            var divF = "";
            if (!document.getElementById("DivMonoGraphContainer")) {
                divM = document.createElement('div');
                divF = document.createElement('iframe');
                divM.id = "DivMonoGraphContainer";
                divF.id = "IframeMonoGraphContainer";
                divM.className = "drugInteraction";
                divM.style.cursor = "default";
                divM.style.backgroundColor = "#ffffff";
                divM.style.width = 600;
                divM.style.height = 400;
                divM.style.zIndex = 101;
                divF.style.zIndex = 100;
                divM.style.left = -10;
                divM.style.top = -150;
                divM.style.position = "absolute";
                divF.style.position = "absolute";
            } else {
                divM = document.getElementById("DivMonoGraphContainer");
                divF = document.getElementById("IframeMonoGraphContainer");
            }

            if (context.parentNode.parentNode.childNodes[2].getElementsByTagName("div").length < 1) {
                context.parentNode.parentNode.childNodes[2].appendChild(divM);
                context.parentNode.parentNode.childNodes[2].appendChild(divF);
            }
            var TableHTML = [];
            TableHTML.push("<table class='PopUpTitleBar' width='600px'>");
            TableHTML.push("  <tr> <td width='95%' id='topborder' class='TitleBarText' align='left'>");
            TableHTML.push("  Interacting Medications Details</td> <td align='right'> ");
            TableHTML.push("  <img id='ImgCross1' class='PopUpTitleBar' onclick='ClientMedicationNonOrder.closeDescDiv(this)' src='App_Themes/Includes/Images/cross.jpg'");
            TableHTML.push("  title='Close' alt='Close' /></td></tr>");
            TableHTML.push("</table> <table width='600px' border='0' cellpadding='0' cellspacing='0'>");
            TableHTML.push("<tbody>");
            TableHTML.push(" <tr><td class='Label'>  <div id='MonoGraphDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow-Y:auto ;overflow-X:none; height:370px;'></div>  </td></tr></tbody></table> ");
            document.getElementById("DivMonoGraphContainer").innerHTML = TableHTML.join('');
            divM.style.width = 600;
            divM.style.height = 400;
            divF.style.height = divM.style.height;
            divF.style.width = divM.style.width;
            divF.style.top = divM.style.top;
            divF.style.left = divM.style.left;
            document.getElementById("DivMonoGraphContainer").style.display = "block";
            document.getElementById("IframeMonoGraphContainer").style.display = "block";
            ClientMedicationNonOrder.DisplayMonographDescription(result.rows[0]["Description"], true);
            return false;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    DisplayMonographDescription: function (varDataToBeDisplayed, varToBeDisplayedInMonographContainer) {
        if (varToBeDisplayedInMonographContainer)
            document.getElementById("MonoGraphDescriptions").innerHTML = varDataToBeDisplayed;
        else
            document.getElementById("InteractionDescriptions").innerHTML = varDataToBeDisplayed;
    },
    onShowSeverity: function (obj, Severity) {
        try {
            if (!document.getElementById("DivSeverityContainer")) {
                divS = document.createElement('div');
                divF = document.createElement('iframe');
                divS.id = "DivSeverityContainer";
                divF.id = "IframeSeverityContainer";
                divS.className = "drugInteraction";
                divS.style.cursor = "default";
                divS.style.backgroundColor = "#ffffff";
                divS.style.zIndex = 95;
                divF.style.zIndex = 94;
                divS.style.left = -10;
                divS.style.top = -150;
                divS.style.height = 100;
                divS.style.width = 400;
                divS.style.position = "absolute";
                divF.style.position = "absolute";
            } else {
                divS = document.getElementById("DivSeverityContainer");
                divF = document.getElementById("IframeSeverityContainer");
            }

            if (obj.parentNode.parentNode.childNodes[3].getElementsByTagName("div").length < 1) {
                obj.parentNode.parentNode.childNodes[3].appendChild(divS);
                obj.parentNode.parentNode.childNodes[3].appendChild(divF);
            }

            var TableHTML = [];
            TableHTML.push("<table width='400px' height='100px'>");
            TableHTML.push(" <tbody>");
            TableHTML.push("  <tr> <td align='right' class='PopUpTitleBar' width='100%' colspan=2> ");
            TableHTML.push("  <img id='ImgCross2' onclick='ClientMedicationNonOrder.closeDescDiv(this)' src='App_Themes/Includes/Images/cross.jpg'");
            TableHTML.push("  title='Close' alt='Close' /></td></tr>");
            switch (Severity) {
                case 1:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'> Contraindicated Drug Combination: This drug combination is contraindicated and generally should not be dispensed or administered to the same patient.");
                        TableHTML.push(" Severe. These medicines are not usually taken together. Contact your healthcare professional (e.g. doctor or pharmacist) for more information. ");
                        TableHTML.push(" </div>  </td></tr> ");
                        break;
                    }
                case 2:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'>Severe Interaction: Action is required to reduce the risk of severe adverse interaction.");
                        TableHTML.push("   Serious. These medicines may interact and cause very harmful effects. Contact your healthcare professional (e.g. doctor or pharmacist) for more information. ");
                        TableHTML.push(" </div>  </td></tr>");
                        break;
                    }
                case 3:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'>Moderate Interaction: Assess the risk to the patient and take action as needed.");
                        TableHTML.push(" Moderate. These medicines may cause some risk when taken together. Contact your healthcare professional (e.g. doctor or pharmacist) for more information.</div></td></tr>");
                        break;
                    }
                case 4:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break;
                    }
                case 5:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break;
                    }
                case 6:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break;
                    }
                case 7:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break;
                    }
                case 8:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break;
                    }
                case 9:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'> Undetermined Severity - Alternative Therapy Interaction: Assess the risk to the patient and take action as needed.");
                        TableHTML.push(" Unknown - Alternative Therapy Interaction. These medications may cause some risk when taken together. Contact your healthcare professional (e.g. doctor or pharmacist) for more information. ");
                        TableHTML.push(" </div>  </td></tr>");
                        break;
                    }
            }
            TableHTML.push(" </tbody></table> ");
            divS.innerHTML = TableHTML.join('');
            divF.style.height = 135;
            divF.style.width = divS.style.width;
            divF.style.top = divS.style.top;
            divF.style.left = divS.style.left;
            document.getElementById("DivSeverityContainer").style.display = "block";
            document.getElementById("IframeSeverityContainer").style.display = "block";
            return false;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    closeDescDiv: function (imgId) {
        try {
            if (imgId != null) {
                if (imgId.id == "ImgCross") {
                    document.getElementById("DivDescriptionContainer").style.display = "none";
                    document.getElementById("IframeDescriptionContainer").style.display = "none";
                }
                if (imgId.id == "ImgCross1") {
                    document.getElementById("DivMonoGraphContainer").style.display = "none";
                    document.getElementById("IframeMonoGraphContainer").style.display = "none";
                }
                if (imgId.id == "ImgCross2") {
                    document.getElementById("DivSeverityContainer").style.display = "none";
                    document.getElementById("IframeSeverityContainer").style.display = "none";
                }
            }
        } catch (e) {
        } finally {
            fnHideParentDiv(); //By Vikas Vyas 
        }
    },
    AcknowledgeInteractionSucceeded: function (result, context, methodname) {
        try {
            if (result == true) {
                var ImageError = document.getElementById("Control_ASP.usercontrols_clientmedicationnonorder_ascx_ImageError");
                var tableErrorMessage = document.getElementById("Control_ASP.usercontrols_clientmedicationnonorder_ascx_tableErrorMessage");
                tableErrorMessage.style.display = 'none';
                LabelErrorMessage.innerText = "";
                ImageError.style.visibility = 'hidden';
                ClientMedicationNonOrder.GetMedicationList(PanelMedicationList);
            }
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onDAWSucceeded: function (result, context, method) {
        try {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008 
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onHeaderClick: function (obj) {
        try {
            var sortBy = obj.getAttribute("SortOrder");
            var ColumnName = obj.getAttribute("ColumnName");
            if (sortBy == "") {
                sortBy = "Asc";
            }
            ColumnName = ColumnName + " " + sortBy;
            ClientMedicationNonOrder.GetMedicationList(PanelMedicationListNonOrder, ColumnName);
        } catch (e) {
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
    doFillHiddenFieldDxPurpose: function (DropDownDxPurpose, HiddenDrugPurpose, HiddenDSMCode, HiddenDxId, HiddenDSMNumber) {
        document.getElementById(HiddenDrugPurpose).value = DropDownDxPurpose.options[DropDownDxPurpose.selectedIndex].innerText;
        document.getElementById(HiddenDSMCode).value = DropDownDxPurpose.options[DropDownDxPurpose.selectedIndex].getAttribute('DSMCode');
        document.getElementById(HiddenDxId).value = DropDownDxPurpose.options[DropDownDxPurpose.selectedIndex].value;
        document.getElementById(HiddenDSMNumber).value = DropDownDxPurpose.options[DropDownDxPurpose.selectedIndex].getAttribute('DSMNumber');
        if (document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_DropDownListDxPurpose').value != -1)
            document.getElementById('ImgSearchIcon').style.display = "block";
        else
            document.getElementById('ImgSearchIcon').style.display = "none";
    },
    doFillHiddenFieldListPrescriber: function (DropDownListPrescriber, HiddenPrescriberName, HiddenPrescriberId) {
        document.getElementById(HiddenPrescriberName).value = DropDownListPrescriber.options[DropDownListPrescriber.selectedIndex].innerText;
        document.getElementById(HiddenPrescriberId).value = DropDownListPrescriber.options[DropDownListPrescriber.selectedIndex].value;
    },
    AddMedicationSteps: function (fillValue, result) {
        try {
            if (fillValue === undefined)
                fillValue = false;
            if (result === undefined)
                result = null;
            var TableRowIndex = document.getElementById('HiddenFieldRowIndex').value;
            var txtButtonValue = document.getElementById('txtButtonValue').value;
            var _context = new Object();
            _context.FillValue = fillValue;
            _context.Result = result;
            var txtStartDate = 'Control_ASP.usercontrols_clientmedicationnonorder_ascx_TextBoxStartDate';
            Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.CreateControls(TableRowIndex, txtButtonValue, txtStartDate, ClientMedicationNonOrder.AddMedicationStepsSuccess, ClientMedicationNonOrder.onFailure, _context);
            document.getElementById('HiddenFieldRowIndex').value = parseInt(document.getElementById('HiddenFieldRowIndex').value) + 2;
            if (result != null) {
                if (parseInt(document.getElementById('HiddenFieldRowIndex').value) < result.tables[1].rows.length)
                    ClientMedicationNonOrder.AddMedicationSteps(fillValue, result);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    AddMedicationStepsSuccess: function (result, context) {
        try {
            var stringToReplace = $("[id*=HiddenRelativePath]").val() + "DXR.axd?r=1_49,2_14,2_13,2_8,1_46";
            result.First = result.First.replace(stringToReplace, "");
            stringToReplace = $("[id*=HiddenRelativePath]").val() + "DXR.axd?r=1_29";
            result.First = result.First.replace(stringToReplace, "");
            stringToReplace = $("[id*=HiddenRelativePath]").val() + "DXR.axd?r=2_11";
            result.First = result.First.replace(stringToReplace, "");
            $("[tableMedicationOrder]").children("tbody").append(result.First);
            eval(result.Second);
            var scriptJSM = '_aspxProcessScriptsAndLinks("", true);';
            eval(scriptJSM);
            if (context.FillValue == 'true') {
                ClientMedicationNonOrder.FillMedicationRowsOnRadioClick(context.Result);
            } else {
                var RowCount = parseInt(document.getElementById('HiddenFieldRowIndex').value) - 2;
                var MedicationNameId = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_HiddenMedicationNameId').value;
                var MedicationName = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_HiddenMedicationName').value;
                if (MedicationNameId != null && MedicationNameId != "") {
                    var table = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_tableMedicationOrder');
                    for (var i = RowCount; i < table.rows.length; i++) {
                        var row = table.rows[i];
                        var Strength = row.cells[1].getElementsByTagName("select")[0];
                        var Schedule = row.cells[4].getElementsByTagName("select")[0];
                        var ddlPotencyUnitCode = row.cells[9].getElementsByTagName("select")[0];
                        ClientMedicationNonOrder.FillPotencyUnitCodes(MedicationNameId, ddlPotencyUnitCode, null);
                        ClientMedicationNonOrder.FillStrength(MedicationNameId, Strength, null, null);
                        ClientMedicationNonOrder.FillScheduled(Schedule, null);
                    }
                }
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    FillMedicationRowsOnRadioClick: function (result) {
        try {
            var table = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_tableMedicationOrder');
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                row.cells[1].getElementsByTagName("select")[0].disabled = false;
                row.cells[2].getElementsByTagName("input")[0].disabled = false;
                row.cells[3].getElementsByTagName("select")[0].disabled = false;
                row.cells[4].getElementsByTagName("select")[0].disabled = false;
                row.cells[5].getElementsByTagName("input")[0].disabled = false;
                row.cells[6].getElementsByTagName("img")[0].disabled = false;
                row.cells[7].getElementsByTagName("input")[0].disabled = false;
                row.cells[8].getElementsByTagName("input")[0].disabled = false;
                row.cells[9].getElementsByTagName("select")[0].disabled = false;
                row.cells[10].getElementsByTagName("input")[0].disabled = false;
                row.cells[11].getElementsByTagName("input")[0].disabled = false;
                row.cells[12].getElementsByTagName("input")[0].disabled = false;
                row.cells[13].getElementsByTagName("input")[0].disabled = false;
            }
            var pucList = [];
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                if (result.tables.length > 1) {
                    if (i < result.tables[1].rows.length) {
                        var Unit = new Object();
                        Unit.DropDown = row.cells[3].getElementsByTagName("select")[0];
                        Unit.SelectedValue = result.tables[1].rows[i]["Unit"];
                        row.cells[0].getElementsByTagName("img")[0].setAttribute("MedicationId", result.tables[1].rows[i]["ClientMedicationId"]);
                        row.cells[0].getElementsByTagName("img")[0].setAttribute("MedicationInstructionId", result.tables[1].rows[i]["ClientMedicationInstructionId"]);
                        row.cells[2].getElementsByTagName("input")[0].value = result.tables[1].rows[i]["Quantity"];

                        if (result.tables[2] != null) {
                            if (result.tables[2].rows[i]["StartDate"] != null) {
                                row.cells[5].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["StartDate"].format("MM/dd/yyyy");
                            }
                            if (result.tables[2].rows[i]["Days"] != null) {
                                row.cells[7].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Days"];
                            }
                            row.cells[15].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["AutoCalcallow"];
                            if (result.tables[2].rows[i]["AutoCalcallow"] == "Y") {
                                if (result.tables[2].rows[i]["Pharmacy"] != null) {
                                    document.getElementById("ComboBoxPharmacyDD_" + i).value = result.tables[2].rows[i]["Pharmacy"];
                                }
                            } else if (result.tables[2].rows[i]["AutoCalcallow"] == "N") {
                                for (j = 0; j < table.rows.length; j++) {
                                    if (j < result.tables[1].rows.length) {
                                        if (result.tables[1].rows[i]["StrengthId"] == result.tables[1].rows[j]["StrengthId"]) {
                                            if (result.tables[2].rows[i]["PharmacyText"] != null && result.tables[2].rows[i]["PharmacyText"] != '') {
                                                document.getElementById("ComboBoxPharmacyDD_" + i).value = result.tables[2].rows[i]["PharmacyText"];
                                            }
                                            if (i > j) {
                                                document.getElementById("ComboBoxPharmacyDD_" + i).disabled = true;
                                            }
                                        }
                                    }
                                }
                            }
                            if (result.tables[2].rows[i]["Sample"] != null) {
                                row.cells[11].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Sample"];
                            }
                            if (result.tables[2].rows[i]["Stock"] != null) {
                                row.cells[12].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Stock"];
                            }
                            if (result.tables[2].rows[i]["Refills"] != null) {
                                row.cells[10].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Refills"];
                            }

                            if (result.tables[2].rows[i]["EndDate"] != null) {
                                row.cells[13].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["EndDate"].format("MM/dd/yyyy");
                            }
                        }
                        row.cells[14].getElementsByTagName("span")[0].value = result.tables[1].rows[i]["RowIdentifier"];

                        if (result.tables.length > 5) {
                            if (result.tables[3].rows.length > i)
                                row.cells[16].getElementsByTagName("input")[0].value = result.tables[3].rows[i]["RowIdentifier"];
                        }

                        if (result.tables[result.tables.length - 1].rows.length > i) {
                            if (result.tables[result.tables.length - 1].rows[i]["DaysOfWeek"] != null) {
                                row.cells[17].getElementsByTagName("input")[0].value = result.tables[result.tables.length - 1].rows[i]["DaysOfWeek"];
                            }
                        }

                        ClientMedicationNonOrder.FillPotencyUnitCodes(result.tables[0].rows[0]["MedicationNameId"], row.cells[9].getElementsByTagName("select")[0], result.tables[1].rows[i]["PotencyUnitCode"]);
                        ClientMedicationNonOrder.FillStrength(result.tables[0].rows[0]["MedicationNameId"], row.cells[1].getElementsByTagName("select")[0], result.tables[1].rows[i]["StrengthId"], Unit);
                        ClientMedicationNonOrder.FillScheduled(row.cells[4].getElementsByTagName("select")[0], result.tables[1].rows[i]["Schedule"]);
                        var medId = result.tables[1].rows[i]["ClientMedicationId"];
                        var notFound = true;
                        for (var i2 = 0; i2 < pucList.length; i2++) {
                            if (pucList[i2].MedicationId == medId) {
                                row.cells[9].getElementsByTagName("select")[0].disabled = true;
                                notFound = false;
                                break;
                            }
                        }
                        if (notFound) {
                            row.cells[9].getElementsByTagName("select")[0].disabled = false;
                            pucList.push({ "MedicationId": medId });
                        }
                    } else {
                        ClientMedicationNonOrder.FillPotencyUnitCodes(result.tables[0].rows[0]["MedicationNameId"], row.cells[9].getElementsByTagName("select")[0], null);
                        ClientMedicationNonOrder.FillStrength(result.tables[0].rows[0]["MedicationNameId"], row.cells[1].getElementsByTagName("select")[0], null, null);
                        ClientMedicationNonOrder.FillScheduled(row.cells[4].getElementsByTagName("select")[0], null);
                    }
                } else {
                    ClientMedicationNonOrder.FillPotencyUnitCodes(result.tables[0].rows[0]["MedicationNameId"], row.cells[9].getElementsByTagName("select")[0], null);
                    ClientMedicationNonOrder.FillStrength(result.tables[0].rows[0]["MedicationNameId"], row.cells[1].getElementsByTagName("select")[0], null, null);
                    ClientMedicationNonOrder.FillScheduled(row.cells[4].getElementsByTagName("select")[0], null);
                }
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    GetSystemReports: function (stringReportName) {
        try {
            fnShow();
            for (i = 0; i < document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_DropDownListDxPurpose').options.length; i++) {
                if (document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_DropDownListDxPurpose').options[i].selected) {
                    var DiagnosisCode = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_DropDownListDxPurpose').options[i].getAttribute("DSMCode");
                }
            }
            Streamline.SmartClient.WebServices.ClientMedications.GetSystemReportsNewOrder(stringReportName, DiagnosisCode, ClientMedicationNonOrder.onSuccessfullGetSystemReportsNewOrder, ClientMedicationNonOrder.onFailure);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    GetSystemReportsMedicationName: function (stringReportName) {
        try {
            fnShow();
            if (document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_HiddenMedicationNameId').value != "") {
                var MedicationNameId = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_HiddenMedicationNameId').value;
            }
            Streamline.SmartClient.WebServices.ClientMedications.GetSystemReportsMedication(stringReportName, MedicationNameId, ClientMedicationNonOrder.onSuccessfullGetSystemReportsNewOrder, ClientMedicationNonOrder.onFailure);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onSuccessfullGetSystemReportsNewOrder: function (result, context, methodname) {
        try {
            parent.fnHideParentDiv();
            if (result == null)
                return;
            document.getElementById("testNewMedOrder").href = result;
            document.getElementById("testNewMedOrder").click();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    ShowErrorUpdate: function () {
        try {
            var labelErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_LabelErrorMessage');
            var DivErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_DivErrorMessage');
            var ImageError = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_ImageError');
            var tableErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_tableErrorMessage');
            if (DivErrorMessage != null) {
                DivErrorMessage.style.display = 'block';
            }
            if (ImageError != null) {
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
            }
            if (tableErrorMessage != null) {
                tableErrorMessage.style.display = 'block';
            }
            if (labelErrorMessage != null && labelErrorMessage != 'undefined') {
                labelErrorMessage.innerText = "At least one medication must be ordered to prescribe.";
            }
        } catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, Ex);
        }
    },
    FillDrugDropDown: function (MedicationNameId, MedicationName) {
        var context = new Object();
        context.MedicationName = MedicationName;
        context.SelectedValue = MedicationNameId;
        context.MedicationNameId = MedicationNameId;
        Streamline.SmartClient.WebServices.ClientMedications.FillDrugDropdown(MedicationNameId, ClientMedicationNonOrder.onSuccessFillDrugDropDown, ClientMedicationNonOrder.onFailure, context);
    },
    onSuccessFillDrugDropDown: function (result, context) {
        try {
            var cboDrugList = $("#ComboBoxDrugDDList");
            cboDrugList.attr('caller', 'ComboBoxDrugDD');
            var cboDrug = $("#ComboBoxDrugDD");
            if (result == null || result.rows == null || !result.rows) {
                cboDrug.val(context.MedicationName);
                cboDrug.attr('opid', context.MedicationNameId);
                cboDrugList.attr('isempty', 'true');
                cboDrugList.empty();
                return;
            }
            var cboContent = $("<div></div>");
            for (var i = 0; i < result.rows.length; i++) {
                cboContent.append("<p opid='" + result.rows[i]["MedicationNameId"] + "' eopid='" + result.rows[i]["ExternalMedicationNameId"] + "'>" + result.rows[i]["MedicationName"] + "</p>");
            }
            if (cboContent.length > 0) {
                cboDrugList.attr('isempty', 'false');
                cboDrugList.html(cboContent.html());
                if (context.SelectedValue) {
                    var $p = $("p[opid='" + context.SelectedValue + "']", cboDrugList);
                    if ($p.length > 0) {
                        var eventItem = { target: $p[0] };
                        ClientMedicationNonOrder.onSelectedDrugComboList(eventItem, cboDrugList[0], false);
                    }
                }
            } else {
                cboDrug.val(context.MedicationName);
                cboDrug.attr('opid', context.MedicationNameId);
                cboDrugList.attr('isempty', 'true');
                cboDrugList.empty();
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    ChangeNonOrderPageCommentText: function (LabelCommentText, CheckboxIncludeOnPRescription, CommentTextOnCheckBoxUnCheck, CommentTextOnCheckBoxCheck) {
        try {
            var CheckboxIncludeOnPRescriptionId = document.getElementById(CheckboxIncludeOnPRescription);
            var LabelCommentTextId = document.getElementById(LabelCommentText);
            if (CheckboxIncludeOnPRescriptionId.checked) {
                if (LabelCommentTextId != null && LabelCommentTextId != 'undefined') {
                    LabelCommentTextId.innerText = CommentTextOnCheckBoxCheck;
                }
            } else {
                if (LabelCommentTextId != null && LabelCommentTextId != 'undefined') {
                    LabelCommentTextId.innerText = CommentTextOnCheckBoxUnCheck;
                }
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    CheckNonOrderPharmacyUnit: function (RowIndex) {
        try {
            var comboboxValue = document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value;
            var AutoCalculationAllowed = $("[id*=HiddenFieldAutoCalcAllowed" + RowIndex + "]").val();
            if (AutoCalculationAllowed.toUpperCase() != 'N') {
                if (comboboxValue != null && comboboxValue != 'undefined' && comboboxValue != '') {
                    if (comboboxValue.length > 13) {
                        document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                    } else if (isNaN(comboboxValue)) {
                        document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                    } else {
                        if (typeof comboboxValue === "number")
                            comboboxValue = comboboxValue.toString();
                        if (comboboxValue.indexOf('.') > -1) {
                            if (comboboxValue.length - (comboboxValue.indexOf('.') + 1) > DigitsAfterDecimal) {
                                document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                            } else if (comboboxValue.indexOf('.') > DigitsBeforeDecimal) {
                                document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                            }
                        } else if (comboboxValue.length > DigitsBeforeDecimal) {
                            document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                        }
                    }
                }
            }
        } catch (e) {

        }
    },
    onClickDrugComboList: function (object, listobj) {
        var $list = $(listobj);
        if ($list.is(':visible')) {
            $list.hide();
        } else {
            if ($list.attr('isempty') == 'true') {
                return;
            } else {
                var $obj = $(object);
                $list.attr('caller', 'ComboBoxDrugDD').css({ 'left': $obj.offset().left, 'top': $obj.offset().top + $obj.height() + 5 }).width($obj.width()).show().scrollTop(0);
                var $pos = $('p[opid=\'' + $('#ComboBoxDrugDD', $obj).attr('opid') + '\']', $list);
                if ($pos.length > 0) {
                    $list.scrollTop($pos.offset().top - $pos.height() - $obj.offset().top);
                }
            }
        }
    },
    onSelectedDrugComboList: function (event, parentObj, triggerSetId) {
        var $obj = $((event.target || event.srcElement));
        var $parent = $(parentObj);
        var externalMedicationNameId = $obj.attr('eopid');
        var medicationNameId = $obj.attr('opid');
        var medicationName = $obj.text();
        $('#' + $parent.attr('caller')).val(medicationName).attr('opid', medicationNameId);
        $parent.hide();
        if (triggerSetId === true) {
            //SetId(medicationNameId, medicationName, '', externalMedicationNameId, '');
            SetId(medicationNameId, medicationName, '', '', '');
        }
    },
    onChangeDrugComboList: function (object, listobj) {
        var $list = $(listobj);
        if ($list.is(':visible')) {
            $list.hide();
        }
        var $obj = $(object);
        var medName = $obj.val().toLowerCase();
        var $p = $("p", $list).filter(function (i) {
            return this.innerHTML.toLowerCase() == medName;
        });
        if ($p.length > 0) {
            var eventItem = { target: $p[0] };
            ClientMedicationNonOrder.onSelectedDrugComboList(eventItem, $list[0], false);
        } else {
            $obj.attr('opid', '');
        }
    },
    onKeyDownComboList: function (event, object) {
        if (event.keyCode == 9) {
            var $list = $(object);
            if ($list.is(':visible')) {
                $list.hide();
            }
        }
    },
    ResetDrugComboList: function (listobj) {
        var $list = $(listobj);
        if ($list.is(':visible')) {
            $list.hide();
        }
    },
    ClearDrugComboList: function (cboDrug, cboDrugList) {
        var $cboDrug = $(cboDrug);
        var $cboDrugList = $(cboDrugList);
        $cboDrug.val("");
        $cboDrug.attr('opid', "");
        $cboDrugList.attr('isempty', 'true');
        $cboDrugList.empty();
    },
    onBlurDrugComboList: function (object, listobj) {
        var $list = $(listobj);
        if ($list.is(':visible')) {
            return;
        }
        var $obj = $(object);
        if ($obj.attr('opid') != "") {
            return;
        } else {
            var LabelErrorMessage = $("[id*=LabelErrorMessage]")[0];
            var DivErrorMessage = $("[id*=DivErrorMessage]")[0];
            var ImageError = $("[id*=ImageError]")[0];
            var tableGridErrorMessage = $("[id*=tableGridErrorMessage]")[0];
            var tableErrorMessage = $("[id*=tableErrorMessage]")[0];
            var cmbText = $obj.val();
            if (cmbText.length <= 2) {
                $("[id*=ImgSearch]")[0].style.display = "none";
                tableErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                DivErrorMessage.style.display = 'block';
                LabelErrorMessage.innerText = 'Please enter at least three characters.';
                $obj.focus();
                return false;
            }
            var opid = '';
            $('p', $list).each(function (item) {
                if ($(item).text() == cmbText) opid = $(item).attr('opid');
            });
            if (opid != '') {
                $obj.attr('opid', opid);
                $("select[id$=DropDownListDxPurpose]")[0].focus();
                return;
            }
            fnShow();
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            LabelErrorMessage.innerText = '';
            tableErrorMessage.style.display = 'none';

            var $divSearch = $("#DivSearch");
            $("#topborder", $divSearch).text("Select Drug");
            var $iFrameSearch = $('#iFrameSearch', $divSearch);
            $iFrameSearch.attr('src', 'ClientMedicationDrug.aspx?MedicationName=' + escape(cmbText));
            $iFrameSearch.css({ 'height': '315px', 'width': '400px' });
            var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
            left = left > 0 ? left : 10;
            var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
            top = top > 0 ? top : 10;
            $divSearch.css({ 'top': top, 'left': left });
            $divSearch.draggable();
            $divSearch.css('display', 'block');
        }
    },
    //---
    onClickPharmacyComboList: function (object, listobj) {
        var $list = $(listobj);
        if ($list.is(':visible')) {
            $list.hide();
        } else {
            if ($list.attr('isempty') == 'true') {
                return;
            } else {
                var $obj = $(object);
                $list.css({ 'left': $obj.offset().left, 'top': $obj.offset().top + $obj.height() + 5 }).width($obj.width()).show().scrollTop(0);
            }
        }
    },
    onSelectedPharmacyComboList: function (event, parentObj) {
        var $obj = $((event.target || event.srcElement));
        var $parent = $(parentObj);
        var pharmacyText = $obj.text();
        $('#' + $parent.attr('caller')).val(pharmacyText);
        $parent.hide();
    },
    onChangePharmacyComboList: function (object, listobj) {
        var $list = $(listobj);
        if ($list.is(':visible')) {
            $list.hide();
        }
        //var $obj = $(object);
        //var pharmacyText = $obj.val().toLowerCase();
        //var $p = $("p", $list).filter(function(i) {
        //    return this.innerHTML.toLowerCase() == medName;
        //});
        //if ($p.length > 0) {
        //    var eventItem = { target: $p[0] };
        //    ClientMedicationNonOrder.onSelectedPharmacyComboList(eventItem, $list[0]);
        //}
    },
    onKeyDownPharmacyComboList: function (event, object) {
        if (event.keyCode == 9) {
            var $list = $(object);
            if ($list.is(':visible')) {
                $list.hide();
            }
        } else if (event.keyCode == 40) {
            ClientMedicationNonOrder.onClickPharmacyComboList('#' + event.srcElement.id, object);
        }
    },
    ResetPharmacyComboList: function (listobj) {
        var $list = $(listobj);
        if ($list.is(':visible')) {
            $list.hide();
        }
    },
    ClearPharmacyComboList: function (cboPharmacy, cboPharmacyList) {
        if (cboPharmacy != "") {
            var $cboPharmacy = $(cboPharmacy);
            $cboPharmacy.val("");
        }
        if (cboPharmacyList != "") {
            var $cboPharmacyList = $(cboPharmacyList);
            $cboPharmacyList.attr('isempty', 'true');
            $cboPharmacyList.empty();
        }
    },
    PopulatePharmacyTextList: function (cboPharmacyList, result) {
        var cboContent = $("<div></div>");
        for (var i = 0; i < result.rows.length; i++) {
            cboContent.append("<p>" + result.rows[i]["PharmText"] + "</p>");
        }
        if (cboContent.length > 0) {
            cboPharmacyList.attr('isempty', 'false');
            cboPharmacyList.html(cboContent.html());
        }
    }
    //---
};