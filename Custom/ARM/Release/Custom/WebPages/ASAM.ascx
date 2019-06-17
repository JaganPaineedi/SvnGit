<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ASAM.ascx.cs" Inherits="ASAM" %>

<script src="<%=RelativePath%>Custom/Scripts/SCASAM.js" type="text/javascript"></script>

<div>
    <asp:Panel ID="Panel_DetailUC" runat="server" Visible="false">
    </asp:Panel>
</div>
<div style="height: 20px">
</div>
<div>
    <dxtc:ASPxPageControl ID="ASAMTabPage" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True"
        Height="250" Width="100%" ContentStyle-BorderLeft-BorderWidth="0px" ContentStyle-BorderRight-BorderWidth="0px"
        ContentStyle-Paddings-PaddingLeft="0px" ContentStyle-Paddings-PaddingRight="0px"
        Paddings-Padding="0px">
        <ClientSideEvents TabClick="function(s, e) { onTabSelected(s,e); }" ActiveTabChanged="function(s, e) {
	                                    onActiveTabChanged(s,e);
                                   }" />
        <TabPages>
            <dxtc:TabPage Text="LOC-One" Name="/Custom/WebPages/ASAM1.ascx">
                <ContentCollection>
                    <dxw:ContentControl ID="ContentControlASAMOne" runat="server">
                    </dxw:ContentControl>
                </ContentCollection>
            </dxtc:TabPage>
            <dxtc:TabPage Text="LOC-Two" Name="/Custom/WebPages/ASAM2.ascx">
                <ContentCollection>
                    <dxw:ContentControl ID="ContentControlASAMTwo" runat="server">
                    </dxw:ContentControl>
                </ContentCollection>
            </dxtc:TabPage>
            <dxtc:TabPage Text="LOC-Three" Name="/Custom/WebPages/ASAM3.ascx">
                <ContentCollection>
                    <dxw:ContentControl ID="ContentControlASAMThree" runat="server">
                    </dxw:ContentControl>
                </ContentCollection>
            </dxtc:TabPage>
            <dxtc:TabPage Text="LOC-Four" Name="/Custom/WebPages/ASAM4.ascx">
                <ContentCollection>
                    <dxw:ContentControl ID="ContentControlASAMFour" runat="server">
                    </dxw:ContentControl>
                </ContentCollection>
            </dxtc:TabPage>
        </TabPages>
    </dxtc:ASPxPageControl>
    <input id="HiddenField_CustomASAMPlacements_DocumentVersionId" name="HiddenField_CustomASAMPlacements_DocumentVersionId"
        type="hidden" value="-1" />
    <%--<input id="HiddenField_DischargeEvents_DocumentId" name="HiddenField_DischargeEvents_DocumentId"
        type="hidden" value="0" />--%>
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentEventInformations,CustomASAMPlacements" />
</div>
