<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PatientConsentHistory.ascx.cs"
    Inherits="Streamline.SmartClient.UI.UserControls_PatientConsentHistory" %>
<%@ Register Src="ConsentHistoryList.ascx" TagName="ConsentHistoryList" TagPrefix="uc1" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>
<asp:ScriptManagerProxy runat="server" ID="SMP1">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/PatientConsentHistory.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>
<table style="width: 100.7%" border="0" cellpadding="0" cellspacing="0">
    <tr>
      
        <td align="left" style="width: 60%" class="header">
            <asp:Label ID="LabelSmartCareRx" runat="server" Visible="true" ForeColor="White"
                Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
        </td>
        <td style="width: 40%; padding-right:0.7%;" align="right" class="header">
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="right" style="width: 50%">
                        <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" runat="server" Style="display: none"
                            OnClientClick="redirectToStartPage();this.disabled=true;return false;" ForeColor="White"></asp:LinkButton>
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
        <td style="height: 1pt; border-bottom: #5b0000 1px solid;" colspan="2">
        </td>
    </tr>
    <tr>
       
            <td style="width: 30%">
            <asp:Label ID="Label2" runat="server" Visible="true" CssClass="TittleBarBase" Text="View Consent History"></asp:Label>
      
        </td>
        <td>
        <table style="float:right">
            <tr>
        <td align="right" style="padding-right:0.7%;">        
            <input type="image" id="ButtonPrintList" name="ButtonPrintList" value="Print List" onclick="javascript: ButtonPrintListViewConsentHistory('Medications - View Client Consent History'); return false;"
                 src="App_Themes/Includes/Images/print_icon.gif" title="Print List" style="padding-right:5px;" />
          
         <td style="background-color:#bdbdbd; width:1px;"></td> 
        <td align="right">
            <asp:ImageButton ID="ButtonCancel" runat="server" ToolTip="Close" OnClientClick="redirectToManagementPage(); return false;" ImageUrl="~/App_Themes/Includes/Images/close_icon.gif" /> 
          </td>
             <td style="background-color:#bdbdbd; width:1px;"></td> 
                </tr>
            </table>
         </td>
    </tr>
    <tr>
      <td align="left" colspan="2">
                <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif" />
            </td>
        </tr>
    <tr>
      
                    <td align="left" nowrap="nowrap" style="padding-left:8px;">
                        <asp:Label ID="LabelClientName" runat="server"></asp:Label>
                    </td>
                    
             
    </tr>
</table>

<script type="text/javascript" language="javascript">

    function fnHideParentDiv1() {

        try {
            var objdvProgress = document.getElementById('dvProgress');
            if (objdvProgress != null)
                objdvProgress.style.display = 'none';
        }
        catch (Exception) {
            alert(Exception.message);
        }

    }


    function fnShowTemp() {

        try {
            fnShowParentDiv("Processing...", 150, 25)
        }
        catch (Exception) {
        }
    }

    function fnShowParentDiv(msgText, progMsgLeft, progMsgTop) {

        try {

            var objdvProgress = document.getElementById("dvProgress");
            objdvProgress.style.left = progMsgLeft;
            objdvProgress.style.top = progMsgTop;
            objdvProgress.style.display = '';
        }
        catch (Exception) {
        }

    }

    function SetMedicationFilterValue(DropDownConsentMedication) {
        try {
            document.getElementById('<%=HiddenFieldMedication.ClientID%>').value = document.getElementById('<%=DropDownConsentMedication.ClientID%>').value

        }
        catch (Exception) {
        }
    }
  

  
</script>

<div>
    <%--Start By Pradeep--%>
    <table align="center" border="0" cellpadding="0" cellspacing="0" style="width:100%;">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td align="LEFT" style="height: 10px; width: 3%" valign="middle">
                            <img id="ImgError" src="App_Themes/Includes/Images/error.gif" alt="" style="display: none;" />&nbsp;
                        </td>
                        <td valign="middle" style="width: 99%">
                            <asp:Label ID="LabelError" runat="server" CssClass="redTextError" Width="90%"></asp:Label>
                        </td>
                        <td align="right" style="width: 12%; padding-right: 5px">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width:100%;">
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

                            <table cellpadding="0" border="0" cellspacing="0" style="width: 60%; text-align:center;">
                                <tr>
                                 
                                    <td>
                                        Start Date&nbsp;
                                        <asp:TextBox ID="TextBoxConsentStartDate" runat="server" AutoCompleteType="Disabled"
                                            CssClass="TextBox" MaxLength="30" TabIndex="1" Width="70px"></asp:TextBox>
                                         <img id="Img2" src="App_Themes/Includes/Images/calender_grey.gif" class="imgcal" onclick="CalShow( this, '<%=TextBoxConsentStartDate.ClientID%>')"
                                            onmouseover="CalShow( this, '<%=TextBoxConsentStartDate.ClientID%>')" alt="" />
                                    </td>                                   
                                 
                                    <td>
                                        End Date&nbsp;
                                        <asp:TextBox ID="TextBoxConsentEndDate" runat="server" AutoCompleteType="Disabled"
                                            CssClass="TextBox" MaxLength="30" TabIndex="2" Width="70px"></asp:TextBox>
                                         <img id="Img1" src="App_Themes/Includes/Images/calender_grey.gif" class="imgcal"  onclick="CalShow( this, '<%=TextBoxConsentEndDate.ClientID%>')"
                                            onmouseover="CalShow( this, '<%=TextBoxConsentEndDate.ClientID%>')" alt="" />
                                    </td>                                   
                               
                                    <td>
                                        Medication&nbsp;
                                        <asp:DropDownList ID="DropDownConsentMedication" runat="server" AutoCompleteType="Disabled"
                                            CssClass="ddlist" MaxLength="30" TabIndex="3" Width="200px">
                                        </asp:DropDownList>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <asp:Button ID="ButtonApplyFilter" runat="server" Text="Apply Filter" CssClass="btnimgexsmall"
                                            OnClick="ButtonApplyFilter_Click" TabIndex="4" /><asp:HiddenField ID="HiddenFieldMedication"
                                                runat="server" />
                                    </td>
                                   
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
                    <tr>
                        <td valign="top">
                            <a href="abc" id="testMedHistory" target="_blank"></a>
                           
                        </td>
                    </tr>
                    <tr>
                        <td width="990px" valign="top">
                            <UI:Heading ID="HeadingMedicationList" runat="server" HeadingText="Consent List" />
                            <table cellpadding="0" cellspacing="0" style="border: 1px; height: 100px; border-color: Black;
                                width: 100%">
                                <tr>
                                    <td>
                                        <!-- Medication List Control -->
                                        <table cellpadding="0" cellspacing="0" style="border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid;
                                            border-left: #dee7ef 3px solid; border-bottom: #dee7ef 3px solid" width="100%">
                                            <tr>
                                                <td>
                                                    <asp:Panel ID="PanelConsentMedicationListInformation" runat="server" BorderColor="Black"
                                                        BorderStyle="None" Height="400px" Width="100%">
                                                        <uc1:ConsentHistoryList ID="ConsentHistoryList1" runat="server" />
                                                    </asp:Panel>
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
</div>

<script type="text/javascript" language="javascript">

    SetVariableName(document.getElementById('<%=PanelConsentMedicationListInformation.ClientID%>'));
</script>

