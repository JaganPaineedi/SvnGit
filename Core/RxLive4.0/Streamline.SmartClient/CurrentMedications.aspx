<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CurrentMedications.aspx.cs"
    Inherits="CurrentMedications" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Current Medications</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script language="javascript" type="text/javascript">

        function closeDiv() {
            try {
                $("#DivSearch").css('display', 'none');
                fnHideParda();
                } catch(e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
        }

        function onSessiontimeOut() {           
            var DivSearch = parent.document.getElementById('DivSearch');
            DivSearch.style.display = 'none';
            parent.location.href = "./MedicationLogin.aspx?SessionExpires='yes'";
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Scripts>
            <asp:ScriptReference Path="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/ExceptionManager.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/DatePopUp/ts_picker.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/calendar.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1"
                NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/TextBoxWrapper.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        </Scripts>
        <Services>
            <asp:ServiceReference Path="~/WebServices/ClientMedications.asmx" InlineScript="true" />
        </Services>
    </asp:ScriptManager>
    <table id="TablePopUpTitleBar" class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="100%" runat="server">
        <tr>
            <td width="590px" id="topborder" class="TitleBarText">
                Current Medications
            </td>
            <td align="left" width="10px">
                <img id="ImgCross" onclick="closeDiv()" src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>'
                    title="Close" alt="Close" />
            </td>
        </tr>
    </table>
    <table id="TableError" cellpadding="0" cellspacing="0" border="0" style="display:none;" runat="server">
        <tr>
            <td style="width: 5%" valign="middle">
                <div id="divimg" runat="server">
                    <asp:Image ID="imgError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif" />
                </div>
            </td>
            <td style="width: 1%" valign="middle">
            </td>
            <td style="width: 91%" valign="middle">
                <asp:Label ID="lblError" runat="server" Visible="true" ForeColor="Red" Font-Names="Microsoft Sans Serif"
                    Font-Size="8.25pt"></asp:Label>
            </td>
        </tr>
    </table>
            <table cellpadding="0" cellspacing="0" border="0" style="font-family: Times New Roman; font-size: 12pt; font-weight: bold; padding-left: 3px;" width="20%">
        <tr>
            <td class="LeftHeading" style="background-repeat: no-repeat">
            </td>
            <td class="CenterHeading" style="background-repeat: repeat-x">
                <b>Current Medications</b>
            </td>
            <td class="RightHeading">
                &nbsp;
            </td>
        </tr>
    </table>
            <table cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; padding-left: 3px;"
        width="96%">
        <tr>
            <td>
                <asp:Panel ID="PanelCurrentMedicationListInformation" runat="server" BorderColor="Black"
                    BorderStyle="None" Height="350px" Width="100%" Style="overflow-: none; overflow-y: auto;">
                </asp:Panel>
                <asp:HiddenField ID="HiddenClientId" runat="server" />
            </td>
        </tr>
    </table>
    <table border="0" cellpadding="0" cellspacing="0" width="96%">
        <tr>
            <td style="width: 49%;" align="right">
                <input id="ButtonSelect" type="button" runat="server" value="Select" class="btnimgexsmall"
                    onclick="returnScriptDrugStrengthId('CurrentMedications'); return false;" />
            </td>
            <td style="width: 2%;">
                &nbsp;
            </td>
            <td style="width: 49%;" align="left">
                <input id="ButtonCancel" type="button" value="Cancel" class="btnimgexsmall" onclick="javascript:CloseCurrentMedication();" />
                <input type="hidden" id="HiddenFieldDrugStrengthId" name="HiddenFieldDrugStrengthId" />
                <input type="hidden" id="HiddenFieldSureScriptsRefillRequestId" name="HiddenFieldSureScriptsRefillRequestId"
                    runat="server" />
            </td>
        </tr>
    </table>
    </form>
</body>
</html>