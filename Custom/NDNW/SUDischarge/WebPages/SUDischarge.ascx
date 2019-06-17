<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SUDischarge.ascx.cs" Inherits="SHS.SmartCare.Custom_SUDischarge_WebPages_SUDischarge" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<script type="text/javascript" src="<%=RelativePath%>Custom/SUDischarge/Scripts/SUDischarge.js"></script>
<asp:Panel ID="PanelMain" runat="server">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td class="content_tab_top1">
                <telerik:RadTabStrip ID="RadTabStrip1TabPage" Skin="Vista" Width="832px"
                    OnClientTabSelected="onTabSelected" OnClientLoad="StoreTabstripClientObject"
                    runat="server" MultiPageID="RadMultiPageTabPage" SelectedIndex="1"
                    EnableEmbeddedScripts="False" EnableEmbeddedSkins="False">
                    <Tabs>
                        <telerik:RadTab Text="Discharge" UcName="SUDischarge" Path="/Custom/SUDischarge/WebPages/Discharge.ascx"
                            runat="server">
                        </telerik:RadTab>
                        <telerik:RadTab Text="Discharge Frequency" UcName="FrequencySU" Path="/Custom/SUDischarge/WebPages/Frequency.ascx"
                            runat="server">
                        </telerik:RadTab>
                        <telerik:RadTab Text="Discharge Information" UcName="SUInformation" Path="/Custom/SUDischarge/WebPages/Information.ascx"
                            runat="server">
                        </telerik:RadTab>
                         <telerik:RadTab Text="Substance Use" UcName="SubstanceUse" Path="/Custom/SUDischarge/WebPages/Substanceuse.ascx"
                            runat="server">
                        </telerik:RadTab>
                    </Tabs>
                </telerik:RadTabStrip>
                <telerik:RadMultiPage ID="RadMultiPageTabPage" EnableEmbeddedScripts="false"
                    runat="server" SelectedIndex="0" CssClass="pageView">
                    <telerik:RadPageView ID="SUDischarge" runat="server">
                    </telerik:RadPageView>
                    <telerik:RadPageView ID="FrequencySU" runat="server">
                    </telerik:RadPageView>
                    <telerik:RadPageView ID="SUInformation" runat="server">
                    </telerik:RadPageView>
                     <telerik:RadPageView ID="SubstanceUse" runat="server">
                    </telerik:RadPageView>
                </telerik:RadMultiPage>
            </td>
        </tr>
        <tr>
            <td></td>
        </tr>
    </table>
</asp:Panel>
<asp:Panel ID="PanelCustomAjax" runat="server">
</asp:Panel>
<input id="HiddenField_DocumentVersions_Version" name="HiddenField_DocumentVersions_Version"
    type="hidden" value="-1" />
<input id="HiddenField_Documents_DocumentId" name="HiddenField_Documents_DocumentId"
    type="hidden" value="0" />
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentSUDischarges" />
