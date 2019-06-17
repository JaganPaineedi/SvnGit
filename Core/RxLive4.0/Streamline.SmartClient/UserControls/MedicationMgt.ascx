<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedicationMgt.ascx.cs"
    Inherits="UserControls_MedicationMgt" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register TagPrefix="UI" TagName="MedicationList" Src="~/UserControls/MedicationList.ascx" %>
<%@ Register TagPrefix="UI" TagName="MedicationClientPersonalInformation" Src="~/UserControls/MedicationClientPersonalInformation.ascx" %>
<asp:ScriptManagerProxy ID="SMPMgt" runat="server">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/UserPreferences.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationClientPersonalInformation.js?rel=3_5_x_4_1"
            NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/AllergySearch.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>
<table id="TableTitleBar" border="0" cellpadding="0" cellspacing="0" width="100.7%">
    <tr>
       <%-- --%>
        <td class="header" style="width: 50%">
        <asp:Label ID="LabelTitleBar" runat="server" Visible="true" style ="color: white; " 
                    Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
            </td>      
        <td style="width: 50%; padding-right:0.7%;" align="right" class="header">
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="right" style="width: 70%">
                        <asp:LinkButton ID="LinkButtonStartPage" Style="display: none; color:white;" Text="Start Page"
                            runat="server" OnClientClick="redirectToStartPage();this.disabled=true;return false;"></asp:LinkButton>
                    </td>
                    <td align="right" style="width: 30%;">
                        <%--<asp:LinkButton ID="LinkButtonLogout" Text="" runat="server" OnClick="LinkButtonLogout_Click" Style="display: none"> 
                            <asp:Image ID="image_logoff" runat="server" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Style="border-width: 0px;" /></asp:LinkButton>--%>
                         <asp:ImageButton ID="LinkButtonLogout" Style="display: none" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Text="" runat="server" OnClick="LinkButtonLogout_Click" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="height: 1pt; border-bottom: #5b0000 1px solid;"></td>
    </tr>
    <tr>      
        <td colspan="2">
            <table style="width:100%;"><tr>
            <td id="topborder" >
                 <asp:Label ID="Label1" runat="server" Visible="true" CssClass="TittleBarBase" Text="Patient Summary"></asp:Label></td>
           
      <td style="float:right;">
          <div class="button-group round">
                        <input type="button" class="btnimglarge" id="ButtonPatientSearch" value="Patient Search...." onclick="ShowClientSearch();" />
                        <input type="button" class="btnimglarge" id="ButtonViewConsentHistory" value="Consent History" onclick="redirectToViewConsentHistoryPageClearSession()"
                             <%=enableDisabled(Streamline.BaseLayer.Permissions.ViewHistory)%> />
                        <!--Mdified by Loveena in ref to Task#2498 View History - It should not be a pop-up.!-->
                        <input type="button" class="btnimglarge" id="ButtonViewHistory" value="Medication History" onclick="redirectToViewHistoryPageClearSession()"
                             <%=enableDisabled(Streamline.BaseLayer.Permissions.ViewHistory)%> />
                       <input type="button" class="btnimglarge" id="ButtonNewOrder" value="New Order" onclick="$('input[id=HiddenFieldChangeOrderPharmacyId]').val(''); $('input[id=HiddenFieldRadioToFax]').val(''); $('input[id=HiddenFieldRefillPharmacyId]').val(''); $('input[id=HiddenFieldSureScriptRefillRequestId]').val(''); $('input[id*=HiddenFieldClickedImage]').val(''); $('input[id*=HiddenFieldRefillPharmacyName]').val(''); redirectToOrderPageClearSession()"
                             <%=enableDisabled(Streamline.BaseLayer.Permissions.NewOrder)%> />
                        <input type="button" class="btnimglarge" id="ButtonAddMedication" value="Add Medication" onclick="redirectToNonOrderPageClearSession('Add Medication')"
                            <%=enableDisabled(Streamline.BaseLayer.Permissions.AddMedication)%> />
              </div>
                    </td>
                </tr></table>
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
                        <asp:Label ID="LabelClientName" runat="server"></asp:Label>,
                    </td>
                    
                </tr>
            </table>
        </td>
    </tr>
</table>
<table width="100%" border="0" style="margin-left:8px;">
    <tr>
        <td align="right">
            <table border="0" cellpadding="0" cellspacing="0" style="width: 728px">
                <tr>
                    <td align="right" valign="top" style="width: 301px">
                        <asp:DropDownList ID="DropDownListClients" runat="server" CssClass="ddlist" Width="0px"
                            OnSelectedIndexChanged="DropDownListClients_SelectedIndexChanged" AutoPostBack="true"
                            Height="17px" Style="visibility: hidden">
                        </asp:DropDownList>
                    </td>
                    <td>&nbsp;
                    </td>
                    <td valign="top" align="left"></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="left" colspan="2">
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="LEFT" valign="middle">
                        <img id="ImgError" src="App_Themes/Includes/Images/error.gif" alt="" style="visibility: hidden;" />
                    </td>
                    <td valign="middle">
                        <asp:Label ID="LabelError" runat="server" class="redTextError"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td  colspan="2">
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                   
                    <td>

                        <!--Client Summary Display -->
                        <UI:MedicationClientPersonalInformation ID="MedicationClientPersonalInformation1"
                            runat="Server" />
                        <!---End of client Summary -->
                        
                        <br />
                        <a href="abc" id="test" target="_blank"></a>
                        <asp:Button ID="ButtonPrintList" runat="server" Text="Print List..." CssClass="btnimgexsmall" style="margin-right: 10px;"
                            OnClientClick="javascript:ButtonPrintList('Medications - Current');return false;"  />
                         <%--   
                        &nbsp; &nbsp;--%>
                        <asp:Button ID="ButtonReOrder" runat="server" Text="Change Order" CssClass="btnimgexsmall" style="margin-right: 10px;"
                            OnClientClick="javascript:ButtonReOrderClick();return false;" SkinID="BtnSmall" />
                      <%--  &nbsp; &nbsp;--%>
                        <asp:Button ID="ButtonRefillOrder" runat="server" Text="Re-order" CssClass="btnimgexsmall" style="margin-right: 10px;" OnClientClick="javascript:ButtonReFillOrderClick();return false;"
                             />
                      <%--  &nbsp; &nbsp;--%>
                        <asp:Button ID="ButtonAdjustDosageSchedule" runat="server"  CssClass="btnimglarge" style="margin-right: 10px;"
                            Text="Adjust Dosage/Schedule" OnClientClick="javascript:ButtonAdjustDosageSchedule();return false;"
                             SkinId ="BtnLarge" hidden="hidden"/><%--&nbsp; &nbsp;--%>

                        <asp:Button ID="ButtonCompleteOrder" runat="server" disabled="true"  CssClass="btnimgmedium" style="margin-right: 10px;"
                            Text="Complete Order" OnClientClick="javascript:ButtonReOrderClick('Complete');return false;" 
                            SkinId ="BtnMedium"/><%--&nbsp; &nbsp;--%>

                        <asp:Button runat="server" ID="ButtonPatientContent" CssClass="btnimgmedium" style="margin-right: 10px;" SkinId ="BtnMedium" Text="Patient Consent" OnClientClick="ButtonPatientContentClick('Patient Consent'); return false;" />
                       <% if (HiddenFieldDropDownListReports.Value!= "Y")
                           {%>
                         <select id="DropDownListReports"  style="width: 201px;margin-right: 10px;" class="ddlist" >
                        </select>

                        <%} %>
                        <asp:Button ID="ButtonRunReport" runat="server" Text="Run Report" CssClass="btnimgexsmall" style="margin-right: 10px;"
                            OnClientClick="javascript:ShowReport();return false;"/>


                          <asp:Button ID="ButtonPMP" runat="server" Text="PMP" Visible="false" ToolTip="Prescription Management Program"
                            OnClientClick="javascript:return ShowPMPReport();"  style="margin-right: 10px;" CssClass="btnimgexsmall" />
                        <asp:Button ID="ButtonPMPrefresh" runat="server" OnClick="ButtonPMP_Click" style="display:none;margin-right: 10px;" />

                        <input type="checkbox" id="CheckBoxNoMedications" onclick="UpdateNoMedicationsFlag();" runat="server" /><label id="LabelNoMedications" for="CheckBoxNoMedications" runat="server" style="font-weight: normal; font-size: 11px; vertical-align:middle;">Patient has no prescribed medications</label>
                        
                        
                        <table cellpadding="0" cellspacing="0" border="0" class="ActiveTab HeaderTab">
                            <tr>
                                <td class="LeftHeading" style="background-repeat: no-repeat"></td>
                                <td class="CenterHeading" style="background-repeat: repeat-x;">
                                    <span style="font-family: Tahoma, Arial, Helvetica, sans-serif; font-size: 11px;">Medication List</span>
                                </td>
                                <td class="RightHeading">
                                </td>
                                 <td>&nbsp;</td>
                            <td></td>
                            </tr>
                        </table>
                        
                        <table cellpadding="0" cellspacing="0" 
                            width="100%">
                            <tr>
                                <td>
                                    
                                    <div id="MedicationListInformation"  class="medlst">
                                        <%--<div style="display:block">--%>
                                        <asp:Panel ID="PanelMedicationListInformation" runat="server" BorderColor="Black"
                                            BorderStyle="None" Height="30%" Width="100%">
                                        </asp:Panel>
                                             <%--</div>--%>
                                    </div>
                                      
                                </td>
                            </tr>
                        </table>
                            
                    </td>
                
               

                
                </tr>
            </table>
            <asp:Label ID="LabelClientScript" runat="server" Text="Label" Visible="false"></asp:Label>
            <asp:LinkButton ID="lnkMgtlink" runat="server" OnClick="LinkButtonSetClient_Click"
                CssClass="hiddenFields">LinkButton</asp:LinkButton>
        </td>
    </tr>
</table>




<asp:HiddenField ID="HiddenFieldPermissionCheckButtonReOrder" runat="server" />
<asp:HiddenField ID="HiddenFieldPermissionCheckButtonRefillOrder" runat="server" />
<asp:HiddenField ID="HiddenFieldPermissionCheckButtonCompleteOrder" runat="server" />
<asp:HiddenField ID="HiddenFieldDropDownListReports" runat="server" />
<asp:HiddenField ID="HiddenFieldIsStaffHasPermissionforClientsDropDown" runat="server" /> 
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        // Code added by jyothi s part of Journey-Support Go Live -#1566
        var StaffPermissionForClientDropDown = $('[id$=HiddenFieldIsStaffHasPermissionforClientsDropDown]').val();
        if (StaffPermissionForClientDropDown == 'false') {
            $('[id$=ButtonPatientSearch]').prop("disabled", true);
        }
    });
    function pageLoad() {
        var DivTag;

        MedicationMgt.FillMedicationControl(document.getElementById('<%=PanelMedicationListInformation.ClientID%>'));
        FillAllergyControlofClientInformation('Y');

        //MedicationMgt.FillSystemReports(); //added by Rohit. Ref ticket #90
        FillSystemReports(); //added by Rohit. Ref ticket #90

        if ($('[id$=HiddenFieldPageCalledFrom]').val() == "MedicationPrescribe") {
            MakeAlertCheckRequest();
        }

        if ($('[id$=HiddenFieldPageCalledFrom]').val() == 'Reconciliation') {
            MakeAlertCheckRequest();
        }

    }

    function openReconceliationPopUp() {
        window.open("Reconciliation.aspx", "Reconciliation", "width=900, height=400");

        /*
        var $divAlertPopup = $("#DivHealthMaintenanceAlertPopUp");
        $("#topborder2", $divAlertPopup).text("Health Maintenance Alert");
        var $iFrameAlertPopup = $('#iFrameAlertPopup', $divAlertPopup);
        $iFrameAlertPopup.attr('src', 'Reconciliation.aspx');
        $iFrameAlertPopup.css({ 'width': '900px', 'height': '500px' });
        var left = ($(window.document).width() / 3) - ($iFrameAlertPopup.width() / 2);
        left = left > 0 ? left : 10;
        var top = ($(window.document).height() / 3) - ($iFrameAlertPopup.height() / 2);
        top = top > 0 ? top : 10;
        $divAlertPopup.css({ 'top': top, 'left': left });
        $divAlertPopup.draggable();
        $divAlertPopup.css('display', 'block');
        
        */

    }

    function MakeAlertCheckRequest() {
        //Wasif - Adding alert code
        //Create the WebRequest object.
        wRequest = new Sys.Net.WebRequest();
        wRequest.set_url("./HealthMaintenanceAlertPopup.aspx?AjaxAction=HealthMaintenanceAlertCheck");
        wRequest.add_completed(OnAlertRequestCompleted);
        //wRequest.set_userContext(Panel);
        wRequest.set_httpVerb("Post");
        var executor = new Sys.Net.XMLHttpExecutor();
        wRequest.set_executor(executor);
        executor.executeRequest();
        var started = executor.get_started();
    }

    function OnAlertRequestCompleted(executor, eventArgs) {
        try {
            if (executor.get_responseAvailable()) {
                // Get the Web request instance.
                var webReq = executor.get_webRequest();
                // Display request Url.
                if (executor.get_statusCode() == 200) {
                    var data = executor.get_responseData();
                    if (data.split("|;")[0] == "success" && data.split("|;")[1] > 0) {
                        var $divAlertPopup = $("#DivHealthMaintenanceAlertPopUp");
                        $("#topborder2", $divAlertPopup).text("Health Maintenance Alert");
                        var $iFrameAlertPopup = $('#iFrameAlertPopup', $divAlertPopup);
                        $iFrameAlertPopup.attr('src', 'HealthMaintenanceAlertPopup.aspx');
                        $iFrameAlertPopup.css({ 'width': '650px', 'height': '500px' });
                        var left = ($(window.document).width() / 3) - ($iFrameAlertPopup.width() / 2);
                        left = left > 0 ? left : 10;
                        var top = ($(window.document).height() / 3) - ($iFrameAlertPopup.height() / 2);
                        top = top > 0 ? top : 10;
                        $divAlertPopup.css({ 'top': top, 'left': left });
                        $divAlertPopup.draggable();
                        $divAlertPopup.css('display', 'block');
                    }
                }
            }
        } catch (e) {
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
        }
    }

    function UpdateNoMedicationsFlag() {
        var CheckboxFlag = ($('[id$=CheckBoxNoMedications]')[0].checked == true) ? 'Y' : 'N';
        Streamline.SmartClient.WebServices.ClientMedications.UpdateNoMedicationsFlag(CheckboxFlag);
    }

    function pageLoadSelectClient(SelectedClientId) {
        var ClientFoundflag = false;
        var output = document.getElementById('<%=DropDownListClients.ClientID%>');
        for (var i = 0; i < output.length; i++) {
            if (output[i].value.indexOf(SelectedClientId) == 0) {
                ClientFoundflag = true;
                break;
            }

        }
        if (ClientFoundflag == true)
            document.getElementById('<%=DropDownListClients.ClientID%>').value = SelectedClientId;

        pageLoad();

    }
    //added by Rohit. ref #90
    function ShowReport() {
        var dropdown = document.getElementById("DropDownListReports");
        var selectedMedicationIds = "";
        ShowError('', false);

        var index = dropdown.selectedIndex;

        if (index == -1)
            return false;

        var baseURL = dropdown.options[index].value;
        var reportTitle = dropdown.options[index].text;

        try {
            if (baseURL.indexOf('<SessionId>') > 0) {
                var i = 0;
                var lengthOfArray = MedicationIds.length;
                if (lengthOfArray == 0) {
                    ShowError('At least one Medication must be selected before running this report', true);
                    return false;
                }

                for (i = 0; i < lengthOfArray; i++)
                    if (selectedMedicationIds == '')
                        selectedMedicationIds += String(MedicationIds[i]);
                    else
                        selectedMedicationIds += ',' + String(MedicationIds[i]);

                fnShow();
                PopupCenter("LoadReport.aspx?reportName=" + encodeURIComponent(reportTitle) + "&medicationIds=" + selectedMedicationIds, "SmartCare", 760, 500);
                fnHideParentDiv();
            }
            else if (baseURL.indexOf('<ClientId>') > 0) {
                fnShow();
                PopupCenter("LoadReport.aspx?reportName=" + encodeURIComponent(reportTitle), "SmartCare", 760, 500);
                fnHideParentDiv();
            }
        }
        catch (e) {

            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }
    }


    function ShowPMPReport() {
        try {
            //$("[id$=ButtonPMP]").attr("disabled", true);
            Streamline.SmartClient.WebServices.ClientMedications.GetNarxInformation(function onSuccessNarxInformation(result) {
                debugger;
                //$("[id$=ButtonPMP]").attr("disabled", false);
                if (result.search("Error") >= 0) {
                    ShowError(result, true);
                }
                else {
                    window.open(result);
                    if ($("[id$=ButtonPMPrefresh]").length > 0) {
                        $("[id$=ButtonPMPrefresh]").click();
                    }
                }
            });
            return false;
        }
        catch (e) {

            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_WEB_SERVICE, e);
        }

    }

</script>

<style type="text/css">

    .medlst {
        height:175px !important;
         overflow: auto; 
          border:3px solid rgb(222, 231, 239);
    }

</style>