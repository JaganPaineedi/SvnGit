
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
function ShowCustomToolTip(sender) {
    if ($(sender).attr('title') == '' || ($(sender) == 'undefined')) {
        $(sender).is("td")
        {
            $(sender).attr('title', $(sender).html());
        }
    }
}

function AddEventHandlers() {
   
    
}

function CustomAjaxRequestCallback(result, CutomAjaxRequest) {
    if (result.indexOf("###StartCurrentDiagnosisUc###") >= 0) {
        var pageResponse = result;
        var start = pageResponse.indexOf("###StartCurrentDiagnosisUc###") + 29;
        var end = pageResponse.indexOf("###EndCurrentDiagnosisUc###");
        var htmlResponse = pageResponse.substr(start, end - start);
        CreateDiagnosisTable(htmlResponse);
    }
}

function CreateDiagnosisTable(result) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<tr>";
    tableHeader += "<th align='left' width='15%'>Type</th>";
    tableHeader += "<th align='left' width='10%'>ICD 9</th>";
    tableHeader += "<th align='left' width='15%'>ICD 10</th>";
    tableHeader += "<th align='left' width='15%'>DSMV</th>";
    tableHeader += "<th align='left' width='30%'>Description</th>";
    tableHeader += "</tr></thead>";
    var result1 = $.xmlDOM(result);
    $(result1).find('DocumentDiagnosisCodes').each(function() {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('DiagnosisType').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD9Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('ICD10Code').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('DSMVCode').text() + "</td>";

        var dsmDesciption = $(this).find('DSMDescription').text();
        if (dsmDesciption.length > 40)
            dsmDesciption = "<span title='" + dsmDesciption + "'>" + dsmDesciption.substring(0, 40) + "..." + "</span>";
        else
            dsmDesciption = "<span>" + dsmDesciption + "</span>";
        tableBody += "<td align='left'>" + dsmDesciption + "</td>";
        tableBody += "</tr>";
    });
    var tableHeaderAxisIII = "<tr>";
    tableHeaderAxisIII += "<td align='left' colspan='5' style='padding-top:5px;'>Psychosocial, Environmental, and Other Factors</td>";
    tableHeaderAxisIII += "</tr>";
    tableHeaderAxisIII += "<tr>";
    tableHeaderAxisIII += "<td align='left' width='5%' style='padding-top:5px;'>&nbsp;</td>";
    tableHeaderAxisIII += "<td align='left' width='55%' style='padding-top:5px;'>Source</td>";
    tableHeaderAxisIII += "</tr>";
    var result2 = $.xmlDOM(result);
    var tableBodyAxisIII = "";
    $(result2).find('DocumentDiagnosisFactors').each(function() {
        tableBodyAxisIII += "<tr>";
        tableBodyAxisIII += "<td align='left'>&nbsp;</td>";
        tableBodyAxisIII += "<td align='left'>" + $(this).find('Factors').text() + "</td>";
        tableBodyAxisIII += "</tr>";
    });

    var tableHeaderAxisIV = "<tr>";
    tableHeaderAxisIV += "<td align='left' colspan='5' style='padding-top:5px;' >Axis IV</td>";
    tableHeaderAxisIV += "</tr>";
    var result3 = $.xmlDOM(result);
    var tableBodyAxisIV = "";
    $(result3).find('DiagnosesIV').each(function() {
        tableBodyAxisIV += "<tr>";
        //below Changes by made Rahul Aneja ref: task#2129 in Thresholds bugs & features ,show all For Axis IV - single line with comma separate values for what is checked ,
        var specification = $(this).find('Specification').text();
        if (specification.substring(specification.length - 2, specification.length - 1) === ",")
            specification = specification.substring(0, specification.length - 2);

        tableBodyAxisIV += "<td align='left' colspan='5'>" + specification + "</td>";
        //End Chages
        tableBodyAxisIV += "</tr>";
    });

    var tableHeaderAxisV = "<tr>";
    tableHeaderAxisV += "<td align='left'colspan='5'  style='padding-top:5px;'>Level of Functioning Score</td>";
    tableHeaderAxisV += "</tr>";
    var result4 = $.xmlDOM(result);
    var tableBodyAxisV = "";
    $(result4).find('DocumentDiagnosis').each(function() {
        tableBodyAxisV += "<tr>";
        tableBodyAxisV += "<td align='left' colspan='2'>GAF Score: " + $(this).find('GAFScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='1'>WHODAS Score: " + $(this).find('WHODASScore').text() + "</td>";
        tableBodyAxisV += "<td align='left' colspan='2'>CAFAS Score: " + $(this).find('CAFASScore').text() + "</td>";
        tableBodyAxisV += "</tr>";
    });

    //tableBody += "</tbody>";

    var effectiveDate = $.xmlDOM(result).find('EffectiveDate').text();

    var trEffictiveDate = "<table width='100%'><tr><td align='left' width='20%'>Effective Date: " + effectiveDate + "</td></tr></table>";

    var DiagnosisHTML = trEffictiveDate + tableHeader + tableBody + "</tbody>" + endTable;
    $("[id$=divPreviousDiagnosis]").html(DiagnosisHTML);
}

