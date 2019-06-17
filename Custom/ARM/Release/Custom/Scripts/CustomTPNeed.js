var initiallySelectedCheckbox = null;
var newNeedAdded = '';
var sortOrder = 'asc';
function AddEventHandlers() {
    var GoalId = 0;

    //Commented by Davinder Kumar 01-06-2011
    // To insert The the Needs in CustomTPNeed Table on Click on Add Need button
    $('input#button_CustomTPNeed_Insert').unbind('click');
    $('input#button_CustomTPNeed_Insert').bind('click', function() {

        var NeedText = $.trim($('[id$=_TextArea_CustomTPNeed_NeedText]').val());
        if (NeedText.trim() != "") {
            ShowMsgBox('Documentation indicating when/where/how this need was identified must exist in the clinical record.', 'Confirmation Message', MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'AddNeedSelectOk(\'' + encodeText(NeedText) + '\');');
        }
    });


    //Commented by Davinder Kumar 03-06-2011
    // To insert The the value in CustomTPGoalNeed table and retriev the date to be planned from that corresponding row
    $('input#button_Ok').unbind('click');
    $('input#button_Ok').bind('click', function() {

        var Needstring = "";
        var Check = "";
        $('table.dxgvTable input[type=checkbox]').each(function() {
            Check = ($(this).attr('checked')) ? "T" : "F";
            var NeedId = decodeText($(this).attr('id'));
            var NeedText = '';
            //NeedText = $('table.dxgvTable [for=' + NeedId + '] > span').html();
            //alert(NeedText);
            NeedId = NeedId.split('_');

            NeedText = $("#Hidden_" + NeedId[1] + "").val();
            Needstring += NeedId[1] + "^" + encodeText(NeedText) + "^" + Check + "#$#";
        });
        if (Needstring.length > 2)
            Needstring = Needstring.substring(0, Needstring.length - 3);
        GoalId = $("[id$=_HiddenField_TPGoalId]").val();
        $.ajax({
            type: "POST",
            url: "../ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx",
            data: "action=adddateneedtobeplan&Needstring=" + Needstring + "&GoalId=" + GoalId,
            success: function(Jvalue) {

                onHarborTPDateNeed(Jvalue);

            }
        });
    });
}

function SetValueOnTxPlanMain(returnValue) {

    if (returnValue != undefined) {
        //Dirty = 'True';
        parent.CreateUnsavedInstanceOnDatasetChange();
        $("[id$=PanelTxPlanMain]")[0].innerHTML = null;
        //$("#PanelTxPlanMain")[0].outerHTML = returnValue;
        $("[id$=PanelTxPlanMain]")[0].outerHTML = returnValue;
    }
}

function onHarborTPDateNeed(result) {
    try {
        var pageResponse = result;

        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        //if (pageResponse != undefined) {
        //parent.CreateUnsavedInstanceOnDatasetChange();
        parent.SetValueOnTxPlanMain(pageResponse);
        parent.CloaseModalPopupWindow();
        /*window.returnValue = pageResponse; //Assign the Parsed HTML
        Dirty = 'True';
        window.close();*/
        //}
    }
    catch (err) {
        LogClientSideException(err, 'HarborTreatmetPlan'); //Code added by Devinder
    }
}

function AddNeedSelectOk(NeedText) {
    //alert('in');
    var ScreenFilter = objectPageResponse.CustomScreenFilters;
    var startIndex = objectPageResponse.CustomScreenFilters.indexOf('<tpgoalid>');
    var endIndex = objectPageResponse.CustomScreenFilters.indexOf('</tpgoalid>');
    GoalId = ScreenFilter.substring(startIndex + 10, endIndex);
    //ScreenFilter is coming with CData For Removing fatching SubString
    GoalId = GoalId.substr(9, GoalId.length - 12)
    initiallySelectedCheckbox = new Array();
    $('table.dxgvTable input[type=checkbox]').each(function() {
        Check = ($(this).attr('checked')) ? "T" : "F";
        var NeedId = decodeText($(this).attr('id'));

        NeedId = NeedId.split('_')[1];


        initiallySelectedCheckbox.push(NeedId + ';' + Check);



    });
    
    if (NeedText != "") {
        $.ajax({
            type: "POST",
            url: "../ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx",
            data: 'action=addassociateneed&NeedText=' + NeedText + "&GoalId=" + GoalId,
            success: function(Jvalue) {
                // parent.CreateUnsavedChangesInstance();
                parent.CreateUnsavedInstanceOnDatasetChange();
                $('[id$=_TextArea_CustomTPNeed_NeedText]').val("");
                var pageResponse = Jvalue;
                var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE3##") + 27;
                var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE3##");
                var GridHtml = RemoveDevXString(pageResponse.substr(start, end - start));
                $("td#divAssoiateNeed").html(GridHtml);

                for (var i = 0; i < initiallySelectedCheckbox.length; i++) {
                    var check = initiallySelectedCheckbox[i].split(';');
                    var checkboxChecked = false;
                    if (check[1] == "T")
                        checkboxChecked = true;
                    $("td#divAssoiateNeed input[type=checkbox][id$=CheckBox_" + check[0] + "").attr('checked', checkboxChecked);
                    if (checkboxChecked == true)
                        $("td#divAssoiateNeed img[id$=Img_CustomTPGoalNeeds_" + check[0] + "").css('display', 'none');
                    else
                        $("td#divAssoiateNeed img[id$=Img_CustomTPGoalNeeds_" + check[0] + "").css('display', 'block');
                }

                if ($('td#divAssoiateNeed input[type=checkbox][newNeed=Y]').length > 0) {
                    newNeedAdded += $('td#divAssoiateNeed input[type=checkbox][newNeed=Y]')[0].id.split('_')[1] + ',';
                }



            }
        });
    }
    return false;
}

//Author : Rohit Katoch
//To show and hide the image along with the checkbox
//Created on : 25 July 2011
function ChangeDisplayChecked(DeleteImageTPNeedsId, CheckBoxTPGoalsId) {
    var DeleteImageTPNeeds = $('#' + DeleteImageTPNeedsId + '');
    if (DeleteImageTPNeeds.length > 0) {
        var CheckBoxTPGoals = $('input[type=checkbox][id*=' + CheckBoxTPGoalsId + ']');
        if (CheckBoxTPGoals.length > 0) {
            if (CheckBoxTPGoals.is(':checked')) {
                DeleteImageTPNeeds.css('display', 'none');
            }
            else {
                DeleteImageTPNeeds.css('display', 'block');
            }
        }
    }
}

//Author: Rohit Katoch
//Confirmation to delete any of the custom Tp Needs
//Created on : 25 July 2011
function DeleteTpGoalNeeds(NeedId, LinkedInDb, LinkedInSession) {
    var associatedNeedList = $('[id$=HiddenSessionNeeds_' + NeedId + ']').val();
    var calledFromGoalId = $('[id$=HiddenField_TPGoalId]').val();

    var askForDeletionMessage = 1;
    if (associatedNeedList != '') {
        var strSplitAssociatedNeeds = associatedNeedList.split(',');

        for (var i = 0; i < strSplitAssociatedNeeds[i].length; i++) {
            if (calledFromGoalId == strSplitAssociatedNeeds[i]) {
                if (strSplitAssociatedNeeds.length == 2) {
                    askForDeletionMessage = 0;
                }
                else {
                    askForDeletionMessage = 2;
                }
                break;
            }
        }
    }
    else {
        askForDeletionMessage = 0;
    }
    if (LinkedInDb.trim() == 'Y') {
        ShowMsgBox('Need can not be deleted as it is associated in another Treatment Plan.', 'Information', MessageBoxButton.OK, MessageBoxIcon.Information);
    }
    else if (LinkedInSession == 'Y') {
        if (askForDeletionMessage > 0)
            ShowMsgBox('Need can not be deleted as it is associated in another Goal of this Treatment Plan.', 'Information', MessageBoxButton.OK, MessageBoxIcon.Information);
        //ShowMsgBox('Are you sure to delete the Treatment Plan Need. Another associations in the Goal will also be removed?', 'Confirmation Message', MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'DeleteTpGoalNeedsOk(\'' + encodeText(NeedId) + '\')', "");
        else {
            ShowMsgBox('Are you sure to delete the Treatment Plan Need?', 'Confirmation Message', MessageBoxButton.YesNo, MessageBoxIcon.Question, 'DeleteTpGoalNeedsOk(\'' + encodeText(NeedId) + '\')', "");
        }

    }
    else {
        ShowMsgBox('Are you sure to delete the Treatment Plan Need?', 'Confirmation Message', MessageBoxButton.YesNo, MessageBoxIcon.Question, 'DeleteTpGoalNeedsOk(\'' + encodeText(NeedId) + '\')', "");
    }
}

//Author : Rohit Katoch
//Ajsx hit to delete the Custom Tp Needs
//Created on : 25 July 2011
function DeleteTpGoalNeedsOk(NeedId) {
    var TPGoalID = $("[id$=_HiddenField_TPGoalId]").val();
    initiallySelectedCheckbox = new Array();
    $('table.dxgvTable input[type=checkbox]').each(function() {
        Check = ($(this).attr('checked')) ? "T" : "F";
        var NeedId = decodeText($(this).attr('id'));

        NeedId = NeedId.split('_')[1];


        initiallySelectedCheckbox.push(NeedId + ';' + Check);



    });
    $.post(GetRelativePath() + "ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx", 'action=DeleteCustomTPNeeds&NeedId=' + NeedId + '&TPGoalID=' + TPGoalID, function(result) { onSuccessDeleteCustomTPGoals(result); });
}


//Author : Rohit Katoch
//To handle the callback of Deleting Tp Needs
//Created on : 25 July 2011
function onSuccessDeleteCustomTPGoals(Result) {
    //parent.CreateUnsavedChangesInstance();
    parent.CreateUnsavedInstanceOnDatasetChange();
    $('[id$=_TextArea_CustomTPNeed_NeedText]').val("");
    var pageResponse = Result;
    var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE3##") + 26;
    var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE3##");
    var GridHtml = RemoveDevXString(pageResponse.substr(start, end - start));
    $("td#divAssoiateNeed").html(GridHtml);
    for (var i = 0; i < initiallySelectedCheckbox.length; i++) {
        var check = initiallySelectedCheckbox[i].split(';');
        var checkboxChecked = false;
        if (check[1] == "T")
            checkboxChecked = true;
        $("td#divAssoiateNeed input[type=checkbox][id$=CheckBox_" + check[0] + "").attr('checked', checkboxChecked);
        if (checkboxChecked == true)
            $("td#divAssoiateNeed img[id$=Img_CustomTPGoalNeeds_" + check[0] + "").css('display', 'none');
        else
            $("td#divAssoiateNeed img[id$=Img_CustomTPGoalNeeds_" + check[0] + "").css('display', 'block');

    }

    //    if ($('td#divAssoiateNeed input[type=checkbox][newNeed=Y]').length > 0) {
    //        newNeedAdded += $('td#divAssoiateNeed input[type=checkbox][newNeed=Y]')[0].id.split('_')[1] + ',';
    //    }
}


function sortRows(e, selector, isDateTime) {


    var $sort = this;
    //var $table = $('#sort-table');
    var $table = $('table[id$=GridViewCustomTPNeed_DXMainTable]');

    var $rows = $('tr.dxgvDataRow', $table);
    $rows.sort(function(a, b) {
        var keyA = $(selector, a).text();
        var keyB = $(selector, b).text();
        if (isDateTime) {
            keyA = new Date(keyA) != 'NaN' ? new Date(keyA) : new Date('1/1/1972');
            keyB = new Date(keyB) != 'NaN' ? new Date(keyB) : new Date('1/1/1972');
        }
        //if($($sort).hasClass('asc')){
        if (sortOrder == 'asc')
            return (keyA > keyB) ? 1 : -1;
        else
            return (keyA < keyB) ? 1 : -1;
        //} else {
        //    return (keyA < keyB) ? 1 : 0;
        //}
    });
    $.each($rows, function(index, row) {
        if (index % 2 == 0) {
            $(row).removeClass('dxgvDataRowAlt');
            $(row).css({ backgroundColor: '#ffffff' });
        }

        else {
            $(row).addClass('dxgvDataRowAlt');
            $(row).css({ backgroundColor: '#f0f6f9' });
        }
        //$(row).css({borderBottomWidth:'0px'});
        $('td.dxgv', $(row)).attr('style', 'border-right-width: 0px; white-space: nowrap; border-left-width: 0px; border-bottom-width: 0px;');

        $table.append(row);

    });
    //e.preventDefault();
    // $('tr.dxgvDataRow:last', $table).css({backgroundColor: '#f0f6f9'});
    sortOrder = sortOrder == 'asc' ? 'desc' : 'asc';


}


function CheckBeforeClose() {
    if (newNeedAdded.length > 0) {

        $.ajax({
            type: "POST",
            url: "../ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx",
            data: 'action=removenewneeds&needids=' + newNeedAdded,
            success: function(result) {
                //parent.CreateUnsavedInstanceOnDatasetChange();
                //parent.CloaseModalPopupWindow();
                $.ajax({
                    type: "POST",
                    url: "../ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx",
                    data: "action=createtxplan",
                    success: function(Jvalue) {

                        onHarborTPDateNeed(Jvalue);

                    }
                });
            }
        });

    }
    else {
        //parent.CloaseModalPopupWindow();
        $.ajax({
            type: "POST",
            url: "../ActivityPages/Client/Detail/HarborTreatmentPlan/TreatmentPlanHarborAjaxScript.aspx",
            data: "action=createtxplan",
            success: function(Jvalue) {

                onHarborTPDateNeed(Jvalue);

            }
        });
    }
}

