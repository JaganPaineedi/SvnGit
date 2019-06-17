<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HealthGraph.ascx.cs" Inherits="UserControls_HealthGraph" %>

<script type="text/javascript" language="javascript">
    function CalShow(ImgCalID, TextboxID) {
        try {
            Calendar.setup({
                inputField: TextboxID,
                ifFormat: "%m/%d/%Y",
                showsTime: false,
                button: ImgCalID,
                step: 1
            });
        }
        catch (e) {

        }
    }
    function GetHealthGraphControl() {
        GetHealthGraph('<%=PanelGraphListInformation.ClientID%>', '<%=DropDownHealthDataListGraph.ClientID%>', '<%=TextBoxStartDate.ClientID%>', '<%=TextBoxEndDate.ClientID%>', '<%=LabelError.ClientID%>')
    }
</script>

<div style="overflow: auto; height:100%;">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td>
                <table id="TableGraph" runat="server" border="0" cellpadding="0" cellspacing="0"
                    width="99%">
                    <tr>
                        <td style="height: 8px" colspan="6">
                            <asp:Label ID="LabelError" runat="server" ForeColor="red" CssClass="Label" Style="display: none"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%">
                            <asp:DropDownList ID="DropDownHealthDataListGraph" runat="server" Width="99%" TabIndex="1">
                            </asp:DropDownList>
                        </td>
                        <td width="10%" class="labelFont" nowrap="nowrap">
                            Start Date:
                        </td>
                        <td width="20%" style="color: Green;" nowrap="nowrap">
                            <asp:TextBox ID="TextBoxStartDate" runat="server" Width="70px" MaxLength="10" TabIndex="2"></asp:TextBox>
                            <img id="Img1" src="App_Themes/Includes/Images/calender_grey.gif" onclick="CalShow(this, '<%=TextBoxStartDate.ClientID%>')"
                                alt="" align="middle" />
                        </td>
                        <td width="10%" class="labelFont" nowrap="nowrap">
                            End Date:
                        </td>
                        <td width="20%" nowrap="nowrap">
                            <asp:TextBox ID="TextBoxEndDate" runat="server" Width="70px" MaxLength="10" TabIndex="3"></asp:TextBox>
                            <img id="Img2" src="App_Themes/Includes/Images/calender_grey.gif" onclick="CalShow(this, '<%=TextBoxEndDate.ClientID%>')"
                                alt="" align="middle" />
                        </td>
                        <td width="10%">
                            <input type="button" align="right" class="btnimgexsmall" value="Filter" tabindex="4"
                                style="width: 45px" onclick="GetHealthGraphControl();" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="margin-left: 10px; margin-top: 10px">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <asp:Panel ID="PanelGraphListInformation" Style="width: 720px; height: 100%;" runat="server">
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>

<script language="javascript" type="text/javascript">
    function ResetDates() {
        document.getElementById('<%=TextBoxStartDate.ClientID%>').innerText = '<%=ListStartDate%>';
        document.getElementById('<%=TextBoxEndDate.ClientID%>').innerText = '<%=ListEndDate%>';
    }
</script>

