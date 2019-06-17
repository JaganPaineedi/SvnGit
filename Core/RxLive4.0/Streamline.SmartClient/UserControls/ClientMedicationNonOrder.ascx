<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ClientMedicationNonOrder.ascx.cs"
    Inherits="Streamline.SmartClient.UI.UserControls_ClientMedicationNonOrder" %>
<%@ Import Namespace="Streamline.BaseLayer" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>
<%@ Register TagPrefix="UI" TagName="MedicationClientPersonalInformation" Src="~/UserControls/MedicationClientPersonalInformation.ascx" %>
<asp:ScriptManagerProxy runat="server" ID="SMP1">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/ClientMedicationNonOrder.js?rel=3_5_x_4_1"
            NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationClientPersonalInformation.js?rel=3_5_x_4_1"
            NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<style type="text/css">
    .ComboBoxDrugDDImage {
        background-image: url('<%= RelativePath %>App_Themes/Includes/Images/dropdowncbo.jpg');
        background-position: right;
        background-repeat: no-repeat;
        vertical-align: middle;
    }

    .ComboBoxDrugDDImage::-ms-clear {
        display: none;
        height: 0;
        width: 0;
    }
</style>

<script language="javascript" type="text/javascript">

    function pageLoad() {
        if ('<%= NonOrderMedicationResult %>' != "") {
            try {
                if (parent.window.opener && parent.window.opener.RefreshTabPageContentFromExternalScreens != undefined) {
                    parent.window.opener.RefreshTabPageContentFromExternalScreens('<%= NonOrderMedicationResult %>', '');
                }
            } catch(e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
        }
        FillAllergyControlofClientInformation('N'); //Fill the MedicationClientPersonalInformation Control added by rohit ref ticket #80
        ShowEditPreferredPharmacy('N'); //Hide PreferredPharmacyEdit Button added by Loveena in ref to task#92
        $("[id$=HiddenInsertClick]").val('');
        var DxPurpose = document.getElementById('<%= DropDownListDxPurpose.ClientID %>');
        var Prescriber = document.getElementById('<%= DropDownListPrescriber.ClientID %>');
        LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        LabelGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage');
        ClientMedicationNonOrder.FillDxPurpose(DxPurpose);
        ClientMedicationNonOrder.FillPrescriber(Prescriber);
        FillRXSource(document.getElementById('<%= DropDownListRXSource.ClientID %>'));
        $("#ComboBoxDrugDD").keydown(function(event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                return false;
            }
        });
        ClientMedicationNonOrder.GetMedicationList('<%= PanelMedicationListInformation.ClientID %>');
        PanelMedicationListNonOrder = '<%= PanelMedicationListInformation.ClientID %>';
        InitializeComponents();
        ClientMedicationNonOrder.ClearDrug('<%= TextBoxStartDate.ClientID %>', '<%= TextBoxDrug.ClientID %>', '<%= TextBoxSpecialInstructions.ClientID %>', '<%= DropDownListDxPurpose.ClientID %>', '<%= DropDownListPrescriber.ClientID %>', '<%= LabelErrorMessage.ClientID %>', '<%= TextBoxDesiredOutcome.ClientID %>', '<%= TextBoxComments.ClientID %>');
        document.getElementById('<%= CheckBoxDispense.ClientID %>').checked = false;
        document.getElementById('<%= CheckBoxOffLabel.ClientID %>').checked = false;
        ClientMedicationNonOrder.ClearTable('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
        $create(Streamline.SmartClient.UI.TextBox, { 'ignoreEnterKey': true }, {}, {}, $get('<%= TextBoxSpecialInstructions.ClientID %>'));
    }

    //Code added by Loveena in ref to Task#86 to fill Drug Dropdown

    function FillDrug(MedicationNameId, MedicationName) {
        try {
            ClientMedicationNonOrder.FillDrugDropDown(MedicationNameId, MedicationName);
        } catch(ex) {
        }
    }

    function NotAcknowledge() {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        DivErrorMessage.style.display = 'block';
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        LabelErrorMessage.innerText = 'Please acknowledge the drug interactions.';
    }

    function ErrorUpdate(message) {
        if (message === undefined) {
            message = 'Error While updating.';
        }
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        DivErrorMessage.style.display = 'block';
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        LabelErrorMessage.innerText = message;
    }

    function Insert_Click() {
        if (Validate() == false) return;
        document.getElementById('buttonInsert').value = "Insert";
        document.getElementById('buttonInsert').disabled = true;
        document.getElementById('ImgSearch').style.display = "none";
        document.getElementById('ImgSearchIcon').style.display = "none";
    }

    /// <summary>
    ///For validation of ClientMedication order page.
    /// <Author>Author: Rishu Chopra</Author>
    /// <CreatedDate>Date: 19-Nov-07</CreatedDate>
    /// </summary>

    function Validate() {
        try {
            var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
            var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
            var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
            var LabelGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage');
            var DivGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivGridErrorMessage');
            var ImageGridError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageGridError');
            var $ComboBoxDrugDD = $("#ComboBoxDrugDD");
            if ($ComboBoxDrugDD.length <= 0) {
                document.getElementById('<%= tableErrorMessage.ClientID %>').style.display = 'block';
                DivErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Error accessing the Drug Drop Down, please contact the system administrator.';
                return false;
            }
            if ($ComboBoxDrugDD.attr('opid') == null || $ComboBoxDrugDD.attr('opid') == "") {
                document.getElementById('<%= tableErrorMessage.ClientID %>').style.display = 'block';
                DivErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please enter Drug Name.';
                return false;
            }
            // check for rxsource
            var rxSourceRequired = '<%= rxresourcerequired %>';
            if (document.getElementById("<%= DropDownListRXSource.ClientID %>").value == "" && rxSourceRequired == 'true') {
                document.getElementById('<%= tableErrorMessage.ClientID %>').style.display = 'block';
                DivErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Missing source information.';
                return false;
            }
            // Made Date Initiated configurable (Apr 9 2014) ref: task# 1446 .:. Core Bugs
            var dateInitiatedRequired = '<%= dateinitiatedrequired %>';
            // Added by Chuck Blaine (Dec 10 2012) ref: task# 2415 .:. Thresholds - Bugs/Features (Offshore)
            if (dateInitiatedRequired == "true" && document.getElementById("<%= TextBoxStartDate.ClientID %>").value == "") {
                document.getElementById('<%= tableErrorMessage.ClientID %>').style.display = 'block';
                DivErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please enter value for \'Date Initiated\'.';
                return false;
            }
            if (document.getElementById('<%= CheckBoxDispense.ClientID %>').checked == true) {
                document.getElementById('<%= HiddenMedicationDAW.ClientID %>').value = 'Y';
            } else {
                document.getElementById('<%= HiddenMedicationDAW.ClientID %>').value = 'N';
            }
            if (document.getElementById('<%= CheckBoxOffLabel.ClientID %>').checked == true) {
                document.getElementById('<%= HiddenMedicationOffLabel.ClientID %>').value = 'Y';
            } else {
                document.getElementById('<%= HiddenMedicationOffLabel.ClientID %>').value = 'N';
            }
            if (document.getElementById('<%= CheckboxIncludeOnPrescription.ClientID %>').checked == true) {
                document.getElementById('<%= HiddenFieldPrescription.ClientID %>').value = 'Y';
            } else {
                document.getElementById('<%= HiddenFieldPrescription.ClientID %>').value = 'N';
            }
            if (document.getElementById('Control_ASP.usercontrols_clientmedicationnonorder_ascx_CheckBoxPermitChanges').checked == true) {

                document.getElementById('<%= HiddenPermitChangesByOtherUsers.ClientID %>').value = 'Y';
            } else {

                document.getElementById('<%= HiddenPermitChangesByOtherUsers.ClientID %>').value = 'N';
            }
            ClientMedicationNonOrder.FillMedicationRow('<%= ClientID + ClientIDSeparator %>tableMedicationOrder', '<%= HiddenMedicationNameId.ClientID %>', '<%= DropDownListDxPurpose.ClientID %>', '<%= DropDownListPrescriber.ClientID %>', '<%= TextBoxSpecialInstructions.ClientID %>', '<%= HiddenMedicationName.ClientID %>', '<%= ClientID + ClientIDSeparator %>LabelErrorMessage', '<%= ClientID + ClientIDSeparator %>DivErrorMessage', '<%= ClientID + ClientIDSeparator %>ImageError', '<%= PanelMedicationListInformation.ClientID %>', '<%= HiddenRowIdentifier.ClientID %>', '<%= TextBoxStartDate.ClientID %>', '<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage', '<%= ClientID + ClientIDSeparator %>DivGridErrorMessage', '<%= ClientID + ClientIDSeparator %>ImageGridError', '<%= HiddenMedicationDAW.ClientID %>', '<%= TextBoxDesiredOutcome.ClientID %>', '<%= TextBoxComments.ClientID %>', '<%= HiddenMedicationOffLabel.ClientID %>', '<%= tableErrorMessage.ClientID %>', '<%= tableGridErrorMessage.ClientID %>', '<%= HiddenFieldPrescription.ClientID %>', '<%= HiddenPermitChangesByOtherUsers.ClientID %>', '<%= DropDownListRXSource.ClientID %>');

        } catch(Err) {
            alert("Error:" + Err.message);
        }
    }

    // Added on 5/21/2015 by Jason Steczyski, Philhaven - Customization Issues Tracking Task #1285
    var ManageClientMedicationNonOrderCompletionEvents = function () {
        var _eventCount;
        var initialized = 0;

        // Disable insert button, set listener for completion of service events, 
        // Reenable insert button on successful of all completion of all services of after 4 seconds 
        var initialize = function(){
            
            $(document).off("MedicationNonOrderServiceEvent");
            document.getElementById('buttonInsert').disabled = true;
            _eventCount = 0;
            initialized++;
            //console.log("Initialized " + initialized);

            $(document).on("MedicationNonOrderServiceEvent", function (event, arg1) {
                _eventCount += 1;
                //console.log("Event " + _eventCount + ' ' + arg1);
                //debugger;
                // Enable insert button after all six services have successfully completed
                if (_eventCount == 6 ) {
                    document.getElementById('buttonInsert').disabled = false;
                    //console.log('Insert button enabled on successful service events');
                    $(document).off("MedicationNonOrderServiceEvent");
                }

            });

            // The timeout below sets the maximum delay to assure the button is not left in the disabled state due to service event failures  
            setTimeout(function() {
                //debugger;
                initialized--;
                //console.log("Timeout " + initialized);
                if (_eventCount < 7 && initialized == 0) {
                    document.getElementById('buttonInsert').disabled = false;
                    //console.log('Insert button enabled on timeout');
                   $(document).off("MedicationNonOrderServiceEvent");
                }
            }, 5000);

        };

        return {
            initialize: initialize
        };

    }();



    function SetId(MedicationNameId, MedicationName, MedicationId, ExternalMedicationNameId, ExternalMedicationId) {
        try {
            document.getElementById('buttonInsert').value = "Insert";

            // Changed on 5/21/2015 by Jason Steczyski, Philhaven - Customization Issues Tracking Task #1285: set disabled to true rather than false
            ManageClientMedicationNonOrderCompletionEvents.initialize();
            //document.getElementById('buttonInsert').disabled = false;

            document.getElementById('<%= HiddenMedicationNameId.ClientID %>').value = MedicationNameId;
            document.getElementById('<%= HiddenMedicationName.ClientID %>').value = MedicationName;
            document.getElementById('<%= HiddenMedicationId.ClientID %>').value = (!MedicationId) ? "" : MedicationId;
            document.getElementById('<%= HiddenRowIdentifier.ClientID %>').value = "";
            ClientMedicationNonOrder.ClearTable('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
            var table = document.getElementById('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
            if (parseInt(MedicationNameId).toString() != "NaN") {
                for (var i = 0; i < table.rows.length; i++) {
                    if (i == 0 && MedicationId) {
                        ClientMedicationNonOrder.LoadDrugOrderTemplateForSelectedMedication(table.rows[i], MedicationNameId, MedicationId, i);
                    } else {
                        var row = table.rows[i];
                        var Strength = row.cells[1].getElementsByTagName("select")[0];
                        var Schedule = row.cells[4].getElementsByTagName("select")[0];
                        var ddlPotencyUnitCode = row.cells[9].getElementsByTagName("select")[0];
                        ClientMedicationNonOrder.FillPotencyUnitCodes(MedicationNameId, ddlPotencyUnitCode, null);
                        ClientMedicationNonOrder.FillStrength(MedicationNameId, Strength, null, null);
                        ClientMedicationNonOrder.FillScheduled(Schedule, null);
                        ClientMedicationNonOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + i, "#ComboBoxPharmacyDDList_" + i);
                    }
                }
            }
            document.getElementById('<%= DropDownListDxPurpose.ClientID %>').focus();
            if (parseInt(MedicationNameId).toString() != "NaN") {
                document.getElementById('ImgSearch').style.display = "block";
            } else {
                document.getElementById('ImgSearch').style.display = "none";
            }

        } catch(Err) {
            alert("Error:" + Err.message);
        } 

    }


    //Ref to Task#2590

    function DisplayErrorMessage(errormessage) {
        try {
            var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
            var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
            var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
            var tableErrorMessage = document.getElementById('<%= tableErrorMessage.ClientID %>');
            tableErrorMessage.style.display = 'block';
            DivErrorMessage.style.display = 'block';
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = errormessage;
        } catch(err) {
            alert("Error:" + Err.message);
        }
    }

    function Clear_Click() {
        ClientMedicationNonOrder.ClearDrug('<%= TextBoxStartDate.ClientID %>', '<%= TextBoxDrug.ClientID %>', '<%= TextBoxSpecialInstructions.ClientID %>', '<%= DropDownListDxPurpose.ClientID %>', '<%= DropDownListPrescriber.ClientID %>', null, '<%= TextBoxDesiredOutcome.ClientID %>', '<%= TextBoxComments.ClientID %>');
        ClientMedicationNonOrder.ClearTable('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
        document.getElementById('<%= CheckBoxDispense.ClientID %>').checked = false;
        document.getElementById('<%= CheckBoxOffLabel.ClientID %>').checked = false;
        document.getElementById('<%= CheckboxIncludeOnPrescription.ClientID %>').checked = false;
        document.getElementById('<%= LabelNonOrderCommentText.ClientID %>').innerText = document.getElementById('<%= HiddenNonOrderPageCommentLabel.ClientID %>').value;
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        LabelErrorMessage.innerText = '';
        ImageError.style.visibility = 'hidden';
        ImageError.style.display = 'none';
        var tableErrorMessage = document.getElementById('<%= tableErrorMessage.ClientID %>');
        tableErrorMessage.style.display = 'none';
        var LabelGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage');
        var ImageGridError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageGridError');
        LabelGridErrorMessage.innerText = '';
        ImageGridError.style.visibility = 'hidden';
        ImageGridError.style.display = 'none';
        var tableGridErrorMessage = document.getElementById('<%= tableGridErrorMessage.ClientID %>');
        tableGridErrorMessage.style.display = 'none';
        document.getElementById('ImgSearch').style.display = "none";
        document.getElementById('ImgSearchIcon').style.display = "none";
        ClientMedicationNonOrder.ClearDrugComboList("#ComboBoxDrugDD", "#ComboBoxDrugDDList");
        document.getElementById('buttonInsert').value = "Insert";
        ClientMedicationNonOrder.GetMedicationList(PanelMedicationListNonOrder);
    }

    function onDeleteClick(sender, e) {
        ClientMedicationNonOrder.DeleateFromList(e, '<%= PanelMedicationListInformation.ClientID %>');
        Clear_Click();
    }

    function onRadioClick(sender, e) {
        ClientMedicationNonOrder.ClearDrug('<%= TextBoxStartDate.ClientID %>', '<%= TextBoxDrug.ClientID %>', '<%= TextBoxSpecialInstructions.ClientID %>', '<%= DropDownListDxPurpose.ClientID %>', '<%= DropDownListPrescriber.ClientID %>', '<%= LabelErrorMessage.ClientID %>', '<%= TextBoxDesiredOutcome.ClientID %>', '<%= TextBoxComments.ClientID %>');
        document.getElementById('<%= CheckBoxDispense.ClientID %>').checked = false;
        document.getElementById('<%= CheckBoxOffLabel.ClientID %>').checked = false;
        ClientMedicationNonOrder.ClearTable('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        LabelErrorMessage.innerText = '';
        ImageError.style.visibility = 'hidden';
        ImageError.style.display = 'none';
        var tableGridErrorMessage = document.getElementById('<%= tableGridErrorMessage.ClientID %>');
        var tableErrorMessage = document.getElementById('<%= tableErrorMessage.ClientID %>');
        tableErrorMessage.style.display = 'none';
        tableGridErrorMessage.style.display = 'none';
        var LabelGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage');
        var ImageGridError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageGridError');
        LabelGridErrorMessage.innerText = '';
        ImageGridError.style.visibility = 'hidden';
        ImageGridError.style.display = 'none';
        ClientMedicationNonOrder.RadioButtonParameters(e, '<%= TextBoxStartDate.ClientID %>', '<%= TextBoxDrug.ClientID %>', '<%= TextBoxSpecialInstructions.ClientID %>', '<%= DropDownListDxPurpose.ClientID %>', '<%= DropDownListPrescriber.ClientID %>', '<%= ClientID + ClientIDSeparator %>tableMedicationOrder', '<%= HiddenRowIdentifier.ClientID %>', '<%= HiddenMedicationNameId.ClientID %>', '<%= HiddenMedicationName.ClientID %>', 'CheckBoxDispense', '<%= TextBoxDesiredOutcome.ClientID %>', '<%= TextBoxComments.ClientID %>', 'CheckBoxOffLabel', 'CheckboxIncludeOnPrescription', '<%= HiddenNonOrderPageCommentLabel.ClientID %>', '<%= HiddenNonOrderPageCommentLabelIncludeOnPrescription.ClientID %>', '<%= LabelNonOrderCommentText.ClientID %>', '<%= DropDownListRXSource.ClientID %>');
        document.getElementById('buttonInsert').value = "Modify";
    }

    function CallUpdateButton() {
        <%= Page.GetPostBackEventReference(FindControl("ButtonUpdate")) %>;
    }

    ////Added by Chandan on 1st Dec Nov 2008 Task#74 Dynamic Grid List MM#1.7
    //Calling a javascript method to add new rows

    function AddSteps() {
        try {
            ClientMedicationNonOrder.AddMedicationSteps('false', null);

        } catch(e) {

        }
    }

    /*----------------------------------------------
    The Common functions used for all dropdowns are:
    -----------------------------------------------
    -- function fnKeyDownHandler(getdropdown, e)
    -- function fnLeftToRight(getdropdown)
    -- function fnRightToLeft(getdropdown)
    -- function fnDelete(getdropdown)
    -- function FindKeyCode(e)
    -- function FindKeyChar(e)
    -- function fnSanityCheck(getdropdown)

  --------------------------- Subrata Chakrabarty */

    function fnKeyDownHandler(getdropdown, e) {
        fnSanityCheck(getdropdown);

        // Press [ <- ] and [ -> ] arrow keys on the keyboard to change alignment/flow.
        // ...go to Start : Press  [ <- ] Arrow Key
        // ...go to End : Press [ -> ] Arrow Key
        // (this is useful when the edited-text content exceeds the ListBox-fixed-width)
        // This works best on Internet Explorer, and not on Netscape

        var vEventKeyCode = FindKeyCode(e);

        // Press left/right arrow keys
        if (vEventKeyCode == 37) {
            fnLeftToRight(getdropdown);
        }
        //    if(vEventKeyCode == 39)
        //    {
        //    fnRightToLeft(getdropdown);
        //    }

        // Delete key pressed
        if (vEventKeyCode == 46) {
            fnDelete(getdropdown);
        }

        // backspace key pressed
        if (vEventKeyCode == 8 || vEventKeyCode == 127) {
            if (e.which) //Netscape
            {
                //e.which = ''; //this property has only a getter.
            } else //Internet Explorer
            {
                //To prevent backspace from activating the -Back- button of the browser
                e.keyCode = '';
                if (window.event.keyCode) {
                    window.event.keyCode = '';
                }
            }
            return true;
        }

        // Tab key pressed, use code below to reorient to Left-To-Right flow, if needed
        //if(vEventKeyCode == 9)
        //{
        //  fnLeftToRight(getdropdown);
        //}
    }

    function fnLeftToRight(getdropdown) {
        getdropdown.style.direction = "ltr";
    }

    function fnRightToLeft(getdropdown) {
        getdropdown.style.direction = "rtl";
    }

    function fnDelete(getdropdown) {
        if (getdropdown.options.length != 0)
            // if dropdown is not empty
        {
            if (getdropdown.options.selectedIndex == vEditableOptionIndex_A)
                // if option the Editable field
            {
                getdropdown.options[getdropdown.options.selectedIndex].text = '';
                getdropdown.options[getdropdown.options.selectedIndex].value = '';
            }
        }
    }


    /*
    Since Internet Explorer and Netscape have different
    ways of returning the key code, displaying keys
    browser-independently is a bit harder.
    However, you can create a script that displays keys
    for either browser.
    The following function will display each key
    in the status line:

  The "FindKey.." function receives the "event" object
    from the event handler and stores it in the variable "e".
    It checks whether the "e.which" property exists (for Netscape),
    and stores it in the "keycode" variable if present.
    Otherwise, it assumes the browser is Internet Explorer
    and assigns to keycode the "e.keyCode" property.
    */

    function FindKeyCode(e) {
        if (e.which) {
            keycode = e.which; //Netscape
        } else {
            keycode = e.keyCode; //Internet Explorer
        }

        //alert("FindKeyCode"+ keycode);
        return keycode;
    }

    function FindKeyChar(e) {
        keycode = FindKeyCode(e);
        if ((keycode == 8) || (keycode == 127)) {
            character = "backspace";
        } else if ((keycode == 46)) {
            character = "delete";
        } else {
            character = String.fromCharCode(keycode);
        }
        //alert("FindKey"+ character);
        return character;
    }

    function fnSanityCheck(getdropdown) {
        if (vEditableOptionIndex_A > (getdropdown.options.length - 1)) {
            alert("PROGRAMMING ERROR: The value of variable vEditableOptionIndex_... cannot be greater than (length of dropdown - 1)");
            return false;
        }
    }

    function FormatOrderDateEntered(datein) {
        var $datein = $(datein);
        if ($datein.val() == "") return "";
        //var regExpressionDate = /([01]?[0-9])(\/?-?([01]?[0-9]{1,2}))(\/?-?([0-9]{2,4}))/;
        //var dateMatch = $datein.val().match(regExpressionDate);
        //if (dateMatch == null) {
        //    $datein.val("");
        //} else {
        //    $datein.val(dateMatch[1] + '/' + dateMatch[3] + '/' + (dateMatch[5].length > 2 ? dateMatch[5] : '20' + dateMatch[5]));
        //    if (!isValidDate($datein)) $datein.val("");
        //}    
        if (!isValidDate($datein)) $datein.val("");
    }

    function isValidDate($dateIn) {
        var d = new Date($dateIn.val());
        if (Object.prototype.toString.call(d) !== "[object Date]") return false;
        var monthfield = $dateIn.val().split("/")[0];
        var dayfield = $dateIn.val().split("/")[1];
        var yearfield = $dateIn.val().split("/")[2];
        var dayobj = new Date(yearfield, monthfield - 1, dayfield);

        return !((dayobj.getMonth() + 1 != monthfield) || (dayobj.getDate() != dayfield) || (dayobj.getFullYear() != yearfield));
    }

    /*----------------------------------------------
    Dropdown specific global variables are:
    -----------------------------------------------
    1) vEditableOptionIndex_A   --> this needs to be set by Programmer!! See explanation.
    2) vEditableOptionText_A    --> this needs to be set by Programmer!! See explanation.
    3) vPreviousSelectIndex_A
    4) vSelectIndex_A
    5) vSelectChange_A

  --------------------------- Subrata Chakrabarty */

    /*----------------------------------------------
    The dropdown specific functions
    (which manipulate dropdown specific global variables)
    used by all dropdowns are:
    -----------------------------------------------
    1) function fnChangeHandler_A(getdropdown)
    2) function fnKeyPressHandler_A(getdropdown, e)
    3) function fnKeyUpHandler_A(getdropdown, e)

  --------------------------- Subrata Chakrabarty */

    /*------------------------------------------------
    IMPORTANT: Global Variable required to be SET by programmer
    -------------------------- Subrata Chakrabarty  */

    var vEditableOptionIndex_A = 0;

    // Give Index of Editable option in the dropdown.
    // For eg.
    // if first option is editable then vEditableOptionIndex_A = 0;
    // if second option is editable then vEditableOptionIndex_A = 1;
    // if third option is editable then vEditableOptionIndex_A = 2;
    // if last option is editable then vEditableOptionIndex_A = (length of dropdown - 1).
    // Note: the value of vEditableOptionIndex_A cannot be greater than (length of dropdown - 1)

    var vEditableOptionText_A = "";

    // Give the default text of the Editable option in the dropdown.
    // For eg.
    // if the editable option is <option ...>--?--</option>,
    // then set vEditableOptionText_A = "--?--";

    /*------------------------------------------------
    Global Variables required for
    fnChangeHandler_A(), fnKeyPressHandler_A() and fnKeyUpHandler_A()
    for Editable Dropdowns
    -------------------------- Subrata Chakrabarty  */

    var vPreviousSelectIndex_A = 0;
    // Contains the Previously Selected Index, set to 0 by default

    var vSelectIndex_A = 0;
    // Contains the Currently Selected Index, set to 0 by default

    var vSelectChange_A = 'MANUAL_CLICK';
    // Indicates whether Change in dropdown selected option
    // was due to a Manual Click
    // or due to System properties of dropdown.

    // vSelectChange_A = 'MANUAL_CLICK' indicates that
    // the jump to a non-editable option in the dropdown was due
    // to a Manual click (i.e.,changed on purpose by user).

    // vSelectChange_A = 'AUTO_SYSTEM' indicates that
    // the jump to a non-editable option was due to System properties of dropdown
    // (i.e.,user did not change the option in the dropdown;
    // instead an automatic jump happened due to inbuilt
    // dropdown properties of browser on typing of a character )

    /*------------------------------------------------
    Functions required for  Editable Dropdowns
    -------------------------- Subrata Chakrabarty  */

    function fnChangeHandler_A(getdropdown) {
        fnSanityCheck(getdropdown);

        vPreviousSelectIndex_A = vSelectIndex_A;
        // Contains the Previously Selected Index

        vSelectIndex_A = getdropdown.options.selectedIndex;
        // Contains the Currently Selected Index

        if ((vPreviousSelectIndex_A == (vEditableOptionIndex_A)) && (vSelectIndex_A != (vEditableOptionIndex_A)) && (vSelectChange_A != 'MANUAL_CLICK'))
            // To Set value of Index variables - Subrata Chakrabarty
        {
            getdropdown[(vEditableOptionIndex_A)].selected = true;
            vPreviousSelectIndex_A = vSelectIndex_A;
            vSelectIndex_A = getdropdown.options.selectedIndex;
            vSelectChange_A = 'MANUAL_CLICK';
            // Indicates that the Change in dropdown selected
            // option was due to a Manual Click
        }
    }

    function fnKeyPressHandler_A(getdropdown, e) {
        fnSanityCheck(getdropdown);

        keycode = FindKeyCode(e);
        keychar = FindKeyChar(e);

        // Check for allowable Characters
        // The various characters allowable for entry into Editable option..
        // may be customized by minor modifications in the code (if condition below)
        // (you need to know the keycode/ASCII value of the  character to be allowed/disallowed.
        // - Subrata Chakrabarty

        if ((keycode > 47 && keycode < 59) || (keycode > 62 && keycode < 127) || (keycode == 32)) {
            var vAllowableCharacter = "yes";
        } else {
            var vAllowableCharacter = "no";
        }

        //alert(window); alert(window.event);

        if (getdropdown.options.length != 0)
            // if dropdown is not empty
            if (getdropdown.options.selectedIndex == (vEditableOptionIndex_A))
                // if selected option the Editable option of the dropdown
            {

                var vEditString = getdropdown[vEditableOptionIndex_A].value;


                // make Editable option Null if it is being edited for the first time
                if ((vAllowableCharacter == "yes") || (keychar == "backspace")) {
                    if (vEditString == vEditableOptionText_A)
                        vEditString = "";
                }
                if (keychar == "backspace")
                    // To handle backspace - Subrata Chakrabarty
                {
                    vEditString = vEditString.substring(0, vEditString.length - 1);
                    // Decrease length of string by one from right

                    vSelectChange_A = 'MANUAL_CLICK';
                    // Indicates that the Change in dropdown selected
                    // option was due to a Manual Click

                }
                //alert("EditString2:"+vEditString);

                if (vAllowableCharacter == "yes")
                    // To handle addition of a character - Subrata Chakrabarty
                {
                    vEditString += String.fromCharCode(keycode);
                    // Concatenate Enter character to Editable string

                    // The following portion handles the "automatic Jump" bug
                    // The "automatic Jump" bug (Description):
                    //   If a alphabet is entered (while editing)
                    //   ...which is contained as a first character in one of the read-only options
                    //   ..the focus automatically "jumps" to the read-only option
                    //   (-- this is a common property of normal dropdowns
                    //    ..but..is undesirable while editing).

                    var i = 0;
                    var vEnteredChar = String.fromCharCode(keycode);
                    var vUpperCaseEnteredChar = vEnteredChar;
                    var vLowerCaseEnteredChar = vEnteredChar;


                    if (((keycode) >= 97) && ((keycode) <= 122))
                        // if vEnteredChar lowercase
                        vUpperCaseEnteredChar = String.fromCharCode(keycode - 32);
                    // This is UpperCase


                    if (((keycode) >= 65) && ((keycode) <= 90))
                        // if vEnteredChar is UpperCase
                        vLowerCaseEnteredChar = String.fromCharCode(keycode + 32);
                    // This is lowercase

                    if (e.which) //For Netscape
                    {
                        // Compare the typed character (into the editable option)
                        // with the first character of all the other
                        // options (non-editable).

                        // To note if the jump to the non-editable option was due
                        // to a Manual click (i.e.,changed on purpose by user)
                        // or due to System properties of dropdown
                        // (i.e.,user did not change the option in the dropdown;
                        // instead an automatic jump happened due to inbuilt
                        // dropdown properties of browser on typing of a character )

                        for (i = 0; i <= (getdropdown.options.length - 1); i++) {
                            if (i != vEditableOptionIndex_A) {
                                var vReadOnlyString = getdropdown[i].value;
                                var vFirstChar = vReadOnlyString.substring(0, 1);
                                if ((vFirstChar == vUpperCaseEnteredChar) || (vFirstChar == vLowerCaseEnteredChar)) {
                                    vSelectChange_A = 'AUTO_SYSTEM';
                                    // Indicates that the Change in dropdown selected
                                    // option was due to System properties of dropdown
                                    break;
                                } else {
                                    vSelectChange_A = 'MANUAL_CLICK';
                                    // Indicates that the Change in dropdown selected
                                    // option was due to a Manual Click
                                }
                            }
                        }
                    }
                }

                // Set the new edited string into the Editable option
                getdropdown.options[vEditableOptionIndex_A].text = vEditString;
                getdropdown.options[vEditableOptionIndex_A].value = vEditString;

                return false;
            }
        return true;
    }

    function fnKeyUpHandler_A(getdropdown, e) {
        fnSanityCheck(getdropdown);

        if (e.which) // Netscape
        {
            if (vSelectChange_A == 'AUTO_SYSTEM') {
                // if editable dropdown option jumped while editing
                // (due to typing of a character which is the first character of some other option)
                // then go back to the editable option.
                getdropdown[(vEditableOptionIndex_A)].selected = true;
            }

            var vEventKeyCode = FindKeyCode(e);
            var vEventKeyChar = FindKeyChar(e);
          
            if ((vEventKeyCode == 37) || (vEventKeyCode == 39)) {
                getdropdown[vEditableOptionIndex_A].selected = true;
            }
            if (vEventKeyChar == "backspace")
            {
                var vEditString = getdropdown[vEditableOptionIndex_A].value;
                vEditString = vEditString.substring(0, vEditString.length - 1);
                // Decrease length of string by one from right
                 vSelectChange_A = 'MANUAL_CLICK';
                // Indicates that the Change in dropdown selected option was due to a Manual Click
                getdropdown.options[vEditableOptionIndex_A].text = vEditString;
                getdropdown.options[vEditableOptionIndex_A].value = vEditString;
            }
        }
    }

    function ManageOrderTemplate(show) {
        if (true === <%= enableDisabled(Permissions.MedOrderTemplate) == "Disabled" ? "false" : "true" %>) {
            if (show == 'save') {
            $('#Span_SaveTemplate').show();
            $('#Span2_SaveTemplate').show();
            $('#Span_OverrideTemplate').hide();
            $('#Span2_OverrideTemplate').hide();
        } else if (show == 'override') {
            $('#Span_SaveTemplate').hide();
            $('#Span2_SaveTemplate').hide();
            $('#Span_OverrideTemplate').show();
            $('#Span2_OverrideTemplate').show();
        } else {
            $('#Span_SaveTemplate').hide();
            $('#Span2_SaveTemplate').hide();
            $('#Span_OverrideTemplate').hide();
            $('#Span2_OverrideTemplate').hide();
        }
        $('#RadioButtonNoTemplate').attr('checked', true);
    }
    }

    /*-------------------------------------------------------------------------------------------- Subrata Chakrabarty */

</script>

<!--end of script for dropdown lstDropDown_A -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">



<div>
    <table width="100.7%" border="0" cellpadding="0" cellspacing="0" style="height: 470px">
        <tr>
            <td style="width: 100%" class="header" colspan="2">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                         <td align="left" style="width: 89%; background: #2c689e; height: 31px; font-size: 11px; font-family: Tahoma, Arial, Helvetica, sans-serif;">
                <asp:Label ID="LabelTitleBar" runat="server" Visible="true" style ="color: white; " 
                    Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
                
            </td>    
                                     <td align="middle" style="width: 2%;display:none;" onclick="ShowKeyPhrasePage();return false;">
                                          <a href="#"><img src="App_Themes/Includes/Images/add-key-icon.png" title="Add Key Phrases" /></a>
                                    </td>
                                    <td align="middle" style="width: 1%;" id="KeyPhrases" runat="server" onclick="ShowUseKeyPhrasePage();return false;">
                                        <a href="#" id="aTag" runat="server"><img src="App_Themes/Includes/Images/key.png" title="Key Phrases" /></a>

                                    </td>
                                    <td align="middle" style="width: 6%;">
                                        <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" runat="server" Style="display: none; color:white;"
                                            OnClientClick=" redirectToStartPage();this.disabled=true;return false; "></asp:LinkButton>
                                    </td>
                                    <td align="middle" style="width: 2%">
                                         <asp:ImageButton ID="LinkButtonLogout" Style="display: none" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Text="" runat="server" OnClick="LinkButtonLogout_Click" />
                                        <%--<asp:LinkButton ID="LinkButtonLogout" Text="" runat="server" OnClick="LinkButtonLogout_Click"
                                            Style="display: none; color:white;"> <asp:Image ID="image_logoff" runat="server" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Style="border-width: 0px;" /></asp:LinkButton>--%>
                                   
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="border-bottom: #5b0000 1px solid; height: 1pt;" colspan="5"></td>
        </tr>
        <tr>
             <td style="width: 32%">
                            <asp:Label ID="Label1" runat="server" Visible="true" CssClass="TittleBarBase" Text="Add Medication (Not Ordered Locally) "></asp:Label>
                        </td>
            <td align="right">  
                <table class="toolbarbutton" border="0" cellpadding="0" cellspacing="0" width="10%">
                    <tr>
                        <td align="left">
                            <img width="7" height="24" alt="" src="App_Themes/Includes/Images/top_options_left_corner.gif">
                        </td>
                        <td class="top_options_bg">
                            <table>
                                <tr>
                                    <td><asp:ImageButton ID="ButtonUpdate" runat="server" ToolTip="Update" OnClick="ButtonUpdate_Click" ImageUrl="~/App_Themes/Includes/Images/save_icon.gif" /></td>
                                    <td style="background-color:#bdbdbd; width:1px;"></td> 
                                     <td><asp:ImageButton ID="ButtonCancel" ToolTip="Close" runat="server" OnClientClick="ClientMedicationNonOrder.CloseButtonClick(); return false;" ImageUrl="~/App_Themes/Includes/Images/close_icon.gif" /> </td>
                                <td style="background-color:#bdbdbd; width:1px;"></td> 
                                     </tr>
                            </table>
                        </td>
                        <td>
                            <img width="7" height="24" alt="" src="App_Themes/Includes/Images/top_options_right_corner.gif">
                        </td>
                    </tr>
                    </table>
            </td>
        </tr>
          <tr>
            <td align="left" colspan="5">
                <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif">
            </td>
        </tr>
        <tr>
            <td colspan="4" style="padding-left:8px;">
                <UI:MedicationClientPersonalInformation ID="MedicationClientPersonalInformation1"
                    runat="Server"></UI:MedicationClientPersonalInformation>
            </td>
        </tr>
        <tr>
            <td valign="top" colspan="4" style="padding-left:8px;">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;">
                    <tr>
                        <td colspan="10" nowrap="nowrap" valign="top">
                            <table id="tableErrorMessage" runat="server" style="display: none" cellpadding="0"
                                cellspacing="0" border="0">
                                <tr>
                                    <td valign="middle">
                                        <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif" Style="display: none" />
                                    </td>
                                    <td valign="middle">
                                        <asp:Label ID="LabelErrorMessage" Style="vertical-align: middle" runat="server" CssClass="redTextError"
                                            BackColor="#DCE5EA"></asp:Label>
                                    </td>
                                    <td valign="middle">
                                        <div id="DivErrorMessage" style="display: none; width: 20px;" runat="server">
                                        </div>
                                    </td>
                                    <td valign="middle"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" colspan="3" style="width: 100%">
                            <UI:Heading ID="Heading2" runat="server" HeadingText="Order"></UI:Heading>
                            <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;"
                                cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="1" cellpadding="1">
                                            <tr>
                                                <td style="width: 65px;" class="labelFont">Prescriber
                                                </td>
                                                <td style="width: 103px;">
                                                    <asp:DropDownList ID="DropDownListPrescriber" runat="server" Width="185px" onKeyDown="fnKeyDownHandler(this, event);"
                                                        onKeyUp="fnKeyUpHandler_A(this, event); return false;" onKeyPress="return fnKeyPressHandler_A(this, event);">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 28px;"></td>
                                                <td style="width: 93px;" class="labelFont">Date Initiated
                                                </td>
                                                <td colspan="2" nowrap>
                                                    <asp:TextBox ID="TextBoxStartDate" runat="server" Width="70px" MaxLength="10" onchange="FormatOrderDateEntered(this);"></asp:TextBox>
                                                    <img id="Img1" src="App_Themes/Includes/Images/calender_grey.gif" class="imgcal"  onclick=" CalShow(this, '<%= TextBoxStartDate.ClientID %>') "
                                                        onmouseover=" CalShow(this, '<%= TextBoxStartDate.ClientID %>') " alt="" align="middle" />&nbsp;
                                                </td>
                                                <td style="width: 28px;"></td>
                                                <td style="width: 50px;" class="labelFont">Source
                                                </td>
                                                <td style="width: 103px;">
                                                    <asp:DropDownList ID="DropDownListRXSource" runat="server" Width="185px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                <tr>
                                    <td style="width: 75px">
                                        <UI:Heading ID="Heading3" runat="server" HeadingText="Medication" />
                                    </td>
                                    <td align="left">
                                        <asp:CheckBox ID="CheckBoxPermitChanges" runat="server" Text="Permit Changes By Other Users"
                                            CssClass="RadioText" />
                                    </td>
                                </tr>
                            </table>
                            <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;"
                                cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="1" cellpadding="1">
                                            <tr>
                                                <td style="width: 53px;" class="labelFont" valign="middle">Drug
                                                </td>
                                                <td colspan="2" nowrap="nowrap" valign="middle" style="width: 185px;">
                                                    <asp:TextBox ID="TextBoxDrug" runat="server" Width="164px" Style="height: 13px; position: absolute;"
                                                        Visible="false"></asp:TextBox>
                                                    <div id="ComboBoxDrugDDDiv" style="border: solid 1px #7b9ebd;" onclick=" ClientMedicationNonOrder.onClickDrugComboList(this, '#ComboBoxDrugDDList'); ">
                                                        <input type="text" id="ComboBoxDrugDD" value="" opid="" style="border: none; width: 160px; height:18px; font-size:11px;"
                                                            onchange=" ClientMedicationNonOrder.onChangeDrugComboList(this, '#ComboBoxDrugDDList'); "
                                                            onblur=" ClientMedicationNonOrder.onBlurDrugComboList(this, '#ComboBoxDrugDDList'); "
                                                            onkeydown=" ClientMedicationNonOrder.onKeyDownComboList(event, '#ComboBoxDrugDDList'); " />
                                                        <div style="float: right; height: 18px; width: 19px;" class="ComboBoxDrugDDImage">&nbsp;</div>
                                                    </div>
                                                    <div id="ComboBoxDrugDDList" style="display: none; white-space: nowrap;"
                                                        class="combolist" isempty="true"
                                                        onclick=" ClientMedicationNonOrder.onSelectedDrugComboList(event, this, true); ">
                                                    </div>
                                                </td>
                                                <td colspan="1" nowrap="nowrap" style="width: 19px;" valign="middle">
                                                    <img id="ImgSearch" src="App_Themes/Includes/Images/search_icon.gif" style="cursor: pointer; display: none;"
                                                        onclick=" javascript:ClientMedicationNonOrder.GetSystemReportsMedicationName('Medication -NewOrder-MedicationName');return false; "
                                                        align="middle" title="View Report" />
                                                </td>
                                                <td style="width: 61px;" class="labelFont">Dx/Purpose
                                                </td>
                                                <td style="width: 103px;" valign="middle">
                                                    <asp:DropDownList ID="DropDownListDxPurpose" runat="server" Width="185px" onclick="ClientMedicationNonOrder.ResetDrugComboList('#ComboBoxDrugDDList');">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 29px;" valign="middle">
                                                    <img id="ImgSearchIcon" onclick=" javascript:ClientMedicationNonOrder.GetSystemReports('Medication -NewOrder-DiagnosisCode');return false; "
                                                        src="App_Themes/Includes/Images/search_icon.gif" style="cursor: pointer; display: none;"
                                                        title="View Report" />
                                                </td>
                                               
                                                <td colspan="1" nowrap="nowrap" style="width: 20px;" valign="middle">
                                                    <input id="CheckBoxDispense" type="checkbox" runat="server" onclick="ClientMedicationNonOrder.ResetDrugComboList('#ComboBoxDrugDDList');" />
                                                </td>
                                                 <td colspan="1" nowrap="nowrap" style="width: 100px;" valign="middle">Dispense as Written
                                                </td>                                              
                                                <td colspan="1" nowrap="nowrap" style="width: 82px" valign="middle">&nbsp;<input id="CheckBoxOffLabel" type="checkbox" runat="server" title="Off Label" />
                                                </td>
                                                  <td>
                                                    <span id="Span_OffLabel" runat="server" class="labelFont">Off Label</span>
                                                </td>
                                            </tr>
                                        </table>
                                        <table border="0" cellpadding="1" cellspacing="1">
                                            <tr>
                                                <!--<td class="labelFont" style="width: 50px; height: 24px;">
                                                        Special Instructions</td>!-->
                                                <td class="labelFont" style="height: 24px; width: 53px;">
                                                    <asp:Label ID="LabelNonOrderNote" runat="server" Text="Note"></asp:Label>
                                                </td>
                                                <td style="height: 24px">
                                                    <asp:TextBox ID="TextBoxSpecialInstructions" EnableTheming="false" runat="server" onclick="ClientMedicationNonOrder.ResetDrugComboList('#ComboBoxDrugDDList');"
                                                        TextMode="MultiLine" MaxLength="1000" Width="180px" CssClass="TextboxMultiline"></asp:TextBox>
                                                </td>
                                                <td style="height: 24px; width: 18px;"></td>
                                                <td class="labelFont" style="height: 24px; width: 62px;">Desired Outcome
                                                </td>
                                                <td style="height: 24px; width: 176px;">
                                                    <asp:TextBox ID="TextBoxDesiredOutcome" EnableTheming="false" runat="server" TextMode="MultiLine" onclick="ClientMedicationNonOrder.ResetDrugComboList('#ComboBoxDrugDDList');"
                                                        MaxLength="1000" Width="180px" CssClass="TextboxMultiline"></asp:TextBox>
                                                </td>
                                                <td style="height: 21px; width: 28px;"></td>
                                                <td class="labelFont" style="height: 24px; width: 100px;">
                                                    <asp:Label ID="LabelNonOrderCommentText" runat="server" Text="Comment"></asp:Label>
                                                </td>
                                                <td colspan="3" style="height: 24px; width: 176px;">
                                                    <asp:TextBox ID="TextBoxComments" EnableTheming="false" runat="server" TextMode="MultiLine" onclick="ClientMedicationNonOrder.ResetDrugComboList('#ComboBoxDrugDDList');"
                                                        MaxLength="1000" CssClass="TextboxMultiline" Width="98%"></asp:TextBox>
                                                </td>
                                              
                                                <td colspan="1" style="height: 24px">
                                                    <input id="CheckboxIncludeOnPrescription" type="checkbox" runat="server" title="Off Label" onclick="ClientMedicationNonOrder.ResetDrugComboList('#ComboBoxDrugDDList');" />
                                                </td>
                                                  <td colspan="1" style="height: 24px; width: 110px;" nowrap="nowrap">Include On Prescription
                                                </td>
                                                <td id="Span_SaveTemplate" style='display: none;'>
                                                    <span class="labelFont">Save as Template</span>
                                                </td>
                                                <td id="Span2_SaveTemplate" colspan="1" nowrap="nowrap" width="82px" valign="middle" style='display: none;'>&nbsp;<input id="RadioButtonSaveTemplate" type="radio" name="SaveTemplateRadio" title="Save as Template" tabindex="0" />
                                                </td>
                                                <td id="Span_OverrideTemplate" style='display: none;'>
                                                    <span class="labelFont">Override Template</span>
                                                </td>
                                                <td id="Span2_OverrideTemplate" colspan="1" nowrap="nowrap" width="82px" valign="middle" style='display: none;'>&nbsp;<input id="RadioButtonOverrideTemplate" type="radio" name="SaveTemplateRadio" title="Override Template" tabindex="0" />
                                                    <input id="RadioButtonNoTemplate" type="radio" name="SaveTemplateRadio" title="No Template" tabindex="0" style="display: none;" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <table id="tblMain" runat="server" width="100%" border="0" cellpadding="0" cellspacing="0"
                    style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid;">
                    <tr>
                        <td colspan="23">
                            <div style="height: 120px; overflow: auto;">
                                <table border="0" width="100%">
                                    <tr style="background-color: #dce5ea;">
                                        <td colspan="3">
                                            <div id="PlaceLabel" runat="server" visible="true">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <div id="PlaceHolder" runat="server" visible="true">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>                                           
                                            <input type="button" id="buttonAddRows" onclick=" AddSteps()" value="More Steps" class="btnimgexsmall" />                                           
                                        </td>
                                        <td align="right">
                                              <input type="button" id="buttonInsert" onclick=" Insert_Click() "
                                                value="Insert" class="btnimgexsmall" />
                                              <input type="button" id="buttonClear" onclick=" Clear_Click() " value="Clear" class="btnimgexsmall" />
                                              </td>                                       
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
                <table id="tableGridErrorMessage" runat="server" style="display: none" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2">
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td style="width: 2px" valign="middle"></td>
                                    <td valign="middle">
                                        <asp:Image ID="ImageGridError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif" Style="display: none" />
                                    </td>
                                    <td valign="middle">&nbsp;
                                        <asp:Label ID="LabelGridErrorMessage" runat="server" CssClass="redTextError" BackColor="#DCE5EA" Height="20px"></asp:Label>
                                    </td>
                                    <td valign="middle">
                                        <div id="DivGridErrorMessage" style="display: none; height: 5px; width: 23px;" runat="server">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <%--<input type="button" id="buttonAddRows" class="ButtonWeb" onclick="AddSteps()" value="Add Steps" />--%>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <%--<td style="width:802px">--%>
                    </tr>
                </table>
                <table style="height: 130px; width: 100%;">
                    <tr>
                        <td>
                            <UI:Heading ID="HeadingMedicationList" runat="server" HeadingText="Medication List" />
                            <table cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; height: 120px; width: 100%;">
                                <tr>
                                    <td>
                                        <div id="MedicationListInformation" style="height: 250px; overflow: auto; border:3px solid rgb(222, 231, 239);">
                                            <asp:Panel ID="PanelMedicationListInformation" runat="server" BorderColor="Black"
                                                BorderStyle="None" Height="250px" Width="100%" BackColor="White">
                                            </asp:Panel>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <div class="ui-draggable" id="divSelectDaysOfWeek" style="display: none; top: 350px; left: 355px; border-top-color: black; border-right-color: black; border-bottom-color: black; border-left-color: black; border-top-width: thin; border-right-width: thin; border-bottom-width: thin; border-left-width: thin; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; position: absolute; z-index: 990; background-color: white;">
                                <table style="width: 435px;" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%"
                                                style="cursor: default;">
                                                <tr class="PopUpTitleBar">
                                                    <td align="left" class="TitleBarText">Select Days Of Week
                                                    </td>
                                                    <td align="right" style="width: 20px;">
                                                        <img title="Close" id="ImgCross" onclick="$('#divSelectDaysOfWeek').hide()" alt="Close" src="App_Themes/Includes/Images/cross.jpg" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 10px">
                                            <table cellpadding="3" cellspacing="0" border="0" width="100%">
                                                <tr>
                                                    <td class="height2" colspan="4">
                                                        <span id="DaysOfWeekError" style="display: none; color: red"></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td class="checkbox_container" width="23%">
                                                        <input type="checkbox" class="SelectDays" id="CheckBox_Sun" name="CheckBox_Sun" />
                                                        <label class="form_label" for="CheckBox_Sun">Sunday</label>
                                                    </td>
                                                    <td class="checkbox_container" width="22%">
                                                        <input type="checkbox" class="SelectDays" id="CheckBox_Mon" name="CheckBox_Mon" />
                                                        <label class="form_label" for="CheckBox_Mon">Monday</label>
                                                    </td>
                                                    <td class="checkbox_container" width="25%">
                                                        <input type="checkbox" class="SelectDays" id="CheckBox_Tue" name="CheckBox_Tue" />
                                                        <label class="form_label" for="CheckBox_Tue">Tuesday</label>
                                                    </td>
                                                    <td class="checkbox_container" width="30%">
                                                        <input type="checkbox" class="SelectDays" id="CheckBox_Wed" name="CheckBox_Wed" />
                                                        <label class="form_label" for="CheckBox_Wed">Wednesday</label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td class="checkbox_container" width="25%">
                                                        <input type="checkbox" class="SelectDays" id="CheckBox_Thr" name="CheckBox_Thr" />
                                                        <label class="form_label" for="CheckBox_Thr">Thursday</label>
                                                    </td>
                                                    <td class="checkbox_container" width="25%">
                                                        <input type="checkbox" class="SelectDays" id="CheckBox_Fri" name="CheckBox_Fri" />
                                                        <label class="form_label" for="CheckBox_Fri">Friday</label>
                                                    </td>
                                                    <td class="checkbox_container" width="25%">
                                                        <input type="checkbox" class="SelectDays" id="CheckBox_Sat" name="CheckBox_Sat" />
                                                        <label class="form_label" for="CheckBox_Sat">Saturday</label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td class="checkbox_container" width="25%"></td>
                                                    <td class="checkbox_container" width="25%"></td>
                                                    <td style="padding-right: 13px">
                                                        <input type="button" class="btnimgexsmall" id="buttonok" runat="server" value="OK"
                                                            onclick="ClientMedicationNonOrder.SelectDaysOfWeekClick()" />
                                                    </td>
                                                    <td>
                                                        <input type="button" class="btnimgexsmall" id="Button1" value="Cancel" tabindex="2"
                                                            onclick="$('#divSelectDaysOfWeek').hide()" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
                <%--</td>--%>
            </td>
        </tr>
        <tr>
            <td style="height: 5px; width: 889px;" colspan="5">
                <input id="HiddenMedicationNameId" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <%--Added as per task#3328 Start Over here--%>
                <input id="HiddenNonOrderPageCommentLabel" type="hidden" runat="server" style="height: 9px; width: 14px;" />
                <input id="HiddenNonOrderPageCommentLabelIncludeOnPrescription" type="hidden" runat="server"
                    style="height: 9px; width: 14px;" />
                <%--Added as per task#3328 End Over here--%>
                <input id="HiddenMedicationDAW" type="hidden" runat="server" style="height: 9px; width: 14px;" />
                <input id="HiddenMedicationOffLabel" type="hidden" runat="server" style="height: 9px; width: 14px;" />
                <!--Added by Loveena in ref to Task#32 !-->
                <input id="HiddenFieldPrescription" type="hidden" runat="server" style="height: 9px; width: 14px;" />
                <asp:HiddenField ID="HiddenFieldRXAddMedicationFrequencyIsRequiredField" runat="server" />
                <asp:HiddenField ID="HiddenFieldRXProgramRequireFrequency" runat="server" />
                <asp:HiddenField ID="HiddenFieldRXShownoOfDaysOfWeekPopup" runat="server" />
                <input id="HiddenMedicationName" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <input id="HiddenCancelYes" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <input id="HiddenRowIdentifier" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <%-- Below HiddenField Added by Chandan on 18th march 2008 for task #2377  --%>
                <input id="HiddenDrugPurpose" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <input id="HiddenDSMCode" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <input id="HiddenDxId" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <input id="HiddenDSMNumber" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <input id="HiddenPrescriberName" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <input id="HiddenPrescriberId" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <input id="HiddenRXSource" type="hidden" runat="server" style="height: 11px; width: 80px;" />
                <input id="HiddenFieldRowIndex" type="hidden" value="2" style="height: 9px; width: 14px;" />
                <input id="HiddenPermitChangesByOtherUsers" type="hidden" value="4" style="height: 9px; width: 14px;"
                    runat="server" />
                <asp:HiddenField ID="HiddenInsertClick" runat="server" />
                <!-- Added in ref to Task#2905 !-->
                <input type="hidden" id="HiddenRelativePath" runat="server" />
                <!-- For new Dx/Purpose enforcement functionality -->
                <asp:HiddenField runat="server" ID="HiddenFieldDxPurposeNotMandatory" />
                <!-- For saving and overriding new order templates-->
                <asp:HiddenField ID="HiddenFieldSaveAsTemplate" runat="server" />
                <asp:HiddenField ID="HiddenFieldOverrideTemplate" runat="server" />
                <input id="HiddenMedicationId" runat="server" type="hidden" style="height: 9px; width: 14px;" />
                <asp:HiddenField runat="server" ID="HiddenFieldLoggedInStaffId" />
                <a href="abc" id="testNewMedOrder" target="_blank"></a>
            </td>
        </tr>
    </table>
</div>
