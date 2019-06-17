function SetCurrentTab(sender, e) {
    try {
        TabIndex = sender.activeTabIndex;

    }
    catch (err) { }
}

function StoreTabstripClientObject(sender) {
    tabobject = sender;
}

AddEventHandlers = (function () {
    try {
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {
            historytabobject = tabobject._selectedIndex;
            if (historytabobject >= 0) {
                selectedTabText = tabobject.get_selectedTab().get_text();

                if (historytabobject == 0 && selectedTabText == 'Dimension 1') {
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension1]").unbind('click');
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension1]").click(function (e) {
                        SetLevel(this, 'DropDownList_CustomDocumentASAMs_D1Level', 'Dimension1', 'D1Level');
                    });
                }

                if (historytabobject == 1 && selectedTabText == 'Dimension 2') {
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension2]").unbind('click');
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension2]").click(function (e) {
                        SetLevel(this, 'DropDownList_CustomDocumentASAMs_D2Level', 'Dimension2', 'D2Level');
                    });
                }

                if (historytabobject == 2 && selectedTabText == 'Dimension 3') {
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension3]").unbind('click');
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension3]").click(function (e) {
                        SetLevel(this, 'DropDownList_CustomDocumentASAMs_D3Level', 'Dimension3', 'D3Level');
                    });
                }

                if (historytabobject == 3 && selectedTabText == 'Dimension 4') {
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension4]").unbind('click');
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension4]").click(function (e) {
                        SetLevel(this, 'DropDownList_CustomDocumentASAMs_D4Level', 'Dimension4', 'D4Level');
                    });
                }

                if (historytabobject == 4 && selectedTabText == 'Dimension 5') {
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension5]").unbind('click');
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension5]").click(function (e) {
                        SetLevel(this, 'DropDownList_CustomDocumentASAMs_D5Level', 'Dimension5', 'D5Level');
                    });
                }

                if (historytabobject == 5 && selectedTabText == 'Dimension 6') {
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension6]").unbind('click');
                    $("[name=RadioButton_CustomDocumentASAMs_Dimension6]").click(function (e) {
                        SetLevel(this, 'DropDownList_CustomDocumentASAMs_D6Level', 'Dimension6', 'D6Level');
                    });
                }

                if (historytabobject == 6 && selectedTabText == 'Final Determination') {
                    SetFinalDetermination();
                }
            }
        }

    }
    catch (ex) {

    }
});


function RefreshTabPageContents(tabControl, selectedTabTitle) {
    try {
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {
            historytabobject = tabobject._selectedIndex;
            if (historytabobject >= 0) {
                selectedTabText = tabobject.get_selectedTab().get_text();

                if (historytabobject == 6 && selectedTabText == 'Final Determination') {
                    SetFinalDetermination();
                }
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'ASAM Document : RefreshTabPageContents');
    }
}

SetLevel = (function (obj, ctrllevelid, mode, columnname) {
    try {
        var ctrlId = $(obj).attr('id');
        var selectedtextvalue = '';
        if (ctrlId.indexOf('_' + mode + '_A') != -1) {
            selectedtextvalue = 'No treatment recommended';
        }
        else if (ctrlId.indexOf('_' + mode + '_B') != -1) {
            selectedtextvalue = 'Level 0.5';
        }
        else if (ctrlId.indexOf('_' + mode + '_C') != -1) {
            selectedtextvalue = 'Opioid Maintenance Therapy';
        }
        else if (ctrlId.indexOf('_' + mode + '_D') != -1) {
            selectedtextvalue = 'Level 1.0';
        }
        else if (ctrlId.indexOf('_' + mode + '_E') != -1) {
            selectedtextvalue = 'Level 2.1';
        }
        else if (ctrlId.indexOf('_' + mode + '_F') != -1) {
            selectedtextvalue = 'Level 2.5';
        }
        else if (ctrlId.indexOf('_' + mode + '_G') != -1) {
            selectedtextvalue = 'Level 3.1';
        }
        else if (ctrlId.indexOf('_' + mode + '_H') != -1) {
            selectedtextvalue = 'Level 3.5';
        }

        var selectedvalue = $("[id$=" + ctrllevelid + "]").find('option[text="' + selectedtextvalue + '"]').val();
        if (selectedvalue) {
            $("[id$=" + ctrllevelid + "]").val(selectedvalue);
            CreateAutoSaveXml('CustomDocumentASAMs', columnname, selectedvalue);
        }
    }
    catch (ex) {

    }
});


SetFinalDetermination = (function () {
    try {
        var D1Level = AutoSaveXMLDom.find("CustomDocumentASAMs:first D1Level").text();
        var D1Risk = AutoSaveXMLDom.find("CustomDocumentASAMs:first D1Risk").text();
        var D1Comments = AutoSaveXMLDom.find("CustomDocumentASAMs:first D1Comments").text();
        if (!D1Level)
            D1Level = '';
        if (!D1Risk)
            D1Risk = '';
        if (!D1Comments)
            D1Comments = '';
        D1Level = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Level] option[value='" + D1Level + "']").text();
        D1Risk = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Risk] option[value='" + D1Risk + "']").text();
        if (D1Level.indexOf('Level') == -1 && D1Level != '')
            D1Level = 'Level ' + D1Level;
        $('#span_dimension1level').html(D1Level);
        if (D1Risk != '')
            $('#span_risk1level').html('Risk: ' + D1Risk);
        else
            $('#span_risk1level').html('');
        $('#TextAreaDimension1').val(D1Comments);

        var D2Level = AutoSaveXMLDom.find("CustomDocumentASAMs:first D2Level").text();
        var D2Risk = AutoSaveXMLDom.find("CustomDocumentASAMs:first D2Risk").text();
        var D2Comments = AutoSaveXMLDom.find("CustomDocumentASAMs:first D2Comments").text();
        if (!D2Level)
            D2Level = '';
        if (!D2Risk)
            D2Risk = '';
        if (!D2Comments)
            D2Comments = '';
        D2Level = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Level] option[value='" + D2Level + "']").text();
        D2Risk = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Risk] option[value='" + D2Risk + "']").text();
        if (D2Level.indexOf('Level') == -1 && D2Level != '')
            D2Level = 'Level ' + D2Level;
        $('#span_dimension2level').html(D2Level);
        if (D2Risk != '')
            $('#span_risk2level').html('Risk: ' + D2Risk);
        else
            $('#span_risk2level').html('');
        $('#TextAreaDimension2').val(D2Comments);

        var D3Level = AutoSaveXMLDom.find("CustomDocumentASAMs:first D3Level").text();
        var D3Risk = AutoSaveXMLDom.find("CustomDocumentASAMs:first D3Risk").text();
        var D3Comments = AutoSaveXMLDom.find("CustomDocumentASAMs:first D3Comments").text();
        if (!D3Level)
            D3Level = '';
        if (!D3Risk)
            D3Risk = '';
        if (!D3Comments)
            D3Comments = '';
        D3Level = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Level] option[value='" + D3Level + "']").text();
        D3Risk = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Risk] option[value='" + D3Risk + "']").text();
        if (D3Level.indexOf('Level') == -1 && D3Level != '')
            D3Level = 'Level ' + D3Level;
        $('#span_dimension3level').html(D3Level);
        if (D3Risk != '')
            $('#span_risk3level').html('Risk: ' + D3Risk);
        else
            $('#span_risk3level').html('');
        $('#TextAreaDimension3').val(D3Comments);

        var D4Level = AutoSaveXMLDom.find("CustomDocumentASAMs:first D4Level").text();
        var D4Risk = AutoSaveXMLDom.find("CustomDocumentASAMs:first D4Risk").text();
        var D4Comments = AutoSaveXMLDom.find("CustomDocumentASAMs:first D4Comments").text();
        if (!D4Level)
            D4Level = '';
        if (!D4Risk)
            D4Risk = '';
        if (!D4Comments)
            D4Comments = '';
        D4Level = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Level] option[value='" + D4Level + "']").text();
        D4Risk = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Risk] option[value='" + D4Risk + "']").text();
        if (D4Level.indexOf('Level') == -1 && D4Level != '')
            D4Level = 'Level ' + D4Level;
        $('#span_dimension4level').html(D4Level);
        if (D4Risk != '')
            $('#span_risk4level').html('Risk: ' + D4Risk);
        else
            $('#span_risk4level').html('');
        $('#TextAreaDimension4').val(D4Comments);

        var D5Level = AutoSaveXMLDom.find("CustomDocumentASAMs:first D5Level").text();
        var D5Risk = AutoSaveXMLDom.find("CustomDocumentASAMs:first D5Risk").text();
        var D5Comments = AutoSaveXMLDom.find("CustomDocumentASAMs:first D5Comments").text();
        if (!D5Level)
            D5Level = '';
        if (!D5Risk)
            D5Risk = '';
        if (!D5Comments)
            D5Comments = '';
        D5Level = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Level] option[value='" + D5Level + "']").text();
        D5Risk = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Risk] option[value='" + D5Risk + "']").text();
        if (D5Level.indexOf('Level') == -1 && D5Level != '')
            D5Level = 'Level ' + D5Level;
        $('#span_dimension5level').html(D5Level);
        if (D5Risk != '')
            $('#span_risk5level').html('Risk: ' + D5Risk);
        else
            $('#span_risk5level').html('');
        $('#TextAreaDimension5').val(D5Comments);

        var D6Level = AutoSaveXMLDom.find("CustomDocumentASAMs:first D6Level").text();
        var D6Risk = AutoSaveXMLDom.find("CustomDocumentASAMs:first D6Risk").text();
        var D6Comments = AutoSaveXMLDom.find("CustomDocumentASAMs:first D6Comments").text();
        if (!D6Level)
            D6Level = '';
        if (!D6Risk)
            D6Risk = '';
        if (!D6Comments)
            D6Comments = '';
        D6Level = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Level] option[value='" + D6Level + "']").text();
        D6Risk = $("[id$=DropDownList_CustomDocumentASAMs_DummyD1Risk] option[value='" + D6Risk + "']").text();
        if (D6Level.indexOf('Level') == -1 && D6Level != '')
            D6Level = 'Level ' + D6Level;
        $('#span_dimension6level').html(D6Level);
        if (D6Risk != '')
            $('#span_risk6level').html('Risk: ' + D6Risk);
        else
            $('#span_risk6level').html('');
        $('#TextAreaDimension6').val(D6Comments);

    }
    catch (ex) {
        
    }
});