var CustomIntegratedCarePlan = CustomIntegratedCarePlan || {
    TodayPlus90: function() { return ShortDateString(new Date(new Date().getTime() + 7776000000)) },
    IntegratedCarePlanAjaxCall: function(parms) {
        var returnResult = "";
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "BasePages/Documents.aspx?scId=" + $('input[id$=hiddenFieldCurrentScreenId]').val() + "&isExternalURL=false",
            data: "ajaxRequest=true&action=CustomAjaxCall&TabIndex=0&requestParametersValues=" + parms,
            async: false,
            success: function(result) {
                returnResult = result;
            }
        });
        return returnResult;
    },
    Clear_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_Data: function() {
        var $clearObject = $("#TableChildControl_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes");
        $("input[required=true]", $clearObject).removeClass('requiredfield');
        $("#HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_CustomDocumentHealthHomeCarePlanLongTermCareOutcomeId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_RecordDeleted", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DeletedBy", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DeletedDate", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_DocumentVersionId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_OutcomeSequence", $clearObject).val("");
        $("#TextArea_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_OutcomeDescription", $clearObject).val("");
        $("#TextBox_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_TargetDate", $clearObject).val(CustomIntegratedCarePlan.TodayPlus90());
    },

    Clear_CustomDocumentHealthHomeCarePlanPESNeeds_Data: function() {
        var $clearObject = $("#TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds");
        $("input[required=true]", $clearObject).removeClass('requiredfield');
        $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_CustomDocumentHealthHomeCarePlanPESNeedId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_RecordDeleted", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DeletedBy", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DeletedDate", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_DocumentVersionId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedSequence", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedTypeName", $clearObject).val("");
        $("[id$=DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType]", $clearObject).val("");
        $("#TextArea_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedPlan", $clearObject).val("");
    },

    Clear_CustomDocumentHealthHomeCarePlanDiagnoses_Data: function() {
        var $clearObject = $("#TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses");
        $("input[required=true]", $clearObject).removeClass('requiredfield');
        $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_CustomDocumentHealthHomeCarePlanDiagnosisId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_RecordDeleted", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DeletedBy", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DeletedDate", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_DocumentVersionId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber", $clearObject).val("");
        $("#TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_ReportedDiagnosis", $clearObject).val("");
        $("#TextBox_CustomDocumentHealthHomeCarePlanDiagnoses_TreatmentProvider", $clearObject).val("");
    },

    Clear_CustomDocumentHealthHomeCarePlanOutcomes_Data: function() {
        var $clearObject = $("#TableChildControl_CustomDocumentHealthHomeCarePlanOutcomes");
        $("input[required=true]", $clearObject).removeClass('requiredfield');
        $("#HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_CustomDocumentHealthHomeCarePlanOutcomeId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_RecordDeleted", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_DeletedBy", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_DeletedDate", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_DocumentVersionId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeSequence", $clearObject).val("");
        $("#TextArea_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeDescription", $clearObject).val("");
        $("#TextArea_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeCriteria", $clearObject).val("");
        $("#TextBox_CustomDocumentHealthHomeCarePlanOutcomes_TargetDate", $clearObject).val(CustomIntegratedCarePlan.TodayPlus90());
    },

    Clear_CustomDocumentHealthHomeCarePlanBHGoals_Data: function() {
        var $clearObject = $("#TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals");
        $("input[required=true]", $clearObject).removeClass('requiredfield');
        $("input,textarea,button,img", $clearObject).attr("disabled", "");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_CustomDocumentHealthHomeCarePlanBHGoalId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_RecordDeleted", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_DeletedBy", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_DeletedDate", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_DocumentVersionId", $clearObject).val("");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_GoalNumber", $clearObject).val("");
        $("#TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalProvider", $clearObject).val("");
        $("#TextArea_CustomDocumentHealthHomeCarePlanBHGoals_NeedDescription", $clearObject).val("");
        $("#TextBox_CustomDocumentHealthHomeCarePlanBHGoals_NeedIdentifiedDate", $clearObject).val(CustomIntegratedCarePlan.TodayPlus90());
        $("#TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalDescription", $clearObject).val("");
        $("#TextBox_CustomDocumentHealthHomeCarePlanBHGoals_GoalTargetDate", $clearObject).val(CustomIntegratedCarePlan.TodayPlus90());
        $("#TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalObjectives", $clearObject).val("");
        $("#TextArea_CustomDocumentHealthHomeCarePlanBHGoals_GoalServices", $clearObject).val("");
        $("#TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals_ButtonInsert", $clearObject).val("Insert");
        $("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_SourceDocumentVersionId", $clearObject).val("");
    },

    CheckForRequiredValues: function($obj) {
        $("input[required=true],textarea[required=true],select[required=true]", $obj).each(function() {
            if ($(this).val() == "") {
                $(this).addClass('requiredfield');
            } else {
                $(this).removeClass('requiredfield');
            }
        });
    },

    InsertGrid_CustomDocumentHealthHomeCarePlanLongTermCareOutcomesData: function(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
        var $obj = $("#" + gridDatatable);
        CustomIntegratedCarePlan.CheckForRequiredValues($obj);
        if ($(buttonCtrl).val().toLowerCase() == "insert") {
            var result = CustomIntegratedCarePlan.IntegratedCarePlanAjaxCall("CustomAjaxRequestType=outcomesequenceresponse^tableName=CustomDocumentHealthHomeCarePlanLongTermCareOutcomes");
            var numval = $("#IntegratedCarePlanOutcomeSequence", result).val();
            $("#HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_OutcomeSequence", $obj).val(numval);
            $("#HiddenField_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_CustomDocumentHealthHomeCarePlanLongTermCareOutcomeId", $obj).val("-" + numval);
        }
        InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
    },

    InsertGrid_CustomDocumentHealthHomeCarePlanPESNeedsData: function(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
        var $obj = $("#" + gridDatatable);
        CustomIntegratedCarePlan.CheckForRequiredValues($obj);
        if ($("#DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType option:selected", $obj).val() == 0) {
            ShowHideErrorMessage('Please select a Need', 'true');
            return;
        }
        if ($(buttonCtrl).val().toLowerCase() == "insert") {
            var result = CustomIntegratedCarePlan.IntegratedCarePlanAjaxCall("CustomAjaxRequestType=psychosocialsupportneedsequence^tableName=CustomDocumentHealthHomeCarePlanPESNeeds");
            var numval = $("#IntegratedCarePlanOutcomeSequence", result).val();
            $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedSequence", $obj).val(numval);
            $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_CustomDocumentHealthHomeCarePlanPESNeedId", $obj).val("-" + numval);
        }
        var ddCodeName = $("[id$=DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType] option:selected").text();
        $("#HiddenField_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedTypeName").val(ddCodeName);
        InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
    },

    InsertGrid_CustomDocumentHealthHomeCarePlanDiagnosesData: function(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
        // validate data here
        var $obj = $("#" + gridDatatable);
        CustomIntegratedCarePlan.CheckForRequiredValues($obj);
        if ($(buttonCtrl).val().toLowerCase() == "insert") {
            var result = CustomIntegratedCarePlan.IntegratedCarePlanAjaxCall("CustomAjaxRequestType=plandiagnosessequencenumber^tableName=CustomDocumentHealthHomeCarePlanDiagnoses");
            var numval = $("#IntegratedCarePlanOutcomeSequence", result).val();
            $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_SequenceNumber", $obj).val(numval);
            $("#HiddenField_CustomDocumentHealthHomeCarePlanDiagnoses_CustomDocumentHealthHomeCarePlanDiagnosisId", $obj).val("-" + numval);
        }
        InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
    },

    InsertGrid_CustomDocumentHealthHomeCarePlanBHGoalsData: function(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
        var $obj = $("#" + gridDatatable);
        CustomIntegratedCarePlan.CheckForRequiredValues($obj);
        if ($(buttonCtrl).val().toLowerCase() == "insert") {
            var result = CustomIntegratedCarePlan.IntegratedCarePlanAjaxCall("CustomAjaxRequestType=bhgoalsgoalnumber^tableName=CustomDocumentHealthHomeCarePlanBHGoals");
            var numval = $("#IntegratedCarePlanOutcomeSequence", result).val();
            $("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_GoalNumber", $obj).val(numval);
            $("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_CustomDocumentHealthHomeCarePlanBHGoalId", $obj).val("-" + numval);
        }
        InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
    },

    InsertGrid_CustomDocumentHealthHomeCarePlanOutcomesData: function(gridDatatable, gridDivName, dataGridID, buttonCtrl) {
        var $obj = $("#" + gridDatatable);
        CustomIntegratedCarePlan.CheckForRequiredValues($obj);
        if ($(buttonCtrl).val().toLowerCase() == "insert") {
            var result = CustomIntegratedCarePlan.IntegratedCarePlanAjaxCall("CustomAjaxRequestType=outcomesequenceresponse^tableName=CustomDocumentHealthHomeCarePlanOutcomes");
            var numval = $("#IntegratedCarePlanOutcomeSequence", result).val();
            $("#HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_OutcomeSequence", $obj).val(numval);
            $("#HiddenField_CustomDocumentHealthHomeCarePlanOutcomes_CustomDocumentHealthHomeCarePlanOutcomeId", $obj).val("-" + numval);
        }
        InsertGridData(gridDatatable, gridDivName, dataGridID, buttonCtrl);
    },

    ClearCustomGridValues: function(gridTableName) {
        switch (gridTableName) {
            case "CustomDocumentHealthHomeCarePlanBHGoals":
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanBHGoals_Data();
                break;
            case "CustomDocumentHealthHomeCarePlanOutcomes":
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanOutcomes_Data();
                break;
            case "CustomDocumentHealthHomeCarePlanDiagnoses":
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanDiagnoses_Data();
                break;
            case "CustomDocumentHealthHomeCarePlanPESNeeds":
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanPESNeeds_Data();
                break;
            case "CustomDocumentHealthHomeCarePlanLongTermCareOutcomes":
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_Data();
                break;
        }
    }
};


function DeleteGridRowValidation(primaryKeyValue, primaryKey, tableName) {
    switch (tableName) {
        case 'CustomDocumentHealthHomeCarePlanBHGoals':
            var result = CustomIntegratedCarePlan.IntegratedCarePlanAjaxCall("CustomAjaxRequestType=deleteresponse^primarykeyvalue=" + primaryKeyValue + "^primarykey=" + primaryKey + "^tableName=CustomDocumentHealthHomeCarePlanBHGoals");
            if ($("#IntegratedCarePlanDeleteResponse", result).val() == "false") {
                ShowHideErrorMessage($("#IntegratedCarePlanDeleteMessage", result).val(), 'true');
                return false;
            }
            return true;
            break;
    }
}


function AddEventHandlers() {
    CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanBHGoals_Data();
    CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanOutcomes_Data();
    CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanDiagnoses_Data();
    CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanPESNeeds_Data();
    CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_Data();
}

function AfterDeleteOperation(primaryKeyValue, primaryKey, gridTableName) {
    CustomIntegratedCarePlan.ClearCustomGridValues(gridTableName);
}

function AddEventHandlerAfterInsertGrid(gridTableName) {
    CustomIntegratedCarePlan.ClearCustomGridValues(gridTableName);
}

function AddParentChildRadioClickEventHandlerForCIR(key, rowIndex, obj, customGridTableName, gridPageName, insertButtonId) {
    switch (customGridTableName) {
        case "TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals":
            var $obj = $("#TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals_DataRow");
            if ($("#HiddenField_CustomDocumentHealthHomeCarePlanBHGoals_SourceDocumentVersionId", $obj).val() != "") {
                $obj.find('input,textarea,img').attr("disabled", "disabled");
                $("#" + insertButtonId).attr("disabled", "disabled");
            }
            break;
    }
}

function AddParentChildEventHandler(handlerType, method) {
    switch (handlerType) {
        case "TableChildControl_CustomDocumentHealthHomeCarePlanBHGoals":
            if (method == "ClearTable")
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanBHGoals_Data();
            break;
        case "TableChildControl_CustomDocumentHealthHomeCarePlanOutcomes":
            if (method == "ClearTable")
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanOutcomes_Data();
            break;
        case "TableChildControl_CustomDocumentHealthHomeCarePlanDiagnoses":
            if (method == "ClearTable")
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanDiagnoses_Data();
            break;
        case "TableChildControl_CustomDocumentHealthHomeCarePlanPESNeeds":
            if (method == "ClearTable")
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanPESNeeds_Data();
            break;
        case "TableChildControl_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes":
            if (method == "ClearTable")
                CustomIntegratedCarePlan.Clear_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes_Data();
            break;
    }
}