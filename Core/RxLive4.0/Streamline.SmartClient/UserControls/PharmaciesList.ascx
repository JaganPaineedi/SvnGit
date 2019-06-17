<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PharmaciesList.ascx.cs" Inherits="Streamline.SmartClient.UI.UserControls_PharmaciesList" %>
<script language="javascript" type="text/javascript">
function pageLoad()
{
     try {              
         RegisterPharmacyListControlEvents();
     }
    catch(ex)
    {
        
         Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
    }  
}

</script>


<asp:Panel  ID="PanelPharmacyList" Height="100%"  runat="server">
</asp:Panel>

<asp:HiddenField ID="HiddenPharmaciesLists" runat="server" Value="" />