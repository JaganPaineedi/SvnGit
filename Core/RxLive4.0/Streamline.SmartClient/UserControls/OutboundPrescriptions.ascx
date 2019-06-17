<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OutboundPrescriptions.ascx.cs" Inherits="UserControls_OutboundPrescriptions" %>

<script type="text/javascript">
    function fnScroll(header, content) {
        $(document.getElementById(header)).scrollLeft($(document.getElementById(content)).scrollLeft());
    }
    //Added by pranay to open the ClientPage on click of Client Name
    function OpenPatientMainPage(clientid) {
        SetPatientMainPage(clientid);
    }
</script>
<asp:Panel ID="PanelOutBoundPrescription" Style="height: 450px;" runat="server" Width="100%">
    <!-- ###StartOutboundPrescripts### -->
    <table id="tblOutBoundPrescription" align="left" border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td align="left">
                <div id="DivGridContainer">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td>
                                <asp:ListView runat="server" ID="lvOutBoundPrescriptionList" OnLayoutCreated="LayoutCreated">
                                    <LayoutTemplate>
                                        <table cellpadding="0" cellspacing="0" class="ListPageContainer">
                                            <tr>
                                                <td>
                                                    <asp:Panel runat="server" ID="divHeader" Style="margin-right: 18px;" CssClass="ListPageHeader">
                                                        <table cellpadding="0" cellspacing="0" width="100%" id="OutBoundPrescriptionHeader">
                                                            <tr>
                                                                <td width="10%">
                                                                    <asp:Panel runat="server" ID="OrderingPrescriberName" SortId="OrderingPrescriberName" CssClass="SortLabel">Prescriber</asp:Panel>
                                                                </td>
                                                                <td width="10%">
                                                                    <asp:Panel runat="server" ID="PatientName" SortId="PatientName" CssClass="SortLabel">Patient Name</asp:Panel>
                                                                </td>
                                                                <td width="7%">
                                                                    <asp:Panel runat="server" ID="CreatedDate" SortId="CreatedDate" CssClass="SortLabel">Date</asp:Panel>
                                                                </td>
                                                                <td width="10%">
                                                                    <asp:Panel runat="server" ID="MedicationName" SortId="MedicationName" CssClass="SortLabel">Medication</asp:Panel>
                                                                </td>
                                                                <td width="15%">
                                                                    <asp:Panel runat="server" ID="Instruction">Strength/Instructions</asp:Panel>
                                                                </td>
                                                                <td width="10%">
                                                                    <asp:Panel runat="server" ID="PharmacyName" SortId="PharmacyName" CssClass="SortLabel">Pharmacy</asp:Panel>
                                                                </td>
                                                                <td width="7%">
                                                                    <asp:Panel runat="server" ID="Method" SortId="Method" CssClass="SortLabel">Method</asp:Panel>
                                                                </td>
                                                                <td width="7%">
                                                                    <asp:Panel runat="server" ID="Status" SortId="Status" CssClass="SortLabel">Status</asp:Panel>
                                                                </td>
                                                                <td width="24%">
                                                                    <asp:Panel runat="server" ID="StatusDescription">Description</asp:Panel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <asp:Panel ID="divListPageContent" runat="server" Style="height: 420px;"
                                                        CssClass="ListPageContent">
                                                        <table width="99.9%" cellspacing="0" cellpadding="0" id="OutBoundPrescriptionList">
                                                            <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                        </table>
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                        </table>
                                    </LayoutTemplate>
                                    <ItemTemplate>
                                        <tr class='<%# Container.DisplayIndex % 2 == 0 ? "" : "ListPageAltRow " %>ListPageHLRow'>
                                            <td width="10%" valign="top">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("OrderingPrescriberName") + "\">" + Eval("OrderingPrescriberName") + "</div>"%>
                                            </td>
                                            <td width="10%" valign="top"><span <%# Eval("ClientId").ToString() != "" ? "style='text-decoration: underline;cursor: pointer;' onclick='OpenPatientMainPage(" + Eval("ClientId") + ");'" : "" %>>
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("ClientId").ToString() + "\">" + Eval("PatientName") + "</div>"%>
                                            </span>
                                            </td>
                                            <td width="7%" valign="top">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("CreatedDate", @"{0:f}") + "\">" + Eval("CreatedDate", "{0:M/d/yyyy}") + "<br />" + Eval("CreatedDate", @"{0:h\:mm tt}") + "</div>"%>
                                            </td>
                                            <td width="10%" valign="top">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("MedicationName") + "\">" + Eval("MedicationName") + "</div>"%>
                                            </td>
                                            <td width="15%" valign="top">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("Instruction") + "\">" + Eval("Instruction") + "</div>"%>
                                            </td>
                                            <td width="10%" valign="top">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("PharmacyName") + "\">" + Eval("PharmacyName") + "</div>"%>
                                            </td>
                                            <td width="7%" valign="top">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("Method") + "\">" + Eval("Method") + "</div>"%>
                                            </td>
                                            <td width="7%" valign="top">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("Status") + "\">" + Eval("Status") + "</div>"%>
                                            </td>
                                            <td width="24%" valign="top">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("StatusDescription") + "\">" + Eval("StatusDescription") + "</div>"%>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:ListView>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    <!-- ###EndOutboundPrescripts### -->
</asp:Panel>
