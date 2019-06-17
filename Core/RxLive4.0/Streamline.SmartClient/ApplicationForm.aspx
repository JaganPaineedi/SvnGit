<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" EnableViewStateMac="false"
         CodeFile="ApplicationForm.aspx.cs" Inherits="Streamline.SmartClient.ApplicationForm" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <%--<meta http-equiv="X-UA-Compatible" content="IE=8" />--%>
        <%--<meta http-equiv="X-UA-Compatible" content="IE=10" />--%>
        

        <meta http-equiv="X-UA-Compatible" content="IE=11" />
       <%-- <style>

            #DivSearch {
                top:10px !important;
            }

        </style>
--%>

    </head>
    <body>
        <div id="dvProgress1" style="left: 280px; position: absolute; top: 25px; white-space: nowrap; z-index: 999;">
          <%--  <font size="Medium" color="#1c5b94"><b><i><span id="spConnMsg">Communicating with Server...</span></i></b></font><img
                                                                                                                                 src="App_Themes/Includes/Images/Progress.gif" />
        --%>
             <img src="App_Themes/Includes/Images/ajax-loader.gif" />
        </div>
    </body>
</html>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head id="Head1" runat="server">
        <meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
        <meta http-equiv="PRAGMA" content="NO-CACHE" />
        <title>Streamline Medication Management</title>
        <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
        <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"> </script>
        <script language="javascript" src="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" type="text/javascript"> </script>
        <script language="javascript" src="App_Themes/Includes/JS/showModalDialog.js" type="text/javascript"> </script>
        <script language="JavaScript" src="App_Themes/Includes/JS/DatePopUp/ts_picker.js?rel=3_5_x_4_1" type="text/javascript"> </script>
        <script language="JavaScript" src="App_Themes/Includes/JS/jscalendar/calendar.js?rel=3_5_x_4_1"
                type="text/javascript"> </script>
        <script language="JavaScript" src="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1"
                type="text/javascript"> </script>
        <script language="JavaScript" src="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1"
                type="text/javascript"> </script>
        <script language="javascript" src="App_Themes/Includes/JS/JScriptMain.js?rel=3_5_x_4_1" type="text/javascript"> </script>
        <script language="javascript" src="App_Themes/Includes/JS/AllergySearch.js?rel=3_5_x_4_1" type="text/javascript"> </script>
        <link href="App_Themes/Includes/JS/jscalendar/calendar-blue.css?rel=3_5_x_4_1" type="text/css"
              rel="stylesheet" />
        <telerik:RadCodeBlock runat="server">

            <script language="javascript" type="text/javascript">

                //Added By Arjun K R
                var SelectedTextAreaObj = null;

                $(document).ready(function () {
                    var textarea = $('textarea');
                    if (textarea.length > 0) {
                        $(textarea).blur(function () {
                            SelectedTextAreaObj = $(this);
                        });
                    }
                    else {
                        SelectedTextAreaObj = null;
                    }
                });

                function closeDivUseKeyPhrase() {
                    $("#DivUseKeyPhrase").css('display', 'none');
                }

                function closeDivKeyAndAgencyPhrase() {
                    $("#DivKeyAndAgencyPhrase").css('display', 'none');
                }
                //Arjun K R Code Block End here

                function RefreshPage() {
                    document.getElementById('DivCoverAll').style.width = window.screen.width;
                    document.getElementById('DivCoverAll').style.height = window.screen.height;
                    redirectToManagementPage();
                }

                function RefreshSharedTables() {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/MedicationMgt.ascx";
                    document.getElementById("txtButtonValue").value = "";
                    <%= Page.GetPostBackEventReference(lnkRefresh) %>;
                }

                function OpenDocuments(Url) {
                    //To enable Print Button after Medical Staff Signs document.       
                    parent.document.getElementById('ButtonPrint').disabled = false;
                    document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').disabled = true;
                    document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').disabled = true;
                    document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').disabled = true;
                    document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').disabled = true;
                    document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked = true;
                    document.getElementById('IFrameDocuments').src = Url;
                }

                function CallBackPageLoad(ObjValue, Status, PageName) {

                }

                //Added by Loveena on 18-May-2009 to enter Signer Name if Signed by relation is selected.

                function Validate() {
                    var LabelErrorMessage = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelErrorMessage');
                    var ImageError = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ImageError');
                    LabelErrorMessage.innerText = "";
                    ImageError.style.display = 'none';
                    if (document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked == true && document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').value == "") {
                        ImageError.style.display = 'block';
                        ImageError.style.visibility = 'visible';
                        LabelErrorMessage.innerText = 'Please Enter Signer Name';
                        return false;
                    }
                    return true;
                }

                function UpdateDocuments() {
                    try {
                        if (Validate() == true) {
                            var _documentDatset = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDataSet').value;
                            var IsCustompage = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownConsentList').value;
                            var ObjValue = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDataSet').value;
                            var RadioButtonMedicalStaff = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked;
                            var RadioButtonPatient = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked;
                            var RadioButtonRelation = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked;
                            var TextBoxSignatureName = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').value;
                            var DropDownRelationShip = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').value;
                            if (RadioButtonRelation == true && DropDownRelationShip == 0) {
                                ShowDocumentsError('Please Select RelationShip', true);
                                return false;
                            }
                            if (IsCustompage > 0) {
                                if (document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked == true) {
                                    window.frames[0].InvokeMethod('Update', _documentDatset, 'ButtonClicked');
                                } else {
                                    UpdatePatientConsent(ObjValue, IsCustompage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip);
                                }
                            } else {
                                UpdatePatientConsent(ObjValue, IsCustompage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip);
                            }
                            return true;
                        }
                        return false;
                    } catch(ex) {
                        alert(ex);
                    }
                }

                function CallBackPageLoad(ObjValue, Status, PageName) {

                }

//Added by Loveena on 11Nov2009 to redirect to Printer Device Location in ref to Task#23  

                function redirectToPrinterDeviceLocationPage() {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/PrinterDevice.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonPrinterDevice")) %>;
                }

                function CallBackUpdate(ObjValue, Status, PageName) {
                    try {
                        if (Status == "True") {
                            document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_HiddenFieldDataSet').value = ObjValue;
                            var b1 = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ButtonUpdate');
                            var IsCustompage = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownConsentList').value;
                            var RadioButtonMedicalStaff = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked;
                            var RadioButtonPatient = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked;

                            var RadioButtonRelation = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked;
                            var TextBoxSignatureName = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_TextBoxSignatureName').value;

                            var DropDownRelationShip = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DropDownRelationShip').value;
                            UpdatePatientConsent(ObjValue, IsCustompage, RadioButtonMedicalStaff, RadioButtonPatient, RadioButtonRelation, TextBoxSignatureName, DropDownRelationShip);
                            return true;
                        } else {
                            if (ObjValue == "")
                                ShowDocumentsError("There is an Eroor while updating", true);
                            else
                                ShowDocumentsError(ObjValue, true);

                        }

                    } catch(ex) {
                        alert(ex);
                    }
                }

                function CallBackDeactivateDocument(ObjValue, Status) {
                    alert('CallBackDeactivateDocument');
                }


                function ShowDocumentsError(ErrorMessage, Show) {
                    try {


                        var LabelErrorMessage = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_LabelErrorMessage');
                        var DivErrorMessage = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_DivErrorMessage');
                        var ImageError = document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_ImageError');
                        if (Show == true) {
                            ImageError.style.display = 'block';
                            ImageError.style.visibility = 'visible';
                            LabelErrorMessage.innerText = ErrorMessage;
                        } else {
                            LabelErrorMessage.innerText = "";
                            ImageError.style.visibility = 'hidden';
                        }

                    } catch(ex) {
                        alert(ex);

                    }
                }

                function Updatemessagestatus(msg) {
                    try {
                        //debugger;
                        if (msg == "OTP") {
                            $('[id$=ImageSuccess]')[0].style.display = 'none';
                            $('[id$=LabelSuccessMessage]')[0].innerText = '';
                            $('[id$=Devicesuccessimage]')[0].style.display = 'none';
                            $('[id$=ImageError]')[0].style.display = 'block';
                            $('[id$=LabelErrorMessage]')[0].innerText = "One Time Password provided is incorrect";
                        }
                        else if (msg == "DEA") {
                            $('[id$=ImageSuccess]')[0].style.display = 'none';
                            $('[id$=LabelSuccessMessage]')[0].innerText = '';
                            $('[id$=ImageError]')[0].style.display = 'block';
                            $('[id$=Devicesuccessimage]')[0].style.display = 'none';
                            $('[id$=LabelErrorMessage]')[0].innerText = "DEA Number is required ";
                        }
                        else if (msg == "Success") {
                            $('[id$=ImageSuccess]')[0].style.display = 'block';
                            $('[id$=LabelSuccessMessage]')[0].innerText = 'Updated Successfully';
                            $('[id$=ImageError]')[0].style.display = 'none';
                            $('[id$=LabelErrorMessage]')[0].innerText = '';
                            $('[id$=Devicesuccessimage]')[0].style.display = 'block';

                        }

                    }
                    catch (err) {
                        return false;
                    }
                }


                //-----Written By Pradeep as per task#31

                function CheckUncheckPermitChangeCheckBox(Status) {

                    try {
                        var checkBox = document.getElementById('Control_ASP.usercontrols_clientmedicationorder_ascx_CheckBoxPermitChanges');
                        if (Status == 'Checked') {

                            checkBox.checked = true;
                        } else {

                            checkBox.checked = false;
                        }
                    } catch(ex) {
                    }
                }

            </script>

            <script type="text/javascript">

                window.onerror = function(message, url, lineNumber) {
                    //Since our framework only understand exception we have to convert it
                    var e = Error.create(message, { description: message, name: 'UnhandledError', lineNumber: lineNumber, url: url });
                    Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_UNHANDLED, e);

                    return true;
                }
            </script>

            <script type="text/javascript" language="javascript">

                function fnHideParentDiv() {

                    try {


                        var objdvProgress = document.getElementById('dvProgress1');
                        if (objdvProgress != null)
                            objdvProgress.style.display = 'none';
                    } catch(Exception) {
                        alert(Exception.message);
                        ShowError(Exception.description, true);
                    }

                }

                /// <summary>
                /// Author Sony John
                /// This event is handled when the application form is closed by either clicking on the  close button or using Alt+f4
                /// </summary>

                function beforeApplicationClose(e) {


                }


                function fnShowParentDiv(msgText, progMsgLeft, progMsgTop) {

                    try {

                        var objdvProgress = document.getElementById("dvProgress1");
                        objdvProgress.style.left = progMsgLeft;
                        objdvProgress.style.top = progMsgTop;
                        objdvProgress.style.display = '';
                    } catch(Exception) {
                        ShowError(Exception.description, true);
                    }

                }

                function fnShow() {

                    try {
                        fnShowParentDiv("Processing...", 280, 25);
                    } catch(Exception) {
                        ShowError(Exception.description, true);
                    }
                }

                function HeadingTabClick(parm1, parm2) {
                    // dummy function to handle Heading Click
                }

            </script>

        </telerik:RadCodeBlock>
    </head>
    <body bottommargin="1px" topmargin="1px" onbeforeunload="beforeApplicationClose(event)"
          leftmargin="1px" rightmargin="1px" onload=" window.history.forward(1); ">
        <form id="form1" runat="server">
            <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
                <Services>
                    <asp:ServiceReference Path="WebServices/CommonService.asmx" />
                    <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
                    <asp:ServiceReference Path="WebServices/ClientMedicationsNonOrder.asmx" InlineScript="true" />
                    <asp:ServiceReference Path="WebServices/UserPreferences.asmx" InlineScript="true" />
                    <asp:ServiceReference Path="WebServices/SureScriptRefillRequest.asmx" InlineScript="true" />
                </Services>
                <Scripts>
                    <asp:ScriptReference Path="App_Themes/Includes/JS/ExceptionManager.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                    <asp:ScriptReference Path="~/App_Themes/Includes/JS/TextBoxWrapper.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                    <asp:ScriptReference Path="~/App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                    <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationOrderDetails.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                    <asp:ScriptReference Path="~/App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                </Scripts>
            </asp:ScriptManager>
            <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">

                <script language="javascript">
                    Sys.Application.add_load(applicationLoad);

                    function applicationLoad(sender, args) {
                        try {

                            var mgr = Streamline.SmartClient.ExceptionManager.getInstance();
                            mgr.addListener(new Streamline.SmartClient.WebServiceTraceListener());

                            fnHideParentDiv(); //by Vikas Vyas 
                        } catch(e) {
                            alert(e.message);
                        }


                    }
                </script>

            </telerik:RadCodeBlock>
           <div id="DivHolderMain" runat="server" style="height: 580px; overflow-x:none; overflow-y: none; width: 99.4%;">
                <asp:Panel Style="background-color: White; border-bottom: white thin solid; border-left: white thin solid; border-right: white thin solid; border-top: white thin solid; top: 0px;"
                           ID="PlaceHolderMain" runat="server" Height="100%">
                </asp:Panel>
            </div>
            <table width="100%" style="margin-top: 30px; vertical-align: bottom; display:none;" id="SmartCareRxFooter">
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="border-bottom: #5b0000 1px solid; height: 1pt; padding-left: 15px">
                    </td>
                </tr>
                <tr>
                    <td class="CopyRightLineColor" style="height: 1px">
                    </td>
                </tr>
                <tr>
                    <td valign="bottom">
                        <table width="98%" border="0">
                            <tr>
                                <td class="footertextbold" align="center">
                                    <b>
                                        <asp:Label ID="LabelCopyrightInfo" runat="server"></asp:Label></b>
                                </td>
                                <td align="right" class="footertextbold" valign="top">
                                    <b>
                                        <asp:Label ID="LabelReleaseVersion" runat="server"></asp:Label></b>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="height: 1px">
                    </td>
                </tr>
            </table>
            <asp:LinkButton ID="lnkTest" runat="server" OnClick="lnkTest_Click" CssClass="hiddenFields">Medication</asp:LinkButton>
            <asp:LinkButton ID="LinkButtonClientMedicationOrder" runat="server" OnClick="lnkClientMedicationOrder_Click"
                            CssClass="hiddenFields">Patient Medication Order</asp:LinkButton>
            <asp:LinkButton ID="LinkButtonClientMedicationNonOrder" runat="server" OnClick="lnkClientMedicationNonOrder_Click"
                            CssClass="hiddenFields">Patient Medication Non Order</asp:LinkButton>
            <!--Added by Loveena in ref to Task#2498 - View History -It should not be a pop-up.!-->
            <asp:LinkButton ID="LinkButtonViewHistory" runat="server" OnClick="LinkButtonViewHistory_Click"
                            CssClass="hiddenFields">View History</asp:LinkButton>
            <!--Added by Pradeep in ref to Task#16(Venture) For testing Purpose!-->
            <asp:LinkButton ID="LinkButtonPatientConsent" runat="server" OnClick="LinkButtonPatientConsentHistory_Click"
                            CssClass="hiddenFields">View Patient Consent History</asp:LinkButton>
            <asp:LinkButton ID="LinkButton1" runat="server" OnClick="LinkButton1_Click" CssClass="hiddenFields">Test</asp:LinkButton>
            <asp:LinkButton ID="lnkPrescribe" runat="server" OnClick="Prescribe_Click" CssClass="hiddenFields">Prescribe</asp:LinkButton>
            <asp:LinkButton ID="LinkButtonUserManagementClose" runat="server" OnClick="LinkButtonUserManagementClose_Click"
                            CssClass="hiddenFields">User Management Close</asp:LinkButton>
            <asp:LinkButton ID="LinkButtonUserManagement" runat="server" OnClick="LinkButtonUserManagement_Click"
                            CssClass="hiddenFields">User Management</asp:LinkButton>
            <asp:LinkButton ID="LinkButtonUserPreferences" runat="server" OnClick="LinkButtonUserPreferences_Click"
                            CssClass="hiddenFields">User Preferences</asp:LinkButton>
            <asp:LinkButton ID="LinkButtonPharmacyManagement" runat="server" OnClick="LinkButtonPharmacyManagement_Click"
                            CssClass="hiddenFields">Pharmacy Management</asp:LinkButton>
            <asp:LinkButton ID="LinkButtonverbalOrder" runat="server" OnClick="LinkButtonverbalOrder_Click"
                            CssClass="hiddenFields">Verbal Orders</asp:LinkButton>
            <asp:LinkButton ID="LinkButtonPrinterDevice" runat="server" OnClick="LinkButtonPrinterDevice_Click"
                            CssClass="hiddenFields">Printer Device Location</asp:LinkButton>
            <!--Added by chandan for task #2604 -->
            <asp:LinkButton ID="LinkButtonPrescriptionReview" runat="server" OnClick="LinkButtonPrescriptionReview_Click"
                            CssClass="hiddenFields">Prescription Review</asp:LinkButton>
            <div id="DivSearch" style="background-color: white; border: black thin solid; display: none; left: 100px; position: absolute; top: 0px; z-index: 990;">
                <table style="width: 100%;" cellpadding="0" cellspacing="0">
                    <tr class="PopUpTitleBar">
                        <td id="topborder" class="TitleBarText"></td>
                        <td style="width: 20px;" align="right"><img id="ImgCross" onclick=" closeDiv() " src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>' title="Close" alt="Close" /></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <iframe id="iFrameSearch" name="iFrameSearch" frameborder="0" marginheight="0" marginwidth="0" scrolling="no"></iframe>    
                        </td>
                    </tr>
                </table>
            </div>
            <div id="DivSearch1" style="background-color: white; border: black thin solid; display: none; left: 100px; position: absolute; top: 0px; z-index: 990;">
                <table style="width: 100%;" cellpadding="0" cellspacing="0">
                    <tr class="PopUpTitleBar">
                        <td id="topborder1" class="TitleBarText"></td>
                        <td style="width: 20px;" align="right"><img id="Img1" onclick=" closeDiv1() " src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>' title="Close" alt="Close" /></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <iframe id="iFrame1" name="iFrame1" frameborder="0" marginheight="0" marginwidth="0" scrolling="no"></iframe>    
                        </td>
                    </tr>
                </table>
            </div>
            <div id="DivHealthMaintenanceAlertPopUp" style="background-color: white; border: black thin solid; display: none; left: 100px; position: absolute; top: 0px; z-index: 990;">
                <table style="width: 100%;" cellpadding="0" cellspacing="0">
                    <tr class="PopUpTitleBar">
                        <td id="topborder2" class="TitleBarText"></td>
                        <td style="width: 20px;" align="right"><img id="Img2" onclick="closeDivAlert();" src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>' title="Close" alt="Close" /></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <iframe id="iFrameAlertPopup" name="iFrameAlertPopup" frameborder="0" marginheight="0" marginwidth="0" scrolling="no"></iframe>    
                        </td>
                    </tr>
                </table>
            </div>
            <div id="DivHealthSearch" style="display: none; left: 100px; position: absolute; top: 0px; z-index: 990;">
                <iframe id="iFrameHealthSearch" name="iFrameSearch" style="background-color: White; border-bottom: black thin solid; border-left: black thin solid; border-right: black thin solid; border-top: black thin solid; height: 340px; left: 600px; position: absolute; top: 0px; width: 225px;"
                        frameborder="0" marginheight="0" marginwidth="0" scrolling="no"></iframe>
            </div>
                <%-- Added By Arjun kr--%>
        <div id="DivUseKeyPhrase" style="background-color: white; border: black thin solid; display: none; left: 5px; position: absolute; top: 0px; z-index: 990;">
            <table style="width: 100%;" cellpadding="0" cellspacing="0">
                <tr class="PopUpTitleBar">
                    <td id="topborderUseKeyPhrase" class="TitleBarText"></td>
                    <td style="width: 20px;" align="right">
                        <img id="Img3" onclick="closeDivUseKeyPhrase() " src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>' title="Close" alt="Close" /></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <%--<iframe id="iFrameUseKeyPhrase" name="iFrameUseKeyPhrase" frameborder="0" marginheight="0" marginwidth="0" scrolling="auto" height="600px" width="200px"></iframe>--%>
                        <div id="myIframe">
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <div id="DivKeyAndAgencyPhrase" style="background-color: white; border: black thin solid; display: none; left: 5px; position: absolute; top: 0px; z-index: 990;">
            <table style="width: 100%;" cellpadding="0" cellspacing="0">
                <tr class="PopUpTitleBar">
                    <td id="topborderKeyAndAgencyPhrase" class="TitleBarText"></td>
                    <td style="width: 20px;" align="right">
                        <img id="Img4" onclick="closeDivKeyAndAgencyPhrase() " src='<%= Page.ResolveUrl("App_Themes/Includes/Images/cross.jpg") %>' title="Close" alt="Close" /></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <%--<iframe id="iFrameKeyAndAgencyPhrase" name="iFrameKeyAndAgencyPhrase" frameborder="0" marginheight="0" marginwidth="0" scrolling="auto" height="600px" width="200px"></iframe>--%>
                        <div id="KeyAndAgencyPhraseIframe">
                        </div>
                    </td>
                </tr>
            </table>
        </div>

<%--Arjun K R Code Block End Here--%>

            <asp:LinkButton ID="lnkRefresh" runat="server" CssClass="hiddenFields" OnClientClick=" return RefreshPage() "
                            OnClick="lnkRefresh_Click">Refresh</asp:LinkButton>
            <asp:LinkButton ID="lnkOrderDetails" runat="server" CssClass="hiddenFields" Style="display: none"
                            OnClick="lnkOrderDetails_Click">Order Details</asp:LinkButton>
            <asp:LinkButton ID="lnkPatientContent" runat="server" Style="display: none;" OnClick="lnkPatientContent_Click">Patient Content</asp:LinkButton>
            <asp:LinkButton ID="lnkLogin" runat="server" OnClick="lnkLogin_Click" CssClass="hiddenFields">Login</asp:LinkButton>
            <div id="DivCoverAll" style="display: block; left: 0px; position: absolute; top: 0px; z-index: 400;"
                 class="transparent">
                <div id="dvProgress" style="background-color: White; left:-500; position: absolute; right: inherit; top: -500px; width: 224px; z-index: 501;">
                    <font size="Medium" color="#1c5b94"><b><i>Refreshing Data...</i></b></font>
                    <img src="App_Themes/Includes/Images/Progress.gif" title="Progress" />
                </div>
            </div>
            <asp:LinkButton ID="lnkClientMedOrder" runat="server" OnClick="lnkClientMedOrder_Click"
                            CssClass="hiddenFields">Patient Medication Order</asp:LinkButton>
            <asp:LinkButton ID="lnkPatientContentDetail" runat="server" OnClick="lnkPatientContentDetail_Click"
                            CssClass="hiddenFields">PatientConsentDetail</asp:LinkButton>



            <asp:HiddenField ID="txtButtonValue" runat="server" />
            <%--Added By Pradeep as per task#3331 Start--%>
            <asp:HiddenField ID="HiddenFieldSureScriptClickedImage" runat="server" />
            <%--Added By Pradeep as per task#3331 End--%>
            <%--Start Added By Pradeep as per task#12--%>
            <asp:HiddenField ID="HiddenFieldConsentStatus" runat="server" />
            <%--End Added By Pradeep as per task#12--%>
            <%--Start Added By Pradeep as per task#2640--%>
            <asp:HiddenField ID="HiddenDefaultPrescribingQuantity" runat="server" />
            <%--End Added By Pradeep as per task#2640--%>
            <!--Code added by Loveena in ref to Task#3!-->
            <asp:HiddenField ID="HiddenFieldScriptId" runat="server" />
            <asp:HiddenField ID="HiddenFieldVerbal" runat="server" />
            <%--End Added By Anuj on 30 Nov,2009 as per task#18 SDI venture 10--%>
            <asp:HiddenField ID="HiddenFieldImageConsentClick" runat="server" />
            <asp:HiddenField ID="HiddenFieldImageClientmedicationConsentId" runat="server" />
            <asp:HiddenField ID="HiddenFieldClientmedicationIdForConsent" runat="server" />
            <asp:HiddenField ID="HiddenFieldImageClickDocumentVersionId" runat="server" />
            <asp:HiddenField ID="HiddenFieldCheckImageClick" runat="server" />
            <%--End Added By Anuj on 30 Nov,2009 as per task#18 SDI venture 10--%>

            <script>
                function redirectToManagementPage(PageCalledFrom) {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/MedicationMgt.ascx";
                    document.getElementById("txtButtonValue").value = "";
                    if (PageCalledFrom == 'Reconciliation') {
                        updatePageCalledFrom(PageCalledFrom);
                    }
                    <%= Page.GetPostBackEventReference(Page.FindControl("lnkTest"), "") %>;
                }

                //Added by Sony in ref to task 2377
                //Made changes by Pradeep as per task#12Venture10.0

                function redirectToOrderPage(buttonClicked, result) {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/ClientMedicationOrder.ascx";
                    document.getElementById("txtButtonValue").value = buttonClicked;
                    if (result == 0) {
                        document.getElementById("HiddenFieldConsentStatus").value = "NoConsentExist";
                    } else {
                        document.getElementById("HiddenFieldConsentStatus").value = "";
                    }
                    <%= Page.GetPostBackEventReference(Page.FindControl("lnkClientMedOrder")) %>;
                }

                //Added by Loveena in ref to Task# 2486

                function redirectToViewHistoryPage() {

                    ShowMedicationViewHistoryDiv();
                }

                function redirectToPatientContentPage(ImageClick, ImageClientMedicationConsentId, ClientmedicationId, ImageClickDocumentVersionId, CheckClick, control) {
                    //Code added by Loveena in ref to Task#2962 to clear all HiddenFields
                    document.getElementById("HiddenFieldImageConsentClick").value = "";
                    document.getElementById("HiddenFieldClientmedicationIdForConsent").value = "";
                    document.getElementById("HiddenFieldCheckImageClick").value = "";
                    //Code ends over here.  
                    //Added in ref to Task#2957
                    if (control == 'ViewConsentHistory') {
                        document.getElementById("HiddenPageName").value = 'ViewConsentHistory';
                    } else {
                        document.getElementById("HiddenPageName").value = "";
                    }
                    document.getElementById("HiddenControlPath").value = "~/UserControls/MadicationPatientContent.ascx";
                    //Added By Anuj on 30nov,2009 for task ref #18 SDI venture 10
                    if (ImageClick === undefined || ImageClick == "") {
                        document.getElementById("HiddenFieldImageConsentClick").value = "";
                        document.getElementById("HiddenFieldImageClientmedicationConsentId").value = "";
                    } else if (ImageClick == "Patient Consent") {
                        //condition added ny Loveena in ref to Task#2962
                        document.getElementById("HiddenFieldImageConsentClick").value = "Patient Consent";
                        document.getElementById("HiddenFieldClientmedicationIdForConsent").value = ClientmedicationId;
                    } else {
                        document.getElementById("HiddenFieldImageConsentClick").value = ImageClick;
                        document.getElementById("HiddenFieldImageClientmedicationConsentId").value = ImageClientMedicationConsentId;
                        document.getElementById("HiddenFieldClientmedicationIdForConsent").value = ClientmedicationId;
                    }
                    if (CheckClick != undefined && CheckClick != "" && CheckClick != '') {
                        document.getElementById("HiddenFieldCheckImageClick").value = CheckClick;
                    }
                    if (ImageClickDocumentVersionId != undefined && ImageClickDocumentVersionId != "" && ImageClickDocumentVersionId != '') {
                        document.getElementById("HiddenFieldImageClickDocumentVersionId").value = ImageClickDocumentVersionId;
                    }
                    //Ended over here
                    <%= Page.GetPostBackEventReference(Page.FindControl("lnkPatientContent")) %>;
                }

                function redirectToPrescribePage() {
                    //added By Priya Ref:task no:85
                    $("[id$=HiddenFieldGetAllPharmacy]").val("");
                    document.getElementById("HiddenControlPath").value = "~/UserControls/MedicationsPrescribe.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("lnkPrescribe")) %>;
                }

                //Added By Priya Ref:task No:2859

                function redirectToVerbalOrder(verbalOrderType) {
                    document.getElementById("HiddenPageName").value = "FromDashBoard";
                    document.getElementById("HiddenControlPath").value = "~/UserControls/VerbalOrdersReview.ascx";
                    document.getElementById("HiddenFieldVerbal").value = verbalOrderType;
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonverbalOrder")) %>;
                }

                function redirectToOrderDetailsPage(control) {
                    if (control == 'ViewHistory') {
                        document.getElementById("HiddenPageName").value = 'ViewHistory';
                    } else if (control == 'PatientMainPage') {
                        document.getElementById("HiddenPageName").value = 'PatientMainPage';
                    }
                    document.getElementById("HiddenControlPath").value = "~/UserControls/MedicationOrderDetails.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("lnkOrderDetails")) %>;
                }

                //Added by Loveena in ref to Task#2498 View History - It should not be a pop-up.

                function redirectToViewHistoryPageClearSession() {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/ViewHistory.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonViewHistory")) %>;
                }

                //Code Written By  Pradeep as per task#16

                function redirectToViewConsentHistoryPageClearSession() {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/PatientConsentHistory.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonPatientConsent")) %>;
                }

                //Added by Chandan 29Oct2009 redirect to PrescriptionReview page ref task#2604

                function redirectToReviewPrescriptions() {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/PrescriptionReview.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonPrescriptionReview")) %>;
                }

                //Added end by Chandan 29Oct2009 redirect to PrescriptionReview page ref task#2604
                //function redirectToOrderPageClearSession()
                //Modified in ref to Task#85

                function redirectToOrderPageClearSession(PageName) {

                    document.getElementById("HiddenControlPath").value = "~/UserControls/ClientMedicationOrder.ascx";
                    //Added in ref to Task#85
                    $("input[id*=HiddenFieldRedirectFrom]").val(PageName);
                    document.getElementById("txtButtonValue").value = "New Order";
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonClientMedicationOrder")) %>;
                }

                function redirectToNonOrderPageClearSession(title) {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/ClientMedicationNonOrder.ascx";
                    document.getElementById("txtButtonValue").value = title;
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonClientMedicationNonOrder")) %>;
                }

                function redirectToOrderDetailsPage(control) {
                    if (control == 'ViewHistory') {
                        document.getElementById("HiddenPageName").value = 'ViewHistory';
                    } else if (control == 'PatientMainPage') {
                        document.getElementById("HiddenPageName").value = 'PatientMainPage';
                    }
                    document.getElementById("HiddenControlPath").value = "~/UserControls/MedicationOrderDetails.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("lnkOrderDetails")) %>;
                }

//   //Added by Loveena on 26-March-2009 to redirect to StartPage

                function redirectToStartPage() {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/ClientList.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonUserManagementClose")) %>;                  
                }

                //Added by Loveena on 26-March-2009 to redirect to UserManagement

                function redirectToUserManagementPage() {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/UserManagement.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonUserManagement")) %>;
                }

                //Added by Loveena on 26-March-2009 to redirect to UserPreferences

                function redirectToUserPreferencesPage(control) {
                    if (control == 'ClientList') {
                        document.getElementById("HiddenPageName").value = 'ClientList';
                    } else {
                        document.getElementById("HiddenPageName").value = 'UserManagement';
                    }
                    document.getElementById("HiddenControlPath").value = "~/UserControls/UserPreferences.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonUserPreferences")) %>;
                }

                //Added by Loveena on 31-March-2009 to redirect to Pharmacy Management

                function redirectToPharmacyManagementPage() {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/PharmacyManagement.ascx";
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonPharmacyManagement")) %>;
                }

                // Added By mohit 12-Nov-2009 in ref to Task#3

                function ButtonVerbalOrderClick(scriptId, type) {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/VerbalOrdersReview.ascx";
                    document.getElementById("HiddenFieldScriptId").value = scriptId;
                    document.getElementById("HiddenFieldVerbal").value = type;
                    <%= Page.GetPostBackEventReference(Page.FindControl("LinkButtonverbalOrder")) %>;
                }

                function redirectToLoginPage() {

                    <%= Page.GetPostBackEventReference(Page.FindControl("lnkLogin")) %>;
                }

                function RefreshManagementPage() {
                    document.getElementById('DivCoverAll').style.width = window.screen.width;
                    document.getElementById('DivCoverAll').style.height = window.screen.height;
                    <%= Page.GetPostBackEventReference(LinkButtonRefreshMgt) %>;
                }

                //Added By Priya  Ref:Task No:2897

                function RefreshSharedTablesStartPage() {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/ClientList.ascx";
                    // document.getElementById("HiddenPageName").value = "FromDashBoard";
                    // document.getElementById("txtButtonValue").value="";
                    __doPostBack('lnkRefresh', '');
                }

                //Added with ref #3 to Patient Consent Detail Page
                //By Anuj Dated 30th December 2009

                function RedirectToPatientConsentDetailPage(PageCalledFrom) {
                    document.getElementById("HiddenControlPath").value = "~/UserControls/PatientConsentDetail.ascx";
                    document.getElementById("HiddenFieldPageCalledFrom").value = PageCalledFrom;
                    //document.getElementById("HiddenFieldImageClientmedicationConsentId").value=ImageClientMedicationConsentId;
                    <%= Page.GetPostBackEventReference(Page.FindControl("lnkPatientContentDetail")) %>;
                }

                function closeDiv1() {
                    $("#DivSearch1").css('display', 'none');
                }

                function closeDivAlert() {
                    $("#DivHealthMaintenanceAlertPopUp").css('display', 'none');
                }

                function updatePageCalledFrom(PageCalledFrom) {
                    $("#HiddenFieldPageCalledFrom").val(PageCalledFrom);
                }
                
            </script>

            <asp:LinkButton ID="LinkButtonRefreshMgt" runat="server" OnClientClick=" return RefreshManagementPage() "
                            OnClick="LinkButtonRefreshMgt_Click" CssClass="hiddenFields">RefreshMgt</asp:LinkButton>
            <%--<asp:HiddenField ID="HiddenControlPath" Value="~/UserControls/MedicationMgt.ascx"
            runat="server" />   --%>
            <asp:HiddenField ID="HiddenControlPath" Value="~/UserControls/MedicationList.ascx"
                             runat="server" />
            <asp:HiddenField ID="HiddenPageName" runat="server" />
            <asp:HiddenField ID="HiddenFieldRedirect" runat="server" />
            <asp:HiddenField ID="HiddenFieldPageCalledFrom" runat="server" />
            <%-- added By Priya Ref:task no:-2829--%>
            <asp:HiddenField ID="HiddenFieldComment" runat="server" />
            <asp:HiddenField ID="HiddenFieldPharmacyId" runat="server" />
            <asp:HiddenField ID="HiddenFieldChangeOrderPharmacyId" runat="server" />
            <asp:HiddenField ID="HiddenFieldRadioToFax" runat="server" />
            <asp:HiddenField ID="HiddenFieldExternalReferenceId" runat="server" />
            <asp:HiddenField ID="HiddenFieldRedirectFrom" runat="server" />
            <asp:HiddenField ID="HiddenFieldRefillSpecialCase" runat="server" />
            <%--Added By Pradeep as per task#3300 --%>
            <asp:HiddenField ID="HiddenFieldRefillPharmacyId" runat="server" />
            <asp:HiddenField ID="HiddenFieldRefillPharmacyName" runat="server" />
            <asp:HiddenField ID="HiddenFieldFullPharmacyName" runat="server" />
            <asp:HiddenField ID="HiddenFieldSureScriptRefillRequestId" runat="server" />
            <asp:HiddenField ID="HiddenFieldSureScriptChangeRequestId" runat="server" /> <%--Added By Pranay w.r.t MeaningFull use--%>
           
            <asp:HiddenField ID="HiddenFieldPharmacyNameAddress" runat="server" />
            <asp:HiddenField ID="HiddenFieldClickedImage" runat="server" />
            <!--Added by Loveena in ref to Task#2973 !-->
            <input type="hidden" id="HiddenFieldSelectedValue" />
            <asp:HiddenField ID="HiddenFieldGetAllPharmacy" runat="server" />
            <asp:HiddenField ID="HiddenFieldPharmacyFaxNo" runat="server" />
            <asp:HiddenField ID="HiddenFieldPharmacyActive" runat="server" />
            <!-- Added by Loveena in ref to Task#3208 :- 2.2 Location Selection Lost When Changing After Preview!-->
            <asp:HiddenField ID="HiddenFieldPrescribingLocation" runat="server" />
            <asp:HiddenField ID="HiddenFieldSureScriptIdentifier" runat="server" />
            <!-- Added by Priya in ref Ref:task No:3274 2.7 Surescripts Refill Requests for Schedule II-V Medications!-->
            <asp:HiddenField ID="HiddenFieldDrugCategory" runat="server" />
            <asp:HiddenField runat="server" ID="HiddenFieldSurescriptsRefillRequestMedicationId" />
        </form>

        <script type="text/javascript"> fnHideParentDiv(); </script>

    </body>
</html>