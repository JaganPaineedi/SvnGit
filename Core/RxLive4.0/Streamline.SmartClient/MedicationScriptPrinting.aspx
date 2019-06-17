<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicationScriptPrinting.aspx.cs" Inherits="MedicationScriptPrinting" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title id="Printheader" runat="server">Medication Script Printing</title>
    <% if(Printfourprescriptionsperpage =="Y"){ %>
    <meta http-equiv="X-UA-Compatible" content="IE=10" />
    <style type="text/css">
    @page 
    {
        size:  auto;   
        margin: 6mm;   
    }
    html
    {
        background-color: #FFFFFF; 
        margin: 0px;  
    }
    body
    {    
        border: solid 1px black ;    
        margin: 5mm 15mm 10mm 15mm; 
    }
    </style>

    <%}%>
   <script language="javascript" type="text/javascript">
            function printScript() {
      var ans=window.print();
     
     
   }
   
            function try1() {
      
      return 1;
   }

   //Code added in ref to Task#2912 to disable Right Click on Popup window

   function disableselect(e) {
                return false;
   }

   function reEnable() {
                return true;
   }

   //if IE4+
            document.onselectstart = new Function("return false");
            document.oncontextmenu = new Function("return false");
   //if NS6
   if (window.sidebar) {
                document.onmousedown = disableselect;
                document.onclick = reEnable;
   }
   //Code ends over here
   </script> 
</head>
<body style="margin:0px; " onunload="try1();window.history.forward(1);">
    <form id="form1" runat="server" style="display:none;">
      <asp:ScriptManager ID="ScriptManager1" runat="server">
          </asp:ScriptManager>
      <asp:Label ID="LabelError" runat="server" BackColor="Bisque">
   </asp:Label>    
    </form>
</body>
</html>