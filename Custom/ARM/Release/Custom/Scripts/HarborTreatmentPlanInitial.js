
//Author Rohit Katoch 
//Added for seperating the Screen Specific code
function SetScreenSpecificValues(dom, action) {

    try {

        HarborTreatmentPlanScreenSpecific(dom);
    }
    catch (ex) {

    }


}

//Author : Rohit Katoch
//Added to hide the controls
function HarborTreatmentPlanScreenSpecific(dom) {
    var ReasonUpdate = $('tr[updateReason]');
    if (ReasonUpdate.length > 0) {
        var DocumentCode = dom[0].childNodes[0].selectNodes("Documents")[0].selectNodes("DocumentCodeId")[0].text;
        if (parseInt(DocumentCode) == 1483 || parseInt(DocumentCode) == 1486) {
            ReasonUpdate.hide();
        }
    }
    
    // added by 10-Nov-2011 Priyanka task#16 in HArbor Development
    var clientDidNotParticipate = $('CustomTreatmentPlans ClientDidNotParticipate', dom);

    if (clientDidNotParticipate.length > 0) {
        if (clientDidNotParticipate.text() == 'Y') {

            $('#TextArea_CustomTreatmentPlans_ClientDidNotParticpateComment').removeAttr('readonly');
        }
    }
}

function ValidateCustomPageEventHandler() {

    var validOrNot = true;
    validOrNot = ValidateServiceId();

    return validOrNot;
}


function ValidateServiceId() {
    var serviceNo = '';
    var validOrNot = true;
    $('[id*=DropDownList_ServiceCode_]').each(function() {
        if ($(this).val() == '') {
            serviceNo += 'Service ' + $(this).attr('ServiceNo') + ', ';
            validOrNot = false;
        }
    }
    );
    if (serviceNo != '')
        serviceNo = serviceNo.substring(0, serviceNo.length - 2);
    if (validOrNot == false)
        ShowMsgBox('Please select Authorization Code for the following services :<br />' + serviceNo, 'Missing Fields', MessageBoxButton.OK, MessageBoxIcon.Information);
    return validOrNot;
}
