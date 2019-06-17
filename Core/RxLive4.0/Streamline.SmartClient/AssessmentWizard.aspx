<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssessmentWizard.aspx.cs"
    Inherits="AssessmentWizard" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript" src="App_Themes/Includes/JS/Assessment.js?rel=3_5_x_4_1"></script>
</head>
<body>
    <form id="form1" runat="server">
        <!--This HiddenField will be used to stored Sessionkey -->
        <asp:HiddenField ID="HiddenFieldSessionkey" runat="server" />
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="width: 50px">
                            </td>
                            <td style="width: 70px">
                                <asp:Label ID="LabelNeed" runat="server" Text="Need"></asp:Label></td>
                            <td style="width: 200px">
                                <asp:TextBox ID="TextBoxNeed" runat="server" Width="180"></asp:TextBox>
                            </td>
                            <td>
                                <asp:Label ID="LabelStatus" runat="server" Text="Status"></asp:Label></td>
                            <td style="width: 200px">
                                <asp:DropDownList ID="DropDownListStatus" runat="server" Width="180">
                                    <asp:ListItem Text="Inprocess" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Complited" Value="2"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:Label ID="LableDate" runat="server" Text="Date"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="TextBoxDate" runat="server" Width="150">
                                </asp:TextBox></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" border="0" width="100%" style="height: 30px">
                        <tr>
                            <td style="width: 50px">
                            </td>
                            <td>
                                <table cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td style="width: 90px">
                                            <asp:Label ID="LabelDiscription" Text="Discription" runat="server"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="TextBoxDiscription" runat="server" Width="665"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="width: 50px">
                            </td>
                            <td style="width: 90px">
                                <asp:Label ID="LabelComment" Text="Comment" runat="server"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="TextBoxComment" runat="server" Width="665"></asp:TextBox></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="width: 40px">
                            </td>
                            <td style="width: 96px">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td class="LeftHeading" style="background-repeat: no-repeat; height: 21px;">
                                        </td>
                                        <td class="CenterHeading" style="background-repeat: repeat-x; height: 21px;">
                                            <b>Needs List</b></td>
                                        <td class="RightHeading" style="height: 21px">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="width: 575px">
                                <asp:CheckBox ID="CheckBoxComplitedNeeds" runat="server" Text="Do not show completed needs" />
                            </td>
                            <td>
                                <asp:Button ID="ButtonAdd" runat="server" Text="Add" Width="100" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td style="padding-left: 50px">
                <div id="DivNeed" runat="server" >
                    
                    </div>
                    <div id="one"></div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
