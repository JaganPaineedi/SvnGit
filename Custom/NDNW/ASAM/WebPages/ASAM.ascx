<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ASAM.ascx.cs" Inherits="SHS.SmartCare.Custom_ASAM_WebPages_ASAM" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<script type="text/javascript" src="<%=RelativePath%>Custom/ASAM/Scripts/ASAM.js"></script>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class="content_tab_top1">
            <telerik:RadTabStrip ID="RadTabStrip1ASAMTabPage" Skin="Vista" Width="832px"
                OnClientTabSelected="onTabSelected" OnClientLoad="StoreTabstripClientObject"
                runat="server" MultiPageID="RadMultiPageASAMTabPage" SelectedIndex="5"
                EnableEmbeddedScripts="False" EnableEmbeddedSkins="False">
                <Tabs>
                    <telerik:RadTab Text="Dimension 1" UcName="ContentControlOneDimension" Path="/Custom/ASAM/WebPages/Dimension1.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Dimension 2" UcName="ContentControlTwoDimension" Path="/Custom/ASAM/WebPages/Dimension2.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Dimension 3" UcName="ContentControlThreeDimension" Path="/Custom/ASAM/WebPages/Dimension3.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Dimension 4" UcName="ContentControlFourDimension" Path="/Custom/ASAM/WebPages/Dimension4.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Dimension 5" UcName="ContentControlFiveDimension" Path="/Custom/ASAM/WebPages/Dimension5.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Dimension 6" UcName="ContentControlSixDimension" Path="/Custom/ASAM/WebPages/Dimension6.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Final Determination" UcName="ContentControlFinalDetermination" Path="/Custom/ASAM/WebPages/FinalDetermination.ascx"
                        runat="server">
                    </telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="RadMultiPageASAMTabPage" EnableEmbeddedScripts="false"
                runat="server" SelectedIndex="0" CssClass="pageView">
                <telerik:RadPageView ID="ContentControlOneDimension" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="ContentControlTwoDimension" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="ContentControlThreeDimension" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="ContentControlFourDimension" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="ContentControlFiveDimension" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="ContentControlSixDimension" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="ContentControlFinalDetermination" runat="server">
                </telerik:RadPageView>
            </telerik:RadMultiPage>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
</table>
<input id="HiddenField_DocumentVersions_Version" name="HiddenField_DocumentVersions_Version"
    type="hidden" value="-1" />
<input id="HiddenField_Documents_DocumentId" name="HiddenField_Documents_DocumentId"
    type="hidden" value="0" />
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentASAMs" />
