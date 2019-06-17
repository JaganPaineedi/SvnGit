<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RefillDenialReason.aspx.cs"
    Inherits="RefillDenialReason" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Refill Denied Reason</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <script type="text/javascript" language="javascript">
        function checkTextAreaMaxLength(textBox, e, length) {
            
            var mLen = textBox["MaxLength"];
            if (null == mLen)
                mLen = length;

            var maxLength = parseInt(mLen);
            if (!checkSpecialKeys(e)) {
                    if (textBox.value.length > maxLength - 1) {
                    if (window.event)//IE 
                        e.returnValue = false;
                    else//Firefox 
                        e.preventDefault();
                }
            }
        }

            function checkSpecialKeys(e) {
            if (e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40)
                return false;
            else
                return true;
        } 

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="WebServices/SureScriptRefillRequest.asmx" InlineScript="true" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        </Scripts>
    </asp:ScriptManager>
    <div width="100%">
        <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td width="590px" id="topborder" class="TitleBarText" style="padding-left: 5px;">
                    Refill Denied Reason
                </td>
                <td align="left" width="10px">
                    <img id="ImgCross" onclick="CloseRefillDeniedReason()" src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>'
                        title="Close" alt="Close" />
                </td>
            </tr>
        </table>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td valign="bottom" style="width: 16px">
                    <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif"
                        Style="display: none; vertical-align: middle" />
                </td>
                <td valign="bottom">
                    <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError" Height="18px"
                        Style="vertical-align: middle"></asp:Label>
                </td>
            </tr>
        </table>
        <table border="0" cellspacing="0" cellpadding="0" width="100%" style="padding-left: 35px;">
            <tr>
                <td style="height: 2px;">
                </td>
            </tr>
            <tr>
                <td align="left">
                    <asp:Label runat="server" ID="Message1">Select a denial reason from the list or type the reason</asp:Label>
                    <asp:Label runat="server" ID="Message2" Visible="False">Please enter a denial reason</asp:Label>
                </td>
            </tr>
            <tr>
                <td style="height: 2px;">
                </td>
            </tr>
            <tr>
                <td style="width: 100%" align="left">
                    <asp:DropDownList ID="DropDownDenialReason" runat="server" Width="90%"  CssClass="ddlist"/>
                </td>
            </tr>
            <tr>
                <td style="height: 2px;">
                </td>
            </tr>
            <tr>
                <td style="width: 100%" align="left">
                  
                   <asp:TextBox ID="TextBoxDenialReason" runat="server" TextMode="MultiLine" Width="88%"
                        Rows="3" MaxLength="70"  EnableTheming="false"  onkeyDown="checkTextAreaMaxLength(this,event,'70');"/>
                </td>
            </tr>
        </table>
        <table width="100%">
            <tr>
                <td style="height: 2px;">
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 40%">
                    <asp:Button ID="ButtonOk" runat="server" Text="OK" Width="35%"  CssClass="btnimgexsmall"/>
                </td>               
                <td align="left" style="width: 40%">
                    <asp:Button ID="ButtonCancel" runat="server" Text="Cancel" OnClientClick="CloseRefillDeniedReason();return false;"
                        Width="35%" CssClass="btnimgexsmall"/>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>