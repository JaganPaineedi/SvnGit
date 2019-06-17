<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GrowthChart.ascx.cs" Inherits="UserControls_GrowthChart" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td>
            <table id="TableGraph" runat="server" border="0" cellpadding="0" cellspacing="0"
                width="99%">
                <tr>
                    <td style="height: 8px" colspan="2">
                        <asp:Label ID="LabelError" runat="server" ForeColor="red" CssClass="Label" Style="display: none"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td width="425px">
                        <select id="DropDownGrowthChartListGraph" style="width: 400px;" onchange="GetGrowthChartImage(this);">
                        </select>
                    </td>                    
                    <td><input type="button" value="Print GrowthChart" onclick="PrintGrowthChartImage($('#GrowthChartImage').attr('src'))" /></td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="padding-left: 10px; padding-top: 1px">
            <div style="padding: 0; margin: 0; height: 400px; overflow:auto;">
                <img id="GrowthChartImage" src="" /></div>
        </td>
    </tr>
</table>
