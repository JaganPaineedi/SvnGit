//=========================================================================================
// Copyright (C) 2010 Streamline Healthcare Solutions Inc.
//
// All rights are reserved. Reproduction or transmission in whole or in part, in
// any form or by any means, electronic, mechanical or otherwise, is prohibited
// without the prior written consent of the copyright owner.
//
// Filename:    Involuntary Services Document.js
//
// Author:      Malathi Shiva 
// Date:        05 May 2015
//=========================================================================================



function AddEventHandlers() {
    $("[id$=DropDownList_CustomDocumentInvoluntaryServices_HearingRecommended]").unbind('change');
    $("[id$=DropDownList_CustomDocumentInvoluntaryServices_HearingRecommended]").bind("change", function() {
    SetCommittedDropDown(this);
    });
    
}


function SetCommittedDropDown(obj) {
    var requestParametersValues = "FunctionName=SetInvoluntaryServicesCommittedDropDown&HearingRecommendedGlobalCodeId=" + $(obj).val() + "&ApplicationBasePath=" + _ApplicationBasePath;
    $.ajax({
        type: "POST",
        url: _ApplicationBasePath + "Custom/InvoluntaryServices/WebPages/InvoluntaryServices.ashx",
        data: requestParametersValues,
        success: function(result) {
            if (result) {
                $('select[id$=DropDownList_CustomDocumentInvoluntaryServices_InvoluntaryServicesCommitted]').val(result);
                CreateAutoSaveXml('CustomDocumentInvoluntaryServices', 'InvoluntaryServicesCommitted', result);
            }
        }
    });
}

