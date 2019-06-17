//=======(==================================================================================
// Copyright (C) 2010 Streamline Healthcare Solutions Inc.
//
// All rights are reserved. Reproduction or transmission in whole or in part, in
// any form or by any means, electronic, mechanical or otherwise, is prohibited
// without the prior written consent of the copyright owner.
//
// Filename:    ReferralFormSender.js
//
// Author:      Vaibhav Khare
// Date:        22 jun 2011
//=========================================================================================

//Purpose :

//Purpose : This function is called on Page load/refresh
function AddEventHandlers() {
    BindProgramDropDown();
    disableField();
    ShowHide();
}
function disableField() {
    
    $("#DropDownList_CustomDocumentReferrals_ReferralStatus").attr('disabled', true);

}
function bindDropDown() {
  
    return false;

 }

function ShowHide() {
   
    var status = $("#DropDownList_CustomDocumentReferrals_ReferralStatus option:selected").text().toLowerCase();

    if (status == 'not sent') {
        $('#table_CommentAndAction').hide();
        $("#Img_RequestDate").attr('disabled', false);
        //  $("#DropDownList_CustomDocumentReferrals_ReferralStatus").attr('disabled', false);
        //$("#DropDownList_CustomDocumentReferrals_ReferralStatus").attr('disabled', false);
       
        $("#DropDownList_CustomDocumentReferrals_ReferringStaff").attr('disabled', false);
        $("#TextArea_CustomDocumentReferrals_AssessedNeedForReferral").attr('disabled', false);
        $("#DropDownList_CustomDocumentReferralServices_AuthorizationCodeId").attr('disabled', false);
        $("#ButtonInsert").attr('disabled', false);
        $("#ButtonInsertDummy").attr('disabled', false);
        $("#ButtonInsertDummy").hide();
        $("#ButtonInsert").show();
        $("#CheckBox_CustomDocumentReferrals_ClientParticpatedWithReferral").attr('disabled', false);
        $("#CheckBox_CustomDocumentReferrals_RemoveClientFromCaseLoad").attr('disabled', false);
        $("#DropDownList_CustomDocumentReferrals_ReceivingStaff").attr('disabled', false);
        $("#DropDownList_CustomDocumentReferrals_ReceivingProgram").attr('disabled', false);
        $("#CustomGrid_GridViewInsert").attr('disabled', false);
        $("#ContactButonDelete").attr('disabled', false);
        $('#ContactButonDelete', $("table[id$=CustomGrid_GridViewInsert]")).each(function(item, index) {

            $(this).attr("disabled", false);

        });
    } else if (status == 'sent') {
        $("#Img_RequestDate").attr('disabled', true);
        $('#table_CommentAndAction').hide();
        // $("#DropDownList_CustomDocumentReferrals_ReferralStatus").attr('disabled', true);
        $("#DropDownList_CustomDocumentReferrals_ReferringStaff").attr('disabled', true);
        $("#TextArea_CustomDocumentReferrals_AssessedNeedForReferral").attr('disabled', true);
        $("#DropDownList_CustomDocumentReferralServices_AuthorizationCodeId").attr('disabled', true);
        $("#ButtonInsertDummy").attr('disabled', true);
        $("#ButtonInsertDummy").show();
        $("#ButtonInsert").hide();
        $("#CheckBox_CustomDocumentReferrals_ClientParticpatedWithReferral").attr('disabled', true);
        $("#CheckBox_CustomDocumentReferrals_RemoveClientFromCaseLoad").attr('disabled', true);
        $("#CustomGrid_GridViewInsert").attr('disabled', true);
        $("#DropDownList_CustomDocumentReferrals_ReceivingStaff").attr('disabled', false);
        $("#DropDownList_CustomDocumentReferrals_ReceivingProgram").attr('disabled', false);
        $("#ContactButonDelete").attr('disabled', true);
        $('#table_CommentAndAction').show();

        $('[id$=table_CommentAndAction] ').show();
        $('#table_CommentAndAction').show();
        $('#ContactButonDelete', $("table[id$=CustomGrid_GridViewInsert]")).each(function(item, index) {

            $(this).attr('disabled', true);

        });

    } else {
        $("#Img_RequestDate").attr('disabled', true);

        // $("#DropDownList_CustomDocumentReferrals_ReferralStatus").attr('disabled', true);
        $("#DropDownList_CustomDocumentReferrals_ReferringStaff").attr('disabled', true);
        $("#TextArea_CustomDocumentReferrals_AssessedNeedForReferral").attr('disabled', true);
        $("#DropDownList_CustomDocumentReferralServices_AuthorizationCodeId").attr('disabled', true);
        $("#ButtonInsertDummy").attr('disabled', true);
        $("#ButtonInsertDummy").show();
        $("#ButtonInsert").hide();
        $("#CheckBox_CustomDocumentReferrals_ClientParticpatedWithReferral").attr('disabled', true);
        $("#CheckBox_CustomDocumentReferrals_RemoveClientFromCaseLoad").attr('disabled', true);
        $("#TextArea_CustomDocumentTransfers_ReceivingComment").attr('disabled', true);
        $("#DropDownList_CustomDocumentTransfers_ReceivingAction").attr('disabled', true);
        $("#DropDownList_CustomDocumentReferrals_ReceivingStaff").attr('disabled', true);
        $("#DropDownList_CustomDocumentReferrals_ReceivingProgram").attr('disabled', true);
        $('#ContactButonDelete', $("table[id$=CustomGrid_GridViewInsert]")).each(function(item, index) {

            $(this).attr("disabled", true);

        });
        $('#table_CommentAndAction').show();
    
    
    }
}

function BindProgramDropDown() {
    // var status = $("Span_DocumentInformation_Status").text();

    var StaffId = $("#DropDownList_CustomDocumentReferrals_ReceivingStaff").val();
    var strDatasource;
    $.ajax({
        type: "POST",
        url: "../AjaxScript.aspx?functionName=FillDropDownCascading",
        data: "staffId=" + StaffId,
        async: false,
        success: function(result) {
                strDatasource = result;
        }
    });

    addDropDownValue(strDatasource);
    var txtVal = $("#TextBox_CustomDocumentReferrals_ReceivingProgram").val();
   
    if (txtVal != "" && txtVal != "-1") {
        
        $("#DropDownList_CustomDocumentReferrals_ReceivingProgram").val(txtVal);
    }
  //  var strHidden = $("#hiddenProgramList").val();
    //$("#DropDownList_CustomDocumentReferrals_ReceivingProgram").children().remove();
   
    //$("DropDownList_CustomDocumentReferrals_ReceivingProgram")[0].options.length = 0; 
  //  var arr = strHidden.split("||");
  //  var counter = arr.length;


  //  $('#DropDownList_CustomDocumentReferrals_ReceivingProgram').each(function(i, option) { $(option).remove(); });

 
//        for (var i = 0; i < counter - 1; i++) {

//            var opt = document.createElement("option");

//            var stafprogamId = arr[i].split(",");

//            var staffIdarray = stafprogamId[1].split("~");

//            // Add an Option object to Drop Down/List Box
//            if (StaffId == staffIdarray[0]) {

//                document.getElementById("DropDownList_CustomDocumentReferrals_ReceivingProgram").options.add(opt);        // Assign text and value to Option object
//                opt.text = stafprogamId[0]; //
//                opt.value = staffIdarray[1];
//               
//            }
//          
//           // if (txtVal != "") {
//           //     document.getElementById("DropDownList_CustomDocumentReferrals_ReceivingProgram").val(txtVal);
//           // }

//        }
      
       

       // var author = $("#DropDownList_DocumentInformation_AuthorList option:selected").val();
       // $("#DropDownList_CustomDocumentReferrals_ReferringStaff").val(author);
    }
//    function pageLoad(sender, args) {
//       
//        if (args.get_isPartialLoad()) {
//            alert("partial");

//        } else {
//        alert("my");
//        }
//    }

   
    function SetValue() {
        var stafprogamId = $("#DropDownList_CustomDocumentReferrals_ReceivingProgram").val();
       
        if (stafprogamId != null && stafprogamId!=-1) {
            $("#TextBox_CustomDocumentReferrals_ReceivingProgram").val(stafprogamId);
        } else {
        //$("#TextBox_CustomDocumentReferrals_ReceivingProgram").val('-1');
        }

    }
    function addDropDownValue(result) {
        $("#DropDownList_CustomDocumentReferrals_ReceivingProgram").children().remove();
                // Assign text and value to Option object
      
        if (result != null || result != '') {
            if (result.xml != null || result.xml != '') {

                var opt1 = document.createElement("option");
                document.getElementById("DropDownList_CustomDocumentReferrals_ReceivingProgram").options.add(opt1);
                opt1.text = ''; //
                opt1.value = -1;
                $.xmlDOM(result.xml).find("StaffProgram").each(function() {
                  //  $("<option value=" + this.childNodes[1].text + ">" + this.childNodes[0].text + "</option>").appendTo("[id$=DropDownList_Staff_DefaultMultiStaffViewId]");
                var opt = document.createElement("option");
                    document.getElementById("DropDownList_CustomDocumentReferrals_ReceivingProgram").options.add(opt);
                    opt.text = this.childNodes[0].text; //
                    opt.value = this.childNodes[1].text;
                });
            }
        }
        SetValue();
    }


    function ValidateCustomPageEventHandler() {

        if ($("#DropDownList_CustomDocumentReferrals_ReceivingStaff").val() == '-1') {
            ShowHideErrorMessage("Please select Receiving Staff.", 'true');
            return false;
        }
        
        if ($("#DropDownList_CustomDocumentReferrals_ReceivingProgram").val() == '-1') {
            ShowHideErrorMessage("Please select Receiving Program.", 'true');
            return false;
        }
    }



    function ValidateDataForParentChildGridEventHandler() {
       
        try {
            var _ServiceName = $("[id$=DropDownList_CustomDocumentReferralServices_AuthorizationCodeId]").val();
           
            if (_ServiceName == null || _ServiceName == '' || parseInt(_ServiceName)==-1) {
                ShowHideErrorMessage(" Please select service", 'true');
                $("[id$=DropDownList_CustomDocumentReferralServices_AuthorizationCodeId]").focus();
                return false;
            }
            else {
                return true;
            }
        }

        catch (err) {
            LogClientSideException(err);
        }
    }