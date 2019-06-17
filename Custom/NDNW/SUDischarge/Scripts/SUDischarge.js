var tabobject = null;

function SetCurrentTab(sender, e) {
    try {
        TabIndex = sender.activeTabIndex;
    }
    catch (err) { }
}

function StoreTabstripClientObject(sender) {
    try {
        tabobject = sender;
    }
    catch (err) { }
}

SetScreenSpecificValues = (function (dom, action) {
    try {
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {
            historytabobject = tabobject._selectedIndex;
            if (historytabobject >= 0) {
                selectedTabText = tabobject.get_selectedTab().get_text();

                

            }
        }
    }
    catch (ex) { }
});

AddEventHandlers = (function () {
    try {
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {
            historytabobject = tabobject._selectedIndex;
            if (historytabobject >= 0) {
                selectedTabText = tabobject.get_selectedTab().get_text();

                if (selectedTabText == 'Discharge Frequency') {
                    var SUAdmissionDrugNameOne = AutoSaveXMLDom.find("CustomDocumentSUDischarges:first SUAdmissionDrugNameOneText").text();
                    var SUAdmissionFrequencyOne = AutoSaveXMLDom.find("CustomDocumentSUDischarges:first SUAdmissionFrequencyOneText").text();
                    var SUAdmissionDrugNameTwo = AutoSaveXMLDom.find("CustomDocumentSUDischarges:first SUAdmissionDrugNameTwoText").text();
                    var SUAdmissionFrequencyTwo = AutoSaveXMLDom.find("CustomDocumentSUDischarges:first SUAdmissionFrequencyTwoText").text();
                    var SUAdmissionDrugNameThree = AutoSaveXMLDom.find("CustomDocumentSUDischarges:first SUAdmissionDrugNameThreeText").text();
                    var SUAdmissionFrequencyThree = AutoSaveXMLDom.find("CustomDocumentSUDischarges:first SUAdmissionFrequencyThreeText").text();

                    if (!SUAdmissionDrugNameOne && !SUAdmissionFrequencyOne)
                        $('[section=trFirstSubstanceUse]').hide();
                    if (!SUAdmissionDrugNameTwo && !SUAdmissionFrequencyTwo)
                        $('[section=trSecondSubstanceUse]').hide();
                    if (!SUAdmissionDrugNameThree && !SUAdmissionFrequencyThree)
                        $('[section=trThirdSubstanceUse]').hide();

                    var SUAdmissionsTobaccoUse = AutoSaveXMLDom.find("CustomDocumentSUDischarges:first SUAdmissionsTobaccoUseText").text();
                    if (!SUAdmissionsTobaccoUse)
                        $('[section=trTobaccoUse]').hide();

                }
            }
        }

    }
    catch (ex) { }
});