var Flag = "";
var ValInquiryId = "";

var _inquiryid = 0;
var _CoverageInfoId = 0;
var data = { emptydetails: [{ InquiriesCoverageInformationId: 0, InquiryId: 0, Provider: '', CoveragePlanId: -1, InsuredId: '', GroupId: '', Comments: ''}] };
var emptydata = data.emptydetails;
var tabAferCareClicked = false;
var tabobject = null;
function AddEventHandlers() {
    //return AddEventHandlers1();
    try {
        
        if (TabIndex == 0) {
            if ($("[id$=DropDownList_CustomInquiries_ReferralType]").length > 0) {
                var DropDown_ReferralType = $("[id$=DropDownList_CustomInquiries_ReferralType]");
                $("[id$=DropDownList_CustomInquiries_ReferralType]").unbind('change');
                $("[id$=DropDownList_CustomInquiries_ReferralType]").bind("change", function () {
                    BindReferralSubtype(DropDown_ReferralType.val());
                });

                var DropDown_ReferralSubType = $("[id$=DropDownList_CustomInquiries_ReferralSubtype]");
                $("[id$=DropDownList_CustomInquiries_ReferralSubtype]").unbind('change');
                $("[id$=DropDownList_CustomInquiries_ReferralSubtype]").bind("change", function () {
                    SaveReferralSubtype(DropDown_ReferralSubType.val());
                });
            }
        }
        //Added by Atul Pandey w.rf.t task #2 of CentraWellness Customization
        //What :To Disable TextArea of section 'Risk Assessment' on selection of Radio Button
        //Why  :Nedeed this fuctionality according to UI according to project review held on 14/jan/2013
        $("#RadioButton_CustomInquiries_RiskAssessmentInDanger_No").click(function() {
            $('#TextArea_CustomInquiries_RiskAssessmentInDangerComment').text('');
            CreateAutoSaveXml('CustomInquiries', 'RiskAssessmentInDangerComment', '')
            $('#TextArea_CustomInquiries_RiskAssessmentInDangerComment').attr("disabled", "disabled");
        });
        $("#RadioButton_CustomInquiries_RiskAssessmentInDanger_Yes").click(function() {

            $('#TextArea_CustomInquiries_RiskAssessmentInDangerComment').removeAttr("disabled");
        });
        $("#RadioButton_CustomInquiries_RiskAssessmentCounselorAvailability_Yes").click(function() {
            $('#TextArea_CustomInquiries_RiskAssessmentCounselorAvailabilityComment').text('');
            CreateAutoSaveXml('CustomInquiries', 'RiskAssessmentCounselorAvailabilityComment', '')
            $('#TextArea_CustomInquiries_RiskAssessmentCounselorAvailabilityComment').attr("disabled", "disabled");
        });
        $("#RadioButton_CustomInquiries_RiskAssessmentCounselorAvailability_No").click(function() {

            $('#TextArea_CustomInquiries_RiskAssessmentCounselorAvailabilityComment').removeAttr("disabled");
        });
        $("#RadioButton_CustomInquiries_RiskAssessmentCrisisLine_Yes").click(function() {
            $('#TextArea_CustomInquiries_RiskAssessmentCrisisLineComment').text('');
            CreateAutoSaveXml('CustomInquiries', 'RiskAssessmentCrisisLineComment', '')
            $('#TextArea_CustomInquiries_RiskAssessmentCrisisLineComment').attr("disabled", "disabled");
        });
        $("#RadioButton_CustomInquiries_RiskAssessmentCrisisLine_No").click(function() {

            $('#TextArea_CustomInquiries_RiskAssessmentCrisisLineComment').removeAttr("disabled");
        });
        //till here    
    
    
    
        $("#tblCustomInquiryMain [id$=DropDownList_CustomInquiries_Sex]").change(function() {
            InquiryDetail.SetPregnant('DropDownList_CustomInquiries_Sex');
        });
        $("#tblCustomInquiryMain [id$=CheckBox_CustomInquiries_SameAsCaller]").change(function() {
            InquiryDetail.SameAsCaller(this);
        });
        $("#tblCustomInquiryMain [id$=Button_SetTodayDate]").click(function() {
            InquiryDetail.SetDate("TextBox_CustomInquiries_InquiryStartDate", 0);
        });
        $("#tblCustomInquiryMain [id$=Button_SetYesterDayDate]").click(function() {
            InquiryDetail.SetDate("TextBox_CustomInquiries_InquiryStartDate", 1);
        });

        $("#tblCustomInquiryMain [id$=Button_SetCurrentTime]").click(function() {
            InquiryDetail.SetTime("Text_CustomInquiries_InquiryStartTime");
            InquiryDetail.ChangeStartDateTime();
        });
        $("#tblCustomInquiryMain [id$=Button_SetEndDate]").click(function() {
            InquiryDetail.SetDate("TextBox_CustomInquiries_InquiryEndDate", 0);
        });
        $("#tblCustomInquiryMain [id$=Button_SetEndYesterDate]").click(function() {
            InquiryDetail.SetDate("TextBox_CustomInquiries_InquiryEndDate", 1);
        });

        $("#tblCustomInquiryMain [id$=Button_SetEndTime]").click(function() {
        // Added by vikesh #1222(unsaved changes on click)
        if($.trim($("#TextBox_CustomInquiries_InquiryEndDate").val())!=''){
            InquiryDetail.SetTime("Text_CustomInquiries_InquiryEndTime");
            InquiryDetail.ChangeEndDateTime();
            }
           });
        $("[name$=CheckBox_CustomInquiries_AccomodationNeeded]").change(function() {
            InquiryDetail.AccomodationNeeded('CheckBox_CustomInquiries_AccomodationNeeded');
        });

        $("[id$=DropDownList_CustomInquiries_PresentingPopulation]").change(function() {
            InquiryDetail.PresentingPopulation = $(this).val();
        });
        $("[id$=TextBox_CustomInquiries_InquiryStartDate]").change(function() {
            InquiryDetail.ChangeStartDateTime();
        });
        $("[id$=TextBox_CustomInquiries_InquiryEndDate]").change(function() {
            InquiryDetail.ChangeEndDateTime();
        });
        $("[id$=Text_CustomInquiries_InquiryStartTime]").change(function() {
            InquiryDetail.ChangeStartDateTime();
        });
        $("[id$=Text_CustomInquiries_InquiryEndTime]").change(function() {
            InquiryDetail.ChangeEndDateTime();
        });

        $("[id$=TextBox_CustomInquiries_DateOfBirth]").change(function() {
            var DateOfBirth = $("input[Id$=TextBox_CustomInquiries_DateOfBirth]")
            if (DateOfBirth.length > 0) {
                GetAge(DateOfBirth);
            }
        });

        if ($("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]").val() == "6781" && $("[id$=TextBox_CustomInquiries_ClientId]").val() == "") {
            $("[id$=TextBox_CustomInquiries_InquirerFirstName]").attr("Required", "true");
            $("[id$=TextBox_CustomInquiries_InquirerLastName]").attr("Required", "true");
        }

        //Enable/Disable Fields when relation to member is changed
        $("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]").unbind("change");
        $("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]").bind("change", function() {

            $("[id$=TextBox_CustomInquiries_InquirerFirstName]").removeAttr("Required");
            $("[id$=TextBox_CustomInquiries_InquirerLastName]").removeAttr("Required");

            //----- BY PKS On Feb 17, 2012 --------
            if ($("[id$=TextBox_CustomInquiries_ClientId]").val() == "") {
                $("[id$=TextBox_CustomInquiries_ClientId]").attr('disabled', 'disabled');
            }
            else {
                $("[id$=TextBox_CustomInquiries_ClientId]").removeAttr('disabled');
            }
            //-------------------------------------
            //relationChange();
            
            if ($(this).val() == "6781" && $("[id$=TextBox_CustomInquiries_ClientId]").val() == "") {
                $("[id$=TextBox_CustomInquiries_InquirerFirstName]").attr("Required", "true");
                $("[id$=TextBox_CustomInquiries_InquirerLastName]").attr("Required", "true");

                if ($("[id$=TextBox_CustomInquiries_MemberFirstName]").val() != "") {
                    $("[id$=TextBox_CustomInquiries_InquirerFirstName]").val($("[id$=TextBox_CustomInquiries_MemberFirstName]").val());
                    $("[id$=TextBox_CustomInquiries_InquirerFirstName]").change();
                }
                if ($("[id$=TextBox_CustomInquiries_MemberMiddleName]").val() != "") {
                    $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").val($("[id$=TextBox_CustomInquiries_MemberMiddleName]").val());
                    $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").change();
                }
                if ($("[id$=TextBox_CustomInquiries_MemberLastName]").val() != "") {
                    $("[id$=TextBox_CustomInquiries_InquirerLastName]").val($("[id$=TextBox_CustomInquiries_MemberLastName]").val());
                    $("[id$=TextBox_CustomInquiries_InquirerLastName]").change();
                }
                if ($("[id$=TextBox_CustomInquiries_MemberPhone]").val() != "") {
                    $("[id$=TextBox_CustomInquiries_InquirerPhone]").val($("[id$=TextBox_CustomInquiries_MemberPhone]").val());
                    $("[id$=TextBox_CustomInquiries_InquirerPhone]").change();
                }
                if ($("[id$=TextBox_CustomInquiries_MemberPhoneExtension]").val() != "") {
                    $("[id$=TextBox_CustomInquiries_InquirerPhoneExtension]").val($("[id$=TextBox_CustomInquiries_MemberPhoneExtension]").val());
                    $("[id$=TextBox_CustomInquiries_InquirerPhoneExtension]").change();
                }
                if ($("[id$=TextBox_CustomInquiries_MemberEmail]").val() != "") {
                    $("[id$=TextBox_CustomInquiries_InquirerEmail]").val($("[id$=TextBox_CustomInquiries_MemberEmail]").val());
                    $("[id$=TextBox_CustomInquiries_InquirerEmail]").change();
                }

                $("[id$=TextBox_CustomInquiries_MemberFirstName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_MemberMiddleName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_MemberLastName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr("Required");
                $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr("Required");
            }

            if ($(this).val() == "6781" && $("[id$=TextBox_CustomInquiries_ClientId]").val() != "") {

                $("[id$=TextBox_CustomInquiries_InquirerFirstName]").val($("[id$=TextBox_CustomInquiries_MemberFirstName]").val());
                $("[id$=TextBox_CustomInquiries_InquirerFirstName]").change();
                $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").val($("[id$=TextBox_CustomInquiries_MemberMiddleName]").val());
                $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").change();
                $("[id$=TextBox_CustomInquiries_InquirerLastName]").val($("[id$=TextBox_CustomInquiries_MemberLastName]").val());
                $("[id$=TextBox_CustomInquiries_InquirerLastName]").change();
                $("[id$=TextBox_CustomInquiries_InquirerPhone]").val($("[id$=TextBox_CustomInquiries_MemberPhone]").val());
                $("[id$=TextBox_CustomInquiries_InquirerPhone]").change();
                $("[id$=TextBox_CustomInquiries_InquirerPhoneExtension]").val($("[id$=TextBox_CustomInquiries_MemberPhoneExtension]").val());
                $("[id$=TextBox_CustomInquiries_InquirerPhoneExtension]").change();
                $("[id$=TextBox_CustomInquiries_InquirerEmail]").val($("[id$=TextBox_CustomInquiries_MemberEmail]").val());
                $("[id$=TextBox_CustomInquiries_InquirerEmail]").change();

                $("[id$=TextBox_CustomInquiries_MemberFirstName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr("Required");

                $("[id$=TextBox_CustomInquiries_MemberMiddleName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_MemberLastName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr("Required");
                $("[id$=TextBox_CustomInquiries_SSN]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_DateOfBirth]").attr('disabled', 'disabled');
                $("[id$=imgOrderDate]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_InquirerFirstName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_InquirerLastName]").attr('disabled', 'disabled');
            }

            if ($(this).val() != "6781" && $("[id$=TextBox_CustomInquiries_ClientId]").val() == "") {
                $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_MemberFirstName]").attr("Required", "true");
                $("[id$=TextBox_CustomInquiries_MemberMiddleName]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_MemberLastName]").attr("Required", "true");
                $('[id$=TextBox_CustomInquiries_SSN]').removeAttr('disabled');
                $('[id$=TextBox_CustomInquiries_DateOfBirth]').removeAttr('disabled');
                $('[id$=imgOrderDate]').removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_InquirerFirstName]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_InquirerLastName]").removeAttr('disabled');
            }
            if ($(this).val() != "6781" && $("[id$=TextBox_CustomInquiries_ClientId]").val() != "") {
                $("[id$=TextBox_CustomInquiries_MemberFirstName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr("Required");
                $("[id$=TextBox_CustomInquiries_MemberMiddleName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_MemberLastName]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr("Required");
                $("[id$=TextBox_CustomInquiries_SSN]").attr('disabled', 'disabled');
                $("[id$=TextBox_CustomInquiries_DateOfBirth]").attr('disabled', 'disabled');

                $("[id$=imgOrderDate]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_InquirerFirstName]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").removeAttr('disabled');
                $("[id$=TextBox_CustomInquiries_InquirerLastName]").removeAttr('disabled');
            }

            if ($(this).val() != "6781") {
                $("[id$=TextBox_CustomInquiries_InquirerFirstName]").val('');
                $("[id$=TextBox_CustomInquiries_InquirerLastName]").val('');
                $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").val('');
                $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").change();
                $("[id$=TextBox_CustomInquiries_InquirerFirstName]").change();
                $("[id$=TextBox_CustomInquiries_InquirerLastName]").change();
            }
        });
        $('[id$=DropDownList_CustomInquiries_ReferralSubtype]').unbind("change");
        $('[id$=DropDownList_CustomInquiries_ReferralSubtype]').bind("change", function() {

            if ($('[id$=DropDownList_CustomInquiries_ReferralSubtype]').val() == "0") {
                CreateAutoSaveXml('CustomInquiries', 'ReferralSubtype', '')
            }
        });
        
        //Inquirer to Member
        $("[id$=TextBox_CustomInquiries_InquirerFirstName]").unbind("change")
        $("[id$=TextBox_CustomInquiries_InquirerFirstName]").bind("change", function() {

            var firstName = $("[id$=TextBox_CustomInquiries_InquirerFirstName]").val();
            if ($('[id$=DropDownList_CustomInquiries_InquirerRelationToMember]').val() == "6781") {
                $("[id$=TextBox_CustomInquiries_MemberFirstName]").val(firstName);
                CreateAutoSaveXml('CustomInquiries', 'MemberFirstName', firstName);
            }
            CreateAutoSaveXml('CustomInquiries', 'InquirerFirstName', firstName);
        });
        $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").unbind("change");
        $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").bind("change", function() {
            var middleName = $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").val();
            if ($('[id$=DropDownList_CustomInquiries_InquirerRelationToMember]').val() == "6781") {
                $("[id$=TextBox_CustomInquiries_MemberMiddleName]").val(middleName);
                CreateAutoSaveXml('CustomInquiries', 'MemberMiddleName', middleName);
            }
            CreateAutoSaveXml('CustomInquiries', 'InquirerMiddleName', middleName);
        });
        $("[id$=TextBox_CustomInquiries_InquirerLastName]").unbind("change");
        $("[id$=TextBox_CustomInquiries_InquirerLastName]").bind("change", function() {
            var lastName = $("[id$=TextBox_CustomInquiries_InquirerLastName]").val();
            if ($('[id$=DropDownList_CustomInquiries_InquirerRelationToMember]').val() == "6781") {
                $("[id$=TextBox_CustomInquiries_MemberLastName]").val(lastName);
                CreateAutoSaveXml('CustomInquiries', 'MemberLastName', lastName);
            }
            CreateAutoSaveXml('CustomInquiries', 'InquirerLastName', lastName);
        });

        //Member to Inquirer
        $("[id$=TextBox_CustomInquiries_MemberPhone]").bind("change", function() {
            var memberPhone = $("[id$=TextBox_CustomInquiries_MemberPhone]").val();
            if ($('[id$=DropDownList_CustomInquiries_InquirerRelationToMember]').val() == "6781") {
                $("[id$=TextBox_CustomInquiries_InquirerPhone]").val(memberPhone);
                CreateAutoSaveXml('CustomInquiries', 'InquirerPhone', memberPhone);
            }
            CreateAutoSaveXml('CustomInquiries', 'MemberPhone', memberPhone);
        });

        //Inquirer to Member
        $("[id$=TextBox_CustomInquiries_InquirerPhone]").bind("change", function() {
            var memberPhone = $("[id$=TextBox_CustomInquiries_InquirerPhone]").val();
            if ($('[id$=DropDownList_CustomInquiries_InquirerRelationToMember]').val() == "6781") {
                $("[id$=TextBox_CustomInquiries_MemberPhone]").val(memberPhone);
                CreateAutoSaveXml('CustomInquiries', 'MemberPhone', memberPhone);
            }
            CreateAutoSaveXml('CustomInquiries', 'InquirerPhone', memberPhone);
        });

        //Inquirer to Member
        $("[id$=TextBox_CustomInquiries_InquirerPhoneExtension]").unbind("change");
        $("[id$=TextBox_CustomInquiries_InquirerPhoneExtension]").bind("change", function() {
            var memberExt = $("[id$=TextBox_CustomInquiries_InquirerPhoneExtension]").val();
            if ($('[id$=DropDownList_CustomInquiries_InquirerRelationToMember]').val() == "6781") {
                $("[id$=TextBox_CustomInquiries_MemberPhoneExtension]").val(memberExt);
                CreateAutoSaveXml('CustomInquiries', 'MemberPhoneExtension', memberExt);
            }
            CreateAutoSaveXml('CustomInquiries', 'InquirerPhoneExtension', memberExt);
        });

        //Member to Inquirer
        $("[id$=TextBox_CustomInquiries_MemberEmail]").unbind("change");
        $("[id$=TextBox_CustomInquiries_MemberEmail]").bind("change", function() {
            var memberEmail = $("[id$=TextBox_CustomInquiries_MemberEmail]").val();
            if ($('[id$=DropDownList_CustomInquiries_InquirerRelationToMember]').val() == "6781") {
                $("[id$=TextBox_CustomInquiries_InquirerEmail]").val(memberEmail);
                CreateAutoSaveXml('CustomInquiries', 'InquirerEmail', memberEmail);
            }
            CreateAutoSaveXml('CustomInquiries', 'MemberEmail', memberEmail);
        });
        //Inquirer to Member
        $("[id$=TextBox_CustomInquiries_InquirerEmail]").unbind("change");
        $("[id$=TextBox_CustomInquiries_InquirerEmail]").bind("change", function() {
            var memberEmail = $("[id$=TextBox_CustomInquiries_InquirerEmail]").val();
            if ($('[id$=DropDownList_CustomInquiries_InquirerRelationToMember]').val() == "6781") {
                $("[id$=TextBox_CustomInquiries_MemberEmail]").val(memberEmail);
                CreateAutoSaveXml('CustomInquiries', 'MemberEmail', memberEmail);
            }
            CreateAutoSaveXml('CustomInquiries', 'InquirerEmail', memberEmail);
        });
        if ($("[id$=TextBox_CustomInquiries_ClientId]").val() != "" || $("[id$=HiddenField_CustomInquiries_ClientId]").val() != "") {
            var clientId = $("[id$=TextBox_CustomInquiries_ClientId]").val();
            if (clientId == '') {
                clientId = $("[id$=HiddenField_CustomInquiries_ClientId]").val();
            }
            $("[id$=Button_RemoveMemberLink]").removeAttr('disabled');
            $("[id$=Button_LinkOrCreateMember]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberFirstName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr("Required");
            $("[id$=TextBox_CustomInquiries_MemberMiddleName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberLastName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr("Required");
            $("[id$=TextBox_CustomInquiries_SSN]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_DateOfBirth]").attr('disabled', 'disabled');
            $("[id$=imgOrderDate]").attr('disabled', 'disabled');
            GetMemberInformationText(clientId);
        }

        if ($("[id$=TextBox_CustomInquiries_ClientId]").val() == "" || $("[id$=HiddenField_CustomInquiries_ClientId]").val() == ""){
            $("[id$=Button_RemoveMemberLink]").attr('disabled', 'disabled');
            $("[id$=Button_LinkOrCreateMember]").removeAttr('disabled');
        }

        $("[id$=TextArea_MemberInformation]").attr('readonly', 'true');
        if ($("[id$=DropDownList_CustomInquiries_RecordedBy]").val() != "") {
            $("[id$=DropDownList_CustomInquiries_RecordedBy]").attr('disabled', 'disabled');
        }

        //Remove Member Link
        $('[id$=Button_RemoveMemberLink]').unbind("click");
        $('[id$=Button_RemoveMemberLink]').bind("click", function() {
            if (UnsavedChangeId <= 0) {
                if ($(this).is(':disabled') == false) {
                    var clientId = $("[id$=TextBox_CustomInquiries_ClientId]").val()
                    var clientName = $("[id$=TextBox_CustomInquiries_MemberLastName]").val();
                    if (clientName != "" && $("[id$=TextBox_CustomInquiries_MemberFirstName]").val() != "")
                        clientName += ", " + $("[id$=TextBox_CustomInquiries_MemberFirstName]").val();
                    else
                        clientName = $("[id$=TextBox_CustomInquiries_MemberFirstName]").val();
                    ShowMsgBox('You are about to remove the association between ' + clientName + '(' + clientId + ')  and this Inquiry. Are you sure you wish to remove this link?', 'Confirmation Message', MessageBoxButton.OKCancel, MessageBoxIcon.Question, 'RemoveMemberLink()');
                    $("span[id$=LabelTitle]").text('Inquiry Details');
                    document.title = 'Inquiry Details';
                }
            }
            else
                ShowMsgBox('Please save an inquiry before remove linking client with inquiry.', 'Confirmation Message', MessageBoxButton.OKCancel, MessageBoxIcon.Question);
        });
    }
    catch (err) {
        LogClientSideException(err, 'Events');
    }
}

function RemoveMemberLink() {
    $('[id$=TextBox_CustomInquiries_ClientId]').val("").change();
    //$('[id$=HiddenField_CustomInquiries_InquiryEventId]').val("").change();
    $('[id$=Button_RemoveMemberLink]').attr('disabled', 'disabled');
    $("[id$=Button_LinkOrCreateMember]").removeAttr('disabled');
    $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr('disabled');
    $("[id$=TextBox_CustomInquiries_MemberFirstName]").attr("Required", "true");
    $("[id$=TextBox_CustomInquiries_MemberMiddleName]").removeAttr('disabled');
    $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr('disabled');
    $("[id$=TextBox_CustomInquiries_MemberLastName]").attr("Required", "true");
    $('[id$=TextBox_CustomInquiries_SSN]').removeAttr('disabled');
    $('[id$=TextBox_CustomInquiries_MasterId]').val('').change();
    $('[id$=TextBox_CustomInquiries_MedicaidId]').val('').change();
    $('[id$=TextBox_CustomInquiries_DateOfBirth]').removeAttr('disabled');
    $('[id$=imgOrderDate]').removeAttr('disabled');
    SavePageData();
}

//Get Drop Down Items when Referral Type Change
function ReferralTypeChange() {
    //ReferralTypeChange1();
    try {
        var ReferralTypeId = $('select[id$=DropDownList_CustomInquiries_ReferralType]').val();

        if (ReferralTypeId > 0) {
            Flag = "ReferralTypeChange";
            OpenPage(5761, objectPageResponse.ScreenId, 'ReferralTypeId=' + ReferralTypeId + '^Flag=ReferralTypeChange', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
        }
    }
    catch (err) {
    }
}

function ShowClientSearchForLink(relationpath) {
    relationpath = GetRelativePath();
    //ShowClientSearchForLink1(relationpath);
    //Modified by sourabh: to display popup when unsaved instance with ref to task#545
    if (UnsavedChangeId <= 0) {
        var filterdata = "";
        var firstName = $.xmlDOM(AutoSaveXMLDom[0].xml).find("MemberFirstName").text(); 
        var lastName = $.xmlDOM(AutoSaveXMLDom[0].xml).find("MemberLastName").text();
        $('[id$=HiddenField_CustomInquiries_SSN]').mask("999-99-9999");
        //$('[id$=HiddenField_CustomInquiries_SSN]').change();
        var ssn = $("[id$=HiddenField_CustomInquiries_SSN]").val();
        var ssnArr = ssn.split('-');
        var ssnFirst = ssnArr[0];
        var ssnSecond = ssnArr[1];
        var ssnThird = ssnArr[2];
        if (ssnFirst == undefined || ssnFirst == '___' || ssnFirst == '_________') {
            ssnFirst = "";
        }
        if (ssnSecond == undefined || ssnSecond == '__') {
            ssnSecond = "";
        }
        if (ssnThird == undefined || ssnThird == '____') {
            ssnThird = "";
        }
        var HiddenField_CustomInquiries_DateOfBirth = $('[id$=HiddenField_CustomInquiries_DateOfBirth]')
        HiddenField_CustomInquiries_DateOfBirth.val(ChangeDateFormat($("[id$=HiddenField_CustomInquiries_DateOfBirth]").val()));
        //HiddenField_CustomInquiries_DateOfBirth.change();
        var dob = $("[id$=HiddenField_CustomInquiries_DateOfBirth]").val();
        OpenClientSearchPage(relationpath, 'InquiryDetails', filterdata, '', '', '', 'Open Client Record', 'ButtonOpenMemberRecord', 'N', 'Y', 'Custom1SendSearchParameterFirstName=' + firstName + '^Custom1SendSearchParameterLastName=' + lastName + '^Custom1SendSearchParameterSSNFirst=' + ssnFirst + '^Custom1SendSearchParameterSSNSecond=' + ssnSecond + '^Custom1SendSearchParameterSSN=' + ssnThird + '^Custom1SendSearchParameterDOB=' + dob, '0', 'Create New Client Record', 'ButtonNewPotentialMember', 'Y', 'N', 'Custom2SendSearchParameterFirstName=' + firstName + '^Custom2SendSearchParameterLastName=' + lastName + '^Custom2SendSearchParameterSSNFirst=' + ssnFirst + '^Custom2SendSearchParameterSSNSecond=' + ssnSecond + '^Custom2SendSearchParameterSSN=' + ssnThird + '^Custom2SendSearchParameterDOB=' + dob, '0');
    }
    else {
        ShowMsgBox('Please save an inquiry before linking client with inquiry.', 'Confirmation Message', MessageBoxButton.OKCancel, MessageBoxIcon.Question);
    }
}


function AppednMemberInfo(ClientInfo, Flag, MemberInfoText) {
    var InquiryRelationToMember = $("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]");
    if (Flag == "Create New Potential Member") {
        var TextBox_CustomInquiries_ClientId = $('[id$=TextBox_CustomInquiries_ClientId]');
        TextBox_CustomInquiries_ClientId.val(ClientInfo[0]);
        CreateAutoSaveXml('CustomInquiries', 'ClientId', ClientInfo[0]);
        $('[id$=Button_RemoveMemberLink]').removeAttr('disabled');
        $("[id$=Button_LinkOrCreateMember]").attr('disabled', 'disabled');
        var TextBox_CustomInquiries_MemberLastName = $('[id$=TextBox_CustomInquiries_MemberLastName]');
        TextBox_CustomInquiries_MemberLastName.val(ClientInfo[1]);
        TextBox_CustomInquiries_MemberLastName.change();
//        var TextBox_CustomInquiries_MemberMiddleName = $('[id$=TextBox_CustomInquiries_MemberMiddleName]');
//        .val(ClientInfo[1]);
//        TextBox_CustomInquiries_MemberMiddleName.change();
        var TextBox_CustomInquiries_MemberFirstName = $('[id$=TextBox_CustomInquiries_MemberFirstName]');
        TextBox_CustomInquiries_MemberFirstName.val(ClientInfo[2]);
        TextBox_CustomInquiries_MemberFirstName.change();
        var TextBox_CustomInquiries_SSN = $('[id$=TextBox_CustomInquiries_SSN]');
        TextBox_CustomInquiries_SSN.val(ClientInfo[3]);
        TextBox_CustomInquiries_SSN.change();
        var TextBox_CustomInquiries_DateOfBirth = $('[id$=TextBox_CustomInquiries_DateOfBirth]')
        TextBox_CustomInquiries_DateOfBirth.val(ChangeDateFormat(ClientInfo[4]));
        TextBox_CustomInquiries_DateOfBirth.change();
        if ($("input[Id$=TextBox_CustomInquiries_DateOfBirth]").length > 0) {
            GetAge($("input[Id$=TextBox_CustomInquiries_DateOfBirth]"));
        }
        var TextArea_MemberInformation = $('[id$=TextArea_MemberInformation]');
        TextArea_MemberInformation.val(MemberInfoText);
        TextArea_MemberInformation.change();
        var TextBox_CustomInquiries_MemberFirstName = $('[id$=TextBox_CustomInquiries_MemberFirstName]');
        TextBox_CustomInquiries_MemberFirstName.attr('disabled', 'disabled');
        TextBox_CustomInquiries_MemberFirstName.removeAttr("Required");
        var TextBox_CustomInquiries_MemberMiddleName = $('[id$=TextBox_CustomInquiries_MemberMiddleName]')
        TextBox_CustomInquiries_MemberMiddleName.attr('disabled', 'disabled');
        var TextBox_CustomInquiries_MemberLastName = $('[id$=TextBox_CustomInquiries_MemberLastName]')
        TextBox_CustomInquiries_MemberLastName.attr('disabled', 'disabled');
        TextBox_CustomInquiries_MemberLastName.removeAttr("Required");
        var TextBox_CustomInquiries_SSN = $('[id$=TextBox_CustomInquiries_SSN]');
        TextBox_CustomInquiries_SSN.attr('disabled', 'disabled');
        var TextBox_CustomInquiries_DateOfBirth = $('[id$=TextBox_CustomInquiries_DateOfBirth]');
        TextBox_CustomInquiries_DateOfBirth.attr('disabled', 'disabled');
        $('[id$=imgOrderDate]').attr('disabled', 'disabled');
        if (InquiryRelationToMember.val() == "6781") {

            $('[id$=TextBox_CustomInquiries_InquirerFirstName]').val(TextBox_CustomInquiries_MemberFirstName.val());
            $('[id$=TextBox_CustomInquiries_InquirerFirstName]').change();
            $('[id$=TextBox_CustomInquiries_InquirerMiddleName]').val(TextBox_CustomInquiries_MemberMiddleName.val());
            $('[id$=TextBox_CustomInquiries_InquirerMiddleName]').change();
            $('[id$=TextBox_CustomInquiries_InquirerLastName]').val(TextBox_CustomInquiries_MemberLastName.val());
            $('[id$=TextBox_CustomInquiries_InquirerLastName]').change();
        }
        //Modified by sourabh to remove client name with ref to task#545
        $("span[id$=LabelTitle]").text('Inquiry Details');
        if (ClientInfo[1] == '' || ClientInfo[2] == '') {
            document.title = 'Inquiry Details' + ' [' + '(' + ClientInfo[0] + ')' + ']';
        }
        else {
            document.title = 'Inquiry Details' + ' [' + ClientInfo[1] + ', ' + ClientInfo[2] + ' (' + ClientInfo[0] + ')' + ']';
        }
        $("[id$=TextBox_CustomInquiries_ClientId]").attr('disabled', 'disabled');
        return false;
    }

    if (Flag == "Inquiry (Selected Client)" || Flag == "Select Member" || Flag == "New Registration") {
        $('[id$=TextBox_CustomInquiries_ClientId]').val(ClientInfo[0]);

        //----- BY PKS On Feb 17, 2012 --------
        if ($("[id$=TextBox_CustomInquiries_ClientId]").val() == "") {
            $("[id$=TextBox_CustomInquiries_ClientId]").attr('disabled', 'disabled');
        }
        else {
            $("[id$=TextBox_CustomInquiries_ClientId]").removeAttr('disabled');
        }
        //-------------------------------------

        CreateAutoSaveXml('CustomInquiries', 'ClientId', ClientInfo[0]);
        AutoSaveFirstCall = false;
        $('[id$=Button_RemoveMemberLink]').removeAttr('disabled');
        $("[id$=Button_LinkOrCreateMember]").attr('disabled', 'disabled');

        $('[id$=TextBox_CustomInquiries_MemberFirstName]').val(ClientInfo[1]);
        $('[id$=TextBox_CustomInquiries_MemberFirstName]').change();

        $('[id$=TextBox_CustomInquiries_MemberMiddleName]').val(ClientInfo[2]);
        $('[id$=TextBox_CustomInquiries_MemberMiddleName]').change();

        $('[id$=TextBox_CustomInquiries_MemberLastName]').val(ClientInfo[3]);
        $('[id$=TextBox_CustomInquiries_MemberLastName]').change();

        $('[id$=TextBox_CustomInquiries_SSN]').val(ClientInfo[4]);
        $('[id$=TextBox_CustomInquiries_SSN]').mask("999-99-9999");
        $('[id$=TextBox_CustomInquiries_SSN]').change();

        $('[id$=TextBox_CustomInquiries_DateOfBirth]').val(ChangeDateFormat(ClientInfo[5]));
        $('[id$=TextBox_CustomInquiries_DateOfBirth]').change();

        if ($("input[Id$=TextBox_CustomInquiries_DateOfBirth]").length > 0) {
            GetAge($("input[Id$=TextBox_CustomInquiries_DateOfBirth]"));
        }

        $('[id$=TextBox_CustomInquiries_MemberPhone]').val(ClientInfo[6]);
        $('[id$=TextBox_CustomInquiries_MemberPhone]').change();

        $('[id$=TextBox_CustomInquiries_MemberEmail]').val(ClientInfo[7]);
        $('[id$=TextBox_CustomInquiries_MemberEmail]').change();

        $('[id$=TextBox_CustomInquiries_Address1]').val(ClientInfo[8]);
        $('[id$=TextBox_CustomInquiries_Address1]').change();

        $('[id$=TextBox_CustomInquiries_Address2]').val(ClientInfo[9]);
        $('[id$=TextBox_CustomInquiries_Address2]').change();

        $('[id$=TextBox_CustomInquiries_City]').val(ClientInfo[10]);
        $('[id$=TextBox_CustomInquiries_City]').change();

        $('[id$=DropDownList_CustomInquiries_State]').val(ClientInfo[11]);
        $('[id$=DropDownList_CustomInquiries_State]').change();

        $('[id$=TextBox_CustomInquiries_ZipCode]').val(ClientInfo[12]);
        $('[id$=TextBox_CustomInquiries_ZipCode]').change();

        if (Flag == "Inquiry (Selected Client)" || Flag == "Select Member") {
            $('[id$=TextBox_CustomInquiries_EmergencyContactFirstName]').val(ClientInfo[13]);
            $('[id$=TextBox_CustomInquiries_EmergencyContactFirstName]').change();
            $('[id$=TextBox_CustomInquiries_EmergencyContactMiddleName]').val(ClientInfo[14]);
            $('[id$=TextBox_CustomInquiries_EmergencyContactMiddleName]').change();

            $('[id$=TextBox_CustomInquiries_EmergencyContactLastName]').val(ClientInfo[15]);
            $('[id$=TextBox_CustomInquiries_EmergencyContactLastName]').change();

            $('[id$=DropDownList_CustomInquiries_EmergencyContactRelationToClient]').val(ClientInfo[16]);
            $('[id$=DropDownList_CustomInquiries_EmergencyContactRelationToClient]').change();

            $('[id$=TextBox_CustomInquiries_EmergencyContactHomePhone]').val(ClientInfo[17]);
            $('[id$=TextBox_CustomInquiries_EmergencyContactHomePhone]').change();

            $('[id$=TextBox_CustomInquiries_EmergencyContactCellPhone]').val(ClientInfo[18]);
            $('[id$=TextBox_CustomInquiries_EmergencyContactCellPhone]').change();

            $('[id$=TextBox_CustomInquiries_EmergencyContactWorkPhone]').val(ClientInfo[19]);
            $('[id$=TextBox_CustomInquiries_EmergencyContactWorkPhone]').change();

            $('[id$=DropDownList_CustomInquiries_Sex]').val(ClientInfo[20]);
            $('[id$=DropDownList_CustomInquiries_Sex]').change();

            $('[id$=DropDownList_CustomInquiries_PresentingPopulation]').val(ClientInfo[21]);
            $('[id$=DropDownList_CustomInquiries_PresentingPopulation]').change();

            $('[id$=TextBox_CustomInquiries_MasterId]').val(ClientInfo[22]);
            $('[id$=TextBox_CustomInquiries_MasterId]').change();

            $('[id$=TextBox_CustomInquiries_MedicaidId]').val(ClientInfo[23]);
            $('[id$=TextBox_CustomInquiries_MedicaidId]').change();

        }

        $('[id$=TextArea_MemberInformation]').val(MemberInfoText);
        $('[id$=TextArea_MemberInformation]').change();

        $('[id$=TextBox_CustomInquiries_MemberFirstName]').attr('disabled', 'disabled');
        $('[id$=TextBox_CustomInquiries_MemberMiddleName]').attr('disabled', 'disabled');
        $('[id$=TextBox_CustomInquiries_MemberLastName]').attr('disabled', 'disabled');

        $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr("Required");
        $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr("Required");

        $('[id$=TextBox_CustomInquiries_SSN]').attr('disabled', 'disabled');
        $('[id$=TextBox_CustomInquiries_DateOfBirth]').attr('disabled', 'disabled');
        $('[id$=imgOrderDate]').attr('disabled', 'disabled');
        if (InquiryRelationToMember.val() == "6781") {

            $('[id$=TextBox_CustomInquiries_InquirerFirstName]').removeAttr('disabled');
            $('[id$=TextBox_CustomInquiries_InquirerMiddleName]').removeAttr('disabled');
            $('[id$=TextBox_CustomInquiries_InquirerLastName]').removeAttr('disabled');
            $('[id$=TextBox_CustomInquiries_InquirerFirstName]').val($('[id$=TextBox_CustomInquiries_MemberFirstName]').val());
            $('[id$=TextBox_CustomInquiries_InquirerFirstName]').change();
            $('[id$=TextBox_CustomInquiries_InquirerMiddleName]').val($('[id$=TextBox_CustomInquiries_MemberMiddleName]').val());
            $('[id$=TextBox_CustomInquiries_InquirerMiddleName]').change();
            $('[id$=TextBox_CustomInquiries_InquirerLastName]').val($('[id$=TextBox_CustomInquiries_MemberLastName]').val());
            $('[id$=TextBox_CustomInquiries_InquirerLastName]').change();
        }
        //Modified by sourabh to remove client name with ref to task#545
        $("span[id$=LabelTitle]").text('Inquiry Details');
        if (ClientInfo[3] == '' || ClientInfo[1] == '') {
            document.title = 'Inquiry Details' + ' - ' + '(' + ClientInfo[0] + ')';
        }
        else {
            document.title = 'Inquiry Details' + ' - ' + ClientInfo[3] + ', ' + ClientInfo[1] + ' (' + ClientInfo[0] + ')';
        }
        return false;
    }
}

function GetMemberInformationText(clientId) {
    if (clientId > 0) {
        Flag = "GetMemberInformationText";
        OpenPage(5761, objectPageResponse.ScreenId, 'MClientId=' + clientId + '^Flag=GetMemberInformationText', 1, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    }
}

function SetScreenSpecificValues(dom, action) {
    //Added by Atul Pandey w.rf.t task #2 of CentraWellness Customization
    //What :To Disable TextArea of section 'Risk Assessment' on selection of Radio Button
    //Why  :Nedeed this fuctionality according to UI according to project review held on 14/jan/2013
    if (TabIndex == 0) {
        if ($("#RadioButton_CustomInquiries_RiskAssessmentInDanger_No").attr('checked') == true) {
            $('#TextArea_CustomInquiries_RiskAssessmentInDangerComment').attr("disabled", "disabled");
        }

        if ($("#RadioButton_CustomInquiries_RiskAssessmentCounselorAvailability_Yes").attr('checked') == true) {
            $('#TextArea_CustomInquiries_RiskAssessmentCounselorAvailabilityComment').attr("disabled", "disabled");
        }
        if ($("#RadioButton_CustomInquiries_RiskAssessmentCrisisLine_Yes").attr('checked') == true) {
            $('#TextArea_CustomInquiries_RiskAssessmentCrisisLineComment').attr("disabled", "disabled");
        }
        //till here

        if (DispositionControl != null) {
            DispositionControl.BindDispositionEvents("divDisposition");
        }
        $("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]").focus();
        if ($("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]").val() == "6781" && $('[id$=TextBox_CustomInquiries_ClientId]').val() == "") {
            $("[id$=TextBox_CustomInquiries_MemberFirstName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberMiddleName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberLastName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr("Required");
            $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr("Required");

            $('[id$=TextBox_CustomInquiries_SSN]').removeAttr('disabled');
            $('[id$=TextBox_CustomInquiries_DateOfBirth]').removeAttr('disabled');
            $('[id$=imgOrderDate]').removeAttr('disabled');
            $("[id$=TextBox_CustomInquiries_InquirerFirstName]").removeAttr('disabled');
            $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").removeAttr('disabled');
            $("[id$=TextBox_CustomInquiries_InquirerLastName]").removeAttr('disabled');
            //Added by sanjayb with ref to task#738 (Pralyankar sir)
            //    var InquiryRelationToMember = $("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]");
            //    if (InquiryRelationToMember.val() == "6781") {

            //        $('[id$=TextBox_CustomInquiries_InquirerFirstName]').val($('[id$=TextBox_CustomInquiries_MemberFirstName]').val());
            //        $('[id$=TextBox_CustomInquiries_InquirerFirstName]').change();
            //        $('[id$=TextBox_CustomInquiries_InquirerMiddleName]').val($('[id$=TextBox_CustomInquiries_MemberMiddleName]').val());
            //        $('[id$=TextBox_CustomInquiries_InquirerMiddleName]').change();
            //        $('[id$=TextBox_CustomInquiries_InquirerLastName]').val($('[id$=TextBox_CustomInquiries_MemberLastName]').val());
            //        $('[id$=TextBox_CustomInquiries_InquirerLastName]').change();
            //    }
        }

        if ($("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]").val() == "6781" && $('[id$=TextBox_CustomInquiries_ClientId]').val() != "") {
            $("[id$=TextBox_CustomInquiries_InquirerFirstName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_InquirerMiddleName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_InquirerLastName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberFirstName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberMiddleName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberLastName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr("Required");
            $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr("Required");
            $("[id$=TextBox_CustomInquiries_SSN]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_DateOfBirth]").attr('disabled', 'disabled');
            $("[id$=imgOrderDate]").attr('disabled', 'disabled');
        }

        if ($("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]").val() != "6781" && $('[id$=TextBox_CustomInquiries_ClientId]').val() != "") {
            $("[id$=TextBox_CustomInquiries_MemberFirstName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberMiddleName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberLastName]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_MemberFirstName]").removeAttr("Required");
            $("[id$=TextBox_CustomInquiries_MemberLastName]").removeAttr("Required");

            $("[id$=TextBox_CustomInquiries_SSN]").attr('disabled', 'disabled');
            $("[id$=TextBox_CustomInquiries_DateOfBirth]").attr('disabled', 'disabled');
            $("[id$=imgOrderDate]").attr('disabled', 'disabled');
        }

        //Added by sourabh to disable pregnant dropdown with ref to task#545
        if ($("CustomInquiries Sex", dom).text() == "M") {
            $("[name=RadioButton_CustomInquiries_Pregnant]").attr('disabled', 'disabled');
        }
        else {
            $("[name=RadioButton_CustomInquiries_Pregnant]").removeAttr('disabled');
        }

        if ($("input[Id$=TextBox_CustomInquiries_DateOfBirth]").length > 0) {
            GetAge($("input[Id$=TextBox_CustomInquiries_DateOfBirth]"));
        }
        functionDisableStatusDropDown();
        if ($('#Hidden_CustomInquiries_InquiryEndTime').val() != '') {
            $('#Text_CustomInquiries_InquiryEndTime').val($('#Hidden_CustomInquiries_InquiryEndTime').val());
        }
        $('#Text_CustomInquiries_InquiryStartTime').val($('#Hidden_CustomInquiries_InquiryStartTime').val());

    }
    var AccNeedVal = $("CustomInquiries AccomodationNeeded", dom).text();
    var ArrNeedValArr = AccNeedVal.split(',');
    $(ArrNeedValArr).each(function(i) {
        switch (parseInt(ArrNeedValArr[i])) {
            case 0:
                $("#CheckBox_CustomInquiries_AccomodationNeeded_0").attr("checked", "checked");
                break;
            case 1:
                $("#CheckBox_CustomInquiries_AccomodationNeeded_1").attr("checked", "checked");
                break;
            case 2:
                $("#CheckBox_CustomInquiries_AccomodationNeeded_2").attr("checked", "checked");
                break;
        }
    });

    var CustomInquiries = $("CustomInquiries", $(dom).get(0));
    if (CustomInquiries.length > 0) {

        if ($(CustomInquiries).find('InquiryId').length > 0) {

            ValInquiryId = $(CustomInquiries).find('InquiryId').text();
        }
    }

    if (action == pageActionEnum.Update) {
        UpdateScreenHistoryNode(CurrentHistoryId, CurrentScreenId, "FiltersData", "InquiryId=" + ValInquiryId);
    }
    
    if (TabIndex == 1) {
        if ($.xmlDOM(objectPageResponse.PageDataSetXml).find("CustomInquiriesCoverageInformations").length > 0) {
            emptydata[0].DocumentVersionId = dom.find("CustomInquiriesCoverageInformations:first InquiryId").text();
            _inquiryid = dom.find("CustomInquiriesCoverageInformations:first InquiryId").text();
            dom.find("CustomInquiriesCoverageInformations").each(function () {
                $(this).children().each(function () {
                    if (this.tagName == "InquiriesCoverageInformationId") {
                        if (parseInt($(this).text()) < 0 && _CoverageInfoId <= 0 && _CoverageInfoId > parseInt($(this).text())) {
                            _CoverageInfoId = parseInt($(this).text());
                        }
                    }
                });
            });
            if (_inquiryid = 0)
                _inquiryid = dom.find("CustomInquiriesCoverageInformations:first InquiryId").text();
            if (_inquiryid = 0)
                _inquiryid = -1;
        }
        else {
            _inquiryid = dom.find("CustomInquiriesCoverageInformations:first InquiryId").text();
        }

        if (tabAferCareClicked == false) {
            tabAferCareClicked = true;
            var appointmentsobjectivestring = $('[id$=HiddenFieldAppointments]').val();
            if (checkjsonstring(appointmentsobjectivestring) == true) {
                var appointments = $.parseJSON(appointmentsobjectivestring);
                if (appointments == null) {
                    appointments = '';
                }
                if (appointments.length > 0) {
                    var appointmentsobjectivestring1 = $('[id$=HiddenFieldsPlan]').val();
                    var htmlText = "";
                    $.templates('varappointmentHTML',
                      {
                          markup: "#appointmentHTML",
                          allowCode: true
                      }); 
                    for (var x = 0; x < appointments.length; x++) {
                        var test = $.parseJSON(appointmentsobjectivestring1);
                        for (var p = 0; p < $.parseJSON(appointmentsobjectivestring1).length; p++) {
                            if (test[p].CoveragePlanId == appointments[x].CoveragePlanId) {
                                test[p].IsSelected = 'Y';
                                break;
                            }
                        }
                        appointments[x].plansdropdownarray = test;
                    }
                    htmlText = $.render.varappointmentHTML(appointments);
                    
                    //$("#appointmentContainer").append($('#appointmentHTML').render(emptydata));
                    $("#appointmentContainer").append(htmlText);

                    //$("#appointmentContainer").append($('#appointmentHTML').render(appointments));
                }
                else {
                    //AddNewCoverageInformation();
                }
            }
            else {
                //AddNewCoverageInformation();
            }
        }
    }
}




function functionDisableStatusDropDown() {
    //Disabling the dropdown of the Inquiry Status if it is complete
    if ($("#HiddenField_CustomInquiries_DefaultInquiryStatus").val() == InquiryStatusCode.completeGlobalCode)
        $("[id$=DropDownList_CustomInquiries_InquiryStatus]").attr('disabled', 'disabled');
}

function CustomButtonEventHandler(btnObject, data, controlValues) {
    var controlValueArr = new Array();
    $.each(controlValues, function(key, value) {
        switch (key) {
            case 'FirstName':
                controlValueArr[0] = value;
                break;
            case 'LastName':
                controlValueArr[1] = value;
                break;
            case 'SSN':
                controlValueArr[2] = value;
                break;
            case 'DOB':
                controlValueArr[3] = value;
                break;
        }
    });

    var btnObjectText = $(btnObject).val();
    var collection = data.split(':');
    var relativePath = GetRelativePath();
    if (btnObjectText == 'Open Client Record') {
        var filter = 'ClientId=' + collection[0] + '^ClientName=' + collection[1];
        OpenPage(5764, 19, filter, 2, relativePath);
    }
    else if (btnObjectText == 'New Registration') {
        Flag = "New Registration";
        var filter = 'FirstName=' + controlValueArr[0] + '^LastName=' + controlValueArr[1] + '^SSN=' + controlValueArr[2] + '^DOB=' + controlValueArr[3] + '^Flag=New Registration';
        OpenPage(5761, 10683, filter, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    }
    else if (btnObjectText == 'Create New Client Record') {
        Flag = "Create New Potential Member";
        var filter = 'FirstName=' + controlValueArr[0] + '^LastName=' + controlValueArr[1] + '^SSN=' + controlValueArr[2] + '^DOB=' + controlValueArr[3] + '^Flag=Create New Potential Member';
        OpenPage(5761, 10683, filter, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    }
}

function CustomAjaxRequestCallback(result, CustomAjaxRequest) {
    if (Flag == "Create New Potential Member") {
        var startIndexCreateMember = result.indexOf("###StartCreateMember###") + 23;
        var endIndexCreateMember = result.indexOf("###EndCreateMember###");
        var outputHTMLCreateMember = result.substr(startIndexCreateMember, endIndexCreateMember - startIndexCreateMember);

        var startIndexText = result.indexOf("###StartText###") + 15;
        var endIndexText = result.indexOf("###EndText###");
        var MemberInfoText = result.substr(startIndexText, endIndexText - startIndexText);

        var ClientInfo = outputHTMLCreateMember.split('!@#$%');

        parent.CloaseModalPopupWindow();
        if (typeof parent.AppednMemberInfo == 'function') {
            var retVal = parent.AppednMemberInfo(ClientInfo, Flag, MemberInfoText);
            if (retVal == false) {
                return false;
            }
        }
    }

    if (Flag == "Inquiry (Selected Client)") {
        var startIndexInquiryMember = result.indexOf("###StartInquiryMember###") + 24;
        var endIndexInquiryMember = result.indexOf("###EndInquiryMember###");
        var outputHTMLInquiryMember = result.substr(startIndexInquiryMember, endIndexInquiryMember - startIndexInquiryMember);

        var startIndexText = result.indexOf("###StartText###") + 15;
        var endIndexText = result.indexOf("###EndText###");
        var MemberInfoText = result.substr(startIndexText, endIndexText - startIndexText);

        var ClientInfo = outputHTMLInquiryMember.split('!@#$%');

        parent.CloaseModalPopupWindow();
        if (typeof parent.AppednMemberInfo == 'function') {
            var retVal = parent.AppednMemberInfo(ClientInfo, Flag, MemberInfoText);
            if (retVal == false) {
                return false;
            }
        }
    }

    if (Flag == "New Registration") {
        var startIndexCreateMember = result.indexOf("###StartCreateMember###") + 23;
        var endIndexCreateMember = result.indexOf("###EndCreateMember###");
        var outputHTMLCreateMember = result.substr(startIndexCreateMember, endIndexCreateMember - startIndexCreateMember);

        var ClientInfo = outputHTMLCreateMember.split('!@#$%');
        var clientId = ClientInfo[0];
        var clientName = ClientInfo[1] + ', ' + ClientInfo[2];
        parent.CloaseModalPopupWindow();
        CreateAutoSaveXml('CustomInquiries', 'ClientId', clientId);
        if (typeof parent.AppednMemberInfo == 'function') {
            var retVal = parent.AppednMemberInfo(ClientInfo, Flag, '');
            SavePageData();
        }
    }

    if (Flag == "ReferralTypeChange") {
        var startIndexReferralType = result.indexOf("###StartReferralType###") + 23;
        var endIndexReferralType = result.indexOf("###EndReferralType###");
        var outputHTMLReferralType = result.substr(startIndexReferralType, endIndexReferralType - startIndexReferralType);
        $('[id$=DropDownList_CustomInquiries_ReferralSubtype]').html($(outputHTMLReferralType).find('select').html());
        $('[id$=DropDownList_CustomInquiries_ReferralSubtype]').change();
    }

    if (Flag == "GetMemberInformationText") {

        var startIndexText = result.indexOf("###StartText###") + 15;
        var endIndexText = result.indexOf("###EndText###");
        if (endIndexText > 0) {
            var outputHTMLText = result.substr(startIndexText, endIndexText - startIndexText);
            $('[id$=TextArea_MemberInformation]').val(outputHTMLText);
            $('[id$=TextArea_MemberInformation]').attr('readonly', 'true');
        }
    }

    if (Flag == "Select Member") {
        var startIndexInquiryMember = result.indexOf("###StartInquiryMember###") + 24;
        var endIndexInquiryMember = result.indexOf("###EndInquiryMember###");
        var outputHTMLInquiryMember = result.substr(startIndexInquiryMember, endIndexInquiryMember - startIndexInquiryMember);

        var startIndexText = result.indexOf("###StartText###") + 15;
        var endIndexText = result.indexOf("###EndText###");
        var MemberInfoText = result.substr(startIndexText, endIndexText - startIndexText);

        var ClientInfo = outputHTMLInquiryMember.split('!@#$%');

        parent.CloaseModalPopupWindow();
        if (typeof parent.AppednMemberInfo == 'function') {
            var retVal = parent.AppednMemberInfo(ClientInfo, Flag, MemberInfoText);
            SavePageData();
        }
    }

    if (Flag == "CheckEpisodes") {
        var startIndexText = result.indexOf("###StartEpisode###") + 18;
        var endIndexText = result.indexOf("###EndEpisode###");
        var outputHTMLText = result.substr(startIndexText, endIndexText - startIndexText);

        if (outputHTMLText == 'Y') {
            ShowHideErrorMessage('An Episode is already open for this member, verify member information before proceeding.', 'true');
            return false;
        }
        else {
            SavePageData();
        }
    }

    if (result.indexOf("###StartDisposition###") >= 0) {
        var start = result.indexOf("###StartDisposition###") + 22;
        var end = result.indexOf("###EndDisposition###");
        var str = result.substr(start, end - start);
        if (DispositionControl != null)
            DispositionControl.FillHTMLToControl(str);
    }

    if (result.indexOf("###StartDispositionHTML###") >= 0) {
        var start = result.indexOf("###StartDispositionHTML###") + 26;
        var end = result.indexOf("###EndDispositionHTML###");
        var str = result.substr(start, end - start);
        if (DispositionControl != null)
            DispositionControl.FillHTMLToDropDowns(str);
    }
}

InquiryStatusCode = {
    completeGlobalCode: ''
}



function ProcessClientInfo(ClientId, ClientName, functionCalledFrom, Status) {
    Flag = "Select Member";
    OpenPage(5761, 10683, 'MClientId=' + ClientId + '^Flag=Select Member', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
}

// This function fire on Save Click
function ValidateCustomPageEventHandler() {
    var CustomInquiriesDom = $("CustomInquiries", AutoSaveXMLDom[0]);
    if ($("InquiryStartDate", CustomInquiriesDom[0]).length > 0) {
        if ($("InquiryStartDate", CustomInquiriesDom[0]).text() == '') {//($.trim($('[id$=TextBox_CustomInquiries_InquiryStartDate]').val()) == "") {
            ShowHideErrorMessage('Inquiry Start Date is required', 'true');
            return false;
        }
    }

    if ($("InquiryStartTime", CustomInquiriesDom[0]).length > 0) {
        if ($("InquiryStartTime", CustomInquiriesDom[0]).text() == '') {//($.trim($('[id$=TextBox_CustomInquiries_InquiryStartDate]').val()) == "") {
            ShowHideErrorMessage('Inquiry Start Time is required', 'true');
            return false;
        }
    }
  

    if (!CheckStartDateEndDate())
        return false;

    if ($("[id$=DropDownList_CustomInquiries_InquiryStatus]").val() == InquiryStatusCode.completeGlobalCode) {
        var signed = $("[name$=RadioButton_CustomInquiries_ClientCanLegalySign]:checked").val();
        if (signed == undefined) {
            ShowHideErrorMessage('Document cannot be ‘Complete’ until the user has Legally Sign selected ‘Yes’ or ‘No’ ', 'true');
            return false;
        }
    }
   // debugger;
    // added by rakesh garg on 22 jan 2013 for ref task #13 in Newaygo Customizations
    //Why : Arrival time is mandatory incase of Walk in subtype,,..
    if ($("[id$=DropDownList_CustomInquiries_ReferralSubtype] option:selected").text().toLowerCase() == "walk in" && $('[id$=TextBoxTime_CustomInquiries_ReferralArrivalTime]').val() == "") {
        //var ArrivalTime = $("TextBox_CustomInquiries_ReferralName", CustomInquiriesDom[0]).text();
        // if (ArrivalTime == undefined || ArrivalTime == '') {
        ShowHideErrorMessage('Arrival Time is required incase of Walk In SubType', 'true');
        return false;
        //}
    }

    if (($.trim($('[id$=DropDownList_CustomInquiries_UrgencyLevel] option:selected').text()) == "Emergent" || $.trim($('[id$=DropDownList_CustomInquiries_UrgencyLevel] option:selected').text()) == "Urgent")
        && $('#RadioButton_CustomInquiries_RiskAssessmentCrisisLine_N').is(':checked')) {
        ShowHideErrorMessage('Inquiry - Risk assessment - Was the consumer advised of the availability of 24/7 crisis line must be answered yes', 'true');
        return false;
    }

    if ($('#TextBox_CustomInquiries_InquirerPhone').val() != '') {
        var phonenumber = $('#TextBox_CustomInquiries_InquirerPhone').val().replace(/[^0-9]/gi, '');
        if (phonenumber.length > 10) {
            ShowHideErrorMessage('Client Information - Phone number must be 10 digits', 'true');
            return false;
        }
    }
    
    var arr=new Array();
    var Planlength = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InquiriesCoverageInformationId").length;
    var xmlDocument = "<Root><ClientPlans>"
    for (var a = 0; a < Planlength; a++) {
        var InquiriesCoverageInformationId = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InquiriesCoverageInformationId")[a].text;
        var planid = GetColumnValueInXMLNodeByKeyValue('CustomInquiriesCoverageInformations', 'InquiriesCoverageInformationId', InquiriesCoverageInformationId, 'CoveragePlanId', AutoSaveXMLDom);
        var insuredid = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InsuredId")[a].text;
        var GroupId = $.xmlDOM(AutoSaveXMLDom[0].xml).find("GroupId")[a].text;
        var Recorddeleted = GetColumnValueInXMLNodeByKeyValue('CustomInquiriesCoverageInformations', 'InquiriesCoverageInformationId', InquiriesCoverageInformationId, 'RecordDeleted', AutoSaveXMLDom);
        //var planid = $.xmlDOM(AutoSaveXMLDom[0].xml).find("CoveragePlanId")[a].text;
        //var insuredid = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InsuredId")[a].text;
        //var groupid = $.xmlDOM(AutoSaveXMLDom[0].xml).find("GroupId")[a].text;
        //var InquiriesCoverageInformationId = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InquiriesCoverageInformationId")[a].text;

        /* New Directions - Support Go Live #109 */
        /* Commented out the existing GroupId condition check */

        //if ((planid == -1 || $.trim(insuredid) == "" || $.trim(GroupId) == "") && Recorddeleted != 'Y') {
        //    ShowHideErrorMessage('Insurance - Coverage Information - Complete Coverage details', 'true');
        //    return false;
        //}

        if ((planid == -1 || $.trim(insuredid) == "") && Recorddeleted != 'Y') {
            ShowHideErrorMessage('Plan and Insured Id required', 'true');
            return false;
        }

        /* Ends Here #109 */

        var obj=new Object();
        obj.planid=planid;
        obj.insuredid=insuredid;

        var flag=false;
        for (i = 0; i < arr.length; i++ )
        {
            if (arr[i].planid == planid && arr[i].insuredid == insuredid && Recorddeleted != 'Y')
            {
                flag = true;
                break;
            }
        }
        if (flag == false) {
            if (Recorddeleted != 'Y') {
                arr.push(obj);
            }
        }
        else{
            ShowHideErrorMessage('Insurance - Coverage Information - Duplicate Plan with Insured ID not allowed', 'true');
            return false;
        }        
    }
}



function OpenClientSummary() {
    if ($('[id$=TextBox_CustomInquiries_ClientId]').val() != "") {
        var clientId = $('[id$=TextBox_CustomInquiries_ClientId]').val();
        OpenPage(5764, 19, 'ClientId=' + clientId, '2', GetRelativePath());
    }
}



InquiryDetail = {
    PresentingPopulation: '',
    _DateValidatorAge: '',
    SameAsCaller: function(obj) {
        if ($(obj).is(':checked')) {
            $("[id$=TextBox_CustomInquiries_EmergencyContactFirstName]").val($("[id$=TextBox_CustomInquiries_InquirerFirstName]").val());
            $("[id$=TextBox_CustomInquiries_EmergencyContactMiddleName]").val($("[id$=TextBox_CustomInquiries_InquirerMiddleName]").val());
            $("[id$=TextBox_CustomInquiries_EmergencyContactLastName]").val($("[id$=TextBox_CustomInquiries_InquirerLastName]").val());

            // Added By Arjun K R 23/April/2015 Task#52 CHC Environment Issues Tracking.
            $("[id$=TextBox_CustomInquiries_EmergencyContactHomePhone]").val($("[id$=TextBox_CustomInquiries_InquirerPhone").val());

            var InqRelToMeb = $("[id$=DropDownList_CustomInquiries_InquirerRelationToMember] option:selected").val();
            $("[id$=DropDownList_CustomInquiries_EmergencyContactRelationToClient] option").each(function(i) {
                if ($(this).val() == InqRelToMeb) {
                    $(this).attr("selected", "true");
                    $(this).parent().attr("disabled", "disabled");
                }
            });
            $("[id$=TextBox_CustomInquiries_EmergencyContactFirstName]").change();
            $("[id$=TextBox_CustomInquiries_EmergencyContactMiddleName]").change();
            $("[id$=TextBox_CustomInquiries_EmergencyContactLastName]").change();
            $("[id$=TextBox_CustomInquiries_EmergencyContactHomePhone]").change();
            $("[id$=DropDownList_CustomInquiries_EmergencyContactRelationToClient]").change();
            

            // Disable of Emergency Controls
            $("[id$=TextBox_CustomInquiries_EmergencyContactFirstName]").attr("disabled", "disabled");
            $("[id$=TextBox_CustomInquiries_EmergencyContactMiddleName]").attr("disabled", "disabled");
            $("[id$=TextBox_CustomInquiries_EmergencyContactLastName]").attr("disabled", "disabled");
            $("[id$=TextBox_CustomInquiries_EmergencyContactHomePhone]").attr("disabled", "disabled");
        }
        else {
            // Enable of Emergency Controls            
            $("[id$=TextBox_CustomInquiries_EmergencyContactFirstName]").removeAttr("disabled");
            $("[id$=TextBox_CustomInquiries_EmergencyContactMiddleName]").removeAttr("disabled");
            $("[id$=TextBox_CustomInquiries_EmergencyContactLastName]").removeAttr("disabled");
            $("[id$=TextBox_CustomInquiries_EmergencyContactHomePhone]").removeAttr("disabled");
            $("[id$=DropDownList_CustomInquiries_EmergencyContactRelationToClient]").removeAttr("disabled");
        }
    },
    SetDate: function(obj, incflag) {
        var dt = new Date();
        dt.setDate(dt.getDate() - incflag);
        $("[id$=" + obj + "]").val(dt.format("MM/dd/yyyy"));
        $("[id$=" + obj + "]").change();
    },
    SetTime: function(obj) {
        var dt = new Date();
        var time = dt.format("hh:mm tt")
        $("#" + obj).val(time).change();
    },
    ChangeStartDateTime: function() {
      
        var startDateTime = '';
        var startDate = $.trim($("#TextBox_CustomInquiries_InquiryStartDate").val());
        if (startDate == '')
            $("#Text_CustomInquiries_InquiryStartTime").val('');
        var startTime = $.trim($("#Text_CustomInquiries_InquiryStartTime").val());
        if ($.trim($("#TextBox_CustomInquiries_InquiryStartDate").val()) != '') {
            if ($.trim($("#TextBox_CustomInquiries_InquiryStartDate").val()) != '' && $.trim($("#Text_CustomInquiries_InquiryStartTime").val()) != '') {
                startDateTime = $("#TextBox_CustomInquiries_InquiryStartDate").val() + " " + $("#Text_CustomInquiries_InquiryStartTime").val();
            }
            else if ($.trim($("#TextBox_CustomInquiries_InquiryStartDate").val()) != '' && $.trim($("#Text_CustomInquiries_InquiryStartTime").val()) == '') {
                startDateTime = $("#TextBox_CustomInquiries_InquiryStartDate").val();
            }
        }

        $("[id$=HiddenField_CustomInquiries_InquiryStartDateTime]").val(startDateTime);
        $("[id$=HiddenField_CustomInquiries_InquiryStartDateTime]").change();
    },
    ChangeStartDateTimeWithoutAutoSave: function() {
        var t = $("[id$=TextBox_CustomInquiries_InquiryStartDate]").val() + " " + $("[id$=Text_CustomInquiries_InquiryStartTime]").val();
        $("[id$=HiddenField_CustomInquiries_InquiryStartDateTime]").val(t);
        $("[id$=HiddenField_CustomInquiries_InquiryStartDateTime]").change();

    },
    ChangeEndDateTime: function() {
        var endDateTime = '';
        var endDate = $.trim($("#TextBox_CustomInquiries_InquiryEndDate").val());
        if (endDate == '')
            $("#Text_CustomInquiries_InquiryEndTime").val('');
        var endTime = $.trim($("#Text_CustomInquiries_InquiryEndTime").val());
        if ($.trim($("#TextBox_CustomInquiries_InquiryEndDate").val()) != '') {
            if ($.trim($("#TextBox_CustomInquiries_InquiryEndDate").val()) != '' && $.trim($("#Text_CustomInquiries_InquiryEndTime").val()) != '') {
                endDateTime = $("#TextBox_CustomInquiries_InquiryEndDate").val() + " " + $("#Text_CustomInquiries_InquiryEndTime").val();
            }
            else if ($.trim($("#TextBox_CustomInquiries_InquiryEndDate").val()) != '' && $.trim($("#Text_CustomInquiries_InquiryEndTime").val()) == '') {
                endDateTime = $("#TextBox_CustomInquiries_InquiryStartDate").val();
            }
        }

        $("[id$=HiddenField_CustomInquiries_InquiryEndDateTime]").val(endDateTime);
        $("[id$=HiddenField_CustomInquiries_InquiryEndDateTime]").change();
    },
    DateCompare: function(control) {
        if ($("#" + control).length) {
            var strDate = $("#" + control).val();
            //alert("1" + Date.parse((new Date()).format("MM/dd/yyyy")));
            var TDate = (new Date()).format("MM/dd/yyyy");
            if (strDate != '') {
                if ((Date.parse(strDate)) <= (Date.parse(TDate))) {
                    return true;
                }
                else {
                    $("#" + control).focus();
                    return false;
                }
            }
        }
        return true;
    },
    SetPregnant: function(control) {
        var sex = $("[id$=" + control + "]").val();
        if (sex == "M") {
            $("[name=RadioButton_CustomInquiries_Pregnant]").removeAttr('checked').attr('disabled', 'disabled');
            $("[id$=RadioButton_CustomInquiries_Pregnant_NotApplicable]").attr('checked', true).change();
        }
        else {
            $("[name=RadioButton_CustomInquiries_Pregnant]").removeAttr('disabled');
        }
    },
    AccomodationNeeded: function(obj) {
        var ANval = '';
        $("[name$=" + obj + "]").each(function(i) {
            if ($(this).is(':checked')) {
                ANval = ANval + $(this).val() + ",";
            }
        });
        if (ANval.length > 0) {
            ANval = ANval.substring(0, ANval.length - 1);
        }
        $("[id$=HiddenField_CustomInquiries_AccomodationNeeded]").val(ANval);
        $("[id$=HiddenField_CustomInquiries_AccomodationNeeded]").change();
    }
}




//Function used to get Age from date of birth
function GetAge(sender) {
    try {
        var _DateOfBirth = $(sender).val();
        if (_DateOfBirth != "") {
            $.ajax({
                type: "POST",
                url: "../AjaxScript.aspx?functionName=ValidateDOB",
                data: 'DateOfBirthQIReporting=' + _DateOfBirth,
                success: SetAge
            });
        }
        else {
            _DateOfBirth = "";
            $("#Span_CustomInquiries_Age").html('');
        }
    }
    catch (err) {
        LogClientSideException(err, 'CustomRegistrations');
    }
}

//Function used to set age value to control
function SetAge(result) {
    try {
        if (result) {
            var successResult = String(result).split('^');
            if (successResult[0] == "Valid") {
                $('[id$=Span_CustomInquiries_Age]').html('(' + successResult[1] + ' )');
                InquiryDetail._DateValidatorAge = successResult[1];
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'CustomRegistrations');
    }
}

function OpenGuardianInfoPopUp(RelativePath, obj) {
    try {
        
        var isSign = $(obj).val();
        var age;
        var Path = GetRelativePath();
        if (InquiryDetail._DateValidatorAge != '') {
            var InqAge = InquiryDetail._DateValidatorAge.split(' ');
            switch ($.trim(InqAge[1])) {
                case 'Days':
                    if (isSign == 'Y') {
                        var _date = new Date();
                        ShowMsgBox('Client is under 16 years of age. Please specify the Client’s Guardian information on the next screen.', 'InquiryAlert', MessageBoxButton.OK, MessageBoxIcon.Information, "OpenPage(5761, 40022, 'Time=" + _date.getMinutes() + _date.getSeconds() + "',1," + Path + ", 'T', 'dialogHeight:350px; dialogWidth:450px;');");
                    }
                    break;
                case 'Years':
                    age = parseInt($.trim(InqAge[0]));
                    if (isSign == 'Y') {
                        if (age < 16) {
                            var _date = new Date();
                            ShowMsgBox('Client is under 16 years of age. Please specify the Client’s Guardian information on the next screen.', 'InquiryAlert', MessageBoxButton.OK, MessageBoxIcon.Information, " OpenPage(5761, 40022, 'Time=" + _date.getMinutes() + _date.getSeconds() + "',1," + Path + ", 'T', 'dialogHeight:350px; dialogWidth:450px;');");
                        } else if (age == 16 || age == 17) {
                        ShowMsgBox('Is Client Legally Emancipated', 'Confirmation Message', MessageBoxButton.OKCancel, MessageBoxIcon.Question, '', "OpenGuardianOnAnswerNo('" + Path + "')");
                        }
                        else {
                            if (isSign == 'N') {
                            }
                        }
                    }
                    else {
                        var _date = new Date();
                        OpenPage(5761, 40022, "Time=" + _date.getMinutes() + _date.getSeconds(), 1, Path, 'T', "dialogHeight:350px; dialogWidth:450px;");
                    }
                    break;
            }
        }
        else {
            if (isSign == 'N') {
                var _date = new Date();
                OpenPage(5761, 40022, "Time=" + _date.getMinutes() + _date.getSeconds(), 1, Path, 'T', "dialogHeight:350px; dialogWidth:450px;");
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'CustomInquiries');
    }
}

function OpenGuardianOnAnswerNo(RelativePath) {
    
    var _date = new Date();
    OpenPage(5761, 40022, "Time=" + _date.getMinutes() + _date.getSeconds(), 1, RelativePath, 'T', "dialogHeight:350px; dialogWidth:450px;");
}

function ManageToolbarItems() {
    HideToolbarItems('New');
    //Added By Mamta Gupta - Ref Task No. 1738 - Kalamazoo Bugs - Go Live - To show print button on MemberInquiryDetail page.
    ShowToolbarItems('Print');
}

////Created By Sudhir Singh : to check the start date time
function CheckStartDateEndDate() {
    var startDate = '';
    var endDate = '';

    if (!InquiryDetail.DateCompare('TextBox_CustomInquiries_InquiryStartDate')) {
        ShowHideErrorMessage("Start Date cannot be greater than today date.", 'true');
        return false
    }

    if ($.trim($("#TextBox_CustomInquiries_InquiryStartDate").val()) != '') {
        if ($.trim($("#TextBox_CustomInquiries_InquiryStartDate").val()) != '' && $.trim($("#Text_CustomInquiries_InquiryStartTime").val()) != '') {
            startDate = $("#TextBox_CustomInquiries_InquiryStartDate").val() + ", " + $("#Text_CustomInquiries_InquiryStartTime").val().replace(/ /g, '');
        }
        else if ($.trim($("#TextBox_CustomInquiries_InquiryStartDate").val()) != '' && $.trim($("#Text_CustomInquiries_InquiryStartTime").val()) == '') {
            startDate = $("#TextBox_CustomInquiries_InquiryStartDate").val();
        }
    }

    if ($.trim($("#TextBox_CustomInquiries_InquiryEndDate").val()) != '') {
        if ($.trim($("#TextBox_CustomInquiries_InquiryEndDate").val()) != '' && $.trim($("#Text_CustomInquiries_InquiryEndTime").val()) != '') {
            endDate = $("#TextBox_CustomInquiries_InquiryEndDate").val() + ", " + $("#Text_CustomInquiries_InquiryEndTime").val().replace(/ /g, '');
        }
        else if ($.trim($("#TextBox_CustomInquiries_InquiryEndDate").val()) != '' && $.trim($("#Text_CustomInquiries_InquiryEndTime").val()) == '') {
            endDate = $("#TextBox_CustomInquiries_InquiryStartDate").val();
        }
    }
    if (endDate != '') {
        startDate = new Date(startDate);
        endDate = new Date(endDate);
        if (startDate > endDate) {
            ShowHideErrorMessage('Inquiry End Date and End Time must be greater then Inquiry Start Date and Start Time.', 'true');
            return false;
        }
    }
    return true;
}


//Not In use
//Added by himanshu for converting the time format to AM/PM format
function SetTimeFormat(currentTime) {
    var timeArr = currentTime.split(':');
    var hours = timeArr[0];
    var minutes = timeArr[1]; var suffix = "AM";
    if (hours >= 12) {
        suffix = "PM";
        hours = hours - 12;
    }
    if (hours == 0) {
        hours = 12;
    }
    return hours + ":" + minutes + " " + suffix;

}

////Framwork Method don know whiy called commented
function DetailScreenCallbackComplete(objectPageResponse) {
    if (objectPageResponse.ScreenProperties != '') {

        if (objectPageResponse.ScreenProperties.CalledFrom == "NewRegistration") {
            var _clientId = '';
            var _clientName = '';
            _clientId = $('CustomInquiries > ClientId', AutoSaveXMLDom).text();
            _clientName = $('CustomInquiries > MemberLastName', AutoSaveXMLDom).text() + ', ' + $('CustomInquiries > MemberFirstName', AutoSaveXMLDom).text();
            ChangeClient(_clientId, _clientName, GetRelativePath(), 5763, 10500, 2);
        }
        else if (objectPageResponse.ScreenProperties.CalledFrom == "CheckEpisodes") {
            var clientId = $("[id$=TextBox_CustomInquiries_ClientId]").val();
            OpenPage(5763, 10684, 'ClientId=' + clientId, 2, GetRelativePath());
        }
    }
}


function SetFilterParameterValueOnSave() {
    if (Flag == 'New Registration') {
        return 'Flag=New Registration';
    }
    else if (Flag == "CheckEpisodes") {
        return 'Flag=CheckEpisodes';
    }
    else {
        return '';
    }
}

function ShowClientSearchForNewRegistration(relationpath) {
    var filterdata = "";
    relationpath = GetRelativePath();
    if ($("[id$=HiddenField_CustomInquiries_ClientId]").val() == "" || $("[id$=HiddenField_CustomInquiries_ClientId]").val() == "") {
        var firstName = $.xmlDOM(AutoSaveXMLDom[0].xml).find("MemberFirstName").text();
        var lastName = $.xmlDOM(AutoSaveXMLDom[0].xml).find("MemberLastName").text();
         
        $('[id$=HiddenField_CustomInquiries_SSN]').mask("999-99-9999");
        //$('[id$=HiddenField_CustomInquiries_SSN]').change();
        var ssn = $("[id$=HiddenField_CustomInquiries_SSN]").val();
       
        //var firstName = $("[id$=TextBox_CustomInquiries_MemberFirstName]").val();
        //var lastName = $("[id$=TextBox_CustomInquiries_MemberLastName]").val();
        //var ssn = $("[id$=HiddenField_CustomInquiries_SSN]").val();
        var ssnArr = ssn.split('-');
        var ssnFirst = ssnArr[0];
        var ssnSecond = ssnArr[1];
        var ssnThird = ssnArr[2];
        if (ssnSecond == undefined) {
            ssnSecond = "";
        }
        if (ssnThird == undefined) {
            ssnThird = "";
        }
        //var dob = $("input[id$=TextBox_CustomInquiries_DateOfBirth]").val();
        var HiddenField_CustomInquiries_DateOfBirth = $('[id$=HiddenField_CustomInquiries_DateOfBirth]')
        HiddenField_CustomInquiries_DateOfBirth.val(ChangeDateFormat($("[id$=HiddenField_CustomInquiries_DateOfBirth]").val()));
        $("input[id$=TextBox_CustomInquiries_MemberFirstName]").change();
        OpenClientSearchPage(relationpath, 'InquiryDetails', filterdata, '', '', '', 'New Registration', 'ButtonNewRegistration', 'Y', 'N', 'Custom1SendSearchParameterFirstName=' + firstName + '^Custom1SendSearchParameterLastName=' + lastName + '^Custom1SendSearchParameterSSNFirst=' + ssnFirst + '^Custom1SendSearchParameterSSNSecond=' + ssnSecond + '^Custom1SendSearchParameterSSN=' + ssnThird + '^Custom1SendSearchParameterDOB=' + HiddenField_CustomInquiries_DateOfBirth.val(), '0');
    }
    else if ($("[id$=TextBox_CustomInquiries_ClientId]").val() != "" || $("[id$=HiddenField_CustomInquiries_ClientId]").val() != '') {
        var clientId = $("[id$=TextBox_CustomInquiries_ClientId]").val();
        var clientName = $("[id$=TextBox_CustomInquiries_MemberLastName]").val() + ', ' + $("[id$=TextBox_CustomInquiries_MemberFirstName]").val();
        Flag = "New Registration";
        SavePageData();
    }
}

//Added For EEV.
function GetEEScreenData(jsonobj) {
    objData.ScreenId = "10683";
    objData.InsuredLastName = "";
    objData.InsuredFirstName = "";
    objData.ClientId = $("[id$=TextBox_CustomInquiries_ClientId]").val();
    objData.InsuredSSN = $("[id$=TextBox_CustomInquiries_SSN]").val();
    objData.InsuredDOB = "";
    objData.InsuredSex = "";
    objData.ClientRelationshipCode = $("[id$=DropDownList_CustomInquiries_InquirerRelationToMember]").val();
    objData.ClientFirstName = $("[id$=TextBox_CustomInquiries_MemberFirstName]").val();
    objData.ClientLastName = $("[id$=TextBox_CustomInquiries_MemberLastName]").val();
    objData.ClientDOB = $("[id$=TextBox_CustomInquiries_DateOfBirth]").val();
    objData.ClientSex = "";
    objData.DateOfServiceStart = "";
    objData.DateOfServiceEnd = "";
    if (objData.ClientId == "") {
        objData.FillDataUsingSP = "false";
    }
    else {
        objData.FillDataUsingSP = "true";
    }
}

function AddNewCoverageInformation() {
    var Planlength = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InquiriesCoverageInformationId").length;

    if (Planlength > 0) {
        var InquiriesCoverageInformationId = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InquiriesCoverageInformationId")[Planlength - 1].text;
        var planid = GetColumnValueInXMLNodeByKeyValue('CustomInquiriesCoverageInformations', 'InquiriesCoverageInformationId', InquiriesCoverageInformationId, 'CoveragePlanId', AutoSaveXMLDom);
        //$.xmlDOM(AutoSaveXMLDom[0].xml).find("CoveragePlanId")[Planlength - 1].text;
        var insuredid = $.xmlDOM(AutoSaveXMLDom[0].xml).find("InsuredId")[Planlength - 1].text;
        var GroupId = $.xmlDOM(AutoSaveXMLDom[0].xml).find("GroupId")[Planlength - 1].text;        
        var Recorddeleted = GetColumnValueInXMLNodeByKeyValue('CustomInquiriesCoverageInformations', 'InquiriesCoverageInformationId', InquiriesCoverageInformationId, 'RecordDeleted', AutoSaveXMLDom);

        /* New Directions - Support Go Live #109 */
        /* Commented out the existing GroupId condition check */

        //if ((planid == "" || $.trim(insuredid) == "" || $.trim(GroupId) == "") && Recorddeleted !='Y') {
        //    ShowHideErrorMessage('Please complete Coverage Details', 'true');
        //    return false;
        //}

        if ((planid == "" || $.trim(insuredid) == "") && Recorddeleted != 'Y') {
            ShowHideErrorMessage('Plan and Insured Id required', 'true');
            return false;
        }
        /* Ends Here #109 */
    }
    
        var xmlInquiryId = AutoSaveXMLDom.find("CustomInquiries:first InquiryId").text();
        if (_CoverageInfoId == 0) {
            _CoverageInfoId = -1
            emptydata[0].InquiriesCoverageInformationId = -1;
        }
        else {
            _CoverageInfoId = _CoverageInfoId + (-1);
            emptydata[0].InquiriesCoverageInformationId = _CoverageInfoId;
        }
        emptydata[0].InquiryId = xmlInquiryId;

        var _inquiriescoverageinformationid;
        var _inquiryid;
        var _plan;
        var _inquirerid;
        var _groupid;
        var _comments;
        var _createdby;
        var _createddate;
        var _modifiedby;
        var _modifieddate;

        var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomInquiriesCoverageInformations')); //Add Table
        _inquiriescoverageinformationid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('InquiriesCoverageInformationId')); //Add Column
        _inquiriescoverageinformationid.text = _CoverageInfoId;
        _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
        _createdby.text = objectPageResponse.LoggedInUserCode;
        _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
        _createddate.text = ISODateString(new Date());
        _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
        _modifiedby.text = objectPageResponse.LoggedInUserCode;
        _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
        _modifieddate.text = ISODateString(new Date());
        _inquiryid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('InquiryId')); //Add Column
        _inquiryid.text = xmlInquiryId;
        _plan = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CoveragePlanId')); //Add Column
        _plan.text = -1;
        _inquirerid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('InsuredId')); //Add Column
        _inquirerid.text = '';
        _groupid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('GroupId')); //Add Column
        _groupid.text = '';
        //_appointmenttype = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('AppointmentType')); //Add Column
        //_appointmenttype.text = '';
        _comments = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('Comment')); //Add Column
        _comments.text = '';
        AddToUnsavedTables("CustomInquiriesCoverageInformations");
        $.templates('varappointmentHTML',
                  {
                      markup: "#appointmentHTML",
                      allowCode: true
                  });
        var appointmentsobjectivestring = $('[id$=HiddenFieldsPlan]').val();
        emptydata[0].plansdropdownarray = $.parseJSON(appointmentsobjectivestring);

        var htmlText = $.render.varappointmentHTML(emptydata);

        //$("#appointmentContainer").append($('#appointmentHTML').render(emptydata));
        $("#appointmentContainer").append(htmlText);
        CreateUnsavedInstanceOnDatasetChange();
        return true;
    
}

function removeCoverageInfo(obj, InquiriesCoverageInformationId) {
    SetColumnValueInXMLNodeByKeyValue("CustomInquiriesCoverageInformations", "InquiriesCoverageInformationId", InquiriesCoverageInformationId, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomInquiriesCoverageInformations", "InquiriesCoverageInformationId", InquiriesCoverageInformationId, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomInquiriesCoverageInformations", "InquiriesCoverageInformationId", InquiriesCoverageInformationId, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    $(obj).parent().parent().remove();
    CreateUnsavedInstanceOnDatasetChange();
}
function Calculation(id) {
    if ($('#' + id).val() != '' || $('#' + id).val() == null) {
        if (id == 'TextBox_CustomInquiries_IncomeGeneralAnnualIncome') {
            //var value = $("[id$=TextBox_CustomInquiries_IncomeGeneralAnnualIncome]").val().slice(1);
            var value = $("[id$=TextBox_CustomInquiries_IncomeGeneralAnnualIncome]").val().substring(1, $("[id$=TextBox_CustomInquiries_IncomeGeneralAnnualIncome]").val().length)
            value = value.replace(/\,/g, '');
            var annualincome = parseFloat(value / 12);
            annualincome = parseFloat(annualincome).toFixed(3)
            $("[id$=TextBox_CustomInquiries_IncomeGeneralMonthlyIncome]").val('$' + annualincome);
            CreateAutoSaveXml('CustomInquiries', 'IncomeGeneralMonthlyIncome', annualincome);
        }
        else {
            //var value = $("[id$=TextBox_CustomInquiries_IncomeGeneralMonthlyIncome]").val().slice(1);
            var value = $("[id$=TextBox_CustomInquiries_IncomeGeneralMonthlyIncome]").val().substring(1, $("[id$=TextBox_CustomInquiries_IncomeGeneralMonthlyIncome]").val().length)
            value = value.replace(/\,/g, '');
            var monthlyincome = parseFloat(value * 12);
            monthlyincome = parseFloat(monthlyincome).toFixed(3)
            $("[id$=TextBox_CustomInquiries_IncomeGeneralAnnualIncome]").val('$' + monthlyincome);
            CreateAutoSaveXml('CustomInquiries', 'IncomeGeneralAnnualIncome', monthlyincome);
        }
    }
}

function CalculationFee() {
    var income = 0;
    var Type;
    if ($("[id$=TextBox_CustomInquiries_IncomeGeneralAnnualIncome]").val() != "") {
        income = $("[id$=TextBox_CustomInquiries_IncomeGeneralAnnualIncome]").val();
        Type = 'A';
    }
    else if ($("[id$=TextBox_CustomInquiries_IncomeGeneralMonthlyIncome]").val() != "") {
        income = $("[id$=TextBox_CustomInquiries_IncomeGeneralMonthlyIncome]").val();
        Type = 'M';
    }
    else {
        ShowHideErrorMessage('Please enter either Annual Income or Monthly Income', 'true');
        return false;
    }
    $.ajax({
        type: "POST",
        url: "../Custom/InquiryDetails/WebPages/AjaxScript.aspx?functionName=CalculateIncome",
        data: "Income=" + income + '&Type=' + Type,
        async: false,
        success: function (result) {
            var Income = result.split('/');
            if (Type = 'A') {
                $("[id$=TextBox_CustomInquiries_IncomeGeneralMonthlyIncome]").val(Income[1]);
                CreateAutoSaveXml('CustomInquiries', 'IncomeGeneralMonthlyIncome', Income[1]);
            }
            else {
                $("[id$=TextBox_CustomInquiries_IncomeGeneralAnnualIncome]").val(Income[0]);
                CreateAutoSaveXml('CustomInquiries', 'IncomeGeneralAnnualIncome', Income[0]);
            }
           
        }
    });

    // TextBox_CustomInquiries_IncomeGeneralAnnualIncome -- annul income
    //TextBox_CustomInquiries_IncomeGeneralMonthlyIncome -- monthly
}

function CustomInquiriesCoverageInformations(obj, mode, inquiriescoverageinformationid) {
    //if (AutoSaveXMLDom.find("CustomInquiriesCoverageInformations").find('InquiriesCoverageInformationId[text=' + inquiriescoverageinformationid + ']').length == 0) {
    //    addinitialnewcoverage(inquiriescoverageinformationid);
    //}
    if (mode == 'CoveragePlanId') {
        SetColumnValueInXMLNodeByKeyValue("CustomInquiriesCoverageInformations", "InquiriesCoverageInformationId", inquiriescoverageinformationid, "CoveragePlanId", $(obj).val(), AutoSaveXMLDom[0]);
    }
    else if (mode == 'InsuredId') {
        SetColumnValueInXMLNodeByKeyValue("CustomInquiriesCoverageInformations", "InquiriesCoverageInformationId", inquiriescoverageinformationid, "InsuredId", $(obj).val(), AutoSaveXMLDom[0]);
    }
    else if (mode == 'GroupId') {
        SetColumnValueInXMLNodeByKeyValue("CustomInquiriesCoverageInformations", "InquiriesCoverageInformationId", inquiriescoverageinformationid, "GroupId", $(obj).val(), AutoSaveXMLDom[0]);
    }    
    else if (mode == 'Comment') {
        SetColumnValueInXMLNodeByKeyValue("CustomInquiriesCoverageInformations", "InquiriesCoverageInformationId", inquiriescoverageinformationid, "Comment", $(obj).val(), AutoSaveXMLDom[0]);
    }
    SetColumnValueInXMLNodeByKeyValue("CustomInquiriesCoverageInformations", "InquiriesCoverageInformationId", inquiriescoverageinformationid, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
    SetColumnValueInXMLNodeByKeyValue("CustomInquiriesCoverageInformations", "InquiriesCoverageInformationId", inquiriescoverageinformationid, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
    CreateUnsavedInstanceOnDatasetChange();
}

function addinitialnewcoverage(_CoverageInfoId) {
    var xmlDocumentVersionId = AutoSaveXMLDom.find("CustomInquiriesCoverageInformations:first DocumentVersionId").text();

    var _inquiriescoverageinformationid;
    var _inquiryid;
    var _plan;
    var _inquirerid;
    var _groupid;
    var _comments;
    var _createdby;
    var _createddate;
    var _modifiedby;
    var _modifieddate;

    var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomInquiriesCoverageInformations')); //Add Table
    _customstandarddischargesummaryappointmentid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('InquiriesCoverageInformationId')); //Add Column
    _inquiriescoverageinformationid.text = _CoverageInfoId;
    _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
    _createdby.text = objectPageResponse.LoggedInUserCode;
    _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
    _createddate.text = ISODateString(new Date());
    _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
    _modifiedby.text = objectPageResponse.LoggedInUserCode;
    _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
    _modifieddate.text = ISODateString(new Date());
    _inquiryid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('InquiryId')); //Add Column
    _inquiryid.text = xmlDocumentVersionId;
    _plan = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CoveragePlanId')); //Add Column
    _plan.text = '';
    _inquirerid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('InsuredId')); //Add Column
    _inquirerid.text = '';
    _groupid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('GroupId')); //Add Column
    _groupid.text = '';
    //_appointmenttype = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('AppointmentType')); //Add Column
    //_appointmenttype.text = '';
    _comments = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('Comment')); //Add Column
    _comments.text = '';
    AddToUnsavedTables("CustomInquiriesCoverageInformations");
}
var SubReferralType = "";
function BindReferralSubtype(GlobalCodeId) {
    try {
        $.ajax({
            type: "POST",
            url: "../Custom/InquiryDetails/WebPages/AjaxScript.aspx?functionName=GetReferralSubtypeByGlobalCode",
            data: 'GlobalCodeId=' + GlobalCodeId + "&ClientEpisodeId=" + "&ReferralType=" + $("[id$=DropDownList_CustomInquiries_ReferralSubtype]").val(),
            asyn: false,
            success: function (result) {
                UpdateDropDown(result);
                if (SubReferralType) {
                    $('select[id$=DropDownList_CustomInquiries_ReferralSubtype]').val(SubReferralType);
                    CreateAutoSaveXml('CustomInquiries', 'ReferralSubtype', SubReferralType);
                    SubReferralType = "";
                }
            }
        });
    }
    catch (err) {
        LogClientSideException(err, 'CustomInquiries-BindReferralSubtype');
    }
}


function SaveReferralSubtype() {
    try {
        var ReferralSubType = $('select[id$=DropDownList_CustomInquiries_ReferralSubtype]').val();
        CreateAutoSaveXml('CustomInquiries', 'ReferralSubtype', SubReferralType);
    }
    catch (err) {
        LogClientSideException(err, 'CustomInquiries-BindReferralSubtype');
    }
}

//bind Referal subtype based on referal type
function UpdateDropDown(result) {
    $("[id$=DropDownList_CustomInquiries_ReferralSubtype]").html("");
    if (result != null || result != '') {
        if (result.xml != null || result.xml != '') {
            $.xmlDOM(result.xml).find("ClientServicesView").each(function () {
                $("<option value=" + this.childNodes[1].text + ">" + this.childNodes[0].text + "</option>").appendTo("[id$=DropDownList_CustomInquiries_ReferralSubtype]");
            });
            if (!$('select[id$=DropDownList_CustomInquiries_ReferralSubtype]').val()) {
                CreateAutoSaveXml('CustomInquiries', 'ReferralSubtype', '');
            }
            else {
                CreateAutoSaveXml('CustomInquiries', 'ReferralSubtype', $('select[id$=DropDownList_CustomInquiries_ReferralSubtype]').val());
            }
        }
    }
}

