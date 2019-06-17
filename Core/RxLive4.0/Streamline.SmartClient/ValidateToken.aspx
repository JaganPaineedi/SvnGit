<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ValidateToken.aspx.cs" Inherits="ValidateToken" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>ValidatePage</title>
    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE" />
    <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
    <script language="javascript">
            function CloseWindow() {
       
        window.open("ApplicationForm.aspx", '', 'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width='+screen.availWidth +',height='+screen.availHeight+',left = 0,top = 0');
   
                if (window.navigator.appVersion.indexOf('MSIE 6.0') > 0) {
               window.opener = 'Test'; 
               window.close(); 
                } else if (window.navigator.appVersion.indexOf('MSIE 7.0') > 0) {
               window.open('','_parent',''); 
               window.close();
         }
    }

    </script> 
</head>
<body>
    <form id="form1" runat="server">
      <asp:Label ID="LabelError" runat="server" CssClass="redTextError"></asp:Label> 
    <div>
    
    </div>
    </form>
</body>
</html>