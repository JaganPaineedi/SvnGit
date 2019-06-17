<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedicationHistoryViewer.ascx.cs" Inherits="UserControls_MedicationHistoryViewer" %>
<script type="text/javascript">
    function PrintEligibilityDocument() {
        var divToPrint = $("[id$='MedicationHistoryViewDiv']");
        var newWin = window.open("", "", "width=200,height=200;");
        newWin.document.write('<html><head><body onload="window.print()">' + divToPrint.html() + '</body></html>');
    }
</script>
<asp:Panel runat="server" ID="MedicationHistoryViewDiv">
</asp:Panel>