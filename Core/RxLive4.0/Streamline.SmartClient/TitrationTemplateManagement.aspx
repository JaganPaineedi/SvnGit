<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TitrationTemplateManagement.aspx.cs" Inherits="TitrationTemplateManagement" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Titration/Taper Template</title>
    <script language="javascript" type="text/javascript">
            function TitrationTemplatePageLoad() {
                try {
                 RegisterTitrationTemplateControlEvents();
                 
                } catch(ex) {
                
                 Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
            }  
        }
      
    </script>
</head>
<body>
    <form id="form1" runat="server">
     
      <div>
         <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
               <td><asp:Label ID="LabelScriptManager" runat="server"></asp:Label>
               <input type="hidden" id="HdnTitrationTemplateId" runat="server" />
                <input type="hidden" id="HiddenTitrationTemplateId" runat="server" />
               </td>
            </tr>
            <tr>
               <td>
                   <table border="0" width="100%">
                       <tbody valign="top">
                           <tr>
                               <td>
                                   <div id="PlaceHolder" runat="server" visible="true" >
                                       <table width="100%" cellspacing="0" cellpadding="0">
                                           <tbody>
                                               <tr>
                                                   <td style="width: 100%;" valign="top">
                                                       <asp:Panel ID="PanelTitrationTraperList" runat="server"  BackColor="White"
                                                           BorderStyle="None" BorderColor="Black">
                                                       </asp:Panel>
                                                   </td>
                                               </tr>
                                           </tbody>
                                       </table>
                                   </div>
                               </td>
                           </tr>
                       </tbody>
                   </table>
               </td>
            </tr>
         </table>
      </div>
       
    </form>
</body>
<script>
Sys.Application.add_load(TitrationTemplatePageLoad)
</script>
</html>