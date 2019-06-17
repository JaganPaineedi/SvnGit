//Author Davinder Kumar
//Date 29/06/2011
//For Cafas Tab

function GotoOnlineCafas() {
    //Modified by Damanpreet Kaur
    PopupProcessing();
    $.ajax({
        type: "POST",
        url: "../AjaxScript.aspx?functionName=GotoOnlineCafas",
        success: function onSuccessGotoOnlineCafas(result) {
            HidePopupProcessing();
            var val = result.split('=');
            if (val[0] == "ErrorMassage") {
                ShowMsgBox(val[1], "Error", MessageBoxButton.OK, MessageBoxIcon.Information);
            }
            else if (val[0] == "Key") {
                window.open(CafasUrl + "Login.aspx?InteropRequestKey=" + val[1] + "=" + val[2]);
            }
        }
    });
}




//Description:Calculate youth CAFAS score.
//Author:Daman
//CreatedOn:20-May-2010

function CalCulateCafasScore(TextBoxid, NeedId, DescriptionTextBox) {
    // Added by sonia -- add (condition ParentUserControlName != "DischargeTabPage_C4") with ref #976 in SC Web Production. To check Parent control(Discharge Summary and Assesment Tab).
    if (TextBoxid != null) {

        // Check first TextBoxid.value != ""  Added By Rakesh Garg  with Ref. Ticket 906 in SCWeb Streamline testing
        if ((TextBoxid.value != "") && (TextBoxid.value == 0 || TextBoxid.value == 10 || TextBoxid.value == 20 || TextBoxid.value == 30)) {
            if (ParentUserControlName != "DischargeTabPage_C4") {
                CafasNeedList(TextBoxid, NeedId, DescriptionTextBox);
            }

        }
        else {
            TextBoxid.value = 0;
            var id = TextBoxid.id;
            $(id).change();


        }
        //Commented with ref to task#199(Sc Web PhaseII)
        //        else {
        //            if (TextBoxid.value != "") {
        //                if (parseInt(TextBoxid.value, 10) > 10) {
        //                    TextBoxid.value = 0;
        //                    var id = TextBoxid.id;
        //                    $(id).change();
        //                }
        //            }
        //            else {
        //                TextBoxid.value = 0;
        //                var id = TextBoxid.id;
        //                $(id).change();

        //            }
        //        }
        var cafasScore = 0;
        cafasScore = (parseInt($('#TextBox_CustomCAFAS2_SchoolPerformance').val()) + parseInt($('#TextBox_CustomCAFAS2_HomePerformance').val()) +
parseInt($('#TextBox_CustomCAFAS2_CommunityPerformance').val()) + parseInt($('#TextBox_CustomCAFAS2_BehaviorTowardsOther').val()) +
parseInt($('#TextBox_CustomCAFAS2_MoodsEmotion').val()) + parseInt($('#TextBox_CustomCAFAS2_SelfHarmfulBehavior').val()) +
parseInt($('#TextBox_CustomCAFAS2_SubstanceUse').val()) + parseInt($('#TextBox_CustomCAFAS2_Thinkng').val()));

        ($('#TextBox_CustomCAFAS2_YouthTotalScore').val(cafasScore))
        UpdateAutoSaveXmlNode('CustomCAFAS2', 'YouthTotalScore', cafasScore);
    }
}
//Function added with reference to ticket #687
function CafasNeedList(TextBoxid, AssociatedHrmNeedId, DescriptionTextBox) {

    //var needDesc = $("#" + DescriptionTextBox).val().trim();
    //var CafasScore = TextBoxid.value;
    //if (CafasScore == undefined) {
    //    CafasScore = $("#" + TextBoxid).val().trim();
    //}
    //if (CafasScore >= 20) {
    //    var xmlNeed = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentNeeds");

    //    if (xmlNeed.length > 0) {
    //        var CustomHRMAssessmentNeedId = $("CustomHRMAssessmentNeeds HRMNeedId[text=" + AssociatedHrmNeedId + "]", AutoSaveXMLDom[0]).parent().find("HRMAssessmentNeedId").text();
    //        var CustomRecordDeleted = $("CustomHRMAssessmentNeeds HRMNeedId[text=" + AssociatedHrmNeedId + "]", AutoSaveXMLDom[0]).parent().find("RecordDeleted").text();
    //        if (CustomHRMAssessmentNeedId != "") {
    //        }
    //        else {
    //            HRMNeedList(AssociatedHrmNeedId, "", "CAFAS", "", needDesc);
    //        }
    //        if (CustomHRMAssessmentNeedId != "" && CustomRecordDeleted == 'Y') {
    //            CustomSetColumnValueInXMLNodeByKeyValue('CustomHRMAssessmentNeeds', 'HRMAssessmentNeedId', CustomHRMAssessmentNeedId, 'RecordDeleted', 'N', AutoSaveXMLDom[0], 'Y');
    //            HRMNeedList(AssociatedHrmNeedId, "", "CAFAS", "", needDesc);
    //        }
    //        else {
    //            HRMNeedList(AssociatedHrmNeedId, "", "CAFAS", "", needDesc);

    //        }
    //    }
    //    else {
    //        HRMNeedList(AssociatedHrmNeedId, "", "CAFAS", "", needDesc);
    //    }
    //}
    //if (CafasScore < 20) {
    //    var xmlNeed = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomHRMAssessmentNeeds");

    //    if (xmlNeed.length > 0) {
    //        var CustomHRMAssessmentNeedId = $("CustomHRMAssessmentNeeds HRMNeedId[text=" + AssociatedHrmNeedId + "]", AutoSaveXMLDom[0]).parent().find("HRMAssessmentNeedId").text();
    //        if (CustomHRMAssessmentNeedId != "") {
    //            DeleteNeedListFromXmlBasedOnHrmNeedId(AssociatedHrmNeedId, AutoSaveXMLDom);

    //        }
    //    }
    //}
}
function GetCafasUrl(dom) {
    var xmlCustomConfigurationsRow = dom[0].childNodes[0].selectNodes("CustomHRMAssessments");
    // Added by sonia with ref #976 (SC Web Production). To Handle error when xmlCustomConfigurationsRow length is 0
    if (xmlCustomConfigurationsRow.length > 0) {
        if (xmlCustomConfigurationsRow[0].selectNodes("CafasURL").length > 0) {
            CafasUrl = xmlCustomConfigurationsRow[0].selectNodes("CafasURL")[0].text.trim();
        }
    }
    else {//This else part is written by Pradeep as per task#468
        xmlCustomConfigurationsRow = dom[0].childNodes[0].selectNodes("CustomLOFTabDetails");
        if (xmlCustomConfigurationsRow.length > 0) {
            if (xmlCustomConfigurationsRow[0].selectNodes("CafasURL").length > 0) {
                CafasUrl = xmlCustomConfigurationsRow[0].selectNodes("CafasURL")[0].text.trim();
            }

        }
    }
}
// Added By Mahesh on 13-Oct-2010 to send the Dom Xml and DocumentVersionID to the ServerSide

function ImportCafasScores() {

    if (DocumentVersionId == undefined || DocumentVersionId <= 0) {
        ShowMsgBox("Please save the Document before importing the CAFAS scores.", "Document not Saved", MessageBoxButton.OK, MessageBoxIcon.Information);

        return;
    }
    ShowMsgBox("Previous Cafas scores will be overridden. Do you want to continue?", "Cafas Assessment", MessageBoxButton.YesNo, MessageBoxIcon.Information, "FasProcessSaveRequest()", "FasProcessUnsaveRequest()", "FasProcessUnsaveRequest()", undefined, undefined, true);
}

function FasProcessSaveRequest() {
    ProcessFasServicesRequest();
}

function FasProcessUnsaveRequest() {
    return;
}

//Created By Mahesh
//We send the Dom Xml along with the DocumentVersionID as data. This method calls the server side coding to 
// Request,receive response and finally process the Xml data received from the Fas Services.
function ProcessFasServicesRequest() {
    parent.PopupProcessing();
    var XmlData = AutoSaveXMLDom[0].xml;
    var DocumentID = DocumentVersionId;
    $.ajax({
    type: "POST",
    //Remove encodeText from  DocumentVersionId w.rf to task 402 in Kalamazoo bugs & Use GetRelativePath() path method for ajax call 
        url: GetRelativePath() + "AjaxScript.aspx?FunctionName=ProcessFasServiceRequest",
        data: 'DocumentVersionID=' + DocumentVersionId + '&xmlString=' + encodeText(XmlData),
        success: function(responseData) {
            XmlResponse = responseData;
            var Response = responseData.split("^#^");

            if (Response[1] != "") {
                HidePopupProcessing();
                ShowMsgBox(Response[1], "Fas Services", MessageBoxButton.OK, MessageBoxIcon.Information);
            }
            else {
                FasServicesCallBack(Response[0]);
                HidePopupProcessing();
                ShowMsgBox("Cafas Data Imported Successfully.", "Fas Services", MessageBoxButton.OK, MessageBoxIcon.Information);
            }
        },
        Error: function(msgs) {

            ShowMsgBox(msgs, "Fas Services", MessageBoxButton.OK, MessageBoxIcon.Information);
        }

    });
    HideMessageBoxWindow();
    parent.PopupProcessing();

}
function CAFASAutoSave(senderId) {
    var controlObject = $("#" + senderId);
    if (controlObject.length >= 1) {
        SaveAutoSaveXMLDom(controlObject[0]);
    }
}