
var ScoreComments = new Array();
ScoreComments = ["None of the time; extremely severe impairment or problems in functioning; pervasive level of continuous paid supports needed."
                 , "A little of the time; severe impairment or problems in functioning; extensive level of continuous paid supports needed."
                 , "Occasionally; moderately severe impairment or problems in functioning; moderate level of continuous paid supports needed."
                 , "Some of the time; moderate impairment or problems in functioning; moderate level of continuous paid supports needed."
                 , "A good bit of the time; mild impairment or problems in functioning; moderate level of intermittent paid supports needed."
                 , "Most of the time; very mild impairment or problems in functioning; low level of intermittent paid supports needed."
                 , "All of the time; no significant impairment or problems in functioning requiring paid supports."
                 ];
var gselectedTextScore = null;
var gtableName;
var gprimaryKeyName;
var gForeignKeyName;
var gprimaryKeyValue;
var gForeignKeyValue;
var gcolumnName;
var gcolumnValue;
var gObject;
var gTextBoxId;
var gAssociatedHrmNeedId;
var gevent;
var selectedRow = 0;
function CreateDLAControlHtmlOld(domObject) {
    var ControlHtml = "";
    var RelativePath = GetRelativePath();
    var XmlHrmDla;
    var XmlScore;
    var ScoreLength;
    var Example;

    var _domDLAActivities = $.xmlDOM($("[id$=HiddenCustomHRMActivitiesDataTable]").val())[0];
    XmlHrmDla = _domDLAActivities.firstChild.childNodes;



    XmlScore = domObject[0].childNodes[0].selectNodes("CustomDailyLivingActivityScores")
    ScoreLength = domObject[0].childNodes[0].selectNodes("CustomDailyLivingActivityScores").length;
    var Count = XmlHrmDla.length;
    var Columns = ['HRMActivityId', 'ActivityScore', 'ActivityComment'];
    var j = 2;
    //Changes made by Mamta Gupta - Ref Task No. 513 - 27/Dec/2011 - K starting value change to maintain taborder for DLA tab in Discharge Summary.
    //var k = 1;
    var k = 4;
    for (var i = 0; i < Count; i++) {
        ControlHtml += "<table border='0' cellspacing='0' cellpadding='0' width='100%'>";
        ControlHtml += "<tr height='10px'>";
        ControlHtml += "<td colspan='2'>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr id='row_" + i + "'>";
        ControlHtml += "<td style='width: 1%'>";
        ControlHtml += "</td>";
        ControlHtml += "<td style='width: 99%' align='left' >";
        ControlHtml += "<table border='0' cellpadding='0' width='100%' cellspacing='0'>";
        ControlHtml += "<tr>";
        ControlHtml += "<td width='20px' >";
        ControlHtml += "<span id='ns_1' class='ui-stepper' >";
        var HRMActivityId = XmlHrmDla[i].selectNodes("HRMActivityId")[0].text;
        var AssociatedHRMNeedId = XmlHrmDla[i].selectNodes("AssociatedHRMNeedId")[0] == null ? 0 : XmlHrmDla[i].selectNodes("AssociatedHRMNeedId")[0].text;
        var PrimaryKeyvalue = '-' + j;
        var ForeignKeyValue = DocumentVersionId;
        var DailyLivingActivityScoreId;
        var _documentVersionId;
        var ActivityScore = 0;
        var ActivityComment = "";
        if (ScoreLength > 0) {
            var documentRowFilter = 'HRMActivityId[text=' + HRMActivityId + ']';


            var XmlScore = GetXMLParentNodeByColumnValue("CustomDailyLivingActivityScores", "HRMActivityId", HRMActivityId, domObject);

            //var docummentRowDomFilter = $(documentRowFilter, XmlScore[i]);
            if (XmlScore.length > 0) {
                DailyLivingActivityScoreId = XmlScore[0].selectNodes("DailyLivingActivityScoreId")[0].text;
                _documentVersionId = XmlScore[0].selectNodes("DocumentVersionId")[0].text;

                // Implementing Length check
                documentRowFilterActivityScore = 'DailyLivingActivityScoreId';
                docummentRowDomFilterActivityScore = $(documentRowFilterActivityScore, XmlScore[0]);
                if (docummentRowDomFilterActivityScore.length > 0) {
                    PrimaryKeyvalue = XmlScore[0].selectNodes("DailyLivingActivityScoreId")[0].text;
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


        ////                ControlHtml += "<input id='TextBox_CustomCAFAS_SchoolPerformance_" + i + "'  type='text' name='TextBox_CustomCAFAS_SchoolPerformance value='" + ActivityScore + "'";
        ControlHtml += "<input type='text' id='TextBox_CustomDailyLivingActivityScores0_ActivityScore_" + i + "'  type='text' name='TextBox_CustomDailyLivingActivityScores0_ActivityScore_" + i + "' value='" + ActivityScore + "' tabindex='" + k + "'";

        ControlHtml += "size='2' NotExist='true' BindAutoSaveEvents='False' onChange=\"SetValuesDLA('CustomDailyLivingActivityScores', 'DailyLivingActivityScoreId','DocumentVersionId'," + PrimaryKeyvalue + "," + ForeignKeyValue + ",'HRMActivityId:ActivityScore','" + HRMActivityId + "',this,'TextArea_CustomDailyLivingActivityScores_ActivityComment_" + i + "','" + AssociatedHRMNeedId + "' );\"    autocomplete='off' class='ui-stepper-textbox' />";
        ControlHtml += "<img name='ns_button_1_1' NotExist='true' class='ui-stepper-plus' style='vertical-align: top; cursor: default'";
        ControlHtml += "src='" + RelativePath + "App_Themes/Includes/Images/toparrow.png' alt=''  />";
        ControlHtml += "<img name='ns_button_2_1' NotExist='true' class='ui-stepper-minus' style='vertical-align: bottom;";
        ControlHtml += "cursor: default' src='" + RelativePath + "App_Themes/Includes/Images/bottomarrow.png' />";
        ControlHtml += "</span>";
        ControlHtml += "</td>";
        ControlHtml += "<td align='left' style='padding-left:5px;'>";
        var ToBoldVariable = XmlHrmDla[i].selectNodes("HRMActivityDescription")[0].text;
        var FormattedText = FormattedTextDLA(ToBoldVariable);
        FormattedText = FormattedText + "<span id='span_" + i + "' </span>";
        ControlHtml += FormattedText;
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr style='height: 5px;'>";
        ControlHtml += "<td colspan='2'>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr>";
        ControlHtml += "<td valign='top'>";
        ControlHtml += "<table border='0' cellpadding='0' width='100%' cellspacing='0'>";
        ControlHtml += "<tr>";
        ControlHtml += "<td valign='top'>";
        ControlHtml += "<a style='cursor:hand' onclick='javascript:ShowDiv(" + i + ",'CustomDailyLivingActivityScores', 'DailyLivingActivityScoreId','DocumentVersionId'," + PrimaryKeyvalue + "," + ForeignKeyValue + ",'HRMActivityId:ActivityScore','" + HRMActivityId + "',this,'TextArea_CustomDailyLivingActivityScores_ActivityComment_" + i + "','" + AssociatedHRMNeedId + "' );return false;'><span class='span_textunderline_cursor' >Scale</span></a>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr style='height: 8px'>";
        ControlHtml += "<td>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr>";
        ControlHtml += "<td valign='bottom'>";
        if (XmlHrmDla[i].selectNodes("Example")[0] != null) {
            Example = XmlHrmDla[i].selectNodes("Example")[0].text;
        }
        ControlHtml += "<a style='cursor:hand' class='span_textunderline_cursor' onclick=\"javascript:ShowDLAExample('" + Example + "');\">Example</a>";
        ControlHtml += " </td>";
        ControlHtml += "</tr>";
        ControlHtml += "</table>";
        ControlHtml += "</td>";
        ControlHtml += "<td>";
        k += 1;
        var ColumnsValue = [XmlHrmDla[i].selectNodes("HRMActivityId")[0].text, i];
        ControlHtml += "<textarea BindAutoSaveEvents='False' spellcheck='True' datatype='String' class='form_textarea' id='TextArea_CustomDailyLivingActivityScores_ActivityComment_" + i + "' name='TextArea_CustomDailyLivingActivityScores_ActivityComment' tabindex='" + k + "'";
        ControlHtml += "rows='3'   onchange=\"SetValuesDLA('CustomDailyLivingActivityScores', 'DailyLivingActivityScoreId','DocumentVersionId'," + PrimaryKeyvalue + "," + ForeignKeyValue + ",'HRMActivityId:ActivityComment','" + HRMActivityId + "',this ,'TextArea_CustomDailyLivingActivityScores_ActivityComment_" + i + "','" + AssociatedHRMNeedId + "' );\"  cols='1' style='width: 690px' datatype='String'>" + ActivityComment + "</textarea>";
        ControlHtml += "<span id='CustomDailyLivingActivityScores_DailyLivingActivityScoreId_" + i + "' pKey='" + PrimaryKeyvalue + "' pcKey='" + ActivityScore + "' rowId='row_" + i + "'></span>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "</table>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr height='10px'>";
        ControlHtml += "<td colspan='2'>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        j++;
        k += 1;

    }
    ControlHtml += "</table>";
    return ControlHtml;

}

function CreateDLAControlHtml(domObject) {
    var ControlHtml = "";
    var RelativePath = GetRelativePath();
    var XmlHrmDla;
    var XmlScore;
    var ScoreLength;
    var Example;
    
    var _domDLAActivities = $.xmlDOM($("[id$=HiddenCustomHRMActivitiesDataTable]").val())[0];
    XmlHrmDla = _domDLAActivities.firstChild.childNodes;



    XmlScore = domObject[0].childNodes[0].selectNodes("CustomDailyLivingActivityScores")
    ScoreLength = domObject[0].childNodes[0].selectNodes("CustomDailyLivingActivityScores").length;
    var Count = XmlHrmDla.length;
    var Columns = ['HRMActivityId', 'ActivityScore', 'ActivityComment'];
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
        ControlHtml += "<td style='width:20%'>";
        var HRMActivityId = XmlHrmDla[i].selectNodes("HRMActivityId")[0].text;

        var AssociatedHRMNeedId = XmlHrmDla[i].selectNodes("AssociatedHRMNeedId")[0] == null ? 0 : XmlHrmDla[i].selectNodes("AssociatedHRMNeedId")[0].text;
        var PrimaryKeyvalue = '-' + (j+i);
        var ForeignKeyValue = DocumentVersionId;
        var DailyLivingActivityScoreId;
        var _documentVersionId;
        var ActivityScore = 0;
        var ActivityComment = "";
        if (ScoreLength > 0) {
            var documentRowFilter = 'HRMActivityId[text=' + HRMActivityId + ']';


            var XmlScore = GetXMLParentNodeByColumnValue("CustomDailyLivingActivityScores", "HRMActivityId", HRMActivityId, domObject);

            //var docummentRowDomFilter = $(documentRowFilter, XmlScore[i]);
            if (XmlScore.length > 0) {
                DailyLivingActivityScoreId = XmlScore[0].selectNodes("DailyLivingActivityScoreId")[0].text;
                _documentVersionId = XmlScore[0].selectNodes("DocumentVersionId")[0].text;

                // Implementing Length check
                documentRowFilterActivityScore = 'DailyLivingActivityScoreId';
                docummentRowDomFilterActivityScore = $(documentRowFilterActivityScore, XmlScore[0]);
                if (docummentRowDomFilterActivityScore.length > 0) {
                    PrimaryKeyvalue = XmlScore[0].selectNodes("DailyLivingActivityScoreId")[0].text;
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
        var FormattedText = FormattedTextDLA(ToBoldVariable);
        ControlHtml += "<b>";
        ControlHtml += (i+1).toString()+". " + FormattedText;
        ControlHtml += "</b>";
        ControlHtml += "</td>";
        ControlHtml += "<td  style='padding-left:10px;width:80%'>";
        ControlHtml += "";
        var ToBoldVariable = XmlHrmDla[i].selectNodes("HRMActivityDescription")[0].text;
        ControlHtml += FormattedTextDLADescription(ToBoldVariable); 
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
        ControlHtml += "<td>";
        if (XmlHrmDla[i].selectNodes("Example")[0] != null) {
            Example = XmlHrmDla[i].selectNodes("Example")[0].text;
            var newchar = '<br>&#013;'; //'&#013;'
            Example = Example.split('crlf').join(newchar);
        }
        ControlHtml += "<img style='cursor: default;vertical-align: middle' id='img21' src='";
        ControlHtml += " ../App_Themes/Includes/Images/info.png' class = 'hastip' title='" + Example + "' />";
        ControlHtml += "</td>";
        ControlHtml += "<td>";
        ControlHtml += "<textarea  BindAutoSaveEvents='False' spellcheck='True' datatype='String' tabindex = " + tabIndex + " class='form_textarea' id='TextArea_CustomDailyLivingActivityScores_ActivityComment_" + i + "' name='TextArea_CustomDailyLivingActivityScores_ActivityComment' rows='3'   onchange=\"SetValuesDLA('CustomDailyLivingActivityScores', 'DailyLivingActivityScoreId','DocumentVersionId'," + PrimaryKeyvalue + "," + ForeignKeyValue + ",'HRMActivityId:ActivityComment','" + HRMActivityId + "',this ,'TextArea_CustomDailyLivingActivityScores_ActivityComment_" + i + "','" + AssociatedHRMNeedId + "' );\"  cols='1' style='width: 476px' datatype='String'>";
        ControlHtml += ActivityComment;
        tabIndex++;
        ControlHtml += "</textarea>";
        ControlHtml += "</td>";
        ControlHtml += "<td cellspacing='0' cellpadding='0'  style='vertical-align: top;'>";
        ControlHtml += "<div  style='vertical-align: top;'>";
        ControlHtml += "<table cellspacing='0' cellpadding='0'  style='vertical-align: top;'>";
        ControlHtml += "<td>";
        ControlHtml += "<span id='ns_1' class='ui-stepper' >";
        ControlHtml += "<input name='TextBox_CustomDailyLivingActivityScores0_ActivityScore_" + i + "'  tabindex = " + tabIndex + " BindAutoSaveEvents='False' class='ui-stepper-textbox element' id='TextBox_CustomDailyLivingActivityScores0_ActivityScore_" + i + "' onchange=\"SetValuesDLA('CustomDailyLivingActivityScores', 'DailyLivingActivityScoreId','DocumentVersionId'," + PrimaryKeyvalue + "," + ForeignKeyValue + ",'HRMActivityId:ActivityScore','" + HRMActivityId + "',this,'TextBox_CustomDailyLivingActivityScores0_ActivityScore_" + i + "','" + AssociatedHRMNeedId + "' );\" type='text' size='2' value=" + ActivityScore + " autocomplete='off' bindautosaveevents='False' notexist='true'  class='ui-stepper-textbox'/>";
        tabIndex++;
        ControlHtml += "<img name='ns_button_1_1' class='ui-stepper-plus' style='vertical-align: top; cursor: default;' alt='' src='" + RelativePath + "App_Themes/Includes/Images/toparrow.png' notexist='true'>";
        ControlHtml += "<img name='ns_button_2_1' class='ui-stepper-minus' style='vertical-align: bottom; cursor: default;' src='" + RelativePath + "App_Themes/Includes/Images/bottomarrow.png' notexist='true'>";
        ControlHtml += "</span>";
        ControlHtml += "</td>";
        ControlHtml += "</tr>";
        ControlHtml += "<tr>";
        ControlHtml += "<td valign='top'><a style='cursor: pointer;' onclick=\"ShowDiv(" + i + ",'CustomDailyLivingActivityScores', 'DailyLivingActivityScoreId','DocumentVersionId'," + PrimaryKeyvalue + "," + ForeignKeyValue + ",'HRMActivityId:ActivityScore','" + HRMActivityId + "',this,'TextBox_CustomDailyLivingActivityScores0_ActivityScore_" + i + "','" + AssociatedHRMNeedId + "' )\";>";
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
            ControlHtml += ScoreComments[(ActivityScore - 1)];
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
function SetValuesDLA(tableName, primaryKeyName, ForeignKeyName, primaryKeyValue, ForeignKeyValue, columnName, columnValue, Object, TextBoxId, AssociatedHrmNeedId, e) {
    columnName = columnName.split(':');
    columnValue = columnValue + '&^@*#%' + $("#" + Object.id)[0].value;
    columnValue = columnValue.split('&^@*#%');
    var ActivityComment = $("#" + TextBoxId).val().trim();
    var fieldvalue = '';
    //Code added with reference to ticket #1028 start
    var xmlScore = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDailyLivingActivityScores");
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


    var CustomHRMAssessmentNeedId = $("CustomHRMAssessmentNeeds HRMNeedId[text=" + AssociatedHrmNeedId + "]", AutoSaveXMLDom[0]).parent().find("HRMAssessmentNeedId").text();
    var CustomRecordDeleted = $("CustomHRMAssessmentNeeds HRMNeedId[text=" + AssociatedHrmNeedId + "]", AutoSaveXMLDom[0]).parent().find("RecordDeleted").text();
    var needDesc = $("#" + TextBoxId).val().trim();
    //start
    if (ParentUserControlName != "DischargeTabPage_C5" && columnName.length > 0 && columnName[1] != "ActivityComment") {
        if (columnValue[1] > 0 && columnValue[1] <= 4) {
            var xmlNeed = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentNeeds");
            if (xmlNeed.length > 0) {
                var CustomHRMAssessmentNeedId = $("CustomHRMAssessmentNeeds HRMNeedId[text=" + AssociatedHrmNeedId + "]", AutoSaveXMLDom[0]).parent().find("HRMAssessmentNeedId").text();
                var CustomRecordDeleted = $("CustomHRMAssessmentNeeds HRMNeedId[text=" + AssociatedHrmNeedId + "]", AutoSaveXMLDom[0]).parent().find("RecordDeleted").text();
                if (CustomHRMAssessmentNeedId != "") {
                }
                else {
                    //HRMNeedList(AssociatedHrmNeedId, "", "DLA", "", needDesc);
                }
                if (CustomHRMAssessmentNeedId != "" && CustomRecordDeleted == 'Y') {
                    CustomSetColumnValueInXMLNodeByKeyValue('CustomHRMAssessmentNeeds', 'HRMAssessmentNeedId', CustomHRMAssessmentNeedId, 'RecordDeleted', 'N', AutoSaveXMLDom[0], 'Y');
                    //Changes made by Vikas Kashyup- Ref Task 131 SCWebPhaseII Bugs/Features 21/Nov/2011- To insert DeletedDate and DeletedBy value in xml
                    CustomSetColumnValueInXMLNodeByKeyValue('CustomHRMAssessmentNeeds', 'HRMAssessmentNeedId', CustomHRMAssessmentNeedId, 'DeletedBy', '', AutoSaveXMLDom[0], 'Y');
                    CustomSetColumnValueInXMLNodeByKeyValue('CustomHRMAssessmentNeeds', 'HRMAssessmentNeedId', CustomHRMAssessmentNeedId, 'DeletedDate', '', AutoSaveXMLDom[0], 'Y');
                    //HRMNeedList(AssociatedHrmNeedId, "", "DLA", "", needDesc);
                }
            }
            else {
                //HRMNeedList(AssociatedHrmNeedId, "", "DLA", "", needDesc);
            }


        }

        if (columnValue[1] == 0 || columnValue[1] > 4) {
            var xmlNeed = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentNeeds");

            if (xmlNeed.length > 0) {
                var CustomHRMAssessmentNeedId = $("CustomHRMAssessmentNeeds HRMNeedId[text=" + AssociatedHrmNeedId + "]", AutoSaveXMLDom[0]).parent().find("HRMAssessmentNeedId").text();
                if (CustomHRMAssessmentNeedId != "") {
                    DeleteNeedListFromXmlBasedOnHrmNeedId(AssociatedHrmNeedId, AutoSaveXMLDom);
                    var CustomRecordDeleted = $("CustomHRMAssessmentNeeds HRMNeedId[text=" + AssociatedHrmNeedId + "]", AutoSaveXMLDom[0]).parent().find("RecordDeleted").text();
                }
            }

        }

        //        if (columnValue[1] > 0 && columnValue[1] == 7 && document.getElementById(TextBoxId).disabled == false) {
        //            document.getElementById(TextBoxId).value = 'No significant Impairment or problem in functioning.';
        //            ActivityComment = 'No significant Impairment or problem in functioning.';
        //        }
    } //end
    //added by priya ref:Task No:221 in UM 2
    if (columnValue[1] > 0 && columnValue[1] > 7 && document.getElementById(TextBoxId).disabled == false) {
        document.getElementById(TextBoxId).value = 'No significant Impairment or problem in functioning.';
        ActivityComment = 'No significant Impairment or problem in functioning.';
    }
    // Code added  with reference to ticket #300 for display textarea value in needs description start
    else if (columnName.length > 0 && columnName[1] == "ActivityComment" && CustomHRMAssessmentNeedId != "") {
        // var _needDescription = columnValue[1].trim();
        var _needDescription = document.getElementById(TextBoxId).value.trim();
        if (_needDescription == "") {
            _needDescription = $.xmlDOM($("[id$=HiddenCustomHRMNeedsDataTable]").val()).find("CustomHRMNeeds  HRMNeedId[text=" + AssociatedHrmNeedId + "]").parent().find("NeedDescription").text();
        }
        //SetValuesNeedList("CustomHRMAssessmentNeeds", "HRMAssessmentNeedId", "DocumentVersionId", CustomHRMAssessmentNeedId, DocumentVersionId, "NeedDescription", _needDescription, 0, AutoSaveXMLDom);

    }
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
            if (parseInt(TextBoxId.substr((TextBoxId.length - 2), TextBoxId.length)) >9) {
               rowNum = TextBoxId.substr((TextBoxId.length - 2), TextBoxId.length);
            }
            else{
               rowNum = TextBoxId.substr((TextBoxId.length - 1), TextBoxId.length);
            }
            if (_columnValue != "") {
                if (parseInt(_columnValue) > 0) {
                    setScoreComments(rowNum, _columnValue);
                }
                else {
                    setScoreComments(rowNum, _columnValue, 0);
                }
            }
            else {
                setScoreComments(rowNum, _columnValue, 0);
            }
            CalculateScores();
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

function ShowDiv(selectedTextRow, tableName, primaryKeyName, ForeignKeyName, primaryKeyValue, ForeignKeyValue, columnName, columnValue, Object, TextBoxId, AssociatedHrmNeedId, e) {
    
    selectedRow = selectedTextRow;
    selectedTextScore = selectedTextRow;
    gtableName = tableName;
    gprimaryKeyName = primaryKeyName;
    gForeignKeyName = ForeignKeyName;
    gprimaryKeyValue = primaryKeyValue;
    gForeignKeyValue = ForeignKeyValue;
    gcolumnName = columnName;
    gcolumnValue = columnValue;
    gObject = Object;
    gTextBoxId = TextBoxId;
    gAssociatedHrmNeedId = AssociatedHrmNeedId;
    gevent = e;
    parent.OpenPage(5765, 22309, '', null, $("input[id$=RelativePath]").val(), 'T', "dialogHeight: 280px; dialogWidth: 660px;dialogTitle:DLA Scale;defaultCloseButtonID:btnClose");

//    var dlaScaleText = '1 – None of the time; extremely severe impairment or problems in functioning;' +
//                       ' pervasive level of continuous paid supports needed.</br> 2 – A little of the time; ' +
//                       'severe impairment or problems in functioning; extensive level of continuous paid supports ' +
//                       'needed.</br> 3 – Occasionally; moderately severe impairment or problems in functioning; ' +
//                       'moderate level of continuous paid supports needed.</br> 4 – Some of the time; moderate ' +
//                       'impairment or problems in functioning; moderate level of continuous paid supports needed.</br> ' +
//                       '5 – A good bit of the time; mild impairment or problems in functioning; moderate level of intermittent ' +
//                       'paid supports needed.</br> 6 – Most of the time; very mild impairment or problems in functioning; ' +
//                       'low level of intermittent paid supports needed.</br>7 – All of the time; ' +
//                       'no significant impairment or problems in functioning requiring paid supports.</br>';
//    ShowMsgBox(dlaScaleText, 'Help', MessageBoxButton.OK, MessageBoxIcon.Information, undefined, undefined, undefined, 205, 460);

}

//Description:Function is used to Fill current client Values
//Author:Sandeep singh
//CreatedOn:07-April-2010

function FormattedTextDLA(ToBoldVariable) {
    try {
        var StringArray = '';
        var Seprator = ':'
        StringArray = ToBoldVariable.split(Seprator)
        ToBoldVariable = '';
        ToBoldVariable +=  StringArray[0];
        return ToBoldVariable;
    }
    catch (ex) {
        throw ex;
    }
}

function FormattedTextDLADescription(ToBoldVariable) {
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
//Function added by Mahesh with refrence to ticket #492
function ShowDLAExample(exampleText) {
    ShowMsgBox(exampleText, 'Example', MessageBoxButton.OK, MessageBoxIcon.Information, undefined, undefined, undefined, 200, 660);
}

/*Added By Mahesh */
function UiStepperValueChaged(sender) {
    //Written by Pradeep to set focus as per task#172
    $(sender).focus();
    $(sender).change();
    CreateUnsavedInstanceOnDatasetChange();
}

function SetScoreValueAndClose(selectedScore) {
    setScoreComments(selectedRow, selectedScore);
    $("#TextBox_CustomDailyLivingActivityScores0_ActivityScore_" + selectedTextScore + "").val(selectedScore);
    var object = $("#TextBox_CustomDailyLivingActivityScores0_ActivityScore_" + selectedTextScore + "")[0];
    SetValuesDLA(gtableName, gprimaryKeyName, gForeignKeyName, gprimaryKeyValue, gForeignKeyValue, gcolumnName, gcolumnValue, object, gTextBoxId, gAssociatedHrmNeedId, gevent)
}

function setScoreComments(row, score, rowzero) {
    if (rowzero == 0) {
        $("#spanScoreDescripion_" + row).html("");
    }
    else {
        $("#spanScoreDescripion_" + row).html(ScoreComments[(score - 1)]);
    }
}

function CalculateScores() {
    var TotalScore = 0;
    var AverageScore = 0;
    var EstimateGAF = 0;
    var nQuestionsAnswered = 0;

    $("input[type=text].ui-stepper-textbox").each(function() {
        if (isNaN(parseInt(this.value)) == true) {
            this.value = "0";
        }
        if (parseInt(this.value) != undefined) {
            TotalScore = TotalScore + (parseInt(this.value));
            if (parseInt(this.value) > 0) {
                nQuestionsAnswered = nQuestionsAnswered+1;
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
    if(15 > nQuestionsAnswered)
        EstimateGAF = 0;
    else if (20 == nQuestionsAnswered) {
        EstimateGAF = (TotalScore / 2.0).toFixed(2);
    }
    else {
        EstimateGAF = (AverageScore * 10.0).toFixed(2);
    }
    if (EstimateGAF == 0)
        $("#TextBoxEstimateGAF").val("");
    else {
        $("#TextBoxEstimateGAF").val(EstimateGAF);
    }

}








