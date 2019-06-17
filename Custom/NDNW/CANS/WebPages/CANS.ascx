<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CANS.ascx.cs" Inherits="SHS.SmartCare.CANS" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<% if (HttpContext.Current == null)
   { %>
<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<%--<script type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>

<script type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>

<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>--%>

<script src="<%=RelativePath%>Custom/CANS/Scripts/CANS.js" type="text/javascript"></script>

<input type="hidden" id="HiddenFieldPageTables" name="HiddenFieldPageTables" value="CustomDocumentCANSGenerals,CustomDocumentCANSYouthStrengths,CustomDocumentCANSModules"
    runat="server" />
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class="content_tab_top1">
            <telerik:RadTabStrip ID="RadTabStripCANS" Skin="Vista" CssClass="DocumentScreen" OnClientTabSelected="onTabSelected"
                OnClientLoad="StoreTabstripClientObject" runat="server" MultiPageID="RadMultiPageCANS"
                SelectedIndex="0" EnableEmbeddedScripts="False" EnableEmbeddedSkins="False">
                <Tabs>
                    <telerik:RadTab Text="General" UcName="CANSGeneral" Path="Custom/CANS/WebPages/CANSGeneral.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Youth Strengths & Needs" UcName="CANSYouthStrengths" Path="Custom/CANS/WebPages/CANSYouthStrengths.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Modules" UcName="CANSModules" Path="Custom/CANS/WebPages/CANSModules.ascx"
                        runat="server">
                    </telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPageCANS" EnableEmbeddedScripts="false" runat="server"
                SelectedIndex="0" CssClass="pageView">
                <telerik:RadPageView ID="CANSGeneral" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="CANSYouthStrengths" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="CANSModules" runat="server">
                </telerik:RadPageView>
            </telerik:RadMultiPage>
        </td>
    </tr>
</table>


<%--<table id="TableCANSDocumentTabContainer" width="100%" border="0" cellpadding="0"
    cellspacing="0">
    <tr>
        <td valign="top" style="width: 100%; padding-top: 0px;">
            <dxtc:ASPxPageControl ID="CANSDocumentTab" ClientInstanceName="CANSDocumentTabIns"
                runat="server" ActiveTabIndex="1" CssFilePath="~/App_Themes/Styles/DevExpressTabStyles.css"
                Width="100%" Paddings-Padding="0px" ContentStyle-Paddings-PaddingRight="0px"
                ContentStyle-Paddings-PaddingLeft="0px" ContentStyle-BorderRight-BorderWidth="0"
                ContentStyle-BorderLeft-BorderWidth="0px">
                <%--<ClientSideEvents TabClick="function(s, e) {        
        onTabSelected(s,e);      
       }" ActiveTabChanged="function(s, e) {onActiveTabChanged(s, e)}" />--%>
<%--       <ClientSideEvents TabClick="GeneralInformationTab" ActiveTabChanged="function(s, e) {onActiveTabChanged(s,e);       
                     SetCurrentTab(s,e);
                     }" />
                <ContentStyle>
                    <Paddings PaddingLeft="0px" PaddingRight="0px"></Paddings>
                    <BorderLeft BorderWidth="0px"></BorderLeft>
                    <BorderRight BorderWidth="0px"></BorderRight>
                </ContentStyle>
                <TabPages>
                    <dxtc:TabPage Text="General" Name="Custom/CANS/WebPages/CANSGeneral.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlGeneral" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
              <dxtc:TabPage Text="Youth Strengths & Needs" Name="Custom/CANS/WebPages/CANSYouthStrengths.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlYouthStrengths" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Modules" Name="Custom/CANS/WebPages/CANSModules.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlModules" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>

                </TabPages>
                <Paddings Padding="0px"></Paddings>
            </dxtc:ASPxPageControl>
        </td>
    </tr>
<tr>
        <td>
            <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="<%=PageTables%>" />
            <input id="HiddenField_DocumentVersions_DocumentVersionId" name="HiddenField_DocumentVersions_DocumentVersionId"
                type="hidden" value="-1" />
        </td>
    </tr>
</table>
--%>
