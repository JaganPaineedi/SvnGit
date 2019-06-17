<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PermissionsAvailableList.aspx.cs"
    Inherits="PermissionsAvailableList" EnableViewState="false" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ OutputCache Location="None" VaryByParam="None" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Available Permissions </title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" type="text/css" rel="stylesheet" />

    <script language="javascript" type="text/javascript">
        function CloseWindow() {
            window.close();
            return false;
        }

        function GetRowValueOnCheckBoxCheck(val, chkboxStatus) {
            if (document.getElementById(chkboxStatus).checked == true) {
                if (document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value == "") {
                    document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value = val;
                    } else if (document.getElementById("<%= HiddenFieldCheckedStaffValues.ClientID %>").value != "") {
                    document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value = document.getElementById("HiddenFieldCheckedStaffValues").value + "," + val;
                }
                } else {
                var checkedItemsValues = new Array();
                checkedItemsValues = document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value.split(",");
                document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value = "";
                for (i = 0; i < checkedItemsValues.length; i++) {
                    if (checkedItemsValues[i] != val) {
                        if (document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value == "") {
                            document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value = checkedItemsValues[i];
                            } else if (document.getElementById("<%= HiddenFieldCheckedStaffValues.ClientID %>").value != "") {
                            document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value = document.getElementById("HiddenFieldCheckedStaffValues").value + "," + checkedItemsValues[i];
                        }
                    }

                }
            }
        }

        function SetParentReturnValue(val) {
            var DivSearch = parent.document.getElementById('DivSearch');
            DivSearch.style.display = 'none';
            parent.window.document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_HiddenStaffPermissionId').value = "";
            if (val == 'ok' && document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value != "") {
                parent.window.document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_HiddenStaffPermissionId').value = document.getElementById("<%=HiddenFieldCheckedStaffValues.ClientID %>").value;
                parent.window.RefreshParentWindow();
                } else if (val == 'cancel') {
                parent.window.document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_HiddenStaffPermissionId').value = "";
                } else if (val == 'ok' && document.getElementById("<%= HiddenFieldCheckedStaffValues.ClientID %>").value == "") {
                parent.window.document.getElementById('Control_ASP.usercontrols_userpreferences_ascx_HiddenStaffPermissionId').value = "";
            }
            parent.window.fnHideParda();
            window.close();
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <input type="hidden" id="HiddenFieldCheckedStaffValues" runat="server" />
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="WebServices/CommonService.asmx" />
            <asp:ServiceReference Path="WebServices/UserPreferences.asmx" InlineScript="true" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/ExceptionManager.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/UserPreferences.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/DatePopUp/ts_picker.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/calendar.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1"
                NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/TextBoxWrapper.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        </Scripts>
    </asp:ScriptManager>
    <table width="100%" cellpadding="4" cellspacing="0" border="0">
        <tr>
            <td>
                <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td>
                            <UI:Heading ID="Heading1" runat="server" HeadingText="Available" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                                    <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; height: 150px; width: 100%;" cellspacing="0"
                                cellpadding="0">
                                <tr>
                                    <td valign="top">
                                                <div style="height: 150px; overflow-x: none; overflow-y: scroll;">
                                            <asp:GridView runat="server" Width="100%" AutoGenerateColumns="false" ID="GridViewSystemActions"
                                                OnRowDataBound="GridViewSystemActions_RowDataBound" ShowHeader="False">
                                                <Columns>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="CheckBoxSystemActions" runat="server" />
                                                        </ItemTemplate>
                                                        <ItemStyle Width="3%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:Label ID="LabelActionId" class="Label" runat="server" Visible="false" Text='<%#Eval("ActionId")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:Label ID="LabelScreenName" class="Label" runat="server" Text='<%#Eval("ScreenName")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                        <ItemTemplate>
                                                            <asp:Label ID="LabelAction" class="Label" runat="server" Text='<%#Eval("Action")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 25px;text-align:center;">
                            <input id="ButtonOk" runat="server" type="button" class="btnimgexsmall" value="OK" onclick="SetParentReturnValue('ok');" />
                        <%-- <input type="submit"  runat="server" name="ButtonCancel" value="Cancel" onclick="SetParentReturnValue('cancel'); return false;" id="ButtonCancel" class="btnimgexsmall">--%>
                          <asp:Button ID="ButtonCancel" runat="server" Text="Cancel" OnClientClick="SetParentReturnValue('cancel');return false;" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="1" style="height: 15px;">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>