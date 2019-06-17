<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UseKeyPhrase.aspx.cs" Inherits="UseKeyPhrase" %>

<%@ Register TagPrefix="UI" TagName="UseMyKeyPhrase" Src="~/UserControls/UseMyKeyPhrases.ascx" %>
<%@ Register TagPrefix="UI" TagName="UseAgencyKeyPhrase" Src="~/UserControls/UseAgencyKeyPhrases.ascx" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/BasePages/UI/Heading.ascx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("ul.tabs li:first").addClass("active").show();
            $(".tab_content:first").show();
            $("ul.tabs li").click(function () {
                $('html, body').animate({ scrollTop: 0 }, 0);
                $("ul.tabs li").removeClass("active");
                $(this).addClass("active");
                var activeTab = $(this).find("a").attr("href");
                $(activeTab).fadeIn();
                if (activeTab == "#tab1") {
                    $divshowhideagency = $("#DivShowHidUseAgencyKeyPhrase");
                    $divshowhideagency.css('display', 'none');
                    $divshowhidemy = $("#DivShowHideUseMyKeyPhrase");
                    $divshowhidemy.css('display', 'block');
        
                }
                if (activeTab == "#tab2") {
                    $divshowhidemy = $("#DivShowHideUseMyKeyPhrase");
                    $divshowhidemy.css('display', 'none');
                    $divshowhideagency = $("#DivShowHidUseAgencyKeyPhrase");
                    $divshowhideagency.css('display', 'block');
                }
            });
        });

        function fnShow() {
            try {
                fnShowParentDiv("Processing...", 280, 25);
            } catch (Exception) {
                ShowError(Exception.description, true);
            }
        }

    </script>
</head>
<body>
    <form id="formUseKeyPhrase" runat="server">
        <asp:ScriptManager ID="ScriptManagerUseKeyPhrase" runat="server" />
        <asp:UpdatePanel ID="UpdatePanelUseKeyPhrase" runat="server">
            <ContentTemplate>
                <div style="overflow-x:hidden">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="padding-top: 3px"  class="TableDashboard">
                        <tr>
                            <td>
                                <ul class="tabs" style="width: 100%">
                                    <li style="left: 0px; top: 0px"><a href="#tab1">My </a></li>
                                    <li><a href="#tab2">Agency</a></li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 5px"></td>
                        </tr>
                        <tr>
                            <td>
                                <div id="DivShowHideUseMyKeyPhrase" style="display: block;">
                                    <UI:UseMyKeyPhrase ID="UseMyKeyPhrase" runat="Server"></UI:UseMyKeyPhrase>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="DivShowHidUseAgencyKeyPhrase" style="display: none">
                                    <UI:UseAgencyKeyPhrase ID="UseAgencyKeyPhrase" runat="Server"></UI:UseAgencyKeyPhrase>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>





