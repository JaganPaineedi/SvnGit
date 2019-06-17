function CSSRSChildAdolescentSinceLTHideandShow(obj) {
    if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead') {
        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead] option:selected")
                .text()) == "Yes") {

            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDeadDescription')
                .attr("disabled", false);

            $('#SB1').hide();
            $('#SB2').hide();

            $('#IID').show();

        } else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead] option:selected")
                .text()) == "No")
        {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'WishToBeDeadDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDeadDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDeadDescription')
              .attr("disabled", true);

            if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts] option:selected")
                .text()) == "No") {

                $('#SB1').show();
                $('#SB2').show();

                $('#IID').hide();
            }
            else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts] option:selected")
           .text()) == '') {
                $('#IID').hide();
            }
            else { }

        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'WishToBeDeadDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDeadDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDeadDescription')
                   .attr("disabled", true);

            $('#SB1').hide();
            $('#SB2').hide();
            if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts] option:selected")
                .text()) == '') {
                $('#IID').hide();
            }
        }
        
    } else if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts') {
        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts] option:selected")
                .text()) == "Yes") {

            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughtsDescription')
                .attr("disabled", false);

            $('#3').show();
            $('#4').show();
            $('#5').show();

            $('#SB1').hide();
            $('#SB2').hide();

            $('#IID').show();

        }
        else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts] option:selected")
                .text()) == "No") {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'NonSpecificActiveSuicidalThoughtsDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughtsDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughtsDescription')
                .attr("disabled", true);

            $('#3').hide();
            $('#4').hide();
            $('#5').hide();

            if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead] option:selected")
                .text()) == "No") {

                $('#SB1').show();
                $('#SB2').show();

                $('#IID').hide();

            }
            else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead] option:selected")
           .text()) == '') {
                $('#IID').hide();
                $('#3').hide();
                $('#4').hide();
                $('#5').hide();

                $('#SB1').hide();
                $('#SB2').hide();
            }
            else {
            }
        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'NonSpecificActiveSuicidalThoughtsDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughtsDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughtsDescription')
                  .attr("disabled", true);

            $('#3').hide();
            $('#4').hide();
            $('#5').hide();

            $('#SB1').hide();
            $('#SB2').hide();
            if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead] option:selected")
                 .text()) == '') {
                $('#IID').hide();
            }
        }
    } else if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct') {
        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct] option:selected")
                .text()) == "Yes") {
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription')
                .attr("disabled", false);

        }
        else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct] option:selected")
                .text()) == "No") {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription')
                .attr("disabled", true);

        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription')
                    .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan') {
        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan] option:selected")
                .text()) == "Yes") {
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription')
                .attr("disabled", false);

        }
        else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan] option:selected")
                .text()) == "No") {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription')
                .attr("disabled", true);

        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription')
                   .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent') {
        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent] option:selected")
                .text()) == "Yes") {
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntentDescription')
                .attr("disabled", false);
        }
        else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent] option:selected")
                .text()) == "No") {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'AciveSuicidalIdeationWithSpecificPlanAndIntentDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntentDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntentDescription')
                .attr("disabled", true);
        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'AciveSuicidalIdeationWithSpecificPlanAndIntentDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntentDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntentDescription')
                   .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt') {
        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttempts')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActualAttemptDescription')
                .attr("disabled", false);

        }
        else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt] option:selected")
                .text()) == "No") {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'TotalNumberOfAttempts', '');
            $('[id$=TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttempts]').val("");
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttempts')
                .attr("disabled", true);

            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'ActualAttemptDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActualAttemptDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActualAttemptDescription')
                .attr("disabled", true);
        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'TotalNumberOfAttempts', '');
            $('[id$=TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttempts]').val("");
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttempts')
                   .attr("disabled", true);
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'ActualAttemptDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActualAttemptDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActualAttemptDescription')
                .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt') {
        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttemptsInterrupted')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttemptDescription')
                .attr("disabled", false);

        }
        else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt] option:selected")
                .text()) == "No") {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'TotalNumberOfAttemptsInterrupted', '');
            $('[id$=TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttemptsInterrupted]').val("");
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttemptsInterrupted')
                .attr("disabled", true);

            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'InterruptedAttemptDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttemptDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttemptDescription')
                .attr("disabled", true);

        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'TotalNumberOfAttemptsInterrupted', '');
            $('[id$=TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttemptsInterrupted]').val("");
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttemptsInterrupted')
                  .attr("disabled", true);

            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'InterruptedAttemptDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttemptDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttemptDescription')
                .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt') {
        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberAttemptsAbortedOrSelfInterrupted')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttemptDescription')
                .attr("disabled", false);

        }
        else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt] option:selected")
                .text()) == "No") {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'TotalNumberAttemptsAbortedOrSelfInterrupted', '');
            $('[id$=TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberAttemptsAbortedOrSelfInterrupted]').val("");
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberAttemptsAbortedOrSelfInterrupted')
                .attr("disabled", true);

            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'AbortedOrSelfInterruptedAttemptDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttemptDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttemptDescription')
                .attr("disabled", true);

        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'TotalNumberAttemptsAbortedOrSelfInterrupted', '');
            $('[id$=TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberAttemptsAbortedOrSelfInterrupted]').val("");
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberAttemptsAbortedOrSelfInterrupted')
                   .attr("disabled", true);

            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'AbortedOrSelfInterruptedAttemptDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttemptDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttemptDescription')
                .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior') {
        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfPreparatoryActs')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehaviorDescription')
                .attr("disabled", false);
        }
        else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior] option:selected")
                .text()) == "No") {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'TotalNumberOfPreparatoryActs', '');
            $('[id$=TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfPreparatoryActs]').val("");
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfPreparatoryActs')
                .attr("disabled", true);

            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'PreparatoryActsOrBehaviorDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehaviorDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehaviorDescription')
                .attr("disabled", true);
        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'TotalNumberOfPreparatoryActs', '');
            $('[id$=TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfPreparatoryActs]').val("");
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfPreparatoryActs')
                   .attr("disabled", true);

            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'PreparatoryActsOrBehaviorDescription', '');
            $('[id$=TextArea_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehaviorDescription]').val("");
            $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehaviorDescription')
                .attr("disabled", true);
        }
    }
    else if (obj == 'DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation') {
        if ($('[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation]').val()) {
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeationDescription')
                .attr("disabled", false);
        }
        else {
            CreateAutoSaveXml('CustomDocumentCSSRSChildSinceLastVisits', 'MostSevereIdeationDescription', '');
            $('[id$=TextBox_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeationDescription]').val("");
            $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeationDescription')
                .attr("disabled", true);
    } 
    }
}

function RefreshCSSRSChildAdolescentSinceLTHideandShow()
{
    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead] option:selected")
                  .text()) == "Yes") {
        $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDeadDescription')
             .attr("disabled", false);

        $('#SB1').hide();
        $('#SB2').hide();

        $('#IID').show();

    }
    else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead] option:selected")
                .text()) == "No") {

        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts] option:selected")
                .text()) == "No") {

            $('#SB1').show();
            $('#SB2').show();

            $('#IID').hide();

        }

    }

    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts] option:selected")
                .text()) == "Yes") {
        $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughtsDescription')
                .attr("disabled", false);
        $('#3').show();
        $('#4').show();
        $('#5').show();

        $('#SB1').hide();
        $('#SB2').hide();

        $('#IID').show();
    }
    else if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts] option:selected")
                .text()) == "No") {

        $('#3').hide();
        $('#4').hide();
        $('#5').hide();

        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead] option:selected")
                .text()) == "No") {

            $('#SB1').show();
            $('#SB2').show();

            $('#IID').hide();

        }
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_WishToBeDead] option:selected")
                  .text()) == '')
    {
        $('#SB1').hide();
        $('#SB2').hide();

        if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_NonSpecificActiveSuicidalThoughts] option:selected")
                .text()) == '')
        {
            $('#IID').hide();
            $('#3').hide();
            $('#4').hide();
            $('#5').hide();
        }
    }

    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct] option:selected")
               .text()) == "Yes") {
        $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription')
             .attr("disabled", false);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan] option:selected")
              .text()) == "Yes") {
        $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription')
             .attr("disabled", false);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntent] option:selected")
              .text()) == "Yes") {
        $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_AciveSuicidalIdeationWithSpecificPlanAndIntentDescription')
             .attr("disabled", false);
    }
    if ($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeation] option:selected").val()) {
        $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_MostSevereIdeationDescription')
             .attr("disabled", false);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_ActualAttempt] option:selected")
              .text()) == "Yes") {
        $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttempts')
             .attr("disabled", false);
        $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_ActualAttemptDescription')
            .attr("disabled", false);
    }

    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttempt] option:selected")
             .text()) == "Yes") {
        $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfAttemptsInterrupted')
             .attr("disabled", false);
        $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_InterruptedAttemptDescription')
            .attr("disabled", false);
    }

    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttempt] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberAttemptsAbortedOrSelfInterrupted')
             .attr("disabled", false);
        $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_AbortedOrSelfInterruptedAttemptDescription')
            .attr("disabled", false);
    }

    if ($.trim($("[id$=DropDownList_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehavior] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentCSSRSChildSinceLastVisits_TotalNumberOfPreparatoryActs')
             .attr("disabled", false);
        $('#TextArea_CustomDocumentCSSRSChildSinceLastVisits_PreparatoryActsOrBehaviorDescription')
            .attr("disabled", false);
    }
    }

