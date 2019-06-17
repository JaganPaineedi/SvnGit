function CSSRSAdultLifetimeChildHideandShow(obj) {
   
    if (obj == 'DropDownList_CustomDocumentChildLTs_DeadLifeTime' || obj == 'DropDownList_CustomDocumentChildLTs_DeadPast1Month') {
        CSSRSAdultLifetimeChildHide();
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
                .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
                .text()) == "Yes") {

            $('#TextArea_CustomDocumentChildLTs_DeadDescription')
                .attr("disabled", false);
            $('#IID').show();

        }
        if (

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
                .text()) == "No")

            ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
                .text()) == '')

            ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
                .text()) == '')

            ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
                .text()) == "No")


        ) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'DeadDescription', '');
            $('[id$=TextArea_CustomDocumentChildLTs_DeadDescription]').val("");
            $('#TextArea_CustomDocumentChildLTs_DeadDescription')
                .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime' || obj == 'DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month') {
    CSSRSAdultLifetimeChildHide();
        if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
                .text()) == '')

            || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
                .text()) == "No")

            || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
                .text()) == '')

            || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
                .text()) == "No")

        ) {

            $('#3').hide();
            $('#4').hide();
            $('#5').hide();
            CreateAutoSaveXml('CustomDocumentChildLTs', 'NonSpecificDescription', '');
            $('[id$=TextArea_CustomDocumentChildLTs_NonSpecificDescription]').val("");
            $('#TextArea_CustomDocumentChildLTs_NonSpecificDescription')
                .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime' || obj == 'DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime] option:selected")
                .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month] option:selected")
                .text()) == "Yes") {
            $('#TextArea_CustomDocumentChildLTs_ActiveSuicidalIdeationDescription')
                .attr("disabled", false);

        } else if (

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month] option:selected")
                .text()) == "No")

            ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month] option:selected")
                .text()) == "No")

            ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month] option:selected")
                .text()) == '')

            ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month] option:selected")
                .text()) == '')


        ) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'ActiveSuicidalIdeationDescription', '');
            $('[id$=TextArea_CustomDocumentChildLTs_ActiveSuicidalIdeationDescription]').val("");
            $('#TextArea_CustomDocumentChildLTs_ActiveSuicidalIdeationDescription')
                .attr("disabled", true);

        }
    } else if (obj == 'DropDownList_CustomDocumentChildLTs_ASILifeTime' || obj == 'DropDownList_CustomDocumentChildLTs_ASIPast1Month') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASILifeTime] option:selected")
                .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASIPast1Month] option:selected")
                .text()) == "Yes") {
            $('#TextArea_CustomDocumentChildLTs_ASISomeIntentActDescription')
                .attr("disabled", false);

        } else if (

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASILifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASIPast1Month] option:selected")
                .text()) == "No")

            ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASILifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASIPast1Month] option:selected")
                .text()) == '')

            ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASILifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASIPast1Month] option:selected")
                .text()) == "No")

            ||
            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASILifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASIPast1Month] option:selected")
                .text()) == '')

        ) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'ASISomeIntentActDescription', '');
            $('[id$=TextArea_CustomDocumentChildLTs_ASISomeIntentActDescription]').val("");
            $('#TextArea_CustomDocumentChildLTs_ASISomeIntentActDescription')
                .attr("disabled", true);

        }
    } else if (obj == 'DropDownList_CustomDocumentChildLTs_ASISPILifeTime' || obj == 'DropDownList_CustomDocumentChildLTs_ASISPIPast1Month') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPILifeTime] option:selected")
                .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPIPast1Month] option:selected")
                .text()) == "Yes") {
            $('#TextArea_CustomDocumentChildLTs_ASISpecificPlanAndIntentDescription')
                .attr("disabled", false);
        } else if (
            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPILifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPIPast1Month] option:selected")
                .text()) == "No")

            ||
            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPILifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPIPast1Month] option:selected")
                .text()) == "No")

            ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPILifeTime] option:selected")
                .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPIPast1Month] option:selected")
                .text()) == '')

            ||
            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPILifeTime] option:selected")
                .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPIPast1Month] option:selected")
                .text()) == '')

        ) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'ASISpecificPlanAndIntentDescription', '');
            $('[id$=TextArea_CustomDocumentChildLTs_ASISpecificPlanAndIntentDescription]').val("");
            $('#TextArea_CustomDocumentChildLTs_ASISpecificPlanAndIntentDescription')
                .attr("disabled", true);
        }


    } else if (obj == 'DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoOne')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentChildLTs_ActualAttemptDescription')
                .attr("disabled", false);

        } else if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime] option:selected")
                .text()) == "No") || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime] option:selected")
                .text()) == '')) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'SuicidalBehaviourAttemptNoOne', '');
            $('[id$=TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoOne]').val("");
            $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoOne')
                .attr("disabled", true);
            if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts] option:selected")
                    .text()) == "No") || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts] option:selected")
                    .text()) == '')) {

                CreateAutoSaveXml('CustomDocumentChildLTs', 'SuicidalBehaviourAttemptNoTwo', '');
                $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoTwo')
                    .attr("disabled", true);
                $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoTwo')
                    .attr("disabled", true);

                CreateAutoSaveXml('CustomDocumentChildLTs', 'ActualAttemptDescription', '');
                $('[id$=TextArea_CustomDocumentChildLTs_ActualAttemptDescription]').val("");
                $('#TextArea_CustomDocumentChildLTs_ActualAttemptDescription')
                    .attr("disabled", true);
            }
        }

    } else if (obj == 'DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedOne')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription')
                .attr("disabled", false);

        } else if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime] option:selected")
                .text()) == "No") ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime] option:selected")
                .text()) == '')
        ) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'TotalNoInterruptedOne', '');
            $('[id$=TextBox_CustomDocumentChildLTs_TotalNoInterruptedOne]').val("");
            $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedOne')
                .attr("disabled", true);
            if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months] option:selected")
                    .text()) == "No") ||

                ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months] option:selected")
                    .text()) == '')) {

                CreateAutoSaveXml('CustomDocumentChildLTs', 'TotalNoInterruptedTwo', '');
                $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedTwo')
                    .attr("disabled", true);
                $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedTwo')
                    .attr("disabled", true);

                CreateAutoSaveXml('CustomDocumentChildLTs', 'InterruptedAttemptDescription', '');
                $('[id$=TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription]').val("");
                $('#TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription')
                    .attr("disabled", true);
            }

        }


    } else if (obj == 'DropDownList_CustomDocumentChildLTs_AbortedLifeTime') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedLifeTime] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentChildLTs_AbortedOne')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentChildLTs_AbortedDescription')
                .attr("disabled", false);

        } else if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedLifeTime] option:selected")
                .text()) == "No") ||
            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedLifeTime] option:selected")
                .text()) == '')
        ) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'AbortedOne', '');
            $('[id$=TextBox_CustomDocumentChildLTs_AbortedOne]').val("");
            $('#TextBox_CustomDocumentChildLTs_AbortedOne')
                .attr("disabled", true);
            if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedPast3Months] option:selected")
                    .text()) == "No") || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedPast3Months] option:selected")
                    .text()) == '')) {

                CreateAutoSaveXml('CustomDocumentChildLTs', 'AbortedTwo', '');
                $('[id$=TextBox_CustomDocumentChildLTs_AbortedTwo]').val("");
                $('#TextBox_CustomDocumentChildLTs_AbortedTwo')
                    .attr("disabled", true);

                CreateAutoSaveXml('CustomDocumentChildLTs', 'AbortedDescription', '');
                $('[id$=TextArea_CustomDocumentChildLTs_AbortedDescription]').val("");
                $('#TextArea_CustomDocumentChildLTs_AbortedDescription')
                    .attr("disabled", true);
            }

        }


    } else if (obj == 'DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentChildLTs_PreparatoryOne')
                .attr("disabled", false);
            $('#TextBox_CustomDocumentChildLTs_PreparatoryOne')
                .attr("disabled", false);
        } else {
            if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime] option:selected")
                    .text()) == '') ||
                ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime] option:selected")
                    .text()) == "No")
            ) {
                CreateAutoSaveXml('CustomDocumentChildLTs', 'PreparatoryOne', '');
                $('[id$=TextBox_CustomDocumentChildLTs_PreparatoryOne]').val("");
                $('#TextBox_CustomDocumentChildLTs_PreparatoryOne')
                    .attr("disabled", true);
            }
            if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months] option:selected")
                    .text()) == '') ||
                ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months] option:selected")
                    .text()) == "No")
            ) {

                CreateAutoSaveXml('CustomDocumentChildLTs', 'PreparatoryTwo', '');
                $('[id$=TextBox_CustomDocumentChildLTs_PreparatoryTwo]').val("");
                $('#TextBox_CustomDocumentChildLTs_PreparatoryTwo')
                    .attr("disabled", true);

                CreateAutoSaveXml('CustomDocumentChildLTs', 'PreparatoryDescription', '');
                $('[id$=TextArea_CustomDocumentChildLTs_PreparatoryDescription]').val("");
                $('#TextArea_CustomDocumentChildLTs_PreparatoryDescription')
                    .attr("disabled", true);
            }
        }


    } else if (obj == 'DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere') {
        if ($('[id$=DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere]').val()) {
            $('#TextBox_CustomDocumentChildLTs_MostSevereDescription')
                .attr("disabled", false);
        } else {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'MostSevereDescription', '');
            $('[id$=TextBox_CustomDocumentChildLTs_MostSevereDescription]').val("");
            $('#TextBox_CustomDocumentChildLTs_MostSevereDescription')
                .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentChildLTs_RecentMostSevere') {
        if ($('[id$=DropDownList_CustomDocumentChildLTs_RecentMostSevere]').val()) {
            $('#TextBox_CustomDocumentChildLTs_RecentMostSevereDescription')
                .attr("disabled", false);
        } else {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'RecentMostSevereDescription', '');
            $('[id$=TextBox_CustomDocumentChildLTs_RecentMostSevereDescription]').val("");
            $('#TextBox_CustomDocumentChildLTs_RecentMostSevereDescription')
                .attr("disabled", true);
        }
    } else if (obj == 'DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoTwo')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentChildLTs_ActualAttemptDescription')
                .attr("disabled", false);
        }
        if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime] option:selected")
                .text()) == '') || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime] option:selected")
                .text()) == "No")) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'SuicidalBehaviourAttemptNoOne', '');
            $('[id$=TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoOne]').val("");
            $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoOne')
                .attr("disabled", true);
            if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts] option:selected")
                    .text()) == "No") || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts] option:selected")
                    .text()) == '')) {

                CreateAutoSaveXml('CustomDocumentChildLTs', 'SuicidalBehaviourAttemptNoTwo', '');
                $('[id$=TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoTwo]').val("");
                $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoTwo')
                    .attr("disabled", true);

                CreateAutoSaveXml('CustomDocumentChildLTs', 'ActualAttemptDescription', '');
                $('[id$=TextArea_CustomDocumentChildLTs_ActualAttemptDescription]').val("");
                $('#TextArea_CustomDocumentChildLTs_ActualAttemptDescription')
                    .attr("disabled", true);
            }
        }




    } else if (obj == 'DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months') {

        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedTwo')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription')
                .attr("disabled", false);
        }
        if (

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months] option:selected")
                .text()) == "No") ||

            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months] option:selected")
                .text()) == '')
        ) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'TotalNoInterruptedTwo', '');
            $('[id$=TextBox_CustomDocumentChildLTs_TotalNoInterruptedTwo]').val("");
            $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedTwo')
                .attr("disabled", true);
            if (

                ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime] option:selected")
                    .text()) == "No") ||

                ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime] option:selected")
                    .text()) == '')
            ) {

                CreateAutoSaveXml('CustomDocumentChildLTs', 'TotalNoInterruptedOne', '');
                $('[id$=TextBox_CustomDocumentChildLTs_TotalNoInterruptedOne]').val("");
                $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedOne')
                    .attr("disabled", true);

                CreateAutoSaveXml('CustomDocumentChildLTs', 'InterruptedAttemptDescription', '');
                $('[id$=TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription]').val("");
                $('#TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription')
                    .attr("disabled", true);
            }
        }


    } else if (obj == 'DropDownList_CustomDocumentChildLTs_AbortedPast3Months') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedPast3Months] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentChildLTs_AbortedTwo')
                .attr("disabled", false);
            $('#TextArea_CustomDocumentChildLTs_AbortedDescription')
                .attr("disabled", false);

        }
        if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedPast3Months] option:selected")
                .text()) == "No") ||
            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedPast3Months] option:selected")
                .text()) == '')
        ) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'AbortedTwo', '');
            $('[id$=TextBox_CustomDocumentChildLTs_AbortedTwo]').val("");
            $('#TextBox_CustomDocumentChildLTs_AbortedTwo')
                .attr("disabled", true);
            if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedLifeTime] option:selected")
                    .text()) == '') ||
                ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedLifeTime] option:selected")
                    .text()) == "No")

            ) {

                CreateAutoSaveXml('CustomDocumentChildLTs', 'AbortedOne', '');
                $('[id$=TextBox_CustomDocumentChildLTs_AbortedOne]').val("");
                $('#TextBox_CustomDocumentChildLTs_AbortedOne').attr("disabled", true);

                CreateAutoSaveXml('CustomDocumentChildLTs', 'AbortedDescription', '');
                $('[id$=TextArea_CustomDocumentChildLTs_AbortedDescription]').val("");
                $('#TextArea_CustomDocumentChildLTs_AbortedDescription')
                    .attr("disabled", true);
            }
        }

    } else if (obj == 'DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months') {
        if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months] option:selected")
                .text()) == "Yes") {
            $('#TextBox_CustomDocumentChildLTs_PreparatoryTwo')
                .attr("disabled", false);

        }
        if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months] option:selected")
                .text()) == "No") ||
            ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months] option:selected")
                .text()) == '')
        ) {
            CreateAutoSaveXml('CustomDocumentChildLTs', 'PreparatoryTwo', '');
            $('[id$=TextBox_CustomDocumentChildLTs_PreparatoryTwo]').val("");
            $('#TextBox_CustomDocumentChildLTs_PreparatoryTwo')
                .attr("disabled", true);
            if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime] option:selected")
                    .text()) == "No") ||
                ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime] option:selected")
                    .text()) == '')
            ) {

                CreateAutoSaveXml('CustomDocumentChildLTs', 'PreparatoryOne', '');
                $('[id$=TextBox_CustomDocumentChildLTs_PreparatoryOne]').val("");
                $('#TextBox_CustomDocumentChildLTs_PreparatoryOne')
                    .attr("disabled", true);

                CreateAutoSaveXml('CustomDocumentChildLTs', 'PreparatoryDescription', '');
                $('[id$=TextArea_CustomDocumentChildLTs_PreparatoryDescription]').val("");
                $('#TextArea_CustomDocumentChildLTs_PreparatoryDescription')
                    .attr("disabled", true);
            }
        }
    }
}

function CSSRSAdultLifetimeChildHide() {

    if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == "No") || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == "No")) {
        $('#IID').hide();
        $('#SB1').show();
        $('#SB2').show();

    } else {
        $('#SB1').hide();
        $('#SB2').hide();
    }


    if (

        ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == '') ||
        ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == "No") ||
        ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == '') ||
        ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == '') ||
        ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == '')
    ) {

        $('#IID').hide();

    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == "Yes") {

        $('#TextArea_CustomDocumentChildLTs_NonSpecificDescription')
            .attr("disabled", false);

        $('#3').show();
        $('#4').show();
        $('#5').show();
        $('#IID').show();
    } else {
        $('#3').hide();
        $('#4').hide();
        $('#5').hide();
    }

    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == '') {
        CreateAutoSaveXml('CustomDocumentChildLTs', 'NonSpecificDescription', '');
        $('[id$=TextArea_CustomDocumentChildLTs_NonSpecificDescription]').val("");
        $('#TextArea_CustomDocumentChildLTs_NonSpecificDescription')
            .attr("disabled", true);
        $('#3').hide();
        $('#4').hide();
        $('#5').hide();
    }

}

function RefreshCSSRSLifeTimeRecentChild() {
    
    //////////////////////////////////////////////////
    //•	If question 1 and 2 are NO – enable “Suicidal Behavior” section
    /////////////////////////////////////////////////           
    if (($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == "No") || ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == "No")) {

        $('#SB1').show();
        $('#SB2').show();

    } else {
        $('#SB1').hide();
        $('#SB2').hide();
    }

    //////////////////////////////////////////////////
    //•	If question 2 is YES – enable question 3, 4, 5
    /////////////////////////////////////////////////
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == "Yes") {
        $('#IID').show();
        $('#3').show();
        $('#4').show();
        $('#5').show();
        $('#TextArea_CustomDocumentChildLTs_NonSpecificDescription')
            .attr("disabled", false);
    } else {
        $('#IID').hide();
        $('#3').hide();
        $('#4').hide();
        $('#5').hide();
    }



    //////////////////////////////////////////////////
    //•	If question 1 and/or 2 is YES – enable “Intensity of Ideation”
    /////////////////////////////////////////////////
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == "No" && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == "No") {

        $('#IID').hide();

    }

    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == '' && $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == '') {

        $('#IID').hide();
        $('#SB1').hide();
        $('#SB2').hide();

    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == "Yes") {

        $('#TextArea_CustomDocumentChildLTs_DeadDescription')
            .attr("disabled", false);
        $('#IID').show();

    }
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourLifeTime] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoOne')
            .attr("disabled", false);
        $('#TextArea_CustomDocumentChildLTs_ActualAttemptDescription')
            .attr("disabled", false);
    } else {
        $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoOne')
            .attr("disabled", true);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_SuicidalBehaviourPast3Monts] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentChildLTs_SuicidalBehaviourAttemptNoTwo')
            .attr("disabled", false);
        $('#TextArea_CustomDocumentChildLTs_ActualAttemptDescription')
            .attr("disabled", false);
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptLifeTime] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedOne')
            .attr("disabled", false);
        $('#TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription')
            .attr("disabled", false);
    } else {
        $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedOne')
            .attr("disabled", true);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_InterruptedAttemptPast3Months] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedTwo')
            .attr("disabled", false);
        $('#TextArea_CustomDocumentChildLTs_InterruptedAttemptDescription')
            .attr("disabled", false);
    } else {
        $('#TextBox_CustomDocumentChildLTs_TotalNoInterruptedTwo')
            .attr("disabled", true);
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedLifeTime] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentChildLTs_AbortedOne')
            .attr("disabled", false);
        $('#TextArea_CustomDocumentChildLTs_AbortedDescription')
            .attr("disabled", false);
    } else {
        $('#TextBox_CustomDocumentChildLTs_AbortedOne')
            .attr("disabled", true);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_AbortedPast3Months] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentChildLTs_AbortedTwo')
            .attr("disabled", false);
        $('#TextArea_CustomDocumentChildLTs_AbortedDescription')
            .attr("disabled", false);
    } else {
        $('#TextBox_CustomDocumentChildLTs_AbortedTwo')
            .attr("disabled", true);
    }
    //////////////////////////////////////////////////////////////////////////////////////////////
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryLifeTime] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentChildLTs_PreparatoryOne')
            .attr("disabled", false);
        $('#TextArea_CustomDocumentChildLTs_PreparatoryDescription')
            .attr("disabled", false);
    } else {
        $('#TextBox_CustomDocumentChildLTs_PreparatoryOne')
            .attr("disabled", true);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_PreparatoryPast3Months] option:selected")
            .text()) == "Yes") {
        $('#TextBox_CustomDocumentChildLTs_PreparatoryTwo')
            .attr("disabled", false);
        $('#TextArea_CustomDocumentChildLTs_PreparatoryDescription')
            .attr("disabled", false);
    } else {
        $('#TextBox_CustomDocumentChildLTs_PreparatoryTwo')
            .attr("disabled", true);
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    if ($("[id$=DropDownList_CustomDocumentChildLTs_LifeTimeMostSevere] option:selected").val()) {
        $('#TextBox_CustomDocumentChildLTs_MostSevereDescription')
            .attr("disabled", false);
    } else {
        $('#TextBox_CustomDocumentChildLTs_MostSevereDescription')
            .attr("disabled", true);
    }
    if ($("[id$=DropDownList_CustomDocumentChildLTs_RecentMostSevere] option:selected").val()) {
        $('#TextBox_CustomDocumentChildLTs_RecentMostSevereDescription')
            .attr("disabled", false);
    } else {
        $('#TextBox_CustomDocumentChildLTs_RecentMostSevereDescription')
            .attr("disabled", true);
    }
    //////////////////////////////////////////////////////////////////////////////////////
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadLifeTime] option:selected")
            .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_DeadPast1Month] option:selected")
            .text()) == "Yes") {
        $('#TextArea_CustomDocumentChildLTs_DeadDescription')
            .attr("disabled", false);
    }
    else {
        $('#TextArea_CustomDocumentChildLTs_DeadDescription')
            .attr("disabled", true);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificLifeTime] option:selected")
            .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_NonSpecificPast1Month] option:selected")
            .text()) == "Yes") {
        $('#TextArea_CustomDocumentChildLTs_NonSpecificDescription')
            .attr("disabled", false);
    } else {
        $('#TextArea_CustomDocumentChildLTs_NonSpecificDescription')
            .attr("disabled", true);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationLifeTime] option:selected")
            .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ActiveSuicidalIdeationPast1Month] option:selected")
            .text()) == "Yes") {
        $('#TextArea_CustomDocumentChildLTs_ActiveSuicidalIdeationDescription')
            .attr("disabled", false);
    } else {
        $('#TextArea_CustomDocumentChildLTs_ActiveSuicidalIdeationDescription')
            .attr("disabled", true);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASILifeTime] option:selected")
            .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASIPast1Month] option:selected")
            .text()) == "Yes") {
        $('#TextArea_CustomDocumentChildLTs_ASISomeIntentActDescription')
            .attr("disabled", false);
    } else {
        $('#TextArea_CustomDocumentChildLTs_ASISomeIntentActDescription')
            .attr("disabled", true);
    }
    if ($.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPILifeTime] option:selected")
            .text()) == "Yes" || $.trim($("[id$=DropDownList_CustomDocumentChildLTs_ASISPIPast1Month] option:selected")
            .text()) == "Yes") {
        $('#TextArea_CustomDocumentChildLTs_ASISpecificPlanAndIntentDescription')
            .attr("disabled", false);
    } else {
        $('#TextArea_CustomDocumentChildLTs_ASISpecificPlanAndIntentDescription')
            .attr("disabled", true);
    }
    ///////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////
}