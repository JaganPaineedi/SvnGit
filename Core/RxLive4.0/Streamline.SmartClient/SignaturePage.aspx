<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SignaturePage.aspx.cs" Inherits="SignaturePage" %>

<%@ OutputCache Location="None" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script language="javaScript" src="App_Themes/Includes/JS/jquery.signaturepad.js" type="text/javascript"></script>
    <script language="javaScript" src="App_Themes/Includes/JS/SigWebSignaturePad.js" type="text/javascript"></script>

    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <link href="App_Themes/Includes/JS/jscalendar/calendar-blue.css?rel=3_5_x_4_1" type="text/css"
        rel="stylesheet" />

    <script language="javascript" type="text/javascript">
        var IsSigpadNotSigned = true;
        var IsSigWebInstalled;
        var SignaturePadValue;
        var UseSignaturePad = '<%=UseSignaturePad %>';
        var UseHTML5Signature = '<%=UseHTML5Signature %>';
        var InstallSigPadDriverPrompt = '<%=InstallSigPadDriverPrompt %>';
        var SignaturePadValue = '<%=StaffUseSignaturePad%>';

        var objCanvas = document.createElement("canvas")
        var objCanvasCheck = (objCanvas.getContext) ? true : false;


        function pageLoad() {
            if (IsSigWebInstalled != false && IsSigWebInstalled != true) {
                if (SigWebInstalled() == "Sigweb not installed") {
                    IsSigWebInstalled = false;
                } else {
                    IsSigWebInstalled = true;
                }
            }

            if (InstallSigPadDriverPrompt == "Y") {
                $("#SigPlus1").attr("classid", "clsid:69A40DA3-4D42-11D0-86B0-0000C025864A");
            }

           // OnSign();
        }

        function onRadioSignatureMouseTouchPadChange() {
            document.getElementById('<%=TextBoxPassword.ClientID%>').disabled = true;
            document.getElementById('<%=RadioPassword.ClientID%>').checked = false;
            document.getElementById('<%=TextBoxPassword.ClientID%>').value = "";
            document.getElementById('<%=CheckBoxSignedPaperDocument.ClientID%>').checked = false;
            ClearControls();
        }

        function onRadioPasswordChange() {
            if (document.getElementById('<%=RadioPassword.ClientID%>').checked == true) {
                document.getElementById('<%=TextBoxPassword.ClientID%>').disabled = false;
                document.getElementById('<%=TextBoxPassword.ClientID%>').value = "";
                document.getElementById('<%=RadioPassword.ClientID%>').disabled = false;
                document.getElementById('<%=RadioSignaturePad.ClientID%>').checked = false;
                document.getElementById('<%=CheckBoxSignedPaperDocument.ClientID%>').checked = false;
                var oCanvas = document.getElementById('canvasSignPad');
                oCanvas.width = oCanvas.width;
                oCanvas.style.visibility = 'hidden';
                document.getElementById('cnv').style.display = 'none';
                ClearControls();
            }
        }

        function onCheckBoxSignedPaperDocumentChange() {
            document.getElementById('<%=TextBoxPassword.ClientID%>').value = "";
            document.getElementById('<%=RadioPassword.ClientID%>').checked = false;
            document.getElementById('<%=RadioSignaturePad.ClientID%>').checked = false;
            document.getElementById('<%=RadioCanvasSignature.ClientID%>').checked = false;
            ClearControls();
        }

        function closeWindow() {
            try {
                var DivSearch = parent.document.getElementById('DivSearch');
                DivSearch.style.display = 'none';
                } catch(e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }

        }

        function loadCanvasSignaturePad() {
            var context, oCanvas, mouseIsPressed;

            //if (document.getElementById('ButtonSignBtnClient').value == 'Sign') {
            document.getElementById('canvasSignPad').className = '';
            document.getElementById('canvasSignPad').style.display = 'block';
            // Added below line by ponnin
            document.getElementById('cnv').style.display = 'none';

            document.getElementById('ButtonSignBtnClient').value == 'Sign';

            var _SigPlus1 = document.getElementById('SigPlus1');
            _SigPlus1.className = 'Hidden';
            _SigPlus1.style.display = 'none';
            _SigPlus1.TabletState = 0;


            document.getElementById('canvasSignPad').style.visibility = 'visible';

            oCanvas = document.getElementById('canvasSignPad'); //retrieve canvas from dom by id that we have assigned
        }

        var lines = [, , ];
        var offset = $(document.getElementById('canvasSignPad')).offset();

        function preDraw(event) {
            $.each(event.touches, function (i, touch) {
                var id = touch.identifier, colors = ["black", "black", "black", "black", "black", "black"], mycolor = colors[Math.floor(Math.random() * colors.length)];
                lines[id] = {
                    x: this.pageX - offset.left, y: this.pageY - offset.top, color: mycolor
                };
            });
            event.preventDefault();
        }
        function draw(event) {
            var e = event, hmm = {};
            $.each(event.touches, function (i, touch) {
                var id = touch.identifier, moveX = this.pageX - offset.left - lines[id].x, moveY = this.pageY - offset.top - lines[id].y;
                var ret = move(id, moveX, moveY);
                lines[id].x = ret.x;
                lines[id].y = ret.y;
            });
            event.preventDefault();
        }
        function move(i, changeX, changeY) {
            var oTouchCanvas, ctxt;
            oTouchCanvas = document.getElementById('canvasSignPad'); //retrieve canvas from dom by id that we have assigned
            ctxt = oTouchCanvas.getContext('2d'); //retrieve context

            ctxt.strokeStyle = lines[i].color;
            ctxt.beginPath(); ctxt.moveTo(lines[i].x, lines[i].y);
            ctxt.lineTo(lines[i].x + changeX, lines[i].y + changeY); ctxt.stroke();
            ctxt.closePath(); return { x: lines[i].x + changeX, y: lines[i].y + changeY };
        }

        function ClearControls() {
            document.getElementById('<%=TextBoxPassword.ClientID%>').value = "";
            if (document.getElementById('RadioCanvasSignature').checked) {
                $('.sigPad').signaturePad({ drawOnly: true });

                loadCanvasSignaturePad();
                var touchPadapi = $('.sigPad').signaturePad();
                touchPadapi.clearCanvas();
            }
            else if (document.getElementById('RadioSignaturePad').checked) {
                OnSign();
                document.getElementById('canvasSignPad').style.display = 'none';
            }
            // Added by ponnin For task #215 of Engineering Improvement Initiatives- NBL(I)
            if (IsSigWebInstalled && objCanvasCheck) {
                ClearTablet();
            } else {
                if (document.form1.SigPlus1.NumberOfTabletPoints > 0) {
                    document.form1.SigPlus1.InitSigPlus();
                    document.form1.SigPlus1.ClearSigWindow(1);
                    document.form1.SigPlus1.ClearTablet();
                }
                document.form1.SigPlus1.TabletState = 1;
            }
        }
    </script>

    <script type="text/javascript">
        function SignaturePadPageLoad() {
            if (UseHTML5Signature == 'Y' && objCanvasCheck) {
                $('#divCanvasSignature').show();
            } else {
                var oCanvas = document.getElementById('canvasSignPad');
                oCanvas.width = oCanvas.width;
            }
            ////////////////////////////////////
            if (UseSignaturePad == "N") {
                $('.checkbox_container').hide();
                $('#SignBlock').hide();
                document.getElementById('tdSignedPaperDocument').style.display = "none";
                document.getElementById('RadioPassword').style.display = "none";
                document.getElementById('RadioSignaturePad').style.display = "none";
                //if Signaturepad not used,then hide both Sigplus and Sigweb control.
                document.getElementById('SigPlus1').style.display = "none";
                document.getElementById('cnv').style.display = "none";
            }
            else {


                if (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonMedicalStaff').checked == true) {
                    document.getElementById('tdSignedPaperDocument').style.display = "none";
                    document.getElementById('RadioPassword').checked = true;
                    onRadioPasswordChange();

                    if (SignaturePadValue == "True") {
                        document.getElementById('RadioSignaturePad').disabled = true;
                    }

                }
                if (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonPatient').checked == true) {
                    document.getElementById('tdSignedPaperDocument').style.display = "block";
                    document.getElementById('<%=TextBoxPassword.ClientID%>').disabled = true;
                    document.getElementById('<%=RadioPassword.ClientID%>').checked = false;
                    document.getElementById('<%=RadioPassword.ClientID%>').disabled = true;
                    document.getElementById('<%=RadioSignaturePad.ClientID%>').checked = true;

                    if (IsSigWebInstalled != false && IsSigWebInstalled != true) {
                        if (SigWebInstalled() == "Sigweb not installed") {
                            IsSigWebInstalled = false;
                        } else {
                            IsSigWebInstalled = true;
                        }
                    }

                    if (InstallSigPadDriverPrompt == "Y") {
                        $("#SigPlus1").attr("classid", "clsid:69A40DA3-4D42-11D0-86B0-0000C025864A");
                    }

                    if (UseHTML5Signature == "Y") {
                        loadCanvasSignaturePad();
                    }
                    if (UseSignaturePad != "N") {
                        OnSign(); //Activate signature pad
                        document.getElementById('canvasSignPad').style.display = 'none';
                    }
                }
                if (parent.document.getElementById('Control_ASP.usercontrols_madicationpatientcontent_ascx_RadioButtonRelation').checked == true) {
                    document.getElementById('tdSignedPaperDocument').style.display = "block";
                    document.getElementById('<%=TextBoxPassword.ClientID%>').disabled = true;
                    document.getElementById('<%=RadioPassword.ClientID%>').checked = false;
                    document.getElementById('<%=RadioPassword.ClientID%>').disabled = true;
                    document.getElementById('<%=RadioSignaturePad.ClientID%>').checked = true;

                    if (IsSigWebInstalled != false && IsSigWebInstalled != true) {
                        if (SigWebInstalled() == "Sigweb not installed") {
                            IsSigWebInstalled = false;
                        } else {
                            IsSigWebInstalled = true;
                        }
                    }

                    if (InstallSigPadDriverPrompt == "Y") {
                        $("#SigPlus1").attr("classid", "clsid:69A40DA3-4D42-11D0-86B0-0000C025864A");
                    }

                    if (UseHTML5Signature == "Y") {
                        loadCanvasSignaturePad();
                    }
                    if (UseSignaturePad != "N") {
                        OnSign(); //Activate signature pad
                        document.getElementById('canvasSignPad').style.display = 'none';
                    }
                }
            }
        }

        function OnSign() {
            if (document.getElementById('ButtonSignBtnClient').value == 'Hide') {
                document.getElementById('ButtonSignBtnClient').value = 'Sign';
                document.getElementById('SigPlus1').className = 'Hidden';
                } else {
                document.getElementById('ButtonSignBtnClient').value = 'Hide';
                document.getElementById('SigPlus1').className = '';
            }

            // Added by ponnin For task #215 of Engineering Improvement Initiatives- NBL(I)
            var ua = navigator.userAgent.toLowerCase();
            if (ua.search("android") == -1) {
                if (IsSigWebInstalled && objCanvasCheck) {
                    var SigwebCanvas = document.getElementById('cnv');
                    SigwebCanvas.style.display = 'block';
                    SigwebCanvas.width = SigwebCanvas.width;
                    onSignChrome();
                    document.getElementById('SigPlus1').style.display = 'none';
                } else {
                    document.getElementById('SigPlus1').className = '';
                    document.getElementById('SigPlus1').style.display = 'block';
                    document.getElementById('cnv').style.display = 'none';
                    document.form1.SigPlus1.TabletState = 1; //Turns tablet on
                }
            }
        }
        
    </script>




</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="WebServices/CommonService.asmx" />
            <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
        </Services>
        <Scripts>
            <asp:ScriptReference Path="App_Themes/Includes/JS/MedicationMgt.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            <asp:ScriptReference Path="App_Themes/Includes/JS/ClientSearch.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        </Scripts>
    </asp:ScriptManager>
    <div style="width: 580px">
        <table align="center">
            <tr>
                <td style="height: 260px; width: 580px;">
                    <table style="width: 580px">
                        <tr>
                                    <td style="height: 7px; width: 580px;" class="labelFont">
                                <b>Get Signature</b>
                            </td>
                        </tr>
                        <tr>
                                    <td style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%; width: 50px;">
                                <div style="height: 196px; width: 575px;">
                                            <object class="Hidden" id="SigPlus1" style="height: 180px; left: 0px; top: 0px; width: 575px;"
                                        height="75" classid="clsid:69A40DA3-4D42-11D0-86B0-0000C025864A" name="SigPlus1"
                                        viewastext="" codebase="../sigplus.cab">
                                        <param name="_Version" value="131095" />
                                        <param name="_ExtentX" value="8467" />
                                        <param name="_ExtentY" value="4763" />
                                        <param name="_StockProps" value="9" />
                                    </object>

                                    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;">
                                    <div class="sigPad">
                                        <canvas id="canvasSignPad" name="canvasSignPad" width="575" height="180" style="display:none"></canvas>
                                        <canvas id="blankCanvas" name="blankCanvas" width="430" height="180" style="display:none"></canvas>
                                        <input type="hidden" id="hiddenTouchpadSig" name="output" class="output">
                                    </div>
                                        <canvas id="cnv" name="cnv" width="430" height="180" style="display: none;"></canvas>

                                    <table cellpadding="0" cellspacing="0" border="0" style="display: none;">
                                        <tr>
                                            <td>
                                                <img src="" id="ImgSignature" class="Hidden" />
                                            </td>
                                            <td>
                                                <input style="border: None" id="ButtonSignBtnClient" onclick="OnSign()" type="button"
                                                    value="Sign" name="ButtonSignBtnClient" class="detailsbutton" />
                                            </td>
                                        </tr>
                                    </table>
                                    <input runat="server" type="hidden" name="TextBoxClientSignatureDummy" id="TextBoxClientSignatureDummy" />
                                </div>
                            </td>
                        </tr>
                    </table>
                            <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 570px; margin-left:2px;">
                        <tr>
                            <td style="width: 100px">
                                <asp:RadioButton ID="RadioPassword" Text="Password" runat="server" CssClass="SumarryLabel"
                                    GroupName="rdo" />
                            </td>
                            <td style="width: 130px">
                                <asp:RadioButton ID="RadioSignaturePad" Text="Signature Pad" runat="server"
                                    CssClass="SumarryLabel" GroupName="rdo" />
                            </td>
                            <td style="width: 130px;display: none;" id="divCanvasSignature">
                                <asp:RadioButton ID="RadioCanvasSignature" Text="Mouse/Touchpad" runat="server"
                                    CssClass="SumarryLabel" GroupName="rdo" />
                                                            
                            </td>
                            <td style="width: 200px" id="tdSignedPaperDocument">
                                <asp:CheckBox ID="CheckBoxSignedPaperDocument" Text="Patient Signed Paper Document"
                                    runat="server" CssClass="SumarryLabel" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <table width="570">
                                    <tr>
                            <td style="width: 100px">
                                <asp:TextBox ID="TextBoxPassword" runat="server" TextMode="Password"></asp:TextBox>
                            </td>
                            <td style="width: 65px" nowrap="nowrap">
                                &nbsp;&nbsp;
                            </td>
                            <td style="width: 130px" nowrap="nowrap">
                                &nbsp;&nbsp;
                            </td>
                            <td nowrap="nowrap" style="width: 220px">
                                <input type="button" id="ButtonSign" value="Sign" class="btnimgexsmall"  runat="server" />
                                <input type="button" value="Clear" class="btnimgexsmall" onclick="ClearControls();" />
                                <input type="button" value="Cancel" class="btnimgexsmall" onclick="closeWindow();" />
                            </td>
                            <input type="hidden" id="HiddenFiledApplicationPath" runat="server" />
                                        </tr>
                                    </table>
                                </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>

<script language="javascript" type="text/javascript">
    Sys.Application.add_load(SignaturePadPageLoad)
</script>

</html>