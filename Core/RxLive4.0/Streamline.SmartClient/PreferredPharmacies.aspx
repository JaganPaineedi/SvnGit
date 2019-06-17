<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PreferredPharmacies.aspx.cs"
    Inherits="PreferredPharmacies" EnableViewState="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head2" runat="server">
    <base target="_self" />
    <title>Client Search</title>
    <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javascript" src="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" type="text/javascript"></script>
    
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript">

        function fnHideParentDiv1() {

            try {
                var objdvProgress = document.getElementById('dvProgress');
                if (objdvProgress != null)
                    objdvProgress.style.display = 'none';
                } catch(Exception) {
                alert(Exception.message);
                ShowError(Exception.description, true);
            }

        }


        function fnShowTemp() {

            try {
                fnShowParentDiv("Processing...", 150, 25);
                } catch(Exception) {
                ShowError(Exception.description, true);
            }
        }

        function fnShowParentDiv(msgText, progMsgLeft, progMsgTop) {

            try {

                var objdvProgress = document.getElementById("dvProgress");
                objdvProgress.style.left = progMsgLeft;
                objdvProgress.style.top = progMsgTop;
                objdvProgress.style.display = '';
                } catch(Exception) {
                ShowError(Exception.description, true);
            }

        }

        //Function added by Loveena in Ref to Task#92 on 26-Dec-2008 to refresh the view of patient overview information.

        function closeDivPharmacies(flag) {
            try {
                if (flag == true) {
                    parent.$("#DivSearch").css('display', 'none');
                    parent.window.RefreshPatientOverview(flag);
                    } else {
                    //Modified by Anuj on 5 March 2010 for task ref:2930(Medication Management)
                    if (document.getElementById('<%=HiddenFieldChangePharmacyDropDownValue.ClientID %>').value == "True") {
                        var datetime = new Date();
                        var answer = window.showModalDialog("YesNo.aspx?datetime=" + datetime.getMinutes() + datetime.getSeconds() + "&CalledFrom=PatientOverView", 'YesNo', 'menubar : no;status : no;resizable:no;dialogTop:350px;dialogWidth:423px; dialogHeight:178px;dialogLeft:300px,location:no; help: No;');
                        if (answer == undefined) {
                            } else if (answer == "N") {
                            parent.$("#DivSearch").css('display', 'none');
                            } else if (answer == "Y") {
                                __doPostBack('ButtonSave', '');
                        }
                        } else {
                        parent.$("#DivSearch").css('display', 'none');
                    }
                }
                } catch(Err) {
                alert("closeDiv" + Err.message);
            }

        }

        function SetPreferredPharmacy1Filter() {
            try {
                document.getElementById('<%=HiddenPreferredPharmacy1.ClientID %>').value = document.getElementById('<%=DropDownListPharmacy1.ClientID %>').value;
                document.getElementById('<%=HiddenFieldChangePharmacyDropDownValue.ClientID %>').value = "True";
                } catch(Exception) {
                ShowError(Exception.description, true);
            }
        }

        function SetPreferredPharmacy2Filter() {
            try {
                document.getElementById('<%=HiddenPreferredPharmacy2.ClientID %>').value = document.getElementById('<%=DropDownListPharmacy2.ClientID %>').value;
                document.getElementById('<%=HiddenFieldChangePharmacyDropDownValue.ClientID %>').value = "True";
                } catch(Exception) {
                ShowError(Exception.description, true);
            }
        }
        function SetPreferredPharmacy3Filter() {
            try {
                document.getElementById('<%=HiddenPreferredPharmacy3.ClientID %>').value = document.getElementById('<%=DropDownListPharmacy3.ClientID %>').value;
                document.getElementById('<%=HiddenFieldChangePharmacyDropDownValue.ClientID %>').value = "True";
            } catch(Exception) {
                ShowError(Exception.description, true);
            }
        }

        //  added By Priya dated 4th Feb 2010 To Open Pharmacy Serach Page for Preferred Prescriber
        //Ref: task 85 SDI Projects FY10 - Venture 

        function openPharmacySearchForPreferredPharmacy(imgname,DropDownValue1,DropDownValue2,DropDownValue3) {
            try {
                
                var getDropDownvalue1 = document.getElementById(DropDownValue1).value;
                var getDropDownvalue2 = document.getElementById(DropDownValue2).value;
                var getDropDownvalue3 = document.getElementById(DropDownValue3).value;
                parent.document.getElementById('HiddenPageName').value = 'PreferredPharmacies';
                
                var $divSearch = parent.$("#DivSearch1");
                $("#topborder1", $divSearch).text("Pharmacy");
                var $iFrameSearch = $('#iFrame1', $divSearch);
                $iFrameSearch.attr('src', 'PharmacySearch.aspx?img=' + imgname + '&DropDownvalue1=' + getDropDownvalue1 + '&DropDownvalue2=' + getDropDownvalue2+ '&DropDownvalue3=' + getDropDownvalue3);
                $iFrameSearch.css({ 'width': '850px', 'height': '510px' });
                var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
                left = left > 0 ? left : 10;
                var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
                top = top > 0 ? top : 10;
                $divSearch.css({ 'top': top, 'left': left });
                $divSearch.draggable();
                $divSearch.css('display', 'block');

                } catch(e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
            return false;
        }

        //added By Priya Ref: task 85 SDI Projects FY10 - Venture 

        function closeParentDiv() {
            try {

                var DivSearch = parent.parent.document.getElementById('DivSearch');
                DivSearch.style.display = 'none';
                } catch(e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }

        }
        
    </script>

</head>
<body enableviewstate="false" scroll="no" topmargin="0" onload="Javascript:EnablesDisable();window.history.forward(1);">
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
            <asp:ScriptReference Path="App_Themes/Includes/JS/ViewMedicationHistory.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/DatePopUp/ts_picker.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/calendar.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/TextBoxWrapper.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        </Scripts>
    </asp:ScriptManager>
    <div>
                <table style="height: 138px; width: 100%;">
            <tbody>
                <tr>
                    <td>
                                <table style="height: 76px; width: 70%;">
                            <tbody>
                                <tr>
                                    <td>
                                    </td>
                                    <td>
                                    </td>
                                    <td style="width: 370px">
                                        <table style="width: 100%" cellspacing="0" cellpadding="0" border="0">
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <%--<table cellspacing="0" cellpadding="0" width="100%" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="width: 3%; height: 2px" valign="top" align="left">
                                                                            <img style="visibility: hidden" id="ImgError" alt="" src="App_Themes/Includes/Images/error.gif" />
                                                                        </td>
                                                                        <td valign="top">
                                                                            <asp:Label ID="LabelError" runat="server" CssClass="redTextError"></asp:Label></td>
                                                                        <td>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>--%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                            <tbody>
                                                <tr>
                                                            <td style="height: 15px; width: 10%;" class="labelHeaderRow" valign="middle" nowrap>
                                                        Patient:
                                                    </td>
                                                            <td style="height: 15px; width: 20%;" class="Label" valign="middle" nowrap>
                                                        <asp:Label ID="LabelClientName" class="Label" runat="server"> </asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                            <td style="height: 15px; width: 10%;" class="labelHeaderRow" valign="middle" nowrap>
                                                        Date Of Birth:
                                                    </td>
                                                            <td style="height: 15px; width: 20%;" class="Label" valign="middle" nowrap>
                                                        <asp:Label ID="LabelClientDOB" Width="250px" class="Label" runat="server"> </asp:Label>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table style="width: 100%">
                            <tbody>
                                <tr style="height: 50px">
                                    <td style="width: 100px">
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px">
                                        <asp:HiddenField ID="HiddenPreferredPharmacy1" runat="server"></asp:HiddenField>
                                        <asp:HiddenField ID="HiddenFieldChangePharmacyDropDownValue" runat="server"></asp:HiddenField>
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="HiddenPreferredPharmacy2" runat="server"></asp:HiddenField>
                                    </td>
                                    <td>
                                        <asp:HiddenField ID="HiddenPreferredPharmacy3" runat="server"></asp:HiddenField>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    </td>
                                    <td style="height: 15px" class="labelHeaderRow" valign="middle" nowrap>
                                        Preferred Pharmacy 1
                                    </td>
                                </tr>
                                <tr>
                                            <td style="height: 24px; width: 100px;">
                                    </td>
                                    <td style="height: 24px">
                                        <asp:DropDownList ID="DropDownListPharmacy1" runat="server" CssClass="ddlist" Height="22px"
                                            Width="450px">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <%-- added By Priya dated 4th Feb 2010 Ref: task 85 SDI Projects FY10 - Venture --%>
                                        <asp:HiddenField ID="image1" runat="server" />
                                        <input type="image" id="ImageSearch1" onclick="openPharmacySearchForPreferredPharmacy('SearchImageFirst','<%=HiddenPreferredPharmacy1.ClientID %>','<%=HiddenPreferredPharmacy2.ClientID %>','<%=HiddenPreferredPharmacy3.ClientID %>');"
                                            src="App_Themes/Includes/Images/search_icon.gif" />
                                        <asp:HiddenField ID="HiddenFieldImage1" runat="server" />
                                    </td>
                                    <%-- added By Priya dated 4th Feb 2010 Ref: task 85 SDI Projects FY10 - Venture --%>
                                </tr>
                                <tr>
                                    <td style="width: 100px">
                                    </td>
                                    <td style="height: 15px" class="labelHeaderRow" valign="middle" nowrap="nowrap">
                                        Preferred Pharmacy 2
                                    </td>
                                    <td style="width: 226px">
                                    </td>
                                </tr>
                                <tr>
                                            <td style="height: 24px; width: 100px;">
                                    </td>
                                    <td style="height: 24px">
                                        <asp:DropDownList ID="DropDownListPharmacy2" runat="server" CssClass="ddlist" Height="21px"
                                            Width="450px">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <%-- added By Priya dated 4th Feb 2010 Ref: task 85 SDI Projects FY10 - Venture --%>
                                        <input type="image" id="ImageSearch2" onclick="openPharmacySearchForPreferredPharmacy('SearchImageSecond','<%=HiddenPreferredPharmacy1.ClientID %>','<%=HiddenPreferredPharmacy2.ClientID %>','<%=HiddenPreferredPharmacy3.ClientID %>');"
                                            src="App_Themes/Includes/Images/search_icon.gif" />
                                    </td>
                                    <%-- added By Priya dated 4th Feb 2010 Ref: task 85 SDI Projects FY10 - Venture --%>
                                </tr>
                                 <tr>
                                    <td style="width: 100px">
                                    </td>
                                    <td style="height: 15px" class="labelHeaderRow" valign="middle" nowrap="nowrap">
                                        Preferred Pharmacy 3
                                    </td>
                                    <td style="width: 226px">
                                    </td>
                                </tr>
                                  <tr>
                                            <td style="height: 24px; width: 100px;">
                                    </td>
                                    <td style="height: 24px">
                                        <asp:DropDownList ID="DropDownListPharmacy3" runat="server" CssClass="ddlist" Height="21px"
                                            Width="450px">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <input type="image" id="ImageSearch3" onclick="openPharmacySearchForPreferredPharmacy('SearchImageThird','<%=HiddenPreferredPharmacy1.ClientID %>','<%=HiddenPreferredPharmacy2.ClientID %>','<%=HiddenPreferredPharmacy3.ClientID %>');"
                                            src="App_Themes/Includes/Images/search_icon.gif" />
                                    </td>
                                </tr>
                                <tr style="height: 50px">
                                    <td style="width: 100px">
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center">
                        <asp:Button ID="ButtonSave" OnClick="ButtonSave_Click" runat="server" Text="Save"
                            CssClass="btnimgexsmall" Width="80px" Font-Size="11px"></asp:Button>
                        <asp:Button ID="btnClose" runat="server" CssClass="btnimgexsmall" OnClientClick="closeDivPharmacies(false); return false;"
                            EnableViewState="False" Text="Cancel" Width="80px" />
                        <asp:HiddenField ID="HiddenFieldPharmacyName" runat="server" />
                        <asp:HiddenField ID="HiddenFieldPharmacyId" runat="server" />
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    </form>

    <script type="text/javascript">        parent.fnHideParentDiv();</script>

</body>
</html>