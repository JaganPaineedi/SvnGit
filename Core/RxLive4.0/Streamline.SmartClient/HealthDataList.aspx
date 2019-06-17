<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HealthDataList.aspx.cs" Inherits="HealthDataList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>HealthDataList</title>
    <link href="~/App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="~/App_Themes/Includes/JS/MedicationClientPersonalInformation.js?rel=3_5_x_4_1"
        language="javascript"></script>

    <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" type="text/javascript"></script>

    <script language="JavaScript" src="App_Themes/Includes/JS/DatePopUp/ts_picker.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script language="JavaScript" src="App_Themes/Includes/JS/jscalendar/calendar.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script language="JavaScript" src="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script language="JavaScript" src="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1"
        type="text/javascript"></script>
    
    <link href="App_Themes/Includes/JS/jscalendar/calendar-blue.css?rel=3_5_x_4_1" type="text/css"
        rel="stylesheet" />

    <script type="text/javascript" language="javascript">

        function HealthDataListPageLoad() {
            GetHealthGraph();
        }

        function CalShow(ImgCalID, TextboxID) {
            try {
                Calendar.setup({
                    inputField: TextboxID,
                    ifFormat: "%m/%d/%Y",
                    showsTime: false,
                    button: ImgCalID,
                    step: 1,
                    onUpdate: function(obj) { if (obj.targetElement != null) obj.targetElement.focus(); }
                });
                } catch(e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
        }

        //Show the add health popup

        function OpenHealthPopUp() {
            var DivSearch = parent.document.getElementById('DivSearch');
            DivSearch.style.display = 'block';
            var iFrameSearch = parent.document.getElementById('iFrameSearch');
            iFrameSearch.contentWindow.document.body.innerHTML = "<div></div>";
            iFrameSearch.src = 'HealthData.aspx?';
            iFrameSearch.style.positions = 'absolute';
            DivSearch.style.left = -300;
            DivSearch.style.top = 150;
            DivSearch.style.height = 350;
            DivSearch.style.width = 800;
            iFrameSearch.style.width = 500;
            iFrameSearch.style.height = 310;

        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <cc1:TabContainer ID="TabContainerMain" runat="server">
        <cc1:TabPanel ID="TabPanelData" runat="server" HeaderText="Health Data" CssClass="ajax__tab_body">
            <ContentTemplate>
                <table width="99%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                                <td style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 90%;" rowspan="2">
                            <table id="TableHealthDataList" runat="server" border="0" cellpadding="0" cellspacing="0"
                                width="100%">
                                <tr>
                                    <td colspan="2" style="height: 8px">
                                    </td>
                                </tr>
                                <tr>
                                            <td style="height: 22px; width: 124px;">
                                        <asp:DropDownList ID="DropDownHealthDataCategory" onChange="FillHealthDataList(this);"
                                            runat="server" Width="100%">
                                        </asp:DropDownList>
                                    </td>
                                            <td style="height: 22px; width: 140px;">
                                        <input id="Button1" type="button" onclick="OpenHealthPopUp();" value="Add Health Data"
                                            class="btnimglarge" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                                <asp:Panel ID="PanelHealthDataList" Style="height: 120px; overflow: -x:hidden; width: 100%;"
                                            runat="server">
                                        </asp:Panel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                        <div id="DivSearch" style="display: none; left: 100px; position: absolute; top: 0px; z-index: 990;">
                            <iframe id="iFrameSearch" name="iFrameSearch" style="background-color: White; border-bottom: black thin solid; border-left: black thin solid; border-right: black thin solid; border-top: black thin solid; height: 340px; left: 600px; position: absolute; top: 0px; width: 225px;"
                        frameborder="0" marginheight="0" marginwidth="0" scrolling="no"></iframe>
                </div>
            </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel ID="TabPanelGraph" runat="server" HeaderText="Graph" CssClass="ajax__tab_body">
            <ContentTemplate>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                                <td style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 80%;">
                            <table id="TableGraph" runat="server" border="0" cellpadding="0" cellspacing="0"
                                width="100%">
                                <tr>
                                    <td style="height: 8px">
                                        <asp:Label ID="LabelError" runat="server" ForeColor="red" CssClass="Label" Style="display: none"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%">
                                        <asp:DropDownList ID="DropDownHealthDataListGraph" runat="server" Width="95%">
                                        </asp:DropDownList>
                                    </td>
                                    <td width="10%" class="labelFont">
                                        Start Date:
                                    </td>
                                    <td width="20%" style="color: Green;">
                                        <asp:TextBox ID="TextBoxStartDate" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
                                        <img id="Img1" src="App_Themes/Includes/Images/calender_grey.gif" onclick="CalShow(this, '<%=TextBoxStartDate.ClientID%>')"
                                            alt="" align="middle" />
                                    </td>
                                    <td width="10%" class="labelFont">
                                        End Date:
                                    </td>
                                    <td width="20%">
                                        <asp:TextBox ID="TextBoxEndDate" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
                                        <img id="Img2" src="App_Themes/Includes/Images/calender_grey.gif" onclick="CalShow(this, '<%=TextBoxEndDate.ClientID%>')"
                                            alt="" align="middle" />
                                    </td>
                                    <td width="10%">
                                        <input type="button" align="right" class="btnimgexsmall" value="Filter" tabindex="18"
                                            style="width: 30px" onclick="GetHealthGraph();" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" width="99%">
                    <tr>
                                <asp:Panel ID="PanelGraphListInformation" Style="height: 97%; overflow: auto; width: 100%;"
                            runat="server">
                        </asp:Panel>
                    </tr>
                </table>
            </ContentTemplate>
        </cc1:TabPanel>
    </cc1:TabContainer>
    <asp:HiddenField ID="HiddenHealthDataList" runat="server" Value="" />
    <input type="hidden" runat="server" id="hiddenHealthDataCategory" />
    <input type="hidden" runat="server" id="hiddenHealthItemName" />
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

<script>
    Sys.Application.add_load(HealthDataListPageLoad)
</script>

</html>