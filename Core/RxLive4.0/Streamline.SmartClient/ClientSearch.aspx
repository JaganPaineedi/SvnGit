<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ClientSearch.aspx.cs" Inherits="ClientSearch" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Includes/JS/jscalendar/calendar-blue.css?rel=3_5_x_4_1" type="text/css"
        rel="stylesheet" />

    <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" type="text/javascript"></script>

    <style>
        .btnimgexsmall
        {
            height:20px !important;

        }
        #btnSSNSearch,#btnDOBSearch {
                  font-family: Tahoma, Arial, Helvetica, sans-serif ! important;
                  font-size: 11px !important;
        }

    </style>

</head>
    <body style="margin-left: 0px; margin-top: 0;">
        <div id="Parda" style="background-color: #ffffff; border: 1px solid #cccc99; display: none; filter: Alpha(Opacity=0); left: 0; position: absolute; top: 0; width: 300px;">
    </div>
        <div id="dvProgress" style="display: none; left: 0; position: absolute; right: inherit; top: 47px; width: 224px"
        class="progress">
        <%--<font size="Medium" color="#1c5b94"><b><i>Communicating with Server...</i></b></font>
        <img src="App_Themes/Includes/Images/Progress.gif" title="Progress" />--%>
             <img src="App_Themes/Includes/Images/ajax-loader.gif" />
    </div>
    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="WebServices/CommonService.asmx" />
                <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
            </Services>
            <Scripts>
                <asp:ScriptReference Path="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/ExceptionManager.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/DatePopUp/ts_picker.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/calendar.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/TextBoxWrapper.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/ClientSearch.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            </Scripts>
        </asp:ScriptManager>

        <script type="text/javascript" language="javascript">

            function ValidateDates(TextBoxDate, lblError, imgError) {
                var _TextBoxDate = document.getElementById(TextBoxDate);
                var _lblError = document.getElementById(lblError);
                var _ImgError = document.getElementById('ImgError');
                var _divdisable = document.getElementById('<%=divimg.ClientID %>');
        //For mm/dd/yyyy
        var RegExPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;

        /*
        if(_TextBoxDate.value=='')
        {
             _TextBoxDate.focus();
             divimg.style.display='block';          
             _lblError.innerText='Date From cannot be left blank';
             fnHideParda('Parda','dvProgress');
             return false;
        }*/

        if (_TextBoxDate.value.match(RegExPattern) == null) {
            divimg.style.display = 'block';
            _lblError.innerText = 'Invalid Date Format (Valid Format is MM/\dd/\yyyy)';
            _TextBoxDate.focus();
            fnHideParda('Parda', 'dvProgress');
            return false;
        }

    }

    function setselectbutton() {
        document.getElementById('<%=btnSelect.ClientID %>').focus();
    }

    function OnchangestextSSNFirst(TextBoxSSNFirst, TextBoxSSNSecond) {

        var _TextBoxSSNFirst = document.getElementById(TextBoxSSNFirst);
        var _TextBoxSSNSecond = document.getElementById(TextBoxSSNSecond);
        if (_TextBoxSSNFirst.value.length == 3) {
            _TextBoxSSNSecond.focus();
        }
    }

    function OnchangestextSSNSecond(TextBoxSSNSecond, txtSSNSearch) {
        var _txtSSNSearch = document.getElementById(txtSSNSearch);
        var _TextBoxSSNSecond = document.getElementById(TextBoxSSNSecond);

        if (_TextBoxSSNSecond.value.length == 2) {
            _txtSSNSearch.focus();
        }

    }

    function CalShow(ImgCalID, TextboxID) {
        Calendar.setup({
            inputField: TextboxID,
            ifFormat: "%m/%d/%Y",
            showsTime: false,
            button: ImgCalID,
            step: 1
        });
    }

    function toupper(obj) {
        try {
            var txt = obj.value;
            if (txt.length == 1) {
                if (txt == ' ') {
                    obj.value = '';
                    obj.length = 0;
                            } else {
                    obj.value = txt.toUpperCase();
                }
            }
            if (window.event.keyCode == 39) {
                if (txt.length > 1) {
                    var txt1 = obj.value;
                    var str1 = txt1.substring(0, 1);
                    str1 = str1.toUpperCase();
                    var str2 = txt1.substring(1, txt.length);
                    str2 = str2.toLowerCase();
                    //obj.value=txt.toUpperCase();
                    obj.value = str1 + str2;
                }
            }
            if (window.event.keyCode == 13) {
                document.getElementById('<%=btnBroadSearch.ClientID %>').focus();
            if (txt.length > 0) {
                __doPostBack('<%=btnBroadSearch.ClientID %>', '');
             }
         }
                    } catch(e) {

     }
 }

 function PostDatacs(Control) {
     try {
         if (window.event.keyCode == 13) {
             document.getElementById(Control).focus();
             if (control.length > 0) {
                 __doPostBack(Control, '');
             }
         }

                    } catch(e) {
     }
 }

 function firstupper(obj) {
     var txt = obj.value;
     var str1 = txt.substring(0, 1);
     str1 = str1.toUpperCase();
     var str2 = txt.substring(1, txt.length);
     //obj.value=txt.toUpperCase();
     obj.value = str1 + str2;
 }

 function ValidateFirstLastName(txtLastName, txtFirstName, lblError, imgError) {
     var _txtLastName = document.getElementById(txtLastName);
     var _txtFirstName = document.getElementById(txtFirstName);
     var _lblError = document.getElementById(lblError);
     var _divdisable = document.getElementById('<%=divimg.ClientID %>');

        //Code Modified by Loveena on 01-June-2009 in ref to Task#2444 1.8 - Client Search: Fails When First Name Or Last Name Contains Char(39).
        //var objNaturalPattern =/^[\w ]+$/;
        var objNaturalPattern = /([A-Za-z0-9\.-]\'?[A-Za-z0-9]){0,}$/;
        //Modified code ends over here.
        if (_txtLastName.value == '' && _txtFirstName.value == '') {
            _txtLastName.focus();
            divimg.style.display = 'block';
            _lblError.innerText = 'Please Enter Search Criteria';
            fnHideParda('Parda', 'dvProgress');
            return false;
        }
        if (_txtLastName.value != '') {

            if (_txtLastName.value.length <= 30 && _txtLastName.value.length > 0) {

                if (_txtLastName.value.match(objNaturalPattern) == null) {
                    _txtLastName.focus();
                    divimg.style.display = 'block';
                    _lblError.innerText = 'Please Enter Valid Last Name';
                    fnHideParda('Parda', 'dvProgress');
                    return false;
                }
                        } else if (_txtLastName.value.length > 30) {
                _txtLastName.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid Last Name';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
        }
        if (_txtFirstName.value != '') {
            if (_txtFirstName.value.length <= 30 && _txtFirstName.value.length > 0) {
                if (_txtFirstName.value.match(objNaturalPattern) == null) {
                    _txtFirstName.focus();
                    divimg.style.display = 'block';
                    _lblError.innerText = 'Please Enter Valid First Name';
                    fnHideParda('Parda', 'dvProgress');
                    return false;
                }
                        } else if (_txtFirstName.value.length > 30) {
                _txtFirstName.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid First Name';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
        }
        divimg.style.display = 'none';
        _lblError.innerText = '';
        document.getElementById('<%=btnSelect.ClientID %>').disabled = true;

        return true;
    }

    function ValidateSSNSearch(TextBoxSSNFirst, TextBoxSSNSecond, txtSSNSearch, lblError) {
        var _txtSSNSearch = document.getElementById(txtSSNSearch);
        var _TextBoxSSNFirst = document.getElementById(TextBoxSSNFirst);
        var _TextBoxSSNSecond = document.getElementById(TextBoxSSNSecond);
        var _lblError = document.getElementById(lblError);
        var _divdisable = document.getElementById('<%=divimg.ClientID %>');
        var objNaturalPattern = /^[0-9]{1,}$/;

        if (_TextBoxSSNFirst.value == '' && _TextBoxSSNSecond.value == '' && _txtSSNSearch.value == '') {
            _txtSSNSearch.focus();
            divimg.style.display = 'block';
            _lblError.innerText = 'Please Enter Search Criteria';
            fnHideParda('Parda', 'dvProgress');
            return false;
        }

        if (_TextBoxSSNFirst.value.length > 0) {
            if (_TextBoxSSNFirst.value.match(objNaturalPattern) == null) {
                _TextBoxSSNFirst.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid SSN Number';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
            if (_TextBoxSSNFirst.value.length != 3) {
                _TextBoxSSNFirst.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid SSN Number';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
        }
        if (_TextBoxSSNSecond.value.length > 0) {
            if (_TextBoxSSNSecond.value.match(objNaturalPattern) == null) {
                _TextBoxSSNSecond.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid SSN Number';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
            if (_TextBoxSSNSecond.value.length != 2) {
                _TextBoxSSNSecond.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid SSN Number';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
        }
        if (_txtSSNSearch.value.length > 0) {
            if (_txtSSNSearch.value.match(objNaturalPattern) == null) {
                _txtSSNSearch.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid SSN Number';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
            if (_txtSSNSearch.value.length != 4) {
                _txtSSNSearch.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid SSN Number';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
        }
        divimg.style.display = 'none';
        _lblError.innerText = '';
        document.getElementById('<%=btnSelect.ClientID %>').disabled = true;
        return true;
    }

    function ValidateNarrowsearh(txtLastName, txtFirstName, lblError) {

        var _txtLastName = document.getElementById(txtLastName);
        var _txtFirstName = document.getElementById(txtFirstName);
        var _lblError = document.getElementById(lblError);
        var _divdisable = document.getElementById('<%=divimg.ClientID %>');
        var objNaturalPattern = /^[\w ]+$/;


        if (_txtLastName.value == '' && _txtFirstName.value == '') {
            _txtLastName.focus();
            divimg.style.display = 'block';
            _lblError.innerText = 'Please Enter Search Criteria';
            fnHideParda('Parda', 'dvProgress');
            return false;
        }
        if (_txtLastName.value != '') {
            if (_txtLastName.value.length > 0) {
                if (_txtLastName.value.match(objNaturalPattern) == null) {
                    _txtLastName.focus();
                    divimg.style.display = 'block';
                    _lblError.innerText = 'Please Enter Valid Last Name';
                    return false;

                }
            }
        }
        if (_txtFirstName.value != '') {
            if (_txtFirstName.value.length > 0) {
                if (_txtFirstName.value.match(objNaturalPattern) == null) {
                    _txtFirstName.focus();
                    divimg.style.display = 'block';
                    _lblError.innerText = 'Please Enter Valid First Name';
                    fnHideParda('Parda', 'dvProgress');
                    return false;
                }
            }
        }
        divimg.style.display = 'none';
        _lblError.innerText = '';
        document.getElementById('<%=btnSelect.ClientID %>').disabled = true;
       return true;
   }

   function ValidatePhoneSearch(txtPhoneSearch, lblError) {

       var _txtPhoneSearch = document.getElementById(txtPhoneSearch);
       var _lblError = document.getElementById(lblError);
       var _divdisable = document.getElementById('<%=divimg.ClientID %>');
        var objNaturalPattern = /^[0-9\-]+$/;
        if (_txtPhoneSearch.value.length == 0) {
            _txtPhoneSearch.focus();
            divimg.style.display = 'block';
            _lblError.innerText = 'Please Enter Phone Number to Search.';
            fnHideParda('Parda', 'dvProgress');
            return false;
                    } else {
            if (_txtPhoneSearch.value.match(objNaturalPattern) == null) {
                _txtPhoneSearch.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid Phone Number to Search.';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
        }
        divimg.style.display = 'none';
        _lblError.innerText = '';
        document.getElementById('<%=btnSelect.ClientID %>').disabled = true;
        return true;
    }

    function ValidateDOBSearch(txtDOBSearch, lblError) {
        var _txtDOBSearch = document.getElementById(txtDOBSearch);
        var _lblError = document.getElementById(lblError);
        var _divdisable = document.getElementById('<%=divimg.ClientID %>');
        var objNaturalPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
        //var objNaturalPattern = /^[0-9\/]+$/;
        if (_txtDOBSearch.value.length == 0) {
            _txtDOBSearch.focus();
            divimg.style.display = 'block';
            _lblError.innerText = 'Please Enter DOB to Search.';
            fnHideParda('Parda', 'dvProgress');
            return false;
                    } else {
            if (_txtDOBSearch.value.match(objNaturalPattern) == null) {
                _txtDOBSearch.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid DOB to Search.';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
        }
        divimg.style.display = 'none';
        _lblError.innerText = '';
        document.getElementById('<%=btnSelect.ClientID %>').disabled = true;
        return true;
    }

    function validateProviderSearch(ddlPrimaryProviderSearch, lblError) {
        var _ddlPrimaryProviderSearch = document.getElementById(ddlPrimaryProviderSearch);
        var _lblError = document.getElementById(lblError);
        var _divdisable = document.getElementById('<%=divimg.ClientID %>');
       if (_ddlPrimaryProviderSearch.options.length == 0) {
           divimg.style.display = 'block';
           _lblError.innerText = 'Please Enter Search Criteria';
           fnHideParda('Parda', 'dvProgress');
           return false;
       }
       divimg.style.display = 'none';
       _lblError.innerText = '';
       document.getElementById('<%=btnSelect.ClientID %>').disabled = true;
       return true;
   }

   function ValidateClientId(txtClientId, lblError) {
       var _txtClientId = document.getElementById(txtClientId);
       var _lblError = document.getElementById(lblError);
       var _divdisable = document.getElementById('<%=divimg.ClientID %>');
       var objNaturalPattern = /^[0-9]+$/;
       if (_txtClientId.value.length == 0) {
           _txtClientId.focus();
           divimg.style.display = 'block';
           _lblError.innerText = 'Please Enter Search Criteria';
           fnHideParda('Parda', 'dvProgress');
           return false;
       }
       if (_txtClientId.value != '') {
           if (_txtClientId.value.match(objNaturalPattern) == null) {
               _txtClientId.focus();
               divimg.style.display = 'block';
               _lblError.innerText = 'Please Enter Valid Patient ID';
               fnHideParda('Parda', 'dvProgress');
               return false;
           }
       }
       divimg.style.display = 'none';
       _lblError.innerText = '';
       document.getElementById('<%=btnSelect.ClientID %>').disabled = true;
       return true;

   }

   /////lock control
   var ret;
   var mywin;

   function fnHideParda(objParda, objdvProgress) {
       var objParda = document.getElementById(objParda);//alert(objParda.id);
       var objdvProgress = document.getElementById(objdvProgress);
       objParda.style.display = 'none';
       objdvProgress.style.display = 'none';
       // fnShowCombo();
   }

   function fnShowParda(progMsgLeft, progMsgTop) {
       //fnHideCombo();
       var objParda = document.getElementById("Parda");
       var objdvProgress = document.getElementById("dvProgress");
       objParda.style.width = document.body.offsetWidth - 2;
       objParda.style.height = document.body.offsetHeight - 20;
       objParda.style.display = '';
       objdvProgress.style.left = progMsgLeft;//parseInt(document.body.offsetWidth)-parseInt(objdvProgress.style.width);
       objdvProgress.style.top = progMsgTop;
       objdvProgress.style.display = '';

   }

   var objComboIds = new Array();

   function fnGetComboCollection() {
       var i;
       objComboIds = document.documentElement.getElementsByTagName("select");
   }

   function fnShowCombo() {
       //alert(objComboIds.length);
       for (i = 0; i < objComboIds.length; i++) {
           var obj = new Object();
           obj = objComboIds[i];
           obj.style.display = '';
       }
   }

   function fnHideCombo() {
       for (i = 0; i < objComboIds.length; i++) {
           var obj = new Object();
                        obj = objComboIds[i];
           obj.style.display = 'none';
       }
   }

   function onsetfocus() {
       document.getElementById('<%=txtLastName.ClientID %>').focus();
    }

    function TABLE1_onclick() {

    }

    function CloseWindow(LastName, firstname, ssnfirst, ssnsecond, ssntheard, phone, dob, Grid) {


        var valueString = "LastName," + document.getElementById(LastName).value +
        ",FirstName," + document.getElementById(firstname).value +
        ",ssnFirst," + document.getElementById(ssnfirst).value
        + document.getElementById(ssnsecond).value
        + document.getElementById(ssntheard).value + "" +
        ",Phone," + document.getElementById(phone).value +
        ",Dod," + document.getElementById(dob).value + "";
        alert(valueString);
        // if(document.getElementById('<%=btnSelect.ClientID %>').disabled==true)
        //{
        window.returnValue = valueString;
        // }
        //alert(document.getElementById(firstname.id).value+"second"+document.getElementById(ssnsecond.id).value+"th"+document.getElementById(ssntheard.id).value);
        //alert(document.getElementById(Grid.id).rows.length);
        window.close();

    }

    //    function MakeQueryString(int ClientId, int NextStepId)
    //    {
    //        var str = "";
    //        //SPMAUserBusinessServices.SPMACommonFunctions.CommonFunctions CommonFunctionsObject = null;
    //        try
    //        {
    //            //CommonFunctionsObject = new SPMAUserBusinessServices.SPMACommonFunctions.CommonFunctions();

    //            //DataWizardId
    //            str = "DWId=2";

    //            str += "&" + "DWInstanceId=0";

    //            //PreviousDataWizardInstanceId
    //            str += "&" + "PDWInstanceId=0";

    //            //ClientId
    //            str += "&" + "CId=" + ClientId;

    //            //ClientSearchGUID
    //            str += "&" + "CSGUID=0";

    //            //NextStepId
    //            str += "&" + "NSId=" + NextStepId;

    //            //UserCode
    //            str += "&" + "UC=" + CommonFunctions.StaffCode.Trim();

    //            //Password
    //            str += "&" + "Pwd=" + CommonFunctionsObject.GetStaffPassword(CommonFunctions.StaffID);
    //            return str;
    //        }
    //        catch (err)
    //        {
    ////        Streamline.BaseLayer.CustomException.ThrowException(ex, "Error in Building Query String for Access Center.");
    ////        return "";
    //        }
    ////        finally
    ////        {
    ////        CommonFunctionsObject = null;
    ////        }

    //    }


    //Date : 16/11/2007
    //Author : Abhay 
    //Purpose : To open Help Page
    //Functions: fnShowHelp & swapImage

    function fnShowHelp() {

        window.open('../HelpFile/ClientSearchHelp.htm', 'this');

    }

    function swapImage(Control, ImgName) {
        ImgPath = "../App_Themes/Includes/Images/" + ImgName;
        document.getElementById(Control).src = ImgPath;
    }

    function closeDiv() {
        try {
            parent.$("#DivSearch").css('display', 'none');
            fnHideParda();
                    } catch(e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    }

    function closeDivSelectClient() {
        try {
            var DivSearch = parent.document.getElementById('DivSearch');
            DivSearch.style.display = 'none';
            parent.window.RefreshManagementPage();
                    } catch(e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    }

    //Code added by Loveena in ref to Task#85

    function SelectClient(ClientId, SureScriptsRefillRequestId) {
        try {
            //        var DivSearch=parent.document.getElementById('DivSearch');
            //        DivSearch.style.display='none';
            //        if(ClientId!="undefined")
            //        { 
            //        //modified by anuj on 9feb,2010 to open the current medication pop up onclick of search button on patient search window       
            //       //parent.window.redirectToStartPage();
            //       redirectToCurrentMedications(ClientId,SureScriptsRefillRequestId);
            //       }
            $("input[id$=HiddenClientId]").val(ClientId);
            $("input[id$=HiddenSureScriptRefillRequestId]").val(SureScriptsRefillRequestId);
            SortInboundRecord('', '');
            var DivSearch = parent.document.getElementById('DivSearch');
            DivSearch.style.display = 'none';
            if (ClientId != "undefined") {
                //redirectToCurrentMedications(ClientId,SureScriptsRefillRequestId);
            }

                    } catch(e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    }

    ///  Added by Mohit Madaan , 14 April 2009
    // To validate the Client Id to search

    function ValidateClientIDSearch(txtClientId, lblError, ExternalInterface) {

        var _txtClientId = document.getElementById(txtClientId);
        var _lblError = document.getElementById(lblError);
        var _divdisable = document.getElementById('<%=divimg.ClientID %>');
        if (ExternalInterface != 'TRUE')
            var objNaturalPattern = /^[0-9]+$/;
        else
            var objNaturalPattern = /^[\w ]+$/;
        if (_txtClientId.value.length == 0) {
            _txtClientId.focus();
            divimg.style.display = 'block';
            _lblError.innerText = 'Please Enter Patient Id to Search.';
            fnHideParda('Parda', 'dvProgress');
            return false;
                    } else {
            if (_txtClientId.value.match(objNaturalPattern) == null) {
                _txtClientId.focus();
                divimg.style.display = 'block';
                _lblError.innerText = 'Please Enter Valid Patient Id to Search.';
                fnHideParda('Parda', 'dvProgress');
                return false;
            }
        }
        divimg.style.display = 'none';
        _lblError.innerText = '';
        document.getElementById('<%=btnSelect.ClientID %>').disabled = true;
        return true;
    }

        </script>
        
        <div>
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="600px">
                <!--       <tr>
                            <td class="sep_tab" style="height: 5px">
                            </td>
                        </tr>-->
                <tr>
                    <td valign="top" style="width: 630px">
                            <table cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef thin solid; border-left: #dee7ef thin solid; border-right: #dee7ef thin solid; border-top: #dee7ef thin solid; height: 1px; width: 627px;">
                            <tr>
                                <td valign="top" style="height: 42px; width: 253px;">
                                    <!--Client Search-->
                                    <table cellpadding="0" cellspacing="0" border="0" style="width: 619px;">
                                        <tr>
                                            <td style="background-color: #5b0000; height: 1pt;">
                                                <asp:PlaceHolder ID="PlaceHolderScript" runat="server"></asp:PlaceHolder>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                <tr>
                                                                    <td style="height: 20px" valign="middle">
                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                            <tr>
                                                                                <td style="width: 5%" valign="middle">
                                                                                    <div id="divimg" runat="server">
                                                                                        <asp:Image ID="imgError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif" />
                                                                                    </div>
                                                                                </td>
                                                                                <td style="width: 1%" valign="middle"></td>
                                                                                <td style="width: 91%" valign="middle">
                                                                                    <asp:Label ID="lblError" runat="server" Visible="true" ForeColor="Black" Font-Names="Microsoft Sans Serif"
                                                                                        Font-Size="11px" Font-Bold="true" style="text-decoration:none;"></asp:Label>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="height: 39px">
                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                            <tr>
                                                                                <td valign="top" style="height: 20px; width: 83px;" align="left">
                                                                                    <asp:Button ID="btnClear" runat="server" Width="82px" CssClass="btnimgexsmall" EnableViewState="False"
                                                                                        Text="Clear" Font-Names="Microsoft Sans Serif" Font-Size="8.25pt" OnClick="btnClear_Click"
                                                                                        OnClientClick="fnShowParda(350,55);"></asp:Button>
                                                                                </td>
                                                                                <td valign="top" style="height: 20px; width: 7%;"></td>
                                                                                <td valign="top" style="height: 20px"></td>
                                                                                <td valign="top" style="height: 20px; padding-left: 22px; width: 120px;"></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <UI:Heading ID="Heading1" runat="server" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                           <!-- Branch -->
                                                                        <table width="600px" style="border: 3px solid rgb(222, 231, 239);" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td>&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                   <%-- <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td align="left" style="height: 24px; width: 3px;">
                                                                                                <%--&nbsp;&nbsp;&nbsp;&nbsp;--%>
                                                                                            <%--</td>
                                                                                            <td align="left" valign="top" style="height: 24px">
                                                                                                <asp:Button ID="btnBroadSearch" runat="server" Width="96px" CssClass="btnimgexsmall"
                                                                                                    EnableViewState="False" Text="Broad Search" OnClick="btnBroadSearch_Click" OnClientClick="fnShowParda(350,55);"
                                                                                                    TabIndex="3" SkinId="BtnSmall"></asp:Button>
                                                                                            </td>
                                                                                            <td align="left" valign="top" style="height: 24px">
                                                                                                <asp:Button ID="btnNarrowSearch" runat="server" Width="96px" CssClass="btnimgexsmall"
                                                                                                    EnableViewState="False" Text="Narrow Search" OnClick="btnNarrowSearch_Click"
                                                                                                    OnClientClick="fnShowParda(350,55);" TabIndex="3" SkinId="BtnSmall"></asp:Button>
                                                                                            </td>
                                                                                            <td valign="top" style="height: 24px">&nbsp;
                                                                                            </td>
                                                                                            <td style="height: 24px; width: 3px;"></td>
                                                                                            <td style="height: 24px; width: 7px;">&nbsp;
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>--%>

                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td align="left" style="height: 24px; width: 3px;">
                                                                                                <%--&nbsp;&nbsp;&nbsp;&nbsp;--%>
                                                                                            </td>
                                                                                            <td align="left" valign="top" style="height: 24px">
                                                                                                <asp:Button ID="btnBroadSearch" runat="server" Width="96px" CssClass="btnimgsmall"
                                                                                                    EnableViewState="False" Text=" Broad Search " OnClick="btnBroadSearch_Click" OnClientClick="fnShowParda(350,55);"
                                                                                                    TabIndex="3" SkinId="BtnSmall"></asp:Button>
                                                                                            </td>
                                                                                            <td align="left" valign="top" style="height: 24px">
                                                                                                <asp:Button ID="btnNarrowSearch" runat="server" Width="96px" CssClass="btnimgsmall"
                                                                                                    EnableViewState="False" Text="Narrow Search" OnClick="btnNarrowSearch_Click"
                                                                                                    OnClientClick="fnShowParda(350,55);" TabIndex="3" SkinId="BtnSmall"></asp:Button>
                                                                                            </td>
                                                                                            <td valign="top" style="height: 24px">&nbsp;
                                                                                            </td>
                                                                                            <td style="height: 24px; width: 3px;"></td>
                                                                                            <td style="height: 24px; width: 7px;">&nbsp;
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>


                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td align="left" style="height: 24px; width: 3px;">
                                                                                                <%--&nbsp;&nbsp;&nbsp;&nbsp;--%>
                                                                                            </td>
                                                                                            <td align="left" valign="middle">
                                                                                                <asp:Label ID="labelText" runat="server" Font-Names="Tahoma, Arial, Helvetica, sans-serif"
                                                                                                    Font-Size="11px" ForeColor="#14426B" Height="11px" Width="65px">Last Name</asp:Label>
                                                                                            </td>
                                                                                            <td></td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtLastName" runat="server" CssClass="TextBox" onkeydown="toupper(this)"
                                                                                                    onkeyup="toupper(this)" onfocusout="firstupper(this)" MaxLength="50" TabIndex="1"
                                                                                                    Width="170px"></asp:TextBox>
                                                                                            </td>
                                                                                            <td></td>
                                                                                            <td valign="middle">
                                                                                                <asp:Label ID="lblFirstName" runat="server" 
                                                                                                    Font-Names="Tahoma, Arial, Helvetica, sans-serif" Font-Size="11px" ForeColor="#14426B" Height="11px" Width="65px">First Name</asp:Label>
                                                                                            </td>
                                                                                            <td style="width: 3px"></td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="TextBox" onkeydown="toupper(this)"
                                                                                                    onkeyup="toupper(this)" onfocusout="firstupper(this)" MaxLength="30" TabIndex="2"
                                                                                                    Width="170px"></asp:TextBox>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <table border="0" cellpadding="0" cellspacing="0" style="height: 5px">
                                                                            <tr>
                                                                                <td></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <UI:Heading ID="Heading2" runat="server" />
                                                                    </td>
                                                                </tr>
                                                                <tr style="width: 600px">
                                                                    <td>

                                                                        <table style="border: 3px solid rgb(222, 231, 239);" width="600px" border="0" cellpadding="0"
                                                                            cellspacing="0" id="TABLE1" language="javascript" onclick="return TABLE1_onclick()">
                                                                            <tr>
                                                                                <td colspan="7">&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr>                                                                            
                                                                                <td style="height: 24px; padding-left:10px;">
                                                                                    <asp:Button ID="btnSSNSearch" runat="server" CssClass="btnimgexsmall" EnableViewState="False"
                                                                                        Text="SSN Search" OnClick="btnSSNSearch_Click" OnClientClick="fnShowParda(350,55);"
                                                                                        TabIndex="8"></asp:Button>
                                                                                </td>                                                                             
                                                                                <td style="height: 24px; width: 157px;">
                                                                                    <asp:TextBox ID="TextBoxSSNFirst" runat="server" Height="16px" Width="32px" CssClass="TextBox"
                                                                                        MaxLength="3" TabIndex="5"></asp:TextBox>-<asp:TextBox ID="TextBoxSSNSecond" runat="server"
                                                                                            Height="16px" Width="32px" CssClass="TextBox" MaxLength="2" TabIndex="6"></asp:TextBox>-<asp:TextBox
                                                                                                ID="txtSSNSearch" runat="server" Height="16px" Width="56px" CssClass="TextBox"
                                                                                                MaxLength="4" TabIndex="7"></asp:TextBox>
                                                                                </td>
                                                                                <td style="height: 24px"></td>
                                                                                <td style="height: 24px; text-align:right;">
                                                                                    <asp:Button ID="btnPhoneSearch" runat="server" CssClass="btnimgmedium"
                                                                                        EnableViewState="False" Text="Phone # Search" OnClick="btnPhoneSearch_Click"
                                                                                        OnClientClick="fnShowParda(350,55);" TabIndex="10" SkinId="BtnMedium"></asp:Button>
                                                                                </td>
                                                                                <td style="height: 24px; width: 1%;"></td>
                                                                                <td style="height: 24px">
                                                                                    <asp:TextBox ID="txtPhoneSearch" runat="server" CssClass="TextBox" MaxLength="50"
                                                                                        TabIndex="9"></asp:TextBox>
                                                                                </td>
                                                                                <td style="height: 24px; width: 1%;"></td>
                                                                            </tr>
                                                                            <tr>                                                                             
                                                                                <td style="height: 5px"></td>                                                                          
                                                                                <td style="height: 5px; width: 157px;"></td>
                                                                                <td style="height: 5px"></td>
                                                                                <td style="height: 5px"></td>
                                                                                <td style="height: 5px; width: 1%;"></td>
                                                                                <td style="height: 5px"></td>
                                                                                <td style="height: 5px; width: 1%;"></td>
                                                                            </tr>
                                                                            <tr>                                                                          
                                                                                <td style="height: 21px; padding-left:10px; width:14%;">
                                                                                    <asp:Button ID="btnDOBSearch" runat="server" CssClass="btnimgexsmall" EnableViewState="False"
                                                                                        Text="DOB Search" OnClick="btnDOBSearch_Click" OnClientClick="fnShowParda(350,55);"
                                                                                        TabIndex="12"></asp:Button>
                                                                                </td>                                                                           
                                                                                <td style="height: 21px; width: 157px;">
                                                                                    <asp:TextBox ID="txtDOBSearch" runat="server" CssClass="TextBox" Width="116px" MaxLength="11"
                                                                                        TabIndex="11"></asp:TextBox>
                                                                                    <img src="App_Themes/Includes/Images/calender_grey.gif" onmouseover="CalShow( this, '<%=txtDOBSearch.ClientID %>')"
                                                                                        alt="" id="imgEnteredTo" class="imgcal" />
                                                                                </td>
                                                                                <td style="height: 21px"></td>
                                                                                <td style="height: 21px; text-align:right;">
                                                                                    
                                                                                    <asp:Button ID="btnClientIdSearch" runat="server" CssClass="btnimgmedium"
                                                                                        EnableViewState="False" Text="Patient ID Search" OnClick="btnClientIdSearch_Click"
                                                                                        Visible="true" OnClientClick="fnShowParda(350,55);" TabIndex="16" SkinID="BtnMedium"></asp:Button>
                                                                                </td>
                                                                                <td style="height: 21px; width: 1%;"></td>
                                                                                <td style="height: 21px">
                                                                                    <asp:TextBox ID="txtClientId" runat="server" onkeydown="toupper(this)" onkeyup="toupper(this)"
                                                                                        onfocusout="firstupper(this)" CssClass="TextBox" Visible="true" TabIndex="15"></asp:TextBox>
                                                                                </td>
                                                                                <td style="height: 21px; width: 1%;"></td>
                                                                            </tr>
                                                                            <tr>                                                                              
                                                                                <td style="height: 5px"></td>                                                                              
                                                                                <td style="height: 5px; width: 157px;"></td>
                                                                                <td style="height: 5px"></td>
                                                                                <td style="height: 5px"></td>
                                                                                <td style="height: 5px; width: 1%;"></td>
                                                                                <td style="height: 5px"></td>
                                                                                <td style="height: 5px; width: 1%;"></td>
                                                                            </tr>
                                                                            <tr>                                                                          
                                                                                <td style="height: 10px"></td>                                                                            
                                                                                <td style="height: 10px; width: 157px;"></td>
                                                                                <td style="height: 10px"></td>
                                                                                <td style="height: 10px"></td>
                                                                                <td style="height: 10px; width: 1%;"></td>
                                                                                <td style="height: 10px"></td>
                                                                                <td style="height: 10px; width: 1%;"></td>
                                                                            </tr>
                                                                            <tr style="background-color: White; height: 5px">
                                                                                <td colspan="7" style="height: 5px"></td>
                                                                            </tr>
                                                                        </table>





                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <UI:Heading ID="Heading3" runat="server" />
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <table style="border: 3px solid rgb(222, 231, 239); height: 100px;" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <div style="border-collapse: separate; border-width: 1px; height: 150px; overflow-x: hidden; overflow-y: auto; text-align: left; width: 585px;">
                                                                                        <asp:GridView ID="dgStaff" runat="server" GridLines="None" Width="575px" AutoGenerateColumns="False"
                                                                                            PageSize="10" RowStyle-Height="19px" CellPadding="0" CellSpacing="0" BorderWidth="0"
                                                                                            AllowSorting="true" OnSorting="dgStaff_Sorting" AllowPaging="true" OnPageIndexChanging="dgStaff_PageIndexChanging"
                                                                                            OnRowDataBound="dgStaff_RowDataBound" OnDataBound="dgStaff_DataBound">
                                                                                            <AlternatingRowStyle CssClass="GridViewAlternatingRowStyle" />
                                                                                            <RowStyle CssClass="GridViewRowStyle" />
                                                                                            <HeaderStyle CssClass="GridViewHeaderText" />
                                                                                            <PagerStyle CssClass="GridViewPagerText" />
                                                                                            <Columns>
                                                                                                <asp:TemplateField>
                                                                                                    <ItemTemplate>
                                                                                                        <%
                                                                                                            if (i == 0)
                                                                                                            {
                                                                                                                i++;
                                                                                                        %>
                                                                                                        <input name="RadioButtonselectclientid" onclick="setselectbutton()" type="radio"
                                                                                                            checked value='<%# Eval("ClientID") %>:<%# formatLastName(Eval("LastName")) %>, <%# formatFirstName(Eval("FirstName")) %>:<%# Eval("ProviderId") %>:<%# Eval("ProviderName") %>::<%# Eval("DOB") %>' />
                                                                                                        <%
                                                                                                        }
                                                                                                        %>
                                                                                                        <%
                                                                                                            else
                                                                                                        {
                                                                                                        %>
                                                                                                        <input name="RadioButtonselectclientid" onclick="setselectbutton()" type="radio"
                                                                                                            value='<%# Eval("ClientID") %>:<%# formatLastName(Eval("LastName")) %>, <%# formatFirstName(Eval("FirstName")) %>:<%# Eval("ProviderId") %>:<%# Eval("ProviderName") %>::<%# Eval("DOB") %>' />
                                                                                                        <% } %>
                                                                                                        <%-- <asp:RadioButton ID="rbbtnselc"  runat="server" Text=" " GroupName="GridRadio" />--%>
                                                                                                    </ItemTemplate>
                                                                                                    <ItemStyle Width="1%" />
                                                                                                    <HeaderStyle ForeColor="#DCE5EA" />
                                                                                                </asp:TemplateField>
                                                                                                <asp:BoundField DataField="ClientID" HeaderText="ID" SortExpression="ClientID">
                                                                                                    <ItemStyle HorizontalAlign="Left" Width="4%" VerticalAlign="Middle" Wrap="False" />
                                                                                                    <HeaderStyle HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="FirstName" HeaderText="First Name" SortExpression="FirstName">
                                                                                                    <ItemStyle HorizontalAlign="Left" Width="6%" VerticalAlign="Middle" Wrap="False" />
                                                                                                    <HeaderStyle HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="LastName" HeaderText="Last Name" SortExpression="LastName">
                                                                                                    <ItemStyle HorizontalAlign="Left" Width="6%" VerticalAlign="Middle" Wrap="False" />
                                                                                                    <HeaderStyle HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="SSN" HeaderText="SSN" SortExpression="SSN">
                                                                                                    <ItemStyle HorizontalAlign="Left" Width="3%" VerticalAlign="Middle" Wrap="False" />
                                                                                                    <HeaderStyle HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="DOB" HeaderText="DOB" SortExpression="DOB" DataFormatString="{0:MM/dd/yyyy}" HtmlEncode="false">
                                                                                                    <ItemStyle HorizontalAlign="Left" Width="5%" VerticalAlign="Middle" Wrap="False" />
                                                                                                    <HeaderStyle HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status">
                                                                                                    <ItemStyle HorizontalAlign="Left" Width="4%" VerticalAlign="Middle" Wrap="False" />
                                                                                                    <HeaderStyle HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                                <asp:BoundField DataField="City" HeaderText="City" SortExpression="City">
                                                                                                    <ItemStyle HorizontalAlign="Left" Width="5%" VerticalAlign="Middle" Wrap="False" />
                                                                                                    <HeaderStyle HorizontalAlign="Left" />
                                                                                                </asp:BoundField>
                                                                                            </Columns>
                                                                                            <EmptyDataTemplate>
                                                                                                <table cellspacing="0" border="0" id="dgStaff" style="border-collapse: collapse; width: 100%;">
                                                                                                    <tr class="GridViewHeaderText">
                                                                                                        <th scope="col" style="color: #DCE5EA;">&nbsp;
                                                                                                        </th>
                                                                                                        <th align="left" scope="col">ID
                                                                                                        </th>
                                                                                                        <th align="left" scope="col">First Name
                                                                                                        </th>
                                                                                                        <th align="left" scope="col">Last Name
                                                                                                        </th>
                                                                                                        <th align="left" scope="col">SSN
                                                                                                        </th>
                                                                                                        <th align="left" scope="col">Provider
                                                                                                        </th>
                                                                                                        <th align="left" scope="col">DOB
                                                                                                        </th>
                                                                                                        <th align="left" scope="col">Status
                                                                                                        </th>
                                                                                                        <th align="left" scope="col">City
                                                                                                        </th>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </EmptyDataTemplate>
                                                                                            <PagerSettings Mode="NumericFirstLast" />
                                                                                        </asp:GridView>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="right">
                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                            <tr>
                                                                                <td valign="top">
                                                                                       <asp:Button ID="btnSelect" runat="server" Width="82px" CssClass="btnimgexsmall" 
                                                                                        OnClientClick="fnShowParda(350,55);" Text="Select" OnClick="btnSelect_Click"></asp:Button><asp:Button ID="btnCancel" runat="server"
                                                                                            CssClass="btnimgexsmall" EnableViewState="False" Text="Cancel" 
                                                                                             Visible="False" OnClientClick="closeDiv();"></asp:Button>  <%--EnableViewState="False"--%>


                                                          
                                                                                </td>
                                                                                <td valign="top" style="width: 2%;"></td>
                                                                                <td valign="top" style="width: 75px;">
                                                                                    <input id="btn1" type="button" value="Cancel" onclick="closeDiv();" class="btnimgexsmall" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>



                                                                    </td>
                                                                </tr>   
                                                                                                                            
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- End of Client Searh-->
                                </td>
                                </tr>
                        </table>
                        <asp:HiddenField ID="HiddenFieldSelectedClientinParent" runat="server" />
                        <input type="hidden" id="HiddenClientId" />
                        <input type="hidden" id="HiddenSureScriptRefillRequestId" />
                        <input type="hidden" id="HiddenFieldChangedclientId" value="false" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
   
        
        
        
         </form>

    <script type="text/jscript">
        parent.fnHideParentDiv();
    </script>

</body>
</html>