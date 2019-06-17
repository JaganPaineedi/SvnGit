<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AllergiesList.aspx.cs" Inherits="AllergiesList" %>

<%@ OutputCache Duration="1" VaryByParam="*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <base target="_self" />
    <title>Client Search</title>

    <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="../JS/AjaxScript.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="App_Themes/Includes/JS/AllergySearch.js?rel=3_5_x_4_1" type="text/javascript"></script>

    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
</head>
<body scroll="no" topmargin="0" onload="AllergySearch.EnablesDisable();fnHideParda('Parda','dvProgress');">
        <div id="Parda" style="background-color: #ffffff; border: 1px solid #cccc99; display: none; filter: Alpha(Opacity=0); left: 0; position: absolute; top: 0; width: 300px;">
    </div>
        <div id="dvProgress" style="display: none; left: 0; position: absolute; right: inherit; top: 47px; width: 224px" class="progress">
       <%-- <font size="Medium" color="#1c5b94"><b><i>Communicating with Server...</i></b></font>
        <img src="../App_Themes/Includes/Images/Progress.gif" title="Progress" />--%>
             <img src="App_Themes/Includes/Images/ajax-loader.gif" />
    </div>
    <form id="form1" runat="server">
    <table cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr style="background-color: blue">
                        <td width="90%" id="topborder" valign="middle" class="TitleBarText">
                            Select Allergy
                        </td>
                        <td align="left" width="10%">
                            <img id="ImgCross" onclick="AllergySearch.closeDiv(0)" src='<%= Page.ResolveUrl("~/App_Themes/Includes/Images/cross.jpg") %>'
                                title="Close" alt="Close" />
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 1pt;" colspan="2">
                            <asp:PlaceHolder ID="PlaceHolderScript" runat="server"></asp:PlaceHolder>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td style="width: 5%" valign="middle">
                                                    <div id="divimg" runat="server">
                                                        <asp:Image ID="imgError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif" />
                                                    </div>
                                                </td>
                                                <td style="width: 1%" valign="middle">
                                                </td>
                                                <td style="width: 91%" valign="middle">
                                                    <asp:Label ID="lblError" runat="server" Visible="true" ForeColor="Red" Font-Names="Microsoft Sans Serif"
                                                        Font-Size="11px" Font-Bold="true" style="text-decoration:none;"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center">
                                                <table border="1" style="border-color: Black; height: 100px;" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                            <div style="border-collapse: separate; border-width: 1px; height: 275px; overflow: auto; text-align: left; width: 220px;">
                                                        <asp:GridView ID="DataGridAllergies" DataKeyNames="AllergenConceptId" runat="server"
                                                            GridLines="None" AutoGenerateColumns="False" RowStyle-Height="10px" CellPadding="0"
                                                            BorderWidth="0px" AllowSorting="True" OnSorting="DataGridAllergies_Sorting" OnPageIndexChanging="DataGridAllergies_PageIndexChanging"
                                                            OnRowDataBound="DataGridAllergies_RowDataBound" PageSize="100" OnRowCreated="DataGridAllergies_RowCreated">
                                                            <AlternatingRowStyle CssClass="GridViewAlternatingRowStyle" />
                                                            <RowStyle CssClass="GridViewRowStyle" Height="10px" />
                                                            <HeaderStyle CssClass="GridViewHeaderText" />
                                                            <PagerStyle CssClass="GridViewPagerText" />
                                                            <Columns>
                                                                <asp:TemplateField>
                                                                    <ItemTemplate>
                                                                    </ItemTemplate>
                                                                    <ItemStyle Width="1%" />
                                                                    <HeaderStyle ForeColor="#DCE5EA" />
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="AllergenConceptId" HeaderText="ID" SortExpression="ID"
                                                                    Visible="False">
                                                                    <ItemStyle HorizontalAlign="Left" Width="4%" VerticalAlign="Middle" Wrap="False" />
                                                                    <HeaderStyle HorizontalAlign="Left" />
                                                                </asp:BoundField>
                                                                <asp:BoundField DataField="ConceptDescription" HeaderText="Allergy" SortExpression="ConceptDescription">
                                                                    <ItemStyle HorizontalAlign="Left" Width="6%" VerticalAlign="Middle" Wrap="False" />
                                                                    <HeaderStyle HorizontalAlign="Left" />
                                                                </asp:BoundField>
                                                            </Columns>
                                                            <EmptyDataTemplate>
                                                                <center>
                                                                    No Records Found
                                                                </center>
                                                            </EmptyDataTemplate>
                                                            <PagerSettings Mode="NumericFirstLast" />
                                                        </asp:GridView>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 10px" colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="center">
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td valign="top" align="center">
                                                    <asp:Button ID="btnSelect" runat="server" Width="82px" CssClass="btnimgexsmall" EnableViewState="False"
                                                        OnClientClick="fnShowParda(350,55);" Text="Select" OnClick="btnSelect_Click">
                                                    </asp:Button>
                                                </td>
                                                <%--<td valign="top" style="width: 2%;">
                                                </td>--%>
                                                <td valign="top" style="width: 71px;">
                                                    <input id="btn1" type="button" value="Cancel" onclick="AllergySearch.closeDiv(0);"
                                                                   class="btnimgexsmall" style="font-size: 8.25pt; width: 66px;" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 19px" colspan="2">
                                        <input id="HiddenAllergyId" type="hidden" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>