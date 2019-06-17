<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PrinterManagement.aspx.cs" Inherits="PrinterManagement" %>
<%@ Register TagPrefix="UI" TagName="PrinterList" Src="~/UserControls/PrinterList.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <UI:PrinterList id="PrinterList1" runat="server" />
    </div>
    </form>
</body>
</html>