<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EducationInformationView.aspx.cs" Inherits="EducationInformationView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <script language="javaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
<head runat="server">
    <title></title>
    <%--<link type="text/css" rel="stylesheet" href="App_Themes/Styles/smartcare_styles.css" />--%>
    <style>
        .content_tab_bg
        {
            background: url(App_Themes/Includes/Images/content_tab_bg.gif) repeat-x left top;
            border-left: 1px solid #7e99a9;
            border-right: 1px solid #7e99a9;
        }

        .labelPadding
        {
            padding: 10px;
        }
    </style>
</head>
<body style="font-family: Tahoma, Arial, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 0; outline: 0;">
    <form id="form1" runat="server">
        <div class="content_tab_bg">
            <div class="labelPadding">
                <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
    $().ready(function () {
        $('[id$=Label1]').html($('[id$=Label1]').text());
        $('#aLinkResource').html($('#divAnchorTag').find('p').first().html()).css('padding-left', '10px');
    })
</script>
