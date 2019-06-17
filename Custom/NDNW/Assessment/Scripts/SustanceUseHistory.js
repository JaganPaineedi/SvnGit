
//Author: Pradeep
//Description: This function is used to Open the AxisV Legends Popup and Get the Value in AxisV TextBox.
function OpenSustanceUseHistoryPopUp(obj, baseUrl) {
  
        returnValue = window.showModalDialog(baseUrl + "SubstanceUseHistoryPopUp.aspx?TextVal=" + obj.value + "", "null", "status:no;edge:center:yes;sunken;resizable:no;dialogWidth:850px;dialogHeight:500px");
        parseInt(returnValue)

    }

    function CheckNumeric(Textbox) {

        var EnteredValue = document.getElementById(Textbox).value;
        var TestValue = EnteredValue.replace(" ", "");
        if (isNaN(TestValue)) {
            //return EnteredValue;
            document.getElementById(Textbox).value = '';  // User must have entered a keyword 
        }
        else {
            // return TestValue;
            document.getElementById(Textbox).value = TestValue;        // Prodict code minus all spaces 
        }

    }
    //----Followings are need to be converted in J query
    function validateInt(TextBox) {
        var o = document.getElementById(TextBox);
        switch (isInteger(o.value)) {
            case true:
                document.getElementById(TextBox).value = o.value;
                break;
            case false:
                document.getElementById(TextBox).value = '';
        }
    }
    //----Followings are need to be converted in J query
    function isInteger(s) {
        var i;

        if (isEmpty(s))
            if (isInteger.arguments.length == 1) return 0;
        else return (isInteger.arguments[1] == true);

        for (i = 0; i < s.length; i++) {
            var c = s.charAt(i);

            if (!isDigit(c)) return false;
        }

        return true;
    }
    //----Followings are need to be converted in J query
    function isEmpty(s) {
        return ((s == null) || (s.length == 0))
    }

    function isDigit(c) {
        return ((c >= "0") && (c <= "9"))
    }
    //Description:Use to insert data in grid
    //Author:Pradeep
    //CreatedOn:Oct14,2009
    function UpdateSubstanceUseHistory(PageType, InsertButton, DropDownSubstance, TextBoxAgeOfFirstUse, TextBoxMethod, TextBoxLastUsed, CheckBoxPreferred, HiddenFieldSubstanceUseHistoryId) {

        try {
            var queryString = "";
            var dropDownSubstance = document.getElementById(DropDownSubstance);
            var dropDownSubstanceSelectedValue = dropDownSubstance.options[dropDownSubstance.selectedIndex].value;
            var textBoxAgeOfFirstUse = document.getElementById(TextBoxAgeOfFirstUse);
            var textBoxMethod = document.getElementById(TextBoxMethod);
            var textBoxLastUsed = document.getElementById(TextBoxLastUsed);
            var checkBoxPreferred = document.getElementById(CheckBoxPreferred);
            var checkBoxValue;
            if (checkBoxPreferred.checked) {
                checkBoxValue = "Y"
            }
            else {
                checkBoxValue = "N";
            }
            var hiddenFieldSubstanceUseHistoryId = document.getElementById(HiddenFieldSubstanceUseHistoryId);

            if (hiddenFieldSubstanceUseHistoryId.value == "") // Insert
            {
                if (PageType == 'SUH') {

                    RequestUrlValue = "AjaxSubstanceUseHistory.aspx";
                    queryString = "fun=insert&page=SUH&Substance=" + dropDownSubstanceSelectedValue + "&AgeOfFirstUse=" + encodeText(textBoxAgeOfFirstUse.value) + "&Method=" + encodeText(textBoxMethod.value) + "&LastUsed=" + encodeText(textBoxLastUsed.value) + +"&checkBoxValue=" + checkBoxValue + "&HidSUHId=" + hiddenFieldSubstanceUseHistoryId;
                }
            }
           
           
            CreateXmlHttp();
            if (HealthAnalysisType == 'FHH') {
                CallAjaxHA('RenderFamilyHealthHistoryGrid', queryString);
            }

            //If record is to be inserted only then scroll the div bar to bottom
            if (InsertButton.value == "Insert") {
                ScrollDivToBottom('DivFamilyHealthHistory');
            }

            dropDownSubstance.selectedIndex =0;
            textBoxAgeOfFirstUse.value = "";
            textBoxMethod.value = "";
            textBoxLastUsed.value = "";
            checkBoxPreferred.value = "";
            InsertButton.value = "Insert";
            hiddenFieldSubstanceUseHistoryId.value = "";
        }
        catch (Ex) {
            alert(Ex)
        }
        return false;
    }
   
    function FillSustanceUseHistoryGrid(baseUrl) {
         try{
             //var dropDownSubstance = $("[id$=DropDownList_CustomSubstanceUseHistory_Substance]");
             var dropDownSubstance = $("[id$=DropDownList_CustomSubstanceUseHistory_Substance]").val(); 
             var textBoxAgeOfFirstUse = $("[id$=TextBox_CustomSubstanceUseHistory_AgeOfFirstUse]");
             var textBoxMethod = $("[id$=TextBox_CustomSubstanceUseHistory_Method]");
             var textBoxLastUsed = $("[id$=TextBox_CustomSubstanceUseHistory_LastUsed]");
             var checkBoxPreferred = $("[id$=CheckBox_CustomSubstanceUseHistory_Preferred]");
             var checkBoxPreferedValue;
             if ($("[id$=CheckBox_CustomSubstanceUseHistory_Preferred]").is(':checked')) {
                 checkBoxPreferedValue = "Y";
             }
             else
              {
                  checkBoxPreferedValue = "N";
              }
              var substanceUseHistoryId = $("[id$=HiddenFieldSubstanceUseHistoryId]")[0].value;
              $.post(baseUrl + "AjaxSubstanceUseHistory.aspx?", 'action=insert&Substance=' + dropDownSubstance + '&AgeOfFirstUse=' + textBoxAgeOfFirstUse[0].value + '&Method=' + textBoxMethod[0].value + '&LastUsed=' + textBoxLastUsed[0].value + '&Preferred=' + checkBoxPreferedValue + '&substanceUseHistoryId=' + substanceUseHistoryId, OnSubstanceUseHistoryGridSuccess);   //InterventionProceduerProvider   
            // var checkBoxPreferredValue = checkBoxPreferred[0].vaue; 
         }
         catch(ex)
         {
             alert('SubstanceUseHistory---FillSustanceUseHistoryGrid()-'+ex);
         }
     }
     function OnSubstanceUseHistoryGridSuccess(result) {
         var pageResponse = result;
         var start = pageResponse.substring(pageResponse.indexOf('###STARTCTR###') + 14);
         var end = pageResponse.indexOf('###ENDCTR###');
         pageResponse = pageResponse.substr(start, end - start);
         if (pageResponse != undefined) {
             $("#DivSustanceUseHistory")[0].outerHTML = pageResponse;
         }
   }
    