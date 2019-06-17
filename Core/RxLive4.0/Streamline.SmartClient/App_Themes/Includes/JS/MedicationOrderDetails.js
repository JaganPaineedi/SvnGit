function fnHideParentDiv() {
    try {
        var objdvProgress = document.getElementById('dvProgress1');
        if (objdvProgress != null)
            objdvProgress.style.display = 'none';
    }
    catch (Exception) {
        alert(Exception.message);
        ShowError(Exception.description, true);
    }
}

function EnableDisablePrintButton(objectMedicationScriptId, objectPrintButton, PrintPermission) {
    try {
        CommonFunctions.ShowWarning('', false);
       ShowError('',false);  
      
     
       var TextBoxMedicationScriptId=document.getElementById(objectMedicationScriptId);
       var ClientMedicationScriptId=TextBoxMedicationScriptId.value;
     
        if (ClientMedicationScriptId == "" || ClientMedicationScriptId == null || ClientMedicationScriptId.charAt(0) == ' ') {
            document.getElementById(objectPrintButton).disabled=true;
            return true;  
       }      
        else {
                //Condition added By pramod as PrintButton must be enable or disable according to permission
            if (PrintPermission != 'Disabled') {
                    document.getElementById(objectPrintButton).disabled=false;
                }
            return true;  
      }
 }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
 }
return false;

}


function ShowPrintOrderDialog(objectMedicationScriptId, objectMedicationOrderMethod, objectMedicationOrderStatus) {
    try {
        CommonFunctions.ShowWarning('', false);
        ShowError('', false);
        var TextBoxMedicationScriptId = document.getElementById(objectMedicationScriptId);
        var ClientMedicationScriptId = TextBoxMedicationScriptId.value;
        var ScriptOrderingMethod = document.getElementById(objectMedicationOrderMethod).value;
        var MedicationOrderStatus = document.getElementById(objectMedicationOrderStatus).value;

        //var MedicationId=document.getElementById(TextBoxMedicationId).value;

        if (ClientMedicationScriptId == "" || ClientMedicationScriptId == null || ClientMedicationScriptId.charAt(0) == ' ') {
            CommonFunctions.ShowWarning('No Script History Found for this Medication', true);
            return false;
        }

        var context = new Object();
        context.ClientMedicationScriptId = ClientMedicationScriptId;
        context.ScriptOrderingMethod = ScriptOrderingMethod;
        context.MedicationOrderStatus = MedicationOrderStatus;
        Streamline.SmartClient.WebServices.ClientMedications.CheckSessionExpiration(onSuccessShowPrintOrderDialog, onFailure, context);

    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}


function onSuccessShowPrintOrderDialog(result, context) {
    try {
        fnShow();
        ClientMedicationScriptId = context.ClientMedicationScriptId;
        ScriptOrderingMethod = context.ScriptOrderingMethod;
        var MedicationOrderStatus = context.MedicationOrderStatus;
        var datetime = new Date();
        var $divSearch = $("#DivSearch");
        $("#topborder", $divSearch).text("Print Medication Order");
        var $iFrameSearch = $('#iFrameSearch', $divSearch);
        $iFrameSearch.attr('src', 'MedicationPrintOrderDialog1.aspx?ClientMedicationScriptId=' + ClientMedicationScriptId + "&OrderingMethod=" + ScriptOrderingMethod + "&datetime=" + datetime.getMinutes() + datetime.getSeconds() + "&MedicationOrderStatus=" + MedicationOrderStatus);
        $iFrameSearch.css({ 'width': '750px', 'height': '380px' });
        var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
        left = left > 0 ? left : 10;
        var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
        top = top > 0 ? top : 10;
        $divSearch.css({ 'top': top, 'left': left });
        $divSearch.draggable();
        $divSearch.css('display', 'block');
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}

function EnableDisableObjects(CheckBoxDiscontinuedId, TextBoxDiscontinueReasonID, TextBoxPermission) {
   var CheckBoxDiscontinued=document.getElementById(CheckBoxDiscontinuedId);
   var TextBoxDiscontinueReason=document.getElementById(TextBoxDiscontinueReasonID);

  
    if ((CheckBoxDiscontinued.checked == true) && (CheckBoxDiscontinued.disabled == false)) {
     TextBoxDiscontinueReason.disabled=true;
        
     CheckBoxDiscontinued.disabled=true;
   
   }
    else {
         //Added By Pramod On 09 Apr 2008 to enable disable TextBox according to Permission
        if (TextBoxPermission != 'Disabled') {
            TextBoxDiscontinueReason.disabled=false;
         }
   }
   
    
}

function ValidateInputs(TextBoxDiscontinueReasonID, ObjectMedicationId, CheckBoxDiscontinuedId, DropdownDiscontinueReasonCode) {
    try {
        var _TextBoxDiscontinueReason = document.getElementById(TextBoxDiscontinueReasonID);
        var DiscontinueReason = _TextBoxDiscontinueReason.value;
        var ObjectMedication = document.getElementById(ObjectMedicationId);
        var DiscontinueReasonCode = document.getElementById(DropdownDiscontinueReasonCode).value;

        var MedicationId = Number(ObjectMedication.value);

        var CheckBoxDiscontinued = document.getElementById(CheckBoxDiscontinuedId);
        //Vithobha added below code for saving LocationId in ClientMedicationScripts when clicked on Button Queue Order Valley - Customizations #65
        //ObjectMedicationId refers to Locationid
        if ((document.getElementById(ObjectMedicationId).selectedIndex == 0)) {
            ShowError('Please select Prescribing Location', true);
            return false;
        }
        if ($("input[id$=HiddenFieldLocationId]").length > 0) {
            $("input[id$=HiddenFieldLocationId]").val("");
            $("input[id$=HiddenFieldLocationId]").val(ObjectMedication.value);
        }
        if ((CheckBoxDiscontinued.checked == true) && (CheckBoxDiscontinued.disabled == false)) {
            if (DiscontinueReason == "" || DiscontinueReason == null || DiscontinueReason.charAt(0) == ' ') {
                    ShowError('Please enter Discontinue Reason',true); 
                    return false;  
                } 
            else {
              fnShow();//By Vikas Vyas On Dated April 04th 2008
                ClientMedicationOrder.ShowError('', false);
                Streamline.SmartClient.WebServices.ClientMedications.DiscontinueMedication(MedicationId, 0, DiscontinueReason, 'Y', DiscontinueReasonCode, MedicationOrderDetails.onSuccessfullDeletion, MedicationOrderDetails.onFailure, e);
              
               }      
           
           }
        else {
             return true;
           }
          
     
            
    }
   
    catch (e) {
           Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
       }   
   


}

var MedicationOrderDetails = {
    onSuccessfullDeletion: function (result, context, methodname) {
        try {
           EnableDisable();
           fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008 
       }
        catch (e) {
             Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
       } 
   
    },
    onFailure: function (error) {
        try {
      fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
      //Added by Chandan for task#122 1.7 - Error Dialog on Session Timeout  
            if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
        location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
    }
            else {
        alert(error.get_message());
    }
    }
        catch (e) {
             Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }  
 }

}
//Sort Expression (Get from Hidden Field in TabPanelClaims div)
function SortExpression(HiddenObjectAscDescClientScriptHistory) {
    try {
       ShowError('',false); 
       var AscDesc = document.getElementById(HiddenObjectAscDescClientScriptHistory).value;
        if (AscDesc == "ASC") {
           document.getElementById(HiddenObjectAscDescClientScriptHistory).value="DESC";
        }
        else {
            document.getElementById(HiddenObjectAscDescClientScriptHistory).value="ASC";
        }
    }
    catch (ex) {
       
    }
}




function SortScriptHistoryHtml(ShortField, HiddenObjectAscDescClientScriptHistory, ShowHidePillImage) {
    try {
      
       fnShow();//By Vikas Vyas On Dated April 04th 2008
        var context = new Object();
        context.GridObject= document.getElementById('DivClientScriptHistory');
        var stringAscDesc= document.getElementById(HiddenObjectAscDescClientScriptHistory).value;
       
        SortExpression(HiddenObjectAscDescClientScriptHistory);
        
        Streamline.SmartClient.WebServices.ClientMedications.SortGridViewClientScriptHistory(stringAscDesc, ShortField, ShowHidePillImage,onSuccessfullFillScriptHistory, onFailure, context)
    }
    catch (ex) {
       
    }


}
//Changes by Sonia
//A new Parameter ScriptId added by Sonia as OrderDetails should be get both according to ClientMedicationId as well as ScriptId
function FillGridScriptHistoryHTML(HiddenClientMedicationId, HiddenClientMedicationScriptId, ShowHidePillImage) {
    try {
        fnShow();//By Vikas Vyas On Dated April 04th 2008
        var HiddenClientMedicationObject=document.getElementById(HiddenClientMedicationId);
        
        var context = new Object();
        context.GridObject= document.getElementById('DivClientScriptHistory');
        //Changes by Sonia
        //A new Parameter ScriptId send in call to web Service as OrderDetails should be get both according to ClientMedicationId as well as ScriptId
        var HiddenClientMedicationScriptObject=document.getElementById(HiddenClientMedicationScriptId);
        Streamline.SmartClient.WebServices.ClientMedications.FillGridScriptHistoryHtml(HiddenClientMedicationObject.value, HiddenClientMedicationScriptObject.value, ShowHidePillImage,onSuccessfullFillScriptHistory, onFailure, context);
  

   }
    catch (ex) {
   
   }

}

//On SuccessFul Sort
function onSuccessfullSort(result, context, methodname) {
    try {
        var GridObject= context.GridObject;      
        GridObject.innerHTML=result; 
        fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008 
      }
    catch (Err) {
          alert(Err.message);
       }
   
 }


//onSuccessfullFillScriptHistory
function onSuccessfullFillScriptHistory(result, context, methodname) {
    try {
        var GridObject= context.GridObject;      
        GridObject.outerHTML=result;
       // GridObject.innerHTML=result; 
        fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
      }
    catch (Err) {
          alert(Err.message);
       }
   
 }

 
function onFailure(error) {
    fnHideParentDiv();//By Vikas Vyas On Dated April 04th 2008
    //Added by Chandan for task#122 1.7 - Error Dialog on Session Timeout  
    if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
        location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
    }
    else {
        alert(error.get_message());
    }
          
 }
 

function ShowMedicationViewHistoryDiv() {
    try {
      
        ShowError('',false);
        fnShow();//By Vikas Vyas On Dated April 04th 2008
        var DivSearch=parent.document.getElementById('DivSearch');
        DivSearch.style.display='block';
        var iFrameSearch=parent.document.getElementById('iFrameSearch');
       iFrameSearch.src= 'ViewMedicationHistory.aspx';
       iFrameSearch.style.positions='absolute';
       iFrameSearch.style.left='0px';
       iFrameSearch.style.width=1015;
       iFrameSearch.style.height=window.screen.height;
       iFrameSearch.style.top='0px';      
 
        iFrameSearch.style.display='block';
        DivSearch.style.left=2;
        
        
    }
    catch (e) {
             Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
       }
    return false;
}
//Description:Used to send request to webservice to save PermitChangesByOtherUsers as per task#31
//Author:Pradeep Created On 25 Nov 2009 
function SavePermitChangesByOtherUsers() {
    try {
   var ObjectMedication=document.getElementById('Control_ASP.usercontrols_medicationorderdetails_ascx_HiddenFieldClientMedicationId');
   var MedicationId=Number(ObjectMedication.value);
//   var checkBoxPermitChangesByOtherUsers=document.getElementById('Control_ASP.usercontrols_medicationorderdetails_ascx_Heading1_CheckBoxPermitChanges');
var checkBoxPermitChangesByOtherUsers=document.getElementById('Control_ASP.usercontrols_medicationorderdetails_ascx_CheckBoxPermitChanges');
   var permitChangesByOtherUsersValue='Y';
        if ((checkBoxPermitChangesByOtherUsers.disabled == false)) {
            if (checkBoxPermitChangesByOtherUsers.checked == true) {
         permitChangesByOtherUsersValue='Y';
        }
            else {
          permitChangesByOtherUsersValue='N';
        }
            Streamline.SmartClient.WebServices.ClientMedications.SavePermitChangesByOtherUsers(MedicationId, permitChangesByOtherUsersValue, MedicationOrderDetails.onSuccessfullDeletion, MedicationOrderDetails.onFailure, e);
   }
  }
    catch (e) {
   Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
  }
}
function onSuccessfullUpdation(result, context, methodname) {
    try {
          
          
       }
    catch (e) {
             Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
       } 
   
 }



