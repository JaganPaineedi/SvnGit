// JScript File
var PanelPharmacyList = "";
var PanelPrinterList = "";

var selected = [];
var password = '';
var otp = '';


//Added By Priya
function ReplaceChar(PharmacyName) {
    var getName = PharmacyName;

}
//Ref to Task#2595
function FillDistinctQuestions(DropFirstQuestionId, GlobalQuestion, selectedDropDown, count) {
    try {
        var Ctrl = 'Control_ASP.usercontrols_userpreferences_ascx_' + DropFirstQuestionId;
        var DropQuestion = document.getElementById(Ctrl);
        var TextValue = DropQuestion.options[DropQuestion.selectedIndex].text + ";" + DropQuestion.options[DropQuestion.selectedIndex].value;

        var FilteredQuestion = GlobalQuestion.split("|");
        FilteredQuestion.remove(TextValue);

        for (var index = 0; index < count; index++) {
            var Control = 'Control_ASP.usercontrols_userpreferences_ascx__DropDownListSecurityQuestion' + index;
            var DropDownControl = document.getElementById(Control);
            var SecondFiltered = GlobalQuestion.split("|");
            for (var j = 0; j < count; j++) {
                var DropControl = 'Control_ASP.usercontrols_userpreferences_ascx__DropDownListSecurityQuestion' + j;
                var DropDownOtherControl = document.getElementById(DropControl);
                if (DropDownOtherControl != DropDownControl) {
                    try {
                        var SelectedValue = DropDownOtherControl.options[DropDownOtherControl.selectedIndex].text + ";" + DropDownOtherControl.options[DropDownOtherControl.selectedIndex].value;
                        SecondFiltered.remove(SelectedValue);
                    }
                    catch (ex) { }

                }
            }
            var selectedValue = DropDownControl.value;
            if (selectedValue == 0)
                selectedValue = -1;
            DropDownControl.innerHTML = "";
            DropDownControl.options[DropDownControl.length] = new Option("Select a Question", "-1", false, false);
            var CodeId;
            var isExist = false;
            for (var i = 0; i < SecondFiltered.length; i++) {
                var IndexOfQuestion = SecondFiltered[i].indexOf(";");
                var Question = SecondFiltered[i].substring(0, IndexOfQuestion);
                CodeId = SecondFiltered[i].substring(IndexOfQuestion + 1, SecondFiltered[i].length);
                optionItem = new Option(Question, CodeId, false, false);
                DropDownControl.options[DropDownControl.length] = optionItem;
                if (CodeId == selectedValue) {
                    isExist = true;
                }
            }
            if (isExist == true) {
                DropDownControl.value = selectedValue;
            }
            if (selectedValue > 0)
                DropDownControl.setAttribute("SecurityQuestionId", selectedValue);
        }







        // QuestionAnswers=FilteredQuestion.split("|");

    }
    catch (e) {
        // alert(e);
        return false;
    }
}


///<CreatedBy>Loveena</CreatedBy>
///<CreationDate>26-March-2009</CreationDate>
///<Purpose>To Fill Degree DropDownList on UserPrefernces</Purpose>

function FillDegree(ddlDegree) {
    try {
        fnShow();
        var context = new Object();
        context.DropDown = ddlDegree;
        Streamline.SmartClient.WebServices.UserPreferences.FillDegree(onDegreeSucceeded, onFailure, context)
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

///<CreatedBy>Loveena</CreatedBy>
///<CreationDate>26-March-2009</CreationDate>
///<Purpose>It is called when Degree is filled successfully</Purpose>

function onDegreeSucceeded(result, context, methodname) {
    try {
        var DropDown = context.DropDown;
        DropDown.innerHTML = "";
        if (result == null || result.rows == null || !result.rows)
            return;
        DropDown.options[DropDown.length] = new Option("", "-1", false, false);
        for (var i = 0; i < result.rows.length; i++) {
            optionItem = new Option(result.rows[i]["CodeName"], result.rows[i]["GlobalCodeId"], false, false);
            DropDown.options[DropDown.length] = optionItem;
        }
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    finally {
        fnHideParentDiv();
    }

}

function OpenUserPreferencesWithStaffId(StaffId) {
    try {
        document.getElementById("HiddenFieldRedirect").value = "Y";
        Streamline.SmartClient.WebServices.UserPreferences.OpenUserPreferencesWithStaffId(StaffId, onSuccessfullOpenUserPreferencesWithStaff, onFailure)

    }
    catch (ex) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, ex);
    }
}

function SetStaffIdForUserPreferenceToNull() {
    try {
        document.getElementById("HiddenFieldRedirect").value = "Y";
        Streamline.SmartClient.WebServices.UserPreferences.SetStaffIdForUserPreferenceIdToNull(onSuccessfullOpenUserPreferencesWithStaff, onFailure)
    }
    catch (ex) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, ex);
    }
}
function onSuccessfullOpenUserPreferencesWithStaff(result) {
    try {
        redirectToUserPreferencesPage('UserManagement')
    }
    catch (Err) {
        alert(Err.message);
    }
}

///<CreatedBy>Loveena</CreatedBy>
///<CreationDate>26-March-2009</CreationDate>
///<Purpose>It is called when error occurs</Purpose>       
function onFailure(error) {
    fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
        location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
    }
    else {
        alert(error.get_message());
    }
}
//Sort Expression (Get from Hidden Field in TabPanelClaims div)
function SortExpression(HiddenObjectAscDescUserManagement) {
    try {
        var AscDesc = document.getElementById(HiddenObjectAscDescUserManagement).value;
        if (AscDesc == "ASC") {
            document.getElementById(HiddenObjectAscDescUserManagement).value = "DESC";
        }
        else {
            document.getElementById(HiddenObjectAscDescUserManagement).value = "ASC";
        }
    }
    catch (ex) {

    }
}

function SortScriptUserManagementHtml(SortField, HiddenObjectAscDescUserManagement, condition, clickevent) {
    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008
        var context = new Object();
        context.GridObject = document.getElementById('DivUserManagement');
        var stringAscDesc = document.getElementById(HiddenObjectAscDescUserManagement).value;

        SortExpression(HiddenObjectAscDescUserManagement);
        if (clickevent == 'radioclick') {
            stringAscDesc = "Asc";
        }
        Streamline.SmartClient.WebServices.UserPreferences.SortGridViewUserManagement(stringAscDesc, SortField, condition, onSuccessfullFillUserManagement, onFailure, context)
    }
    catch (ex) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, ex);
    }

}

//On SuccessFull Sort
function onSuccessfullSort(result, context, methodname) {
    try {
        var GridObject = context.GridObject;
        GridObject.html(result);
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008 
    }
    catch (Err) {
        alert(Err.message);
    }

}


//onSuccessfullFillUserManagement
function onSuccessfullFillUserManagement(result, context, methodname) {
    try {
        var GridObject = context.GridObject;
        if (result == null)
            return;
        GridObject.html(result);
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
    }
    catch (Err) {
        alert(Err.message);
    }

}
function GetUnformatedFormatedPhone(PhoneNumber, TextBoxPhone) {
    try {
        var context = TextBoxPhone;
        Streamline.SmartClient.WebServices.UserPreferences.getUnformatedPhoneNumber(PhoneNumber, onSuccessfullUnFormatPhoneNumber, onFailure, context)
    }
    catch (err) {
        alert(err.message);
    }
}

function GetUnformatedFormatedFax(FaxNumber, TextBoxFax) {
    try {
        var context = TextBoxFax;
        Streamline.SmartClient.WebServices.UserPreferences.getUnformatedPhoneNumber(FaxNumber, onSuccessfullUnFormatPhoneNumber, onFailure, context)
    }
    catch (err) {
        alert(err.message);
    }
}

function onSuccessfullUnFormatPhoneNumber(result, context) {
    try {
        Streamline.SmartClient.WebServices.UserPreferences.getFormatedPhoneNumber(result, onSuccessfullFormatPhoneNumber, onFailure, context)
    }
    catch (err) {
        alert(err.message);
    }
}


function onSuccessfullFormatPhoneNumber(result, context) {
    try {
        document.getElementById(context).value = result;
    }
    catch (err) {
        alert(err.message);
    }
}

//Modified in ref to Task#85 added parameters
function RadioButtonParameters(e, PharmacyActive, TextBoxName, TextBoxPhone, TextBoxFax, TextBoxEmail, TextBoxCity, TextBoxZip, TextBoxSureScriptsIdentifier, TextBoxAddress, DropDownListState, CheckBoxActive, CheckBoxPreferred, TextBoxSpecialty) {
    try {
        var context = new Object();
        context.PharmacyName = TextBoxName;
        context.Phone = TextBoxPhone;
        context.Fax = TextBoxFax;
        context.City = TextBoxCity;
        context.Zip = TextBoxZip;
        context.Address = TextBoxAddress;
        context.SureScriptsIdentifier = TextBoxSureScriptsIdentifier;
        context.State = DropDownListState;
        context.Active = CheckBoxActive;
        context.Preferred = CheckBoxPreferred;
        context.ButtonMerge = document.getElementById('buttonMerge');
        context.Email = TextBoxEmail;
        context.Specialty = TextBoxSpecialty == undefined ? "" : TextBoxSpecialty;
        if (e.PharmacyId == undefined) {
            if (document.getElementById('HiddenFieldCheckButtonStatus').value == 'S') {
                Streamline.SmartClient.WebServices.UserPreferences.RadioButtonClick(e, onRadioButtonSucceeded, onFailure, context)
            }
            else {
                var id = document.getElementById('HiddenFieldParentSelectedPharmacyId').value;
                Streamline.SmartClient.WebServices.UserPreferences.RadioButtonClick(id, onRadioButtonSucceeded, onFailure, context)
            }
        }
        else {
            Streamline.SmartClient.WebServices.UserPreferences.RadioButtonClick(e.PharmacyId, onRadioButtonSucceeded, onFailure, context)
        }
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}
function RadioButtonParametersOnSearch(e, TextBoxName, TextBoxID, TextBoxPhone, TextBoxAddress, TextBoxCity, DropDownListState, TextBoxZip, TextBoxSureScriptsIdentifier, TextBoxFax) {
    try {
        var context = new Object();
        context.Id = TextBoxID;
        context.PharmacyName = TextBoxName;
        context.Phone = TextBoxPhone;
        context.Fax = TextBoxFax;
        context.City = TextBoxCity;
        context.Zip = TextBoxZip;
        context.Address = TextBoxAddress;
        context.SureScriptsIdentifier = TextBoxSureScriptsIdentifier;
        context.State = DropDownListState;

        Streamline.SmartClient.WebServices.UserPreferences.RadioButtonClick(e, onRadioButtonSucceededSearch, onFailure, context)

    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function onRadioButtonSucceededSearch(result, context, methodname) {
    try {
        if (result.tables[0].rows[0]["PharmacyId"] != null) {
            document.getElementById(context.Id).value = result.tables[0].rows[0]["PharmacyId"];
        }
        else {
            document.getElementById(context.Id).value = "";
        }
        if (result.tables[0].rows[0]["PharmacyName"] != null) {
            document.getElementById(context.PharmacyName).value = result.tables[0].rows[0]["PharmacyName"];
        }
        else {
            document.getElementById(context.PharmacyName).value = "";
        }
        if (result.tables[0].rows[0]["PhoneNumber"] != null) {
            document.getElementById(context.Phone).value = result.tables[0].rows[0]["PhoneNumber"];
        }
        else {
            document.getElementById(context.Phone).value = "";
        }
        if (result.tables[0].rows[0]["Address"] != null) {
            document.getElementById(context.Address).value = result.tables[0].rows[0]["Address"];
        }
        else {
            document.getElementById(context.Address).value = "";
        }

        if (result.tables[0].rows[0]["State"] == "0 " || result.tables[0].rows[0]["State"] == "  " || result.tables[0].rows[0]["State"] == null) {
            document.getElementById(context.State).selectedIndex = "0";
        }
        else {
            document.getElementById(context.State).value = result.tables[0].rows[0]["State"];
        }
        if (result.tables[0].rows[0]["City"] != null) {
            document.getElementById(context.City).value = result.tables[0].rows[0]["City"];
        }
        else {
            document.getElementById(context.City).value = "";
        }
        if (result.tables[0].rows[0]["FaxNumber"] != null) {
            document.getElementById(context.Fax).value = result.tables[0].rows[0]["FaxNumber"];
        }
        else {
            document.getElementById(context.Fax).value = "";
        }
        if (result.tables[0].rows[0]["ZipCode"] != null) {
            document.getElementById(context.Zip).value = result.tables[0].rows[0]["ZipCode"];
        }
        else {
            document.getElementById(context.Zip).value = "";
        }
        if (result.tables[0].rows[0]["SureScriptsPharmacyIdentifier"] != null) {

            document.getElementById(context.SureScriptsIdentifier).value = result.tables[0].rows[0]["SureScriptsPharmacyIdentifier"];
        }
        else {
            document.getElementById(context.SureScriptsIdentifier).value = "";
        }

        if (result.tables[0].rows[0]["PhoneNumber"] != null) {
            GetUnformatedFormatedPharmacyPhone(result.tables[0].rows[0]["PhoneNumber"], context.Phone);
        }
        if (result.tables[0].rows[0]["FaxNumber"] != null) {
            GetUnformatedFormatedPharmacyPhone(result.tables[0].rows[0]["FaxNumber"], context.Fax);
        }
        if (PharmacyManagement.hideInProgress) PharmacyManagement.hideInProgress();
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}
//-------Modification History----------------------------
//Date ---------Author----------Purpose------------------
//3 Jan 2010    Pradeep         Made changes to check null value 
function onRadioButtonSucceeded(result, context, methodname) {
    try {
        fnShow();
        if (result != 'undefined') {
            if (result.PharmacyEditAllowed != null) {
                if (result.PharmacyEditAllowed.toUpperCase() == "N") {
                    $("[id$=TextBoxName]").attr("disabled", true);
                    $("[id$=TextBoxPhone]").attr("disabled", true);
                    $("[id$=TextBoxFax]").attr("disabled", true);
                    $("[id$=TextBoxEmail]").attr("disabled", true);
                    $("[id$=TextBoxAddress]").attr("disabled", true);
                    $("[id$=TextBoxCity]").attr("disabled", true);
                    $("[id$=DropDownListState]").attr("disabled", true);
                    $("[id$=TextBoxZip]").attr("disabled", true);
                    $("[id$=CheckBoxActive]").attr("disabled", true);
                    $("[id$=CheckBoxPreferred]").attr("disabled", false);
                    $("[id$=TextBoxSureScriptsIdentifier]").attr("disabled", true);
                    $("[id$=TextBoxSpecialty]").attr("disabled", true);
                }
                else {

                    $("[id$=TextBoxName]").attr("disabled", false);
                    $("[id$=TextBoxPhone]").attr("disabled", false);
                    $("[id$=TextBoxFax]").attr("disabled", false);
                    $("[id$=TextBoxEmail]").attr("disabled", false);
                    $("[id$=TextBoxAddress]").attr("disabled", false);
                    $("[id$=TextBoxCity]").attr("disabled", false);
                    $("[id$=DropDownListState]").attr("disabled", false);
                    $("[id$=TextBoxZip]").attr("disabled", false);
                    $("[id$=CheckBoxActive]").attr("disabled", false);
                    $("[id$=CheckBoxPreferred]").attr("disabled", false);
                    $("[id$=TextBoxSureScriptsIdentifier]").attr("disabled", false);
                    $("[id$=TextBoxSpecialty]").attr("disabled", false);
                }
            }
        }

        if (result.PharmacyName != null) {
            document.getElementById(context.PharmacyName).value = result.PharmacyName;
        }
        else {
            document.getElementById(context.PharmacyName).value = "";
        }
        if (result.PhoneNumber != null) {
            document.getElementById(context.Phone).value = result.PhoneNumber;
        }
        else {
            document.getElementById(context.Phone).value = "";
        }
        if (result.Address != null) {
            document.getElementById(context.Address).value = result.Address;
        }
        else {
            document.getElementById(context.Address).value = "";
        }

        if (result.State == "0 " || result.State == "  " || result.State == null) {
            document.getElementById(context.State).selectedIndex = "0";
        }
        else {
            document.getElementById(context.State).value = result.State;
        }
        if (result.City != null) {
            document.getElementById(context.City).value = result.City;
        }
        else {
            document.getElementById(context.City).value = "";
        }
        if (result.FaxNumber != null) {
            document.getElementById(context.Fax).value = result.FaxNumber;
        }
        else {
            document.getElementById(context.Fax).value = "";
        }
        if (result.ZipCode != null) {
            document.getElementById(context.Zip).value = result.ZipCode;
        }
        else {
            document.getElementById(context.Zip).value = "";
        }
        //Changed By Priya Ref:Task nO:85
        if (result.SureScriptsPharmacyIdentifier != null) {

            document.getElementById(context.SureScriptsIdentifier).value = result.SureScriptsPharmacyIdentifier;
            document.getElementById('buttonMerge').disabled = true;
        }
        else {
            document.getElementById(context.SureScriptsIdentifier).value = "";
            document.getElementById('buttonMerge').disabled = false;
        }
        if (result.Active == "Y") {
            document.getElementById(context.Active).checked = true;
        }
        else {
            document.getElementById(context.Active).checked = false;
        }
        if (result.PhoneNumber != null) {
        }
        if (result.FaxNumber != null) {
        }
        if (result.PreferredPharmacy == "Y") {
            document.getElementById(context.Preferred).checked = true;
        }
        else {
            document.getElementById(context.Preferred).checked = false;
        }
        if (result.Email != null) {
            document.getElementById(context.Email).value = result.Email;
        }
        else {
            document.getElementById(context.Email).value = "";
        }
        if (result.Specialty != null && context.Specialty != undefined) {
            document.getElementById(context.Specialty).value = result.Specialty;
        }
        else if (context.TextBoxSpecialty != undefined) {
            document.getElementById(context.Specialty).value = "";
        }

        if (PharmacyManagement.hideInProgress) PharmacyManagement.hideInProgress();

    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    finally {

        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008

    }
}

function DeleteFromList(e) {
    try {
        fnShow(); //By Vikas Vyas On Dated April 04th 2008            
        Streamline.SmartClient.WebServices.UserPreferences.DeletePharmacy(e.PharmacyId, UserPreferences.onSuccessfullDeletion, onFailure, e);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

var UserPreferences = {
    onSuccessfullDeletion: function (result, context, methodname) {
        try {
            //Code Added by Pradeep as per task#3346 on 17 March 2011 Start over here
            var LabelErrorMessage = $('[id$=LabelErrorMessage]')[0];
            var ImageError = $('[id$=ImageError]')[0];
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            if (result.tables[0] != 'undefined') {
                if (result.tables[0].rows[0]["PharmacyEditAllowed"].toUpperCase() == 'N') {
                    $('[id$=ImageError]')[0].style.visibility = 'visible';
                    $('[id$=ImageError]')[0].style.display = 'block';
                    $('[id$=LabelErrorMessage]')[0].style.display = 'block';
                    $('[id$=LabelErrorMessage]')[0].style.visibility = 'visible';
                    $('[id$=LabelErrorMessage]')[0].innerText = 'A pharamacy from the directory may not be deleted';
                    return false;
                } else {
                    var row = document.getElementById(context.RowId);
                    var table = document.getElementById(context.TableId);
                    row.style.display = 'none';
                    row = table.rows(row.rowIndex + 1);
                    document.getElementById('buttonInsert').value = 'Insert';
                    $("input[type='radio']:checked", $("#" + context.TableId)).attr('checked', false);
                    fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
                    $("[id$=TextBoxName]").attr("disabled", false);
                    $("[id$=CheckBoxPreferred]").attr("disabled", false);
                    $("[id$=TextBoxSureScriptsIdentifier]").attr("disabled", false);
                }
            }
            //Code Added by Pradeep as per task#3346 on 17 March 2011 End over here

        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    },
    onSuccessfullDeletionPermission: function (result, context, methodname) {
        try {
            var row = document.getElementById(context.RowId);
            var table = document.getElementById(context.TableId);
            row.style.display = 'none';
            row = table.rows(row.rowIndex + 1);
            fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008           
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

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
        GetPharmacyList(PanelPharmacyList, ColumnName);

    }
    catch (e) {

    }
}
//Added By Priya Ref:Task no:85
function onHeaderSearchClick(obj) {
    try {
        var sortBy = obj.getAttribute("SortOrder");
        var ColumnName = obj.getAttribute("ColumnName");
        if (sortBy == "") {
            sortBy = "Asc";

        }
        ColumnName = ColumnName + " " + sortBy;
        var panel = $("[id$=PanelPharmaciesListSearchPage]")[0].id;
        GetPharmacySearchListSort(panel, ColumnName);

    }
    catch (e) {

    }
}
function GetPharmacySearchListSort(SortColumn) {
    try {
        if ($("input[id$=HiddenFieldSortingDirection]").val().toUpperCase() == "ASC")
            $("input[id$=HiddenFieldSortingDirection]").val("DESC");
        else if ($("input[id$=HiddenFieldSortingDirection]").val().toUpperCase() == "DESC")
            $("input[id$=HiddenFieldSortingDirection]").val("ASC");
        $.ajax({
            type: "POST",
            url: "./PharmacyManagement.aspx?FunctionId=GetPharmacySearchListSort",
            data: 'SortColumn=' + SortColumn + '&SortDirection=' + $("input[id$=HiddenFieldSortingDirection]").val() + '&CurrentPage=' + $('[id$=HiddenCurrentPage]')[0].value + '',
            success: OnFillPharmacySearchSortControlCompleted,
            error: onFailure
        });
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Added By Priya Ref:Task no:85
//For sorting in Pharmacy Search Page
function OnFillPharmacySearchSortControlCompleted(result) {
    try {
        if (result.xml == undefined)
            var pageResponse = result;
        else
            var pageResponse = result.xml;
        var start = pageResponse.indexOf("##STARTPHARMACYSEARCH##") + 32;
        var end = pageResponse.indexOf("##ENDPHARMACYSEARCH##");
        pageResponse = pageResponse.substr(start, end - start).trim();
        if (pageResponse != undefined) {
            $("div[id$=PanelPharmaciesListSearchPage]")[0].innerHTML = pageResponse;
        }
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function GetPharmacyList(Panel, SortBy) {
    try {
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("PharmacyManagement.aspx?FunctionId=GetPharmacyList&par0=" + SortBy + "&par1=" + document.getElementById("Control_ASP.usercontrols_pharmacymanagement_ascx_HiddenRadioButtonValue").value);
        wRequest.add_completed(OnFillPharmacyControlCompleted);
        wRequest.set_userContext(Panel);
        wRequest.set_httpVerb("Post");
        var executor = new Sys.Net.XMLHttpExecutor();
        wRequest.set_executor(executor);
        executor.executeRequest();
        var started = executor.get_started();
        PanelPharmacyList = Panel;
        // alert("Executor started: " + started);

    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function GetPrinterList(Panel, SortBy) {
    try {
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("PrinterManagement.aspx?FunctionId=GetPrinterList&par0=" + SortBy + "&par1=" + document.getElementById("Control_ASP.usercontrols_printerdevice_ascx_HiddenRadioButtonValue").value);
        wRequest.add_completed(OnFillPrinterControlCompleted);
        wRequest.set_userContext(Panel);
        wRequest.set_httpVerb("Post");
        var executor = new Sys.Net.XMLHttpExecutor();
        wRequest.set_executor(executor);
        executor.executeRequest();
        var started = executor.get_started();
        PanelPrinterList = Panel;
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function OnFillPrinterControlCompleted(executor, eventArgs) {
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
                    var Script = data.substring(ScriptStart + 48, ScriptEnd);
                    var Rscript = document.createElement('script');
                    Rscript.text = Script;
                    Panel.appendChild(Rscript);
                    Panel.innerHTML = data + Panel.innerHTML;
                    RegisterPrinterListControlEvents();
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

// Clear the control Added by mohit Nov 16 2009
function ClearPrinterRow(DropDownListLocations, CheckBoxActive, TextBoxPath, TextBoxDeviceLabel, HiddenRadioButtonValue, PanelPrinterList, buttonInsert) {
    try {
        var context = new Object();
        context.DropDownListLocations = DropDownListLocations;
        context.CheckBoxActive = CheckBoxActive;
        context.TextBoxPath = TextBoxPath;
        context.TextBoxDeviceLabel = TextBoxDeviceLabel;
        context.HiddenRadioButtonValue = HiddenRadioButtonValue;
        context.PanelPrinterList = PanelPrinterList;
        context.buttonInsert = buttonInsert;
        Streamline.SmartClient.WebServices.UserPreferences.ClearPrinter(onSucceededClearPrinter, onFailure, context);

    }
    catch (e) {
    }
}

// on successfully clear
function onSucceededClearPrinter(result, context) {
    try {
        document.getElementById(context.DropDownListLocations).value = "0";
        document.getElementById(context.CheckBoxActive).Checked = false;

        document.getElementById(context.TextBoxPath).value = "";
        document.getElementById(context.TextBoxDeviceLabel).value = "";


        document.getElementById(context.buttonInsert).value = "Insert";
    }
    catch (e) {
    }
}

//Radio button printer page click 
function RadioButtonPrinterParameters(e, DropDownListLocations, CheckBoxActive, TextBoxPath, TextBoxDeviceLabel, HiddenRadioButtonValue) {
    try {

        var context = new Object();
        context.Location = DropDownListLocations;
        context.Active = CheckBoxActive;
        context.Path = TextBoxPath;
        context.DeviceLabel = TextBoxDeviceLabel;

        Streamline.SmartClient.WebServices.UserPreferences.RadioButtonClickForPrinter(e.PrinterDeviceLocationId, onRadioButtonPrinterSucceeded, onFailure, context)
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
    }
}

function onRadioButtonPrinterSucceeded(result, context, methodname) {
    try {
        fnShow();
        if (result.tables[0].rows[0]["DeviceLabel"] != null)
            document.getElementById(context.DeviceLabel).value = result.tables[0].rows[0]["DeviceLabel"];
        if (result.tables[0].rows[0]["DeviceUNCPath"] != null)
            document.getElementById(context.Path).value = result.tables[0].rows[0]["DeviceUNCPath"];

        if (result.tables[0].rows[0]["LocationId"] == "0 " || result.tables[0].rows[0]["LocationId"] == "  ") {
            document.getElementById(context.Location).selectedIndex = "0";
        }
        else {
            document.getElementById(context.Location).value = result.tables[0].rows[0]["LocationId"];
        }

        if (result.tables[0].rows[0]["Active"] == "Y") {
            document.getElementById(context.Active).checked = true;
        }
        else {
            document.getElementById(context.Active).checked = false;
        }
        //Modified by Loveena in ref to Task#2659
        //GetUnformatedFormatedPhone(result.tables[0].rows[0]["PhoneNumber"],context.Phone);
        //GetUnformatedFormatedPhone(result.tables[0].rows[0]["FaxNumber"],context.Fax);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    finally {

        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008

    }
}

//Delete from the printer list
function DeleteFromPrinterList(e) {
    try {
        fnShow();
        Streamline.SmartClient.WebServices.UserPreferences.DeletePrinter(e.PrinterDeviceLocationId, onSuccessfullPrinterListDeletion, onFailure, e);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function onSuccessfullPrinterListDeletion(result, context, methodname) {
    try {
        var row = document.getElementById(context.RowId);
        var table = document.getElementById(context.TableId);

        row.style.display = 'none';
        row = table.rows(row.rowIndex + 1);
        document.getElementById('buttonInsert').value = 'Insert';
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008//$("input[type='radio']:checked",$("#"+context.TableId)).attr(           
        $("input[type='radio']:checked", $("#" + context.TableId)).attr('checked', false);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }

}

function FillPrinterRow(DropDownListLocations, CheckBoxActive, TextBoxPath, TextBoxDeviceLabel, HiddenRadioButtonValue, PanelPrinterList, buttonInsert) {
    try {

        var Location = document.getElementById(DropDownListLocations).value;
        var Active;
        if (document.getElementById(CheckBoxActive).checked == true)
            Active = 'Y';
        else
            Active = 'N';

        var Path = document.getElementById(TextBoxPath).value;
        var DeviceLabel = document.getElementById(TextBoxDeviceLabel).value;


        var context = new Object();
        context.HiddenRadioButtonValue = HiddenRadioButtonValue;
        context.PanelPrinterList = PanelPrinterList;
        context.buttonInsert = buttonInsert;

        Streamline.SmartClient.WebServices.UserPreferences.SavePrinterRow(Location, Active, Path, DeviceLabel, onSucceededPrinter, onFailure, context);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

// Add Succeefully printer row
function onSucceededPrinter(result, context) {
    try {
        GetPrinterList(context.PanelPrinterList, 'DeviceLabel Asc');
        document.getElementById(context.buttonInsert).value = "Insert";
        RegisterPrinterListControlEvents();

    }
    catch (e) {

    }
}

function OnFillPharmacyControlCompleted(executor, eventArgs) {
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
                    var Script = data.substring(ScriptStart + 49, ScriptEnd);
                    var Rscript = document.createElement('script');
                    Rscript.text = Script;
                    Panel.appendChild(Rscript);
                    Panel.innerHTML = data + Panel.innerHTML;
                    RegisterPharmacyListControlEvents();


                }
                if (document.getElementById('HiddenFieldCheckButtonStatus').value == 'S') {

                    var radioButtonId = "Rb_" + parent.document.getElementById('HiddenFieldPharmacyId').value;
                    var chk = $("input[id$=" + radioButtonId + "]")[0];
                    chk.checked = true;
                }
                if (document.getElementById('HiddenFieldCheckButtonStatus').value == 'M') {
                    var radioButtonId = "Rb_" + parent.document.getElementById('HiddenFieldParentSelectedPharmacyId').value;
                    var chk = $("input[id$=" + radioButtonId + "]")[0];
                    chk.checked = true;
                }
            }
            //ClearPharmacyManagementControls();
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

function GetAllPharmaciesList(Panel, stringCondition) {
    try {
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("PharmacyManagement.aspx?FunctionId=GetAllPharmaciesList&par0=" + stringCondition);
        wRequest.add_completed(OnFillPharmacyControlCompleted);
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
//Modified in ref to Task#85
function ClearControls(TextBoxName, TextBoxPhone, TextBoxFax, TextBoxCity, TextBoxZip, TextBoxSureScriptsIdentifier, TextBoxAddress, DropDownListState, CheckBoxActive, CheckBoxPreferred) {
    try {
        document.getElementById(TextBoxName).value = "";
        document.getElementById(TextBoxAddress).value = "";
        document.getElementById(TextBoxFax).value = "";
        document.getElementById(TextBoxPhone).value = "";
        document.getElementById(TextBoxCity).value = "";
        document.getElementById(TextBoxZip).value = "";
        document.getElementById(TextBoxSureScriptsIdentifier).value = "";
        document.getElementById(CheckBoxActive).checked = true;
        document.getElementById(CheckBoxPreferred).checked = true;
        document.getElementById(DropDownListState).value = "0";

    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function Delete_Permission(e) {
    try {
        Streamline.SmartClient.WebServices.UserPreferences.DeletePermission(e.StaffPermissionId, UserPreferences.onSuccessfullDeletionPermission, onFailure, e);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

/// <summary>
/// It is used to popup UserPermissions page.
/// </summary>
function ShowUserPermissionsDiv() {
    try {
        var $divSearch = $("#DivSearch");
        $("#topborder", $divSearch).text("Add Permissions");
        var $iFrameSearch = $('#iFrameSearch', $divSearch);
        $iFrameSearch.attr('src', 'PermissionsAvailableList.aspx?');
        $iFrameSearch.css({ 'width': '400px', 'height': '210px' });
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

function GetPermissionsList(Panel, HiddenStaffPermissionId) {
    try {
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("UserPreferences.aspx?FunctionId=GetPermissionsList&par0=" + document.getElementById(HiddenStaffPermissionId).value);
        wRequest.add_completed(OnFillPermissionsListCompleted);
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

function OnFillPermissionsListCompleted(executor, eventArgs) {
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
                    var Script = data.substring(ScriptStart + 52, ScriptEnd);
                    var Rscript = document.createElement('script');
                    Rscript.text = Script;
                    Panel.appendChild(Rscript);
                    Panel.innerHTML = data + Panel.innerHTML;
                    RegisterPermissionsListControlEvents();
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

//Modified in ref to Task#85
function FillPharmacyRow(TextBoxName, TextBoxPhone, TextBoxFax, TextBoxEmail, TextBoxAddress, DropDownListState, TextBoxCity, TextBoxZip, TextBoxSureScriptsIdentifier, CheckBoxActive, CheckBoxPreferred, HiddenRadioButtonValue, PanelPharmaciesList, RadioButtonAllPharmacies, RadioButtonActivePharmacies, TextBoxSpecialty, buttonInsert) {
    try {
        var PharmacyName = document.getElementById(TextBoxName).value;
        var Phone = document.getElementById(TextBoxPhone).value;
        var Fax = document.getElementById(TextBoxFax).value;
        var Email = document.getElementById(TextBoxEmail).value;
        var Address = document.getElementById(TextBoxAddress).value;
        var State = document.getElementById(DropDownListState).value;
        if (State == "0")
            State = null;
        var City = document.getElementById(TextBoxCity).value;
        var Zip = document.getElementById(TextBoxZip).value;
        var SureScriptsIdentifier = document.getElementById(TextBoxSureScriptsIdentifier).value;
        var Specialty = document.getElementById(TextBoxSpecialty).value;
        var Active;
        var Preferred;
        var context = new Object();
        context.HiddenRadioButtonValue = HiddenRadioButtonValue;
        context.PanelPharmaciesList = PanelPharmaciesList;
        context.RadioButtonAllPharmacies = RadioButtonAllPharmacies;
        context.RadioButtonActivePharmacies = RadioButtonActivePharmacies;
        context.buttonInsert = buttonInsert;
        //-------Following Lines are written by Pradeep
        context.TextBoxName = TextBoxName;
        context.TextBoxPhone = TextBoxPhone;
        context.TextBoxFax = TextBoxFax;
        context.TextBoxEmail = TextBoxEmail;
        context.TextBoxAddress = TextBoxAddress;
        context.DropDownListState = DropDownListState;
        context.TextBoxCity = TextBoxCity;
        context.CheckBoxActive = CheckBoxActive;
        context.CheckBoxPreferred = CheckBoxPreferred;
        context.TextBoxZip = TextBoxZip;
        context.SureScriptsIdentifier = TextBoxSureScriptsIdentifier;
        context.Specialty = TextBoxSpecialty;

        //-------  
        if (document.getElementById(CheckBoxActive).checked == true)
            Active = 'Y';
        else
            Active = 'N';
        if (document.getElementById(CheckBoxPreferred).checked == true)
            Preferred = 'Y';
        else
            Preferred = 'N';
        Streamline.SmartClient.WebServices.UserPreferences.SavePharmacyRow(PharmacyName, Phone, Fax, Email, Address, State, City, Zip, SureScriptsIdentifier, Active, Preferred, Specialty, onSucceededPharmacy, onFailure, context);
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

function onSucceededPharmacy(result, context) {
    try {

        //--Code aded by Pradeep as per task#3346 on 17 March 2011 Start over here
        var LabelErrorMessage = $('[id$=LabelErrorMessage]')[0];
        var ImageError = $('[id$=ImageError]')[0];
        LabelErrorMessage.innerText = '';
        ImageError.style.visibility = 'hidden';
        ImageError.style.display = 'none';

        if (result.tables[0] != 'undefined') {
            if (result.tables[0].rows[0]["PharmacyIsValid"].toUpperCase() == 'N' && result.tables[0].rows[0]["ValidationMessage"] != '') {
                $('[id$=ImageError]')[0].style.visibility = 'visible';
                $('[id$=ImageError]')[0].style.display = 'block';
                $('[id$=LabelErrorMessage]')[0].style.display = 'block';
                $('[id$=LabelErrorMessage]')[0].style.visibility = 'visible';
                $('[id$=LabelErrorMessage]')[0].innerText = result.tables[0].rows[0]["ValidationMessage"];
                PharmacyManagement.hideInProgress();
                return false;
            }

        }
        document.getElementById('HiddenFieldCheckButtonStatus').value = '';
        GetAllPharmaciesList(context.PanelPharmaciesList, 'All');
        document.getElementById(context.buttonInsert).value = "Insert";
        document.getElementById(context.TextBoxName).value = "";
        document.getElementById(context.TextBoxPhone).value = "";
        document.getElementById(context.TextBoxFax).value = "";
        document.getElementById(context.TextBoxEmail).value = "";
        document.getElementById(context.TextBoxAddress).value = "";
        document.getElementById(context.DropDownListState).selectedIndex = 0;
        document.getElementById(context.TextBoxCity).value = "";
        document.getElementById(context.CheckBoxActive).checked = false;
        document.getElementById(context.CheckBoxPreferred).checked = false;
        document.getElementById(context.TextBoxZip).value = "";
        document.getElementById(context.SureScriptsIdentifier).value = "";
        document.getElementById(context.Specialty).value = "";
        $("[id$=TextBoxName]").attr("disabled", false);
        $("[id$=TextBoxPhone]").attr("disabled", false);
        $("[id$=TextBoxFax]").attr("disabled", false);
        $("[id$=TextBoxEmail]").attr("disabled", false);
        $("[id$=TextBoxAddress]").attr("disabled", false);
        $("[id$=TextBoxCity]").attr("disabled", false);
        $("[id$=DropDownListState]").attr("disabled", false);
        $("[id$=TextBoxZip]").attr("disabled", false);
        $("[id$=CheckBoxActive]").attr("disabled", false);
        $("[id$=CheckBoxPreferred]").attr("disabled", false);
        $("[id$=TextBoxSureScriptsIdentifier]").attr("disabled", false);
        $("[id$=TextBoxSpecialty]").attr("disabled", false);
        PharmacyManagement.hideInProgress();
    }
    catch (e) {

    }
}

function ClearPharmacyRow(TextBoxName, TextBoxPhone, TextBoxFax, TextBoxEmail, TextBoxAddress, DropDownListState, TextBoxCity, TextBoxZip, TextBoxSureScriptsIdentifier, CheckBoxActive, CheckBoxPreferred, HiddenRadioButtonValue, PanelPharmaciesList, RadioButtonAllPharmacies, RadioButtonActivePharmacies, TextBoxSpecialty, buttonInsert, buttonMerge) {
    try {
        var context = new Object();
        context.TextBoxName = TextBoxName;
        context.TextBoxPhone = TextBoxPhone;
        context.TextBoxFax = TextBoxFax;
        context.TextBoxEmail = TextBoxEmail;
        context.TextBoxAddress = TextBoxAddress;
        context.DropDownListState = DropDownListState;
        context.TextBoxCity = TextBoxCity;
        context.TextBoxZip = TextBoxZip;
        context.TextBoxSureScriptsIdentifier = TextBoxSureScriptsIdentifier;
        context.CheckBoxActive = CheckBoxActive;
        context.CheckBoxPreferred = CheckBoxPreferred;
        context.HiddenRadioButtonValue = HiddenRadioButtonValue;
        context.PanelPharmaciesList = PanelPharmaciesList;
        context.RadioButtonAllPharmacies = RadioButtonAllPharmacies;
        context.RadioButtonActivePharmacies = RadioButtonActivePharmacies;
        context.Specialty = TextBoxSpecialty;
        context.buttonInsert = buttonInsert;
        //Added By Priya Ref:task no:85
        document.getElementById(buttonMerge).disabled = true;
        //End
        Streamline.SmartClient.WebServices.UserPreferences.ClearPharmacy(onSucceededClearPharmacy, onFailure, context);

    }
    catch (e) {
    }
}

function onSucceededClearPharmacy(result, context) {
    try {
        //Added bY Pradeep as per task#3346 Start over here
        var LabelErrorMessage = $('[id$=LabelErrorMessage]')[0];
        var ImageError = $('[id$=ImageError]')[0];
        LabelErrorMessage.innerText = '';
        ImageError.style.visibility = 'hidden';
        ImageError.style.display = 'none';
        //Added bY Pradeep as per task#3346 End over here
        document.getElementById('HiddenFieldCheckButtonStatus').value = '';
        if (document.getElementById(context.HiddenRadioButtonValue).value == "All") {
            document.getElementById(context.RadioButtonAllPharmacies).Checked = true;
            GetAllPharmaciesList(context.PanelPharmaciesList, 'All')
            document.getElementById(context.RadioButtonActivePharmacies).Checked = false;
        }
        else {
            document.getElementById(context.RadioButtonActivePharmacies).Checked = true;
            GetAllPharmaciesList(context.PanelPharmaciesList, 'Active');
            document.getElementById(context.RadioButtonAllPharmacies).Checked = false;
        }
        document.getElementById(context.TextBoxName).value = "";;
        document.getElementById(context.TextBoxPhone).value = "";
        document.getElementById(context.TextBoxFax).value = "";
        document.getElementById(context.TextBoxEmail).value = "";
        document.getElementById(context.TextBoxAddress).value = "";
        document.getElementById(context.DropDownListState).value = "0";
        document.getElementById(context.TextBoxCity).value = "";
        document.getElementById(context.TextBoxZip).value = "";
        document.getElementById(context.TextBoxSureScriptsIdentifier).value = "";
        document.getElementById(context.CheckBoxActive).Checked = false;
        document.getElementById(context.CheckBoxPreferred).checked = false;
        document.getElementById(context.Specialty).value = "";
        document.getElementById(context.buttonInsert).value = "Insert";
        $("[id$=TextBoxName]").attr("disabled", false);
        $("[id$=TextBoxPhone]").attr("disabled", false);
        $("[id$=TextBoxFax]").attr("disabled", false);
        $("[id$=TextBoxEmail]").attr("disabled", false);
        $("[id$=TextBoxAddress]").attr("disabled", false);
        $("[id$=TextBoxCity]").attr("disabled", false);
        $("[id$=DropDownListState]").attr("disabled", false);
        $("[id$=TextBoxZip]").attr("disabled", false);
        $("[id$=CheckBoxActive]").attr("disabled", false);
        $("[id$=CheckBoxPreferred]").attr("disabled", false);
        $("[id$=TextBoxSureScriptsIdentifier]").attr("disabled", false);
        $("[id$=TextBoxSpecialty]").attr("disabled", false);
    }
    catch (e) {
    }
}
Array.prototype.remove = function (s) {
    for (i = 0; i < this.length; i++) {
        if (s == this[i]) this.splice(i, 1);
    }
}


function addOption(selectbox, text, value) {

    try {

        // alert('adop');

        var optn = document.createElement("OPTION");

        optn.text = text;

        optn.value = value;


        if (document.all)

            selectbox.options.add(optn);

        else

            selectbox.options[selectbox.options.length] = optn;

        //selectbox.options.add(optn);

    }

    catch (ex) {

        alert('addOption' + ex);

    }

}





//Called from Registration Participant control JS(ascx)--Sanvir Kumar Apr 02,2008

function selectedOption(selectbox, selectedValue) {


    // alert('in');

    try {

        for (var i = 0; i < selectbox.length; i++) {

            if (selectbox.options[i].value == selectedValue) {

                // alert(selectbox.options[i].value);

                selectbox.selectedIndex = i;

                // alert(selectbox.options[i].value);

            }

        }

    }

    catch (e) {

        alert(e);

    }

}

function CheckSelectedSecurityQuestionReg(DropQuestion, BindText, LabelSecurity) {

    //Page_ClientValidate(); 

    var DropSelectedQuestion = DropQuestion;

    var LabelSelecetedSecurityQuestion = document.getElementById(LabelSecurity);

    var returnFlag = 1;


    try {

        SetLabelValue(LabelSelecetedSecurityQuestion, "");


        if (DropQuestion == null) {

            return true;

        }


        if (DropSelectedQuestion.selectedIndex == 0) {

            SetLabelValue(LabelSelecetedSecurityQuestion, BindText);

            returnFlag = 0; //return false;

        }

        if (returnFlag == 0) {

            return false;

        }

        return true;

    }

    catch (e) {

        alert(e);

    }

}


function SecurityQuestionsRow() {
    this.Question;
    this.Answer;
    this.StaffSecurityQuestionId;
}
//Ref to Task#2595
function FillSecurityQuestion(tableSecrityQuestions) {
    try {
        var setQuestion = 0;
        var table = document.getElementById(tableSecrityQuestions);
        //Added By Ref:task No:3029
        var tablelength = table.rows.length;
        var totalquestion = tablelength / 2;
        var arrayobjpushSecurityQuestionsRow = new Array();
        var objSecurityQuestionsRow;
        for (var i = 0; i < table.rows.length; i++) {
            var row = table.rows[i];
            if ((i % 2) == 0) {
                objSecurityQuestionsRow = new SecurityQuestionsRow();
                objSecurityQuestionsRow.StaffSecurityQuestionId = row.cells[3].getElementsByTagName("input")[0].value;
                objSecurityQuestionsRow.Question = row.cells[2].getElementsByTagName("select")[0].value;
                //added By Priya Ref:Task No:3029
                if (objSecurityQuestionsRow.Question == -1)
                    setQuestion = setQuestion + 1;
                if (objSecurityQuestionsRow.StaffSecurityQuestionId == "")
                    objSecurityQuestionsRow.StaffSecurityQuestionId = -(i);
            }
            else {
                objSecurityQuestionsRow.Answer = row.cells[3].getElementsByTagName("input")[0].value;
            }



            if ((i % 2) != 0) {
                //added Ref:task no:3029
                if (objSecurityQuestionsRow.Question != -1) {
                    arrayobjpushSecurityQuestionsRow.push(objSecurityQuestionsRow);
                }

            }


        }
        //added By Priya Ref:Task No:3029
        if (setQuestion != totalquestion) {
            Streamline.SmartClient.WebServices.UserPreferences.SaveSecurityQuestions(arrayobjpushSecurityQuestionsRow, onSaveSecurityQuestionsSucceeded, onFailure);
        }
    }
    catch (ex) {
    }
}

function onSaveSecurityQuestionsSucceeded(result) {
    try {

    }
    catch (ex) {
    }
}

function CheckUserNameExists(userCode) {
    try {
        Streamline.SmartClient.WebServices.UserPreferences.CheckUserNameExists(userCode, onCheckUserNameExistsSucceded, onFailure)
    }
    catch (e) {
    }
}

function onCheckUserNameExistsSucceded(result) {
    if (result != "") {
        document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_DivErrorMessage').style.display = 'block';
        document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_ImageError').style.display = 'block';
        document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_ImageError').style.visibility = 'visible';
        document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_LabelErrorMessage').innerText = result;
        document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_HiddenCheckUserExists').value = false;
        $("[id$=ButtonClose]")[0].disabled = false;
    }
    else {
        document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_anchorUpdate').click();
    }
}

//Call the function to generate the HealthData Control
//Task #34 Mohit Madaan 
function GetFillHelthDataList(Panel, drpData) {
    try {

        var healthCategoryId = document.getElementById(drpData).value;
        //Streamline.SmartClient.WebServices.UserPreferences.GenerateHealthDataRow(healthCategoryId,onSucceededHealthData,onFailure,context);
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("HealthData.aspx?FunctionId=GetHealthDataList&par0=" + healthCategoryId);
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

function OnFillHealthDataControlCompleted(executor, eventArgs) {
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
                    //data=data.substring(indexofdiv+6,data.length);
                    //var ScriptStart = data.indexOf('<script');
                    //var ScriptEnd = data.indexOf('</script>');
                    //var Script = data.substring(ScriptStart+49,ScriptEnd);
                    // var Rscript = document.createElement('script'); 
                    //Rscript.text=Script;
                    //Panel.appendChild(Rscript);
                    var start = data.indexOf('#####START#####');
                    var end = data.indexOf('#####END#####');
                    data = data.substring(start + 30, end - 50);
                    Panel.innerHTML = data + Panel.innerHTML;
                    //RegisterHealthListControlEvents();
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

//Code added by Loveena in ref to Task#34
function HealthDataRow() {
    this.ItemValue1;
    this.ItemValue2;
    this.ItemValue3;
    this.ItemValue4;
    this.ItemValue5;
    this.ItemValue6;
    this.ItemValue7;
    this.ItemValue8;
    this.ItemValue9;
    this.ItemValue10;
    this.ItemValue11;
    this.ItemValue12;
    this.ItemChecked1;
    this.ItemChecked2;
    this.ItemChecked3;
    this.ItemChecked4;
    this.ItemChecked5;
    this.ItemChecked6;
    this.ItemChecked7;
    this.ItemChecked8;
    this.ItemChecked9;
    this.ItemChecked10;
    this.ItemChecked11;
    this.ItemChecked12;
    this.DateRecorded;
    this.HealthDataCategoryId;
    this.ItemName;
    this.HealthDataId;
}
function SaveHealthDataCategories(TextBoxDateRecorded, DropDownListHealthData, DropDownObject, PanelHealthDataList, HealthDataId) {
    try {
        var context = new Object();
        context.DropDownObject = DropDownObject;
        context.PanelHealthDataList = PanelHealthDataList;
        context.DropDownListHealthDataValue = document.getElementById(DropDownListHealthData).value;
        var table = document.getElementById('tableHealthDataList');
        var arrayHealthDataRow = new Array();
        var TextBoxDateRecorded = document.getElementById(TextBoxDateRecorded).value;
        var DropDownListHealthData = document.getElementById(DropDownListHealthData).value;
        for (var i = 0; i < table.rows.length; i++) {
            var j = i + 1;
            var row = table.rows[i];
            if (row.cells[1] != null) {
                var rowIndexId = parseInt(row.cells[1].getElementsByTagName("input")[0].value, 10);
                var objHealtDataRows = new HealthDataRow();
                objHealtDataRows.HealthDataId = HealthDataId;
                objHealtDataRows.DateRecorded = TextBoxDateRecorded;
                objHealtDataRows.HealthDataCategoryId = DropDownListHealthData;
                objHealtDataRows["ItemValue" + rowIndexId] = $(row.cells[2]).find("input[type='text']").val();
                if ($(row.cells[2]).find("input[type='checkbox']").length > 0) {
                    objHealtDataRows["ItemChecked" + rowIndexId] = $(row.cells[2]).find("input[type='checkbox']")[0].checked;
                } else {
                    objHealtDataRows["ItemChecked" + rowIndexId] = null;
                }
                objHealtDataRows.ItemName = rowIndexId;
                arrayHealthDataRow.push(objHealtDataRows);
            }

        }
        Streamline.SmartClient.WebServices.UserPreferences.SaveHealthData(arrayHealthDataRow, onSaveHealthDataSucceed, onFailure, context);
    }
    catch (ex) {
        alert('SaveHealthDataCategories()--' + ex);
    }
}

function onSaveHealthDataSucceed(result, context) {
    parent.FillHealthData(context.PanelHealthDataList, context.DropDownObject, context.DropDownListHealthDataValue, result);
}
//Code ends over here.

//Code added by Loveena in ref to Task#34

function SetFormula() {
    try {
        SetDecimal();
        var Formula = document.getElementById('HiddenFormula').value;
        var arr = new Array();
        if (Formula != "")
            arr = Formula.split(',');
        for (var loopCount = 0; loopCount < arr.length; loopCount++) {
            var formulaValue = new Array();
            formulaValue = arr[loopCount].toString().split(':');
            var str = formulaValue[1];

            var $PanelHealthDataControl = $("#PanelHelthDataControl");

            $PanelHealthDataControl.find("input").each(function () {
                if (this.value != "" && this.id.indexOf("TextBoxItemValue") >= 0) {
                    var numVal = this.id.substring(this.id.length - 1, this.id.length);
                    str = str.ReplaceAll("$" + numVal, parseFloat(this.value, 10));
                }
            });


            str = "var value =" + str;
            if (str.indexOf("$") == -1) {
                eval(str);
                if (value.toString() == 'NaN' || value.toString() == 'Infinity')
                    value = 0;

                var formValLength = formulaValue[0].length;
                document.getElementById("TextBoxItemValue" + formulaValue[0].substring(formValLength - 1, formValLength)).value = value;
            }
        }
        SetDecimal();
    }
    catch (ex) {
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

}

function SetDecimal() {
    try {
        var Decimal = document.getElementById('HiddenDecimal').value;
        var arrDecimal = new Array();
        arrDecimal = Decimal.split(',');
        for (var loopCounter = 0; loopCounter < arrDecimal.length; loopCounter++) {
            var DecimalValue = new Array();
            DecimalValue = arrDecimal[loopCounter].toString().split(':');
            DecimalValue[1] = "var decimalval=" + DecimalValue[1];
            eval(DecimalValue[1]);
            var decField = document.getElementById("TextBoxItemValue" + DecimalValue[0].substring(DecimalValue[0].length - 1, DecimalValue[0].length));
            if (decField != null) {
                decField.value = roundit(decField.value, decimalval);
            }
        }
    }
    catch (ex) {
    }
}

function roundit(Num, Places) {
    if (Places > 0) {
        if ((Num.toString().length - Num.toString().lastIndexOf('.')) > (Places + 1)) {
            var Rounder = Math.pow(10, Places);
            return Math.round(Num * Rounder) / Rounder;
        }
        else return Num;
    }
    else return Math.round(Num);
}

////Description:Used to check/uncheck default checkboxe as per task#23
////Author:Pradeep
////CreatedOn:Nov 30,2009
////UsedIn:UserPreferances.ascx
function UnCheckOtherDefaultCheckBoxes(CheckBox, locationId) {
    try {
        var table = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_tableUserLocationList');
        var checkBox = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_' + CheckBox);
        var rowCount = table.rows.length;
        if (checkBox.checked) {
            for (var i = 0; i < rowCount; i++) {
                var row = table.rows[i];
                if (row.cells.length > 1) {
                    var otherCheckBox = row.cells[2].childNodes[0].getElementsByTagName('input')[0];
                    if (otherCheckBox.id != checkBox.id) {
                        otherCheckBox.checked = false;
                    }
                }
            }
            Streamline.SmartClient.WebServices.UserPreferences.EditDefaultPrescribingLocation(locationId, 'Default Checked', onSuccessfullEditPrinterDeviceLocation, onFailure);
        }
        else {
            Streamline.SmartClient.WebServices.UserPreferences.EditDefaultPrescribingLocation(locationId, 'Default UnChecked', onSuccessfullEditPrinterDeviceLocation, onFailure);
        }

    }
    catch (Ex) {
    }
}

function DisableDefaultCheckboxs(checkboxID) {

    document.getElementById(checkboxID).disabled = true;


}

////Description:Used toMake Disable Default CheckBox  as per task#23
////Author:Pradeep
////CreatedOn:Nov 30,2009
////UsedIn:UserPreferances.ascx
function MakeDisableDefaultCheckBox(CheckBoxAssigned, CheckBoxDefault, LocationId, dropDown) {
    try {
        var checkBoxAssigned = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_' + CheckBoxAssigned);
        var checkBoxDefault = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_' + CheckBoxDefault);
        var dropDownList = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_' + dropDown);
        var dropDownValue = dropDownList.options[dropDownList.selectedIndex].value;

        if (!checkBoxAssigned.checked) {

            if (checkBoxDefault.checked) {
                checkBoxDefault.checked = false;
                checkBoxDefault.disabled = true;
                Streamline.SmartClient.WebServices.UserPreferences.EditStaffLocations(LocationId, 'Assign Not Checked', 'Default Checked', dropDownValue, onSuccessfullEditStaffLocation, onFailure);
            }
            else {
                checkBoxDefault.disabled = true;
                Streamline.SmartClient.WebServices.UserPreferences.EditStaffLocations(LocationId, 'Assign Not Checked', 'Default Not Checked', dropDownValue, onSuccessfullEditStaffLocation, onFailure);
            }


        }
        else {

            checkBoxDefault.disabled = false;
            //checkBoxDefault.style.disabled=false;
            // checkBoxDefault.setAttribute("disabled",false);

            Streamline.SmartClient.WebServices.UserPreferences.EditStaffLocations(LocationId, 'Assign Checked', 'Not Applicable', dropDownValue, onSuccessfullEditStaffLocation, onFailure);
        }

    }
    catch (ex) {
    }
}
////Description:Used toMake Disable Default CheckBox  as per task#23
////Author:Pradeep
////CreatedOn:Nov 30,2009
////UsedIn:UserPreferances.ascx
function SetPrinterDeviceLocation(dropDownList, locationId, assignCheckBox) {
    try {
        var dropDownList = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_' + dropDownList);
        var dropDownValue = dropDownList.options[dropDownList.selectedIndex].value;
        assignCheckBox = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_' + assignCheckBox);
        if (assignCheckBox.checked) {
            Streamline.SmartClient.WebServices.UserPreferences.UpdatePrinterDeviceLocation(locationId, dropDownValue, 'Assigned', onSuccessfullSetPrinterDeviceLocation, onFailure);
        }
        else {
            Streamline.SmartClient.WebServices.UserPreferences.UpdatePrinterDeviceLocation(locationId, dropDownValue, 'NotAssigned', onSuccessfullSetPrinterDeviceLocation, onFailure);
        }

    }
    catch (ex) {
    }
}

////Description:Used toMake Disable Default CheckBox  as per task#23
function onSuccessfullEditStaffLocation() {
}
////Description:Used toMake Disable Default CheckBox  as per task#23
function onSuccessfullEditPrinterDeviceLocation() {
}
function onSuccessfullSetPrinterDeviceLocation() {
}
function disableDefaultCheckBox() {
    var checkBoxDefault = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_' + CheckBoxDefault);

    checkBoxDefault.disabled = true;

}
function ClearPrinterControls(DropDownListLocations, CheckBoxActive, TextBoxPath, TextBoxDeviceLabel) {
    try {
        document.getElementById(DropDownListLocations).selectedIndex = 0;
        document.getElementById(CheckBoxActive).checked = false;
        document.getElementById(TextBoxPath).value = "";
        document.getElementById(TextBoxDeviceLabel).value = "";
    }
    catch (e) {
    }
}

function onHeaderPrinterClick(obj) {
    try {
        var sortBy = obj.getAttribute("SortOrder");
        var ColumnName = obj.getAttribute("ColumnName");
        if (sortBy == "") {
            sortBy = "Asc";

        }
        ColumnName = ColumnName + " " + sortBy;
        GetPrinterListOnHeaderClick(PanelPrinterList, ColumnName);

    }
    catch (e) {

    }
}

function ClearPrinterListFilters() {

    $("input[id$=_TextBoxDeviceLabel]").val("");
    $("input[id$=_TextBoxPath]").val("");
    $("input[id$=_CheckBoxActive]").attr("checked", false);
    $("select[id*=_DropDownListLocations]")[0].selectedIndex = 0;
    $("input[id$=buttonInsert]").attr('value', 'Insert');

    //$("input[id$=_DropDownListLocations]").val("");

}

function GetPrinterListOnHeaderClick(Panel, SortBy) {
    try {
        //document.getElementById('Control_ASP.usercontrols_pharmacymanagement_ascx_PharmaciesList1_PanelPharmacyList').Clear();
        // Create the WebRequest object.                
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("PrinterManagement.aspx?FunctionId=GetPrinterListOnHeaderClick&par0=" + SortBy + "&par1=" + document.getElementById("Control_ASP.usercontrols_printerdevice_ascx_HiddenRadioButtonValue").value);
        wRequest.add_completed(OnFillPrinterControlCompleted);
        wRequest.set_userContext(Panel);
        wRequest.set_httpVerb("Post");
        var executor = new Sys.Net.XMLHttpExecutor();
        wRequest.set_executor(executor);
        executor.executeRequest();
        var started = executor.get_started();
        PanelPrinterList = Panel;
        // alert("Executor started: " + started);
        ClearPrinterListFilters();
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}
function SetDefaultFocus(ConrolId) {
    try {
        var controlClietId = document.getElementById(ConrolId);
        if (controlClietId != null) {
            controlClietId.focus();
        }
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}
//Description:Used to clear pharmacy management control value 
function ClearPharmacyManagementControls() {
    try {
        $("input[id$=_TextBoxName]").val("");
        $("input[id$=_TextBoxPhone]").val("");
        $("input[id$=_TextBoxFax]").val("");
        $("textarea[id$=_TextBoxAddress]").val("");
        $("input[id$=_TextBoxCity]").val("");
        $("input[id$=_TextBoxZip]").val("");
        $("select[id*=_DropDownListState]")[0].selectedIndex = 0;
        $("input[id$=buttonInsert]").attr('value', 'Insert'); //
        $("input[id$=CheckBoxActive]").attr('checked', false);
        $("input[id$=CheckBoxPreferred]").attr('checked', false);


    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Function added by Loveena in ref to Task#86 to save CharCopyPrinterDeviceLocationId
function SetChartCopyPrinterDeviceLocation(dropDownList, locationId) {
    try {
        var dropDownList = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_' + dropDownList);
        var dropDownValue = dropDownList.options[dropDownList.selectedIndex].value;
        Streamline.SmartClient.WebServices.UserPreferences.UpdateChartCopyPrinterDeviceLocation(locationId, dropDownValue, onSuccessfullSetChartCopyPrinterDeviceLocation, onFailure);

    }
    catch (ex) {
    }
}

function onSuccessfullSetChartCopyPrinterDeviceLocation() {
}

//Function added in ref to Task#2595 to have unique answers
function CheckSecurityAnswerExists(tableSecrityQuestions) {
    var length = 0;
    var allValueExist = 0;
    try {
        var table = document.getElementById(tableSecrityQuestions);
        //Code added by Loveena in ref to Task#2595 to enter unique security answer.
        //check for all blank values
        for (var i = 0; i < table.rows.length; i++) {
            var row = table.rows[i];
            if ((i % 2) == 0) {
                // var answer = row.cells[3].getElementsByTagName("input")[0].value.replace(/^[\s]+/, '').replace(/[\s]+$/, '').replace(/[\s]{2,}/, ' ');
                var Question = row.cells[2].getElementsByTagName("select")[0].value;
                if (Question == -1) {
                    allValueExist = 0;
                }
                else {
                    allValueExist = 1;
                    break;
                }
            }
        }

        if (allValueExist == 1) {
            for (var i = 0; i < table.rows.length; i++) {
                var row = table.rows[i];
                if ((i % 2) != 0) {
                    for (var j = 0; j < table.rows.length; j++) {
                        var _Row = table.rows[j];
                        if ((j % 2) != 0) {
                            var previousAnswer = row.cells[3].getElementsByTagName("input")[0].value.replace(/^[\s]+/, '').replace(/[\s]+$/, '').replace(/[\s]{2,}/, ' ');
                            var nextAnswer = _Row.cells[3].getElementsByTagName("input")[0].value.replace(/^[\s]+/, '').replace(/[\s]+$/, '').replace(/[\s]{2,}/, ' ');
                            //added By Priya Ref: task No:3029
                            if (i != j) {
                                if (previousAnswer != '' && nextAnswer != '') {
                                    if (previousAnswer.toLowerCase() == nextAnswer.toLowerCase()) {


                                        length = (length + 1);
                                    }
                                }
                            }

                        }
                    }
                    //added By Priya Ref: task No:3029
                    //                if (length == 0 || length == 1) 
                    //                {
                    //                }
                    //return true;
                    if (length == 0) {
                        //objSecurityQuestionsRow.Answer = row.cells[3].getElementsByTagName("input")[0].value;
                    }
                    else {
                        return false;
                    }
                }
            }
        }
    }
    catch (ex) {
    }
}

//Function added in ref to Task#3029 to have  answers
function CheckAnswerExists(tableSecrityQuestions) {

    var Quesexist = 0;
    try {
        var objSecurityQuestionsRow;
        var table = document.getElementById(tableSecrityQuestions);
        for (var i = 0; i < table.rows.length; i++) {
            var row = table.rows[i];
            if ((i % 2) == 0) {
                objSecurityQuestionsRow = new SecurityQuestionsRow();
                objSecurityQuestionsRow.StaffSecurityQuestionId = row.cells[3].getElementsByTagName("input")[0].value;
                objSecurityQuestionsRow.Question = row.cells[2].getElementsByTagName("select")[0].value;
                if (objSecurityQuestionsRow.Question != -1) {
                    Quesexist = 1;
                }
                else
                    Quesexist = 0;
            }
            else
                objSecurityQuestionsRow.Answer = row.cells[3].getElementsByTagName("input")[0].value;
            if (Quesexist == 1 && objSecurityQuestionsRow.Answer == '')
                return false;

        }
    }
    catch (ex) {
    }
}
//added By Priya Ref: task No:2659
function GetUnformatedFormatedPharmacyPhone(PhoneNumber, TextBoxPhone) {
    try {
        var context = TextBoxPhone;
        Streamline.SmartClient.WebServices.UserPreferences.getUnformatedPhoneNumber(PhoneNumber, onSuccessfullUnFormatPharmacyPhoneNumber, onFailure, context)
    }
    catch (err) {
        alert(err.message);
    }
}
//Added By Priya Ref: task No:2659
function onSuccessfullUnFormatPharmacyPhoneNumber(result, context) {
    try {
        document.getElementById(context).value = result;
    }
    catch (err) {
        alert(err.message);
    }
}

//Added in ref to Task#85
function openPharmacySearch() {
    try {
        var _width = 0;
        if (document.body && document.body.offsetWidth) {
            _width = document.body.offsetWidth;
        } else if (window.innerWidth && window.innerHeight) {
            _width = window.innerWidth;
        }
        _width = _width < 960 ? _width : 960;

        parent.document.getElementById('HiddenPageName').value = ' ';
        parent.document.getElementById('HiddenFieldPharmacyId').value = '';

        var $divSearch = $("#DivSearchPharmacy");
        $("#topborder", $divSearch).text("Pharmacy Search");
        var $iFrameSearch = $('#iFramePharmacySearch', $divSearch);
        $iFrameSearch.attr('src', 'PharmacySearch.aspx?');
        $iFrameSearch.css({ 'width': (_width + "px"), 'height': '510px' });
        var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
        left = left > 0 ? left : 10;
        var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
        top = top > 0 ? top : 10;
        $divSearch.css({ 'top': top, 'left': left });
        $divSearch.draggable();
        $divSearch.css('display', 'block');
        fnHideParentDiv();
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
    return false;
}
//Ref:Task no:85
function FillPharmacySearchList(_textBoxName, _textBoxID, _textBoxPhone, _textBoxAddress, _textBoxCity, _dropDownListState, _textBoxZip, _textBoxSureScriptsIdentifier, _textBoxFax, _textBoxSpecialty, _currentPage) {
    try {
        var PharmacyName = document.getElementById(_textBoxName).value;
        var ID = document.getElementById(_textBoxID).value;
        var Phone = document.getElementById(_textBoxPhone).value;
        var Fax = document.getElementById(_textBoxFax).value;
        var Address = document.getElementById(_textBoxAddress).value;
        var State = document.getElementById(_dropDownListState).value;
        var City = document.getElementById(_textBoxCity).value;
        var Zip = document.getElementById(_textBoxZip).value;
        var SureScriptIdentifier = document.getElementById(_textBoxSureScriptsIdentifier).value;
        var Specialty = document.getElementById(_textBoxSpecialty).value;
        var Active;
        var context = new Object();
        context.TextBoxName = _textBoxName;
        context.TextBoxPhone = _textBoxPhone;
        context.ID = _textBoxID;
        context.TextBoxFax = _textBoxFax;
        context.TextBoxAddress = _textBoxAddress;
        context.DropDownListState = _dropDownListState;
        context.TextBoxCity = _textBoxCity;
        context.TextBoxZip = _textBoxZip;
        context.TextBoxSpecialty = _textBoxSpecialty;
        $.ajax({
            type: "POST",
            url: "./PharmacyManagement.aspx?FunctionId=GetSearchPharmaciesList",
            data: 'PharmacyId=' + ID + '&PharmacyName=' + PharmacyName + '&Phone=' + Phone + '&Address=' + Address + '&Fax=' + Fax + '&State=' + State + '&City=' + City + '&Zip=' + Zip + '&Specialty=' + Specialty + '&CurrentPage=0' + '&SureScriptIdentifier=' + SureScriptIdentifier + '',
            success: OnFillPharmacySearchControlCompleted,
            error: onFailure
        });
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}
//Ref:Task no:85
function OnFillPharmacySearchControlCompleted(result) {
    try {
        if (result.xml == undefined)
            var pageResponse = result;
        else
            var pageResponse = result.xml;
        var start = pageResponse.indexOf("##STARTPHARMACYSEARCH##") + 32;
        var end = pageResponse.indexOf("##ENDPHARMACYSEARCH##");
        pageResponse = pageResponse.substr(start, end - start).trim();
        if (pageResponse != undefined) {
            $("div[id$=PanelPharmaciesListSearchPage]")[0].innerHTML = pageResponse;
        }
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Function is made by Sahil Bhagat in ref of Task #85 on Feb. 9,2010
//Modified by Priya Ref:task no:85
function MergePharmacies1(HiddenFieldParentPharmacyId, HiddenFieldMergePharmacyId) {

    var mergePharmacyId;
    var ParentPharmacyId;
    if (HiddenFieldMergePharmacyId != null) {
        mergePharmacyId = HiddenFieldMergePharmacyId;
        parentPharmacyId = HiddenFieldParentPharmacyId;
        Streamline.SmartClient.WebServices.UserPreferences.MergePharmacy(parentPharmacyId, mergePharmacyId, onSucceededMergePharmacy, onFailureMergePharmacy);
    }

}
//After Successfuly Merge
function onSucceededMergePharmacy() {
    try {
        var value;
        if (parent.document.getElementById("Control_ASP.usercontrols_pharmacymanagement_ascx_HiddenRadioButtonValue") != null)
            value = "Active";
        else
            value = "All";
        window.returnValue = pharmacyId;
        window.close();
        closePharmacyDiv("F");
        parent.PharmacyManagement.GetPharmaciesList(value);
        parent.PharmacyManagement.SetRadioButton();
    }
    catch (e) {
    }
}
//Failure of Merging
function onFailureMergePharmacy() {
    try {
        alert("You have failed to update Pharmacy Table! Please try again.");
    }
    catch (e) {
    }
}
function encodeHtmlText(TextToEncode) {
    try {
        var encodedHtml = document.getElementById(TextToEncode).value;
        encodedHtml = encodedHtml.replace(/>/g, "%3E");
        encodedHtml = encodedHtml.replace(/</g, "%3C");
        document.getElementById(TextToEncode).value = encodedHtml;

    }
    catch (ex) {
    }
}

function GetSureScriptsPrescriberId(StaffId) {
    try {
        fnShow();
        Streamline.SmartClient.WebServices.UserPreferences.GetSureScriptsPrescriberId(StaffId, onSucceededGetSureScriptsPrescriberId, onFailure);
    }
    catch (ex) {
    }
}
function onSucceededGetSureScriptsPrescriberId(result) {
    try {
        if (result == undefined || result == '') {
            fnHideParentDiv();
            return;
        } else {
            fnShow();
            var StaffId = result.StaffId;
            var SurescriptsOrganizationId = result.SurescriptsOrganizationId;
            var OrganizationName = result.OrganizationName;
            var ActiveStartTime = result.ActiveStartTime;
            var ActiveEndTime = result.ActiveEndTime;
            var DEANumber = result.DEANumber;
            var NPI = result.NPI;
            var LastName = result.LastName;
            var FirstName = result.FirstName;
            var MiddleName = result.MiddleName;
            var NamePrefix = result.NamePrefix;
            var SpecialtyCode = result.SpecialtyCode;
            var City = result.City;
            var State = result.State;
            var Zip = result.Zip;
            var PhoneNumber = result.PhoneNumber;
            var FaxNumber = result.FaxNumber;
            var Email = result.Email;
            var SPI_Id = result.SPI_Id;
            var Address = result.Address;
            Streamline.SmartClient.WebServices.UserPreferences.GetPrescriberId(StaffId, SurescriptsOrganizationId, OrganizationName, ActiveStartTime, ActiveEndTime, DEANumber, NPI, LastName, FirstName, MiddleName, NamePrefix, SpecialtyCode, City, State, Zip, Address, PhoneNumber, FaxNumber, Email, SPI_Id, onSuccessPrescriberId, onFailure);
        }
    }
    catch (ex) {
    }
}

function onSuccessPrescriberId(result) {
    if (result == undefined || result == '') {
        fnHideParentDiv();
        return;
    } else {
        if (result[0] == "SUCCESS") {
            $("[id$=TextBoxSureScriptsPrescriberId]").val(result[1]);
            var registerButton = document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_ButtonRegister');
            $("[id$=HiddenSureScriptPrescriberId]").val(result[1]);
            if (document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_HiddenIsAdmin').value == 'Y') {
                //registerButton.value = "Update Registration";
                document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_HiddenIDGenerated').value = 'Y';
            }
            //if (registerButton.value == "Update Registration") {
            if (registerButton) registerButton.style.display = "none";
            $("#LabelRegisterSpan").text("SureScripts will be updated when the staff record is updated");
            $("[id$=ImageRegisterError]")[0].style.display = "none";
            var _labelRegistrationError = $("[id$=LabelRegisterError]")[0];
            _labelRegistrationError.style.display = "block";
            _labelRegistrationError.style.color = "green";
            _labelRegistrationError.innerText = "Registration Updated";
            //}
        }
        if (result[0] == "FAILURE") {
            $("[id$=ImageRegisterError]")[0].style.display = "block";
            var _labelRegistrationError = $("[id$=LabelRegisterError]")[0];
            _labelRegistrationError.style.display = "block";
            _labelRegistrationError.style.color = "red";
            _labelRegistrationError.innerText = result[1];
        }
        fnHideParentDiv();
    }
}

//added by priya
function PagingPharmacySearchList(_textBoxName, _textBoxID, _textBoxPhone, _textBoxAddress, _textBoxCity, _dropDownListState, _textBoxZip, _textBoxSureScriptsIdentifier, _textBoxFax, _textBoxSpecialty, HiddenCurrentPage) {
    try {
        var PharmacyName = document.getElementById(_textBoxName).value;
        var ID = document.getElementById(_textBoxID).value;
        var Phone = document.getElementById(_textBoxPhone).value;
        var Fax = document.getElementById(_textBoxFax).value;
        var Address = document.getElementById(_textBoxAddress).value;
        var State = document.getElementById(_dropDownListState).value;
        var City = document.getElementById(_textBoxCity).value;
        var Zip = document.getElementById(_textBoxZip).value;
        var SureScriptIdentifier = document.getElementById(_textBoxSureScriptsIdentifier).value;
        var Specialty = document.getElementById(_textBoxSpecialty).value;
        var Active;
        $.ajax({
            type: "POST",
            url: "./PharmacyManagement.aspx?FunctionId=GetSearchPharmaciesList",
            data: 'PharmacyId=' + ID + '&PharmacyName=' + PharmacyName + '&Phone=' + Phone + '&Address=' + Address + '&Fax=' + Fax + '&State=' + State + '&City=' + City + '&Zip=' + Zip + "&Specialty=" + Specialty + '&CurrentPage=' + HiddenCurrentPage + '&SureScriptIdentifier=' + SureScriptIdentifier + '',
            success: OnFillPharmacySearchControlCompleted,
            error: onFailure
        });
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}

//Added by Loveena in ref to Task#3215
function MergePharmacies(DetailPharmacyId, SearchPharmacyId) {
    try {
        Streamline.SmartClient.WebServices.UserPreferences.MergePharmacies(DetailPharmacyId, SearchPharmacyId, onSuccessMergePharmacy, onFailure);
    }
    catch (e) {
    }
}

function onSuccessMergePharmacy(result) {
    try {
        if (result == undefined || result == '')
            return;
        else {
            if (parseInt(result.tables[0].rows[0]["MergeStatus"]) == 0) {
                var PreferredPharmacyId = parent.$("[id$=HiddenFieldParentSelectedPharmacyId]").val();
                var SureScriptsPharmacyId = parent.$("[id$=HiddenFieldPharmacyId]").val();
                Streamline.SmartClient.WebServices.UserPreferences.MergePharmacy(PreferredPharmacyId, SureScriptsPharmacyId, onSucceededMergePharmacy, onFailure);
            }
            else
                ShowPharmacyError(true, result.tables[1].rows[0]["MergeMessage"].toString());
        }
    }
    catch (e) {
    }
}

function ShowPharmacyError(ShowMessage, Message) {
    var LabelErrorMessage = $('[id$=LabelErrorMessage]')[0];
    var ImageError = $('[id$=ImageError]')[0];
    LabelErrorMessage.innerText = '';
    ImageError.style.visibility = 'hidden';
    ImageError.style.display = 'none';
    if (ShowMessage == true) {
        $('[id$=ImageError]')[0].style.visibility = 'visible';
        $('[id$=ImageError]')[0].style.display = 'block';
        $('[id$=LabelErrorMessage]')[0].style.display = 'block';
        $('[id$=LabelErrorMessage]')[0].style.visibility = 'visible';
        $('[id$=LabelErrorMessage]')[0].innerText = Message;
        return false;
    }
    else {
        if (ShowMessage == false) {
            $('[id$=ImageError]')[0].style.visibility = 'hidden';
            $('[id$=ImageError]')[0].style.display = 'none';
            $('[id$=LabelErrorMessage]')[0].style.display = 'none';
            $('[id$=LabelErrorMessage]')[0].style.visibility = 'hidden';
            $('[id$=LabelErrorMessage]')[0].innerText = '';
            return false;
        }
    }
}

function Select_Click() {
    if (parent.document.getElementById('HiddenFieldCheckButtonStatus') != null) {
        if (parent.document.getElementById('HiddenFieldCheckButtonStatus').value == 'S' && parent.document.getElementById('HiddenPageName').value != 'PreferredPharmacies') {
            var PharmacyId = parent.document.getElementById('HiddenFieldPharmacyId').value;
            SetReturnValues(parent.document.getElementById('HiddenFieldPharmacyId').value, parent.document.getElementById('HiddenFieldExternalReferenceId').value);
        }
    }
    if (parent.document.getElementById('HiddenPageName').value == 'MedicationsPrescribe' || (parent.document.getElementById('HiddenPageName').value == ' ' && parent.document.getElementById('HiddenFieldCheckButtonStatus').value != 'S')) {
        var PharmacyId = parent.document.getElementById('HiddenFieldPharmacyId').value;
        Streamline.SmartClient.WebServices.UserPreferences.SavePreferredPharmacy(PharmacyId, onSuccessSavePreferredPharmacy, onFailure);
    }
    if (parent.document.getElementById('HiddenPageName').value == 'PreferredPharmacies') {
        SetReturnValues(parent.document.getElementById('HiddenFieldPharmacyId').value, parent.document.getElementById('HiddenFieldExternalReferenceId').value);
    }
}

function onSuccessSavePreferredPharmacy() {
    SetReturnValues(parent.document.getElementById('HiddenFieldPharmacyId').value, parent.document.getElementById('HiddenFieldExternalReferenceId').value);
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
            step: 1
        });
        //document.getElementById('buttonInsert').disabled=false;
    }
    catch (e) {
        Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
    }
}
function ValidateDateField(TextBox) {
    var _txtBox = document.getElementById(TextBox);
    var objNaturalPattern = /^(?=\d)(?:(?:(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2}))($|\ (?=\d)))?(((0?[1-9]|1[012])(:[0-5]\d){0,2}(\ [AP]M))|([01]\d|2[0-3])(:[0-5]\d){1,2})?$/;
    //var objNaturalPattern = /^[0-9\/]+$/;

    if (_txtBox.value.length > 0) {
        if (_txtBox.value.match(objNaturalPattern) == null) {
            _txtBox.value = '';
            _txtBox.focus();

            return false;
        }
        else {
            return true;
        }
    }
    else {

        return true;
    }
}

var UserManagementSortField = "";
var UserManagementSearchField = "";

function SearchUserManagementListPage(obj) {
    Errormessage('hide');
    Successmessage('hide');
    PasswordErrormessage('hide');

    if ($(obj).attr('id') == 'UserMangementResetButton') {
        $("#UserMangementSearchText").val("");
        UserManagementSearchField = "";
    } else {
        UserManagementSearchField = $("#UserMangementSearchText").val();
    }
    SortUserManagementListPage(UserManagementSortField, UserManagementSearchField);
}

function ChangeUserActiveUsermanagementListPage() {
    Errormessage('hide');
    Successmessage('hide');
    PasswordErrormessage('hide');
    SortUserManagementListPage(UserManagementSortField, UserManagementSearchField);
}

function SortUserManagementListPage(sortField, filterField) {
    UserManagementSortField = sortField;
    filterField = filterField || UserManagementSearchField;
    fnShow();
    var activeUsersOnly = $("[id$=RadioButtonActiveUsers]")[0].checked;
    var prescribersOnly = $("[id$=RadioButtonAllPrescribers]")[0].checked;
    var epcsprescribers = $("[id$=RadioButtonAllEPCSPrescribers]")[0].checked;
    $("#HiddenControlPath").val("~/UserControls/UserManagement.ascx");
    $.ajax({
        type: "POST",
        url: "./ApplicationForm.aspx",
        data: { 'sortField': sortField, "activeUsersOnly": (activeUsersOnly == true ? "Y" : "N"), 'searchField': filterField, "prescribersOnly": (prescribersOnly == true ? "Y" : "N"), "epcsprescribers": (epcsprescribers == true ? "Y" : "N") },
        success: onSortUserManagementListPage,
        error: onFailure
    });
}
function onSortUserManagementListPage(result) {
    var start = result.indexOf('<!-- ###StartUserManagement### -->') + 34;
    var end = result.indexOf('<!-- ###EndUserManagement### -->');
    var pageResponse = result;
    pageResponse = pageResponse.substr(start, end - start);
    if (pageResponse != undefined) {
        $("[id$='PanelUserManagement']").html(pageResponse);
    }
    fnHideParentDiv();
}


function EPCSvalidation() {

    var idValues = new Array();
    $("input:checkbox:checked").each(function () {
        idValues.push($(this).attr('keyid'));
    })
    selected = idValues;

    Successmessage('hide');
    Errormessage('hide');
    PasswordErrormessage('hide');
    password = $("[id$='UserMangementPassword']").val();
    otp = $("[id$='UserMangementOTP']").val();
    if (password == "" && otp == "") {
        $('[id$=ImageError]')[0].style.display = 'block';
        $('[id$=ImageError]')[0].style.visibility = 'visible';
        $('[id$=LabelErrorMessage]')[0].innerText = 'Please enter Password and Token #/OTP ';
        return false;
    }
    else if (password == "") {
        $('[id$=ImageError]')[0].style.display = 'block';
        $('[id$=ImageError]')[0].style.visibility = 'visible';
        $('[id$=LabelErrorMessage]')[0].innerText = 'Please enter Password';
        return false;
    }
    else if (otp == "") {
        $('[id$=ImageError]')[0].style.display = 'block';
        $('[id$=ImageError]')[0].style.visibility = 'visible';
        $('[id$=LabelErrorMessage]')[0].innerText = 'Please enter Token #/OTP ';
        return false;
    }
    else if (selected == "") {
        $('[id$=ImageError]')[0].style.display = 'block';
        $('[id$=ImageError]')[0].style.visibility = 'visible';
        $('[id$=LabelErrorMessage]')[0].innerText = 'Please select a Staff from the list';
        return false;
    }

    else {
        $('[id$=ImageError]')[0].style.display = 'none';
        $('[id$=ImageError]')[0].style.visibility = 'hidden';
        $('[id$=LabelErrorMessage]')[0].innerText = '';
        return true;
    }

}

function EnableEPCS() {
    if (EPCSvalidation()) {

        $.ajax({
            type: "POST",
            url: "./AjaxScript.aspx?functionName=Updatestaff",
            data: 'selectedstaff=' + selected + '&enable=' + 'Y' + '&password=' + password + '&otp=' + otp,
            success: Updatestaff
        });
    }
}

function DisableEPCS() {
    //debugger;
    if (EPCSvalidation()) {
        $.ajax({
            type: "POST",
            url: "./AjaxScript.aspx?functionName=Updatestaff",
            data: 'selectedstaff=' + selected + '&enable=' + 'N' + '&password=' + password + '&otp=' + otp,
            success: UpdatestaffDisabled
        });
    }
}

function Updatestaff(result) {
    //debugger;
    $("[id$='UserMangementPassword']").val('');
    $("[id$='UserMangementOTP']").val('');
    ChangeUserActiveUsermanagementListPage();
    selected = [];
    password = '';
    otp = '';
    if (result == 'Fail') {
        Successmessage('hide');
        PasswordErrormessage('hide');
        Errormessage('show');
        return false;
    }
    if (result == 'PasswordFail') {
        Successmessage('hide');
        Errormessage('hide');
        PasswordErrormessage('show');
        return false;
    }
    else if (result == 'Success') {
        Successmessage('show');
        Errormessage('hide');
        PasswordErrormessage('hide');
        return false;
    }
}


function UpdatestaffDisabled(result) {
    //debugger;
    $("[id$='UserMangementPassword']").val('');
    $("[id$='UserMangementOTP']").val('');
    ChangeUserActiveUsermanagementListPage();
    selected = [];
    password = '';
    otp = '';
    if (result == 'Fail') {
        Successmessage('hide');
        PasswordErrormessage('hide');
        Errormessage('show');
        return false;
    }
    if (result == 'PasswordFail') {
        Successmessage('hide');
        Errormessage('hide');
        PasswordErrormessage('show');
        return false;
    }
    else if (result == 'Success') {
        SuccessmessageDisabled('show');
        Errormessage('hide');
        PasswordErrormessage('hide');
        return false;
    }
}

//function CheckSelectedItem(checkboxID, selectedid) {
//    //$("[id$='UserMangementPassword']").val('');
//    //$("[id$='UserMangementOTP']").val('');
//    var checkbox = document.getElementById(checkboxID);
//    Errormessage('hide');
//    Successmessage('hide');
//    PasswordErrormessage('hide');
//    var staffid = selectedid;
//    if (checkbox.checked) {
//        selected.push(staffid);

//    }
//    else {
//        for (var i = selected.length; i--;) {
//            if (selected[i] === staffid) selected.splice(i, 1);
//        }
//    }
//}

function Successmessage(res) {
    if (res == 'hide') {
        $('[id$=ImageSuccess]')[0].style.display = 'none';
        $('[id$=ImageSuccess]')[0].style.visibility = 'hidden';
        $('[id$=LabelSuccessMessage]')[0].innerText = '';
    }
    else if (res == 'show') {
        $('[id$=ImageSuccess]')[0].style.display = 'block';
        $('[id$=ImageSuccess]')[0].style.visibility = 'visible';
        $('[id$=LabelSuccessMessage]')[0].innerText = 'Staff enabled for EPCS.';
    }

}


function SuccessmessageDisabled(res) {
    if (res == 'hide') {
        $('[id$=ImageSuccess]')[0].style.display = 'none';
        $('[id$=ImageSuccess]')[0].style.visibility = 'hidden';
        $('[id$=LabelSuccessMessage]')[0].innerText = '';
    }
    else if (res == 'show') {
        $('[id$=ImageSuccess]')[0].style.display = 'block';
        $('[id$=ImageSuccess]')[0].style.visibility = 'visible';
        $('[id$=LabelSuccessMessage]')[0].innerText = 'Staff disabled for EPCS.';
    }

}
function Errormessage(res) {
    if (res == 'hide') {
        $('[id$=ImageError]')[0].style.display = 'none';
        $('[id$=ImageError]')[0].style.visibility = 'hidden';
        $('[id$=LabelErrorMessage]')[0].innerText = '';
    }
    else if (res == 'show') {
        $('[id$=ImageError]')[0].style.display = 'block';
        $('[id$=ImageError]')[0].style.visibility = 'visible';
        $('[id$=LabelErrorMessage]')[0].innerText = 'One Time Password provided is incorrect';
    }

}

function PasswordErrormessage(res) {
    if (res == 'hide') {
        $('[id$=ImageError]')[0].style.display = 'none';
        $('[id$=ImageError]')[0].style.visibility = 'hidden';
        $('[id$=LabelErrorMessage]')[0].innerText = '';
    }
    else if (res == 'show') {
        $('[id$=ImageError]')[0].style.display = 'block';
        $('[id$=ImageError]')[0].style.visibility = 'visible';
        $('[id$=LabelErrorMessage]')[0].innerText = 'Password is incorrect';
    }

}
function DeleteUserPreferencesInfromations() {
    Streamline.SmartClient.WebServices.UserPreferences.DeleteUserPreferenceInformation(onUserPreferencesSucceeded, onUserPreferencesFailure);
}
function onUserPreferencesSucceeded() {
    OpenStartPage();
}
function onUserPreferencesFailure() {

}