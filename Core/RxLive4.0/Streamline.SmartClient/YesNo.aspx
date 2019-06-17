<%@ Page Language="C#" AutoEventWireup="true" CodeFile="YesNo.aspx.cs" Inherits="YesNo" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <base target="_self" />
    <title>Medication</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function yesClicked() {
            window.returnValue = 'Y';
            window.close();
            closeDialogWithReturnValue("Y");
        }

        function noOrCancelClicked() {
            window.returnValue = 'N';
            window.close();
            closeDialogWithReturnValue("N");
        }

        function closeDialogWithReturnValue(returnValue) {
            if (parent.document.getElementById('dialog-body') && parent.document.getElementById('dialog-body').contentWindow && parent.document.getElementById('dialog-body').contentWindow.returnValue) {
                parent.document.getElementById('dialog-body').contentWindow.returnValue = returnValue;
            }
            if (parent.document.getElementById('dialog-close'))
                parent.document.getElementById('dialog-close').click();
        }
    </script>
</head>
<%--<body bgcolor="#F0F0F0">
    <form id="form1" runat="server">
        <table align="center" border="0" cellpadding="0" cellspacing="0" width="250px">
            <tr>
                <td valign="top" align="left" class="" style="Width:250px;">                                
                    <table align="center" class="" width="250px">
                        <tr>
                            <td colspan="3" style="height:15px;">                               
                            </td>
                        </tr>
                        <tr>
                          
                           <td colspan="3" align="left"  class="Alerts" style="Width:250px;">
                                    <span id="SpanConfirm" runat="server" class="Label" style="text-align: left; Width: 250px;"></span>
                            </td>
                        </tr>
                        <tr>
                             <td colspan="3" style="height:20px;">                               
                            </td>
                        </tr>
                        <tr>
                           <td align="center" nowrap="nowrap" class="">
                                <input type="button" size="10" id="ButtonYes" onclick="javascript: yesClicked();"  style="font-family:MS Sans Serif; font-size:8.25pt; height:24px; width:70px" value="Yes" runat="server" />
                                &nbsp;
                                <input type="button" id="ButtonNo" value="No" onclick="javascript: noOrCancelClicked();" runat="server" style="font-family:MS Sans Serif; font-size:8.25pt; height:24px; width:70px" />                                                                
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>--%>
<body bgcolor="#F0F0F0">
    <form id="form1" runat="server">
        <div id="MessagePopUp" style="width: 400px; height: 156px; left: 481px; top: 77.5px;" class="modalPopup">
            <table border="0" cellspacing="0" cellpadding="0" align="center" style="border: solid 1px #4b81b6; background-color: #fff; color: Black;"
                width="100%">
                <tbody>
                    <tr>
                        <td colspan="3" align="left" class="DialogHeader" style="cursor: default;" valign="top">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td align="left">
                                            <span id="MessageBoxCaption">Confirmation Message</span>
                                        </td>
                                        <td align="right">
                                            <img src="./App_Themes/Includes/Images/ModalClose.png" title="Close" alt="Close" class="PopUpCloseButton" onclick="noOrCancelClicked();">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tbody>
                                    <tr>
                                        <td colspan="3" style="height: 20px"></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 20px">&nbsp;
                                        </td>
                                        <td>
                                            <div id="DivMessageBox" style="height: 90px; width: 380px;">
                                                <table cellpadding="0" width="100%" cellspacing="0" border="0">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div id="MessageBoxErrorMessage" class="error_msg" style="overflow-y: auto; overflow-x: auto; height: 15px;">
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 25%; padding: 1px 13px;" valign="top" align="right">
                                                                <img id="MessageBoxIcon" alt="Message Box Icon" class="element" src="./App_Themes/Includes/Images/Question.png">
                                                            </td>
                                                            <td colspan="3" align="left" class="Alerts" style="Width: 250px;">
                                                                <span id="SpanConfirm" runat="server" class="Label" style="text-align: left; Width: 250px;"></span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3" height="10"></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3" align="center">
                                                                <table border="0" cellpadding="2" cellspacing="2">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td style="padding-left: 4px">
                                                                                <input type="button" size="10" id="ButtonYes" class="less_detail_btn_new element" onclick="javascript: yesClicked();" style="font-family: MS Sans Serif; font-size: 8.25pt;" value="Yes" runat="server" />

                                                                            </td>
                                                                            <td style="padding-left: 4px">
                                                                                <input type="button" id="ButtonNo" value="No" class="less_detail_btn_new element" onclick="javascript: noOrCancelClicked();" runat="server" style="font-family: MS Sans Serif; font-size: 8.25pt;" />

                                                                            </td>

                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </td>
                                        <td style="width: 20px">&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" style="height: 20px"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>

        </div>
    </form>
</body>
</html>
