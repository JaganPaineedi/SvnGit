<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditAgencyKeyPhrases.aspx.cs" Inherits="EditAgencyKeyPhrases" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<%@ Register TagPrefix="UI" TagName="RXEditAgencyKeyPhrases" Src="~/UserControls/RXEditAgencyKeyPhrases.ascx" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $(".tab_content").hide(); //Hide all content
            $("ul.tabs li:first").addClass("active").show(); //Activate first tab
            $(".tab_content:first").show(); //Show first tab content
            $("ul.tabs li").click(function () {
                $('html, body').animate({ scrollTop: 0 }, 0);
                $("ul.tabs li").removeClass("active"); //Remove any "active" class
                $(this).addClass("active"); //Add "active" class to selected tab
                $(".tab_content").hide(); //Hide all tab content
                var activeTab = $(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
                $(activeTab).fadeIn(); //Fade in the active ID content
                if (activeTab == "#tab2") {
                    var outboundTable = $("#tblOutBoundPrescription", $(activeTab));
                    var width = $(window).width();
                    var tableWidth = $(".ListPageHeader>table", outboundTable).width();
                    $(".ListPageHeader", outboundTable).width((width >= tableWidth ? tableWidth : (width - 18)));
                    tableWidth = tableWidth + 18;
                    $(".ListPageContent", outboundTable).width((width >= tableWidth ? tableWidth : width));
                }
                var heihtToSet = 0;
            });
        });


        function SaveAgencyKeyPhrases() {
            //debugger
            ClientMedicationOrder.SaveAgencyKeyPhrases();
        }
        function CloseAgencyKeyPhrases() {
            ClientMedicationOrder.CloseAgencyKeyPhrases();
        }

    </script>

    <script type="text/javascript">

        window.onerror = function (message, url, lineNumber) {
            //Since our framework only understand exception we have to convert it
            var e = Error.create(message, { description: message, name: 'UnhandledError', lineNumber: lineNumber, url: url });
            Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_UNHANDLED, e);

            return true;
        }

    </script>


</head>

<body>

    <form id="form2" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
            </Services>
            <Scripts>
                <asp:ScriptReference Path="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/jquery-ui.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/ExceptionManager.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/AjaxScript.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/DatePopUp/ts_picker.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/calendar.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/TextBoxWrapper.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            </Scripts>
        </asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
               <%-- <asp:Label ID="LabelProgressText" runat="server" Font-Bold="True" Font-Italic="True"
                    Font-Size="Medium" ForeColor="#1C5B94" meta:resourcekey="LabelProgressTextResource1"
                    Text="Communicating with server..."></asp:Label>
                <asp:Image ID="ImageProgressText" runat="server" ImageUrl="~/App_Themes/Includes/Images/Progress.gif"
                    meta:resourcekey="ImageProgressTextResource1" />--%>
                 <img id="Img1" src="App_Themes/Includes/Images/ajax-loader.gif" runat="server" meta:resourcekey="LabelProgressTextResource1" />
            </ProgressTemplate>
        </asp:UpdateProgress>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td>
                                <table id="TableTitleBar" border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td align="right" style="width: 30%">
                                            <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td align="right" style="width: 50%"></td>
                                                    <td align="right" style="width: 50%"></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 1pt; border-bottom: #5b0000 1px solid;"></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td align="left">
                                                        <asp:Label ID="LabelClientName" runat="server" Style="font-family: Microsoft Sans Serif; font-size: 8.25pt;"></asp:Label>
                                                    </td>
                                                    <td align="right" nowrap="nowrap">
                                                        <input type="Button" id="ButtonSave" value="Save/Close" class=" btnimgsmall" onclick="SaveAgencyKeyPhrases();" />
                                                        <input type="Button" id="ButtonCancel" value="Cancel" class=" btnimgexsmall" onclick="CloseAgencyKeyPhrases();" />

                                                    </td>
                                                    <td></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <UI:RXEditAgencyKeyPhrases ID="RXEditAgencyKeyPhrases" runat="Server"></UI:RXEditAgencyKeyPhrases>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
