<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ReconciliationDataList.ascx.cs"
    Inherits="UserControls_ReconciliationDataList" %>
<script type="text/javascript" src="../App_Themes/Includes/JS/jquery.js" ></script>
<script type="text/javascript">
    $(document).ready(function () {
        var PanelMedReconciliation = document.getElementById('<%=PanelMedReconciliation.ClientID %>');
        FillAllReconciliationDataList(PanelMedReconciliation);
    });
</script>
<script type="text/javascript" language="javascript">
    function FillReconciliationDataListControl() {
        //debugger;
        var PanelReconciliationDataList = document.getElementById('<%=PanelReconciliationDataList.ClientID %>');
        var PanelMedReconciliation = document.getElementById('<%=PanelMedReconciliation.ClientID %>');
        var DropDownObject = document.getElementById('<%=DropDownReconciliationSourceFilter.ClientID %>');

        FillReconciliationDataList(PanelReconciliationDataList, DropDownObject);
        FillAllReconciliationDataList(PanelMedReconciliation);

    }


    function FillMedReconciliationDataListControl() {
        var DropDownObjectStatus = document.getElementById('<%=DropDownMedReconciliation.ClientID %>');
        var PanelMedReconciliation = document.getElementById('<%=PanelMedReconciliation.ClientID %>');
        var DropDownDocumentVersionId = document.getElementById('<%=DropDownReconciliationSourceFilter.ClientID %>');
        if (DropDownDocumentVersionId.value == "-1" || DropDownObjectStatus.value == "-1") {
            ShowError("Select value from both dropdowns then click Add Med Reconciliation button", true);
            return false;
        }

        if (($('[name="reconciliationcbsHeader"]').prop('checked') == false) && ($('[name="reconciliationcbsHeader"]').prop('disabled') != true)) {
            ShowError("Select Checkbox then click Add Med Reconciliation button", true);
            return false;
        }
        ShowError("", false);
        //FillMedReconciliationDataList(PanelMedReconciliation, DropDownObjectStatus, null, DropDownDocumentVersionId);
        //FillAllReconciliationDataList(PanelMedReconciliation);
        
        ReconcileMedicationList.ReconcileMedicationList();
    }

    function FillAllergyReconciliationDataListControl() {
        //debugger;
        var DropDownObjectStatus = document.getElementById('<%=DropDownMedReconciliation.ClientID %>');
        var PanelMedReconciliation = document.getElementById('<%=PanelMedReconciliation.ClientID %>');
        var DropDownDocumentVersionId = document.getElementById('<%=DropDownReconciliationSourceFilter.ClientID %>');

        FillAllergyReconciliationDataList(PanelMedReconciliation, DropDownObjectStatus, null, DropDownDocumentVersionId);
        FillAllReconciliationDataList(PanelMedReconciliation);
   }

</script>

<table>
    <tr>
        <td style="width: 50%;">
            <asp:DropDownList ID="DropDownReconciliationSourceFilter" runat="server" Width="100%" onChange="FillReconciliationDataListControl(this);">
                <asp:ListItem Text="" Value="" />
            </asp:DropDownList>
			</td>
        <td style="width: 50%;">
            <asp:DropDownList ID="DropDownMedReconciliation" runat="server" Width="50%" AppendDataBoundItems="true">
                <asp:ListItem Text="" Value="" />
            </asp:DropDownList>

            <asp:Button ID="ButtonMedAdd" Text="Add Med Reconciliation"  runat="server" OnClientClick="FillMedReconciliationDataListControl(this);return false;" SkinId="BtnLarge" />

             
            <%--            <asp:Button ID="ButtonAllergyAdd" Text="Add Allergy Reconciliation" Style="text-align: center" Width="200px" runat="server" OnClientClick="FillAllergyReconciliationDataListControl(this);return false;" />--%>

        </td>
    </tr>
    <tr>
        <td style="width: 50%;">
            <asp:Panel ID="PanelReconciliationDataList" runat="server">
            </asp:Panel>
        </td>
        <td style="width: 50%">
            <asp:Panel ID="PanelMedReconciliation" runat="server">
            </asp:Panel>
        </td>
    </tr>
</table>
