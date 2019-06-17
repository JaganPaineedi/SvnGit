<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EligibilityViewer.ascx.cs" Inherits="UserControls_EligibilityViewer" %>
<script type="text/javascript">
    function PrintEligibilityDocument() {
        var divToPrint = $("[id$='EligilityViewDiv']");
        var newWin = window.open("", "", "width=200,height=200;");
        newWin.document.write('<html><head><body onload="window.print()">' + divToPrint.html() + '</body></html>');
    }
</script>
<%--<input type="button" value="Print Eligibility" onclick="PrintEligibilityDocument(); return false;" />--%>
<style type="text/css">
    tr.EligibilityView td
    {
        padding-right: 10px;
    }

    tr.top td.EligibilityView
    {
        border-top: thin solid black;
    }

    tr.bottom td.EligibilityView
    {
        border-bottom: thin solid black;
    }

    tr.row td.EligibilityView:first-child
    {
        border-left: thin solid black;
    }

    tr.row td.EligibilityView:last-child
    {
        border-right: thin solid black;
    }
</style>
<asp:Panel runat="server" ID="EligilityViewDiv">
</asp:Panel>