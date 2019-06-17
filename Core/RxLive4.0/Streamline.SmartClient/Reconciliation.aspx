<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Reconciliation.aspx.cs" Inherits="Reconciliation" %>

<%@ Register TagPrefix="ui" TagName="reconciliationdata" Src="~/UserControls/ReconciliationDataList.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
<head id="Head1" runat="server">
    <title>Reconciliation</title>
    <style>
        .content_tab_bg
        {
            background: url(App_Themes/Includes/Images/content_tab_bg.gif) repeat-x left top;
            border-left: 1px solid #7e99a9;
            border-right: 1px solid #7e99a9;
        }

        .labelPadding
        {
            padding: 10px;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            //debugger;
            FillReconciliationData();
            FillMedReconciliationData();
        });
    </script>
</head>
<body style="font-family: Tahoma, Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 0; outline: 0;">
    <form id="form2" runat="server">
        <div class="content_tab_bg">
            <div class="labelPadding">
                <ui:reconciliationdata ID="ReconciliationData" runat="server" />
            </div>
        </div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="~/WebServices/ClientMedications.asmx" InlineScript="true" />
            </Services>
            <Scripts>
                <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationClientPersonalInformation.js?rel=3_5_x_4_1"
                    NotifyScriptLoaded="true" />
            </Scripts>
        </asp:ScriptManager>
    </form>
</body>
</html>


