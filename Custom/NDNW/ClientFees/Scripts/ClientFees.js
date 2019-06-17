//This is the override function To Attach events on each controls
/*********
Created By: Amit Kumar Srivastava
Date : Dec 12, 2010
*********/
function AddEventHandlers() {

    try {//debugger;
        MemberFeesFunctions.BindInsertClick();
        MemberFeesFunctions.BindClearClick();
        MemberFeesFunctions.BindOnchange();

        SetLocationDD(AutoSaveXMLDom);
        SetProgramDD(AutoSaveXMLDom);
    }
    catch (err) {
        LogClientSideException(err, 'AddEventHandlers');
    }

}

SetLocationDD = (function(dom) {
    //debugger;
    $("[id$=LocationDD]").multipleSelect({
        selectAll: false
    });
    $("[id$=LocationDD]").multipleSelect("uncheckAll");

});


SetProgramDD = (function(dom) {
    //debugger;
    $("[id$=ProgramDD]").multipleSelect({
        selectAll: false
    });
    $("[id$=ProgramDD]").multipleSelect("uncheckAll");

});


function AddParentChildRadioClickEventHandler(key) {
    //debugger
    if ($('[id$=HiddenField_CustomClientFees_ProgramsText]').val() == '') {
        $('[id$=HiddenField_CustomClientFees_Programs]').val('');
    }
    if ($('[id$=HiddenField_CustomClientFees_LocationsText]').val() == '') {
        $('[id$=HiddenField_CustomClientFees_Locations]').val('');
    }

    //var programarray = $('[id$=HiddenField_CustomClientFees_Programs]').val(SelectedLocationsText.split(','));
    var Programarray = $('[id$=HiddenField_CustomClientFees_Programs]').val().split(',');
    var Locationarray = $('[id$=HiddenField_CustomClientFees_Locations]').val().split(',');

    if (Programarray.length > 0) {
        $("[id$=ProgramDD]").multipleSelect("setSelects", Programarray);
    }

    if (Locationarray.length > 0) {
        $("[id$=LocationDD]").multipleSelect("setSelects", Locationarray);
    }
}


//This is the override function To Manage ToolBar Items
/*********
Created By: Amit Kumar Srivastava
Date : Dec 19, 2010
*********/
function ManageToolbarItems() {

    HideDetailToolbarItems('New');
    HideDetailToolbarItems('Delete');
    HideDetailToolbarItems('Help');
}

//This is the override function To Set screen Specific Values
/*********
Created By: Amit Kumar Srivastava
Date : Dec 16, 2010
*********/
function SetScreenSpecificValues(dom, action) {
    //debugger;
    try {
        MemberFeesFunctions.clientMemberfeeids.val('');
        MemberFeesFunctions.clientMemberfeeids.css('background-color', '#EBE4D5');
        MemberFeesFunctions.clientMemberfeeids.css('color', '#000');
        // alert(FilterGlobalCodes(varGlobalCodeCategoriesRequiredOnClientSide, 'Category', 'PROGRAMSTATUS'));
    }
    catch (err) {
        LogClientSideException(err, 'SetScreenSpecificValues');
    }
}

//All controls which is need to manually validation
/*********
Created By: Amit Kumar Srivastava
Date : Dec 15, 2010
*********/
function ValidateDataForParentChildGridEventHandler() {
    //debugger;
    try {
        /***Validate Dates***/
        //return ValidateDataForParentChildGridEventHandler1();
        if (MemberFeesFunctions.ValidateMemberFees() == true || MemberFeesFunctions.MemberFee.val() == '') {
            if ((MemberFeesFunctions.ValidateDateApplyFilterudf('[id$=TextBox_CustomClientFees_StartDate]', '[id$=TextBox_CustomClientFees_EndDate]', true) == 'undefined')) {
                return MemberFeesFunctions.validateParentchild();
            }
            else {
                var result = MemberFeesFunctions.ValidateDateApplyFilterudf('[id$=TextBox_CustomClientFees_StartDate]', '[id$=TextBox_CustomClientFees_EndDate]', true);
                if (result == true) {
                    return MemberFeesFunctions.validateParentchild();
                }
                else {
                    return false;
                }
            }
            ShowHideErrorMessage("", 'false');
        }
        else {
            ShowHideErrorMessage("Please enter correct Member Fees.", 'true');
            MemberFeesFunctions.MemberFee.val('');
            MemberFeesFunctions.MemberFee.focus();
            return false;
        }
    }
    catch (err) {
        LogClientSideException(err, 'ValidateDataForParentChildGridEventHandler');
    }
}
var MemberFeesFunctions = {
    begindate: $('[id$=TextBox_CustomClientFees_StartDate]'),
    enddate: $('[id$=TextBox_CustomClientFees_EndDate]'),
    MemberFee: $('[id$=TextBox_CustomClientFees_StandardRatePercentage]'),
    Comment: $('[id$=TextArea_CustomClientFees_Comment]'),
    Memberfeeid: $('[id$=TextBox_CustomClientFees_ClientFeeId]'),
    BtnInsert: $('[id$=TableChildControl_CustomClientFees_ButtonInsert]'),
    HFMemberfeeid: $('[id$=HiddenField_CustomClientFees_ClientFeeId]'),
    HFPrimaryKey: $('[id$=HiddenFieldPrimaryKey]'),
    clientMemberfeeids: $('[id$=TextBox_CustomClientFees_ClientFeeId]'),

    clientStandaredPercentage: $('input[id$=HiddenField_CustomClientFees_StandardRatePercentage1]'),
    //clientStandaredPercentage: $('input[id$=HiddenField_CustomClientFees_StandardRatePercentage1]').val().indexof('%') == -1?null:$('input[id$=HiddenField_CustomClientFees_StandardRatePercentage1]'),   
    Location: $('[id$=LocationDD]'),
    Program: $('[id$=ProgramDD]'),
    statusforinsert: 0,
    ///bind page control and page default view
    ValidateMemberFees: function() {
        //debugger;
        if (MemberFeesFunctions.MemberFee.val() != "") {
            var arrayOfStrings = new Array();
            arrayOfStrings = MemberFeesFunctions.MemberFee.val().split(".");
            if (arrayOfStrings.length <= 2) {
                //alert(parseFloat(MemberFeesFunctions.MemberFee.val()));
                if (isNaN(parseFloat(MemberFeesFunctions.MemberFee.val()))) {
                    ShowHideErrorMessage("Please enter correct Member Fees.", 'true');
                    return false;
                }
                else if (parseFloat(MemberFeesFunctions.MemberFee.val()) >= 1 && parseFloat(MemberFeesFunctions.MemberFee.val()) <= 100) {
                    ShowHideErrorMessage("", 'false');
                    return true;
                }
                else {
                    ShowHideErrorMessage("Please enter correct Member Fees.", 'true');
                    return false;
                }
            }
            else {
                ShowHideErrorMessage("Please enter correct Member Fees.", 'true');
                return false;
            }
        }
    },

    ///bind page control and page default view
    ClearValues: function() {
        //debugger;
        MemberFeesFunctions.begindate.val('');
        MemberFeesFunctions.enddate.val('');
        MemberFeesFunctions.MemberFee.val('');
        MemberFeesFunctions.Comment.val('');
        MemberFeesFunctions.Memberfeeid.val('');
        MemberFeesFunctions.clientStandaredPercentage.val('');
        MemberFeesFunctions.clientStandaredPercentage.val('');
        MemberFeesFunctions.clientStandaredPercentage.val('');
        $("[id$=LocationDD]").multipleSelect("uncheckAll");
        $("[id$=ProgramDD]").multipleSelect("uncheckAll");
        $("[id$=TextBox_CustomClientFees_Rate]").val('');


        if (MemberFeesFunctions.BtnInsert.val() == "Modify") {
            MemberFeesFunctions.BtnInsert.val('Insert');
        }
        MemberFeesFunctions.HFMemberfeeid.val('');
    },

    ///bind page control and page default view
    BindInsertClick: function() {
        //debugger;
        $("input[id$=TableChildControl_CustomClientFees_ButtonInsert]").bind('click', function() {
            //debugger;

            if ($('[id$=TextBox_CustomClientFees_StandardRatePercentage]').val() != "" && $('[id$=TextBox_CustomClientFees_Rate]').val() != "") {
                ///please select any relation
                ShowHideErrorMessage("Please enter Standard Rate Percentage or Rate", 'true');
                return false;
            }
            var SelectedLocations = $("[id$=LocationDD]").multipleSelect("getSelects");
            $('[id$=HiddenField_CustomClientFees_Locations]').val(SelectedLocations.join(','));


            var SelectedLocationsText = $("[id$=LocationDD]").multipleSelect("getSelects", "text");
            $('[id$=HiddenField_CustomClientFees_LocationsText]').val(SelectedLocationsText.join(','));


            var SelectedPrograms = $("[id$=ProgramDD]").multipleSelect("getSelects");
            $('[id$=HiddenField_CustomClientFees_Programs]').val(SelectedPrograms.join(','));


            var SelectedProgramsText = $("[id$=ProgramDD]").multipleSelect("getSelects", "text");
            $('[id$=HiddenField_CustomClientFees_ProgramsText]').val(SelectedProgramsText.join(','));


         

            if (MemberFeesFunctions.ValidateMemberFees() == true) {
                MemberFeesFunctions.clientStandaredPercentage.val(MemberFeesFunctions.MemberFee.val() + '%');
            }
           else {
               //MemberFeesFunctions.clientStandaredPercentage.val('');
               if ($('[id$=TextBox_CustomClientFees_StandardRatePercentage]').val() == "" && $('[id$=TextBox_CustomClientFees_Rate]').val() != "") {
                   $('[id$=HiddenField_CustomClientFees_StandardRatePercentage1]').val($('[id$=TextBox_CustomClientFees_Rate]').val())
               }
            }

//            if ($('[id$=TextBox_CustomClientFees_StandardRatePercentage]').val() == "" && $('[id$=TextBox_CustomClientFees_Rate]').val() != "") {
//                $('[id$=HiddenField_CustomClientFees_StandardRatePercentage1]').val($('[id$=TextBox_CustomClientFees_Rate]').val())
//            }
//            else {
//                $('[id$=HiddenField_CustomClientFees_StandardRatePercentage1]').val($('[id$=TextBox_CustomClientFees_StandardRatePercentage]').val())
//            }
            
            
            //alert(MemberFeesFunctions.MemberFee.val() + ' save ' + MemberFeesFunctions.clientStandaredPercentage.val());
            InsertGridData('TableChildControl_CustomClientFees', 'InsertGridClientFees', 'CustomGridClientFees', this);
            if (MemberFeesFunctions.statusforinsert == 1) {
                MemberFeesFunctions.ClearValues();
                MemberFeesFunctions.statusforinsert = 0;
            }
        });
    },

    ///bind page control and page default view
    BindClearClick: function() {
        //debugger;
        $("input[id$=TableChildControl_CustomClientFees_ButtonClear]").bind('click', function() {
            MemberFeesFunctions.ClearValues();
        });
    },

    ///bind page control and page default view
    BindOnchange: function() {
        //debugger;
        $("input[id$=TextBox_CustomClientFees_StandardRatePercentage]").bind('change', function() {
            MemberFeesFunctions.ValidateMemberFees();
        });
    },

    //check for datetime
    ValidateDateApplyFilterudf: function(fromDate, toDate, isBlankAllowed) {
        //debugger;

        var _FromDate = $("#" + fromDate).val();
        var _ToDate = $("#" + toDate).val();

        if (isBlankAllowed) {
            if (_FromDate == '' && _ToDate == '') {
                return true;
            }
        }
        if (_FromDate == "" || _FromDate == undefined) {
            ShowHideErrorMessage("Please enter correct Begin Date.", 'true');
            $("#" + fromDate).focus();
            return false;
        }


        if (isDate(_FromDate, 'From') == false) {

            return false;
        }

        //  alert(_ToDate);

        //        if (_ToDate == "" || _ToDate == undefined) {
        //            ShowHideErrorMessage("Please enter correct End Date.", 'true');
        //            $("#" + toDate).focus();
        //            return false;
        //        }

        if (!Date.parse(_FromDate)) {
            ShowHideErrorMessage("Please enter correct Begin Date.", 'true');
            $("#" + fromDate).val('');
            $("#" + fromDate).focus();
            return false;
        }
        if (_ToDate != "") {
            if (isDate(_ToDate, 'To') == false) {

                return false;
            }
            if (!Date.parse(_ToDate)) {
                ShowHideErrorMessage("Please enter correct End Date.", 'true');
                $("#" + toDate).val('');
                $("#" + toDate).focus();
                return false;
            }
            if (Date.parse(_FromDate) <= Date.parse(_ToDate)) {
                //GetListPageWithFilters();
                ShowHideErrorMessage("", 'false');
                return true;

            }
            else {
                ShowHideErrorMessage("Start Date should be less than End Date.", 'true');
                $("#" + toDate).focus();
                return false;
            }
        }
        else {
            return true;
        }
    },

    //Validate dates already exists
    ValidateDataForParentChildGridEvents: function() {
        //debugger;
        var isExist = false;
        var Begindates = $('[id$=TextBox_CustomClientFees_StartDate]').val();
        var Enddates = $('[id$=TextBox_CustomClientFees_EndDate]').val();
        var HFPKey = $('[id$=HiddenField_CustomClientFees_ClientFeeId]').val();
        var tables = $('table[id$=CustomGridClientFees_GridViewInsert_DXMainTable] tr[id*=CustomGridClientFees_GridViewInsert_DXDataRow] > td');
        var modifiedid = 0;
        if (MemberFeesFunctions.BtnInsert.val() == "Modify") {
            modifiedid = 1;
        }
        if (Begindates == "" && Enddates == "") {
            ShowHideErrorMessage('Begin Date, End Date should not be blank.', 'true');
            return false;
        }
        else if (Begindates != "" || Enddates != "") {
            if (Begindates == "") {
                ShowHideErrorMessage('Begin Date should not be blank.', 'true');
                return false;
            }
            var i = 2;
            var j = 0;
            var k = 0;
            var l = 0;
            if (tables.length > 0) {
                //                if (Enddates == "") {
                //                    ShowHideErrorMessage('End date Will not be blank.', 'true');
                //                    return false;
                //                }
                tables.each(function() {
                    if (isExist == false) {
                        var startdates = "";
                        var lastdates = "";
                        var modifiedprimaryid = "";
                        j = j + 1;
                        if (j == i) {
                            k = i + 1;
                            l = i + 6;
                            startdates = tables[i].innerText;
                            lastdates = tables[k].innerText;
                            modifiedprimaryid = tables[l].innerText;
                            i = i + 21;
                            k = i;
                        }
                        if (startdates != "" || lastdates != "") {
                            if (lastdates == "") {
                                if ((Date.parse(Begindates) < Date.parse(startdates)) && (Date.parse(Enddates) < Date.parse(startdates))) {
                                    if (Enddates == "") {
                                        isExist = true;
                                    }
                                }
                                else {
                                    isExist = true;
                                }
                                if (isExist == true && modifiedid != 0) {
                                    //alert("7");
                                    if (HFPKey == parseInt(modifiedprimaryid)) {
                                        // alert("8");
                                        isExist = false;
                                    }
                                    else {
                                        //alert("9");
                                        isExist = true;
                                    }
                                }
                            }
                            if (startdates != "" && lastdates != "") {
                                if (Enddates == "") {
                                    if ((Date.parse(startdates) < Date.parse(Begindates)) && (Date.parse(lastdates) < Date.parse(Begindates))) {
                                    }
                                    else {
                                        isExist = true;
                                    }
                                }
                                else {
                                    //alert("1");
                                    if ((Date.parse(startdates) <= Date.parse(Begindates)) && (Date.parse(lastdates) >= Date.parse(Enddates))) {
                                        //alert("2");
                                        isExist = true;
                                    }
                                    if ((Date.parse(startdates) >= Date.parse(Begindates)) && (Date.parse(lastdates) <= Date.parse(Enddates))) {
                                        //alert("3");
                                        isExist = true;
                                    }
                                    if ((Date.parse(startdates) <= Date.parse(Begindates)) && (Date.parse(lastdates) <= Date.parse(Enddates)) && (Date.parse(Begindates) <= Date.parse(lastdates))) {
                                        //alert("4");
                                        isExist = true;
                                    }
                                    if ((Date.parse(startdates) >= Date.parse(Begindates)) && (Date.parse(lastdates) >= Date.parse(Enddates)) && (Date.parse(Enddates) >= Date.parse(startdates))) {
                                        // alert("5");
                                        isExist = true;
                                    }

                                    //alert("6" + " startdates >= Begindates) && (lastdates <= Enddates " + startdates + " >= " + Begindates + " && " + lastdates + "<=" + Enddates);
                                    if (isExist == true && modifiedid != 0) {
                                        // alert("7");
                                        if (HFPKey == parseInt(modifiedprimaryid)) {
                                            //alert("8");
                                            isExist = false;
                                        }
                                        else {
                                            //alert("9");
                                            isExist = true;
                                        }
                                    }
                                    // alert("10");
                                }
                            }
                        }
                    }
                }

        );
            }

            else {

            }
            if (isExist == false) {
                return true;
            }
            else {
                ShowHideErrorMessage('Date range already exists.', 'true');
                return false;
            }
        }
    },

    //Function For existing dates ParentChildGrid
    validateParentchild: function() {
        //debugger;
        var result = MemberFeesFunctions.ValidateDataForParentChildGridEvents();
        if (result == true) {
            MemberFeesFunctions.statusforinsert = 1;
            return result;
        }
        else {
            return false;
        }
    }
}
function AddParentChildDeleteImageEventHandler(GridtableName, object) {
    //alert("AddParentChildDeleteImageEventHandler");
    MemberFeesFunctions.ClearValues();
}