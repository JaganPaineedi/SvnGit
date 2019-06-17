var MedicationIds = new Array();
var TextBoxAddAllergy;
var t;
var PanelMedicationList;
var SignedBy = "";
var OrderName;
var pharmacyId;
//Added By Anuj on 24 Nov,2009 for task ref #3 SDI-Venture 10
var ApprovalStatus = new Array();
var SelectedConsentId;
//Ended Over here
//Added by Loveena in ref to Task#3099 Do not Show Consent Warning for Non-Ordered Medications
var Ordered = new Array();
var SortExpressionOutBound = '';
//Added By Priya
var SortExpressionInBound = '';
var CalledFrom = '';
//Added By Chuck Blaine
var isStaff = false;
var FieldClientMedicationScriptId;
var EnableChangeOrderButton = new Array();

///Sunil.D 05/01/2017 Added Education Info Icon onclick function will redirect to education info with Drugcode for #43 meaning full Use. 
function openEducationInformationDetalisForDiagnosis(MedicationNameId) {
    try {
        //  debugger;  
        Streamline.SmartClient.WebServices.ClientMedications.GetClientEducationNDC(MedicationNameId, function onSuccessClientEducation(result) {
            if (result.length > 0) {
                window.open("EducationInformationView.aspx?Type=NDC&NDCCode=" + result);
            }
        }, onFailure);
    }
    catch (err) {
        LogClientSideException(err, 'openEducationInformationDetalisForDiagnosis');
    }
}

function fnHideParentDiv() {
    try {
        var objdvProgress = document.getElementById('dvProgress1');
        if (objdvProgress != null)
            objdvProgress.style.display = 'none';
    } catch (Exception) {
        alert(Exception.message);
        ShowError(Exception.description, true);
    }
}

//Added By Anuj on 24 oct,2009
//(This Method wll select the order name from discontinue screen. ref.Task #1 SDI Projects FY10 - Venture)

function SelectMethodNameForSystemReport(objectRadioButton) {
    try {
        var radionButtonValue = objectRadioButton.value.toString();
        OrderName = radionButtonValue;
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}


function validateCharacters(strValue) {
    /************************************************
    DESCRIPTION: Validates that a string doesnt have 
    numeric or special characters

    PARAMETERS:
    strValue - String to be tested for validity

    RETURNS:
    True if valid, otherwise false.

    *************************************************/
    //var objRegExp  = /^[\w\.\']{2,}([\s][\w\.\']{2,})+$/;
    //var objRegExp  = /(^-?\d\d*$)/
    //var objRegExp  = /[a-zA-Z]/;
    //[^a-zA-Z]+/; //[^d][a-zA-Z][^d]/

    //    if(validateInteger(strValue)==false)
    //    {
    var NewStrValue = strValue.replace(/[^ a-zA-Z0-9._,&#\''\-()\\\/]/g, '');

    //alert('strValue=='+strValue);
    if (NewStrValue != strValue) {
        return false;
    }
    if (NewStrValue.indexOf('<') > 0 || NewStrValue.indexOf('>') > 0 || (NewStrValue.indexOf('&') == 0 && NewStrValue.indexOf('#') == 1) || (NewStrValue.indexOf('&') == 1 && NewStrValue.indexOf('#') == 0) || NewStrValue.indexOf('&&&&') >= 0 || NewStrValue.indexOf('&#') >= 0 || NewStrValue.indexOf('&&') >= 0 || NewStrValue.indexOf('--') >= 0 || NewStrValue.indexOf('__') >= 0 || NewStrValue.indexOf('##') >= 0)
        return false;

    //    }
    //    else
    //        return false;
}


//function onLinkClick(sender, e) {
//    try {
//        fnShow(); //By Vikas Vyas On Dated April 04th 2008
//        //Added OrderType in ref to Task#3273 - 2.6.1 Non-Ordered Medications: Allow Changes
//        if (e.OrderType != "N")
//            Streamline.SmartClient.WebServices.ClientMedications.SetOrderDetailsMedicationIdForMainPage(e.MedicationId, e.MedicationScriptId, onSuccessfullPopulationOfOrderDetails, onFailure);
//        else if (e.OrderType == "N")
//            Streamline.SmartClient.WebServices.ClientMedications.PopulateRowsforMedicationList(e.MedicationId, "UpdateMedication", 0, 0, '', '', '', '', onSuccessfullPopulation, onFailure, "Update Medication");
//    }
//    catch (e) {
//        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
//    }

//}

//function onSuccessfullPopulationOfOrderDetails(result, context, methodname) {
//    try {

//        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
//        redirectToOrderDetailsPage('PatientMainPage');
//    } catch(e) {
//        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
//    }

//}


function onSucceeded(result) {
    try {
        //alert(result);

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}


function ShowAllergySearchDiv(SearchObject) {
    try {
        ShowError('', false);
        TextBoxAddAllergy = document.getElementById(SearchObject);
        var SearchCriteria = document.getElementById(SearchObject).value;
        TextBoxAddAllergy.disabled = false;

        if (SearchCriteria == "" || SearchCriteria == null || SearchCriteria.charAt(0) == ' ' || SearchCriteria.length < 2) {
            ShowError('Please enter atleast 2 characters as search criteria', true);
            return false;
        }
        var answer = validateCharacters(SearchCriteria);
        if (answer == false) {
            ShowError('Please enter valid characters as search criteria', true);
            return false;
        }

        var st = "";
        st = SearchCriteria;
        if (st.indexOf('#') > 0)
            st = st.replace('#', '^');
        if (st.indexOf('&') > 0)
            st = st.replace('&', '!');

        fnShow(); //By Vikas Vyas On Dated April 04th 2008

        var $divSearch = $("#DivSearch");
        $("#topborder", $divSearch).text("Search Allergy");
        var $iFrameSearch = $('#iFrameSearch', $divSearch);
        $iFrameSearch.attr('src', 'ViewAllergiesList.aspx?SearchCriteria=' + st);
        $iFrameSearch.css({ 'width': '350px', 'height': '510px' });
        var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
        left = left > 0 ? left : 10;
        var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
        top = top > 0 ? top : 10;
        $divSearch.css({ 'top': top, 'left': left });
        $divSearch.draggable();
        $divSearch.css('display', 'block');

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}


function ShowAllergySearchDivonLostFocus(SearchObject) {
    try {

        document.getElementById(SearchObject).disabled = false;
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}

function ShowAllergySearchDivonLostFocus1(SearchObject) {
    try {
        ShowError('', false);
        TextBoxAddAllergy = document.getElementById(SearchObject);
        var SearchCriteria = document.getElementById(SearchObject).value;


        {
            ShowAllergySearchDiv(SearchObject);
        }

        //var DivCoverAll=parent.document.getElementById('DivCoverAll');
        //DivCoverAll.style.display='block';*/
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return true;
}

function ShowMedicationViewHistoryDiv() {
    try {

        ShowError('', false);
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        var DivSearch = parent.document.getElementById('DivSearch');
        DivSearch.style.display = 'block';
        var iFrameSearch = parent.document.getElementById('iFrameSearch');
        iFrameSearch.src = 'ViewMedicationHistory.aspx';
        iFrameSearch.style.positions = 'absolute';
        iFrameSearch.style.left = '0px';
        iFrameSearch.style.width = 1015;
        iFrameSearch.style.height = window.screen.height;
        iFrameSearch.style.top = '0px';

        iFrameSearch.style.display = 'block';
        DivSearch.style.left = 2;


    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}


function ShowPreferredPharmaciesDiv() {
    try {
        ShowError('', false);
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        var currentTime = new Date();
        var $divSearch = $("#DivSearch");
        $("#topborder", $divSearch).text("Client Preferred Pharmacies");
        var $iFrameSearch = $('#iFrameSearch', $divSearch);
        $iFrameSearch.attr('src', 'PreferredPharmacies.aspx?Time=' + currentTime.getTime());
        $iFrameSearch.css({ 'width': '500px', 'height': '350px' });
        var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
        left = left > 0 ? left : 10;
        var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
        top = top > 0 ? top : 10;
        $divSearch.css({ 'top': top, 'left': left });
        $divSearch.draggable();
        $divSearch.css('display', 'block');
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}


function closeDiv() {
    try {
        //$("#DivSearch").css('display', 'none');
        $('#DivSearch', window.parent.document).css('display', 'none');
        fnHideParda();
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function CloseDiscontinueDiv(divDiscontinue) {
    fnHideParentDiv();
    //Code added by Loveena in ref to Task#2819.
    $("[id$=ImgError]").css('display', 'none');
    $("[id$=LabelError]").css('display', 'none');
    divDiscontinue.style.display = 'none';
}

function SetId(flag) {

}

function ShowMainPageError(ShowMessage, ShowError) {
    try {
        if (ShowError == true) {
            if ($('[id$=LabelMainError]') != null) {
                $('[id$=LabelMainError]').css('display', 'block').text(ShowMessage);
            }
        } else {
            $('[id$=LabelMainError]').css('display', 'none').text(ShowMessage);
        }

    } catch (Err) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        document.getElementById('ImgError').style.visibility = 'visible';
        document.getElementById('Control_ASP.LabelError').innerText = 'An Error Occured, Please Contact your System Administrator';
        return false;
    }
}

function ShowError(ShowMessage, ShowImage) {
    var imageError = $('[id$=ImageError]');
    if (imageError.length < 1) imageError = $('[id$=ImgError]');
    var labelError = $('[id$=LabelErrorMessage]');
    if (labelError.length < 1) labelError = $('[id$=LabelError]');
    try {
        if (ShowImage == true) {
            if ($('[id$=tableErrorMessage]').length > 0 && $('[id$=DivErrorMessage]').length > 0) {
                $('[id$=tableErrorMessage]')[0].style.display = 'block';
                $('[id$=DivErrorMessage]')[0].style.display = 'block';
            }
            imageError[0].style.visibility = 'visible';
            document.documentElement.scrollTop = 0;
        } else {
            imageError[0].style.display = 'none';
        }
        labelError[0].innerText = ShowMessage;
    } catch (Err) {
        imageError[0].style.display = 'block';
        labelError[0].innerText = 'An Error Occured, Please Contact your System Administrator';
        return false;
    }
}


function ButtonPrintList(stringReportName) {
    try {
        PopupCenter("LoadReport.aspx?reportName=" + encodeURIComponent(stringReportName), "SmartCare", 760, 500);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function onSuccessfullGetSystemReportsMedManagement(result, context, methodname) {
    fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    if (result == null)
        return;
    //alert('re ' + result); 
    document.getElementById("test").href = result;
    document.getElementById("test").click();
}


function ButtonReOrderClick(ButtonAction) {
    try {
       
        $('input[id=HiddenFieldSureScriptRefillRequestId]').val('');
        //Code Added bY Pradeep as per task#3300
        $('input[id=HiddenFieldRefillSpecialCase]').val('');
        //Code added by Pradeep as per task#3297 Start Over Here
        $('input[id=HiddenFieldRadioToFax]').val('');
        $('input[id=HiddenFieldChangeOrderPharmacyId]').val('');
        //End added by Pradeep as per task#3297 Start Over Here
        $('input[id=HiddenFieldRefillPharmacyId]').val('');
        //Addedd By Loveen as per task#3290
        $('input[id=HiddenFieldRefillPharmacyName]').val('');
        $("input[id*=HiddenFieldClickedImage]").val('');
        //Added By priya ref:Task No:3274 2.7 Surescripts Refill Requests for Schedule II-V Medications
        $("input[Id$=HiddenFieldDrugCategory]").val('');
        //end
        if (EnableChangeOrderButton.indexOf("False") > -1 && ButtonAction != 'Complete') {
            var datetime = new Date();
            window.open("YesNo.aspx?datetime=" + datetime.getMinutes() + datetime.getSeconds() + "&CalledFrom=ChangeOrderControlDrugAlert", 'YesNo', 'menubar : no;status : no,Height=178px,Width=423px,resizable:no,Top:200px;Left:300px,location:no, help: No;');
           // window.open('YesNo.aspx?CalledFrom=OrderPage' + '^' + ValidationMessage, 'YesNo', 'location=no,width=340px,height=116px,top=200px,left=300px,resizable = no,scrollbars=no');
        }
        else {
            //if (medicationId) {
            //    MedicationIds.push(medicationId);
            //    ApprovalStatus.push("False");
            //}

            var stringMedicationIds = "";
            var i = 0;
            var lengthOfArray = MedicationIds.length;
            var context = "Change";
            if (ButtonAction == 'Complete')
                context = "Complete";
            //Added By Anuj on 24 Nov,2009 for task ref #3 SDI venture -10
            var lengthOfApprovalStatusArray = ApprovalStatus.length;
            var j = 0;
            //Ended over here
            if (lengthOfArray == 0) {
                ShowError("Please select at least one record from Medication List", true);
                return false;
            }
            //Added By Anuj on 24 Nov,2009 for task ref #3 SDI venture -10
            if (lengthOfApprovalStatusArray > 0) {
                for (j = 0; j < lengthOfApprovalStatusArray; j++) {
                    if (ApprovalStatus[j] == "True") {
                        ShowError("One of the selected Medication is Waiting for Prescriber Approval", true);
                        return false;
                    }
                }
            } else {
                ShowError("Please select at least one record from Medication List", true);
                return false;
            }
            //Ended over here       
            fnShow(); //By Vikas Vyas On Dated April 04th 2008   

            for (i = 0; i < lengthOfArray; i++) {
                if (stringMedicationIds == "") {
                    stringMedicationIds += String(MedicationIds[i]);
                } else {
                    stringMedicationIds += "," + String(MedicationIds[i]);
                }
            }
            //Added new parameters in ref to Task#3224 For approve button, we are required to disable some additional fields in the grid.
            Streamline.SmartClient.WebServices.ClientMedications.PopulateRowsforMedicationList(stringMedicationIds, context, 0, 0, '', '', '', '', onSuccessfullPopulation, onFailure, context);
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }

}

function onSuccessfullPopulation(result, context, methodname) {
   
    try {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        if (context == "Update Medication")
            redirectToNonOrderPageClearSession(context);
        else
            redirectToOrderPage(context, result); //Made changes as per task#31 By Pradeep             
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

// handle Adjust Dosage/Schedule button click

function ButtonAdjustDosageSchedule(FromScreenName) {
    try {
        $('input[id=HiddenFieldSureScriptRefillRequestId]').val('');
        $('input[id=HiddenFieldRefillSpecialCase]').val('');
        $('input[id=HiddenFieldRadioToFax]').val('');
        $('input[id=HiddenFieldChangeOrderPharmacyId]').val('');
        $('input[id=HiddenFieldRefillPharmacyId]').val('');
        $('input[id=HiddenFieldRefillPharmacyName]').val('');
        $("input[id*=HiddenFieldClickedImage]").val('');
        $("input[Id$=HiddenFieldDrugCategory]").val('');
        var stringMedicationIds = "";
        var i = 0;
        var lengthOfArray = MedicationIds.length;
        var context = "Adjust";
        //Added By Anuj on 24 Nov,2009 for task ref #3 SDI venture -10
        var lengthOfApprovalStatusArray = ApprovalStatus.length;
        var j = 0;
        //Ended over here
        if (lengthOfArray == 0) {
            ShowError("Please select at least one record from Medication List", true);
            return false;
        }
        //Added By Anuj on 24 Nov,2009 for task ref #3 SDI venture -10
        if (lengthOfApprovalStatusArray > 0) {
            for (j = 0; j < lengthOfApprovalStatusArray; j++) {
                if (ApprovalStatus[j] == "True") {
                    ShowError("One of the selected Medication is Waiting for Prescriber Approval", true);
                    return false;
                }
            }
        } else {
            ShowError("Please select at least one record from Medication List", true);
            return false;
        }
        //Ended over here       
        fnShow(); //By Vikas Vyas On Dated April 04th 2008   

        for (i = 0; i < lengthOfArray; i++) {
            if (stringMedicationIds == "") {
                stringMedicationIds += String(MedicationIds[i]);
            } else {
                stringMedicationIds += "," + String(MedicationIds[i]);
            }
        }
        if (FromScreenName) {
            $("[id$=HiddenFieldRedirectFrom]").val(FromScreenName);
        }

        if (!FromScreenName)
            FromScreenName = "";


        //Added new parameters in ref to Task#3224 For approve button, we are required to disable some additional fields in the grid.
        Streamline.SmartClient.WebServices.ClientMedications.PopulateRowsforMedicationList(stringMedicationIds, context, 0, 0, FromScreenName, '', '', '', onSuccessfullAdjustDosageSchedule, onFailure, context);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }

}

function onSuccessfullAdjustDosageSchedule(result, context, methodname) {

    try {
        fnHideParentDiv();
        if (context == "Update Medication")
            redirectToNonOrderPageClearSession(context);
        else
            redirectToOrderPage(context, result); //Made changes as per task#31 By Pradeep             
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}


//Added by Sony in ref to task 2377
//When the Refill order is clicked from medication management screen

function ButtonReFillOrderClick() {
    try {
        $('input[id=HiddenFieldSureScriptRefillRequestId]').val('');
        //Code Added bY Pradeep as per task#3300
        $('input[id=HiddenFieldRefillSpecialCase]').val('');
        //--Code Added by Pradeep as per task#3297 Start Over Here
        $('input[id=HiddenFieldRadioToFax]').val('');
        $('input[id=HiddenFieldChangeOrderPharmacyId]').val('');
        //--Code Added by Pradeep as per task#3297 End Over Here
        $('input[id=HiddenFieldRefillPharmacyId]').val('');
        $('input[id=HiddenFieldRefillPharmacyName]').val('');
        $("input[id*=HiddenFieldClickedImage]").val('');
        //Added By priya ref:Task No:3274 2.7 Surescripts Refill Requests for Schedule II-V Medications
        $("input[Id$=HiddenFieldDrugCategory]").val('');
        //end
        var stringMedicationIds = "";
        var i = 0;
        var lengthOfArray = MedicationIds.length;
        var context = "Refill";
        //Added By Anuj on 24 Nov,2009 for task ref #3 SDI venture -10
        var lengthOfApprovalStatusArray = ApprovalStatus.length;
        var j = 0;
        //Ended over here
        if (lengthOfArray == 0) {
            ShowError("Please select at least one record from Medication List", true);
            return false;
        }
        //Added By Anuj on 24 Nov,2009 for task ref #3 SDI venture -10
        if (lengthOfApprovalStatusArray > 0) {
            for (j = 0; j < lengthOfApprovalStatusArray; j++) {
                if (ApprovalStatus[j] == "True") {
                    ShowError("One of the selected Medication is Waiting for Prescriber Approval.", true);
                    return false;
                }
            }
        } else {
            ShowError("Please select at least one record from Medication List", true);
            return false;
        }
        //Ended over here

        fnShow(); //By Vikas Vyas 

        for (i = 0; i < lengthOfArray; i++) {
            if (stringMedicationIds == "") {
                stringMedicationIds += String(MedicationIds[i]);
            } else {
                stringMedicationIds += "," + String(MedicationIds[i]);
            }
        }
        //Added new parameters in ref to Task#3224 For approve button, we are required to disable some additional fields in the grid.
        Streamline.SmartClient.WebServices.ClientMedications.PopulateRowsforMedicationList(stringMedicationIds, context, 0, 0, '', '', '', '', onSuccessfullPopulation, onFailure, context);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }

}


//Added by Mohit Madaan on April 11 2009
//When the Patient Content isclicked from medication management screen
//Modified By Anuj on 30nov,2009 for task ref #18 SDI venture 10

function ButtonPatientContentClick(ImageConsentClick) {
    try {
        ShowError("", false);
        var stringMedicationIds = "";
        var i = 0;
        var lengthOfArray = MedicationIds.length;
        //Code added by Loveena in ref to Task#3099 Do not Show Consent Warning for Non-Ordered Medications
        var lengthOfNonOrderedArray = Ordered.length;
        //Code ends over here.
        var context = new Object();
        //var context="PatientConsent";
        //Modified By Anuj on 30nov,2009 for task ref #18 SDI venture 10
        context.MethodName = "PatientConsent";
        var value = sessionStorage.getItem("COMPLETEORDERSTORX");        
        if (value == "Y") {          
            for (i = 0; i < lengthOfNonOrderedArray; i++) {
                if (String(Ordered[i]) == "N") {
                    ShowError("You have selected one of a non-ordered medication. Consents are only allowed for ordered medications.", true);
                    return false;
                }
            }
        }
        var ImageClick = "";
        if (ImageConsentClick === undefined) {
            context.ImageClick = "";
            context.ImageClientMedicationConsentId = "";
        } else {
            context.ImageClick = ImageConsentClick;
            //context.ImageClientMedicationId = MedicationIds[0];  
            context.ImageClientMedicationConsentId = SelectedConsentId;
        }

        //Ended over here
        if (lengthOfArray == 0) {
            ShowError("Please select at least one record from Medication List", true);
            return false;
        }

        fnShow();
        for (i = 0; i < lengthOfArray; i++) {
            if (stringMedicationIds == "") {
                stringMedicationIds += String(MedicationIds[i]);
            } else {
                stringMedicationIds += "," + String(MedicationIds[i]);
            }
        }
        context.ClientMedicationId = stringMedicationIds;
        Streamline.SmartClient.WebServices.ClientMedications.PopulateRowsforMedicationList(stringMedicationIds, context.MethodName, 0, 0, '', '', '', '', onSuccessfullContentPopulation, onFailure, context);
        //Ended overe here
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

//Added By Mohit Madaan on April 11 2009
//function onSuccessfullContentPopulation(result,context,methodname)
//Modified by Anuj on 30nov,2009 for task ref# 18 SDI Venture 10

function onSuccessfullContentPopulation(result, context, methodname) {

    try {
        fnHideParentDiv();
        //redirectToPatientContentPage();
        //Condition added by Loveena in ref to Task#2962
        if (context.ImageClick == "Patient Consent")
            redirectToPatientContentPage(context.ImageClick, '', context.ClientMedicationId);
        else {
            //Added By Anuj on 30 nov,2009 for task ref #18 SDI venture 10
            redirectToPatientContentPage(context.ImageClick, context.ImageClientMedicationConsentId);
            //Ended over here
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}


function onFailure(error) {

    try {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        //Added by Chandan for task#122 1.7 - Error Dialog on Session Timeout  
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        } else {
            alert(error.get_message());
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

function onSuccessfullDiscontinue(result, context, methodname) {
    try {
        var pharmacyName;
        var TableHTML = [];
        var div = "";
        t = new Object();
        t = context.e;
        if (sessionStorage.DeleateFromList == "DeleateFromList") {
            if (document.getElementById("divDiscontinueMain") != undefined)
                div = document.getElementById("divDiscontinueMain");


        }
        else {
            if (!document.getElementById("divDiscontinueMain"))
                div = document.createElement('div');
            else {
                div = document.getElementById("divDiscontinueMain");
            }
        }
        div.id = "divDiscontinueMain";
        div.style.cursor = "default";
        div.style.backgroundColor = "#ffffff";
        div.style.top = "320px";
        div.style.zIndex = 99;
        //div.style.bottom=context.clientY;
        div.className = "drugInteraction";
        div.style.position = "absolute";

        TableHTML.push("<table cellpadding='0' cellspacing='0'  style='height: 1px; border-right: #dee7ef thin solid;border-top: #dee7ef thin solid; border-left: #dee7ef thin solid; border-bottom: #dee7ef thin solid;'>");
        TableHTML.push("<tr><td style='padding:0px;'>");
        TableHTML.push("<table class='PopUpTitleBar' border='0' cellpadding='0' cellspacing='0'   width='100%'>");
        TableHTML.push("<tr><td  id='topborder' class='TitleBarText' align='left' style='color: #fefefe; font-weight: bold; padding: 5px; padding-left: 2px; cursor: move;'>Enter Discontinue Reason</td>");
        TableHTML.push("<td align='left' width='10px'><img id='ImgCrossDiscontinue' onclick='CloseDiscontinueDiv(divDiscontinueMain);' src='App_Themes/Includes/Images/cross.jpg'      title='Close' alt='Close' />");
        TableHTML.push(" </td></tr></table></td></tr>");


        TableHTML.push(" <tr><td valign='top' style='width: 100%' align='center'>");
        TableHTML.push("<table border='0px' cellpadding='0' cellspacing='0px' width='100%'>");
        TableHTML.push("<tr>");
        TableHTML.push("<td valign='middle' style='width:80%' align='left' colspan='2'>");

        //Code Added by Loveena in ref to Task#2487 on 28-April-2009 to display DiscontinueReasonCode drop down.
        TableHTML.push("<tr>");
        TableHTML.push("<td align='left'>");
        TableHTML.push("<select width='255px' class='ddlist' name='dropdownDiscontinueReason' runat='server' id='dropdownDiscontinueReason' onchange='EnableDiscontinueButton(this);'>");
        TableHTML.push(result.rows[0]["PairResultData"]);
        TableHTML.push("</select>");
        TableHTML.push("</td>");
        TableHTML.push("</tr>");
        //Code ends over here.            
        TableHTML.push("<tr>");
        TableHTML.push("<td align='left'>");
        TableHTML.push("<textarea cols='30' id='TextBoxDiscontinueReason' class='TextBox' style='height:52px' name='TextBoxDiscontinueReason'  onkeyup= 'doKeydown(this);'  onkeydown= 'doKeydown(this);'   onkeypress= 'doKeydown(this);' onbeforepaste='doBeforePaste(this);'   onpaste='doPaste(this);'  maxLength='1000'        /></textarea>");
        TableHTML.push("</td>");
        TableHTML.push("</tr>");

        TableHTML.push("</td>");
        TableHTML.push("</tr>");
        TableHTML.push("<tr><td colspan='2'> &nbsp;&nbsp;</td></tr>");
        TableHTML.push(" <tr><td colspan='2'  style='text-align:center;><input id='ButtonDiscontinue' class='btnimgexsmall' type='button' value=Discontinue onclick='MedicationMgt.ClientMedicationDiscontinue(TextBoxDiscontinueReason,dropdownDiscontinueReason);'  disabled=true />&nbsp;<input id='ButtonCancel' class='btnimgexsmall' type='button' value='Cancel'  onclick='CloseDiscontinueDiv(divDiscontinueMain);' /></td>");
        TableHTML.push("</tr>");
        TableHTML.push("</table></td></tr></table>");

        div.innerHTML = "";
        div.innerHTML = TableHTML.join("");

        if (sessionStorage.DeleateFromList == "DeleateFromList") {
            div.style.display = "block";
        }
        else {
            if ((context.sender.target.parentNode.getElementsByTagName("div").length < 1) && (context.sender.target.parentNode.getElementsByTagName("div").length != 1)) {
                context.sender.target.parentNode.appendChild(div);
            }
        }
        document.getElementById("divDiscontinueMain").style.display = "block";
        //Added by Sonia
        //Default focus should be in TextBox when user clicked on Discontinue option
        document.getElementById("TextBoxDiscontinueReason").focus();
        var TableHTML = [];
        var div = "";
        t = new Object();
        t = context.e;
        if (!document.getElementById("divDiscontinueMain"))
            div = document.createElement('div');
        else {
            div = document.getElementById("divDiscontinueMain");
        }
        div.id = "divDiscontinueMain";
        div.style.cursor = "default";
        div.style.backgroundColor = "#ffffff";
        div.style.zIndex = 99;
        //div.style.bottom=context.clientY;
        div.className = "drugInteraction";
        div.style.position = "absolute";

        TableHTML.push("<table cellpadding='0' cellspacing='0'  style='height: 1px; border-right: #dee7ef thin solid;border-top: #dee7ef thin solid; border-left: #dee7ef thin solid; border-bottom: #dee7ef thin solid;'>");
        TableHTML.push("<tr><td style='padding:0px;'>");
        TableHTML.push("<table class='PopUpTitleBar' border='0' cellpadding='0' cellspacing='0'   width='100%'>");
        TableHTML.push("<tr><td  id='topborder' class='TitleBarText' align='left' style='color: #fefefe; font-weight: bold; padding: 5px; padding-left: 2px; cursor: move;'>Enter Discontinue Reason</td>");
        TableHTML.push("<td align='left' width='10px'><img id='ImgCrossDiscontinue' onclick='CloseDiscontinueDiv(divDiscontinueMain);' src='App_Themes/Includes/Images/cross.jpg'      title='Close' alt='Close' />");
        TableHTML.push(" </td></tr></table></td></tr>");


        TableHTML.push(" <tr><td valign='top' style='width: 100%' align='center'>");
        TableHTML.push("<table border='0px' cellpadding='0' cellspacing='0px' width='100%'>");
        TableHTML.push("<tr>");
        TableHTML.push("<td valign='middle' style='width:80%' align='left' colspan='2'>");

        //Code Added by Loveena in ref to Task#2487 on 28-April-2009 to display DiscontinueReasonCode drop down.
        TableHTML.push("<tr>");
        TableHTML.push("<td align='left'>");
        TableHTML.push("<select width='255px' class='ddlist' name='dropdownDiscontinueReason' runat='server' id='dropdownDiscontinueReason' onchange='EnableDiscontinueButton(this);'>");
        TableHTML.push(result.rows[0]["PairResultData"]);
        TableHTML.push("</select>");
        TableHTML.push("</td>");
        TableHTML.push("</tr>");
        //Code ends over here.

        TableHTML.push("<tr>");
        TableHTML.push("<td align='left'>");
        TableHTML.push("<textarea cols='69' id='TextBoxDiscontinueReason' class='TextBox' style='height:52px' name='TextBoxDiscontinueReason'  onkeyup= 'doKeydown(this);'  onkeydown= 'doKeydown(this);'   onkeypress= 'doKeydown(this);' onbeforepaste='doBeforePaste(this);'   onpaste='doPaste(this);'  maxLength='1000'        /></textarea>");
        TableHTML.push("<td>");
        TableHTML.push("</tr>");
        TableHTML.push("<tr>");
        TableHTML.push("<td align='left'>");
        TableHTML.push("<fieldset><legend ><span class='LegendTitle'>Discontinuation Letter</span></legend>");
        if (t.SureScriptsOutgoingMessageId !== "") {
            TableHTML.push("<input type='radio' id='RadioButton_EScript' value='E' onclick='SelectMethodNameForSystemReport(this)'; align='left' name='SelectReport'><span class='RadioDiscontinue'>SureScript: ", t.PharmacyName, "</span></input><br/>");
        } else {
            TableHTML.push("<input type='radio' id='RadioButton_EScript' value='E' name='SelectReport' style='display:none;'></input>");
        }
        TableHTML.push("<input type='radio' id='RadioButton_Fax' value='F' onclick='SelectMethodNameForSystemReport(this)'; align='left'  name='SelectReport'><span class='RadioDiscontinue' style='vertical-align:middle;'>Fax</span></input><br/>");

        TableHTML.push("<select width='150px' class='ddlist'  name='dropdownPharmacies' runat='server' id='dropdownPharmacies' >");
        TableHTML.push(result.rows[1]["PairResultData"]);
        TableHTML.push("</select></br>");
        pharmacyName = t.PharmacyName;

        TableHTML.push(result.rows[2]["PairResultData"]);

        TableHTML.push("</fieldset>");
        TableHTML.push("</td>");
        TableHTML.push("</tr>");
        //Code ends over here. 


        TableHTML.push("</td>");
        TableHTML.push("</tr>");
        TableHTML.push("<tr><td colspan='2'> &nbsp;&nbsp;</td></tr>");
        TableHTML.push(" <tr><td colspan='2' style='text-align:center;'><input id='ButtonDiscontinue' class='btnimgexsmall' type='button' value=Discontinue onclick='MedicationMgt.ClientMedicationDiscontinue(TextBoxDiscontinueReason,dropdownDiscontinueReason,RadioButton_Fax,RadioButton_Print,RadioButton_None,dropdownPharmacies, RadioButton_EScript);'  disabled=true />&nbsp;<input id='ButtonCancel' class='btnimgexsmall'  type='button' value='Cancel'  onclick='CloseDiscontinueDiv(divDiscontinueMain);' /></td>");
        TableHTML.push("</tr>");
        TableHTML.push("</table></td></tr></table>");

        div.innerHTML = "";
        div.innerHTML = TableHTML.join("");

        if (sessionStorage.DeleateFromList == "DeleateFromList") {
            div.style.display = "block";
        }
        else {

            if ((context.sender.target.parentNode.getElementsByTagName("div").length < 1) && (context.sender.target.parentNode.getElementsByTagName("div").length != 1)) {
                context.sender.target.parentNode.appendChild(div);
            }
        }
         

            var index = GetPharamcyIndex(pharmacyName);
            if (index != undefined)
                document.getElementById("dropdownPharmacies").selectedIndex = index;
            else {
                index = GetPrefferedPharmacyIndex(result.rows[3].PairResultData);
                if (index != undefined)
                    document.getElementById("dropdownPharmacies").selectedIndex = index;
                else {
                    index = GetPrefferedPharmacyIndex(result.rows[4].PairResultData);
                    if (index != undefined)
                        document.getElementById("dropdownPharmacies").selectedIndex = index;
                }
            }
        

        document.getElementById("divDiscontinueMain").style.display = "block";
        //Added by Sonia
        //Default focus should be in TextBox when user clicked on Discontinue option
        document.getElementById("TextBoxDiscontinueReason").focus();
    } catch (e) {
    }
}

function GetPharamcyIndex(seachtext) {
    var index;
    seachtext = seachtext.split('%7e');
    for (var i = 0; i < document.getElementById('dropdownPharmacies').options.length; i++) {
        if (document.getElementById('dropdownPharmacies').options[i].text.split(' - ')[0].trim() == seachtext[0]) {
            index = i;
            break;
        }
    }
    return index;
}

function GetPrefferedPharmacyIndex(seachtext) {
    var index1;
    seachtext = seachtext.split(" - ");
    for (var i = 0; i < document.getElementById('dropdownPharmacies').options.length; i++) {
        if (document.getElementById('dropdownPharmacies').options[i].text.split(' - ')[0].trim() == seachtext[0]) {
            index1 = i;
            break;
        }
    }
    return index1;
}

function doKeydown(objectTextBox) {
    var objh = objectTextBox;
    var objb = document.getElementById('ButtonDiscontinue');

    var strlen = CommonFunctions.trimAll(objh.value).length;
    if (strlen > 0)
        objb.disabled = false;
    else
        objb.disabled = true;


}

function EnableDiscontinueButton(objectDropDown) {
    var objh = objectDropDown;
    var objb = document.getElementById('ButtonDiscontinue');
    if (objh.value > 0)
        objb.disabled = false;
    else
        objb.disabled = true;
}


function onCheckBoxClick(sender, e) {
    try {
        EnableChangeOrderButton.push(e.EnableChangeOrderButton);
        //if (EnableChangeOrderButton.indexOf("False") > -1) {
        //    parent.document.getElementById('Control_ASP.usercontrols_medicationmgt_ascx_ButtonReOrder').disabled = true;
        //}
        //else {
        //    parent.document.getElementById('Control_ASP.usercontrols_medicationmgt_ascx_ButtonReOrder').disabled = false;
        //}
        if (sender.target.checked == true) {
            MedicationIds.push(e.MedicationId);
            //Added By Anuj on 24 Nov,2009 for task ref #3 SDI Venture -10
            ApprovalStatus.push(e.ApprovalStatus);
            //Ended over here
            //Added By Loveena in ref to Task#3099 Do not Show Consent Warning for Non-Ordered Medications
            Ordered.push(e.Ordered);
            //Ended over here
        } else {
            EnableChangeOrderButton.length = 0;
            if (Array.contains(MedicationIds, e.MedicationId))
                Array.remove(MedicationIds, e.MedicationId);
            //Added By Anuj on 24 Nov,2009 for task ref #3 SDI Venture -10
            if (Array.contains(ApprovalStatus, e.ApprovalStatus))
                Array.remove(ApprovalStatus, e.ApprovalStatus);
            //Ended over here
            //Added By Loveena in ref to Task#3099 Do not Show Consent Warning for Non-Ordered Medications
            if (Array.contains(Ordered, e.Ordered))
                Array.remove(Ordered, e.Ordered);
            //Ended over here
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Created By Anuj on 5 nov,2009 for task ref # 18 SDI Projects FY10 - Venture
//Called when the consent (Yellow/Green  icon) is clicked from medication list page

function onImageConsentClick(sender, e) {
    try {
        if (e.ViewConsentReport === undefined) {
            if (Array.contains(MedicationIds, e.MedicationId)) {
                Array.remove(MedicationIds, e.MedicationId);
            }
            //Added By Anuj on 22Dec,2009
            var context = new Object();
            context.ClientmedicationId = e.MedicationId;
            context.ClientMedicationConsentId = e.ClientMedicationConsentId;
            context.ClientId = e.ClientId;

            Streamline.SmartClient.WebServices.ClientMedications.GetClientMedicationId(e.ClientMedicationConsentId, onSuccessGetClientMedicationIds, onFailure, context);
            //Ended over here


            //MedicationIds.push(e.MedicationId);
            //Modified By Anuj on 30nov,2009 for task ref #18 SDI venture 10
            // var ImageConsentClick='ImageConsentClick';
            //ButtonPatientContentClick(ImageConsentClick);
        } else {
            var context = new Object();
            context.ClientmedicationId = e.MedicationId;
            context.ClientMedicationConsentId = e.ClientMedicationConsentId;
            context.ClientId = e.ClientId;
            //var ImageConsentClick = 'ImageConsentClick';
            context.ImageClick = 'ImageConsentClick';
            if (e.YellowClick != undefined) {
                context.YellowClick = e.YellowClick;
            } else {
                context.YellowClick = "N";
            }

            Streamline.SmartClient.WebServices.ClientMedications.GetClientMedicationId(e.ClientMedicationConsentId, onSuccessGetClientMedicationIdsForPatientConsentDetail, onFailure, context);

        }

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Called OnSuccess of GetClientMedicationIds

function onSuccessGetClientMedicationIds(result, context) {
    try {
        if (result === undefined || result == null || result == "") {
            //Print Message
        } else {
            var arr = new Array();
            arr = result.split(",");
            for (var i = 0; i < arr.length; i++) {
                if (Array.contains(MedicationIds, arr[i])) {
                    Array.remove(MedicationIds, arr[i]);
                }
            }
            for (var i = 0; i < arr.length; i++) {
                MedicationIds.push(arr[i]);
            }
        }
        if (SelectedConsentId != null || SelectedConsentId != "" || SelectedConsentId == "undefined") {
            SelectedConsentId = "";
        }
        SelectedConsentId = context.ClientMedicationConsentId;
        var ImageConsentClick = 'ImageConsentClick';
        ButtonPatientContentClick(ImageConsentClick);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

function onSuccessGetLatestVersionForPatientConsentDetail(result, context) {
    try {
        if (context.YellowClick == "Y") {
            var ImageClickDocumentVersionId = result;
            redirectToPatientContentPage(context.ImageClick, context.ClientMedicationConsentId, context.ClientmedicationId, ImageClickDocumentVersionId, context.YellowClick, '');
        } else if (context.YellowClick == "G") {
            var ImageClickDocumentVersionId = result;
            redirectToPatientContentPage(context.ImageClick, context.ClientMedicationConsentId, context.ClientmedicationId, ImageClickDocumentVersionId, context.YellowClick, '');
        } else {
            RedirectToPatientConsentDetailPage("MedicationManagementPage");
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function onFailure() {
    try {

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}


//Called OnSuccess of GetClientMedicationIds
//Added by anuj 30th December 2009

function onSuccessGetClientMedicationIdsForPatientConsentDetail(result, context) {
    try {
        //Commented by Loveena in ref to Task#2975
        //Streamline.SmartClient.WebServices.ClientMedications.GetLatestDocumentVersionIdForClientMedication(context.ClientMedicationConsentId, onSuccessGetLatestVersionForPatientConsentDetail, onFailure, context);
        if (context.YellowClick == "Y") {
            var ImageClickDocumentVersionId = result.First;
            redirectToPatientContentPage(context.ImageClick, context.ClientMedicationConsentId, result.Second, ImageClickDocumentVersionId, context.YellowClick, '');
        } else if (context.YellowClick == "G") {
            var ImageClickDocumentVersionId = result.First;
            redirectToPatientContentPage(context.ImageClick, context.ClientMedicationConsentId, result.Second, ImageClickDocumentVersionId, context.YellowClick, '');
        } else {
            RedirectToPatientConsentDetailPage("MedicationManagementPage");
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Changes Ended Over Here 

function onFailure(error) {
    try {

        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        //Added by Chandan for task#122 1.7 - Error Dialog on Session Timeout  
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        } else {
            alert(error.get_message());
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

var MedicationMgt = {
    FillMedicationControl: function (Panel, SortBy) {
       
      
        try {
            if (Panel === undefined) {
                Panel = PanelMedicationList;
            }
            if (SortBy === undefined) {
                SortBy = '';
            }
            PanelMedicationList = Panel;
            // Create the WebRequest object.
            wRequest = new Sys.Net.WebRequest();
            wRequest.set_url("AjaxScript.aspx?FunctionId=GetMedicationMgtList&par0=" + SortBy + "&container=MedicationMgt");
            wRequest.add_completed(MedicationMgt.OnFillMedicationControlCompleted);
            wRequest.set_userContext(Panel);
            wRequest.set_httpVerb("Post");
            var executor = new Sys.Net.XMLHttpExecutor();
            wRequest.set_executor(executor);
            executor.executeRequest();
            var started = executor.get_started();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    },
    CheckOTPForElectronicApproval: function (executor, eventArgs) {
        try {

            if (executor.get_responseAvailable()) {
                if (executor.get_statusCode() == 200) {
                    var data = executor.get_responseData();
                    if (data.indexOf('value=true') < 0) {
                        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").style.display = 'block';
                        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_ImageError").style.display = 'block';
                        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_tableErrorMessage").style.display = 'block';
                        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").innerHTML = 'Invalid OTP.';
                        return false;
                    }
                    else {
                        ApproveQueueorders(FieldClientMedicationScriptId);
                        return true;
                    }
                }
            }
            else {
                if (executor.get_timedOut())
                    alert("Timed Out");
                else if (executor.get_aborted())
                    alert("Aborted");
            }
        } catch (e) {
            Streamline.SmartClient.WebServices.CommonService.WriteToDatabase(data.toString(), 'CheckOTPForElectronicApproval', null)
            //Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    OnFillMedicationControlCompleted: function (executor, eventArgs) {
        try {
            if (executor.get_responseAvailable()) {
                var webReq = executor.get_webRequest();
                if (executor.get_statusCode() == 200) {
                    var Panel = webReq.get_userContext();
                    Panel.innerHTML = "";
                    var data = executor.get_responseData();
                    var indexofdiv = data.indexOf('</div>');
                    if (data.length > 545) {
                        data = data.substring(indexofdiv + 6, data.length);
                        var ScriptStart = data.indexOf('<script');
                        var ScriptEnd = data.indexOf('</script>');
                        var Script = data.substring(ScriptStart + 57, ScriptEnd);
                        var Rscript = document.createElement('script');
                        Rscript.text = Script;
                        Panel.appendChild(Rscript);
                        Panel.innerHTML = data + Panel.innerHTML;
                        RegisterMedicationListControlEvents();
                        MedicationMgt.AutoResizeMedicationList();
                    }
                }
            } else {
                if (executor.get_timedOut())
                    alert("Timed Out");
                else if (executor.get_aborted())
                    alert("Aborted");
            }
            if (parent.window.opener != undefined && parent.window.opener.RefreshTabPageContentFromExternalScreens != undefined) {
                parent.window.opener.RefreshTabPageContentFromExternalScreens('update', '');
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onSuccessfullDeletion: function (result, context, methodname) {
        try {
            try {
                if (parent.window.opener != undefined && parent.window.opener.RefreshTabPageContentFromExternalScreens != undefined) {
                    parent.window.opener.RefreshTabPageContentFromExternalScreens('update', '');
                }
            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
            var table = document.getElementById(context.TableId);
            var row = document.getElementById(context.RowId);
            var exitFlag = false;
            while (row != null) {
                if (row.cells[0].className == "blackLine")
                    exitFlag = true;
                row.style.display = 'none';

                if (exitFlag)
                    break;
                row = table.rows[row.rowIndex + 1];

            }
            var medTable = $('table[id^=MedicationList]', '#MedicationList1_PanelMedicationList')[0];
            var medRows = medTable.querySelectorAll("TR.GridViewRowStyle");
            for (var i = 0; i < medRows.length; i++) {
                if (medRows[i].style.display != 'none')
                    break;
                if (i == medRows.length - 1)
                    $('[id$=CheckBoxNoMedications]').removeAttr('disabled');
            }
            //Added By Anuj on 3 Dec,2009
            var QueueOrderRow = document.getElementById(context.RowId);
            QueueOrderRow = table.rows[QueueOrderRow.rowIndex - 1];
            if (QueueOrderRow.cells[0].className == "textbolditalic") {
                QueueOrderRow.style.display = 'none';
            }
            //Ended over here

            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
            wRequest = new Sys.Net.WebRequest();
            if (OrderName != "E" && OrderName != "N" && OrderName != "" && OrderName != undefined) {
                var datetime = new Date();
                window.open('DiscontinueMedicationRDLC.aspx?MedicationId=' + t.MedicationId + "&OrderName=" + OrderName + "&StaffId=" + t.StaffId + "&PharmacyId=" + pharmacyId + "&datetime=" + datetime.getMinutes() + datetime.getSeconds(), '', "menubar = 0,status = 0,resizable=no,scrollbars=yes,height=600px,width=800px,top=50px,left=50px");
                var executor = new Sys.Net.XMLHttpExecutor();
                wRequest.set_executor(executor);
                executor.executeRequest();
                var started = executor.get_started();
            }

        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    AutoResizeMedicationList: function () {
        // need to auto size the medication list.
        var smartCareRxFooter = $("#SmartCareRxFooter");
        var medicationListInformation = $("#MedicationListInformation");
        var panelMedicationList = $("[id$='PanelMedicationList']", medicationListInformation);

        if (panelMedicationList.length <= 0) return;
        var windowSize = $(window).height();
        var extraRoom = windowSize - ($("#SmartCareRxFooter").offset().top + $("#SmartCareRxFooter").height() + (parseInt($("#SmartCareRxFooter").css('margin-top'), 10) || 0));
        var newSize = medicationListInformation.height() + extraRoom;
        newSize = newSize < 300 ? 300 : newSize;
      
        medicationListInformation.height(newSize);
    },
    onDeleteClick: function (sender, e) {
        try {
            var context = new Object();
            context.sender = sender;
            context.e = e;
            Streamline.SmartClient.WebServices.ClientMedications.GenerateDiscontinueReasonDropDown(onSuccessfullDiscontinue, onFailure, context);
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    DeleateFromList: function (sender, e) {
        sessionStorage.setItem('sender', JSON.stringify(sender));
        sessionStorage.setItem('e', JSON.stringify(e));
        sessionStorage.setItem('DeleateFromList', "DeleateFromList");
        var div = "";
        if (!document.getElementById("divDiscontinueMain"))
            div = document.createElement('div');
        else {
            div = document.getElementById("divDiscontinueMain");
            div.style.display = "none";
        }
        div.id = "divDiscontinueMain";
        if ((sender.target.parentNode.getElementsByTagName("div").length < 1) && (sender.target.parentNode.getElementsByTagName("div").length != 1)) {
            sender.target.parentNode.appendChild(div);
        }
        var answer = window.showModalDialog('YesNo.aspx?CalledFrom=MedicationMgt', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
      
        if (sender == undefined || e == undefined) {
            var sender = JSON.parse(sessionStorage.sender);
            var e = JSON.parse(sessionStorage.e);
        }

        if (answer == 'Y') {
            try {
                var context = new Object();
                context.sender = sender;
                context.e = e;
                Streamline.SmartClient.WebServices.ClientMedications.GenerateDiscontinueReasonDropDown(onSuccessfullDiscontinue, onFailure, context);
            }
            catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
        }
    },

    ClientMedicationDiscontinue: function (TextBoxDiscontinueObject, DropDownListDiscontinueReasonCode, RadioButton_Fax, RadioButton_Print, RadioButton_None, dropdownPharmacies, RadioButton_EScript) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            //Code added by Loveena in ref to Task#2819.
            $("[id$=ImgError]").css('display', 'none');
            $("[id$=LabelError]").css('display', 'none');
            var strDiscontinueReason = "";
            strDiscontinueReason = TextBoxDiscontinueObject.value;
            //Code Added by Loveena in ref to Task#2487 to display DiscontinueReasonCode Drop-Down
            var DiscontinueReasonCode = "";
            DiscontinueReasonCode = DropDownListDiscontinueReasonCode.value;
            //code ends over here.
            //debugger;
            if (RadioButton_Fax.checked == true) {
                OrderName = "F";
            } else if (RadioButton_Print.checked == true) {
                OrderName = "P";
                pharmacyId = "";
            } else if (RadioButton_None.checked == true) {
                OrderName = "N";
                pharmacyId = "";
            } else if (RadioButton_EScript.checked == true) {
                OrderName = "E";
            }

            if (DiscontinueReasonCode == "0")
            {
                fnHideParentDiv();
                $("[id$=ImgError]").css('display', '');
                $("[id$=LabelError]").css('display', '');
                ShowError('Please Select Discontinue Reason.', true);
                return false;
            }

            if (RadioButton_Fax.checked == true && dropdownPharmacies != undefined) {
                pharmacyId = dropdownPharmacies.value;
                if (pharmacyId == "0") {
                    fnHideParentDiv();
                    $("[id$=ImgError]").css('display', '');
                    $("[id$=LabelError]").css('display', '');
                    ShowError('Please Select Pharmacy.', true);
                    return false;
                } else {
                    pharmacyId = dropdownPharmacies.value;
                }

            }
            if (t.ClientMedicationConsentId == 0 || t.ClientMedicationConsentId == null || t.ClientMedicationConsentId === undefined) {
                t.ClientMedicationConsentId = 0;
            }
            if (pharmacyId == "" || pharmacyId == null || pharmacyId === undefined) {
                pharmacyId = "0";
            }
            Streamline.SmartClient.WebServices.ClientMedications.DiscontinueMedication(
                t.MedicationId, t.MedicationScriptId, strDiscontinueReason, 'Y', DiscontinueReasonCode,
                t.ClientMedicationConsentId, t.SureScriptsOutgoingMessageId, OrderName,pharmacyId,
                MedicationMgt.onSuccessfullDeletion, onFailure, t);
        } catch (e) {
            Streamline.SmartClient.WebServices.CommonService.WriteToDatabase(e.toString(), 'ClientMedicationDiscontinue', null);
        }
    },
    onLinkClick: function (sender, e) {
        try {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            //Added OrderType in ref to Task#3273 - 2.6.1 Non-Ordered Medications: Allow Changes
            if (e.OrderType != "N")
                Streamline.SmartClient.WebServices.ClientMedications.SetOrderDetailsMedicationIdForMainPage(e.MedicationId, e.MedicationScriptId, MedicationMgt.onSuccessfullPopulationOfOrderDetails, onFailure);
            else if (e.OrderType == "N")
                Streamline.SmartClient.WebServices.ClientMedications.PopulateRowsforMedicationList(e.MedicationId, "UpdateMedication", 0, 0, '', '', '', '', onSuccessfullPopulation, onFailure, "Update Medication");
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }

    },
    onSuccessfullPopulationOfOrderDetails: function (result, context, methodname) {
        try {

            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
            redirectToOrderDetailsPage('PatientMainPage');
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    }
};

function onDrugInteractionClick(sender, e) {
    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        if (!sender.target.id || sender.target.tagName == "DIV") {
            fnHideParentDiv();
            return false;
        }
        if ((sender.target.id == "ImgCross") || (sender.target.id == "ImgCross1")) {
            closeDescDiv(sender.target.id);
            return;
        }

        Streamline.SmartClient.WebServices.ClientMedications.GetDrugInteractionText(e.InteractionId, onDrugInteractionSucceeded, onFailure, sender);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}


//Modified in ref to Task#2796

function onDrugInteractionSucceeded(result, context, methodname) {
    try {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        if (result == null || result.rows == null || !result.rows)
            return;
        var div1 = "";
        var divF = "";
        var NoSeverityRows = false;

        if (!document.getElementById("DivDescriptionContainer")) {
            var x = (screen.availWidth / 2) - 200;
            var y = ((screen.availHeight - 60) / 2) - 100;
            x = (x > 0) ? x : 0;
            y = (y > 0) ? y : 0;
            div1 = document.createElement('div');
            divF = document.createElement('iframe');
            divF.style.zindex = 98;
            divF.id = "IframeDescriptionContainer";
            div1.id = "DivDescriptionContainer";
            div1.className = "drugInteraction";
            div1.style.cursor = "default";
            div1.style.backgroundColor = "#ffffff";
            div1.style.zIndex = "99";
            div1.style.left = x;
            div1.style.top = y;
            //div.src='App_Themes/Includes/JS/HTMLPage.htm';
            div1.style.height = "400px";
            divF.style.position = "absolute";
            divF.height = 400;
            div1.style.position = "absolute";
            div1.style.overflow = "auto";
            // document.body.appendChild(div);
        } else {
            div1 = document.getElementById("DivDescriptionContainer");
            divF = document.getElementById("IframeDescriptionContainer");
        }
        if (result.columns.length <= 1) {


            //Changed by Loveena on 08-Jan-2009 as ref to task#144 to set the heading. 
            var TableHTML = [];

            TableHTML.push("<table class='PopUpTitleBar' width='603px'>");
            TableHTML.push("<tr>");
            TableHTML.push("<td width='95%' id='topborder' class='TitleBarText' align='left'>Interacting Medications Details</td>");
            TableHTML.push("<td align='right'>");
            TableHTML.push("<img id='ImgCross' class='PopUpTitleBar' onclick='closeDescDiv(this)' src='App_Themes/Includes/Images/cross.jpg' title='Close' alt='Close' />");
            TableHTML.push("</td>");
            TableHTML.push("</tr>");
            TableHTML.push("</table>");
            TableHTML.push("<table width='390px' border='0' cellpadding='0' cellspacing='0'>");
            //TableHTML.push("<tbody>");
            //code ends over here.
            TableHTML.push("<tr>");
            TableHTML.push("<td class='Label'>");
            TableHTML.push("<div id='InteractionDescriptions' style='font-size: 8.25pt; font-weight:normal; text-align:left; height:100%; padding: 5px;'></div>");
            TableHTML.push("</td>");
            TableHTML.push("</tr>");
            //TableHTML.push("</tbody>");
            TableHTML.push("</table>");

            div1.innerHTML = TableHTML.join("");
            NoSeverityRows = true;
            div1.style.height = "400px";
            div1.style.width = "620px";
        } else {
            //Changed by Loveena on 08-Jan-2009 as ref to task#144 to set the heading.
            var TableHTML = [];

            TableHTML.push("<table class='PopUpTitleBar' width='400px'>");

            //TableHTML= TableHTML + " <tbody>";
            TableHTML.push("  <tr> <td width='95%' id='topborder' class='TitleBarText' align='left'>");
            TableHTML.push("  Interacting Medications Details</td> <td align='right'> ");
            TableHTML.push("  <img id='ImgCross' class='PopUpTitleBar' onclick='closeDescDiv(this)' src='App_Themes/Includes/Images/cross.jpg'");
            TableHTML.push("  title='Close' alt='Close' /></td></tr>");
            TableHTML.push("</table> <table width='400px'>");
            TableHTML.push("<tbody>");
            //code ends over here.
            TableHTML.push(" <tr> <td class='DescriptionRow'>Severity</td> <td class='DescriptionRow'>Description</td><td></td><td></td></tr>");
            for (i = 0; i < result.rows.length; i++) {
                //Added by Chandan on 19th Nov 2008 
                //Ref Task #82 (1.6.5 - Drug Interactions Check Against Current Meds) 
                //To show Interacting Medications title in the Monograph Description pop up
                //Added one more parameter(InteractionId) in 'onDrugInteractionDescriptionClick' method
                //TableHTML= TableHTML + " <tr> <td> <span class='linkStyle'  onclick='onShowSeverity(this," + result.rows[i]["Severity"] + ")'>" + result.rows[i]["Severity"] + "</span> </td> <td style='text-align:left;'><span class='linkStyle' style='text-align:left' onclick='onDrugInteractionDescriptionClick(this," + result.rows[i]["MonoGraphId"] + ")'>" + result.rows[i]["Description"] + "</span></td><td></td><td></td></tr>";
                TableHTML.push(" <tr> <td> <span class='linkStyle'  onclick='onShowSeverity(this," + result.rows[i]["Severity"] + ")'>" + result.rows[i]["Severity"] + "</span> </td> <td style='text-align:left;'><span class='linkStyle' style='text-align:left' onclick='onDrugInteractionDescriptionClick(this," + result.rows[i]["MonoGraphId"] + "," + result.rows[i]["InteractionId"] + ")'>" + result.rows[i]["Description"] + "</span></td><td></td><td></td></tr>");
            }
            TableHTML.push(" </tbody></table> ");
            //document.frames('myfrm').document.body.document.getElementById(el);
            div1.innerHTML = TableHTML.join("");
            div1.style.height = 200;
            div1.style.width = 400;

        }

        divF.style.height = div1.style.height;
        divF.style.width = div1.style.width;
        divF.style.top = div1.style.top;
        divF.style.left = div1.style.left;
        if (context.target.getElementsByTagName("div").length < 1) {
            context.target.appendChild(div1);
            context.target.appendChild(divF);
        }
        document.getElementById("DivDescriptionContainer").style.display = "block";
        //What:Vithobha Changed from block to none for divF.style.display Why: Riverwood Support #804
        divF.style.display = "none";
        if (NoSeverityRows == true)
            DisplayMonographDescription(result.rows[0]["Description"], false);

        //div.contentWindow.document.body.innerHTML=TableHTML;

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function DisplayMonographDescription(varDataToBeDisplayed, varToBeDisplayedInMonographContainer) {
    if (varToBeDisplayedInMonographContainer)
        document.getElementById("MonoGraphDescriptions").innerHTML = varDataToBeDisplayed;
    else
        document.getElementById("InteractionDescriptions").innerHTML = varDataToBeDisplayed;
}


function onDrugInteractionDescriptionClick(context, MonographId, InteractionId) //Added by Chandan on 19th Nov 2008 - added a new parameter InteractionId
{
    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        //Added by Chandan on 19th Nov 2008 
        //Ref Task #82 (1.6.5 - Drug Interactions Check Against Current Meds) 
        //To show Interacting Medications title in the Monograph Description pop up        
        //Streamline.SmartClient.WebServices.ClientMedications.getMonographDescription(MonographId,onDrugInteractionDescriptionSucceeded,onFailure,context);
        Streamline.SmartClient.WebServices.ClientMedications.getMonographDescription(MonographId, InteractionId, onDrugInteractionDescriptionSucceeded, onFailure, context);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}


//Modified in ref to Task#2796

function onDrugInteractionDescriptionSucceeded(result, context, methodname) {
    try {
        var divM = "";
        var divF = "";
        if (!document.getElementById("DivMonoGraphContainer")) {

            divM = document.createElement('div');
            divF = document.createElement('iframe');

            divM.id = "DivMonoGraphContainer";
            divF.id = "IframeMonoGraphContainer";

            divM.className = "drugInteraction";
            divM.style.cursor = "default";
            divM.style.backgroundColor = "#ffffff";
            divM.style.width = 390;
            divM.style.height = 400;

            divM.style.zIndex = 101;
            divF.style.zIndex = 100;

            divM.style.left = -10;
            divM.style.top = -150;

            divM.style.position = "absolute";
            divF.style.position = "absolute";

            // document.appendChild(div);
        } else {
            divM = document.getElementById("DivMonoGraphContainer");
            divF = document.getElementById("IframeMonoGraphContainer");
        }

        if (context.parentNode.parentNode.childNodes[3].getElementsByTagName("div").length < 1) {
            context.parentNode.parentNode.childNodes[3].appendChild(divM);
            context.parentNode.parentNode.childNodes[3].appendChild(divF);
        }


        //Changed by Loveena on 08-Jan-2009 as ref to task#144 to set the heading.
        var TableHTML = [];

        TableHTML.push("<table class='PopUpTitleBar' width='390px'>");

        //TableHTML= TableHTML + " <tbody>";
        TableHTML.push("  <tr> <td width='95%' id='topborder' class='TitleBarText' align='left'>");
        TableHTML.push("  Interacting Medications Details</td> <td align='right'> ");
        TableHTML.push("  <img id='ImgCross1' class='PopUpTitleBar' onclick='closeDescDiv(this)' src='App_Themes/Includes/Images/cross.jpg'");
        TableHTML.push("  title='Close' alt='Close' /></td></tr>");
        TableHTML.push("</table> <table width='390px' border='0' cellpadding='0' cellspacing='0'>");
        TableHTML.push("<tbody>");
        //Code ends over here.
        //if (window.navigator.appVersion.indexOf('MSIE 7.0') > 0) {
        TableHTML.push(" <tr><td class='Label'>  <div id='MonoGraphDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow-Y:auto ;overflow-X:none; height:370px;'></div>  </td></tr></tbody></table> ");

        //        }
        //        else if (window.navigator.appVersion.indexOf('MSIE 6.0') > 0) {

        //            TableHTML = TableHTML + " <tr> <td class='Label'>  <div id='MonoGraphDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow-Y:auto ;overflow-X:none;height:370px;'></div>  </td></tr></tbody></table> ";

        //        }
        document.getElementById("DivMonoGraphContainer").innerHTML = TableHTML.join("");
        //   document.getElementById("MonoGraphDescriptions").innerHTML=result.rows[0]["Description"];

        divM.style.width = 390;
        divM.style.height = 400;
        divF.style.height = divM.style.height;
        divF.style.width = divM.style.width;
        divF.style.top = divM.style.top;
        divF.style.left = divM.style.left;


        document.getElementById("DivMonoGraphContainer").style.display = "block";
        document.getElementById("IframeMonoGraphContainer").style.display = "block";
        DisplayMonographDescription(result.rows[0]["Description"], true);
        return false;


    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    } finally {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    }

}


function onShowSeverity(obj, Severity) {
    try {
        if (!document.getElementById("DivSeverityContainer")) {

            divS = document.createElement('div');
            divF = document.createElement('iframe');

            divS.id = "DivSeverityContainer";
            divF.id = "IframeSeverityContainer";

            divS.className = "drugInteraction";
            divS.style.cursor = "default";
            divS.style.backgroundColor = "#ffffff";

            divS.style.zIndex = 101;
            divF.style.zIndex = 100;

            divS.style.left = -10;
            divS.style.top = -150;

            divS.style.height = "150px";
            divS.style.width = "300px";

            divS.style.position = "absolute";
            divF.style.position = "absolute";
        } else {
            divS = document.getElementById("DivSeverityContainer");
            divF = document.getElementById("IframeSeverityContainer");
        }

        if (obj.parentNode.parentNode.childNodes[3].getElementsByTagName("div").length < 1) {
            obj.parentNode.parentNode.childNodes[3].appendChild(divS);
            obj.parentNode.parentNode.childNodes[3].appendChild(divF);
        }

        var TableHTML = [];
        TableHTML.push("<table width='300px' height='100px'>");
        TableHTML.push(" <tbody>");
        TableHTML.push("  <tr> <td align='right' class='PopUpTitleBar' width='100%' colspan=2> ");
        TableHTML.push("  <img id='ImgCross2' onclick='closeDescDiv(this)' src='App_Themes/Includes/Images/cross.jpg'");
        TableHTML.push("  title='Close' alt='Close' /></td></tr>");
        switch (Severity) {
            case 1:
                {
                    TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; height:100px; width: 290px; word-wrap: break-word;'> Contraindicated Drug Combination: This drug combination <br> is contraindicated and generally should not be dispensed or <br> administered to the same patient.");
                    TableHTML.push(" Severe. These medicines<br> are not usually taken together. Contact your healthcare <br>professional (e.g. doctor or pharmacist) for more <br>information. ");
                    TableHTML.push(" </div>  </td></tr> ");
                    break;
                }
            case 2:
                {
                    TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; height:100px; width: 290px; word-wrap: break-word;'>Severe Interaction: Action is required to reduce the risk of <br> severe adverse interaction.");
                    TableHTML.push("   Serious. These medicines may <br> interact and cause very harmful effects. Contact your <br> healthcare professional (e.g. doctor or pharmacist) for more <br>information. ");
                    TableHTML.push(" </div>  </td></tr>");
                    break;
                }
            case 3:
                {
                    TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; height:100px; width: 290px; word-wrap: break-word;'>Moderate Interaction: Assess the risk to the patient and <br>take action as needed.");
                    TableHTML.push(" Moderate. These medicines may <br> cause some risk when taken together. Contact your <br> healthcare professional (e.g. doctor or pharmacist) for more <br>information.</div></td></tr>");
                    break;
                }
            case 4:
                {
                    TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px; width: 290px; word-wrap: break-word;'></div>  </td></tr>");
                    break;
                }
            case 5:
                {
                    TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px; width: 290px; word-wrap: break-word;'></div>  </td></tr>");
                    break;
                }
            case 6:
                {
                    TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px; width: 290px; word-wrap: break-word;'></div>  </td></tr>");
                    break;
                }
            case 7:
                {
                    TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px; width: 290px; word-wrap: break-word;'></div>  </td></tr>");
                    break;
                }
            case 8:
                {
                    TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; overflow:auto ;height:100px; width: 290px; word-wrap: break-word;'></div>  </td></tr>");
                    break;
                }
            case 9:
                {
                    TableHTML.push(" <tr> <td class='Label'>  <div id='SeverityDescriptions' style='font-size: 8.25pt; font-weight:normal;  text-align:left; height:100px; width: 290px; word-wrap: break-word;'> Undetermined Severity - Alternative Therapy Interaction:<br> Assess the risk to the patient and take action as needed.<br>");
                    TableHTML.push(" Unknown - Alternative Therapy Interaction. These <br>medications may cause some risk when taken together. <br>Contact your healthcare professional (e.g. doctor or<br> pharmacist) for more information. ");
                    TableHTML.push(" </div>  </td></tr>");
                    break;
                }
        }
        TableHTML.push(" </tbody></table> ");
        divS.innerHTML = TableHTML.join("");

        divF.style.height = divS.style.height;
        divF.style.width = divS.style.width;
        divF.style.top = divS.style.top;
        divF.style.left = divS.style.left;

        document.getElementById("DivSeverityContainer").style.display = "block";
        document.getElementById("IframeSeverityContainer").style.display = "block";
        return false;

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function closeDescDiv(imgId) {
    try {
        if (imgId != null) {
            if (imgId.id == "ImgCross") {
                document.getElementById("DivDescriptionContainer").style.display = "none";
                document.getElementById("IframeDescriptionContainer").style.display = "none";
            }
            if (imgId.id == "ImgCross1") {
                document.getElementById("DivMonoGraphContainer").style.display = "none";
                document.getElementById("IframeMonoGraphContainer").style.display = "none";
            }
            if (imgId.id == "ImgCross2") {
                document.getElementById("DivSeverityContainer").style.display = "none";
                document.getElementById("IframeSeverityContainer").style.display = "none";
            }
        }

    } catch (e) {
        // Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    } finally {
        fnHideParentDiv();
    }
}

function ValidateAllergySearchCriteria(txtAllergySearch) {

    var _txtAllergySearch = document.getElementById(txtAllergySearch);


    var objNaturalPattern = /^[\w ]+$/;


    if (_txtAllergySearch.value != '') {
        if (_txtAllergySearch.value.length <= 100 && _txtAllergySearch.value.length > 0) {
            if (_txtAllergySearch.value.match(objNaturalPattern) == null) {
                _txtAllergySearch.focus();
                ShowError('Please enter valid characters as search criteria', true);
                return false;

            }
        } else if (_txtAllergySearch.value.length > 100) {
            _txtAllergySearch.focus();
            ShowError('Please enter atleast 2 characters as search criteria', true);
            return false;
        }
    }
    ShowError('', false);


    return true;
}


function ShowClientSearchDiv(clientId) {
    try {
       
        ShowError('', false);
        var DivSearch = parent.document.getElementById('DivSearch');
        DivSearch.style.display = 'block';

        var iFrameSearch = parent.document.getElementById('iFrameSearch');
        iFrameSearch.src = 'ClientSearch.aspx?SelectedClientId=' + clientId;
        iFrameSearch.style.positions = 'absolute';
        iFrameSearch.style.left = '10px';
        iFrameSearch.style.width = '630px';
        iFrameSearch.style.height = '370px';
        iFrameSearch.style.top = '20px';
        iFrameSearch.style.scrollbars = 'yes';
        iFrameSearch.style.display = 'block';
        fnHideParentDiv();
        $(iFrameSearch).draggable();
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}

function onHeaderClick(obj) {
    try {
        var sortBy = obj.getAttribute("SortOrder");
        var ColumnName = obj.getAttribute("ColumnName");
        if (sortBy == "") {
            sortBy = "Asc";

        }
        ColumnName = ColumnName + " " + sortBy;
        FillMedicationControl(PanelMedicationList, ColumnName);

    } catch (e) {

    }
}

//added by Rohit. ref #90

function ShowSystemReport(stringReportName, stringURL) {
    try {

        var stringMedicationIds = "";
        ShowError('', false);
        var context = "Change";

        // fnShow();


        if (stringURL.indexOf('<SessionId>') > 0) {
            var i = 0;
            var lengthOfArray = MedicationIds.length;
            if (lengthOfArray == 0) {
                ShowError('At least one Medication must be selected before running this report', true);
                return false;
            }

            for (i = 0; i < lengthOfArray; i++)
                if (stringMedicationIds == '')
                    stringMedicationIds += String(MedicationIds[i]);
                else
                    stringMedicationIds += ',' + String(MedicationIds[i]);

            fnShow();
            Streamline.SmartClient.WebServices.ClientMedications.ShowSystemReports(stringReportName, stringURL, stringMedicationIds, onSuccessShowSystemReports, onSyatemReportFailure);
        } else if (stringURL.indexOf('<ClientId>') > 0) {
            fnShow();
            Streamline.SmartClient.WebServices.ClientMedications.ShowSystemReports(stringReportName, stringURL, stringMedicationIds, onSuccessShowSystemReports, onSyatemReportFailure);
        } else {
            document.getElementById("test").href = stringURL;
            document.getElementById("test").click();

        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}


//added by Rohit. ref #90

function onSuccessShowSystemReports(result, context, methodname) {
    fnHideParentDiv();
    if (result == null)
        return;

    document.getElementById("test").href = result;
    document.getElementById("test").click();


}

//added by Rohit. ref #90

function onSyatemReportFailure(error) {
    try {
        fnHideParentDiv();
        //Added by Chandan for task#122 1.7 - Error Dialog on Session Timeout  
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        } else {
            alert(error.get_message());
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//added by Rohit. ref #90

function FillSystemReports() {
    try {
        //fnShow();
        Streamline.SmartClient.WebServices.ClientMedications.FillSystemReports(onFillSystemReports, onFailSystemReports);


    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}


//added by Rohit. ref #90

function onFillSystemReports(result, context, methodname) {
    fnHideParentDiv();
    if (result == null || result == '<>')
        return;

    var str1 = result.split('<>'); //split into two. text and value
    var s1 = str1[0].split('><'); //split text
    var s2 = str1[1].split('><'); //split value

    if ($("select[Id$=DropDownListReports]").length > 0) {
        var dropdown = document.getElementById("DropDownListReports");
        var i = 0;
        while (i < s1.length) {
            var optn1 = document.createElement("OPTION");
            optn1.text = s1[i]; //"111anyText" + result;
            optn1.value = s2[i]; // "www.22xyz.com";
            dropdown.options[i] = optn1;
            i += 1;
        }
    }
}

//added by Rohit. ref #90

function onFailSystemReports(error) {
    try {
        fnHideParentDiv();
        //Added by Chandan for task#122 1.7 - Error Dialog on Session Timeout  
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        } else {
            alert(error.get_message());
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Added by Chandan for task Harbor

function ShowClientSearch(clientId) {
    try {
     

        clientId = clientId || "";
        
        var DivSearch = parent.document.getElementById('DivSearch');
        DivSearch.style.display = 'block';
        var iFrameSearch = parent.document.getElementById('iFrameSearch');
        iFrameSearch.src = 'ClientSearch.aspx?SelectedClientId=' + clientId;
        iFrameSearch.style.positions = 'absolute';
        iFrameSearch.style.left = '10px';
        iFrameSearch.style.width = '630px';
        iFrameSearch.style.height = '370px';
        iFrameSearch.style.top = '20px';
        iFrameSearch.style.scrollbars = 'yes';
        iFrameSearch.style.display = 'block';
        fnHideParentDiv();
        $(iFrameSearch).draggable();
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}


function pageLoadSelectClient(SelectedClientId) {
    var ClientFoundflag = false;
    var output = document.getElementById('<%=DropDownListClients.ClientID%>');
    for (var i = 0; i < output.length; i++) {
        if (output[i].value.indexOf(SelectedClientId) == 0) {
            ClientFoundflag = true;
            break;
        }

    }
    if (ClientFoundflag == true)
        document.getElementById('<%=DropDownListClients.ClientID%>').value = SelectedClientId;

    pageLoad();

}

//Created by Chandan on 11th May 2009 for Update the PatientConsent Record task#2433  
//Added by Anuj on

function UpdatePatientConsent(ObjValue, IsCustomPage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip, ClientMedicationConsentId, sigFileContent, NoPasswordRequired) {
    isStaff = RadioButtonMedicalStaff;
    try {
        var context = new Object();
        var eSignature = "";
        //Code added by Loveena in ref to Task#2962
        parent.$("input[id$=HiddenFieldImageConsentClick]").val("");
        //*******************************************************************
        //document.frames[1].document.body.document.getElementById("TextBoxClientSignatureDummy").value
        if (document.form1.TextBoxClientSignatureDummy != undefined) {
            if (document.form1.TextBoxClientSignatureDummy.value != "")
                eSignature = document.form1.TextBoxClientSignatureDummy.value;
        } else {
            if ((NoPasswordRequired != "True" || isStaff == false) && document.frames[1].document.body.document.getElementById("TextBoxClientSignatureDummy").value != "")
                eSignature = document.frames[1].document.body.document.getElementById("TextBoxClientSignatureDummy").value;
        }

        var IsSignaturePad = false;
        if (document.getElementById('RadioSignaturePad') != null || document.getElementById('RadioCanvasSignature') != null) {
            if (document.getElementById('RadioSignaturePad').checked == true)
                IsSignaturePad = true;
            else if (document.getElementById('RadioCanvasSignature').checked == true)
                IsSignaturePad = true;
        }
        else {
            if ((NoPasswordRequired != "True" || isStaff == false) && document.frames[1].document.body.document.getElementById('RadioSignaturePad').checked == true)
                IsSignaturePad = true;
        }
        if (DropDownRelationShip == "")
            DropDownRelationShip = 0;
        //******************************************************************
        context.RadioButtonMedicalStaff = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff');
        context.RadioButtonPatient = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient');
        context.RadioButtonRelation = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation');
        context.TextBoxSignatureName = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName');
        context.DropDownConsentList = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownConsentList');
        context.LabelSignedNotSigned = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelSignedNotSigned');
        context.DropDownRelationShip = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip');
        context.IFrameDocuments = parent.document.getElementById('IFrameDocuments');
        context.ReportUrl = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldReportUrl');
        //Modified by Anuj on 21 Dec,2009
        context.ClientMedicationConsentId = ClientMedicationConsentId;
        context.ButtonSign = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonSign');
        //Ended Over here
        //Added by Anuj for Task ref:2932 (Medication Management)
        //context.ButtonConsentEdit = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonConsentEdit');
        //Ended over here

        var IsClientSignedPaper = 'N';

        if (document.getElementById('CheckBoxSignedPaperDocument') != null) {
            if (document.getElementById('CheckBoxSignedPaperDocument').checked == true)
                IsClientSignedPaper = 'Y';
        } else {
            if ((NoPasswordRequired != "True" || isStaff == false) && document.frames[1].document.body.document.getElementById('CheckBoxSignedPaperDocument').checked == true)
                IsClientSignedPaper = 'Y';
        }
        if (sigFileContent == undefined)
            Streamline.SmartClient.WebServices.ClientMedications.UpdatePatientConsent(ObjValue, IsCustomPage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip, eSignature, IsSignaturePad, IsClientSignedPaper, ClientMedicationConsentId, onSuccessfullUpdatePatientConsent, onFailure, context);
        else
            Streamline.SmartClient.WebServices.ClientMedications.UpdatePatientConsent1(ObjValue, IsCustomPage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip, eSignature, IsSignaturePad, IsClientSignedPaper, ClientMedicationConsentId, sigFileContent, onSuccessfullUpdatePatientConsent, onFailure, context);

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Created by Chandan on 11th May 2009 for Update the PatientConsent Record task#2433

function onSuccessfullUpdatePatientConsent(result, context) {
    try {
        var DivSearch = parent.document.getElementById('DivSearch');
        DivSearch.style.display = 'none';
        //fnHideParda();
        //Code added by Loveena to insert value of DocumentVersionId
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDocumentVersionId').value = result;
        if (context.RadioButtonMedicalStaff.checked == true) {
            context.RadioButtonMedicalStaff.checked = false;
            context.RadioButtonMedicalStaff.disabled = true;
            context.RadioButtonPatient.checked = true;
            context.RadioButtonPatient.disabled = false;
            context.RadioButtonRelation.disabled = false;
            context.DropDownConsentList.disabled = true;
            context.DropDownRelationShip.disabled = false;
            context.TextBoxSignatureName.disabled = false;
            //Added By Anuj for Task ref:2932 (Madication Management)
            //context.ButtonConsentEdit.disabled = true;
            parent.document.getElementById('ButtonConsentEdit').disabled = true;
            parent.document.getElementById('ButtonRevoke').disabled = false;
            //Ended over here

            //Code added by Loveena in ref to Task#2564 1.9.5.5 Patient Consent - Add "Print" Button 
            //To enable Print Button after Medical Staff Signs document.
            parent.document.getElementById('ButtonPrint').disabled = false;
            //Code ends over here.
            context.LabelSignedNotSigned.innerText = "Signed by Medical Staff";
            //parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldSignedBy').value="Signed by Medical Staff";
            if (context.DropDownConsentList.value > 0) {
                context.IFrameDocuments.src = context.ReportUrl.value + '&DocumentVersionId =' + result;
            } else {
                //context.IFrameDocuments.src = "Test1.aspx";
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_anchorId').click();
            }
        } else {
            if (context.ClientMedicationConsentId != null && context.ClientMedicationConsentId != "" && context.ClientMedicationConsentId != "undefined") {
                context.LabelSignedNotSigned.innerText = "Signed by Patient";
                context.ButtonSign.disabled = true;
                context.RadioButtonPatient.checked = false;
                context.RadioButtonPatient.disabled = true;
                context.RadioButtonRelation.disabled = true;
                context.RadioButtonRelation.checked = false;
                context.DropDownRelationShip.disabled = true;
                context.TextBoxSignatureName.disabled = true;
            }
            context.LabelSignedNotSigned.innerText = "Signed by Patient";
            context.ButtonSign.disabled = true;
            context.RadioButtonPatient.checked = false;
            context.RadioButtonPatient.disabled = true;
            context.RadioButtonRelation.disabled = true;
            context.RadioButtonRelation.checked = false;
            context.DropDownRelationShip.disabled = true;
            context.TextBoxSignatureName.disabled = true;

            // parent.redirectToManagementPage();
            if (context.DropDownConsentList.value > 0) {
                context.IFrameDocuments.src = context.ReportUrl.value + '&DocumentVersionId =' + result;
            } else
                //context.IFrameDocuments.src = "Test1.aspx";
            {
                //context.IFrameDocuments.src = "Test1.aspx";
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_anchorId').click();
            }
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

function ShowPrintDiv(ClientMedicationIds, IsStaffSign) {
    try {
        var datetime = new Date();
        parent.document.getElementById('IFrameDocuments').src = "ConsentStandardReportViewer.aspx?&currentDate='" + datetime.getMinutes() + datetime.getSeconds() + "'&varClientMedicationIds=" + ClientMedicationIds + "&ReportViewer=" + true;
        if ($("[id*=HiddenFieldImageConsentClick]").val() != "Patient Consent") {
            if (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldSignedBy').value == "") {

                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelSignedNotSigned').innerText = "Signed by Medical Staff";
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldSignedBy').value = "Signed by Medical Staff";
                //Added by Anuj for task ref:2932 (Medication Management)
                parent.$("[id*=ButtonConsentEdit]")[0].disabled = true;
                parent.$("[id*=ButtonRevoke]")[0].disabled = false;
                //Ended over here
            } else if (IsStaffSign == "Y") {
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelSignedNotSigned').innerText = "Signed by Medical Staff";
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldSignedBy').value = "Signed by Medical Staff";
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonSign').disabled = false;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = false;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked = true;

                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked = false;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').disabled = false;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').disabled = false;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').disabled = false;
                //Added by Anuj for task ref:2932 (Medication Management)
                parent.document.getElementById('ButtonConsentEdit').disabled = true;
                parent.document.getElementById('ButtonRevoke').disabled = false;
                //Ended over here
            } else if (IsStaffSign == "G") {
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelSignedNotSigned').innerText = "Signed by Patient";
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldSignedBy').value = "Signed by Patient";
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonSign').disabled = true;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = true;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked = false;

                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked = false;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').disabled = true;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').disabled = true;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').disabled = true;

                parent.document.getElementById('ButtonConsentEdit').disabled = true;
                parent.document.getElementById('ButtonRevoke').disabled = false;

            } else {
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelSignedNotSigned').innerText = "Signed by Patient";
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldSignedBy').value = "Signed by Patient";
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonSign').disabled = true;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = true;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked = false;

                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked = false;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').disabled = true;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').disabled = true;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').disabled = true;
                //Added by Anuj for task ref:2932 (Medication Management)
                parent.document.getElementById('ButtonConsentEdit').disabled = true;
                parent.document.getElementById('ButtonRevoke').disabled = false;
                //Ended over here


            }
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').disabled = true;
            if (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonSign').disabled == true) {
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = true;
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked = false;
            } else {
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = false;
            }
            //Code added by Loveena in ref to Task#2564 1.9.5.5 Patient Consent - Add "Print" Button 
            //To enable Print Button after Medical Staff Signs document.
            parent.document.getElementById('ButtonPrint').disabled = false;
            //Code ends over here.
            if (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked == true) {
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked = true;
            } else {
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked = true;
            }
            if (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonSign').disabled == true) {
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked = false;
            }
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownConsentList').disabled = true;
        } else {
            if ($("input[id$=HiddenFieldImageConsentClick]").val() == "Patient Consent" && $("input[id$=ButtonConsentEdit]").val() == "View") {
                parent.document.getElementById('ButtonPrint').disabled = true;
                parent.$("input[id$=ButtonSign]")[0].disabled = false;
                parent.$("[id*=RadioButtonMedicalStaff]")[0].disabled = false;
                parent.$("[id*=RadioButtonMedicalStaff]")[0].checked = true;
                parent.$("[id*=RadioButtonPatient]")[0].disabled = true;
                parent.$("[id*=RadioButtonRelation]")[0].disabled = true;
                parent.$("[id*=DropDownRelationShip]")[0].disabled = true;
                parent.$("[id*=LabelSignedNotSigned]").val("Not Signed");
            }
            if ($("input[id$=HiddenFieldImageConsentClick]").val() == "Patient Consent" && $("input[id$=ButtonConsentEdit]").val() == "Edit") {
                parent.document.getElementById('ButtonPrint').disabled = false;
                parent.$("input[id$=ButtonSign]")[0].disabled = false;
                parent.$("[id*=RadioButtonMedicalStaff]")[0].disabled = false;
                parent.$("[id*=RadioButtonMedicalStaff]")[0].checked = true;
                parent.$("[id*=RadioButtonPatient]")[0].disabled = true;
                parent.$("[id*=RadioButtonRelation]")[0].disabled = true;
                parent.$("[id*=DropDownRelationShip]")[0].disabled = true;
                parent.$("[id*=LabelSignedNotSigned]").val("Not Signed");
            }
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    //return false;
}


function OpensignaturePad() {
    var NoPasswordRequired = $('[id$=HiddenFieldDocumentSignaturesNoPassword]').val();
    var StaffPassword = $('[id$=HiddenFieldStaffPassword]').val();
    var isStaff2 = $('[id$=RadioButtonMedicalStaff]')[0].checked;
    //var isStaff2 = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked;
    try {

        //Modified by : Malathi shiva : WRT : Valley - Support Go Live	Task# 73
        //Purpose: When we sign a Consent screen by selecting Relation without a signer name, 
        //It tries to open the signature pop up but fails to open the pop up but throws the validation for Signer name.
        //When we have a validation in Consent screen, but tries to find the controls from the Signature pop up in UpdateDocuments functions
        if (Validate() == false)
            return false;
        else {
            if (NoPasswordRequired != "True" || isStaff2 == false) {
                var $divSearch = $("#DivSearch");
                $("#topborder", $divSearch).text("Get Signature");
                var $iFrameSearch = $('#iFrameSearch', $divSearch);
                $iFrameSearch.attr('src', 'SignaturePage.aspx?');
                $iFrameSearch.css({ 'width': '600px', 'height': '300px' });
                var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
                left = left > 0 ? left : 10;
                var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
                top = top > 0 ? top : 10;
                $divSearch.css({ 'top': top, 'left': left });
                $divSearch.draggable();
                //Vithobha added enable/ disable of draggable for sign pop up, Key Point Enviornment Issue Tracking 118
                $divSearch.mousedown(function () {
                    $("#DivSearch").draggable("enable");
                });
                $divSearch.mouseup(function () {
                    $("#DivSearch").draggable("disable");
                });
                $divSearch.css('display', 'block');
            } else {
                UpdateDocuments(StaffPassword, NoPasswordRequired);
            }
        }
    } catch (e) {
    }

}

//function OpenDocuments(Url)
//Modified By Anuj on 30 nov, 2009 for task ref# 18 SDI venture 10

function OpenDocuments(Url, ImageConsentClickValue, CheckImageClick) {
    //Added By Anuj on 30Nov,2009 for task ref 18
    parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = true;
    //Ended over here
    //Code added by Loveena in ref to Task#2564 1.9.5.5 Patient Consent - Add "Print" Button 
    //To enable Print Button after Medical Staff Signs document.
    parent.document.getElementById('ButtonPrint').disabled = true;
    //Code ends over here.
    //Condition added by Loveena in ref to Task#2962
    if ($("input[id$=HiddenFieldImageConsentClick]").val() == "Patient Consent" && $("input[id$=ButtonConsentEdit]").val() == "View") {
        parent.document.getElementById('ButtonPrint').disabled = true;
        parent.$("input[id$=ButtonSign]")[0].disabled = false;
        parent.$("[id*=RadioButtonMedicalStaff]")[0].disabled = false;
        parent.$("[id*=RadioButtonMedicalStaff]")[0].checked = true;
        parent.$("[id*=RadioButtonPatient]")[0].disabled = true;
        parent.$("[id*=RadioButtonRelation]")[0].disabled = true;
        parent.$("[id*=DropDownRelationShip]")[0].disabled = true;
        parent.$("[id*=LabelSignedNotSigned]").val("Not Signed");
    }
    if ($("input[id$=HiddenFieldImageConsentClick]").val() == "Patient Consent" && $("input[id$=ButtonConsentEdit]").val() == "Edit") {
        parent.document.getElementById('ButtonPrint').disabled = false;
        parent.$("input[id$=ButtonSign]")[0].disabled = true;
        parent.$("[id*=RadioButtonMedicalStaff]")[0].disabled = false;
        parent.$("[id*=RadioButtonMedicalStaff]")[0].checked = true;
        parent.$("[id*=RadioButtonPatient]")[0].disabled = true;
        parent.$("[id*=RadioButtonRelation]")[0].disabled = true;
        parent.$("[id*=DropDownRelationShip]")[0].disabled = true;
        parent.$("[id*=LabelSignedNotSigned]").val("Not Signed");
    }
    //Modified By Anuj on 30Nov,2009 for task ref 18
    if (ImageConsentClickValue === undefined || ImageConsentClickValue == "") {
        //Added in ref to Task#2962
        parent.$("input[id$=ButtonConsentEdit]")[0].disabled = false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked = true;
    } else if (CheckImageClick == "Y") {
        //Code added by Loveena in ref to Task#2962 yo make Edit Button disable if page opened from Freen or Yellow check
        parent.$("input[id$=ButtonConsentEdit]")[0].disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').disabled = false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').disabled = false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').disabled = false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked = false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelSignedNotSigned').innerText = "Signed by Medical Staff";
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownConsentList').disabled = true;
        //parent.document.getElementById('ButtonPrint').disabled=false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldSignedBy').value = "Signed by Medical Staff";
    } else if (CheckImageClick == "G") {
        //Added in ref to Task32962
        parent.$("input[id$=ButtonConsentEdit]")[0].disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked = false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = true;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked = false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelSignedNotSigned').innerText = "Signed by Patient";
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownConsentList').disabled = true;
        //parent.document.getElementById('ButtonPrint').disabled=false;
        parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldSignedBy').value = "Signed by Patient";
    }

    //Ended over here
    if (Url != "HarborConsent.aspx") {
        document.getElementById('dvWaiting').style.display = 'block';
    }
    parent.document.getElementById('IFrameDocuments').src = Url;
}

function CallBackPageLoad(ObjValue, Status, PageName) {
    //alert('CallBackPageLoad');    
    document.getElementById('dvWaiting').style.display = 'none';
}

//Added by Loveena on 18-May-2009 to enter Signer Name if Signed by relation is selected.

function Validate() {
    var LabelErrorMessage = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelErrorMessage');
    var ImageError = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ImageError');
    LabelErrorMessage.innerText = "";
    ImageError.style.display = 'none';
    if (document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked == true && document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').selectedIndex == 0) {
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        LabelErrorMessage.innerText = 'Please Select Relation';
        return false;
    }

    if (document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked == true && document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').selectedIndex > 0) {
        if (document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').value == "") {
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = 'Please Enter Signer Name';
            return false;
        }
    }
    return true;
}

function UpdateDocuments(UserPassword, NoPasswordRequired) {
    var UserPassword1 = '';
    try { //Added by anuj 01 Dec 2009      
       
        var ImageClientmedicationConsentId = parent.document.getElementById('HiddenFieldImageClientmedicationConsentId').value;
        if (NoPasswordRequired == "True" || document.getElementById('RadioPassword').checked == true) {
            if (document.getElementById('TextBoxPassword') != null) {
                UserPassword1 = document.getElementById('TextBoxPassword').value;
                ValidatePassword(UserPassword1, NoPasswordRequired);
            }
            else {
                onSucessValidatePassword(true);
            }
        } else {
            if (GetSignature()) {
                var _documentDatset = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDataSet').value;
                var IsCustompage = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownConsentList').value;
                var ObjValue = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDataSet').value;
                var RadioButtonMedicalStaff = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked;
                var RadioButtonPatient = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked;
                var RadioButtonRelation = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked;
                var TextBoxSignatureName = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').value;
                var DropDownRelationShip = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').value;
                if (RadioButtonRelation == true && DropDownRelationShip == 0) {
                    ShowDocumentsError('Please Select RelationShip', true);
                    return false;
                }
                if (IsCustompage > 0) {
                    if (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked == true) {
                        parent.window.frames[0].InvokeMethod('Update', _documentDatset, 'ButtonClicked');
                    } else {
                        UpdatePatientConsent(ObjValue, IsCustompage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip, ImageClientmedicationConsentId, document.form1.TextBoxClientSignatureDummy.value);
                    }
                } else {
                    UpdatePatientConsent(ObjValue, IsCustompage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip, ImageClientmedicationConsentId, document.form1.TextBoxClientSignatureDummy.value);
                }
                return true;
            }
            return false;
        }
    } catch (ex) {
        alert(ex);
    }
}

//Password Validation
function ValidatePassword(UserPassword, NoPasswordRequired) {
    Streamline.SmartClient.WebServices.ClientMedications.ValidatePassword(UserPassword, NoPasswordRequired, onSucessValidatePassword, onFailureValidatePassword);
}

function onSucessValidatePassword(result) {
    var ImageClientmedicationConsentId = parent.document.getElementById('HiddenFieldImageClientmedicationConsentId').value;
    var NoPasswordRequired = $('[id$=HiddenFieldDocumentSignaturesNoPassword]').val();
    if (result == true) {
        var _documentDatset = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDataSet').value;
        var IsCustompage = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownConsentList').value;
        var ObjValue = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDataSet').value;
        var RadioButtonMedicalStaff = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked;
        var RadioButtonPatient = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked;
        var RadioButtonRelation = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked;
        var TextBoxSignatureName = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').value;
        var DropDownRelationShip = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').value;
        if (RadioButtonRelation == true && DropDownRelationShip == 0) {
            ShowDocumentsError('Please Select RelationShip', true);
            return false;
        }
        if (IsCustompage > 0) {
            if (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked == true) {
                parent.window.frames[0].InvokeMethod('Update', _documentDatset, 'ButtonClicked');
            } else {
                UpdatePatientConsent(ObjValue, IsCustompage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip, ImageClientmedicationConsentId);
            }
        } else {
            UpdatePatientConsent(ObjValue, IsCustompage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip, ImageClientmedicationConsentId, undefined, NoPasswordRequired);
        }
        return true;
    } else {
        alert('Please Enter Valid Password');
        document.getElementById('TextBoxPassword').value = "";
        document.getElementById('TextBoxPassword').focus();
        return false;
    }
}

function onFailureValidatePassword(error) {
    try {
        alert(error.get_message());
    } catch (e) {
    }


}

function CallBackUpdate(ObjValue, Status, PageName) {
    try {
        if (Status == "True") {
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDataSet').value = ObjValue;
            var b1 = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonUpdate');
            var IsCustompage = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownConsentList').value;
            var RadioButtonMedicalStaff = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked;
            var RadioButtonPatient = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked;

            var RadioButtonRelation = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked;
            var TextBoxSignatureName = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').value;

            var DropDownRelationShip = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').value;
            //Added on 29 Dec, fro tsk ref #18,19 SDI venture-10
            var ClientMedicationConsentId = "";
            if (parent.document.getElementById('HiddenFieldImageClientmedicationConsentId') == "undefined") {
                ClientMedicationConsentId = "";
            } else {
                ClientMedicationConsentId = parent.document.getElementById('HiddenFieldImageClientmedicationConsentId').value;
            }
            //Ended over here
            //Modified on 29 Dec, fro tsk ref #18,19 SDI venture-10
            UpdatePatientConsent(ObjValue, IsCustompage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip, ClientMedicationConsentId);
            return true;
        } else {
            if (ObjValue == "")
                ShowDocumentsError("There is an Eroor while updating", true);
            else
                ShowDocumentsError(ObjValue, true);

        }

    } catch (ex) {
        alert(ex);
    }
}

function CallBackDeactivateDocument(ObjValue, Status) {
    alert('CallBackDeactivateDocument');
}


function ShowDocumentsError(ErrorMessage, Show) {
    try {


        var LabelErrorMessage = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelErrorMessage');
        var DivErrorMessage = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DivErrorMessage');
        var ImageError = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ImageError');
        //Code Added by Loveena Ends Here.
        if (Show == true) {
            //DivErrorMessage.style.display = 'block';  
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = ErrorMessage;
        } else {
            LabelErrorMessage.innerText = "";
            ImageError.style.visibility = 'hidden';
        }

    } catch (ex) {
        alert(ex);

    }
}

//Added by Chandan on 25 May 2008 For Signature Functionality

function GetSignature() {
    try {

        if (document.getElementById('RadioCanvasSignature').checked) {
            var api = $('.sigPad').signaturePad();
            if (!api.validateForm()) {
                alert('No Signature was detected,please try signing again,if you continue to recieve this error contact your system administrator.')
                document.getElementById('RadioCanvasSignature').checked = true;
                return false;
            }
            var sig = api.getSignatureImage();
            SignatureString = sig.replace('data:image/png;base64,', '');
        }

        // Check for empty electronic Signature.
        // Added by ponnin For task #230 of Engineering Improvement Initiatives- NBL(I)
        if (document.getElementById('RadioSignaturePad').checked == true) {
            if (IsSigWebInstalled && objCanvasCheck) {
                if (GetSigString() == "300D0A300D0A") {
                    alert('No Signature was detected,please try signing again,if you continue to recieve this error contact your system administrator.');
                    return false;
                }
            } else {
                if (document.form1.SigPlus1.SigString == "300D0A300D0A00000000000000000000000000000000000000000000000000000000000000000000") {
                    alert('No Signature was detected,please try signing again,if you continue to recieve this error contact your system administrator.');
                    return false;
                }
            }
        }

        if ((IsSigWebInstalled || document.getElementById('RadioCanvasSignature').checked) && objCanvasCheck) {
            var oCanvas = document.getElementById('cnv');
            var oCanvasDataURL = oCanvas.toDataURL('image/png');
            if (document.getElementById('RadioCanvasSignature').checked) {
                document.form1.TextBoxClientSignatureDummy.value = "SIGWEBINSTALLED" + SignatureString;
            }
            else {
                document.form1.TextBoxClientSignatureDummy.value = "SIGWEBINSTALLED" + oCanvasDataURL.replace('data:image/png;base64,', '');
            }
        } else
            if (document.form1.SigPlus1.NumberOfTabletPoints > 0) {
                document.form1.SigPlus1.TabletState = 0; //Turns tablet off
                document.form1.SigPlus1.AutoKeyStart();
                document.form1.SigPlus1.AutoKeyFinish();
                document.form1.SigPlus1.EncryptionMode = 2;
                document.form1.SigPlus1.SigCompressionMode = 1;
                document.form1.TextBoxClientSignatureDummy.value = document.form1.SigPlus1.SigString;
                document.form1.SigPlus1.ImageFileFormat = 4;
                document.form1.SigPlus1.ImageXSize = 256;
                document.form1.SigPlus1.ImageYSize = 128;
            }

        IsSigpadNotSigned = false;
        return true;


    } catch (ex) {
        alert(ex);
    }
}

//Get Verbal Order Review Data added by Mohit 13 Nov in ref to Task#3
function GetVerbalOrderReviewData(ClientMedicationScriptId, DrugCategory) {
    MedicationIds.length = 0;
    var p = document.getElementById("radioPrint").checked;
    document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_HiddenDrugCategory").value = DrugCategory;
    document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_divReportViewer").innerHTML = "";
    Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.GetVerbalOrderReviewData(ClientMedicationScriptId, onSuccessfullGetVerbalOrderReviewData, onFailure);

}
var scriptId;
function noteClientMedicationScriptId(scriptId) {
    document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").innerHTML = '';
    document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").style.display = 'none';
    document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_ImageError").style.display = 'none';
    document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_tableErrorMessage").style.display = 'none';
    if (scriptId != "") {
        // False and 'Y' is hard coded because 
        MedicationIds.push(scriptId);
        ApprovalStatus.push("False");
        Ordered.push('Y');
    }
}




function onSuccessfullGetVerbalOrderReviewData(result, context, methodname) {
    if (result != null && result.tables.length > 0) {
        if (result.tables[0].rows[0]["VerbalOrderApproved"] != null && result.tables[0].rows[0]["VerbalOrderApproved"] == "Y") {
            //This one is added becuase in Queued Order we do not have RetractOrder button, So it will throw error at this line since the button is not found, Defensive code
            if ($("#HiddenFieldVerbal").val() != "A") {
                document.getElementById("ButtonRetractOrder").disabled = false;
            }
            document.getElementById("ButtonApproveOrder").disabled = true;
        } else {
            if ($("#HiddenFieldVerbal").val() != "A") {
                document.getElementById("ButtonRetractOrder").disabled = true;
            }
            document.getElementById("ButtonApproveOrder").disabled = false;
        }

        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_lblClientName").innerHTML = result.tables[0].rows[0]["LastName"] + ", " + result.tables[0].rows[0]["FirstName"];
        if (result.tables[0].rows[0]["DOB"] != null)
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_lblDob").innerHTML = result.tables[0].rows[0]["DOB"];
        else
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_lblDob").innerHTML = "";
        if (result.tables[0].rows[0]["LocationName"] != null) {
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_lblPrescribinglocation").innerHTML = result.tables[0].rows[0]["LocationName"];
        } else
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_lblPrescribinglocation").innerHTML = "";
        if (result.tables[0].rows[0]["PharmacyName"] != null) {
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_lblPharmacy").innerHTML = result.tables[0].rows[0]["PharmacyName"];
            document.getElementById("hiddenPharmacyId").value = result.tables[0].rows[0]["PharmacyId"];
        } else
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_lblPharmacy").innerHTML = "";
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_hiddenClientMedicationScriptId").value = result.tables[0].rows[0]["ClientMedicationScriptId"];
        if (result.tables[0].rows[0]["OrderingMethod"] == "F") {
            //document.getElementById("radioPrint").disabled = true;
            document.getElementById("spanPrint").disabled = true;
            document.getElementById("radioPrint").checked = false;
            document.getElementById("radioElectronic").checked = false;
            document.getElementById("radioFax").checked = true;
            //document.getElementById("radioFax").style.disabled = false;
        }
        if (result.tables[0].rows[0]["OrderingMethod"] == "P") {
            //document.getElementById("radioPrint").disabled = false;
            document.getElementById("spanFax").disabled = true;
            document.getElementById("radioPrint").checked = true;
            document.getElementById("radioFax").checked = false;
            document.getElementById("radioElectronic").checked = false;
            //document.getElementById("radioFax").style.disabled = true;
        }
        if (result.tables[0].rows[0]["OrderingMethod"] == "E") {
            //document.getElementById("radioPrint").disabled = false;
            document.getElementById("spanElectronic").disabled = true;
            document.getElementById("radioElectronic").checked = true;
            document.getElementById("radioPrint").checked = false;
            document.getElementById("radioFax").checked = false;
            //document.getElementById("radioFax").style.disabled = true;
        }
        var DrugCategory = document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_HiddenDrugCategory").value;
        if (DrugCategory < 1 || document.getElementById("radioPrint").checked == true || document.getElementById("radioFax").checked== true) {
            document.getElementById("label_readytosign").style.visibility = "hidden";
            document.getElementById("CheckBox_ReadyToSign").style.visibility = "hidden";
            document.getElementById("label_OTP").style.visibility = "hidden";
            document.getElementById("TextBox_OneTimePassword").style.visibility = "hidden";
            document.getElementById('divDisclaimer').style.visibility = "hidden";
        }
        else {
            document.getElementById("label_readytosign").style.visibility = "visible";
            document.getElementById("CheckBox_ReadyToSign").style.visibility = "visible";
            document.getElementById("CheckBox_ReadyToSign").checked = false;
            document.getElementById("label_OTP").style.visibility = "visible";
            document.getElementById("TextBox_OneTimePassword").style.visibility = "visible";
            document.getElementById('divDisclaimer').style.visibility = "visible";
            document.getElementById("TextBox_OneTimePassword").value = "";
        }
        var scriptId = document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_hiddenClientMedicationScriptId").value;
        //document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_anchor").click();
        if ($("#HiddenFieldVerbal").val() == "A") {
            for (i = 0; i < result.tables[1].rows.length; i++) {
                noteClientMedicationScriptId(result.tables[1].rows[i]["ClientMedicationId"]);
            }
            $("[Id$=_boolRowWithInteractionFound]").val("");
            if (result.tables.length > 2) {
                $("[Id$=_boolRowWithInteractionFound]").val('1');
            }
            if (DrugCategory > 1) {
                $("[Id$=HiddenFieldCheckDrugCategory]").val('2');
            }
        }
        fnShow();
        Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.GetRDLCContents(scriptId, onRDLCSuccess, onFailure);
        fnHideParentDiv();
    }
}

String.prototype.ReplaceAll = function (stringToFind, stringToReplace) {

    var temp = this;

    var index = temp.indexOf(stringToFind);

    while (index != -1) {

        temp = temp.replace(stringToFind, stringToReplace);

        index = temp.indexOf(stringToFind);

    }

    return temp;

};

function onRDLCSuccess(result) {
    result = result.replace("img", "img style='width:100%'");
    document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_divReportViewer").innerHTML = "";
    document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_divReportViewer").innerHTML = result;
    if ($("[id*=HiddenFieldRXFourPrescriptionsperpage]").length > 0) {
        if ($("[id*=HiddenFieldRXFourPrescriptionsperpage]").val().toUpperCase() == "Y") {
            var deg = 90;
            var div = document.getElementById('Control_ASP.usercontrols_verbalordersreview_ascx_divReportViewer');
            var divimage = $(div).find("img");
            $(divimage).css('transform', 'rotate(90deg)');
            $(divimage).css('marginLeft', '120px');
            $(div).scrollTop(110);
            div.style.overflowY = 'scroll';
            div.style.height = '440px';
            div.style.width = '700px';
        }
    }
    fnHideParentDiv();
}

//Validating Ready to sign checkbox and OPT password for the Control Drugs-- Pranay 
function ElectronicApprove(hiddenClientMedicationScriptId) {
    try{
        if (document.getElementById("TextBox_OneTimePassword").style.visibility == "visible") {
            if ((document.getElementById("CheckBox_ReadyToSign").checked == false && document.getElementById("TextBox_OneTimePassword").value.length == 0) || ((document.getElementById("CheckBox_ReadyToSign").checked == false || document.getElementById("TextBox_OneTimePassword").value.length == 0))) {
                document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").style.display = 'block';
                document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_ImageError").style.display = 'block';
                document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_tableErrorMessage").style.display = 'block';
                document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").innerHTML = 'Please review and sign.';
                return false;
            }
            else {
                if (document.getElementById("radioPrint").checked != true) {
                    var passwordOTP = document.getElementById("TextBox_OneTimePassword").value;
                    var wRequest = new Sys.Net.WebRequest();
                    wRequest.set_url("AjaxScript.aspx?FunctionId=ApproveEPrescription&passwordOTP=" + passwordOTP);
                    wRequest.add_completed(MedicationMgt.CheckOTPForElectronicApproval);
                    wRequest.set_httpVerb("Post");
                    var executor = new Sys.Net.XMLHttpExecutor();
                    wRequest.set_executor(executor);
                    executor.executeRequest();
                    var started = executor.get_started();
                }
            }
        }
        else {
            ApproveQueueorders(hiddenClientMedicationScriptId);
        }
    }
    catch(e)
    {
        Streamline.SmartClient.WebServices.CommonService.WriteToDatabase(e.toString(), 'ElectronicApprove(hiddenClientMedicationScriptId)', null)
    }
}

//Code added by Loveena in ref to Task#3 to add checked immage on click of Approve Order button
function ApproveOrders(hiddenClientMedicationScriptId) {
    FieldClientMedicationScriptId = hiddenClientMedicationScriptId;
    ElectronicApprove(hiddenClientMedicationScriptId);
}
function ApproveQueueorders(hiddenClientMedicationScriptId) {
    if ($("[Id$=_boolRowWithInteractionFound]").val() == "1") {
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").style.display = 'block';
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_ImageError").style.display = 'block';
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_tableErrorMessage").style.display = 'block';
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").innerHTML = 'Medication with Interaction Level 1 Cannot be Approved.';
        return false;
    }
    var scriptId = document.getElementById(hiddenClientMedicationScriptId).value;
    if (scriptId != "" && scriptId != "undefined") {
        Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.createVerbalControls(scriptId, 'Approve', onApproveOrdersSuccess, onFailure);
    }
}
function onApproveOrdersSuccess(result, context) {
    try {
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").style.display = 'none';
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_ImageError").style.display = 'none';
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_tableErrorMessage").style.display = 'none';
        if (result.First == "Medication can be signed in 72 hours from the time the queued.") {
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").style.display = 'block';
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_ImageError").style.display = 'block';
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_tableErrorMessage").style.display = 'block';
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").innerHTML = 'Medication can be signed in 72 hours from the time the queued.';
            return false;
        }
        var arr = new Array();
        arr = result.Second.split(',');
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_PlaceHolder").innerHTML = "";
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_PlaceLabel").innerHTML = "";
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_PlaceLabel").innerHTML = arr[0];
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_PlaceHolder").innerHTML = result.First;
        var id = new Array();
        id = result.Third.split(',');
        if (id[1] == "True" && $('#tableApprovedOrders tr td:empty:first').parent().length > 0) {
            var rowid = $('#tableApprovedOrders tr td:empty:first').parent().attr('id').split('_');
            document.getElementById("radioButtonOrder" + rowid[1]).checked = true;
            if (rowid[1] == "0") {
                var r1 = document.getElementById("radioButtonOrder" + rowid[1])
                    r1.onclick();
            }
        }
        else if ($('#tableApprovedOrders tr td:empty:first').parent().length == 0) {
            document.getElementById("radioButtonOrder" + id[2]).checked = true;
            GetVerbalOrderReviewData(id[3]);
        }
        else {
            var e1 = document.getElementById("radioButtonOrder" + String(parseInt(id[2], 10) + 1));
            e1.onclick();
            }
        if (arr[1] == "True") {
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_ButtonSign").disabled = false;
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_HiddenFieldSign").value = true;
        }
        if (arr[1] == "False") {
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_ButtonSign").disabled = true;
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_HiddenFieldSign").value = false;
        }
        if ($("span[id$=QInteraction]").length > 0) {
            $("span[id$=QInteraction]").css('margin-right', '3px')
        }
    } catch (ex) {
    }
}

//Code end over here.

//Code added by Loveena in ref to Task#3 to remove checked immage on click of Retract Order button

function RetractOrder(hiddenClientMedicationScriptId) {
    try {
        var scriptId = document.getElementById(hiddenClientMedicationScriptId).value;
        if (scriptId != "" && scriptId != "undefined")
            Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.createVerbalControls(scriptId, 'Retract', onApproveOrdersSuccess, onFailure);
    } catch (ex) {
    }
}

function dialogForVoidOrder(scriptId) {
    var answer = window.showModalDialog('YesNo.aspx?CalledFrom=Queuedorder', 'YesNo', 'menubar : no;status : no;resizable:no;dialogTop:200px;dialogWidth:423px; dialogHeight:178px;dialogLeft:300px,location:no; help: No;');
    if (answer == 'Y') {
        var scriptId = $("[Id$=hiddenClientMedicationScriptId]").val();
        if (scriptId != "" && scriptId != "undefined") {
            Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.CancelOrders(scriptId, onCancelSuccess, onFailure);
        }
    }
    else if (answer == undefined || answer == null) {
    }
}

function VoidOrder() {
    try {
        dialogForVoidOrder(scriptId);
    }
    catch (ex) {
    }
}

function onCancelSuccess(result, context) {
    document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_CancelOrderCreateControls").click();
}

//Code added by Loveena in ref to Task#3 to Approve all orders
function ApproveAllOrders() {
    try {
        if ($("[Id$=_boolRowWithInteractionFound]").val() == "1") {
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").style.display = 'block';
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_ImageError").style.display = 'block';
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_tableErrorMessage").style.display = 'block';
            document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_LabelErrorMessage").innerHTML = 'Medication with Interaction Level 1 Cannot be Approved.';
            return false;
        }
        Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.createVerbalControls(0, 'ApproveAll', onApproveOrdersSuccess, onFailure);
    } catch (ex) {
    }
}

//Code addded by Loveena in ref to Task#3

function ValidateSign(LabelErrorMessage, ImageError, tableErrorMessage, txtpassword, type) {
    try {
        var pharmacyId = "";
        var valPassword = document.getElementById(txtpassword).value;
        var LabelErrorMessage = LabelErrorMessage;
        var ImageError = ImageError;
        var tableErrorMessage = tableErrorMessage;
        var context = new Object();
        context.ImageError = ImageError;
        context.tableErrorMessage = tableErrorMessage;
        context.LabelErrorMessage = LabelErrorMessage;

        document.getElementById(LabelErrorMessage).style.display = 'none';
        document.getElementById(ImageError).style.display = 'none';
        document.getElementById(tableErrorMessage).style.display = 'none';
        var OrderingMethod = "";
        //Modified By Pushpita Date 11th Feb 2010 to implement Electronic
        if (document.getElementById('radioPrint').checked == true)
            OrderingMethod = "P";
        else if (document.getElementById('radioFax').checked == true) {
            OrderingMethod = "F";
            context.OrderingMethod = "F";
        }
        else {
            OrderingMethod = "E";
            pharmacyId = document.getElementById("hiddenPharmacyId").value;
            context.OrderingMethod = "E";
        }
        if (type == "Sign") {
            if (document.getElementById(txtpassword).value == "") {
                document.getElementById(LabelErrorMessage).style.display = 'block';
                document.getElementById(ImageError).style.display = 'block';
                document.getElementById(tableErrorMessage).style.display = 'block';
                document.getElementById(LabelErrorMessage).innerHTML = 'Please Enter the Password.';
                return false;
            } else {

                Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.SaveOnSign(OrderingMethod, valPassword, pharmacyId, onSaveSignSuccess, onFailure, context);
            }
        } else {
            Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.SaveOnSign(OrderingMethod, valPassword, pharmacyId, onSaveSignSuccess, onFailure, context);
        }
    } catch (ex) {
    }
}

function onSaveSignSuccess(result, context) {
    var LabelErrorMessage = context.LabelErrorMessage;
    var ImageError = context.ImageError;
    var tableErrorMessage = context.tableErrorMessage;
    document.getElementById(LabelErrorMessage).style.display = 'none';
    document.getElementById(ImageError).style.display = 'none';
    document.getElementById(tableErrorMessage).style.display = 'none';
    if (result.Second != "InvalidPassword") {
        if (result.First == "A" && result.Third == true){
            window.open('MedicationScriptPrinting.aspx?varScriptIds=' + result.Second + '&varFaxSendStatus=' + result.Third, '', 'menubar = 0;status = 0; height=500px;width=750px;top=20px;left=170px;scrollbars=1');
        }
        document.getElementById("Control_ASP.usercontrols_verbalordersreview_ascx_anchor").click();
    } else {
        document.getElementById(LabelErrorMessage).style.display = 'block';
        document.getElementById(ImageError).style.display = 'block';
        document.getElementById(tableErrorMessage).style.display = 'block';
        document.getElementById(LabelErrorMessage).innerHTML = 'Invalid Password.';
        return false;
    }

}

//Added by Pradeep
//Ref Ticket #19

function ShowConsentDetail(MedicationNameId, DocumentVersionId) {

    try {
        var context = new Object();
        context.MedicationNameId = MedicationNameId;
        context.DocumentVersionId = DocumentVersionId;
        Streamline.SmartClient.WebServices.CommonService.SetDetailsForPatientConsentDetail(MedicationNameId, DocumentVersionId, onSetPatientConsentDetailSuccess, onFailure, context);

    } catch (e) {

    }

}

function onSetPatientConsentDetailSuccess(result, context) {
    try {

        //RedirectToPatientConsentDetailPage("ConsentHistoryPage");
        //Modified in ref to Task#2975
        redirectToPatientContentPage('ImageConsentClick', "", result, context.DocumentVersionId, "G", "ViewConsentHistory");
    } catch (e) {
    }
}

//Added By Anuj for tas ref 2932 (Medication Management)

function ChangeConsentFormMode(object) {
    try {
        if ($("[id$=RadioButtonMedicalStaff]")[0].checked == true) {
            $("[id$=RadioButtonPatient]").disabled = true;
            $("[id$=RadioButtonRelation]").disabled = true;
            if (object.value == "Edit") {
                //$("select[Id$=DropDownConsentList]").attr("disabled", "false");
                $("select[Id$=DropDownConsentList]")[0].disabled = false;
                object.value = "View";
                //Code added by Loveena in ref to Task#2962
                OpenDocuments('HarborConsent.aspx', 'Patient Consent', '');
            } else if (object.value == "View") {
                //$("select[Id$=DropDownConsentList]").attr("disabled", "true");
                $("select[Id$=DropDownConsentList]")[0].disabled = true;
                object.value = "Edit";
                parent.$("[id*=HiddenFieldImageConsentClick]").val("Patient Consent");
                parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_anchorId').click();
            }
        }
    } catch (e) {
    }
}


function dialogForRevokConsent() {
    var datetime = new Date();
    var DocumentVersionId = "";
    var answer = window.showModalDialog("./YesNo.aspx?datetime=" + datetime.getMinutes() + datetime.getSeconds() + "&CalledFrom=PatientConsent", 'YesNo', 'menubar : no;status : no;resizable:no;dialogTop:350px;dialogWidth:423px; dialogHeight:178px;dialogLeft:300px,location:no; help: No;');
    if (answer == undefined) {
    } else if (answer == "N") {
    } else if (answer == "Y") {
        var SignedBy = (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldSignedBy').value);
        if (parent.document.getElementById('HiddenFieldImageClickDocumentVersionId').value != undefined && parent.document.getElementById('HiddenFieldImageClickDocumentVersionId').value != "" && parent.document.getElementById('HiddenFieldImageClickDocumentVersionId').value != '' && parent.document.getElementById('HiddenFieldImageClickDocumentVersionId').value != null) {
            DocumentVersionId = parent.document.getElementById('HiddenFieldImageClickDocumentVersionId').value;
        } else {
            DocumentVersionId = parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDocumentVersionId').value;
        }
        Streamline.SmartClient.WebServices.ClientMedications.RevokeConsent(SignedBy, DocumentVersionId, onSuccessRevokeConsent, onFailureRevokeConsent);
    }
}



//Added By Anuj for tas ref 2932 (Medication Management)

function RevokeConsent() {
    try {
        try {
            dialogForRevokConsent();
        } catch (e) {
        }

    } catch (e) {
    }

}

//Added By Anuj for tas ref 2932 (Medication Management)

function onSuccessRevokeConsent(result) {
    try {

        if (result == "1") {
            var LabelErrorMessage = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelErrorMessage');
            //var ImageError = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ImageError');
            //ImageError.style.display = 'block';
            //ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = 'You have successfully revoked the consent';
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonSign').disabled = true;
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = true;
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked = false;
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked = false;
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').disabled = true;
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').disabled = true;
            parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').disabled = true;
            parent.document.getElementById('ButtonRevoke').disabled = true;
            parent.document.getElementById('HiddenFieldImageClickDocumentVersionId').value = "";

        }
    } catch (e) {
    }


}

//Added By Anuj for tas ref 2932 (Medication Management)

function onFailureRevokeConsent() {
    try {

    } catch (e) {
    }


}

//Code added in ref to Task#85

function SetPatientMainPage(clientId) {
    Streamline.SmartClient.WebServices.SureScriptRefillRequest.OpenPatientMainPage(clientId, onSuccessPatientMainPage, onFailure);
}

function onSuccessPatientMainPage() {
    RefreshManagementPage();
}

//Modified By Priya Ref:task No:3274 2.7 Surescripts Refill Requests for Schedule II-V Medications

function redirectToOrderPageFromDashBoard(clientId, SureScriptsRefillRequestId, PharmacyId, PharmacyName, DrugCategory) {
 
    fnShow();
    var context = new Object();
    context.SureScriptsRefillRequestId = SureScriptsRefillRequestId;
    $("input[Id$=HiddenFieldRefillPharmacyId]").val(PharmacyId);
    $("input[Id$=HiddenFieldRefillPharmacyName]").val(PharmacyName);
    $("input[Id$=HiddenFieldDrugCategory]").val(DrugCategory);
    $("input[id*=HiddenFieldClickedImage]").val('');
    $("input[id=HiddenFieldSureScriptRefillRequestId]").val(SureScriptsRefillRequestId);
    $("input[id*=HiddenFieldClickedImage]").val('DeniedNewPrescriptions');
    Streamline.SmartClient.WebServices.SureScriptRefillRequest.SetClientInformation(clientId, false, onSuccessSetClientInformation, onFailure, context);
}

function redirectToOrderPageFromDenialScreen(clientId, SureScriptsRefillRequestId, PharmacyId, PharmacyName, DrugCategory, UserCode) {
    try {
        var DivSearch = parent.document.getElementById('DivSearch1');
        DivSearch.style.display = 'block';
        var iFrameSearch = parent.document.getElementById('iFrame1');
        var dt = new Date();
        var currentTime = dt.getTime();
        iFrameSearch.src = 'RefillDenialReason.aspx?SureScriptsRefillRequestId=' + SureScriptsRefillRequestId +
            '&Clientid=' + clientId + '&PharmacyId=' + PharmacyId + '&PharmacyName=' + PharmacyName + '&DrugCategory=' + DrugCategory +
            '&UserCode=' + UserCode + '&RequiresCallBack=true&Time=' + currentTime;
        iFrameSearch.style.positions = 'absolute';
        iFrameSearch.style.left = '140px';
        iFrameSearch.style.width = '380px';
        iFrameSearch.style.height = '200px';
        iFrameSearch.style.top = '200px';
        iFrameSearch.style.scrollbars = 'yes';
        iFrameSearch.style.display = 'block';
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}


function onSuccessSetClientInformation(result, context) {
    $("input[id=HiddenFieldSureScriptRefillRequestId]").val(context.SureScriptsRefillRequestId);
    redirectToOrderPageClearSession('DashBoard');
}


function redirectToCurrentMedications(clientId, SureScriptsRefillRequestId, ChangedclientId) {

    //var DivSearch = parent.document.getElementById('DivSearch');
    var $divSearch = $("#DivSearch");
    $divSearch.css('display', 'block');
    $divSearch.draggable();
    $("#topborder", $divSearch).text("Current Medications");
    DivSearch.style.display = 'block';
    var iFrameSearch = parent.document.getElementById('iFrameSearch');
    if (SureScriptsRefillRequestId != undefined) {
        iFrameSearch.src = 'CurrentMedications.aspx?SelectedClientId=' + clientId + '&SureScriptsRefillRequestId=' + SureScriptsRefillRequestId + '&ChangedclientId=' + ChangedclientId + '&Popupheader=' + 'N';
    } else {
        iFrameSearch.src = 'CurrentMedications.aspx?SelectedClientId=' + clientId + '&ChangedclientId=' + ChangedclientId + '&Popupheader=' + 'N';
    }
    iFrameSearch.style.positions = 'absolute';
    iFrameSearch.style.left = '10px';
    iFrameSearch.style.width = '780px';
    iFrameSearch.style.height = '440px';
    iFrameSearch.style.top = '20px';
    iFrameSearch.style.scrollbars = 'yes';
    iFrameSearch.style.display = 'block';

    //fnHideParentDiv();
}

//Added by Anuj
//Called from CurrentMedication Popup
//Created Date: 4Feb,2010

function onCurrentMedicationHeaderClick(obj) {
    try {

        var sortBy = obj.getAttribute("SortOrder");
        var ColumnName = obj.getAttribute("ColumnName");
        if (sortBy == "") {
            sortBy = "Asc";
        } else if (sortBy == "Desc") {
            sortBy = "Desc";
        } else if (sortBy == "Asc") {
            sortBy = "Asc";
        }
        ColumnName = ColumnName + " " + sortBy;
        FillCurrentMedicationList(PanelCurrentMedicationListInformation, ColumnName);
    } catch (e) {

    }
}

//Added by Anuj
//Called from onCurrentMedicationHeaderClick function
//Created Date: 5Feb,2010

function FillCurrentMedicationList(Panel, SortBy) {

    try {

        if (Panel === undefined) {
            Panel = PanelMedicationList;
        }
        if (SortBy === undefined) {
            SortBy = '';
        }
        PanelMedicationList = Panel;

        if (Panel[1] != undefined)
            Panel = Panel[1];

        //var ClientID = $("input[id$=HiddenClientId]")[0].value;
        var ClientID = document.getElementById("HiddenClientId").value;
        // Create the WebRequest object.
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("AjaxScript.aspx?CurrentClientMedicationList=GetCurrentClientMedicationList" + "&SortBy=" + SortBy + "&ClientId=" + ClientID);
        //wRequest.set_url("AjaxScript.aspx?SortBy=" + SortBy);
        wRequest.add_completed(OnFillCurrentMedicationListCompleted);
        wRequest.set_userContext(Panel);
        wRequest.set_httpVerb("Post");
        var executor = new Sys.Net.XMLHttpExecutor();
        wRequest.set_executor(executor);
        executor.executeRequest();
        var started = executor.get_started();
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

//Added by Anuj
//Called on success of FillCurrentMedicationList
//Created Date: 5Feb,2010

function OnFillCurrentMedicationListCompleted(executor, eventArgs) {
    try {
        if (executor.get_responseAvailable()) {

            // Get the Web request instance.
            var webReq = executor.get_webRequest();
            // Display request Url.
            if (executor.get_statusCode() == 200) {
                var Panel = webReq.get_userContext();
                Panel.innerHTML = "";
                var data = executor.get_responseData();
                //var indexofdiv = data.indexOf('</div>');
                var indexofstart = data.indexOf('###STARTGRAPH###');
                var indexofend = data.indexOf('###ENDGRAPH###');
                var data1 = "";
                if (data.length > 545) {
                    data1 = data.substring(indexofstart + 22, indexofend - 12);
                    Panel.innerHTML = data1 + Panel.innerHTML;
                    data1 = "";
                }
            }
        } else {
            if (executor.get_timedOut())
                alert("Timed Out");
            else if (executor.get_aborted())
                alert("Aborted");

        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Function added by Loveena in ref to Task#85 to Refill the Order from DashBoard
//Parameter added by priya Ref:3274 2.7 Surescripts Refill Requests for Schedule II-V Medications

function ButtonDashBoardReFillOrderClick(stringMedicationId, method, clientId, sureScriptRefillRequestId, PharmacyId, ClickedImage, NumberOfRefills, QuantityValue, Quantity, NumberOfDaysSupply, object, DrugCategory, PharmacyName, PotencyUnitCode) {
    try {
     
        //var PharmacyName = $("input[id*=HiddenField]", $(object).parents("tr:first")).val();
        ShowMainPageError('', false);
        if (PharmacyId.toString() == "") {
            ShowMainPageError('Pharmacy does not exist for this Refill Request', true);
            return;
        }
        fnShow(); //By Vikas Vyas
        var context = new Object();
        context.MedicationId = stringMedicationId;
        context.method = method;
        //Code added by priya Ref:3274 2.7 Surescripts Refill Requests for Schedule II-V Medications
        $("input[Id$=HiddenFieldDrugCategory]").val(DrugCategory);
        $("input[id*=HiddenFieldRedirectFrom]").val('DashBoard');
        $("input[id*=HiddenFieldClickedImage]").val('');
        $("input[id=HiddenFieldSureScriptRefillRequestId]").val(sureScriptRefillRequestId);
        $("input[Id$=HiddenFieldRefillPharmacyId]").val(PharmacyId);
        $("input[Id$=HiddenFieldRefillPharmacyName]").val(PharmacyName);
        $("input[id*=HiddenFieldClickedImage]").val(ClickedImage);
        $("input[id*=HiddenFieldRefillSpecialCase]").val(''); //Added By Pradeep as per task#3300
        if (method.toUpperCase() == "CHANGEAPPROVALORDER") {
            $("input[id=HiddenFieldSureScriptChangeRequestId]").val(sureScriptRefillRequestId);
        }
        else { $("input[id=HiddenFieldSureScriptChangeRequestId]").val(''); }
        if (NumberOfRefills == '') {
            NumberOfRefills = 0;
        }
        if ((ClickedImage == "Approved" || ClickedImage == "ApprovedWithChanges") && method.toUpperCase() != "CHANGEAPPROVALORDER") {
            NumberOfRefills = NumberOfRefills - 1; //Made changes as per task#3300
            if (parseInt(NumberOfRefills) < 0) {
                NumberOfRefills = 0;
                $("input[id*=HiddenFieldRefillSpecialCase]").val('TRUE');
            }
        }
        if (QuantityValue == '')
            QuantityValue = 0;
        if (NumberOfDaysSupply == '') {
            NumberOfDaysSupply = 0;
        }
        //Addedd By Loveena on 21 Dec as per task#3285
        context.Quantity = Quantity;
        context.NumberOfDaysSupply = NumberOfDaysSupply;
        context.NumberOfRefills = NumberOfRefills;
        context.QuantityValue = QuantityValue;
        context.ClickedImage = ClickedImage;
        context.PotencyUnitCode = PotencyUnitCode;
        context.SureScriptChangeRequestId = sureScriptRefillRequestId;
        Streamline.SmartClient.WebServices.SureScriptRefillRequest.SetClientInformation(clientId, true, onSuccessfulSetClientInformation, onFailure, context);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }

}



function onSuccessfulSetClientInformation(result, context) {
    try {
     
        var stringMedicationId = context.MedicationId;
        var method = context.method;
        var NumberOfRefills = context.NumberOfRefills;
        var QuantityValue = context.QuantityValue;
        var ClickedImage = context.ClickedImage;
        var Quantity = context.Quantity;
        var NumberOfDaysSupply = context.NumberOfDaysSupply;
        var PotencyUnitCode = context.PotencyUnitCode;

        //Added new parameters in ref to Task#3224 For approve button, we are required to disable some additional fields in the grid.
        Streamline.SmartClient.WebServices.ClientMedications.PopulateRowsforMedicationList(stringMedicationId, method, NumberOfRefills, QuantityValue, ClickedImage, Quantity, NumberOfDaysSupply, PotencyUnitCode, onSuccessfullPopulation, onFailure, method);

    } catch (e) {
    }
}

//Added By PranayB w.r.t Meaningfuluse Stage-3
function ButtonDashBoardChangeOrderClick(stringMedicationId, method, clientId, sureScriptRefillRequestId, PharmacyId, ClickedImage, NumberOfRefills, QuantityValue, Quantity, NumberOfDaysSupply, object, DrugCategory, PharmacyName, PotencyUnitCode) {
    try {

        ShowMainPageError('', false);
        if (PharmacyId.toString() == "") {
            ShowMainPageError('Pharmacy does not exist for this Change Request', true);
            return;
        }
        fnShow(); //By Vikas Vyas
        var context = new Object();
        context.MedicationId = stringMedicationId;
        context.method = method;
        //Code added by priya Ref:3274 2.7 Surescripts Refill Requests for Schedule II-V Medications
        $("input[Id$=HiddenFieldDrugCategory]").val(DrugCategory);
        $("input[id*=HiddenFieldRedirectFrom]").val('DashBoard');
        $("input[id*=HiddenFieldClickedImage]").val('');
        $("input[id=HiddenFieldSureScriptRefillRequestId]").val(sureScriptRefillRequestId);
        $("input[id=HiddenFieldSureScriptChangeRequestId]").val(sureScriptRefillRequestId);
        $("input[Id$=HiddenFieldRefillPharmacyId]").val(PharmacyId);
        $("input[Id$=HiddenFieldRefillPharmacyName]").val(PharmacyName);
        $("input[id*=HiddenFieldClickedImage]").val(ClickedImage);
        $("input[id*=HiddenFieldRefillSpecialCase]").val(''); //Added By Pradeep as per task#3300
        if (NumberOfRefills == '') {
            NumberOfRefills = 0;
        }
        if (ClickedImage == "Approved" || ClickedImage == "ApprovedWithChanges") {
            NumberOfRefills = NumberOfRefills ; //Made changes as per task#3300 //Pranay Change 
            if (parseInt(NumberOfRefills) < 0) {
                NumberOfRefills = 0;
                $("input[id*=HiddenFieldRefillSpecialCase]").val('TRUE');
            }
        }
        if (QuantityValue == '')
            QuantityValue = 0;
        if (NumberOfDaysSupply == '') {
            NumberOfDaysSupply = 0;
        }
        //Addedd By Loveena on 21 Dec as per task#3285
        context.Quantity = Quantity;
        context.NumberOfDaysSupply = NumberOfDaysSupply;
        context.NumberOfRefills = NumberOfRefills;
        context.QuantityValue = QuantityValue;
        context.ClickedImage = ClickedImage;
        context.PotencyUnitCode = PotencyUnitCode;

        Streamline.SmartClient.WebServices.SureScriptRefillRequest.SetClientInformation(clientId, true, onSuccessfulSetClientInformation1, onFailure, context);
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }

}

function onSuccessfulSetClientInformation1(result, context) {
    try {
      
        var stringMedicationId = context.MedicationId;
        var method = context.method;
        var NumberOfRefills = context.NumberOfRefills;
        var QuantityValue = context.QuantityValue;
        var ClickedImage = context.ClickedImage;
        var Quantity = context.Quantity;
        var NumberOfDaysSupply = context.NumberOfDaysSupply;
        var PotencyUnitCode = context.PotencyUnitCode;

        if (ClickedImage.toUpperCase() == "APPROVED") {
            redirectToOrderPage('CHANGEAPPROVALORDER', 0); //ApproveChangeOrder
        }
        else if (ClickedImage.toUpperCase() == "APPROVEDWITHCHANGES") {
            redirectToOrderPage('APPROVEWITHCHANGESCHANGEORDER', 0); //ApproveWithChangesChangeOrder
        }
    }
    catch (e) { }

}
function RequestRefillOrder(context) {
    try {

    } catch (e) {
    }
}

function Testsucess(result) {
    try {

    } catch (e) {
    }
}
function ButtonAuthorizeChangeOrderClick(sureScriptChangeRequestId)
{
   
    Streamline.SmartClient.WebServices.SureScriptRefillRequest.AuthorizeChangeOrder(sureScriptChangeRequestId,onSucessAuthorizeChange, onFailure);
}

function onSucessAuthorizeChange(result)
{
    if (result > 0) {
        alert("Approved");
        SortInboundRecord('', 'RxChange');
    }
    else {
        ShowError('Error while Approving', true);
        return false;
    }
}

//function added by Loveena in ref to Task#85 to open Patient Search Window on click of Search Image.
function ShowClientSearch(clientId, clientfirstName, clientLastName, SureScriptsRefillRequestId, prescriberId) {
    try {
       
            var $divSearch = $("#DivSearch");
            $("#topborder", $divSearch).text("Patient Search");
            var $iFrameSearch = $('#iFrameSearch', $divSearch);
            $iFrameSearch.attr('src', 'ClientSearch.aspx?SelectedClientId=' + clientId + '&ClientFirstName=' + clientfirstName + '&ClientLastName=' + clientLastName + '&SureScriptsRefillRequestId=' + SureScriptsRefillRequestId + '&prescriberId=' + prescriberId);
            $iFrameSearch.css({ 'width': '630px', 'height': '540px' });
            fnHideParentDiv();
            var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
            left = left > 0 ? left : 10;
            var top = ($(window.document).height() / 3) - ($iFrameSearch.height());
            top = top > 0 ? top : 10;
            $divSearch.css({ 'top': top, 'left': left });
            $divSearch.draggable();
            $divSearch.css('display', 'block');
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        return false;
    }

    //Added by Anuj
    //Called from CurrentMedications page (onradioClick)
    //Created Date: 9Feb,2010

    function onCurrentMedicationRadioClick(ClientMedicationScriptDrugStrengthId, ClientMedicationId) {
        $("input[id$=HiddenFieldDrugStrengthId]")[0].value = ClientMedicationScriptDrugStrengthId;

    }

    //Added by Anuj
    //Called from CurrentMedications page to return ClientMedicationScriptDrugStrengthId
    //Created Date: 9Feb,2010

    function returnScriptDrugStrengthId(calledFrom) {
        var context = new Object();
        context.CalledFrom = calledFrom;
        var SureScriptsRefillRequestId = $("input[id$=HiddenFieldSureScriptsRefillRequestId]")[0].value;
        var ClientMedicationScriptDrugStrengthId = $("input[id$=HiddenFieldDrugStrengthId]")[0].value;
        if (SureScriptsRefillRequestId.toString() == "")
            SureScriptsRefillRequestId = 0;
        if (ClientMedicationScriptDrugStrengthId.toString() == "")
            ClientMedicationScriptDrugStrengthId = 0;
        if (ClientMedicationScriptDrugStrengthId != '0' && ClientMedicationScriptDrugStrengthId != '' && ClientMedicationScriptDrugStrengthId != "") {

            Streamline.SmartClient.WebServices.ClientMedications.UpdateSureScriptsRefillRequests(SureScriptsRefillRequestId, ClientMedicationScriptDrugStrengthId, onSuccessfulUpdateSureScriptsRefillRequests, onFailure, context);
        } else {
            closeDiv();
        }
    }

    //Added by Anuj
    //Called onSuccess of returnScriptDrugStrengthId
    //Created Date: 9Feb,2010

    function onSuccessfulUpdateSureScriptsRefillRequests(result, context) {
        SortInboundRecord('', context.CalledFrom);
        closeDiv();

    }

    function CloseCurrentMedication() {
        closeDiv();
    }

    //added By Priya ref:task no:85

    function ShowAgainPreferredPharmaciesDiv(DropDownValue1, DropDownValue2, imgname, PharmacyId, PharmacyName, ExternalReferenceId) {
        try {
            var getDropDownValue1 = document.getElementById(DropDownValue1).value;
            var getDropDownValue2 = document.getElementById(DropDownValue2).value;

            if (imgname == undefined) {
                var DivSearch = parent.document.getElementById('DivSearch');
                DivSearch.style.display = 'block';
                var dt = new Date();
                var currentTime = dt.getTime();
                var iFrameSearch = parent.document.getElementById('iFrameSearch');
                iFrameSearch.src = 'PreferredPharmacies.aspx?imgname=none' + '&DropDownValue1=' + getDropDownValue1 + '&DropDownValue2=' + getDropDownValue2 + '&Time=' + currentTime + '&ExternalReferenceId=' + ExternalReferenceId;
                iFrameSearch.style.positions = 'absolute';
                iFrameSearch.style.left = '100px';
                iFrameSearch.style.width = '500px';
                iFrameSearch.style.height = '350px';
                iFrameSearch.style.top = '100px';
                iFrameSearch.style.display = 'block';
                return false;
            }
            var getImageName = document.getElementById(imgname).value;
            if (getImageName.value != "") {
                parent.document.getElementById('HiddenPageName').value = 'PreferredPharmacies';


            }

            var DivSearch = parent.document.getElementById('DivSearch');
            DivSearch.style.display = 'block';
            var dt = new Date();
            var currentTime = dt.getTime();
            var iFrameSearch = parent.document.getElementById('iFrameSearch');
            if (getImageName.value != "") {
                iFrameSearch.src = 'PreferredPharmacies.aspx?imgname=' + getImageName + '&DropDownValue1=' + getDropDownValue1 + '&DropDownValue2=' + getDropDownValue2 + '&PharmacyId=' + PharmacyId + '&PharmacyName=' + encodeText(PharmacyName) + '&ExternalReferenceId=' + ExternalReferenceId;

            } else
                iFrameSearch.src = 'PreferredPharmacies.aspx';
            iFrameSearch.style.positions = 'absolute';
            iFrameSearch.style.left = '100px';
            iFrameSearch.style.width = '500px';
            iFrameSearch.style.height = '350px';
            iFrameSearch.style.top = '100px';
            iFrameSearch.style.display = 'block';
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        return false;
    }


    //Added by Priya
    //onChange of DropDownListInBoundPrescriber
    //Created Date:24Feb,2010 task ref 85

    function SortInboundRecord(SortColumn, calledFrom) {
        if ($("[id*=DropDownListRefillPrescriber]").length == 0)
            var PrescriberId = parent.$("[id*=DropDownListRefillPrescriber]")[0].value;
        else
            var PrescriberId = $("[id*=DropDownListRefillPrescriber]")[0].value;
        if (SortExpressionInBound == '') {
            SortExpressionInBound = 'Desc';
        } else if (SortExpressionInBound == 'Desc') {
            SortExpressionInBound = 'Asc';
        } else if (SortExpressionInBound == 'Asc') {
            SortExpressionInBound = 'Desc';
        }
        if (SortColumn == '')
            SortColumn = 'PatientName';
        var sortInString = '';
        sortInString = SortColumn + ' ' + SortExpressionInBound;
        CalledFrom = calledFrom;
        //    //$("input[id$=HiddenFieldDrugStrengthId]")[0].value = ClientMedicationScriptDrugStrengthId;
        //    $.ajax({
        //        type: "POST",
        //        url: "./AjaxScript.aspx?SortInboundRecord=SortInboundRecord",
        //        //data: 'DisclosureDate=' + Date + '&ClientId=' + ClientId + '&ClientDisclosureId=' + ClientDisclosureId,
        //        data: 'sortInString=' + sortInString + '&PrescriberId=' + PrescriberId + '&CalledFrom='+ calledFrom,
        //        success: OnFillRefillRequestCompleted,
        //        error  : onFailure
        //    });
        // Create the WebRequest object.
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("./AjaxScript.aspx?SortInboundRecord=SortInboundRecord" + "&sortInString=" + sortInString + "&PrescriberId=" + PrescriberId + "&CalledFrom=" + calledFrom);
        wRequest.add_completed(OnFillRefillRequestCompleted);
        //wRequest.set_userContext(Panel);
        wRequest.set_httpVerb("Post");
        var executor = new Sys.Net.XMLHttpExecutor();
        wRequest.set_executor(executor);
        executor.executeRequest();
        var started = executor.get_started();
    }

    //Code Added By Pushpita Ref:task 85

    function BindGridRefillRequest(DropDownListRefillPrescriber) {
        var PrescriberId = document.getElementById(DropDownListRefillPrescriber).value;

        if (PrescriberId != '' && PrescriberId != "") {
            wRequest = new Sys.Net.WebRequest();
            wRequest.set_url("./AjaxScript.aspx?SearchInboundPrescription=FillPharmacies" + "&PrescriberID=" + PrescriberId);
            wRequest.add_completed(OnFillRefillRequestCompleted);
            //wRequest.set_userContext(Panel);
            wRequest.set_httpVerb("Post");
            var executor = new Sys.Net.XMLHttpExecutor();
            wRequest.set_executor(executor);
            executor.executeRequest();
            var started = executor.get_started();

            //        $.ajax({
            //            type: "POST",
            //            url: "AjaxScript.aspx?SearchInboundPrescription=FillPharmacies",
            //            data: 'PrescriberID=' + PrescriberId,
            //            success: OnFillRefillRequestCompleted
            //        });
        }
    }

    //Added By Pushpita Ref:Task 85

    function OnFillRefillRequestCompleted(executor, eventArgs) {
        try {
            if (executor.get_responseAvailable()) {

                // Get the Web request instance.
                var webReq = executor.get_webRequest();
                // Display request Url.
                if (executor.get_statusCode() == 200) {
                    var Panel;
                    if ($("div[id$=PanelRefillRequest]").length == 0) {
                        Panel = parent.$("div[id$=PanelRefillRequest]")[0];
                    } else
                        Panel = $("div[id$=PanelRefillRequest]")[0];
                    Panel.innerHTML = "";
                    var data = executor.get_responseData();
                    //var indexofdiv = data.indexOf('</div>');
                    var indexofstart = data.indexOf("##STARTREFILLREQUEST##");
                    var indexofend = data.indexOf("##ENDREFILLREQUEST##");
                    var data1 = "";
                    if (data.length > 545) {
                        data1 = data.substring(indexofstart + 22, indexofend - 9);
                        Panel.innerHTML = data1 + Panel.innerHTML;
                        data1 = "";
                    }
                    RefreshChangeList(executor);
                }
                if (CalledFrom == '' && $("input[id$=HiddenClientId]").length != 0 && $("input[id$=HiddenClientId]").val() != 'undefined' && $("input[id$=HiddenClientId]").val() != '')
                    redirectToCurrentMedications($("input[id$=HiddenClientId]").val(), $("input[id$=HiddenSureScriptRefillRequestId]").val(), $("[id$=HiddenFieldChangedclientId]").val());
            } else {
                if (executor.get_timedOut())
                    alert("Timed Out");
                else if (executor.get_aborted())
                    alert("Aborted");

            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    }

    function RefreshChangeList(executor) {
        var Panel1;
        if ($("div[id$=PanelChangeRequest]").length == 0) {
            Panel1 = parent.$("div[id$=PanelChangeRequest]")[0];
        } else
            Panel1 = $("div[id$=PanelChangeRequest]")[0];
        Panel1.innerHTML = "";
        var data = executor.get_responseData();
        //var indexofdiv = data.indexOf('</div>');
        var indexofstart = data.indexOf("##STARTRXCHANGE##");
        var indexofend = data.indexOf("##ENDRXCHANGE##");
        var data1 = "";
        if (data.length > 545) {
            data1 = data.substring(indexofstart + 24, indexofend - 9);
            Panel1.innerHTML = data1 + Panel1.innerHTML;
            data1 = "";
        }
    }

    //Added by Anuj
    //onChange of DropDownListOutBoundPrescriber
    //Created Date: 17Feb,2010 task ref 85

    function SortOutboundRecord(SortColumn) {
        var staffId = $("[id*=DropDownListOutBoundPrescriber]")[0].value;
        if (SortExpressionOutBound == '') {
            SortExpressionOutBound = 'Desc';
        } else if (SortExpressionOutBound == 'Desc') {
            SortExpressionOutBound = 'Asc';
        } else if (SortExpressionOutBound == 'Asc') {
            SortExpressionOutBound = 'Desc';
        }
        var sortString = '';
        sortString = SortColumn + ' ' + SortExpressionOutBound;
        //$("input[id$=HiddenFieldDrugStrengthId]")[0].value = ClientMedicationScriptDrugStrengthId;
        $.ajax({
            type: "POST",
            url: "./AjaxScript.aspx?SortOutboundRecord=SortOutboundRecord",
            //data: 'DisclosureDate=' + Date + '&ClientId=' + ClientId + '&ClientDisclosureId=' + ClientDisclosureId,
            data: 'sortString=' + sortString + '&StaffId=' + staffId,
            success: onSuccessSearchOutboundPrescription
        });

    }

    //Added by Anuj
    //Success of deleteScriptActivityPending
    //Created Date: 17Feb,2010 task ref 85

    function onSuccessSearchOutboundPrescription(result) {
        try {
            if (result.xml == undefined)
                var pageResponse = result;
            else
                var pageResponse = result.xml;
            var start = pageResponse.indexOf("##STARTPAGEOUTBOUNDPRES##") + 32;
            var end = pageResponse.indexOf("##ENDPAGEOUTBOUNDPRESC##");
            pageResponse = pageResponse.substr(start, end - start).trim();
            if (pageResponse != undefined) {
                $("div[id$=PanelOutBoundPrescription]")[0].innerHTML = pageResponse;
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    }

    //Added by Anuj
    //onChange of DropDownListOutBoundPrescriber
    //Created Date: 17Feb,2010 task ref 85

    function SearchOutboundPrescription(object) {
        var staffId = document.getElementById(object).value;
        $.ajax({
            type: "POST",
            url: "./AjaxScript.aspx?SearchOutboundPrescription=SearchOutboundPrescription",
            data: 'StaffId=' + staffId,
            success: onSuccessSearchOutboundPrescription
        });

    }

    //Added by Anuj
    //Used to delete record from ClientMedicationScriptActivitiesPending Table
    //Created Date: 17Feb,2010 task ref 85

    function deleteScriptActivityPending(ScriptActivitiesPendingId) {

        //var SureScriptsRefillRequestId = $("input[id$=HiddenFieldSureScriptsRefillRequestId]")[0].value;
        // var ScriptActivitiesPendingId = ScriptActivitiesPendingId;
        //alert(ScriptActivitiesPendingId);
        var staffId = $("[id*=DropDownListOutBoundPrescriber]")[0].value;
        if (ScriptActivitiesPendingId != '0' && ScriptActivitiesPendingId != '' && ScriptActivitiesPendingId != "") {
            $.ajax({
                type: "POST",
                url: "./AjaxScript.aspx?DeleteScriptActivityPending=DeleteScriptActivityPending",
                data: 'ScriptActivitiesPendingId=' + ScriptActivitiesPendingId + '&StaffId=' + staffId,
                success: onSuccessfuldeleteScriptActivityPending
            });

        }
    }

    //Added by Anuj
    //Success of deleteScriptActivityPending
    //Created Date: 17Feb,2010 task ref 85

    function onSuccessfuldeleteScriptActivityPending(result) {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGEOUTBOUNDPRES##") + 32;
        var end = pageResponse.indexOf("##ENDPAGEOUTBOUNDPRESC##");
        pageResponse = pageResponse.substr(start, end - start).trim();
        if (pageResponse != undefined) {
            $("div[id$=PanelOutBoundPrescription]")[0].innerHTML = pageResponse;
        }

    }


    //Description:Used to encode text
    //Author:Pradeep
    //CreatedOn:Oct 14,2009
    //To encode HTML-Start

    function encodeText(TextToEncode) {
        try {
            return escape(TextToEncode)
                .replace(/\?/g, "%3F")
                .replace(/\=/g, "%3D")
                .replace(/&/g, "%26")
                .replace(/@/g, "%40")
                .replace(/\+/g, "%2B")
                .replace(/&/g, "%26")
                .replace(/,/g, "%2C")
                .replace(/:/g, "%3A")
                .replace(/:/g, "%3B")
                .replace(/#/g, "%23");
        } catch (ex) {
        }
    }

    //Description:Used to encode text
    //Author:Vikas Monga
    //CreatedOn:Jan 08,2010
    //To decode HTML

    function decodeText(TextToDcode) {
        try {
            return TextToDcode.replace(/&gt;/g, ">")
                .replace(/&lt;/g, "<")
                .replace(/%3F/g, "?")
                .replace(/%3D/g, "=")
                .replace(/%26/g, "&")
                .replace(/%40/g, "@")
                .replace(/%2B/g, "+")
                .replace(/%26/g, "&")
                .replace(/%2C/g, ",")
                .replace(/&amp;/g, "&")
                .replace(/&amp;/g, "&");
        } catch (ex) {

        }
    }

    function ButtonDenyClick(SureScriptREfillRequestId, UserCode, DenialReasonCode, DenialReasonText, DenyType) {
       // debugger;
        try {
            var LabelErrorMessage = document.getElementById('LabelErrorMessage');
            var ImageError = document.getElementById('ImageError');
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            if (document.getElementById('DropDownDenialReason').value == 0) {
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please Select a Denial Reason';
                return false;
            }
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            var GetDenialReasonCode = document.getElementById(DenialReasonCode).value;
            var GetDenialReasonText = document.getElementById(DenialReasonText).value;
            var prescriberId = 0;
            prescriberId = parseInt(parent.$("[id*=DropDownListRefillPrescriber]")[0].value);
             var context = new Object();
            if (DenyType == "CHANGE"){
                context.Type = "RXChange";
                Streamline.SmartClient.WebServices.SureScriptRefillRequest.DenySureScriptsChangeRequests(SureScriptREfillRequestId, GetDenialReasonCode, GetDenialReasonText, UserCode, prescriberId, onSuccessfulDenySureScriptsRefillRequests, onFailure, context);
            }
            else
            {
                context.Type = "Refill";
                Streamline.SmartClient.WebServices.SureScriptRefillRequest.DenySureScriptsRefillRequests(SureScriptREfillRequestId, GetDenialReasonCode, GetDenialReasonText, UserCode, prescriberId, onSuccessfulDenySureScriptsRefillRequests, onFailure,context);
            }



        } catch (ex) {
        }
    }

    function onSuccessfulDenySureScriptsRefillRequests(result, context) {
       // debugger;
        alert("Denied");
        if (context.Type == "RXChange") {
            SortInboundRecord('', 'RxChange');
            CloseRefillDeniedReason();
        }
        else {
            SortInboundRecord('', '');
            CloseRefillDeniedReason();
        }
    }


    function ButtonDenyWithNewRxClick(SureScriptsRefillRequestId, UserCode, DenialReasonCode, DenialReasonText, ClientId, PharmacyId, PharmacyName, DrugCategory) {
        try {
            var LabelErrorMessage = document.getElementById('LabelErrorMessage');
            var ImageError = document.getElementById('ImageError');
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            if (document.getElementById('TextBoxDenialReason').value == '') {
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please Enter a Denial Reason';
                return false;
            }
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            var GetDenialReasonCode = 0; //document.getElementById(DenialReasonCode).value;
            var GetDenialReasonText = document.getElementById(DenialReasonText).value;
            var prescriberId = 0;
            prescriberId = parseInt(parent.$("[id*=DropDownListRefillPrescriber]")[0].value);

            var context = new Object();
            context.SureScriptsRefillRequestId = SureScriptsRefillRequestId;
            context.UserCode = UserCode;
            context.DenialReasonCode = DenialReasonCode;
            context.DenialReasonText = DenialReasonText;
            context.ClientId = ClientId;
            context.PharmacyId = PharmacyId;
            context.PharmacyName = PharmacyName;
            context.DrugCategory = DrugCategory;

            Streamline.SmartClient.WebServices.SureScriptRefillRequest.DenySureScriptsRefillRequestsWithNewRx(SureScriptsRefillRequestId, GetDenialReasonCode, GetDenialReasonText, UserCode, prescriberId, onSuccessfulDenySureScriptsRefillRequestsWithNewRx, onFailure, context);
        } catch (ex) {
        }
    }

    function onSuccessfulDenySureScriptsRefillRequestsWithNewRx(result, context) {
        SortInboundRecord('', '');
        CloseRefillDeniedReason();
        parent.redirectToOrderPageFromDashBoard(context.ClientId, context.SureScriptsRefillRequestId, context.PharmacyId, context.PharmacyName, context.DrugCategory);
    }

    // added By Priya  to Open RefillDeniedReason Page Ref:Task no:85

    function openRefillDeniedReason(SureScriptsRefillRequestId, UserCode, DenyType) {
        // debugger;
        try {
            var DivSearch = parent.document.getElementById('DivSearch1');
            DivSearch.style.display = 'block';
            var iFrameSearch = parent.document.getElementById('iFrame1');
            var dt = new Date();
            var currentTime = dt.getTime();
            iFrameSearch.src = 'RefillDenialReason.aspx?SureScriptsRefillRequestId=' + SureScriptsRefillRequestId + '&UserCode=' + UserCode + '&Time=' + currentTime + '&DenyType=' + DenyType;
            iFrameSearch.style.positions = 'absolute';
            iFrameSearch.style.left = '140px';
            iFrameSearch.style.width = '380px';
            iFrameSearch.style.height = '200px';
            iFrameSearch.style.top = '200px';
            iFrameSearch.style.scrollbars = 'yes';
            iFrameSearch.style.display = 'block';
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        return false;
    }

    // added By Priya  to Close RefillDeniedReason Page Ref:Task no:85

    function CloseRefillDeniedReason() {

        var DivSearch = parent.document.getElementById('DivSearch1');
        DivSearch.style.display = 'none';
    }

    //added By priya Ref:Task No:85

    function validateRefillDeniedReasonPage() {
        try {
            var LabelErrorMessage = document.getElementById('LabelErrorMessage');
            var ImageError = document.getElementById('ImageError');
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            if (document.getElementById('DropDownDenialReason').value == 0 && document.getElementById('TextBoxDenialReason').value == '') {
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please select Denial Reason';
                return false;
            }

            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            return true;
        } catch (ex) {
        }
    }

    function onOutboundPrescriptionHeaderClick(obj) {
        try {
            var ColumnName = obj.getAttribute("ColumnName");
            SortOutboundRecord(ColumnName);
        } catch (e) {

        }
    }

    function PopupCenter(pageURL, title, w, h) {
        w = w || screen.width - 200;
        h = h || screen.height - 200;
        var left = (screen.width / 2) - (w / 2);
        var top = (screen.height / 2) - (h / 2);
        var targetWin = window.open(pageURL, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
    }

    var OutBoundPrescriptionSortField = "CreatedDate Desc";

    function SortOutBoundPrescriptionListPage(sortField) {
        OutBoundPrescriptionSortField = sortField;
        var obpStaff = $("[id*=DropDownListOutBoundPrescriber]")[0].value;
        fnShow();
        $("#HiddenControlPath").val("~/UserControls/ClientList.ascx");
        $.ajax({
            type: "POST",
            url: "./ApplicationForm.aspx",
            data: { 'sortField': sortField, 'obpStaffid': obpStaff },
            success: onSortOutBoundPrescriptionListPage,
            error: onFailure
        });
    }

    function onSortOutBoundPrescriptionListPage(result) {
        var start = result.indexOf('<!-- ###StartOutboundPrescripts### -->') + 38;
        var end = result.indexOf('<!-- ###EndOutboundPrescripts### -->');
        var pageResponse = result;
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
           // var width = $(window).width();
           // var tableWidth = parseInt($(".ListPageHeader>table", pageResponse).attr('width'));
            var outboundPanel = $("[id$='PanelOutBoundPrescription']");
            outboundPanel.html(pageResponse);
           // $(".ListPageHeader", outboundPanel).width((width >= tableWidth ? tableWidth : (width - 18)));
          //  tableWidth = tableWidth + 18;
           // $(".ListPageContent", outboundPanel).width((width >= tableWidth ? tableWidth : width));
        }
        fnHideParentDiv();
    }

    function EnableDisableChangeOrderButton(obj) {
        var ChangeOrderButtonModify = new Array();
        $('[id$=MedicationList1_PanelMedicationList] input:checkbox:checked').each(function () {
            ChangeOrderButtonModify.push($(this).attr("DrugCategory"));
        });
        var cat2Found = ChangeOrderButtonModify.indexOf("2");
        var cat3Found = ChangeOrderButtonModify.indexOf("3");
        var cat4Found = ChangeOrderButtonModify.indexOf("4");
        var cat5Found = ChangeOrderButtonModify.indexOf("5");

        if (cat2Found >= 0 || cat3Found >= 0 || cat4Found >= 0 || cat5Found >= 0) {
            parent.document.getElementById('Control_ASP.usercontrols_medicationmgt_ascx_ButtonReOrder').disabled = true;
        }
        else {
            parent.document.getElementById('Control_ASP.usercontrols_medicationmgt_ascx_ButtonReOrder').disabled = false;
        }
    }

    function EnableDisableCompleteOrderbtn(obj, source) {
        var cid = obj.id;
        var flag = true;
        var Brow_UserAgent = navigator.userAgent.toLowerCase();
        if (source == "SmartCareOrders") {
            $('.RxMedications').attr("disabled", "true");
            $('.SmartCareOrders').removeAttr("disabled");
            if (Brow_UserAgent.indexOf("chrome") > -1 && Brow_UserAgent.indexOf("chromium") < 0) {
                $(".RxMedications").css("pointer-events", "none");
                $(".SmartCareOrders").css("pointer-events", "auto");
            }
            var re = $("#" + cid).parent().attr('class');          
            if (re == "SmartCareOrders_N") {
                sessionStorage.setItem("COMPLETEORDERSTORX", "N");
                $('[id$=ButtonCompleteOrder]').attr("disabled", "true");
            }
            else {
                if ($('[id$=HiddenFieldPermissionCheckButtonCompleteOrder]').val() == 'Y') {
                    $('[id$=ButtonCompleteOrder]').removeAttr("disabled");
                    sessionStorage.setItem("COMPLETEORDERSTORX", "Y");
                }
            }
            $('[id$=ButtonReOrder]').attr("disabled", "true");
            $('[id$=ButtonRefillOrder]').attr("disabled", "true");
        }
        else if (source == "RxMedications") {
            $('.SmartCareOrders').attr("disabled", "true");
            $('.RxMedications').removeAttr("disabled");
            if (Brow_UserAgent.indexOf("chrome") > -1 && Brow_UserAgent.indexOf("chromium") < 0) {
                $(".SmartCareOrders").css("pointer-events", "none");
                $(".RxMedications").css("pointer-events", "auto");
            }
            $('[id$=ButtonCompleteOrder]').attr("disabled", "true");
            if ($('[id$=HiddenFieldPermissionCheckButtonReOrder]').val() == 'Y') {
                $('[id$=ButtonReOrder]').removeAttr("disabled");
            }
            if ($('[id$=HiddenFieldPermissionCheckButtonRefillOrder]').val() == 'Y') {
                $('[id$=ButtonRefillOrder]').removeAttr("disabled");
            }
        }

        $('[id$=MedicationList1_PanelMedicationList] input:checkbox:checked').each(function () {
            flag = false;
        });

        if (flag) {
            $('.SmartCareOrders').removeAttr("disabled");
            $('.RxMedications').removeAttr("disabled");
            $('[id$=ButtonCompleteOrder]').attr("disabled", "true");
            if ($('[id$=HiddenFieldPermissionCheckButtonReOrder]').val() == 'Y') {
                $('[id$=ButtonReOrder]').removeAttr("disabled");
            }
            if ($('[id$=HiddenFieldPermissionCheckButtonRefillOrder]').val() == 'Y') {
                $('[id$=ButtonRefillOrder]').removeAttr("disabled");
            }
            if (Brow_UserAgent.indexOf("chrome") > -1 && Brow_UserAgent.indexOf("chromium") < 0) {
                $(".SmartCareOrders").css("pointer-events", "auto");
                $(".RxMedications").css("pointer-events", "auto");
            }
        }
    }



