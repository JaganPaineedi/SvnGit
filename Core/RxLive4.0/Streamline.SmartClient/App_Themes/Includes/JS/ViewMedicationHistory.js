//Added by Sonia
var MedicationObject;
var PanelMedicationViewList;

function SetVariableName(objectPanel) {
    PanelMedicationViewList = objectPanel;

}

function ClientMedicationDiscontinue(TextBoxDiscontinueObject) {
    try {

        fnShow(); //By Vikas Vyas On Dated April 04th 2008

        var strDiscontinueReason = "";
        strDiscontinueReason = TextBoxDiscontinueObject.value;
        Streamline.SmartClient.WebServices.ClientMedications.DiscontinueMedication(MedicationObject.MedicationId, strDiscontinueReason, 'Y', ViewMedicationHistory.onSuccessfullDeletion, ViewMedicationHistory.onFailure, MedicationObject);

    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function CloseDiscontinueDiv(divDiscontinue) {
    divDiscontinue.style.display = 'none';

}

function ButtonPrintListViewHistory(stringReportName) {
    try {
        //fnShow(); //By Vikas Vyas On Dated April 04th 2008
        //    var StartDate=document.getElementById("TextBoxStartDate").value;
        //    var EndDate=document.getElementById("TextBoxEndDate").value;
        //    //Code added by Loveena in ref to Task# 2424 on 06-March-2009 to pass paramemeters to Report Url.
        //    var DateType=document.getElementById("DropDownListDateFilter").value
        //    var MedicationNameId=document.getElementById("DropDownMedication").value;
        //    var Prescriber=document.getElementById("DropDownListPrescriber").value
        //    //Code added by Loveena ends over here.
        //Code modified as ref to Task#2498 - View Medication History - should not be a pop-up.
        var StartDate = $("[id$=TextBoxStartDate]").val();
        var EndDate = $("[id$=TextBoxEndDate]").val();
        //Code added by Loveena in ref to Task# 2424 on 06-March-2009 to pass paramemeters to Report Url.
        var DateType = $("[id$=DropDownListDateFilter]").val();
        var MedicationNameId = $("[id$=DropDownMedication]").val();
        var Prescriber = $("[id$=DropDownListPrescriber]").val();
        //Code added by Loveena ends over here.
      var ExpandCollapseAll = $('[id$="HiddenPrintEC"]').val();
        //Following Code added as per Task 2234
        if (EndDate == "" || EndDate == undefined)
            EndDate = "01/01/9999";
        //Code Added by Loveena in ref to task#2424 on 06-March-2009 to pass paramemetrs to Report Url.
        if (DateType == "0" || DateType == undefined)
            DateType = "";
        if (MedicationNameId == "0" || MedicationNameId == undefined)
            MedicationNameId = "";
        if (Prescriber == "0" || Prescriber == undefined)
            Prescriber = "";
        //Streamline.SmartClient.WebServices.ClientMedications.GetSystemReportsMedHistory(stringReportName, StartDate, EndDate, DateType, MedicationNameId, Prescriber, onSuccessfullGetSystemReportsMedHistory, onFailure);
        PopupCenter("LoadReport.aspx?reportName=" + encodeURIComponent(stringReportName) + "&StartDate=" + encodeURIComponent(StartDate) + "&EndDate=" + encodeURIComponent(EndDate) + "&ExpandCollapseAll=" + encodeURIComponent(ExpandCollapseAll), "SmartCare", 760, 500);
    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function onSuccessfullGetSystemReportsMedHistory(result, context, methodname) {
    parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    if (result == null)
        return;
    document.getElementById("testMedHistory").href = result;
    document.getElementById("testMedHistory").click();
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


function closeDiv() {
    try {
        $("#DivSearch").css('display', 'none');
        fnHideParda();
        parent.window.redirectToManagementPage();
    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}


function CalShow(ImgCalID, TextboxID) {
    Calendar.setup({ inputField: TextboxID, ifFormat: "%m/%d/%Y", showsTime: false, button: ImgCalID, step: 1 });
}

function EnablesDisable() {
    //alert('Hello');
}

function Check1() {
    alert('Hello');
}


function CheckDates(TextBoxStartDateID, TextBoxEndDateID, LabelErrorID) {
    try {

        var StartDate = document.getElementById(TextBoxStartDateID).value;
        var TextBoxStartDateObject = document.getElementById(TextBoxStartDateID);
        var EndDate = document.getElementById(TextBoxEndDateID).value;
        if (StartDate == "" || StartDate == null || StartDate.charAt(0) == ' ') {
            ShowError('Please Select Start Date', true);
            return false;
        } else {
            if ((ValidateDates(TextBoxStartDateID, 'Start Date'))) {
                if ((EndDate != "") && (EndDate != null) && (EndDate.charAt(0) != ' ')) {
                    if (ValidateDates(TextBoxEndDateID, 'End Date')) {
                        //Added By Pramod on 11 Apr 2008 as communication with server should be shown after validating date
                        fnShowTemp();
                        return true;
                    } else {
                        document.getElementById(TextBoxEndDateID).focus();
                        return false;
                    }
                } else {
                    //Added By Pramod on 11 Apr 2008 as communication with server should be shown after validating date
                    fnShowTemp();
                    return true;
                }
            } else {
                TextBoxStartDateObject.focus();
                return false;
            }
        }

    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
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
    } catch(Err) {
        imageError[0].style.display = 'block';
        labelError[0].innerText = 'An Error Occured, Please Contact your System Administrator';
        return false;
    }
}


function ValidateDates(TextBoxDate, ControlName) {
    try {


        var _TextBoxDate = document.getElementById(TextBoxDate);

        //For mm/dd/yyyy
        var RegExPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;


        if (_TextBoxDate.value.match(RegExPattern) == null) {

            ShowError('Invalid ' + ControlName + ' Format (Valid Format is mm/\dd/\yyyy)', true);

            return false;
        } else {
            return true;
        }

    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

function onDeleteClick(sender, e) {
    try {
        var TableHTML = "";
        var div = "";
        MedicationObject = new Object();
        MedicationObject = e;
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
        //Added By Pramod On 21 Apr 2008 to Set TextBox position.
        div.style.top = (sender.screenY - 200);

        TableHTML = TableHTML + "<table cellpadding='0' cellspacing='0'  style='height: 1px; border-right: #dee7ef thin solid;border-top: #dee7ef thin solid; border-left: #dee7ef thin solid; border-bottom: #dee7ef thin solid;'>";
        TableHTML = TableHTML + "<tr><td >";
        TableHTML = TableHTML + "<table class='PopUpTitleBar' border='0' cellpadding='0' cellspacing='0'   width='100%'>";
        TableHTML = TableHTML + "<tr><td  id='topborder' class='TitleBarText'>Enter Discontinue Reason</td>";
        TableHTML = TableHTML + "<td align='left' width='10px'><img id='ImgCrossDiscontinue' onclick='CloseDiscontinueDiv(divDiscontinueMain);' src='App_Themes/Includes/Images/cross.jpg'      title='Close' alt='Close' />";
        TableHTML = TableHTML + " </td></tr></table></td></tr>";


        TableHTML = TableHTML + " <tr><td valign='top' style='width: 100%' align='center'>";
        TableHTML = TableHTML + "<table border='0px' cellpadding='0' cellspacing='0px' width='100%'>";
        TableHTML = TableHTML + "<tr>";
        TableHTML = TableHTML + "<td valign='middle' style='width:80%' align='left' colspan='2'>";
        if (e.AddOrder == 'True') {
            TableHTML = TableHTML + "<textarea cols='30' id='TextBoxDiscontinueReason'  class='TextBox' style='height:52px' name='TextBoxDiscontinueReason'  onkeyup= 'doKeydown(this);'  onkeydown= 'doKeydown(this);'   onkeypress= 'doKeydown(this);' onbeforepaste='doBeforePaste(this);'   onpaste='doPaste(this);'  maxLength='1000'        /></textarea>";
        } else {
            TableHTML = TableHTML + "<textarea cols='30' id='TextBoxDiscontinueReason' disabled class='TextBox' style='height:52px' name='TextBoxDiscontinueReason'  onkeyup= 'doKeydown(this);'  onkeydown= 'doKeydown(this);'   onkeypress= 'doKeydown(this);' onbeforepaste='doBeforePaste(this);'   onpaste='doPaste(this);'  maxLength='1000'        /></textarea>";
        }


        TableHTML = TableHTML + "</td>";
        TableHTML = TableHTML + "</tr>";
        TableHTML = TableHTML + "<tr><td colspan='2'> &nbsp;&nbsp;</td></tr>";
        TableHTML = TableHTML + " <tr><td colspan='2'><input id='ButtonDiscontinue' class='btnimgexsmall' type='button' value=Discontinue onclick='ClientMedicationDiscontinue(TextBoxDiscontinueReason);'  disabled=true />&nbsp;<input id='ButtonCancel' class='ButtonWeb' style='width: 98px' type='button' value='Cancel'  onclick='CloseDiscontinueDiv(divDiscontinueMain);'    /></td>";


        TableHTML = TableHTML + "</tr>";


        TableHTML = TableHTML + "</table></td></tr></table>";

        div.innerHTML = "";
        div.innerHTML = TableHTML;


        if ((sender.target.parentNode.getElementsByTagName("div").length < 1) && (sender.target.parentNode.getElementsByTagName("div").length != 1)) {
            sender.target.parentNode.appendChild(div);
        }
        //if((sender.target.parentNode.getElementsById("divDiscontinueMain").length==1) 
        document.getElementById("divDiscontinueMain").style.display = "block";
        //Added by sonia
        //Default focus should be in TextBox when user clicked on Discontinue option
        document.getElementById("TextBoxDiscontinueReason").focus();


    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

function DeleateFromList(sender, e) {
    try {
        var TableHTML = "";
        var div = "";
        MedicationObject = new Object();
        MedicationObject = e;
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
        //Added By Pramod On 21 Apr 2008 to Set TextBox position.
        div.style.top = (sender.screenY - 200);

        TableHTML = TableHTML + "<table cellpadding='0' cellspacing='0'  style='height: 1px; border-right: #dee7ef thin solid;border-top: #dee7ef thin solid; border-left: #dee7ef thin solid; border-bottom: #dee7ef thin solid;'>";
        TableHTML = TableHTML + "<tr><td >";
        TableHTML = TableHTML + "<table class='PopUpTitleBar' border='0' cellpadding='0' cellspacing='0'   width='100%'>";
        TableHTML = TableHTML + "<tr><td  id='topborder' class='TitleBarText'>Enter Discontinue Reason</td>";
        TableHTML = TableHTML + "<td align='left' width='10px'><img id='ImgCrossDiscontinue' onclick='CloseDiscontinueDiv(divDiscontinueMain);' src='App_Themes/Includes/Images/cross.jpg'      title='Close' alt='Close' />";
        TableHTML = TableHTML + " </td></tr></table></td></tr>";


        TableHTML = TableHTML + " <tr><td valign='top' style='width: 100%' align='center'>";
        TableHTML = TableHTML + "<table border='0px' cellpadding='0' cellspacing='0px' width='100%'>";
        TableHTML = TableHTML + "<tr>";
        TableHTML = TableHTML + "<td valign='middle' style='width:80%' align='left' colspan='2'>";
        if (e.AddOrder == 'True') {
            TableHTML = TableHTML + "<textarea cols='30' id='TextBoxDiscontinueReason'  class='TextBox' style='height:52px' name='TextBoxDiscontinueReason'  onkeyup= 'doKeydown(this);'  onkeydown= 'doKeydown(this);'   onkeypress= 'doKeydown(this);' onbeforepaste='doBeforePaste(this);'   onpaste='doPaste(this);'  maxLength='1000'        /></textarea>";
        } else {
            TableHTML = TableHTML + "<textarea cols='30' id='TextBoxDiscontinueReason' disabled class='TextBox' style='height:52px' name='TextBoxDiscontinueReason'  onkeyup= 'doKeydown(this);'  onkeydown= 'doKeydown(this);'   onkeypress= 'doKeydown(this);' onbeforepaste='doBeforePaste(this);'   onpaste='doPaste(this);'  maxLength='1000'        /></textarea>";
        }


        TableHTML = TableHTML + "</td>";
        TableHTML = TableHTML + "</tr>";
        TableHTML = TableHTML + "<tr><td colspan='2'> &nbsp;&nbsp;</td></tr>";
        TableHTML = TableHTML + " <tr><td colspan='2'><input id='ButtonDiscontinue' class='btnimgexsmall' type='button' value=Discontinue onclick='ClientMedicationDiscontinue(TextBoxDiscontinueReason);'  disabled=true />&nbsp;<input id='ButtonCancel' class='ButtonWeb' style='width: 98px' type='button' value='Cancel'  onclick='CloseDiscontinueDiv(divDiscontinueMain);'    /></td>";


        TableHTML = TableHTML + "</tr>";


        TableHTML = TableHTML + "</table></td></tr></table>";

        div.innerHTML = "";
        div.innerHTML = TableHTML;


        if ((sender.target.parentNode.getElementsByTagName("div").length < 1) && (sender.target.parentNode.getElementsByTagName("div").length != 1)) {
            sender.target.parentNode.appendChild(div);
        }
        //if((sender.target.parentNode.getElementsById("divDiscontinueMain").length==1) 
        document.getElementById("divDiscontinueMain").style.display = "block";
        //Added by sonia
        //Default focus should be in TextBox when user clicked on Discontinue option
        document.getElementById("TextBoxDiscontinueReason").focus();


    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

var ViewMedicationHistory = {
    onSuccessfullDeletion: function(result, context, methodname) {
        try {

            var table = document.getElementById(context.TableId);
            var row = document.getElementById(context.RowId);
            var exitFlag = false;
            while (row != null) {

                if (row.cells[0].className == "blackLine")
                    exitFlag = true;
                row.style.display = 'none';

                if (exitFlag)
                    break;
                row = table.rows(row.rowIndex + 1);
            }
            // table.deleteRow(table.rows[row.rowIndex]);


        } catch(e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {
            parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008

        }
    },
    onFailure: function(error) {
        try {
            parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
            //Added by Chandan for task#122 1.7 - Error Dialog on Session Timeout 
            if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
                location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
            } else {
                alert(error.get_message());
            }
        } catch(e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onLinkClick: function (sender, e) {        
        try {

            fnShow(); //By Vikas Vyas On Dated April 04th 2008
            //A new parameter MedicationScriptId added by Sonia as OrderDetails should be get both acc to MedicationId as well as ScriptId
            Streamline.SmartClient.WebServices.ClientMedications.SetOrderDetailsMedicationId(e.MedicationId, e.MedicationScriptId, ViewMedicationHistory.onSuccessfullPopulationOfOrderDetails, ViewMedicationHistory.onFailure);
        } catch(e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    },
    onSuccessfullPopulationOfOrderDetails: function(result, context, methodname) {
        try {

            var DivSearch = parent.document.getElementById('DivSearch');
            DivSearch.style.display = 'none';
            parent.window.redirectToOrderDetailsPage('ViewHistory');
        } catch(e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        } finally {

            parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        }
    }
};
//function onLinkClick(sender, e) {
//    try {

//      fnShow();//By Vikas Vyas On Dated April 04th 2008
//       //A new parameter MedicationScriptId added by Sonia as OrderDetails should be get both acc to MedicationId as well as ScriptId
//        Streamline.SmartClient.WebServices.ClientMedications.SetOrderDetailsMedicationId(e.MedicationId, e.MedicationScriptId, onSuccessfullPopulationOfOrderDetails, ViewMedicationHistory.onFailure);
//    }
//    catch (e) {
//        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
//    }
// }

//function onSuccessfullPopulationOfOrderDetails(result, context, methodname) {
//    try {

//        var DivSearch = parent.document.getElementById('DivSearch');
//        DivSearch.style.display = 'none';
//        parent.window.redirectToOrderDetailsPage('ViewHistory');
//    } catch(e) {
//        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
//    } finally {

//        parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
//    }
//}


//Validates user entries


function onSuccessfullDeletion(result, context, methodname) {
    try {

        var table = document.getElementById(context.TableId);
        var row = document.getElementById(context.RowId);
        var exitFlag = false;
        while (row != null) {

            if (row.cells[0].className == "blackLine")
                exitFlag = true;
            row.style.display = 'none';

            if (exitFlag)
                break;
            row = table.rows(row.rowIndex + 1);
        }
        parent.window.redirectToOrderDetailsPage('ViewHistory');

    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

function onFailure(error) {
    try {

        parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        } else {
            alert(error.get_message());
        }
    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function ViewFillMedicationControl(Panel, SortBy) {

    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        // Set the optional parameter if needed
        if (Panel === undefined) {
            Panel = PanelMedicationViewList;
        }
        if (SortBy === undefined) {
            SortBy = '';
        }
        PanelMedicationViewList = Panel;


        // Create the WebRequest object.
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("AjaxScript.aspx?FunctionId=GetMedicationMgtHistory&par0=" + SortBy);
        wRequest.add_completed(OnViewFillMedicationControlCompleted);
        wRequest.set_userContext(Panel);
        wRequest.set_httpVerb("Post");
        var executor = new Sys.Net.XMLHttpExecutor();
        wRequest.set_executor(executor);
        executor.executeRequest();
        var started = executor.get_started();
        // alert("Executor started: " + started);
    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

function OnViewFillMedicationControlCompleted(executor, eventArgs) {
    try {
        if (executor.get_responseAvailable()) {

            // Get the Web request instance.
            var webReq = executor.get_webRequest();
            // Display request Url.
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
                }
            }
        } else {
            if (executor.get_timedOut())
                alert("Timed Out");
            else if (executor.get_aborted())
                alert("Aborted");

        }
    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    } finally {
        parent.fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008 
    }

}

function onHeaderClick(obj) {
    try {
        var sortBy = obj.getAttribute("SortOrder");
        var ColumnName = obj.getAttribute("ColumnName");
        if (sortBy == "") {
            sortBy = "Asc";

        }
        ColumnName = ColumnName + " " + sortBy;
        //ViewFillMedicationControl(document.getElementById(PanelMedicationViewList),ColumnName);
        GetMedicationViewList(PanelMedicationViewList, ColumnName);

    } catch(e) {

    }
}


function GetMedicationViewList(Panel, SortBy) {

    try {

        requestUrl = "AjaxScript.aspx?FunctionId=GetMedicationMgtHistory&par0=" + SortBy;
        //alert(requestUrl);

        CreateXmlHttp();
        if (XmlHttp) {
            XmlHttp.onreadystatechange = function() { handleGetMedicationList(Panel); };
            XmlHttp.open("POST", requestUrl, true);

            XmlHttp.send(null);

        }
    } catch(Err) {
        alert(Err.description);
    }
}

function handleGetMedicationList(PanelMedicationViewList) {
    if (XmlHttp.readyState == 4) {
        if (XmlHttp.status == 200) {


            PanelMedicationViewList.innerHTML = "";

            //Following commented by sonia
            //Task #46 MM1.5.2 View Medication History: Medication records disappear from the grid.

            /*  var data=XmlHttp.responseText;
	        var indexofdiv= data.indexOf('</div>');
	        data=data.substring(indexofdiv+6,data.length);
	        var ScriptStart = data.indexOf('<script');
	        var ScriptEnd = data.indexOf('</script>');
	        var Script = data.substring(ScriptStart+57,ScriptEnd);
	        var Rscript = document.createElement('script'); 
	        Rscript.text=Script;
	        var dataxml = XmlHttp.responseXML.childNodes[1].childNodes[1].getElementsByTagName("div")[1].xml; 
  	        PanelMedicationViewList.appendChild(Rscript);
 	        PanelMedicationViewList.innerHTML= dataxml +PanelMedicationViewList.innerHTML ;
            RegisterMedicationListControlEvents();*/

            //Added by sonia
            //Task #46 MM1.5.2 View Medication History: Medication records disappear from the grid.
            //Code changed to display data from XmlHttp


            var data = XmlHttp.responseText;
            var indexofdiv = data.indexOf('</div>');
            if (data.length > 545) {
                data = data.substring(indexofdiv + 6, data.length);
                var ScriptStart = data.indexOf('<script');
                var ScriptEnd = data.indexOf('</script>');
                var Script = data.substring(ScriptStart + 57, ScriptEnd);
                var Rscript = document.createElement('script');
                Rscript.text = Script;
                PanelMedicationViewList.appendChild(Rscript);
                //Added By chandan on 24th Nov 2008 as view history disappear after click filter button as we already sort grid
                //found during unit testing on build #1.6.5
                //Ref: task No:3035
                data = data.substring(data.indexOf('<medlist>') + 10, data.indexOf('</medlist>'));

                //data = data.substring(data.indexOf('<MedList>')+10,data.indexOf('</MedList>')); 
                //end here
                PanelMedicationViewList.innerHTML = data + PanelMedicationViewList.innerHTML;
                RegisterMedicationListControlEvents();
            }


        }
    }
}

function HideViewHistory(error) {
    try {
        parent.fnHideParentDiv();
        var DivSearch = parent.document.getElementById('DivSearch');
        DivSearch.style.display = 'none';
        parent.window.pageLoad();
        if (error == "Session Expired") {
            alert(error);
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        } else {
            alert(error);
        }
    } catch(e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}


function PopupCenter(pageURL, title, w, h) {
    w = w || screen.width - 200;
    h = h || screen.height - 200;
    var left = (screen.width / 2) - (w / 2);
    var top = (screen.height / 2) - (h / 2);
    var targetWin = window.open(pageURL, title, 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
}