<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PermissionsList.ascx.cs"
    Inherits="UserControls_PermissionsList" %>

<script language="javascript" type="text/javascript">
    function pageLoad() {
        try {
            if (typeof RegisterPermissionsListControlEvents === 'function')
            RegisterPermissionsListControlEvents();
        }
        catch (ex) {

            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
        }
    }

</script>

<asp:Panel ID="PanelPermissionsList" Height="100px" Style="overflow-x: hidden;" Width="100%"
    runat="server">
</asp:Panel>
<asp:HiddenField ID="HiddenPermissionsList" runat="server" Value="" />
