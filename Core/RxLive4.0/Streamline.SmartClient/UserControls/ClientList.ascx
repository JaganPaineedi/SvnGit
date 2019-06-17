<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ClientList.ascx.cs" Inherits="UserControls_ClientList" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>
<%@ Register Src="~/UserControls/OutboundPrescriptions.ascx" TagPrefix="OP" TagName="OutboundPrescriptions" %>

<asp:ScriptManagerProxy ID="SMPMgt" runat="server">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationClientPersonalInformation.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<script language="javascript" type="text/javascript">
    function GetFocus() {
        document.getElementById('<%=TextBoxAnswer1.ClientID%>').focus();
    }
</script>


<script language="javascript" type="text/javascript">
    function pageLoadSelectClient(SelectedClientId) {
        var DivSearch = parent.document.getElementById('DivSearch');
        DivSearch.style.display = 'none';
        document.getElementById('<%=TextBoxAnswer1.ClientID%>').focus();
    }
    function BeforeSubmit() {
        var LabelErrorMessage = document.getElementById('<%=this.ClientID+this.ClientIDSeparator%>LabelErrorMessage');
        var DivErrorMessage = document.getElementById('<%=this.ClientID+this.ClientIDSeparator%>DivErrorMessage');
        var ImageError = document.getElementById('<%=this.ClientID+this.ClientIDSeparator%>ImageError');
        //Code to clear Error Messages.
        LabelErrorMessage.innerText = '';
        ImageError.style.visibility = 'hidden';
        ImageError.style.display = 'none';

        if (document.getElementById('<%=TextBoxAnswer1.ClientID%>').value == '') {
            DivErrorMessage.style.display = 'block';
            ImageError.style.display = 'block';
            ImageError.style.visibility = 'visible';
            LabelErrorMessage.style.display = 'block';
            LabelErrorMessage.style.visibility = 'visible';
            document.getElementById('<%=TextBoxAnswer1.ClientID%>').focus();
            LabelErrorMessage.innerText = 'Please enter the Answer of following Security Question.';
            return false;
        }
    }
    //Code added by Loveena in ref to Task#85 to open PatientMainPage on click of hyperlink PatientName
    function OpenPatientMainPage(clientid) {
        SetPatientMainPage(clientid);
    }
</script>

<script type="text/javascript">
    $(document).ready(function () {
        // Code added by jyothi s part of Journey-Support Go Live -#1566
        var StaffPermissionForClientDropDown = $('[id$=HiddenFieldIsStaffHasPermissionforClientsDropDown]').val();
        if (StaffPermissionForClientDropDown == 'false') {
            $('[id$=ButtonPatientSearch]').prop("disabled", true);
        }
        $(".tab_content").hide(); //Hide all content
        $("ul.tabs li:first").addClass("active").show(); //Activate first tab
        $(".tab_content:first").show(); //Show first tab content
        $("#DivHolderMain")[0].style.height = "100%";
        $("#PlaceHolderMain")[0].style.height = "100%";
        $("ul.tabs li").click(function () {
            $('html, body').animate({ scrollTop: 0 }, 0);
            $("ul.tabs li").removeClass("active"); //Remove any "active" class
            $(this).addClass("active"); //Add "active" class to selected tab
            $(".tab_content").hide(); //Hide all tab content
            var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
            $(activeTab).fadeIn(); //Fade in the active ID content
            if (activeTab == "#tab2") {
                var outboundTable = $("#tblOutBoundPrescription", $(activeTab));
                var width = $(window).width();
                var tableWidth = $(".ListPageHeader>table", outboundTable).width();
                $(".ListPageHeader", outboundTable).width((width >= tableWidth ? tableWidth : (width - 18)));
                tableWidth = tableWidth + 18;
                $(".ListPageContent", outboundTable).width((width >= tableWidth ? tableWidth : width));
            }
            var heihtToSet = 0;
            if (activeTab == "#tab5") {
                var outboundTable = $("#tblOutBoundPrescription", $(activeTab));
                var width = $(window).width();
                var tableWidth = $(".ListPageHeader>table", outboundTable).width();
                $(".ListPageHeader", outboundTable).width((width >= tableWidth ? tableWidth : (width - 18)));
                tableWidth = tableWidth + 18;
                $(".ListPageContent", outboundTable).width((width >= tableWidth ? tableWidth : width));
            }
            var heihtToSet = 0;
        });
    });
</script>

<asp:Panel ID="PanelStartPage" runat="server" Style="bottom: 20px">

    <div>
        <table id="Header" width="100.7%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td align="left" style="width: 60%;" class="header">
                    <asp:Label ID="Label1" runat="server" Visible="true" Style="color: white;"
                        Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
                </td>
                <td style="width: 30%; padding-right: 0.7%;" align="right" class="header">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td align="right" style="width: 50%">
                                <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" runat="server" OnClientClick="redirectToStartPage();this.disabled=true;return false;" Style="display: none; color: white;"></asp:LinkButton>
                            </td>
                            <td align="right" style="width: 10%">
                                <asp:ImageButton ID="LinkButtonLogout" Style="display: none" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Text="" runat="server" OnClick="LinkButtonLogout_Click" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 1pt; border-bottom: #5b0000 1px solid;"></td>
            </tr>
        </table>
    </div>
    <table width="100%">
        <tr>
            <td style="width: 10%">
                <asp:Label ID="LabelTitleBar" runat="server" Visible="true" CssClass="TittleBarBase"
                    Text="Start Page"></asp:Label>
            </td>
            <td style="float: right;">
                <div class="button-group round">

                    <asp:Button ID="ButtonMyPreferences" runat="server" CssClass="btnimglarge" EnableTheming="false" TabIndex="6" Text="My Preferences"
                        OnClientClick="redirectToUserPreferencesPage('ClientList');this.disabled=true;return false;" OnClick="ButtonMyPreferences_Click" />
                    <asp:Button ID="ButtonPatientSearch" runat="server" CssClass="btnimglarge" EnableTheming="false" TabIndex="7" Text="Patient Search..."
                        OnClick="ButtonPatientSearch_Click" />
                    <asp:Button ID="ButtonManageUsers" runat="server" CssClass="btnimglarge" EnableTheming="false" TabIndex="8" Text="Manage Users"
                        OnClientClick="redirectToUserManagementPage();this.disabled=true;return false;" />
                    <asp:Button ID="ButtonManagePharmacies" runat="server" CssClass="btnimglarge" EnableTheming="false" TabIndex="9"
                        Text="Manage Pharmacies" OnClientClick="redirectToPharmacyManagementPage();this.disabled=true;return false;" />
                    <asp:Button ID="ButtonPrinter" runat="server" CssClass="btnimglarge" EnableTheming="false" TabIndex="10" Text="Printer Device Locations"
                        OnClientClick="redirectToPrinterDeviceLocationPage();this.disabled=true;return false;" />


                    <asp:Button ID="ButtonRefreshSharedTables" runat="server" CssClass="btnimglarge" EnableTheming="false" TabIndex="11" Text="Refresh Shared Tables" OnClientClick="RefreshSharedTablesStartPage();return false;" />
                    <asp:Button ID="ButtonReviewPrescriptions" runat="server" CssClass="btnimglarge" EnableTheming="false" Text="Pending Review" TabIndex="12" OnClientClick="redirectToReviewPrescriptions();this.disabled=true;return false;" />
                    <asp:Button ID="ButtonVerbalOrders" runat="server" CssClass="btnimglarge" EnableTheming="false" Text="Verbal Orders" OnClientClick="redirectToVerbalOrder('V');this.disabled=true;return false;" TabIndex="13"/>
                    <asp:Button ID="ButtonQueuedOrders" runat="server" CssClass="btnimglarge" EnableTheming="false" Text="Queued Orders" OnClientClick="redirectToVerbalOrder('A');this.disabled=true;return false;" TabIndex="14" />

                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="height: 1pt; border-bottom: #5b0000 1px solid;"></td>
        </tr>
    </table>
    <!--Added in ref to Task#2700!-->
    <table border="0" cellpadding="0" cellspacing="0" style="width: 980px">
        <tr>
            <td nowrap="nowrap" align="center">&nbsp;
                <asp:Label ID="LabelMainError" runat="server" CssClass="redTextError" Height="18px"
                    Style="vertical-align: middle"></asp:Label>
            </td>
        </tr>
    </table>
    <table id="StartPage" width="98%" border="0" cellpadding="0" cellspacing="0" runat="server">
        <tr>
            <%--<td width="950px" class="btn-group" align="left">
                
                <asp:Button ID="ButtonMyPreferences" runat="server" EnableTheming="false" TabIndex="6" Text="My Preferences"
                    OnClientClick="redirectToUserPreferencesPage('ClientList');this.disabled=true;return false;" OnClick="ButtonMyPreferences_Click" />
                <asp:Button ID="ButtonPatientSearch" runat="server" EnableTheming="false"  TabIndex="7" Text="Patient Search"
                    OnClick="ButtonPatientSearch_Click" />
                <asp:Button ID="ButtonManageUsers"  runat="server" EnableTheming="false" TabIndex="8" Text="Manage Users"
                    OnClientClick="redirectToUserManagementPage();this.disabled=true;return false;" />
                <asp:Button ID="ButtonManagePharmacies"  runat="server" EnableTheming="false" TabIndex="9"
                    Text="Manage Pharmacies" OnClientClick="redirectToPharmacyManagementPage();this.disabled=true;return false;" />
                <asp:Button ID="ButtonPrinter" runat="server" EnableTheming="false" TabIndex="10" Width="185px" Text="Printer Device Locations"
                    OnClientClick="redirectToPrinterDeviceLocationPage();this.disabled=true;return false;" />
                <asp:Button ID="ButtonRefreshSharedTables" runat="server" EnableTheming="false" TabIndex="11"  Text="Refresh Shared Tables" OnClientClick="RefreshSharedTablesStartPage();return false;" />
                <asp:Button ID="ButtonReviewPrescriptions" runat="server" EnableTheming="false" Text="Pending Review"  TabIndex="12" OnClientClick="redirectToReviewPrescriptions();this.disabled=true;return false;" />
                <asp:Button ID="ButtonVerbalOrders" runat="server" EnableTheming="false" Text="Verbal Orders" OnClientClick="redirectToVerbalOrder('V');this.disabled=true;return false;" TabIndex="13" />
                <asp:Button ID="ButtonQueuedOrders" runat="server" EnableTheming="false" Text="Queued Orders" OnClientClick="redirectToVerbalOrder('A');this.disabled=true;return false;" TabIndex="14" />
                 <asp:HiddenField ID="HiddenFieldVerbalOrderType" runat="server" />
                  
            </td>--%>
        </tr>
    </table>
    <table id="TableDashboard" runat="server" cellpadding="0" cellspacing="0" border="0" style="margin-left: 8px;" width="99%" class="TableDashboard">
        <tr>
            <td>&nbsp;
            </td>
        </tr>
        <tr>
            <td id="tdDashboard" valign="top" rowspan="2" style="height: 350px; height: 1pt;">
                <ul class="tabs" style="width: 100%">
                    <li style="left: 0px; top: 0px"><a href="#tab1">Refill Requests</a></li>
                    <li><a href="#tab2">Outbound Prescriptions</a></li>
                    <li><a href="#tab3" style="display: none;">Favorites</a></li>
                    <li><a href="#tab4">Rx Change</a></li>
                    <li><a href="#tab5">Rx Fill</a></li>
                </ul>
                <div style="width: 100%;" style="border-top: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-bottom: #dee7ef 3px solid;">
                    <div id="tab1" class="tab_content" style="height: 320px;">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="labelFont">Prescriber</span>
                                    <asp:DropDownList ID="DropDownListRefillPrescriber" runat="server" Width="298px">
                                    </asp:DropDownList>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <%--Added By Priya Ref: task No: 85--%>
                                    <asp:Panel ID="PanelRefillRequest" runat="server" ScrollBars="Vertical" Height="450px" Width="100%" Style="overflow-x: none; overflow-y: auto;">
                                        <asp:ListView runat="server" ID="RefillList" OnItemDataBound="RenderRefillRequestRow">
                                            <LayoutTemplate>
                                                <table cellpadding="0" cellspacing="1" border="0" style="font-size: 12px;" width="100%">
                                                    <tr style="background-color: #dce5ea; font-weight: bold; text-decoration: underline; height: 20px; cursor: pointer; font-size: larger;">
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
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="tab2" class="tab_content" style="display: none;">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="labelFont">Prescriber</span>
                                    <asp:DropDownList ID="DropDownListOutBoundPrescriber" runat="server" Width="298px">
                                    </asp:DropDownList>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <OP:OutboundPrescriptions ID="OutboundPrescriptionsControl" runat="server"></OP:OutboundPrescriptions>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="tab3" class="tab_content" style="overflow-x: hidden; overflow-y: hidden; height: 320px;">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <asp:GridView ID="GridViewResources" runat="server" GridLines="None" AutoGenerateColumns="False"
                                RowStyle-Height="10px" CellPadding="0" BorderWidth="0px" ShowHeader="false" Width="98%"
                                OnRowDataBound="GridViewResources_RowDataBound" EnableViewState="false">
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemStyle Width="12px" />
                                    </asp:TemplateField>
                                </Columns>
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemStyle HorizontalAlign="Left" />
                                        <ItemTemplate>
                                            <b><a style='cursor: pointer; color: Blue; font-size: small' href='<%#Eval("CodeName")%>'
                                                target="_blank">
                                                <%#Eval("Description")%>
                                            </a></b>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </table>
                    </div>
                    <%--Added By PranayB Ref: task No:RXCHANGE MU Changes--%>
                    <div id="tab4" class="tab_content" style="height: 320px;">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="labelFont">Prescriber</span>
                                    <asp:DropDownList ID="DropDownListChangePrescriber" runat="server" Width="298px">
                                    </asp:DropDownList>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <%--Added By PranayB Ref: task No:RXCHANGE MU Changes--%>
                                    <asp:Panel ID="PanelChangeRequest" runat="server" ScrollBars="Vertical" Height="320px" Width="100%" Style="overflow-x: none; overflow-y: auto;">
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
                                </td>
                            </tr>
                        </table>
                    </div>
                    <%--Added By Pranay Ref: task No:RXFILL MU Changes--%>
                    <div id="tab5" class="tab_content" style="display: none;">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="labelFont">Prescriber</span>
                                    <asp:DropDownList ID="DropDownListStartPresriber" runat="server" Width="298px">
                                    </asp:DropDownList>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <OP:OutboundPrescriptions ID="RxFillControl" runat="server"></OP:OutboundPrescriptions>

                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</asp:Panel>
<table border="0" cellpadding="0" cellspacing="0" style="font-size: 12pt; font-family: Times New Roman">
    <tr>
        <td>
            <asp:Label ID="LabelClientScript" runat="server" Text="Label" Visible="false"></asp:Label>
        </td>
    </tr>
</table>
<!-- Ref to Task#2595 !-->
<table id="TableSecurityQuestion" width="400" border="0" align="center" cellpadding="0"
    cellspacing="0" style="vertical-align: middle; margin-top: 15%; margin-bottom: 20%; display: none;"
    runat="server" class="loginborder">
    <tr>
        <td align="left" colspan="3" width="100%">
            <table border="0" width="100%">
                <tbody>
                    <tr>
                        <td align="center" nowrap="nowrap">
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="middle">
                                        <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif" Style="display: none;" />
                                    </td>
                                    <td valign="middle" nowrap="nowrap">&nbsp;
                                        <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError" Height="18px"></asp:Label>
                                    </td>
                                    <td valign="middle">
                                        <div id="DivErrorMessage" runat="server" style="display: none; width: 22px; height: 12px">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="TrErrorMessage" runat="server">
                        <td align="center" nowrap="nowrap">
                            <span class="Label"><b>Please answer the following security questions to login the application</b></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </td>
    </tr>
    <tr id="TrQuestion" runat="server">
        <td align="right">
            <span class="Label">Question&nbsp; </span>
        </td>
        <td align="left" width="2%">:
        </td>
        <td align="left" width="68%">
            <span class="Label" id="Question1" runat="server"></span>
        </td>
    </tr>
    <tr id="TrAnswer" runat="server">
        <td align="right">
            <span class="Label">Answer </span>
        </td>
        <td align="left">:<span style="color: #ff0000">*</span>
        </td>
        <td align="left">
            <asp:TextBox ID="TextBoxAnswer1" runat="server" TabIndex="1" Width="300px" TextMode="Password"></asp:TextBox>
        </td>
    </tr>
    <!--Added in ref to Task#2954 !-->
    <tr>
        <td style="height: 6px" colspan="3"></td>
    </tr>
    <tr id="CurrentLocation" runat="server">
        <td align="right">
            <span class="Label">Current Location </span>
        </td>
        <td align="left">:
        </td>
        <td align="left">
            <asp:DropDownList ID="DropDownListLocations" runat="server" Width="305px" TabIndex="2">
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td align="right">
            <br />
            <br />
            &nbsp;
        </td>
        <td align="center"></td>
        <td align="left">
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<asp:Button ID="ButtonSubmit" Text="Submit"
                runat="server" CssClass="btnimgexsmall" OnClick="ButtonSubmit_Click" TabIndex="3" />
            <asp:Button runat="server" ID="ButtonCancel" Text="Cancel" CausesValidation="False"
                CssClass="btnimgexsmall" OnClick="ButtonCancel_Click" TabIndex="4"></asp:Button>
        </td>
    </tr>
</table>


<asp:HiddenField ID="HiddenSecurityAnswer" runat="server" />
<asp:HiddenField ID="HiddenFieldFirstChance" runat="server" />
<asp:HiddenField ID="HiddenFieldSecondChance" runat="server" />
<asp:HiddenField ID="HiddenFiledProxyPrescriber" runat="server" />
<asp:HiddenField ID="HiddenFieldIsStaffHasPermissionforClientsDropDown" runat="server" />
