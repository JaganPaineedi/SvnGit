<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Login to SmartCare</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%--<asp:Label ID="Label1" CssClass="redtextbold" runat="server" Text="Session Expired"></asp:Label>--%>
            <table style="width: 100%" border="0px" cellpadding="0px" cellspacing="0px">
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 100px">
                        <table align="center" border="2px" style="border-color: #1C5B94">
                            <tr>
                                <td>
                                        <table align="center" style="height: 80px; vertical-align: top; width: 670px;">
                                        <tr>
                                                <td style="background-color: #1C5B94; height: 30px;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 20px;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div id="errorPageContainer" xmlns="http://www.w3.org/1999/xhtml" style="margin-left: 15px;">
                                                    <div id="errorTitle">
                                                        <h1 id="errorTitleText" style="color: Maroon">
                                                            Your session has timed out.</h1>
                                                    </div>
                                                    <div id="errorLongContent">
                                                        <div id="errorShortDesc">
                                                            <p id="errorShortDescText">
                                                                Your session has timed out due to inactivity.</p>
                                                        </div>
                                                        <div id="errorLongDesc">
                                                            <p>You must log back into the application to continue.</p>
                                                        </div>
                                                        <div id="Div1">
                                                            <p><a href ="MedicationLogin.aspx">Click here to return to the login page.</a></p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 20px;">
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center">
                    </td>
                </tr>
                <tr>
                    <td id="LowerSpace">
                    </td>
                </tr>
                <tr>
                    <td align="center" style="height: 0px; vertical-align: bottom;">
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>