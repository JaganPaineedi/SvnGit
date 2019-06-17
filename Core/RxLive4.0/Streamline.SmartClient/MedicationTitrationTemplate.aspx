<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicationTitrationTemplate.aspx.cs"
    Inherits="MedicationTitrationTemplate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Titration Template Name</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Includes/JS/jscalendar/calendar-blue.css?rel=3_5_x_4_1" type="text/css"
        rel="stylesheet" />

    <script type="text/javascript" language="javascript" src="App_Themes/Includes/JS/ClientMedicationTitration.js?rel=3_5_x_4_1"></script>

</head>
<body>
    <form id="form1" runat="server" style="background-color: white">
        <table class="PopUpTitleBar" border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td width="100%" id="topborder" class="TitleBarText" align="left">
                    Titration Template</td>
            </tr>
        </table>
         <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="WebServices/CommonService.asmx" />
                <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
            </Services>
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
                <asp:ScriptReference Path="App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/ClientMedicationTitration.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <%--Start Added By Pradeep as per task#15--%>
                <%--<asp:ScriptReference Path="App_Themes/Includes/JS/TitrationTemplate.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />--%>
                <%--End Added By Pradeep as per task#15--%>
            </Scripts>
        </asp:ScriptManager>
        <table border="0" cellpadding="0" cellspacing="0" style="background-color: white;">
            <tr>
                <td align="LEFT" style="width: 3%" valign="middle">
                    <img id="ImageGridError" src="App_Themes/Includes/Images/error.gif" alt="" style="visibility: hidden" />&nbsp;
                </td>
                <td valign="middle">
                    <asp:Label ID="LabelGridErrorMessage" runat="server" CssClass="redTextError"></asp:Label></td>
                <td>
                </td>
            </tr>
        </table>
            <table style=" background-color: white ;border-bottom: #FFFFFF 3px solid; border-left: #FFFFFF 3px solid; border-right: #FFFFFF 3px solid; border-top: #FFFFFF 3px solid; width: 100%;" cellspacing="0" cellpadding="0" >
            <tr>
                    <td style="height: 24px; width: 80px;" class="labelFont">
                    Template Name</td>
                    <td style="height: 24px; width: 4px;">
                    &nbsp;</td>
                    <td style="height: 24px; width: 112px;">
                    <asp:TextBox ID="TextBoxTempalteName" runat="server" Width="155px" MaxLength="200"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td height="20px" colspan="3">
                </td>
            </tr>
            <tr >
                <td colspan="3" align="center" valign="bottom">
                    <input type="button" id="ButtonSave" class="btnimgexsmall" value="Save" style="width: 70px;"
                        onclick="ClientMedicationTitration.SaveTitrationTemplate('<%=HiddenFieldMedicationNameId.ClientID%>','<%=HiddenFieldTemplateName.ClientID%>')" /><%--onclick="UseTitrationTemplate()"--%>
                    &nbsp;&nbsp;&nbsp;
                    <input type="button" id="ButtonCancel" class="btnimgexsmall" value="Cancel" style="width: 70px;"
                        onclick="ClientMedicationTitration.CloseTemplate()" />
                        <input id="HiddenFieldMedicationNameId" type="hidden" runat="server" style="height: 9px; width: 14px;" />
                        <input id="HiddenFieldTemplateName" type="hidden" runat="server" style="height: 9px; width: 14px;" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>