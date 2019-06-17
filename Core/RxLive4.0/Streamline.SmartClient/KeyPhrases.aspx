<%@ Page Language="C#" AutoEventWireup="true" CodeFile="KeyPhrases.aspx.cs" Inherits="KeyPhrases" EnableViewState="false" EnableEventValidation="false" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>
<%--<%@ Register TagPrefix="UI" TagName="RXPhrasesGeneral" Src="~/UserControls/RXPhrasesGeneral.ascx" %>--%>
<%@ Register TagPrefix="UI" TagName="RXMyPhrases" Src="~/UserControls/RXMyPhrases.ascx" %>
<%@ Register TagPrefix="UI" TagName="RxAgencyKeyPhrases" Src="~/UserControls/RxAgencyKeyPhrases.ascx" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />

    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1"
        type="text/javascript"></script>

    <script type="text/javascript" language="javascript">
        var checkboxObj = {};
        $(document).ready(function () {
            $("ul.tabs li:first").addClass("active").show(); //Activate first tab
            $(".tab_content:first").show(); //Show first tab content
            $("ul.tabs li").click(function () {
                $('html, body').animate({ scrollTop: 0 }, 0);
                $("ul.tabs li").removeClass("active");
                $(this).addClass("active");
                var activeTab = $(this).find("a").attr("href");
                $(activeTab).fadeIn();
                if (activeTab == "#tab1") {
                    $divshowhideagency = $("#DivShowHideUseAgencyKeyPhrase");
                    $divshowhideagency.css('display', 'none');
                    $divshowhidemy = $("#DivShowHideUseMyKeyPhrase");
                    $divshowhidemy.css('display', 'block');

                }
                if (activeTab == "#tab2") {
                    $divshowhidemy = $("#DivShowHideUseMyKeyPhrase");
                    $divshowhidemy.css('display', 'none');
                    $divshowhideagency = $("#DivShowHideUseAgencyKeyPhrase");
                    $divshowhideagency.css('display', 'block');
                }
                var heihtToSet = 0;
            });
        });
       
        function SaveKeyPhrases() {
            ClientMedicationOrder.SaveKeyPhrases();
        }
     
        function OpenEditAgencyPhrases() {
            try {
                closeKeyPhrasesPopupDiv();
                var $divSearch = parent.$("#DivSearch1");
                $("#topborder1", $divSearch).text("SmartCare");
                var $iFrameSearch = $('#iFrame1', $divSearch);
                $iFrameSearch.attr('src', 'EditAgencyKeyPhrases.aspx?');
                $iFrameSearch.css({ 'width': '800px', 'height': '450px' });
                var left = ($(window.document).width() / 3) - ($iFrameSearch.width() / 2);
                left = left > 0 ? left : 10;
                var top = ($(window.document).height() / 3) - ($iFrameSearch.height() / 2);
                top = top > 0 ? top : 10;
                $divSearch.css({ 'top': top, 'left': left });
                $divSearch.draggable();
                $divSearch.css('display', 'block');

            

            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
            return false;
        }

        function closeKeyPhrasesPopupDiv() {
            try {
                var DivSearch = parent.parent.document.getElementById('DivKeyAndAgencyPhrase');
                DivSearch.style.display = 'none';
            } catch (e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }

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
                <asp:ServiceReference Path="WebServices/CommonService.asmx" />
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
                <asp:ScriptReference Path="App_Themes/Includes/JS/jscalendar/lang/calendar-en.js?rel=3_5_x_4_1"
                    NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/js/jscalendar/calendar-setup.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
                <asp:ScriptReference Path="App_Themes/Includes/JS/TextBoxWrapper.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            </Scripts>
        </asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress2" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <%--<asp:Label ID="LabelProgressText" runat="server" Font-Bold="True" Font-Italic="True"
                    Font-Size="Medium" ForeColor="#1C5B94" meta:resourcekey="LabelProgressTextResource1"
                    Text="Communicating with server..."></asp:Label>
                <asp:Image ID="ImageProgressText" runat="server" ImageUrl="~/App_Themes/Includes/Images/Progress.gif"
                    meta:resourcekey="ImageProgressTextResource1" />--%>
                <img id="ImageProgressText" src="App_Themes/Includes/Images/ajax-loader.gif" runat="server" meta:resourcekey="ImageProgressTextResource1" />
            </ProgressTemplate>
        </asp:UpdateProgress>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div style="overflow-x:hidden">
                    <table align="center" border="0" cellpadding="0" cellspacing="0" width="600px">
                        <table id="TableTitleBar" border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>

                                <td align="right" style="width: 30%">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="right" style="width: 50%">
                                                <asp:LinkButton ID="LinkButtonStartPage" runat="server" OnClientClick="redirectToStartPage();this.disabled=true;return false;" Style="display: none" Text="Start Page"></asp:LinkButton>
                                            </td>
                                            <td align="right" style="width: 50%">
                                                <asp:LinkButton ID="LinkButtonLogout" runat="server" Style="display: none" Text="Logout"></asp:LinkButton>
                                            </td>
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
                                                <input type="button" class="btnimgexsmall" id="ButtonEditAgencyPhrases" value="Edit Agency Phrases" onclick="OpenEditAgencyPhrases();" />
                                                <input type="button" value="Save/Close" style="width: 100px" class="btnimgexsmall" onclick="SaveKeyPhrases();" />                          
                                                <input type="button" ID="btnClose" runat="server" class="btnimgexsmall" onclick="ClientMedicationOrder.CloseKeyPhrase();" value="Cancel" />

                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>

                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td>
                                    <ul class="tabs" style="width: 100%">
                                        <li style="left: 0px; top: 0px"><a href="#tab1">My Phrases</a></li>

                                        <li><a href="#tab2">Agency Phrases</a></li>

                                    </ul>

                                </td>
                            </tr>
                            <tr>
                                <td style="height: 5px"></td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="DivShowHideUseMyKeyPhrase" style="display: block;">
                                        <UI:RXMyPhrases ID="RXMyPhrases" runat="Server"></UI:RXMyPhrases>                                      
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="DivShowHideUseAgencyKeyPhrase" style="display: none;">
                                        <UI:RxAgencyKeyPhrases ID="UseAgencyKeyPhrase" runat="Server"></UI:RxAgencyKeyPhrases>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </table>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
