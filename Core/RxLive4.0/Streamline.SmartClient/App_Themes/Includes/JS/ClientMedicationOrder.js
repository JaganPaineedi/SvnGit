var thisMedicationRowStrengthId;
var EndDate;
var StartDateBox;
var XmlHttp;
var PanelMedicationList = "";
var NumberofDigitsAfterDecimal = 2;
var NumberofDigitsBeforeDecimal = 10;
//Code added in ref to Task#2802
var AutoCalcallowed = "";
//Code ends over here.
//Variables Added by Loveena in Ref to Task #76 to Move Error Messages.
var LabelGridErrorMessage = "";
var ImageGridError = "";
//Code Ends Here.

var DivErrorMessage = "";
var LabelErrorMessage = "";
var ImageError = "";
//Code added by Loveena in ref to Task#2529 on 23-July-2009
//1.9.5.1 - New Medication Order Layout Optimizations 
var tableErrorMessage = "";
var orderTemplateIsInProgress = false;
var orderTemplateIsInProgressMedicationId = 0;
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
    var NewStrValue = strValue.replace(/[^ a-zA-Z0-9._,&#\''\-]/g, '');

    if (NewStrValue.indexOf('<') > 0 || NewStrValue.indexOf('>') > 0)
        return false;
}


/// <summary>
/// Author Rishu Chopra
/// It is used to set popup.
/// </summary>

function fnShowParda(progMsgLeft, progMsgTop) {
    try {
        var objParda = document.getElementById("Parda");
        var objdvProgress = document.getElementById("dvProgress");
        objParda.style.width = document.body.offsetWidth - 2;
        objParda.style.height = document.body.offsetHeight - 20;
        objParda.style.display = '';
        objdvProgress.style.left = progMsgLeft;
        objdvProgress.style.top = progMsgTop;
        objdvProgress.style.display = '';
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function onKeyPress(sender, e) {
    if ((e.charCode == 189 || e.charCode == 109) ||
      (e.charCode >= 48 && e.charCode <= 57) ||
      (e.charCode >= 96 && e.charCode <= 105)) {
        return true;
    } else {
        return false;
    }
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

function onDAWClick(sender, e) {
    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        Streamline.SmartClient.WebServices.ClientMedications.UpdateDAW(e.MedicationId, sender.target.checked, ClientMedicationOrder.onDAWSucceeded, ClientMedicationOrder.onFailure, sender);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function onAcknowledgeClick(sender, e) {
    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        Streamline.SmartClient.WebServices.ClientMedications.AcknowledgeInteraction(e.MedicationId, e.ClickType, ClientMedicationOrder.AcknowledgeInteractionSucceeded, ClientMedicationOrder.onFailure, sender);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
    return false;
}

function SetValuesOfDisclosedToNameDropdown(s, e) {
    DropDownListPharmaciesDevXInstance.SetValue();
    onFillPharmaciesComboSucceeded($("[id$=HiddenField_PharmaciesId]").val());
}

function SetValueOfHiddenFields(object, objectsToSet) {
        if ($("[id$=DropDownListPharmacies_I]").val() != "Select Pharmacy") {
        var _PharmacyToName1 = DropDownListPharmaciesDevXInstance;
        if (_PharmacyToName1.GetSelectedItem() != null) {
            _PharmacyToNameValue = (_PharmacyToName1.GetSelectedItem().value);
            _PharmacyToNameType = _PharmacyToName1.GetSelectedItem().value.substr(_PharmacyToName1.GetSelectedItem().value.length - 1)
        }
    }
	if (($("[id$=DropDownListPharmacies_I]").val() == "Select Pharmacy" || $("[id$=DropDownListPharmacies_I]").val() == "") && $("[id$=HiddenField_PharmaciesId]").val() != "") {
        $("[id$=HiddenField_PharmaciesId]").val('');
    }
    _boolDisclosure = 'true';
    var _PharmacyToNameSelectedIndex = 0;
    var _PharmacyToNameSelectedValue = "";
    var _PharmacyToNameSelectedItemText = "";
    var _PharmacyToNameValue = "";
    var _PharmacyToNameType = "";
    var _PharmacyToIdSource = "";
    if (DropDownListPharmaciesDevXInstance.GetSelectedItem() != null) {
        _PharmacyToNameSelectedIndex = DropDownListPharmaciesDevXInstance.GetSelectedItem().index;
        _PharmacyToNameSelectedValue = (DropDownListPharmaciesDevXInstance.GetSelectedItem().value);
        _PharmacyToNameSelectedItemText = DropDownListPharmaciesDevXInstance.GetSelectedItem().text;
        _PharmacyToIdSource = (DropDownListPharmaciesDevXInstance.GetSelectedItem().value).slice(-1);

        if (_PharmacyToNameSelectedIndex == 0 || _PharmacyToNameSelectedIndex == -1) {
            document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_RadioButtonFaxToPharmacy').checked = false;
            document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_RadioButtonPrintScript').checked = true;
        } else {
            document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_RadioButtonFaxToPharmacy').checked = true;
            document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_RadioButtonPrintScript').checked = false;
        }
    }
    if (_PharmacyToNameSelectedIndex != 0) {
        $("[id$=HiddenField_PharmaciesId]")[0].value = _PharmacyToNameSelectedValue;
        $("[id$=HiddenField_PharmaciesName]")[0].value = _PharmacyToNameSelectedItemText;
    }
    else {
        var _PharmacyToNameSelectedValue1 = $("[id$=HiddenField_PharmaciesId]").val();
        var _PharmacyToNameSelectedItemText1 = $("[id$=HiddenField_PharmaciesName]").val();
        $("[id$=HiddenField_PharmaciesId]")[0].value = _PharmacyToNameSelectedValue1;
        $("[id$=HiddenField_PharmaciesName]")[0].value = _PharmacyToNameSelectedItemText1;
        //DropDownListPharmaciesDevXInstance.SetValue();
    }
}

function onFillPharmaciesComboSucceeded(ClientPharmacyId) {
    debugger;   /* ClientPharmacyId is the Client pref pharmacy*/
    var pharmacyid;
    var pharmacyName;
    pharmacyName = $("[id$=HiddenField_PharmaciesName]").val();
    if (ClientPharmacyId != "") {
        pharmacyid = ClientPharmacyId;
        $("[id$=DropDownListPharmacies_I]").val($("[id$=HiddenField_PharmaciesName]").val());
        $("input[id$=RadioButtonFaxToPharmacy]").prop("checked", true);
        if ($("input[id$=HiddenFieldChartCopy]").length > 0) {   /* Added this .length check bcos some case it is failing */
            if ($("input[id$=HiddenFieldChartCopy]").val().toUpperCase() == 'TRUE') {
                if ($("input[id$=RadioButtonFaxToPharmacy]")[0].checked == true && $("input[id$=HiddenFieldChartCopy]").val().toUpperCase() == "TRUE") {
                    $("input[id$=CheckBoxPrintChartCopy]").attr("checked", true);
                    MedicationPrescribe.EnableChartCopyPrinterDeviceLocation();
                }
            } else
                $("input[id$=CheckBoxPrintChartCopy]").attr("checked", false);
        }
    }

    MedicationPrescribe.AddItemInPreferredPharmacy(ClientPharmacyId);
    var _DrugsOrderMethod = document.getElementById("txtButtonValue").value;

    if (parent.$("[id$=HiddenFieldRedirectFrom]").val().toUpperCase() == "" && $("input[id$=HiddenFieldChangeOrderPharmacyId]").val() != "") {
        pharmacyid = $("[id$=HiddenFieldChangeOrderPharmacyId]").val();
        pharmacyName = $("[id$=HiddenFieldRefillPharmacyName]").val();

        var list = parent.$("[id$=DropDownListPharmacies_I]")[0];

        var PharmacyIdExists = false;
        var outerhtml;
        if ($("[id*=DropDownListPharmacies").length > 0) {
            outerhtml = ($("[id*=DropDownListPharmacies"))[0].outerHTML;
        }
        else {
            outerhtml = parent.$("[id*=DropDownListPharmacies")[0].outerHTML;
        }
        var itemvalues = outerhtml.substring(outerhtml.indexOf("itemsValue=") + 12, outerhtml.indexOf("'];"))
        if (itemvalues.search(pharmacyid) > 0) {
            PharmacyIdExists = true;
        }

        if (pharmacyid != "") {
            if (PharmacyIdExists) {
                if ($("input[id$=HiddenFieldRadioToFax]").val() == "true") {
                    $("input[id$=RadioButtonFaxToPharmacy]").attr("checked", true);
                    if ($("input[id$=HiddenFieldChartCopy]").length > 0) {  /* Added a .length check */
                        if ($("input[id$=HiddenFieldChartCopy]").val().toUpperCase() == 'TRUE') {
                            if ($("input[id$=RadioButtonFaxToPharmacy]")[0].checked == true && $("input[id$=HiddenFieldChartCopy]").val().toUpperCase() == "TRUE") {
                                $("input[id$=CheckBoxPrintChartCopy]").attr("checked", true);

                                MedicationPrescribe.EnableChartCopyPrinterDeviceLocation();
                            }
                        } else {
                            $("input[id$=CheckBoxPrintChartCopy]").attr("checked", false);
                        }
                    }
                } else {
                    $("input[id$=RadioButtonFaxToPharmacy]").attr("checked", false);
                }

                $("[id$=DropDownListPharmacies_I]").attr("disabled", false);

                $("[id$=ImageSearch]").css("display", "block");
                $("[id$=ImageSearch]").attr("disabled", false);

                $("[id$=DropDownListPharmacies_I]").val(pharmacyName);
                $("[id$=HiddenField_PharmaciesName]").val(pharmacyName)
                $("[id$=HiddenField_PharmaciesId]").val(pharmacyid)
            }
        }
    }

    if (parent.$("[id$=HiddenFieldRedirectFrom]").val().toUpperCase() == "DASHBOARD" && (_DrugsOrderMethod.toUpperCase() == "REFILL" ||_DrugsOrderMethod.toUpperCase()=="APPROVEWITHCHANGESCHANGEORDER"|| _DrugsOrderMethod.toUpperCase() == "CHANGEAPPROVALORDER"  || _DrugsOrderMethod.toUpperCase() == "NEW ORDER")) {
        var pharmacyid = $("[id$=HiddenFieldRefillPharmacyId]").val();
        var pharmacyName = $("[id$=HiddenFieldRefillPharmacyName]").val();

        var list = parent.$("[id$=DropDownListPharmacies_I]")[0];

        var PharmacyIdExists = false;
        var outerhtml;
        if ($("[id*=DropDownListPharmacies").length > 0) {
            outerhtml = ($("[id*=DropDownListPharmacies"))[0].outerHTML;
        }
        else {
            outerhtml = parent.$("[id*=DropDownListPharmacies")[0].outerHTML;
        }
        var itemvalues = outerhtml.substring(outerhtml.indexOf("itemsValue=") + 12, outerhtml.indexOf("'];"))
        if (itemvalues.search(pharmacyid) > 0) {
            PharmacyIdExists = true;
        }

        if (pharmacyid != "") {
            if (PharmacyIdExists) {
                $("[id$=DropDownListPharmacies_I]").val(pharmacyName);
                $("[id$=DropDownListPharmacies_I]").attr("disabled", "disabled");
                $("[id$=DropDownListPharmacies_B-1]").hide();
                if (pharmacyName != "")
                    $("[id$=HiddenFieldFullPharmacyName]").val(pharmacyName);

                $("[id$=ImageSearch]").css("display", "block");
                $("[id$=ImageSearch]").attr("disabled", true);
            } else {
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_LabelPharmacyName').innerText = pharmacyName;

                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_LabelPharmacyName').innerHTML = pharmacyName;

                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_LabelPharmacyName').style.display = 'block';
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListPharmacies').style.display = 'none';
                $("[id$=ImageSearch]").css("display", "none");
            }
        } else {
            $("[id$=DropDownListPharmacies_I]").attr("disabled", false);

            $("[id$=ImageSearch]").css("display", "block");
            $("[id$=ImageSearch]").attr("disabled", false);
        }
    }

    if (parent.$("[id$=HiddenFieldRedirectFrom]").val().toUpperCase() == "FROMQUEUEDORDERSCREEN") {
        if (pharmacyName != "")
            $("[id$=DropDownListPharmacies_I]").val(pharmacyName);
        if ($("[id$=HiddenField_OrderingMethod]").val() == 'P')
            $('input[id$=RadioButtonPrintScript]').prop('checked', true);
        else if ($("[id$=HiddenField_OrderingMethod]").val() == 'F' || $("[id$=HiddenField_OrderingMethod]").val() == 'E')
            $('input[id$=RadioButtonFaxToPharmacy]').prop('checked', true);
    }
    if ($("[id$=DropDownListPharmacies_I]").attr("disabled") == "disabled") {
        $("[id$=DropDownListPharmacies_I]").val($("[id$=HiddenFieldFullPharmacyName]").val());
    }
}

var ClientMedicationOrder = {
    CalToBeShown: function (ImgCalID, TextboxID) {
        try {
            var method = document.getElementById("txtButtonValue").value;
            if (method == "REFILL" || method == "Refill") {
                return false;
            } else
                ClientMedicationOrder.CalShow(ImgCalID, TextboxID);
        } catch (e) {
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
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    CloseButtonClick: function () {
        try {
            Streamline.SmartClient.WebServices.ClientMedications.CloseClick(ClientMedicationOrder.onCloseSucceeded, ClientMedicationOrder.onFailure);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    dialogForClose: function () {
        var answer = window.showModalDialog('YesNo.aspx?CalledFrom=Order', 'YesNo', 'menubar : no;status : no;resizable:no;dialogTop:200px;dialogWidth:423px; dialogHeight:178px;dialogLeft:300px,location:no; help: No;');
        if (answer == 'N') {
            if (LabelErrorMessage.innerText == "") {
            }
        }
        else {
            CallDeleteMedicationsButton();
            if ($("input[id*=HiddenPageName]")[0].value == "FromDashBoard") {
                redirectToVerbalOrder('A');
            }
        }
    },
    onCloseSucceeded: function (result, context) {
        try {
            if (result == true) {
                try {
                    ClientMedicationOrder.dialogForClose();
                } catch (e) {
                }
            } else {
                if ($("input[id*=HiddenFieldRedirectFrom]")[0].value.toString() == "DashBoard") {
                    redirectToStartPage();
                } else {
                    redirectToManagementPage();
                }
                return false;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onSystemConfigurationKeysToolTipSucceeded: function (result) {
        try {
            $("#ButtonInfo").attr('title', result)
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
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
                Streamline.SmartClient.WebServices.CommonService.CalculatePharmacy(Days, Quantity, Schedule, Sample, Stock, ClientMedicationOrder.onSucceededPharmacy, ClientMedicationOrder.onFailure, objRow);
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
            Streamline.SmartClient.WebServices.CommonService.CalculateEndDate(document.getElementById(startDate).value, Days, Refill, ClientMedicationOrder.onSucceeded, ClientMedicationOrder.onFailure);
        } catch (e) {
            StartDateBox.innerText = "";
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    CalculateTempEndDate: function (startDate, days, refill, enddate) {
        try {
            var Days = document.getElementById(days).value;
            var Refill = document.getElementById(refill).value;
            if (document.getElementById(startDate).value == "")
                return;
            if (Days == "")
                Days = 0;
            if (Refill == "")
                Refill = 0;
            var d = new Date(document.getElementById(startDate).value);
            var _toAdd = parseInt(Days) * (parseInt(Refill) + 1);
            d.setDate(d.getDate() + parseInt(_toAdd));
            $get(enddate).value = d.format("MM/dd/yyyy");
        } catch (ex) {
            //alert('CalculateTempEndDate' + ex);
        }
    },
    onSucceeded: function (result) {
        try {
            if (result == "") {
                StartDateBox.innerText = "";
                EndDate.innerText = "";
            } else
                EndDate.value = result;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
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
            Streamline.SmartClient.WebServices.ClientMedications.GetMedicationStrength(intMedicationNameId, ClientMedicationOrder.onStrengthSucceeded, ClientMedicationOrder.onFailure, context);
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
                optionItem.setAttribute("ExternalMedicationId", result[i]["ExternalMedicationId"]);
                optionItem.setAttribute("PotencyUnitCode", result[i]["PotencyUnitCode"]);
                DropDown.options[DropDown.length] = optionItem;
            }
            if (context.SelectedValue) {
                DropDown.value = context.SelectedValue;
                if (!context.CauseChangeEvent) {
                    var _imgFormulary = $(DropDown).parent().parent("tr")[0].cells[2].getElementsByTagName("img")[0];
                    var _externalMedicationId = $('option:selected', DropDown).attr('ExternalMedicationId');
                    if (_externalMedicationId != null && _externalMedicationId != '') {
                        _imgFormulary.setAttribute('ExternalMedicationId', _externalMedicationId);
                        _imgFormulary.disabled = false;
                    }
                }
                if (context.Unit)
                    ClientMedicationOrder.FillUnit(DropDown, context.Unit.DropDown.id, context.Unit.SelectedValue);
            }
            if (context.CauseChangeEvent) {
                $(DropDown).change();
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
            Streamline.SmartClient.WebServices.ClientMedications.FillDxPurpose(ClientMedicationOrder.onDxPurposeSucceeded, ClientMedicationOrder.onFailure, context);
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
            Streamline.SmartClient.WebServices.ClientMedications.FillPrescriber(ClientMedicationOrder.onPrescriberSucceeded, ClientMedicationOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onPrescriberSucceeded: function (result, context, methodname) {
        try {
            context.innerHTML = "";
            if (result == null || result.rows == null || !result.rows)
                return;
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
            Streamline.SmartClient.WebServices.ClientMedications.FillSchedule(ClientMedicationOrder.onScheduledSucceeded, ClientMedicationOrder.onFailure, context);
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
        }

    },
    FillPotencyUnitCodes: function (medicationNameId, ddlPotencyUnitCodes, selectedValue) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var context = new Object();
            context.DropDown = ddlPotencyUnitCodes;
            context.SelectedValue = selectedValue;
            Streamline.SmartClient.WebServices.ClientMedications.FillPotencyUnitCodes(medicationNameId, ClientMedicationOrder.onFillPotencyUnitCodesSucceeded, ClientMedicationOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    FillMedicationRelatedInformation: function (medicationId, clientId, TextBoxSpecialInstructions, TextBoxDesiredOutcome, TextBoxComments, CheckboxIncludeOnPrescription, selectedValue) {
        try {
            fnShow(); 
            var context = new Object();
            context.TextBoxSpecialInstructions = TextBoxSpecialInstructions;
            context.TextBoxDesiredOutcome = TextBoxDesiredOutcome;
            context.TextBoxComments = TextBoxComments;
            context.CheckboxIncludeOnPrescription = CheckboxIncludeOnPrescription;
            Streamline.SmartClient.WebServices.ClientMedications.FillMedicationRelatedInformation(medicationId, clientId, ClientMedicationOrder.onFillMedicationRelatedInformationSucceeded, ClientMedicationOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onFillMedicationRelatedInformationSucceeded: function (result, context, methodname) {
        try {
            if (result == null || result.length <= 0)
                return;
            var textComments = context.TextBoxComments;
            textComments.value = result[0]["Comments"] == null ? "" : result[0]["Comments"];

            //var textboxSpecialInstructions = context.TextBoxSpecialInstructions;
            //textboxSpecialInstructions.value = result[0]["SpecialInstructions"];

            //var textBoxDesiredOutcome = context.TextBoxDesiredOutcome;
            //textBoxDesiredOutcome.value = result[0]["DesiredOutcomes"];

            var IncludeCommentOnPrescription = result[0]["IncludeCommentOnPrescription"];
            if(IncludeCommentOnPrescription=='Y')
                document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_CheckboxIncludeOnPrescription").checked = true;
            else
                document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_CheckboxIncludeOnPrescription").checked = false;

        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
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
        }
    },
    onDxPurposeChange: function () {
        try {
            if (document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListDxPurpose').value != -1) {
                document.getElementById('ImgSearchIcon').style.display = "block";
                document.getElementById('ImgComments').style.display = "none";
            } else {
                document.getElementById('ImgSearchIcon').style.display = "none";
            }
            ClientMedicationOrder.SetDocumentDirty();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onPrescriber: function () {
        try {
            ClientMedicationOrder.SetDocumentDirty();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onUnitBlur: function (Unit) {
        try {
            document.getElementById('buttonInsert').disabled = false;
            document.getElementById("HiddenFieldGirdDirty").value = "true";
            ClientMedicationOrder.ManipulateRowValues(null, Unit);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onScheduleBlur: function (Schedule) {
        try {
            document.getElementById('buttonInsert').disabled = false;
            document.getElementById("HiddenFieldGirdDirty").value = "true";
            ClientMedicationOrder.ManipulateRowValues(null, Schedule);

            var num = Schedule.id.slice(-1);
            var SelectDays = $("[id$=noOfDaysOfWeek" + num + "]").val();
            ClientMedicationOrder.clearDaysofWeek();
            if (SelectDays != "" && SelectDays != undefined)
                ClientMedicationOrder.fillDaysofWeek(SelectDays);
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
    onUnitChange: function (rowIndex) {
        try {
            document.getElementById('buttonInsert').disabled = false;
            ClientMedicationOrder.SetDocumentDirty();
            document.getElementById("HiddenFieldGirdDirty").value = "true";
            var context = new Object();
            context.rowIndex = rowIndex;
            var table = $("[id$=tableMedicationOrder]")[0];
            context.SelectedValue = "";
            var currentRow = table.rows[context.rowIndex];
            var dosage = 0;
            if (currentRow.cells[3].getElementsByTagName("input")[0].value != "")
                dosage = parseFloat(currentRow.cells[3].getElementsByTagName("input")[0].value);
            var schedule = currentRow.cells[5].getElementsByTagName("select")[0].value;
            if (currentRow.cells[16].getElementsByTagName("input")[0].value == "N") {
                var pharmacyTextComboBox = document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value;
                if (pharmacyTextComboBox != null && pharmacyTextComboBox != "") {
                    context.SelectedValue = pharmacyTextComboBox;
                    $("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
                } else {
                    $("input[id$=HiddenFieldSelectedValue]").val("");
                }
                if (currentRow.cells[1].getElementsByTagName("select")[0].value > 0 &&
                    currentRow.cells[3].getElementsByTagName("input")[0].value > 0 &&
                    currentRow.cells[5].getElementsByTagName("select")[0].value > 0 &&
                    currentRow.cells[8].getElementsByTagName("input")[0].value > 0 &&
                    currentRow.cells[4].getElementsByTagName("select")[0].value > 0) {
                    for (j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (rowIndex != j) {
                            if (currentRow.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                if (newRow.cells[3].getElementsByTagName("input")[0].value > 0)
                                    dosage = dosage + parseFloat(newRow.cells[3].getElementsByTagName("input")[0].value);
                                schedule = schedule + "," + newRow.cells[5].getElementsByTagName("select")[0].value;
                            }
                        }
                    }
                    ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                    Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(
                        currentRow.cells[1].getElementsByTagName("select")[0].value, dosage, schedule,
                            currentRow.cells[8].getElementsByTagName("input")[0].value, ClientMedicationOrder.onDispenseQuantitySucceeded, ClientMedicationOrder.onFailure, context);
                } else {
                    ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                }
            } else {
                $("input[id$=HiddenFieldSelectedValue]").val("");
                ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                ClientMedicationOrder.callDispenseQntCalculateMethod(currentRow, rowIndex);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onScheduleChange: function (rowIndex) {
        try {
            document.getElementById('buttonInsert').disabled = false;
            ClientMedicationOrder.SetDocumentDirty();
            document.getElementById("HiddenFieldGirdDirty").value = "true";
            var context = new Object();
            context.rowIndex = rowIndex;
            var table = $("[id$=tableMedicationOrder]")[0];
            context.SelectedValue = "";
            var currentRow = table.rows[context.rowIndex];
            var dosage = 0;
            if (currentRow.cells[3].getElementsByTagName("input")[0].value != "")
                dosage = parseFloat(currentRow.cells[3].getElementsByTagName("input")[0].value);
            var schedule = currentRow.cells[5].getElementsByTagName("select")[0].value;
            if (currentRow.cells[16].getElementsByTagName("input")[0].value == "Y") {
                $("input[id$=HiddenFieldSelectedValue]").val("");
            }
            if (currentRow.cells[16].getElementsByTagName("input")[0].value == "N") {
                var pharmacyTextComboBox = document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value;
                if (pharmacyTextComboBox != null && pharmacyTextComboBox != "") {
                    context.SelectedValue = pharmacyTextComboBox;
                    $("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
                } else {
                    $("input[id$=HiddenFieldSelectedValue]").val("");
                }
                if (currentRow.cells[1].getElementsByTagName("select")[0].value > 0 &&
                    currentRow.cells[3].getElementsByTagName("input")[0].value > 0 &&
                    currentRow.cells[5].getElementsByTagName("select")[0].value > 0 &&
                    currentRow.cells[8].getElementsByTagName("input")[0].value > 0 &&
                    currentRow.cells[4].getElementsByTagName("select")[0].value > 0) {
                    for (j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (rowIndex != j) {
                            if (currentRow.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                if (newRow.cells[3].getElementsByTagName("input")[0].value > 0)
                                    dosage = dosage + parseFloat(newRow.cells[3].getElementsByTagName("input")[0].value);
                                schedule = schedule + "," + newRow.cells[5].getElementsByTagName("select")[0].value;
                            }
                        }
                    }

                    ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                    Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(
                        currentRow.cells[1].getElementsByTagName("select")[0].value, dosage, schedule,
                            currentRow.cells[8].getElementsByTagName("input")[0].value, ClientMedicationOrder.onDispenseQuantitySucceeded, ClientMedicationOrder.onFailure, context);
                } else {
                    ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                }
            } else {
                ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onStartDate: function (StartDate, rowIndex) {
        try {
            document.getElementById('buttonInsert').disabled = false;
            document.getElementById("HiddenFieldGirdDirty").value = "true";
            var method = document.getElementById("txtButtonValue").value;
            var table = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_tableMedicationOrder');
            var row = table.rows[rowIndex];
            var Category = row.cells[15].getAttribute("MedicationCategory");
            if (method == "REFILL" || method == "Refill") {
                var store = document.activeElement;
                if (rowIndex == 0) {
                    if (document.getElementById("HiddenFieldOldStartDate").value != StartDate.value) {
                        var _NextRow = table.rows[1];
                        var _NextStrength = _NextRow.cells[1].getElementsByTagName("select")[0].value;
                        if (_NextStrength != -1) {
                            // if (confirm("Apply this date change to other items in the list?")) {
                            var answer = window.showModalDialog('YesNo.aspx?CalledFrom=ClienMedicationOrderSDate', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
                            if (answer == 'Y') {
                                var oldStartDate = new Date(document.getElementById("HiddenFieldOldStartDate").value);
                                var newStartDate = new Date(StartDate.value);
                                var ONE_DAY = 1000 * 60 * 60 * 24;
                                var date1_ms = oldStartDate.getTime();
                                var date2_ms = newStartDate.getTime();
                                var difference_ms = date2_ms - date1_ms;
                                var DaysDiff = Math.round(difference_ms / ONE_DAY);
                                var ExitLoop = false;
                                if (table.rows.length > 0) {
                                    var row = table.rows[0];
                                    for (var i = 0; i < table.rows.length; i++) {
                                        if (ExitLoop == false) {
                                            var NextCnt = i;
                                            var row = table.rows[i];
                                            var Strength = row.cells[1].getElementsByTagName("select")[0].value;
                                            var Days = row.cells[8].getElementsByTagName("input")[0];
                                            var startDate = new Date(row.cells[6].getElementsByTagName("input")[0].value);
                                            var editDate = new Date(startDate.setDate(startDate.getDate() + DaysDiff));
                                            var Refills = row.cells[11].getElementsByTagName("input")[0];
                                            var EndDate = row.cells[14].getElementsByTagName("input")[0];
                                            row.cells[6].getElementsByTagName("input")[0].setAttribute('SuspendRowManipulation', 'true');
                                            Days.setAttribute('SuspendRowManipulation', 'true');
                                            EndDate.setAttribute('SuspendRowManipulation', 'true');
                                            Refills.setAttribute('SuspendRowManipulation', 'true');
                                            if (i == 0)
                                                row.cells[6].getElementsByTagName("input")[0].value = StartDate.value;
                                            else
                                                row.cells[6].getElementsByTagName("input")[0].value = editDate.format("MM/dd/yyyy");
                                            var NewStartDate = row.cells[6].getElementsByTagName("input")[0];
                                            if (((Number.parseInvariant(Days.value) < 1) || (Number.parseInvariant(Days.value) > 365)) == false) {
                                                ClientMedicationOrder.CalculateTempEndDate(NewStartDate.id, Days.id, Refills.id, EndDate.id);
                                            }
                                            if (NextCnt < table.rows.length - 1) {
                                                NextCnt = NextCnt + 1;
                                                var nextrow = table.rows[NextCnt];
                                                var nextStrength = nextrow.cells[1].getElementsByTagName("select")[0].value;
                                                document.getElementById("HiddenFieldOldStartDate").value = StartDate.value;
                                                if (nextStrength == '-1' || Strength == "") {
                                                    ExitLoop = true;
                                                }
                                            }
                                            row.cells[6].getElementsByTagName("input")[0].setAttribute('SuspendRowManipulation', 'false');
                                            Days.setAttribute('SuspendRowManipulation', 'false');
                                            EndDate.setAttribute('SuspendRowManipulation', 'false');
                                            Refills.setAttribute('SuspendRowManipulation', 'false');
                                        }
                                    }
                                }
                            } else {
                                var row = table.rows[0];
                                row.cells[6].getElementsByTagName("input")[0].value = StartDate.value;
                                document.getElementById("HiddenFieldOldStartDate").value = StartDate.value;
                            }
                        }
                    }
                }
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    RecalculateEndDate: function (startDate, days, refill, enddate) {
        try {
            var oneMinute = 60 * 1000;
            var oneHour = oneMinute * 60;
            var oneDay = oneHour * 24;
            var threeDays = oneDay * days;
            var enddate = new Date();
            var startDateNew = new Date();
            var Days = document.getElementById(days).value;
            var Refill = document.getElementById(refill).value;
            if (document.getElementById(startDate).value == "")
                return;
            if (Days == "")
                Days = 0;
            if (Refill == "")
                Refill = 0;
            EndDate = document.getElementById(enddate);
            startDateNew = document.getElementById(startDate);
            if (!Date.parse(document.getElementById(startDate).value)) {
                document.getElementById(startDate).value = "";
                return;
            }
            dateInMs = startDateNew.getTime();
            dateInMs += threeDays;
            startDateNew.setTime(dateInMs);
            return startDateNew.ToString("MM/dd/yyyy");
        } catch (e) {
        }
    },
    onEndDate: function () {
        try {
            document.getElementById('buttonInsert').disabled = false;
            document.getElementById("HiddenFieldGirdDirty").value = "true";
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    TextBoxOrderDate: function () {
        try {
            ClientMedicationOrder.SetDocumentDirty();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onStrengthChange: function (obj, unit, unitValue, days, TopStartDate, startDate, quantity, rowIndex) //,HiddenMedicationNameId)
    {
        try {
            var method = document.getElementById("txtButtonValue").value;
            if (method == 'REFILL' || method == 'Refill' || method == '' || document.getElementById(startDate).value == "") {
                var today = new Date();
                if (document.getElementById(TopStartDate).value == "") {
                    document.getElementById(TopStartDate).value = today.format("MM/dd/yyyy");
                }
                if (rowIndex == "0") {
                    var rxStartDate = new Date(document.getElementById(TopStartDate).value);
                }
                else {
                    if (document.getElementById(startDate).value != "") {
                        var rxStartDate = new Date(document.getElementById(startDate).value);
                    }
                    else {
                        var rxStartDate = new Date(document.getElementById(TopStartDate).value);
                    }
                }

                document.getElementById(startDate).value = rxStartDate.format("MM/dd/yyyy");
            }
            var context = new Object();
            context.rowIndex = rowIndex;
            var table = $("[id$=tableMedicationOrder]")[0];
            var currentRow = table.rows[context.rowIndex];
            var _medicationId = obj.options[obj.selectedIndex].getAttribute('MedicationId');
            var _externalMedicationId = obj.options[obj.selectedIndex].getAttribute('ExternalMedicationId');
            var _imgFormulary = currentRow.cells[2].getElementsByTagName("img")[0];
            if (_externalMedicationId != null && _externalMedicationId != '') {
                _imgFormulary.setAttribute('ExternalMedicationId', _externalMedicationId);
                _imgFormulary.disabled = false;
            }
            var hiddenDefaultPrescribingQuantity = document.getElementById("HiddenDefaultPrescribingQuantity").value;
            var textboxQuantity = document.getElementById(quantity);
            if (textboxQuantity.value == '') {
                textboxQuantity.value = hiddenDefaultPrescribingQuantity;
            }
            ClientMedicationOrder.FillUnit(obj, unit, unitValue);
            if ($get(days).value != "" && $get(days).value != null && $get(days).value != '') {

            } else {
                $get(days).value = $get(days).getAttribute("MedicationDays");
            }
            ClientMedicationOrder.PotencyUnitCodeUpdate(table, rowIndex, "DropDownListStrength");
            document.getElementById('buttonInsert').disabled = false;
            var MedicationNameId = document.getElementById('ComboBoxDrugDD').getAttribute('opid');
            var MedicationName = document.getElementById('ComboBoxDrugDD').value;
            ClientMedicationOrder.GetFormularyInformation(MedicationNameId, _externalMedicationId, ClientMedicationOrder.onSuccessFormularyInformation); // Added By PranayB.
            Streamline.SmartClient.WebServices.ClientMedications.CalculateAutoCalcAllow(currentRow.cells[1].getElementsByTagName("select")[0].value, ClientMedicationOrder.onAutoCalcAllowSucceeded, ClientMedicationOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onPotencyUnitCodeChange: function (obj, rowId) {
        ClientMedicationOrder.SetDocumentDirty();
        document.getElementById("HiddenFieldGirdDirty").value = "true";
        ClientMedicationOrder.PotencyUnitCodeUpdate($("[id$=tableMedicationOrder]")[0], rowId, "DropDownListPotencyUnitCode");
        return;
    },
    PotencyUnitCodeUpdate: function (htmlTable, currentRowId, event) {
        var pucList = [];
        for (var i = 0; i < htmlTable.rows.length; i++) {
            var potencyUnitCode = "";
            var row = htmlTable.rows[i];
            var sel = row.cells[1].getElementsByTagName("select")[0];
            var selPuc = row.cells[10].getElementsByTagName("select")[0];
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
    callDispenseQntCalculateMethod: function (currentRow, rowIndex)
    {
        try {
            var objRow = new Object();
            objRow.MedicationId = currentRow.cells[1].getElementsByTagName("select")[0];
            objRow.rowIndex = rowIndex;
            objRow.Schedule = currentRow.cells[5].getElementsByTagName("select")[0];
            objRow.Quantity = currentRow.cells[3].getElementsByTagName("input")[0];
            if (objRow.Quantity.value != "")
                dosage = parseFloat(objRow.Quantity.value);
            var schedule = objRow.Schedule.value;
            objRow.Units = currentRow.cells[4].getElementsByTagName("select")[0];
            objRow.StartDate = currentRow.cells[6].getElementsByTagName("input")[0];
            objRow.Days = currentRow.cells[8].getElementsByTagName("input")[0];
            objRow.Pharmacy = currentRow.cells[9].getElementsByTagName("input")[0];
            objRow.Sample = currentRow.cells[12].getElementsByTagName("input")[0];
            objRow.Stock = currentRow.cells[13].getElementsByTagName("input")[0];
            objRow.Refills = currentRow.cells[11].getElementsByTagName("input")[0];
            objRow.EndDate = currentRow.cells[14].getElementsByTagName("input")[0];

            //   if (CallingObjectId.indexOf("TextBoxQuantity") > 0 || CallingObjectId.indexOf("DropDownListSchedule") > 0 || CallingObjectId.indexOf("TextBoxDays") > 0)
            if (((Number.parseInvariant(objRow.Days.value) < 1) || (Number.parseInvariant(objRow.Days.value) > 365)) == false)
                ClientMedicationOrder.CalculatePharmacy(objRow);
        } catch (e) {
        }
    },
    onAutoCalcAllowSucceeded: function (result, context) { //#ka rolled over
        try {

            var rowIndex = context.rowIndex;
            var table = $("[id$=tableMedicationOrder]")[0];
            var currentRow = table.rows[rowIndex];
            if (result.rows.length > 0) {
                currentRow.cells[16].getElementsByTagName("input")[0].value = result.rows[0]["AutoCalcAllowed"];
                for (var i = 0; i < table.rows.length; i++) {
                    var row = table.rows[i];
                    row.cells[9].getElementsByTagName("input")[0].disabled = false;
                    row.cells[10].getElementsByTagName("select")[0].disabled = false;
                    row.cells[11].getElementsByTagName("input")[0].disabled = false;
                    row.cells[12].getElementsByTagName("input")[0].disabled = false;
                    row.cells[13].getElementsByTagName("input")[0].disabled = false;
                }
                for (var i = 0; i < table.rows.length; i++) {
                    var row = table.rows[i];
                    for (var j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (row.cells[1].getElementsByTagName("select")[0].value != "-1") {
                            if (row.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value && row.cells[16].getElementsByTagName("input")[0].value == "N") {
                                if (j > i) {
                                    newRow.cells[10].getElementsByTagName("select")[0].disabled = true;
                                    newRow.cells[11].getElementsByTagName("input")[0].disabled = true;
                                    newRow.cells[12].getElementsByTagName("input")[0].disabled = true;
                                    newRow.cells[13].getElementsByTagName("input")[0].disabled = true;
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
            if (currentRow.cells[3].getElementsByTagName("input")[0].value != "")
                dosage = parseFloat(currentRow.cells[3].getElementsByTagName("input")[0].value);
            var schedule = currentRow.cells[5].getElementsByTagName("select")[0].value;

            if (currentRow.cells[16].getElementsByTagName("input")[0].value == "N") {
                var pharmacyTextComboBox = document.getElementById("ComboBoxPharmacyDD_" + context.rowIndex).value;
                if (pharmacyTextComboBox != null && pharmacyTextComboBox != "") {
                    newContext.SelectedValue = pharmacyTextComboBox;
                    $("input[id$=HiddenFieldSelectedValue]").val(newContext.SelectedValue);
                } else {
                    $("input[id$=HiddenFieldSelectedValue]").val("");
                }
                if (currentRow.cells[1].getElementsByTagName("select")[0].value > 0 && currentRow.cells[3].getElementsByTagName("input")[0].value > 0 && currentRow.cells[5].getElementsByTagName("select")[0].value > 0 && currentRow.cells[8].getElementsByTagName("input")[0].value > 0 && currentRow.cells[4].getElementsByTagName("select")[0].value > 0) {
                    //Condition added in ref to Task#2905.            
                    for (j = 0; j < table.rows.length; j++) {
                        var newRow = table.rows[j];
                        if (rowIndex != j) {
                            if (currentRow.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                if (newRow.cells[3].getElementsByTagName("input")[0].value > 0)
                                    dosage = dosage + parseFloat(newRow.cells[3].getElementsByTagName("input")[0].value);
                                schedule = schedule + "," + newRow.cells[5].getElementsByTagName("select")[0].value;
                            }
                        }
                    }
                    ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + context.rowIndex, "#ComboBoxPharmacyDDList_" + context.rowIndex);
                    Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(currentRow.cells[1].getElementsByTagName("select")[0].value, dosage, schedule, currentRow.cells[9].getElementsByTagName("input")[0].value, ClientMedicationOrder.onDispenseQuantitySucceeded, ClientMedicationOrder.onFailure, newContext);
                } else {
                    ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + context.rowIndex, "#ComboBoxPharmacyDDList_" + context.rowIndex);
                }
               } 
            else {
                $("input[id$=HiddenFieldSelectedValue]").val("");
                ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + context.rowIndex, "#ComboBoxPharmacyDDList_" + context.rowIndex);
                ClientMedicationOrder.callDispenseQntCalculateMethod(currentRow, rowIndex);             
            }
        } catch (e) {
        }
    },
    FillUnit: function (ddlStrength, ddlUnit, selectedValue)//,MedicationNameId)
    {
        try {
            if (ddlStrength.selectedIndex == null || ddlStrength.selectedIndex <= 0)
                return;
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            var MedicationId = ddlStrength.options[ddlStrength.selectedIndex].getAttribute('MedicationId');
            var context = new Object();
            context.DropDown = document.getElementById(ddlUnit);
            context.SelectedValue = selectedValue;
            Streamline.SmartClient.WebServices.ClientMedications.FillUnit(MedicationId, ClientMedicationOrder.onUnitSucceeded, ClientMedicationOrder.onFailure, context);
            Streamline.SmartClient.WebServices.ClientMedications.C2C5Drugs(MedicationId, ClientMedicationOrder.onC2C5DrugSucceeded, ClientMedicationOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    onC2C5DrugSucceeded: function (result, context, methodname) { //#ka rolled over
        try {

            try {
                _Row = context.DropDown.parentNode.parentNode;
                _Row.cells[15].setAttribute("MedicationCategory", "");
            } catch (e) {
            }
            if (result == null || result.rows == null || !result.rows)
                return;
            if (result.rows.length > 0) {
                _Row.cells[15].setAttribute("MedicationCategory", result.rows[0]["Category"]);
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
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request." || error.get_message().indexOf('failed') > 0) {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        //else {
        //alert(error.get_message());
        //}
    },
    DeleateFromList: function (s, e) {
        sessionStorage.setItem('s', JSON.stringify(s));  
        sessionStorage.setItem('e', JSON.stringify(e));        
        var popupWindow = window.showModalDialog('YesNo.aspx?CalledFrom=MedicationList', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
        if (popupWindow == 'Y') {
            if (e == undefined) {
                var s = JSON.parse(sessionStorage.s);
                var e = JSON.parse(sessionStorage.e);
            }
            try {
                fnShow(); //By Vikas Vyas On Dated April 04th 2008 
                Streamline.SmartClient.WebServices.ClientMedications.DeleteClientMedication(e.MedicationId, ClientMedicationOrder.onDeleteButtonSucceeded, ClientMedicationOrder.onFailure, e);
            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
            }
        }
    },
    onDeleteButtonSucceeded: function (result, context, methodname) {
        try {
            if (result == true) {
                ClientMedicationOrder.GetMedicationList(PanelMedicationList);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    RadioButtonParameters: function (e, TextBoxOrderDate, TextboxDrug, TextBoxSpecialInstructions, DropDownListDxPurpose, DropDownListPrescriber, TableName, HiddenRowIdentifier, HiddenMedicationNameId, HiddenMedicationName, TextBoxStartDate, CheckBoxDispense, TextBoxDesiredOutcome, TextBoxComments, CheckBoxOffLabel, CheckboxIncludeOnPrescription, HiddenOrderPageCommentLabel, HiddenOrderPageCommentLabelIncludeOnPrescription, LabelCommentText) {
        try {
            fnShow();
            var context = new Object();
            context.HiddenOrderPageCommentLabel = HiddenOrderPageCommentLabel;
            context.HiddenOrderPageCommentLabelIncludeOnPrescription = HiddenOrderPageCommentLabelIncludeOnPrescription;
            context.LabelCommentText = LabelCommentText;
            context.OrderDate = TextBoxOrderDate;
            context.Drug = TextboxDrug;
            context.SpecialInstructions = TextBoxSpecialInstructions;
            context.DxPurpose = DropDownListDxPurpose;
            context.Prescriber = DropDownListPrescriber;
            context.Table = TableName;
            context.MedicationNameId = HiddenMedicationNameId;
            context.HiddenRowIdentifier = HiddenRowIdentifier;
            context.MedicationName = HiddenMedicationName;
            context.CheckBoxDispense = CheckBoxDispense;
            context.DesiredOutCome = TextBoxDesiredOutcome;
            context.Comments = TextBoxComments;
            context.OffLabel = CheckBoxOffLabel;
            context.IncludeOnPrescription = CheckboxIncludeOnPrescription;
            context.MedicationStartDate = TextBoxStartDate;
            var Orderingmethod = document.getElementById("txtButtonValue").value.toUpperCase();
            Streamline.SmartClient.WebServices.ClientMedications.RadioButtonClick(e.MedicationId, ClientMedicationOrder.onRadioButtonSucceeded, ClientMedicationOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onRadioButtonSucceeded: function (result, context, methodname) {
        try {
            $("#ComboBoxDrugDD").val(result.tables[0].rows[0]["MedicationName"].toString()).attr('opid', result.tables[0].rows[0]["MedicationNameId"]);
            var externalMedicationNameId = result.tables[0].rows[0]["ExternalMedicationNameId"];
            $("[id$='HiddenExternalMedicationNameId']").val(externalMedicationNameId);
            document.getElementById(context.MedicationNameId).value = result.tables[0].rows[0]["MedicationNameId"];
            if (result.tables[0].rows[0]["SpecialInstructions"] != null)
                document.getElementById(context.SpecialInstructions).value = result.tables[0].rows[0]["SpecialInstructions"];
            document.getElementById(context.DxPurpose).value = result.tables[0].rows[0]["DxId"];
            var Orderingmethod = document.getElementById("txtButtonValue").value.toUpperCase();
            $("input[id$=HiddenFieldPrescriber]").val("");
            $("input[id$=HiddenFieldPrescriberName]").val("");
            document.getElementById(context.Prescriber).value = result.tables[0].rows[0]["PrescriberId"];
            $("input[id$=HiddenFieldPrescriber]").val(result.tables[0].rows[0]["PrescriberId"]);
            $("input[id$=HiddenFieldPrescriberName]").val(result.tables[0].rows[0]["PrescriberName"]);
            if (result.tables[4].rows[0]["MedicationInstrStartDate"] != null) {
                document.getElementById(context.MedicationStartDate).value = result.tables[4].rows[0].MedicationInstrStartDate.format("MM/dd/yyyy");
            }

            if (result.tables[0].rows[0]["DesiredOutcomes"] != null)
                document.getElementById(context.DesiredOutCome).value = result.tables[0].rows[0]["DesiredOutcomes"];
            if (result.tables[0].rows[0]["Comments"] != null)
                document.getElementById(context.Comments).value = result.tables[0].rows[0]["Comments"];
            if (result.tables[0].rows[0]["OffLabel"] == "Y") {
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxOffLabel').checked = true;
            } else {
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxOffLabel').checked = false;
            }
            if (result.tables[0].rows[0]["IncludeCommentOnPrescription"] == "Y") {
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckboxIncludeOnPrescription').checked = true;
                document.getElementById(context.LabelCommentText).innerText = document.getElementById(context.HiddenOrderPageCommentLabelIncludeOnPrescription).value;
            } else {
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckboxIncludeOnPrescription').checked = false;
                document.getElementById(context.LabelCommentText).innerText = document.getElementById(context.HiddenOrderPageCommentLabel).value;
            }
            document.getElementById(context.HiddenRowIdentifier).value = result.tables[0].rows[0]["RowIdentifier"];
            document.getElementById(context.MedicationName).value = result.tables[0].rows[0]["MedicationName"];
            if (result.tables[0].rows[0]["DAW"] == "Y") {
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxDispense').checked = true;
            } else {
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxDispense').checked = false;
            }
            try {
                if (result.tables[0].rows[0]["MedicationName"].toString() != "") {
                    document.getElementById('ImgSearch').style.display = "block";
                }
            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
            if (document.getElementById(context.DxPurpose).value != "") {
                document.getElementById('ImgSearchIcon').style.display = "block";
                document.getElementById('ImgComments').style.display = "none";
            } else {
                document.getElementById('ImgSearchIcon').style.display = "none";
                document.getElementById('ImgComments').style.display = "block";
                document.getElementById('ImgComments').title = result.tables[0].rows[0]["DxId"];
            }
            if (result.tables[0].rows[0]["PermitChangesByOtherUsers"] != null) {
                if (result.tables[0].rows[0]["PermitChangesByOtherUsers"].toUpperCase() == 'N') {
                    document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxPermitChanges').checked = false;
                } else {
                    document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxPermitChanges').checked = true;
                }
            } else {
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxPermitChanges').checked = true;
            }

            if (result.tables[2].rows[0]["OrderingMethod"] == 'P')
                $('[id$=RadioButtonPrintScript]').attr('checked', true);
            else if (result.tables[2].rows[0]["OrderingMethod"] == 'F' || result.tables[2].rows[0]["OrderingMethod"] == 'E')
                $('[id$=RadioButtonFaxToPharmacy]').attr('checked', true);
            if (result.tables[2].rows[0]["PharmacyId"] != null)
                $("select[id$=DropDownListPharmacies]").val(result.tables[2].rows[0]["PharmacyId"]);
            if (result.tables[2].rows[0]["PrintDrugInformation"] == 'Y')
                $('[id$=CheckBoxPrintDrugInformation]').attr('checked', true);
            if (result.tables[2].rows[0]["LocationId"] != null)
                $("select[id$=DropDownListLocations]").val(result.tables[2].rows[0]["LocationId"]);
            var table1 = document.getElementById(context.Table);
            if (result.tables[1].rows.length > table1.rows.length) {
                ClientMedicationOrder.AddMedicationSteps('true', result);
            } else {
                ClientMedicationOrder.FillMedicationRowsOnRadioClick(result);
            }
			ClientMedicationOrder.FillDEANumber(document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListDEANumber'));
            ClientMedicationOrder.GetFormularyInformation(externalMedicationNameId, '', ClientMedicationOrder.onSuccessFormularyInformation)
            if ($("input[id$=HiddenFieldDrugInfo]").length > 0) {
                var ClientDOB = $("input[id$=HiddenFieldDrugInfo]").val();
                ClientMedicationOrder.GetDrugInfo(result.tables[0].rows[0]["MedicationNameId"], ClientDOB);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
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
        this.RowIdentifierCMI;
        this.AutoCalcallow;
        this.PharmaText;
        this.StrengthRowIdentifier;
        this.PotencyUnitCode;
        this.NoOfDaysOfWeek;
    },
    ClientMedicationRow: function () {
        this.MedicationNameId;
        this.ExternalMedicationNameId;
        this.DrugPurpose;
        this.DSMCode;
        this.DSMNumber;
        this.ClientId;
        this.PrescriberName;
        this.PrescriberId;
        this.Ordered;
        this.OrderDate;
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
        this.PermitChangesByOtherUsers;
        this.IncludeOnPrescription;
        this.PlanName;
    },
    ClearDrug: function (TextBoxStartDate, TextBoxOrderDate, TextboxDrug, TextBoxSpecialInstructions, DropDownListDxPurpose, DropDownListPrescriber, TitrateButton, TextBoxDesiredOutcome, TextBoxComments) {
        try {
            var today = new Date();
            var month = today.getMonth() + 1;
            var day = today.getDate();
            var year = today.getFullYear();
            var s = "/";
            ClientMedicationOrder.ClearDrugComboList("#ComboBoxDrugDD", "#ComboBoxDrugDDList");
            document.getElementById(TextBoxSpecialInstructions).value = "";
            document.getElementById(DropDownListDxPurpose).value = "";
            document.getElementById(TextBoxComments).value = "";
            document.getElementById(TextBoxDesiredOutcome).value = "";
            var Orderingmethod = document.getElementById("txtButtonValue").value.toUpperCase();
            if (!( Orderingmethod == 'CHANGE')) {
                document.getElementById(TextBoxStartDate).value = month + s + day + s + year;
                document.getElementById('ButtonTitrate').disabled = false;
            } else {
                document.getElementById(TextBoxStartDate).value = "";
                document.getElementById('ButtonTitrate').disabled = true;
            }
            if ($('[id*=TextBoxDrugInfo').length > 0) {
                $('[id*=TextBoxDrugInfo').val('');
            }
            document.getElementById("HiddenFieldGirdDirty").value = "false";
            Streamline.SmartClient.WebServices.ClientMedications.ClearMedicationRow();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ClearTable: function (tbl) {
        try {
            var table = document.getElementById(tbl);
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                ClientMedicationOrder.ClearRow(row, true, i);
            }
            setTimeout(function () {
                Streamline.SmartClient.WebServices.ClientMedications.ClearTemporaryDeletedRowsFlags(ClientMedicationOrder.onClearMedicationSucceeded, ClientMedicationOrder.onClearMedicationFailure);
            }, 5000);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onClearMedicationFailure: function (error, context) {
        fnHideParentDiv();
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        //else {
        //alert(error.get_message());
        //}
        return false;
    },
    onClearMedicationSucceeded: function (result, context, methodname) {
        try {
            if ($("[id$=HiddenFieldRedirectFrom]").val() == "FromQueuedOrderScreen") {
                if (!$("input[name='MedicationList1$']:checked").val()) {
                    $('input[name="MedicationList1$"]:radio:first').click();
                    $("[id$=HiddenFieldRedirectFrom]").val('');
                }
            }
        } catch (e) {
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    ClearRow: function (row, clearCombo, rowIndex) {  //#ka rolled over
        try {
            if (clearCombo) {
                row.cells[1].getElementsByTagName("select")[0].innerHTML = "";
                row.cells[1].getElementsByTagName("select")[0].value = -1;
            }
            else
                row.cells[1].getElementsByTagName("select")[0].value = -1;

            row.cells[3].getElementsByTagName("input")[0].value = "";
            if (clearCombo)
                row.cells[4].getElementsByTagName("select")[0].innerHTML = "";
            else
                row.cells[4].getElementsByTagName("select")[0].value = -1;
            if (clearCombo) {
                row.cells[5].getElementsByTagName("select")[0].innerHTML = "";
                row.cells[5].getElementsByTagName("select")[0].value = -1;
            }
            else
                row.cells[5].getElementsByTagName("select")[0].value = -1;

            row.cells[6].getElementsByTagName("input")[0].value = "";
            row.cells[8].getElementsByTagName("input")[0].value = "";
            ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
            row.cells[9].getElementsByTagName("input")[0].disabled = false;
            row.cells[10].getElementsByTagName("select")[0].value = -1;
            row.cells[11].getElementsByTagName("input")[0].value = "";
            row.cells[12].getElementsByTagName("input")[0].value = "";
            row.cells[13].getElementsByTagName("input")[0].value = "";
            row.cells[14].getElementsByTagName("input")[0].value = "";
            row.cells[15].getElementsByTagName("span")[0].value = 'undefined';
            row.cells[16].getElementsByTagName("input")[0].value = "";
            row.cells[17].getElementsByTagName("input")[0].value = "";
            row.cells[0].getElementsByTagName("img")[0].removeAttribute("MedicationId");
            row.cells[0].getElementsByTagName("img")[0].removeAttribute("MedicationInstructionId");
            row.cells[2].getElementsByTagName("img")[0].disabled = true;
            row.cells[2].getElementsByTagName("img")[0].removeAttribute("ExternalMedicationId");
            $("input[id$=HiddenFieldSelectedValue]").val("");
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    FillMedicationRow: function (tbl, HiddenMedicationNameId, HiddenExternalMedicationNameId, DropDownListDxPurpose, DropDownListPrescriber, TextBoxOrderDate, TextBoxSpecialInstructions, HiddenMedicationName, LabelErrorMessage, DivErrorMessage, ImageError, PanelMedicationList, HiddenRowIdentifier, LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, HiddenMedicationDAW, TextBoxComments, TextBoxDesiredOutcome, HiddenMedicationOffLabel, tableErrorMessage, tableGridErrorMessage, HiddenPermitChangesByOtherUsers, HiddenFieldOnPrescription, DropDownListCoverage, CheckBoxVerbalOrderReadBack) {
        try {
            var method = document.getElementById("txtButtonValue").value;
            fnShow();
            var context = new Object();
            context.Panel = PanelMedicationList;
            context.LabelErrorMessage = LabelErrorMessage;
            context.DivErrorMessage = DivErrorMessage;
            context.ImageError = ImageError;
            context.tableErrorMessage = tableErrorMessage;

            context.tableGridErrorMessage = tableGridErrorMessage;
            context.LabelGridErrorMessage = LabelGridErrorMessage;
            context.DivGridErrorMessage = DivGridErrorMessage;
            context.ImageGridError = ImageGridError;

            var objClientMedicationrow = new ClientMedicationOrder.ClientMedicationRow();
            var docDropDownPrescriber = document.getElementById(DropDownListPrescriber);

            //Added By PranayB 
            if (!($("select[id*=DropDownListDEANumber]").val())) {
                document.getElementById(context.ImageGridError).style.display = 'block';
                document.getElementById(context.ImageGridError).style.visibility = 'visible';
                document.getElementById(context.DivGridErrorMessage).style.display = 'block';
                document.getElementById(context.tableGridErrorMessage).style.display = 'block';
                document.getElementById(context.LabelGridErrorMessage).innerText = 'Please Select  Prescriber With DEA#.';
                fnHideParentDiv();
                return false;
            }

            objClientMedicationrow.MedicationNameId = document.getElementById(HiddenMedicationNameId).value;
            var externalMedicationNameId = document.getElementById(HiddenExternalMedicationNameId).value;
            if (externalMedicationNameId != '' && parseInt(externalMedicationNameId).toString() != "NaN") {
                objClientMedicationrow.ExternalMedicationNameId = externalMedicationNameId;
            }
            var docCheckBoxVerbalOrderReadBack = document.getElementById(CheckBoxVerbalOrderReadBack);
            if (docCheckBoxVerbalOrderReadBack.checked == true) {
                objClientMedicationrow.VerbalOrderReadBack = "Y";
            }
            objClientMedicationrow.StaffLicenseDegreeId = $("select[id*=DropDownListDEANumber]").val();

            var docDropDownDxPurpose = document.getElementById(DropDownListDxPurpose);
            if (docDropDownDxPurpose.selectedIndex != -1) {
                objClientMedicationrow.DrugPurpose = docDropDownDxPurpose.options[docDropDownDxPurpose.selectedIndex].innerText;
                objClientMedicationrow.DSMCode = docDropDownDxPurpose.options[docDropDownDxPurpose.selectedIndex].getAttribute('DSMCode');
                objClientMedicationrow.DxId = docDropDownDxPurpose.value;
            }
            objClientMedicationrow.PrescriberName = docDropDownPrescriber.options[docDropDownPrescriber.selectedIndex].innerText;
            $("input[id$=HiddenFieldPrescriberName]").val("");
            $("input[id$=HiddenFieldPrescriber]").val("");
            $("input[id$=HiddenFieldPrescriberName]").val(docDropDownPrescriber.options[docDropDownPrescriber.selectedIndex].innerText);
            $("input[id$=HiddenFieldPrescriber]").val(docDropDownPrescriber.value);
            if (docDropDownDxPurpose.selectedIndex != -1) {
                objClientMedicationrow.DSMNumber = docDropDownDxPurpose.options[docDropDownDxPurpose.selectedIndex].getAttribute('DSMNumber');
            }
            var docDropDownListCoverage = document.getElementById(DropDownListCoverage);
            if (docDropDownListCoverage.selectedIndex != -1) {
                objClientMedicationrow.PlanName = docDropDownListCoverage.options[docDropDownListCoverage.selectedIndex].innerText;
            }
            objClientMedicationrow.PrescriberId = docDropDownPrescriber.value;
            objClientMedicationrow.OrderDate = document.getElementById(TextBoxOrderDate).value;
            objClientMedicationrow.SpecialInstructions = document.getElementById(TextBoxSpecialInstructions).value;
            objClientMedicationrow.MedicationName = document.getElementById(HiddenMedicationName).value;
            objClientMedicationrow.DAW = document.getElementById(HiddenMedicationDAW).value;
            objClientMedicationrow.Comments = document.getElementById(TextBoxComments).value;
            objClientMedicationrow.DesiredOutcome = document.getElementById(TextBoxDesiredOutcome).value;
            objClientMedicationrow.OffLabel = document.getElementById(HiddenMedicationOffLabel).value;
            objClientMedicationrow.IncludeOnPrescription = document.getElementById(HiddenFieldOnPrescription).value;
            objClientMedicationrow.PermitChangesByOtherUsers = document.getElementById(HiddenPermitChangesByOtherUsers).value;
            if (document.getElementById(HiddenRowIdentifier).value != "")
                objClientMedicationrow.RowIdentifierCM = document.getElementById(HiddenRowIdentifier).value;
            var saveAsTemplate = $('#RadioButtonSaveTemplate').is(':checked');
            var overrideTemplate = $('#RadioButtonOverrideTemplate').is(':checked');
            var orderTemplateCurrentMedicationId = 1;
            var saveTemplateFlag;
            
            var arrayobjpushClientMedicationInstructionrow = new Array();
            var ExitLoop = false;
            var LabelErrorMessage = document.getElementById(LabelErrorMessage);
            var DivErrorMessage = document.getElementById(DivErrorMessage);
            var ImageError = document.getElementById(ImageError);
            var tableErrorMessage = document.getElementById(tableErrorMessage);

            var LabelGridErrorMessage = document.getElementById(LabelGridErrorMessage);
            var DivGridErrorMessage = document.getElementById(DivGridErrorMessage);
            var ImageGridError = document.getElementById(ImageGridError);
            var tableGridErrorMessage = document.getElementById(tableGridErrorMessage);
            var table = document.getElementById(tbl);
            var refillHolder = 0;
            var strengthHolder = 0;
            var categoryDrugCounter = 0;

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
            if (orderTemplateIsInProgress && table.rows.length > 0) {
                orderTemplateCurrentMedicationId = table.rows[0].cells[1].getElementsByTagName("select")[0].value;
            }
            if (orderTemplateIsInProgress && orderTemplateIsInProgressMedicationId == orderTemplateCurrentMedicationId) {
                saveTemplateFlag = 'Override';
            }

            orderTemplateIsInProgress = $('#RadioButtonSaveTemplate').is(':checked') || $('#RadioButtonOverrideTemplate').is(':checked');

            ManageOrderTemplate('none');

            if (orderTemplateIsInProgress && table.rows.length > 0) {
                orderTemplateIsInProgressMedicationId = table.rows[0].cells[1].getElementsByTagName("select")[0].value;
            }

            for (var i = 0; i < table.rows.length; i++) {
                var objClientMedicationInstructionrow = new ClientMedicationOrder.ClientMedicationInstructionRow();
                if (ExitLoop == false) {
                    var NextCnt = i;
                    var row = table.rows[i];
                    var Strength = row.cells[1].getElementsByTagName("select")[0].value;
                    var Quantity = row.cells[3].getElementsByTagName("input")[0].value;
                    var Unit = row.cells[4].getElementsByTagName("select")[0].value;
                    var Schedule = row.cells[5].getElementsByTagName("select")[0].value;
                    var StartDate = row.cells[6].getElementsByTagName("input")[0].value;
                    if (row.cells[8].getElementsByTagName("input")[0].value == "")
                        row.cells[8].getElementsByTagName("input")[0].value = 0;
                    var Days = row.cells[8].getElementsByTagName("input")[0].value;
                    if (row.cells[16].getElementsByTagName("input")[0].value == "Y") {
                        var pharmacyTextComboBox = document.getElementById("ComboBoxPharmacyDD_" + i);
                        if (pharmacyTextComboBox != null && pharmacyTextComboBox.value == "") {
                            pharmacyTextComboBox.value = "0";
                        }
                    }
                    var Pharma = document.getElementById("ComboBoxPharmacyDD_" + i).value;
                    if (row.cells[11].getElementsByTagName("input")[0].value == "")
                        row.cells[11].getElementsByTagName("input")[0].value = 0;
                    var Refills = row.cells[11].getElementsByTagName("input")[0].value;

                    if (row.cells[12].getElementsByTagName("input")[0].value == "")
                        row.cells[12].getElementsByTagName("input")[0].value = 0;
                    var Sample = row.cells[12].getElementsByTagName("input")[0].value;
                    if (row.cells[13].getElementsByTagName("input")[0].value == "")
                        row.cells[13].getElementsByTagName("input")[0].value = 0;
                    var Stock = row.cells[13].getElementsByTagName("input")[0].value;

                    var EndDate = row.cells[14].getElementsByTagName("input")[0].value;
                    if (row.cells[4].getElementsByTagName("select")[0].selectedIndex != '-1')
                        var Instruction = row.cells[1].getElementsByTagName("select")[0].options[row.cells[1].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[3].getElementsByTagName("input")[0].value + " " + row.cells[4].getElementsByTagName("select")[0].options[row.cells[4].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[5].getElementsByTagName("select")[0].options[row.cells[5].getElementsByTagName("select")[0].selectedIndex].innerText;

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
                            tableErrorMessage.style.display = 'none';
                            ImageError.style.visibility = 'hidden';
                            ImageError.style.display = 'none';
                            LabelErrorMessage.innerText = '';
                        }
                    }
                    if (!strengthHolder) {
                        strengthHolder = Strength;
                    }
                    if (strengthHolder == Strength) {
                        if (Refills > 0 && refillHolder && (Refills != refillHolder)) {
                            ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Number of Refills for instructions of the same strength must be the same.', tableGridErrorMessage);
                            fnHideParentDiv();
                            return false;
                        }
                    }
                    strengthHolder = Strength;
                    refillHolder = Refills;
                    if (Strength == '-1' || Strength == "") {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Please enter Strength.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                          
                        return false;
                    } else if (Quantity == '') {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Please enter Dose.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                           
                        return false;
                    } else if (Quantity <= 0) {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Dose should be greater than 0.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                            
                        return false;
                    }
                        //Code end over here
                    else if (Unit == '-1' || Unit == "") {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Please select Unit.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                            
                        return false;
                    } else if (Schedule == '-1' || Schedule == "") {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Please select Directions.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                            
                        return false;
                    } else if (StartDate == '') {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Please enter Rx start date.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                            
                        return false;
                    } else if (Days == '') {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Please enter Days.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                            
                        return false;

                    } 
                    else if ((Number.parseInvariant(Days) < 1) || (Number.parseInvariant(Days) > 365)) {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Days must be in the range 1 to 365 .', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                            
                        return false;
                    } else if (Pharma <= 0) {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Dispense Qty should be greater than 0.', tableGridErrorMessage);
                        fnHideParentDiv(); //By PranayB 08/28/2018                         
                        return false;

                    }


                    else if (EndDate == '') {
                    }

                    var Category = row.cells[15].getAttribute("MedicationCategory");
                    if (Category >= 2) {
                        checkCategory = Category;
                    }
                    if (Category == 2) {
                        if (Number.parseInvariant(Days) > 90) {
                            ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Maximum Days (90)  for Directions II drug exceeded.', tableGridErrorMessage);
                            fnHideParentDiv(); //By Pranay   Dec 16th 2016                  
                            return false;
                        }
                    }
                    //If Loggedin user is not a prescriber, Then should not be able to insert controlled drugs
                    //if (Category == 2 || Category == 3 || Category == 4 || Category == 5) {
                    //   $("input[id$=HiddenFieldTemp]").val("1");
                    //    var IsPrescriber = $("input[id$=IsPrescriber]").val();
                    //    if (IsPrescriber != 'Y') {
                    //        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'You are unauthorized to prescribe Control drugs.', tableGridErrorMessage);
                    //        fnHideParentDiv();
                    //        return false;
                    //    }
                    //}

                    if (Category == 2) {
                        categoryDrugCounter++;
                        if (row.cells[11].getElementsByTagName("input")[0].value > 2) {
                            ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Maximum additional scripts (2) for Directions II drug exceeded.', tableGridErrorMessage);
                            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                            
                            row.cells[11].getElementsByTagName("input")[0].value = "";
                            row.cells[11].getElementsByTagName("input")[0].focus();
                            return false;
                        }
                    }
                    if (Category == 3 || Category == 4 || Category == 5) {
                        categoryDrugCounter++;
                        if (row.cells[11].getElementsByTagName("input")[0].value > 5) {
                            ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Maximum refills exceeded for directions C2-C5 medication.', tableGridErrorMessage);
                            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
                            LabelGridErrorMessage.innerText = 'Maximum refills exceeded for directions C2-C5 medication.'; //Code Added by Loveena as Ref to Task#76 on 13 Nov 2008 to move Error Messages.
                            row.cells[11].getElementsByTagName("input")[0].value = "";
                            row.cells[11].getElementsByTagName("input")[0].focus();
                            return false;
                        }
                    }
                    var objDateOrder = ClientMedicationOrder.getDateObject(document.getElementById(TextBoxOrderDate).value, "/");
                    var ObjDateStartDate = ClientMedicationOrder.getDateObject(StartDate, "/");
                    if (objDateOrder > ObjDateStartDate) {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Start date in the list cannot be before order date.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                           
                        row.cells[11].getElementsByTagName("input")[0].value = "";
                        row.cells[11].getElementsByTagName("input")[0].focus();
                        return false;
                    }
                    //added By Pramod on 15 Apr 2008 to validate smaple
                    if (Sample < 0) {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Sample must be greater than or equal to zero.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
                        row.cells[11].getElementsByTagName("input")[0].value = "";
                        row.cells[11].getElementsByTagName("input")[0].focus();
                        return false;
                    }
                    if (Stock < 0) {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Stock must be greater than or equal to zero.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                            
                        row.cells[11].getElementsByTagName("input")[0].value = "";
                        row.cells[11].getElementsByTagName("input")[0].focus();
                        return false;
                    }
                    if (($('input[id*=HiddenFieldRedirectFrom]').val() == 'DashBoard') && ($('input[id*=txtButtonValue]').val() != 'APPROVEWITHCHANGESCHANGEORDER') && ($('input[id*=txtButtonValue]').val() != 'CHANGEAPPROVALORDER') && (($('input[id*=HiddenFieldClickedImage]').val() == 'ApprovedWithChanges') || ($('input[id*=HiddenFieldClickedImage]').val() == 'Approved'))) {
                        debugger;
                        if (Refills == '0' || Refills == '') {
                            ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Refills must be positive value between 1 and 99', tableGridErrorMessage);
                            fnHideParentDiv();
                            row.cells[11].getElementsByTagName("input")[0].value = "";
                            row.cells[11].getElementsByTagName("input")[0].focus();
                            return false;
                        }
                    }
                    //---Code Added by Pradeep as per task#3330 on 14 March2011 End Over here
                    if (Refills < 0) {
                        ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Refills must be greater than or equal to zero.', tableGridErrorMessage);
                        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                                                       
                        row.cells[11].getElementsByTagName("input")[0].value = "";
                        row.cells[11].getElementsByTagName("input")[0].focus();
                        return false;
                    }
                    flag = false;
                    var k = 0;
                    if (row.cells[16].getElementsByTagName("input")[0].value == "N") {
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
                        if (k == 0) {
                            if (document.getElementById("ComboBoxPharmacyDD_" + i).value == '') {
                                flag = true;
                            }
                        }
                        if (flag == true) {
                            ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Only one dispense quantity is allowed per strength.', tableGridErrorMessage);
                            fnHideParentDiv();
                            document.getElementById("ComboBoxPharmacyDD_" + i).value = "";
                            $("#ComboBoxPharmacyDD_" + i).focus();
                            return false;
                        }
                    } else if (row.cells[16].getElementsByTagName("input")[0].value == "Y") {
                        if (Pharma < 0 || Pharma.toString() == "") {
                            ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Sample/Stock cannot be more than the order dose.', tableGridErrorMessage);
                            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
                            row.cells[11].getElementsByTagName("input")[0].value = "";
                            row.cells[11].getElementsByTagName("input")[0].focus();
                            return false;
                        }
                        if (Pharma + Sample + Stock <= 0) {
                            ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Medication must have Dispense Qty+Sample+Stock greater than 0.', tableGridErrorMessage);
                            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
                            row.cells[11].getElementsByTagName("input")[0].value = "";
                            row.cells[11].getElementsByTagName("input")[0].focus();
                            return false;
                        }
                    }
                    if (row.cells[14].getElementsByTagName("input")[0].value != "") {
                        if (!ClientMedicationOrder.validateDate(row.cells[14].getElementsByTagName("input")[0])) {
                            ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Invalid EndDate.', tableGridErrorMessage);
                            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008                            
                            row.cells[14].getElementsByTagName("input")[0].focus();
                            return false;
                        }
                    }
                    objClientMedicationInstructionrow.StrengthId = row.cells[1].getElementsByTagName("select")[0].value;
                    objClientMedicationInstructionrow.Quantity = row.cells[3].getElementsByTagName("input")[0].value;
                    objClientMedicationInstructionrow.Unit = row.cells[4].getElementsByTagName("select")[0].value;
                    objClientMedicationInstructionrow.Schedule = row.cells[5].getElementsByTagName("select")[0].value;
                    objClientMedicationInstructionrow.StartDate = row.cells[6].getElementsByTagName("input")[0].value;
                    objClientMedicationInstructionrow.Days = row.cells[8].getElementsByTagName("input")[0].value;
                    objClientMedicationInstructionrow.PotencyUnitCode = row.cells[10].getElementsByTagName("select")[0].value;
                    if (objClientMedicationInstructionrow.PotencyUnitCode == -1) {
                        objClientMedicationInstructionrow.PotencyUnitCode = "";
                    }
                    if (row.cells[16].getElementsByTagName("input")[0].value == "Y") {
                        objClientMedicationInstructionrow.Pharmacy = document.getElementById("ComboBoxPharmacyDD_" + i).value;
                    } else if (row.cells[16].getElementsByTagName("input")[0].value == "N") {
                        if (document.getElementById("ComboBoxPharmacyDD_" + i).value == "") {
                            if (document.getElementById("HiddenFieldPharmatextStatus").value = 'UpdateByOriginalValue') {
                                objClientMedicationInstructionrow.PharmaText = document.getElementById("HiddenFieldOriginalPharmaText").value;
                            } else {
                                objClientMedicationInstructionrow.PharmaText = document.getElementById("ComboBoxPharmacyDD_" + i).value;
                            }
                        } else {
                            if (document.getElementById("HiddenFieldPharmatextStatus").value == 'UpdateByOriginalValue') {
                                objClientMedicationInstructionrow.PharmaText = document.getElementById("HiddenFieldOriginalPharmaText").value;
                            } else {
                                objClientMedicationInstructionrow.PharmaText = document.getElementById("ComboBoxPharmacyDD_" + i).value;
                                objClientMedicationInstructionrow.Pharmacy = document.getElementById("ComboBoxPharmacyDD_" + i).value;
                            }
                        }
                    }
                    objClientMedicationInstructionrow.AutoCalcallow = row.cells[16].getElementsByTagName("input")[0].value;
                    objClientMedicationInstructionrow.Sample = row.cells[12].getElementsByTagName("input")[0].value;
                    objClientMedicationInstructionrow.Stock = row.cells[13].getElementsByTagName("input")[0].value;
                    if (($('input[id*=HiddenFieldRedirectFrom]').val() == 'DashBoard') &&
                        ($('input[id*=txtButtonValue]').val() != 'CHANGEAPPROVALORDER') &&
                        ($('input[id*=txtButtonValue]').val() != 'APPROVEWITHCHANGESCHANGEORDER') &&
                        ($('input[id*=HiddenFieldClickedImage]').val() == 'Approved' || $('input[id*=HiddenFieldClickedImage]').val() == 'ApprovedWithChanges')) {
                        debugger;
                        objClientMedicationInstructionrow.Refills = row.cells[11].getElementsByTagName("input")[0].value - 1;
                    } else {
                        objClientMedicationInstructionrow.Refills = row.cells[11].getElementsByTagName("input")[0].value;
                    }
                    objClientMedicationInstructionrow.EndDate = row.cells[14].getElementsByTagName("input")[0].value;
                    objClientMedicationrow.DrugCategory = Category;
                    if ((row.cells[15].getElementsByTagName("span")[0].value != "") && (row.cells[15].getElementsByTagName("span")[0].value != "undefined"))
                        objClientMedicationInstructionrow.RowIdentifierCMI = row.cells[15].getElementsByTagName("span")[0].value;

                    if ((row.cells[17].getElementsByTagName("input")[0].value != "") && (row.cells[17].getElementsByTagName("input")[0].value != "undefined"))
                        objClientMedicationInstructionrow.StrengthRowIdentifier = row.cells[17].getElementsByTagName("input")[0].value;

                    objClientMedicationInstructionrow.NoOfDaysOfWeek = row.cells[18].getElementsByTagName("input")[0].value;
                    objClientMedicationInstructionrow.Instruction = row.cells[1].getElementsByTagName("select")[0].options[row.cells[1].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[3].getElementsByTagName("input")[0].value + " " + row.cells[4].getElementsByTagName("select")[0].options[row.cells[4].getElementsByTagName("select")[0].selectedIndex].innerText + " " + row.cells[5].getElementsByTagName("select")[0].options[row.cells[5].getElementsByTagName("select")[0].selectedIndex].innerText;
                    arrayobjpushClientMedicationInstructionrow.push(objClientMedicationInstructionrow);

                }
            }

            //AHN SGL 128 - Removed the validation for controlled medications - Nandita S on Feb 28,2018
            //if (categoryDrugCounter > 1) {
            //    ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Scheduled medication cannot have more than 1 instruction on an order. Separate order must be completed.', tableGridErrorMessage);
            //    fnHideParentDiv();
            //    return false;
            //}

            document.getElementById("HiddenFieldPharmatextStatus").value = '';
            document.getElementById("HiddenFieldOriginalPharmaText").value = '';
            Streamline.SmartClient.WebServices.ClientMedications.SaveMedicationRow(objClientMedicationrow, arrayobjpushClientMedicationInstructionrow, method, saveTemplateFlag, ClientMedicationOrder.onSaveMedicationSucceeded, ClientMedicationOrder.onSaveMedicationFailure, context);
            if (saveAsTemplate)
                $('#RadioButtonSaveTemplate').attr('checked', false);
            if (overrideTemplate)
                $('#RadioButtonOverrideTemplate').attr('checked', false);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onSaveMedicationFailure: function (error, context) {
        document.getElementById(context.ImageGridError).style.display = 'block';
        document.getElementById(context.ImageGridError).style.visibility = 'visible';
        document.getElementById(context.DivGridErrorMessage).style.display = 'block';
        document.getElementById(context.tableGridErrorMessage).style.display = 'block';
        document.getElementById(context.LabelGridErrorMessage).innerText = error.get_message();
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        //else {
        //alert(error.get_message());
        //}
        return false;
    },
    onSaveMedicationSucceeded: function (result, context, methodname) {
        try {
            if (result.length > 0) {
                if (result.indexOf("String was not recognized as a valid DateTime") >= 0 && result.indexOf("OrderDate Column") >= 0) {
                    document.getElementById(context.tableErrorMessage).style.display = 'block';
                    document.getElementById(context.ImageError).style.display = 'block';
                    document.getElementById(context.ImageError).style.visibility = 'visible';
                    document.getElementById(context.DivErrorMessage).style.display = 'block';
                    document.getElementById(context.LabelErrorMessage).innerText = 'Please enter valid Order Date.';
                    return false;
                }
                if (result.indexOf("String was not recognized as a valid DateTime") >= 0 && result.indexOf("StartDate Column") >= 0) {
                    document.getElementById(context.tableErrorMessage).style.display = 'block';
                    document.getElementById(context.ImageError).style.display = 'block';
                    document.getElementById(context.ImageError).style.visibility = 'visible';
                    document.getElementById(context.DivErrorMessage).style.display = 'block';
                    document.getElementById(context.LabelErrorMessage).innerText = 'Please enter valid Start Date.';
                    return false;
                }
                if (result.indexOf("You are not allowed to change the prescription") >= 0) {
                    document.getElementById(context.tableErrorMessage).style.display = 'block';
                    document.getElementById(context.ImageError).style.display = 'block';
                    document.getElementById(context.ImageError).style.visibility = 'visible';
                    document.getElementById(context.DivErrorMessage).style.display = 'block';
                    document.getElementById(context.LabelErrorMessage).innerText = 'You are not allowed to change the prescription';
                    return false;
                }
                if (result.indexOf("Session TimeOut") >= 0) {
                    redirectToLoginPage();
                    return false;
                }
                document.getElementById(context.tableGridErrorMessage).style.display = 'block';
                document.getElementById(context.ImageGridError).style.display = 'block';
                document.getElementById(context.ImageGridError).style.visibility = 'visible';
                document.getElementById(context.DivGridErrorMessage).style.display = 'block';
                document.getElementById(context.LabelGridErrorMessage).innerText = result;
                return false;
            }
            Clear_Click(false);
            document.getElementById('buttonInsert').disabled = false;
        } catch (e) {
            document.getElementById('buttonInsert').disabled = false;
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    GetMedicationList: function (Panel, SortBy) {
        try {
            if (Panel === undefined) {
                Panel = PanelMedicationList;
            }
            if (SortBy === undefined) {
                SortBy = '';
            }
            var method = document.getElementById("txtButtonValue").value;
            wRequest = new Sys.Net.WebRequest();
            wRequest.set_url("AjaxScript.aspx?FunctionId=GetMedicationList&par0=" + SortBy + "&par1=" + method + "&container=ClientMedicationOrder");
            wRequest.add_completed(ClientMedicationOrder.OnFillMedicationControlCompleted);
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
    SetDocumentDirty: function () {
        try {
            document.getElementById("HiddenFieldOrderPageDirty").value = "true";
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ShowHideError: function (LabelErrorMessage, DivErrorMessage, ImageError, error, tableErrorMessage) {
        try {
            var context = new Object();
            context.LabelErrorMessage = LabelErrorMessage;
            context.DivErrorMessage = DivErrorMessage;
            context.ImageError = ImageError;
            context.tableErrorMessage = tableErrorMessage;
            var LabelErrorMessage = document.getElementById(LabelErrorMessage);
            var DivErrorMessage = document.getElementById(DivErrorMessage);
            var ImageError = document.getElementById(ImageError);
            var tableErrorMessage = document.getElementById(tableErrorMessage);
            tableErrorMessage.style.display = 'block';
            DivErrorMessage.style.display = 'block';
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = error;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ShowHideGridErrors: function (LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, error, tableGridErrorMessage) {
        try {
            tableGridErrorMessage.style.display = 'block';
            DivGridErrorMessage.style.display = 'block';
            ImageGridError.style.display = 'block';
            ImageGridError.style.visibility = 'visible';
            LabelGridErrorMessage.innerText = error;
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
            }
            //else {
            //if (executor.get_timedOut())
            //alert("Timed Out");
            //else if (executor.get_aborted())
            //alert("Aborted");
            //}
        } catch (e) {
        }
    },
    DeleteRow: function (sender, e) {
		var vDisabledEl = $(this).attr("disabled");
        if (vDisabledEl == "disabled" || vDisabledEl == true || vDisabledEl == "true") {
            try {
                if (e.stopImmediatePropagation) {
                    e.stopImmediatePropagation();
                }
                else if (e.stopPropagation) {
                    e.stopPropagation();
                }
            } catch (ex) { }
            return false;
        }
        if (sender.target.getAttribute("MedicationId") != null) {
            ClientMedicationOrder.DeleteFromTable(sender);
        } else {
            ClientMedicationOrder.ClearRow(sender.target.parentElement.parentElement, false, sender.target.parentElement.parentElement.rowIndex);
        }
    },
    DeleteFromTable: function (object) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008 
            var MedicationId = object.target.getAttribute("MedicationId");
            var MedicationInstructionId = object.target.getAttribute("MedicationInstructionId");
            var DrugScrengthRowId = object.target.getAttribute("DrugScrengthRowId");
            Streamline.SmartClient.WebServices.ClientMedications.DeleteClientMedicationInstructions(MedicationId, MedicationInstructionId, DrugScrengthRowId, ClientMedicationOrder.onDeleteFromTableSucceeded, ClientMedicationOrder.onFailure, object);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onDeleteFromTableSucceeded: function (result, context, methodname) {
        try {
            if (result == true) {
                ClientMedicationOrder.PotencyUnitCodeUpdate($("[id$=tableMedicationOrder]")[0], -1, "DeleteRow");
                ClientMedicationOrder.ClearRow(context.target.parentElement.parentElement, false, context.target.parentElement.parentElement.rowIndex);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    onDrugInteractionClick: function (sender, e) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            if (!sender.target.id || sender.target.tagName == "DIV") {
                fnHideParentDiv();
                return false;
            }
            if ((sender.target.id == "ImgCross") || (sender.target.id == "ImgCross1")) {
                ClientMedicationOrder.closeDescDiv(sender.target.id);
                return;
            }
            Streamline.SmartClient.WebServices.ClientMedications.GetDrugInteractionText(e.InteractionId, ClientMedicationOrder.onDrugInteractionSucceeded, ClientMedicationOrder.onFailure, sender);
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
                TableHTML.push("  <img id='ImgCross' class='PopUpTitleBar' onclick='ClientMedicationOrder.closeDescDiv(ImgCross)' src='App_Themes/Includes/Images/cross.jpg'");
                TableHTML.push("  title='Close' alt='Close' /></td></tr>");
                TableHTML.push("</table> <table width='600px' border='0' cellpadding='0' cellspacing='0'>");
                TableHTML.push("<tbody>");
                TableHTML.push(" <tr> <td class='Label' > <div id='InteractionDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow-Y:auto ;overflow-X:none; height:370px;'></div>  </td></tr></tbody></table> ");

                div1.innerHTML = TableHTML.join("");
                NoSeverityRows = true;
                div1.style.height = 400;
                div1.style.width = 600;
            } else {
                var TableHTML = [];
                TableHTML.push("<table class='PopUpTitleBar' width='400px'>");
                TableHTML.push("  <tr> <td width='95%' id='topborder' class='TitleBarText' align='left'>");
                TableHTML.push("  Interacting Medications Details</td> <td align='right'> ");
                TableHTML.push("  <img id='ImgCross' class='PopUpTitleBar' onclick='ClientMedicationOrder.closeDescDiv(ImgCross)' src='App_Themes/Includes/Images/cross.jpg'");
                TableHTML.push("  title='Close' alt='Close' /></td></tr>");
                TableHTML.push("</table> <table width='400px'>");
                TableHTML.push("<tbody>");
                TableHTML.push(" <tr> <td class='DescriptionRow'>Severity</td> <td class='DescriptionRow'>Description</td><td></td><td></td></tr>");
                for (i = 0; i < result.rows.length; i++) {
                    TableHTML.push(" <tr> <td> <span class='linkStyle'  onclick='ClientMedicationOrder.onShowSeverity(this," + result.rows[i]["Severity"] + ")'>" + result.rows[i]["Severity"] + "</span> </td> <td style='text-align:left;'><span class='linkStyle' style='text-align:left' onclick='ClientMedicationOrder.onDrugInteractionDescriptionClick(this," + result.rows[i]["MonoGraphId"] + "," + result.rows[i]["InteractionId"] + ")'>" + result.rows[i]["Description"] + "</span></td><td></td><td></td></tr>");
                }
                TableHTML.push(" </tbody></table> ");
                div1.innerHTML = TableHTML.join("");
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
                ClientMedicationOrder.DisplayMonographDescription(result.rows[0]["Description"], false);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    DisplayMonographDescription: function (varDataToBeDisplayed, varToBeDisplayedInMonographContainer) {
        if (varToBeDisplayedInMonographContainer)
            document.getElementById("MonoGraphDescriptions").innerHTML = varDataToBeDisplayed;
        else
            document.getElementById("InteractionDescriptions").innerHTML = varDataToBeDisplayed;
    },
    onDrugInteractionDescriptionClick: function (context, MonographId, InteractionId) //Added By Chandan on 19th Nov 2008 A new Parameter "InteractionId" 
    {
        try {
            fnShow();
            Streamline.SmartClient.WebServices.ClientMedications.getMonographDescription(MonographId, InteractionId, ClientMedicationOrder.onDrugInteractionDescriptionSucceeded, ClientMedicationOrder.onFailure, context);
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

                // document.appendChild(div);
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
            TableHTML.push("  <img id='ImgCross1' class='PopUpTitleBar' onclick='ClientMedicationOrder.closeDescDiv(ImgCross1)' src='App_Themes/Includes/Images/cross.jpg'");
            TableHTML.push("  title='Close' alt='Close' /></td></tr>");
            TableHTML.push("</table> <table width='600px' border='0' cellpadding='0' cellspacing='0'>");
            TableHTML.push("<tbody>");
            TableHTML.push(" <tr><td class='Label'>  <div id='MonoGraphDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow-Y:auto ;overflow-X:none; height:370px;'></div>  </td></tr></tbody></table> ");
            document.getElementById("DivMonoGraphContainer").innerHTML = TableHTML.join("");

            divM.style.width = 600;
            divM.style.height = 400;
            divF.style.height = divM.style.height;
            divF.style.width = divM.style.width;
            divF.style.top = divM.style.top;
            divF.style.left = divM.style.left;

            document.getElementById("DivMonoGraphContainer").style.display = "block";
            document.getElementById("IframeMonoGraphContainer").style.display = "block";
            ClientMedicationOrder.DisplayMonographDescription(result.rows[0]["Description"], true);
            return false;
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
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
            TableHTML.push("  <img id='ImgCross2' onclick='ClientMedicationOrder.closeDescDiv(ImgCross2)' src='App_Themes/Includes/Images/cross.jpg'");
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
            divS.innerHTML = TableHTML.join("");

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
        } catch (e) {
        } finally {
            fnHideParentDiv(); //By Vikas Vyas 
        }
    },
    AcknowledgeInteractionSucceeded: function (result, context, methodname) {
        try {
            if (result == true) {
                var tableErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_tableErrorMessage');
                LabelErrorMessage.innerText = "";
                ImageError.style.visibility = 'hidden';
                tableErrorMessage.style.display = 'none';
                ClientMedicationOrder.GetMedicationList(PanelMedicationList);
            }
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
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
            if (_Row.cells[11].getElementsByTagName("input")[0].value != '') {
                if (!CommonFunctions.IsNumericValue(_Row.cells[11].getElementsByTagName("input")[0].value)) {
                    _Row.cells[11].getElementsByTagName("input")[0].value = '';
                    return false;
                }
            }
            objRow.MedicationId = _Row.cells[1].getElementsByTagName("select")[0];
            var rowIndex = _Row.rowIndex;
            objRow.rowIndex = rowIndex;
            context.rowIndex = rowIndex;
            context.SelectedValue = "";
            var table = $("[id$=tableMedicationOrder]")[0];
            objRow.Schedule = _Row.cells[5].getElementsByTagName("select")[0];
            objRow.Quantity = _Row.cells[3].getElementsByTagName("input")[0];
            var dosage = 0;
            if (objRow.Quantity.value != "")
                dosage = parseFloat(objRow.Quantity.value);
            var schedule = objRow.Schedule.value;
            objRow.Units = _Row.cells[4].getElementsByTagName("select")[0];
            objRow.StartDate = _Row.cells[6].getElementsByTagName("input")[0];
            objRow.Days = _Row.cells[8].getElementsByTagName("input")[0];
            objRow.Pharmacy = _Row.cells[9].getElementsByTagName("input")[0];
            objRow.Sample = _Row.cells[12].getElementsByTagName("input")[0];
            objRow.Stock = _Row.cells[13].getElementsByTagName("input")[0];
            objRow.Refills = _Row.cells[11].getElementsByTagName("input")[0];
            objRow.EndDate = _Row.cells[14].getElementsByTagName("input")[0];

            var CallingObjectId;

            if (e.id == null) {
                CallingObjectId = sender.get_id();
            } else {
                CallingObjectId = e.id;
            }

            if (CallingObjectId.indexOf("TextBoxStartDate") > 0 || CallingObjectId.indexOf("TextBoxRefills") > 0 || CallingObjectId.indexOf("TextBoxDays") > 0) {
                if (((Number.parseInvariant(objRow.Days.value) < 1) || (Number.parseInvariant(objRow.Days.value) > 365)) == false)
                    ClientMedicationOrder.CalculateEndDate(objRow.StartDate.id, objRow.Days.id, objRow.Refills.id, objRow.EndDate.id);
            }

            if (CallingObjectId.indexOf("TextBoxQuantity") > 0 || CallingObjectId.indexOf("DropDownListSchedule") > 0 || CallingObjectId.indexOf("TextBoxDays") > 0)
                if (((Number.parseInvariant(objRow.Days.value) < 1) || (Number.parseInvariant(objRow.Days.value) > 365)) == false)
                    if (_Row.cells[16].getElementsByTagName("input")[0].value == "Y") {
                        ClientMedicationOrder.CalculatePharmacy(objRow);
                        $("input[id$=HiddenFieldSelectedValue]").val("");
                    } else if ((_Row.cells[16].getElementsByTagName("input")[0].value == "N") && objRow.MedicationId.value > 0 && objRow.Quantity.value > 0 && objRow.Schedule.value > 0 && objRow.Days.value > 0 && objRow.Units.value > 0) {
                        if (document.getElementById("ComboBoxPharmacyDD_" + rowIndex) != null) {
                            if (document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value != undefined && document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value != "")
                                context.SelectedValue = document.getElementById("ComboBoxPharmacyDD_" + rowIndex).value;
                            $("input[id$=HiddenFieldSelectedValue]").val(context.SelectedValue);
                        }
                        for (j = 0; j < table.rows.length; j++) {
                            var newRow = table.rows[j];
                            if (rowIndex != j) {
                                if (_Row.cells[1].getElementsByTagName("select")[0].value == newRow.cells[1].getElementsByTagName("select")[0].value) {
                                    if (newRow.cells[3].getElementsByTagName("input")[0].value > 0)
                                        dosage = dosage + parseFloat(newRow.cells[3].getElementsByTagName("input")[0].value);
                                    schedule = schedule + "," + newRow.cells[5].getElementsByTagName("select")[0].value;
                                }
                            }
                        }

                        if ($('input[id*=HiddenFieldRedirectFrom]').val() != 'DashBoard')//The following if(only check condition) condition is written by Pradeep as per task#3285
                        {
                            ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                            Streamline.SmartClient.WebServices.ClientMedications.CalculateDispenseQuantity(objRow.MedicationId.value, dosage, schedule, objRow.Days.value, ClientMedicationOrder.onDispenseQuantitySucceeded, ClientMedicationOrder.onFailure, context);
                        }
                    } else {
                        if ($('input[id*=HiddenFieldRedirectFrom]').val() != 'DashBoard') {
                            ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + rowIndex, "#ComboBoxPharmacyDDList_" + rowIndex);
                        }
                    }
            document.getElementById('buttonInsert').disabled = false;
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
            ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + context.rowIndex, "#ComboBoxPharmacyDDList_" + context.rowIndex);
            if (result == null || result.rows == null || !result.rows) {
                return;
            }
            ClientMedicationOrder.PopulatePharmacyTextList($("#ComboBoxPharmacyDDList_" + context.rowIndex), result);
            document.getElementById("ComboBoxPharmacyDD_" + context.rowIndex).value = $("input[id$=HiddenFieldSelectedValue]").val();
        } catch (ex) {
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
            ClientMedicationOrder.GetMedicationList(PanelMedicationList, ColumnName);
        } catch (e) {

        }
    },
    getDateObject: function (dateString, dateSeperator) {
        var curValue = dateString;
        var sepChar = dateSeperator;
        var curPos = 0;
        var cDate, cMonth, cYear;

        curPos = dateString.indexOf(sepChar);
        cMonth = dateString.substring(0, curPos) - 1;
        endPos = dateString.indexOf(sepChar, curPos + 1);
        cDate = dateString.substring(curPos + 1, endPos);
        curPos = endPos;
        endPos = curPos + 5;
        cYear = curValue.substring(curPos + 1, endPos);
        dtObject = new Date(cYear, cMonth, cDate);
        return dtObject;
    },
    validateDate: function (fld) {
        try {
            var RegExPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
            var errorMessage = 'Please enter valid date as month, day, and four digit year.\nYou may use a slash, hyphen or period to separate the values.\nThe date must be a real date. 2-30-2000 would not be accepted.\nFormay mm/dd/yyyy.';
            if ((fld.value.match(RegExPattern)) && (fld.value != '')) {
                return true;
            } else {
                return false;
            }
        } catch (err) {
            return false;
        }
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
            var txtStartDate = 'Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxStartDate';
            Streamline.SmartClient.WebServices.ClientMedications.CreateControls(TableRowIndex, txtButtonValue, txtStartDate, ClientMedicationOrder.AddMedicationStepsSuccess, ClientMedicationOrder.onFailure, _context);
            document.getElementById('HiddenFieldRowIndex').value = parseInt(document.getElementById('HiddenFieldRowIndex').value) + 2;
            if (result != null) {
                if (parseInt(document.getElementById('HiddenFieldRowIndex').value) < result.tables[1].rows.length)
                    ClientMedicationOrder.AddMedicationSteps(fillValue, result);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    AddMedicationStepsSuccess: function (result, context) {
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
            ClientMedicationOrder.FillMedicationRowsOnRadioClick(context.Result);
        } else {
            var RowCount = parseInt(document.getElementById('HiddenFieldRowIndex').value) - 2;
            var MedicationNameId = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationNameId').value;
            var MedicationName = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationName').value;
            if (MedicationNameId != null && MedicationNameId != "") {
                var table = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_tableMedicationOrder');
                for (var i = RowCount; i < table.rows.length; i++) {
                    var row = table.rows[i];
                    var Strength = row.cells[1].getElementsByTagName("select")[0];
                    var Schedule = row.cells[5].getElementsByTagName("select")[0];
                    var ddlPotencyUnitCode = row.cells[10].getElementsByTagName("select")[0];
                    ClientMedicationOrder.FillPotencyUnitCodes(MedicationNameId, ddlPotencyUnitCode, null);
                    ClientMedicationOrder.FillStrength(MedicationNameId, Strength, null, null);
                    ClientMedicationOrder.FillScheduled(Schedule, null);
                }
            }
        }
    },
    FillMedicationRowsOnRadioClick: function (result) {
        var someRowsRefill = false;
        var table = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_tableMedicationOrder');
        for (var i = 0; i < table.rows.length; i++) {
            var row = table.rows[i];
            row.cells[1].getElementsByTagName("select")[0].disabled = false;
            //row.cells[2].getElementsByTagName("img")[0].disabled = false;
            row.cells[3].getElementsByTagName("input")[0].disabled = false;
            row.cells[4].getElementsByTagName("select")[0].disabled = false;
            row.cells[5].getElementsByTagName("select")[0].disabled = false;
            row.cells[6].getElementsByTagName("input")[0].disabled = false;
            row.cells[7].getElementsByTagName("img")[0].disabled = false;
            row.cells[8].getElementsByTagName("input")[0].disabled = false;
            row.cells[9].getElementsByTagName("input")[0].disabled = false;
            row.cells[10].getElementsByTagName("select")[0].disabled = false;
            row.cells[11].getElementsByTagName("input")[0].disabled = false;
            row.cells[12].getElementsByTagName("input")[0].disabled = false;
            row.cells[13].getElementsByTagName("input")[0].disabled = false;
            row.cells[14].getElementsByTagName("input")[0].disabled = false;
        }
        document.getElementById("HiddenFieldOrderPageDirty").value = "false";
        var HiddenMedicationId = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationId');
        var HiddenTitrateMode = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenTitrateMode');
        var Medicationmethod = document.getElementById("txtButtonValue").value;
        var HiddenFieldRedirectFrom = $('input[id*=HiddenFieldRedirectFrom]').val();
        var HiddenFieldClickedImage = $('input[id*=HiddenFieldClickedImage]').val();
        if (HiddenFieldClickedImage == 'Approved' || HiddenFieldClickedImage == 'ApprovedWithChanges') {
            document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_Refills').innerText = 'Total Dispenses Approved';
        }
        var TitrationFlag;
        if (result.tables[0].rows.length > 0) {
            if (result.tables[0].rows[0]["TitrationType"] != null) {
                document.getElementById('ButtonTitrate').disabled = false;
                document.getElementById('buttonAddRows').disabled = true;
                document.getElementById('buttonInsert').disabled = true;
                document.getElementById('buttonClear').disabled = true;
                TitrationFlag = 'Y';
            } else {
                document.getElementById('ButtonTitrate').disabled = true;
                document.getElementById('buttonAddRows').disabled = false;
                document.getElementById('buttonInsert').disabled = false;
                document.getElementById('buttonClear').disabled = false;
                TitrationFlag = 'N';
            }
            HiddenMedicationId.value = result.tables[0].rows[0]["ClientMedicationId"];
            HiddenTitrateMode.value = "Modify";
            document.getElementById("HiddenFieldOriginalPharmaText").value = '';
            document.getElementById("HiddenFieldPharmatextStatus").value = '';
        }
        if (TitrationFlag == 'Y' && Medicationmethod != "Refill") {
            OpenTitratePage();
        }
        else {
            var pucList = [];
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                if (i < result.tables[1].rows.length) {
                    var Unit = new Object();
                    Unit.DropDown = row.cells[4].getElementsByTagName("select")[0];
                    Unit.SelectedValue = result.tables[1].rows[i]["Unit"];
                    row.cells[0].getElementsByTagName("img")[0].setAttribute("MedicationId", result.tables[1].rows[i]["ClientMedicationId"]);
                    row.cells[0].getElementsByTagName("img")[0].setAttribute("MedicationInstructionId", result.tables[1].rows[i]["ClientMedicationInstructionId"]);
                    if (result.tables.length > 4) {
                        if (result.tables[3].rows.length > i)
                            row.cells[0].getElementsByTagName("img")[0].setAttribute("DrugScrengthRowId", result.tables[3].rows[i]["RowIdentifier"]);
                    }
                    row.cells[2].getElementsByTagName("img")[0].setAttribute("MedicationId", result.tables[1].rows[i]["StrengthId"]);

                    if (result.tables[1].rows[i]["Quantity"] != null) {
                        row.cells[3].getElementsByTagName("input")[0].value = result.tables[1].rows[i]["Quantity"];
                    } else {
                        row.cells[3].getElementsByTagName("input")[0].value = "";
                    }

                    if (result.tables[1].rows[i]["StartDate"] != null) {
                        row.cells[6].getElementsByTagName("input")[0].value = result.tables[1].rows[i]["StartDate2"];
                        document.getElementById("HiddenFieldOldStartDate").value = result.tables[1].rows[0]["StartDate2"]; //.format("MM/dd/yyyy");

                    } else
                        row.cells[6].getElementsByTagName("input")[0].value = "";

                    if (result.tables[1].rows[i]["EndDate"] != null) {
                        if (Medicationmethod == "REFILL" || Medicationmethod == "Refill") {
                            row.cells[14].getElementsByTagName("input")[0].value = result.tables[1].rows[i]["EndDate"].format('MM/dd/yyyy');
                        } else
                            row.cells[14].getElementsByTagName("input")[0].value = result.tables[1].rows[i]["EndDate"].format("MM/dd/yyyy");
                    } else
                        row.cells[14].getElementsByTagName("input")[0].value = "";

                    if (result.tables[2] != null) {
                        if (result.tables[2].rows[i]["Days"] != null) {
                            row.cells[8].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Days"];
                        }
                        row.cells[16].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["AutoCalcallow"];
                        if (result.tables[2].rows[i]["AutoCalcallow"] == "Y") {
                            if (result.tables[2].rows[i]["Pharmacy"] != null) {
                                document.getElementById("ComboBoxPharmacyDD_" + i).value = result.tables[2].rows[i]["Pharmacy"];
                            }

                        } else if (result.tables[2].rows[i]["AutoCalcallow"] == "N") {
                            for (j = 0; j < table.rows.length; j++) {
                                if (j < result.tables[1].rows.length) {
                                    if (result.tables[1].rows[i]["StrengthId"] == result.tables[1].rows[j]["StrengthId"]) {
                                        if (result.tables[2].rows[i]["PharmacyText"] != null && result.tables[2].rows[i]["PharmacyText"] != '') {
                                            if ((result.tables[0].rows[0]["DrugCategory"] == '3' || result.tables[0].rows[0]["DrugCategory"] == '4' || result.tables[0].rows[0]["DrugCategory"] == '5') && HiddenFieldRedirectFrom == 'DashBoard')//Made changes as per task#3274
                                            {
                                                document.getElementById("ComboBoxPharmacyDD_" + i).value = result.tables[2].rows[i]["PharmacyText"];
                                                document.getElementById("HiddenFieldOriginalPharmaText").value = result.tables[2].rows[i]["PharmacyText"];
                                                document.getElementById("HiddenFieldPharmatextStatus").value = 'UpdateByOriginalValue';
                                            } else {
                                                document.getElementById("ComboBoxPharmacyDD_" + i).value = result.tables[2].rows[i]["PharmacyText"];
                                            }
                                            if (Medicationmethod != 'New Order' && Medicationmethod != 'Change')//Added By Pradeep as per task#3301
                                            {
                                                document.getElementById("ComboBoxPharmacyDD_" + i).disabled = true;
                                            }
                                        } else {
                                            if ((result.tables[0].rows[0]["DrugCategory"] == '3' || result.tables[0].rows[0]["DrugCategory"] == '4' || result.tables[0].rows[0]["DrugCategory"] == '5') && HiddenFieldRedirectFrom == 'DashBoard')//Made changes as per task#3274
                                            {
                                                document.getElementById("ComboBoxPharmacyDD_" + i).value = result.tables[2].rows[i]["PharmacyText"];
                                                document.getElementById("HiddenFieldOriginalPharmaText").value = result.tables[2].rows[i]["PharmacyText"];
                                                document.getElementById("HiddenFieldPharmatextStatus").value = 'UpdateByOriginalValue';
                                            } else {
                                                if (HiddenFieldRedirectFrom == 'DashBoard') {
                                                    document.getElementById("ComboBoxPharmacyDD_" + i).value = result.tables[2].rows[i]["PharmacyText"];
                                                }
                                            }
                                            document.getElementById("ComboBoxPharmacyDD_" + i).disabled = true;
                                        }
                                        if (i > j) {
                                            if (Medicationmethod != 'New Order' && Medicationmethod != 'Change')//Added By Pradeep as per task#3301
                                            {
                                                document.getElementById("ComboBoxPharmacyDD_" + i).disabled = true;
                                            }
                                        }
                                    }
                                }
                            }

                        }
                        if (result.tables[2].rows[i]["Sample"] != null) {
                            row.cells[12].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Sample"];
                        }
                        if (result.tables[2].rows[i]["Stock"] != null) {
                            row.cells[13].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Stock"];
                        }
                        if (result.tables[2].rows[i]["Refills"] != null) {
                            if (HiddenFieldRedirectFrom == 'DashBoard' && (HiddenFieldClickedImage == 'Approved' || HiddenFieldClickedImage == 'ApprovedWithChanges')) {
                                row.cells[11].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Refills"] + 1;//Added as per task#3330
                                if ((HiddenFieldClickedImage == 'Approved')) {
                                    if ($("input[id*=HiddenFieldRefillSpecialCase]").val().toUpperCase() == "TRUE" && Medicationmethod.toUpperCase() != 'New Order') {
                                        row.cells[11].getElementsByTagName("input")[0].disabled = false;
                                    } else {
                                        row.cells[11].getElementsByTagName("input")[0].disabled = true;
                                    }
                                    document.getElementById("ComboBoxPharmacyDD_" + i).disabled = true;
                                } else { //This else part is written as per task#3330
                                    row.cells[11].getElementsByTagName("input")[0].disabled = false;
                                }
                            } else {
                                row.cells[11].getElementsByTagName("input")[0].value = result.tables[2].rows[i]["Refills"];
                                row.cells[11].getElementsByTagName("input")[0].disabled = false;
                            }
                        } else {
                            row.cells[11].getElementsByTagName("input")[0].disabled = false;
                        }
                    }
                    row.cells[15].getElementsByTagName("span")[0].value = result.tables[1].rows[i]["RowIdentifier"];
                    if (result.tables.length > 5) {
                        if (result.tables[3].rows.length > i)
                            row.cells[17].getElementsByTagName("input")[0].value = result.tables[3].rows[i]["RowIdentifier"];
                    }
                    if (result.tables[result.tables.length - 1].rows.length > i) {
                        if (result.tables[result.tables.length - 1].rows[i]["DaysOfWeek"] != null) {
                            row.cells[18].getElementsByTagName("input")[0].value = result.tables[result.tables.length - 1].rows[i]["DaysOfWeek"];
                        }
                    }
                    ClientMedicationOrder.FillPotencyUnitCodes(result.tables[0].rows[0]["MedicationNameId"], row.cells[10].getElementsByTagName("select")[0], result.tables[1].rows[i]["PotencyUnitCode"]);
                    ClientMedicationOrder.FillStrength(result.tables[0].rows[0]["MedicationNameId"], row.cells[1].getElementsByTagName("select")[0], result.tables[1].rows[i]["StrengthId"], Unit);
                    ClientMedicationOrder.FillScheduled(row.cells[5].getElementsByTagName("select")[0], result.tables[1].rows[i]["Schedule"]);
                    var medId = result.tables[1].rows[i]["ClientMedicationId"];
                    var notFound = true;
                    for (var i2 = 0; i2 < pucList.length; i2++) {
                        if (pucList[i2].MedicationId == medId) {
                            row.cells[10].getElementsByTagName("select")[0].disabled = true;
                            notFound = false;
                            break;
                        }
                    }
                    if (notFound) {
                        row.cells[10].getElementsByTagName("select")[0].disabled = false;
                        pucList.push({ "MedicationId": medId });
                    }
                } else {
                    ClientMedicationOrder.FillPotencyUnitCodes(result.tables[0].rows[0]["MedicationNameId"], row.cells[10].getElementsByTagName("select")[0], null);
                    ClientMedicationOrder.FillStrength(result.tables[0].rows[0]["MedicationNameId"], row.cells[1].getElementsByTagName("select")[0], null, null);
                    ClientMedicationOrder.FillScheduled(row.cells[5].getElementsByTagName("select")[0], null);
                }

                var method = document.getElementById("txtButtonValue").value;
                if ((TitrationFlag == "Y" && (method.toUpperCase() == "CHANGE" || method.toUpperCase() == "ADJUST")) || (TitrationFlag == "Y" && method == "")) {
                    document.getElementById('ButtonTitrate').disabled = false;
                    row.cells[1].getElementsByTagName("select")[0].disabled = true;
                    row.cells[3].getElementsByTagName("input")[0].disabled = true;
                    row.cells[4].getElementsByTagName("select")[0].disabled = true;
                    row.cells[5].getElementsByTagName("select")[0].disabled = true;
                    row.cells[6].getElementsByTagName("input")[0].disabled = true;
                    row.cells[7].getElementsByTagName("img")[0].disabled = true;
                    row.cells[8].getElementsByTagName("input")[0].disabled = true;
                    row.cells[9].getElementsByTagName("input")[0].disabled = true;
                    row.cells[10].getElementsByTagName("select")[0].disabled = true;
                    row.cells[11].getElementsByTagName("input")[0].disabled = true;
                    row.cells[12].getElementsByTagName("input")[0].disabled = true;
                    row.cells[13].getElementsByTagName("input")[0].disabled = true;
                    row.cells[14].getElementsByTagName("input")[0].disabled = true;
                } else if (method.toUpperCase() == "REFILL" && result.tables[1].rows[i] != undefined && result.tables[1].rows[i]["ClientMedicationInstructionId"] > 0) {
                    document.getElementById('ButtonTitrate').disabled = false;
                    row.cells[0].getElementsByTagName("img")[0].disabled = false;
                    row.cells[1].getElementsByTagName("select")[0].disabled = false;
                    row.cells[3].getElementsByTagName("input")[0].disabled = false;
                    row.cells[4].getElementsByTagName("select")[0].disabled = false;
                    row.cells[5].getElementsByTagName("select")[0].disabled = false;
                    row.cells[6].getElementsByTagName("input")[0].disabled = false;
                    row.cells[7].getElementsByTagName("img")[0].disabled = false;
                    row.cells[8].getElementsByTagName("input")[0].disabled = false;
                    row.cells[9].getElementsByTagName("input")[0].disabled = false;
                    row.cells[10].getElementsByTagName("select")[0].disabled = false;
                    if (HiddenFieldRedirectFrom == 'DashBoard' && HiddenFieldClickedImage == 'Approved') {
                        row.cells[12].getElementsByTagName("input")[0].disabled = true;
                        row.cells[13].getElementsByTagName("input")[0].disabled = true;
                    } else {
                        row.cells[12].getElementsByTagName("input")[0].disabled = false;
                        row.cells[13].getElementsByTagName("input")[0].disabled = false;
                    }
                    row.cells[14].getElementsByTagName("input")[0].disabled = false;
                    someRowsRefill = true;
                } else {
                    if ((method.toUpperCase() == "CHANGE" || method.toUpperCase() == "REFILL") && (result.tables[0].rows[0]["ClientMedicationId"] > 0)) {
                        row.cells[0].getElementsByTagName("img")[0].setAttribute("disabled", "True");
                        row.cells[0].getElementsByTagName("img")[0].setAttribute("title", "Can't delete previously ordered medication.");
                    }
                    else {
                        row.cells[0].getElementsByTagName("img")[0].disabled = false;
                    }                    
                    row.cells[1].getElementsByTagName("select")[0].disabled = false;
                    row.cells[3].getElementsByTagName("input")[0].disabled = false;
                    row.cells[4].getElementsByTagName("select")[0].disabled = false;
                    row.cells[5].getElementsByTagName("select")[0].disabled = false;
                    row.cells[6].getElementsByTagName("input")[0].disabled = false;
                    row.cells[7].getElementsByTagName("img")[0].disabled = false;
                    row.cells[8].getElementsByTagName("input")[0].disabled = false;
                    row.cells[11].getElementsByTagName("input")[0].disabled = false;
                    row.cells[12].getElementsByTagName("input")[0].disabled = false;
                    row.cells[13].getElementsByTagName("input")[0].disabled = false;
                    row.cells[14].getElementsByTagName("input")[0].disabled = false;
                }
            }
        }
        if (someRowsRefill == true) { //}Medicationmethod.toUpperCase() == "REFILL") {
            $("#ComboBoxDrugDDDiv").attr('disabled', true);
            document.getElementById('buttonAddRows').disabled = false;
        }
    },
    GetSystemReports: function (stringReportName) {
        try {
            fnShow();
            for (i = 0; i < document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListDxPurpose').options.length; i++) {
                if (document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListDxPurpose').options[i].selected) {
                    var DiagnosisCode = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListDxPurpose').options[i].getAttribute("DSMCode");
                }
            }
            Streamline.SmartClient.WebServices.ClientMedications.GetSystemReportsNewOrder(stringReportName, DiagnosisCode, ClientMedicationOrder.onSuccessfullGetSystemReportsNewOrder, ClientMedicationOrder.onFailure);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    GetSystemReportsMedicationName: function (stringReportName) {
        try {
            fnShow();
            if (document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationNameId').value != "") {
                var MedicationNameId = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenMedicationNameId').value;
            }
            Streamline.SmartClient.WebServices.ClientMedications.GetSystemReportsMedication(stringReportName, MedicationNameId, ClientMedicationOrder.onSuccessfullGetSystemReportsNewOrder, ClientMedicationOrder.onFailure);
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
    ShowTitrationPage: function (HiddenFieldClientMedicationID) {
        var LabelErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_LabelErrorMessage');
        var DivErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DivErrorMessage');
        var ImageError = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_ImageError');
        var tableErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_tableErrorMessage');
        try {
            if (document.getElementById("HiddenFieldGirdDirty").value == "true") {
                tableErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                DivErrorMessage.style.display = 'block';
                LabelErrorMessage.innerText = 'You must save or clear the current medication before entering a titration.';
                return false;
            }
            var ClientMedicationID = document.getElementById(HiddenFieldClientMedicationID).value;
            if ($('[id$=HiddenFieldShowDosages]').val() === 'Y')
                $('[id$=HiddenMedicationName]').val($('[id$=ComboBoxDrugDD]').val());
            Streamline.SmartClient.WebServices.ClientMedications.PopulateRowforTitrationList(ClientMedicationID, ClientMedicationOrder.onTitrationSuccess, ClientMedicationOrder.onFailure);
        } catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    onTitrationSuccess: function (result) {
        try {
            var LabelErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_LabelErrorMessage');
            var DivErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DivErrorMessage');
            var ImageError = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_ImageError');
            var tableErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_tableErrorMessage');
            fnShow();
            if (result == 0) {
                tableErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                DivErrorMessage.style.display = 'block';
                LabelErrorMessage.innerText = 'You are not allowed to change the prescription.';
                return false;
            }
            var $divSearch = $("#DivSearch1");
            $("#topborder1", $divSearch).text("Titration");
            var $iFrameSearch = $('#iFrame1', $divSearch);
            $iFrameSearch.attr('src', 'ClientMedicationTitration.aspx');
            $iFrameSearch.css({ 'width': '850px', 'height': '520px' });
            var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
            left = left > 0 ? left : 10;
            var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
            top = top > 0 ? top : 10;
            $divSearch.css({ 'top': top, 'left': left });
            $divSearch.draggable();
            $divSearch.css('display', 'block');
            fnHideParentDiv();

            return false;
        } catch (ex) {

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
    RefreshMedicationList: function (DAW, SpecialInstruction) {
        try {
            document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxSpecialInstructions').value = SpecialInstruction;
            if (DAW == 'Y')
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxDispense').checked = true;
            else
                document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxDispense').checked = false;
            ClientMedicationOrder.GetMedicationList('Control_ASP.usercontrols_clientmedicationorder_ascx_PanelMedicationListInformation');
            document.getElementById('HiddenFieldOrderPageDirty').value = 'false';
            Clear_Click(false);
        } catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    CheckExistingMedication: function (MedicationNameId) {
        try {
            Streamline.SmartClient.WebServices.CommonService.CheckExistingMedication(MedicationNameId, ClientMedicationOrder.onCheckExistingMedicationSuccess, ClientMedicationOrder.onFailure);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    onCheckExistingMedicationSuccess: function (result) {
        try {
            if (result != "") {
                parent.window.Clear_Click();
                parent.window.DisplayErrorMessage(result);
            }
        } catch (ex) {
        }
    },
    ShowMessage: function () {
        var labelErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_LabelErrorMessage');
        var DivErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_DivErrorMessage');
        var ImageError = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_ImageError');
        var tableErrorMessage = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_tableErrorMessage');
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
        if (labelErrorMessage != null) {
            labelErrorMessage.innerText = "At least one medication must be ordered to prescribe.";
        }
    },
    FillDrugDropDown: function (MedicationNameId, MedicationName) {
        var context = new Object();
        context.MedicationName = MedicationName;
        context.SelectedValue = MedicationNameId;
        context.MedicationNameId = MedicationNameId;
        Streamline.SmartClient.WebServices.ClientMedications.FillDrugDropdown(MedicationNameId, ClientMedicationOrder.onSuccessFillDrugDropDown, ClientMedicationOrder.onFailure, context);
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
                        ClientMedicationOrder.onSelectedDrugComboList(eventItem, cboDrugList[0], false);
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
    onSuccessFillDosageInfoText: function (result, context) {
        var staffId = $('[id$=HiddenFieldLoggedInStaffId]').val();
        try {
            if (result != null && result.rows != null) {
                $('[id$=TextBoxDrugInfo]').val(result.rows[0]["DosageInfo"]);
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onFailureFillDosageInfoText: function () {
    },
    onFailureLoadDrugOrderTemplate: function () {
    },
    LoadDrugOrderTemplateForSelectedMedication: function (row, medicationNameId, selectedMedicationId, rowId) {
        var context = {};
        context.row = row;
        context.medicationNameId = medicationNameId;
        context.medicationId = selectedMedicationId;
        context.rowId = rowId;
        var staffId = $('[id$=HiddenFieldLoggedInStaffId]').val();
        Streamline.SmartClient.WebServices.ClientMedications.LoadDrugOrderTemplate(selectedMedicationId, staffId, ClientMedicationOrder.onSuccessLoadDrugOrderTemplate, ClientMedicationOrder.onFailureLoadDrugOrderTemplate, context);
    },
    onSuccessLoadDrugOrderTemplate: function (result, context) {
        try {
            if (result != null && result.rows != null) {
                var Strength = context.row.cells[1].getElementsByTagName("select")[0];
                var Schedule = context.row.cells[5].getElementsByTagName("select")[0];
                var ddlPotencyUnitCode = context.row.cells[10].getElementsByTagName("select")[0];
                ClientMedicationOrder.FillPotencyUnitCodes(context.medicationNameId, ddlPotencyUnitCode, result.rows[0]["PotencyUnitCode"]);
                var Unit = new Object();
                Unit.DropDown = context.row.cells[4].getElementsByTagName("select")[0];
                Unit.SelectedValue = result.rows[0]["Unit"];
                ClientMedicationOrder.FillStrength(context.medicationNameId, Strength, context.medicationId, Unit, false);
                ClientMedicationOrder.FillScheduled(Schedule, result.rows[0]["Schedule"]);
                context.row.cells[3].getElementsByTagName("input")[0].value = result.rows[0]["Quantity"];
                var _startDate = new Date();
                context.row.cells[6].getElementsByTagName("input")[0].value = _startDate.format("MM/dd/yyyy");
                context.row.cells[8].getElementsByTagName("input")[0].value = result.rows[0]["Days"];
                context.row.cells[11].getElementsByTagName("input")[0].value = result.rows[0]["Refills"];
                context.row.cells[16].getElementsByTagName("input")[0].value = result.rows[0]["AutoCalculate"];
                ClientMedicationOrder.ManipulateRowValues(null, context.row.cells[8].getElementsByTagName("input")[0]);
                if (result.rows[0]["DispenseQuantityText"] != "") {
                    document.getElementById("ComboBoxPharmacyDD_" + context.rowId).value = result.rows[0]["DispenseQuantityText"];
                } else if (result.rows[0]["DispenseQuantity"] != 0) {
                    document.getElementById("ComboBoxPharmacyDD_" + context.rowId).value = result.rows[0]["DispenseQuantity"];
                }
                $('[id$=TextBoxComments]').val(result.rows[0]["Comment"]);
                if (result.rows[0]["IncludeOnPrescription"] == 'Y') {
                    $('[id$=CheckboxIncludeOnPrescription]').attr('checked', true);
                } else {
                    $('[id$=CheckboxIncludeOnPrescription]').attr('checked', false);
                }
                ManageOrderTemplate('override');
            } else {
                var ddlPotencyUnitCode = context.row.cells[10].getElementsByTagName("select")[0];
                ClientMedicationOrder.FillPotencyUnitCodes(context.medicationNameId, ddlPotencyUnitCode, null);
                var Unit = new Object();
                Unit.DropDown = context.row.cells[4].getElementsByTagName("select")[0];
                var Strength = context.row.cells[1].getElementsByTagName("select")[0];
                ClientMedicationOrder.FillStrength(context.medicationNameId, Strength, context.medicationId, Unit, true);
                var Schedule = context.row.cells[5].getElementsByTagName("select")[0];
                ClientMedicationOrder.FillScheduled(Schedule, null);
                var _startDate = new Date();
                context.row.cells[6].getElementsByTagName("input")[0].value = _startDate.format("MM/dd/yyyy");
                ClientMedicationOrder.ClearPharmacyComboList("", "#ComboBoxPharmacyDDList_" + context.rowId);
                ManageOrderTemplate('save');
            }
        } catch (ex) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    },
    GetDrugInfo: function (MedicationNameId, ClientDOB) {
        try {
            Streamline.SmartClient.WebServices.ClientMedications.FillDosageInfoText(MedicationNameId, ClientDOB, ClientMedicationOrder.onSuccessFillDosageInfoText, ClientMedicationOrder.onFailureFillDosageInfoText);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    FillPrinter: function (ddlPrinter) {
        try {
            var context = ddlPrinter;
            var locationId = 0;
            if ($("select[id$=DropDownListLocations]")[0].value != "")
                locationId = parseInt($("select[id$=DropDownListLocations]")[0].value);
            Streamline.SmartClient.WebServices.ClientMedications.PrinterDeviceLocationsCombo(locationId, ClientMedicationOrder.onPrinterSucceeded, ClientMedicationOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onPrinterSucceeded: function (result, context) {
        try {
            context.innerHTML = "";
            if (result == null || result.rows == null || !result.rows) {
                context.options[context.length] = new Option("<Manual Selection>", "-1", false, false);
                return;
            }
            context.options[context.length] = new Option("<Manual Selection>", "-1", false, false);
            for (var i = 0; i < result.rows.length; i++) {
                optionItem = new Option(result.rows[i]["DeviceLabel"], result.rows[i]["PrinterDeviceLocationId"], false, false);
                optionItem.setAttribute("DeviceLabel", result.rows[i]["DeviceLabel"]);
                optionItem.setAttribute("PrinterDeviceLocationId", result.rows[i]["PrinterDeviceLocationId"]);
                context.options[context.length] = optionItem;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    FillDEANumber: function (ddlDEANumber) {
        try {
            var context = ddlDEANumber;
            Streamline.SmartClient.WebServices.ClientMedications.FillDEANumberCombo($("select[id$=DropDownListPrescriber]").val(), ClientMedicationOrder.onFillDEANumberComboSucceeded, ClientMedicationOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onFillDEANumberComboSucceeded: function (result, context) {
        try {
            context.innerHTML = "";
            for (var i = 0; i < result.First.rows.length; i++) {

                optionItem = new Option(result.First.rows[i]["DEANumber"], result.First.rows[i]["StaffLicenseDegreeId"], false, false);
                optionItem.setAttribute("DEANumber", result.First.rows[i]["DEANumber"]);
                optionItem.setAttribute("StaffLicenseDegreeId", result.First.rows[i]["StaffLicenseDegreeId"]);
                optionItem.setAttribute("DEAState", result.First.rows[i]["StateFIPS"]);
                context.options[context.length] = optionItem;
            }
            $("input[id$=HiddenFieldDEANumber]")[0].value = $("select[id$=DropDownListDEANumber]").val();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv();
        }
    },
    FillChartcopyPrinter: function (ddlPrinter) {
        try {
            var context = $("select[id$=DropDownListChartCopyPrinter]")[0];
            var locationId = 0;
            if ($("select[id$=DropDownListLocations]")[0].value != "")
                locationId = parseInt($("select[id$=DropDownListLocations]")[0].value);
            Streamline.SmartClient.WebServices.ClientMedications.ChartCopyPrinterDeviceLocationsCombo(locationId, ClientMedicationOrder.onChartCopyPrinterSucceeded, ClientMedicationOrder.onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onChartCopyPrinterSucceeded: function (result, context) {
        try {
            context.innerHTML = "";
            if (result == null || result.rows == null || !result.rows) {
                context.options[context.length] = new Option("--Select Printer--", "-1", false, false);
                return;
            }
            context.options[context.length] = new Option("--Select Printer--", "-1", false, false);
            for (var i = 0; i < result.rows.length; i++) {
                optionItem = new Option(result.rows[i]["DeviceLabel"], result.rows[i]["PrinterDeviceLocationId"], false, false);
                optionItem.setAttribute("DeviceLabel", result.rows[i]["DeviceLabel"]);
                optionItem.setAttribute("PrinterDeviceLocationId", result.rows[i]["PrinterDeviceLocationId"]);
                context.options[context.length] = optionItem;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    },
    ShowValidationDialogue: function (ValidationMessage) {
        try {
            //var popupWindow = null;
            //  window.open('YesNo.aspx?CalledFrom=OrderPage' + '^' + ValidationMessage, 'YesNo', 'menubar : no;status : no;dialogHeight:75px;dialogWidth=340px;resizable:no;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
            window.open('YesNo.aspx?CalledFrom=OrderPage' + '^' + ValidationMessage, 'YesNo', 'location=no,width=423px,height=178px,top=200px,left=300px,resizable = no,scrollbars=no');
            //  window.onfocus();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ShowValidationMessage: function (ValidationMessage) {
        try {
            window.open('YesNo.aspx?CalledFrom=OrderPage' + '^' + ValidationMessage, 'YesNo', 'location=no,width=423px,height=178px,top=200px,left=300px,resizable = no,scrollbars=no');
            //window.open('YesNo.aspx?CalledFrom=OrderPage' + '^' + ValidationMessage, 'YesNo', 'menubar : no;status : no;dialogHeight:75px;dialogWidth=340px;resizable:no;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    ChangeOrderPageCommentText: function (LabelCommentText, CheckboxIncludeOnPrescription, CommentTextOnCheckBoxUnCheck, CommentTextOnCheckBoxCheck) {
        try {
            var CheckboxIncludeOnPrescriptionId = document.getElementById(CheckboxIncludeOnPrescription);
            var LabelCommentTextId = document.getElementById(LabelCommentText);
            if (CheckboxIncludeOnPrescriptionId.checked) {
                if (LabelCommentTextId != null && LabelCommentTextId != 'undefined') {
                    LabelCommentTextId.innerText = CommentTextOnCheckBoxCheck;
                }

                // open the Acknowledge Pop up for the Staff whose 'EnableRxPopUpAcknowledgement' column is set to 'Y' this column is set to the staff who does not follow the use of the “Include on Prescription” correctly
                if ($("[id*=HiddenFieldEnableRxPopUpAcknowledgement]").length > 0) {
                    if ($("[id*=HiddenFieldEnableRxPopUpAcknowledgement]").val().toLowerCase() == "y") {
                        var mes = 'I acknowledge that the comment entered meets SureScripts requirements and does not include any part of the drug name, strength, dose, quantity or effective date.';
                        var Title = 'SmartCare'
                        window.showModalDialog('YesNo.aspx?CalledFrom=OrderPage' + '^' + mes + '^' + Title, 'YesNo', 'menubar : no;status : no;dialogHeight:423px;dialogWidth=178px;resizable:no;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
                    }
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
    CheckPharmacyUnit: function (RowIndex) {
        var comboboxValue = document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value;
        var AutoCalculationAllowed = $("[id*=HiddenFieldAutoCalcAllowed" + RowIndex + "]").val();
        if (AutoCalculationAllowed.toUpperCase() != 'N') {
            if (comboboxValue != null && comboboxValue != 'undefined' && comboboxValue != '' && (typeof comboboxValue !== 'number')) {
                if (comboboxValue.length > 10) {
                    document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                } else if (isNaN(comboboxValue)) {
                    document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                } else {
                    if (comboboxValue.indexOf(".") > -1) {
                        if (comboboxValue.length - (comboboxValue.indexOf(".") + 1) > NumberofDigitsAfterDecimal) {
                            document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                        } else if (comboboxValue.indexOf(".") > NumberofDigitsBeforeDecimal) {
                            document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                        }
                    } else if (comboboxValue.length > NumberofDigitsBeforeDecimal) {
                        document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                    }
                }
            }
        } else if (comboboxValue) {
            if (!isNaN(comboboxValue)) {
                if (comboboxValue.length > 10) {
                    document.getElementById("ComboBoxPharmacyDD_" + RowIndex).value = "";
                }
            }
        }
    },
    FormularyCheck: function (sender) {
        if (sender != null) {
            window.frames["iFrame1"].document.body.innerHTML = "<div><b>Loading....</b></div>";
            var MedicationId = sender.getAttribute("MedicationId");
            var PrescriberId = $("select[id$=DropDownListPrescriber]").val();
            if (parseInt(MedicationId).toString() != "NaN" && parseInt(PrescriberId).toString() != "NaN") {
                var DivSearch = parent.document.getElementById('DivSearch1');
                DivSearch.style.display = 'block';
                DivSearch.style.left = 200;
                DivSearch.style.top = 100;
                DivSearch.style.height = '300px';
                var iFrameSearch = parent.document.getElementById('iFrame1');
                iFrameSearch.src = 'ClientMedicationFormulary.aspx?MedicationId=' + MedicationId + '&PrescriberId=' + PrescriberId;
                iFrameSearch.style.positions = 'relative';
                iFrameSearch.style.left = '5px';
                iFrameSearch.style.width = '400px';
                iFrameSearch.style.height = '300px';
                iFrameSearch.style.top = '1px';
                iFrameSearch.style.display = 'block';
                iFrameSearch.style.scrolling = "auto";
                return;
            }
        }
    },
    CheckUncheckFaxToPharmaciesRadioButton: function (DropDownListPharmacies, RadioFaxToPharmacies, RadioPrint) {
        try {
            var dropDownListPharmacies = document.getElementById(DropDownListPharmacies);
            var radioFaxToPharmacies = document.getElementById(RadioFaxToPharmacies);
            var radioPrint = document.getElementById(RadioPrint);
            var selectedIndex = dropDownListPharmacies.selectedIndex;
            if (selectedIndex == 0 || selectedIndex == -1) {
                radioFaxToPharmacies.checked = false;
                radioPrint.checked = true;
            } else {
                radioFaxToPharmacies.checked = true;
                radioPrint.checked = false;
                //document.getElementById('ButtonOk').disabled = false;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
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
            ClientMedicationOrder.onSelectedDrugComboList(eventItem, $list[0], false);
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
            SetId(medicationNameId, medicationName, '', externalMedicationNameId, '');
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
            ClientMedicationOrder.onSelectedDrugComboList(eventItem, $list[0], false);
        } else {
            $obj.attr('opid', '');
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
        var $obj = $(object);
        var pharmacyText = $obj.val().toLowerCase();
        var $p = $("p", $list).filter(function (i) {
            return this.innerHTML.toLowerCase() == medName;
        });
        if ($p.length > 0) {
            var eventItem = { target: $p[0] };
            ClientMedicationOrder.onSelectedPharmacyComboList(eventItem, $list[0]);
        }
        ClientMedicationOrder.SetDocumentDirty();
    },
    onKeyDownPharmacyComboList: function (event, object) {
        if (event.keyCode == 9) {
            var $list = $(object);
            if ($list.is(':visible')) {
                $list.hide();
            }
        } else if (event.keyCode == 40) {
            ClientMedicationOrder.onClickPharmacyComboList('#' + event.srcElement.id, object);
        }
    },
    onBlurPharmacyComboList:function(event,object)
    {
        event.value = Math.ceil(event.value);
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
    },
    //---
    GetFormularyInformation: function (ExternalMedicationNameId, ExternalMedicationId, onSuccessCallBack) {
        var CoverageReqId = $("select[id$=DropDownListCoverage]").val();
        Streamline.SmartClient.WebServices.ClientMedications.GetFormularyInformation(ExternalMedicationNameId, ExternalMedicationId, CoverageReqId, onSuccessCallBack, ClientMedicationOrder.onFailure);
    },
    onSuccessFormularyInformation: function (result) {
        if (result.length > 0) {
            var $td = $("<td></td>").html(result);
            $("#MedicationOrderFormulary").html($td[0].outerHTML);
            HeadingTabClick('#MedicationOrderFormulary', '#HeaderItem_MedicationOrderFormulary');
        } else {
            $("#MedicationOrderFormulary").html("<td>Formulary Status Unknown</td>");
        }
    },
    GetChangeMedicationOrderList: function (SureScriptChangeRequestId) {
        //debugger;
        //var CoverageReqId = $("select[id$=DropDownListCoverage]").val();
        debugger;
        Streamline.SmartClient.WebServices.ClientMedications.GetChangeMedicationOrderList(SureScriptChangeRequestId, ClientMedicationOrder.onSuccessChangeMedicationOrderList, ClientMedicationOrder.onFailure);
    },
    onSuccessChangeMedicationOrderList: function (result) {
       // debugger;
        if (result.length > 0) {
            debugger;
            var $td = $("<td></td>").html(result);
            $("#MedicationOrderChangeList").html($td[0].outerHTML);
            HeadingTabClick('#MedicationOrderChangeList', '#HeaderItem_MedicationOrderChangeList');
        } else {
            $("#MedicationOrderChangeList").html("<td>Formulary Status Unknown</td>");
        }
    }
    ,
    GetClientEducationNDC: function (ExternalMedicationNameId, onSuccessCallBack) {
        Streamline.SmartClient.WebServices.ClientMedications.GetClientEducationNDC(ExternalMedicationNameId, onSuccessCallBack, ClientMedicationOrder.onFailure);
    },
    onSuccessClientEducation: function (result) {
        if (result.length > 0) {
            $('#ImgEducationStrengths').attr('preferredNDC', result);
        } else {
            $('#ImgEducationStrengths').removeAttr('preferredNDC');
        }
    },
    FormularyCheck: function (sender) {
        if (sender != null) {
            var ExternalMedicationId = sender.getAttribute("ExternalMedicationId");
            if (parseInt(ExternalMedicationId).toString() != "NaN") {
                var ExternalMedicationNameId = document.getElementById('ComboBoxDrugDD').getAttribute("opid");
                ClientMedicationOrder.GetFormularyInformation(ExternalMedicationNameId, ExternalMedicationId, ClientMedicationOrder.onSuccessFormularyInformationPopup);
            }
            //else {
            //alert('Formulary does not have a valid id');
            //}
        }
    },
    onSuccessFormularyInformationPopup: function (result) {
        var x = result;
        if (result.length > 0) {
            var $divSearch = $("#DivSearch1");
            $("#topborder1", $divSearch).text("Formulary");
            var $iFrameSearch = $('#iFrame1', $divSearch);
            $iFrameSearch.css({ 'width': '600px', 'height': '400px' });
            $iFrameSearch.attr('scrolling', 'yes');
            var iFrameDoc = $iFrameSearch[0].contentDocument || $iFrameSearch.contentWindow.document;
            iFrameDoc.open();
            iFrameDoc.write(result);
            iFrameDoc.close();
            var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
            left = left > 0 ? left : 10;
            var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
            top = top > 0 ? top : 10;
            $divSearch.css({ 'top': top, 'left': left });
            $divSearch.draggable();
            $divSearch.css('display', 'block');
        }
    },

    GetPhrasesList: function (Panel, DropDownListScreenPhraseCategory) {
        //debugger;
        try {
            var DropdownKeyPhraseCategory = document.getElementById(DropDownListScreenPhraseCategory);
            var MyPhraseCategoryId = DropdownKeyPhraseCategory.value;
            var MyPhrasCategoryText = DropdownKeyPhraseCategory.options[DropdownKeyPhraseCategory.selectedIndex].innerText;

            wRequest = new Sys.Net.WebRequest();
            wRequest.set_url("AjaxScript.aspx?FunctionId=GetPhrasesList&SelectedCategoryId=" + MyPhraseCategoryId + "&SelectedCategoryName=" + MyPhrasCategoryText);

            wRequest.add_completed(ClientMedicationOrder.OnFillKeyPhrasesCompleted);
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
    OnFillKeyPhrasesCompleted: function (executor, eventArgs) {
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
                   }
                }
            }

        } catch (e) {
        }
    },

    FillKeyPhraseRow: function (tbl, HiddenKeyPhraseId, TextBoxPhraseText, DropDownListKeyPhraseCategory, HiddenFavorite, LabelErrorMessage, DivErrorMessage, ImageError, PanelPhrasesListInformation, LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, tableErrorMessage, tableGridErrorMessage) {
        try {
            var context = new Object();
            context.Panel = PanelPhrasesList;
            context.LabelErrorMessage = LabelErrorMessage;
            context.DivErrorMessage = DivErrorMessage;
            context.ImageError = ImageError;
            context.tableErrorMessage = tableErrorMessage;
            context.HiddenKeyPhraseId = HiddenKeyPhraseId;
            context.tableGridErrorMessage = tableGridErrorMessage;
            context.LabelGridErrorMessage = LabelGridErrorMessage;
            context.DivGridErrorMessage = DivGridErrorMessage;
            context.ImageGridError = ImageGridError;

            var objClientKeyPhraseRow = new ClientMedicationOrder.ClientKeyPhraseRow();
            var docDropDownPhraseCategory = document.getElementById(DropDownListKeyPhraseCategory);

            objClientKeyPhraseRow.KeyPhraseCategory = docDropDownPhraseCategory.value;
            objClientKeyPhraseRow.KeyPhraseCategoryName = docDropDownPhraseCategory.options[docDropDownPhraseCategory.selectedIndex].innerText;
            objClientKeyPhraseRow.HiddenKeyPhraseId = document.getElementById(HiddenKeyPhraseId).value;

            objClientKeyPhraseRow.PhraseText = document.getElementById(TextBoxPhraseText).value;
            if (objClientKeyPhraseRow.KeyPhraseId == '')
                objClientKeyPhraseRow.KeyPhraseId = 0;

            objClientKeyPhraseRow.Favorite = document.getElementById(HiddenFavorite).value;
            var LabelErrorMessage = document.getElementById(LabelErrorMessage);
            var DivErrorMessage = document.getElementById(DivErrorMessage);
            var ImageError = document.getElementById(ImageError);
            var tableErrorMessage = document.getElementById(tableErrorMessage);
            var LabelGridErrorMessage = document.getElementById(LabelGridErrorMessage);
            var DivGridErrorMessage = document.getElementById(DivGridErrorMessage);
            var ImageGridError = document.getElementById(ImageGridError);
            var tableGridErrorMessage = document.getElementById(tableGridErrorMessage);
            var table = document.getElementById(tbl);
            Streamline.SmartClient.WebServices.ClientMedications.SaveKeyPhraseRow(objClientKeyPhraseRow, ClientMedicationOrder.onSaveKeyPhrasesucceeded, ClientMedicationOrder.onSaveKeyPhraseFailure, context);

        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onSaveKeyPhrasesucceeded: function (result, context) {
        try {
            document.getElementById(context.HiddenKeyPhraseId).value = 0;
            Clear_Click();
            if (document.getElementById('buttonInsert').value = "Modify") {
                document.getElementById('buttonInsert').value = "Insert";
            }

        } catch (e) {

            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
        }
    },
    onSaveKeyPhraseFailure: function (error, context) {
        document.getElementById(context.ImageGridError).style.display = 'block';
        document.getElementById(context.ImageGridError).style.visibility = 'visible';
        document.getElementById(context.DivGridErrorMessage).style.display = 'block';
        document.getElementById(context.tableGridErrorMessage).style.display = 'block';
        document.getElementById(context.LabelGridErrorMessage).innerText = error.get_message();
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        return false;
    },
    ModifyPhraseList: function (KeyPhraseId, CheckBoxFavorites, TextBoxPhraseText, DropDownListKeyPhraseCategory, HiddenKeyPhraseId) {
        try {
            var context = new Object();
            context.FavoritePhrase = CheckBoxFavorites;
            context.PhraseText = TextBoxPhraseText;
            context.HiddenKeyPhraseId = HiddenKeyPhraseId;
            context.KeyPhraseCategory = DropDownListKeyPhraseCategory;
            Streamline.SmartClient.WebServices.ClientMedications.ModifyPhraseList(KeyPhraseId, ClientMedicationOrder.onModifyPhraseListSuccess, ClientMedicationOrder.onKeyPhraseFailure, context);

        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onModifyPhraseListSuccess: function (result, context) {
        try {
            //debugger
            if (result.tables[0].rows[0]["PhraseText"] != null)
                document.getElementById(context.PhraseText).value = result.tables[0].rows[0]["PhraseText"];

            if (result.tables[0].rows[0]["KeyPhraseCategory"] != null)
                document.getElementById(context.KeyPhraseCategory).value = result.tables[0].rows[0]["KeyPhraseCategory"];


            if (result.tables[0].rows[0]["Favorite"] == "Y") {
                document.getElementById(context.FavoritePhrase).checked = true;
            } else {
                document.getElementById(context.FavoritePhrase).checked = false;
            }
            document.getElementById(context.HiddenKeyPhraseId).value = result.tables[0].rows[0]["KeyPhraseId"];
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onKeyPhraseFailure: function (error) {
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request." || error.get_message().indexOf('failed') > 0) {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
    },
    DeleateFromPhraseList: function (KeyPhraseId) {
        try {
            Streamline.SmartClient.WebServices.ClientMedications.DeleteKeyPhraseRow(KeyPhraseId, ClientMedicationOrder.onDeleteButtonKeyPhraseSucceded, ClientMedicationOrder.onKeyPhraseFailure, KeyPhraseId);
        } catch (KeyPhraseId) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, KeyPhraseId);
        }
    },
    onDeleteButtonKeyPhraseSucceded: function (result, context, methodname) {
        try {
            if (result == true) {
                Clear_Click();
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {

        }
    },
    SaveKeyPhrases: function () {
        try {

            Streamline.SmartClient.WebServices.ClientMedications.SaveKeyPhrases(JSON.stringify(checkboxObj), ClientMedicationOrder.SaveKeyPhrasessucceeded, ClientMedicationOrder.onSaveKeyPhraseFailure);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    SaveKeyPhrasessucceeded: function (result) {
        parent.$("#DivKeyAndAgencyPhrase").css('display', 'none');
    },
    CloseKeyPhrase: function () {
        try {

            Streamline.SmartClient.WebServices.ClientMedications.CloseKeyPhrase(ClientMedicationOrder.onKeyPhraseCloseSucceeded, ClientMedicationOrder.onFailure);

        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onKeyPhraseCloseSucceeded: function (result, context) {
        try {
            if (result == true) {
                try {
                    ClientMedicationOrder.dialogForKeyPhraseClose();
                } catch (e) {
                }
            } else {
                parent.$("#DivKeyAndAgencyPhrase").css('display', 'none');

            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    dialogForKeyPhraseClose: function () {
      
            ClientMedicationOrder.SaveKeyPhrases();
    },
    GetAgencyKeyPhrasesList: function (Panel, DropDownListScreenPhraseCategory) {
        try {

            var DropdownKeyPhraseCategory = document.getElementById(DropDownListScreenPhraseCategory);
            var AgencyCategoryId = DropdownKeyPhraseCategory.value;
            var AgencyCategoryText = DropdownKeyPhraseCategory.options[DropdownKeyPhraseCategory.selectedIndex].innerText;
            wRequest = new Sys.Net.WebRequest();
            wRequest.set_url("AjaxScript.aspx?FunctionId=GetAgencyKeyPhrasesByCategory&SelectedCategoryId=" + AgencyCategoryId + "&SelectedCategoryName=" + AgencyCategoryText);
            wRequest.add_completed(ClientMedicationOrder.OnFillAgencyKeyPhrasesCompleted);
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
    OnFillAgencyKeyPhrasesCompleted: function (executor, eventArgs) {
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
                    }
                }
            }

        } catch (e) {
        }
    },

    FillAgencyKeyPhraseRow: function (tbl, HiddenKeyPhraseId, TextBoxPhraseText, DropDownListAgencyKeyPhraseCategory, LabelErrorMessage, DivErrorMessage, ImageError, PanelPhrasesListInformation, HiddenRowIdentifier, LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, tableErrorMessage, tableGridErrorMessage) {
        try {
            var context = new Object();
            context.Panel = PanelPhrasesList;
            context.LabelErrorMessage = LabelErrorMessage;
            context.DivErrorMessage = DivErrorMessage;
            context.ImageError = ImageError;
            context.tableErrorMessage = tableErrorMessage;
            context.HiddenKeyPhraseId = HiddenKeyPhraseId;
            context.tableGridErrorMessage = tableGridErrorMessage;
            context.LabelGridErrorMessage = LabelGridErrorMessage;
            context.DivGridErrorMessage = DivGridErrorMessage;
            context.ImageGridError = ImageGridError;

            var objClientAgencyKeyPhraseRow = new ClientMedicationOrder.ClientAgencyKeyPhraseRow();
            var docDropDownPhraseCategory = document.getElementById(DropDownListAgencyKeyPhraseCategory);
            objClientAgencyKeyPhraseRow.KeyPhraseCategory = docDropDownPhraseCategory.value;
            objClientAgencyKeyPhraseRow.KeyPhraseCategoryName = docDropDownPhraseCategory.options[docDropDownPhraseCategory.selectedIndex].innerText;
            objClientAgencyKeyPhraseRow.HiddenKeyPhraseId = document.getElementById(HiddenKeyPhraseId).value;
            objClientAgencyKeyPhraseRow.PhraseText = document.getElementById(TextBoxPhraseText).value;
            if (objClientAgencyKeyPhraseRow.AgencyKeyPhraseId == '')
                objClientAgencyKeyPhraseRow.AgencyKeyPhraseId = 0;

            var LabelErrorMessage = document.getElementById(LabelErrorMessage);
            var DivErrorMessage = document.getElementById(DivErrorMessage);
            var ImageError = document.getElementById(ImageError);
            var tableErrorMessage = document.getElementById(tableErrorMessage);
            var LabelGridErrorMessage = document.getElementById(LabelGridErrorMessage);
            var DivGridErrorMessage = document.getElementById(DivGridErrorMessage);
            var ImageGridError = document.getElementById(ImageGridError);
            var tableGridErrorMessage = document.getElementById(tableGridErrorMessage);

            if (objClientAgencyKeyPhraseRow.PhraseText == "") {
                ClientMedicationOrder.ShowHideGridErrors(LabelGridErrorMessage, DivGridErrorMessage, ImageGridError, 'Please enter Agency Phrase text.', tableGridErrorMessage);
                return false;
            }

            Streamline.SmartClient.WebServices.ClientMedications.SaveAgencyKeyPhraseRow(objClientAgencyKeyPhraseRow, ClientMedicationOrder.onSaveAgencyKeyPhrasesucceeded, ClientMedicationOrder.onSaveAgencyKeyPhraseFailure, context);

        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onSaveAgencyKeyPhrasesucceeded: function (result, context, methodname) {
        try {
            document.getElementById(context.HiddenKeyPhraseId).value = 0;
            Clear_Click();
            if (document.getElementById('buttonInsert').value = "Modify") {
                document.getElementById('buttonInsert').value = "Insert";
            }

        } catch (e) {

            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {

        }
    },
    onSaveAgencyKeyPhraseFailure: function (error, context) {
        //debugger
        document.getElementById(context.ImageGridError).style.display = 'block';
        document.getElementById(context.ImageGridError).style.visibility = 'visible';
        document.getElementById(context.DivGridErrorMessage).style.display = 'block';
        document.getElementById(context.tableGridErrorMessage).style.display = 'block';
        document.getElementById(context.LabelGridErrorMessage).innerText = error.get_message();
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        return false;
    },
    ModifyAgencyKeyPhraseList: function (AgencyKeyPhraseId, TextBoxPhraseText, DropDownListAgencyKeyPhraseCategory, HiddenKeyPhraseId) {
        try {
            var AgencyKeyPhraseObj = new Object();
            AgencyKeyPhraseObj.PhraseText = TextBoxPhraseText;
            AgencyKeyPhraseObj.KeyPhraseCategory = DropDownListAgencyKeyPhraseCategory;
            AgencyKeyPhraseObj.HiddenKeyPhraseId = HiddenKeyPhraseId;
            Streamline.SmartClient.WebServices.ClientMedications.ModifyAgencyKeyPhraseList(AgencyKeyPhraseId, ClientMedicationOrder.onModifyAgencyKeyPhraseListSuccess, ClientMedicationOrder.onModifyAgencyKeyPhraseFailure, AgencyKeyPhraseObj);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },

    onModifyAgencyKeyPhraseListSuccess: function (result, AgencyKeyPhraseObj) {
        try {
            if (result.tables[0].rows[0]["PhraseText"] != null)
                document.getElementById(AgencyKeyPhraseObj.PhraseText).value = result.tables[0].rows[0]["PhraseText"];

            if (result.tables[0].rows[0]["KeyPhraseCategory"] != null)
                document.getElementById(AgencyKeyPhraseObj.KeyPhraseCategory).value = result.tables[0].rows[0]["KeyPhraseCategory"];

            document.getElementById(AgencyKeyPhraseObj.HiddenKeyPhraseId).value = result.tables[0].rows[0]["AgencyKeyPhraseId"];
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onModifyAgencyKeyPhraseFailure: function (error) {
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request." || error.get_message().indexOf('failed') > 0) {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
    },
    DeleteFromAgencyKeyPhraseList: function (AgencyKeyPhraseId) {
        try {
            Streamline.SmartClient.WebServices.ClientMedications.DeleteAgencyKeyPhraseRow(AgencyKeyPhraseId, ClientMedicationOrder.onDeleteButtonAgencyKeyPhraseSucceded, ClientMedicationOrder.onAgencyKeyPhraseFailure, AgencyKeyPhraseId);
        } catch (AgencyKeyPhraseId) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, KeyPhraseId);
        }
    },
    onDeleteButtonAgencyKeyPhraseSucceded: function (result, context, methodname) {
        try {
            if (result == true) {
                Clear_Click();
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {

        }
    },
    onAgencyKeyPhraseFailure: function (error) {
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request." || error.get_message().indexOf('failed') > 0) {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
    },
    SaveAgencyKeyPhrases: function () {
        try {

            Streamline.SmartClient.WebServices.ClientMedications.SaveAgencyKeyPhrases(ClientMedicationOrder.SaveKeyAgencyPhrasessucceeded, ClientMedicationOrder.onSaveAgencyKeyPhraseFailure);

        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },

    SaveKeyAgencyPhrasessucceeded: function (result) {
        //debugger
        parent.$("#DivSearch1").css('display', 'none');
    },

    CloseAgencyKeyPhrases: function () {
        try {

            Streamline.SmartClient.WebServices.ClientMedications.CloseAgencyKeyPhrases(ClientMedicationOrder.onAgencyKeyPhraseCloseSucceeded, ClientMedicationOrder.onSaveAgencyKeyPhraseFailure);

        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    dialogForCloseAgencyKeyPhrases: function () {
    
            ClientMedicationOrder.SaveAgencyKeyPhrases();
    },

    onAgencyKeyPhraseCloseSucceeded: function (result, context) {
        try {
            if (result == true) {
                try {
                    ClientMedicationOrder.dialogForCloseAgencyKeyPhrases();
                } catch (e) {
                }
            } else {
                parent.$("#DivSearch1").css('display', 'none');
                return false;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {

        }
    },

    ClientKeyPhraseRow: function () {
        this.KeyPhraseId;
        this.PhraseText;
        this.KeyPhraseCategory;
        this.Favorite;
        this.RowIdentifierKeyPhrase
        this.KeyPhraseCategoryName

    },
    ClientAgencyKeyPhraseRow: function () {
        this.AgencyKeyPhraseId;
        this.PhraseText;
        this.KeyPhraseCategory;
        this.RowIdentifierKeyPhrase
        this.KeyPhraseCategoryName

    },
   

};