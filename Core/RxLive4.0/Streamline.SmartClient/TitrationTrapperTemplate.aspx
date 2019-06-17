<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TitrationTrapperTemplate.aspx.cs"
    Inherits="TitrationTrapperTemplate" %>

<%@ Register Src="BasePages/UI/Heading.ascx" TagName="Heading" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head runat="server">
    <title>Titration/Taper Template</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Includes/JS/jscalendar/calendar-blue.css?rel=3_5_x_4_1" type="text/css"
        rel="stylesheet" />

    <script language="javascript" type="text/javascript">
        function TitrationTemplatePageLoad() {
            try {
                RegisterTitrationTemplateControlEvents();
                var radioButtonClinicianTemplate = document.getElementById('RadioButtonClinicianTemplate');
                var radioButtonPrescriberTemplate = document.getElementById('RadioButtonPrescriberTemplate');
                if (radioButtonClinicianTemplate.checked) {
                    document.getElementById('<%=HiddenRadioButtonTitrationTempValue.ClientID%>').value = 'Client';
                    } else if (radioButtonPrescriberTemplate.checked) {
                        document.getElementById('<%=HiddenRadioButtonTitrationTempValue.ClientID%>').value = 'Others';
                    }


            } catch (ex) {

                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, ex);
            }
        }

        function GetTitrationTemplate(condition) {
            try {
                document.getElementById('<%=HiddenRadioButtonTitrationTempValue.ClientID%>').value = condition;
                    GetTitrationTemplateList('<%=PanelTitrationTraperList.ClientID%>', condition, '<%=HiddenTitrationTemplateId.ClientID%>');
                } catch (ex) {
                }
            }

            function onRadioClick(sender, e) {

                try {
                    var titrationTemplateId = sender.target.getAttribute("TitrationTemplateId");
                    //alert('Called from Titration TraperTemplate.aspxHiddenFieldId--'+document.getElementById('<%=HiddenTitrationTemplateId.ClientID%>').value);
                    document.getElementById('<%=HiddenTitrationTemplateId.ClientID%>').value = titrationTemplateId;

                } catch (ex) {
                    alert('PageName:-TitrationTemplate.aspx;FunctionName:-onRadioClick;ErrorrMessage:-' + ex);
                }
            }

            function CloseTemplate() {
                window.close();
               
                if (parent.document.getElementById('dialog-close'))
                    parent.document.getElementById('dialog-close').click();
            }

            function ReturnValues() {
                try {
                    if (document.getElementById('TextBoxTitrationTaperDate').value == "") {
                        alert('Please select Titration/Taper Date');
                        return false;
                    } else {
                        SetReturnValues('<%=TextBoxTitrationTaperDate.ClientID%>', '<%=HiddenTitrationTemplateId.ClientID%>');
                        if (parent.document.getElementById('dialog-close'))
                            parent.document.getElementById('dialog-close').click();
                    }
                } catch (e) {
                }
            }

            function CalShow(ImgCalID, TextboxID) {
                Calendar.setup({
                    inputField: TextboxID,
                    ifFormat: "%m/%d/%Y",
                    showsTime: false,
                    button: ImgCalID,
                    step: 1
                });
            }
    </script>

</head>
<body>
    <form id="form1" runat="server">
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
                <asp:ScriptReference Path="App_Themes/Includes/JS/TitrationTemplate.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/ClientMedicationOrder.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <%--End Added By Pradeep as per task#15--%>
            </Scripts>
        </asp:ScriptManager>
        <%--<div style="height: 680px; width: 840px;">--%>
        <div>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:white">
                <tr>
                    <td style="width: 5px" valign="top">&nbsp;</td>
                    <td align="left" valign="top">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="height: 10px"></td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td class="labelFont" align="left" style="width: 80px">Drug:   <asp:Label ID="LabelDrugName" runat="server" CssClass="Label"></asp:Label>
                                            </td>
                                            <%--<td style="width: 5px" align="left">&nbsp;</td>
                                            <td align="left">
                                              
                                            </td>--%>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 5px;" valign="top"></td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td align="left">
                                                <%--<asp:RadioButton ID="RadioButtonClinicianTemplate" runat="server" Text="My Template"
                                                GroupName="Type" CssClass="SumarryLabel" AutoPostBack="false"  />
                                            <asp:RadioButton ID="RadioButtonPrescriberTemplate" runat="server" Text="Other Prescriber's Template"
                                                GroupName="Type" CssClass="SumarryLabel" AutoPostBack="false" />--%>
                                                <input id="RadioButtonClinicianTemplate" runat="server" checked="true" type="radio" name="TemplateType" onclick="GetTitrationTemplate('Client');" tabindex="1" />
                                                <a class="radiobtntext">My Template</a>
                                                <input id="RadioButtonPrescriberTemplate" runat="server" name="TemplateType" type="radio" onclick="GetTitrationTemplate('Others');" tabindex="3" />
                                                <a class="radiobtntext">Other Prescriber's Template</a>
                                                <input type="hidden" id="HiddenRadioButtonTitrationTempValue" runat="server" />
                                                <input type="hidden" id="HiddenTitrationTemplateId" runat="server" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 10px" valign="top"></td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <table border="0" width="100%">
                                        <tbody valign="top">
                                            <tr>
                                                <td>
                                                    <uc1:Heading ID="HeadingTitrationTraperTemplate" runat="server" HeadingText="Titration/Taper Templates" />
                                                    <div id="PlaceHolder" runat="server" visible="true" style="height: 350px; overflow: auto">
                                                        <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; height: 345px; width: 100%;" cellspacing="0"
                                                            cellpadding="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td style="width: 100%;" valign="top">
                                                                        <asp:Panel ID="PanelTitrationTraperList" runat="server" BackColor="White" BorderStyle="None"
                                                                            Style="overflow-x: hidden" BorderColor="Black">
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
                            <tr>
                                <td style="height: 5px" valign="top"></td>
                            </tr>
                            <tr>
                                <td valign="middle">
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td class="labelFont" align="left" style="width: 25%;">Titration/Taper Start</td>
                                            <td style="width: 5%" align="left" valign="top"></td>
                                            <td align="left" style="width: 25%">
                                                <asp:TextBox ID="TextBoxTitrationTaperDate" TabIndex="3" runat="server" Width="65px"></asp:TextBox>

                                                <img id="ImgStartDate" src="App_Themes/Includes/Images/calender_grey.gif" onclick="ClientMedicationTitration.CalShow(this, '<%=TextBoxTitrationTaperDate.ClientID %>')"
                                                    onmouseover="ClientMedicationTitration.CalShow( this, '<%=TextBoxTitrationTaperDate.ClientID %>')" alt="" style="vertical-align: middle"
                                                    visible="false" />
                                            </td>
                                            <td align="center" width="20%">
                                                <input type="button" tabindex="4" id="buttonSelect" class="btnimgexsmall" value="Select" onclick="ReturnValues();" />
                                            </td>
                                            <td align="left" style="width: 5%">&nbsp;
                                            </td>
                                            <td align="left">
                                                <input type="button" tabindex="5" id="buttonCancel" class="btnimgexsmall" value="Cancel" onclick="CloseTemplate()" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
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
