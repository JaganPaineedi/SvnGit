var PanelHealthDataList = "";
var DropDownHealthDataCategory = "";
//----------Modification History-----
//Added one parameter allergy Type By Pradeep  as per task#9
//Added one parameter Comments in ref to Task#86
function SaveClientAllergyData(flag, KeyValue, DivAllergy, AllergyType, objectTextBoxAllergy, objectHiddenSelectedAllergyId, comments, active, AllergyReaction, AllergySeverity) {
    try {
        if (flag == true) {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008 
            var GridHtml;

            GridHtml = document.getElementById(DivAllergy);

            document.getElementById(objectTextBoxAllergy).value = "";
            document.getElementById(objectHiddenSelectedAllergyId).value = KeyValue;

            Streamline.SmartClient.WebServices.ClientMedications.SaveAllergyId(KeyValue, AllergyType, comments, active, AllergyReaction, AllergySeverity, onSuccessfullSave, onFailure, GridHtml);

        }
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_USER_DEFINED, e);
        throw Error.invalidOperation('Error in Saving Allergy Data');

    }
}

//Function added by Loveena in Ref to Task#92 on 26-Dec-2008 to refresh the view of patient overview information.
function RefreshPatientOverviewArea(flag, DivHtmlConatiner) {
    try {

        if (flag == true) {
            fnShow(); //By Vikas Vyas On Dated April 04th 2008 
            var GridHtml;
            GridHtml = document.getElementById(DivHtmlConatiner);
            Streamline.SmartClient.WebServices.ClientMedications.GetPatientOverviewContents(onSuccessfullRetrieval, onFailure, GridHtml);


        }
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_USER_DEFINED, e);
        throw Error.invalidOperation('Error in Refreshing Patient Overview area');

    }
}


//Function added by Loveena in Ref to Task#92 on 26-Dec-2008 to refresh the view of patient overview information.
function onSuccessfullRetrieval(result, context, methodname) {
    try {
        context.innerHTML = result;
    }
    catch (Err) {
        alert(Err.message);
    }
    finally {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    }

}


function onSuccessfullSave(result, context, methodname) {
    try {
        if (result.indexOf('AlreadyExists') >= 0) {
            ShowError('Selected allergy already exists in Known Allergies', true);
        } else {
            try {
                if (parent.window.opener != undefined && parent.window.opener.RefreshTabPageContentFromExternalScreens != undefined) {
                    parent.window.opener.RefreshTabPageContentFromExternalScreens(result, '');
                }
            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
        }

        pageLoad();

    }
    catch (Err) {
        alert(Err.message);
    }
    finally {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    }

}
function onFailure(error) {

    fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    //Added by Chandan for task#122 1.7 - Error Dialog on Session Timeout  
    if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
        location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
    }
    else {
        alert(error.get_message());
    }
}


function DeleteClientAllergy(AllergyId, objRow, objTable, objectMainDiv) {
    sessionStorage.setItem('AllergyId', AllergyId);
    sessionStorage.setItem('objRow', objRow);
    sessionStorage.setItem('objTable', objTable);
    sessionStorage.setItem('objectMainDiv', objectMainDiv);
    var answer = window.showModalDialog('YesNo.aspx?CalledFrom=MClientPersonalInfo', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
    if (answer == 'Y') {
        if (AllergyId == undefined || objRow == undefined || objTable == undefined || objectMainDiv == undefined) {
            var AllergyId = sessionStorage.getItem("AllergyId");
            var objRow = sessionStorage.getItem("objRow");
            var objTable = sessionStorage.getItem("objTable");
            var objectMainDiv = sessionStorage.getItem("objectMainDiv");
        }
        try {
            ShowError('', false);
            // if (confirm('Are you sure you want to Delete this Record from Client Allergies?')) {

            fnShow(); //By Vikas Vyas On Dated April 04th 2008

            $(objRow).remove();
            var RowsCount = $(objTable + ' tr').length;
            var objectMainDIV = document.getElementById(objectMainDiv);
            if (RowsCount == 0) {
                // objectMainDIV.innerHTML="<table class='SumarryLabel' cellspacing='0' border='0' ><tr><td>&nbsp;</td></tr><tr class='GridViewRowStyle'><td align='center' colspan=2><td>No Known Medication/Other Allergies </td></tr></table>";
                objectMainDIV.innerHTML = "<table class='SumarryLabel' cellspacing='0' border='0' ><tr><td>&nbsp;</td></tr><tr class='GridViewRowStyle'><td align='center' colspan=2><td></td></tr></table>";
            }
            Streamline.SmartClient.WebServices.ClientMedications.DeleteAllergy(AllergyId, onSuccessfullAllergyDeletion, onFailure);
        }
    
    catch (ex) {
        alert(ex.message);
    }

}

}

function onSuccessfullAllergyDeletion(result, context, methodname) {
    parent.window.MakeAlertCheckRequest();

    try {
        try {
            if (parent.window.opener != undefined && parent.window.opener.RefreshTabPageContentFromExternalScreens != undefined) {
                parent.window.opener.RefreshTabPageContentFromExternalScreens(result, '');
            }    
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        pageLoad();

    }
    catch (Err) {
        alert(Err.message);
    }
    finally {

        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    }

}

/// -----Modification History---------------
/// Date -----Author-----------Purpose-------
/// 20 Oct 2009 Pradeep        Ref.task#9(Added one parameter FilterCriteria in FillAllergyControl function )
function FillAllergyControl(DivAllergy, Editable, FilterCriteria) {
    try {
        var GridHtml;
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        GridHtml = document.getElementById(DivAllergy);
        Streamline.SmartClient.WebServices.ClientMedications.DisplayClientAllergyList(Editable, FilterCriteria, OnFillAllergyControlCompleted, onFailure, GridHtml);

    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_USER_DEFINED, e);
        //throw Error.invalidOperation('Error in Saving Allergy Data'); 

    }


}


function OnFillAllergyControlCompleted(result, context, methodname) {
    try {
        context.innerHTML = result;
        $(document).trigger('allergyupdate');
    }
    catch (Err) {
        alert(Err.message);
    }
    finally {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    }
}

function HideDisplayAddAllergy(TextBoxAddAllergyId, LinkAddAllergy, Editable) {
    try {
        if (Editable == 'N') {
            document.getElementById(TextBoxAddAllergyId).style.visibility = 'hidden';
            document.getElementById(LinkAddAllergy).style.visibility = 'hidden';

        }
        else {
            document.getElementById(TextBoxAddAllergyId).style.visibility = 'visible';
            document.getElementById(LinkAddAllergy).style.visibility = 'visible';

        }

    }
    catch (ex) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_USER_DEFINED, ex);
    }
}


function HideAllergyControl(TableAllergy, TextBoxAddAllergyId, LinkAddAllergy, HeadingKnownAllergies, DisplayOrNot) {

    var HeadingKnownAllergyTitle = HeadingKnownAllergies;
    // HeadingKnownAllergyTitle+="_labelText";

    try {
        if (DisplayOrNot == 'Y') {
            document.getElementById(TableAllergy).style.visibility = 'hidden';
            document.getElementById(TextBoxAddAllergyId).style.visibility = 'hidden';
            document.getElementById(LinkAddAllergy).style.visibility = 'hidden';
            document.getElementById(HeadingKnownAllergyTitle).style.visibility = 'hidden';
        }
        else {
            document.getElementById(TableAllergy).style.visibility = 'visible';
            document.getElementById(TextBoxAddAllergyId).style.visibility = 'visible';
            document.getElementById(LinkAddAllergy).style.visibility = 'visible';
            document.getElementById(HeadingKnownAllergyTitle).style.visibility = 'visible';
        }

    }
    catch (ex) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_USER_DEFINED, ex);
    }
}
//Added By Anuj on 25 Nov,2009 for task ref # 34 SDI Venture 10
function OpenHealthDataList() {
    var a = new Date();
    window.open("HealthDataList.aspx?time=" + a.getMinutes() + a.getSeconds(), '', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=900,height=500,left = 80,top = 50');
}

function FillReconciliationDataList(PanelReconciliationDataList, DropDownReconciliation, dropdownValue) {
    try {
        var Panel;
        Panel = PanelReconciliationDataList;
        DropDownReconciliationDataCategory = DropDownReconciliation;
        wRequest = new Sys.Net.WebRequest();
        if (dropdownValue == undefined || dropdownValue == null)
            wRequest.set_url("HealthDataListManagement.aspx?FunctionId=GetReconciliationDataList&selectedValue=" + DropDownReconciliation.value);
        else
            wRequest.set_url("HealthDataListManagement.aspx?FunctionId=GetReconciliationDataList&selectedValue=" + dropdownValue);
        wRequest.add_completed(OnFillReconciliationDataControlCompleted);

        wRequest.set_userContext(Panel);
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

function FillAllReconciliationDataList(PanelMedReconciliation) {
    try {
        var Panel;
        Panel = PanelMedReconciliation;
        wRequest = new Sys.Net.WebRequest();
     
            wRequest.set_url("HealthDataListManagement.aspx?FunctionId=GetAllReconciliationDataList&selectedValue=");
        wRequest.add_completed(OnFillMedReconciliationDataControlCompleted);
        wRequest.set_userContext(Panel);
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



function FillMedReconciliationDataList(PanelMedReconciliation, DropDownMedReconciliation, dropdownValue, DropDownDocumentVersionId) {
    try {

        var Panel;
        Panel = PanelMedReconciliation;
        DropDownReconciliationDataCategory = DropDownMedReconciliation;      
        wRequest = new Sys.Net.WebRequest();
       wRequest.set_url("HealthDataListManagement.aspx?FunctionId=GetMedReconciliationDataList&selectedValue=" + DropDownMedReconciliation.value + "&DocumentVersionId=" + DropDownDocumentVersionId.value);
      wRequest.add_completed(OnFillMedReconciliationDataControlCompleted);
       wRequest.set_userContext(Panel);
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

function FillAllergyReconciliationDataList(PanelMedReconciliation, DropDownMedReconciliation, dropdownValue, DropDownDocumentVersionId) {
    try {
        var Panel;
        Panel = PanelMedReconciliation;
        DropDownReconciliationDataCategory = DropDownMedReconciliation;
            wRequest = new Sys.Net.WebRequest();
        if (dropdownValue == undefined || dropdownValue == null)
            wRequest.set_url("HealthDataListManagement.aspx?FunctionId=GetAllergyReconciliationDataList&selectedValue=" + DropDownMedReconciliation.value + "&DocumentVersionId=" + DropDownDocumentVersionId.value);
        else
            wRequest.set_url("HealthDataListManagement.aspx?FunctionId=GetAllergyReconciliationDataList&selectedValue=" + dropdownValue + "&DocumentVersionId=" + DropDownDocumentVersionId.value);
        wRequest.add_completed(OnFillMedReconciliationDataControlCompleted);
        wRequest.set_userContext(Panel);
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





var PanelMedicationList = "";
function FillHealthDataList(PanelHealthDataList, DropDownObject, DropdownValue)
//function FillHealthDataList(DropDownObject,SortBy)
{
    try {
        var Panel;
        Panel = PanelHealthDataList;
        if (Panel === undefined) {
            Panel = PanelMedicationList;
        }
        //       if ( SortBy === undefined ) {
        //          SortBy = '';
        //       }
        DropDownHealthDataCategory = DropDownObject;
        wRequest = new Sys.Net.WebRequest();
        if (DropdownValue == undefined || DropdownValue == null)
            wRequest.set_url("HealthDataListManagement.aspx?FunctionId=GetHealthDataList&selectedValue=" + DropDownObject.value);
        else
            wRequest.set_url("HealthDataListManagement.aspx?FunctionId=GetHealthDataList&selectedValue=" + DropdownValue);
        wRequest.add_completed(OnFillHealthDataControlCompleted);
        wRequest.set_userContext(Panel);
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

function FillReconciliationData(PanelReconciliationDataList, DropDownReconciliation, dropdownValue) {
    try {
        var context = new Object();
        context.PanelReconciliationDataList = $("div[id$=PanelReconciliationDataList]")[0];
        context.ddlReconciliation = $("select[id$=DropDownReconciliationSourceFilter]")[0];
        context.dropdownValue = dropdownValue;
        PanelReconciliationDataList = context.PanelReconciliationDataList;
        DropDownReconciliation = context.ddlReconciliation;
        Streamline.SmartClient.WebServices.ClientMedications.FillReconciliationDropDown(onReconciliationDataSucceeded, onFailure, context)
   
    } catch (ex) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }

}

function FillMedReconciliationData(PanelMedReconciliation, DropDownMedReconciliation, dropdownValue) {
    try {
        var context = new Object();
        context.PanelMedReconciliation = $("div[id$=PanelMedReconciliation]")[0];
        context.ddlMedReconciliation = $("select[id$=DropDownMedReconciliation]")[0];
        context.dropdownValue = dropdownValue;
        PanelMedReconciliation = context.PanelMedReconciliation;
        DropDownMedReconciliation = context.ddlMedReconciliation;
        Streamline.SmartClient.WebServices.ClientMedications.FillMedReconciliationDropDown(onMedReconciliationDataSucceeded, onFailure, context)

    } catch (ex) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }

}

//Added by Loveena in ref to Task#34
function FillHealthData(PanelHealthDataList, ddlHealthData, dropdownValue, response) {
    try {
        try {
            if (parent.window.opener != undefined && response != undefined && parent.window.opener.RefreshTabPageContentFromExternalScreens != undefined) {
                parent.window.opener.RefreshTabPageContentFromExternalScreens(response, '');
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
        var context = new Object();
        context.PanelHealthDataList = $("div[id$=PanelHealthDataList]")[0];
        context.ddlHealthData = $("select[id$=DropDownHealthDataCategory]")[0];
        context.dropdownValue = dropdownValue;
        PanelHealthDataList = context.PanelHealthDataList;
        DropDownHealthDataCategory = context.ddlHealthData;
        Streamline.SmartClient.WebServices.ClientMedications.FillHealthData(onHealthDataSucceeded, onFailure, context)
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function onReconciliationDataSucceeded(result, context) {
    try {
     // context.ddlReconciliation.innerHTML = "";
        if (result == null || result.rows == null || !result.rows) {
            FillReconciliationDataList(context.PanelReconciliationDataList, context.ddlReconciliation);
            return;
        } 
        if (result != null || result.rows != null || result.rows) {

            var optionCount = context.ddlReconciliation.options.length;
            for (var i = 0; i < optionCount; i++) {
                context.ddlReconciliation.options[0] = null;
            }

            if (result.rows.length > 0) {
                var optionItem = new Option("", "-1", false, false);
                context.ddlReconciliation.options.add(optionItem);
                for (var i = 0; i < result.rows.length; i++) {
                    optionItem = new Option(result.rows[i]["Name"].toString(), result.rows[i]["DocumentVersionId"].toString(), false, false);
                    context.ddlReconciliation.options.add(optionItem);
                }
                if (context.dropdownValue != undefined)
                    context.ddlReconciliation.value = context.dropdownValue;
                FillReconciliationDataList(context.PanelReconciliationDataList, context.ddlReconciliation, context.dropdownValue);
            }
        }

    } catch (ex) {

    }
}

function onMedReconciliationDataSucceeded(result, context) {
    try {
        
        //context.ddlMedReconciliation.innerHTML = "";
        if (result != null || result.rows != null || result.rows) {
            var optionCount = context.ddlMedReconciliation.options.length;
            for (var i = 0; i < optionCount; i++) {
                context.ddlMedReconciliation.options[0] = null;
            }

            if (result.rows.length > 0) {
                var optionItem = new Option("", "-1", false, false);
                context.ddlMedReconciliation.options.add(optionItem);
            }
            for (var i = 0; i < result.rows.length; i++) {
                optionItem = new Option(result.rows[i]["CodeName"].toString(), result.rows[i]["GlobalCodeId"].toString(), false, false);
                context.ddlMedReconciliation.options[context.ddlMedReconciliation.length] = optionItem;
            }

        }

    } catch (ex) {

    }
}

function onHealthDataSucceeded(result, context) {
    try {
        context.ddlHealthData.innerHTML = "";
        if (result == null || result.rows == null || !result.rows) {
            FillHealthDataList(context.PanelHealthDataList, context.ddlHealthData);
            return;
        }
        //        context.options[context.length]=new Option("","-1",false,false);
        if (result != null || result.rows != null || result.rows) {
            for (var i = 0; i < result.rows.length; i++) {
                optionItem = new Option(result.rows[i]["CategoryName"], result.rows[i]["HealthDataCategoryId"], false, false);
                context.ddlHealthData.options[context.ddlHealthData.length] = optionItem;
            }
            if (context.dropdownValue != undefined)
                context.ddlHealthData.value = context.dropdownValue;
            FillHealthDataList(context.PanelHealthDataList, context.ddlHealthData, context.dropdownValue);
        }

    }
    catch (e) {
    }
}

function onMedDataSucceeded(result,context) {
    try {
     
        if (result != null || result.rows != null || result.rows) {
            FillAllReconciliationDataList(context.PanelMedReconciliation);
           // return;
        }

    }
    catch (e) {
    }
}

function OnFillReconciliationDataControlCompleted(executor, eventArgs) {
    try {
        if (executor.get_responseAvailable()) {
            var webReq = executor.get_webRequest();
            if (executor.get_statusCode() == 200) {
                var Panel = webReq.get_userContext();
                PanelReconciliationDataList = webReq.get_userContext();
                Panel.innerHTML = "";
                var data = executor.get_responseData();
                var indexofstart = data.indexOf('#####STARTRECONCILIATION#####');
                var indexofend = data.indexOf('#####ENDRECONCILIATION#####');
                var data1 = "";
                if (data.length > 545) {
                    data1 = data.substring(indexofstart + 43, indexofend - 47);
                    Panel.innerHTML = data1;
                }
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
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function OnFillMedReconciliationDataControlCompleted(executor, eventArgs) {
    try {
        if (executor.get_responseAvailable()) {
            var webReq = executor.get_webRequest();
            if (executor.get_statusCode() == 200) {
                var Panel = webReq.get_userContext();
                PanelMedReconciliationData = webReq.get_userContext();
                Panel.innerHTML = "";
                var data = executor.get_responseData();
                var indexofstart = data.indexOf('#####STARTMEDRECONCILIATION#####');
                var indexofend = data.indexOf('#####ENDMEDRECONCILIATION#####');
                var data1 = "";
                if (data.length > 545) {
                    data1 = data.substring(indexofstart + 43, indexofend - 49);
                    Panel.innerHTML = data1;
                }
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
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}


//Added By Anuj on 25 Nov,2009 for task ref # 34 SDI Venture 10
function OnFillHealthDataControlCompleted(executor, eventArgs) {
    try {
        if (executor.get_responseAvailable()) {
            var webReq = executor.get_webRequest();
            if (executor.get_statusCode() == 200) {
                var Panel = webReq.get_userContext();
                PanelHealthDataList = webReq.get_userContext();
                Panel.innerHTML = "";
                var data = executor.get_responseData();
                var indexofstart = data.indexOf('#####START#####');
                var indexofend = data.indexOf('#####END#####');
                var data1 = "";
                if (data.length > 545) {
                    data1 = data.substring(indexofstart + 29, indexofend - 20);
                    var indexofdiv = data1.indexOf('</div>');
                    data1 = data1.substring(0, indexofdiv + 6);
                    var ScriptStart = data.indexOf('##SDelete##');
                    var ScriptEnd = data.indexOf('##EDelete##');
                    if (ScriptStart > 0 && ScriptEnd > 0) {
                        var Script = data.substring(ScriptStart + 68, ScriptEnd - 9);
                        var Rscript = document.createElement('script');
                        Rscript.text = Script;
                        Panel.appendChild(Rscript);
                    }
                    Panel.innerHTML = data1 + Panel.innerHTML;
                    //RegisterHealthDataListControlEvents();
                }
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
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}
//Added By Anuj on 26 Nov,2009 for task ref # 34 SDI Venture 10
//function onHealthDataDeleteClick(sender,e)
function onHealthDataDeleteClick(HealthDataId, TableId, RowId)
{
    sessionStorage.setItem('HealthDataId', HealthDataId);
    sessionStorage.setItem('TableId', TableId);
    sessionStorage.setItem('RowId', RowId);
    
    var ans = window.showModalDialog('YesNo.aspx?CalledFrom=HealthRecordDelete', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
    if (ans == 'Y') {
        var agree = window.showModalDialog('YesNo.aspx?CalledFrom=ClientPersonalHealthData', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
        try {
            //fnShow();
            // var agree = confirm("Are you sure you wish to continue?");
            //  if (agree) {
            if (agree == 'Y') {
                if (HealthDataId == undefined || TableId == undefined || RowId == undefined) {
                    var HealthDataId = sessionStorage.getItem("HealthDataId");
                    var TableId = sessionStorage.getItem("TableId");
                    var RowId = sessionStorage.getItem("RowId");
                }
                var context = new Object();
                context.TableId = TableId;
                context.RowId = RowId;
                //Added by Loveena in ref to Task#2804
                //context.PanelHealthDataList = PanelHealthDataList;                   
                Streamline.SmartClient.WebServices.ClientMedications.DeleteHealthDataRecord(HealthDataId, onSuccessHealthDataDelete, onFailure, context);
            }
            else {
                return false;
            }

        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    }
}
//Added By Anuj on 26 Nov,2009 for task ref # 34 SDI Venture 10
//function onSuccessHealthDataDelete(result,context,methodname)
function onSuccessHealthDataDelete(result, context) {
    try {

        var row = document.getElementById(context.RowId);
        var table = document.getElementById(context.TableId);
        row.style.display = 'none';
        row = table.rows(row.rowIndex + 1);
        //fnHideParentDiv();
        //Added by Loveena in ref to Task#2804 
        FillHealthData(PanelHealthDataList, DropDownHealthDataCategory, null, result);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}
//Added By Anuj on 26 Nov,2009 for task ref # 34 SDI Venture 10
function onFailure() {

}

function GetHealthGraph(PanelGraphListInformation, DropDownHealthDataListGraph, TextBoxStartDate, TextBoxEndDate, LabelError) {
    try {
        // Create the WebRequest object.      
        var Pamel = "";
        var healthDataCategoryName = "";
        var $DropDownHealthDataListGraph = $("[id$=DropDownHealthDataListGraph]");
        if ($DropDownHealthDataListGraph == null || $DropDownHealthDataListGraph.length == 0) {
            return false;
        }
        else {
            var ddlReport = $DropDownHealthDataListGraph[0];
            var healthDataCategoryId = $DropDownHealthDataListGraph[0].value;
            if (healthDataCategoryId == "")
                healthDataCategoryId = 0;
            var index = $DropDownHealthDataListGraph[0].selectedIndex;
        }
        if (ddlReport.selectedIndex >= 0)
            healthDataCategoryName = ddlReport.options[ddlReport.selectedIndex].text;
        if (document.getElementById(PanelGraphListInformation) == null)
            Panel = PanelGraphListInformation[0];
        else
            Panel = document.getElementById(PanelGraphListInformation);
        var startdate = new Date();
        if (document.getElementById(TextBoxStartDate) != null)
            startdate = document.getElementById(TextBoxStartDate).value;
        else
            startdate = TextBoxStartDate[0].value;
        var enddate = new Date();
        if (document.getElementById(TextBoxEndDate) == null)
            enddate = TextBoxEndDate[0].value;
        else
            enddate = document.getElementById(TextBoxEndDate).value;
        if (document.getElementById(LabelError) != null)
            document.getElementById(LabelError).style.display = 'none';
        if (CompareDate(startdate, enddate, '/') == false) {
            if (document.getElementById(LabelError) != null) {
                document.getElementById(LabelError).style.display = 'block';
                document.getElementById(LabelError).innerHTML = 'End Date should be Greater than Start Date';
            }
            else {
                LabelError[0].style.display = 'block';
                LabelError[0].innerHTML = 'End Date should be Greater than Start Date';
            }

            return;
        }
        var context = new Object();
        context.ObjPanel = Panel;
        context.Index = index;
        context.StartDate = startdate;
        context.EndDate = enddate;
        Panel.innerHTML = "";
        Streamline.SmartClient.WebServices.ClientMedications.GetHealthGraphItem(healthDataCategoryId, onHealthGraphItemSucceeded, onFailure, context);

    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function CompareDate(date1, date2, separator) {

    var datearr1 = date1.split(separator);
    var datearr2 = date2.split(separator);
    /* Here You need to modify your code according to your date Current is MM/DD/YYYY */
    var year1 = parseInt(datearr1[2]);
    var month1 = parseInt(datearr1[0]);
    var day1 = parseInt(datearr1[1]);

    var year2 = parseInt(datearr2[2]);
    var month2 = parseInt(datearr2[0]);
    var day2 = parseInt(datearr2[1]);

    var utc1 = Date.UTC(year1, month1, day1);
    var utc2 = Date.UTC(year2, month2, day2);

    if (utc1 < utc2) {
        return true;
    }
    else {
        return false;
    }
}

function OnFillHealthGraphControlCompleted(executor, eventArgs) {
    try {
        if (executor.get_responseAvailable()) {
            // Get the Web request instance.
            var webReq = executor.get_webRequest();
            // Display request Url.
            if (executor.get_statusCode() == 200) {
                var Panel = webReq.get_userContext();

                var data = executor.get_responseData();
                var indexofstart = data.indexOf('###STARTGRAPH###');
                var indexofend = data.indexOf('###ENDGRAPH###');
                var data1 = "";
                if (data.length > 545) {
                    data1 = data.substring(indexofstart + 22, indexofend - 10);
                    Panel.innerHTML = Panel.innerHTML + data1;                    
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

function refreshGrowthChart() {
    try {
        var context = new Object();
        context.dropdownGrowthChart = $("#DropDownGrowthChartListGraph");
        if (context.dropdownGrowthChart.children('option').length == 0) {
            Streamline.SmartClient.WebServices.ClientMedications.GetGrowthChartCategories(onGrowthChartSucceed, onFailure, context);
        }

    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function onGrowthChartSucceed(result, context) {
    context.dropdownGrowthChart[0].options.innerHTML = "";
    context.dropdownGrowthChart[0].options.innerTEXT = "";
    for (var i = 0; i < result.rows.length; i++) {
        optionItem = new Option(result.rows[i]["CategoryDescription"], result.rows[i]["CategoryId"], false, false);
        context.dropdownGrowthChart[0].options[i] = new Option(optionItem.text, result.rows[i]["CategoryId"], false, false);
        if (result.rows[i]["IsSelected"] == 1) { context.dropdownGrowthChart[0].selectedIndex = i; }
    }   
    context.dropdownGrowthChart.trigger('onchange');
}

function GetGrowthChartImage(dropdown) {
    try {
        if (dropdown.value != null && dropdown.value != undefined) {
            var context = new Object();
            context.image = $("#GrowthChartImage");
            Streamline.SmartClient.WebServices.ClientMedications.GetGrowthChartImage(dropdown.value, 'IMG', onGrowthChartImageSucceed, onFailure, context);
        }
    } catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

//function PrintGrowthChartImage(dropdown) {
//    try {
//        if (dropdown.value != null && dropdown.value != undefined) {
//            var context = new Object();
//            Streamline.SmartClient.WebServices.ClientMedications.GetGrowthChartImage(dropdown.value, 'PRNT', onGrowthChartImageSucceed, onFailure, context);
//        }
//    } catch (e) {
//        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
//    }
//}

function PrintGrowthChartImage(src) {
    var gc = window.open(src, "_new");
    gc.window.print();
    gc.close();    
}

function onGrowthChartImageSucceed(result, context) {
    try {
        if (result != '' && context.image != undefined) {
            context.image.attr('src', result);
        }
    } catch (e) { }
}

function refreshGraph() {
    try {
        var context = new Object();
        $("#DivHolderMain")[0].style.height = "1000px";
        context.dropDownHealthGraph = $("select[id*=DropDownHealthDataListGraph]");
        context.PanelGraphListInformation = $("div[id$=PanelGraphListInformation]");
        context.TextBoxStartDate = $("input[id$=TextBoxStartDate]");
        context.TextBoxEndDate = $("input[id$=TextBoxEndDate]");
        context.LabelError = $("span[id$=LabelError]");

        Streamline.SmartClient.WebServices.ClientMedications.FillHealthGraph(onHealthGraphSucceeded, onFailure, context)
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}
function onHealthGraphSucceeded(result, context) {
    try {
        context.dropDownHealthGraph.innerHTML = "";
        context.dropDownHealthGraph[0].options.innerHTML = "";
        context.dropDownHealthGraph[0].options.innerTEXT = "";
        if (result == null || result.rows == null || !result.rows) {
            GetHealthGraph(context.PanelGraphListInformation, context.dropDownHealthGraph, context.TextBoxStartDate, context.TextBoxEndDate, context.LabelError);
            return;
        }
        for (var i = 0; i < result.rows.length; i++) {
            optionItem = new Option(result.rows[i]["CategoryName"], result.rows[i]["HealthDataCategoryId"], false, false);
            context.dropDownHealthGraph[0].options[context.dropDownHealthGraph[0].length] = new Option(optionItem.text, result.rows[i]["HealthDataCategoryId"], false, false);
        }
        GetHealthGraph(context.PanelGraphListInformation, context.dropDownHealthGraph, context.TextBoxStartDate, context.TextBoxEndDate, context.LabelError);
    }
    catch (e) {
    }
}

//Added By Chandan For Get the HealthItems For the Graph
function onHealthGraphItemSucceeded(result, context) {
    try {
        if (result.rows != null) {
            for (var i = 0; i < result.rows.length; i++) {
                wRequest = new Sys.Net.WebRequest();
                wRequest.set_url("HealthDataListManagement.aspx?FunctionId=GetHealthGraphInformation&healthDataCategoryId=" + result.rows[i]["HealthDataCategoryId"] + "&index=" + context.Index + "&startdate=" + context.StartDate + "&enddate=" + context.EndDate + "&healthDataCategoryName=" + result.rows[i]["ItemName"]);
                wRequest.add_completed(OnFillHealthGraphControlCompleted);
                wRequest.set_userContext(context.ObjPanel);
                wRequest.set_httpVerb("Post");
                var executor = new Sys.Net.XMLHttpExecutor();
                wRequest.set_executor(executor);
                executor.executeRequest();
                var started = executor.get_started();
            }
        }

    }
    catch (e) {
    }
}

function refreshGraphList() {
    try {
        $("#DivHolderMain")[0].style.height = "100%";
        FillHealthData('PanelHealthDataList', 'ddlHealthData')
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function refreshReconciliation() {
    try {
        $("#DivHolderMain")[0].style.height = "100%";
        FillReconciliationData()
        FillMedReconciliationData()
      }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}


function onHealthDataEditClick(HealthDataId, HealthDataCategoryId) {
    try {
        var DivHealthSearch = parent.document.getElementById('DivHealthSearch');
        DivHealthSearch.style.display = 'block';
        var iFrameHealthSearch = parent.document.getElementById('iFrameHealthSearch');
        var DropDownHealthCategory = $("select[id$=DropDownHealthDataCategory]")[0].id;
        var PanelHealthDataList = $("[id$=PanelHealthDataList]")[0].id
        iFrameHealthSearch.src = 'HealthData.aspx?DropDownObject=' + DropDownHealthCategory + '&PanelHealthDataList=' + PanelHealthDataList + '&HealthDataCategoryId=' + HealthDataCategoryId + '&HealthDataId=' + HealthDataId;
        iFrameHealthSearch.style.positions = 'absolute';
        DivHealthSearch.style.left = -300;
        DivHealthSearch.style.top = 150;
        DivHealthSearch.style.height = 350;
        DivHealthSearch.style.width = 800;
        iFrameHealthSearch.style.width = 500;
        iFrameHealthSearch.style.height = 310;
        return;
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

var ReconcileMedicationList = {
    ClientMedicationInstructionRow: function () {
        this.StrengthId;
        this.Unit;
        this.Schedule;
        this.Quantity;
        this.StartDate;
        this.EndDate;
        this.Instruction;
        this.RowIdentifierCMI;
        this.StrengthRowIdentifier;
        this.PotencyUnitCode;
        this.UserDefinedMedicationId;
    },
    ClientMedicationRow: function () {
        this.MedicationNameId;
        this.Ordered;
        this.DrugPurpose;
        this.DSMCode;
        this.DSMNumber;
        this.ClientId;
        this.PrescriberName;
        this.PrescriberId;
        this.SpecialInstructions;
        this.StartDate;
        this.EndDate;
        this.RowIdentifier;
        this.CreatedBy;
        this.CreatedDate;
        this.ModifiedBy;
        this.ModifiedDate;
        this.MedicationName;
        this.DAW;
        this.RowIdentifierCM;
        this.DesiredOutcome;
        this.Comments;
        this.OffLabel;
        this.IncludeCommentOnPrescription;
        this.RXSource;
        this.UserDefinedMedicationNameId;
    },
    ReconcileMedicationList: function () {
        var objClientMedicationrow = new ReconcileMedicationList.ClientMedicationRow();
        var objClientMedicationInstructionrow = new Array();
        objClientMedicationInstructionrow = new ReconcileMedicationList.ClientMedicationInstructionRow();
        var arrayobjpushClientMedicationInstructionrow = new Array();
        var saveTemplateFlag = 'None';
        if ($('[name="reconciliationcbsHeader"]').prop('checked') == true) {
            $('[name="reconciliationcbs"]:checked').each(function () {
                console.log(this.id);
                var UserDefinedMedication = this.getAttribute("UserDefinedMedication");
                if (UserDefinedMedication == "Y")
                { objClientMedicationrow.UserDefinedMedicationNameId = this.getAttribute("medicationnameid");
                }
                else
                { objClientMedicationrow.MedicationNameId = this.getAttribute("medicationnameid"); }

                objClientMedicationrow.Ordered = 'N';
                //objClientMedicationrow.DrugPurpose;
                //objClientMedicationrow.DSMCode;
                //objClientMedicationrow.DSMNumber;
                //objClientMedicationrow.ClientId;
                //objClientMedicationrow.PrescriberName;
                //objClientMedicationrow.PrescriberId;
                objClientMedicationrow.SpecialInstructions = "";
                objClientMedicationrow.StartDate = this.getAttribute("medicationstartdate");;
                objClientMedicationrow.EndDate = this.getAttribute("medicationenddate");;
                //objClientMedicationrow.RowIdentifier;
                //objClientMedicationrow.CreatedBy;
                //objClientMedicationrow.CreatedDate;
                //objClientMedicationrow.ModifiedBy;
                //objClientMedicationrow.ModifiedDate;
                //objClientMedicationrow.MedicationName;
                //objClientMedicationrow.DAW;
                //objClientMedicationrow.RowIdentifierCM;
                objClientMedicationrow.DesiredOutcome = "";
                objClientMedicationrow.Comments = this.getAttribute("Comment");
                //objClientMedicationrow.OffLabel;
                objClientMedicationrow.IncludeCommentOnPrescription = "Y";
                //objClientMedicationrow.RXSource;

                if (UserDefinedMedication == "Y") {
                    objClientMedicationInstructionrow.UserDefinedMedicationId = this.getAttribute("strengthid");
                }
                else {
                    objClientMedicationInstructionrow.StrengthId = this.getAttribute("strengthid");;
                }               
                objClientMedicationInstructionrow.Unit = this.getAttribute("unitid");;
                objClientMedicationInstructionrow.Schedule = this.getAttribute("scheduleid");;
                objClientMedicationInstructionrow.Quantity = this.getAttribute("quantity");;
                objClientMedicationInstructionrow.StartDate = this.getAttribute("medicationstartdate");;
                objClientMedicationInstructionrow.EndDate = this.getAttribute("medicationenddate");;
                //objClientMedicationInstructionrow.Instruction;
                //objClientMedicationInstructionrow.RowIdentifierCMI;
                //objClientMedicationInstructionrow.StrengthRowIdentifier;
                //objClientMedicationInstructionrow.PotencyUnitCode;
                arrayobjpushClientMedicationInstructionrow.push(objClientMedicationInstructionrow);
            });
            var context = new Object();

            try {
                if (objClientMedicationrow.MedicationNameId > 0 || objClientMedicationrow.UserDefinedMedicationNameId > 0)
                    Streamline.SmartClient.WebServices.ClientMedicationsNonOrder.SaveImportedMedicationRow(objClientMedicationrow, arrayobjpushClientMedicationInstructionrow, saveTemplateFlag, ReconcileMedicationList.onSaveMedicationSucceeded, ReconcileMedicationList.onSaveMedicationFailure, context);
                //Streamline.SmartClient.WebServices.ClientMedications.SaveMedicationRow(objClientMedicationrow, arrayobjpushClientMedicationInstructionrow, '', '', ReconcileMedicationList.onSaveMedicationSucceeded, ReconcileMedicationList.onSaveMedicationFailure, context);

            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
            }
        }
    },
    onSaveMedicationSucceeded: function (result, context, methodname) {
        try {
                    wRequest = new Sys.Net.WebRequest();
                    wRequest.set_url("HealthDataListManagement.aspx?FunctionId=SaveImportedList");
                    wRequest.add_completed(ReconcileMedicationList.onSaveMedicationSucess);
                    wRequest.set_userContext(context.ObjPanel);
                    wRequest.set_httpVerb("Post");
                    var executor = new Sys.Net.XMLHttpExecutor();
                    wRequest.set_executor(executor);
                    executor.executeRequest();
                    var started = executor.get_started();
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onSaveMedicationFailure: function (result, context, methodname) {
        try {
            if (result.length > 0) {
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onSaveMedicationSucess: function (result, context, methodname) {
        try {
            var DropDownObjectStatus = $("[id*=DropDownMedReconciliation]")[0];
            var PanelMedReconciliation = $("[id*=PanelMedReconciliation]")[0];
            var DropDownDocumentVersionId = $("[id*=DropDownReconciliationSourceFilter]")[0];
            FillMedReconciliationDataList(PanelMedReconciliation, DropDownObjectStatus, null, DropDownDocumentVersionId);
            FillAllReconciliationDataList(PanelMedReconciliation);
            redirectToManagementPage('Reconciliation');

        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },

};




