<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AjaxScript.aspx.cs" Inherits="AjaxScript"
    ValidateRequest="false" %>

<%@ Register TagPrefix="UI" TagName="MedicationList" Src="~/UserControls/MedicationList.ascx" %>
<%@ Register TagPrefix="UI" TagName="KeyPhraseList" Src="~/UserControls/PhraseList.ascx" %>
<%@ Register TagPrefix="UI" TagName="AgencyKeyPhraseList" Src="~/UserControls/AgencyKeyPhraseList.ascx" %>

<%@ Register Src="~/UserControls/ConsentHistoryList.ascx" TagName="ConsentHistoryList"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form2" runat="server">
        <medlist>
    <div>
    <UI:MedicationList ID="MedicationList1" runat="server" />
        <asp:Label ID="LabelClientScript" runat="server" Text="Label" Visible="false"></asp:Label></div>
       </medlist>

        <phraselist>
         <UI:KeyPhraseList ID="KeyPhraseList1"  runat="server" />
            <asp:Label ID="LabelKeyClientScript" runat="server" Text="Label" Visible="false"></asp:Label>
        </phraselist>

        <agencykeyphraselist>
         <UI:AgencyKeyPhraseList ID="AgencyKeyPhraseList1"  runat="server" />
            <asp:Label ID="LabelAgencyKeyClientScript" runat="server" Text="Label" Visible="false"></asp:Label>
        </agencykeyphraselist>

        <consentmedlist>
    <div>
    <uc1:ConsentHistoryList ID="ConsentHistoryList1" runat="server" />
        <asp:Label ID="LabelConsentClientScript" runat="server" Text="Label" Visible="false"></asp:Label></div>
       </consentmedlist>
        <div>
            <!-- Added By Anuj Ref: task 85-->
            <font style="display: none">###STARTGRAPH###</font>
            <asp:Panel ID="PanelCurrentMedicationListInformation" runat="server" BorderColor="Black"
                BorderStyle="None" Height="97%" Width="100%" Style="overflow: auto;">
            </asp:Panel>
            <font style="display: none">###ENDGRAPH###</font>
        </div>
        <div>
            <font style="display: none">###STARTFORMULARY###</font>
            <asp:Panel ID="PanelFORMULARY" runat="server" BorderColor="Black"
                BorderStyle="None" Height="97%" Width="100%" Style="overflow: auto;">
            </asp:Panel>
            <font style="display: none">###ENDFORMULARY###</font>
        </div>
        <!-- Ended over here-->
        <%-- Added By Pushpita Ref: task 85--%>
        <font style="display: none">##STARTREFILLREQUEST##</font>
        <asp:Panel runat="server" ID="RefillListDiv">
            <asp:ListView runat="server" ID="RefillList" OnItemDataBound="RenderRefillRequestRow">
                <LayoutTemplate>
                    <table cellpadding="0" cellspacing="1" border="0" style="font-size: 12px;" width="100%">
                        <tr style="background-color: #dce5ea; cursor: pointer; font-size: larger; font-weight: bold; height: 20px; text-decoration: underline;">
                            <th>Action</th>
                            <th align="left"><span onclick="SortInboundRecord('PatientName','Sort');">Patient</span></th>
                            <th align="left"><span onclick="SortInboundRecord('DrugDescription','Sort');">Medication Prescribed</span></th>
                            <th align="left"><span onclick="SortInboundRecord('DispensedDrugDescription','Sort');">Medication Dispensed</span></th>
                            <th align="left"><span onclick="SortInboundRecord('PharmacyName','Sort');">Pharmacy</span></th>
                            <th align="left"><span onclick="SortInboundRecord('PrescriberName','Sort');">Prescriber</span></th>
                        </tr>
                        <asp:PlaceHolder runat="server" ID="itemPlaceholder" />
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                    <tr style='<%# Container.DisplayIndex % 2 == 0 ? "background-color:#fff;": "background-color:#ccc;" %>'>
                        <td valign="top" width="8%">
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <div style='<%# Eval("ServiceLevel").ToString() != "0" ? "display:block;": "display:none;"%>'>
                                            <asp:Label runat="server" ID="ImageApprovedLabel">
                                                <asp:Image ID="ImageApproved" runat="server" ToolTip="Approved" Style="cursor: pointer;" />
                                            </asp:Label>
                                            <asp:Label runat="server" ID="ImageApprovedWithChangesLabel">
                                                <asp:Image ID="ImageApprovedWithChanges" runat="server" ToolTip="Approved With Changes" Style="cursor: pointer;" />
                                            </asp:Label>
                                            <asp:Label runat="server" ID="ImageDeniedNewPrescriptionsLabel">
                                                <asp:Image ID="ImageDeniedNewPrescriptions" runat="server" ToolTip="Denied New Prescription To Follow" Style="cursor: pointer;" />
                                            </asp:Label>
                                            <asp:Label runat="server" ID="ImageDenyLabel">
                                                <asp:Image ID="ImageDeny" runat="server" ToolTip="Denied" Style="cursor: pointer;" ImageUrl="~/App_Themes/Includes/Images/enable_22.png" />
                                            </asp:Label>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Date Received:</b></td>
                                </tr>
                                <tr>
                                    <td>
                                        <%# Eval("CreatedDate","{0:M/d/yyyy}") %>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%# Eval("CreatedDate", "{0:h:mm tt}") %>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="ErrorSpan" Font-Bold="True" ForeColor="Red"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" width="13%">
                            <!-- patient -->
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="ImageSearchLabel">
                                            <asp:Image ID="ImageSearch" ImageUrl="~/App_Themes/Includes/Images/SearchRefillRequest.gif"
                                                runat="server" Style="cursor: pointer;" ToolTip="Patient Search" />
                                        </asp:Label>
                                    </td>
                                    <td><span <%# Eval("ClientId").ToString() != "" ? "style='text-decoration: underline;cursor: pointer;font-weight:bold;' onclick='OpenPatientMainPage(" + Eval("ClientId") + ");'" : "" %>>
                                        <%# Eval("ClientLastName") %>, <%# Eval("ClientFirstName") %> <%# Eval("ClientMiddleName") %>
                                    </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2"><b>DOB:</b> <%# Eval("ClientDOB","{0:M/d/yyyy}") %>
                                        <asp:Label runat="server" ID="ClientDOBAge"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><b>Gender:</b> <%# Eval("ClientSex").ToString() == "F" ? "Female" : "Male"  %></td>
                                </tr>
                                <tr style='<%# Eval("ClientAddress1").ToString() == "" ? "display:none;": "" %>'>
                                    <td colspan="2"><%# Eval("ClientAddress1") %></td>
                                </tr>
                                <tr style='<%# Eval("ClientAddress2").ToString() == "" ? "display:none;": "" %>'>
                                    <td colspan="2"><%# Eval("ClientAddress2") %></td>
                                </tr>
                                <tr style='<%# Eval("ClientCity").ToString() == "" ? "display:none;": "" %>'>
                                    <td colspan="2"><%# Eval("ClientCity") %>, <%# Eval("ClientState") %> <%# Eval("ClientZip") %></td>
                                </tr>
                                <tr style='<%# Eval("ClientPhone").ToString() == "" ? "display:none;": "" %>'>
                                    <td colspan="2"><b>PH:</b> <%# Eval("ClientPhone") %></td>
                                </tr>
                                <tr style='<%# Eval("ClientFax").ToString() == "" ? "display:none;": "" %>'>
                                    <td colspan="2"><b>Fax:</b> <%# Eval("ClientFax") %></td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" width="25%">
                            <!-- Prescribed -->
                            <table cellpadding="0" cellspacing="0" border="0" style="padding-right: 3px;">
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="ImageSearchMedicationLabel">
                                            <asp:Image ID="ImageSearchMedication" ImageUrl="~/App_Themes/Includes/Images/SearchRefillRequest.gif"
                                                runat="server" Style="cursor: pointer;" ToolTip="Current Medications" />
                                        </asp:Label>
                                    </td>
                                    <td><%# Eval("DrugDescription") %></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><span style="color: darkviolet; font-weight: bold;">
                                        <%# Eval("MedicationName").ToString() != "" ? "(" + Eval("MedicationName").ToString() + ")" : "" %> 
                                    </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><b>Qty:</b> <%# Eval("QuantityValue","{0:0.##########}") %> &nbsp;&nbsp; <b>Refills:</b> <%# Eval("RefillType").ToString() == "PRN" ? "PRN" : Eval("NumberOfRefills") %> &nbsp;&nbsp; <b>Days Supply:</b> <%# Eval("NumberOfDaysSupply") %> &nbsp;&nbsp; <b>DAW:</b> <%# Eval("Substitutions").ToString() == "1" || Eval("Substitutions").ToString() == "7" ? "Y" : "N" %></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><b>Potency:</b> <%# Eval("PotencyUnitCodeDesc") %> &nbsp;&nbsp; <b>Written Date:</b> <%# Eval("WrittenDate","{0:M/d/yyyy}") %></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><b>Directions:</b> <%# Eval("Directions") %></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td><b>Notes:</b> <%# Eval("Note") %></td>
                                </tr>
                                <tr style='<%# Eval("Diagnosis1").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td></td>
                                    <td><b>Diagnois:</b> <%# Eval("Diagnosis1") %></td>
                                </tr>
                                <tr style='<%# Eval("Diagnosis2").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td></td>
                                    <td><b>Diagnois:</b> <%# Eval("Diagnosis2") %></td>
                                </tr>
                                <tr style='<%# Eval("PriorAuthValue").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td></td>
                                    <td><b>Prior Authorizations:</b> <%# "(" + Eval("PriorAuthQualifier") +") " + Eval("PriorAuthValue") %></td>
                                </tr>
                                <tr style='<%# Eval("PriorAuthStatus").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td></td>
                                    <td><b>Prior Authorization Status:</b> <%# Eval("PriorAuthStatus") %></td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" width="25%">
                            <!-- Dispensed -->
                            <table cellpadding="0" cellspacing="0" border="0" style="padding-right: 3px;">
                                <tr>
                                    <td><%# Eval("DispensedDrugDescription") %></td>
                                </tr>
                                <tr>
                                    <td><b>Qty:</b> <%# Eval("DispensedQuantityValue","{0:0..##########}") %> &nbsp;&nbsp; <b>Refills:</b> <%# Eval("DispensedNumberOfRefills") %> &nbsp;&nbsp; <b>Days Supply:</b> <%# Eval("DispensedNumberOfDaysSupply") %> &nbsp;&nbsp; <b>DAW:</b> <%# Eval("DispensedSubstitutions").ToString() == "1" || Eval("DispensedSubstitutions").ToString() == "7" ? "Y" : "N" %></td>
                                </tr>
                                <tr>
                                    <td><b>Potency:</b> <%# Eval("DispensedPotencyUnitCodeDesc") %> &nbsp;&nbsp; <b>Written Date:</b> <%# Eval("DispensedWrittenDate","{0:M/d/yyyy}") %></td>
                                </tr>
                                <tr>
                                    <td><b>Directions:</b> <%# Eval("DispensedDirections") %></td>
                                </tr>
                                <tr>
                                    <td><b>Notes:</b> <%# Eval("DispensedNote") %></td>
                                </tr>
                                <tr style='<%# Eval("DispensedDiagnosis1").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td><b>Diagnois:</b> <%# Eval("DispensedDiagnosis1") %></td>
                                </tr>
                                <tr style='<%# Eval("DispensedDiagnosis2").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td><b>Diagnois:</b> <%# Eval("DispensedDiagnosis2") %></td>
                                </tr>
                                <tr style='<%# Eval("DispensedPriorAuthValue").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td><b>Prior Authorizations:</b> <%# "(" + Eval("DispensedPriorAuthQualifier") +") " + Eval("DispensedPriorAuthValue") %></td>
                                </tr>
                                <tr style='<%# Eval("DispensedPriorAuthStatus").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td><b>Prior Authorization Status:</b> <%# Eval("DispensedPriorAuthStatus") %></td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" width="17%">
                            <!-- Pharmacy -->
                            <table cellpadding="0" cellspacing="0" border="0" style="padding-right: 3px;">
                                <tr>
                                    <td><%# Eval("PharmacyName") %></td>
                                </tr>
                                <tr>
                                    <td><%# Eval("PharmacyAddress") %></td>
                                </tr>
                                <tr>
                                    <td><%# Eval("PharmacyCity") %>, <%# Eval("PharmacyState") %> <%# Eval("PharmacyZip") %></td>
                                </tr>
                                <tr>
                                    <td><b>PH:</b> <%# Eval("PharmacyPhoneNumber") %></td>
                                </tr>
                                <tr>
                                    <td><b>Fax:</b> <%# Eval("PharmacyFaxNumber") %></td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" width="12%">
                            <!-- prescriber -->
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td><%# Eval("PrescriberLastName") %>, <%# Eval("PrescriberFirstName") %></td>
                                </tr>
                                <tr style='<%# Eval("PrescriberAddress1").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td><%# Eval("PrescriberAddress1") %></td>
                                </tr>
                                <tr style='<%# Eval("PrescriberAddress2").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td><%# Eval("PrescriberAddress2") %></td>
                                </tr>
                                <tr style='<%# Eval("PrescriberCity").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td><%# Eval("PrescriberCity") %>, <%# Eval("PrescriberState") %> <%# Eval("PrescriberZip") %></td>
                                </tr>
                                <tr style='<%# Eval("PrescriberPhone").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td><b>PH:</b> <%# Eval("PrescriberPhone") %></td>
                                </tr>
                                <tr style='<%# Eval("PrescriberFax").ToString() == "" ? "display:none;": "display:block;" %>'>
                                    <td><b>Fax:</b> <%# Eval("PrescriberFax") %></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                </EmptyDataTemplate>
            </asp:ListView>
        </asp:Panel>
        <font style="display: none">##ENDREFILLREQUEST##</font>

        <%-- Ended By Pushpita Ref: task 85--%>
        <!-- Added By Anuj Ref: task 85-->
        <font style="display: none">##STARTPAGEOUTBOUNDPRES##</font>
        <asp:Panel ID="PanelOutBoundPrescription" runat="server" BorderColor="Black" BorderStyle="None">
        </asp:Panel>
        <font style="display: none">##ENDPAGEOUTBOUNDPRESC##</font>
        <!-- Ended over here-->

        <font style="display: none">##STARTRXCHANGE##</font>
        <%--Added By PranayB Ref: task No:RXCHANGE MU Changes--%>
        <asp:Panel ID="ChangeListDiv" runat="server"  >
            <asp:ListView runat="server" ID="ChangeList" OnItemDataBound="RenderChangeRequestRow">
                <LayoutTemplate>
                    <table cellpadding="0" cellspacing="1" border="0" style="font-size: 12px;" width="100%">
                        <tr style="background-color: #dce5ea; font-weight: bold; text-decoration: underline; height: 20px; cursor: pointer; font-size: larger;">
                            <th>Action</th>
                            <th align="left"><span onclick="SortInboundRecord('PatientName','Sort');">Patient</span></th>
                            <th align="left"><span onclick="SortInboundRecord('DrugDescription','Sort');">Medication Prescribed</span></th>
                            <th align="left"><span onclick="SortInboundRecord('DispensedDrugDescription','Sort');">Medication Requested</span></th>
                            <th align="left"><span onclick="SortInboundRecord('PharmacyName','Sort');">Pharmacy</span></th>
                            <th align="left"><span onclick="SortInboundRecord('PrescriberName','Sort');">Prescriber</span></th>
                        </tr>
                        <asp:PlaceHolder runat="server" ID="itemPlaceholder" />
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                    <tr style='<%# Container.DisplayIndex % 2 == 0 ? "background-color:#fff;": "background-color:#ccc;" %>'>
                        <td valign="top" width="8%">
                            <div id="divIcons" runat="server">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td>
                                            <div style='<%# Eval("ServiceLevel").ToString() != "0" ? "display:block;": "display:none;"%>'>
                                                <asp:Label runat="server" ID="ImageApprovedLabel">
                                                    <asp:Image ID="ImageApproved" runat="server" ToolTip="Approved" Style="cursor: pointer;" />
                                                </asp:Label>
                                                <asp:Label runat="server" ID="ImageApprovedWithChangesLabel">
                                                    <asp:Image ID="ImageApprovedWithChanges" runat="server" ToolTip="Approved With Changes" Style="cursor: pointer;" />
                                                </asp:Label>
                                                <%--    <asp:Label runat="server" ID="ImageDeniedNewPrescriptionsLabel">
                                                                            <asp:Image ID="ImageDeniedNewPrescriptions" runat="server" ToolTip="Denied New Prescription To Follow" Style="cursor: pointer;" />
                                                                        </asp:Label>--%>
                                                <asp:Label runat="server" ID="ImageDenyLabel">
                                                    <asp:Image ID="ImageDeny" runat="server" ToolTip="Denied" Style="cursor: pointer;" ImageUrl="~/App_Themes/Includes/Images/enable_22.png" />
                                                </asp:Label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><b>Date Received:</b></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <%# Eval("CreatedDate","{0:M/d/yyyy}") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <%# Eval("CreatedDate", "{0:h:mm tt}") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="ErrorSpan" Font-Bold="True" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td valign="top" width="13%">
                            <!-- patient -->
                            <div id="divPatient" runat="server">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td colspan="2">
                                            <asp:Label runat="server" ID="ImageSearchLabel">
                                                <asp:Image ID="ImageSearch" ImageUrl="~/App_Themes/Includes/Images/SearchRefillRequest.gif"
                                                    runat="server" Style="cursor: pointer;" ToolTip="Patient Search" />
                                            </asp:Label>

                                            <span <%# Eval("ClientId").ToString() != "" ? "style='text-decoration: underline;cursor: pointer;font-weight:bold;' onclick='OpenPatientMainPage(" + Eval("ClientId") + ");'" : "" %>>
                                                <%# Eval("ClientLastName") %>, <%# Eval("ClientFirstName") %> <%# Eval("ClientMiddleName") %>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><b>DOB:</b> <%# Eval("ClientDOB","{0:M/d/yyyy}") %>
                                            <asp:Label runat="server" ID="ClientDOBAge"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2"><b>Gender:</b> <%# Eval("ClientSex").ToString() == "F" ? "Female" : "Male"  %></td>
                                    </tr>
                                    <tr style='<%# Eval("ClientAddress1").ToString() == "" ? "display:none;": "" %>'>
                                        <td colspan="2"><%# Eval("ClientAddress1") %></td>
                                    </tr>
                                    <tr style='<%# Eval("ClientAddress2").ToString() == "" ? "display:none;": "" %>'>
                                        <td colspan="2"><%# Eval("ClientAddress2") %></td>
                                    </tr>
                                    <tr style='<%# Eval("ClientCity").ToString() == "" ? "display:none;": "" %>'>
                                        <td colspan="2"><%# Eval("ClientCity") %>, <%# Eval("ClientState") %> <%# Eval("ClientZip") %></td>
                                    </tr>
                                    <tr style='<%# Eval("ClientPhone").ToString() == "" ? "display:none;": "" %>'>
                                        <td colspan="2"><b>PH:</b> <%# Eval("ClientPhone") %></td>
                                    </tr>
                                    <tr style='<%# Eval("ClientFax").ToString() == "" ? "display:none;": "" %>'>
                                        <td colspan="2"><b>Fax:</b> <%# Eval("ClientFax") %></td>
                                    </tr>
                                    <tr>
                                        <tr style='<%# Eval("PayerId").ToString() == "" ? "display:none;": "display:block;" %>'>
                                            <td colspan="2"><b>PayerId:</b> <%# Eval("PayerId") %></td>
                                        </tr>
                                        <tr style='<%# Eval("BINLocationNumber").ToString() == "" ? "display:none;": "display:block;" %>'>
                                            <td colspan="2"><b>BIN:</b> <%# Eval("BINLocationNumber") %></td>
                                        </tr>
                                        <tr style='<%# Eval("PayerName").ToString() == "" ? "display:none;": "display:block;" %>'>
                                            <td colspan="2"><b>PayerName:</b> <%# Eval("PayerName") %></td>
                                        </tr>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td valign="top" width="25%">
                            <!-- Prescribed -->
                            <div id="divMedicationPrescribed" runat="server">
                                <table cellpadding="0" cellspacing="0" border="0" style="padding-right: 3px;">
                                    <tr>
                                        <td>
                                            <asp:Label runat="server" ID="ImageSearchMedicationLabel">
                                                <asp:Image ID="ImageSearchMedication" ImageUrl="~/App_Themes/Includes/Images/SearchRefillRequest.gif"
                                                    runat="server" Style="cursor: pointer;" ToolTip="Current Medications" />
                                            </asp:Label>
                                        </td>
                                        <td><%# Eval("DrugDescription") %></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><span style="color: darkviolet; font-weight: bold;">
                                            <%# Eval("MedicationName").ToString() != "" ? "(" + Eval("MedicationName").ToString() + ")" : "" %> 
                                        </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><b>Qty:</b> <%# Eval("QuantityValue","{0:0.##########}") %> &nbsp;&nbsp; <b>Refills:</b> <%# Eval("RefillType").ToString() == "PRN" ? "PRN" : Eval("NumberOfRefills") %> &nbsp;&nbsp; <b>Days Supply:</b> <%# Eval("NumberOfDaysSupply") %> &nbsp;&nbsp; <b>DAW:</b> <%# Eval("Substitutions").ToString() == "1" || Eval("Substitutions").ToString() == "7" ? "Y" : "N" %></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><b>Potency:</b> <%# Eval("PotencyUnitCodeDesc") %> &nbsp;&nbsp; <b>Written Date:</b> <%# Eval("WrittenDate","{0:M/d/yyyy}") %></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><b>Directions:</b> <%# Eval("Directions") %></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td><b>Notes:</b> <%# Eval("Note") %></td>
                                    </tr>
                                    <tr style='<%# Eval("Diagnosis1").ToString() == "" ? "display:none;": "display:block;" %>'>
                                        <td></td>
                                        <td><b>Diagnois:</b> <%# Eval("Diagnosis1") %></td>
                                    </tr>
                                    <tr style='<%# Eval("Diagnosis2").ToString() == "" ? "display:none;": "display:block;" %>'>
                                        <td></td>
                                        <td><b>Diagnois:</b> <%# Eval("Diagnosis2") %></td>
                                    </tr>
                                    <tr style='<%# Eval("PriorAuthValue").ToString() == "" ? "display:none;": "display:block;" %>'>
                                        <td></td>
                                        <td><b>Prior Authorizations:</b> <%# "(" + Eval("PriorAuthQualifier") +") " + Eval("PriorAuthValue") %></td>
                                    </tr>
                                    <tr style='<%# Eval("PriorAuthStatus").ToString() == "" ? "display:none;": "display:block;" %>'>
                                        <td></td>
                                        <td><b>Prior Authorization Status:</b> <%# Eval("PriorAuthStatus") %></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td valign="top" width="25%">
                            <!-- Requested -->
                            <table cellpadding="0" cellspacing="0" border="0" style="padding-right: 3px;">
                                <%-- <tr>
                                                                <td><%# Eval("RequestedDrugDescription") %></td>
                                                            </tr>
                                                            <tr>
                                                                <td><b>Qty:</b> <%# Eval("RequestedQuantityValue","{0:0..##########}") %> &nbsp;&nbsp; <b>Refills:</b> <%# Eval("RequestedNumberOfRefills") %> &nbsp;&nbsp; <b>Days Supply:</b> <%# Eval("RequestedNumberOfDaysSupply") %> &nbsp;&nbsp; <b>DAW:</b> <%# Eval("RequestedSubstitutions").ToString() == "1" || Eval("RequestedSubstitutions").ToString() == "7" ? "Y" : "N" %></td>
                                                            </tr>
                                                            <tr>
                                                                <td><b>Potency:</b> <%# Eval("RequestedPotencyUnitCodeDesc") %> &nbsp;&nbsp; <b>Written Date:</b> <%# Eval("RequestedWrittenDate","{0:M/d/yyyy}") %></td>
                                                            </tr>
                                                            <tr>
                                                                <td><b>Directions:</b> <%# Eval("RequestedDirections") %></td>
                                                            </tr>
                                                            <tr>
                                                                <td><b>Notes:</b> <%# Eval("RequestedNote") %></td>
                                                            </tr>
                                                            <tr style='<%# Eval("RequestedDiagnosis1").ToString() == "" ? "display:none;": "display:block;" %>'>
                                                                <td><b>Diagnois:</b> <%# Eval("RequestedDiagnosis1") %></td>
                                                            </tr>
                                                            <tr style='<%# Eval("RequestedDiagnosis2").ToString() == "" ? "display:none;": "display:block;" %>'>
                                                                <td><b>Diagnois:</b> <%# Eval("RequestedDiagnosis2") %></td>
                                                            </tr>
                                                            <tr style='<%# Eval("RequestedPriorAuthValue").ToString() == "" ? "display:none;": "display:block;" %>'>
                                                                <td><b>Prior Authorizations:</b> <%# "(" + Eval("RequestedPriorAuthQualifier") +") " + Eval("RequestedPriorAuthValue") %></td>
                                                            </tr>
                                                            <tr style='<%# Eval("RequestedPriorAuthStatus").ToString() == "" ? "display:none;": "display:block;" %>'>
                                                                <td><b>Prior Authorization Status:</b> <%# Eval("RequestedPriorAuthStatus") %></td>
                                                            </tr>--%>
                                <tr style='<%# Eval("ChangeRequestType").ToString() == "P" ? "display:block;": "display:none;" %>'>
                                    <td><span style="color: green; font-weight: bold;">Prior Authorization Required
                                    </span>
                                    </td>
                                </tr>
                                <%# Eval("SureScriptsChangeMedicationRequests") %>
                                <%--  <%if(Eval("SureScriptsChangeMedicationRequests").ToString()!=null) %>>
                                                                <%{ %>
                                                                <%# Eval("SureScriptsChangeMedicationRequests") %>       
                                                                <%} %>
                                                                else  <% {%>
                                                                <tr style='<%# Eval("ChangeRequestType").ToString() == "P" ? "display:block;": "display:none;" %>'>
                                                                <td><span style="color: green; font-weight: bold;">Prior Authorization Required
                                                                </span>
                                                                </td></tr>
                                                                <% }%>--%>
                            </table>
                        </td>
                        <td valign="top" width="17%">
                            <!-- Pharmacy -->
                            <div runat="server" id="divPharmacy">
                                <table cellpadding="0" cellspacing="0" border="0" style="padding-right: 3px;">
                                    <tr>
                                        <td><%# Eval("PharmacyName") %></td>
                                    </tr>
                                    <tr>
                                        <td><%# Eval("PharmacyAddress") %></td>
                                    </tr>
                                    <tr>
                                        <td><%# Eval("PharmacyCity") %>, <%# Eval("PharmacyState") %> <%# Eval("PharmacyZip") %></td>
                                    </tr>
                                    <tr>
                                        <td><b>PH:</b> <%# Eval("PharmacyPhoneNumber") %></td>
                                    </tr>
                                    <tr>
                                        <td><b>Fax:</b> <%# Eval("PharmacyFaxNumber") %></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td valign="top" width="12%">
                            <!-- prescriber -->
                            <div id="divPrescriber" runat="server">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td><%# Eval("PrescriberLastName") %>, <%# Eval("PrescriberFirstName") %></td>
                                    </tr>
                                    <tr style='<%# Eval("PrescriberAddress1").ToString() == "" ? "display:none;": "display:block;" %>'>
                                        <td><%# Eval("PrescriberAddress1") %></td>
                                    </tr>
                                    <tr style='<%# Eval("PrescriberAddress2").ToString() == "" ? "display:none;": "display:block;" %>'>
                                        <td><%# Eval("PrescriberAddress2") %></td>
                                    </tr>
                                    <tr style='<%# Eval("PrescriberCity").ToString() == "" ? "display:none;": "display:block;" %>'>
                                        <td><%# Eval("PrescriberCity") %>, <%# Eval("PrescriberState") %> <%# Eval("PrescriberZip") %></td>
                                    </tr>
                                    <tr style='<%# Eval("PrescriberPhone").ToString() == "" ? "display:none;": "display:block;" %>'>
                                        <td><b>PH:</b> <%# Eval("PrescriberPhone") %></td>
                                    </tr>
                                    <tr style='<%# Eval("PrescriberFax").ToString() == "" ? "display:none;": "display:block;" %>'>
                                        <td><b>Fax:</b> <%# Eval("PrescriberFax") %></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                </EmptyDataTemplate>
            </asp:ListView>
        </asp:Panel>
        <font style="display: none">##ENDRXCHANGE##</font>
    </form>
</body>
</html>
