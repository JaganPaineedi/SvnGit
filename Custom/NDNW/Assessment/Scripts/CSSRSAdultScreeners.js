
//function SetScreenSpecificValues() {
//    var valSuicidalThoughts = $('[id$=DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughts] :selected').text();
//    if (valSuicidalThoughts.toUpperCase() == "NO") {
//        $('.HideSectionforNo').hide();
//    }
//    else {
//        $('.HideSectionforNo').show();
//    }
//}

//var CSSRS = {
//    ShowHideSections: function (obj) {
//        var array = $(obj)[0].id.split('_');

//        if (array[array.length - 1] != undefined && array[array.length - 1] != "") {

//            var selectedValue = $(obj).find(':selected').text()

//            if (array[array.length - 1].toUpperCase() == "SUICIDALTHOUGHTS" && selectedValue.toUpperCase() == "NO") {
//                $('.HideSectionforNo').hide();
//                CSSRS.UpdatetheChildControlsOnHide();
//            }
//            else if (array[array.length - 1].toUpperCase() == "SUICIDALTHOUGHTS") {
//                $('.HideSectionforNo').show();
//            }
//        }
//    },
//    UpdatetheChildControlsOnHide: function () {
//        var customCSSRS = GetAutoSaveXMLDomNode('CustomDocumentCSSRSAdultScreeners');
//        var items = customCSSRS.length > 0 ? $(customCSSRS).XMLExtract() : [];
//        if (items.length > 0) {
//            items[0]["SuicidalThoughtsWithMethods"] = '';
//            items[0]["SuicidalIntentWithoutSpecificPlan"] = '';
//            items[0]["SuicidalIntentWithSpecificPlan"] = '';
//            CreateAutoSaveXMLObjArray('CustomDocumentCSSRSAdultScreeners', 'DocumentVersionId', items[0], false);
//        }
//    }
//}



function HideandShowSections() {
    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughts] option:selected").text()) == "Yes") {
        $('#STM').show();
        $('#SIA').show();
        $('#SISP').show();
        $('#SB').show();
    }
    else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSAdultScreeners_SuicidalThoughts] option:selected").text()) == "No") {
        $('#STM').hide();
        $('#SIA').hide();
        $('#SISP').hide();
        $('#SB').show();
    }
    else {
        $('#STM').hide();
        $('#SIA').hide();
        $('#SISP').hide();
        $('#SB').hide();
    }
}