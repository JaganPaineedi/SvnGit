
var DiagnosisType = 'Diagnoses';

function AddCommonUserControlsEventHandlers() {
    try {
        $("#TextBox_DiagnosesIAndII_DiagnosisOrder").each(function() {
            $(this).keyup(function() {
                RetainOrderForDiagnosisIandII(this);
            })
        }
            )
    }
    catch (err) {
        LogClientSideException(err, 'AddEventHandlers'); //Code added by Devinder 
    }
}
//Public Variables
var DiagnosisOrder;
//******************************//
//Author: Mohit Madaan
//Description: This function is used to Open the AxisV Legends Popup and Get the Value in AxisV TextBox.
//Modified by:Ashwani K. Angrish on 17 JAn 2011
//Description :change from showModalDialog to OpenPage
function OpenAxisVLegend(val, obj, baseUrl) {
    try {
        var myDate = new Date();
        var time = myDate + myDate.getMinutes() + myDate.getSeconds();
        if (val == 'V') {
            OpenPage(5765, 118, 'Value=' + val + '^TextVal=' + obj.value + '^time=' + time, null, GetRelativePath(), 'T', "dialogHeight: 400px; dialogWidth: 800px;dialogTitle:Global Assessment");
            //        //=========Commented By Ashwani on 17 Jan 2011
            //            returnValue = window.showModalDialog(baseUrl + "ShowDiagnosisAxisPopUp.aspx?Value=" + val + "&TextVal=" + obj.value + "&time=" + time + "", "null", "status:no;edge:center:yes;sunken;resizable:no;dialogWidth:800px;dialogHeight:350px");
            //            parseInt(returnValue)
            //            if (val == 'V') {
            //                //Purpose: To fill average between start & end in AxisV by Checking if selected values is not empty & it is numeric
            //                if (returnValue != '' && isNaN(parseInt(returnValue)) == false) {
            //                    var TextBoxDiagnosesVAxisV = $("#TextBox_DiagnosesV_AxisV");

            //                    if (parseInt(returnValue) == 0) {
            //                        // $("#TextBox_DiagnosesV_AxisV").val(0);
            //                        TextBoxDiagnosesVAxisV.val(0);
            //                        CreateAutoSaveXml('DiagnosesV', 'AxisV', TextBoxDiagnosesVAxisV.val());
            //                    }
            //                    else {
            //                        //$("#TextBox_DiagnosesV_AxisV").val(parseInt(returnValue) - 5);
            //                        TextBoxDiagnosesVAxisV.val(parseInt(returnValue) - 5);
            //                        CreateAutoSaveXml('DiagnosesV', 'AxisV', TextBoxDiagnosesVAxisV.val());
            //                    }
            //                }
            //            }
            //            //=========END Commented By Ashwani on 17 Jan 2011
        }
    }
    catch (err) {
        LogClientSideException(err, 'OpenAxisVLegend'); //Code added by Devinder 
    }
}

//******************************//
//Author: Vikas Vyas
//Description: This function is used to Open the AxisV Legends Popup on MA Service note and Get the Value in AxisV TextBox.
function OpenAxisVLegendForMAServiceNote(textBoxID, val, obj, baseUrl) {
    try {
        var myDate = new Date();
        var time = myDate + myDate.getMinutes() + myDate.getSeconds();
        if (val == 'V') {
            var myDate = new Date();
            OpenPage(5765, 118, 'Value=' + val + '^TextVal=' + obj.value + '^time=' + myDate.getMinutes() + myDate.getSeconds(), null, GetRelativePath(), 'T', "dialogHeight: 350px; dialogWidth: 800px;dialogTitle:Global Assessment");
            //====================Commented By Ashwani on 17 JAn 2011====================
            //            returnValue = window.showModalDialog(baseUrl + "ShowDiagnosisAxisPopUp.aspx?Value=" + val + "&TextVal=" + obj.value + "&time=" + time + "", "null", "status:no;edge:center:yes;sunken;resizable:no;dialogWidth:800px;dialogHeight:350px");
            //            parseInt(returnValue)
            //            if (val == 'V') {
            //                //Purpose: To fill average between start & end in AxisV by Checking if selected values is not empty & it is numeric
            //                if (returnValue != '' && isNaN(parseInt(returnValue)) == false) {
            //                    textBoxID = "#" + textBoxID;
            //                    var TextBoxDiagnosesVAxisV = $("" + textBoxID + "");

            //                    if (parseInt(returnValue) == 0)
            //                    // $("#TextBox_DiagnosesV_AxisV").val(0);
            //                        TextBoxDiagnosesVAxisV.val(0);
            //                    else {
            //                        //$("#TextBox_DiagnosesV_AxisV").val(parseInt(returnValue) - 5);
            //                        TextBoxDiagnosesVAxisV.val(parseInt(returnValue) - 5);
            //                        CreateAutoSaveXml('DiagnosesV', 'AxisV', TextBoxDiagnosesVAxisV.val());
            //                    }
            //                }
            //                $(textBoxID).change();
            //            }
            //====================END Commented By Ashwani on 17 JAn 2011====================
        }
    }
    catch (err) {
        LogClientSideException(err, 'OpenAxisVLegendForMAServiceNote');
    }
}


// Purpose: Function used to handle the AxisV TextBox Validation
// Created By : Mohit Madaan
//Created Date : September 4,2009
var AxisValue;
function CheckAxisVLegend(obj) {
    try {
        var value = obj.value;
        if (!isNaN(value) == true || value == '') {
            if (obj.value != '') {
                AxisValue = obj.value;
                $("#ButtonAxisVRanges")[0].focus = true;
            }
        }
        else {
            if (AxisValue != '' && AxisValue != undefined) {
                $("#TextBox_DiagnosesV_AxisV").val(AxisValue);
            }
            else {
                $("#TextBox_DiagnosesV_AxisV").val('');
                $("#ButtonAxisVRanges")[0].focus = true;
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'CheckAxisVLegend'); //Code added by Devinder 
    }
}

// Purpose: Function used Change the Text Value of AxisV to Old Integer value if Exists.
// Created By : Mohit Madaan
//Created Date : September 4 2009
function changeVal(obj) {
    try {
        var value = obj.value;
        if (!isNaN(value) || value == '') {
            AxisValue = value
        }
    }
    catch (err) {
        LogClientSideException(err, 'changeVal'); //Code added by Devinder 
    }
}

//Samrat Task #1464
function validateICDlength(obj) {
    var _return = true;
    var _value = $('#TextBox_DiagnosesIIICodes_ICDCode').val();
    if (_value.toString().length == 0) {
        ShowHideErrorMessage('', 'false');
    }
    else if (_value.toString().length < 2) {
        _return = false;
        ShowHideErrorMessage('Please enter minimum 2 characters', 'true');
        $('#TextBox_DiagnosesIIICodes_ICDCode').focus();
    }

    else {
        ShowHideErrorMessage('', 'false');
    }
    return _return;
}

//Purpose:TO Set the Value in TextBoxIII, When User select value from PopUp
//Created By: Mohit Madaan
//Date      : September 4,2009
var textBoxICDCode;
function OpenDiagnosisIIIPopUp(obj, baseUrl) {
    try {
        //Samrat Task #1464
        if (!validateICDlength(obj)) {
            return false;
        }
        
        if (obj.value != '' && obj.value != undefined) {
            textBoxICDCode = obj;
            $.ajax({
                type: "POST",
                //url: $(textBoxICDCode)[0].getAttribute('baseUrl') + "AjaxScript.aspx?functionName=VerifyICDCode",
                url: baseUrl + "AjaxScript.aspx?functionName=VerifyICDCode",
                data: 'ICDCode=' + obj.value,
                success: handleICDCodeOnCallback
            });
        }
        else {
            $("#TextBoxICDDescription").val('');
            $("#TextBoxICDDescription")[0].style.display = 'block';
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].innerHTML = '';
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].style.display = 'none';
            //$("#TableChildControl_DiagnosesIIICodes_ButtonInsert").val('Insert');

        }
    }
    catch (err) {
        LogClientSideException(err, 'OpenDiagnosisIIIPopUp'); //Code added by Devinder 
    }
    return true;
}
//Author Mohit Madaan
// This function is used for handle the request for ICD COdes.
function handleICDCodeOnCallback(result) {
    try {
        if (result == '-1') // For Wrong entry
        {
            //$("[Id=" + textBoxICDCode.id + "]").val('');
            //$("[Id=" + textBoxICDCode.id + "]")[0].focus();
            SetDiagnosesIIIControlToDefault();
        }
        else if (result == '0') // for exact match
        {
            var replaceString = result;
            var diagnosisValue = replaceString.split("$$$");
            $("#TextBox_DiagnosesIIICodes_ICDCode").val(diagnosisValue[0]);
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].style.display = 'block';
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].innerHTML = diagnosisValue[1];
            $("#TextBoxICDDescription")[0].style.display = 'none';
            $("#TextBoxICDDescription").val('');
        }
        else if (result == '1') // To Open the popup
        {
            OpenModelDialogueforDiagnosisIII();
        }
        else {
            var replaceString = result;
            var diagnosisValue = replaceString.split("$$$");
            $("#TextBox_DiagnosesIIICodes_ICDCode").val(diagnosisValue[0]);
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].style.display = 'block';
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].innerHTML = diagnosisValue[1];
            $("#TextBoxICDDescription")[0].style.display = 'none';
            $("#TextBoxICDDescription").val('');
        }
    }
    catch (err) {
        LogClientSideException(err, 'handleICDCodeOnCallback'); //Code added by Devinder 
    }
}

//Author: Mohit Madaan
//This function is used to open the PopUp For AxisIII Codes
function OpenModelDialogueforDiagnosisIII() {
    try {
        var val = 'III';
        var myDate = new Date();
        var time = myDate + myDate.getMinutes() + myDate.getSeconds();
        if (textBoxICDCode.value != '' || textBoxICDCode.value != undefined) {
            OpenPage(5765, 118, 'Value=' + val + '^TextVal=' + textBoxICDCode.value + '^time=' + time, null, GetRelativePath(), 'T', "dialogHeight: 400px; dialogWidth: 800px;dialogTitle:Diagnosis Code");
            //==========Commented by Ashwani on 17 Jan 2011
            //returnValue = window.showModalDialog($(textBoxICDCode)[0].getAttribute('baseUrl') + "ShowDiagnosisAxisPopUp.aspx?Value=" + val + "&TextVal=" + textBoxICDCode.value + "&time=" + time + "", "null", "center:yes;resizable:no;dialogWidth:800px;dialogHeight:350px;");
            //           
            //            //Added by Anuj on 14 July,2010
            //            if (returnValue != '' && returnValue != undefined) {
            //                var replaceString = returnValue;
            //                var diagnosisValue = returnValue.split("$$$");
            //                diagnosisValue[1] = diagnosisValue[1].replace("^", "\"");
            //                diagnosisValue[1] = diagnosisValue[1].replace("~", "\'");

            //                $("#TextBox_DiagnosesIIICodes_ICDCode").val(diagnosisValue[0]);
            //                $("#Span_DiagnosesIIICodes_ICDDescription")[0].style.display = 'block';
            //                $("#Span_DiagnosesIIICodes_ICDDescription")[0].innerHTML = diagnosisValue[1];
            //                $("#TextBoxICDDescription")[0].style.display = 'none';
            //                $("#TextBoxICDDescription").val('');
            //            }
            //            else {
            //                SetDiagnosesIIIControlToDefault();
            //                //Clear DiagnosesIAndII
            //            }
            //            return false;
            //            //Ended over here
            //==========End Commented by Ashwani on 17 Jan 2011
        }
    }
    catch (err) {
        LogClientSideException(err, 'OpenModelDialogueforDiagnosisIII'); //Code added by Devinder 
    }
}

//Purpose     :This function is used to Toggle the Textbox and Span of Description 
//Created By  :Mohit Madaan
//Created Date:September 5,2009
function ToggleDescriptionLabelAndTextBox(obj) {
    try {

        var value = obj.value;
        if (value == '') {

            $("#TextBoxDSMDescription").val('');
            $("#TextBoxDSMDescription")[0].style.display = 'block';
            $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = '';
            $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'none';
        }
    }
    catch (err) {
        LogClientSideException(err, 'ToggleDescriptionLabelAndTextBox'); //Code added by Devinder 
    }
}

//Description:Use to check from which TextBox we call to open popup
//Name: Mohit Madaan
//Date: September 5,2009
var textBoxDSMCode;
function openDiagnosisIandIIPopUp(obj, baseUrl) {

    try {

        if (obj.value != '' && obj.value != undefined) {
            textBoxDSMCode = obj;

            $.ajax({
                type: "POST",
                //url: $(textBoxDSMCode)[0].getAttribute('baseUrl') + "AjaxScript.aspx?functionName=VerifyDSMCode",
                url: baseUrl + "AjaxScript.aspx?functionName=VerifyDSMCode",
                data: 'DSMCode=' + obj.value,
                success: handleDSMCodeOnCallback
            });
        }
        else {
            $("#TextBoxDSMDescription").val('');
            $("#TextBoxDSMDescription")[0].style.display = 'block';
            $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = '';
            $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'none';
            $("#SpanAxis")[0].style.display = 'none';
            $("#SpanAxis").innerHTML = '';
            //============= commented by Rakesh on 14 Sep 2011===ref task# 501==to set focus on checkbox
            $("#CheckBox_DiagnosesIAndII_RuleOut").focus();
            //$("#ButtonInsert")[0].disabled = true;
            // $("#TableChildControl_DiagnosesIAndII_ButtonInsert").val('Insert');
        }
    }
    catch (err) {
        LogClientSideException(err, 'openDiagnosisIandIIPopUp'); //Code added by Devinder 
    }
    return true;
}
//Author: Mohit Madaan
//Description: This function handle the call back for openDiagnosisIandIIPopUp function
function handleDSMCodeOnCallback(result) {

    try {
        if (result != '' && result != undefined) {
            if (result == '-1') {
               SetControlToDefault();
                //Clear Diagnoses
                //--Added by Ashwani K.Angrish on 10 Dec 2010                
                ShowHideErrorMessage('Invalid Dx Code.', 'true');

            }
            else if (result == '1') {
                SetDiagnosisIandIIDSMCodeValue(textBoxDSMCode);
            }
            else {

                var replaceString = result;
                var diagnosisValue = replaceString.split("$$$");
                $("#TextBox_DiagnosesIAndII_DSMCode").val(diagnosisValue[0]);
                $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'block';
                $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = diagnosisValue[1];
                $("#TextBoxDSMDescription")[0].style.display = 'none';
                $("#TextBoxDSMDescription").val('');
                $("#SpanAxis")[0].style.display = 'block';
                $("#SpanAxis")[0].style.display = 'block';
                $("#SpanAxis")[0].innerHTML = diagnosisValue[2];
                //$("#ButtonInsert")[0].disabled = false;
                $("#HiddenField_DiagnosesIAndII_DSMNumber").val(diagnosisValue[3]);
                $("#HiddenField_DiagnosesIAndII_Axis").val(diagnosisValue[4]);
                //============= commented by Rakesh on 14 Sep 2011===ref task# 501==to set focus on checkbox
                $("#CheckBox_DiagnosesIAndII_RuleOut").focus();
                //document.getElementById(_controlPerfix + 'HiddenFieldDsmDescription').value = diagnosisValue[1];
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'handleDSMCodeOnCallback'); //Code added by Devinder 
    }
}

//Purpose:Used To Set DiagnosisIandII values in TextBoxCode,Description and Axis
//Created By: Mohit Madaan
//Date      : September 5,2009
function SetDiagnosisIandIIDSMCodeValue(obj) {

    try {
        var val = 'I';
        var myDate = new Date();
        var time = myDate + myDate.getMinutes() + myDate.getSeconds();
        OpenPage(5765, 118, 'Value=' + val + '^TextVal=' + obj.value + '^time=' + time, null, GetRelativePath(), 'T', "dialogHeight: 400px; dialogWidth: 800px;dialogTitle:Diagnosis Code");
        //==============Commented By Ashwani on 17 Jan
        //        returnValue = window.showModalDialog($(textBoxDSMCode)[0].getAttribute('baseUrl') + "ShowDiagnosisAxisPopUp.aspx?Value=" + val + "&TextVal=" + obj.value + "&time=" + time + "", "null", "center:yes;resizable:no;dialogWidth:800px;dialogHeight:350px;");
        //        if (returnValue != '' && returnValue != undefined) {
        //            var replaceString = returnValue;
        //            var diagnosisValue = returnValue.split("$$$");
        //            diagnosisValue[1] = diagnosisValue[1].replace("^", "\"");
        //            diagnosisValue[1] = diagnosisValue[1].replace("~", "\'");

        //            $("#TextBox_DiagnosesIAndII_DSMCode").val(diagnosisValue[0]);
        //            $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'block';
        //            $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = diagnosisValue[1];
        //            $("#TextBoxDSMDescription")[0].style.display = 'none';
        //            $("#TextBoxDSMDescription").val('');
        //            $("#SpanAxis")[0].style.display = 'block';
        //            $("#SpanAxis")[0].style.display = 'block';
        //            $("#SpanAxis")[0].innerHTML = diagnosisValue[2];
        //            //$("#ButtonInsert")[0].disabled = false;
        //            $("#HiddenField_DiagnosesIAndII_DSMNumber").val(diagnosisValue[3]);
        //            $("#HiddenField_DiagnosesIAndII_Axis").val(diagnosisValue[4]);
        //            //document.getElementById(_controlPerfix + 'HiddenFieldDsmDescription').value = diagnosisValue[1];
        //        }
        //        else {
        //            SetControlToDefault();
        //            //Clear DiagnosesIAndII
        //        }
        //        return false;
        //==============END Commented By Ashwani on 17 Jan
    }
    catch (err) {
        LogClientSideException(err, 'SetDiagnosisIandIIDSMCodeValue'); //Code added by Devinder 
    }
}

// Purpose: calculate the ASCII code of the given character
// Created By : Mohit Madaan
// Created Date : November 4,2009

function CalcKeyCode(aChar) {
    try {
        var character = aChar.substring(0, 1);
        var code = aChar.charCodeAt(0);
        return code;
    }
    catch (err) {
        LogClientSideException(err, 'CalcKeyCode'); //Code added by Devinder 
    }
}

function RetainOrderForDiagnosisIandII(val) {
    try {
        var strPass = val.value;
        var strLength = strPass.length;
        var lchar = val.value.charAt((strLength) - 1);
        var cCode = CalcKeyCode(lchar);

        /* Check if the keyed in character is a number
        do you want alphabetic UPPERCASE only ?
        or lower case only just check their respective
        codes and replace the 48 and 57 */

        if (cCode < 48 || cCode > 57) {
            var myNumber = "";
            val.value = myNumber;
        }
        else {
            DiagnosisOrder = val.value;
        }
    }
    catch (err) {
        LogClientSideException(err, 'RetainOrderForDiagnosisIandII'); //Code added by Devinder 
    }
    return false;
}



///Description:Use to open the Popup for TextBox Description
//Date:06/05/2009
var textBoxDSMDescription;
function openDiagnosisIWindowForDescription(obj, baseUrl) {
    try {
        if (obj.value != '' && obj.value != undefined) {
            textBoxDSMDescription = obj;
            var replaceString = obj.value.replace("\'", "~");
            $.ajax({
                type: "POST",
                //url: $(textBoxDSMDescription)[0].getAttribute('baseUrl') + "AjaxScript.aspx?functionName=VerifyDSMDescription",
                url: baseUrl + "AjaxScript.aspx?functionName=VerifyDSMDescription",
                data: 'DSMDesc=' + replaceString,
                success: handleDSMDesc
            });
        }
    }
    catch (err) {
        LogClientSideException(err, 'openDiagnosisIWindowForDescription'); //Code added by Devinder 
    }
    return false;
}
//Function is used to Set the DiagnosisIandII value when there is exact match of the DSMDescription String
//Author: Mohit Madaan
function handleDSMDesc(result) {

    try {
        if (result == '-1') {
            $("#TextBoxDSMDescription").val('');
        }
        else if (result == '1') {
            SetDiagnosisIandIIDSMDescValue()
        }
        else {
            var replaceString = result;
            var diagnosisValue = replaceString.split("$$$");

            diagnosisValue[1] = diagnosisValue[1].replace("^", "\"");
            diagnosisValue[1] = diagnosisValue[1].replace("~", "\'");

            $("#TextBox_DiagnosesIAndII_DSMCode").val(diagnosisValue[0]);
            $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'block';
            $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = diagnosisValue[1];
            $("#TextBoxDSMDescription")[0].style.display = 'none';
            $("#TextBoxDSMDescription").val('');
            $("#SpanAxis")[0].style.display = 'block';
            $("#SpanAxis")[0].style.display = 'block';
            $("#SpanAxis")[0].innerHTML = diagnosisValue[2];
            //$("#ButtonInsert")[0].disabled = false;
            $("#HiddenField_DiagnosesIAndII_DSMNumber").val(diagnosisValue[3]);
            $("#HiddenField_DiagnosesIAndII_Axis").val(diagnosisValue[4]);
            //document.getElementById(_controlPerfix + 'HiddenFieldDsmDescription').value = diagnosisValue[1];
        }
    }
    catch (err) {
        LogClientSideException(err, 'handleDSMDesc'); //Code added by Devinder 
    }
    return false;
}

//This function is used to open the Popup of for Diagnosis Description Values.
//Author: Mohit Madaan
function SetDiagnosisIandIIDSMDescValue() {

    try {
        var val = 'D';
        var myDate = new Date();
        var time = myDate + myDate.getMinutes() + myDate.getSeconds();
        var descVal = textBoxDSMDescription.value

        OpenPage(5765, 118, 'Value=' + val + '^TextVal=' + descVal + '^time=' + time, null, GetRelativePath(), 'T', "dialogHeight: 400px; dialogWidth: 800px;dialogTitle:Diagnosis Code");

        //  returnValue = window.showModalDialog($(textBoxDSMDescription)[0].getAttribute('baseUrl') + "ShowDiagnosisAxisPopUp.aspx?Value=" + val + "&TextVal=" + textBoxDSMDescription.value + "&time=" + time + "", "null", "center:yes;resizable:no;dialogWidth:800px;dialogHeight:350px;");
        //        if (returnValue != '' && returnValue != undefined) {
        //            var replaceString = returnValue;
        //            var diagnosisValue = returnValue.split("$$$");

        //            diagnosisValue[1] = diagnosisValue[1].replace("^", "\"");
        //            diagnosisValue[1] = diagnosisValue[1].replace("~", "\'");


        //            $("#TextBox_DiagnosesIAndII_DSMCode").val(diagnosisValue[0]);
        //            $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'block';
        //            $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = diagnosisValue[1];
        //            $("#TextBoxDSMDescription")[0].style.display = 'none';
        //            $("#TextBoxDSMDescription").val('');
        //            $("#SpanAxis")[0].style.display = 'block';
        //            $("#SpanAxis")[0].style.display = 'block';
        //            $("#SpanAxis")[0].innerHTML = diagnosisValue[2];
        //            //$("#ButtonInsert")[0].disabled = false;
        //            $("#HiddenField_DiagnosesIAndII_DSMNumber").val(diagnosisValue[3]);
        //            $("#HiddenField_DiagnosesIAndII_Axis").val(diagnosisValue[4]);
        //        }
        //        else {
        //            SetControlToDefault();
        //            //Clear DiagnosesIAndII
        //        }
    }
    catch (err) {
        LogClientSideException(err, 'SetDiagnosisIandIIDSMDescValue'); //Code added by Devinder 
    }
}
//This function is used to set the AxisI control to default values
//Author : Mohit Madaan
function SetControlToDefault() {
    // Set the Diagnoses Order
    try {
        ClearDiagnosisIandII();
    }
    catch (err) {
        LogClientSideException(err, 'SetControlToDefault'); //Code added by Devinder 
    }
}

//Function is used to open the PopUp for Diagnosis AxisIV categories.
//Author : Mohit Madaan
function OpenDiagnosisIVValues(obj, baseUrl) {
    try {
        var val = 'IV'; var k; var count;
        var myDate = new Date();
        var time = myDate + myDate.getMinutes() + myDate.getSeconds();
        if (obj != undefined) {

            var checkStatus = '';
            if (document.getElementById("CheckBox_DiagnosesIV_PrimarySupport").checked == true) {
                checkStatus = checkStatus + "1|";
            }
            if (document.getElementById("CheckBox_DiagnosesIV_SocialEnvironment").checked == true) {
                checkStatus = checkStatus + "2|";
            }
            if (document.getElementById("CheckBox_DiagnosesIV_Educational").checked == true) {
                checkStatus = checkStatus + "3|";
            }
            if (document.getElementById("CheckBox_DiagnosesIV_Occupational").checked == true) {
                checkStatus = checkStatus + "4|";
            }
            if (document.getElementById("CheckBox_DiagnosesIV_Housing").checked == true) {
                checkStatus = checkStatus + "5|";
            }
            if (document.getElementById("CheckBox_DiagnosesIV_Economic").checked == true) {
                checkStatus = checkStatus + "6|";
            }
            if (document.getElementById("CheckBox_DiagnosesIV_HealthcareServices").checked == true) {
                checkStatus = checkStatus + "7|";
            }
            if (document.getElementById("CheckBox_DiagnosesIV_Legal").checked == true) {
                checkStatus = checkStatus + "8|";
            }
            if (document.getElementById("CheckBox_DiagnosesIV_Other").checked == true) {
                checkStatus = checkStatus + "9|";
            }
            OpenPage(5765, 118, 'Value=' + val + '^TextVal=' + obj.value + '^CheckBox=' + checkStatus + '^time=' + time, null, GetRelativePath(), 'T', "dialogHeight: 400px; dialogWidth: 800px;dialogTitle:Diagnosis Code");
            //---------------Commented By Ashwani Kumar Angrish
            //            returnValue = window.showModalDialog(baseUrl + "ShowDiagnosisAxisPopUp.aspx?Value=" + val + "&TextVal=" + obj.value + "&CheckBox=" + checkStatus + "&time=" + time + "", "null", "center:yes;resizable:no;dialogWidth:800px;dialogHeight:350px;");
            //            if (isNaN(parseInt(returnValue)) == true) {
            //                if (typeof returnValue != "" && typeof returnValue != "undefined") {
            //                    checkedItemsValues = returnValue.split("|")
            //                    count = 1;
            //                    var objectCheckbox;
            //                    for (var j = 0; j < checkedItemsValues.length; j++) {

            //                        objectCheckbox = $('[categoryid=' + count + ']')[0];
            //                        if (checkedItemsValues[j] != "") {
            //                            k = checkedItemsValues[j].toString();
            //                            if (k.indexOf("Y") != -1) {
            //                                //$('[categoryid=' + count + ']')[0].checked = true;
            //                                objectCheckbox.checked = true;
            //                            }
            //                            else {
            //                                objectCheckbox.checked = false; //modified by Sweetyk on 8Feb,2010
            //                                //$('[categoryid=' + count + ']')[0].checked = false;
            //                            }

            //                            if (objectCheckbox.checked) {
            //                                CreateAutoSaveXml('DiagnosesIV', objectCheckbox.id.split('_')[2], "Y");
            //                            }
            //                            else {
            //                                CreateAutoSaveXml('DiagnosesIV', objectCheckbox.id.split('_')[2], "N");
            //                            }
            //                            count = count + 1;
            //                        }
            //                    }
            //                }
            //            }
            //----------------End Commented By Ashwani Kumar Angrish
        }
    }
    catch (err) {
        LogClientSideException(err, 'OpenDiagnosisIVValues'); //Code added by Devinder 
    }
}
//Function is used to Clear the DiagnosisIandII controls.
//Author Mohit Madaan
function AddParentChildEventHandler(containerTableName) {
    try {
        if (containerTableName.trim() == "TableChildControl_DiagnosesIAndII") {
            //$("#TextBox_DiagnosesIAndII_DSMCode").focus();
            if ($("#Span_DiagnosesIAndII_DSMDescription").length > 0) {
                $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = '';

            }

            $("#Span_DiagnosesIAndII_DSMDescription").hide();
            $("#TextBoxDSMDescription").show();
            $("#TextBoxDSMDescription").val('');
            $("#SpanAxis").hide()
            $("#SpanAxis").html('');
            $("#TextBox_DiagnosesIAndII_DSMCode").val('');
            //$("#TextArea_DiagnosesIAndII_Specifier").val('');       
            $("#TextArea_DiagnosesIAndII_Source").val('');
            $("#CheckBox_DiagnosesIAndII_RuleOut").removeAttr('checked');
            $("#RadioButton_DiagnosesIAndII_BillableYes_Y").attr('checked', 'checked');
            $("#RadioButton_DiagnosesIAndII_BillableNo_N").removeAttr('checked');
            $("[Id$=DropDownList_DiagnosesIAndII_DiagnosisType]").val('');
            // $("[Id$=DropDownList_DiagnosesIAndII_Severity]").val('');
            $("[Id$=DropDownList_DiagnosesIAndII_Remission]").val('');
            $("#TableChildControl_DiagnosesIAndII_ButtonInsert").val('Insert');
            //$("#ButtonInsert")[0].disabled = true;

            //Set the hieghest order on clear
            var order = $("#HiddenFieldOrder").val();
            $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val(order);

            //Calculate Order
            //UnSelect the Radio Button of the Grid on Clear Button
            // $("input[type=radio]", $("div#InsertGrid")).removeAttr('checked');
            //Clear the Primary key Value
            $("#HiddenField_DiagnosesIAndII_DiagnosisId").val('');
        }
        else if (containerTableName.trim() == "TableChildControl_DiagnosesIIICodes") {
            //$("#TextBox_DiagnosesIIICodes_ICDCode").focus();
            if ($("#Span_DiagnosesIIICodes_ICDDescription").length > 0) {
                $("#Span_DiagnosesIIICodes_ICDDescription")[0].innerHTML = '';

            }

            $("#Span_DiagnosesIIICodes_ICDDescription").hide();
            $("#TextBoxICDDescription").show();
            $("#TextBoxICDDescription").val('');

            $("#TextBox_DiagnosesIIICodes_ICDCode").val('');
            $("#CheckBox_DiagnosesIIICodes_Billable").removeAttr('checked');


            $("#TableChildControl_DiagnosesIIICodes_ButtonInsert").val('Insert');

            $("#HiddenField_DiagnosesIIICodes_DiagnosesIIICodeid").val('');
        }
    }
    catch (err) {
        LogClientSideException(err, 'AddParentChildEventHandler'); //Code added by Devinder 
    }
}

//Purpose: To make possible navigation between gridview rows & also to select there values
//Created By: Mohit Madaan
//Date      : September 4, 2009
var currentRowId = 0;
function SelectRow() {
    try {
        if ((window.event.keyCode ? window.event.keyCode : window.event.which) == 40) {
            MarkRow(currentRowId + 1);
            ScrollDivWithSelection(true);

        }
        else if ((window.event.keyCode ? window.event.keyCode : window.event.which) == 38) {
            MarkRow(currentRowId - 1);
            ScrollDivWithSelection(false);

        }
        else if ((window.event.keyCode ? window.event.keyCode : window.event.which) == 13) {
            MarkRow(currentRowId);
            //Modify by jagdeep as per task 1601	Harbor Go Live Issues
            SetParentReturnValue($('[id$=HiddenPopUpName]').val(), $('[id$=HiddenPageName]').val());
            //SetParentReturnValue('ok');
        }

    }
    catch (err) {
        LogClientSideException(err, 'SelectRow'); //Code added by Devinder 
    }
}

function ScrollDivWithSelection(isDownKeyPressed) {
    var _DivToScroll = $("div #div1");
    var _checkboxItem = $("tr input[type=radio]:checked", _DivToScroll);
    var _currentScroll = _DivToScroll[0].scrollTop;
    var scrollflag = 22;
    if ($.browser.msie) { if ($.browser.version == 7) { scrollflag = 23; } }
    if (_checkboxItem.length > 0) {
        var _PositionY = $(_checkboxItem[0]).parents("tr:first")[0].offsetTop;
        if (isDownKeyPressed) {

            if (_PositionY > 265) {
                _DivToScroll.scrollTop(_currentScroll + scrollflag);
            }
        }
        else {
            if (_currentScroll >= 10)
                _DivToScroll.scrollTop(_currentScroll - scrollflag);

        }
    }

}


//Used to change the selected row for Diangosis Popup
//Created Date: September 10, 2009
//Author: Mohit Madaan
function MarkRow(rowId) {
    try {
        if (document.getElementById(rowId) == null)
            return;
        if (document.getElementById(currentRowId) != null) {
            document.getElementById(currentRowId).style.backgroundColor = '#ffffff';
            if (rowId == 0) {
                document.getElementById(currentRowId).style.backgroundColor = '#ffffff';
            }
            else {//This code is added for maintain alternate color of row
                if (rowId % 2 == 0) {
                    document.getElementById(currentRowId).style.backgroundColor = '#f0f6f9';

                }
                else {
                    document.getElementById(currentRowId).style.backgroundColor = '#ffffff';
                }
            }
        }
        currentRowId = rowId;
        $("#buttonok").removeAttr("disabled");
        document.getElementById(rowId).style.backgroundColor = '#cccccc';
        var searchString = "title="
        var str;
        if ($("[id$=hddDisplayGridviewName]").val() != 'GridViewAxisIVLegend') { //Modify by jagdeep as per task 1601	Harbor Go Live Issues
       //if (document.getElementById('hddDisplayGridviewName').value != 'GridViewAxisIVLegend') {
            var parentobj = $("#" + rowId);
            if (parentobj.length > 0) {
                $("td>input[type=radio]", parentobj).attr("checked", "checked");
                var DSMs = $("td>span", parentobj);
                if (DSMs.length >= 4) {
                    var dsmcode = $.trim($(DSMs[0]).html()); ;
                    var dsmDescription = $.trim($(DSMs[1]).html());
                    var dsmAxis = $.trim($(DSMs[2]).html());
                    var dsmNumber = $.trim($(DSMs[3]).html());
                    var dsmAxisValue = $.trim($(DSMs[4]).html());
                    $("#hddnretval").val(dsmcode + "$$$" + dsmDescription + "$$$" + dsmAxis + "$$$" + dsmNumber + "$$$" + dsmAxisValue);
                }
                else if (DSMs.length == 2) {
                    $("#hddnretval").val($.trim($(DSMs[0]).html()));
                }
            }

            //            str = document.getElementById(rowId).outerHTML.substring(document.getElementById(rowId).outerHTML.search(searchString) + searchString.length);
            //            document.getElementById("hddnretval").value = str.substring(0, document.getElementById(rowId).outerHTML.search(" ") + 1);
        }
    }
    catch (err) {
        LogClientSideException(err, 'MarkRow'); //Code added by Devinder 
    }
}
//Function : This Function is used to get the selected the values from popup 
//Created Date: September 10, 2009
//Author: Mohit Madaan
//Modification On 29 July,2010 By Mahesh S Description : Add information when user hit the enter key Seprator
//Modified on :17 Jan 2011 by Ashwani K. Angrish 
//Description:changes form showdialog to modal popup
function GetRowValueOnSingleClick(val, rowNumber) {
    try {
        $("td>input[type=radio]", $("#" + rowNumber)).attr("checked", "checked");
        $("input[id$=buttonok]").removeAttr("disabled");
        $("input[id$=hddnretval]").val(val);

        //Code added by mahesh on 29 July,2010        
        if (val.toString().indexOf('$$$') > -1) {//$$$ found
            var arrayDescriptionICDCode = val.toString().split('$$$');
            $("input[id$=hiddenFieldForDescriptionICDCode]").val(arrayDescriptionICDCode[1])
        }
        //End of modificaiton

        if (currentRowId % 2 == 0) {
            document.getElementById(currentRowId).style.backgroundColor = '#ffffff';
        }
        else {
            document.getElementById(currentRowId).style.backgroundColor = '#f0f6f9';
        }
        currentRowId = rowNumber;
        document.getElementById(currentRowId).style.backgroundColor = '#cccccc';
        try {
            //to make ok button focus, so that scroll bar will not move
            $("$input[id$=buttonok]").focus();
        }
        catch (e)
              { }
    }
    catch (err) {
        LogClientSideException(err, 'GetRowValueOnSingleClick'); //Code added by Devinder 
    }
}
//Function : This Function is used to get the selected the values on double click
//Created Date: September 10, 2009
//Author: Mohit Madaan
//Modification on 29 July,2010 By Mahesh S Description Set the desctiption information if user hit the enter key ref with task #872
var rowColor = false;
function GetRowValueOnDoubleClick(val) {
    try {
        //document.getElementById("hddnretval").value = val;
        //modified by priya
        $('input[id$=hddnretval]').val(val);
        //Commendted by mahesh S window.returnValue = document.getElementById("hddnretval").value;
        //        if (val.toString().indexOf('$$$') > 0) {
        //            window.returnValue = document.getElementById("hddnretval").value;
        //        }
        //        else {//Code added by maehsh on 29 July 
        //            window.returnValue = document.getElementById("hddnretval").value + '$$$' + $("input[id$=hiddenFieldForDescriptionICDCode]").val();
        //        }
        //        window.close();
    }
    catch (err) {
        LogClientSideException(err, 'GetRowValueOnDoubleClick'); //Code added by Devinder 
    }
}
//Purpose:To Check if click on any row only that color row need to be changed, to show as selected row.
//Created By: Mohit Madaan
//Date      : September 4, 2009
var prevousRow = 0;
function ChangeRowColor(row) {
    try {
        if (prevousRow != 0) {
            //prevousRow.style.backgroundColor = row.style.backgroundColor;
            prevousRow.style.backgroundColor = '';
        }
        row.style.backgroundColor = '#cccccc';
        prevousRow = row;
    }
    catch (err) {
        LogClientSideException(err, 'ChangeRowColor'); //Code added by Devinder 
    }
}
//Function : This Function is used to set the Seleced Row value in returnValue variable on parent page.
//Created Date: September 10, 2009
//Author: Mohit Madaan
//Modification on 29 July,2010 By Mahesh S Description Set the desctiption information if user hit the enter key ref with task #872
//Modified On:17 jan 2011 by Ashwani K. Angrish
//Description:Changes for Modal Popup
function SetParentReturnValue(val, optionParam) {
    try {
        var returnValue;
        parent.UpdateLastSessionTime();
        if (val.toString().indexOf('$$$') > -1) {
            //return value contains$$$
            returnValue = $("input[id$=hddnretval]").val();
            parent.CloaseModalPopupWindow();
        }
        else {
            //If return values doesn't contains value then add $$$ and description
            returnValue = $("input[id$=hddnretval]").val() + '$$$' + $("input[id$=hiddenFieldForDescriptionICDCode]").val();
            parent.CloaseModalPopupWindow();
        }
        //-------For Diagnosis Code
        //Added by Ashwani K.  Ref:Task No:19 ARRA Development on 26 April 2011
        //to give developer the liberty to use the resultant diagnosis value to use
        if (typeof AppendDiagnosisCodeInXML == 'function') {
            var retVal = parent.AppendDiagnosisCodeInXML(returnValue);
            if (retVal == false)
                return false;
        }

        if ((val == 'I' || val == 'D') && $("input[id$=hddnretval]").val() != "") {

            if (returnValue != '' && returnValue != undefined) {
                var replaceString = returnValue;
                var diagnosisValue = returnValue.split("$$$");
                diagnosisValue[1] = diagnosisValue[1].replace("^", "\"");
                diagnosisValue[1] = diagnosisValue[1].replace("~", "\'");

                if (optionParam != undefined && optionParam == 'SN') {
                    //Commented by Ashwani K.  Ref:Task No:19 ARRA Development on 26 April 2011
                    //                    //added by shifali in ref to give developer the liberty to use
                    //                    //the resultant diagnosis value to use                    
                    //                    if (typeof AppendDiagnosisCodeInXML == 'function') {
                    //                        parent.AppendDiagnosisCodeInXML(returnValue);
                    //                        return false;
                    //                    }
                    parent.CreateAutoSaveXml('Services', parent.textBoxDSMCode.id.split('_')[2], diagnosisValue[0]);
                    if (parent.textBoxDSMCode.id.split('_')[2].indexOf('1') >= 0 && diagnosisValue[0] != "" && diagnosisValue[0] != undefined) {

                        parent.CreateAutoSaveXml('Services', "DiagnosisNumber1", diagnosisValue[3]);
                        parent.CreateAutoSaveXml('Services', "DiagnosisVersion1", "DSMIV");
                    }
                    else if (parent.textBoxDSMCode.id.split('_')[2].indexOf('2') >= 0 && diagnosisValue[0] != "" && diagnosisValue[0] != undefined) {

                        parent.CreateAutoSaveXml('Services', "DiagnosisNumber2", diagnosisValue[3]);
                        parent.CreateAutoSaveXml('Services', "DiagnosisVersion2", "DSMIV");
                    }
                    else if (parent.textBoxDSMCode.id.split('_')[2].indexOf('3') >= 0 && diagnosisValue[0] != "" && diagnosisValue[0] != undefined) {

                        parent.CreateAutoSaveXml('Services', "DiagnosisNumber3", diagnosisValue[3]);
                        parent.CreateAutoSaveXml('Services', "DiagnosisVersion3", "DSMIV");
                    }
                    parent.$("#" + parent.textBoxDSMCode.id)[0].value = diagnosisValue[0];
                    //openPopUp = -1;
                }
                else {
                    parent.$("#TextBox_DiagnosesIAndII_DSMCode").val(diagnosisValue[0]);
                    parent.$("[id$=Span_DiagnosesIAndII_DSMDescription]").css('display', 'block');
                    parent.$("[id$=Span_DiagnosesIAndII_DSMDescription]").html(diagnosisValue[1]);
                    parent.$("[id$=TextBoxDSMDescription]").css('display', 'none');
                    //============= commented by Ashwani on 17 JAn 2011
                    //              $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'block';
                    //              $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = diagnosisValue[1];
                    //              $("#TextBoxDSMDescription")[0].style.display = 'none';
                    ////============= commented by Ashwani on 17 JAn 2011
                    parent.$("#TextBoxDSMDescription").val('');
                    parent.$("#SpanAxis").css('display', 'block');
                    parent.$("#SpanAxis").html(diagnosisValue[2]);
                    parent.$("#HiddenField_DiagnosesIAndII_DSMNumber").val(diagnosisValue[3]);
                    parent.$("#HiddenField_DiagnosesIAndII_Axis").val(diagnosisValue[4]);
                    //Added by Rakesh w.rf task 974 in SC web phase II bugs/Features to hide message show on parent screen if user select diagnosis code 
                    parent.ShowHideErrorMessage('', 'false');
                    //============= commented by Rakesh on 14 Sep 2011===ref task# 501==to set focus on checkbox
                    parent.$("#CheckBox_DiagnosesIAndII_RuleOut").focus();
                }
            }
            else {
                if (optionParam != undefined && optionParam == 'SN') {
                    parent.$("#" + parent.textBoxDSMCode.id).val("");
                    parent.$("#" + parent.textBoxDSMCode.id).focus();
                    parent.CreateAutoSaveXml('Services', parent.textBoxDSMCode.id.split('_')[2], parent.$("#" + parent.textBoxDSMCode.id).val());
                    //openPopUp = 0;
                }
                else {
                    SetControlToDefault();
                }
            }
            return false;

        }
        //------------For Axis V Legend
        else if (val == 'V' && $("input[id$=hddnretval]").val() != "") {



            //Purpose: To fill average between start & end in AxisV by Checking if selected values is not empty & it is numeric
            if (returnValue != '' && isNaN(parseInt(returnValue)) == false) {
                var TextBoxDiagnosesVAxisV = parent.$("#TextBox_DiagnosesV_AxisV");

                if (parseInt(returnValue) == 0) {
                    // $("#TextBox_DiagnosesV_AxisV").val(0);
                    TextBoxDiagnosesVAxisV.val(0);
                    parent.CreateAutoSaveXml('DiagnosesV', 'AxisV', TextBoxDiagnosesVAxisV.val());
                }
                else {
                    //$("#TextBox_DiagnosesV_AxisV").val(parseInt(returnValue) - 5);
                    TextBoxDiagnosesVAxisV.val(parseInt(returnValue) - 5);
                    parent.CreateAutoSaveXml('DiagnosesV', 'AxisV', TextBoxDiagnosesVAxisV.val());
                }
            }

        }
        //Code added by Rakesh with ref to task 144 in SC web Phase II bugs/Features as Javscript error came so to save AxisV value in CustomHRMAssessments 
        else if (val == 'StaffAxisV' && $("input[id$=hddnretval]").val() != "") {
            //Purpose: To fill average between start & end in AxisV by Checking if selected values is not empty & it is numeric
            if (returnValue != '' && isNaN(parseInt(returnValue)) == false) {
                var TextBoxDiagnosesVAxisV = parent.$("#TextBox_CustomHRMAssessments_StaffAxisV");

                if (parseInt(returnValue) == 0) {

                    TextBoxDiagnosesVAxisV.val(0);
                    parent.CreateAutoSaveXml('CustomHRMAssessments', 'StaffAxisV', TextBoxDiagnosesVAxisV.val());
                }
                else {
                    TextBoxDiagnosesVAxisV.val(parseInt(returnValue) - 5);
                    parent.CreateAutoSaveXml('CustomHRMAssessments', 'StaffAxisV', TextBoxDiagnosesVAxisV.val());
                }
            }

        }
        //Code added ends here
        //-----------For Diagnosis III
        else if ((val == 'III' || val == 'DIII') && $("input[id$=hddnretval]").val() != "") {


            if (returnValue != '' && returnValue != undefined) {
                var replaceString = returnValue;
                var diagnosisValue = returnValue.split("$$$");
                diagnosisValue[1] = diagnosisValue[1].replace("^", "\"");
                diagnosisValue[1] = diagnosisValue[1].replace("~", "\'");

                parent.$("#TextBox_DiagnosesIIICodes_ICDCode").val(diagnosisValue[0]);
                parent.$("#Span_DiagnosesIIICodes_ICDDescription").css('display', 'block');
                parent.$("#Span_DiagnosesIIICodes_ICDDescription").html(diagnosisValue[1]);
                parent.$("#TextBoxICDDescription").css('display', 'none'); ;
                parent.$("#TextBoxICDDescription").val('');
            }
            else {
                SetDiagnosesIIIControlToDefault();
                //Clear DiagnosesIAndII
            }
            return false;
            //            //Ended over here
        }
        //-----------Axis IV
        else if (val == 'IV' && $("input[id$=hddnretval]").val() != "") {

            if (typeof returnValue != "" && typeof returnValue != "undefined") {
                checkedItemsValues = returnValue.split("|")
                count = 1;
                var objectCheckbox;
                for (var j = 0; j < checkedItemsValues.length; j++) {

                    objectCheckbox = parent.$('[categoryid=' + count + ']');
                    if (checkedItemsValues[j] != "") {
                        k = checkedItemsValues[j].toString();
                        if (k.indexOf("Y") != -1) {
                            //$('[categoryid=' + count + ']')[0].checked = true;
                            objectCheckbox[0].checked = true;
                        }
                        else {
                            objectCheckbox[0].checked = false; //modified by Sweetyk on 8Feb,2010
                            //$('[categoryid=' + count + ']')[0].checked = false;
                        }

                        if (objectCheckbox[0].checked) {
                            parent.CreateAutoSaveXml('DiagnosesIV', objectCheckbox[0].id.split('_')[2], "Y");
                        }
                        else {
                            parent.CreateAutoSaveXml('DiagnosesIV', objectCheckbox[0].id.split('_')[2], "N");
                        }
                        count = count + 1;
                    }
                }
            }

        }
        else {
            parent.CloaseModalPopupWindow();
        }

    }
    catch (err) {
        LogClientSideException(err, 'SetParentReturnValue'); //Code added by Devinder 
    }
}


function Close() {
    try {
        self.close();
    }
    catch (err) {
        LogClientSideException(err, 'Close'); //Code added by Devinder 
    }
}



//This Function is used to Insert- the Data In the Grid Control
//Author :Mohit Madaan
//Created Date : September 14,2009
function InsertDiagnosesIAndIIGridData(obj, tableChildControl, InsertGrid) {

    var dsmCode;
    try {
        dsmCode = $("#TextBox_DiagnosesIAndII_DSMCode").val();
        if (!ValidateAxisIAndII()) {
            return false;
        }
        if (dsmCode != '' && dsmCode != undefined) {
            $.ajax({
                type: "POST",
                url: $(obj)[0].getAttribute('baseUrl') + "AjaxScript.aspx?functionName=ValidateDSMCodeAndHighestOrder",
                //url: baseUrl + "AjaxScript.aspx?functionName=ValidateDSMCodeAndHighestOrder",
                data: 'DSMCode=' + dsmCode,
                success: function(result) {
                    var v = result.split(",");
                    //if (result == "1") {// For Valid DsmCode
                    if (v[0] == "1") {// For Valid DsmCode
                        // Add the Diagnoses Order in the HiddenField
                        var DiagnosisOrderVal = $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val();
                        //$("#HiddenFieldOrder").val($("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val());
                        InsertGridData(tableChildControl, InsertGrid, undefined, obj);
                        // var order = $("#HiddenFieldOrder").val();
                        if ($("#TableChildControl_DiagnosesIAndII_ButtonInsert").val() == "Insert") {
                            var order = parseInt($("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val()) + 1;
                            $("#HiddenFieldOrder").val(order);

                            $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val($("#HiddenFieldOrder").val());

                        }
                        else {
                            $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val(parseInt($("#HiddenFieldOrder").val()));
                            if (parseInt($("#HiddenFieldOrder").val()) <= parseInt($("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val())) {
                                //$("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val(parseInt($("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val()) + 1);
                                $("#HiddenFieldOrder").val($("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val());


                            }
                        }
                        // $("#TextBox_DiagnosesIAndII_DiagnosisOrder").val(parseInt(order) + 1);

                        //document.getElementById('TextBox_DiagnosesIAndII_DiagnosisOrder').value = parseInt(order)+1;
                       // ClearDiagnosisIandII();

                    }
                    else if (result == "0") {// For Invalid DSMCode
                        ClearDiagnosisIandII();
                    }
                }
            });
        }
        else {
            ClearDiagnosisIandII();
        }

    }
    catch (err) {
        LogClientSideException(err, 'InsertDiagnosesIAndIIGridData'); //Code added by Devinder 
    }
}


function SetCustomValueOnRadioClick(customGridTableName) {
    try {
        if (customGridTableName.trim() == 'TableChildControl_DiagnosesIIICodes') {
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].style.display = 'block';
            $("#TextBoxICDDescription")[0].style.display = 'none';
        }
        else if (customGridTableName.trim() == 'TableChildControl_DiagnosesIAndII') {
            $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'block';
            $("#TextBoxDSMDescription")[0].style.display = 'none';
            $("#SpanAxis")[0].style.display = 'block';
            $("#SpanAxis")[0].innerHTML = "Axis " + $("#HiddenField_DiagnosesIAndII_Axis").val();
        }
        //$("#HiddenFieldOrder").val() = $("#TextBox_DiagnosesIAndII_DiagnosisOrder").val();
    }
    catch (err) {
        LogClientSideException(err, 'SetCustomValueOnRadioClick'); //Code added by Devinder 
    }
}



function ValidateAxisIAndII() {
    try {
        ShowHideErrorMessage('', 'false');
        var DiagnosisOrderVal = $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val();

        if (isNaN(parseInt(DiagnosisOrderVal)) == true) {
            if ($.trim(DiagnosisOrderVal) != '') {
                $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val('')
                ShowHideErrorMessage('Please enter all required fields.', 'true');
                $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").focus();
                return false;
            }

        }
        if ($.trim($("#TextBox_DiagnosesIAndII_DSMCode").val()) == '') {
            ShowHideErrorMessage('Please enter all required fields.', 'true');
            $("#TextBox_DiagnosesIAndII_DSMCode").focus();
            return false;
        }
        //Added by Rakesh w.rf task 974 in SC web phase II bugs/Features
        if ($("#SpanAxis").html() == "") {
            ShowHideErrorMessage('Please select DSM Code information from pop up.', 'true');
            return false;
        }
        var dropdownDiagnoses = $("select[id$=DropDownList_DiagnosesIAndII_DiagnosisType]");
        if (dropdownDiagnoses.length > 0) {
            if (dropdownDiagnoses[0].selectedIndex == 0) {
                ShowHideErrorMessage('Please enter all required fields.', 'true');
                dropdownDiagnoses[0].focus();
                return false;
            }
        }

        if ($.trim(DiagnosisOrderVal) == '') {
            ShowHideErrorMessage('Please enter all required fields.', 'true');
            $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").focus();
        }

        if ($.trim(DiagnosisOrderVal) != '' && $.trim($("#TextBox_DiagnosesIAndII_DSMCode").val()) != '') {
            return true;
        }
        ShowHideErrorMessage('Please enter all required fields.', 'true');
    }
    catch (err) {
        LogClientSideException(err, 'ValidateAxisIAndII'); //Code added by Devinder 
    }
}

//Author  : Sweety
//Purpose : This function will be used to set the order when a record deleted.
//Date:     8 Feb,2010
var maxRecords = "0";
function AddParentChildDeleteImageEventHandler(customGridTableName, obj) {
    try {
        //var order = parseInt($("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val()) - 1;
        var order = "";
        if ($("#HiddenFieldOrder").length > 0) {   // Added by Jitender on 21 July 2010
            order = parseInt($("#HiddenFieldOrder")[0].value);
        }

        if (maxRecords == "0") {
            $("#HiddenFieldMaximumRecords").val(order);
            maxRecords = parseInt($("#HiddenFieldMaximumRecords").val());

        }
        else {
            if ($("#HiddenFieldOrder").length > 0) {   // Added by Jitender on 21 July 2010
                maxRecords = parseInt($("#HiddenFieldOrder")[0].value);
            }
        }
        maxRecords = (parseInt(maxRecords)) - 1;

        if (parseInt(maxRecords) <= 1) {
            maxRecords = 1;
            $("#HiddenFieldOrder").val(maxRecords);

        }
        else {
            $("#HiddenFieldOrder").val(order);

        }
        $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val($("#HiddenFieldOrder").val());

        $("#TextBoxDSMDescription").val('');
        if ($("#TextBoxDSMDescription").length > 0) {     // Added by Jitender
            $("#TextBoxDSMDescription")[0].style.display = 'block';
        }
        if ($("#Span_DiagnosesIAndII_DSMDescription").length > 0) {   // Added by Jitender
            $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = '';
            $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'none';
        }

    }
    catch (err) {
        LogClientSideException(err, 'AddParentChildDeleteImageEventHandler');
    }
}

function ClearDiagnosisIandII() {
    try {

        $("#TextBox_DiagnosesIAndII_DSMCode").focus();
        $("#Span_DiagnosesIAndII_DSMDescription")[0].innerHTML = '';
        $("#Span_DiagnosesIAndII_DSMDescription")[0].style.display = 'none';
        $("#TextBoxDSMDescription")[0].style.display = 'block';
        $("#TextBoxDSMDescription").val('');
        $("#SpanAxis")[0].style.display = 'none';
        $("#SpanAxis")[0].style.display = 'none';
        $("#SpanAxis").innerHTML = '';
        $("#TextBox_DiagnosesIAndII_DSMCode").val('');
        //$("#TextArea_DiagnosesIAndII_Specifier").val('');       
        $("#TextArea_DiagnosesIAndII_Source").val('');
        $("#CheckBox_DiagnosesIAndII_RuleOut")[0].checked = false;
        $("#RadioButton_DiagnosesIAndII_BillableYes_Y")[0].checked = true;
        $("#RadioButton_DiagnosesIAndII_BillableNo_N")[0].checked = false;
        $("[Id$=DropDownList_DiagnosesIAndII_DiagnosisType]").val('');

        var dropdownDiagnoses = $("select[id$=DropDownList_DiagnosesIAndII_DiagnosisType]");
        if (dropdownDiagnoses.length > 0) {
            dropdownDiagnoses[0].selectedIndex = 0;
        }

        //$("[Id$=DropDownList_DiagnosesIAndII_Severity]").val('');
        $("[Id$=DropDownList_DiagnosesIAndII_Remission]").val('');
        $("#TableChildControl_DiagnosesIAndII_ButtonInsert").val('Insert');
        //$("#ButtonInsert")[0].disabled = true;

        //Set the hieghest order on clear
        var order = $("#HiddenFieldOrder").val();

        //---added on 7 DEc 2010 by Ashwani K. Angrish
        if (order.trim() != "") {
            $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val(order);
        }

        //Calculate Order
        //UnSelect the Radio Button of the Grid on Clear Button
        var GridViewDiagnosis = 'GridViewInsert';
        //        if (document.getElementById(GridViewDiagnosis) != null) {
        //            var gridView = document.getElementById(GridViewDiagnosis);
        //            var gridViewControls = gridView.getElementsByTagName("input");
        //            for (i = 0; i < gridViewControls.length; i++) {
        //                if (gridViewControls[i].type == "radio") {
        //                    gridViewControls[i].checked = false;
        //                }
        //            }
        //            alert("GridRadio");
        //            alert(gridView);
        //        }
        $("[id$=GridViewInsert]").find("input[type=radio]").removeAttr('checked');
        //Clear the Primary key Value
        $("#HiddenField_DiagnosesIAndII_DiagnosisId").val('');
    }
    catch (err) {
        LogClientSideException(err, 'ClearDiagnosisIandII'); //Code added by Devinder 
    }
}
function AddParentChildRadioClickEventHandler(key) {
    //$("select[id$=DropDownList_DiagnosesIAndII_DiagnosisType]").focus();
    //$("select[id$=DropDownList_DiagnosesIAndII_DiagnosisType]").focus();
}
//function SetScreenSpecificValues(dom, action) {
//    try {
//        var Initialvalue = $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val();
//        $("#HiddenFieldOrder").val(Initialvalue);
//    }
//    catch (err) {
//        LogClientSideException(err, 'SetScreenSpecificValues');
//    }
//}

//Added By Anuj on 14 july,2010
var textBoxICDDescription;
function openDiagnosisIIIWindowForDescription(obj, baseUrl) {
    try {
        if (obj.value != '' && obj.value != undefined) {
            textBoxICDDescription = obj;
            var replaceString = obj.value.replace("\'", "~");
            $.ajax({
                type: "POST",
                //url: $(textBoxICDDescription)[0].getAttribute('baseUrl') + "AjaxScript.aspx?functionName=VerifyICDDescription",
                url: baseUrl + "AjaxScript.aspx?functionName=VerifyICDDescription",
                data: 'ICDDesc=' + replaceString,
                success: handleICDDesc
            });
        }
    }
    catch (err) {
        LogClientSideException(err, 'openDiagnosisIIIWindowForDescription'); //Code added by Devinder 
    }
    return false;
}
//Function is used to Set the DiagnosisIandII value when there is exact match of the DSMDescription String
//Author: Mohit Madaan
function handleICDDesc(result) {

    try {
        if (result == '-1') {
            $("#TextBoxICDDescription").val('');
        }
        else if (result == '1') {
            SetDiagnosisIIIICDDescValue()
        }
        else {
            var replaceString = result;
            var diagnosisValue = replaceString.split("$$$");

            diagnosisValue[1] = diagnosisValue[1].replace("^", "\"");
            diagnosisValue[1] = diagnosisValue[1].replace("~", "\'");

            $("#TextBox_DiagnosesIIICodes_ICDCode").val(diagnosisValue[0]);
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].style.display = 'block';
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].innerHTML = diagnosisValue[1];
            $("#TextBoxICDDescription")[0].style.display = 'none';
            $("#TextBoxICDDescription").val('');
        }
    }
    catch (err) {
        LogClientSideException(err, 'handleICDDesc'); //Code added by Devinder 
    }
    return false;
}


//This function is used to open the Popup of for Diagnosis Description Values.
//Author: Anuj Tomar
function SetDiagnosisIIIICDDescValue() {

    try {


        var val = 'DIII';
        var myDate = new Date();
        var time = myDate + myDate.getMinutes() + myDate.getSeconds();
        var descVal = textBoxICDDescription.value

        OpenPage(5765, 118, 'Value=' + val + '^TextVal=' + descVal + '^time=' + time, null, GetRelativePath(), 'T', "dialogHeight: 400px; dialogWidth: 800px;dialogTitle:Diagnosis Code");

        //        returnValue = window.showModalDialog($(textBoxICDDescription)[0].getAttribute('baseUrl') + "ShowDiagnosisAxisPopUp.aspx?Value=" + val + "&TextVal=" + textBoxICDDescription.value + "&time=" + time + "", "null", "center:yes;resizable:no;dialogWidth:800px;dialogHeight:350px;");
        //        if (returnValue != '' && returnValue != undefined) {
        //            var replaceString = returnValue;
        //            var diagnosisValue = returnValue.split("$$$");

        //            diagnosisValue[1] = diagnosisValue[1].replace("^", "\"");
        //            diagnosisValue[1] = diagnosisValue[1].replace("~", "\'");


        //            $("#TextBox_DiagnosesIIICodes_ICDCode").val(diagnosisValue[0]);
        //            $("#Span_DiagnosesIIICodes_ICDDescription")[0].style.display = 'block';
        //            $("#Span_DiagnosesIIICodes_ICDDescription")[0].innerHTML = diagnosisValue[1];
        //            $("#TextBoxICDDescription")[0].style.display = 'none';
        //            $("#TextBoxICDDescription").val('');
        //        }
        //        else {
        //            SetDiagnosesIIIControlToDefault();
        //        }
    }
    catch (err) {
        LogClientSideException(err, 'SetDiagnosisIIIICDDescValue'); //Code added by Devinder 
    }
}
function SetDiagnosesIIIControlToDefault() {
    try {
        ClearDiagnosisIII();
    }
    catch (err) {
        LogClientSideException(err, 'SetDiagnosesIIIControlToDefault'); //Code added by Devinder 
    }
}
function ClearDiagnosisIII() {
    try {

        $("#TextBox_DiagnosesIIICodes_ICDCode").focus();
        $("#Span_DiagnosesIIICodes_ICDDescription")[0].innerHTML = '';
        $("#Span_DiagnosesIIICodes_ICDDescription")[0].style.display = 'none';
        $("#TextBoxICDDescription")[0].style.display = 'block';
        $("#TextBoxICDDescription").val('');
        $("#TextBox_DiagnosesIIICodes_ICDCode").val('');
        $("#CheckBox_DiagnosesIIICodes_Billable")[0].checked = false;
        $("#TableChildControl_DiagnosesIIICodes_ButtonInsert").val('Insert');

        //UnSelect the Radio Button of the Grid on Clear Button
        //        var GridViewDiagnosis = 'GridViewInsert';
        //        if (document.getElementById(GridViewDiagnosis) != null) {
        //            var gridView = document.getElementById(GridViewDiagnosis);
        //            var gridViewControls = gridView.getElementsByTagName("input");
        //            for (i = 0; i < gridViewControls.length; i++) {
        //                if (gridViewControls[i].type == "radio") {
        //                    gridViewControls[i].checked = false;
        //                }
        //            }
        //            alert("DIAIII Clear");
        //        }
        $("[id$=GridViewInsert]").find("input[type=radio]").removeAttr('checked');
        //Clear the Primary key Value
        $("#HiddenField_DiagnosesIIICodes_DiagnosesIIICodeid").val('');
    }
    catch (err) {
        LogClientSideException(err, 'ClearDiagnosisIII'); //Code added by Devinder 
    }
}
function ToggleICDDescriptionLabelAndTextBox(obj) {
    try {

        var value = obj.value;
        if (value == '') {

            $("#TextBoxICDDescription").val('');
            $("#TextBoxICDDescription")[0].style.display = 'block';
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].innerHTML = '';
            $("#Span_DiagnosesIIICodes_ICDDescription")[0].style.display = 'none';
        }
    }
    catch (err) {
        LogClientSideException(err, 'ToggleICDDescriptionLabelAndTextBox'); //Code added by Devinder 
    }
}

function ValidateAxisIII() {
    try {
        ShowHideErrorMessage('', 'false');
        if ($.trim($("#TextBox_DiagnosesIIICodes_ICDCode").val()) != '') {
            return true;
        }
        ShowHideErrorMessage('Please enter all required fields.', 'true');
    }
    catch (err) {
        LogClientSideException(err, 'ValidateAxisIII'); //Code added by Devinder 
    }
}

//This Function is used to Insert- the Data In the AxisIII Grid Control
//Author :Anuj Tomar
//Created Date : September 14,2009
function InsertDiagnosesIIIGridData(obj, tableChildControl, InsertGrid, CustomICDGrid, baseUrl) {
    var ICDCode;
    try {
        ICDCode = $("#TextBox_DiagnosesIIICodes_ICDCode").val();
        if (!ValidateAxisIII()) {
            return false;
        }
        if (ICDCode != '' && ICDCode != undefined) {
            $.ajax({
                type: "POST",
                //url: $(obj)[0].getAttribute('baseUrl') + "AjaxScript.aspx?functionName=ValidateICDCode",
                url: baseUrl + "AjaxScript.aspx?functionName=ValidateICDCode",
                data: 'AxixIIIicdCode=' + ICDCode,
                success: function(result) {
                    var v = result.split(",");
                    if (v[0] == "1") {// For Valid ICDCode
                        InsertGridData(tableChildControl, InsertGrid, CustomICDGrid, obj)
                        if ($("#TableChildControl_DiagnosesIIICodes_ButtonInsert").val() == "Insert") {

                        }
                        else {
                        }
                        ClearDiagnosisIII();

                    }
                    else if (result == "0") { // For Invalid ICDCode
                        ClearDiagnosisIII();
                    }
                }
            });
        }
        else {
            ClearDiagnosisIII();
        }

    }
    catch (err) {
        LogClientSideException(err, 'InsertDiagnosesIIIGridData');
    }
}


// Purpose: Function used to handle the StaffAxisV TextBox Validation
// Created By : Anuj TOmar
//Created Date : July 18,2010
var StaffAxisValue;
function CheckStaffAxisVLegend(obj) {
    try {
        var value = obj.value;
        if (!isNaN(value) == true || value == '') {
            if (obj.value != '') {
                StaffAxisValue = obj.value;
                $("#ButtonStaffAxisVRanges")[0].focus = true;
            }
        }
        else {
            if (StaffAxisValue != '' && StaffAxisValue != undefined) {
                $("#TextBox_CustomHRMAssessments_StaffAxisV").val(AxisValue);
            }
            else {
                $("#TextBox_CustomHRMAssessments_StaffAxisV").val('');
                $("#ButtonStaffAxisVRanges")[0].focus = true;
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'CheckStaffAxisVLegend'); //Code added by Devinder 
    }
}

// Purpose: Function used Change the Text Value of StaffAxisV to Old Integer value if Exists.
// Created By : Anuj TOmar
//Created Date : July 18,2010
function changeStaffAxisVal(obj) {
    try {
        var value = obj.value;
        if (!isNaN(value) || value == '') {
            StaffAxisValue = value
        }
    }
    catch (err) {
        LogClientSideException(err, 'changeStaffAxisVal');
    }
}
// Purpose: Function is used to open the Diagnoses V Modal Diaglog
// Created By : Anuj TOmar
//Created Date : July 18,2010
//Modified By Rakesh 26 JUly 2011
function OpenStaffAxisVLegend(val, obj, baseUrl) {
    try {
        var myDate = new Date();
        var time = myDate + myDate.getMinutes() + myDate.getSeconds();
        if (val == 'StaffAxisV') {
            //Below  code and open page call changes made by Rakesh with ref to task 144 in Phase II bugs/featurs
            OpenPage(5765, 118, 'Value=' + val + '^TextVal=' + obj.value + '^time=' + time, null, GetRelativePath(), 'T', "dialogHeight: 400px; dialogWidth: 800px;dialogTitle:Global Assessment");
            //Below changes made by Rakesh with ref to task 144 in Phase II bugs/featurs
            //        //=========Commented By Ashwani on 17 Jan 2011
            //            returnValue = window.showModalDialog(baseUrl + "ShowDiagnosisAxisPopUp.aspx?Value=" + val + "&TextVal=" + obj.value + "&time=" + time + "", "null", "status:no;edge:center:yes;sunken;resizable:no;dialogWidth:800px;dialogHeight:350px");
            //            parseInt(returnValue)
            //            if (val == 'StaffAxisV') {
            //                if (returnValue != '' && isNaN(parseInt(returnValue)) == false) {
            //                    var TextBoxStaffDiagnosesVAxisV = $("#TextBox_CustomHRMAssessments_StaffAxisV");

            //                    if (parseInt(returnValue) == 0) {
            //                        TextBoxStaffDiagnosesVAxisV.val(0);
            //                        CreateAutoSaveXml('CustomHRMAssessments', 'StaffAxisV', TextBoxStaffDiagnosesVAxisV.val());
            //                    }
            //                    else {
            //                        TextBoxStaffDiagnosesVAxisV.val(parseInt(returnValue) - 5);
            //                        //Need to check for AutoSave in Assessment
            //                        CreateAutoSaveXml('CustomHRMAssessments', 'StaffAxisV', TextBoxStaffDiagnosesVAxisV.val());
            //                    }
            //                }
            //            }
            //            //=========END Commented By Ashwani on 17 Jan 2011

        }
    }
    catch (err) {
        LogClientSideException(err, 'OpenStaffAxisVLegend'); //Code added by Devinder 
    }
}
function ShowHideIcdCodes() {
    try {
        
        var divICDCodes = $('div[id$=divICDCodes]')[0];
        if (divICDCodes.style.display == 'block' || divICDCodes.style.display == '') {
            //if (divICDCodes.style.display == 'block') { Modify by jagdeep as per task #1793-Harbor Go Live Issues
            divICDCodes.style.display = 'none';
        }
        else if (divICDCodes.style.display == 'none') {
            divICDCodes.style.display = 'block';
        }
    }
    catch (err) {
        LogClientSideException(err, 'ShowHideIcdCodes'); //Code added by Devinder 
    }
}
function ShowHideDiagnosesContent(DiagnosisType) {
    //try {
    if (DiagnosisType.trim() == 'DXSA') {
        $('td[id$=TdHRMAssesmentAxisIII]')[0].visible = true;
        $('td[id$=TdHRMAssesmentSAAxisV]')[0].visible = true;
        $('td[id$=TdHRMAssesmentAxisIII]')[0].style.display = 'block';
        $('td[id$=TdHRMAssesmentSAAxisV]')[0].style.display = 'block';
        $('td[id$=TdDiagnosesAxixV]')[0].style.display = 'none';
        $('td[id$=TdDiagnosesAxixV]')[0].visible = false;
        //$("#TextBox_CustomHRMAssessments_StaffAxisV")
        //$("#HiddenField_DiagnosesIAndII_DSMNumber")
        if ($("#HiddenField_DiagnosesV_AxisV")[0].value != null && $("#HiddenField_DiagnosesV_AxisV")[0].value != 'null') {
            $("#TextBox_DiagnosesV_AxisV5")[0].value = $("#HiddenField_DiagnosesV_AxisV")[0].value;
        }


    }
    else if (DiagnosisType.trim() == 'DXDD') {

        $('td[id$=TdHRMAssesmentAxisIII]')[0].visible = true;
        $('td[id$=TdHRMAssesmentSAAxisV]')[0].visible = false;
        $('td[id$=TdHRMAssesmentAxisIII]')[0].style.display = 'block';
        $('td[id$=TdHRMAssesmentSAAxisV]')[0].style.display = 'none';
        $('td[id$=TdDiagnosesAxixV]')[0].style.display = 'block';
        $('td[id$=TdDiagnosesAxixV]')[0].visible = true;

    }
    else if (DiagnosisType.trim() == 'Diagnoses') {
        $('td[id$=TdHRMAssesmentAxisIII]')[0].visible = false;
        $('td[id$=TdHRMAssesmentSAAxisV]')[0].visible = false;
        $('td[id$=TdHRMAssesmentAxisIII]')[0].style.display = 'none';
        $('td[id$=TdHRMAssesmentSAAxisV]')[0].style.display = 'none';
        $('td[id$=TdDiagnosesAxixV]')[0].style.display = 'block';
        $('td[id$=TdDiagnosesAxixV]')[0].visible = true;

    }
    else if (DiagnosisType.trim() == 'Discharge') {
        $('td[id$=TdHRMAssesmentAxisIII]')[0].visible = false;
        $('td[id$=TdHRMAssesmentSAAxisV]')[0].visible = false;
        $('td[id$=TdHRMAssesmentAxisIII]')[0].style.display = 'none';
        $('td[id$=TdHRMAssesmentSAAxisV]')[0].style.display = 'none';
        $('td[id$=TdDiagnosesAxixV]')[0].style.display = 'block';
        $('td[id$=TdDiagnosesAxixV]')[0].visible = true;
    }
    //}
    //catch (err) {
    //    LogClientSideException(err, 'ShowHideDiagnosesContent'); //Code added by Devinder 
    //}
}
//Ended over here

//Author: Shifali
//Created On: 7March,2011
//Created By: Shifali(ref task# 873 under streamline testing)
function SetDiagnosisIAndIIHiddenOrderField(dom) {

    var sortedList = "";
    //Condition added by Sonia with ref to 451
    if ((dom != undefined || dom != null) && dom[0] != null && dom[0] != undefined) {
        //Changed end here
        var unfilteredDiagnosesIAndIINodes = dom[0].childNodes[0].selectNodes("DiagnosesIAndII");
        $.fn.sort = [].sort; //copy the array method
        sortedList = $(unfilteredDiagnosesIAndIINodes).sort(function(a, b) { //using the native sort here
            var first = $(a)[0].selectNodes("DiagnosisOrder")[0].text;
            var second = $(b)[0].selectNodes("DiagnosisOrder")[0].text;
            return (first < second) ? -1 : 1;
        });
        if (sortedList != undefined && sortedList != "" && sortedList.length != 0) {
            var nodeLength = sortedList.length;
            if (sortedList[nodeLength - 1].selectSingleNode("DiagnosisOrder") != null) {
                var diagnosisMaxOrder = sortedList[nodeLength - 1].selectSingleNode("DiagnosisOrder").text;
                $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val(parseInt(diagnosisMaxOrder) + 1);
            }
        }
    }
    var Initialvalue = $("[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]").val();
    $("#HiddenFieldOrder").val(Initialvalue);

    var IsDivICDCodesContainVale = $('div[id$=divICDCodes] img[id*=ContactButonDelete]').length;
    if (IsDivICDCodesContainVale > 0) {
        $('div[id$=divICDCodes]').show();
    }
    else {
        $('div[id$=divICDCodes]').hide();
    }
}

//Created By Davinder Kumar.
//Subtract value of DiagnosisOrder when records are deleted from grid.
function GridRenderCallBackComplete(action, call) {

    if (call == 'GridCallback') {
        if (action == 'DeleteCustomGrid') {
            var txtBoxDiagnosesOrder = $('[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]');
            if (txtBoxDiagnosesOrder.length > 0) {
                var diagnoseOrderValue = txtBoxDiagnosesOrder.val();
                //Below if condition check added by Rakesh with ref to task 168 in SC web phaseII bugs Assessment: Diagnosis Tab - order of Axis I & II
                if (diagnoseOrderValue > 1) {
                    txtBoxDiagnosesOrder.val(parseInt(diagnoseOrderValue) - 1);
                    $("#HiddenFieldOrder").val(txtBoxDiagnosesOrder.val());
                    RetainOrderForDiagnosisIandII(txtBoxDiagnosesOrder[0]);
                }
                //Changes end here 
            }
        }
    }
}

///function Created by Sonia
//To handle Diagnosis I & ii POP up close
function CloseDiagnosisIAndIIPopUp(ModelPopupName) {
    if (ModelPopupName == 'DiagnosisIAndIIPopUp') {
        parent.$("#TextBox_DiagnosesIAndII_DSMCode").focus();
        //set focus to set code textbox.
    }

}
//All controls which is need to manually validation
/*********
Created By: Amit Kumar Srivastava
Date : Feb 20, 2012
Purpose: Kalamazoo Task # 306, Dx: Axis I/II sub tab, saving resets dx order to 1
         (On the diagnosis (either dx tab or dx document) after inserting 1+ diagnoses (2 for instance), clicking save resets the diagnosis order to 1 for the next diagnosis, rather than retaining the subsequent number (3 in this instance), inserting a fourth diagnosis in this scenario would be assigned a dx order of 2, rather than the appropriate order of 4. Each time save is clicked the order number for the next dx is reset to 1.
            to replicate:
            1. Create a dx document
            2. Insert dx with the prepopulated order of 1
            3. Notice order field now says 2 (appropriately)
            3. Insert dx with prepopulated order of 2
            4. Click save, Notice the order field for the next dx has reset to 1, rather than a 3
            5. Insert a third dx but do not change the order number from 1 to 3
            6. Notice order field now says 2 (rather than 4)
            7. Click save
            8. Notice order field for the next dx has reset to 1 again. )
*********/
//rename the method name as per added attribute(ValidateClientSideMethodName) in custom grid control on page
function ValidateParentChildDiagnosis() {
    try {
         
        var isExist = false;
        var DiagnosisOrder = $('[id$=TextBox_DiagnosesIAndII_DiagnosisOrder]').val();
        var HFPKey = $('[id$=HiddenField_DiagnosesIAndII_DiagnosisId]').val();
        var BtnInsert = $('[id$=TableChildControl_DiagnosesIAndII_ButtonInsert]');
        var tables = $('table[id$=TableChildControl_DiagnosesIAndII] table[id$=CustomGrid_GridViewInsert_DXMainTable] tr[id*=CustomGrid_GridViewInsert_DXDataRow] > td');
        var modifiedid = 0;
        var i = 7;
        var j = 0;
        var k = 0;
        var orders = 0;
        if (BtnInsert.val() == "Modify") {
            modifiedid = 1;
        }
        if (tables.length > 0) {
            tables.each(function() {
                if (isExist == false) {
                    var modifiedprimaryid = "";
                    j = j + 1;
                    if (j == i) {
                        modifiedprimaryid = tables[i].innerText;
                        k = i + 8;
                        orders = tables[k].innerText;
                        i = i + 26;
                        k = i;

                        if (parseInt(DiagnosisOrder) == parseInt(orders)) {
                            isExist = true;
                        }
                        if (isExist == true && modifiedid != 0 && modifiedprimaryid != "") {
                            if (parseInt(HFPKey) == parseInt(modifiedprimaryid)) {
                                isExist = false;
                            }
                            else {
                                isExist = true;
                            }
                        }
                    }
                }
            });
        }
        if (isExist == false) {
            ShowHideErrorMessage('', 'false');
            return true;
        }
        else {
            ShowHideErrorMessage('Diagnosis Order already exists.', 'true');
            return false;
        }
    }
    catch (err) {
        LogClientSideException(err, 'ValidateDataForParentChildGridEventHandler');
    }
}