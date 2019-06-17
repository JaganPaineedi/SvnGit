///Function : This Function is used to refresh other tab page contents by XML DOM
///Created Date: March 05, 2010
///Author: Jitender
function RefreshTabPageContents(tabControl, selectedTabTitle) {
    //var myarray = new Array();
    if (selectedTabTitle == "LOC-Four") {
        var count = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomASAMLevelOfCares").length;
        var dimension1Level = "", dimension2Level = "", dimension3Level = "";
        var dimensionNeed = "", dimensionLevelOfCare = "", levelOfCareName = "";
        for (index = 1; index <= count; index++) {
            dimensionNeed = GetColumnValueInXMLNodeByKeyValue('CustomASAMPlacements', 'DocumentVersionId', $('#HiddenField_CustomASAMPlacements_DocumentVersionId').val(), 'Dimension' + index.toString() + 'Need', AutoSaveXMLDom[0]);
            dimensionLevelOfCare = GetColumnValueInXMLNodeByKeyValue('CustomASAMPlacements', 'DocumentVersionId', $('#HiddenField_CustomASAMPlacements_DocumentVersionId').val(), 'Dimension' + index.toString() + 'LevelOfCare', AutoSaveXMLDom[0]);
            levelOfCareName = GetColumnValueInXMLNodeByKeyValue('CustomASAMLevelOfCares', 'ASAMLevelOfCareId', dimensionLevelOfCare, 'LevelOfCareName', AutoSaveXMLDom[0]);

            if (index == 1) {
                dimension1Level = dimensionLevelOfCare;
            }
            else if (index == 2) {
                dimension2Level = dimensionLevelOfCare;
            }
            else if (index == 3) {
                dimension3Level = dimensionLevelOfCare;
            }
            ///Table_ASAMLevelOfCares is an HTML Table on ASAM4 Page.
            $('#TextArea_CustomASAMPlacements_Dimension' + index.toString() + 'Need', $("#Table_ASAMLevelOfCares")).val(dimensionNeed);
            $('#TextBox_CustomASAMPlacements_Dimension' + index.toString() + 'LevelOfCareName').val(levelOfCareName);
        }
        GetSuggestedPlacement(dimension1Level, dimension2Level, dimension3Level);
    }
}

///Added By Jitender
///20 March 2010
///This function is used to get Suggested Placement value.
function GetSuggestedPlacement(_dimension1Level, _dimension2Level, _dimension3Level) {
    try {
        if (_dimension1Level != "" || _dimension2Level != "" || _dimension3Level != "") {
            $.ajax(
        {
            type: "POST",
            url: "../AjaxScript.aspx?functionName=GetSuggestedPlacement",
            data: "Dimension1LevelOfCare=" + _dimension1Level + "&Dimension2LevelOfCare=" + _dimension2Level + "&Dimension3LevelOfCare=" + _dimension3Level,
            success: fillSuggestedPlacement
        });
        }
    }
    catch (err) {
        LogClientSideException(err, 'ASAM');
    }
}

///Added By Jitender
///20 March 2010
///This function is used to Fill Suggested Placement According to Seleced Procedure
function fillSuggestedPlacement(result) {
    try {
        if (result != "" && result != undefined) {
            var suggestedPlacementName = result.split(',')[0], suggestedPlacement = result.split(',')[1];
            $('[id=Span_CustomASAMPlacements_SuggestedPlacementName]')[0].innerHTML = suggestedPlacementName;
            $("#HiddenField_CustomASAMPlacements_SuggestedPlacement").val(suggestedPlacement);
            CreateAutoSaveXml('CustomASAMPlacements', 'SuggestedPlacement', $("#HiddenField_CustomASAMPlacements_SuggestedPlacement").val());
        }
    }
    catch (err) {
        LogClientSideException(err, 'ASAM');
    }
}

function SuggestedPlacement() {
    var height = 50;
    var width = 300;
    //alert("The suggested level is based on the highest level from Dimensions 1, 2, and 3.");
    ShowMsgBox("The suggested level is based on the highest level from Dimensions 1, 2, and 3.", 'Suggested Placement', MessageBoxButton.OK, MessageBoxIcon.Information, undefined, undefined, undefined, height, width);
}

function SetScreenSpecificValues(dom, action) {
    try {
        AttachCustomValidationEventHandler();
    }
    catch (ex) {
        LogClientSideException(err, 'SUASAM');
    }
}