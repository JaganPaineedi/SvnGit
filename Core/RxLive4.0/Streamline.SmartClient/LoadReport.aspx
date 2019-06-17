<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LoadReport.aspx.cs" Inherits="LoadReport" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ Register src="~/UserControls/ClientReportViewer.ascx" tagname="ClientReportViewer" tagprefix="uc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <script type="text/javascript">
        window.onload = function () {
            if (typeof window.opener.fnHideParentDiv == 'function') {
                window.opener.fnHideParentDiv();
            }
        };
    </script>
    
    <form id="form1" runat="server">
     <uc1:ClientReportViewer ID="ClientReportViewer1" runat="server" ></uc1:ClientReportViewer>
     </form>
</body>