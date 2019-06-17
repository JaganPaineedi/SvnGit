var data = { LifeDomainProblem: [{ Id: 0, RelapseLifeDomainId: 0, DocumentVersionId: 0, LifeDomainDetail: '', LifeDomain: '', Resources: '', Barriers: '', LifeDomainNumber: 0}] };
var LifeDomainProblems = data.LifeDomainProblem;
var _LifeDomainId = 0;
var _DocumentVersionId = 0;
var tabAferCareClicked = false;
var LifeDomainCount = 0;


//var openNewpage;
/*Override Architectural functions */
function SetCurrentTab(sender, e) {
    //try {
    //    TabIndex = sender.activeTabIndex;
    //}
    //catch (err) { }
}

function onTabSelectedClient(sender, args) {
    onTabSelected(sender, args, false);
}
function StoreTabstripClientObject(sender) {

    tabobject = sender;
}


$.views.helpers({
    GetDropDownHtmlDropdowns: function(DropDownType, RelapseLifeDomainId, DropDownValue) {

        if (DropDownType == "LifeDomain") {
            var text = $("select[id$=DropDownList_CustomRelapseLifeDomains_LifeDomain]").html();
            text = text.replace('selected="selected"', '');
            text = text.replace('value="' + DropDownValue + '"', 'selected="selected"' + ' value="' + DropDownValue + '"');
            return text;
        }

        if (DropDownType == "RelapseGoalStatus") {
            var text = $("select[id$=DropDownList_CustomRelapseGoals_RelapseGoalStatus]").html();
            text = text.replace('selected="selected"', '');
            text = text.replace('value="' + DropDownValue + '"', 'selected="selected"' + ' value="' + DropDownValue + '"');
            return text;
        }

        if (DropDownType == "ObjectiveStatus") {
            var text = $("select[id$=DropDownList_CustomRelapseObjectives_ObjectiveStatus]").html();
            text = text.replace('selected="selected"', '');
            text = text.replace('value="' + DropDownValue + '"', 'selected="selected"' + ' value="' + DropDownValue + '"');
            return text;
        }

        if (DropDownType == "ActionStepStatus") {
            var text = $("select[id$=DropDownList_CustomRelapseActionSteps_ActionStepStatus]").html();
            text = text.replace('selected="selected"', '');
            text = text.replace('value="' + DropDownValue + '"', 'selected="selected"' + ' value="' + DropDownValue + '"');
            return text;
        }

    }
});

SetScreenSpecificValues = (function(dom, action) {
    try {
        //debugger;
        if (TabIndex == 1) {
            if ($.xmlDOM(objectPageResponse.PageDataSetXml).find("CustomRelapseLifeDomains").length > 0) {
                LifeDomainProblems[0].DocumentVersionId = dom.find("CustomRelapseLifeDomains:first DocumentVersionId").text();
                _DocumentVersionId = dom.find("CustomRelapseLifeDomains:first DocumentVersionId").text();

                dom.find("CustomRelapseLifeDomains").each(function() {

                    $(this).children().each(function() {
                        if (this.tagName == "RelapseLifeDomainId") {
                            if (parseInt($(this).text()) < 0 && _LifeDomainId <= 0 && _LifeDomainId > parseInt($(this).text())) {
                                _LifeDomainId = parseInt($(this).text());

                            }
                        }
                    });
                });

                if (_DocumentVersionId = 0)
                    _DocumentVersionId = dom.find("CustomDocumentRelapsePreventionPlans:first DocumentVersionId").text();
                if (_DocumentVersionId == 0)
                    _DocumentVersionId = -1;
            }
            else {
                _DocumentVersionId = dom.find("CustomDocumentRelapsePreventionPlans:first DocumentVersionId").text();
            }

            if (tabAferCareClicked == false) {
                tabAferCareClicked = true;
                var ClientProblemstring = $('[id$=HiddenFieldLifeDomain]').val();
                if (checkjsonstring(ClientProblemstring) == true) {
                    var ClientProblems = $.parseJSON(ClientProblemstring);
                    if (ClientProblems.length > 0) {

                        $("#ClientLifeDomainContainer").append($('#ClientLifeDomainHTML').render(ClientProblems));
                    }
                    else {
                        addnewLifeDomain();
                    }
                }
                else {
                    addnewLifeDomain();
                }
            }
        }

    }
    catch (ex) {

    }
});

AddEventHandlers = (function() {
    try {
    }
    catch (ex) {

    }
});


addnewLifeDomain = (function() {
    //debugger;

    var xmlDocumentVersionId = AutoSaveXMLDom.find("CustomDocumentRelapsePreventionPlans:first DocumentVersionId").text();
    if (_LifeDomainId == 0) {
        _LifeDomainId = -1
        LifeDomainProblems[0].RelapseLifeDomainId = -1;
    }
    else {
        _LifeDomainId = _LifeDomainId + (-1);
        LifeDomainProblems[0].RelapseLifeDomainId = _LifeDomainId;
    }
    LifeDomainProblems[0].DocumentVersionId = xmlDocumentVersionId;
    var id = $(AutoSaveXMLDom[0]).find("CustomRelapseLifeDomains").length + 1;
    LifeDomainProblems[0].Id = id;
    var _CustomRelapseLifeDomainsId;
    var _documentversionid;
    var _provider;
    var _date;
    var _time;
    var _appointmenttype;
    var _comments;
    var _createdby;
    var _createddate;
    var _modifiedby;
    var _modifieddate;
    var _id;
    var _newProblem;
    var _Domainnumber;


    var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomRelapseLifeDomains')); //Add Table
    _CustomRelapseLifeDomainsId = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('RelapseLifeDomainId')); //Add Column
    _CustomRelapseLifeDomainsId.text = _LifeDomainId;
    _Id = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('Id')); //Add Column
    _Id.text = id;
    _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
    _createdby.text = objectPageResponse.LoggedInUserCode;
    _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
    _createddate.text = ISODateString(new Date());
    _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
    _modifiedby.text = objectPageResponse.LoggedInUserCode;
    _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
    _modifieddate.text = ISODateString(new Date());
    _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
    _documentversionid.text = xmlDocumentVersionId;
    _newProblem = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('NewProblem')); //Add Column
    _newProblem.text = 'Y'



    $("#ClientLifeDomainContainer").append($('#ClientLifeDomainHTML').render(LifeDomainProblems));
    CreateUnsavedInstanceOnDatasetChange();
    var conValue = ',{"Id":' + id + ',"RelapseLifeDomainId":' + _LifeDomainId + ',"DocumentVersionId":' + xmlDocumentVersionId + ',"LifeDomainDetail":' + null + '}]';
    $('[id$=HiddenFieldLifeDomain]').val($('[id$=HiddenFieldLifeDomain]').val().replace("]", conValue));
    if ($("#ClientProblemMedicalContainer").length > 0) {
        var ClientProblemstring = $('[id$=HiddenFieldLifeDomain]').val();
        if (checkjsonstring(ClientProblemstring) == true) {
            var ClientProblems = $.parseJSON(ClientProblemstring);
            if (ClientProblems.length > 0) {
                $("#ClientProblemMedicalContainer").html('');
                $("#ClientProblemMedicalContainer").append($('#ClientProblemMedicalHTML').render(ClientProblems));
            }

        }
    }
    //$('#Span_' + _LifeDomainId + '_LifeDomainNumber').html($('[section=spannumber]').length - 1);
    //$('#Span_' + _LifeDomainId + '_LifeDomainNumber').html(id);
    $('#Span_' + _LifeDomainId + '_LifeDomainNumber').html($('[section=spannumber]').length);
    _Domainnumber = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('LifeDomainNumber')); //Add Column
    _Domainnumber.text = $('[section=spannumber]').length

    AddToUnsavedTables("CustomRelapseLifeDomains");
    return false;


});



CustomLifeDomainProblemsaveXMLvalue = (function(obj, mode, clientproblemid) {
    //debugger;
    if (AutoSaveXMLDom.find("CustomRelapseLifeDomains").find('RelapseLifeDomainId[text=' + clientproblemid + ']').length == 0) {
        addinitialnewappointment(RelapseLifeDomainId);
    }
    if (mode == 'LifeDomainDetail') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", clientproblemid, "LifeDomainDetail", $(obj).val(), AutoSaveXMLDom[0]);
        BindProblemsInMedicalSecisionTab();
    }
    else if (mode == 'LifeDomain') {

        SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", clientproblemid, "LifeDomain", $(obj).val(), AutoSaveXMLDom[0]);

    }
    else if (mode == 'Resources') {

        SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", clientproblemid, "Resources", $(obj).val(), AutoSaveXMLDom[0]);

    }

    else if (mode == 'Barriers') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", clientproblemid, "Barriers", $(obj).val(), AutoSaveXMLDom[0]);
    }

    else if (mode == 'LifeDomainDate') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", clientproblemid, "LifeDomainDate", $(obj).val(), AutoSaveXMLDom[0]);
    }

    else if (mode == 'MyGoal') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", clientproblemid, "MyGoal", $(obj).val(), AutoSaveXMLDom[0]);
    }

    else if (mode == 'AchievedThisGoal') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", clientproblemid, "AchievedThisGoal", $(obj).val(), AutoSaveXMLDom[0]);
    }



    SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", clientproblemid, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", clientproblemid, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();
});

addinitialnewappointment = (function(RelapseLifeDomainId) {
    //debugger;
    var xmlDocumentVersionId = AutoSaveXMLDom.find("CustomDocumentRelapsePreventionPlans:first DocumentVersionId").text();
    var _CustomRelapseLifeDomainsId;
    var _createdby;
    var _createddate;
    var _modifiedby;
    var _modifieddate;
    var _documentversionid;
    var _Problem;
    var _Severity;
    var _Duration;
    var _Intensity;
    var _LifeDomainDate;
    var _MyGoal;
    var id = dom.find("CustomRelapseLifeDomains").length + 1;
    var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomRelapseLifeDomains')); //Add Table
    _CustomRelapseLifeDomainsId = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('RelapseLifeDomainId')); //Add Column
    _CustomRelapseLifeDomainsId.text = _LifeDomainId;
    _Id = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('Id')); //Add Column
    _Id.text = id;
    _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
    _createdby.text = objectPageResponse.LoggedInUserCode;
    _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
    _createddate.text = ISODateString(new Date());
    _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
    _modifiedby.text = objectPageResponse.LoggedInUserCode;
    _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
    _modifieddate.text = ISODateString(new Date());
    _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
    _documentversionid.text = xmlDocumentVersionId;
    _Problem = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('LifeDomainDetail')); //Add Column
    _Problem.text = '';
    _Severity = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('LifeDomain')); //Add Column
    _Severity.text = '';
    _Duration = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('Resources')); //Add Column
    _Duration.text = '';
    _Intensity = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('Barriers')); //Add Column
    _Intensity.text = '';

    _LifeDomainDate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('LifeDomainDate')); //Add Column
    _LifeDomainDate.text = '';

    _MyGoal = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('MyGoal')); //Add Column
    _MyGoal.text = '';

    _AchievedThisGoal = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('AchievedThisGoal')); //Add Column
    _AchievedThisGoal.text = '';
    AddToUnsavedTables("CustomRelapseLifeDomains");
    $("#ClientLifeDomainContainer").append($('#ClientLifeDomainHTML').render(emptydata));
    CreateUnsavedInstanceOnDatasetChange();
});

function CallCustomNoteAfterDocumentCallbackComplete() {
    if (openNewpage == true && openNewpage != undefined) {
        EffectiveDate = $('#TextBox_DocumentInformation_EffectiveDate').val();
        var documentstatus = ValidationBeforeUpdate();
        var PastHistryCount = 0;
        if (documentstatus) {

            SavePageData();
        }
        //OpenPage(screenTypeEnum.Detail, 750, 'DocumentVersionId=' + AutoSaveXMLDom.find("Documents:first InProgressDocumentVersionId").text() + '^EffectiveDate=' + EffectiveDate + '^PageFrom=ProgressServieNote', 0, GetRelativePath(), 'T', 'dialogHeight: 550px; dialogWidth: 800px;');
    }

}

function OpenCustomPopUpAfterDocumentCallbackComplete() {
    if (AutoSaveXMLDom.find("Documents:first InProgressDocumentVersionId").text() && !objectPageResponse.ValidationInfoHTML && openNewpage) {
        openNewpage = false;
        OpenPage(screenTypeEnum.Detail, 750, 'DocumentVersionId=' + AutoSaveXMLDom.find("Documents:first InProgressDocumentVersionId").text() + '^EffectiveDate=' + EffectiveDate + '^PageFrom=ProgressServieNote', 0, GetRelativePath(), 'T', 'dialogHeight: 550px; dialogWidth: 800px;');
    } else {
        openNewpage = false;
    }
}
function OpenSignPopupForPsychiatricProgressNote() {
    ActionSignOrComplete = true;
    ActionValidateDocumentPageData = false;
    SavePageDataSet(AutoSaveXMLDom[0].xml);
}


function EnableOrDisableOtherTextbox(Controlid, ControlToEnable) {
    if (Controlid.checked == true) {
        $("[id$=" + ControlToEnable + "]").attr("disabled", false);
    }
    else {
        $("[id$=" + ControlToEnable + "]").attr("disabled", true);
        $("[id$=" + ControlToEnable + "]").val('');
        CreateAutoSaveXml(ControlToEnable.split('_')[1], ControlToEnable.split('_')[2], '');
    }

}


function BindProblemsInMedicalSecisionTab() {
    var ProblemId = 0;
    AutoSaveXMLDom.find("CustomRelapseLifeDomains").each(function() {
        $(this).children().each(function() {
            if (this.tagName == "RelapseLifeDomainId") {
                ProblemId = parseInt($(this).text());
            }
            if (this.tagName == "LifeDomainDetail") {
                $("[id$=" + ProblemId + "LifeDomainDetail]").text($(this).text());
            }
        });
    });
}




ISODateString = (function(dateIn) {
    var d;
    if ((typeof (dateIn) === 'date') ? true : (typeof (dateIn) === 'object') ? dateIn.constructor.toString().match(/date/i) !== null : false) {
        d = dateIn;
    } else {
        d = new Date(dateIn);
    }
    function pad(n) {
        n = parseInt(n, 10);
        return n < 10 ? '0' + n : n;
    }
    return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + 'T' +
        pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds());
});



function GetNewServiceId() {
    var newServiceId = -1;
    var existingMaxServiceId = 0;
    var XmlServices = $("CustomRelapseGoals", AutoSaveXMLDom[0]);
    XmlServices.each(function() {
        if (parseInt($('RelapseGoalId', $(this)).text()) < existingMaxServiceId) {
            existingMaxServiceId = parseInt($('RelapseGoalId', $(this)).text());
        }
    });
    if (parseInt(existingMaxServiceId) > 0)
        newServiceId = -1;
    else
        newServiceId = parseInt(existingMaxServiceId) - 1;
    return newServiceId;
}



function CreateNewServiceNodeInXML(tableName, clientId, clientName, primaryKeyColumnName, primaryKeyValue, xmlDom) {
    CreateXMLNodeForTable(tableName, primaryKeyColumnName, primaryKeyValue, xmlDom);
    var newServiceXMLDom = $("CustomRelapseGoals>RelapseGoalId[text=" + primaryKeyValue + "]", xmlDom).parent();

    var DocumentVersionId = GetDefaultValues("DocumentVersionId", parentDefaultTable);
    var RelapseLifeDomainId = GetDefaultValues("RelapseLifeDomainId", parentDefaultTable);
    var RelapseGoalStatus = GetDefaultValues("RelapseGoalStatus", parentDefaultTable);
    var ProjectedDate = GetDefaultValues("ProjectedDate", parentDefaultTable);
    var MyGoal = GetDefaultValues("MyGoal", parentDefaultTable);
    var AchievedThisGoal = GetDefaultValues("AchievedThisGoal", parentDefaultTable);


    objectSerializedService =
   {
       "CustomRelapseGoals":
       [
           {
               "RelapseGoalId": primaryKeyValue,
               "RelapseGoalStatus": 125,
               "GoalNumber": ""



           }
        ]
   };

}


function CreateXMLNodeForTable(tableName, primaryKeyColumnName, primaryKeyValue, xmlDom) {
    var tableObject = xmlDom.createElement(tableName);
    var columnObject = xmlDom.createElement(primaryKeyColumnName);
    tableObject.appendChild(columnObject);
    var columnValue = primaryKeyValue;
    columnObject.text = columnValue;
    xmlDom.childNodes[0].appendChild(tableObject);
    AddToUnsavedTables(tableName);
}



AddNewMemberService = (function(RelapseLifeDomainId, obj) {
    //debugger
    try {
        var PrimaryKeyName = 'RelapseGoalId';
        var PrimaryKeyTableName = 'CustomRelapseGoals';
        var PrimaryKeyId = 0;
        var objectSerializedService = null;
        AutoSaveXMLDom.find(PrimaryKeyTableName).each(function() {
            $(this).children().each(function() {
                if (this.tagName == PrimaryKeyName) {
                    if (parseInt($(this).text()) < 0 && PrimaryKeyId <= 0 && PrimaryKeyId > parseInt($(this).text())) {
                        PrimaryKeyId = parseInt($(this).text());
                    }
                }
            });
        });

        if (PrimaryKeyId == 0)
            PrimaryKeyId = -1
        else
            PrimaryKeyId = PrimaryKeyId + (-1);

        var _trprimarykeyid;
        var _createdby;
        var _createddate;
        var _modifiedby;
        var _modifieddate;
        var _documentversionid;
        var _relapselifedomainid;
        var _Lifedoamingoalnumber;

        var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(PrimaryKeyTableName)); //Add Table
        _trprimarykeyid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement(PrimaryKeyName)); //Add Column
        _trprimarykeyid.text = PrimaryKeyId;

        _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
        _createdby.text = objectPageResponse.LoggedInUserCode;

        _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
        _createddate.text = ISODateString(new Date());

        _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
        _modifiedby.text = objectPageResponse.LoggedInUserCode;

        _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
        _modifieddate.text = ISODateString(new Date());

        var tablelist = $('#HiddenFieldPageTables').val();
        var DocumentVersionId = -1;
        var findtext = tablelist.split(',')[0] + ":first DocumentVersionId";
        if (AutoSaveXMLDom.find(findtext).text())
            DocumentVersionId = AutoSaveXMLDom.find(findtext).text();
        _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
        _documentversionid.text = DocumentVersionId;
        _relapselifedomainid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('RelapseLifeDomainId')); //Add Column
        _relapselifedomainid.text = RelapseLifeDomainId;
        AddToUnsavedTables(PrimaryKeyTableName);
        CreateUnsavedInstanceOnDatasetChange();

        objectSerializedService = { "CustomRelapseGoals": [{ "RelapseGoalId": PrimaryKeyId, "RelapseGoalStatus": "", "RelapseGoalStatusName": "", "ProjectedDate": "", "MyGoal": "", "AchievedThisGoal": ""}] };
        var newServiceContainer = $("td#TRMainLifeDomainsChild_" + RelapseLifeDomainId + ":last");
        newServiceContainer.append($('#GoalHTML').render(objectSerializedService.CustomRelapseGoals));

        $('#DropDownList_CustomRelapseGoals_RelapseGoalStatus_' + PrimaryKeyId).html($('[id$=DropDownList_CustomRelapseGoals_RelapseGoalStatus]').html())

        var lifedomainnumber = $('#Span_' + RelapseLifeDomainId + '_LifeDomainNumber').html();
        var goalnumber = $('#DivProblem_' + RelapseLifeDomainId).find('[section=spangoalnumber]').length
        var concatenatednumber = lifedomainnumber + '.' + goalnumber
        $('#Span_' + PrimaryKeyId + '_GoalNumber').html(concatenatednumber);

        _Lifedoamingoalnumber = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('GoalNumber')); //Add Column
        _Lifedoamingoalnumber.text = lifedomainnumber + '.' + $('#DivProblem_' + RelapseLifeDomainId).find('[section=spangoalnumber]').length

    }
    catch (ex) {
        debugger;
    }
});







CustomGoalsaveXMLvalue = (function(obj, mode, RelapseGoalId) {
    //debugger;

    if (mode == 'MyGoal') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", RelapseGoalId, "MyGoal", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'AchievedThisGoal') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", RelapseGoalId, "AchievedThisGoal", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'RelapseGoalStatus') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", RelapseGoalId, "RelapseGoalStatus", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'ProjectedDate') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", RelapseGoalId, "ProjectedDate", $(obj).val(), AutoSaveXMLDom[0]);
    }

    SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", RelapseGoalId, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", RelapseGoalId, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();

});






AddNewObjectives = (function(RelapseGoalId, obj) {
    //debugger
    try {
        var PrimaryKeyName = 'RelapseObjectiveId';
        var PrimaryKeyTableName = 'CustomRelapseObjectives';
        var PrimaryKeyId = 0;
        var Objectiveservice = null;
        AutoSaveXMLDom.find(PrimaryKeyTableName).each(function() {
            $(this).children().each(function() {
                if (this.tagName == PrimaryKeyName) {
                    if (parseInt($(this).text()) < 0 && PrimaryKeyId <= 0 && PrimaryKeyId > parseInt($(this).text())) {
                        PrimaryKeyId = parseInt($(this).text());
                    }
                }
            });
        });

        if (PrimaryKeyId == 0)
            PrimaryKeyId = -1
        else
            PrimaryKeyId = PrimaryKeyId + (-1);

        var _trprimarykeyid;
        var _createdby;
        var _createddate;
        var _modifiedby;
        var _modifieddate;
        var _documentversionid;
        var _relapsegoalid;
        var _relapseobjectivenumber;

        var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(PrimaryKeyTableName)); //Add Table
        _trprimarykeyid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement(PrimaryKeyName)); //Add Column
        _trprimarykeyid.text = PrimaryKeyId;

        _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
        _createdby.text = objectPageResponse.LoggedInUserCode;

        _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
        _createddate.text = ISODateString(new Date());

        _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
        _modifiedby.text = objectPageResponse.LoggedInUserCode;

        _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
        _modifieddate.text = ISODateString(new Date());

        var tablelist = $('#HiddenFieldPageTables').val();
        var DocumentVersionId = -1;
        var findtext = tablelist.split(',')[0] + ":first DocumentVersionId";
        if (AutoSaveXMLDom.find(findtext).text())
            DocumentVersionId = AutoSaveXMLDom.find(findtext).text();
        _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
        _documentversionid.text = DocumentVersionId;
        _relapsegoalid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('RelapseGoalId')); //Add Column
        _relapsegoalid.text = RelapseGoalId;
        AddToUnsavedTables(PrimaryKeyTableName);
        CreateUnsavedInstanceOnDatasetChange();

        Objectiveservice = { "CustomRelapseObjectives": [{ "RelapseObjectiveId": PrimaryKeyId, "ObjectiveStatus": "", "ObjectiveStatusname": "", "ObjectivesCreateDate": "", "RelapseObjectives": "", "IWillAchieve": "", "ResolutionDate": "", "ExpectedAchieveDate": "", "ObjectivesNumber": ""}] };
        var newServiceContainer = $("td#TRMainGoalChild_" + RelapseGoalId + ":last");
        newServiceContainer.append($('#ObjectiveHTML').render(Objectiveservice.CustomRelapseObjectives));

        $('#DropDownList_CustomRelapseObjectives_ObjectiveStatus_' + PrimaryKeyId).html($('[id$=DropDownList_CustomRelapseObjectives_ObjectiveStatus]').html())

        var Goalnumber = $('#Span_' + RelapseGoalId + '_GoalNumber').html();
        $('#DivGoal_' + RelapseGoalId).find('[section=spanobjectivenumber]').length
        $('#Span_' + PrimaryKeyId + '_ObjectivesNumber').html(Goalnumber + '.' + $('#DivGoal_' + RelapseGoalId).find('[section=spanobjectivenumber]').length);

        _relapseobjectivenumber = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ObjectivesNumber')); //Add Column
        _relapseobjectivenumber.text = Goalnumber + '.' + $('#DivGoal_' + RelapseGoalId).find('[section=spanobjectivenumber]').length

    }
    catch (ex) {
        debugger;
    }
});





CustomObjecivesaveXMLvalue = (function(obj, mode, RelapseObjectiveId) {
    //debugger;

    if (mode == 'ObjectivesCreateDate') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "ObjectivesCreateDate", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'ObjectiveStatus') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "ObjectiveStatus", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'IWillAchieve') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "IWillAchieve", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'ExpectedAchieveDate') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "ExpectedAchieveDate", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'ResolutionDate') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "ResolutionDate", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'RelapseObjectives') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "RelapseObjectives", $(obj).val(), AutoSaveXMLDom[0]);
    }


    SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();

});




AddNewObjectiveactions = (function(RelapseObjectiveId, obj) {
    //debugger
    try {
        var PrimaryKeyName = 'RelapseActionStepId';
        var PrimaryKeyTableName = 'CustomRelapseActionSteps';
        var PrimaryKeyId = 0;
        var Objectiveaction = null;
        AutoSaveXMLDom.find(PrimaryKeyTableName).each(function() {
            $(this).children().each(function() {
                if (this.tagName == PrimaryKeyName) {
                    if (parseInt($(this).text()) < 0 && PrimaryKeyId <= 0 && PrimaryKeyId > parseInt($(this).text())) {
                        PrimaryKeyId = parseInt($(this).text());
                    }
                }
            });
        });

        if (PrimaryKeyId == 0)
            PrimaryKeyId = -1
        else
            PrimaryKeyId = PrimaryKeyId + (-1);

        var _trprimarykeyid;
        var _createdby;
        var _createddate;
        var _modifiedby;
        var _modifieddate;
        var _documentversionid;
        var _relapseobjectiveid;
        var _Lifedomainactionnumber;

        var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(PrimaryKeyTableName)); //Add Table
        _trprimarykeyid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement(PrimaryKeyName)); //Add Column
        _trprimarykeyid.text = PrimaryKeyId;

        _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
        _createdby.text = objectPageResponse.LoggedInUserCode;

        _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
        _createddate.text = ISODateString(new Date());

        _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
        _modifiedby.text = objectPageResponse.LoggedInUserCode;

        _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
        _modifieddate.text = ISODateString(new Date());

        var tablelist = $('#HiddenFieldPageTables').val();
        var DocumentVersionId = -1;
        var findtext = tablelist.split(',')[0] + ":first DocumentVersionId";
        if (AutoSaveXMLDom.find(findtext).text())
            DocumentVersionId = AutoSaveXMLDom.find(findtext).text();
        _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
        _documentversionid.text = DocumentVersionId;
        _relapseobjectiveid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('RelapseObjectiveId')); //Add Column
        _relapseobjectiveid.text = RelapseObjectiveId;
        AddToUnsavedTables(PrimaryKeyTableName);
        CreateUnsavedInstanceOnDatasetChange();

        Objectiveaction = { "CustomRelapseActionSteps": [{ "RelapseActionStepId": PrimaryKeyId, "ActionStepStatus": "", "RelapseActionSteps": "", "CreateDate": "", "ToAchieveMyGoal": "", "ActionStepNumber": ""}] };
        var newServiceContainer = $("td#TRMainObjectiveChild_" + RelapseObjectiveId + ":last");
        newServiceContainer.append($('#ObjectiveActions').render(Objectiveaction.CustomRelapseActionSteps));

        $('#DropDownList_CustomRelapseActionSteps_ActionStepStatus_' + PrimaryKeyId).html($('[id$=DropDownList_CustomRelapseActionSteps_ActionStepStatus]').html())




        var objectivenumber = $('#Span_' + RelapseObjectiveId + '_ObjectivesNumber').html();
        //$('#DivAction_' + RelapseObjectiveId).find('[section=spanactionnumber]').length
        $('#Span_' + PrimaryKeyId + '_ActionStepNumber').html(objectivenumber + '.' + $('#DivObjective_' + RelapseObjectiveId).find('[section=spanactionnumber]').length);


        _Lifedomainactionnumber = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ActionStepNumber')); //Add Column
        _Lifedomainactionnumber.text = objectivenumber + '.' + $('#DivObjective_' + RelapseObjectiveId).find('[section=spanactionnumber]').length

    }
    catch (ex) {
        debugger;
    }
});



CustomActionsaveXMLvalue = (function(obj, mode, RelapseActionStepId) {
    //debugger;

    if (mode == 'ActionStepStatus') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", RelapseActionStepId, "ActionStepStatus", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'ToAchieveMyGoal') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", RelapseActionStepId, "ToAchieveMyGoal", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'CreateDate') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", RelapseActionStepId, "CreateDate", $(obj).val(), AutoSaveXMLDom[0]);
    }

    if (mode == 'RelapseActionSteps') {
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", RelapseActionStepId, "RelapseActionSteps", $(obj).val(), AutoSaveXMLDom[0]);
    }



    SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", RelapseActionStepId, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", RelapseActionStepId, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();

});








deleteProblem = (function(RelapseLifeDomainId) {

    SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", RelapseLifeDomainId, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", RelapseLifeDomainId, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", RelapseLifeDomainId, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);

    /* To set the record deleted for the child under the parent */

    var goalobj = $('#DivProblem_' + RelapseLifeDomainId).find('[section=spangoalnumber]');
    for (var k = 0; k < goalobj.length; k++) {
        var GoalId = goalobj[k].id.split('_');
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", GoalId[1], "RecordDeleted", "Y", AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", GoalId[1], "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", GoalId[1], "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);

        var Objecivesobj = $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]');
        for (var l = 0; l < Objecivesobj.length; l++) {
            var ObjectiveId = Objecivesobj[l].id.split('_');
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "RecordDeleted", "Y", AutoSaveXMLDom[0]);
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);

            var Actionsobj = $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]');
            for (var M = 0; M < Actionsobj.length; M++) {
                var ActionsId = Actionsobj[M].id.split('_');
                SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "RecordDeleted", "Y", AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
                SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);

            }
        }
    }

    /* End here */
    CreateUnsavedInstanceOnDatasetChange();
});


removeLifeDomain = (function(obj, RelapseLifeDomainId) {
    //debugger;
    try {
        deleteProblem(RelapseLifeDomainId);
        $('#DivProblem_' + RelapseLifeDomainId).remove();
        var sectionobj = $('[section=spannumber]');
        for (var j = 0; j < sectionobj.length; j++) {
            $('[section=spannumber]')[j].innerHTML = '';
            $('[section=spannumber]')[j].innerHTML = j + 1;
            var ID = sectionobj[j].id.split('_');
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", ID[1], "LifeDomainNumber", j + 1, AutoSaveXMLDom[0]);
            var goalobj = $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]');
            for (var k = 0; k < goalobj.length; k++) {
                var GoalId = goalobj[k].id.split('_');
                var Goalnumber = j + 1 + '.' + parseInt(k + 1);
                SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", GoalId[1], "GoalNumber", Goalnumber, AutoSaveXMLDom[0]);
                $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]')[k].innerHTML = '';
                $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]')[k].innerHTML = Goalnumber;

                var Objecivesobj = $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]');
                for (var l = 0; l < Objecivesobj.length; l++) {
                    var ObjectiveId = Objecivesobj[l].id.split('_');
                    var Objectivenumber = j + 1 + '.' + parseInt(k + 1) + '.' + parseInt(l + 1);
                    SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "ObjectivesNumber", Objectivenumber, AutoSaveXMLDom[0]);
                    $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]')[l].innerHTML = '';
                    $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]')[l].innerHTML = Objectivenumber;

                    var Actionsobj = $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]');
                    for (var M = 0; M < Actionsobj.length; M++) {
                        var ActionsId = Actionsobj[M].id.split('_');
                        var Actionsnumber = j + 1 + '.' + parseInt(k + 1) + '.' + parseInt(l + 1) + '.' + parseInt(M + 1);
                        SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "ActionStepNumber", Actionsnumber, AutoSaveXMLDom[0]);
                        $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]')[M].innerHTML = '';
                        $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]')[M].innerHTML = Actionsnumber;
                    }
                }
            }
        }



    }
    catch (ex) { }
});





removeGoal = (function(obj, RelapseGoalId) {
    //debugger;
    try {
        deleteGoal(RelapseGoalId);
        $('#DivGoal_' + RelapseGoalId).remove();
        
        
        var sectionobj = $('[section=spannumber]');
        for (var j = 0; j < sectionobj.length; j++) {
            $('[section=spannumber]')[j].innerHTML = '';
            $('[section=spannumber]')[j].innerHTML = j + 1;
            var ID = sectionobj[j].id.split('_');
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", ID[1], "LifeDomainNumber", j + 1, AutoSaveXMLDom[0]);
            var goalobj = $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]');
            for (var k = 0; k < goalobj.length; k++) {
                var GoalId = goalobj[k].id.split('_');
                var Goalnumber = j + 1 + '.' + parseInt(k + 1);
                SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", GoalId[1], "GoalNumber", Goalnumber, AutoSaveXMLDom[0]);
                $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]')[k].innerHTML = '';
                $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]')[k].innerHTML = Goalnumber;

                var Objecivesobj = $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]');
                for (var l = 0; l < Objecivesobj.length; l++) {
                    var ObjectiveId = Objecivesobj[l].id.split('_');
                    var Objectivenumber = j + 1 + '.' + parseInt(k + 1) + '.' + parseInt(l + 1);
                    SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "ObjectivesNumber", Objectivenumber, AutoSaveXMLDom[0]);
                    $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]')[l].innerHTML = '';
                    $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]')[l].innerHTML = Objectivenumber;

                    var Actionsobj = $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]');
                    for (var M = 0; M < Actionsobj.length; M++) {
                        var ActionsId = Actionsobj[M].id.split('_');
                        var Actionsnumber = j + 1 + '.' + parseInt(k + 1) + '.' + parseInt(l + 1) + '.' + parseInt(M + 1);
                        SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "ActionStepNumber", Actionsnumber, AutoSaveXMLDom[0]);
                        $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]')[M].innerHTML = '';
                        $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]')[M].innerHTML = Actionsnumber;
                    }
                }
            }
        }



    }
    catch (ex) { }
});



deleteGoal = (function(RelapseGoalId) {

SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", RelapseGoalId, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", RelapseGoalId, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", RelapseGoalId, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);


    /* To set the record deleted for the child under the parent */

    var Objecivesobj = $('#DivGoal_' + RelapseGoalId).find('[section=spanobjectivenumber]');
    for (var l = 0; l < Objecivesobj.length; l++) {
        var ObjectiveId = Objecivesobj[l].id.split('_');
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "RecordDeleted", "Y", AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);

        var Actionsobj = $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]');
        for (var M = 0; M < Actionsobj.length; M++) {
            var ActionsId = Actionsobj[M].id.split('_');
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "RecordDeleted", "Y", AutoSaveXMLDom[0]);
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);

        }
    }


    /* End here */
    CreateUnsavedInstanceOnDatasetChange();
});





removeobjectives = (function(obj, RelapseObjectiveId) {
    //debugger;
    try {
        deleteObjective(RelapseObjectiveId);
        $('#DivObjective_' + RelapseObjectiveId).remove();
        var sectionobj = $('[section=spannumber]');
        for (var j = 0; j < sectionobj.length; j++) {
            $('[section=spannumber]')[j].innerHTML = '';
            $('[section=spannumber]')[j].innerHTML = j + 1;
            var ID = sectionobj[j].id.split('_');
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", ID[1], "LifeDomainNumber", j + 1, AutoSaveXMLDom[0]);
            var goalobj = $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]');
            for (var k = 0; k < goalobj.length; k++) {
                var GoalId = goalobj[k].id.split('_');
                var Goalnumber = j + 1 + '.' + parseInt(k + 1);
                SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", GoalId[1], "GoalNumber", Goalnumber, AutoSaveXMLDom[0]);
                $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]')[k].innerHTML = '';
                $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]')[k].innerHTML = Goalnumber;

                var Objecivesobj = $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]');
                for (var l = 0; l < Objecivesobj.length; l++) {
                    var ObjectiveId = Objecivesobj[l].id.split('_');
                    var Objectivenumber = j + 1 + '.' + parseInt(k + 1) + '.' + parseInt(l + 1);
                    SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "ObjectivesNumber", Objectivenumber, AutoSaveXMLDom[0]);
                    $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]')[l].innerHTML = '';
                    $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]')[l].innerHTML = Objectivenumber;

                    var Actionsobj = $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]');
                    for (var M = 0; M < Actionsobj.length; M++) {
                        var ActionsId = Actionsobj[M].id.split('_');
                        var Actionsnumber = j + 1 + '.' + parseInt(k + 1) + '.' + parseInt(l + 1) + '.' + parseInt(M + 1);
                        SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "ActionStepNumber", Actionsnumber, AutoSaveXMLDom[0]);
                        $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]')[M].innerHTML = '';
                        $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]')[M].innerHTML = Actionsnumber;
                    }
                }
            }
        }



    }
    catch (ex) { }
});



deleteObjective = (function(RelapseObjectiveId) {

SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", RelapseObjectiveId, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);


    /* To set the record deleted for the child under the parent */

        var Actionsobj = $('#DivObjective_' + RelapseObjectiveId).find('[section=spanactionnumber]');
        for (var M = 0; M < Actionsobj.length; M++) {
            var ActionsId = Actionsobj[M].id.split('_');
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "RecordDeleted", "Y", AutoSaveXMLDom[0]);
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
        }

    /* End here */
    CreateUnsavedInstanceOnDatasetChange();
});







removeactions = (function(obj, RelapseActionStepId) {
    //debugger;
    try {
        deleteAction(RelapseActionStepId);
        $('#DivAction_' + RelapseActionStepId).remove();
        var sectionobj = $('[section=spannumber]');
        for (var j = 0; j < sectionobj.length; j++) {
            $('[section=spannumber]')[j].innerHTML = '';
            $('[section=spannumber]')[j].innerHTML = j + 1;
            var ID = sectionobj[j].id.split('_');
            SetColumnValueInXMLNodeByKeyValue("CustomRelapseLifeDomains", "RelapseLifeDomainId", ID[1], "LifeDomainNumber", j + 1, AutoSaveXMLDom[0]);
            var goalobj = $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]');
            for (var k = 0; k < goalobj.length; k++) {
                var GoalId = goalobj[k].id.split('_');
                var Goalnumber = j + 1 + '.' + parseInt(k + 1);
                SetColumnValueInXMLNodeByKeyValue("CustomRelapseGoals", "RelapseGoalId", GoalId[1], "GoalNumber", Goalnumber, AutoSaveXMLDom[0]);
                $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]')[k].innerHTML = '';
                $('#DivProblem_' + ID[1]).find('[section=spangoalnumber]')[k].innerHTML = Goalnumber;

                var Objecivesobj = $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]');
                for (var l = 0; l < Objecivesobj.length; l++) {
                    var ObjectiveId = Objecivesobj[l].id.split('_');
                    var Objectivenumber = j + 1 + '.' + parseInt(k + 1) + '.' + parseInt(l + 1);
                    SetColumnValueInXMLNodeByKeyValue("CustomRelapseObjectives", "RelapseObjectiveId", ObjectiveId[1], "ObjectivesNumber", Objectivenumber, AutoSaveXMLDom[0]);
                    $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]')[l].innerHTML = '';
                    $('#DivGoal_' + GoalId[1]).find('[section=spanobjectivenumber]')[l].innerHTML = Objectivenumber;

                    var Actionsobj = $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]');
                    for (var M = 0; M < Actionsobj.length; M++) {
                        var ActionsId = Actionsobj[M].id.split('_');
                        var Actionsnumber = j + 1 + '.' + parseInt(k + 1) + '.' + parseInt(l + 1) + '.' + parseInt(M + 1);
                        SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", ActionsId[1], "ActionStepNumber", Actionsnumber, AutoSaveXMLDom[0]);
                        $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]')[M].innerHTML = '';
                        $('#DivObjective_' + ObjectiveId[1]).find('[section=spanactionnumber]')[M].innerHTML = Actionsnumber;
                    }
                }
            }
        }



    }
    catch (ex) { }
});




deleteAction = (function(RelapseActionStepId) {

SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", RelapseActionStepId, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", RelapseActionStepId, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
SetColumnValueInXMLNodeByKeyValue("CustomRelapseActionSteps", "RelapseActionStepId", RelapseActionStepId, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);

    CreateUnsavedInstanceOnDatasetChange();
});