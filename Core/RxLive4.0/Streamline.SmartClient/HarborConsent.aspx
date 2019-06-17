<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HarborConsent.aspx.cs" Inherits="HarborConsent" %>
<%@ Register Src="~/UserControls/HarborStandardConsent.ascx" TagName="HarborStandartConsent" TagPrefix="UI" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <asp:Panel ID="PanelConsent" runat="server">
    <UI:HarborStandartConsent ID="HarborStandardConsent" runat="server" />
    </asp:Panel>
    </div>
    </form>
</body>
</html>