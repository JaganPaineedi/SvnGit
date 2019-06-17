<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="ChangePassword" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script language="javascript" type="text/javascript">
    function SetNewValues(cancelled, newPassword) {
var ret= new Array(cancelled,newPassword);
window.opener.update(ret);
window.close();
}

    function CloseWindow() {
window.close();
}
</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Change Password</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" type="text/css" rel="stylesheet" />
<link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table cellpadding="0" cellspacing="0" border="0" style="width: 31%">
    <tr>
        <td valign="top" style="width: 20px;">
                            <div id="DivErrorImage" style="display: none; width: 124px;" runat="server">
                <table cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td valign="top">
                            <img src="App_Themes/Includes/Images/Flag/error.gif" alt="" /><asp:Label ID="lblError" runat="server" CssClass="redTextError"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
</table>        
        <table style="width: 213px">
            <tr>
                <td style="width: 92px" class="labelFont">
                    <asp:Label ID="LabelUserName" runat="server" Text="User Name"></asp:Label></td>
                <td>
                    <asp:TextBox ID="TextBoxUserName" runat="server" Width="155px"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 92px" class="labelFont">
                    <asp:Label ID="LabelOldPassword" runat="server" Text="Old Password" Width="121px"></asp:Label></td>
                <td>
                    <asp:TextBox ID="TextBoxOldPassword" runat="server" TextMode="Password" Width="155px"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 92px" class="labelFont">
                    <asp:Label ID="LabelNewPassword" runat="server" Text="New Password" Width="123px"></asp:Label></td>
                <td>                
                    <asp:TextBox ID="TextBoxNewPassword" runat="server" TextMode="Password" Width="155px"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 92px" class="labelFont">
                    <asp:Label ID="LabelConfirmPassword" runat="server" Text="Confirm Password" Width="111px"></asp:Label></td>
                <td>
                    <asp:TextBox ID="TextBoxConfirmPassword" runat="server" TextMode="Password" Width="155px"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 92px" align="right">
                    <asp:Button ID="ButtonOk" runat="server" Text="OK" OnClick="ButtonOk_Click" Width="59px" CssClass="btnimgexsmall"/></td>
                <td>
                    &nbsp;<asp:Button ID="ButtonCancel" runat="server" Text="Cancel" OnClick="ButtonCancel_Click" CssClass="btnimgexsmall"/></td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>