<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ClientMedicationOrder.ascx.cs"
    EnableViewState="false" Inherits="Streamline.SmartClient.UI.UserControls_ClientMedicationOrder" %>
<%@ Import Namespace="Streamline.BaseLayer" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>
<%@ Register Assembly="Streamline.DropDowns" Namespace="Streamline.DropDowns" TagPrefix="cc2" %>

<asp:ScriptManagerProxy runat="server" ID="SMP1">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/ClientMedicationOrder.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationClientPersonalInformation.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationPrescribe.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<style type="text/css">
    .ComboBoxDrugDDImage {
        background-image: url('<%= RelativePath %>App_Themes/Includes/Images/dropdowncbo.jpg');
        background-position: right;
        background-repeat: no-repeat;
        vertical-align: middle;
    }
.top_options_bg {
    width: 0% !important;
}

    .labelFont {
    /* background-color: #dce5ea; */
    font-family: Tahoma, Arial, Helvetica, sans-serif;
    /* font-size: 8.25pt; */
    font-size: 11px;
    /* padding-left: 5px; */
    color: Black;
    text-align: left;
    margin-right: 2px;
}
</style>

<script language="javascript" type="text/javascript">
    $(document).ready(function () {
        $("#DivHolderMain")[0].style.height = "100%";
        $("#PlaceHolderMain")[0].style.height = "100%";
    });
   
    function pageLoad() {
        try {
            var today = new Date();
            var month = today.getMonth() + 1;
            var day = today.getDate();
            var year = today.getFullYear();
            var s = "/";

            var DxPurpose = document.getElementById('<%=DropDownListDxPurpose.ClientID%>');
            var PrescribingLocation = document.getElementById('<%=DropDownListLocations.ClientID%>');
            var Prescriber = document.getElementById('<%=DropDownListPrescriber.ClientID%>');
            var DropDownListPrinterDeviceLocations = document.getElementById('<%=DropDownListPrinterDeviceLocations.ClientID%>');
            var DropDownListPharmacies = document.getElementById('<%=DropDownListPharmacies.ClientID%>');
            var DropDownChartCoprPrinter = document.getElementById('<%=DropDownListChartCopyPrinter.ClientID%>');
            LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
            ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');

            var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
            LabelGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage');
            ImageGridError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageGridError');
            var tableGridErrorMessage = document.getElementById('<%=tableGridErrorMessage.ClientID%>');

            ClientMedicationOrder.FillDxPurpose(DxPurpose);
            ClientMedicationOrder.FillPrinter(DropDownListPrinterDeviceLocations);
            //ClientMedicationOrder.FillPharmacies(DropDownListPharmacies);
            ClientMedicationOrder.FillChartcopyPrinter(DropDownChartCoprPrinter);
            $("#ComboBoxDrugDD").keydown(function(event) {
                if (event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });
            $("#ButtonInfo").attr('title', $("[id$=HiddenFieldInfoToolTip]").val())

            ClientMedicationOrder.GetMedicationList('<%=PanelMedicationListInformation.ClientID%>');
            PanelMedicationList = '<%=PanelMedicationListInformation.ClientID%>';
            InitializeComponents();

            ClientMedicationOrder.ClearDrug('<%=TextBoxStartDate.ClientID%>', '<%=TextBoxOrderDate.ClientID%>', '<%=TextBoxDrug.ClientID%>', '<%=TextBoxSpecialInstructions.ClientID%>', '<%=DropDownListDxPurpose.ClientID%>', '<%=DropDownListPrescriber.ClientID%>', document.getElementById('ButtonTitrate'), '<%=TextBoxDesiredOutcome.ClientID%>', '<%=TextBoxComments.ClientID%>');

            document.getElementById('<%=CheckBoxDispense.ClientID%>').checked = false;
            document.getElementById('<%=CheckBoxOffLabel.ClientID%>').checked = false;
            if (document.getElementById('<%=HiddenOrderDateTobeSet.ClientID%>').value == "Y") {
                document.getElementById('<%=TextBoxOrderDate.ClientID%>').value = today.format("MM/dd/yyyy");
            }
            ClientMedicationOrder.ClearTable('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');


            $create(Streamline.SmartClient.UI.TextBox, { 'ignoreEnterKey': true }, {}, {}, $get('<%=TextBoxComments.ClientID%>'));
            $create(Streamline.SmartClient.UI.TextBox, { 'ignoreEnterKey': true }, {}, {}, $get('<%=TextBoxDesiredOutcome.ClientID%>'));
            $create(Streamline.SmartClient.UI.TextBox, { 'ignoreEnterKey': true }, {}, {}, $get('<%=TextBoxSpecialInstructions.ClientID%>'));
            if (document.getElementById("txtButtonValue").value == "New Order") {
                if ($("[id$=RadioButtonPrintScript]").length > 0 && $("[id$=RadioButtonFaxToPharmacy]").length > 0)
                {
                    if($("[id$=RadioButtonPrintScript]")[0].checked == false && $("[id$=RadioButtonFaxToPharmacy]")[0].checked == false) 
                    {
                        if($("input[id$=HiddenFieldRadioToFax]").val() == "true")
                        {
                            $("[id$=RadioButtonFaxToPharmacy]").attr('checked', true);
                            MedicationPrescribe.SetPrintChartCopy('<%=RadioButtonFaxToPharmacy.ClientID%>', '<%=CheckBoxPrintChartCopy.ClientID%>', $("[id$=HiddenFieldChartCopy]").val());
                        }
                        else
                        {
                            $("[id$=RadioButtonPrintScript]").attr('checked', true);
                        }
                    } 
                }
            }
            if (document.getElementById("txtButtonValue").value.toUpperCase() == "COMPLETE") {
                document.getElementById('buttonInsert').style.display="none";
            }
            if(document.getElementById("txtButtonValue").value.toUpperCase() == "ADJUST") {
                document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_ButtonPrescribe").className = "btnimgmedium";
            } 
            //Added By PranayB w.r.t MU
            var OrderMethodType=document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenFieldOrderType").value.toUpperCase();
            if (OrderMethodType == "APPROVEWITHCHANGESCHANGEORDER"||OrderMethodType=="CHANGEAPPROVALORDER"){
                var SureScriptChangeRequestId= document.getElementById("HiddenFieldSureScriptChangeRequestId").value;
                ClientMedicationOrder.GetChangeMedicationOrderList(SureScriptChangeRequestId,ClientMedicationOrder.onSuccessChangeMedicationOrderList);
            }
        } catch(e) {
            alert(e);
        }
    }

    function SetPrescriberId() {
        try {
            $("input[id$=HiddenFieldPrescriber]")[0].value = "";
            $("input[id$=HiddenFieldPrescriber]")[0].value = $("select[id$=DropDownListPrescriber]").val();
            $("input[id$=HiddenFieldPrescriberName]")[0].value = $("select[id$=DropDownListPrescriber]")[0][$("select[id$=DropDownListPrescriber]")[0].selectedIndex].innerHTML;
            ClientMedicationOrder.FillDEANumber(document.getElementById('<%=DropDownListDEANumber.ClientID%>'));
            //  ClientMedicationOrder.SetDocumentDirty();
        } catch(ex) {
        }
    }

    function NotAcknowledge() {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        //2529
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
        DivErrorMessage.style.display = 'block';
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        //2529
        tableErrorMessage.style.display = 'block';
        LabelErrorMessage.innerText = 'Please acknowledge the drug interactions.';
    }


    //Description:Prevent user to prescribe if allergy type is A as pertas#9
    //Author:Pradeep
    //CreatedOn:Oct 27,2009

    function NoPrescribe() {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
        DivErrorMessage.style.display = 'block';
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        //2529
        tableErrorMessage.style.display = 'block';
        LabelErrorMessage.innerText = 'At least one of the drugs being prescribed interacts with a patient allergy. Please remove it from the list to proceed.';
    }

    //Function added by sonia
    //Validation added ref Task #56 MM1.5
    //In case Prescribers are different for Medications then Error Message will be displayed

    function PrescriberNotSame() {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        //2529
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
        DivErrorMessage.style.display = 'block';
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        //2529
        tableErrorMessage.style.display = 'block';
        LabelErrorMessage.innerText = 'Prescriber must be same for all medications on the order.';


    }

    //Code end over here

    //Function added by sonia
    //Validation added ref Task #56 MM1.5
    //Need to display some message on the Prescribe button event if values for Pharm+Stock+Samples = 0 for any of the instructions. 

    function MedicationsScriptDataValidation() {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        //2529
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
        DivErrorMessage.style.display = 'block';
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        //2529
        tableErrorMessage.style.display = 'block';
        LabelErrorMessage.innerText = 'All Medications in the Order must have Pharmacy+Sample+Stock greater than 0';


    }

    //Code end over here

    //Function added by Ankesh with ref to Task # 77 on 12/16/2008

    function InformationNotComplete() {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        //2529
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
        DivErrorMessage.style.display = 'block';
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        tableErrorMessage.style.display = 'block';
        LabelErrorMessage.innerText = 'One or more medications have missing information. Please review your medication list for medications flagged for missing information. ';
    }

    //Function added by Chandan
    //Validation added ref Task #2397 1.7.2 - Do not Allow Refill to Use Obsolete Diagnosis
    //Need to display some message on the Prescribe button event for Active DSM . 

    function ActiveDSMCode() {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        DivErrorMessage.style.display = 'block';
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        //2529
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
        tableErrorMessage.style.display = 'block';
        LabelErrorMessage.innerText = 'One or more refill medications has an obsolete dx/purpose. Update medications with current dx/purpose';

    }

    //Code end over here


    function ErrorUpdate() {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        //2529
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
        tableErrorMessage.style.display = 'block';
        DivErrorMessage.style.display = 'block';
        ImageError.style.display = 'block';
        ImageError.style.visibility = 'visible';
        LabelErrorMessage.innerText = 'Error While updating.';


    }

    function Insert_Click() {
        HeadingTabClick('#MedicationOrderMedicationList', '#HeaderItem_MedicationOrderMedicationList');
        var varValidate = Validate();
        if (varValidate == true) {
            document.getElementById('HiddenFieldOrderPageDirty').value = false;
            document.getElementById('buttonInsert').value = "Insert";
            document.getElementById('buttonInsert').disabled = true;
            document.getElementById('ImgSearch').style.display = "none";
            document.getElementById('ImgSearchIcon').style.display = "none";
        }
        return;
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
            var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
            var LabelGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage');
            var DivGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivGridErrorMessage');
            var ImageGridError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageGridError');
            var tableGridErrorMessage = document.getElementById('<%=tableGridErrorMessage.ClientID%>');

            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            tableErrorMessage.style.display = 'none';
            LabelGridErrorMessage.innerText = '';
            ImageGridError.style.visibility = 'hidden';
            ImageGridError.style.display = 'none';
            tableGridErrorMessage.style.display = 'none';

            if (document.getElementById('<%=TextBoxOrderDate.ClientID%>').value == '') {
                tableErrorMessage.style.display = 'block';
                DivErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please enter Order Date.';
                return false;
            }
            var _OrderDate = new Date(document.getElementById('<%=TextBoxOrderDate.ClientID%>').value);
            var _TodaysDate = new Date(new Date().getMonth() + 1 + '/' + new Date().getDate() + '/' + new Date().getYear());
            if (_OrderDate < _TodaysDate) {
                //2529
                tableErrorMessage.style.display = 'block';
                DivErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Order date can not be in the past.';
                return false;
            }

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
                tableErrorMessage.style.display = 'block';
                DivErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please enter a drug name.';
                return false;
            }
           
            if(document.getElementById("ComboBoxDrugDD").value == "Xyrem"){
                document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_CheckboxIncludeOnPrescription").checked= true;
                ClientMedicationOrder.ChangeOrderPageCommentText('Control_ASP.usercontrols_clientmedicationorder_ascx_LabelCommentText','Control_ASP.usercontrols_clientmedicationorder_ascx_CheckboxIncludeOnPrescription','Comment','Note to Pharmacy');
                if((document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_CheckboxIncludeOnPrescription").checked == false) || (document.getElementById("Control_ASP.usercontrols_clientmedicationorder_ascx_TextBoxComments").value == "") ){
                    tableErrorMessage.style.display = 'block';
                    DivErrorMessage.style.display = 'block';
                    ImageError.style.display = 'block';
                    ImageError.style.visibility = 'visible';
                    LabelErrorMessage.innerText = 'Prescriptions for GHB require a note on medical need, please enter notes to pharmacy.';
                    return false;
                }
            }
            if (document.getElementById('<%=DropDownListPrescriber.ClientID%>').value == '-1' || document.getElementById('<%=DropDownListPrescriber.ClientID%>').value == "") {
                //2529
                tableErrorMessage.style.display = 'block';
                DivErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please select Prescriber.';
                return false;
            }

            if (document.getElementById('<%=HiddenFieldDxPurposeNotMandatory.ClientID%>').value == "N" && (document.getElementById('<%=DropDownListDxPurpose.ClientID%>').value == "-1" || document.getElementById('<%=DropDownListDxPurpose.ClientID%>').value == "")) {
                tableErrorMessage.style.display = 'block';
                DivErrorMessage.style.display = 'block';
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please select Dx/Purpose.';
                return false;
            }

            if (document.getElementById('<%=CheckBoxDispense.ClientID%>').checked == true) {
                document.getElementById('<%=HiddenMedicationDAW.ClientID%>').value = 'Y';
            } else {
                document.getElementById('<%=HiddenMedicationDAW.ClientID%>').value = 'N';
            }
            if (document.getElementById('<%=CheckBoxOffLabel.ClientID%>').checked == true) {
                document.getElementById('<%=HiddenMedicationOffLabel.ClientID%>').value = 'Y';
            } else {
                document.getElementById('<%=HiddenMedicationOffLabel.ClientID%>').value = 'N';
            }
            if (document.getElementById('<%= CheckboxIncludeOnPrescription.ClientID %>').checked == true) {
                document.getElementById('<%=HiddenFieldOnPrescription.ClientID%>').value = 'Y';
            } else {
                document.getElementById('<%=HiddenFieldOnPrescription.ClientID%>').value = 'N';
            }
            if (document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxPermitChanges').checked == true) {
                document.getElementById('<%=HiddenPermitChangesByOtherUsers.ClientID%>').value = 'Y';
            } else {
                document.getElementById('<%=HiddenPermitChangesByOtherUsers.ClientID%>').value = 'N';
            }
            
            ClientMedicationOrder.FillMedicationRow('<%= ClientID + ClientIDSeparator %>tableMedicationOrder', '<%= HiddenMedicationNameId.ClientID %>', '<%= HiddenExternalMedicationNameId.ClientID %>','<%= DropDownListDxPurpose.ClientID %>', '<%= DropDownListPrescriber.ClientID %>', '<%= TextBoxOrderDate.ClientID %>', '<%= TextBoxSpecialInstructions.ClientID %>', '<%= HiddenMedicationName.ClientID %>', '<%= ClientID + ClientIDSeparator %>LabelErrorMessage', '<%= ClientID + ClientIDSeparator %>DivErrorMessage', '<%= ClientID + ClientIDSeparator %>ImageError', '<%= PanelMedicationListInformation.ClientID %>', '<%= HiddenRowIdentifier.ClientID %>', '<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage', '<%= ClientID + ClientIDSeparator %>DivGridErrorMessage', '<%= ClientID + ClientIDSeparator %>ImageGridError', '<%= HiddenMedicationDAW.ClientID %>', '<%= TextBoxComments.ClientID %>', '<%= TextBoxDesiredOutcome.ClientID %>', '<%= HiddenMedicationOffLabel.ClientID %>', '<%= tableErrorMessage.ClientID %>', '<%= tableGridErrorMessage.ClientID %>', '<%= HiddenPermitChangesByOtherUsers.ClientID %>', '<%= HiddenFieldOnPrescription.ClientID %>', '<%= DropDownListCoverage.ClientID %>', '<%= CheckBoxVerbalOrderReadBack.ClientID %>');
            $("#ComboBoxDrugDDDiv").attr('disabled', false);
        } catch(Err) {
            alert("Error:" + Err.message);
        }
    }

    //Modified as ref to Task#86

    function SetId(MedicationNameId, MedicationName, MedicationId, ExternalMedicationNameId, ExternalMedicationId) {
        try {
            
            document.getElementById('buttonInsert').value = "Insert";
            document.getElementById('buttonInsert').disabled = false;
            document.getElementById('<%=HiddenMedicationNameId.ClientID%>').value = MedicationNameId;
            document.getElementById('<%= HiddenExternalMedicationNameId.ClientID %>').value = ExternalMedicationNameId;
            document.getElementById('<%=HiddenMedicationName.ClientID%>').value = MedicationName;
            document.getElementById('<%=HiddenMedicationId.ClientID%>').value = (!MedicationId) ? "" : MedicationId;
            document.getElementById('<%= HiddenExternalMedicationId.ClientID %>').value = (!ExternalMedicationId) ? "" : ExternalMedicationId;
            document.getElementById('<%=HiddenRowIdentifier.ClientID%>').value = "";
            document.getElementById('<%=HiddenTitrateMode.ClientID%>').value = "New";
            ClientMedicationOrder.ClearTable('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
            document.getElementById('ButtonTitrate').disabled = false;
            var table = document.getElementById('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
            var TextBoxSpecialInstructions = document.getElementById('<%= ClientID + ClientIDSeparator %>TextBoxSpecialInstructions');
            var TextBoxDesiredOutcome = document.getElementById('<%= ClientID + ClientIDSeparator %>TextBoxDesiredOutcome');
            var TextBoxComments = document.getElementById('<%= ClientID + ClientIDSeparator %>TextBoxComments');
            var CheckboxIncludeOnPrescription = document.getElementById('<%= ClientID + ClientIDSeparator %>CheckboxIncludeOnPrescription');
            var ClientNameLabel=document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_LabelClientName').textContent;
            var init = ClientNameLabel.indexOf('(');
            var fin = ClientNameLabel.indexOf(')');
            var clientId=ClientNameLabel.substr(init+1,fin-init-1)
            table.disabled = false;
            document.getElementById('buttonAddRows').disabled = false;
            document.getElementById('buttonClear').disabled = false;
            if (parseInt(MedicationNameId).toString() != "NaN") {
                for (var i = 0; i < table.rows.length; i++) {
                    if (i == 0 && MedicationId) {
                        ClientMedicationOrder.LoadDrugOrderTemplateForSelectedMedication(table.rows[i], MedicationNameId, MedicationId, i);
                    } else {
                        var row = table.rows[i];
                        var Strength = row.cells[1].getElementsByTagName("select")[0];
                        var Schedule = row.cells[5].getElementsByTagName("select")[0];
                        var ddlPotencyUnitCode = row.cells[10].getElementsByTagName("select")[0];
                        ClientMedicationOrder.FillPotencyUnitCodes(MedicationNameId, ddlPotencyUnitCode, null);
                        ClientMedicationOrder.FillStrength(MedicationNameId, Strength, null, null);
                        ClientMedicationOrder.FillScheduled(Schedule, null);
                        ClientMedicationOrder.FillMedicationRelatedInformation(MedicationId, clientId, TextBoxSpecialInstructions, TextBoxDesiredOutcome, TextBoxComments, CheckboxIncludeOnPrescription, null)
                        ClientMedicationOrder.ClearPharmacyComboList("#ComboBoxPharmacyDD_" + i, "#ComboBoxPharmacyDDList_" + i);
                    }
                }
                var DOB = document.getElementById('<%=HiddenFieldDrugInfo.ClientID%>').value;
                if (DOB != null && DOB != "" && DOB != '' && DOB != "NaN") {
                    ClientMedicationOrder.GetDrugInfo(MedicationNameId, DOB);
                }
                if (ExternalMedicationNameId != '' && parseInt(ExternalMedicationNameId).toString() != "NaN") {
                  
                    ClientMedicationOrder.GetFormularyInformation(ExternalMedicationNameId, ExternalMedicationId, ClientMedicationOrder.onSuccessFormularyInformation);
                }
                ClientMedicationOrder.GetClientEducationNDC(MedicationNameId, ClientMedicationOrder.onSuccessClientEducation);
            }
            document.getElementById('<%=DropDownListDxPurpose.ClientID%>').focus();

            if (parseInt(MedicationNameId).toString() != "NaN") {
                document.getElementById('ImgSearch').style.display = "block";
            } else {
                document.getElementById('ImgSearch').style.display = "none";
            }
        } catch(Err) {
            alert("Error:" + Err.message);
        }
    }

    function FillDrug(MedicationNameId, MedicationName) {
        try {
            ClientMedicationOrder.FillDrugDropDown(MedicationNameId, MedicationName);
        } catch(ex) {
        }
    }
    function OpenEducationMedicationCodes() {
        if ($('#ImgEducationStrengths').attr('preferredNDC')) {
            window.open("EducationInformationView.aspx?Type=NDC&NDCCode=" + $('#ImgEducationStrengths').attr('preferredNDC'));
        }
    }

    //Ref to Tasl#2590

    function DisplayErrorMessage(errormessage) {

        try {
            var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
            var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
            var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
            var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
            tableErrorMessage.style.display = 'block';
            DivErrorMessage.style.display = 'block';
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = errormessage;
        } catch(err) {
            alert("Error:" + Err.message);
        }
    }

    function Clear_Click(flagClearOrderDate) {
        if (flagClearOrderDate === undefined)
            flagClearOrderDate = true;
        if (flagClearOrderDate)
        { 
            ClientMedicationOrder.ClearDrug('<%=TextBoxStartDate.ClientID%>', '<%=TextBoxOrderDate.ClientID%>', '<%=TextBoxDrug.ClientID%>', '<%=TextBoxSpecialInstructions.ClientID%>', '<%=DropDownListDxPurpose.ClientID%>', '<%=DropDownListPrescriber.ClientID%>', null, '<%=TextBoxDesiredOutcome.ClientID%>', '<%=TextBoxComments.ClientID%>');
        }
        else
        {
            ClientMedicationOrder.ClearDrug('<%=TextBoxStartDate.ClientID%>', null, '<%=TextBoxDrug.ClientID%>', '<%=TextBoxSpecialInstructions.ClientID%>', '<%=DropDownListDxPurpose.ClientID%>', '<%=DropDownListPrescriber.ClientID%>', null, '<%=TextBoxDesiredOutcome.ClientID%>', '<%=TextBoxComments.ClientID%>');
        }
        //Code added by Loveena in Ref to Task#129 on 19-Dec-2008 
        document.getElementById('<%=CheckBoxDispense.ClientID%>').checked = false;
        document.getElementById('<%=CheckBoxOffLabel.ClientID%>').checked = false;
        //Code added by Loveena in ref to Task#32
        document.getElementById('<%= CheckboxIncludeOnPrescription.ClientID %>').checked = false;
        //Added by Pradeep as per task#3328 Start Over here
        document.getElementById('<%=LabelCommentText.ClientID%>').innerText = document.getElementById('<%=HiddenOrderPageCommentLabel.ClientID%>').value;
        //Added by Pradeep as per task#3328 End Over here
        ClientMedicationOrder.ClearTable('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        LabelErrorMessage.innerText = '';
        ImageError.style.visibility = 'hidden';
        ImageError.style.display = 'none';
        //2529
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
        tableErrorMessage.style.display = 'none';
        //Code added by Loveena in ref to task#159 on 13-jan-2009. 
        document.getElementById('HiddenFieldOrderPageDirty').value = false;
        
        var LabelGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage');
        var ImageGridError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageGridError');
        LabelGridErrorMessage.innerText = '';
        ImageGridError.style.visibility = 'hidden';
        ImageGridError.style.display = 'none';
        var tableGridErrorMessage = document.getElementById('<%=tableGridErrorMessage.ClientID %>');
        tableGridErrorMessage.style.display = 'none';
        document.getElementById('ImgSearch').style.display = "none";
        document.getElementById('ImgSearchIcon').style.display = "none";
        ClientMedicationOrder.ClearDrugComboList("#ComboBoxDrugDD", "#ComboBoxDrugDDList");
        document.getElementById('buttonInsert').value = "Insert";
        document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_Refills').innerText = 'Refills';
        $("#ComboBoxDrugDDDiv").attr('disabled', false);
        ClientMedicationOrder.GetMedicationList(PanelMedicationList);
    }

    function onDeleteClick(sender, e) {
        ClientMedicationOrder.DeleateFromList(e, '<%=PanelMedicationListInformation.ClientID%>');
        Clear_Click(false);
    }

    function onRadioClick(sender, e) {
        ClientMedicationOrder.ClearDrug('<%=TextBoxStartDate.ClientID%>', '<%=TextBoxOrderDate.ClientID%>', '<%=TextBoxDrug.ClientID%>', '<%=TextBoxSpecialInstructions.ClientID%>', '<%=DropDownListDxPurpose.ClientID%>', '<%=DropDownListPrescriber.ClientID%>', null, '<%=TextBoxDesiredOutcome.ClientID%>', '<%=TextBoxComments.ClientID%>');
        document.getElementById('<%=CheckBoxDispense.ClientID%>').checked = false;
        ClientMedicationOrder.ClearTable('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        LabelErrorMessage.innerText = '';
        ImageError.style.visibility = 'hidden';
        ImageError.style.display = 'none';
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID%>');
        tableErrorMessage.style.display = 'none';

        var LabelGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage');
        var ImageGridError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageGridError');
        LabelGridErrorMessage.innerText = '';
        ImageGridError.style.visibility = 'hidden';
        ImageGridError.style.display = 'none';
        var tableGridErrorMessage = document.getElementById('<%=tableGridErrorMessage.ClientID%>');
        tableGridErrorMessage.style.display = 'none';
        ClientMedicationOrder.RadioButtonParameters(e, '<%= TextBoxOrderDate.ClientID %>', '<%= TextBoxDrug.ClientID %>', '<%= TextBoxSpecialInstructions.ClientID %>', '<%= DropDownListDxPurpose.ClientID %>', '<%= DropDownListPrescriber.ClientID %>', '<%= ClientID + ClientIDSeparator %>tableMedicationOrder', '<%= HiddenRowIdentifier.ClientID %>', '<%= HiddenMedicationNameId.ClientID %>', '<%= HiddenMedicationName.ClientID %>', '<%= TextBoxStartDate.ClientID %>', 'CheckBoxDispense', '<%= TextBoxDesiredOutcome.ClientID %>', '<%= TextBoxComments.ClientID %>', 'CheckBoxOffLabel', 'CheckboxIncludeOnPRescription', '<%= HiddenOrderPageCommentLabel.ClientID %>', '<%= HiddenOrderPageCommentLabelIncludeOnPrescription.ClientID %>', '<%= LabelCommentText.ClientID %>');
    document.getElementById('buttonInsert').value = "Modify";
}

function ismaxlength(obj) {
    var mlength = obj.getAttribute ? parseInt(obj.getAttribute("maxlength")) : "";
    if (obj.getAttribute && obj.value.length > mlength)
        obj.value = obj.value.substring(0, mlength);
}

function CallUpdateButton() {
    <%= Page.GetPostBackEventReference(FindControl("ButtonUpdate")) %>;
}

    function CallDeleteMedicationsButton() {
        <%= Page.GetPostBackEventReference(FindControl("ButtonDeleteCurrentMedications")) %>;
    }


    ///<summary>
    ///<Author>Loveena</Author>
    ///<Description>Function to display Error Message if Prescribe Button is clicked before Insert Button</Description>
    ///<CreationDate>16 Nov 2008 </CreationDate>
    ///</summary>

    function InsertBeforePrescribe() 
    {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var LabelGridErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelGridErrorMessage');

        var _OrderDate = new Date(document.getElementById('<%=TextBoxOrderDate.ClientID%>').value);
        var _TodaysDate = new Date(new Date().getMonth() + 1 + '/' + new Date().getDate() + '/' + new Date().getYear());
        if (_OrderDate == 'NaN' || _OrderDate < _TodaysDate) {
            ClientMedicationOrder.ShowHideError('<%= ClientID + ClientIDSeparator %>LabelErrorMessage', '<%= ClientID + ClientIDSeparator %>DivErrorMessage', '<%= ClientID + ClientIDSeparator %>ImageError', 'Order date can not be before todays date.', '<%= tableErrorMessage.ClientID %>');
            return false;
        }
        $("input[id$=HiddenFieldDEANumber]").val("");
        
        $("input[id$=HiddenFieldDEANumber]").val($("select[id$=DropDownListDEANumber]").val());
        $("input[id$=HiddenFieldTempPrescriberId]").val($("select[id$=DropDownListPrescriber]").val())
        //  alert('DEANUmber-'+  $("input[id$=HiddenFieldDEANumber]").val() );
        if ((document.getElementById('HiddenFieldOrderPageDirty').value == 'false' || document.getElementById('HiddenFieldOrderPageDirty').value == '') && LabelErrorMessage.innerText == 'One or more medications does not have a current consent') {
            $("input[id$=HiddenFieldLocationId]").val("");
            $("input[id$=HiddenFieldLocationId]").val($("select[id$=DropDownListLocations]").val());
            $("input[id$=HiddenFieldScriptsPharmacyId]").val("");

            /* Code modified by Anto */
            //if ($("select[id$=DropDownListPharmacies]").val().toString() != "-1")
            //    $("input[id$=HiddenFieldScriptsPharmacyId]").val($("select[id$=DropDownListPharmacies]").val());
            if ($("[id$=HiddenField_PharmaciesId]")[0].value != "-1")
                $("input[id$=HiddenFieldScriptsPharmacyId]").val($("[id$=HiddenField_PharmaciesId]")[0].value);
            /* Code modified by Anto ends here */

            $("input[id$=HiddenFieldChangeOrderPharmacyId]").val("");
            $("input[id$=HiddenFieldRadioToFax]").val("");

            /* Code modified by Anto */
            //$("input[id$=HiddenFieldChangeOrderPharmacyId]").val($("select[id$=DropDownListPharmacies]").val());
            $("input[id$=HiddenFieldChangeOrderPharmacyId]").val($("[id$=HiddenField_PharmaciesId]")[0].value);
            $("input[id$=HiddenFieldRefillPharmacyName]").val($("[id$=HiddenField_PharmaciesName]")[0].value);
            /* Code modified by Anto ends here */

            $("input[id$=HiddenFieldRadioToFax]").val($("input[id$=RadioButtonFaxToPharmacy]")[0].checked);
            return MedicationPrescribe.ValidateInputs('Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListPharmacies', 'Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListLocations', 'Control_ASP.usercontrols_clientmedicationorder_ascx_RadioButtonFaxToPharmacy', 'Control_ASP.usercontrols_clientmedicationorder_ascx_RadioButtonPrintScript', 'Control_ASP.usercontrols_clientmedicationorder_ascx_DropDownListPrescriber');
        } else if (document.getElementById('HiddenFieldOrderPageDirty').value == 'true') {
            ClientMedicationOrder.ShowHideError('<%= ClientID + ClientIDSeparator %>LabelErrorMessage', '<%= ClientID + ClientIDSeparator %>DivErrorMessage', '<%= ClientID + ClientIDSeparator %>ImageError', 'Please either insert data into Medication List or discard the changes before Prescribing.', '<%= tableErrorMessage.ClientID %>');
                return false;
            }
        $("input[id$=HiddenFieldLocationId]").val("");
        $("input[id$=HiddenFieldLocationId]").val($("select[id$=DropDownListLocations]").val());
        $("input[id$=HiddenFieldScriptsPharmacyId]").val("");
        //--Start over hereCode Written By Pradeep as per task#3297
        $("input[id$=HiddenFieldChangeOrderPharmacyId]").val("");
        $("input[id$=HiddenFieldRadioToFax]").val("");

        /* Code modified by Anto */
        //$("input[id$=HiddenFieldChangeOrderPharmacyId]").val($("select[id$=DropDownListPharmacies]").val());
        $("input[id$=HiddenFieldChangeOrderPharmacyId]").val($("[id$=HiddenField_PharmaciesId]")[0].value);
        $("input[id$=HiddenFieldRefillPharmacyName]").val($("[id$=HiddenField_PharmaciesName]")[0].value);
        /* Code modified by Anto ends here */

        $("input[id$=HiddenFieldRadioToFax]").val($("input[id$=RadioButtonFaxToPharmacy]")[0].checked); //--End over hereCode Written By Pradeep as per task#3297
        /* Code modified by Anto */
        
        //if ($("select[id$=DropDownListPharmacies]").val().toString() != "-1")
        //    $("input[id$=HiddenFieldScriptsPharmacyId]").val($("select[id$=DropDownListPharmacies]").val());

        if ($("[id$=HiddenField_PharmaciesId]")[0].value != "-1")
            $("input[id$=HiddenFieldScriptsPharmacyId]").val($("[id$=HiddenField_PharmaciesId]")[0].value);
        /* Code modified by Anto ends here */
       
        if($("[id$=DropDownListPharmacies_I]").val()=="Select Pharmacy") // Added by PranayB w.r.t AHN SGL TASK# 251.
        {
            $("input[id$=HiddenFieldScriptsPharmacyId]").val('');
            $("input[id$=HiddenFieldPharmacyId]").val('');
        }

        return MedicationPrescribe.ValidateInputs('<%=DropDownListPharmacies.ClientID%>', '<%=DropDownListLocations.ClientID%>', '<%=RadioButtonFaxToPharmacy.ClientID%>', '<%=RadioButtonPrintScript.ClientID%>', '<%=DropDownListPrescriber.ClientID%>');
    }

    ////Added by Chandan on 26th Nov 2008 Task#74 Dynamic Grid List MM#1.7
    //Calling a javascript method to add new rows

    function AddSteps() {
        try {
            ClientMedicationOrder.AddMedicationSteps('false', null);
        } catch(e) {

        }
    }

    function FormatOrderDateEntered(datein) {
        var $datein = $(datein);
        if ($datein.val() == "") return "";
        var regExpressionDate = /([01]?[0-9])(\/?-?([01]?[0-9]{1,2}))(\/?-?([0-9]{2,4}))/;
        var dateMatch = $datein.val().match(regExpressionDate);
        if (dateMatch == null) {
            $datein.val("");
        } else {
            $datein.val(dateMatch[1] + '/' + dateMatch[3] + '/' + (dateMatch[5].length > 2 ? dateMatch[5] : '20' + dateMatch[5]));
            if (!isValidDate($datein)) $datein.val("");
        }
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

    //Added End by Chandan on 26th Nov 2008 Task#74 MM#1.7

    function OpenTitratePage() {
        if (document.getElementById("HiddenFieldGirdDirty").value == "false") {
            ClientMedicationOrder.ClearTable('<%= ClientID + ClientIDSeparator %>tableMedicationOrder');
        }
        var ValidateDrug = TitrationValidation();
        if (ValidateDrug == true) {
            ClientMedicationOrder.ShowTitrationPage('<%=HiddenMedicationId.ClientID%>');
        }
        return;
    }

    function TitrationValidation() {
        var LabelErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%= ClientID + ClientIDSeparator %>DivErrorMessage');
        var ImageError = document.getElementById('<%= ClientID + ClientIDSeparator %>ImageError');
        LabelErrorMessage.innerText = '';
        ImageError.style.visibility = 'hidden';
        ImageError.style.display = 'none';
        //2529
        var tableErrorMessage = document.getElementById('<%=tableErrorMessage.ClientID %>');
        tableErrorMessage.style.display = 'none';

        if (document.getElementById('<%=HiddenMedicationNameId.ClientID%>').value == "") {
            //2529
            tableErrorMessage.style.display = 'block';
            DivErrorMessage.style.display = 'block';
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = 'Please select Drug.';
            return false;
        }

        if ((document.getElementById('<%=DropDownListDxPurpose.ClientID%>').value == "-1" || document.getElementById('<%=DropDownListDxPurpose.ClientID%>').value == "") && $('[id$=HiddenFieldDxPurposeNotMandatory]').val().toUpperCase() != "Y") {
            //2529
            tableErrorMessage.style.display = 'block';
            DivErrorMessage.style.display = 'block';
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = 'Please select Dx/Purpose.';
            return false;
        }

        if (document.getElementById('<%=DropDownListPrescriber.ClientID%>').value == '-1') {
            tableErrorMessage.style.display = 'block';
            DivErrorMessage.style.display = 'block';
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = 'Please select Prescriber.';
            return false;
        }
        //Modified in ref to Task#86 for Editable Drop down 
        //if(document.getElementById('<%=TextBoxDrug.ClientID%>').value=='')
        if (!$('#ComboBoxDrugDD').val()) {
            //2529
            tableErrorMessage.style.display = 'block';
            DivErrorMessage.style.display = 'block';
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.innerText = 'Please select a Drug.';
            return false;
        }

        return true;
    }

    function openPharmacySearchForprintOnPage() {
        MedicationPrescribe.openPharmacySearchForprint('<%= DropDownListPharmacies.ClientID %>');
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

    function HeadingTabClick(headerId, tabClicked) {
        var $headingMedicationListSection = $("#HeadingMedicationListSection");
        $("Table.HeaderTab", $headingMedicationListSection).removeClass("ActiveTab");
        $(tabClicked, $headingMedicationListSection).addClass("ActiveTab");
        var $medicationListContainer = $("#MedicationListContainer", $headingMedicationListSection);
        $("tr.HeaderTabContent", $medicationListContainer).hide();
        var $showtabdata = $("tr" + headerId, $medicationListContainer);
        $showtabdata.show();
        ExpandMedicationListSection(headerId, $medicationListContainer);
    }

    function ExpandMedicationListSection(headerId, $medicationListContainer) {
        $medicationListContainer = $medicationListContainer || $("#MedicationListContainer");
        var smartCareRxFooter = $("#SmartCareRxFooter");
        var $panel;
        switch (headerId) {
            case "#MedicationOrderMedicationList":
                var $panel = $("#MedicationListInformation", $medicationListContainer);
                break;
            case "#MedicationOrderFormulary":
                var $panel = $("#FormularyInformationTabData", $medicationListContainer);
                break;
            case "#MedicationOrderChangeList":
                var $panel = $("#ChangeMedicationListInformation", $medicationListContainer);
                break;

            default:
                return;
                break;
        }
        if ($panel.length <= 0) return;
        var windowSize = $(window).height();
        var extraRoom = windowSize - ($("#SmartCareRxFooter").offset().top + $("#SmartCareRxFooter").height() + (parseInt($("#SmartCareRxFooter").css('margin-top'), 10) || 0));
        var newSize = $panel.height() + extraRoom;
        newSize = newSize > 250 ? newSize : 250;
        if (newSize > $panel.children().height()) {
            $panel.height(($panel.children().height() + 20));
        } else {
            $panel.height(newSize);
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
</script>

<script language="javascript" type="text/javascript">
    //--Function Added by Pradeep as per task#31
    function SetHiddenFieldDirty() {
        if (document.getElementById('HiddenFieldOrderPageDirty') != null) {
            document.getElementById('HiddenFieldOrderPageDirty').value = true;
        }
    }

</script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<div>
    <table width="100.7%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td align="left" style="width: 78%;" class="header">
                <asp:Label ID="LabelTitleBar" runat="server" Visible="true" Style="color: white;"
                    Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
            </td>
            <td align="middle" style="width: 2%; display: none;" class="header" onclick="ShowKeyPhrasePage();return false;">
                 <a href="#">
                    <img src="App_Themes/Includes/Images/add-key-icon.png" title="Add Key Phrases" /></a> </td>
            <td align="right" id="KeyPhrases" runat="server" style="width: 1%;" class="header">
                <a href="#" id="aTag" runat="server" onclick="ShowUseKeyPhrasePage();return false;">
                    <img src="App_Themes/Includes/Images/key.png" title="Key Phrases" /></a>
            </td>
       <td align="middle" style="width: 5%;" class="header">
                <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" runat="server" OnClientClick="redirectToStartPage();this.disabled=true; return false;"
                    Style="display: none; color: white;"></asp:LinkButton>
            </td>
            <td align="middle" style="width: 2%; padding-right: 0.7%;" class="header">
                <asp:ImageButton ID="LinkButtonLogout" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Text="" runat="server" OnClick="LinkButtonLogout_Click"
                    TabIndex="5" />
            </td>

        </tr>
        <tr>
            <td colspan="5" style="height: 1pt; border-bottom: #5b0000 1px solid;"></td>
        </tr>

    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="width: 100%">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 30%">
                            <asp:Label ID="Label1" runat="server" Visible="true" CssClass="TittleBarBase" Text="New Medication Order"></asp:Label>
                        </td>
                       
                       <td>
                            <table style="float:right" cellpadding="0" cellspacing="0" border="0">
                                <tbody>
                                    <tr>
                                        <td align="right">
                                            <img width="7" height="24" alt="" src="App_Themes/Includes/Images/top_options_left_corner.gif">
                                        </td>
                                        <td class="top_options_bg">
                                            <table>
                                                <tr>
                                                    <td>
                                            <asp:Button ID="ButtonDeleteCurrentMedications" CssClass="btnimgexsmall" runat="server"
                                                Text="Delete" OnClick="ButtonDeleteCurrentMedications_Click"
                                                Visible="false" />  &nbsp;
                                                        </td>
                                                   
                                                    <td>
                                                                        <asp:ImageButton ID="ButtonUpdate" runat="server" ToolTip="Update" Visible="false" OnClick="ButtonUpdate_Click" ImageUrl="~/App_Themes/Includes/Images/save_icon.gif" /> &nbsp;                                          
                          </td>
                                                    <td>
                            <asp:Button ID="ButtonPrescribe" runat="server"
                                Text="Prescribe" OnClientClick=" return InsertBeforePrescribe(); "
                                OnClick="ButtonPrescribe_Click" />&nbsp;
  </td>
                                                    <td>
                            <asp:Button runat="server" ID="ButtonQueueOrder" Text="Queue Order" SkinID="BtnSmall"
                                OnClientClick=" return InsertBeforePrescribe(); " OnClick="ButtonQueueOrder_Click" />
                                                    <td>
                                                        &nbsp;                         
                      </td>
                                                    <td style="background-color:#bdbdbd; width:1px;"></td> 
                                                    <td></td>
                                                    <td>
                             <asp:ImageButton ID="ButtonClose" runat="server" ToolTip="Cancel" OnClientClick=" ClientMedicationOrder.CloseButtonClick(); return false;" ImageUrl="~/App_Themes/Includes/Images/close_icon.gif" />
                                           </td>
                                                       <td></td>
                                                    <td style="background-color:#bdbdbd; width:1px;"></td> 
                                                         </tr>
                                                </table>
                                                </td>
                                        <td>
                                            <img width="7" height="24" alt="" src="App_Themes/Includes/Images/top_options_right_corner.gif">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>

                </table>
            </td>
        </tr>
        <tr>
            <td align="left">
                <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif">
            </td>
        </tr>
        <tr>
            <td style="padding-left: 8px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td align="left">
                            <asp:Label ID="LabelClientName" runat="server"></asp:Label>
                        </td>

                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="width: 100%; padding-left: 8px;">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                        <td colspan="9">
                            <table id="tableErrorMessage" runat="server" style="display: none" border="0" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td valign="middle">
                                        <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif"
                                            Style="display: none;" />
                                    </td>
                                    <td valign="middle">&nbsp;
                                        <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError"
                                            BackColor="#DCE5EA"></asp:Label>&nbsp;
                                    </td>
                                    <td valign="middle">
                                        <div id="DivErrorMessage" runat="server" style="display: none; height: 12px; width: 22px;">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <UI:Heading ID="Heading1" runat="server" HeadingText="Order"></UI:Heading>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%" id="OrderHeader" runat="server">
                                <tr>
                                    <td>
                                        <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;"
                                            cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="1">
                                                        <tr>
                                                            <td class="RadioText" align="left" style="width: 2px">
                                                                <asp:RadioButton ID="RadioButtonFaxToPharmacy" runat="server" GroupName="Print" AutoPostBack="false" />
                                                            </td>
                                                            <td class="RadioText" nowrap="nowrap">
                                                                <label class="SumarryLabel">
                                                                    Send Directly to Pharmacy</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table border="0" cellpadding="0" cellspacing="1">
                                                        <tr>
                                                            <td style="width: 50px">
                                                                <asp:Label ID="LabelPharmacy" runat="server" CssClass="labelFont" Text="Pharmacy"></asp:Label>
                                                            </td>
                                                            <td align="left" style="width: 100px; padding-left: 10px" nowrap="nowrap">
                                                                <asp:Panel ID="PanelDropDownListPharmacies" runat="server">
                                                                    <cc2:StreamlineDropDowns ID="DropDownListPharmacies" Width="350px"
                                                                        runat="server" EnableIncrementalFiltering="true" EnableSynchronization="False"
                                                                        EnableViewState="false" DropDownStyle="DropDownList" AddBlankRow="true"
                                                                        BlankRowText="Select Pharmacy" BlankRowValue="" SelectedIndex="0"
                                                                        bindautosaveevents="False" Font-Size="11px">
                                                                        <ClientSideEvents LostFocus="function(s, e) {                                                           
                                                          SetValueOfHiddenFields(this);
                                                         }"
                                                                            Init="function(s, e) { 
                                                            SetValuesOfDisclosedToNameDropdown(s,e);
                                                         }" />
                                                                    </cc2:StreamlineDropDowns>

                                                                    <asp:Label ID="LabelPharmacyName" runat="server" class="SumarryLabel" Style="display: none; margin-left: 5px; width: 350px;"
                                                                        Text="Pradeep"></asp:Label>
                                                                </asp:Panel>
                                                            </td>
                                                            <td align="left">
                                                                <input type="image" id="ImageSearch" runat="server" src="~/App_Themes/Includes/Images/search_icon.gif"
                                                                    onclick="openPharmacySearchForprintOnPage(); return false;" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" style="width: 100%;" align="left">
                                                    <input id="HiddenField_PharmaciesId" name="HiddenField_PharmaciesId" runat="server"
                                                        type="hidden" bindautosaveevents="True" />
                                                    <input id="HiddenField_PharmaciesName" name="HiddenField_PharmaciesName" runat="server"
                                                        type="hidden" bindautosaveevents="True" />
                                                    <input id="HiddenField_OrderingMethod" name="HiddenField_OrderingMethod" runat="server"
                                                        type="hidden" bindautosaveevents="True" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;"
                                            cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="0" cellspacing="2">
                                                        <tr>
                                                            <td align="left" nowrap="nowrap" class="RadioText">
                                                                <asp:RadioButton ID="RadioButtonPrintScript" runat="server" GroupName="Print" />
                                                            </td>
                                                            <td class="RadioText" nowrap="nowrap">
                                                                <label class="SumarryLabel">
                                                                    PrintScript</label>
                                                            </td>
                                                            <td align="left" valign="bottom" class="RadioText">
                                                                <asp:CheckBox ID="CheckBoxPrintDrugInformation" runat="server" />
                                                            </td>
                                                            <td class="RadioText" nowrap="nowrap">
                                                                <label class="SumarryLabel">
                                                                    Print Drug Information</label>
                                                            </td>
                                                            <td align="left" valign="bottom" nowrap="nowrap" class="RadioText">
                                                                <asp:CheckBox ID="CheckBoxPrintChartCopy" runat="server" />
                                                            </td>
                                                            <td class="RadioText" nowrap="nowrap">
                                                                <label class="SumarryLabel">
                                                                    Print Chart Copy</label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <table border="0" cellpadding="0" cellspacing="2">
                                                        <tr>
                                                            <td style="width: 5px">
                                                                <asp:Label ID="LabelPrinter" runat="server" CssClass="labelFont" Text="Printer"></asp:Label>
                                                            </td>
                                                            <td align="left" colspan="2" nowrap="nowrap">
                                                                <asp:DropDownList ID="DropDownListPrinterDeviceLocations" runat="server" Style="width: 350px"
                                                                    CssClass="ddlist">
                                                                </asp:DropDownList>
                                                            </td>
                                                            <td style="width: 10px;" valign="middle"></td>
                                                            <td align="left" nowrap="nowrap">
                                                                <asp:Label ID="LabelChartCopyPrinter" runat="server" Text="Chart Copy Printer" CssClass="labelFont"
                                                                    Style="display: none"></asp:Label>
                                                            </td>
                                                            <td align="left" nowrap="nowrap">
                                                                <asp:DropDownList ID="DropDownListChartCopyPrinter" runat="server" Style="display: none; width: 170px;">
                                                                </asp:DropDownList>
                                                            </td>


                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;"
                                cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="1" cellpadding="1">
                                            <tr>
                                                <td style="width: 61px;" class="labelFont">Prescriber
                                                </td>
                                                <td valign="middle">
                                                    <asp:DropDownList ID="DropDownListPrescriber" runat="server" Width="185px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 10px;" valign="middle"></td>
                                                <td style="width: 40px;" class="labelFont">DEA #
                                                </td>
                                                <td valign="middle">
                                                    <asp:DropDownList ID="DropDownListDEANumber" runat="server" Width="185px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 62px;" class="labelFont" valign="middle">Order Date
                                                </td>
                                                <td nowrap="nowrap" valign="middle">
                                                    <asp:TextBox ID="TextBoxOrderDate" runat="server" Width="70px" MaxLength="10" onchange="FormatOrderDateEntered(this);"></asp:TextBox>
                                                    <img id="Img2" src="App_Themes/Includes/Images/calender_grey.gif" class="imgcal" onclick="ClientMedicationOrder.CalShow( this, '<%=TextBoxOrderDate.ClientID%>')"
                                                        onmouseover="ClientMedicationOrder.CalShow( this, '<%=TextBoxOrderDate.ClientID%>')" alt="" align="middle" />&nbsp;
                                                </td>
                                                <td nowrap="nowrap">
                                                    <asp:Label ID="LabelPrescribingLocation" runat="server" CssClass="labelFont" Text="Prescribing Location"></asp:Label>
                                                    <asp:DropDownList ID="DropDownListLocations" runat="server" CssClass="ddlist" Width="170px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td colspan="1" nowrap="nowrap" style="width: 20px;" valign="middle" class="RadioText">
                                                    <input id="CheckBoxVerbalOrderReadBack" type="checkbox" runat="server" onclick="ClientMedicationOrder.ResetDrugComboList('#ComboBoxDrugDDList');" />
                                                </td>
                                                <td class="RadioText" colspan="1" nowrap="nowrap"  valign="middle">Verbal Order Read Back
                                                </td>

                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <UI:Heading ID="Heading3" runat="server" HeadingText="Medication" />
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="CheckBoxPermitChanges" runat="server" Text="Permit Changes By Other Users"
                                            CssClass="RadioText" />
                                    </td>

                                    <td>
                                        <input id="CheckBoxCompoundedMedication" type="checkbox" runat="server" onclick="CheckBoxCompoundedMedication();" />
                                    </td>
                                    <td>
                                        <span id="Span1" runat="server" class="labelFont">Compounded Medication</span>
                                    </td>
                                    <td>


                                        <asp:TextBox ID="TextBoxCompoundedMedication" runat="server" Width="255px" MaxLength="100">
                                        </asp:TextBox>
                                </tr>
                            </table>
                            <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;"
                                cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table border="0" cellspacing="1" cellpadding="1">
                                            <tr>
                                                <td style="width: 83px;" class="labelFont" valign="middle">Drug
                                                </td>

                                                <td colspan="2" nowrap="nowrap" valign="middle" style="width: 203px;">
                                                    <asp:TextBox ID="TextBoxDrug" runat="server" Width="164px" Style="height: 13px; position: absolute;"
                                                        Visible="false"></asp:TextBox>
                                                    <div id="ComboBoxDrugDDDiv" style="border: solid 1px #7b9ebd;" onclick=" ClientMedicationOrder.onClickDrugComboList(this, '#ComboBoxDrugDDList');">
                                                        <input type="text" id="ComboBoxDrugDD" value="" opid="" style="border: none; width: 160px; font-size: 11px; height: 18px"
                                                            onchange=" ClientMedicationOrder.onChangeDrugComboList(this, '#ComboBoxDrugDDList'); "
                                                            onblur=" ClientMedicationOrder.onBlurDrugComboList(this, '#ComboBoxDrugDDList'); "
                                                            onkeydown=" ClientMedicationOrder.onKeyDownComboList(event, '#ComboBoxDrugDDList'); " />
                                                        <div style="float: right; height: 18px; width: 19px;" class="ComboBoxDrugDDImage">&nbsp;</div>
                                                        <div style="float: right">
                                                            <img id="ImgEducationStrengths" style="cursor: pointer;" src="App_Themes/Includes/Images/Educationinfo.png" onclick="OpenEducationMedicationCodes()" />
                                                        </div>
                                                    </div>
                                                    <div id="ComboBoxDrugDDList" style="display: none; white-space: nowrap;"
                                                        class="combolist" isempty="true"
                                                        onclick=" ClientMedicationOrder.onSelectedDrugComboList(event, this, true); ">
                                                    </div>
                                                </td>
                                                <td colspan="1" nowrap="nowrap" style="width: 19px;" valign="middle">
                                                    <img id="ImgSearch" src="App_Themes/Includes/Images/search_icon.gif" style="cursor: pointer; display: none; visibility: hidden;"
                                                        onclick="javascript:ClientMedicationOrder.GetSystemReportsMedicationName('Medication -NewOrder-MedicationName');return false;"
                                                        align="middle" title="View Report" />
                                                </td>
                                                <td style="width: 88px;" class="labelFont">Dx/Purpose
                                                </td>
                                                <td style="width: 103px;" valign="middle">
                                                    <asp:DropDownList ID="DropDownListDxPurpose" runat="server" Width="200px" onclick="ClientMedicationOrder.ResetDrugComboList('#ComboBoxDrugDDList');">
                                                    </asp:DropDownList>
                                                </td>
                                                <td style="width: 20px;" valign="middle">
                                                    <img id="ImgSearchIcon" src="App_Themes/Includes/Images/search_icon.gif" style="cursor: pointer; display: none; visibility: hidden;"
                                                        onclick="javascript:ClientMedicationOrder.GetSystemReports('Medication -NewOrder-DiagnosisCode');return false;"
                                                        align="middle" title="View Report" />
                                                    <img id="ImgComments" src="App_Themes/Includes/Images/comment.png" style="display: none;" align="middle" />
                                                </td>
                                                 <td style="width: 90px;" class="labelFont">Active Coverage
                                                </td>
                                                <td style="width: 103px;" valign="middle">
                                                    <asp:DropDownList ID="DropDownListCoverage" runat="server" Width="200px">
                                                    </asp:DropDownList>
                                                </td>
                                             <td colspan="1" nowrap="nowrap" style="width: 20px;" valign="middle" class="RadioText">
                                                    <input id="CheckBoxDispense" type="checkbox" runat="server" onclick="ClientMedicationOrder.ResetDrugComboList('#ComboBoxDrugDDList');" />
                                                </td>
                                                <td class="RadioText" colspan="1" nowrap="nowrap" valign="middle">Dispense as Written
                                                </td>
                                                <td colspan="1" nowrap="nowrap" style="width: 82px" valign="middle" class="RadioText">&nbsp;<input id="CheckBoxOffLabel" type="checkbox" runat="server" title="Off Label"
                                                    tabindex="0" />
                                                </td>
                                                <td>
                                                    <span id="Span_OffLabel" runat="server" class="RadioText">Off Label</span>
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
                                        <table border="0" cellpadding="1" cellspacing="1">
                                            <tr>
                                                <td class="labelFont">
                                                    <asp:Label ID="LabelNote" runat="server" Text="Note"></asp:Label>
                                                </td>
                                                <td style="height: 24px">
                                                    <asp:TextBox ID="TextBoxSpecialInstructions" EnableTheming="false" runat="server" onclick="ClientMedicationOrder.ResetDrugComboList('#ComboBoxDrugDDList');"
                                                        TextMode="MultiLine" MaxLength="1000" Width="200px" CssClass="TextboxMultiline"></asp:TextBox>
                                                </td>
                                                <td style="height: 24px; width: 18px;"></td>
                                                <td class="labelFont">Desired Outcome
                                                </td>
                                                <td style="height: 24px; width: 176px;">
                                                    <asp:TextBox ID="TextBoxDesiredOutcome" EnableTheming="false" runat="server" TextMode="MultiLine" onclick="ClientMedicationOrder.ResetDrugComboList('#ComboBoxDrugDDList');"
                                                        MaxLength="1000" Width="200px" CssClass="TextboxMultiline"></asp:TextBox>
                                                </td>
                                                <td style="width: 18px;"></td>
                                                <td class="labelFont" style="width: 90px;">
                                                    <asp:Label ID="LabelCommentText" runat="server" Text="Comment"></asp:Label>
                                                </td>
                                                <td colspan="3" style="width: 205px;">
                                                    <asp:TextBox ID="TextBoxComments" EnableTheming="false" runat="server" TextMode="MultiLine" onclick="ClientMedicationOrder.ResetDrugComboList('#ComboBoxDrugDDList');"
                                                        MaxLength="1000" CssClass="TextboxMultiline" Width="98%"></asp:TextBox>
                                                </td>
                                                 <td colspan="1" class="RadioText">
                                                    <input id="CheckboxIncludeOnPrescription" type="checkbox" runat="server" title="Off Label" onclick="ClientMedicationOrder.ResetDrugComboList('#ComboBoxDrugDDList');" />
                                                </td>
                                                <td class="RadioText" colspan="1"  nowrap="nowrap">Include On Prescription
                                                </td>
                                                    <td align="right">
                                                    <img id="ButtonInfo" name="ButtonInfo" src="<%=WebsiteSettings.BaseUrl %>App_Themes/Includes/Images/info1.gif" title="<%=ToolTipTitle %>" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 6%;" class="MedicationTitrate">

                            <input type="button" id="ButtonTitrate" class="btnimgexsmall" onclick=" OpenTitratePage()"
                                value="Titrate..." tabindex="0" />

                        </td>
                        <td>
                            <asp:TextBox ID="TextBoxDrugInfo" Enabled="false" runat="server" Width="925px"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <table id="tblMain" runat="server" border="0" cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;">
                    <tr>
                        <td colspan="23" style="height: 126px">
                            <div style="height: 120px; overflow: auto;">
                                <table border="0" width="98%">
                                    <tr style="background-color: #dce5ea;">
                                        <td colspan="2">
                                            <div id="PlaceLabel" runat="server" visible="true">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <div id="PlaceHolder" runat="server" visible="true" style="overflow: auto">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>

                                            <input type="button" id="buttonAddRows" onclick="AddSteps()" value="More Steps"
                                                disabled="disabled" tabindex="0" class="btnimgexsmall" />

                                        </td>
                                        <td align="right">

                                            <input type="button" id="buttonInsert" onclick="Insert_Click()"
                                                value="Insert" tabindex="0" class="btnimgexsmall" />


                                            <input type="button" id="buttonClear" onclick="Clear_Click()" value="Clear"
                                                tabindex="0" class="btnimgexsmall" />

                                        </td>
                                    </tr>
                                </table>
                        </td>
                    </tr>
                </table>
                 </tr>
                </table>
</div>

                   
                <table id="tableGridErrorMessage" runat="server" style="display: none" border="0"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td valign="top">
                            <asp:Image ID="ImageGridError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif"
                                Style="display: none; vertical-align: middle" />
                        </td>
                        <td valign="top">
                            <asp:Label ID="LabelGridErrorMessage" runat="server" Style="vertical-align: middle"
                                CssClass="redTextError" BackColor="#DCE5EA" Height="18px"></asp:Label>
                        </td>
                        <td valign="top">
                            <div id="DivGridErrorMessage" style="display: none; width: 19px;" runat="server">
                            </div>
                        </td>
                    </tr>
                </table>
<table style="width: 100%; margin-left: 5px;" id="HeadingMedicationListSection">
    <tbody>
        <tr>
            <td style="width: 100%;" valign="top">
                <UI:Heading ID="HeadingMedicationList" runat="server" HeadingDetailId="MedicationListDetailTabs"></UI:Heading>
                <div id="Div1" style="height: 160px; overflow: auto">
                    <table style="border: #dee7ef 3px solid;" cellspacing="0" cellpadding="0" id="MedicationListContainer" width="99.8%">
                        <tbody>
                            <tr id="MedicationOrderMedicationList" class="HeaderTabContent">
                                <td style="width: 100%;">
                                    <div id="MedicationListInformation" style="height: 140px; overflow: auto; border: 3px solid rgb(222, 231, 239);">
                                        <asp:Panel ID="PanelMedicationListInformation" runat="server" Height="140px" Width="100%" BackColor="White"
                                            BorderStyle="None" BorderColor="Black">
                                        </asp:Panel>
                                    </div>
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
                                                                    onclick="ClientMedicationOrder.SelectDaysOfWeekClick()" />
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
                            <tr id="MedicationOrderFormulary" style="display: none;" class="HeaderTabContent">
                                <td>Loading...</td>
                            </tr>
                            <tr id="MedicationOrderChangeList" style="display: none;" class="HeaderTabContent">
                                <td>Loading...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
    </tbody>
</table>
<table>
       
        <tr>
            <td style="width: 872px">
                <input id="HiddenMedicationNameId" type="hidden" runat="server" />
                <input id="HiddenFieldUserId" type="hidden" runat="server" />
                <input id="HiddenFieldIsPrescriber" type="hidden" runat="server" />
                <input id="HiddenFieldTemp" type="hidden" runat="server" />
                <input id="HiddenExternalMedicationNameId" type="hidden" runat="server" />
                <input id="HiddenOrderPageCommentLabel" type="hidden" runat="server" />
                <input id="HiddenOrderPageCommentLabelIncludeOnPrescription" type="hidden" runat="server" />
                <input id="HiddenMedicationDAW" type="hidden" runat="server" />
                <input id="HiddenMedicationOffLabel" type="hidden" runat="server" />
                <input id="HiddenFieldOnPrescription" type="hidden" runat="server" />
                <input id="HiddenMedicationName" type="hidden" runat="server" />
                <input id="HiddenRowIdentifier" type="hidden" runat="server" />
                <input id="HiddenOrderDateTobeSet" type="hidden" runat="server" />
                <input id="HiddenFieldOrderPageDirty" type="hidden" />
                <input id="HiddenFieldGirdDirty" type="hidden" />
                <input id="HiddenFieldAddDays" type="hidden" />
                <input id="HiddenFieldOldStartDate" type="hidden" />
                <input id="HiddenFieldOriginalPharmaText" type="hidden" />
                <input id="HiddenFieldPharmatextStatus" type="hidden" />
                <input id="HiddenFieldEndDate" type="hidden" />
                <input id="HiddenFieldRowIndex" type="hidden" value="2" />
                <input id="HiddenMedicationId" runat="server" type="hidden" />
                <input id="HiddenExternalMedicationId" runat="server" type="hidden" />
                <input id="HiddenTitrateMode" runat="server" type="hidden" value="New" />
                <input id="HiddenAutoCalcallowed" type="hidden" runat="server" value="N" />
                <input id="HiddenPermitChangesByOtherUsers" runat="server" type="hidden" />
                <input id="HiddenFieldPrescriberId" runat="server" type="hidden" />
                <input id="HiddenFieldTempPrescriberId" runat="server" type="hidden" />
                <input type="hidden" id="HiddenFieldPrescriber" runat="server" />
                <input type="hidden" id="HiddenFieldPrescriberPermission" runat="server" />
                <input type="hidden" id="HiddenFieldTempPrescriberPermission" runat="server" />
                <input type="hidden" id="HiddenFieldDEANumber" runat="server" />
                <input type="hidden" id="HiddenFieldPrescriberName" runat="server" />
                <input type="hidden" id="HiddenRelativePath" runat="server" />
                <asp:HiddenField ID="HiddenFieldDrugInfo" runat="server" />
                <asp:HiddenField ID="HiddenFieldShowError" runat="server" />
                <asp:HiddenField ID="HiddenFieldAllFaxed" runat="server" />
                <asp:HiddenField ID="HiddenFieldStoredProcedureName" runat="server" />
                <asp:HiddenField ID="HiddenFieldReportName" runat="server" />
                <asp:HiddenField ID="HiddenPrinterDeviceLocations" runat="server" />
                <asp:HiddenField ID="HiddenFieldLocationId" runat="server" />
                <asp:HiddenField ID="HiddenFieldScriptsPharmacyId" runat="server" />
                <asp:HiddenField ID="HiddenFieldChartCopy" runat="server" />
                <asp:HiddenField runat="server" ID="HiddenFieldDxPurposeNotMandatory" />
                <asp:HiddenField ID="HiddenFieldSaveAsTemplate" runat="server" />
                <asp:HiddenField ID="HiddenFieldOverrideTemplate" runat="server" />
                <asp:HiddenField ID="HiddenFieldShowDosages" runat="server" />
                <asp:HiddenField runat="server" ID="HiddenFieldLoggedInStaffId" />
                <asp:HiddenField ID="HiddenFieldEnableRxPopUpAcknowledgement" runat="server" />
                <asp:HiddenField ID="HiddenFieldInfoToolTip" runat="server" />
                <asp:HiddenField ID="HiddenFieldPharmacyPrescriber" runat="server" />
                <asp:HiddenField ID="HiddenFieldRXShownoOfDaysOfWeekPopup" runat="server" />
                <a href="abc" id="testNewMedOrder" target="_blank"></a>
                <asp:TextBox ID="TextBoxStartDate" runat="server" Width="70px" MaxLength="10" Style="display: none"></asp:TextBox>
                <img id="ImgStartDate" src="App_Themes/Includes/Images/calender_grey.gif" class="imgcal" style="display: none"
                    onclick="ClientMedicationOrder.CalToBeShown( this, '<%=TextBoxStartDate.ClientID %>')" onmouseover="CalToBeShown( this, '<%=TextBoxStartDate.ClientID %>')"
                    alt="" visible="false" />
                <asp:HiddenField ID="HiddenFieldPharmacyId" runat="server" />
                <asp:HiddenField ID="HiddenFieldOrderType" runat="server" />
                <%--Added By Pranay w.r.t MeaningFull use--%>

            </td>
        </tr>
</table>

<asp:Button CssClass="btnimglarge" ID="ButtonSuggestedProtocol" Enabled="false" runat="server"
    Font-Size="11px" Height="25px" Text="Suggested Protocol..." Visible="False" /><div
        id="DivGridtest" runat="server">
    </div>
