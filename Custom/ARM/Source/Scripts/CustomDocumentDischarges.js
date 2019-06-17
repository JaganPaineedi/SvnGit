// Create by Pradeep A
// Date April 25, 2011
// Mod: April 25, 2011 - Initial File Created
// Mod:
// Desc: Used to handle the page data for Custom Document Discharge Goals
// *************************************************************





//Purpose : This function is called on Page load/refresh
function AddEventHandlers() {
    try {
        if (!$("#CheckBox_CustomDocumentDischarges_InvoluntaryTermination").is(":checked")) {
            //Added by Rohit to remove checked attr on 12Jan2012
            $("#CheckBox_CustomDocumentDischarges_ClientInformedRightAppeal").removeAttr("checked");
            $("#CheckBox_CustomDocumentDischarges_ClientInformedRightAppeal").attr("disabled", true);
            //Added by Rohit to remove checked attr on 12Jan2012
            $("#CheckBox_CustomDocumentDischarges_StaffMemberContact72Hours").removeAttr("checked");
            $("#CheckBox_CustomDocumentDischarges_StaffMemberContact72Hours").attr("disabled", true);
        }
    }
    catch (err) {
        LogClientSideException(err);
    }
}

//Created By - Rohit Katoch
//Created On - 12Jan2012
//Purpose - Check/Uncheck  event handler for involuntaryTermination checkbox 
function SetScreenSpecificValues(dom, action) {
    var involuntaryTermination = $('CustomDocumentDischarges InvoluntaryTermination', dom);
    if (involuntaryTermination.length > 0) {
        if (involuntaryTermination.text() != 'Y') {
            $("#CheckBox_CustomDocumentDischarges_ClientInformedRightAppeal").removeAttr("checked");
            $("#CheckBox_CustomDocumentDischarges_ClientInformedRightAppeal").attr("disabled", true);
            $("#CheckBox_CustomDocumentDischarges_StaffMemberContact72Hours").removeAttr("checked");
            $("#CheckBox_CustomDocumentDischarges_StaffMemberContact72Hours").attr("disabled", true);
        }
        else if (involuntaryTermination.text() == 'Y') {
            $("#CheckBox_CustomDocumentDischarges_ClientInformedRightAppeal").attr("disabled", false);
            $("#CheckBox_CustomDocumentDischarges_StaffMemberContact72Hours").attr("disabled", false);
        }
    }
}

var CustomDocumentDischargeGoals = {
    LoadCustomDocumentDischargeGoals: function() {
        $("#CustomDocumentDischargeTable").children().remove(); //.find("tr .tmplrow").remove();

        var goals = GetAutoSaveXMLDomNode("CustomDocumentDischargeGoals");

        var items = goals.length > 0 ? $(goals).XMLExtract() : [];
        var itemslist = items.sort(function(a, b) { return a.DischargeGoalId > b.DischargeGoalId ? -1 : a.DischargeGoalId < b.DischargeGoalId ? 1 : 0; })
        var len = itemslist.length;
        //var tabMaximum = len * 7;
        //var tabMax = tabMaximum;

        //var tabMin = tabMax - 7;
        //var tabIndex = tabMax;
        var tmplDischargeGoals = $("#CustomDocumentDischargeGoalsTmp1");

        if (tmplDischargeGoals.length > 0) {

            for (var kda = 0; kda < len; kda++) {
                var id = itemslist[kda]["DischargeGoalId"];
                var GoalText = itemslist[kda]["GoalText"];
                tmplDischargeGoals.tmpl({ "DischargeGoalId": id, "GoalText": GoalText }).prependTo("#CustomDocumentDischargeTable");
                $("#CustomDocumentDischargeTable").FormPopulate("CustomDocumentDischargeGoals_" + id + "_", itemslist[kda]);
            }
            //if (len > 0) { $(document).unbind('xmlchange', CustomDocumentDischargeGoals.LoadCustomDocumentDischargeGoals); }
        }
    },
    CustomDocumentDischargeGoalsChange: function(obj, prefix, id) {
        var goals = GetAutoSaveXMLDomNode('CustomDocumentDischargeGoals');
        var items = goals.length > 0 ? $(goals).XMLExtract() : [];
        var item = ArrayHelpers.GetItem(items, id, 'DischargeGoalId');

        if (item !== null && item !== undefined) {
            //ArrayHelpers.SetDateUserInfo(item);
            $(obj).FormGetItemValue(item, $(obj).attr('id').replace(prefix, ''));
            CreateAutoSaveXMLObjArray('CustomDocumentDischargeGoals', 'DischargeGoalId', item, false);
        }
    }
}

