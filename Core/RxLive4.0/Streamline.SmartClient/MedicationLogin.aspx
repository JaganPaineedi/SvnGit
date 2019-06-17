<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicationLogin.aspx.cs"
    Inherits="MedicationLogin" %>

<%@ Register Src="~/UserControls/MedicationLogin.ascx" TagName="LoginUserControl"
    TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
        <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

        <script type="text/javascript" src="App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1"> </script>

    <!-- Title Changed by Mohit-->
    <title>Streamline Medication Management</title>
</head>
    <body topmargin="0" leftmargin="0" style="background-image: url(App_Themes/Includes/Images/bg_login.JPG); background-repeat: repeat;">
    <form id="formLogin" runat="server">
    <div id="DivMain">
                <table border="0" cellpadding="0" cellspacing="0" style="height: 100%; width: 100%;">
            <tr>
                <td align="center" valign="top">
                    <table width="520" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="height: 105px;">
                            </td>
                        </tr>
                        <tr>
                            <td id="TdSessionExpires" runat="server" style="display: none;">
                                <label style="color: Red; font-family: Microsoft Sans Serif; font-size: 8.25pt; font-weight: bold">
                                   Your session has expired. Please login to begin a new session.</label>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="background-color: White;">
                                <uc1:LoginUserControl ID="LoginUser" runat="server" />
                            </td>
                        </tr>
                        <tr style="display:none;">
                            <td style="height: 25px;">
                            </td>
                        </tr>
                        <tr style="display:none;">
                            <td align="center" class="footertextbold" style="height: 22px">
                            </td>
                        </tr>
                        <tr style="display:none;">
                            <td style="height: 15px;">
                            </td>
                        </tr>
                        <tr style="display:none;">
                            <td align="center" class="footertextbold">
                                <b>
                                    <asp:Label ID="LabelCopyrightInfo" runat="server"></asp:Label></b>
                            </td>
                            <td align="right" class="footertextbold" valign="top">
                                <b>
                                    <asp:Label ID="LabelReleaseVersion" runat="server"></asp:Label></b>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>