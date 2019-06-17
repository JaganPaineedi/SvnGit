<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Heading.ascx.cs" Inherits="UserControls_Heading" %>

<%# Eval(HeadingDetailId) %>
<table cellpadding="0" cellspacing="0" border="0">
    <tr>
        <asp:Repeater runat="server" ID="HeaderTdRepeat">
            <ItemTemplate>
                <td>
                    <table cellpadding="0" cellspacing="0" border="0" id='HeaderItem_<%# DataBinder.Eval(Container.DataItem, "headerItemId") %>'  <%#(((RepeaterItem)Container).ItemIndex+1).ToString() == "1" ? "class='ActiveTab HeaderTab'" :"class='HeaderTab'" %>>
                        <tr>
                            <td class="LeftHeading" style="background-repeat: no-repeat"></td>
                            <td class="CenterHeading" style="background-repeat: repeat-x; cursor: pointer;" onclick="HeadingTabClick('#<%# DataBinder.Eval(Container.DataItem, "headerItemId") %>', '#HeaderItem_<%# DataBinder.Eval(Container.DataItem, "headerItemId") %>');return false;">
                                <span style="font-family: Tahoma, Arial, Helvetica, sans-serif; font-size: 11px"><%# DataBinder.Eval(Container.DataItem, "headerLabel") %></span>
                            </td>
                            <td class="RightHeading"></td>
                            <%--<td>&nbsp;</td>
                            <td></td>--%>
                        </tr>
                    </table>
                </td>
            </ItemTemplate>
        </asp:Repeater>
    </tr>
</table>
