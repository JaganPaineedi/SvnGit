<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FBABIPGeneral.ascx.cs" Inherits="ActivityPages_Client_Detail_Documents_Threshold_FBABIP_FBABIPGeneral" %> 

 
<link href="<%=RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />   
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/FBABIP/Scripts/FBABIP.js"></script>   
<table border="0" cellpadding="0" cellspacing="0"  width="100%">
    <tr>
        <td class="content_tab_top1">
            <dxtc:ASPxPageControl ID="FBABIPGeneralTabPage" ClientInstanceName="FBABIPGeneralTabPage"
                Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True"
                CssFilePath="~/App_Themes/Styles/DevExpressTabStyles.css" Height="250" ContentStyle-BorderLeft-BorderWidth="0px"
                ContentStyle-BorderRight-BorderWidth="0px" ContentStyle-Paddings-PaddingLeft="0px"
                ContentStyle-Paddings-PaddingRight="0px" Paddings-Padding="0px">
                <ClientSideEvents TabClick="function(s, e) { onTabSelected(s,e); }"/>
                <TabPages>
                    <dxtc:TabPage Text="Functional Behavior Assessment" Name="/Custom/FBABIP/WebPages/FuntionalBehaviorAssessment.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlFBA" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>
                    <dxtc:TabPage Text="Behavior Intervention Plan" Name="/Custom/FBABIP/WebPages/BehaviorInterventionPlan.ascx">
                        <ContentCollection>
                            <dxw:ContentControl ID="ContentControlBIP" runat="server">
                            </dxw:ContentControl>
                        </ContentCollection>
                    </dxtc:TabPage>                    
                </TabPages>
            </dxtc:ASPxPageControl>
        </td>
    </tr>  
</table>
<input type="hidden" id="HiddenFieldPageTables" name="HiddenFieldPageTables" value="CustomDocumentFABIPs" />

   