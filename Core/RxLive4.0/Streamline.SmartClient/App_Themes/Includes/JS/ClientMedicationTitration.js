
var EndDate;
var StartDateBox;
var XmlHttp;
var PanelTitrationSteps = "";
var LabelGridErrorMessage = "";
var ImageGridError = "";
var LabelErrorMessage = "";
var ImageError = "";
var TitrationStepNumber = "";
var NextStepStartDate = "";
var ToModifyStepNumber = "";


/// <summary>
/// Author Rishu Chopra
/// create xmlhttp object
/// </summary>
function CreateXmlHttp() {
    try {
        XmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
        Browser = "IE";
    }
    catch (e) {
        try {
            XmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            Browser = "IE";
        }
        catch (oc) {
            XmlHttp = null;
        }
    }
    if (!XmlHttp && typeof XMLHttpRequest != "undefined") {
        XmlHttp = new XMLHttpRequest();
        Browser = "FX";
    }
}

function validateCharacters(strValue) {
    var NewStrValue = strValue.replace(/[^ a-zA-Z0-9._,&#\''\-]/g, '');
    if (NewStrValue.indexOf('<') > 0 || NewStrValue.indexOf('>') > 0)
        return false;
}


var ClientMedicationTitration = {
    CalToBeShown: function (ImgCalID, TextboxID) {
        try {
            var method = document.getElementById("txtButtonValue").value;
            if (method == "REFILL" || method == "Refill") {
                return false;
            }
            else
                CalShow(ImgCalID, TextboxID);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    CalShow: function (ImgCalID, TextboxID) {
        try {
            Calendar.setup({
                inputField: TextboxID,
                ifFormat: "%m/%d/%Y",
                showsTime: false,
                button: ImgCalID,
                step: 1,
                onUpdate: function (obj) { if (obj.targetElement != null) obj.targetElement.focus(); }
            });
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    CalculatePharmacy: function (objRow) {
        try {
            parent.fnShow();
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
                Streamline.SmartClient.WebServices.CommonService.CalculatePharmacy(Days, Quantity, Schedule, Sample, Stock, ClientMedicationTitration.onSucceededPharmacy, ClientMedicationTitration.onFailure, objRow);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    onSucceededPharmacy: function (result, context) {
        try {
            eval("ComboPharmaText" + context.rowIndex).SetText(result);
            var Pharma = Number.parseInvariant(context.Pharmacy.value);
            if (isNaN(Pharma))
                Pharma = 0;
            var calculatedQty = result;
            if (calculatedQty > 0 || ((calculatedQty > 0.01) && (calculatedQty < 0.99)))
                calculatedQty = result;
            else
                calculatedQty = 0;
            eval("ComboPharmaText" + context.rowIndex).SetText(calculatedQty);
            if (Pharma == 0) {
                context.Pharmacy.value = "";
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    CalculateEndDate: function (startDate, days, refill, enddate) {
        try {
            ClientMedicationTitration.ValidInteger(document.getElementById(days));
            ClientMedicationTitration.ValidDecimal(document.getElementById(refill));
            parent.fnShow();
            var Days = document.getElementById(days).value;
            var Refill = document.getElementById(refill).value;
            if (document.getElementById(startDate).value == "")
                return
            if (Days == "")
                Days = 0;
            if (Refill == "")
                Refill = 0;
            EndDate = document.getElementById(enddate);
            StartDateBox = document.getElementById(startDate);
            if (!Date.parse(document.getElementById(startDate).value)) {
                document.getElementById(startDate).value = "";
                return
            }
            Streamline.SmartClient.WebServices.CommonService.CalculateTitrationEndDate(document.getElementById(startDate).value, Days, Refill, ClientMedicationTitration.onSucceeded, ClientMedicationTitration.onFailure);
        }
        catch (e) {
            StartDateBox.innerText = "";
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    onSucceeded: function (result) {
        try {
            if (result == "") {
                StartDateBox.innerText = "";
                EndDate.innerText = "";
            }
            else
                //EndDate.innerText = result;
                document.getElementById('TextBoxEndDate').value = result;
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    FillStrength: function (intMedicationNameId, ddlStrength, selectedValue, UnitObject, extraArgs) {
        try {
            if (extraArgs === undefined) {
                extraArgs = new Object();
                extraArgs.NoOfRows = 0;
                extraArgs.CallRadioClick = false;
                extraArgs.RowNumber = -1;
            }
            parent.fnShow();
            if (intMedicationNameId == null || ddlStrength == null) {
                parent.fnHideParentDiv();
                return;
            }
            var context = new Object();
            context.DropDown = ddlStrength;
            context.SelectedValue = selectedValue;
            context.Unit = UnitObject;
            context.MedicationNameId = intMedicationNameId;
            context.args = extraArgs;
            Streamline.SmartClient.WebServices.ClientMedications.GetMedicationStrength(intMedicationNameId, ClientMedicationTitration.onStrengthSucceeded, ClientMedicationTitration.onFailure, context)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onStrengthSucceeded: function (result, context, methodname) {
        try {
            var DropDown = context.DropDown;
            DropDown.innerHTML = "";
            if (result == null || result.length <= 0)
                return;
            var medId = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationId');
            DropDown.options[DropDown.length] = new Option("", "-1");
            for (var i = 0; i < result.length; i++) {
                optionItem = new Option(result[i]["Strength"], result[i]["MedicationId"], false, false);
                optionItem.setAttribute("MedicationId", result[i]["MedicationId"]);
                optionItem.setAttribute("PotencyUnitCode", result[i]["PotencyUnitCode"]);
                DropDown.options[DropDown.length] = optionItem;
            }
            if (context.SelectedValue) {
                DropDown.value = context.SelectedValue;
                ClientMedicationTitration.FillUnit(DropDown, context.Unit.DropDown.id, context.Unit.SelectedValue, context.args);
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    FillScheduled: function (ddlSchedule, selectedValue, extraArgs) {
        try {
            if (extraArgs === undefined) {
                extraArgs = new Object();
                extraArgs.NoOfRows = 0;
                extraArgs.CallRadioClick = false;
                extraArgs.RowNumber = -1;
            }
            parent.fnShow();
            var context = new Object();
            context.DropDown = ddlSchedule;
            context.SelectedValue = selectedValue;
            context.args = extraArgs;
            Streamline.SmartClient.WebServices.ClientMedications.FillSchedule(ClientMedicationTitration.onScheduledSucceeded, ClientMedicationTitration.onFailure, context)
        }
        catch (e) {
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
                DropDown.options[DropDown.length] = optionItem;
            }
            if (context.SelectedValue) {
                DropDown.value = context.SelectedValue;
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    onScheduleBlur: function (Schedule) {
        try {
            document.getElementById('buttonInsert').disabled = false;
            ClientMedicationTitration.SetDocumentDirty();
            ClientMedicationTitration.ManipulateRowValues(null, Schedule);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onUnitChange: function (rowIndex) {
        try {
            document.getElementById('buttonInsert').disabled = false;
            ClientMedicationTitration.SetDocumentDirty();
            var context = new Object();
            context.rowIndex = rowIndex;
            var table = $("[id$=tableMedicationStepBuilder]")[0];
            context.SelectedValue = "";
            var currentRow = table.rows[context.rowIndex];
            var dosage = 0;
            if (currentRow.cells[2].getElementsByTagName("input")[0].value != "")
                dosage = parseFloat(currentRow.cells[2].getElementsByTagName("input")[0].value);
            var schedule = currentRow.cells[4].getElementsByTagName("select")[0].value;
            if (currentRow.cells[9].getElementsByTagName("input")[0].value == "Y") {
                parent.$("input[id$=HiddenFieldSelectedValue]").val("");
            }
            if (currentRow.cells[9].getElementsByTagName("input")[0].value == "N") {
                if (eval("ComboPharmaText" + rowIndex).GetSelectedItem() != null) {
                    if (eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != undefined && eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != "")
                        context.SelectedValue = eval("ComboPharmaText" + rowIndex).GetSelectedItem().value;
                    parent.$("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
                }
                else if (eval("ComboPharmaText" + rowIndex).GetSelectedItem() == null && parent.$("input[id$=HiddenFieldSelectedValue]").val() == "") {
                    parent.$("input[id$=HiddenFieldSelectedValue]").val("");
                }
                if (currentRow.cells[1].getElementsByTagName("select")[0].value > 0 && currentRow.cells[2].getElementsByTagName("input")[0].value > 0 && currentRow.cells[4].getElementsByTagName("select")[0].value > 0 && $("[id*=TextBoxDays]").val() > 0 && currentRow.cells[3].getElementsByTagName("select")[0].value > 0) {
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
                    eval("ComboPharmaText" + rowIndex).ClearItems();
                    eval("ComboPharmaText" + rowIndex).SetText("");
                    Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(currentRow.cells[1].getElementsByTagName("select")[0].value, dosage, schedule, $("[id*=TextBoxDays]").val(), ClientMedicationTitration.onDispenseQuantitySucceeded, ClientMedicationTitration.onFailure, context);
                }
                else {
                    eval("ComboPharmaText" + rowIndex).ClearItems();
                    eval("ComboPharmaText" + rowIndex).SetText("");
                }
            }
            else {
                eval("ComboPharmaText" + rowIndex).ClearItems();
                eval("ComboPharmaText" + rowIndex).SetText("");
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onScheduleChange: function (rowIndex) {
        try {
            document.getElementById('buttonInsert').disabled = false;
            ClientMedicationTitration.SetDocumentDirty();
            var context = new Object();
            context.rowIndex = rowIndex;
            var table = $("[id$=tableMedicationStepBuilder]")[0];
            context.SelectedValue = "";
            var currentRow = table.rows[context.rowIndex];
            var dosage = 0;
            if (currentRow.cells[2].getElementsByTagName("input")[0].value != "")
                dosage = parseFloat(currentRow.cells[2].getElementsByTagName("input")[0].value);
            var schedule = currentRow.cells[4].getElementsByTagName("select")[0].value;
            if (currentRow.cells[9].getElementsByTagName("input")[0].value == "Y") {
                parent.$("input[id$=HiddenFieldSelectedValue]").val("");
            }
            if (currentRow.cells[9].getElementsByTagName("input")[0].value == "N") {
                if (eval("ComboPharmaText" + rowIndex).GetSelectedItem() != null) {
                    if (eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != undefined && eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != "")
                        context.SelectedValue = eval("ComboPharmaText" + rowIndex).GetSelectedItem().value;
                    parent.$("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
                }
                else if (eval("ComboPharmaText" + rowIndex).GetSelectedItem() == null && $("input[id$=HiddenFieldSelectedValue]").val() == "") {
                    $("input[id$=HiddenFieldSelectedValue]").val("");
                }
                if (currentRow.cells[1].getElementsByTagName("select")[0].value > 0 && currentRow.cells[2].getElementsByTagName("input")[0].value > 0 && currentRow.cells[4].getElementsByTagName("select")[0].value > 0 && $("[id*=TextBoxDays]").val() > 0 && currentRow.cells[3].getElementsByTagName("select")[0].value > 0) {
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
                    eval("ComboPharmaText" + rowIndex).ClearItems();
                    eval("ComboPharmaText" + rowIndex).SetText("");
                    Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(currentRow.cells[1].getElementsByTagName("select")[0].value, dosage, schedule, $("[id*=TextBoxDays]").val(), ClientMedicationTitration.onDispenseQuantitySucceeded, ClientMedicationTitration.onFailure, context);
                }
                else {
                    eval("ComboPharmaText" + rowIndex).ClearItems();
                    eval("ComboPharmaText" + rowIndex).SetText("");
                }
            }
            else {
                eval("ComboPharmaText" + rowIndex).ClearItems();
                eval("ComboPharmaText" + rowIndex).SetText("");
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    //onStartDate: function () {
    //    try {
    //        document.getElementById('buttonInsert').disabled = false;
    //        ClientMedicationTitration.SetDocumentDirty();
    //    }
    //    catch (e) {
    //        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    //    }
    //},
    //onEndDate: function () {
    //    try {
    //        document.getElementById('buttonInsert').disabled = false;
    //        ClientMedicationTitration.SetDocumentDirty();
    //    }
    //    catch (e) {
    //        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    //    }
    //},
    onStrengthChange: function (obj, unit, unitValue, textBoxQuantity, rowIndex) {
        try {
            ClientMedicationTitration.SetDocumentDirty();
            var context = new Object();
            context.rowIndex = rowIndex;
            var table = $("[id$=tableMedicationStepBuilder]")[0];
            var currentRow = table.rows[context.rowIndex];
            var hiddenDefaultPrescribingQuantity = parent.document.getElementById("HiddenDefaultPrescribingQuantity").value;
            var textboxQuantity = document.getElementById(textBoxQuantity);
            if (textboxQuantity.value == '') {
                textboxQuantity.value = hiddenDefaultPrescribingQuantity;
            }
            ClientMedicationTitration.FillUnit(obj, unit, unitValue);
            document.getElementById('buttonInsert').disabled = false;
            Streamline.SmartClient.WebServices.ClientMedications.CalculateAutoCalcAllow(currentRow.cells[1].getElementsByTagName("select")[0].value, ClientMedicationTitration.onAutoCalcAllowSucceeded, ClientMedicationTitration.onFailure, context);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onAutoCalcAllowSucceeded: function (result, context) {
        try {
            var rowIndex = context.rowIndex;
            var table = $("[id$=tableMedicationStepBuilder]")[0];
            var currentRow = table.rows[rowIndex];
            if (result.rows.length > 0) {
                currentRow.cells[9].getElementsByTagName("input")[0].value = result.rows[0]["AutoCalcAllowed"];
                for (var i = 0; i < table.rows.length; i++) {
                    var row = table.rows[i];
                    eval("ComboPharmaText" + i).SetEnabled(true);
                }
                for (var i = 0; i < table.rows.length; i++) {
                    var row = table.rows[i];
                    for (var j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (row.cells[1].getElementsByTagName("select")[0].value != "-1") {
                            if (row.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value && row.cells[9].getElementsByTagName("input")[0].value == "N") {
                                if (j > i) {
                                    eval("ComboPharmaText" + j).SetEnabled(false);
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
            if (currentRow.cells[9].getElementsByTagName("input")[0].value == "Y") {
                parent.$("input[id$=HiddenFieldSelectedValue]").val("");
            }
            if (currentRow.cells[9].getElementsByTagName("input")[0].value == "N") {
                if (eval("ComboPharmaText" + rowIndex).GetSelectedItem() != null) {
                    if (eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != undefined && eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != "")
                        newContext.SelectedValue = eval("ComboPharmaText" + rowIndex).GetSelectedItem().value;
                    parent.$("input[id$=HiddenFieldSelectedValue]").val(newContext.SelectedValue);
                }
                else if (eval("ComboPharmaText" + rowIndex).GetSelectedItem() == null && $("input[id$=HiddenFieldSelectedValue]").val() == "") {
                    $("input[id$=HiddenFieldSelectedValue]").val("");
                }
                if (currentRow.cells[1].getElementsByTagName("select")[0].value > 0 && currentRow.cells[2].getElementsByTagName("input")[0].value > 0 && currentRow.cells[4].getElementsByTagName("select")[0].value > 0 && $("[id*=TextBoxDays]").val() > 0 && currentRow.cells[3].getElementsByTagName("select")[0].value > 0) {
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
                    eval("ComboPharmaText" + rowIndex).ClearItems();
                    eval("ComboPharmaText" + rowIndex).SetText("");
                    Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(currentRow.cells[1].getElementsByTagName("select")[0].value, dosage, schedule, $("[id*=TextBoxDays]").val(), ClientMedicationTitration.onDispenseQuantitySucceeded, ClientMedicationTitration.onFailure, newContext);
                }
                else {
                    eval("ComboPharmaText" + rowIndex).ClearItems();
                    eval("ComboPharmaText" + rowIndex).SetText("");
                }
            }
            else {
                eval("ComboPharmaText" + rowIndex).ClearItems();
                eval("ComboPharmaText" + rowIndex).SetText("");
            }
        }
        catch (e) {
        }
    },
    FillUnit: function (ddlStrength, ddlUnit, selectedValue, extraArgs) {
        try {
            if (extraArgs === undefined) {
                extraArgs = new Object();
                extraArgs.NoOfRows = 0;
                extraArgs.CallRadioClick = false;
                extraArgs.RowNumber = -1;
            }
            if (ddlStrength.selectedIndex == null || ddlStrength.selectedIndex <= 0)
                return;
            parent.fnShow();
            var MedicationId = ddlStrength.options[ddlStrength.selectedIndex].getAttribute('MedicationId');
            var context = new Object();
            context.DropDown = document.getElementById(ddlUnit);
            context.SelectedValue = selectedValue;
            context.args = extraArgs;
            Streamline.SmartClient.WebServices.ClientMedications.FillUnit(MedicationId, ClientMedicationTitration.onUnitSucceeded, ClientMedicationTitration.onFailure, context)
            Streamline.SmartClient.WebServices.ClientMedications.C2C5Drugs(MedicationId, ClientMedicationTitration.onC2C5DrugSucceeded, ClientMedicationTitration.onFailure, context)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    onC2C5DrugSucceeded: function (result, context, methodname) {
        try {
            try {
                _Row = context.DropDown.parentNode.parentNode;
                _Row.cells[7].setAttribute("MedicationCategory", "");
            }
            catch (e) {
            }
            if (result == null || result.rows == null || !result.rows)
                return;
            if (result.rows.length > 0) {
                _Row.cells[7].setAttribute("MedicationCategory", result.rows[0]["Category"]);
            }
            if ((context.args.NoOfRows == context.args.RowNumber) && (context.args.CallRadioClick == true)) {
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
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
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    onFailure: function (error) {
        parent.fnHideParentDiv();
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        else {
            alert(error.get_message());
        }
    },
    DeleteFromList: function (e) {
        try {
            parent.fnShow();
            Streamline.SmartClient.WebServices.ClientMedications.DeleteTitrationStep(e.MedicationId, e.TitrationStepNumber, ClientMedicationTitration.onDeleteButtonSucceeded, ClientMedicationTitration.onFailure, e)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onDeleteButtonSucceeded: function (result, context, methodname) {
        try {
            if (result == true) {
                ClientMedicationTitration.GetMedicationList(PanelTitrationSteps); //,'','Y');
                ClientMedicationTitration.FillTitrationSummary();
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    RadioButtonParameters: function (e, DropDownTitrationSteps, TextBoxStartDate, TextBoxDays, TextBoxEndDate, TableName, HiddenRowIdentifier, TextBoxRefills) {
        try {
            parent.fnShow();
            var context = new Object();
            context.TitrationStep = DropDownTitrationSteps;
            context.StartDate = TextBoxStartDate;
            context.EndDate = TextBoxEndDate;
            context.Days = TextBoxDays;
            context.Table = TableName;
            context.Refill = TextBoxRefills;
            context.HiddenRowIdentifier = HiddenRowIdentifier;
            ToModifyStepNumber = e.TitrationStepNumber;
            Streamline.SmartClient.WebServices.ClientMedications.RadioButtonClickTitration(e.MedicationId, e.TitrationStepNumber, ClientMedicationTitration.onRadioButtonSucceeded, ClientMedicationTitration.onFailure, context)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onRadioButtonSucceeded: function (result, context, methodname) {
        try {
            document.getElementById(context.TitrationStep).value = result.tables[1].rows[0]["TitrationStepNumber"];
            document.getElementById(context.StartDate).value = result.tables[2].rows[0]["StartDate"].format("MM/dd/yyyy");
            document.getElementById(context.EndDate).value = result.tables[2].rows[0]["EndDate"].format("MM/dd/yyyy");
            document.getElementById(context.Days).value = result.tables[2].rows[0]["Days"];
            document.getElementById(context.Refill).value = result.tables[2].rows[0]["Refills"];
            document.getElementById(context.HiddenRowIdentifier).value = result.tables[0].rows[0]["RowIdentifier"];
            var table1 = document.getElementById(context.Table);
            ClientMedicationTitration.FillMedicationRowsOnRadioClick(result, true);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    ClientMedicationInstructionRow: function () {
        this.StrengthId;
        this.Unit;
        this.Schedule;
        this.Quantity;
        this.Days;
        this.Pharmacy;
        this.Sample;
        this.Stock;
        this.Refills;
        this.StartDate;
        this.EndDate;
        this.Instruction;
        this.TitrateSummary;
        this.RowIdentifierCMI;
        this.PotencyUnitCode;
    },
    ClearDates: function (TextBoxStartDate, TextBoxEndDate, TextBoxDays) {
        try {
            var today = new Date()
            document.getElementById(TextBoxStartDate).value = today.format("MM/dd/yyyy");
            document.getElementById(TextBoxEndDate).value = "";
            document.getElementById(TextBoxDays).value = "";
            ClientMedicationTitration.FillSteps();
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ClearTable: function (tbl) {
        try {
            var table = document.getElementById(tbl);
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                ClientMedicationTitration.ClearRow(row, i);
            }
            Streamline.SmartClient.WebServices.ClientMedications.ClearTemporaryTitrationDeletedRowsFlags(ClientMedicationTitration.onClearMedicationSucceeded, ClientMedicationTitration.onClearMedicationFailure)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onClearMedicationFailure: function (error, context) {
        parent.fnHideParentDiv();
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        else {
            alert(error.get_message());
        }
        return false;
    },
    onClearMedicationSucceeded: function (result, context, methodname) {
        try {
        }
        catch (e) {
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    ClearRow: function (row, rowIndex) {
        try {
            row.cells[0].getElementsByTagName("img")[0].removeAttribute("MedicationId");
            row.cells[0].getElementsByTagName("img")[0].removeAttribute("MedicationInstructionId");
            row.cells[1].getElementsByTagName("select")[0].value = -1;
            row.cells[2].getElementsByTagName("input")[0].value = "";
            row.cells[3].getElementsByTagName("select")[0].value = -1;
            row.cells[4].getElementsByTagName("select")[0].value = -1;
            eval("ComboPharmaText" + rowIndex).SetText("");
            eval("ComboPharmaText" + rowIndex).ClearItems();
            row.cells[6].getElementsByTagName("input")[0].value = "";
            row.cells[7].getElementsByTagName("input")[0].value = "";
            row.cells[7].setAttribute("RowIdentifierCMI", 'undefined');
            row.cells[9].getElementsByTagName("input")[0].value = "";
            parent.$("input[id$=HiddenFieldSelectedValue]").val("");
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    FillTitrationRow: function (tbl, TextBoxRefills, DropDownTitrationStep, TextBoxStartDate, TextBoxDays, TextBoxEndDate, LabelErrorMessage, ImageError, PanelTitrationSteps, HiddenRowIdentifier, LabelGridErrorMessage, ImageGridError, HiddenMedicationNameId) {
        try {
            var method = parent.document.getElementById("txtButtonValue").value;
            parent.fnShow();
            var context = new Object();
            context.Panel = PanelTitrationSteps;
            context.LabelErrorMessage = LabelErrorMessage;
            context.ImageError = ImageError;
            context.LabelGridErrorMessage = LabelGridErrorMessage;
            context.ImageGridError = ImageGridError;
            var arrayobjpushClientMedicationInstructionrow = new Array();
            var ExitLoop = false;
            var LabelErrorMessage = document.getElementById(LabelErrorMessage);
            var ImageError = document.getElementById(ImageError);
            var LabelGridErrorMessage = document.getElementById(LabelGridErrorMessage);
            var ImageGridError = document.getElementById(ImageGridError);
            if (document.getElementById(TextBoxRefills).value != "")
                var Refills = document.getElementById(TextBoxRefills).value;
            else
                var Refills = "0";
            var TitrationStep = document.getElementById(DropDownTitrationStep).value;
            TitrationStepNumber = TitrationStep;
            document.getElementById(DropDownTitrationStep).disabled = false;
            var StartDate = document.getElementById(TextBoxStartDate).value;
            var EndDate = document.getElementById(TextBoxEndDate).value;
            var Days = document.getElementById(TextBoxDays).value;
            var MedicationNameId = document.getElementById(HiddenMedicationNameId).value;
            var RowIdentifierCM = document.getElementById(HiddenRowIdentifier).value;
            var table = document.getElementById(tbl);
            for (var i = 0; i < table.rows.length; i++) {
                var objClientMedicationInstructionrow = new ClientMedicationTitration.ClientMedicationInstructionRow();
                if (ExitLoop == false) {
                    var NextCnt = i;
                    var row = table.rows[i];
                    var strengthObject = row.cells[1].getElementsByTagName("select")[0];
                    var Strength = strengthObject.value;
                    var Quantity = row.cells[2].getElementsByTagName("input")[0].value;
                    var Unit = row.cells[3].getElementsByTagName("select")[0].value;
                    var Schedule = row.cells[4].getElementsByTagName("select")[0].value;
                    if (row.cells[9].getElementsByTagName("input")[0].value == "Y") {
                        if (eval("ComboPharmaText" + i).GetText() == "")
                            eval("ComboPharmaText" + i).SetText("0");
                    }
                    var Pharma = eval("ComboPharmaText" + i).GetText();
                    if (row.cells[6].getElementsByTagName("input")[0].value == "")
                        row.cells[6].getElementsByTagName("input")[0].value = 0;
                    var Sample = row.cells[6].getElementsByTagName("input")[0].value;
                    if (row.cells[7].getElementsByTagName("input")[0].value == "")
                        row.cells[7].getElementsByTagName("input")[0].value = 0;
                    var Stock = row.cells[7].getElementsByTagName("input")[0].value;
                    if (row.cells[3].getElementsByTagName("select")[0].selectedIndex != '-1')
                        var Instruction = row.cells[1].getElementsByTagName("select")[0].options[row.cells[1].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[2].getElementsByTagName("input")[0].value + " " + row.cells[3].getElementsByTagName("select")[0].options[row.cells[3].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[4].getElementsByTagName("select")[0].options[row.cells[4].getElementsByTagName("select")[0].selectedIndex].innerText;
                    if (NextCnt < table.rows.length - 1) {
                        NextCnt = NextCnt + 1
                        var nextrow = table.rows[NextCnt];
                        var nextStrength = nextrow.cells[1].getElementsByTagName("select")[0].value;

                        if (nextStrength == '-1' || Strength == "") {
                            ExitLoop = true;
                            ImageError.style.visibility = 'hidden';
                            ImageError.style.display = 'none';
                            LabelErrorMessage.innerText = '';

                            ImageError.style.visibility = 'hidden';
                            ImageError.style.display = 'none';
                            LabelErrorMessage.innerText = '';
                        }
                    }
                    if (Strength == '-1' || Strength == "") {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Please enter Strength.');
                        parent.fnHideParentDiv();
                        return false;
                    }
                    else if (Quantity == '') {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Please enter Dose.');
                        parent.fnHideParentDiv();
                        return false;
                    }
                    else if (Quantity <= 0) {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Dose should be greater than 0.');
                        parent.fnHideParentDiv();
                        return false;
                    }
                    else if (Unit == '-1' || Unit == "") {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Please select Unit.');
                        parent.fnHideParentDiv();
                        return false;
                    }
                    else if (Schedule == '-1' || Schedule == "") {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Please select Directions.');
                        parent.fnHideParentDiv();
                        return false;
                    }
                    else if (StartDate == '') {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Please enter  start date.');
                        parent.fnHideParentDiv();
                        return false;
                    }
                    else if (Days == '') {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Please enter Days.');
                        parent.fnHideParentDiv();
                        return false;
                    }
                    else if ((Number.parseInvariant(Days) < 1) || (Number.parseInvariant(Days) > 365)) {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Days must be in the range 1 to 365 .');
                        parent.fnHideParentDiv();
                        return false;
                    }
                    else if (Pharma <= 0) {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Dispense Qty should be greater than 0.');
                        parent.fnHideParentDiv(); // Added by PranayB 08/28
                        return false;

                    }
                    var DateStart = new Date(StartDate);
                    var DateEnd = new Date(EndDate);
                    if (DateEnd < DateStart) {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'End Date should be greater than Start Date.');
                        parent.fnHideParentDiv();
                        return false;
                    }
                    var Category = row.cells[7].getAttribute("MedicationCategory");
                    flag = false;
                    var k = 0;
                    if (row.cells[9].getElementsByTagName("input")[0].value == "N") {
                        for (j = 0; j < table.rows.length; j++) {
                            var newRow = table.rows[j];
                            if (i != j) {
                                if (row.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                    if (eval("ComboPharmaText" + j).GetText() == '') {
                                        k = 0;
                                    }
                                    else {
                                        k = k + 1;
                                        break;
                                    }
                                }
                            }
                        }
                        if (k == 0) {
                            if (eval("ComboPharmaText" + i).GetText() == '') {
                                flag = true;
                            }
                        }
                        if (flag == true) {
                            ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Only one dispense quantity is allowed per strength.');
                            parent.fnHideParentDiv();
                            eval("ComboPharmaText" + i).SetText("");
                            eval("ComboPharmaText" + i).GetInputElement().focus();
                            return false;
                        }
                    }
                    else if (row.cells[9].getElementsByTagName("input")[0].value == "Y") {
                        if (Pharma < 0) {
                            ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Sample/Stock cannot be more than the order dose.');
                            parent.fnHideParentDiv();
                            eval("ComboPharmaText" + i).SetText("");
                            eval("ComboPharmaText" + i).GetInputElement().focus();
                            return false;
                        }
                    }
                    if (Sample < 0) {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Sample must be greater than or equal to zero.');
                        parent.fnHideParentDiv();
                        row.cells[6].getElementsByTagName("input")[0].value = "";
                        row.cells[6].getElementsByTagName("input")[0].focus();
                        return false;
                    }
                    if (Stock < 0) {
                        ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Stock must be greater than or equal to zero.');
                        parent.fnHideParentDiv();
                        row.cells[7].getElementsByTagName("input")[0].value = "";
                        row.cells[7].getElementsByTagName("input")[0].focus();
                        return false;
                    }
                    if (row.cells[9].getElementsByTagName("input")[0].value == "Y") {
                        if (Pharma + Sample + Stock <= 0) {
                            ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, 'Medication must have Dispense Qty+Sample+Stock>0.');
                            parent.fnHideParentDiv();
                            row.cells[6].getElementsByTagName("input")[0].value = "";
                            row.cells[7].getElementsByTagName("input")[0].value = "";
                            row.cells[6].getElementsByTagName("input")[0].focus();
                            return false;
                        }
                    }
                    objClientMedicationInstructionrow.Refills = Refills;
                    objClientMedicationInstructionrow.TitrationStep = TitrationStep;
                    objClientMedicationInstructionrow.StartDate = StartDate;
                    objClientMedicationInstructionrow.Days = Days;
                    objClientMedicationInstructionrow.EndDate = EndDate;
                    ClientMedicationTitration.CalculateStartDate(EndDate);
                    var currentStepNumber = TitrationStep;
                    var currentStepStartDate = StartDate;
                    objClientMedicationInstructionrow.StrengthId = row.cells[1].getElementsByTagName("select")[0].value;
                    objClientMedicationInstructionrow.PotencyUnitCode = row.cells[1].getElementsByTagName("select")[0].options[row.cells[1].getElementsByTagName("select")[0].selectedIndex].attributes["PotencyUnitCode"].value;
                    objClientMedicationInstructionrow.Quantity = row.cells[2].getElementsByTagName("input")[0].value;
                    objClientMedicationInstructionrow.Unit = row.cells[3].getElementsByTagName("select")[0].value;
                    objClientMedicationInstructionrow.Schedule = row.cells[4].getElementsByTagName("select")[0].value;
                    if (row.cells[9].getElementsByTagName("input")[0].value == "Y")
                        objClientMedicationInstructionrow.Pharmacy = eval("ComboPharmaText" + i).GetText();
                    else if (row.cells[9].getElementsByTagName("input")[0].value == "N") {
                        if (eval("ComboPharmaText" + i).GetText() == "") {
                            objClientMedicationInstructionrow.PharmaText = null;
                        }
                        else {
                            objClientMedicationInstructionrow.PharmaText = eval("ComboPharmaText" + i).GetText();
                        }
                    }
                    objClientMedicationInstructionrow.AutoCalcallow = row.cells[9].getElementsByTagName("input")[0].value;
                    objClientMedicationInstructionrow.Sample = row.cells[6].getElementsByTagName("input")[0].value;
                    objClientMedicationInstructionrow.Stock = row.cells[7].getElementsByTagName("input")[0].value;
                    if ((row.cells[7].getAttribute("RowIdentifierCMI") != null) && (row.cells[7].getAttribute("RowIdentifierCMI") != "undefined"))
                        objClientMedicationInstructionrow.RowIdentifierCMI = row.cells[7].getAttribute("RowIdentifierCMI");
                    objClientMedicationInstructionrow.Instruction = row.cells[1].getElementsByTagName("select")[0].options[row.cells[1].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[2].getElementsByTagName("input")[0].value + " " + row.cells[3].getElementsByTagName("select")[0].options[row.cells[3].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[4].getElementsByTagName("select")[0].options[row.cells[4].getElementsByTagName("select")[0].selectedIndex].innerText;
                    objClientMedicationInstructionrow.TitrateSummary = row.cells[1].getElementsByTagName("select")[0].options[row.cells[1].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[3].getElementsByTagName("select")[0].options[row.cells[3].getElementsByTagName("select")[0].selectedIndex].innerText;
                    arrayobjpushClientMedicationInstructionrow.push(objClientMedicationInstructionrow);
                }
            }
            var AddStepFlag = document.getElementById('buttonInsert').value
            Streamline.SmartClient.WebServices.ClientMedications.SaveTitrationRow(MedicationNameId, Category, RowIdentifierCM, AddStepFlag, arrayobjpushClientMedicationInstructionrow, method, currentStepNumber, currentStepStartDate, ToModifyStepNumber, ClientMedicationTitration.onSaveTitrationSucceeded, ClientMedicationTitration.onSaveTitrationFailure, context)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    CalculateStartDate: function (EndDate) {
        try {
            Streamline.SmartClient.WebServices.CommonService.CalculateStartDate(EndDate, ClientMedicationTitration.onCalucateStartDateSucceeded, ClientMedicationTitration.onFailure)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onCalucateStartDateSucceeded: function (result) {
        try {
            if (result != null || result !== "")
                NextStepStartDate = result;
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onSaveTitrationSucceeded: function (result, context, methodname) {
        try {
            if (result.length > 0) {
                if (result.indexOf("String was not recognized as a valid DateTime") >= 0 && result.indexOf("OrderDate Column") >= 0) {
                    document.getElementById(context.ImageError).style.display = 'block';
                    document.getElementById(context.ImageError).style.visibility = 'visible';
                    document.getElementById(context.LabelErrorMessage).innerText = 'Please enter valid Order Date.';
                    return false;
                }
                if (result.indexOf("String was not recognized as a valid DateTime") >= 0 && result.indexOf("StartDate Column") >= 0) {
                    document.getElementById(context.ImageError).style.display = 'block';
                    document.getElementById(context.ImageError).style.visibility = 'visible';
                    document.getElementById(context.LabelErrorMessage).innerText = 'Please enter valid Start Date.';
                    return false;
                }
            }
            Clear_Click(false);
            document.getElementById('buttonInsert').disabled = false;
            if (NextStepStartDate == "")
                document.getElementById('TextBoxStartDate').value = result;
            else
                document.getElementById('TextBoxStartDate').value = NextStepStartDate;
            ClientMedicationTitration.FillSteps();
            ClientMedicationTitration.FillTitrationSummary();
        }
        catch (e) {
            document.getElementById('buttonInsert').disabled = false;
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    onSaveTitrationFailure: function (error, context) {
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            window.close();
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        else {
            document.getElementById(context.ImageGridError).style.display = 'block';
            document.getElementById(context.ImageGridError).style.visibility = 'visible';
            document.getElementById(context.LabelGridErrorMessage).innerText = error.get_message();
            parent.fnHideParentDiv();
            return false;
        }
    },
    GetMedicationList: function (Panel, SortBy) {
        try {
            if (Panel === undefined) {
                Panel = PanelTitrationSteps;
            }
            if (SortBy === undefined) {
                SortBy = '';
            }
            var method = parent.document.getElementById("txtButtonValue").value;
            wRequest = new Sys.Net.WebRequest();
            wRequest.set_url("AjaxScript.aspx?FunctionId=GetTitrationList&par0=" + SortBy + "&par1=" + method + "&TitrationStepNumber=" + TitrationStepNumber);
            wRequest.add_completed(ClientMedicationTitration.OnFillMedicationControlCompleted);
            wRequest.set_userContext(Panel);
            wRequest.set_httpVerb("Post");
            var executor = new Sys.Net.XMLHttpExecutor();
            wRequest.set_executor(executor);
            executor.executeRequest();
            var started = executor.get_started();
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    SetDocumentDirty: function () {
        try {
            document.getElementById("HiddenFieldOrderPageDirty").value = "true";
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ShowHideGridErrors: function (LabelGridErrorMessage, ImageGridError, error) {
        try {
            ImageGridError.style.display = 'block';
            ImageGridError.style.visibility = 'visible';
            LabelGridErrorMessage.innerText = error;
        }
        catch (e) {
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
                        var ScriptEnd = data.indexOf('</script>');
                        var Script = data.substring(ScriptStart + 57, ScriptEnd);
                        var Rscript = document.createElement('script');
                        Rscript.text = Script;
                        Panel.appendChild(Rscript);
                        data = data.substring(data.indexOf('<medlist>') + 10, data.indexOf('</medlist>'));
                        Panel.innerHTML = data + Panel.innerHTML;
                        RegisterMedicationListControlEvents();
                    }
                }
            }
            else {
                if (executor.get_timedOut())
                    alert("Timed Out");
                else
                    if (executor.get_aborted())
                        alert("Aborted");
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    DeleteRow: function (sender, e) {
        if (sender.target.getAttribute("MedicationId") != null) {
            ClientMedicationTitration.DeleteFromTable(sender);
        }
        else {
            ClientMedicationTitration.ClearRow(sender.target.parentElement.parentElement, sender.target.parentElement.parentElement.rowIndex);
        }
    },
    DeleteFromTable: function (object) {
        try {
            parent.fnShow(); //By Vikas Vyas On Dated April 04th 2008 
            var MedicationId = object.target.getAttribute("MedicationId");
            var MedicationInstructionId = object.target.getAttribute("MedicationInstructionId");
            Streamline.SmartClient.WebServices.ClientMedications.DeleteTitrateInstructions(MedicationId, MedicationInstructionId, ClientMedicationTitration.onDeleteFromTableSucceeded, ClientMedicationTitration.onFailure, object)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onDeleteFromTableSucceeded: function (result, context, methodname) {
        try {
            if (result == true) {
                ClientMedicationTitration.ClearRow(context.target.parentElement.parentElement, context.target.parentElement.parentElement.rowIndex);
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    DisplayMonographDescription: function (varDataToBeDisplayed, varToBeDisplayedInMonographContainer) {
        if (varToBeDisplayedInMonographContainer)
            document.getElementById("MonoGraphDescriptions").innerHTML = varDataToBeDisplayed;
        else
            document.getElementById("InteractionDescriptions").innerHTML = varDataToBeDisplayed;
    },
    onDrugInteractionDescriptionClick: function (context, MonographId, InteractionId) {
        try {
            parent.fnShow();
            Streamline.SmartClient.WebServices.ClientMedications.getMonographDescription(MonographId, InteractionId, ClientMedicationTitration.onDrugInteractionDescriptionSucceeded, ClientMedicationTitration.onFailure, context);
        }
        catch (e) {
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
            }
            else {
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
            TableHTML.push("  <img id='ImgCross1' class='PopUpTitleBar' onclick='ClientMedicationTitration.closeDescDiv(ImgCross1)' src='App_Themes/Includes/Images/cross.jpg'");
            TableHTML.push("  title='Close' alt='Close' /></td></tr>");
            TableHTML.push("</table> <table width='600px' height='100%' border='0' cellpadding='0' cellspacing='0'>");
            TableHTML.push("<tbody>");
            if (window.navigator.appVersion.indexOf('MSIE 7.0') > 0) {
                TableHTML.push(" <tr><td class='Label'>  <div id='MonoGraphDescriptions' style='height:365px;font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;'></div>  </td></tr></tbody></table> ");
            }
            else if (window.navigator.appVersion.indexOf('MSIE 6.0') > 0) {
                TableHTML.push(" <tr> <td class='Label'>  <div id='MonoGraphDescriptions' style='height:365px ;font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;'></div>  </td></tr></tbody></table> ");
            }
            document.getElementById("DivMonoGraphContainer").innerHTML = TableHTML.join('');
            divM.style.width = 600;
            divM.style.height = "100%";
            divF.style.height = divM.style.height;
            divF.style.width = divM.style.width;
            divF.style.top = divM.style.top;
            divF.style.left = divM.style.left;
            document.getElementById("DivMonoGraphContainer").style.display = "block";
            document.getElementById("IframeMonoGraphContainer").style.display = "block";
            ClientMedicationTitration.DisplayMonographDescription(result.rows[0]["Description"], true);
            return false;
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
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
                divS.style.zIndex = 101;
                divF.style.zIndex = 100;
                divS.style.left = -10;
                divS.style.top = -150;
                divS.style.height = 100;
                divS.style.width = 400;
                divS.style.position = "absolute";
                divF.style.position = "absolute";
            }
            else {
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
            TableHTML.push("  <img id='ImgCross2' onclick='ClientMedicationTitration.closeDescDiv(ImgCross2)' src='App_Themes/Includes/Images/cross.jpg'");
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
                        break
                    }
                case 3:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'>Moderate Interaction: Assess the risk to the patient and take action as needed.");
                        TableHTML.push(" Moderate. These medicines may cause some risk when taken together. Contact your healthcare professional (e.g. doctor or pharmacist) for more information.</div></td></tr>");
                        break
                    }
                case 4:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break
                    }
                case 5:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break
                    }
                case 6:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break
                    }
                case 7:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break
                    }
                case 8:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'></div>  </td></tr>");
                        break
                    }
                case 9:
                    {
                        TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px;'> Undetermined Severity - Alternative Therapy Interaction: Assess the risk to the patient and take action as needed.");
                        TableHTML.push(" Unknown - Alternative Therapy Interaction. These medications may cause some risk when taken together. Contact your healthcare professional (e.g. doctor or pharmacist) for more information. ");
                        TableHTML.push(" </div>  </td></tr>");
                        break
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
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    closeDescDiv: function (imgId) {
        try {
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
        catch (e) {
        }
        finally {
            parent.fnHideParentDiv(); //By Vikas Vyas 
        }
    },
    ManipulateRowValues: function (sender, e) {
        try {
            if (e.target === undefined)
                _Row = e.parentNode.parentNode;
            else
                _Row = e.target.parentNode.parentNode;
            var context = new Object();
            var objRow = new Object();
            objRow.Refills = document.getElementById('TextBoxRefills');
            objRow.StartDate = document.getElementById('TextBoxStartDate');
            objRow.Days = document.getElementById('TextBoxDays');
            objRow.EndDate = document.getElementById('TextBoxEndDate');
            objRow.Quantity = _Row.cells[2].getElementsByTagName("input")[0];
            objRow.Units = _Row.cells[3].getElementsByTagName("select")[0];
            objRow.Schedule = _Row.cells[4].getElementsByTagName("select")[0];
            objRow.Pharmacy = _Row.cells[5].getElementsByTagName("input")[0];
            objRow.Sample = _Row.cells[6].getElementsByTagName("input")[0];
            objRow.Stock = _Row.cells[7].getElementsByTagName("input")[0];
            objRow.MedicationId = _Row.cells[1].getElementsByTagName("select")[0];
            objRow.Strength = _Row.cells[1].getElementsByTagName("select")[0];
            var rowIndex = _Row.rowIndex;
            objRow.rowIndex = rowIndex;
            context.rowIndex = rowIndex;
            context.SelectedValue = "";
            var table = $("[id$=tableMedicationStepBuilder]")[0];
            var dosage = 0;
            if (objRow.Quantity.value != "")
                dosage = parseFloat(objRow.Quantity.value);
            var schedule = objRow.Schedule.value;
            if (_Row.cells[9].getElementsByTagName("input")[0].value == "Y") {
                if (((Number.parseInvariant(objRow.Days.value) < 1) || (Number.parseInvariant(objRow.Days.value) > 365)) == false)
                    ClientMedicationTitration.CalculatePharmacy(objRow);
                parent.$("input[id$=HiddenFieldSelectedValue]").val("");
            }
            else if ((_Row.cells[9].getElementsByTagName("input")[0].value == "N") && objRow.MedicationId.value > 0 && objRow.Quantity.value > 0 && objRow.Schedule.value > 0 && objRow.Days.value > 0) {
                if (eval("ComboPharmaText" + rowIndex).GetSelectedItem() != null) {
                    if (eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != undefined && eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != "")
                        context.SelectedValue = eval("ComboPharmaText" + rowIndex).GetSelectedItem().value;
                    parent.$("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
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
                eval("ComboPharmaText" + rowIndex).ClearItems();
                eval("ComboPharmaText" + rowIndex).SetText("");
                Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(objRow.MedicationId.value, dosage, schedule, objRow.Days.value, ClientMedicationTitration.onDispenseQuantitySucceeded, ClientMedicationTitration.onFailure, context);
            }
            else {
                eval("ComboPharmaText" + rowIndex).ClearItems();
                eval("ComboPharmaText" + rowIndex).SetText("");
            }
            document.getElementById('buttonInsert').disabled = false;
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    CheckKeyPress: function (rowIndex) {
        try {
            if ($("[id*=HiddenFieldAutoCalcAllowed" + rowIndex + "]").val() == "Y") {
                eval("ComboPharmaText" + rowIndex).inputElement.maxLength = 4;
                if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode == 8) || event.keyCode == 46)
                    event.returnValue = true;
                else
                    event.returnValue = false;
            }
            else if ($("[id*=HiddenFieldAutoCalcAllowed" + rowIndex + "]").val() == "N")
                eval("ComboPharmaText" + rowIndex).inputElement.maxLength = 100;
        }
        catch (e) {
        }
    },
    onDispenseQuantitySucceeded: function (result, context) {
        try {

            if (eval("ComboPharmaText" + context.rowIndex).GetListBoxControl() != undefined) {
                eval("ComboPharmaText" + context.rowIndex).ClearItems();
            }
            if (result == null || result.rows == null || !result.rows) {
                return;
            }
            for (var i = 0; i < result.rows.length; i++) {
                eval("ComboPharmaText" + context.rowIndex).AddItem(result.rows[i]["PharmText"], result.rows[i]["SortOrder"]);
            }
            eval("ComboPharmaText" + context.rowIndex).SetValue(parent.$("input[id$=HiddenFieldSelectedValue]").val());
        }
        catch (ex) {
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
            ClientMedicationTitration.GetMedicationList(PanelTitrationSteps, ColumnName);
        }
        catch (e) {
        }
    },
    FillMedicationRowsOnRadioClick: function (result, callRadioClick) {
        try {
            if (callRadioClick === undefined)
                callRadioClick = false;
            var table = document.getElementById('tableMedicationStepBuilder');
            var args = new Object();
            args.CallRadioClick = callRadioClick;
            args.NoOfRows = table.rows.length - 1;
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                eval("ComboPharmaText" + i).SetEnabled(true);
            }
            for (var i = 0; i < table.rows.length; i++) {
                args = new Object();
                args.RowNumber = i;
                args.NoOfRows = result.tables[1].rows.length - 1;
                args.CallRadioClick = callRadioClick;
                //Ended over here 
                var row = table.rows[i];
                if (i < result.tables[1].rows.length) {
                    var Unit = new Object();
                    Unit.DropDown = row.cells[3].getElementsByTagName("select")[0];
                    Unit.SelectedValue = result.tables[1].rows[i]["Unit"];
                    row.cells[0].getElementsByTagName("img")[0].setAttribute("MedicationId", result.tables[1].rows[i]["ClientMedicationId"]);
                    row.cells[0].getElementsByTagName("img")[0].setAttribute("MedicationInstructionId", result.tables[1].rows[i]["ClientMedicationInstructionId"]);
                    ClientMedicationTitration.FillStrength(result.tables[0].rows[0]["MedicationNameId"], row.cells[1].getElementsByTagName("select")[0], result.tables[1].rows[i]["StrengthId"], Unit, args);
                    if (result.tables[1].rows[i]["Quantity"] != null) {
                        row.cells[2].getElementsByTagName("input")[0].value = result.tables[1].rows[i]["Quantity"];
                    }
                    else {
                        row.cells[2].getElementsByTagName("input")[0].value = "";
                    }
                    if (callRadioClick == true) {
                        if (result.tables[1] != null) {
                            row.cells[9].getElementsByTagName("input")[0].value = result.tables[1].rows[i]["AutoCalcallow"];
                            if (result.tables[1].rows[i]["AutoCalcallow"] == "Y") {
                                if (result.tables[1].rows[i]["Pharmacy"] != null) {
                                    eval("ComboPharmaText" + i).SetText(result.tables[2].rows[i]["Pharmacy"]);
                                }
                            }
                            else if (result.tables[2].rows[i]["AutoCalcallow"] == "N") {
                                for (j = 0; j < table.rows.length; j++) {
                                    if (j < result.tables[1].rows.length) {
                                        if (result.tables[1].rows[i]["StrengthId"] == result.tables[1].rows[j]["StrengthId"]) {
                                            if (result.tables[1].rows[i]["PharmacyText"] != null && result.tables[1].rows[i]["PharmacyText"] != '') {
                                                eval("ComboPharmaText" + i).SetText(result.tables[2].rows[i]["PharmacyText"]);
                                            }
                                            if (i > j) {
                                                eval("ComboPharmaText" + i).SetEnabled(false);
                                            }
                                        }
                                    }
                                }
                            }
                            if (result.tables[1].rows[i]["Sample"] != null) {
                                row.cells[6].getElementsByTagName("input")[0].value = result.tables[1].rows[i]["Sample"];
                            }
                            if (result.tables[1].rows[i]["Stock"] != null) {
                                row.cells[7].getElementsByTagName("input")[0].value = result.tables[1].rows[i]["Stock"];
                            }
                        }
                    }
                    else {
                        if (result.tables[2] != null) {
                            row.cells[9].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["AutoCalcallow"];
                            if (result.tables[2].rows[i]["AutoCalcallow"] == "Y") {
                                if (result.tables[2].rows[i]["Pharmacy"] != null) {
                                    eval("ComboPharmaText" + i).SetText(result.tables[2].rows[i]["Pharmacy"]);
                                }
                            }
                            else if (result.tables[2].rows[i]["AutoCalcallow"] == "N") {
                                for (j = 0; j < table.rows.length; j++) {
                                    if (j < result.tables[1].rows.length) {
                                        if (result.tables[1].rows[i]["StrengthId"] == result.tables[1].rows[j]["StrengthId"]) {
                                            if (result.tables[2].rows[i]["PharmacyText"] != null && result.tables[2].rows[i]["PharmacyText"] != '') {
                                                eval("ComboPharmaText" + i).SetText(result.tables[2].rows[i]["PharmacyText"]);
                                            }
                                            if (i > j) {
                                                eval("ComboPharmaText" + i).SetEnabled(false);
                                            }
                                        }
                                    }
                                }

                            }
                            if (result.tables[2].rows[i]["Sample"] != null) {
                                row.cells[6].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Sample"];
                            }
                            if (result.tables[2].rows[i]["Stock"] != null) {
                                row.cells[7].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Stock"];
                            }
                        }
                    }
                    row.cells[7].setAttribute("RowIdentifierCMI", result.tables[1].rows[i]["RowIdentifier"]);
                    ClientMedicationTitration.FillScheduled(row.cells[4].getElementsByTagName("select")[0], result.tables[1].rows[i]["Schedule"], args);
                }
                else {
                    ClientMedicationTitration.FillStrength(result.tables[0].rows[0]["MedicationNameId"], row.cells[1].getElementsByTagName("select")[0], null, null, args);
                    ClientMedicationTitration.FillScheduled(row.cells[4].getElementsByTagName("select")[0], null, args);
                }
            }

        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    },
    FillDropDowns: function (MedicationNameId) {
        try {
            if (MedicationNameId != null && MedicationNameId != "") {
                var table = document.getElementById('tableMedicationStepBuilder');
                for (var i = 0; i < table.rows.length; i++) {
                    var row = table.rows[i];
                    var Strength = row.cells[1].getElementsByTagName("select")[0];
                    var Schedule = row.cells[4].getElementsByTagName("select")[0];
                    ClientMedicationTitration.FillStrength(MedicationNameId, Strength, null, null);
                    ClientMedicationTitration.FillScheduled(Schedule, null);
                }
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    GetTitrationValues: function () {
        try {
            var DropDownListDxPurpose = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListDxPurpose');
            var DropDownListPrescriber = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListPrescriber');
            var objTitrateMedication = new Object();
            if (parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationId').value != "")
                objTitrateMedication.MedicationId = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationId').value;
            else
                objTitrateMedication.MedicationId = 0;
            objTitrateMedication.MedicationNameId = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationNameId').value;
            objTitrateMedication.MedicationName = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationName').value;
            objTitrateMedication.DrugCategory = "0";
            objTitrateMedication.OrderDate = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxOrderDate').value;
            objTitrateMedication.DAW = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxDispense').checked;
            objTitrateMedication.SpecialInstructions = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxSpecialInstructions').value;
            objTitrateMedication.OffLabel = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxOffLabel').checked;
            objTitrateMedication.DesiredOutcome = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxDesiredOutcome').value;
            objTitrateMedication.Comments = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxComments').value;
            objTitrateMedication.TitrateMode = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenTitrateMode').value;
            if (DropDownListDxPurpose.selectedIndex !== -1) {
                objTitrateMedication.DrugPurpose = DropDownListDxPurpose.options[DropDownListDxPurpose.selectedIndex].innerText;
                objTitrateMedication.DSMCode = DropDownListDxPurpose.options[DropDownListDxPurpose.selectedIndex].getAttribute('DSMCode');
                objTitrateMedication.DSMNumber = DropDownListDxPurpose.options[DropDownListDxPurpose.selectedIndex].getAttribute('DSMNumber');
                objTitrateMedication.DxId = DropDownListDxPurpose.value;
            }
            objTitrateMedication.PrescriberId = DropDownListPrescriber.value;
            objTitrateMedication.PrescriberName = DropDownListPrescriber.options[DropDownListPrescriber.selectedIndex].innerText;
            document.getElementById('TextBoxDrug').value = objTitrateMedication.MedicationName;
            document.getElementById('TextBoxSpecialInstructions').value = objTitrateMedication.SpecialInstructions;
            if (objTitrateMedication.DAW == true)
                document.getElementById('CheckBoxDispense').checked = true;
            else
                document.getElementById('CheckBoxDispense').checked = false;
            document.getElementById('HiddenFieldOrderDate').value = objTitrateMedication.OrderDate;
            document.getElementById('HiddenMedicationNameId').value = objTitrateMedication.MedicationNameId;
            PanelTitrationSteps = 'PanelTitrationSteps';
            ClientMedicationTitration.FillDropDowns(objTitrateMedication.MedicationNameId);
            ClientMedicationTitration.FillSteps();
            ClientMedicationTitration.FillTitrationSummary();
            Streamline.SmartClient.WebServices.ClientMedications.UpdateDatasetForTitration(objTitrateMedication, ClientMedicationTitration.onSucceededAddToTitration, ClientMedicationTitration.onFailure);
        }
        catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    onSucceededAddToTitration: function (result, context) {
        try {
            if (result == "T")
                document.getElementById('RadioButtonTitration').checked = true;
            else
                document.getElementById('RadioButtonTaper').checked = true;
        }
        catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    FillSteps: function () {
        try {
            Streamline.SmartClient.WebServices.ClientMedications.FillStepNumbers(ClientMedicationTitration.onSucceededStepNumbers, ClientMedicationTitration.onFailure);
        }
        catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    onSucceededStepNumbers: function (result) {
        try {
            var DropDown = document.getElementById('DropDownTitrationSteps');
            DropDown.innerHTML = "";
            if (result == null)
                return;
            for (var i = 0; i < result.length; i++) {
                optionItem = new Option(result[i], result[i], false, false);
                DropDown.options[DropDown.length] = optionItem;
            }
            DropDown.value = result.length;
        }
        catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    FillTitrationSummary: function () {
        try {
            Streamline.SmartClient.WebServices.ClientMedications.TitrationSummary(ClientMedicationTitration.onSucceededTitrationSummary, ClientMedicationTitration.onFailure);
        }
        catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    onSucceededTitrationSummary: function (result) {
        try {
            if (result == null)
                return;
            if (result.Third != undefined)
                document.getElementById('LabelNoOfSteps').innerText = result.Third;
            else
                document.getElementById('LabelNoOfSteps').innerText = "";
            if (result.Second[0] != undefined)
                document.getElementById('LabelStartDate').innerText = result.Second[0];
            else
                document.getElementById('LabelStartDate').innerText = "";
            if (result.Second[1] != undefined)
                document.getElementById('LabelEndDate').innerText = result.Second[1];
            else
                document.getElementById('LabelEndDate').innerText = "";
            if (result.First != undefined) {
                document.getElementById('PanelOrderSummary').innerHTML = result.First;
            }
            else {
                document.getElementById('PanelOrderSummary').innerHTML = "";
            }
            ClientMedicationTitration.FillSteps();
        }
        catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    CalculatePharmacyForDaysChange: function () {
        try {
            var table = document.getElementById('tableMedicationStepBuilder');
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                var context = new Object();
                var objRow = new Object();
                objRow.Refills = document.getElementById('TextBoxRefills');
                objRow.StartDate = document.getElementById('TextBoxStartDate');
                objRow.Days = document.getElementById('TextBoxDays');
                objRow.EndDate = document.getElementById('TextBoxEndDate');
                objRow.Quantity = row.cells[2].getElementsByTagName("input")[0];
                objRow.Units = row.cells[3].getElementsByTagName("select")[0];
                objRow.Schedule = row.cells[4].getElementsByTagName("select")[0];
                objRow.Pharmacy = row.cells[5].getElementsByTagName("input")[0];
                objRow.Sample = row.cells[6].getElementsByTagName("input")[0];
                objRow.Stock = row.cells[7].getElementsByTagName("input")[0];
                objRow.MedicationId = row.cells[1].getElementsByTagName("select")[0];
                var rowIndex = row.rowIndex;
                context.rowIndex = rowIndex;
                context.SelectedValue = "";
                objRow.rowIndex = rowIndex;
                var dosage = 0;
                if (objRow.Quantity.value != "")
                    dosage = parseFloat(objRow.Quantity.value);
                var schedule = objRow.Schedule.value;
                if (row.cells[9].getElementsByTagName("input")[0].value == "Y") {
                    ClientMedicationTitration.CalculatePharmacy(objRow);
                    parent.$("input[id$=HiddenFieldSelectedValue]").val("");
                }
                else if ((row.cells[9].getElementsByTagName("input")[0].value == "N") && objRow.MedicationId.value > 0 && objRow.Quantity.value > 0 && objRow.Schedule.value > 0 && objRow.Days.value > 0) {
                    if (eval("ComboPharmaText" + rowIndex).GetSelectedItem() != null) {
                        if (eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != undefined && eval("ComboPharmaText" + rowIndex).GetSelectedItem().value != "")
                            context.SelectedValue = eval("ComboPharmaText" + rowIndex).GetSelectedItem().value;
                        parent.$("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
                    }
                    for (j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (rowIndex != j) {
                            if (row.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                if (newRow.cells[2].getElementsByTagName("input")[0].value > 0)
                                    dosage = dosage + parseFloat(newRow.cells[2].getElementsByTagName("input")[0].value);
                                schedule = schedule + "," + newRow.cells[4].getElementsByTagName("select")[0].value;
                            }
                        }
                    }
                    eval("ComboPharmaText" + rowIndex).ClearItems();
                    eval("ComboPharmaText" + rowIndex).SetText("");
                    Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(objRow.MedicationId.value, dosage, schedule, objRow.Days.value, ClientMedicationTitration.onDispenseQuantitySucceeded, ClientMedicationTitration.onFailure, context);
                }
                else {
                    eval("ComboPharmaText" + rowIndex).ClearItems();
                    eval("ComboPharmaText" + rowIndex).SetText("");
                }
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ValidInteger: function (control) {
        try {
            control.value = ClientMedicationTitration.trim(control.value);
            if (!/\D/.test(control.value) == false) {
                control.value = '';
                control.focus();
            }
        }
        catch (ex) {

        }
    },
    ValidDecimal: function (control) {
        try {
            control.value = ClientMedicationTitration.trim(control.value);
            if (control.value.length == 1) {
                if (control.value == '.') {
                    control.value = '';
                    return;
                }
            }
            if (control.value.substring(0, 1) == '.')  //   add . is at first index add 0.
            {
                control.value = '0' + control.value;
            }
            if (control.value.substring(control.value.length - 1) == '.') // if . is at last index add .0
            {
                control.value = control.value + '0';
            }
            if (/^\d+(\.\d+)?$/.test(control.value) == false) {
                control.value = '';
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
    UpdateTitration: function () {
        var objTitrateMedication = new Object();
        var _refills;
        try {
            if (parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationId').value != "")
                objTitrateMedication.MedicationId = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationId').value;
            else
                objTitrateMedication.MedicationId = 0;
            if (document.getElementById('CheckBoxDispense').checked == true)
                objTitrateMedication.DAW = 'Y';
            objTitrateMedication.SpecialInstructions = document.getElementById('TextBoxSpecialInstructions').value;
            if (document.getElementById('RadioButtonTitration').checked == true)
                objTitrateMedication.TitrationType = 'T';
            else if (document.getElementById('RadioButtonTaper').checked == true)
                objTitrateMedication.TitrationType = 'P';
            if (document.getElementById('TextBoxRefills').value == "")
                _refills = 0;
            else
                _refills = document.getElementById('TextBoxRefills').value;
            objTitrateMedication.PermitChangesByOtherUsers = document.getElementById('HiddenPermit').value;

            Streamline.SmartClient.WebServices.ClientMedications.UpdateTitration(objTitrateMedication, _refills, ClientMedicationTitration.onSucceededUpdateTitration, ClientMedicationTitration.onFailure);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onSucceededUpdateTitration: function (result) {
        var _DAW = "";
        var _SpecialInstruction = "";
        var LabelGridErrorMessage = document.getElementById('LabelGridErrorMessage');
        var ImageGridError = document.getElementById('ImageGridError');
        try {
            if (result == "Please add atleast one titration step.") {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, result);
                parent.fnHideParentDiv();
                return false;
            }
            if (result == "One or more start dates are out of sequence. Please correct before saving.") {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, result);
                parent.fnHideParentDiv();
                return false;
            }
            if (document.getElementById('CheckBoxDispense').checked == true)
                _DAW = 'Y';
            _SpecialInstruction = document.getElementById('TextBoxSpecialInstructions').value
            var DivSearch = parent.document.getElementById('DivSearch1');
            DivSearch.style.display = 'none';
            parent.ClientMedicationOrder.RefreshMedicationList(_DAW, _SpecialInstruction);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    //onUpdateTitrationFailure: function (error, context) {
    //    if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
    //        window.close();
    //        location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
    //    }
    //    else {
    //        document.getElementById(context.ImageGridError).style.display = 'block';
    //        document.getElementById(context.ImageGridError).style.visibility = 'visible';
    //        document.getElementById(context.LabelGridErrorMessage).innerText = error.get_message();
    //        parent.fnHideParentDiv();
    //        return false;
    //    }
    //},
    redirectToOrderPageClearSession: function () {
        try {
            var DivSearch = parent.document.getElementById('DivSearch1');
            DivSearch.style.display = 'none';
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    SaveTemplate: function (HiddenMedicationNameId, CreatedBy) {
        var context = new Object();
        context.MedicationNameId = document.getElementById(HiddenMedicationNameId).value;
        context.MedicationName = document.getElementById('TextBoxDrug').value;
        context.CreatedBy = CreatedBy;
        Streamline.SmartClient.WebServices.ClientMedications.CheckTitrationInstructions(context.MedicationNameId, ClientMedicationTitration.onCheckTemplateSucceeded, ClientMedicationTitration.onCheckTemplateFailure, context)
    },
    onCheckTemplateSucceeded: function (result, context) {
        var LabelGridErrorMessage = document.getElementById('LabelGridErrorMessage');
        var ImageGridError = document.getElementById('ImageGridError');
        try {
            if (result == "Please add atleast one titration step.") {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, result);
                return false;
            }
            else if (result == "true") {
               // window.open("MedicationTitrationTemplate.aspx?MedicationNameId=" + context.MedicationNameId + '&MedicationName=' + context.MedicationName + '&CreatedBy=' + context.CreatedBy, "", "location=no,width=370px,height=150px,top=200px,left=300px,resizable = no,scrollbars=no");
                window.showModalDialog("MedicationTitrationTemplate.aspx?MedicationNameId=" + context.MedicationNameId + '&MedicationName=' + context.MedicationName + '&CreatedBy=' + context.CreatedBy, "", "menubar : no;status : no;dialogHeight=200px;dialogWidth=300px;resizable:no;dialogTop:200px;dialogLeft:300px,location:no; help: No;");
              }
            else if (result == "Error while lodading dataSet") {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, result);
                return false;
            }
            else if (result == "Session has expired") {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, result);
                return false;
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onCheckTemplateFailure: function () {
        try {
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    SaveTitrationTemplate: function (HiddenFieldMedicationNameId, HiddenFieldTemplateName) {
        try {
            var MedicationId = document.getElementById('HiddenFieldMedicationNameId').value
            var TemplateName = document.getElementById('TextBoxTempalteName').value;
            Streamline.SmartClient.WebServices.ClientMedications.SaveTitrationTemplate(MedicationId, TemplateName, ClientMedicationTitration.onSaveTitrationTemplateSucceeded, ClientMedicationTitration.onSaveTitrationTemplateFailure)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onSaveTitrationTemplateSucceeded: function (result) {
        var LabelGridErrorMessage = document.getElementById('LabelGridErrorMessage');
        var ImageGridError = document.getElementById('ImageGridError');
        try {
            if (result == "Please add atleast one titration step.") {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, result);
                return false;
            }
            else if (result == "true") {
                ClientMedicationTitration.CloseTemplate()
            }
            else if (result == "false") {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, "A template with this name already exists, please select a different name.");
                return false;
            }
            else if (result == "Please enter template name.") {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, result);
                return false;
            }
            else {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, "Error while updating.");
                return false;
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onSaveTitrationTemplateFailure: function () {
        try {
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },

    ClearAllTitrationTemperList: function () {
        var popupWindow = window.showModalDialog('YesNo.aspx?CalledFrom=ClientTitrationList', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
        if (popupWindow == 'Y') {
            try {

                Streamline.SmartClient.WebServices.ClientMedications.DeleteAllTitrateInstructions(ClientMedicationTitration.onDeleteAllTitrationSucceeded, ClientMedicationTitration.onFailure);
            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
            }
        }
    },
    onDeleteAllTitrationSucceeded: function (result) {
        var LabelGridErrorMessage = document.getElementById('LabelGridErrorMessage');
        var ImageGridError = document.getElementById('ImageGridError');
        try {
            if (result == true) {
                ClientMedicationTitration.GetMedicationList(PanelTitrationSteps);
                ClientMedicationTitration.FillTitrationSummary();
            }
            else if (result == false) {
                ClientMedicationTitration.ShowHideGridErrors(LabelGridErrorMessage, ImageGridError, "There is no instruction to delete.");
                parent.fnHideParentDiv();
                return false;
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    },
    SetTitrationTemplate: function (TitrationTemplateId, TitrationStartDate) {
        try {
            if (TitrationTemplateId != "" && TitrationTemplateId != null)
                Streamline.SmartClient.WebServices.ClientMedications.SetTitrationTemplate(TitrationTemplateId, TitrationStartDate, ClientMedicationTitration.onSetTitrationTemplateSucceeded, ClientMedicationTitration.onFailure)
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    CloseTemplate: function () {
        window.close();

        if (parent.document.getElementById('dialog-close'))
            parent.document.getElementById('dialog-close').click();
    },
    onSetTitrationTemplateSucceeded: function (result) {
        try {
            Clear_Click(false);
            if (result.length > 0) {
                var startDate = new Date(result);
                var ss = startDate.format("MM/dd/yyyy");
                document.getElementById('TextBoxStartDate').value = ss;
            }
            document.getElementById('buttonInsert').disabled = false;
            ClientMedicationTitration.FillSteps();
            ClientMedicationTitration.FillTitrationSummary();
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        finally {
            parent.fnHideParentDiv();
        }
    }
    //,
    //onTemplateSucceeded: function (result, context) {
    //    try {
    //        ClientMedicationTitration.FillMedicationRowsOnRadioClick(result, true);
    //        document.getElementById('DropDownTitrationSteps').value = result.tables[1].rows[0]["TitrationStepNumber"];
    //        document.getElementById('TextBoxStartDate').value = result.tables[1].rows[0]["StartDate"].format("MM/dd/yyyy");
    //        document.getElementById('TextBoxEndDate').value = result.tables[1].rows[0]["EndDate"].format("MM/dd/yyyy");
    //        document.getElementById('TextBoxDays').value = result.tables[1].rows[0]["Days"];
    //        document.getElementById('HiddenRowIdentifier').value = result.tables[0].rows[0]["RowIdentifier"];
    //        var table1 = document.getElementById('tableMedicationStepBuilder');
    //    }
    //    catch (e) {
    //        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    //            }   
    //}
}
