<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ScreeningsMain.ascx.cs"
   Inherits="SHS.SmartCare.Custom_Screenings_WebPages_ScreeningsMain"  %>

    <script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Screenings/Scripts/Screenings.js"></script>
<asp:Panel ID="PanelMain" runat="server">
  
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td style="margin-left: 0; margin-right: 0">
                <dxtc:ASPxPageControl ID="ScreeningsTabPageInstance" ClientInstanceName="ScreeningsTabPageInstance"
                    runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" CssFilePath="~/App_Themes/Styles/DevExpressTabStyles.css"
                    Width="100%" Paddings-Padding="0px" ContentStyle-Paddings-PaddingRight="0px"
                    ContentStyle-Paddings-PaddingLeft="0px" ContentStyle-BorderRight-BorderWidth="0"
                    ContentStyle-BorderLeft-BorderWidth="0px">
                   <ClientSideEvents TabClick="function(s, e) { 
       
        onTabSelected(s,e);
      
       
       }" ActiveTabChanged="function(s, e) {onActiveTabChanged(s, e)}" />
                    <TabPages>
                        <dxtc:TabPage Text="Substance Abuse Screening" Name="/Custom/Screenings/WebPages/SubstanceUse.ascx">
                            <ContentCollection>
                                <dxw:ContentControl CssClass="ContentControlDischarge" ID="ContentControlSubstance" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                        <dxtc:TabPage Text="Mental Health Screening" Name="/Custom/Screenings/WebPages/MentalHealth.ascx">
                            <ContentCollection>
                                <dxw:ContentControl CssClass="ContentControlDischarge" ID="ContentControlMH" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                          <dxtc:TabPage Text="Traumatic Brain Injury Screening" Name="/Custom/Screenings/WebPages/BrainInjury.ascx">
                            <ContentCollection>
                                <dxw:ContentControl CssClass="ContentControlDischarge" ID="ContentControlBrain" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                          <dxtc:TabPage Text="OutComes" Name="/Custom/Screenings/WebPages/Outcomes.ascx">
                            <ContentCollection>
                                <dxw:ContentControl CssClass="ContentControlDischarge" ID="ContentControlOutcomes" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                    </TabPages>
                </dxtc:ASPxPageControl>
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentSubstanceAbuseScreenings,CustomDocumentMentalHealthScreenings,CustomDocumentTraumaticBrainInjuryScreenings,CustomDocumentOutComesScreenings" />
                <input id="HiddenField_CustomDocumentSubstanceAbuseScreenings_DocumentVersionId" name="HiddenField_CustomDocumentSubstanceAbuseScreenings_DocumentVersionId"
                    type="hidden" />
            </td>
        </tr>
    </table>
</asp:Panel>
