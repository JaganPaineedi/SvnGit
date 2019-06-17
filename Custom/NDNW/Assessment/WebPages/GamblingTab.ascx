<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GamblingTab.ascx.cs" Inherits="SHS.SmartCare.GamblingTab" %> 

 
 

<% if (HttpContext.Current == null)
   { %>
<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="padding-top: 5px;">
    <tr>
        <td class="content_tab_top1">
            <dxtc:ASPxPageControl ID="GambTabs" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True"
                Width="100%" ClientInstanceName="GambTabs" ContentStyle-BorderLeft-BorderWidth="0px" 
                ContentStyle-BorderRight-BorderWidth="0px" ContentStyle-Paddings-PaddingLeft="0px"
                ContentStyle-Paddings-PaddingRight="0px"  Paddings-Padding="0px">
                <ClientSideEvents TabClick="function(s, e) {onTabSelected(s,e);onChildTabSelected(s,e);}" ActiveTabChanged="function(s, e) {onActiveTabChanged(s, e)}"/>
                <ContentStyle>
                    <Paddings PaddingLeft="0px" PaddingRight="0px"></Paddings>
                    <BorderLeft BorderWidth="0px"></BorderLeft>
                    <BorderRight BorderWidth="0px"></BorderRight>
                </ContentStyle>
                <TabPages>
                    <dxtc:TabPage Text="General" Name="/Custom/Assessment/WebPages/GamblingGeneral.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlSafetyPlan" runat="server" CssClass="serviceTabStyle">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Gambling" Name="/Custom/Assessment/WebPages/Gambling.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlCrisisPlan" runat="server" CssClass="serviceTabStyle">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                </TabPages>
                <Paddings Padding="0px"></Paddings>
            </dxtc:ASPxPageControl>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
</table>
