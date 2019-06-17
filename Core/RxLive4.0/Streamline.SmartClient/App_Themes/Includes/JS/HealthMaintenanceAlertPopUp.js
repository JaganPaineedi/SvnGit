$(function() {
    bindAllPageEvents();
});

function closeDivAlert(flag, returnValue, AllergyType, comments, active) {
    try {
        var DivSearch = parent.document.getElementById('DivHealthMaintenanceAlertPopUp');
        DivSearch.style.display = 'none';
        //parent.window.SaveAllergyData(flag, returnValue, AllergyType, comments, active);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}


function bindAllPageEvents() {
    $('#chkAllRowsHMTemplates').bind('click', function() {
        checkAllRowsOfHMTemplate(this);
    });

    $('#divMultipleAccept,#divMultipleReject').bind('click', function() {
        var $checkedElements = $('[id$=chkRowHMTemplate]:visible:checked');
        var clickAction = $(this).attr('data-clickAction');
        acceptRejectSelectedTemplates(clickAction, $checkedElements);
        saveHMTemplateUserDecisions();
        return false;
    });

//    $('#divMultipleExpandCollapse').bind('click', function() {
//        showHideTemplateCriteriaDetails($(this), "MultipleExpandCollapse");
//        return false;
//    });

//    $('#divReset').bind('click', function() {
//        resetAcceptedRejectedTemplates();
//        return false;
//    });

    $('[id$=divSingleAccept],[id$=divSingleReject]').bind('click', function() {
        var primarykeylist = $(this).attr('data-primarykeylist');
        if (primarykeylist) {
            var $checkedElements = $('[id$=chkRowHMTemplate][data-primarykeylist="' + primarykeylist + '"]');
            var clickAction = $(this).attr('data-clickAction');
            acceptRejectSelectedTemplates(clickAction, $checkedElements);
            saveHMTemplateUserDecisions();
        }
        return false;
    });
//    $('[id$=divSingleExpandCollapse]').bind('click', function() {
//        showHideTemplateCriteriaDetails($(this), "SingleExpandCollapse");
//    });

//    $('#divSaveHMTemplateDecisions').bind('click', function() {
//        saveHMTemplateUserDecisions();
//        return false;
//    });

    $('#divCancelHMTemplateDecisions').bind('click', function() {
        closeDivAlert();
        return false;
    });
}

function checkAllRowsOfHMTemplate(chkboxElm) {
    if (chkboxElm) {
        $('[id$=chkRowHMTemplate]:visible').each(function(indx, elm) {
            $(elm).attr("checked", chkboxElm.checked);
        })
    }
}

function acceptRejectSelectedTemplates(decision, $checkedElements) {
    var userDecision = "";
    var color = "";
    var msg = "";

    if ($checkedElements && $checkedElements.length) {
        if (decision == "accept") {
            userDecision = "Y";
            color = "green";
            msg = $checkedElements.length + ' template(s) has been accepted ';
        }
        else if (decision == "reject") {
            userDecision = "N";
            color = "red";
            msg = $checkedElements.length + ' template(s) has been rejected ';
        }

        $checkedElements.each(function(indx, elm) {
            $(elm).attr("data-UserDecision", userDecision);
            $(elm).parents('tr').hide();
            $(elm).attr("checked", false);
        });

        $('[id$=chkAllRowsHMTemplates]').attr('checked', false);
        resetRowClass();
//        setCountTrackLabels();
    }
    else {
        color = "orange";
        msg = "Please select an template";
    }

    $('#spanDecisionMessage').text(msg);
    $('#spanDecisionMessage').css('color', color);
}
function resetRowClass() {
    $('.clsDetailRow:visible:even').removeClass('odd_row').addClass('even_row');
    $('.clsDetailRow:visible:odd').removeClass('even_row').addClass('odd_row');
}
//function setCountTrackLabels() {
//    var $acceptedTemplates = $('[id$=chkRowHMTemplate][data-UserDecision="Y"]');
//    var $rejectedTemplates = $('[id$=chkRowHMTemplate][data-UserDecision="N"]');
//    if ($acceptedTemplates.length || $rejectedTemplates.length) {
//        $('#spanAcceptCount').text("Accepted Count : " + $acceptedTemplates.length);
//        $('#spanRejectCount').text("Rejected Count : " + $rejectedTemplates.length);
//    }
//    else {
//        $('#spanAcceptCount').text("");
//        $('#spanRejectCount').text("");
//    }
//}

//function showHideTemplateCriteriaDetails($divClickedButton, type) {
//    if ($divClickedButton.length && type) {
//        var allSingleBtnsText = "";
//        var $divAllSingleButtons = [];
//        var clickedBtnNewText = "";
//        var clickedBtnNewAction = "";
//        var $divTemplateCriteriaDetails = [];

//        if (type == "MultipleExpandCollapse") {
//            $divAllSingleButtons = $('[id$=divSingleExpandCollapse]');
//            $divTemplateCriteriaDetails = $("#tblTemplateAndCriteria").find('[id$=divTemplateCriteriaDetails]');
//        }
//        else if (type == "SingleExpandCollapse") {
//            var key = $divClickedButton.attr('data-PrimaryKeyList');
//            $divTemplateCriteriaDetails = $('[id$=divTemplateCriteriaDetails][data-PrimaryKeyList="' + key + '"]');
//        }
//        if ($divTemplateCriteriaDetails.length) {
//            var clickAction = $divClickedButton.attr('data-clickAction');
//            if (clickAction == "collapse") {
//                $divTemplateCriteriaDetails.hide();
//                clickedBtnNewAction = "expand";
//                clickedBtnNewText = '+';

//                if (type == "MultipleExpandCollapse") {
//                    clickedBtnNewText = 'Expand All(+)';
//                    allSingleBtnsText = "+";
//                }
//            }
//            else if (clickAction == "expand") {
//                $divTemplateCriteriaDetails.show();
//                clickedBtnNewAction = "collapse";
//                clickedBtnNewText = '-';

//                if (type == "MultipleExpandCollapse") {
//                    clickedBtnNewText = 'Collapse All(-)';
//                    allSingleBtnsText = "-";
//                }
//            }
//            $divClickedButton.attr('data-clickAction', clickedBtnNewAction);
//            $divClickedButton.text(clickedBtnNewText);

//            if ($divAllSingleButtons.length) {
//                $divAllSingleButtons.each(function(indx, elm) {
//                    $(elm).attr('data-clickAction', clickedBtnNewAction);
//                    $(elm).text(allSingleBtnsText);
//                });
//            }
//        }

//    }
//}

//function resetAcceptedRejectedTemplates() {
//    var $elements = $('[id$=chkRowHMTemplate]');
//    $elements.each(function(indx, elm) {
//        $(elm).removeAttr("data-UserDecision");
//        $(elm).parents('tr').show();
//        $(elm).attr("checked", false);
//    });
//    $('[id$=chkAllRowsHMTemplates]').attr('checked', false);
//    resetRowClass();
//    setCountTrackLabels();

//    $('#spanDecisionMessage').text("All rows are reset");
//    $('#spanDecisionMessage').css('color', "blue");
//}

function saveHMTemplateUserDecisions() {
    var clientId = $('[id$=hiddenClientId]').val();
    if (clientId) {    
        var $acceptedTemplates = $('[id$=chkRowHMTemplate][data-UserDecision="Y"]');
        var $rejectedTemplates = $('[id$=chkRowHMTemplate][data-UserDecision="N"]');

        var acceptedKeys = getElementsAttributeValueList($acceptedTemplates, 'data-PrimaryKeyList');
        var rejectedKeys = getElementsAttributeValueList($rejectedTemplates, 'data-PrimaryKeyList');
        
        if (acceptedKeys || rejectedKeys) {
            PopupProcessing();
            $.ajax({
            type: "GET",
            timeout: 60000,
            cache: false,
                url: GetRelativePath() + "GenericHandlers/HealthMaintenance.ashx?AjaxAction=saveHMTemplateUserDecisions",
                data: { AcceptedKeys: acceptedKeys, RejectedKeys: rejectedKeys, ClientId: clientId },
                success: function(result) {
                    saveHMTemplateUserDecisionsCallback(result)
                }
            });
        }
        else {
            $('#spanDecisionMessage').text("Accept / Reject atleast one template");
            $('#spanDecisionMessage').css('color', "red");
        }
    }

}

function saveHMTemplateUserDecisionsCallback(result) {
    HidePopupProcessing();
    if (result) {
        $('[id$=chkRowHMTemplate][data-UserDecision="Y"]').parents('tr').remove();
        $('[id$=chkRowHMTemplate][data-UserDecision="N"]').parents('tr').remove();
        $('#spanDecisionMessage').text("Saved successfully");
        $('#spanDecisionMessage').css('color', "green");

        $('[id$=hiddenAlertCount]').val(result);
        parent.setHealthMaintenanceAlertlabel(result, true,false);

        if ($('[id$=chkRowHMTemplate]').length == 0) {
            $("#divDataTemplate").hide();
            $("#divBlankTemplate").css('display','table');
        }
        
//        setCountTrackLabels();
    }
}

function getElementsAttributeValueList($attrElements, attrName) {
    var retValue = "";
    if ($attrElements.length && attrName) {
        $attrElements.each(function(indx, elm) {
            var key = $(elm).attr(attrName);
            if (retValue) {
                retValue += ',' + key
            }
            else {
                retValue = key;
            }
        })
    }
    return retValue;
}

function OpenCLEducationResourceDetails(documentType, educationResourceId, resourceUrl) {
    if (resourceUrl != null && resourceUrl != "")
        window.open(resourceUrl);
}