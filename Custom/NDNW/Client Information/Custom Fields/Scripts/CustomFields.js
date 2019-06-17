if ($('[id$=DropDownList_CustomClients_InsuranceType]').length > 0) {
    $('[id$=DropDownList_CustomClients_InsuranceType]').change(function () {
        if ($('[id$=DropDownList_CustomClients_InsuranceType] option:selected').val() != "") {
            PopupProcessing();
            $.ajax({
                type: "POST",
                url: "../Custom/Client Information/Custom Fields/WebPages/CustomFields.aspx?FunctionName=BindPayerName&selectedInsuranceType=" + $('[id$=DropDownList_CustomClients_InsuranceType] option:selected').val(),
                data: "",
                success: function (result) {
                    BindPayerName(result);
                    HidePopupProcessing();
                },
                error: function (ex) {
                    $('[id$=DropDownList_CustomClients_PayerName]').attr("disabled", "enabled");
                    HidePopupProcessing();
                }
            });
        }
        else if ($('[id$=DropDownList_CustomClients_InsuranceType] option:selected').val() == "") {
            $('[id$=DropDownList_CustomClients_PayerName]').attr("disabled", "enabled");
            $('[id$=DropDownList_CustomClients_PayerName]').html("");
            CreateAutoSaveXml('CustomClients', 'PayerName', '');
        }
    });
}

function BindPayerName(result) {
    try {
        if (result != null || result != '') {
            if (result.xml != null || result.xml != '') {
                $('[id$=DropDownList_CustomClients_PayerName]').empty();
                $('<option></option>').val('').text('').appendTo('[id$=DropDownList_CustomClients_PayerName]');
                $.xmlDOM(result.xml).find("DataViewPayers").each(function () {
                    $('<option title="' + this.childNodes[0].text + '"></option>').val(this.childNodes[1].text).text(this.childNodes[0].text).appendTo("[id$=DropDownList_CustomClients_PayerName]");
                });
                $('[id$=DropDownList_CustomClients_PayerName]').removeAttr("disabled");
                if (!$('[id$=DropDownList_CustomClients_InsuranceType] option:selected').val()) {
                    CreateAutoSaveXml('CustomClients', 'PayerName', '');
                }
                else {
                    CreateAutoSaveXml('CustomClients', 'PayerName', $('[id$=DropDownList_CustomClients_PayerName] option:selected').val());
                }
            }
        }
    }
    catch (ex) {
        $('[id$=DropDownList_CustomClients_PayerName]').attr("disabled", "enabled");
        HidePopupProcessing();
    }
}