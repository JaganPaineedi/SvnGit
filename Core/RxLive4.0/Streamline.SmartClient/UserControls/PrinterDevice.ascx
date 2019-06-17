<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PrinterDevice.ascx.cs"
    Inherits="UserControls_PrinterDevice" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>
<asp:ScriptManagerProxy runat="server" ID="SMP1">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/UserPreferences.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<script language="javascript" type="text/javascript">


    function pageLoad() {

        FillPrinter();

    }
    function FillPrinter() {
        GetPrinterList('<%=PanelPrinterList.ClientID%>', 'DeviceLabel Asc');
    }





    function Insert_Click() {

        try {
            var LabelErrorMessage = document.getElementById('<%=LabelErrorMessage.ClientID%>');

            var ImageError = document.getElementById('<%=ImageError.ClientID%>');
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';

            if (document.getElementById('<%=DropDownListLocations.ClientID%>').value == '0') {
                ImageError.style.display = 'block';
                ImageError.style.visibility = 'visible';
                LabelErrorMessage.innerText = 'Please Select location.';
                return false;
            }
            else {
                FillPrinterRow('<%=DropDownListLocations.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=TextBoxPath.ClientID%>', '<%=TextBoxDeviceLabel.ClientID%>', '<%=HiddenRadioButtonValue.ClientID%>', '<%=PanelPrinterList.ClientID%>', 'buttonInsert');
            }
            ClearPrinterControls('<%=DropDownListLocations.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=TextBoxPath.ClientID%>', '<%=TextBoxDeviceLabel.ClientID%>');
        }
        catch (ex) {
        }
    }

    function Clear_Click() {

        ClearPrinterRow('<%=DropDownListLocations.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=TextBoxPath.ClientID%>', '<%=TextBoxDeviceLabel.ClientID%>', '<%=HiddenRadioButtonValue.ClientID%>', '<%=PanelPrinterList.ClientID%>', 'buttonInsert');
        $("input[type=radio]:checked", $("#DivPharmacyList")).attr("checked", false);

    }

    function onPrinterRadioClick(sender, e) {
        document.getElementById('buttonInsert').value = "Update";
        var LabelErrorMessage = document.getElementById('<%=this.ClientID+this.ClientIDSeparator%>LabelErrorMessage');
        var ImageError = document.getElementById('<%=this.ClientID+this.ClientIDSeparator%>ImageError');
        LabelErrorMessage.innerText = '';
        ImageError.style.visibility = 'hidden';
        ImageError.style.display = 'none';

        RadioButtonPrinterParameters(e, '<%=DropDownListLocations.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=TextBoxPath.ClientID%>', '<%=TextBoxDeviceLabel.ClientID%>', '<%=HiddenRadioButtonValue.ClientID%>');


    }
    function onDeleteClick(sender, e) {
        sessionStorage.setItem('e', JSON.stringify(e));
        var popupWindow = window.showModalDialog('YesNo.aspx?CalledFrom=PrintList', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
        if (popupWindow == 'Y') {

            if (e == undefined) {
                var e = JSON.parse(sessionStorage.e);
            }
            try {
                DeleteFromPrinterList(e);
                Clear_Controls();
            }
            catch (err) {
            }
        }
    }

    function Clear_Controls() {

        ClearPrinterControls('<%=DropDownListLocations.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=TextBoxPath.ClientID%>', '<%=TextBoxDeviceLabel.ClientID%>');
    }
    function onPrinterHeaderClick(obj) {
        onHeaderPrinterClick(obj);
    }
</script>


<table id="TableMain" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td>
            <table id="TableTitle" border="0" cellpadding="0" cellspacing="0" width="100.7%">
                <tr>
                   
                    <td style="width: 40%" class="header">
                        <asp:Label ID="LabelSmartCareRx" runat="server" Visible="true"
                            Text="© Streamline Healthcare Solutions | SmartCareRx" style="display:none" ForeColor="White"></asp:Label>
                    </td>
                    <td style="width: 60%; padding-right:0.7%;" align="right" class="header">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right" style="width: 50%">
                                    <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" ForeColor="White" runat="server" OnClientClick="redirectToStartPage();this.disabled=true;return false;"></asp:LinkButton>
                                </td>
                                <td align="right" style="width: 10%">
                                    <%--<asp:LinkButton ID="LinkButtonLogout" Text="" runat="server" OnClick="LinkButtonLogout_Click"
                                        Style="display: none"><asp:Image ID="image_logoff" runat="server" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" BorderWidth="0" /></asp:LinkButton>--%>
                                     <asp:ImageButton ID="LinkButtonLogout" Style="display: none" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Text="" runat="server" OnClick="LinkButtonLogout_Click" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="height: 1pt; border-bottom: #5b0000 1px solid;">
                    </td>
                </tr>
                
                
                <tr>
                     <td>
                        <asp:Label ID="Label1" runat="server" Visible="true" CssClass="TittleBarBase" Text="Add Printer Device"></asp:Label>
                    </td>
                    
                    
                     <td align="right" style="padding-right:0.7%;">
                         <asp:ImageButton ID="ButtonClose" runat="server" ToolTip="Close" OnClientClick="redirectToStartPage();return false;" ImageUrl="~/App_Themes/Includes/Images/close_icon.gif" />
                                </td>
                </tr>
                
                
                
                
                <tr>
                     <td align="left" colspan="2">
                <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif" />
            </td>
            
            
            
            
                </tr>
                <tr>
                    <td align="right" colspan="3" style="padding-left:8px;">
                        <table cellpadding="0" width="100%" cellspacing="0" border="0">
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                        
                                            <td valign="middle" style="width: 16px">
                                                <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif"
                                                    Style="display: none;" />
                                            </td>
                                            <td valign="middle" align="left">
                                                <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError" Height="18px"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                               
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table id="TableGeneral" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-left:8px;">
    <tr>
        <td>
            <UI:Heading ID="Heading1" runat="server" HeadingText="Details" />
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td >
                         <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td class="toplt_curve" style="width: 6px"></td>
                                                                        <td class="top_brd" style="width: 100%"></td>
                                                                        <td class="toprt_curve" style="width: 6px"></td>
                                                                    </tr>
                                                                </table>
                    </td>
                    </tr>
                                                        <tr>

                                                                        <td class="mid_bg ltrt_brd">
            <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>   
                                <td >
                                    <table>
                                        <tr>
                                            <td class="labelFont">
                                                 <asp:Label ID="LabelName" class="Label" runat="server" Text="Location"></asp:Label>
                                                    </td>
                                            <td>
                                                
                                                
                                                 <asp:DropDownList ID="DropDownListLocations" runat="server" Width="206px">
                                    </asp:DropDownList>
                                            </td>
                                            <td><asp:CheckBox ID="CheckBoxActive" runat="server" Text="Active" Style="text-align: center" /></td>
                                        </tr>
                                    </table>
                                </td>
                            
                                <td class="labelFont">
                                    <asp:Label ID="LabelPath" class="Label" runat="server" Text="Path"></asp:Label>
                                    <asp:TextBox ID="TextBoxPath" runat="server" CssClass="TextBox" Width="170px" MaxLength="50"></asp:TextBox>
                                </td>
                              
                                <td nowrap="nowrap" class="labelFont" valign="middle">
                                    <asp:Label ID="LabelDeviceLabel" class="Label" runat="server" Text="Device Label"></asp:Label>
                                     <asp:TextBox ID="TextBoxDeviceLabel" runat="server" CssClass="TextBox" Width="206px"
                                        MaxLength="50"></asp:TextBox>
                                </td>  
                                 <td>
            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td>                     
                        <input type="button" id="buttonInsert" class="btnimgexsmall" onclick="Insert_Click()"
                            value="Insert" /></td>
                        <td><input type="button" id="buttonClear" class="btnimgexsmall" onclick="Clear_Click()" value="Clear" /></td>
                        
                 
                </tr>
            </table>
        </td>
                            </tr>
                           
                        </table>
                    
                    </td>
                </tr>
            </table>

                                                                            <table border="0" cellpadding="0" cellspacing="0" style="width: 98%">
    <tr>
       
    </tr>
</table>
 </td>
                                                                     
                    </tr>
                 <tr>
                                                            <td>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                                    <tr>
                                                                        <td class="botlt_curve" style="width: 6px"></td>
                                                                        <td class="bot_brd" style="width: 99.1%"></td>
                                                                        <td class="botrt_curve" style="width: 6px"></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                        </table>

        </td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" style="margin-left:8px;">
    <tr>
        <td style="width: 663px; height: 10px;">
            <input type="hidden" id="HiddenRadioButtonValue" runat="server" />
        </td>
        <td align="center">
        </td>
    </tr>
</table>
<table style="border: #dee7ef 3px solid; width:100%; height: 310px; margin-left:8px;" cellspacing="0" cellpadding="0">
    <tbody>
        <tr>
            <td>
                <div id="DivPharmacyList" style="overflow-x: hidden; overflow-y: auto; height: 310px;
                    width: 100%;">
                    <%--<UI:PharmaciesList ID="PharmaciesList1" runat="server" /> --%>
                    <asp:Panel ID="PanelPrinterList" runat="server">
                    </asp:Panel>
                </div>
            </td>
        </tr>
    </tbody>
</table>
