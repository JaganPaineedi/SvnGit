<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PharmacySearch.aspx.cs" Inherits="PharmacySearch" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<%@ Register TagPrefix="UC" TagName="PharmacySearch" Src="~/UserControls/PharmacySearchList.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script language="javascript" src="App_Themes/Includes/JS/UserPreferences.js?rel=3_5_x_4_1" type="text/javascript"> </script>

<script language="javascript" type="text/javascript">

    function FillPharmacyList() {
        try {
            //Changed By Priya Ref:Task no:85
            $('[id$=HiddenCurrentPage]')[0].value = 0;                                 
            var LabelErrorMessage = document.getElementById('<%=LabelErrorMessage.ClientID%>');
            var ImageError = document.getElementById('<%=ImageError.ClientID%>');
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            document.getElementById('ButtonSelect').disabled = true;
            var HiddenCurrentPage = $('[id$=HiddenCurrentPage]')[0].value;
            FillPharmacySearchList('<%=TextBoxName.ClientID%>', '<%=TextBoxID.ClientID%>', '<%=TextBoxPhone.ClientID%>', '<%=TextBoxAddress.ClientID%>', '<%=TextBoxCity.ClientID%>', '<%=DropDownListState.ClientID%>', '<%=TextBoxZip.ClientID%>', '<%=TextBoxSureScriptsIdentifier.ClientID%>', '<%=TextBoxFax.ClientID%>','<%=TextBoxSpecialty.ClientID%>',  HiddenCurrentPage);
        } catch(ex) {
        }
    }

    function closePharmacyDiv(flag) {
        try {
            //added By Priya Ref: task 85 SDI Projects FY10 - Venture            
            if (parent.document.getElementById('HiddenPageName').value == 'PreferredPharmacies') {
                var DivSearch = parent.document.getElementById('DivSearch1');

                DivSearch.style.display = 'none';
                if (flag == "F")
                    ShowAgainPreferredPharmaciesDiv('<%=HiddenFieldPreferredDropDown1Value.ClientID%>', '<%=HiddenFieldPreferredDropDown2Value.ClientID%>');
                else {
                    var PharmacyName = parent.document.getElementById('HiddenFieldPharmacyNameAddress').value;
                    var PharmacyId = parent.document.getElementById('HiddenFieldPharmacyId').value;
                    var ExternalReferenceId = parent.document.getElementById('HiddenFieldExternalReferenceId').value;
                    ShowAgainPreferredPharmaciesDiv('<%=HiddenFieldPreferredDropDown1Value.ClientID%>', '<%=HiddenFieldPreferredDropDown2Value.ClientID%>', '<%=HiddenFieldImg.ClientID%>', PharmacyId, PharmacyName, ExternalReferenceId);
                }

            } else if (parent.document.getElementById('HiddenPageName').value == 'MedicationsPrescribe') {
                var DivSearch = parent.document.getElementById('DivSearch1');
                DivSearch.style.display = 'none';
                MedicationPrescribe.AddItemInPreferredPharmacy();

            } else {
                var DivSearch = parent.document.getElementById('DivSearchPharmacy');
                DivSearch.style.display = 'none';
            }
        } catch(e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }

    }

//3215

    function onRadioClickSearch(PharmacyId, PharmacyName, Fax, Active, ExternalReferenceId, SureScriptsPharmacyIdentifier) {         
        var pharmacyId = PharmacyId;
        //added By Priya Ref: task 85 SDI Projects FY10 - Venture
        var pharmacyname = PharmacyName;
        pharmacyname = pharmacyname.ReplaceAll("~", "'");
        var pharmacyFax = Fax;
        var pharmacyActive = Active;
        parent.document.getElementById('HiddenFieldPharmacyActive').value = pharmacyActive;
        parent.document.getElementById('HiddenFieldPharmacyFaxNo').value = pharmacyFax;
        parent.document.getElementById('HiddenFieldPharmacyNameAddress').value = pharmacyname;
        parent.document.getElementById('HiddenFieldPharmacyId').value = pharmacyId;
        parent.document.getElementById('HiddenFieldExternalReferenceId').value = ExternalReferenceId;
        parent.document.getElementById('HiddenFieldSureScriptIdentifier').value = SureScriptsPharmacyIdentifier;
        document.getElementById('ButtonSelect').disabled = false;
        document.getElementById('ButtonSelect').focus();

    }


    function Select_Click() {
        SetReturnValues(parent.document.getElementById('HiddenFieldPharmacyId').value, parent.document.getElementById('HiddenFieldExternalReferenceId').value);
    }

    //------------CreatedDate--------Feb. 05,2010
    //------------Author-------------Sahil 
    //This function will redirect to PharmacyManagement page with PharmacyId selected in Pharmacy Search page.

    function SetReturnValues(HiddenFieldPharmacyId, HiddenFieldExternalReferenceId) {

        try {
            var pharmacyId = HiddenFieldPharmacyId;
            
            //added By Priya Ref: task 85 SDI Projects FY10 - Venture
            if (parent.document.getElementById('HiddenPageName').value == 'PreferredPharmacies') {
                window.close();
                closePharmacyDiv("E");

            } else if (parent.document.getElementById('HiddenPageName').value == 'MedicationsPrescribe') {
                window.close();
                closePharmacyDiv("F");
            } else {
                //For Manage Pharmacies Page
                //added By Priya Ref:task No:85
                //For Merge Button
                if (parent.document.getElementById('HiddenFieldCheckButtonStatus').value == 'M') {

                    var ParentSelectedPharmacyId = parent.document.getElementById('HiddenFieldParentSelectedPharmacyId').value;
                    var LabelErrorMessage = document.getElementById('<%=LabelErrorMessage.ClientID%>');
                    var ImageError = document.getElementById('<%=ImageError.ClientID%>');
                    if (ParentSelectedPharmacyId == pharmacyId) {
                        var LabelErrorMessage = document.getElementById('<%=LabelErrorMessage.ClientID%>');
                        var ImageError = document.getElementById('<%=ImageError.ClientID%>');
                        LabelErrorMessage.innerText = '';
                        ImageError.style.visibility = 'hidden';
                        ImageError.style.display = 'none';
                        ImageError.style.display = 'block';
                        ImageError.style.visibility = 'visible';
                        LabelErrorMessage.innerText = ' Same Pharmacies Cannot be Merged. Choose another Pharmacy.';
                    } else {
                        LabelErrorMessage.innerText = '';
                        ImageError.style.visibility = 'hidden';
                        ImageError.style.display = 'none';
                        MergePharmacies(ParentSelectedPharmacyId, HiddenFieldPharmacyId);
                    }
                } else {
                    window.returnValue = pharmacyId;
                    window.close();
                    closePharmacyDiv("F");
                    parent.PharmacyManagement.SetRadioButton();
                }
            }
        } catch(e) {
        }

    }

    //added By Priya To Clear the Fields Ref: task 85 SDI Projects FY10 - Venture 

    function ClearFields() {

        document.getElementById('TextBoxName').value = "";
        document.getElementById('TextBoxPhone').value = "";
        document.getElementById('TextBoxID').value = "";
        document.getElementById('TextBoxCity').value = "";
        document.getElementById('DropDownListState').value = "0";
        document.getElementById('TextBoxAddress').value = "";
        document.getElementById('TextBoxSureScriptsIdentifier').value = "";
        document.getElementById('TextBoxZip').value = "";
        document.getElementById('TextBoxFax').value = "";
    }

//added By Priya

    function PagingPharmacyList(buttonText) {
        try {
            var NextDisabled = "";
            var PreviousisDisabled = "";
            if ($($('[id$=LinkButtonPrevious]')[0]).attr('disabled') == "disabled") {
                PreviousisDisabled = "disabled";
            }
            else {
                PreviousisDisabled = "enabled"
            }

            if ($($('[id$=LinkButtonNext]')[0]).attr('disabled') == "disabled") {
                NextDisabled = "disabled";
            }
            else {
                NextDisabled = "enabled"
            }
            var LabelErrorMessage = document.getElementById('<%=LabelErrorMessage.ClientID%>');
            var ImageError = document.getElementById('<%=ImageError.ClientID%>');
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            document.getElementById('ButtonSelect').disabled = true;
            if(buttonText=='Next')
                var HiddenCurrentPage = parseInt($('[id$=HiddenCurrentPage]')[0].value) + 1;
            else
                var HiddenCurrentPage = parseInt($('[id$=HiddenCurrentPage]')[0].value) - 1;

            if ((PreviousisDisabled != 'disabled' && HiddenCurrentPage != -1 && buttonText == "Previous") || NextDisabled != 'disabled' && buttonText == "Next") {
                $('[id$=HiddenCurrentPage]')[0].value = HiddenCurrentPage;
                PagingPharmacySearchList('<%=TextBoxName.ClientID%>', '<%=TextBoxID.ClientID%>', '<%=TextBoxPhone.ClientID%>', '<%=TextBoxAddress.ClientID%>', '<%=TextBoxCity.ClientID%>', '<%=DropDownListState.ClientID%>', '<%=TextBoxZip.ClientID%>', '<%=TextBoxSureScriptsIdentifier.ClientID%>', '<%=TextBoxFax.ClientID%>', '<%=TextBoxSpecialty.ClientID%>', HiddenCurrentPage);
            }
        } catch(ex) {
        }
    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Pharmacy Search</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">

    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script language="javascript" type="text/javascript" src="App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1"></script>

    <asp:ScriptManager runat="server" ID="SMP2">
        <Scripts>
            <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationPrescribe.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="~/App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="~/App_Themes/Includes/JS/UserPreferences.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        </Scripts>
        <Services>
            <asp:ServiceReference InlineScript="true" Path="~/WebServices/UserPreferences.asmx" />
            <asp:ServiceReference InlineScript="true" Path="~/WebServices/ClientMedications.asmx" />
        </Services>
    </asp:ScriptManager>
   <!-- scsc-->
            <div>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="middle" style="width: 16px">
                        <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif" Style="display: none;" />
                    </td>
                    <td valign="middle">
                        <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError" Height="18px"></asp:Label>
                    </td>
                </tr>
            </table>
            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; padding-left: 1%">
                <tr>
                    <td>
                        <UI:Heading ID="Heading2" runat="server" HeadingText="Search Criteria"></UI:Heading>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" width="99%">
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="toplt_curve" style="width: 6px"></td>
                                            <td class="top_brd" style="width: 99%"></td>
                                            <td class="toprt_curve" style="width: 6px"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>

                                <td class="mid_bg ltrt_brd">
                                    <table border="0" cellpadding="1" cellspacing="1" width="100%">
                                        <tr>
                                            <td class="labelFont" valign="middle">
                                                <asp:Label ID="labelName" CssClass="Label" runat="server" Text="Name"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="TextBoxName" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                                            </td>
                                            <td class="labelFont" valign="middle">
                                                <asp:Label ID="LabelId" runat="server" Text="ID" CssClass="Label" />
                                            </td>
                                            <td nowrap="nowrap" valign="middle">
                                                <asp:TextBox ID="TextBoxID" runat="server" Width="162px" MaxLength="4"></asp:TextBox>
                                            </td>
                                            <td class="labelFont" valign="middle">
                                                <asp:Label ID="LabelPhone" runat="server" Text="Phone #" CssClass="Label" />
                                            </td>
                                            <td nowrap="nowrap" valign="middle">
                                                <asp:TextBox ID="TextBoxPhone" runat="server" Width="162px" MaxLength="50"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 2px;" colspan="6"></td>
                                        </tr>
                                        <tr>
                                            <td class="labelFont" nowrap="nowrap" valign="middle">
                                                <asp:Label ID="labelAddress" runat="server" Text="Address" CssClass="Label" />
                                            </td>
                                            <td nowrap="nowrap" valign="middle">
                                                <asp:TextBox ID="TextBoxAddress" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                                            </td>
                                            <td class="labelFont" nowrap="nowrap" valign="middle">
                                                <asp:Label ID="LabelCity" runat="server" Text="City" CssClass="Label" />
                                            </td>
                                            <td nowrap="nowrap" valign="middle">
                                                <asp:TextBox ID="TextBoxCity" runat="server" Width="162px" MaxLength="30"></asp:TextBox>
                                            </td>
                                            <td class="labelFont" nowrap="nowrap" valign="middle">
                                                <asp:Label ID="LabelState" runat="server" Text="State" CssClass="Label" />
                                            </td>
                                            <td valign="middle">
                                                <asp:DropDownList ID="DropDownListState" runat="server" Width="162px" CssClass="ddlist">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 2px;" colspan="6"></td>
                                        </tr>
                                        <tr>
                                            <td class="labelFont" nowrap="nowrap" valign="middle">
                                                <asp:Label ID="LabelSureScriptsIdentifier" runat="server" Text="NCPDP Number"
                                                    CssClass="Label" />
                                            </td>
                                            <td nowrap="nowrap" valign="middle">
                                                <asp:TextBox ID="TextBoxSureScriptsIdentifier" runat="server" Width="200px" MaxLength="35"></asp:TextBox>
                                            </td>
                                            <td class="labelFont" nowrap="nowrap">
                                                <asp:Label ID="lableFax" runat="server" Text="Fax #" CssClass="Label" />
                                            </td>
                                            <td nowrap="nowrap" valign="middle">
                                                <asp:TextBox ID="TextBoxFax" runat="server" Width="162px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td class="labelFont" nowrap="nowrap" valign="middle">
                                                <asp:Label ID="labelZip" runat="server" Text="Zip" CssClass="Label" />
                                            </td>
                                            <td nowrap="nowrap" valign="middle">
                                                <asp:TextBox ID="TextBoxZip" runat="server" Width="162px" MaxLength="12"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 2px;" colspan="6"></td>
                                        </tr>
                                        <tr>
                                            <td class="labelFont" nowrap="nowrap" valign="middle">
                                                <asp:Label ID="Label1" runat="server" Text="Specialty"
                                                    CssClass="Label" />
                                            </td>
                                            <td nowrap="nowrap" valign="middle" colspan="2">
                                                <asp:TextBox ID="TextBoxSpecialty" runat="server" Width="100%"></asp:TextBox>
                                            </td>
                                            <td colspan="3">
                                                <table>
                                                    <tr>
                                                        <td style="width: 80%"></td>
                                                        <td align="right" style="width: 10%">
                                                            <input type="button" id="buttonSearch" class="btnimgexsmall" onclick="FillPharmacyList();"
                                                                value="Search" tabindex="0" runat="server" />
                                                        </td>
                                                        <td align="right" style="width: 5%">
                                                            <input type="button" id="buttonClear" class="btnimgexsmall" value="Clear" tabindex="1"
                                                                onclick="ClearFields();" />
                                                        </td>
                                                        <td></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>

                                    </table>
                                </td>

                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td class="botlt_curve" style="width: 6px"></td>
                                            <td class="bot_brd" style="width: 99%"></td>
                                            <td class="botrt_curve" style="width: 6px"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>

                        </table>
                    </td>
                </tr>
            </table>
            <table>
            </table>
        <table cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <UI:Heading ID="Heading1" runat="server" HeadingText="Records Found"></UI:Heading>
                </td>
            </tr>
        </table>
        <table width="100%" style="border: #dee7ef 3px solid; height: 200px; width: 100%;" cellspacing="0" cellpadding="0">
            <tr>
                <td colspan="2">
                    <UC:PharmacySearch ID="PharmacySearchList" runat="server"></UC:PharmacySearch>
                </td>
            </tr>
        </table>
        <table width="100%">
            <tr>
                <td align="right" style="width: 50%">
                    <asp:Button ID="ButtonSelect" runat="server" Text="Select" OnClientClick="Select_Click(); return false;"
                        disabled="disabled" CssClass="btnimgexsmall" />
                </td>
                <td align="left" style="width: 50%">
                    <asp:Button ID="ButtonCancel" runat="server" Text="Cancel" OnClientClick="closePharmacyDiv('F');return false;"
                        CssClass="btnimgexsmall" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:HiddenField ID="HiddenFieldImg" runat="server" />
                    <asp:HiddenField ID="HiddenFieldPreferredDropDown1Value" runat="server" />
                    <asp:HiddenField ID="HiddenFieldPreferredDropDown2Value" runat="server" />  
                    <input type="hidden" id="HiddenCurrentPage" value="0" runat="server" />  
                    <input type="hidden" id="HiddenFieldSortingDirection" value="Asc" />                    
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>