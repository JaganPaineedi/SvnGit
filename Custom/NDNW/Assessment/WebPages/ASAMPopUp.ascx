<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ASAMPopUp.ascx.cs" Inherits="ActivityPages_Client_Detail_Kalamazoo_KalamazooAssessment_ASAMPopUp" %>

<script src="<%=RelativePath%>Custom/Assessment/Scripts/ASAM.js" type="text/javascript"></script>

<script src="<%=RelativePath%>Custom/Assessment/Scripts/AssessmentASAMPopUp.js" type="text/javascript"></script>

<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<style type="text/css">
    html
    {
        overflow: hidden;
    }
</style>
<div id="DivMainPageContent">
    <div style="float: right; margin-right: 5px">
        <table>
            <tr>
                <td>
                    <input type="button" id="Button_ASAM_Save" name="Button_ASAM_Save" value="Save" class="less_detail_btn"
                        onclick="SaveASAMPopUpData()" />
                </td>
                <td>
                    <input id="ButtonCancel" type="button" runat="server" value="Close" onclick="CloseASAMPopUp();"
                        class="less_detail_btn" />
                </td>
            </tr>
        </table>
    </div>
    <div style="float: left; margin-left: 8px; width: 99%">
        <dxtc:ASPxPageControl ID="ASAMTabPage" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True"
            Height="250" Width="100%" ContentStyle-BorderLeft-BorderWidth="0px" ContentStyle-BorderRight-BorderWidth="0px"
            ContentStyle-Paddings-PaddingLeft="0px" ContentStyle-Paddings-PaddingRight="0px"
            Paddings-Padding="0px">
            <ClientSideEvents TabClick="function(s, e) { onTabSelected(s,e); }" ActiveTabChanged="function(s, e) {
	                                    onActiveTabChanged(s,e);
                                   }" />
            <TabPages>
                <dxtc:TabPage Text="ASAM-One" Name="/ActivityPages/Client/PADocuments/ASAM1.ascx">
                    <ContentCollection>
                        <dxw:ContentControl ID="ContentControlASAMOne" runat="server">
                        </dxw:ContentControl>
                    </ContentCollection>
                </dxtc:TabPage>
                <dxtc:TabPage Text="ASAM-Two" Name="/ActivityPages/Client/PADocuments/ASAM2.ascx">
                    <ContentCollection>
                        <dxw:ContentControl ID="ContentControlASAMTwo" runat="server">
                        </dxw:ContentControl>
                    </ContentCollection>
                </dxtc:TabPage>
                <dxtc:TabPage Text="ASAM-Three" Name="/ActivityPages/Client/PADocuments/ASAM3.ascx">
                    <ContentCollection>
                        <dxw:ContentControl ID="ContentControlASAMThree" runat="server">
                        </dxw:ContentControl>
                    </ContentCollection>
                </dxtc:TabPage>
                <dxtc:TabPage Text="ASAM-Four" Name="/ActivityPages/Client/PADocuments/ASAM4.ascx">
                    <ContentCollection>
                        <dxw:ContentControl ID="ContentControlASAMFour" runat="server">
                        </dxw:ContentControl>
                    </ContentCollection>
                </dxtc:TabPage>
            </TabPages>
        </dxtc:ASPxPageControl>
        <input id="HiddenField_CustomASAMPlacements_DocumentVersionId" name="HiddenField_CustomASAMPlacements_DocumentVersionId"
            type="hidden" value="-1" />
        <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomASAMPlacements" />
    </div>
</div>
