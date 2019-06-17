        
function HideandShow() {
    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughts] option:selected").text()) == "Yes") {
        $('#STM').show();
        $('#SIA').show();
        $('#SISP').show();
        $('#SB').show();
    }
    else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSAdultSinceLastVisits_SuicidalThoughts] option:selected").text()) == "No") {
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