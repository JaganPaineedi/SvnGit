<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ConsentStandardReportViewer.aspx.cs"
         Inherits="ConsentStandardReportViewer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head id="Head1" runat="server">

        <script language="javascript" type="text/javascript">
            function printScript1() {
                var ans = window.print();

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
    <body style="margin: 0px;" onunload=" try1();window.history.forward(1); ">
        <form id="form2" runat="server">
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
            <asp:Label ID="LabelError" runat="server" BackColor="Bisque">
            </asp:Label>
            <div id="divNonReportViewer" runat="server" style="width: 100%; text-align: center;"></div>
            <div id="divReportViewer1" runat="server" style="height: 100%; scrollbar-3dlight-color: Azure; width: 720px;">
            </div>
        </form>
    </body>
</html>