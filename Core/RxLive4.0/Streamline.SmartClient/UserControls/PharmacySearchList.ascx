<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PharmacySearchList.ascx.cs"
    Inherits="UserControls_PharmacySearchList" %>
<div id="DivPharmacyList" style="width: 100%; overflow: none; height: 280px;">
    <asp:Panel ID="PanelPharmaciesListSearchPage" runat="server">
        <asp:GridView ID="GridViewSearchPharmacies" runat="server" AllowSorting="True" AutoGenerateColumns="False"
            BorderWidth="0px" CellPadding="0" GridLines="None" RowStyle-Height="10px" EnableViewState="False"
            Width="100%" OnRowDataBound="GridViewSearchPharmacies_RowDataBound">
            <AlternatingRowStyle CssClass="ListPageAltRow" />
            <PagerSettings Visible="False" />
            <RowStyle CssClass="GridViewRowStyle ListPageHLRow" Height="10px" />
            <HeaderStyle CssClass="GridViewHeaderText" />
            <PagerStyle CssClass="GridViewPagerText" />
            <Columns>
                <asp:TemplateField SortExpression="PharmacyId">
                    <ItemTemplate>
                        <asp:Literal ID="ButtonPharmacyId" runat="server"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:Label ID="LabelHeaderPharmacyId" Text="ID" runat="server" Style="cursor: pointer;
                            text-decoration: underline"></asp:Label>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:Label ID="LabelPharmacyId" runat="server" Text='<%# Eval("PharmacyId")%>'>
                        </asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" Width="5%" />
                    <ItemStyle HorizontalAlign="Left" Width="5%" Wrap="False" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:Label ID="LabelHeaderActive" Text="Active" runat="server" Style="cursor: pointer;
                            text-decoration: underline"></asp:Label>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:Label ID="LabelActive" runat="server" Text='<%#Eval("Active")%>'>
                        </asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Left" Width="5%" />
                    <ItemStyle HorizontalAlign="Left" Width="5%" Wrap="False" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:Label ID="LabelHeaderPreferredPharmacy" Text="Pref" runat="server" Style="cursor: pointer;
                            text-decoration: underline"></asp:Label>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:Label ID="LabelPreferredPharmacy" Text='<%#Eval("PreferredPharmacy")%>' runat="server"></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Left" Width="6%" Wrap="False" />
                    <HeaderStyle HorizontalAlign="Left" Width="6%" />
                </asp:TemplateField>
                <asp:TemplateField SortExpression="PharmacyName">
                    <HeaderTemplate>
                        <asp:Label ID="LabelHeaderPharmacyName" Text="Name" runat="server" Style="cursor: pointer;
                            text-decoration: underline"></asp:Label>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:Label ID="LabelPharmacyName" runat="server" Text='<%# Eval("PharmacyName")%>'>
                        </asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Left" Width="17%" Wrap="False" />
                    <HeaderStyle HorizontalAlign="Left" Width="17%" />
                </asp:TemplateField>
                <asp:TemplateField SortExpression="UserCode">
                    <HeaderTemplate>
                        <asp:Label ID="LabelHeaderAddress" Text="Address" runat="server" Style="cursor: pointer;
                            text-decoration: underline"></asp:Label>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:Label ID="LabelAddress" runat="server" Text='<%# Eval("Address")%>'>
                        </asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Left" Width="30%" Wrap="False" />
                    <HeaderStyle HorizontalAlign="Left" Width="30%" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Label ID="LabelPhoneNumber" runat="server" Text='<%# Eval("PhoneNumber")%>'>
                        </asp:Label>
                    </ItemTemplate>
                    <HeaderTemplate>
                        <asp:Label ID="LabelHeaderPhoneNumber" runat="server" Style="cursor: pointer; text-decoration: underline"
                            Text="Phone"></asp:Label>
                    </HeaderTemplate>
                    <HeaderStyle HorizontalAlign="Left" Width="10%" />
                    <ItemStyle HorizontalAlign="Left" Width="10%" Wrap="False" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:Label ID="LabelHeaderFax" Text="Fax" runat="server" Style="cursor: pointer; text-decoration: underline"></asp:Label>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:Label ID="LabelFax" runat="server" Text='<%# Eval("FaxNumber")%>'>
                        </asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Left" Width="10%" Wrap="False" />
                    <HeaderStyle HorizontalAlign="Left" Width="10%" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Label ID="LabelSureScriptsPharmacyIdentifier" runat="server" Text='<%# Eval("SureScriptsPharmacyIdentifier")%>'>
                        </asp:Label>
                    </ItemTemplate>
                    <HeaderTemplate>
                        <asp:Label ID="LabelHeaderSureScriptsPharmacyIdentifier" runat="server" Style="cursor: pointer;
                            text-decoration: underline" Text="NCPDP"></asp:Label>
                    </HeaderTemplate>
                    <HeaderStyle HorizontalAlign="Left" Width="10%" />
                    <ItemStyle HorizontalAlign="Left" Width="10%" Wrap="False" />
                </asp:TemplateField>
                <asp:TemplateField>
                    <HeaderTemplate>
                        <asp:Label ID="LabelHeaderSpecialty" Text="Specialty" runat="server"></asp:Label>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <asp:Label ID="LabelSpecialty" runat="server" Text='<%# Eval("Specialty")%>'>
                        </asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Left" Width="10%" Wrap="False" />
                    <HeaderStyle HorizontalAlign="Left" Width="10%" />
                </asp:TemplateField>
                <asp:TemplateField Visible="false">
                    <ItemTemplate>
                        <asp:Label ID="LabelExternalReferenceId" runat="server" Text='<%# Eval("ExternalReferenceId")%>'>
                        </asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Left" Width="17%" Wrap="False" />
                    <HeaderStyle HorizontalAlign="Left" Width="17%" />
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <table cellspacing="0" cellpadding="0" border="0" style="border-width: 0px; width: 100%;
                    border-collapse: collapse;">
                    <tr class="GridViewHeaderText" style="height: 20px;">
                        <th scope="col">
                            &nbsp;
                        </th>
                        <th align="left" scope="col">
                            ID
                        </th>
                        <th scope="col">
                            Active
                        </th>
                        <th align="left" scope="col">
                            Preferred
                        </th>
                        <th align="left" scope="col">
                            Name
                        </th>
                        <th align="center" scope="col">
                            Address
                        </th>
                        <th align="center" scope="col">
                            Phone
                        </th>
                        <th align="center" scope="col">
                            Fax
                        </th>
                        <th align="center" scope="col">
                            NCPDP Number
                        </th>
                        <th align="center" scope="col">Specialty</th>
                    </tr>
                    <tr class="GridViewRowStyle" style="height: 10px;">
                        <td align="center" colspan="10" valign="middle">
                            No Records Found
                        </td>
                    </tr>
                </table>
            </EmptyDataTemplate>
        </asp:GridView>
    </asp:Panel>
</div>
<div>
    <table border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <asp:LinkButton ID="LinkButtonPrevious" runat="server" OnClientClick="PagingPharmacyList('Previous'); return false;">Previous</asp:LinkButton>
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                <asp:LinkButton ID="LinkButtonNext" runat="server" OnClientClick="PagingPharmacyList('Next'); return false;">Next</asp:LinkButton>
            </td>
            <td style="width: 60%">
            </td>
            <td align="center">
                <asp:Label ID="LabelPageNumber" Style="font-family: Microsoft Sans Serif; font-size: 8.25pt;"
                    runat="server"></asp:Label>
                <asp:Label ID="LabelTotalPages" Style="font-family: Microsoft Sans Serif; font-size: 8.25pt;"
                    runat="server"></asp:Label>
            </td>
        </tr>
    </table>
</div>
