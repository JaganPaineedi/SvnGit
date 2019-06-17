<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserManagement.ascx.cs"
    Inherits="Streamline.SmartClient.UI.UserControls_UserManagement" %>

<script language="javascript" type="text/javascript">
    function OpenUserPreferences(StaffId) {
        fnShow();
        OpenUserPreferencesWithStaffId(StaffId);
    }
    function SetStaffIdForUserPreferenceIdToNull() {
        SetStaffIdForUserPreferenceToNull();
    }
    function fnScroll(header, content) {
        $(header).scrollLeft($(content).scrollLeft());
    }

</script>

<asp:ScriptManagerProxy runat="server" ID="SMPOD">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/UserPreferences.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>
<asp:HiddenField ID="HiddenFieldAscDescGridUserManagement" runat="server" Value="ASC" />



<div>
    <table id= "Header" width="100.7%" border="0" cellspacing="0" cellpadding="0">      
        <tr>
            <td colspan="7" style="height: 1pt; border-bottom: #5b0000 1px solid;"></td>
        </tr>
    </table>
</div>

<asp:HiddenField ID="HiddenField1" runat="server" Value="ASC" />
<table id="TableTitleBar" border="0" cellpadding="0" cellspacing="0" width="100.7%">
    <tr>
        <td align="left" style="width: 60%;" class="header">
                <asp:Label ID="LabelTitleBar" runat="server" Visible="true" style ="color: white;" 
                    Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
                
            </td>  
       
        <td style="width: 30%; padding-right:0.7%;" align="right" class="header">
             <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="right" style="width: 50%">
                        <asp:LinkButton ID="LinkButtonStartPage" Text="Start Page" runat="server" OnClientClick="redirectToStartPage();this.disabled=true;return false;" Style="display: none; color:white;"></asp:LinkButton>
                    </td>
                    <td align="right" style="width: 10%">
                        <%--<asp:LinkButton ID="LinkButtonLogout" Text="" runat="server" OnClick="LinkButtonLogout_Click"
                            Style="display: none"> <asp:Image ID="image_logoff" runat="server" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Style="border-width: 0px;" /></asp:LinkButton>--%>
                                     <asp:ImageButton ID="LinkButtonLogout" Style="display: none" ImageUrl="~/App_Themes/Includes/Images/logoff_icon.gif" Text="" runat="server" OnClick="LinkButtonLogout_Click" />

                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="height: 1pt; border-bottom: #5b0000 1px solid;"></td>
    </tr>
    <tr>
         <td id="topborder" style="width: 30%">
            <asp:Label ID="Label1" runat="server" Visible="true" CssClass="TittleBarBase" Text="User Management"></asp:Label>
        </td>
         <td align="right">
              <table class="toolbarbutton" border="0" cellpadding="0" cellspacing="0" width="10%">
                    <tr>
                        <td align="left">
                            <img width="7" height="24" alt="" src="App_Themes/Includes/Images/top_options_left_corner.gif">
                        </td>
                        <td class="top_options_bg">
                            <table>
                                <tr>
                                    
             <td>
                
                 <img id="ButtonNewUser" title="New User" onclick="SetStaffIdForUserPreferenceIdToNull()" style="cursor:pointer;" src="App_Themes/Includes/Images/new_icon.gif" />
               

             </td>
                                     <td style="background-color:#bdbdbd; width:1px;"></td>    
             <td>
             
                 <img id="ButtonClose" title="Close" onclick="redirectToStartPage()" style="cursor:pointer;" src="App_Themes/Includes/Images/close_icon.gif" /></td>
                   <td style="background-color:#bdbdbd; width:1px;"></td> 
                                     </tr>
                            </table>
                        </td>
                        <td>
                            <img width="7" height="24" alt="" src="App_Themes/Includes/Images/top_options_right_corner.gif">
                        </td>
                    </tr>
                    </table>
        </td>
    </tr>
     <tr>
            <td align="left" colspan="2">
                <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif" />
            </td>
        </tr>
</table>






<table width="100%" style="margin-left:8px;">
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="middle" style="width: 16px">
                        <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif"
                            Style="display: none;" />
                    </td>
                    <td valign="middle" style="padding-left: 3px">
                        <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError" Height="18px"
                            ></asp:Label>
                    </td>

                    <td valign="top" style="width: 16px">
                        <asp:Image ID="ImageSuccess" runat="server" ImageUrl="~/App_Themes/Includes/Images/Yes.png"
                            Style="display: none; vertical-align: middle" />
                    </td>
                    <td valign="bottom" style="padding-left: 3px">
                        <asp:Label ID="LabelSuccessMessage" runat="server" CssClass="greenTextSuccess" Height="18px"
                            Style="vertical-align: middle"></asp:Label>
                    </td>
                </tr>
            </table>

        </td>
    </tr>
    <tr>
        <td align="left">
            <table border="0">
                <tr>
                    <td class="Label">Password
                    </td>
                    <td style="padding-left: 5px">
                        <%--<input type="text" size="20" id="UserMangementPassword"  runat="server" />--%>
                        <asp:TextBox ID="UserMangementPassword" runat="server" CssClass="TextBox" Width="130px"
                            MaxLength="20" TextMode="Password"></asp:TextBox>
                    </td>
                    <td class="Label" style="padding-left: 25px">Enter Token #/OTP </td>
                    <td style="padding-left: 5px">
                        <%-- <input type="text" size="20" id="UserMangementOTP" runat="server" />--%>
                        <asp:TextBox ID="UserMangementOTP" runat="server" CssClass="TextBox" Width="130px"
                            MaxLength="20" type="number"></asp:TextBox>
                    </td>
                    <td style="width: 258px"></td>
                    <td>
                        <%--<input id="UserMangementEnableEPCS" type="button" value="Enable EPCS" onclick="EnableEPCS()"
                            class="ButtonWeb" style="width: 95px; height: 24px" />--%>

                        <input id="UserMangementEnableEPCS" type="button" value="Enable EPCS" onclick="EnableEPCS()"
                            class="btnimgsmall"/>
                    </td>
                    <td>
                        <input id="UserMangementDisableEPCS" type="button" value="Disable EPCS" onclick="DisableEPCS()"
                            class="btnimgsmall" />
                    </td>
                </tr>
            </table>
        </td>       
    </tr>
</table>


<table border="0" cellpadding="0" cellspacing="0" width="99%" style="margin-left:8px;">
    <tr>
        <td>
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
<table cellpadding="0" cellspacing="0" border="0" style="margin-left:8px; width:100%;">
    <tr>
        <td>
            <input id="RadioButtonActiveUsers" runat="server" 
                checked="true"
                type="radio" onclick="ChangeUserActiveUsermanagementListPage();" />
                <a class="radiobtntext">Active Users Only</a>
            </td>
        <td>
            <input id="RadioButtonAllUsers" runat="server" 
                type="radio"
                onclick="ChangeUserActiveUsermanagementListPage();" /><a class="radiobtntext">All
        Users</a>
              </td>
        <td>
            <input id="RadioButtonAllPrescribers" runat="server" 
                type="radio"
                onclick="ChangeUserActiveUsermanagementListPage();" /><a class="radiobtntext">
        All Prescribers</a>
              </td>
        <td>
            <input id="RadioButtonAllEPCSPrescribers" runat="server" 
                type="radio"
                onclick="ChangeUserActiveUsermanagementListPage();" /><a class="radiobtntext">
        All EPCS Prescribers</a>
              </td>
        <td>
             <input type="text" size="30" id="UserMangementSearchText" placeholder="Enter first and/or last name" class="Textbox" style="margin-left:10px;"/>
        </td>
        <td>
           <button id="UserMangementSearchTextButton" class="btnimgexsmall" onclick="SearchUserManagementListPage(this);return false;">Search</button>             
              </td>
        <td>            
           <button id="UserMangementResetButton" class="btnimgexsmall"  onclick="SearchUserManagementListPage(this);return false;">Reset</button>
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

                                      
<asp:Panel ID="PanelUserManagement" runat="server" style="margin-left:8px;">
    <!-- ###StartUserManagement### -->
    <table id="Table1" align="left" border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td align="left">
                <div id="DivGridContainer">
                    <table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
                        <tr>
                            <td>
                                <asp:ListView runat="server" ID="lvUserList" OnLayoutCreated="LayoutCreated" >
                                    <LayoutTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0" style="width:100%;" class="ListPageContainer">
                                            <tr>
                                                <td>
                                                    <asp:Panel runat="server" ID="divHeader" Style="margin-right: 18px; height: auto;" CssClass="ListPageHeader">
                                                        <table cellpadding="0" cellspacing="0" width="99%">
                                                            <tr>
                                                                <td width="3%"></td>
                                                                <td width="15%">
                                                                    <asp:Panel runat="server" ID="StaffName" SortId="StaffName">Staff Name</asp:Panel>
                                                                </td>
                                                                <td width="9%">
                                                                    <asp:Panel runat="server" ID="UserCode" SortId="UserCode" >User Name</asp:Panel>
                                                                </td>
                                                                <td width="7%">
                                                                    <asp:Panel runat="server" ID="Active" SortId="Active" >Active</asp:Panel>
                                                                </td>
                                                                <td width="9%">
                                                                    <asp:Panel runat="server" ID="Prescriber" SortId="Prescriber" >Prescriber</asp:Panel>
                                                                </td>
                                                                <td width="14%">
                                                                    <asp:Panel runat="server" ID="DeviceAuthenticated" SortId="DeviceAuthenticated" >Device Authenticated</asp:Panel>
                                                                </td>
                                                                <td width="10%">
                                                                    <asp:Panel runat="server" ID="EPCSEnabled" SortId="EPCSEnabled" >EPCS Enabled</asp:Panel>
                                                                </td>
                                                                <td width="18%">
                                                                    <asp:Panel runat="server" ID="EPCS" SortId="EPCS" >EPCS Permission</asp:Panel>
                                                                </td>
                                                                <td width="15%">
                                                                    <asp:Panel runat="server" ID="PhoneNumber" SortId="PhoneNumber" >Phone Number</asp:Panel>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top">
                                                    <asp:Panel ID="divListPageContent" runat="server" Style="height: 410px;"
                                                        CssClass="ListPageContent">
                                                        <table width="99%" cellspacing="0" cellpadding="0" id="UserList">
                                                            <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                                        </table>
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                        </table>
                                    </LayoutTemplate>
                                    <ItemTemplate>
                                        <tr class='<%# Container.DisplayIndex % 2 == 0 ? "" : "ListPageAltRow " %>ListPageHLRow' id='<%# "UserListRow_" + Eval("StaffId") %>'>
                                            <td width="3%">
                                                <%--<input type="checkbox" runat="server" id="KeyID_KeyId" keyid='<%#Eval("StaffId")%>' disabled='<%# Eval("Permission").ToString() == "N" ? true : false %>' onclick='<%# "javascript:CheckSelectedItem(this.id)"%>' />--%>
                                                <input type="checkbox" runat="server" id="KeyID_KeyId" keyid='<%#Eval("StaffId")%>' disabled='<%# Eval("EPCSPermission").ToString() == "N" ? true : false %>'/>
                                                <input type="hidden" id="hidden_KeyID_KeyId" value='<%#Eval("StaffId")%>' />
                                            </td>
                                            <td width="15%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("StaffName") + "\" onclick=\"OpenUserPreferences("+ Eval("StaffId") + ");\"><u>" + Eval("StaffName") + "</u></div>"%>
                                            </td>
                                            <td width="9%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("UserCode") + "\">" + Eval("UserCode") + "</div>"%>
                                            </td>
                                            <td width="7%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("Active") + "\">" + Eval("Active") + "</div>"%>
                                            </td>
                                            <td width="9%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("Prescriber") + "\">" + Eval("Prescriber") + "</div>"%>
                                            </td>
                                            
                                            <td width="14%">
                                 <%# "<div class=\"ellipsis\" Title=\"" + Eval("DeviceAuthenticated") + "\">" + Eval("DeviceAuthenticated") + "</div>"%>
                                            </td>
                                             <td width="10%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("EPCSEnabled") + "\">" + Eval("EPCSEnabled") + "</div>"%>
                                            </td>
                                            <td width="18%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("EPCS") + "\">" + Eval("EPCS") + "</div>"%>
                                            </td>
                                            <td width="15%">
                                                <%# "<div class=\"ellipsis\" Title=\"" + Eval("PhoneNumber") + "\">" + Eval("PhoneNumber") + "</div>"%>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <EmptyDataTemplate>
                                        <tr>
                                            <td colspan="5" style="text-align: center; color: red;">No Staff Records Found</td>
                                        </tr>
                                    </EmptyDataTemplate>
                                </asp:ListView>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    <!-- ###EndUserManagement### -->
</asp:Panel>
<script type="text/javascript">
    $("#UserMangementSearchText").keydown(function (event) {
        if (event.keyCode == 13) {
            $("#UserMangementSearchTextButton").click();
            return false;
        }
    });
</script>
