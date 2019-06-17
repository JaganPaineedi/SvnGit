//Author : Jagdeep Hundal
//Purpose : Handel need list process.


//Function to bind need list data.

function BindNeedList(domObject) {
    try {
        var XmlDiagnosticNeed = $("CustomDocumentAssessmentNeeds", domObject);
        createNeedListHTML(XmlDiagnosticNeed);
    }
    catch (err) {
        LogClientSideException(err, 'Diagnostic Needs List');
    }
}

//Function to delete need list data.
function DeleteNeedList(deletedNeedId) {
    try {
        var value = confirm("Are You sure want to delete this record");
        if (value) {

            XmlDiagnosticNeed = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDocumentAssessmentNeeds");
            XmlDiagnosticNeed = $("CustomDocumentAssessmentNeeds", AutoSaveXMLDom);
            CustomSetColumnValueInXMLNodeByKeyValue('CustomDocumentAssessmentNeeds', 'AssessmentNeedId', deletedNeedId, 'RecordDeleted', 'Y', AutoSaveXMLDom[0], 'Y');
            createNeedListHTML(XmlDiagnosticNeed);
        }

    }
    catch (err) {
        LogClientSideException(err, 'Diagnostic Needs List');
    }
}

//Function to add custom textbox tio add need list data.


function AddDiagnosticNeedList() {
    try {
        var makeHTML = true;
        var XmlDiagnosticNeed;
        XmlDiagnosticNeed = $("CustomDocumentAssessmentNeeds", AutoSaveXMLDom);
        if (XmlDiagnosticNeed.length == 0) {
            SetValuesNeedList("CustomDocumentAssessmentNeeds", "AssessmentNeedId", "DocumentVersionId", -1, DocumentVersionId,
                          "NeedName^NeedDescription^NeedStatus", '^^6530', 0, AutoSaveXMLDom);
        }
        else if (XmlDiagnosticNeed.length > 0) {
            if (CheckForBlankNeed(false) == false) {
                makeHTML = true;

                var assessmentNeedId = XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("AssessmentNeedId")[0].text;
                var newAssessmentNeedId = -1;
                if (parseInt(assessmentNeedId) > 0)
                    newAssessmentNeedId = -1;
                else
                    newAssessmentNeedId = parseInt(assessmentNeedId) - 1;

                SetValuesNeedList("CustomDocumentAssessmentNeeds", "AssessmentNeedId", "DocumentVersionId", parseInt
                             (newAssessmentNeedId), DocumentVersionId, "NeedName^NeedDescription^NeedStatus", '^^6530', 0, AutoSaveXMLDom);
            }
            else {

                alert('Please fill the blank need names');
                makeHTML = false;
            }
        }

        if (makeHTML == true) {
            XmlDiagnosticNeed = $("CustomDocumentAssessmentNeeds", AutoSaveXMLDom); ;
            createNeedListHTML(XmlDiagnosticNeed);
        }
    }
    catch (err) {
        LogClientSideException(err, 'Diagnostic Needs List');
    }
}

//Function to set  primary key and Foreign keys.
function SetValuesNeedList(tableName, primaryKeyName, ForeignKeyName, primaryKeyValue, ForeignKeyValue, columnName, columnValue, Object, dom) {
    try {

        columnName = columnName.split('^');
        // i in case of passing object
        // Pass zero if not usable
        if (Object == 0) {
        }
        else {
            columnValue = columnValue + '^' + $("#" + Object.id)[0].value;
        }
        columnValue = columnValue.split('^');
        columnValue_Length = columnValue.length;
        //var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, "DiagnosticNeedId", columnValue[2], "AssessmentNeedId", dom[0]);
        var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, "AssessmentNeedId", columnValue[2], "AssessmentNeedId", dom[0]);
        if (_xmlDom.length > 0) {
            primaryKeyValue = _xmlDom;
            CustomSetColumnValueInXMLNodeByKeyValue("CustomDocumentAssessmentNeeds", "AssessmentNeedId", parseInt(primaryKeyValue), 'RecordDeleted', 'N', dom[0], 'N');
        }
        var primaryKeySet = false;
        var currentDate = new Date();
        currentDate = currentDate.format("MM/dd/yyyy h:mm tt");
        for (var k = 0; k < columnValue_Length; k++) {
            //for new mode
            if (primaryKeyValue <= 0) {
                //Start set value for FK
                //RAP Tab in Unsave Changes Area
                var fk = ForeignKeyValue;
                // end set value for FK  
                //Check nodexml with tablename and primary key
                //var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'DiagnosticNeedId', AutoSaveXMLDom[0]);
                var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'AssessmentNeedId', AutoSaveXMLDom[0]);
                if (_xmlDom.length == 0 && primaryKeySet == false) {
                    //create table if not exist in xml
                    //Append column key with value
                    AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)); //Add table in the XML Dom
                    var _currentNode = "";
                    _currentNode = AutoSaveXMLDom[0].childNodes[0].lastChild.appendChild(AutoSaveXMLDom[0].createElement(primaryKeyName));
                    _currentNode.text = primaryKeyValue;
                    primaryKeySet = true;
                }
                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, ForeignKeyName, ForeignKeyValue, AutoSaveXMLDom[0], 'Y');

                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName[k], columnValue[k], AutoSaveXMLDom[0], 'Y');
                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'ModifiedDate', currentDate, AutoSaveXMLDom[0], 'Y');
                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'ModifiedBy', ApplicationLoggedInUserCode, AutoSaveXMLDom[0], 'Y');
                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'CreatedDate', currentDate, AutoSaveXMLDom[0], 'Y');
                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'CreatedBy', ApplicationLoggedInUserCode, AutoSaveXMLDom[0], 'Y');
            }
            else {
                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName[k], columnValue[k], AutoSaveXMLDom[0], 'Y');
                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'ModifiedDate', currentDate, AutoSaveXMLDom[0], 'Y');
                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'ModifiedBy', ApplicationLoggedInUserCode, AutoSaveXMLDom[0], 'Y');

            }

        }
    }
    catch (err) {
        LogClientSideException(err, 'Diagnostic Needs List');
    }
}

//Function to create html for custom textbox.
function createNeedListHTML(XmlDiagnosticNeed) {
    try {
        var myDate = new Date();
        var controlHtml = "<table border='0' cellspacing='0' cellpadding='0' width='97%'>";
        var needId;
        var _createNeedListRow = true;
        var needStatus;
        for (var i = 0; i < XmlDiagnosticNeed.length; i++) {

            if ($("RecordDeleted", XmlDiagnosticNeed[i]).length > 0 && $("RecordDeleted", XmlDiagnosticNeed[i]).text().trim() == 'N') {
                _createNeedListRow = true;
            }
            else if ($("RecordDeleted", XmlDiagnosticNeed[i]).length > 0 && $("RecordDeleted", XmlDiagnosticNeed[i]).text().trim() == 'Y') {
                _createNeedListRow = false;
            }
            else if ($("RecordDeleted", XmlDiagnosticNeed[i]).length == 0) {
                _createNeedListRow = true;
            }
            if (_createNeedListRow == true) {

                if ($("NeedStatus", XmlDiagnosticNeed[i]).length > 0)
                    needStatus = $("NeedStatus", XmlDiagnosticNeed[i]).text();

                if ($("AssessmentNeedId", XmlDiagnosticNeed[i]).length > 0)
                    needId = $("AssessmentNeedId", XmlDiagnosticNeed[i]).text();

                controlHtml += "<tr>";
                controlHtml += "<td style='width:5%' align='center'>";
                //if (XmlDiagnosticNeed[i].selectNodes("DiagnosticNeedId").length <= 0) {
                controlHtml += ("<img class='cursor_default' style='vertical-align: top' id='" + needId + "' ");
                controlHtml += ("src='../App_Themes/Includes/Images/deleteIcon.gif' alt='' onclick='javascript:DeleteNeedList(this.id);return false;'\" />");
                //                }
                //                else
                //                    controlHtml += "&nbsp;";

                controlHtml += "</td>";
                controlHtml += "<td style='width: 2%'>";
                controlHtml += " </td>";
                controlHtml += "<td style='width: 29%'>";
                //                if (XmlDiagnosticNeed[i].selectNodes("DiagnosticNeedId").length > 0 && XmlDiagnosticNeed[i].selectNodes("DiagnosticNeedId")[0].text.trim() != "")
                //                    controlHtml += "<input type='text' style='width: 270px;height:65px;' maxlength='50' disabled='disabled' readonly='readonly' spellcheck='False' bindautosaveevents='False' class='form_textarea' id='TextArea_CustomDocumentAssessmentNeeds_NeedName_" + i + "'  name='TextArea_CustomDocumentAssessmentNeeds_NeedName'" + i + "' onchange=\"UpdateAutoSaveXMLValues('NeedName',this.value," + needId + ");\" value=";
                //                else

                //Modified By; Amit Kumar Srivastava,  Harbor Diagnostic Assessment Need Name does not allow full 250 characters, SmartcareWeb Phase 3 Development
                //controlHtml += "<input type='text' style='width: 270px;height:65px;' maxlength='50' spellcheck='True' bindautosaveevents='False' class='form_textarea' id='TextArea_CustomDocumentAssessmentNeeds_NeedName_" + i + "'  name='TextArea_CustomDocumentAssessmentNeeds_NeedName'" + i + "' onchange=\"UpdateAutoSaveXMLValues('NeedName',this.value," + needId + ");\" value=";
//                controlHtml += "<input type='text' style='width: 270px;height:65px;' maxlength='250' spellcheck='True' bindautosaveevents='False' class='form_textarea' id='TextArea_CustomDocumentAssessmentNeeds_NeedName_" + i + "'  name='TextArea_CustomDocumentAssessmentNeeds_NeedName'" + i + "' onchange=\"UpdateAutoSaveXMLValues('NeedName',this.value," + needId + ");\" value=";
//                
//                if ($("NeedName", XmlDiagnosticNeed[i]).length > 0 && $("NeedName", XmlDiagnosticNeed[i]).text().trim() != "")
//                    controlHtml += '"' + $("NeedName", XmlDiagnosticNeed[i]).text() + '"';
//                else
//                    controlHtml += '""';
                //                controlHtml += "/>"; controlHtml += "</td>";
                //                controlHtml += "<textarea maxLength='249' onkeyup=\"return ismaxlength(this," + needId + ")\" rows='5' spellcheck='True' cols='30' bindautosaveevents='False' class='form_textarea' id='TextArea_CustomDocumentAssessmentNeeds_NeedName_" + i + "'  name='TextArea_CustomDocumentAssessmentNeeds_NeedName'" + i + "' onchange=\"UpdateAutoSaveXMLValues('NeedName',this.value," + needId + ");\">";

                //Added By Mamta Gupta - Ref Task No. 260 - 3.x Issues - To bind Max Length with TextArea
                controlHtml += "<textarea onkeypress='if (this.value.length >= 250) { return false; }' rows='5' spellcheck='True' cols='30' bindautosaveevents='False' class='form_textarea' id='TextArea_CustomDocumentAssessmentNeeds_NeedName_" + i + "'  name='TextArea_CustomDocumentAssessmentNeeds_NeedName'" + i + "' AssessmentNeedId='" + needId + "' onchange=\"UpdateAutoSaveXMLValues('NeedName',this.value," + needId + ");\">";
                
                if ($("NeedName", XmlDiagnosticNeed[i]).length > 0 && $("NeedName", XmlDiagnosticNeed[i]).text().trim() != "")
                    controlHtml +=  $("NeedName", XmlDiagnosticNeed[i]).text() ;
                else
                    controlHtml += '';
                controlHtml += "</textarea></td>";
                controlHtml += "<td style='width: 2%'></td>";
                controlHtml += "<td style='width: 38%'>";

                controlHtml += "<textarea class='form_textarea' id='TextArea_CustomDocumentAssessmentNeeds_NeedDescription_" + i + "'  name='TextArea_CustomDocumentAssessmentNeeds_NeedDescription'" + i + "' value=";
                //                if (XmlDiagnosticNeed[i].selectNodes("DiagnosticNeedId").length > 0 && XmlDiagnosticNeed[i].selectNodes("DiagnosticNeedId")[0].text.trim() != "")
                //                    controlHtml += "disabled='disabled' readonly='readonly' spellcheck='False' ";
                //                else
                controlHtml += " spellcheck='True' ";

                controlHtml += "rows='5' spellcheck='True' cols='30' bindautosaveevents='False' onchange=\"UpdateAutoSaveXMLValues('NeedDescription',this.value," + needId + ");\">";
                if ($("NeedDescription", XmlDiagnosticNeed[i]).length > 0 && $("NeedDescription", XmlDiagnosticNeed[i]).text().trim() != "")
                    controlHtml += $("NeedDescription", XmlDiagnosticNeed[i]).text();
                else
                    controlHtml += "";

                controlHtml += "</textarea>";
                //Need Status
                controlHtml += "</td>";
                controlHtml += "<td style='width: 2%'></td>";
                controlHtml += "<td style='width: 22%'>";
                var needStatusSection = CreateNeedStatus(i, needStatus, needId);
                controlHtml = controlHtml + needStatusSection;
                controlHtml += "</td>";

                controlHtml += "</tr>";
                controlHtml += "<tr class='height2'>";
                controlHtml += "<td></td>";
                controlHtml += "</tr>";
            }

        }
        controlHtml += "</table>";
        $("#DivDiagnosticNeedList").html(controlHtml);
        //Added By Mamta Gupta - Ref Task No. 260 - 3.x Issues - To bind blur event with TextArea
        bindevent();
    }
    catch (err) {
        LogClientSideException(err, 'Diagnostic Needs List');
    }
}

//Function to check the blanck value of textboxes.
function CheckForBlankNeed(ClickEvent) {
    try {
        var XmlDiagnosticNeed;
        if (AutoSaveXMLDom == undefined || AutoSaveXMLDom == "")
            return false;
        XmlDiagnosticNeed = $("CustomDocumentAssessmentNeeds", AutoSaveXMLDom);
        if (XmlDiagnosticNeed.length > 0) {
            if (
        (XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("NeedName").length > 0 && XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("NeedName")[0].text.trim() == "")
        &&
        (
            ((XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("RecordDeleted").length > 0) &&
            (XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("RecordDeleted")[0].text.trim() == "N"))
        ||
            (XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("RecordDeleted").length == 0)
        )
        ) {
                if (ClickEvent != undefined && ClickEvent == true) {
                    var NeedList_tab = tabobject.findTabByText('Needs List');
                    NeedList_tab.click();
                }
                return true;

            }
            else if (
        (XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("NeedName").length <= 0) &&
        (
            ((XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("RecordDeleted").length > 0) &&
            (XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("RecordDeleted")[0].text.trim() == "N"))
        ||
            (XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("RecordDeleted").length == 0)
        )
        ) {
                if (ClickEvent != undefined && ClickEvent == true) {
                    var NeedList_tab = tabobject.findTabByText('Needs List');
                    NeedList_tab.click();
                }
                return true;
            }
            else {
                return false;
            }
        }

        return false;
    }
    catch (err) {
        LogClientSideException(err, 'Diagnostic Needs List');
    }
}
//Function to check the blanck value of textboxes after save.
function CheckNeeds(dom) {
    if (dom != undefined) {
        if ((dom != "" && dom[0].childNodes[0].selectNodes("CustomDocumentAssessmentNeeds").length > 0)) {
            xmlAssessmentNeeds = dom[0].childNodes[0].selectNodes("CustomDocumentAssessmentNeeds");
            for (var index = 0; index < xmlAssessmentNeeds.length; index++) {

                if (
                (
                ((xmlAssessmentNeeds[index].selectNodes("NeedName").length <= 0) || (xmlAssessmentNeeds[index].selectNodes("NeedName").length > 0 && xmlAssessmentNeeds[index].selectNodes("NeedName")[0].text.trim() == ""))
                //                ||
                //                ((xmlAssessmentNeeds[index].selectNodes("NeedDescription").length <= 0) || (xmlAssessmentNeeds[index].selectNodes("NeedDescription").length > 0 && xmlAssessmentNeeds[index].selectNodes("NeedDescription")[0].text.trim() == ""))
               )
                && (
                ((xmlAssessmentNeeds[index].selectNodes("RecordDeleted").length > 0) && (xmlAssessmentNeeds[index].selectNodes("RecordDeleted")[0].text.trim() == "N")) || (xmlAssessmentNeeds[index].selectNodes("RecordDeleted").length == 0)
                )
                ) {

                    return false;
                }
            }
            return true;
        }
    }

}

//Function to call autosave request. 
function CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom, CallAutoSave) {
    try {
        SetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom);
        //Check if need to stop autosave request.
        if (CallAutoSave != undefined && CallAutoSave != 'undefined' && CallAutoSave == 'N') {
            return false;
        }
        else {
            Dirty = "True";
            ParentDirty = true;
            if (UnsavedChangeId == 0 && AutoSaveFirstCall == false) {

                if (GetAutoSaveEnabled() == "y") {
                    AutoSaveFirstCall = true;
                    AutoSavePageData();
                }
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'Diagnostic Needs List');
    }
}
//Function to update xml on text change evevnt.

function UpdateAutoSaveXMLValues(columnName, columnvalue, primaryKeyvalue) {
    try {
        var XmlDiagnosticNeed = $("CustomDocumentAssessmentNeeds", AutoSaveXMLDom);
        if (XmlDiagnosticNeed.length > 0) {
            var _xmlDom = GetXMLParentNodeByColumnValue("CustomDocumentAssessmentNeeds", "AssessmentNeedId", primaryKeyvalue, AutoSaveXMLDom[0]);
            if (_xmlDom != null) {
                if (_xmlDom.length > 0) {

                    if (_xmlDom[0].selectSingleNode(columnName) == null) {
                        _xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement(columnName));
                        var nodecol = _xmlDom[0].selectSingleNode(columnName);
                        nodecol.text = columnvalue;
                    }
                    else {
                        var nodecol = _xmlDom[0].selectSingleNode(columnName);
                        nodecol.text = columnvalue;
                    }
                }
            }
        }
        //added for unsaved changes of need description
        if (UnsavedChangeId == 0 && AutoSaveFirstCall == false) {
            CreateUnsavedChangesInstance();
            //Modified by Mamta Gupta - Ref Task 260 - 3.xIssues - Stop to make multiple unsaved instances
            AutoSaveFirstCall = true;
        }
    }
    catch (err) {
        LogClientSideException(err, 'Diagnostic Needs List');
    }
}

//Function used to create html for NeedStatus.


function CreateNeedStatus(i, needStatus, needId) {
    //Addressed in Treatment, Referred to External Provider, Deferred
    var _newCase = true;
    var _addressedinTreatment = "";
    var _referredtoExternalProvider = "";
    var _controlHtml = "";
    var _deferred = "";

    _controlHtml += "<table border='0' cellspacing='0' cellpadding='0' width='97%'>";

    //------Addressed in Treatment
    _addressedinTreatment += "<tr class='RadioText'>";
    _addressedinTreatment += "<td>";
    _addressedinTreatment += "<input class='cursor_default' type='radio' id='RadioButton_CustomDocumentAssessmentNeeds_NeedStatus_6530_" + i + "'";
    _addressedinTreatment += "name='RadioButtonList" + i + "' value='6530' ";

    if ((needStatus == "6530" || needStatus == ""))
        _addressedinTreatment += " checked = 'checked' ";

    _addressedinTreatment += " onclick=\"UpdateAutoSaveXMLValues('NeedStatus',this.value," + needId + ");\"  />";
    _addressedinTreatment += "<label style='padding-left: 4px' for='RadioButton_CustomDocumentAssessmentNeeds_NeedStatus_6530_" + i + "'>Addressed in Treatment</label>";
    _addressedinTreatment += "</td>";
    _addressedinTreatment += "</tr>";
    _addressedinTreatment += "<tr class='height2'>";
    _addressedinTreatment += "<td>";
    _addressedinTreatment += "</td>";
    _addressedinTreatment += "</tr>";

    _controlHtml = _controlHtml + _addressedinTreatment;

    //----------_referredtoExternalProvider
    _referredtoExternalProvider += "<tr class='RadioText'>";
    _referredtoExternalProvider += "<td>";
    _referredtoExternalProvider += "<input class='cursor_default' type='radio' id='RadioButton_CustomDocumentAssessmentNeeds_NeedStatus_6531_" + i + "'";
    _referredtoExternalProvider += "name='RadioButtonList" + i + "' value='6531'";

    if (needStatus == "6531")
        _referredtoExternalProvider += "checked = 'checked' ";

    _referredtoExternalProvider += "onclick=\"UpdateAutoSaveXMLValues('NeedStatus',this.value," + needId + ");\"/>";
    _referredtoExternalProvider += "<label style='padding-left: 4px' for='RadioButton_CustomDocumentAssessmentNeeds_NeedStatus_6531_" + i + "'>Referred to External Provider</label>";
    _referredtoExternalProvider += "</td>";
    _referredtoExternalProvider += "</tr>";
    _referredtoExternalProvider += "<tr class='height2'>";
    _referredtoExternalProvider += "<td>";
    _referredtoExternalProvider += "</td>";
    _referredtoExternalProvider += "</tr>";

    _controlHtml = _controlHtml + _referredtoExternalProvider;

    //-----------Deferred
    _deferred += "<tr class='RadioText'>";
    _deferred += "<td>";
    _deferred += "<input class='cursor_default' type='radio' id='RadioButton_CustomDocumentAssessmentNeeds_NeedStatus_6532_" + i + "'";
    _deferred += "name='RadioButtonList" + i + "' value='6532' ";

    if (needStatus == "6532")
        _deferred += "checked = 'checked' ";

    _deferred += "onclick=\"UpdateAutoSaveXMLValues('NeedStatus',this.value," + needId + ");\"  />";
    _deferred += "<label  style='padding-left: 4px' for='RadioButton_CustomDocumentAssessmentNeeds_NeedStatus_6532_" + i + "'>";
    _deferred += "Deferred</label>";
    _deferred += "</td>";
    _deferred += "</tr>";
    _deferred += "<tr class='height2'>";
    _deferred += "<td>";
    _deferred += "</td>";
    _deferred += "</tr>";

    _controlHtml = _controlHtml + _deferred;
    _controlHtml += "</table>";
    return _controlHtml;
}

//Function used to delete value from need list xml  on basis of Diagnostic NeedId. 

function DeleteNeedListFromXmlBasedOnDiagnosticNeedId(diagnosticNeedId, dom) {
    var XmlDiagnosticNeed = $("CustomDocumentAssessmentNeeds", dom);
    if (XmlDiagnosticNeed.length == 0) {
    }
    else {
        var CustomAssessmentNeedId = $("CustomDocumentAssessmentNeeds DiagnosticNeedId[text=" + DiagnosticNeedId + "]", dom[0]).parent().find("AssessmentNeedId").text();

        if (CustomAssessmentNeedId < 0) {
            CustomSetColumnValueInXMLNodeByKeyValue('CustomDocumentAssessmentNeeds', 'AssessmentNeedId', CustomAssessmentNeedId, 'RecordDeleted', 'Y', dom[0], 'Y');
        }
        else
            CustomSetColumnValueInXMLNodeByKeyValue('CustomDocumentAssessmentNeeds', 'AssessmentNeedId', CustomAssessmentNeedId, 'RecordDeleted', 'Y', dom[0], 'Y');
    }
}



//Function to bind list data when Tab page load.
//function RefreshTabPageContents(tabControl, selectedTabTitle) {
//    try {
//        if (selectedTabTitle == 'Needs List') {
//            BindNeedList(AutoSaveXMLDom);
//        }
//        //        if (selectedTabTitle == 'DLA20') {
//        //            RefreshDLATabPage(AutoSaveXMLDom);
//        //        }

//    }
//    catch (err) {
//        LogClientSideException(err, 'Diagnostic Needs List');
//    }
//}






////***************** DAL Tab******************

//function RefreshDLATabPage(domObject) {
//    if ($("#DivActivityContent")[0].innerHTML != "") {
//        return;
//    }
//    var ReturnHtml = CreateDLAControlHtml(domObject);
//    $("#DivActivityContent").html(ReturnHtml)
//    BindUIstepper();
//    CreateInitializationImages(domObject);

//}

//Function used to set value of need list on basis of DLA. 
//function DiagnosticNeedList(diagnosticNeedId, control, tabName, sectionName, DlaDesc) {
//    var NeedName = "";
//    var NeedDescription = "";
//    var isChecked;    //debugger;

//    if (tabName != "DLA20")
//        isChecked = $("#" + control.id + "").attr("checked");
//    else if (tabName == "DLA20")
//        isChecked = true;

//    if (isChecked == true) {

//        if (tabName == "DLA20") {
//            NeedName = $.xmlDOM($("[id$=HiddenCustomDiagnosticNeedsDataTable]").val()).find("CustomDiagnosticNeeds  DiagnosticNeedId[text=" + diagnosticNeedId + "]").parent().find("NeedName").text();
//            if (DlaDesc != '') {
//                NeedDescription = DlaDesc;
//            }
//            else {
//                NeedDescription = $.xmlDOM($("[id$=HiddenCustomDiagnosticNeedsDataTable]").val()).find("CustomDiagnosticNeeds  DiagnosticNeedId[text=" + diagnosticNeedId + "]").parent().find("NeedDescription").text();
//            }
//        }
//        var makeHTML = true;
//        //debugger;
//        var XmlDiagnosticNeed;
//        XmlDiagnosticNeed = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDocumentAssessmentNeeds");
//        if (XmlDiagnosticNeed.length == 0) {
//            SetValuesNeedList("CustomDocumentAssessmentNeeds", "AssessmentNeedId", "DocumentVersionId", -1, DocumentVersionId, "NeedName^NeedDescription^DiagnosticNeedId", "" + NeedName + "^" + NeedDescription + "^" + diagnosticNeedId, 0, AutoSaveXMLDom);
//        }
//        else if (XmlDiagnosticNeed.length > 0) {
//            //-----Check wether last row is empty or not
//            if ((XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("NeedName").length > 0 && XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("NeedName")[0].text.trim() != "") || (XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("NeedDescription").length > 0 && XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("NeedDescription")[0].text.trim() != "")) {
//                makeHTML = true;

//                var diagnosAssessmentNeedId = XmlDiagnosticNeed[XmlDiagnosticNeed.length - 1].selectNodes("AssessmentNeedId")[0].text;
//                var newdiagnosAssessmentNeedId = -1;
//                if (parseInt(diagnosAssessmentNeedId) > 0)
//                    newdiagnosAssessmentNeedId = -1;
//                else
//                    newdiagnosAssessmentNeedId = parseInt(diagnosAssessmentNeedId) - 1;

//                SetValuesNeedList("CustomDocumentAssessmentNeeds", "AssessmentNeedId", "DocumentVersionId", parseInt(newdiagnosAssessmentNeedId), DocumentVersionId, "NeedName^NeedDescription^DiagnosticNeedId", "" + NeedName + "^" + NeedDescription + "^" + diagnosticNeedId, 0, AutoSaveXMLDom);

//            }
//        }
//        if (makeHTML == true) {

//            XmlDiagnosticNeed = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDocumentAssessmentNeeds");

//        }
//    }
//    else
//        DeleteNeedListFromXmlBasedOnDiagnosticNeedId(diagnosticNeedId, AutoSaveXMLDom);

//}







//var tabobject = null;
//Function to get Tab value when on tab load.
//function StoreTabstripClientObject(sender) {
//    tabobject = sender;
//}

//Function to Bind need list data on updating need list .
//function SetScreenSpecificValues(dom, action) {
//    try {
//        if ((action == pageActionEnum.Update || action == pageActionEnum.None) && tabobject != null) {
//            if (tabobject.get_selectedTab().get_text().indexOf('Needs') >= 0)
//                BindNeedList(dom);
//        }

////        if ((action == pageActionEnum.Update || action == pageActionEnum.None) && tabobject != null) {
////            if (tabobject.get_selectedTab().get_text().indexOf('DLA20') >= 0) {
////                RefreshDLATabPage(dom);
////            }
////        }
//    }
//    catch (err) {
//        LogClientSideException(err, 'Diagnostic Assessment: SetScreenSpecificValues');
//    }
//}

//Function to get Tab value On Tab Selecting  .
//function ClientTabSelectingHandler(sender, eventArgs) {
//    try {
//        var tabStrip = sender;
//        var tab = eventArgs._tab;
//        if (ParentUserControlName == "DiagnosticNeedsList") {
//            if (CheckForBlankNeed(undefined) == true) {
//                ShowHideErrorMessage('Please enter Need name and Need Description before switching to another tab.', 'true');
//                eventArgs.set_cancel(true);
//                return false;
//            }
//            else {
//                ShowHideErrorMessage('', 'false');
//                return true;
//            }
//        }
//        return true;
//    }
//    catch (err) {
//        LogClientSideException(err, 'Diagnostic Needs List');
//    }

//}
//Added By: Amit Kumar Srivastava, to set max length to the text box.
function ismaxlength(obj, needId) {

    var mlength = obj.getAttribute ? parseInt(obj.getAttribute("maxlength")) : "";
    if (obj.getAttribute && obj.value.length > mlength) {
        obj.value = obj.value.substring(0, mlength);
        UpdateAutoSaveXMLValues('NeedName', obj.value,  needId );
    }
    else {
        return false;
    }
}
//Added By Mamta Gupta - Ref Task No. 260 - 3.x Issues - To bind blur event with TextArea
function bindevent() {
    //$("textarea").find("[id*=TextArea_CustomDocumentAssessmentNeeds_NeedName]").blur(function(event) {
    $("[id*=TextArea_CustomDocumentAssessmentNeeds_NeedName]").blur(function(event) {
        var maxLength = 250;
        var length = this.value.length;
        if (length > maxLength) {
            //reassign substring of max length to text area value
            this.value = this.value.substring(0, maxLength);
            UpdateAutoSaveXMLValues('NeedName', this.value, $(this).attr("AssessmentNeedId"));

        }
    });
}