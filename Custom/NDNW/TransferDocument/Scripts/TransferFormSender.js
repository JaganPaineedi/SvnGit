//=======(==================================================================================
// Copyright (C) 2010 Streamline Healthcare Solutions Inc.
//
// All rights are reserved. Reproduction or transmission in whole or in part, in
// any form or by any means, electronic, mechanical or otherwise, is prohibited
// without the prior written consent of the copyright owner.
//
// Filename:    transferFromSender.js
//
// Author:      Vaibhav Khare
// Date:        22 jun 2011
//=========================================================================================

//Purpose :

//Purpose : This function is called on Page load/refresh
function AddEventHandlers() {
    BindProgramDropDown();
    ShowHide();
}


function ShowHide() {
    var status = $("[Id$=DropDownList_CustomDocumentTransfers_TransferStatus] :selected")[0].innerHTML;

    if (status == 'Complete') {
        $("[id$=DropDownList_CustomDocumentTransfers_TransferringStaff]").attr('disabled', true);
        $("[id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]").attr('disabled', true);
        // $("[id$=DropDownList_CustomDocumentTransfers_TransferStatus]").attr('disabled', true);
    }

    if (status == 'Not Sent') {
        $("[id$=DropDownList_CustomDocumentTransfers_TransferringStaff]").attr('disabled', false);
        $("[id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]").attr('disabled', false);
    }

    if (status == 'Sent') {
        $("[id$=DropDownList_CustomDocumentTransfers_TransferringStaff]").attr('disabled', false);
        $("[id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]").attr('disabled', false);
    }

    $("#Img_RequestDate").attr('disabled', false);
    $("[Id$=DropDownList_CustomDocumentTransfers_TransferringStaff]").attr('disabled', false);
    $("#TextArea_CustomDocumentTransfers_AssessedNeedForTransfer").attr('disabled', false);
    $("[Id$=DropDownList_CustomTransferServices_AuthorizationCodeId]").attr('disabled', false);
    $("#CheckBox_CustomDocumentTransfers_ClientParticpatedWithTransfer").attr('disabled', false);
    $("[Id$=DropDownList_CustomDocumentTransfers_ReceivingStaff]").attr('disabled', false);
    $("[Id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]").attr('disabled', false);
    $('#ContactButonDelete', $("table[id$=CustomGrid_GridViewInsert]")).each(function (item, index) {

        $(this).attr("disabled", false);

    });

    if (status == 'Not Sent') {
        $('#table_CommentAndAction').hide();
        $("#Img_RequestDate").attr('disabled', false);
        $("#DropDownList_CustomDocumentTransfers_TransferringStaff").attr('disabled', false);
        $("#TextArea_CustomDocumentTransfers_AssessedNeedForTransfer").attr('disabled', false);
        $("#DropDownList_CustomTransferServices_AuthorizationCodeId").attr('disabled', false);
        $("#ButtonInsert").attr('disabled', false);
        $("#ButtonInsertDummy").attr('disabled', false);
        $("#ButtonInsertDummy").hide();
        $("#ButtonInsert").show();
        $("#CheckBox_CustomDocumentTransfers_ClientParticpatedWithTransfer").attr('disabled', false);
        $("#DropDownList_CustomDocumentTransfers_ReceivingStaff").attr('disabled', false);
        $("[Id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]").attr('disabled', false);
        $("#CustomGrid_GridViewInsert").attr('disabled', false);
        $("#ContactButonDelete").attr('disabled', false);
    } else if (status == 'Sent') {
        $("#Img_RequestDate").attr('disabled', true);
        $("[Id$=DropDownList_CustomDocumentTransfers_TransferringStaff]").attr('disabled', true);
        $("#TextArea_CustomDocumentTransfers_AssessedNeedForTransfer").attr('disabled', true);
        $("[Id$=DropDownList_CustomTransferServices_AuthorizationCodeId]").attr('disabled', true);
        $("#TextBox_CustomDocumentTransfers_ReceivingActionDate").attr('disabled', true);
        $("#ButtonInsertDummy").attr('disabled', true);
        $("#ButtonInsertDummy").show();
        $("#ButtonInsert").hide();
        $("#CheckBox_CustomDocumentTransfers_ClientParticpatedWithTransfer").attr('disabled', true);
        $('#table_CommentAndAction').show();
        $("#CustomGrid_GridViewInsert").attr('disabled', true);
        $("#ContactButonDelete").attr('disabled', true);
        $('#ContactButonDelete', $("table[id$=CustomGrid_GridViewInsert]")).each(function (item, index) {

            $(this).attr('disabled', true);

        });
    } else {
        $("#Img_RequestDate").attr('disabled', true);
        $("[Id$=DropDownList_CustomDocumentTransfers_TransferringStaff]").attr('disabled', true);
        $("#TextArea_CustomDocumentTransfers_AssessedNeedForTransfer").attr('disabled', true);
        $("[Id$=DropDownList_CustomTransferServices_AuthorizationCodeId]").attr('disabled', true);
        $("#ButtonInsertDummy").attr('disabled', true);
        $("#ButtonInsertDummy").show();
        $("#ButtonInsert").hide();
        $("#CheckBox_CustomDocumentTransfers_ClientParticpatedWithTransfer").attr('disabled', true);
        $("#TextArea_CustomDocumentTransfers_ReceivingComment").attr('disabled', true);
        $("[Id$=DropDownList_CustomDocumentTransfers_ReceivingAction]").attr('disabled', true);
        $("[Id$=DropDownList_CustomDocumentTransfers_ReceivingStaff]").attr('disabled', true);
        $("[Id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]").attr('disabled', true);

        $('#table_CommentAndAction').show();
        $('#ContactButonDelete', $("table[id$=CustomGrid_GridViewInsert]")).each(function (item, index) {

            $(this).attr("disabled", true);

        });

    }
    $("[Id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]").val($("CustomDocumentTransfers>ReceivingProgram", AutoSaveXMLDom[0]).text());
}

function SetValue() {
  
}

function BindProgramDropDown() {
    var StaffId = $("[Id$=DropDownList_CustomDocumentTransfers_ReceivingStaff]").val();
    var strDatasource;
    $.ajax({
        type: "POST",
        url: "../AjaxScript.aspx?functionName=FillDropDownCascading",
        data: "staffId=" + StaffId,
        async: false,
        success: function (result) {
            strDatasource = result;
        }
    });

    addDropDownValue(strDatasource);
    UpdateAutoSaveXmlNode("CustomDocumentDiagnosticAssessments", "ReceivingProgram", "");
}


function addDropDownValue(result) {
    $("[Id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]").empty();
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $('[id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]').empty();
            $('<option></option>').val('').text('').appendTo('[id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]');
            $.xmlDOM(result.xml).find("StaffProgram").each(function () {
                $('<option></option>').val(this.childNodes[1].text).text(this.childNodes[0].text).appendTo('[id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]');
            });
        } else {
            $('<option></option>').val("").text().appendTo('[id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]');
        }
    }
}

function ValidateCustomPageEventHandler() {

    if ($("[Id$=DropDownList_CustomDocumentTransfers_ReceivingStaff]").val() == '-1') {
        ShowHideErrorMessage("Please select Receiving Staff.", 'true');
        return false;
    }

    if ($("[Id$=DropDownList_CustomDocumentTransfers_ReceivingProgram]").val() == '-1') {
        ShowHideErrorMessage("Please select Receiving Program.", 'true');
        return false;
    }
}


function ValidateDataForParentChildGridEventHandler() {
    try {
        var _ServiceName = $("[Id$=DropDownList_CustomTransferServices_AuthorizationCodeId]").val();
        if (_ServiceName == null || _ServiceName == '' || parseInt(_ServiceName) == -1) {
            ShowHideErrorMessage(" Please select service", 'true');
            $("[Id$=DropDownList_CustomTransferServices_AuthorizationCodeId]").focus();
            return false;
        }
        else {
            var counter = 0;
            var trobject = $('tr .dxgvDataRow[id*=CustomGrid_GridViewInsert_DXDataRow]');
            trobject.each(function () {
                if ($(this).children().eq(11)[0].innerText != "") {
                    if (parseInt($(this).children().eq(11)[0].innerText) == parseInt(_ServiceName)) {
                        counter++;
                    }
                }
            });

            if (parseInt(counter) > 0) {
                $("[Id$=DropDownList_CustomTransferServices_AuthorizationCodeId]").val('');
                ShowHideErrorMessage('Service already exists.', 'true');
                return false;
            }

            ShowHideErrorMessage('Service already exists.', 'false');
            return true;
        }
    }

    catch (err) {
        LogClientSideException(err);
    }
}
function AddEventHandlerAfterInsertGrid() {
    $("[Id$=DropDownList_CustomTransferServices_AuthorizationCodeId]").val('');
}