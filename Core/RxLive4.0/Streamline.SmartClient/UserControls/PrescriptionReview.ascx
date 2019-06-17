<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PrescriptionReview.ascx.cs"
    Inherits="UserControls_PrescriptionReview" %>
<asp:ScriptManagerProxy runat="server" ID="SMPOD">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/UserPreferences.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<script type="text/javascript" language="javascript">
function OpenStartPage()
 {   
    if(document.getElementById('<%=LabelErrorMessage.ClientID %>').innerText == 'Your account is disabled.Please contact system administrator.')
    location.href="MedicationLogin.aspx";
    else
    redirectToStartPage();
    
}  
  
function Validate()
{
if(document.getElementById('<%=TextBoxAnswer.ClientID  %>').value == "")
    {
    document.getElementById('<%=LabelErrorMessage.ClientID  %>').style.display = "block";
    document.getElementById('<%=ImageError.ClientID  %>').style.display = "block";
    document.getElementById('<%=LabelErrorMessage.ClientID  %>').innerText ="Enter the Security Answer";        
    return false;
    }     
}    
 
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td style="height:40px">
            <asp:Label ID="Label1" runat="server" CssClass="TittleBarBase" Text="Prescription Review"></asp:Label></td>
        <td align="center" style="width: 30%">
                        <asp:Label ID="LabelSmartCareRx" runat="server" Visible="true" CssClass="SamrtCareTittleBarBase"
                            Text="SmartCareRx"></asp:Label>
                    </td>
                    <td style="width: 30%" align="right">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right" style="width: 50%">
                                    <asp:LinkButton ID="LinkButtonStartPage" Style="display: none" Text="Start Page" runat="server" OnClientClick="redirectToStartPage();return false;"></asp:LinkButton>
                                </td>
                                <td align="right" style="width: 50%">
                                    <asp:LinkButton ID="LinkButtonLogout" Text="Logout" runat="server" OnClick="LinkButtonLogout_Click"
                                        Style="display: none"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                    </td>
    </tr>
    <tr>
        <td colspan="3" style="height: 1pt; border-bottom: #5b0000 1px solid;">
        </td>
    </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="200px">
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="height: 1px">
                <tr>
                    <td valign="middle" style="width:2%" align="right">
                        <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif"
                            Style="display: none;" />
                    </td>
                    <td valign="middle" align ="left" style="width:98%" >
                        &nbsp;
                        <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError"
                            Height="18px"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <table>
                <tr>
                    <td class="labelFont">
                        Prescriber</td>
                    <td width="10px">
                        <asp:HiddenField ID="HiddenFieldRDLCurrentDateTime" runat="server" />
                    </td>
                    <td nowrap>
                        <asp:Label ID="LabelPrescriberName" runat="server" Width="200px" CssClass="Label"></asp:Label>
                    </td>
                    <td width="50px">
                        <asp:HiddenField ID="HiddenFieldSecurityAnswer" runat="server" />
                    </td>
                    <td class="labelFont">
                        Last Review Date and Time</td>
                    <td width="10px">
                    </td>
                    <td nowrap>
                        <asp:Label ID="LabelReviewDateTime" runat="server" Width="300px" CssClass="Label"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="width:50%">
            <table id="Table1" runat="server" cellpadding="0" cellspacing="0" style="border-right: #dee7ef 3px solid;
                border-top: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-bottom: #dee7ef 3px solid;
                width:100%; height: 200px; overflow-x:hidden; overflow-y:scroll">
                <tr>
                    <td valign="top" height="440px">
                        <!--<iframe id="IFrameDocuments" width="100%" height="100%"></iframe>!-->
                        <div id="divReportViewer" runat="server" style="width:980px;overflow-x:scroll; overflow-y:scroll;
                            height: 440px">
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <table width="100%" border="0">
                <tr>
                    <td class="labelFont">
                        Security Question</td>
                    <td width="10px">
                        &nbsp;
                    </td>
                    <td>
                        <asp:Label ID="LabelSecurityQuestion" Width="300px" runat="server" CssClass="Label"></asp:Label>
                    </td>
                    <td class="labelFont">
                        Answer</td>
                    <td width="10px">
                    </td>
                    <td>
                        <asp:TextBox ID="TextBoxAnswer" runat="server" Width="300px" TextMode="Password"></asp:TextBox></td>
                    <td>
                        <%--<input type="button" id="ButtonApprove" class="ButtonWeb" value="Approve" style="width: 80px;
                            height: 25px" onclick="approvePrescription();" />--%>
                        <asp:Button ID="ButtonApprove" runat="server" Text="Approve" OnClientClick="return Validate();" CssClass="btnimgexsmall" OnClick="ButtonApprove_Click" /></td>
                    <td>
                        <input type="button" id="ButtonClose" value="Close" class="btnimgexsmall" width="79px"
                            onclick="OpenStartPage();return false;" style="width: 80px; height: 25px" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<asp:HiddenField ID="HiddenSecurityAnswer" runat="server" />
<asp:HiddenField ID="HiddenFieldFirstChance" runat="server" />
<asp:HiddenField ID="HiddenFieldSecondChance" runat="server" />
