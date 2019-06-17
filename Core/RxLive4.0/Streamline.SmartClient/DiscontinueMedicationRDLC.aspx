<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DiscontinueMedicationRDLC.aspx.cs" Inherits="DiscontinueMedicationRDLC" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Discontinue Medication </title>
    <script language="javascript" type="text/javascript">
            function printRDLC() {
         var ans=window.print();
       }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table cellpadding="0" cellspacing="0" style="width:100%">
            <tr>
                <td>
                    <asp:Panel ID="Panel1" runat="server" Width="100%" style="overflow-x:hidden; overflow-y:hidden">
                        <div id="divReportViewer" runat="server" style="width:100%;">
                        </div>
                    </asp:Panel>
                </td>
            </tr>
        </table>
            
    </div>
    <asp:HiddenField ID="HiddenFieldArgument" runat="server" /> 
           <asp:HiddenField ID="HiddenFieldAllFaxed" runat="server" /> 
           <asp:HiddenField ID="HiddenFieldShowError" runat="server" />  
           <asp:HiddenField ID="HiddenFieldStoredProcedureName" runat="server" /> 
           <asp:HiddenField ID="HiddenFieldReportName" runat="server" /> 
           <asp:Label ID="LabelClientScript" runat="server"></asp:Label>
    </form>
</body>
</html>