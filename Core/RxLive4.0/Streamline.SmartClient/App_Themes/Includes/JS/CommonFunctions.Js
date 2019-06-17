function OpenNewPage(Control, PageName) {
    document.getElementById("HiddenPageName").value = PageName;
    __doPostBack(Control, PageName);

}


function ShowUseKeyPhrasePage() {
    try {
        ShowUseKeyPhraseDiv();
    }
    catch (e) {

    }

}

function ShowUseKeyPhraseDiv() {
    try {
        ShowError('', false);
        var $DivUseKeyPhrase = $("#DivUseKeyPhrase");
        $("#topborderUseKeyPhrase", $DivUseKeyPhrase).text("SmartCareRx");
        $divIframe = document.getElementById("myIframe");
        $divIframe.innerHTML = '<object width="210" height="570" type="text/html" data="UseKeyPhrase.aspx"></object>';
        var left = 5;
        var top = 5;
        $DivUseKeyPhrase.css({ 'top': top, 'left': left });
        $DivUseKeyPhrase.draggable();
        $DivUseKeyPhrase.css('display', 'block');

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}

function ShowKeyPhrasePage() {
    try {
        ShowKeyPhrasePageDiv();
    }
    catch (e) {

    }

}

function ShowKeyPhrasePageDiv() {
    try {
        ShowError('', false);
        var $DivKeyAndAgencyPhrase = $("#DivKeyAndAgencyPhrase");
        $("#topborderKeyAndAgencyPhrase", $DivKeyAndAgencyPhrase).text("SmartCareRx");
        $divIframe = document.getElementById("KeyAndAgencyPhraseIframe");
        $divIframe.innerHTML = '<object width="800" height="555" type="text/html" data="KeyPhrases.aspx"></object>';
        var left = 10;
        var top = 10;
        $DivKeyAndAgencyPhrase.css({ 'top': top, 'left': left });
        $DivKeyAndAgencyPhrase.draggable();
        $DivKeyAndAgencyPhrase.css('display', 'block');


    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}


var CommonFunctions = {
    ShowWarning: function (ShowMessage, ShowImage) {
    try {
        if (ShowImage == true) {
            document.getElementById('ImgError').style.visibility = 'visible';
            document.getElementById('ImgError').src = "App_Themes/Includes/Images/Warning.gif";
            document.documentElement.scrollTop = 0;
        }
        else {
            document.getElementById('ImgError').style.visibility = 'hidden';
        }

        if (document.getElementById('LabelError') != null)
            document.getElementById('LabelError').innerText = ShowMessage;
        else if (document.getElementById('Control_ASP.usercontrols_medicationorderdetails_ascx_LabelError') != null)
            document.getElementById('Control_ASP.usercontrols_medicationorderdetails_ascx_LabelError').innerText = ShowMessage;
        else
            document.getElementById('Control_ASP.usercontrols_medicationmgt_ascx_LabelError').innerText = ShowMessage;
    }
    catch (Err) {
        document.getElementById('ImgError').style.visibility = 'visible';
        if (document.getElementById('LabelError') != null)
            document.getElementById('LabelError').innerText = 'An Error Occured, Please Contact your System Administrator';
        else if (document.getElementById('Control_ASP.usercontrols_medicationorderdetails_ascx_LabelError') != null)
            document.getElementById('Control_ASP.usercontrols_medicationorderdetails_ascx_LabelError').innerText = ShowMessage;
        else
            document.getElementById('Control_ASP.usercontrols_medicationmgt_ascx_LabelError').innerText = 'An Error Occured, Please Contact your System Administrator';

        return false;
    }
    },
    ShowError: function (ShowMessage, ShowImage) {
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
    },
    redirectToReportViewer: function (LocationId, ScriptIds) {
    try {
            this.ShowError('', false);
        var myans1 = window.open('ReportViewer.aspx?PrescribingLocationId=' + LocationId + '&GeneratedScriptIds=' + ScriptIds, '', 'menubar = 0;status = 0; height=800px,width=710px,top=20px,left=170px,scrollbars=1');
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
    },
    trimAll: function (strValue) {
    var objRegExp = /^(\s*)$/;
    if (objRegExp.test(strValue)) {
        strValue = strValue.replace(objRegExp, '');
        if (strValue.length == 0)
            return strValue;
    }
    objRegExp = /^(\s*)([\W\w]*)(\b\s*$)/;
    if (objRegExp.test(strValue)) {
        //remove leading and trailing whitespace characters
        strValue = strValue.replace(objRegExp, '$2');
    }
    return strValue;
    },
    PrintMedicationScript: function (varScriptIds, varAllFaxed, varChartScriptIds, varFaxSendStatus) {
    var date1 = new Date();
        this.ShowPrintMedicationScriptDiv(varScriptIds, varAllFaxed, varChartScriptIds, varFaxSendStatus);
    },
    ShowPrintMedicationScriptDiv: function (ScriptIds, AllFaxed, ChartScriptIds, varFaxSendStatus) {
    try {
            this.ShowError('', false);
        if (AllFaxed == "0")
            alert('Some Medications could not be Faxed,Please review script History!');
        var d = new Date();
        var myans1 = window.open('MedicationScriptPrinting.aspx?varScriptIds=' + ScriptIds + '&varChartScriptIds=' + ChartScriptIds + '&varFaxSendStatus=' + varFaxSendStatus + '&varTime =' + d.getTime(), '', 'menubar = 0;status = 0; height=500px,width=750px,top=20px,left=170px,scrollbars=1');
        if ($("[id$=HiddenFieldRedirectFrom]").val().toUpperCase() == "DASHBOARD")
            redirectToStartPage();
        else
            redirectToManagementPage();
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
    },
    ShowPrintPatientConsentDiv: function (ScriptIds, AllFaxed, ChartScriptIds, varFaxSendStatus) {
    try {
        var datetime = new Date();
        var myans1 = window.open("ConsentStandardReportViewer.aspx?&varClientMedicationIds=" + ScriptIds + "&ReportViewer=" + false + "&datetime=" + datetime.getMinutes() + datetime.getSeconds(), '', 'menubar = 0;status = 0; height=500px,width=820px,top=20px,left=170px,scrollbars=1');
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
    },
    IsNumericValue: function (strString)   //  check for valid numeric strings 
{
    try {
        var strValidCharacter = "0123456789";
        var strChar;
        var blnResult = true;
        if (strString.length == 0) {
            return false;
        }
        for (i = 0; i < strString.length && blnResult == true; i++) {
            strChar = strString.charAt(i);
            if (strValidCharacter.indexOf(strChar) == -1) {
                blnResult = false;
            }
        }
        return blnResult;
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    }
}

