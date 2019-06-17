<%@ Control Language="C#" AutoEventWireup="true" CodeFile="VerbalOrdersReview.ascx.cs"
    Inherits="UserControls_VerbalOrdersReview" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<asp:ScriptManagerProxy runat="server" ID="SMP1">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<script type="text/javascript" language="javascript">

    $(document).ready(function () {
        if ($("span[id$=QInteraction]").length > 0) {
            $("span[id$=QInteraction]").css('margin-right', '3px')
        }
        document.getElementById("CheckBox_ReadyToSign").checked = false;
        document.getElementById("TextBox_OneTimePassword").value = "";
    });

    function ApproveOrder() {
        ApproveOrders('<%=hiddenClientMedicationScriptId.ClientID %>');
    }
    function RetractOrders() {
        RetractOrder('<%=hiddenClientMedicationScriptId.ClientID %>');
    }

    function popup() {
        var answerClose = window.showModalDialog('YesNo.aspx?CalledFrom=VerbalOrdersReview', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
        if (answerClose == 'Y') {
            if (document.getElementById("HiddenPageName").value == "FromDashBoard") {
                redirectToStartPage();
            }
            else
                redirectToManagementPage();
        }
    }
    function Close() {

        if (document.getElementById('<%=HiddenFieldSign.ClientID %>').value == "true") 
        {
           // if (confirm('There are approved orders that have not been signed yet. Would you still like to Close the page?')) {
                //added By Priya Ref:task No:2859
            popup();
        }       
        else {
                  if (document.getElementById("HiddenPageName").value == "FromDashBoard") 
                    redirectToStartPage();               
                else
                    redirectToManagementPage();
            }
        }

    function BeforeSign(type) {
        var path = '<%=Server.MapPath(".") %>';
        path.ReplaceAll("//", "#");
        ValidateSign('<%=LabelErrorMessage.ClientID %>', '<%=ImageError.ClientID %>', '<%=tableErrorMessage.ClientID %>', '<%=txtPasword.ClientID %>', type, path)
    }
</script>


<a id="CancelOrderCreateControls" runat="server" onclick="false" onserverclick="createControl"></a>
<a id="anchor" runat="server" onclick="false" onserverclick="GetControl"></a>
<table border="0" cellpadding="0" cellspacing="0" width="100.7%">
    <tr>
        <td style="width: 60%" nowrap="nowrap" class="header">           
             <asp:Label ID="LabelTitleBar" runat="server" Visible="true" style ="color: white; " 
                    Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
        </td>       
        <td style="width: 40%; padding-right:0.7%;" align="right" class="header">
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="right" style="width: 70%">
                        <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" runat="server" Style="display: none; color:white;"
                            OnClientClick="redirectToStartPage();return false;"></asp:LinkButton>
                    </td>
                    <td align="right" style="width: 30%">
                        <%--<asp:LinkButton ID="LinkButtonLogout" Text="" runat="server" OnClick="LinkButtonLogout_Click"
                            Style="display: none"><asp:Image ID="image_logoff" runat="server" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" 
                                Style="border-width: 0px;" /></asp:LinkButton>--%>
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
        <td colspan="2">
            <asp:Label ID="LabelTitle" runat="server" Visible="true" CssClass="TittleBarBase"
                Text="Order Approval for..."></asp:Label>
        </td>
    </tr>
     <tr>
        <td colspan="2">
    <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif">
              </td>
    </tr>
</table>
<table cellpadding="0" width="100%" cellspacing="0" border="0" style="margin-left:8px;">
    <tr>
        <td align="left" valign="top" style="width: 40%;">
            <table id="tableErrorMessage" runat="server" border="0" cellpadding="0" cellspacing="0"
                style="height: 10px">
                <tr>
                    <td valign="middle" style="height: 10px">
                        <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif"
                            Style="display: none;" />
                    </td>
                    <td valign="middle" style="height: 10px">
                        <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError"></asp:Label>&nbsp;
                    </td>
                </tr>
            </table>
        </td>
        <td align="right" valign="bottom" style="width: 60%;">
            <table cellpadding="1" width="50%" cellspacing="1" border="0">
                <tr>
                    <td align="left" style="width: 90px;" class="labelFont">
                        <span>Password:</span>
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtPasword" runat="server" TextMode="Password"></asp:TextBox>
                    </td>
                    <td align="left">
                        <input type="button" id="ButtonSign" value="Sign" disabled="disabled" onclick="BeforeSign('Sign');"
                            class="btnimgexsmall" runat="server" />
                    </td>
                    <td align="left"></td>
                    <td align="left">
                        <asp:Button ID="btnClose" runat="server" CssClass="btnimgexsmall" EnableViewState="False"
                            Text="Close" TabIndex="3" OnClientClick="Close();return false" style="margin-right:10px;"></asp:Button>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="height: 450px; vertical-align: top; width: 50%; min-width: 500px;">
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" border="0" width="98%">
                            <tr>
                                <td align="left">
                                    <UI:Heading ID="Heading1" runat="server" HeadingText="Orders" />
                                </td>
                                <td align="right"></td>
                                <td valign="top" align="right">
                                    <input type="button" id="ButtonApproveAll" tabindex="4" class="btnimgmedium" value="Approve All Order"
                                        onclick="ApproveAllOrders();" <%=enableDisabled(Streamline.BaseLayer.Permissions.ApproveAllOrder)%> />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" width="98%" cellpadding="0" cellspacing="0">
                            <tr style="background-color: #dce5ea;">
                                <td colspan="2">
                                    <div id="PlaceLabel" runat="server" visible="true">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="PlaceHolder" runat="server" visible="true" style="overflow: auto; height: 350px; width: 100%;">
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td style="height: 450px; width: 50%" valign="top">
            <table style="width: 100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td>
                        <UI:Heading ID="Heading2" runat="server" HeadingText="Order Details" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <table style="border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; border-left: #dee7ef 3px solid; width: 100%; border-bottom: #dee7ef 3px solid"
                            cellpadding="0" cellspacing="0">
                            <tr>
                                <td>
                                    <table cellpadding="1" cellspacing="1" border="0" width="100%">
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td align="left" class="labelFont">Patient: <asp:Label ID="lblClientName" runat="server" CssClass="labelFont"></asp:Label>
                                                        </td>                                                      
                                                        <td class="labelFont" align="left">
                                                            <span>DOB: </span> <asp:Label ID="lblDob" runat="server" CssClass="labelFont"></asp:Label>
                                                        </td>                                                     
                                                        <td class="labelFont" nowrap="nowrap" align="left">
                                                            <span>Prescribing Location: </span> <asp:Label ID="lblPrescribinglocation" runat="server" CssClass="labelFont"></asp:Label>
                                                        </td>                                                     
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0" >
                                                    <tr>
                                                        <td style="width: 10px;display:inline;" align="left" nowrap="nowrap">
                                                            <input type="radio" name="radio" id="radioPrint" disabled="disabled" /><span id="spanPrint"
                                                                class="radiobtntext" disabled="disabled">Print</span>
                                                        </td>
                                                        <td style="width: 10px;display:inline;" align="left" nowrap="nowrap">
                                                            <input type="radio" name="radio" id="radioFax" disabled="disabled" /><span id="spanFax"
                                                                class="radiobtntext" disabled="disabled" style="width: 7px">Fax</span>
                                                        </td>
                                                        <td style="width: 20px;display:inline;" align="left" nowrap="nowrap">
                                                            <input type="radio" name="radio" id="radioElectronic" disabled="disabled" /><span
                                                                id="spanElectronic" class="radiobtntext" disabled="disabled">Electronic</span>
                                                        </td>
                                                        <td style="width: 2px;display:inline;" align="left"></td>
                                                        <td class="labelFont" style="width: 10px" align="left" nowrap="nowrap">
                                                            <span style="width: 55px;vertical-align: middle;padding-top: 3px;display: inline-block;">Pharmacy : </span>
                                                        </td>
                                                        <td style="width: 2px" align="left"></td>
                                                        <td nowrap="nowrap" align="left" nowrap="nowrap">
                                                            <asp:Label ID="lblPharmacy" runat="server"  style="vertical-align: middle;padding-top: 3px;" CssClass="labelFont" Width="50px"></asp:Label>
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
                    <td>
                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                            <tr>
                                <td>
                                    <UI:Heading ID="Heading3" runat="server" HeadingText="Prescription" />
                                </td>
                                <td>                                   
                                    <input type="CheckBox" id="CheckBox_ReadyToSign" />
                                     <span id="label_readytosign" style="vertical-align:middle;">Ready To Sign</span>
                                </td>
                                <td>
                                    <span id="label_OTP">OTP</span>
                                    <input type="Text" id="TextBox_OneTimePassword" />
                                </td>

                                <td align="left">
                                    <% if (Session["OpenVerbalOrder"] == "V")
                                       {%>

                                    <input type="button" id="ButtonRetractOrder" tabindex="5" class="btnimgmedium" style="margin-right:-9px;" value="Retract Your Approval" onclick="RetractOrders();" disabled="disabled" />
                                    <%} %>
                                    <% if (Session["OpenVerbalOrder"] == "A")
                                       {%>
                                    <asp:Button ID="ButtonAdjustDosageSchedule" runat="server" Text="Adjust Dosage/Schedule" TabIndex="5"
                                        OnClientClick="javascript:ButtonAdjustDosageSchedule('FromQueuedOrderScreen');return false;"
                                        SkinId="BtnLarge" />
                                    <%} %>
                                </td>

                                <td align="left">
                                    <% if (Session["OpenVerbalOrder"] == "A")
                                       {%>
                                    <input type="button" style="margin-left:4px; margin-right:6px;" id="ButtonCanceltOrder" tabindex="6" class="btnimgexsmall" value="Void" onclick="VoidOrder();" />
                                    <%} %>
                                </td>
                                <td align="left">
                                    <input type="button" style="margin-right:8px;" id="ButtonApproveOrder" tabindex="7" class="btnimgsmall" value="Approve Order" onclick="ApproveOrder();" />
                                </td>
                            </tr>
                        </table>
                        <table style="height: 350px; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; border-left: #dee7ef 3px solid; width: 100%; border-bottom: #dee7ef 3px solid"
                            cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <div id="divReportViewer" runat="server" style="overflow-y: scroll; height: 360px;">
                                    </div>
                                </td>
                            </tr>
                            <tr style="display:none">
                                <td>
                                    <table style="width:100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div id="divDisclaimer">
                                                       
                                                        <span id="Control_ASP.usercontrols_medicationsprescribe_ascx_ctl00_Disclaimer" style="font-size: Smaller; font-style: italic;">By completing the two-factor authentication protocol at this time, you are legally sigining the prescriptions(s) 
 and authorizing the transmission of the above information to the pharmacy for dispensing. The two-factor authentication protocol may only be completed by the practitioner whose name and DEA registration number appear above.</span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<asp:HiddenField ID="hiddenClientMedicationScriptId" runat="server" />
<asp:HiddenField ID="HiddenDrugCategory" runat="server" />
<asp:HiddenField ID="HiddenFieldSign" runat="server" />
<asp:HiddenField ID="HiddenMedicationScriptId" runat="server" />
<asp:HiddenField ID="_boolRowWithInteractionFound" runat="server" />
<asp:HiddenField ID="HiddenFieldRXFourPrescriptionsperpage" runat="server" />
<input type="hidden" id="hiddenPharmacyId" />