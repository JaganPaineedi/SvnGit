<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PharmacyManagement.ascx.cs"
    Inherits="Streamline.SmartClient.UI.UserControls_PharmacyManagement" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>
<%@ Register TagPrefix="UI" TagName="PharmaciesList" Src="~/UserControls/PharmaciesList.ascx" %>
<style type="text/css">   
    .TextBox {
        margin-left: 77px;
    }
</style>
<asp:ScriptManagerProxy runat="server" ID="SMP1">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/UserPreferences.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<script language="javascript" type="text/javascript">

    function pageLoad() {
        PharmacyManagement.FillPharmacies();
    }

    var PharmacyManagement = {
        onRadioClickPharmacy: function (sender, e) {
            document.getElementById('HiddenFieldParentSelectedPharmacyId').value = e.PharmacyId;
            document.getElementById('buttonInsert').value = "Update";
            var LabelErrorMessage = document.getElementById('<%=this.ClientID+this.ClientIDSeparator%>LabelErrorMessage');
            var ImageError = document.getElementById('<%=this.ClientID+this.ClientIDSeparator%>ImageError');
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            RadioButtonParameters(e, ' ', '<%=TextBoxName.ClientID%>', '<%=TextBoxPhone.ClientID%>', '<%=TextBoxFax.ClientID%>', '<%=TextBoxEmail.ClientID%>', '<%=TextBoxCity.ClientID%>', '<%=TextBoxZip.ClientID%>', '<%=TextBoxSureScriptsIdentifier.ClientID%>', '<%=TextBoxAddress.ClientID%>', '<%=DropDownListState.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=CheckBoxPreferred.ClientID%>', '<%=TextBoxSpecialty.ClientID%>');
        },

        onDeleteClick: function (sender, e) {
            sessionStorage.setItem('e', JSON.stringify(e));        
            var answer = window.showModalDialog('YesNo.aspx?CalledFrom=PharmaciesList', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
            if (answer == 'Y') {
                if (e == undefined) {
                    var e = JSON.parse(sessionStorage.e);
                }
                try {
                    DeleteFromList(e);
                    PharmacyManagement.Clear_Controls();
                } catch (err) {
                }
            }
        },
        GetPharmaciesList: function (condition) {
            try {
                document.getElementById('<%=HiddenRadioButtonValue.ClientID%>').value = condition;
                GetAllPharmaciesList('<%=PanelPharmaciesList.ClientID%>', condition);
            } catch (ex) {
            }
        },
        Clear_Controls: function () {
            ClearControls('<%=TextBoxName.ClientID%>', '<%=TextBoxPhone.ClientID%>', '<%=TextBoxFax.ClientID%>', '<%=TextBoxCity.ClientID%>', '<%=TextBoxZip.ClientID%>', '<%=TextBoxSureScriptsIdentifier.ClientID%>', '<%=TextBoxAddress.ClientID%>', '<%=DropDownListState.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=CheckBoxPreferred.ClientID%>');
        },
        SetRadioButton: function () {
            PharmacyManagement.showInProgress();
            var e = new Object();
            e.PharmacyId = parent.document.getElementById('HiddenFieldPharmacyId').value;
            e.Active = parent.document.getElementById('HiddenFieldPharmacyActive').value;
            if (parent.document.getElementById('HiddenFieldCheckButtonStatus').value == 'S') {
                document.getElementById('buttonInsert').value = "Update";
                var radioButtonId = "Rb_" + document.getElementById('HiddenFieldParentSelectedPharmacyId').value;
                var chk = $("input[id$=" + radioButtonId + "]")[0];
                if (chk != undefined)
                    chk.checked = false;
            } else {
                document.getElementById('buttonInsert').value = "Update";
            }

            var checkBoxPreferred = '<%=CheckBoxPreferred.ClientID%>';
            document.getElementById(checkBoxPreferred).checked = true;
            var LabelErrorMessage = document.getElementById('<%=this.ClientID+this.ClientIDSeparator%>LabelErrorMessage');
            var ImageError = document.getElementById('<%=this.ClientID+this.ClientIDSeparator%>ImageError');
            LabelErrorMessage.innerText = '';
            ImageError.style.visibility = 'hidden';
            ImageError.style.display = 'none';
            RadioButtonParameters(e.PharmacyId, e.Active, '<%=TextBoxName.ClientID%>', '<%=TextBoxPhone.ClientID%>', '<%=TextBoxFax.ClientID%>', '<%=TextBoxEmail.ClientID%>', '<%=TextBoxCity.ClientID%>', '<%=TextBoxZip.ClientID%>', '<%=TextBoxSureScriptsIdentifier.ClientID%>', '<%=TextBoxAddress.ClientID%>', '<%=DropDownListState.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=CheckBoxPreferred.ClientID%>', '<%=TextBoxSpecialty.ClientID%>');
        },
        FillPharmacies: function () {
            GetPharmacyList('<%=PanelPharmaciesList.ClientID%>', 'PharmacyName Asc');
        },
        imposeMaxLength: function (Object, MaxLen) {
            if (Object.value.length >= MaxLen)
                Object.value = Object.value.substring(0, MaxLen);
        },
        Insert_Click: function () {
            try {
                if (PharmacyManagement.checkRequiredFields()) {
                    PharmacyManagement.showInProgress();
                    FillPharmacyRow('<%=TextBoxName.ClientID%>', '<%=TextBoxPhone.ClientID%>', '<%=TextBoxFax.ClientID%>', '<%=TextBoxEmail.ClientID%>', '<%=TextBoxAddress.ClientID%>', '<%=DropDownListState.ClientID%>', '<%=TextBoxCity.ClientID%>', '<%=TextBoxZip.ClientID%>', '<%=TextBoxSureScriptsIdentifier.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=CheckBoxPreferred.ClientID%>', '<%=HiddenRadioButtonValue.ClientID%>', '<%=PanelPharmaciesList.ClientID%>', '<%=RadioButtonAllPharmacies.ClientID%>', '<%=RadioButtonActivePharmacies.ClientID%>', '<%=TextBoxSpecialty.ClientID%>', 'buttonInsert');
                }
            } catch (ex) {
            }
        },

        Clear_Click: function () {
            ClearPharmacyRow('<%=TextBoxName.ClientID%>', '<%=TextBoxPhone.ClientID%>', '<%=TextBoxFax.ClientID%>', '<%=TextBoxEmail.ClientID%>', '<%=TextBoxAddress.ClientID%>', '<%=DropDownListState.ClientID%>', '<%=TextBoxCity.ClientID%>', '<%=TextBoxZip.ClientID%>', '<%=TextBoxSureScriptsIdentifier.ClientID%>', '<%=CheckBoxActive.ClientID%>', '<%=CheckBoxPreferred.ClientID%>', '<%=HiddenRadioButtonValue.ClientID%>', '<%=PanelPharmaciesList.ClientID%>', '<%=RadioButtonAllPharmacies.ClientID%>', '<%=RadioButtonActivePharmacies.ClientID%>', '<%=TextBoxSpecialty.ClientID%>', 'buttonInsert', 'buttonMerge');
        },

        Merge_Click: function () {
            try {
                document.getElementById('HiddenFieldCheckButtonStatus').value = 'M';
                openPharmacySearch();
            } catch (ex) {
            }
        },

        Search_Click: function () {
            try {
                document.getElementById('HiddenFieldCheckButtonStatus').value = 'S';
                openPharmacySearch('buttonSearch');
            } catch (ex) {
            }
        },

        checkRequiredFields: function () {
            try {
                var LabelErrorMessage = document.getElementById('<%=LabelErrorMessage.ClientID%>');
                var ImageError = document.getElementById('<%=ImageError.ClientID%>');
                LabelErrorMessage.innerText = '';
                ImageError.style.visibility = 'hidden';
                ImageError.style.display = 'none';
                if (document.getElementById('<%=TextBoxName.ClientID%>').value == '') {
                    ImageError.style.display = 'block';
                    ImageError.style.visibility = 'visible';
                    LabelErrorMessage.innerText = 'Please Enter Pharmacy Name';
                    return false;
                }

                if ($("input[id$=TextBoxFax]").val() == '') {
                    ImageError.style.display = 'block';
                    ImageError.style.visibility = 'visible';
                    LabelErrorMessage.innerText = 'Please Enter Fax Number';
                    return false;
                }

                var RegExPattern = new RegExp(/^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/);
                if ((document.getElementById('<%=TextBoxEmail.ClientID%>').value.match(RegExPattern)) || (document.getElementById('<%=TextBoxEmail.ClientID%>').value.replace(/^\s+|\s+$/g, "") == "")) {
                    return true;
                } else {
                    ImageError.style.display = 'block';
                    ImageError.style.visibility = 'visible';
                    LabelErrorMessage.innerText = 'Please enter valid email.';
                    $("[id$=TextBoxEmail]").focus();
                    return false;
                }
                LabelErrorMessage.innerText = '';
                ImageError.style.visibility = 'hidden';
                ImageError.style.display = 'none';
                return true;
            } catch (ex) {
            }
        },
        showInProgress: function () {
            var obj = document.getElementById("PharmacyManagement_dvProgress");
            if (obj) obj.style.display = '';
        },
        hideInProgress: function () {
            var obj = document.getElementById("PharmacyManagement_dvProgress");
            if (obj) obj.style.display = 'none';
        }
    }

    function closeDiv() {
        $("#DivSearchPharmacy").css('display', 'none');
    }
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<table id="TableMain" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td style="height: 38px">
            <table id="TableTitle" border="0" cellpadding="0" cellspacing="0" width="100.7%">
                <tr>                   
                    <td style="width: 60%" class="header">
                        <asp:Label ID="LabelSmartCareRx" runat="server" Visible="true" style ="color: white;" 
                            Text="© Streamline Healthcare Solutions | SmartCareRx"></asp:Label>
                    </td>
                    <td style="width: 40%; padding-right:0.7%;" align="right" class="header">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right" style="width: 50%">
                                    <asp:LinkButton ID="LinkButtonStartPage" Style="display: none; color:white;" Text="Start Page"
                                        runat="server" OnClientClick="redirectToStartPage();this.disabled=true;return false;"></asp:LinkButton>
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
                    <td colspan="2" style="height: 1pt; border-bottom: #5b0000 1px solid;"></td>
                </tr>
                <tr>
                     <td style="width: 30%">
                        <asp:Label ID="Label1" runat="server" Visible="true" CssClass="TittleBarBase" Text="Pharmacy Management"></asp:Label>
                    </td>

                    <td width="70%;" align="right" style="padding-right:0.7%;">

                         <asp:ImageButton ID="ButtonClose" runat="server" ToolTip="Close" OnClientClick="redirectToStartPage(); return false;" ImageUrl="~/App_Themes/Includes/Images/close_icon.gif" /> 
                    </td>
                </tr>
                 <tr>
            <td align="left" colspan="2">
                <img width="100%" height="1" alt="" src="App_Themes/Includes/Images/feather_ltr_red.gif" />
            </td>
        </tr>
            </table>
        </td>
    </tr>
</table>
<table id="TableGeneral" border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-left:8px;">
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td valign="middle" style="width: 16px">
                        <asp:Image ID="ImageError" runat="server" ImageUrl="~/App_Themes/Includes/Images/error.gif" Style="display: none;" />
                    </td>
                    <td valign="middle">
                        <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError" Height="18px"></asp:Label>
                    </td>
                </tr>
            </table>
            <UI:Heading ID="Heading1" runat="server" HeadingText="Details" />
        </td>
    </tr>
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>          
                                 <td>
                                    <asp:Label ID="LabelName" class="labelFont" runat="server" Text="Name"></asp:Label>
                                </td>                   
                                <td style="width:280px;">                                   
                                     <asp:TextBox ID="TextBoxName" runat="server" CssClass="TextBox" Width="280px" MaxLength="100"></asp:TextBox>                                    
                                </td>       
                                <td>
                                     <asp:CheckBox ID="CheckBoxActive" runat="server" Text="Active" Style="text-align: center" />
                                     <asp:CheckBox ID="CheckBoxPreferred" runat="server" Text="Preferred" Style="text-align: center" />
                                </td>
                                  <td>
                                    <asp:Label ID="LabelPhone" class="Label" runat="server" Text="Phone"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="TextBoxPhone" runat="server" CssClass="TextBox" Width="100px" MaxLength="50"></asp:TextBox>
                                </td>
                                 <td>
                                    <asp:Label ID="LabelFax" class="labelFont" runat="server" Text="Fax"></asp:Label>
                                </td>                      
                               <td>
                                    <asp:TextBox ID="TextBoxFax" runat="server" CssClass="TextBox" Width="80px" MaxLength="50"></asp:TextBox>
                                </td>
                                  <td>
                                    <asp:Label ID="LabelEmail" class="labelFont" runat="server" Text="Email Id"></asp:Label>
                                </td>
                                 <td>
                                    <asp:TextBox ID="TextBoxEmail" runat="server" CssClass="TextBox" Width="120px"></asp:TextBox>
                                </td>
                        </tr> 
                             <tr>
                                <td style="height: 5px;">                                     
                                </td>
                            </tr>             
                            <tr>          
                                 <td valign="middle" rowspan="2">
                                    <asp:Label ID="LabelAddress" class="labelFont" runat="server" Text="Address"></asp:Label>
                                </td>                  
                                <td rowspan="2">
                                    <asp:TextBox ID="TextBoxAddress" runat="server" EnableTheming="false"  CssClass="MultilineTextBox"
                                        TextMode="MultiLine" Width="280px" Height="31px" onBlur="return PharmacyManagement.imposeMaxLength(this, 100);"></asp:TextBox>
                                </td>                             
                                <td valign="middle" style="text-align:right; ">
                                    &nbsp;</td>                             
                                <td>
                                   <asp:Label ID="Label" runat="server" class="label" Text="City "></asp:Label>
                                </td>
                                <td valign="middle" style="text-align:left;">
                                    <asp:TextBox ID="TextBoxCity" runat="server" CssClass="TextBox" Width="120px" MaxLength="30"></asp:TextBox>
                                </td>                             
                                <td valign="middle">
                                    <asp:Label ID="Label3" class="labelFont" runat="server" Text="State "></asp:Label>
                                </td> 
                                <td valign="middle">
                                     <asp:DropDownList ID="DropDownListState" runat="server" Width="120px">
                                    </asp:DropDownList>
                                </td>                             
                                <td>
                                    <asp:Label ID="LabelZip" class="labelFont" runat="server" Text="Zip Code "></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="TextBoxZip" runat="server" CssClass="TextBox" Width="120px" MaxLength="12"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td valign="middle" style="text-align:right; ">
                                               &nbsp;</td>
                                 <td>
                                                <asp:Label ID="Label2" class="Label" runat="server" Text="Specialty" ></asp:Label>
                                            </td>
                                <td colspan="6">
                                    <table border="0" cellspacing="0" cellpadding="0" style="padding-top:5px;">
                                        <tr>
                                       
                                           
                                <td  style="text-align:left;" Width="250px">
                                     <asp:TextBox ID="TextBoxSpecialty" runat="server" CssClass="TextBox"
                                                    Width="250px" MaxLength="160"></asp:TextBox>
                                </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                               
                    <td>
                        <asp:Label ID="LabelSureScripts" class="labelFont" runat="server" Text="NCPDP Number"></asp:Label>
                    </td>
                    <td>
                                     <asp:TextBox ID="TextBoxSureScriptsIdentifier" runat="server" CssClass="TextBox"
                                                    Width="280px"></asp:TextBox>
                                </td>
                    <td align="right" valign="bottom" style="padding-right:5px;" colspan="7">
                        <input type="button" id="buttonMerge" class="btnimgexsmall" style="display: none" onclick="PharmacyManagement.Merge_Click()" disabled="disabled"
                            value="Merge" />
                        <input type="button" id="buttonSearch" class="btnimgexsmall" onclick="PharmacyManagement.Search_Click()"
                            value="Search..." />
                        <input type="button" id="buttonInsert" class="btnimgexsmall" onclick="PharmacyManagement.Insert_Click()"
                            value="Insert" />
                        <input type="button" id="buttonClear" class="btnimgexsmall" onclick="PharmacyManagement.Clear_Click()" value="Clear" />
                        <input type="hidden" id="HiddenFieldCheckButtonStatus" />
                        <input type="hidden" id="HiddenFieldSelectedPharmacyId" />
                        <%--Added By Priya Ref:task No:85--%>
                        <input type="hidden" id="HiddenFieldParentSelectedPharmacyId" />
                
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
               
</table>



<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td style="width: 50%">
           <input id="RadioButtonActivePharmacies" runat="server" style="visibility: hidden;"
                checked="true" type="radio" onclick="PharmacyManagement.GetPharmaciesList('Active');" />
                    <a style="visibility: hidden;" class="radiobtntext">Active Pharmacies Only</a>
            
            <input id="RadioButtonAllPharmacies" runat="server" style="visibility: hidden;"
                type="radio" onclick="PharmacyManagement.GetPharmaciesList('All');" /><a style="visibility: hidden;" class="radiobtntext">All Pharmacies</a>
            <input type="hidden" id="HiddenRadioButtonValue" runat="server" />
            <UI:Heading ID="Heading2" runat="server" HeadingText="Preferred Pharmacies"></UI:Heading>
        </td>
        <td style="width: 45%; text-align: right;">
            <div id="PharmacyManagement_dvProgress" style="display: none; right: inherit;" class="progress">
                <%--<font size="Medium" color="#1c5b94"><b><i>Processing...</i></b></font>
                <img src="App_Themes/Includes/Images/Progress.gif" title="Progress" />--%>
                <img src="App_Themes/Includes/Images/ajax-loader.gif" />
            </div>
        </td>
        <td style="width: 5%;">&nbsp;</td>
    </tr>
</table>
<%--<table style="border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; border-left: #dee7ef 3px solid; width: 80%; border-bottom: #dee7ef 3px solid; height: 300px;" cellspacing="0" cellpadding="0">
    <tbody>
        <tr>
            <td>
               
            </td>
        </tr>
    </tbody>
</table>--%>
            </td></tr></table>
           
<div id="DivSearchPharmacy" style="position: absolute; left: 100px; top: 0px; z-index: 990; display: none; background-color: white; border: black thin solid;">
    <table style="width: 100%;" cellpadding="0" cellspacing="0">
        <tr class="PopUpTitleBar">
            <td id="topborder" class="TitleBarText"></td>
            <td style="width: 20px;" align="right">
                <img id="ImgCross" onclick="closeDiv()" src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>' title="Close" alt="Close" /></td>
        </tr>
        <tr>
            <td colspan="2">
                <iframe id="iFramePharmacySearch" name="iFramePharmacySearch" frameborder="0" marginheight="0" marginwidth="0" scrolling="no"></iframe>
            </td>
        </tr>
    </table>
</div>
  <div id="DivPharmacyList" style="overflow-x: scroll; margin-left:8px; overflow-y: scroll; height: 360px; width: 100%; border: 3px solid rgb(222, 231, 239);">
                    <asp:Panel ID="PanelPharmaciesList" runat="server">
                    </asp:Panel>
                </div>