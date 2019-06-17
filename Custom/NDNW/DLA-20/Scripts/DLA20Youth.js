
SCDLAY = function() {
    var constructor = function() {
    }
    return constructor
} ();

SCDLAY.ScoreComments = new Array();
SCDLAY.ScoreComments = ["None of the time; Pervasive, continuous intervention required- Dysfunctional; Extremely severe disabling impairment."
                 , "Almost never; Not functional; Dependent; Severe Impairments."
                 , "Occasionally; Functioning depends on continuous support; Serious substantial Impairment."
                 , "Some of the time; marginal independence Low Level of continuous support; Moderate Impairment."
                 , "A good bit of the time (WNL); Independent with moderate, routine support; Mild problems; social, job."
                 , "Most of the time (WNL); Independent with intermittent support or follow-up; Intermittent problem."
                 , "All of the time (WNL); Optimal & independent asset; no problem."
                 ];
SCDLAY.gselectedTextScore = null;
SCDLAY.gtableName;
SCDLAY.gprimaryKeyName;
SCDLAY.gForeignKeyName;
SCDLAY.gprimaryKeyValue;
SCDLAY.gForeignKeyValue;
SCDLAY.gcolumnName;
SCDLAY.gcolumnValue;
SCDLAY.gObject;
SCDLAY.gTextBoxId;
SCDLAY.gAssociatedHrmNeedId;
SCDLAY.gevent;
SCDLAY.selectedRow = 0;
SCDLAY.DLAYouthClicked = false;


SCDLAY.CreateDLAControlHtml = function (domObject) {
    var ControlHtml = "";
    var RelativePath = GetRelativePath();
    var XmlHrmDla;
    var XmlScore;
    var ScoreLength;
    var Example;

    var _domDLAActivities = $.xmlDOM($("[id$=HiddenCustomHRMActivitiesDataTableYouth]").val())[0];
    XmlHrmDla = _domDLAActivities.firstChild.childNodes;



    XmlScore = domObject[0].childNodes[0].selectNodes("CustomYouthDLAScores")
    ScoreLength = domObject[0].childNodes[0].selectNodes("CustomYouthDLAScores").length;
    var Count = XmlHrmDla.length;
    var Columns = ['DailyLivingActivityId', 'ActivityScore', 'ActivityComment'];
    var j = 2;
    //Changes made by Mamta Gupta - Ref Task No. 513 - 27/Dec/2011 - K starting value change to maintain taborder for DLA tab in Discharge Summary.
    //var k = 1;
    var k = 4;
    var tabIndex = 1;
    for (var i = 0; i < Count; i++) {
        ControlHtml += "<table border='0' cellspacing='0' cellpadding='0' width='100%'   style='padding-left:10px'>";
        ControlHtml += "<tr style='height: 6px;'></tr>";
        ControlHtml += "<tr>";
        ControlHtml += "<td style='width:75%'>";
        ControlHtml += "<div>";
        ControlHtml += "<table border='0' cellspacing='0' cellpadding='0' width='100%'>";
        ControlHtml += "<tr>";
        ControlHtml += "<td>";
        ControlHtml += "<div>";
        ControlHtml += "<table border='0' cellspacing='0' cellpadding='0' width='100%'>";
        ControlHtml += "<tr>";
        ControlHtml += "<td style='width:20%;vertical-align: top;'>";
        var DailyLivingActivityId = XmlHrmDla[i].selectNodes("DailyLivingActivityId")[0].text;

        var AssociatedHRMNeedId = XmlHrmDla[i].selectNodes("AssociatedHRMNeedId")[0] == null ? 0 : XmlHrmDla[i].selectNodes("AssociatedHRMNeedId")[0].text;
        var PrimaryKeyvalue = '-' + (j + i);
        var ForeignKeyValue = DocumentVersionId;
        var YouthDLAScoreId;
        var _documentVersionId;
        var ActivityScore = 0;
        var ActivityComment = "";
        if (ScoreLength > 0) {
            var documentRowFilter = 'DailyLivingActivityId[text=' + DailyLivingActivityId + ']';


            var XmlScore = GetXMLParentNodeByColumnValue("CustomYouthDLAScores", "DailyLivingActivityId", DailyLivingActivityId, domObject);

            //var docummentRowDomFilter = $(documentRowFilter, XmlScore[i]);
            if (XmlScore.length > 0) {
                YouthDLAScoreId = XmlScore[0].selectNodes("YouthDLAScoreId")[0].text;
                _documentVersionId = XmlScore[0].selectNodes("DocumentVersionId")[0].text;

                // Implementing Length check
                documentRowFilterActivityScore = 'YouthDLAScoreId';
                docummentRowDomFilterActivityScore = $(documentRowFilterActivityScore, XmlScore[0]);
                if (docummentRowDomFilterActivityScore.length > 0) {
                    PrimaryKeyvalue = XmlScore[0].selectNodes("YouthDLAScoreId")[0].text;
                }


                // Implementing Length check
                documentRowFilterActivityScore = 'ActivityScore';
                docummentRowDomFilterActivityScore = $(documentRowFilterActivityScore, XmlScore[0]);
                if (docummentRowDomFilterActivityScore.length > 0) {
                    if (XmlScore[0].selectNodes("ActivityScore")[0].text != "") {

                        ActivityScore = XmlScore[0].selectNodes("ActivityScore")[0].text;
                    }
                    else
                        ActivityComment = "";
                }

                // Implementing Length check
                documentRowFilterActivityComment = 'ActivityComment';
                docummentRowDomFilterActivityComment = $(documentRowFilterActivityComment, XmlScore[0]);
                if (docummentRowDomFilterActivityComment.length > 0) {
                    ActivityComment = XmlScore[0].selectNodes("ActivityComment")[0].text;
                }
            }
            else {
                ActivityComment = "";
                ActivityScore = 0;
            }
        }
        else {
            ActivityComment = "";
            ActivityScore = 0;
        }
        var ToBoldVariable = XmlHrmDla[i].selectNodes("HRMActivityDescription")[0].text;
        var FormattedText = SCDLAY.FormattedTextDLA(ToBoldVariable);
        ControlHtml += "<b>";
        ControlHtml += (i + 1).toString() + ". " + FormattedText;
        ControlHtml += "</b>";
        ControlHtml += "</td>";
        ControlHtml += "<td  style='padding-left:10px;width:80%;padding-right:20px;vertical-align: top;'>";
        ControlHtml += "";
        var ToBoldVariable = XmlHrmDla[i].selectNodes("HRMActivityDescription")[0].text.replace(/&lt;/g, '<').replace(/&gt;/g, '>');
        ControlHtml += SCDLAY.FormattedTextDLADescription(ToBoldVariable);
        ControlHtml += "";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr>";
        ControlHtml += "<td style='padding-left:20px'>";
        ControlHtml += "<i>Specify:</i>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "</table>";
        ControlHtml += "</div>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr>";
        ControlHtml += "<td>";
        ControlHtml += "<div>";
        ControlHtml += "<table style='padding-left:0px'>";
        ControlHtml += "<tr>";
        ControlHtml += "<td style='vertical-align: top'>";
        if (XmlHrmDla[i].selectNodes("Example")[0] != null) {
            Example = XmlHrmDla[i].selectNodes("Example")[0].text;
            var newchar = '<br>&#013;'; //'&#013;'
            Example = Example.split('crlf').join(newchar);
        }
        ControlHtml += "<img style='cursor: default;vertical-align: top' id='img21' src='";
        ControlHtml += " ../App_Themes/Includes/Images/info.png' class = 'hastip' title='" + Example + "' />";
        ControlHtml += "</td>";
        ControlHtml += "<td>";
        ControlHtml += "<textarea  BindAutoSaveEvents='False' spellcheck='True' datatype='String' tabindex = " + tabIndex + " class='form_textarea' id='TextArea_CustomYouthDLAScores_ActivityComment_" + i + "' name='TextArea_CustomYouthDLAScores_ActivityComment' rows='3'   onchange=\"SCDLAY.SetValuesDLA('CustomYouthDLAScores', 'YouthDLAScoreId','DocumentVersionId'," + PrimaryKeyvalue + "," + ForeignKeyValue + ",'DailyLivingActivityId:ActivityComment','" + DailyLivingActivityId + "',this ,'TextArea_CustomYouthDLAScores_ActivityComment_" + i + "','" + AssociatedHRMNeedId + "' );\"  cols='1' style='width: 496px' datatype='String'>";
        ControlHtml += ActivityComment;
        tabIndex++;
        ControlHtml += "</textarea>";
        ControlHtml += "</td>";
        ControlHtml += "<td cellspacing='0' cellpadding='0'  style='vertical-align: top;'>";
        ControlHtml += "<div  style='vertical-align: top;'>";
        ControlHtml += "<table cellspacing='0' cellpadding='0'  style='vertical-align: top;'>";
        ControlHtml += "<td>";
        ControlHtml += "<span id='ns_1' class='ui-stepper' >";
        ControlHtml += "<input name='TextBox_CustomYouthDLAScores0_ActivityScore_" + i + "'  tabindex = " + tabIndex + " BindAutoSaveEvents='False' class='ui-stepper-textbox element' id='TextBox_CustomYouthDLAScores0_ActivityScore_" + i + "' onchange=\"SCDLAY.SetValuesDLA('CustomYouthDLAScores', 'YouthDLAScoreId','DocumentVersionId'," + PrimaryKeyvalue + "," + ForeignKeyValue + ",'DailyLivingActivityId:ActivityScore','" + DailyLivingActivityId + "',this,'TextBox_CustomYouthDLAScores0_ActivityScore_" + i + "','" + AssociatedHRMNeedId + "' );\" type='text' size='2' value=" + ActivityScore + " autocomplete='off' bindautosaveevents='False' notexist='true'  class='ui-stepper-textbox'/>";
        tabIndex++;
        ControlHtml += "<img name='ns_button_1_1' class='ui-stepper-plus' style='vertical-align: top; cursor: default;' alt='' src='" + RelativePath + "App_Themes/Includes/Images/toparrow.png' notexist='true'>";
        ControlHtml += "<img name='ns_button_2_1' class='ui-stepper-minus' style='vertical-align: bottom; cursor: default;' src='" + RelativePath + "App_Themes/Includes/Images/bottomarrow.png' notexist='true'>";
        ControlHtml += "</span>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr>";
        ControlHtml += "<td valign='top'><a style='cursor: pointer;' onclick=\"SCDLAY.ShowDiv(" + i + ",'CustomYouthDLAScores', 'YouthDLAScoreId','DocumentVersionId'," + PrimaryKeyvalue + "," + ForeignKeyValue + ",'DailyLivingActivityId:ActivityScore','" + DailyLivingActivityId + "',this,'TextBox_CustomYouthDLAScores0_ActivityScore_" + i + "','" + AssociatedHRMNeedId + "' )\";>";
        ControlHtml += "<span class='span_textunderline_cursor'>Scale</span></a></td>";
        ControlHtml += "</tr>";
        ControlHtml += "</table>";
        ControlHtml += "</div>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "</table>";
        ControlHtml += "</div>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "</table>";
        ControlHtml += "</div>";
        ControlHtml += "</td>";
        ControlHtml += "<td style='width:25%;padding-top:20px'>";
        ControlHtml += "<span id = 'spanScoreDescripion_" + i + "'>";
        if (ActivityScore > 0) {
            ControlHtml += SCDLAY.ScoreComments[(ActivityScore - 1)];
        }
        else {
            ControlHtml += "";
        }
        ControlHtml += "</span>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "</table>";


    }
    //ControlHtml += "</table>";
    return ControlHtml;

}




//Change column value in a specific Row values based on PrimaryKeyId
function CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom, CallAutoSave) {
    SetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom);
    var CreatedBy = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, "CreatedBy", xmlDom);
    if (CreatedBy == '' || CreatedBy == undefined || CreatedBy == null)
        SetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, "CreatedBy", objectPageResponse.LoggedInUserCode, xmlDom);
    var CreatedDate = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, "CreatedDate", xmlDom);
    if (CreatedDate == '' || CreatedDate == undefined || CreatedDate == null)
        SetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, "CreatedDate", ISODateString(new Date()), xmlDom);
    SetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, "ModifiedBy", objectPageResponse.LoggedInUserCode, xmlDom);
    SetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, "ModifiedDate", ISODateString(new Date()), xmlDom);
    //Check if need to stop autosave request.
    if (CallAutoSave != undefined && CallAutoSave != 'undefined' && CallAutoSave == 'N') {
        return false;
    }
    else {
        CreateUnsavedInstanceOnDatasetChange();
    }

}
//Jitender on 10 May,2010
//Set values for Dom Manipulation on HRMSupport
SCDLAY.SetValuesDLA = function(tableName, primaryKeyName, ForeignKeyName, primaryKeyValue, ForeignKeyValue, columnName, columnValue, Object, TextBoxId, AssociatedHrmNeedId, e) {
    columnName = columnName.split(':');
    columnValue = columnValue + '&^@*#%' + $("#" + Object.id)[0].value;
    columnValue = columnValue.split('&^@*#%');
    var ActivityComment = $("#" + TextBoxId).val().trim();
    var fieldvalue = '';
    //Code added with reference to ticket #1028 start
    var xmlScore = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomYouthDLAScores");
    if (xmlScore.length > 0) {
        var ActivityScore = $(xmlScore).find(primaryKeyName + '[text=' + primaryKeyValue + ']').parent().find('ActivityScore').text();
        if (ActivityScore == columnValue[1] && columnName[1] == 'ActivityScore') {
            return false;
        }
        else {
            ActivityScore = columnValue[1];
        }
    }
    //Code added with reference to ticket #1028 end

    //Code added with reference to ticket #596 start
    if (columnValue[1] > 7) {
        columnValue[1] = 0;
    }

    if (columnValue[1] < 7 && columnName[1] == 'ActivityScore' && ActivityScore == 7 && document.getElementById(TextBoxId).disabled == false) {
        document.getElementById(TextBoxId).value = '';
        ActivityComment = '';
    }
    //Code added with reference to ticket #596 end


    //added by priya ref:Task No:221 in UM 2
    if (columnValue[1] > 0 && columnValue[1] > 7 && document.getElementById(TextBoxId).disabled == false) {
        document.getElementById(TextBoxId).value = 'No significant Impairment or problem in functioning.';
        ActivityComment = 'No significant Impairment or problem in functioning.';
    }
    // Code added  with reference to ticket #300 for display textarea value in needs description start

    // Code added  with reference to ticket #300 for display textarea value in needs description end
    columnValue_Length = columnValue.length;
    //var Column2Value = $("#" + i.id)[0].value;
    var primaryKeySet = false;
    for (var k = 0; k < columnValue_Length; k++) {
        var _columnValue = columnValue[k];
        if (columnName[k] == "ActivityScore" && _columnValue == 0)
            _columnValue = "";


        //for new mode
        if (primaryKeyValue <= 0) {

            //Start set value for FK
            //Changes to make RAP Tab in Unsave Changes Area
            var fk = ForeignKeyValue;
            // end set value for FK
            //Check nodexml with tablename and primary key

            var _xmlDom = GetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'DocumentVersionId', AutoSaveXMLDom[0]);
            if (_xmlDom.length == 0 && primaryKeySet == false) {
                //create table if not exist in xml
                //Append column key with value
                AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement(tableName)); //Add table in the XML Dom
                var _currentNode = "";
                _currentNode = AutoSaveXMLDom[0].childNodes[0].lastChild.appendChild(AutoSaveXMLDom[0].createElement(primaryKeyName));
                _currentNode.text = primaryKeyValue;
                primaryKeySet = true;
                CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, ForeignKeyName, ForeignKeyValue, AutoSaveXMLDom[0], 'Y');
            }

            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName[k], _columnValue, AutoSaveXMLDom[0], 'Y');

        }
        else {
            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, columnName[k], _columnValue, AutoSaveXMLDom[0], 'Y');
        }
        //Commented with reference to ticket #596

        if (columnName[k] == "ActivityScore") {
            var rowNum = 0;
            if (parseInt(TextBoxId.substr((TextBoxId.length - 2), TextBoxId.length)) > 9) {
                rowNum = TextBoxId.substr((TextBoxId.length - 2), TextBoxId.length);
            }
            else {
                rowNum = TextBoxId.substr((TextBoxId.length - 1), TextBoxId.length);
            }
            if (_columnValue != "") {
                if (parseInt(_columnValue) > 0) {
                    SCDLAY.setScoreComments(rowNum, _columnValue);
                }
                else {
                    SCDLAY.setScoreComments(rowNum, _columnValue, 0);
                }
            }
            else {
                SCDLAY.setScoreComments(rowNum, _columnValue, 0);
            }
            SCDLAY.CalculateScores();
        }
        // if (ActivityComment != '')
        if (columnName[1] == "ActivityComment") {
            CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyName, primaryKeyValue, 'ActivityComment', ActivityComment, AutoSaveXMLDom[0], 'Y');
        }
    }
}


function BindUIstepper() {
    try {
        $("span[class='ui-stepper']").stepper({ start: 0, min: 0, max: 7, step: 1 });
    }
    catch (ex) {
        throw ex;
    }
}

//Code Added with reference to ticket #325 end

SCDLAY.ShowDiv = function(selectedTextRow, tableName, primaryKeyName, ForeignKeyName, primaryKeyValue, ForeignKeyValue, columnName, columnValue, Object, TextBoxId, AssociatedHrmNeedId, e) {

    SCDLAY.selectedRow = selectedTextRow;
    SCDLAY.selectedTextScore = selectedTextRow;
    SCDLAY.gtableName = tableName;
    SCDLAY.gprimaryKeyName = primaryKeyName;
    SCDLAY.gForeignKeyName = ForeignKeyName;
    SCDLAY.gprimaryKeyValue = primaryKeyValue;
    SCDLAY.gForeignKeyValue = ForeignKeyValue;
    SCDLAY.gcolumnName = columnName;
    SCDLAY.gcolumnValue = columnValue;
    SCDLAY.gObject = Object;
    SCDLAY.gTextBoxId = TextBoxId;
    SCDLAY.gAssociatedHrmNeedId = AssociatedHrmNeedId;
    SCDLAY.gevent = e;
    SCDLAY.DLAYouthClicked = true;
    parent.OpenPage(5765, 22309, '', null, $("input[id$=RelativePath]").val(), 'T', "dialogHeight: 280px; dialogWidth: 660px;dialogTitle:DLA Scale;defaultCloseButtonID:btnClose");


}


SCDLAY.FormattedTextDLA = function(ToBoldVariable) {
    try {
        var StringArray = '';
        var Seprator = ':'
        StringArray = ToBoldVariable.split(Seprator)
        ToBoldVariable = '';
        ToBoldVariable += StringArray[0];
        return ToBoldVariable;
    }
    catch (ex) {
        throw ex;
    }
}

SCDLAY.FormattedTextDLADescription = function(ToBoldVariable) {
    try {
        var StringArray = '';
        var Seprator = ':'
        StringArray = ToBoldVariable.split(Seprator)
        ToBoldVariable = '';
        ToBoldVariable += StringArray[1];
        return ToBoldVariable;
    }
    catch (ex) {
        throw ex;
    }
}
SCDLAY.ShowDLAExample = function(exampleText) {
    ShowMsgBox(exampleText, 'Example', MessageBoxButton.OK, MessageBoxIcon.Information, undefined, undefined, undefined, 200, 660);
}

function UiStepperValueChaged(sender) {
    $(sender).focus();
   // $(sender).change();
    CreateUnsavedInstanceOnDatasetChange();
}

SCDLAY.SetScoreValueAndClose = function(selectedScore) {
    SCDLAY.setScoreComments(SCDLAY.selectedRow, selectedScore);
    $("#TextBox_CustomYouthDLAScores0_ActivityScore_" + SCDLAY.selectedTextScore + "").val(selectedScore);
    var object = $("#TextBox_CustomYouthDLAScores0_ActivityScore_" + SCDLAY.selectedTextScore + "")[0];
    SCDLAY.SetValuesDLA(SCDLAY.gtableName, SCDLAY.gprimaryKeyName, SCDLAY.gForeignKeyName, SCDLAY.gprimaryKeyValue, SCDLAY.gForeignKeyValue, SCDLAY.gcolumnName, SCDLAY.gcolumnValue, object, SCDLAY.gTextBoxId, SCDLAY.gAssociatedHrmNeedId, SCDLAY.gevent)
}

SCDLAY.setScoreComments = function(row, score, rowzero) {
    if (rowzero == 0) {
        $("#spanScoreDescripion_" + row).html("");
    }
    else {
        $("#spanScoreDescripion_" + row).html(SCDLAY.ScoreComments[(score - 1)]);
    }
}

SCDLAY.CalculateScores = function() {
    var TotalScore = 0;
    var AverageScore = 0;
    var EstimateGAF = 0;
    var nQuestionsAnswered = 0;
    var LatestAvgDLA = $('CustomDocumentMHAContents > LatestAverageDLA', AutoSaveXMLDom).text();
    $("input[type=text].ui-stepper-textbox").each(function() {
        if (isNaN(parseInt(this.value)) == true) {
            this.value = "0";
        }
        if (parseInt(this.value) != undefined) {
            TotalScore = TotalScore + (parseInt(this.value));
            if (parseInt(this.value) > 0) {
                nQuestionsAnswered = nQuestionsAnswered + 1;
            }
        }
    });

    AverageScore = TotalScore / nQuestionsAnswered;
    AverageScore = (AverageScore).toFixed(2);
    if (isNaN(AverageScore)) {
        AverageScore = 0;
    }
    $("#TextBoxSum20Ratings").val(TotalScore);
    $("#TextBoxAverageDLA").val(AverageScore);

    //GAF Score Calculation
    if (nQuestionsAnswered > 0) {
        EstimateGAF = (AverageScore * 10.0).toFixed(2);
    }
    if (EstimateGAF == 0)
        $("#TextBoxEstimateGAF").val("");
    else {
        $("#TextBoxEstimateGAF").val(EstimateGAF);
    }
    var changeScore = 0;
    if (LatestAvgDLA != "") {
        changeScore = LatestAvgDLA - AverageScore;
        changeScore = (changeScore).toFixed(2);
    }
    if (isNaN(changeScore)) {
        changeScore = 0;
    }
    $("#TextBoxChangeScoreDLA").val(changeScore);
}








