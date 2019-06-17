<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PatientConsentDetail.ascx.cs"
    Inherits="Streamline.SmartClient.UI.UserControls_PatientConsentDetail" %>
    <script language="javascript" type ="text/javascript">

        function ShowDivForConsentPrint() {
            var d = new Date();
            var ChartScriptIds = "";
            var myans1 = window.showModalDialog('MedicationScriptPrinting.aspx?varScriptIds=' + '<%=Session["imgId1"]%>' + '&varChartScriptIds=' + ChartScriptIds + '&varFaxSendStatus=' + true + '&varTime =' + d.getTime(), 'Medication Script Printing', 'menubar : no;status : no;dialogHeight:500px;dialogWidth=750px;resizable:no;dialogTop:20px;dialogLeft:170px,location:no; help: No;'); 
        } 
    </script>
<div>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="width: 100%">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 30%">
                            <asp:Label ID="Label2" runat="server" CssClass="TittleBarBase" Text="Consent Detail"></asp:Label>
                        </td>
                        <td align="center" style="width: 30%">
                            <asp:Label ID="LabelSmartCareRx" runat="server" Visible="true" CssClass="SamrtCareTittleBarBase"
                                Text="SmartCareRx"></asp:Label>
                        </td>
                        <td style="width: 30%" align="right">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right" style="width: 50%">
                                    <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" runat="server" OnClientClick="redirectToStartPage();this.disabled=true;return false;" style="display:none"></asp:LinkButton>
                                </td>
                                <td align="right" style="width: 50%">
                                    <asp:LinkButton ID="LinkButtonLogout" Text="Logout" runat="server" OnClick="LinkButtonLogout_Click"
                                        Style="display: none"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 1pt; border-bottom: #5b0000 1px solid; width: 872px;" colspan="3">
            </td>
        </tr>
        <tr>
            <td style="width: 100%;">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                        <td colspan="9">
                            <table id="tableErrorMessage" runat="server" style="display: none" border="0" cellpadding="0"
                                cellspacing="0">
                                <tr>
                                    <td valign="bottom">
                                        <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif"
                                            Style="display: none; vertical-align: middle" />
                                    </td>
                                    <td valign="bottom">
                                        &nbsp;
                                        <asp:Label ID="LabelErrorMessage" runat="server" Style="vertical-align: middle" CssClass="redTextError"
                                            BackColor="#DCE5EA"></asp:Label>&nbsp;
                                    </td>
                                    <td valign="bottom">
                                        <div id="DivErrorMessage" runat="server" style="display: none; width: 22px; height: 12px">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                    </tr>
                    <tr>
                        <td align="right">
                            &nbsp;&nbsp;
                            <asp:Button ID="ButtonPrescribe" CssClass="btnimgexsmall" runat="server" Font-Size="11px"
                                Text="Print" Width="100px" OnClientClick="ShowDivForConsentPrint();return;" />&nbsp;
                            <asp:Button ID="ButtonClose" CssClass="btnimgexsmall" runat="server" Font-Size="11px"
                                Text="Close" Width="65px" OnClientClick="redirectToViewConsentHistoryPageClearSession(); return false;" />
                            <asp:Button ID="ButtonClose1" CssClass="btnimgexsmall" runat="server" Font-Size="11px"
                                Text="Close" Width="65px" OnClientClick="redirectToManagementPage(); return false;"
                                Visible="false" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table style="border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; border-left: #dee7ef 3px solid;
                                width: 100%; border-bottom: #dee7ef 3px solid" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <div id="divPatientConsentReport" runat="server" style="width: 720px; scrollbar-3dlight-color: Azure;">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        </table>
</div>
<asp:HiddenField ID="HiddenFieldReportUrl" runat="server" />
<asp:HiddenField ID="HiddenFieldLatestDocumentVersionId" runat="server" />
<asp:Label ID="Label1" runat="server" Visible="false"></asp:Label>
