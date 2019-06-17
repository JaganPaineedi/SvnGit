//Description:Used to get Titration Template data
//Author:Pradeep
//CreatedOn:Nov 12,2009
//UsedBy:GetTitrationTemplateList(Panel,stringCondition) in TitrationTemplate.js
function OnFillTitrationTemplateCompleted(executor, eventArgs) {
    try {
        if (executor.get_responseAvailable()) {
            // Get the Web request instance.
            var webReq = executor.get_webRequest();
            // Display request Url.
            if (executor.get_statusCode() == 200) {
                var Panel = document.getElementById(webReq.get_userContext());
                Panel.innerHTML = "";
                var data = executor.get_responseData();
                var indexofdiv = data.indexOf('</div>');
                if (data.length > 545) {
                    data = data.substring(indexofdiv + 6, data.length);
                    var ScriptStart = data.indexOf('<script');
                    var ScriptEnd = data.indexOf('</script>');
                    var Script = data.substring(ScriptStart + 58, ScriptEnd);
                    var Rscript = document.createElement('script');
                    Rscript.text = Script;
                    Panel.appendChild(Rscript);
                    Panel.innerHTML = data + Panel.innerHTML;


                    RegisterTitrationTemplateControlEvents();
                }
            }
        }
        else {
            if (executor.get_timedOut())
                alert("Timed Out");
            else
                if (executor.get_aborted())
                    alert("Aborted");
        }
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}
//Description:Use to open titration/traper template page as per task#15(Venture)
//Author:Pradeep
//CreatedOn:12 Nov 2009
function ShowTitrationTraperPage(HiddenFieldMedicationNameId, HiddenTemplateOrderDate) {
    try {
        CloseShowTitrationTraperPage(HiddenFieldMedicationNameId, HiddenTemplateOrderDate);
        return false;
    }
    catch (ex) {
    }
}
function CloseShowTitrationTraperPage(HiddenFieldMedicationNameId, HiddenTemplateOrderDate) {
    var date = new Date();
    var time = date.getTime();
    var medicationNameId = document.getElementById(HiddenFieldMedicationNameId).value;
    var orderDate = document.getElementById(HiddenTemplateOrderDate).value;
    // Streamline.SmartClient.WebServices.ClientMedications.GetTitrationTemplateData(MedicationNameId,onTitrationTemplateSuccess,onFailure);
    var newwindow = window.showModalDialog('TitrationTrapperTemplate.aspx?MedicationNameId=' + medicationNameId + '&Time=' + time + '&OrderDate=' + orderDate, 'name', 'dialogWidth:500px;dialogHeight:500px');
    ClientMedicationTitration.SetTitrationTemplate(newwindow.titrationTemplateId, newwindow.titrationDate);
}

function SetReturnValues(TextBoxTitrationDate, HiddenFieldTitrationTemplateId) {
    var obj = new Object();
    var titrationDate = document.getElementById(TextBoxTitrationDate).value;
    var titrationTemplateId = document.getElementById(HiddenFieldTitrationTemplateId).value;
    obj.titrationDate = titrationDate;
    obj.titrationTemplateId = titrationTemplateId;
    window.returnValue = obj;
    window.close();
}


/// <summary>
/// Author Pradeep
/// It is called when  error occurs.
/// </summary>       
function onFailure(error) {
    // fnHideParentDiv();
    if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {

        location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
    }
    else {
        alert(error.get_message());
    }
}
/// <summary>
/// Author :Pradeep
/// It is used to check whether Method is Refill then CalShow need not to be called.
/// </summary>
function CalToBeShown(ImgCalID, TextboxID) {

    try {
        CalShow(ImgCalID, TextboxID);

    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

/// <summary>
/// Author Rishu Chopra
/// It is used to Set Calender format and is called during calender popup.
/// </summary>
function CalShow(ImgCalID, TextboxID) {

    try {
        Calendar.setup({
            inputField: TextboxID,
            ifFormat: "%m/%d/%Y",
            showsTime: false,
            button: ImgCalID,
            step: 1,
            //Added By Pramod on 15 Apr 2008 to set focus on textbox after clicking calender controls
            onUpdate: function (obj) { if (obj.targetElement != null) obj.targetElement.focus(); }
        });
        // document.getElementById('buttonInsert').disabled=false;     
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

/// <summary>
/// Author :Pradeep
/// Description:It is uset to sorting data on header click
///CreatedOn:nov 16,2009
/// </summary>
function onHeaderClick(obj) {
    try {
        var sortBy = obj.getAttribute("SortOrder");
        var ColumnName = obj.getAttribute("ColumnName");
        if (sortBy == "") {
            sortBy = "Asc";

        }
        ColumnName = ColumnName + " " + sortBy;
        //GetTitrationTemplateList(PanelMedicationListNonOrder,ColumnName);

    }
    catch (e) {

    }
}

function onSuccessfullDelete(result, context) {

}

function DeleteTemplateRow(sender, e) {
    sessionStorage.setItem('TitrationTemplateId', sender.target.getAttribute("TitrationTemplateId"));
    sessionStorage.setItem('sender', sender.target.getAttribute("TitrationTemplateId"));
    sessionStorage.setItem('radioSelected', document.getElementById('HiddenRadioButtonTitrationTempValue').value);
    var TemplateRowResult = parent.window.showModalDialog('YesNo.aspx?CalledFrom=TitrationTemplate', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');

    var TitrationTemplateId = undefined;
    var radioSelected = "";
    var sender = "";

    if (TitrationTemplateId == undefined || sender == undefined) {
        TitrationTemplateId = sessionStorage.getItem("TitrationTemplateId");
        radioSelected = sessionStorage.getItem("radioSelected");
        sender = sessionStorage.getItem("sender");
    }
    if (TemplateRowResult == 'Y') {
        if (TitrationTemplateId != null || TitrationTemplateId != undefined) {
            DeleteTemplateFromTable(sender, radioSelected);
        }
    }

}
function onTitrationTemplateDeleteSuccess(executor, context, methodname) {

}

function DeleteTemplateFromTable(object, radioSelected) {
    wRequest = new Sys.Net.WebRequest();
    var Panel = 'PanelTitrationTraperList';
    //var TitrationTemplateId = object.target.getAttribute("TitrationTemplateId");

    var TitrationTemplateId = "";
    if (object == undefined)
        TitrationTemplateId = object.target.getAttribute("TitrationTemplateId")
    else
        TitrationTemplateId = object;

    wRequest.set_url("TitrationTemplateManagement.aspx?FunctionId=DeleteTitrationTemplateList&par0=" + TitrationTemplateId + "&par1=" + radioSelected);
    wRequest.add_completed(OnFillTitrationTemplateCompleted);
    wRequest.set_userContext(Panel);
    wRequest.set_httpVerb("Post");
    var executor = new Sys.Net.XMLHttpExecutor();
    wRequest.set_executor(executor);
    executor.executeRequest();
    var started = executor.get_started();

    //  var TitrationTemplateId=object.target.getAttribute("TitrationTemplateId");
    //  Streamline.SmartClient.WebServices.ClientMedications.DeleteTitrationTemplate(TitrationTemplateId,onTitrationTemplateDeleteSuccess,onFailure,object);
}

function onTitrationTemplateDeleteSuccess(result, context) {
    var result = result;
}


function GetTitrationTemplateList(Panel, stringCondition, HiddenFieldTitrationTemplateId) {
    try {
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("TitrationTemplateManagement.aspx?FunctionId=GetTitrationTemplateList&par0=" + stringCondition);
        wRequest.add_completed(OnFillTitrationTemplateListCompleted);
        wRequest.set_userContext(Panel + ";" + HiddenFieldTitrationTemplateId);
        wRequest.set_httpVerb("Post");
        var executor = new Sys.Net.XMLHttpExecutor();
        wRequest.set_executor(executor);
        executor.executeRequest();
        var started = executor.get_started();
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}
function OnFillTitrationTemplateListCompleted(executor, eventArgs) {
    try {
        if (executor.get_responseAvailable()) {
            // Get the Web request instance.
            var webReq = executor.get_webRequest();
            // Display request Url.
            if (executor.get_statusCode() == 200) {
                var userContext = webReq.get_userContext();
                var PanelAndHiddenField = userContext.split(';');
                var Panel = document.getElementById(PanelAndHiddenField[0]);
                var HiddenFieldTitrationTemplateId = document.getElementById(PanelAndHiddenField[1]);
                Panel.innerHTML = "";
                var data = executor.get_responseData();
                var indexofdiv = data.indexOf('</div>');
                if (data.length > 545) {
                    data = data.substring(indexofdiv + 6, data.length);
                    var ScriptStart = data.indexOf('<script');
                    var ScriptEnd = data.indexOf('</script>');
                    var Script = data.substring(ScriptStart + 58, ScriptEnd);
                    var Rscript = document.createElement('script');
                    //var hdnFieldIndex=
                    Rscript.text = Script;
                    Panel.appendChild(Rscript);
                    Panel.innerHTML = data + Panel.innerHTML;
                    HiddenFieldTitrationTemplateId.value = document.getElementById('HdnTitrationTemplateId').value;
                    RegisterTitrationTemplateControlEvents();
                }
            }
            else {
                if (executor.get_timedOut()) {
                    alert("Timed Out");
                }
                else {
                    if (executor.get_aborted()) {
                        alert("Aborted");
                    }
                }
            }
        }
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}
function onRadioTemplateClick(sender, e) {

    try {
        var titrationTemplateId = sender.target.getAttribute("TitrationTemplateId");
        //document.getElementById('<%=HiddenTitrationTemplateId.ClientID%>').value=titrationTemplateId;
        document.getElementById('HiddenTitrationTemplateId').value = titrationTemplateId;
    }
    catch (ex) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

