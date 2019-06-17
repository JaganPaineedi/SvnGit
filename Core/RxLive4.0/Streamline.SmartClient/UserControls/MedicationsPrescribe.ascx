<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedicationsPrescribe.ascx.cs"
    Inherits="Streamline.SmartClient.UI.UserControls_MedicationsPrescribe" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register TagPrefix="UI" TagName="MedicationList" Src="~/UserControls/MedicationList.ascx" %>
<asp:ScriptManagerProxy runat="server" ID="SMP2">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationPrescribe.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>
<!-- Main Table-->

<script type="text/javascript">
    $(document).ready(function () {
        var a;
        var drugsWithoutCheckboxCount;
        $('[id$=ButtonNewOrder]').attr("disabled", true);
        $("#DivHolderMain")[0].style.height = "548px";
        $("#PlaceHolderMain")[0].style.height = "548px";

        a = $("input[type='checkbox'][id^=ControlledSubstance]");
        drugsWithoutCheckboxCount = a.filter(":hidden").length;
        if (a.length == a.filter(":checked").length + drugsWithoutCheckboxCount || document.getElementById("Control_ASP.usercontrols_medicationsprescribe_ascx_ctl00_HiddenEPCSPermisions").value == "false" || document.getElementById('Control_ASP.usercontrols_medicationsprescribe_ascx_TextBoxOneTimePassword') == null) {
            $('[id$=ButtonNewOrder]').attr("disabled", false);
            if (document.getElementById('Control_ASP.usercontrols_medicationsprescribe_ascx_TextBoxOneTimePassword') == null) {
                $("input[type='checkbox'][id^=ControlledSubstance]").hide();
            }
        } else {
            $('[id$=ButtonNewOrder]').attr("disabled", true);
        }

        $("input[type='checkbox'][id^=ControlledSubstance]").change(function () {
            a = $("input[type='checkbox'][id^=ControlledSubstance]");
            drugsWithoutCheckboxCount = a.filter(":hidden").length;
            if (a.length == a.filter(":checked").length + drugsWithoutCheckboxCount || document.getElementById("Control_ASP.usercontrols_medicationsprescribe_ascx_ctl00_HiddenEPCSPermisions").value == "false" || document.getElementById('Control_ASP.usercontrols_medicationsprescribe_ascx_TextBoxOneTimePassword') == null) {
                $('[id$=ButtonNewOrder]').attr("disabled", false);
                if (document.getElementById('Control_ASP.usercontrols_medicationsprescribe_ascx_TextBoxOneTimePassword') == null) {
                    $("input[type='checkbox'][id^=ControlledSubstance]").hide();
                }
            } else {
                $('[id$=ButtonNewOrder]').attr("disabled", true);
            }
        });
    });
    if ('<%=OrderMedicationResult %>' != "") {
        try {
            if (parent.window.opener && parent.window.opener.RefreshTabPageContentFromExternalScreens != undefined) {
                parent.window.opener.RefreshTabPageContentFromExternalScreens('<%=OrderMedicationResult %>', '');
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    }

    function redirectToPharmacyPreview() {
        var url = '<%=ResolveUrl("../PreviewPharmacy.aspx")%>';
        window.open(url, '_blank', 'directories=0,titlebar=0,toolbar=0,location=0,status=0,menubar=0,scrollbars=no,resizable=no,width=1000,height=650');
    }

    function openPharmacySearchForprintOnPage() {
        MedicationPrescribe.openPharmacySearchForprint('<%= DropDownListPharmacies.ClientID %>');
    }

</script>

<table width="99%" border="0">
    <!-- Main Table First Row-->
    <tr>
        <td>
            <!-- Inner Table-->
            <table cellpadding="0" cellspacing="0" border="0" width="100.7%">
                <!-- Inner Table First Row-->
                <tr>
                    <td  class="header" style="width: 70%">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                        <asp:Label ID="Label1" runat="server" Visible="true" style ="color: white;" 
                            Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
                    </td>  
                            </tr>
                        </table>
                    </td>
                    <td style="width: 30%; padding-right:0.7%;" align="right" class="header">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right" style="width: 50%" >
                                    <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" runat="server" Style="display: none"
                                        OnClientClick="redirectToStartPage(); return false" ForeColor="White"></asp:LinkButton>
                                </td>
                                <td align="right" style="width: 50%">
                                    <%--<asp:LinkButton ID="LinkButtonLogout" Text="" runat="server" OnClick="LinkButtonLogout_Click"
                                        Style="display: none"><asp:Image ID="image_logoff" runat="server" 
                                            ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Style="border-width: 0px;" /></asp:LinkButton>--%>
                                     <asp:ImageButton ID="LinkButtonLogout" Style="display: none" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Text="" runat="server" OnClick="LinkButtonLogout_Click" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="height: 1pt; border-bottom: #5b0000 1px solid;" colspan="2"></td>
                </tr>
                <tr>
                     <td style="width: 300px">
                                    <asp:Label ID="LabelHeading" runat="server" CssClass="TittleBarBase" Text="Prescribe"></asp:Label>
                                </td>
                     <td align="right" nowrap="nowrap" style="padding-right:0.7%;">
                                    <asp:Button runat="server" ID="ButtonDeleteMedications" Font-Size="11px" 
                                        Visible="false" OnClick="ButtonDeleteMedications_Click" /><asp:Button
                                            ID="ButtonPatientContent" runat="server" Font-Size="11px" Text="Patient Consent"
                                             OnClientClick="javascript:redirectToPatientContentPage();return false;"
                                            Visible="false" />
                                    <%--Start Added By Anuj for Task Ref#3 0n 19Nov,2009 for setting up the value that Queue oder Button is clicked--%>
                                    <asp:Button runat="server" ID="ButtonQueueOrder" Font-Size="11px" Text="Queue Order"
                                        OnClick="ButtonQueueOrder_Click" Visible="false" />
                                    <asp:Button runat="server" ID="ButtonChangeOrder" Text="Change Order" Font-Size="11px"
                                       SkinId="BtnMedium"  OnClientClick="MedicationPrescribe.onChangeOrderClick();"/>
                                    <asp:Button
                                            ID="ButtonPharmacyPreview" runat="server" Font-Size="11px" Text="Pharmacy Preview..."
                                            SkinId="BtnMedium" OnClientClick="javascript:redirectToPharmacyPreview();return false;"
                                            Visible="true" />
                                    <%--End Added By Anuj for Task Ref#3 0n 19Nov,2009 for setting up the value that Queue oder Button is clicked--%>
                                    <asp:Button runat="server" ID="ButtonNewOrder" Font-Size="11px" Text="Prescribe"
                                        OnClick="ButtonNewOrder_Click" OnClientClick="this.disabled = true;parent.window.updatePageCalledFrom('MedicationPrescribe');MedicationPrescribe.ControlledSubstancesList();" UseSubmitBehavior="false" />
                                   <%-- <asp:Button ID="ButtonCancel" runat="server" Font-Size="11px" Text="Cancel"
                                        OnClientClick="MedicationPrescribe.CloseButtonClick1();return false;" />--%>
                         <asp:ImageButton ID="ButtonCancel" runat="server" ToolTip="Cancel" OnClientClick="MedicationPrescribe.CloseButtonClick1(); return false;" ImageUrl="~/App_Themes/Includes/Images/close_icon.gif" /> 
                                </td>
                </tr>
                  <tr>
            <td align="left" colspan="2">
                <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif" />
            </td>
        </tr>
                <tr>
                    <td colspan="2" style="padding-left:8px;">
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
                    <td style="padding-left:8px;">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td colspan="2">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td style="width: 72%">
                                                <span style="color: Red;">Prescription has not yet been submitted. To submit please click the Prescribe button</span>
                                            </td>
                                            <td style="width: 28%">
                                            
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" style="height: 30px; width: 3%" valign="middle">
                                    <img id="ImgError" src="App_Themes/Includes/Images/error.gif" alt="" style="display: none;" />&nbsp;
                                </td>
                                <td valign="middle" nowrap="nowrap">
                                    <asp:Label ID="LabelError" runat="server" class="redTextError"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left:8px;">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr style="height: 25px;" valign="top">
                                <td align="right" nowrap="nowrap">
                                    <asp:Label ID="LabelPassword" runat="server" Visible="false">Password</asp:Label>
                                    <asp:TextBox ID="TextBoxPassword" runat="server" Width="100px" TextMode="Password" Visible="false"></asp:TextBox>
                                     <asp:Label ID="LabelOneTimePassword" runat="server" Visible="false">Enter Token #/One Time Password</asp:Label>
                                    <asp:TextBox ID="TextBoxOneTimePassword" runat="server" Width="100px" Visible="false" onBlur="MedicationPrescribe.ValidInteger(this)"></asp:TextBox>
                                </td>
                            </tr>                         
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left:8px;">
                         <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="LEFT" style="width: 3%" valign="middle">
                                    <img id="ImagePrescribeGridError" src="App_Themes/Includes/Images/error.gif" alt="" style="visibility: hidden" />&nbsp;
                                </td>
                                <td valign="middle">
                                    <asp:Label ID="PrescribeGridErrorMessage" runat="server" CssClass="redTextError"></asp:Label>
                                </td>
                                <td></td>
                            </tr>
                         </table>
                    </td>
                </tr>
                <tr>
                    <!-- Inner Table Second Row Contains Client Personal Information Summary-->
                    <td colspan="2" style="display: none; padding-left:8px;">
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td valign="top" width="100%">
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"
                                                width="25%">
                                                <span class="labelFont">Name:&nbsp;</span> <a id="HyperLinkPatientName" runat="server"
                                                    class="LinkLabel"></a>
                                            </td>
                                            <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"
                                                width="25%">
                                                <span class="labelFont">DOB/Age:&nbsp;&nbsp;</span> <a id="HyperLinkPatientDOB" runat="server"
                                                    class="LinkLabel"></a>
                                            </td>
                                            <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap" valign="top"
                                                width="25%">
                                                <span class="labelFont">Race:&nbsp;</span> <a id="HyperLinkRace" runat="server" class="LinkLabel"></a>
                                            </td>
                                            <td class="SumarryLabel" nowrap="nowrap" style="white-space: nowrap; width: 34%;"
                                                valign="top">
                                                <span class="labelFont">Sex:&nbsp;</span> <a id="HyperLinkSex" runat="server" class="LinkLabel"></a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">&nbsp;
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr style="display: none;">
                    <!-- Inner Table Fourth Row Contains Script and Patient Information-->
                    <td colspan="2" style="padding-left:8px;">
                        <UI:Heading ID="Heading1" runat="server" HeadingText="Script and Patient Information" />
                        <table cellpadding="0" cellspacing="0" style="border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-bottom: #dee7ef 3px solid"
                            width="100%">
                            <tr>
                                <td>
                                    <table width="100%">
                                        <tr>
                                            <td valign="top">
                                                <asp:Label ID="LabelPrescribingLocation" runat="server" CssClass="labelFont" Font-Names="verdana"
                                                    Font-Size="8.25pt" Text="Prescribing Location"></asp:Label>
                                                <asp:DropDownList ID="DropDownListLocations" runat="server" CssClass="ddlist" Width="189px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                    <tr>
                                                        <td valign="top" style="width: 100px" nowrap="nowrap">
                                                            <asp:RadioButton ID="RadioButtonPrintScript" runat="server" AutoPostBack="false"
                                                                CssClass="SumarryLabel" GroupName="Print" Text="Print Script" />
                                                        </td>
                                                        <td align="left" valign="top" style="width: 250px" nowrap="nowrap">
                                                            <asp:Label ID="LabelPrinter" runat="server" CssClass="labelFont" Font-Names="verdana"
                                                                Font-Size="8.25pt" Text="Printer"></asp:Label>
                                                            &nbsp;<asp:DropDownList ID="DropDownListPrinterDeviceLocations" runat="server" CssClass="ddlist"
                                                                Height="19px" Width="180px">
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td align="left">
                                                            <asp:RadioButton ID="RadioButtonFaxToPharmacy" runat="server" GroupName="Print" Text="Fax"
                                                                CssClass="SumarryLabel" AutoPostBack="false" />
                                                        </td>
                                                        <td align="left">
                                                            <asp:RadioButton ID="RadioButtonElectronic" runat="server" GroupName="Print" Text="Electronic"
                                                                CssClass="SumarryLabel" AutoPostBack="false" />
                                                        </td>
                                                        <td style="width: 5px">
                                                            <asp:Label ID="LabelPharmacy" runat="server" CssClass="labelFont" Font-Names="verdana"
                                                                Font-Size="8.25pt" Text="Pharmacy"></asp:Label>
                                                        </td>
                                                        <td style="width: 2px"></td>
                                                        <td align="left" style="width: 100px" nowrap="nowrap">
                                                            <asp:Panel ID="PanelDropDownListPharmacies" runat="server">
                                                                <asp:DropDownList ID="DropDownListPharmacies" runat="server" Style="width: 350px"
                                                                    CssClass="ddlist">
                                                                </asp:DropDownList>
                                                            </asp:Panel>
                                                        </td>
                                                        <td align="left">
                                                            <input type="image" id="ImageSearch" runat="server" src="~/App_Themes/Includes/Images/search_icon.gif"
                                                                onclick='openPharmacySearchForprintOnPage(); return false;' />
                                                        </td>
                                                        <%-- added By Priya dated 4th Feb 2010--%>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <%--Start Added By Pradeep as per task#23--%>
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                    <tr>
                                                        <td align="left" valign="top" style="width: 2%" nowrap="nowrap">
                                                            <asp:CheckBox ID="CheckBoxPrintDrugInformation" runat="server" />
                                                        </td>
                                                        <td style="width: 15%">
                                                            <span class="Label">Print Drug Information</span>
                                                        </td>
                                                        <td style="width: 2%" nowrap="nowrap">
                                                            <asp:CheckBox ID="CheckBoxPrintChartCopy" runat="server" />
                                                        </td>
                                                        <td style="width: 15%">
                                                            <span class="Label">Print Chart Copy</span>
                                                        </td>
                                                        <td align="left" style="width: 120px" nowrap="nowrap">
                                                            <asp:Label ID="LabelChartCopyPrinter" runat="server" Text="Chart Copy Printer" CssClass="labelFont"
                                                                Font-Names="verdana" Font-Size="8.25pt" Style="display: none"></asp:Label>
                                                        </td>
                                                        <td style="width: 2px"></td>
                                                        <td style="width: 480px">
                                                            <asp:DropDownList ID="DropDownListChartCopyPrinter" runat="server" Style="display: none; width: 180px">
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
                    <td colspan="2" style="padding-left:8px;">
                        <table cellpadding="0" cellspacing="0" style="border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-bottom: #dee7ef 3px solid; height: 450px;"
                            width="100%">
                            <tr>
                                <td>
                                    <asp:Panel ID="Panel1" runat="server" Width="100%" Height="440px" ScrollBars="Vertical">
                                        <div id="divReportViewer" runat="server" style="width: 100%; scrollbar-3dlight-color: Azure;">
                                        </div>
                                    </asp:Panel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <!-- Inner Table Fifth Row Contains No Information-->
                    <td class="style2" style="padding-left:8px;">&nbsp;
                        <asp:Label ID="LabelClientScript" runat="server" Text="Label" Visible="False"></asp:Label>
                    </td>
                </tr>
            </table>
            <input id="HiddenFieldMedicationCount" type="hidden" />
        </td>
    </tr>
</table>
<!-- Added the Hidden Field in ref to Task#86!-->
<asp:HiddenField ID="HiddenFieldChartCopyPrinterDeviceLocationId" runat="server" />
<asp:HiddenField ID="HiddenFieldControlledSubstancesList" runat="server" />
<asp:HiddenField ID="HiddenFieldControlledSubstancesListValidate" runat="server" />

<script language="javascript">
    function pageLoad() {
        document.getElementById('HiddenFieldMedicationCount').value = 1;
        MedicationPrescribe.EnablesDisable('<%=ButtonNewOrder.ClientID%>', '<%=RadioButtonFaxToPharmacy.ClientID%>', '<%=RadioButtonPrintScript.ClientID%>', '<%=HiddenFieldShowError.ClientID %>');
   }

   function DisableOrderButton() {
       MedicationPrescribe.EnableDisableOrderButton('<%=ButtonNewOrder.ClientID%>');
   }

   function fnPrint(objButton) {
       objButton.style.display = 'none';
       ReportViewer1.style.display = 'none';
       divPrint.style.display = '';
       window.print();
       objButton.style.display = '';
       ReportViewer1.style.display = '';
       divPrint.style.display = 'none';
       return false;
   }

   function fnDeleteFiles() {
       try {
           var ret = TestReport.deleteImages();
       }
       catch (Exception) {
           alert("Script Exception: " + Exception.message + " occured in function: fnDeleteFiles()");
       }

   }

   function MM_preloadImages_load() {
       var temp = document.getElementById("HiddenFieldArgument").value;
       MM_preloadImages(temp);
   }

   function CallDeleteMedicationsButton() {
        <%=Page.GetPostBackEventReference(this.FindControl("ButtonDeleteMedications")) %>
  }

</script>

<script type="text/javascript">    fnHideParentDiv();</script>

<asp:HiddenField ID="HiddenFieldArgument" runat="server" />
<asp:HiddenField ID="HiddenFieldAllFaxed" runat="server" />
<asp:HiddenField ID="HiddenFieldShowError" runat="server" />
<asp:HiddenField ID="HiddenFieldStoredProcedureName" runat="server" />
<asp:HiddenField ID="HiddenFieldReportName" runat="server" />
<asp:HiddenField ID="HiddenPrinterDeviceLocations" runat="server" />
<asp:HiddenField ID="HiddenFieldPharmacyId" runat="server" />
