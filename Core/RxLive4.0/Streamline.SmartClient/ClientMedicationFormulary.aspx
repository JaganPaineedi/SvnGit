<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ClientMedicationFormulary.aspx.cs"
    Inherits="ClientMedicationFormulary" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Drug Formulary</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript">
        var ClientMedicationFomulary = {
            closeDiv: function() {
                try {
                    var DivSearch = parent.document.getElementById('DivSearch1');
                    DivSearch.style.display = 'none';
                }
                catch (Err) {
                    alert("ClientMedicationFomulary.closeDiv" + Err.message);
                }

            }
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <table border="0" cellpadding="0" cellspacing="0" style="width: 400px;">
        <tr class="PopUpTitleBar">
            <td width="90%" id="topborder" valign="middle" class="TitleBarText">
                Drug Formulary
            </td>
            <td align="right" width="10%">
                <img id="ImgCross" onclick="ClientMedicationFomulary.closeDiv()" src='<%= Page.ResolveUrl("~/App_Themes/Includes/Images/cross.jpg") %>'
                    title="Close" alt="Close" />
            </td>
        </tr>
    </table>
    <div style="width: 400px; height: 300px; overflow: auto;">
        <table border="0" cellpadding="0" cellspacing="0" style="width: 400px;">
            <tr>
                <td colspan="2">
                    <asp:Label ID="lbPBM" runat="server" Text="PBM NAME :"></asp:Label>
                    &nbsp;<asp:DropDownList ID="ddlPBM" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlPBM_SelectedIndexChanged"
                        Height="21px" Width="232px">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label ID="Status" runat="server" ForeColor="Red" Font-Bold="true" Style="padding-left: 5px;"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdbg" colspan="2">
                    PatientDetails
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 10px;">
                    <asp:GridView ID="GVPatient" runat="server" AutoGenerateColumns="False" ShowHeader="False">
                        <Columns>
                            <asp:BoundField DataField="InfoType" />
                            <asp:BoundField DataField="Info" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td class="tdbg" colspan="2">
                    PBM Details
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 10px;">
                    <asp:Label ID="lbPBMName" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdbg" colspan="2">
                    Formulary Details
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 10px;">
                    <asp:Label ID="lbFormulary" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="tdbg" colspan="2">
                    DrugType
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 10px;">
                    <p>
                        <asp:Label ID="lbDrugType" runat="server"></asp:Label></p>
                    <p>
                        <asp:Label ID="lbDrugClass" runat="server"></asp:Label></p>
                </td>
            </tr>
            <tr>
                <td class="tdbg" colspan="2">
                    Coverage Details
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 10px;">
                    <asp:GridView ID="GVCOV" runat="server" AutoGenerateColumns="False" ShowHeader="False">
                        <Columns>
                            <asp:BoundField DataField="Type" HeaderText="CoverageType" />
                            <asp:BoundField DataField="Data" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td class="tdbg" colspan="2">
                    Copay Details
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 10px;">
                    <asp:GridView ID="GVCOPAY" runat="server" AutoGenerateColumns="False" ShowHeader="False">
                        <Columns>
                            <asp:BoundField DataField="Type" HeaderText="CopayType" />
                            <asp:BoundField />
                            <asp:BoundField DataField="Data" HeaderText="CopayDetails" />
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td class="tdbg" colspan="2">
                    Alternative Details
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 10px;">
                    <asp:GridView ID="GVALT" runat="server" BackColor="White" Width="100%" BorderColor="#336666"
                        BorderStyle="Double" BorderWidth="3px" CellPadding="4" GridLines="Horizontal"
                        AutoGenerateColumns="False">
                        <RowStyle BackColor="White" ForeColor="#333333" />
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" DataSource='<%# Bind("ALT") %>'
                                        BorderStyle="None" GridLines="None">
                                        <Columns>
                                            <asp:BoundField DataField="Type" />
                                            <asp:BoundField DataField="Data" />
                                        </Columns>
                                    </asp:GridView>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <FooterStyle BackColor="White" ForeColor="#333333" />
                        <PagerStyle BackColor="#336666" ForeColor="White" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="#339966" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#336666" Font-Bold="True" ForeColor="White" />
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td class="tdbg" colspan="2">
                    Therapeutic Alternative
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 10px;">
                    <asp:GridView ID="GVTHALT" runat="server" AutoGenerateColumns="False" ShowHeader="False"
                        Width="100%">
                        <Columns>
                            <asp:TemplateField HeaderText="- -">
                                <ItemTemplate>
                                    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSource='<%# Bind("Therapeutic") %>'
                                        BorderStyle="None" GridLines="None" Style="text-align: left">
                                        <Columns>
                                            <asp:BoundField DataField="Type" HeaderText="                                                                                                                                                           " />
                                            <asp:BoundField DataField="Data" />
                                        </Columns>
                                        <EditRowStyle BorderStyle="None" />
                                    </asp:GridView>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    &nbsp;
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
