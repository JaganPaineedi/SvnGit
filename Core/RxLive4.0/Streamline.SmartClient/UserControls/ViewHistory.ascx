<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ViewHistory.ascx.cs" Inherits="Streamline.SmartClient.UI.UserControls_ViewHistory" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>
<%@ Register TagPrefix="UI" TagName="MedicationList" Src="~/UserControls/MedicationList.ascx" %>
<asp:ScriptManagerProxy runat="server" ID="SMP1">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/ViewMedicationHistory.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>


<table style="width: 100.7%" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>

        <td style="width: 40%" class="header">
            <asp:Label ID="LabelSmartCareRx" runat="server" Visible="true" ForeColor="White"
                Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
        </td>
        <td style="width: 60%; padding-right: 0.7%;" align="right" class="header">
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="right" style="width: 50%">
                        <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" runat="server" OnClientClick="redirectToStartPage();this.disabled=true;return false;"
                            Style="display: none" ForeColor="White"></asp:LinkButton>
                    </td>
                    <td align="right" style="width: 10%">
                        <%--<asp:LinkButton ID="LinkButtonLogout" Text="" runat="server" OnClick="LinkButtonLogout_Click"
                            Style="display: none"><asp:Image ID="image_logoff" runat="server" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Style="border-width: 0px;" /></asp:LinkButton>--%>
                        <asp:ImageButton ID="LinkButtonLogout" Style="display: none" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Text="" runat="server" OnClick="LinkButtonLogout_Click" />

                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="height: 1pt; border-bottom: #5b0000 1px solid;" colspan="2"></td>
    </tr>
    <tr>
        <td style="width: 30%">
            <asp:Label ID="Label2" runat="server" Visible="true" CssClass="TittleBarBase" Text="View Medication History"></asp:Label>
        </td>
        <td align="right" style="padding-right: 0.7%;">

            <%-- <input type="image" style="display:none" id="ButtonPrintList1" name="ButtonPrintList" value="Print List" onclick="javascript: ButtonPrintListViewHistory('Medications - View History'); return false;"
                src="App_Themes/Includes/Images/print_icon.gif" title="Print List" <%=enableDisabled(Streamline.BaseLayer.Permissions.PrintList)%> style="padding-right:5px;" />               
            --%>

            <asp:ImageButton ID="ButtonCancel" runat="server" ToolTip="Close" OnClientClick="redirectToManagementPage();return false;" ImageUrl="~/App_Themes/Includes/Images/close_icon.gif" />
        </td>
    </tr>
    <tr>
        <td align="left" colspan="2">
            <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif" />
        </td>
    </tr>
    <tr>
        <td align="left" nowrap="nowrap" colspan="2" style="padding-left: 8px;">
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
            ShowError(Exception.description, true);
        }

    }


    function fnShowTemp() {

        try {
            fnShowParentDiv("Processing...", 150, 25)
        }
        catch (Exception) {
            ShowError(Exception.description, true);
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
            ShowError(Exception.description, true);
        }

    }

    function SetFilterValue(DropDownMedication) {
        try {
            document.getElementById('<%=HiddenFieldMedication.ClientID%>').value = document.getElementById('<%=DropDownMedication.ClientID%>').value
        }
        catch (Exception) {
            ShowError(Exception.description, true);
        }
    }

    function SetPrescriberFilterValue() {
        try {
            document.getElementById('<%=HiddenFieldPrescriber.ClientID%>').value = document.getElementById('<%=DropDownListPrescriber.ClientID%>').value
        }
        catch (Exception) {
            ShowError(Exception.description, true);
        }
    }
    function SetDateFilterValue() {
        try {
            document.getElementById('<%=HiddenFieldDateFilter.ClientID%>').value = document.getElementById('<%=DropDownListDateFilter.ClientID%>').value
            //alert(document.getElementById('<%=HiddenFieldDateFilter.ClientID%>').value);
        }
        catch (Exception) {
            ShowError(Exception.description, true);
        }
    }
    function SetDiscontinueReasonFilterValue() {
        try {
            document.getElementById('<%=HiddenFieldDiscontineReasonFilter.ClientID%>').value = document.getElementById('<%=DropDownListDiscontinuedReason.ClientID%>').value
        }
        catch (Exception) {
            ShowError(Exception.description, true);
        }
    }

</script>

<div style="margin-left: 8px;">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td>
                <table border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="LEFT" style="height: 10px; width: 3%" valign="middle">
                            <img id="ImgError" src="App_Themes/Includes/Images/error.gif" alt="" style="display: none;" />&nbsp;
                        </td>
                        <td valign="middle" style="width: 100%">
                            <asp:Label ID="LabelError" runat="server" CssClass="redTextError"></asp:Label>
                        </td>
                        <td align="right"></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <!--Source-->
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;">
                    <tr>
                        <td>

                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td class="toplt_curve" style="width: 6px"></td>
                                    <td class="top_brd" style="width: 99%"></td>
                                    <td class="toprt_curve" style="width: 6px"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>

                        <td class="mid_bg ltrt_brd">
                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%; margin-left: 5px;">
                                <tr>
                                    <td>Date&nbsp;                                                                      
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="DropDownListDateFilter" runat="server" AutoCompleteType="Disabled"
                                            CssClass="ddlist" MaxLength="30" TabIndex="6" Width="150px">
                                        </asp:DropDownList>
                                        &nbsp;
                                    </td>
                                    <td>Start Date
                                    </td>
                                    <td>
                                        <asp:TextBox ID="TextBoxStartDate" runat="server" AutoCompleteType="Disabled" CssClass="TextBox"
                                            MaxLength="30" TabIndex="5" Width="95px" Height="15px"></asp:TextBox>

                                        <img id="Img2" src="App_Themes/Includes/Images/calender_grey.gif" class="imgcal" onclick="CalShow( this, '<%=TextBoxStartDate.ClientID%>')"
                                            onmouseover="CalShow( this, '<%=TextBoxStartDate.ClientID%>')" alt="" />
                                    </td>
                                    <td>End Date
                                    </td>
                                    <td>
                                        <asp:TextBox ID="TextBoxEndDate" runat="server" AutoCompleteType="Disabled" CssClass="TextBox"
                                            MaxLength="30" TabIndex="5" Width="95px" Height="15px"></asp:TextBox>
                                        <img id="Img1" src="App_Themes/Includes/Images/calender_grey.gif" class="imgcal" onclick="CalShow( this, '<%=TextBoxEndDate.ClientID%>')"
                                            onmouseover="CalShow( this, '<%=TextBoxEndDate.ClientID%>')" alt="" />
                                    </td>

                                    <td>

                                        <asp:Button ID="ButtonApplyFilter" runat="server" Text="Apply Filter" CssClass="btnimgexsmall"
                                            OnClick="ButtonApplyFilter_Click" />
                                    </td>





                                </tr>
                                <tr>
                                    <td style="height: 5px;"></td>
                                </tr>
                                <tr>

                                    <td>Medication    
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="DropDownMedication" runat="server" AutoCompleteType="Disabled"
                                            CssClass="ddlist" MaxLength="30" TabIndex="6" Width="200px">
                                        </asp:DropDownList>

                                    </td>

                                    <td>Prescriber
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="DropDownListPrescriber" runat="server" AutoCompleteType="Disabled"
                                            CssClass="ddlist" MaxLength="30" TabIndex="4" Width="200px">
                                        </asp:DropDownList>

                                    </td>



                                    <td>Discontinue Reason
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="DropDownListDiscontinuedReason" runat="server" AutoCompleteType="Disabled"
                                            CssClass="ddlist" MaxLength="30" TabIndex="4" Width="200px">
                                        </asp:DropDownList>

                                    </td>


                                    <td>
                                        <asp:HiddenField ID="HiddenFieldMedication" runat="server" />
                                        <asp:HiddenField ID="HiddenFieldDateFilter" runat="server" />

                                        <asp:HiddenField ID="HiddenFieldPrescriber" runat="server" />
                                        <asp:HiddenField ID="HiddenFieldDiscontineReasonFilter" runat="server" />
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
                                    <td class="bot_brd" style="width: 99%"></td>
                                    <td class="botrt_curve" style="width: 6px"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr style="padding-top: 12px; padding-bottom: 12px">
                        <td valign="top">
                            <a href="abc" id="testMedHistory" target="_blank"></a>



                            <input type="button" id="ButtonPrintList" name="ButtonPrintList" value="Print List" onclick="javascript: ButtonPrintListViewHistory('Medications - View History'); return false;"
                                class="btnimgsmall" <%=enableDisabled(Streamline.BaseLayer.Permissions.PrintList)%> />
                            <input type="button" id="ExapandCollapseMedList" name="ButtonExapandCollapseMedList" value="Expand/Collapse All" class="ExapandCollapseMedList btnimglarge" />



                        </td>
                    </tr>
                    <tr>
                        <td width="100%" valign="top">
                            <UI:Heading ID="HeadingMedicationList" runat="server" HeadingText="Medication List" />
                            <table cellpadding="0" cellspacing="0" style="border: 1px; height: 100px; border-color: Black; width: 100%">
                                <tr>
                                    <td>
                                        <!-- Medication List Control  -->
                                        <table class="PanelMedicationTable" cellpadding="0" cellspacing="0" style="border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-bottom: #dee7ef 3px solid"
                                            width="100%">
                                            <tr>
                                                <td>
                                                    <asp:Panel ID="PanelMedicationListInformation" runat="server" BorderColor="Black"
                                                        BorderStyle="None" Height="380px" Width="100%" Style="overflow: auto;">
                                                        <UI:MedicationList ID="MedicationList1" runat="Server" />
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                        </table>
                                        <!-- Medication List Control -->
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

    SetVariableName(document.getElementById('<%=PanelMedicationListInformation.ClientID%>'));
   
 


</script>

