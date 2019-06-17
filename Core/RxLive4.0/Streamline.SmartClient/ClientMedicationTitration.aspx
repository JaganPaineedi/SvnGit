<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ClientMedicationTitration.aspx.cs"
    Inherits="ClientMedicationTitration" %>

<%@ OutputCache Location="None" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<script language="javascript" src="App_Themes/Includes/JS/showModalDialog.js" type="text/javascript"> </script>
 <script language="javascript" type="text/javascript">
    function FormatDateEntered(datein) {       
        var $datein = $(datein);
        if ($datein.val() == "") return "";
        var regExpressionDate = /([01]?[0-9])(\/?-?([01]?[0-9]{1,2}))(\/?-?([0-9]{2,4}))/;
        var dateMatch = $datein.val().match(regExpressionDate);
        if (dateMatch == null) {
            $datein.val("");
        } else {
            $datein.val(dateMatch[1] + '/' + dateMatch[3] + '/' + (dateMatch[5].length > 2 ? dateMatch[5] : '20' + dateMatch[5]));
            if (!isValidDate($datein)) $datein.val("");
        }
    }
    function isValidDate($dateIn) {
        var d = new Date($dateIn.val());
        if (Object.prototype.toString.call(d) !== "[object Date]") return false;
        var monthfield = $dateIn.val().split("/")[0];
        var dayfield = $dateIn.val().split("/")[1];
        var yearfield = $dateIn.val().split("/")[2];
        var dayobj = new Date(yearfield, monthfield - 1, dayfield);

        return !((dayobj.getMonth() + 1 != monthfield) || (dayobj.getDate() != dayfield) || (dayobj.getFullYear() != yearfield));
    }
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<body>
    <div id="dvProgress" style="display: none; left: 0; position: absolute; right: inherit; top: 47px; width: 224px" class="progress">
        <%--<font size="Medium" color="#1c5b94"><b><i>Communicating with Server...</i></b></font>
        <img src="App_Themes/Includes/Images/Progress.gif" title="Progress" />--%>
         <img src="App_Themes/Includes/Images/ajax-loader.gif" />
    </div>
</body>
</html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="head1" runat="server">
    <title>Titration Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1"
        type="text/javascript"> </script>

    <link href="App_Themes/Includes/JS/jscalendar/calendar-blue.css?rel=3_5_x_4_1" type="text/css"
        rel="stylesheet" />

    <script type="text/javascript">
        function capturekey(e) {
            var key = (typeof event != 'undefined') ? window.event.keyCode : e.keyCode;
            var focusControl = document.activeElement;
            if (focusControl != 'undefined') {
                if (key == 8 && focusControl.type != "textarea" && focusControl.type != "text") {
                    return false;
                }
            }
        }

        if (navigator.appName != "Mozilla") {
            document.onkeypress = capturekey;
        } else {
            document.addEventListener("keyup", capturekey, true);
        }

        //Function Added by Loveena on 4-March-2009 as ref to Task#2399 to get focused control in Mozilla

        function onElementFocused(e) {
            if (e && e.target)
                document.activeElement =
                    e.target == document ? null : e.target;
        }

        if (document.addEventListener)
            document.addEventListener("focus", onElementFocused, true);
    </script>

    <script language="javascript" type="text/javascript">

        function TitrationPageLoad() {

            InitializeComponents();
            var permit = 'Y';
            var TitrateMode = parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_HiddenTitrateMode').value;
            if (parent.document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxPermitChanges').checked == false) {
                permit = 'N';
            }
            document.getElementById('<%#HiddenPermit.ClientID %>').value = permit;

            if (TitrateMode == "Modify")
                ClientMedicationTitration.GetMedicationList('<%#PanelTitrationSteps.ClientID %>');
            if (document.getElementById('<%#TextBoxSpecialInstructions.ClientID %>') != "undefined") {
                document.getElementById('<%#TextBoxSpecialInstructions.ClientID %>').focus();
                }
            }

            function SetFocus() {
                try {
                    document.getElementById('<%#TextBoxSpecialInstructions.ClientID %>').focus();
                } catch (Exception) {
                    return false;
                }
            }

            /// <summary>
            /// For closing the Titration page on click of cross button.
            /// <Author>Author:Ankesh Bharti</Author>
            /// <CreatedDate>Date: 24-Dec-08</CreatedDate>
            /// </summary>   

            function closeTitrationPage() {
                try {
                    parent.$("#DivSearch1").css('display', 'none');
                } catch (Exception) {
                    ShowError(Exception.description, true);
                }
            }

            /// <summary>
            /// For Insert Click of StepBuilder in Titration page.
            /// <Author>Author:Ankesh Bharti</Author>
            /// <CreatedDate>Date: 27-Dec-08</CreatedDate>
            /// </summary>   

            function Insert_Click() {

                var varValidate = Validate();
                //document.getElementById('HiddenFieldOrderPageDirty').value=false;
                if (varValidate == true) {
                    document.getElementById('buttonInsert').value = "Add Step";
                    document.getElementById('buttonInsert').disabled = true;
                }
                return;
            }

            /// <summary>
            /// For validation of Titration page.
            /// <Author>Author:Ankesh Bharti</Author>
            /// <CreatedDate>Date: 27-Dec-08</CreatedDate>
            /// </summary>

            function Validate() {

                try {

                    var LabelErrorMessage = document.getElementById('LabelErrorMessage');
                    var ImageError = document.getElementById('ImageError');

                    LabelErrorMessage.innerText = '';
                    ImageError.style.visibility = 'hidden';
                    ImageError.style.display = 'none';

                    var LabelGridErrorMessage = document.getElementById('LabelGridErrorMessage');
                    var ImageGridError = document.getElementById('ImageGridError');

                    LabelGridErrorMessage.innerText = '';
                    ImageGridError.style.visibility = 'hidden';
                    ImageGridError.style.display = 'none';

                    if (document.getElementById('<%#CheckBoxDispense.ClientID %>').checked == true) {
                        document.getElementById('<%#HiddenMedicationTitrateDAW.ClientID %>').value = 'Y';
                    } else {
                        document.getElementById('<%#HiddenMedicationTitrateDAW.ClientID %>').value = 'N';
                    }
                    ClientMedicationTitration.FillTitrationRow('tableMedicationStepBuilder', '<%#TextBoxRefills.ClientID %>', '<%#DropDownTitrationSteps.ClientID %>', '<%#TextBoxStartDate.ClientID %>', '<%#TextBoxDays.ClientID %>', '<%#TextBoxEndDate.ClientID %>', 'LabelErrorMessage', 'ImageError', '<%#PanelTitrationSteps.ClientID %>', '<%#HiddenRowIdentifier.ClientID %>', 'LabelGridErrorMessage', 'ImageGridError', '<%#HiddenMedicationNameId.ClientID %>');
                } catch (Err) {
                    alert("Error:" + Err.message);
                }
            }

            /// <summary>
            /// For validation of Titration page.
            /// <Author>Author:Ankesh Bharti</Author>
            /// <CreatedDate>Date: 06-Jan-08</CreatedDate>
            /// </summary>  

            function Clear_Click() {
                ClientMedicationTitration.ClearDates('<%#TextBoxStartDate.ClientID %>', '<%#TextBoxEndDate.ClientID %>', '<%#TextBoxDays.ClientID %>');
                ClientMedicationTitration.ClearTable('tableMedicationStepBuilder');

                var LabelErrorMessage = document.getElementById('LabelErrorMessage');
                var ImageError = document.getElementById('ImageError');
                LabelErrorMessage.innerText = '';
                ImageError.style.visibility = 'hidden';
                ImageError.style.display = 'none';

                var LabelGridErrorMessage = document.getElementById('LabelGridErrorMessage');
                var ImageGridError = document.getElementById('ImageGridError');
                LabelGridErrorMessage.innerText = '';
                ImageGridError.style.visibility = 'hidden';
                ImageGridError.style.display = 'none';

                document.getElementById('buttonInsert').value = "Add Step";
                document.getElementById('DropDownTitrationSteps').disabled = false;
                ClientMedicationTitration.GetMedicationList('<%#PanelTitrationSteps.ClientID %>');
            }

            /// <summary>
            /// For validation of Titration page.
            /// <Author>Author:Ankesh Bharti</Author>
            /// <CreatedDate>Date: 06-Jan-08</CreatedDate>
            /// </summary>

        function onDeleteClick(sender, e) {
            sessionStorage.setItem('sender', JSON.stringify(sender));
            sessionStorage.setItem('e', JSON.stringify(e));
            sessionStorage.setItem('id', JSON.stringify('<%#PanelTitrationSteps.ClientID %>'));
            var answer = window.showModalDialog('YesNo.aspx?CalledFrom=TitrationTemplate', 'YesNo', 'menubar : no;status : no;resizable:no;dialogWidth:423px; dialogHeight:178px;dialogTop:200px;dialogLeft:300px,location:no; help: No;');
             if (answer == 'Y') {
                var sender = JSON.parse(sessionStorage.sender);
                var e = JSON.parse(sessionStorage.e);
                ClientMedicationTitration.DeleteFromList(e, '<%#PanelTitrationSteps.ClientID %>');
                Clear_Click(false);
            }
        }

            /// <summary>
            /// For validation of Titration page.
            /// <Author>Author:Ankesh Bharti</Author>
            /// <CreatedDate>Date: 06-Jan-08</CreatedDate>
            /// </summary>

            function onRadioClick(sender, e) {
                ClientMedicationTitration.ClearDates('<%#TextBoxStartDate.ClientID %>', '<%#TextBoxEndDate.ClientID %>', '<%#TextBoxDays.ClientID %>');
                ClientMedicationTitration.ClearTable('tableMedicationStepBuilder');

                var LabelErrorMessage = document.getElementById('LabelErrorMessage');
                var ImageError = document.getElementById('ImageError');
                LabelErrorMessage.innerText = '';
                ImageError.style.visibility = 'hidden';
                ImageError.style.display = 'none';

                var LabelGridErrorMessage = document.getElementById('LabelGridErrorMessage');
                var ImageGridError = document.getElementById('ImageGridError');
                LabelGridErrorMessage.innerText = '';
                ImageGridError.style.visibility = 'hidden';
                ImageGridError.style.display = 'none';

                ClientMedicationTitration.RadioButtonParameters(e, '<%#DropDownTitrationSteps.ClientID %>', '<%#TextBoxStartDate.ClientID %>', '<%#TextBoxDays.ClientID %>', '<%#TextBoxEndDate.ClientID %>', 'tableMedicationStepBuilder', '<%#HiddenRowIdentifier.ClientID %>', '<%#TextBoxRefills.ClientID %>');
                document.getElementById('buttonInsert').value = "Modify";
            }

            //---Written By Pradeep as per task#15 Nov 18,2009

            function OpenTitrationTemplate() {
                ShowTitrationTraperPage('<%#HiddenMedicationNameId.ClientID %>', '<%#TextBoxStartDate.ClientID %>');
            }
    </script>

</head>
<body onload=" Javascript:ClientMedicationTitration.GetTitrationValues(); "
    onkeydown=" Javascript:return capturekey(this); ">
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
                <%--End Added By Pradeep as per task#15--%>
            </Scripts>
        </asp:ScriptManager>
        
        
        <div style="height: 520px; overflow-y:auto;">
            <table border="0" cellpadding="0" cellspacing="5" style="height: 520px;">
                <tr>
                    <td>
                        <asp:Label ID="LabelClientInfoTitle" runat="server" Visible="true" CssClass="TittleBarBase"
                            Text="Titration / Taper – Patient: Smith, John (12345), DOB: 9/1/1965"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="background-color: #5b0000; height: 1pt;"></td>
                </tr>
                <tr>
                    <td colspan="10" valign="top" style="padding-left:8px;">
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="LEFT" style="width: 3%">
                                    <img id="ImageError" src="App_Themes/Includes/Images/error.gif" alt="" style="visibility: hidden" />&nbsp;
                                </td>
                                <td style="vertical-align:top;">
                                    <asp:Label ID="LabelErrorMessage" runat="server" CssClass="redTextError"></asp:Label>
                                </td>
                                <td></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="padding-left:8px;">
                         <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td >
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

                        <table style="width: 100%;" cellspacing="0" cellpadding="0">
                            <tr>
                                <td rowspan="1" class="labelFont">Drug
                                </td>
                                <td style="width: 4px">&nbsp;
                                </td>
                                <td style="width: 112px;">
                                    <asp:TextBox ID="TextBoxDrug" runat="server" Width="155px" Enabled="false"></asp:TextBox>
                                </td>
                                <td>&nbsp;
                                </td>
                                <!--<td colspan="3" style="width: 150px;" class="labelFont">
                                            Special Instructions</td>!-->
                                <td colspan="3" class="labelFont">Note
                                </td>
                                <td style="width: 4px"></td>
                                <td valign="top" rowspan="2">&nbsp;<asp:TextBox ID="TextBoxSpecialInstructions" EnableTheming="false" runat="server"
                                    Width="390px" TextMode="MultiLine" MaxLength="1000" CssClass="TextboxMultiline"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="9" style="height: 2px;"></td>
                            </tr>
                            <tr>
                                <td class="labelFont">Type
                                </td>
                                <td style="width: 4px"></td>
                                <td style="width: 112px;">
                                    <asp:RadioButton ID="RadioButtonTitration" runat="server" Text="Titration" GroupName="Type"
                                        CssClass="SumarryLabel" AutoPostBack="false" />
                                    <asp:RadioButton ID="RadioButtonTaper" runat="server" Text="Taper" GroupName="Type"
                                        CssClass="SumarryLabel" AutoPostBack="false" />
                                </td>
                                <td></td>
                                <td style="width: 10px;" class="labelFont">Refills
                                </td>
                                <td style="width: 4px"></td>
                                <td style="width: 40px;">
                                    <asp:TextBox ID="TextBoxRefills" runat="server" Width="32px" MaxLength="2" />
                                </td>
                                <td style="width: 4px"></td>
                                <td>
                                    <asp:CheckBox ID="CheckBoxDispense" runat="server" Text="Dispense as Written" CssClass="SumarryLabel" />
                                </td>
                            </tr>
                        </table>
<table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                            <tr style="height: 10px;">
                                <td>
                                    <table style="float:right;">
                                        <tr>
                                        <td> <input type="button" id="ButtonUseTemplate" class="btnimgsmall" value="Use Template"
                                        onclick=" OpenTitrationTemplate(); " />
                                    &nbsp;&nbsp;&nbsp;</td>
                                         <td><input type="button" id="ButtonSaveAsTemplate" runat="server" class="btnimgmedium" value="Save As Template" />
                                    &nbsp;&nbsp;&nbsp;</td>
                                            <td>
                                                  <table cellpadding="0" cellspacing="0" border="0">
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <div class="glow_lt">
                                                                                                            &nbsp;
                                                                                                        </div>
                                                                                                    </td>
                                                                                                    <td>

                                                                                                        <div class="glow_mid">
                                        <input type="button" id="ButtonClearSteps" value="Clear Steps and Start Over"
                                            onclick=" ClientMedicationTitration.ClearAllTitrationTemperList() " />
                                                                                                             </div>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <div class="glow_rt">
                                                                                                            &nbsp;
                                                                                                        </div>
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
             
              
                        </table>

                        
                        <UI:Heading ID="HeadingTitrationStepBuilder" runat="server" HeadingText="Titration Step Builder"></UI:Heading>
                        <table id="tblMain" runat="server" border="0" cellpadding="0" cellspacing="0" style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;">
                             <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                            <tr>
                                <td colspan="9">
                                    
 <table border="0" cellpadding="0" cellspacing="0" width="99%" style="margin-left:3px;">
                <tr>
                    <td >
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

                                    <table border="0" width="100%">
                                        <tr>
                                            <td style="height: 19px; width: 50px;" class="labelFont">Step
                                            </td>
                                            <td style="height: 19px; width: 28px;">
                                                <asp:DropDownList ID="DropDownTitrationSteps" runat="server" CssClass="ddlist" Width="40px">
                                                </asp:DropDownList>
                                            </td>
                                            <td style="height: 19px; width: 50px;" class="labelFont">Start
                                            </td>
                                            <td style="height: 19px; width: 120px;" nowrap>
                                                <asp:TextBox ID="TextBoxStartDate" runat="server" Width="70px" MaxLength="10" AutoCompleteType="Disabled" onchange="FormatDateEntered(this);"></asp:TextBox>
                                                <img id="ImgOrderDate" src="App_Themes/Includes/Images/calender_grey.gif" class="imgcal"  onclick="ClientMedicationTitration.CalShow(this, '<%=TextBoxStartDate.ClientID%>')"
                                                    onmouseover="ClientMedicationTitration.CalShow(this, '<%=TextBoxStartDate.ClientID%>')" alt="" />
                                            </td>
                                            <td style="height: 19px; width: 50px;" class="labelFont">Days
                                            </td>
                                            <td style="height: 19px; width: 35px;">
                                                <asp:TextBox ID="TextBoxDays" runat="server" Width="32px" MaxLength="4" />
                                            </td>
                                            <td style="height: 10px; width: 17px;"></td>
                                            <td style="height: 19px; width: 50px;" class="labelFont">End
                                            </td>
                                            <td style="height: 19px" nowrap>
                                                <asp:TextBox ID="TextBoxEndDate" runat="server" Width="70px" MaxLength="10" AutoCompleteType="Disabled" onchange="FormatDateEntered(this);"></asp:TextBox>
                                                <img id="Img1" src="App_Themes/Includes/Images/calender_grey.gif" class="imgcal"  onclick="ClientMedicationTitration.CalShow(this, '<%=TextBoxEndDate.ClientID%>')"
                                                    onmouseover="ClientMedicationTitration.CalShow(this, '<%=TextBoxEndDate.ClientID%>')" alt="" />
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
                        </table>


                                </td>
                            </tr>
                            <tr>
                                <td colspan="9">
                                    <table border="0" width="100%">
                                        <tr style="background-color: #dce5ea;">
                                            <td style="height: 21px">
                                                <div id="PlaceLabel" runat="server" visible="true" style="overflow: auto">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div id="PlaceHolder" runat="server" visible="true">
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <table width="100%">
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="LEFT" style="width: 3%">
                                                <img id="ImageGridError" src="App_Themes/Includes/Images/error.gif" alt="" style="visibility: hidden" />&nbsp;
                                            </td>
                                            <td style="vertical-align:top;">
                                                <asp:Label ID="LabelGridErrorMessage" runat="server" CssClass="redTextError"></asp:Label>
                                            </td>
                                            <td></td>
                                        </tr>
                                    </table>
                                </td>
                                <td align="right" valign="top" style="width: 50px;">
                                    <input type="button" id="buttonInsert" class="btnimgexsmall" onclick=" Insert_Click() "
                                        value="Add Step" style="width: 80px;" />
                                </td>
                                <td align="right" valign="top" style="width: 50px;">
                                    <input type="button" id="buttonClear" class="btnimgexsmall" onclick=" Clear_Click() " value="Clear"
                                         />
                                </td>
                            </tr>
                        </table>
                        <table style="width: 100%;">
                            <tbody valign="top">
                                <tr>
                                    <td style="width: 100%;">
                                        <UI:Heading ID="HeadingTitrationSteps" runat="server" HeadingText="Titration Steps"></UI:Heading>
                                        <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;" cellspacing="0" cellpadding="0">
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <div id="TitrationSteps" style="height: 100px; overflow: auto">
                                                            <asp:Panel ID="PanelTitrationSteps" runat="server" Height="100px" BackColor="White"
                                                                BorderStyle="None" BorderColor="Black">
                                                            </asp:Panel>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <table style="width: 100%;">
                            <tbody>
                                <tr>
                                    <td style="width: 100%;">
                                        <UI:Heading ID="HeadingTitrationSummary" runat="server" HeadingText="Titration Summary"></UI:Heading>
                                        <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td valign="top">
                                                    <table style="border-bottom: #FFFFFF 3px solid; border-left: #FFFFFF 3px solid; border-right: #FFFFFF 3px solid; border-top: #FFFFFF 3px solid; width: 100%;" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                            <td style="height: 21px; width: 110px;" class="labelFont">Number of Steps
                                                            </td>
                                                            <td style="width: 4px"></td>
                                                            <td style="height: 21px; width: 30px;">
                                                                <asp:Label ID="LabelNoOfSteps" runat="server" Width="19px" CssClass="SumarryLabel"></asp:Label>
                                                            </td>
                                                            <td style="height: 21px; width: 50px;" class="labelFont">Start Date
                                                            </td>
                                                            <td style="width: 4px"></td>
                                                            <td style="height: 21px; width: 70px;">
                                                                <asp:Label ID="LabelStartDate" runat="server" Text="" CssClass="SumarryLabel" Width="76px"></asp:Label>
                                                            </td>
                                                            <td style="height: 21px; width: 50px;" class="labelFont">End Date
                                                            </td>
                                                            <td style="width: 4px"></td>
                                                            <td style="height: 21px; width: 70px;">
                                                                <asp:Label ID="LabelEndDate" runat="server" Text="" CssClass="SumarryLabel" Width="76px"></asp:Label>
                                                            </td>
                                                            <td style="height: 21px; width: 300px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="10" style="height: 2px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="labelFont" style="height: 21px; width: 110px;">Order Summary
                                                            </td>
                                                            <td rowspan="2" colspan="9" style="height: 40px; width: 650px;">
                                                                <div style="overflow: auto; scrollbar-base-color: Transparent; width: 640px;">
                                                                    <asp:Panel ID="PanelOrderSummary" runat="server">
                                                                    </asp:Panel>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="10"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <table width="100%">
                            <tr>
                              
                                <td valign="top" style="text-align:center;">
                                    <input type="button" id="ButtonSave" class="btnimgsmall" onclick=" ClientMedicationTitration.UpdateTitration() "
                                        value="Save & Close" style="margin-right:6.5px;"/>
                                     <input type="button" id="ButtonCancel" class="btnimgexsmall" onclick=" ClientMedicationTitration.redirectToOrderPageClearSession() "
                                        value="Cancel" onblur=" SetFocus(); " />
                                </td>
                               
                            </tr>
                            <tr style="display:none;">
                                <td style="border-bottom: #5b0000 1px solid; height: 1pt; padding-left: 15px"></td>
                            </tr>
                            <tr style="display:none;">
                                <td align="center" class="footertextbold">
                                    <b>
                                        <asp:Label ID="LabelCopyrightInfo" runat="server"></asp:Label>
                                    </b>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input id="HiddenMedicationNameId" type="hidden" runat="server" />
                        <input id="HiddenTemplateOrderDate" type="hidden" value="12/20/2009" runat="server" />
                        <input id="HiddenMedicationName" type="hidden" runat="server" style="height: 9px; width: 14px;" />
                        <input id="HiddenRowIdentifier" type="hidden" runat="server" style="height: 9px; width: 14px;" />
                        <input id="HiddenOrderDateTobeSet" type="hidden" runat="server" style="height: 9px; width: 14px;" />
                        <input id="HiddenFieldOrderPageDirty" type="hidden" style="height: 9px; width: 14px;" />
                        <input id="HiddenFieldRowIndex" type="hidden" value="5" style="height: 9px; width: 14px;" />
                        <input id="HiddenFieldOrderDate" type="hidden" style="height: 9px; width: 14px;" runat="server" />
                        <input id="HiddenMedicationTitrateDAW" type="hidden" style="height: 9px; width: 14px;"
                            runat="server" />
                        <input id="HiddenPermit" type="hidden" style="height: 9px; width: 14px;" runat="server" />
                    </td>
                </tr>
            </table>
        </div>
   
    </form>
</body>

<script>
    Sys.Application.add_load(TitrationPageLoad)
</script>

</html>
