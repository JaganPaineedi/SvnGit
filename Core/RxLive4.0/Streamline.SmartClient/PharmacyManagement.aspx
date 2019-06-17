<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PharmacyManagement.aspx.cs"
    Inherits="PharmacyManagement" ValidateRequest="false" %>

<%@ Register TagPrefix="UI" TagName="PharmacyList" Src="~/UserControls/PharmaciesList.ascx" %>
<%@ Register TagPrefix="UC" TagName="PharmacySerachList" Src="~/UserControls/PharmacySearchList.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <UI:PharmacyList ID="PharmacyList1" runat="server" Visible="false" />
        <asp:Panel ID="PanelPharmaciesListSearch" runat="server" ScrollBars="Auto">
        <font style="display: none">##STARTPHARMACYSEARCH##</font>
        <UC:PharmacySerachList ID="PharmacySerachList" runat="server" Visible="false" />
        <font style="display: none">##ENDPHARMACYSEARCH##</font>
        </asp:Panel>
    </div>
    </form>
</body>
</html>