var GlobalCodesXML = null;
var typeStatus = '';
function SetScreenSpecificValues(dom, action) {
    GlobalCodesXML = $.xmlDOM($('input[type=hidden][id$=HiddenFieldGlobaCodes]').val());
    if ($("GlobalCodes Code:contains('QUARTERLY')", GlobalCodesXML).length > 0)
        typeStatus = $('GlobalCodeId', $("GlobalCodes Code:contains('QUARTERLY')", GlobalCodesXML).parent()).text();

    if ($('CustomDocumentFABIPs Type', dom).text() != typeStatus)
        HideQuaterlyGroup(true);
    else
        HideQuaterlyGroup(false);

    $('select[id$=DropDownList_CustomDocumentFABIPs_Type').attr('disabled', true);
    
    $('select[id$=DropDownList_CustomDocumentFABIPs_Type').unbind('change');
    $('select[id$=DropDownList_CustomDocumentFABIPs_Type').bind('change', function() {

        for (var j = 1; j <= 5; j++) {
            $('input#TextBox_CustomDocumentFABIPs_TargetBehavior' + j).attr('disabled', false);
            var FromLastDocument = 'FromLastDocument' + 1;
            CreateAutoSaveXml('CustomDocumentFABIPs', FromLastDocument, 'N');
        }

        if ($(this).val() != typeStatus)
            HideQuaterlyGroup(true);
        else
            HideQuaterlyGroup(false);


    });

    DisableTargets(dom);
    //AddTR();
}

function HideQuaterlyGroup(hideControl) {
    if (hideControl == true) {
        $('table#SectionGroup1375').hide();
        $('table#SectionGroup1379').hide();
        $('table#SectionGroup1383').hide();
        $('table#SectionGroup1387').hide();
        $('table#SectionGroup1391').hide();
    }
    else {
        $('table#SectionGroup1375').show();
        $('table#SectionGroup1379').show();
        $('table#SectionGroup1383').show();
        $('table#SectionGroup1387').show();
        $('table#SectionGroup1391').show();
    }

}

function DisableTargets(dom) {
    if ($('CustomDocumentFABIPs FromLastDocument1', dom).length > 0 && $('CustomDocumentFABIPs FromLastDocument1', dom).text() == 'Y')
        $('input#TextBox_CustomDocumentFABIPs_TargetBehavior1').attr('disabled', true);

    if ($('CustomDocumentFABIPs FromLastDocument2', dom).length > 0 && $('CustomDocumentFABIPs FromLastDocument2', dom).text() == 'Y')
        $('input#TextBox_CustomDocumentFABIPs_TargetBehavior2').attr('disabled', true);

    if ($('CustomDocumentFABIPs FromLastDocument3', dom).length > 0 && $('CustomDocumentFABIPs FromLastDocument3', dom).text() == 'Y')
        $('input#TextBox_CustomDocumentFABIPs_TargetBehavior3').attr('disabled', true);

    if ($('CustomDocumentFABIPs FromLastDocument4', dom).length > 0 && $('CustomDocumentFABIPs FromLastDocument4', dom).text() == 'Y')
        $('input#TextBox_CustomDocumentFABIPs_TargetBehavior4').attr('disabled', true);

    if ($('CustomDocumentFABIPs FromLastDocument5', dom).length > 0 && $('CustomDocumentFABIPs FromLastDocument5', dom).text() == 'Y')
        $('input#TextBox_CustomDocumentFABIPs_TargetBehavior5').attr('disabled', true);                           
        
}