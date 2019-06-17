<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedicationLogin.ascx.cs" Inherits="UserControls_MedicationLogin" %>

<script language="javascript" type="text/javascript">
function OpenChangePassword(Password,UserName)
{
   alert('Your Password is expired. Please create a new password.');    
   document.getElementById('LoginUser_TextBoxChangePasswordUserName').innerText = UserName;   
   document.getElementById('LoginUser_DivLogin').style.display="none";
   document.getElementById('LoginUser_DivChangePassword').style.display="block";
   document.getElementById('LoginUser_TextBoxOldPassword').focus();
}
function Validates()
{
    ShowHideError("none", "");
    if (document.getElementById('LoginUser_TextBoxChangePasswordUserName').value == "")
        {
        ShowHideError("block", "Please enter User Name");
        return false;
        }
    if (document.getElementById('LoginUser_TextBoxOldPassword').value != document.getElementById('LoginUser_hiddenOldPassword').value)
        {
        ShowHideError("block", "Old password do not match");
        return false;
        }
    if (document.getElementById('LoginUser_TextBoxNewPassword').value == "")
        {
        ShowHideError("block", "Please enter New password");
        return false;
        }
    if (document.getElementById('LoginUser_TextBoxConfirmPassword').value == "")
        {
        ShowHideError("block", "Please enter Confirm Password");
        return false;
        }
    if (document.getElementById('LoginUser_TextBoxNewPassword').value == document.getElementById('LoginUser_hiddenOldPassword').value)
        {
        ShowHideError("block", "New password should be different than old password");
        return false;
        }
    if (document.getElementById('LoginUser_TextBoxNewPassword').value != document.getElementById('LoginUser_TextBoxConfirmPassword').value)
        {
        ShowHideError("block", "New password and Confirm Password do not match");
        return false;
        }
    return true;
}

function ShowHideError(show, msg)
        {        
        document.getElementById('LoginUser_lblError').style.display = show;
        document.getElementById('LoginUser_lblError').innerText = msg;        
       document.getElementById('LoginUser_DivLogin').style.display="none";
   document.getElementById('LoginUser_DivChangePassword').style.display="block";
        }
function update(elemValue) { }
function SetNewValues(newPassword) {
document.getElementById('LoginUser_TextBoxPassword').innerText = newPassword;
document.getElementById('LoginUser_TextBoxPassword').focus();
document.getElementById('LoginUser_DivLogin').style.display="block";
document.getElementById('LoginUser_DivChangePassword').style.display="none";
}
function CloseWindow(){
document.getElementById('LoginUser_DivLogin').style.display="block";
document.getElementById('LoginUser_DivChangePassword').style.display="none";
}
</script>
<div>
    <table width="520" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td style="width: 22px">
                <img src="App_Themes/Includes/Images/c1.jpg" alt="" width="21" height="18" /></td>
            <td valign="top">
                &nbsp;</td>
            <td align="right">
                <img src="App_Themes/Includes/Images/c2.jpg" width="21" alt="" height="18" /></td>
        </tr>
        <tr>
            <td style="background-image: url(App_Themes/Includes/Images/c3.jpg); width: 22px;
                border: 0px;">
                <img src="App_Themes/Includes/Images/clr.gif" alt="" width="1" height="1" /></td>
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <%--<tr>
                        <td style="height: 25px;" class="blacktextbold" align="left">
                            Streamline Healthcare Solutions, LLC
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 25px;" class="blacktextboldbig" align="left">
                            SmartCareRx
                        </td>
                    </tr>--%>
                    <tr>
                        <td>
                            <img src="<%=WebsiteSettings.BaseUrl+_logoPath %>" alt="Streamline Healthcare Solutions, L.L.C." /></td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:Label ID="LabelOrganizationName" runat="server" CssClass="redtextbold"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <div id="DivLogout" style="display: none" runat="server">
                                <table width="370" border="0" align="center" cellpadding="0" cellspacing="5" class="loginborder">
                                    <tr>
                                        <td style="height: 30px;">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" align="center">
                                            <asp:Label ID="LabelLogin" runat="server" CssClass="bluetextbold"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td style="height: 10px;">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" align="center">
                                            <asp:Button ID="ButtonLogout" runat="server" CssClass="inbuttons" Text="Logout" TabIndex="1"
                                                />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 30px;">
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div id="DivLogin" style="display: none;" runat="server">
                                <table width="370" border="0" align="center" cellpadding="0" cellspacing="5" class="loginborder">
                                    <tr>
                                        <td colspan="2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" align="left" colspan="2">
                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                <tr>
                                                    <td style="width: 80px;">&nbsp;
                                                    </td>
                                                    <td valign="middle" style="width: 20px;">
                                                        <div id="DivErrorImage" style="width: 20px;display:none" runat="server">
                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                <tr>
                                                                    <td valign="middle">
                                                                        <img src="App_Themes/Includes/Images/Flag/error.gif" alt="" />                                                                        
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </td>
                                                    <td valign="middle" style="width: 350px;" nowrap="nowrap" align="center">
                                                        <asp:Label ID="LabelError" runat="server" CssClass="redTextError"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>                                    
                                    <tr>
                                        <td valign="top" align="right" style="width: 120px;">
                                            <asp:Label ID="LabelUserName" runat="server" CssClass="bluetextbold">Username</asp:Label>
                                        </td>
                                        <td valign="top" align="left" style="width: 240px;">
                                            <asp:TextBox ID="TextBoxUsername" runat="server" CssClass="txtbx1" Width="160" TabIndex="1"
                                                MaxLength="30"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:Label ID="LabelPassword" runat="server" CssClass="bluetextbold">Password</asp:Label></td>
                                        <td align="left">
                                            <asp:TextBox ID="TextBoxPassword" runat="server" CssClass="txtbx1" Width="160" TabIndex="2"
                                                MaxLength="50" TextMode="Password"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="height: 10px;">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;</td>
                                        <td align="left">
                                            <asp:Button ID="ButtonLogon" runat="server" CssClass="inbuttons" Text="Login" TabIndex="3"
                                                OnClick="ButtonLogon_Click" Width="70" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:PlaceHolder ID="PlaceHolderScript" runat="server"></asp:PlaceHolder>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            &nbsp;</td>
                                    </tr>
                                </table>
                            </div>
                            <div id="DivChangePassword" runat="server" style="display:none">
                            <table width="370" border="0" align="center" cellpadding="0" cellspacing="5" class="loginborder">
                                <tr>
                                    <td colspan="2">
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" align="left" colspan="2">
                                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 80px;">
                                                    &nbsp;
                                                </td>
                                                <td valign="middle" style="width: 20px;">
                                                    <div id="Div1" style="width: 20px;display:none" runat="server">
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td valign="middle">
                                                                    <img src="App_Themes/Includes/Images/Flag/error.gif" alt="" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                                <td valign="middle" style="width: 350px;" nowrap="nowrap">
                                                    &nbsp;<asp:Label ID="lblError" runat="server" CssClass="redTextError" style="display:none"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" align="left" style="width: 120px;">
                            <asp:Label ID="Label1"  runat="server" Text="User Name" CssClass="bluetextbold" Width="122px"></asp:Label></td>
                                    <td valign="top" align="left" style="width: 240px;">
                                        <asp:TextBox ID="TextBoxChangePasswordUserName" CssClass="txtbx1" runat="server" Width="155px"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td align="left">
                            <asp:Label ID="LabelOldPassword" runat="server" CssClass="bluetextbold" Text="Old Password" Width="121px"></asp:Label></td>
                                    <td align="left">
                                        <asp:TextBox ID="TextBoxOldPassword" runat="server" CssClass="txtbx1" TextMode="Password" Width="155px"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td align="left">
                            <asp:Label ID="LabelNewPassword" runat="server" CssClass="bluetextbold" Text="New Password" Width="123px"></asp:Label></td>
                                    <td align="left">
                            <asp:TextBox ID="TextBoxNewPassword" runat="server" CssClass="txtbx1" TextMode="Password" Width="155px"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td align="left">
                            <asp:Label ID="LabelConfirmPassword" runat="server" CssClass="bluetextbold" Text="Confirm Password" Width="119px"></asp:Label></td>
                                    <td align="left">
                            <asp:TextBox ID="TextBoxConfirmPassword" runat="server" CssClass="txtbx1" TextMode="Password" Width="155px"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="height: 10px;">
                                    </td>
                                </tr>
                                <tr >
                                    <td align="right">
                                        <asp:Button ID="ButtonOk" CssClass="inbuttons" runat="server" Text="OK" OnClick="ButtonOk_Click" Width="59px"/></td>
                                    <td align="left">
                                        <asp:Button ID="ButtonCancel" CssClass="inbuttons" runat="server"  Text="Cancel" OnClick="ButtonCancel_Click" /></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        &nbsp;</td>
                                </tr>
                            </table>
    </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                    </tr>
                </table>
            </td>
            <td style="background-image: url(App_Themes/Includes/Images/c4.jpg); width: 21px;">
                <img src="App_Themes/Includes/Images/clr.gif" alt="" width="1" height="1" /></td>
        </tr>
        <tr>
            <td style="width: 22px">
                <img src="App_Themes/Includes/Images/c5.jpg" alt="" width="21" height="21" /></td>
            <td style="background-image: url(App_Themes/Includes/Images/c6.jpg);">
                &nbsp;</td>
            <td align="right">
                <img src="App_Themes/Includes/Images/c7.jpg" alt="" width="21" height="21" /></td>
        </tr>
    </table>
    <input type="hidden" id="hiddenOldPassword" runat="server" />
    <input type="hidden" id="hiddenCancelled" runat="server" />
</div>
<asp:HiddenField ID="HiddenFieldLoginCount" runat="server" />
<asp:HiddenField ID="HiddenFieldUseName" runat="server" />
