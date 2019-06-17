var AllergySearch = {
    objectAllergyId: "", radioSelected: "", rowobject: "", SelectedRowNumber: "",
    EnablesDisable: function() {
        try {
            radioSelected = document.getElementById('HiddenRadioSelectedObject').value;
            rowobject = document.getElementById('HiddenRadioObject').value;
            SelectedRowNumber = document.getElementById('HiddenSelectedRowNumber').value;
            objectAllergyId = document.getElementById('HiddenAllergyId');
            if (objectAllergyId.value == null || objectAllergyId.value == "")
                document.getElementById('btnSelect').disabled = true;
            document.getElementById('DivGridViewAllergies').scrollTop = ((document.getElementById('DivGridViewAllergies').scrollTop + 1) * 16 * SelectedRowNumber) + 8;

            //Changes by sonia
            //Ref Task 115 New Order: Wrong alert message on Radio button selection 
            if (SelectedRowNumber == '') {
                if (document.getElementById('DataGridAllergies_ctl02_RadioSelect') != undefined) {
                    document.getElementById('DataGridAllergies_ctl02_RadioSelect').focus();
                    radioSelected = "DataGridAllergies_ctl02_RadioSelect";
                    rowobject = "DataGridAllergies_ctl02";
                }
            }
            //changes end over here
            //DataGridAllergies_ctl03_RadioSelect.focus();

            //(SelectedRowNumber*13);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    },
    //--------Modification History--------
    //--Date------Author----Purpose--------
    //27 Oct 2009 Pradeep   Adding one more parameter ,AllergyType  as per task#9(Venture)
    //added one parameter comments in ref to Task#86 
    closeDiv: function (flag, returnValue, AllergyType, comments, active, AllergyReaction, AllergySeverity) {
        try {
            var DivSearch = parent.document.getElementById('DivSearch');
            DivSearch.style.display = 'none';
            parent.window.SaveAllergyData(flag, returnValue, AllergyType, comments, active, AllergyReaction, AllergySeverity);
            parent.window.MakeAlertCheckRequest();
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    },
    //Added by Sonia to control key press events
    fnSelect: function(radioSelect, DataGridAllergies) {
        try {
            var tblGrid = document.getElementById(DataGridAllergies);
            AllergySearch.deSelectAll();
            radioSelect.checked = true;
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    },
    returnOnClick: function(radioSelect, DataGridAllergies, Key) {
        try {
            objectAllergyId = document.getElementById('HiddenAllergyId');
            objectAllergyId.value = Key;
            var tblGrid = document.getElementById(DataGridAllergies);
            AllergySearch.deSelectAll();
            document.getElementById(radioSelect).checked = true;
            document.getElementById('btnSelect').disabled = false;
            AllergySearch.fnReturnValues();
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    deSelectAll: function() {
        try {
            var objRadios = document.getElementsByTagName("input");
            for (var i = 0; i < objRadios.length; i++) {
                if (objRadios[i].type == "radio") {
                    objRadios[i].checked = false;
                }
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }



    },
    fnGetSelected: function(event, radioSelect) {
        try {
            if (event.keyCode == 13) {

                var returnValues = radioSelect.parentNode.parentNode.childNodes[1].innerText;
                objectAllergyId = document.getElementById('HiddenAllergyId');
                objectAllergyId.value = returnValues;
                document.getElementById('btnSelect').disabled = false;

                AllergySearch.closeDiv(true, returnValues);
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    fnReturnValues: function() {
        try {
            var string;
            objectAllergyId = document.getElementById('HiddenAllergyId');
            Key = objectAllergyId.value;
            //----Start modification By Pradeep---
            var AllergyType;
            // var RadioButtonList=document.getElementById('<%=RadioButtonListAllergyType.ClientID %>')
            var radio = document.getElementsByName('RadioButtonListAllergyType');
            for (var j = 0; j < radio.length; j++) {
                if (radio[j].checked)
                    AllergyType = radio[j].value;
            }
            //Code added by Loveena in ref to Task#86 to save Comments next to allergy type
            var comments = $("[id$=TextBoxComments]").val();

            //Added By Arjun Kr #49 Meaningfulluse Stage 3

            var AllergyReaction = $("[id$=DropDownListAllergyReaction]").val() == null || $("[id$=DropDownListAllergyReaction]").val() == undefined ? -1 : $("[id$=DropDownListAllergyReaction]").val();
            var AllergySeverity = $("[id$=DropDownListAllergySeverity]").val() == null || $("[id$=DropDownListAllergySeverity]").val() == undefined ? -1 : $("[id$=DropDownListAllergySeverity]").val();

            
            //---End modification By Pradeep---  
            var active = $("[id$=CheckBoxAllergyActive]")[0].checked == true ? 'Y' : 'N';
            document.getElementById('btnSelect').disabled = false;
            //Start Modification----By Pradeep---
            //Parameter added by Loveena in ref to Task#86
            if (Key != "")
                AllergySearch.closeDiv(true, Key, AllergyType, comments, active, AllergyReaction, AllergySeverity);

            //EndModification----By Pradeep---
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    //Added by Loveena in ref to Task#86 to Edit Comments
    OpenComment: function(ClientAllergyId, AllergyType) {
        try {
            var DivSearch = parent.document.getElementById('DivSearch');
            DivSearch.style.display = 'block';
            var iFrameSearch = parent.document.getElementById('iFrameSearch');
            iFrameSearch.contentWindow.document.body.innerHTML = "<div></div>";            
            iFrameSearch.src = 'AllergyComment.aspx?ClientAllergyId=' + ClientAllergyId + '&AllergyType=' + AllergyType;
            iFrameSearch.style.positions = 'absolute';
            iFrameSearch.style.left = (($(window).width() - 500) / 2) + "px"; //'280px';
            iFrameSearch.style.width = '400px';
            iFrameSearch.style.height = '240px';
            iFrameSearch.style.top = (($(window).height() - 400) / 2) + "px"; // '80px';
            iFrameSearch.style.scrollbars = 'yes';
            iFrameSearch.style.display = 'block';
            fnHideParentDiv();
        }
        catch (ex) {
        }
    },
    OpenCommentDetails: function(ClientAllergyId, allergyType, active, comments, filterlist) {
        try {
            var $divSearch = $("#DivSearch");
            $("#topborder", $divSearch).text("Allergies / Intolerance / Failed Trials Details");
            var $iFrameSearch = $('#iFrameSearch', $divSearch);
            $iFrameSearch.attr('src', 'AllergyComment.aspx?ClientAllergyId=' + ClientAllergyId + '&AllergyType=' + allergyType + '&Active=' + active + '&Comments=' + encodeURIComponent(comments) + '&FilterList=' + filterlist);
            $iFrameSearch.css({ 'width': '400px', 'height': '180px' });
            var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
            left = left > 0 ? left : 10;
            var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
            top = top > 0 ? top : 10;
            $divSearch.css({ 'top': top, 'left': left });
            $divSearch.draggable();
            $divSearch.css('display', 'block');
            fnHideParentDiv();
        }
        catch (ex) {
        }
    },
    ChangeColor: function(objRow, Gridview, radio, Key) {

        try {


            objectAllergyId = document.getElementById('HiddenAllergyId');
            objectAllergyId.value = Key;
            document.getElementById('btnSelect').disabled = false;

            if (radioSelected == radio) {
                //Changes by sonia
                //Ref Task 115 New Order: Wrong alert message on Radio button selection 
                document.getElementById(objRow).runtimeStyle.backgroundColor = "#6D71FC";
                document.getElementById(objRow).runtimeStyle.color = "White";
                document.getElementById(objRow).focus();
                document.getElementById(radio).checked = true;
                return;
                //changes end over here
            }

            document.getElementById(objRow).runtimeStyle.backgroundColor = "#6D71FC";
            document.getElementById(objRow).runtimeStyle.color = "White";
            document.getElementById(objRow).focus();

            if (radioSelected != undefined && radioSelected != "") {

                document.getElementById(radioSelected).checked = false;
                document.getElementById(rowobject).runtimeStyle.backgroundColor = "White";
                document.getElementById(rowobject).runtimeStyle.color = "Black";
                document.getElementById(radio).checked = true;
                radioSelected = radio;
                rowobject = objRow;
            }
            else {
                document.getElementById(radio).checked = true;
                radioSelected = radio;
                rowobject = objRow;
            }
        }
        catch (e) {
            //Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    SelectOnChange: function(Gridview, Key) {
        var row;
        var i;
        var objrow;
        var selectRadio;
        var SelectedRowKeyValue;
        try {
            //if user has press enter key then calling AllergySearch.fnReturnValues function that will return value to calling page

            //Changes by sonia
            //Ref Task 115 New Order: Wrong alert message on Radio button selection 
            if (event.keyCode == 13) {
                AllergySearch.fnReturnValues();
                return false;
            }
            //changes end over here
            objectAllergyId = document.getElementById('HiddenAllergyId');
            objectAllergyId.value = Key;
            document.getElementById('btnSelect').disabled = false;


            if (radioSelected != undefined && radioSelected != "") {

                Radio = radioSelected.split("_");
            }
            else
                return true;
            //these code will find row number 
            i = Radio[1].substring(3, Radio[1].length)
            if (i > 9) {
                row = parseInt(i);
                row = row + 1;

            }
            else {

                row = i.substring(1, i.length);
                row = parseInt(row) + 1;

            }
            if (event.keyCode == 38) {
                row = row - 2;


            }
            if ((row == 1) || (row > document.getElementById(Gridview).rows.length - 1)) {
                //return ;
                row = "0" + row - 1;
            }

            if (row <= 9) {

                row = "0" + row;

            }
            if (row == "00")
                return;

            objrow = "DataGridAllergies_ctl" + row
            selectRadio = "DataGridAllergies_ctl" + row + "_RadioSelect"

            SelectedRowKeyValue = document.getElementById("DataGridAllergies_ctl" + row + "_lblAllergenConceptId").innerHTML;

            //Changes by sonia
            //Ref Task 115 New Order: Wrong alert message on Radio button selection           
            AllergySearch.ChangeColor(objrow, Gridview, selectRadio, SelectedRowKeyValue);
            //changes end over here
            //if user hase enter up arror then setting scroll position
            if (event.keyCode == 40) {
                document.getElementById('DivGridViewAllergies').scrollTop = document.getElementById('DivGridViewAllergies').scrollTop + 13;

            }
            //if user hase enter down arror then setting scroll position
            else if (event.keyCode == 38) {
                document.getElementById('DivGridViewAllergies').scrollTop = document.getElementById('DivGridViewAllergies').scrollTop - 13;

            }

            else //if user has press othere than these key
            {
                return;
            }

        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    onSucceeded: function(result) {
        try {
            alert(result);
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    },
    //Added by Loveena in ref to Task#86
    SaveAllergyComments: function(AllergyId, AllergyType, AllergyActive, Comments, FilterList) {
        try {
            var context = new Object();
            context = parent.$("[id=DIVAllergiesList]")[0];
            Streamline.SmartClient.WebServices.ClientMedications.SaveComments(AllergyId, AllergyType, AllergyActive, Comments, FilterList, AllergySearch.onSuccessfullSaveComments, AllergySearch.onFailure, context);
        }
        catch (ex) {
        }
    },
    onSuccessfullSaveComments: function(result, context, methodname) {
        try {
            var _height = context.clientHeight + "px";
            context.innerHTML = "";
            context.innerHTML = result;
            parent.$("#DivSearch").css('display', 'none');
            AllergySearch.GetNoKnownAllergyFlag("CheckBoxNoKnownAllergies", "");
            try {
                if (parent.window.opener != undefined && parent.window.opener.RefreshTabPageContentFromExternalScreens != undefined) {
                    var response = $("#allergyresultresponse", context).val() || "";
                    parent.window.opener.RefreshTabPageContentFromExternalScreens(response, '');
                }
            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
        } catch (Err) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, Err);
        }
        finally {
        }

    },
    /// <summary>
    /// Author Rishu Chopra
    /// It is called when  error occurs.
    /// </summary>       
    onFailure: function(error) {
        fnHideParentDiv(); //By Vikas Vyas On Dated April 04th 2008
        if (error.get_message() == "Session Expired" || error.get_message() == "There was an error processing the request.") {
            location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
        else {
            alert(error.get_message());
        }
    },
    GetNoKnownAllergyFlag: function(ID, CheckboxFlag) {
        try {
            Streamline.SmartClient.WebServices.ClientMedications.GetNoKnownAllergyFlag(CheckboxFlag, function(result) {
                var obj = $("#" + ID);
                if (obj.length == 0) { obj = parent.$("#" + ID); }
                if (result.toString().toLowerCase() == "true") {
                    obj[0].checked = true;
                } else {
                    obj[0].checked = false;
                }
            }, AllergySearch.onFailure);
            //Vithobha Added below code to send A08 message,Philhaven Development: #376 HL7
            if (CheckboxFlag == "Y" || CheckboxFlag == "N")
            {
                Streamline.SmartClient.WebServices.ClientMedications.UpdateClientAllergyforHL7();
            }
        }
        catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    }
}