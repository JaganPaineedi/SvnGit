<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DLA.ascx.cs" Inherits="SHS.SmartCare.Custom_DLA_20_WebPages_DLA" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/DLA-20/Scripts/DLAMain.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/DLA-20/Scripts/DLA20Youth.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/DLA-20/Scripts/DLA.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/DLA-20/Scripts/tooltipsy.min.js"></script>
<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>
<style type="text/css">
    .RadTabStrip .rtsLink, .RadTabStrip .rtsOut, .RadTabStrip .rtsIn
    {
        padding-left: 0px;
        padding-right: 0px;
    }
    .tooltipsy
    {
        padding: 10px;
        max-width: 600px;
        color: #303030;
        background-color: #E0E0E0;
        border: 1px solid #deca7e;
    }
</style>
<script type="text/javascript">
    $('.hastip').tooltipsy();
</script>
<table id="TableDLATabContainer" width="100%" border="0" cellpadding="0" cellspacing="0" CssClass="DocumentScreen">
    <tr>
        <td valign="top" style="width: 100%; padding-top: 0px;">
            <telerik:RadTabStrip ID="RadTabStrip1" Skin="Vista" Width="832px" OnClientTabSelected="onTabSelected"
                OnClientTabSelecting="onTabSelectedClient" runat="server" MultiPageID="RadMultiPage1"
                OnClientLoad="StoreTabstripClientObject"  EnableEmbeddedScripts="False"
                EnableEmbeddedSkins="False">
                <Tabs>
                    <telerik:RadTab Text="DLA-20" UcName="DLA20" Path="/Custom/DLA-20/WebPages/DLA20.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="DLA-20 Y" UcName="YDLA20Y" Path="/Custom/DLA-20/WebPages/DLA20Y.ascx"
                        runat="server">
                    </telerik:RadTab>                                      
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPage1" EnableEmbeddedScripts="false" runat="server"
                CssClass="pageView">
                <telerik:RadPageView ID="DLA" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="YDLA20Y" runat="server">
                </telerik:RadPageView>                               
            </telerik:RadMultiPage>
        </td>
    </tr>
    <tr>
        <td>
             <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="<%=PageTables%>" />
            <input id="HiddenField_<%=PageTables%>_DocumentVersionId" name="HiddenField_<%=PageTables%>_DocumentVersionId"
                type="hidden" value="-1" />
               <input id="HiddenCustomHRMActivitiesDataTable" runat="server" name="HiddenCustomHRMActivitiesDataTable"
                style="display: none" />
                <input id="HiddenCustomHRMActivitiesDataTableYouth" runat="server" name="HiddenCustomHRMActivitiesDataTableYouth"
                style="display: none" />
            <input id="hiddenICDCodes" name="hiddenProgramCodes" type="hidden" runat="server" />
            <input type="hidden" id="HiddenClientAge"  runat="server"/>
        </td>
    </tr>
</table>
