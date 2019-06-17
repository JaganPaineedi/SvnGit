<%@ Control Language="C#" AutoEventWireup="true" CodeFile="IndividualServiceNote.ascx.cs" Inherits="Custom_IndividualServiceNote_WebPages_IndividualServiceNote" %>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/IndividualServiceNote/Scripts/IndividualServiceNote.js"></script>
<%--<script src="<%=RelativePath%>Custom/Common/Scripts/CustomBillingDiagnosis.js" type="text/javascript"></script>--%>
<input type="hidden" id="HiddenFieldPageTables" name="HiddenFieldPageTables" value="CustomDocumentIndividualServiceNoteGenerals,CustomDocumentDBTs,CustomIndividualServiceNoteGoals,CustomIndividualServiceNoteObjectives,CustomIndividualServiceNoteDiagnoses" />
<asp:Panel ID="PanelMain" runat="server">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td style="margin-left: 0; margin-right: 0">
                <dxtc:ASPxPageControl ID="IndividualServiceNoteTabPageInstance" ClientInstanceName="IndividualServiceNoteTabPageInstance"
                    runat="server" ActiveTabIndex="0" CssFilePath="~/App_Themes/Styles/DevExpressTabStyles.css"
                    Width="100%" Paddings-Padding="0px" ContentStyle-Paddings-PaddingRight="0px"
                    ContentStyle-Paddings-PaddingLeft="0px" ContentStyle-BorderRight-BorderWidth="0"
                    ContentStyle-BorderLeft-BorderWidth="0px">
                    <ClientSideEvents TabClick="function(s, e) {        
        onTabSelected(s,e);      
       }" ActiveTabChanged="function(s, e) {onActiveTabChanged(s, e)}" />
                    <TabPages>
                        <dxtc:TabPage Text="General" Name="/Custom/IndividualServiceNote/WebPages/IndividualServiceNoteGeneral.ascx">
                            <ContentCollection>
                                <dxw:ContentControl ID="General" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                        <dxtc:TabPage Text="DBT" Name="/Custom/IndividualServiceNote/WebPages/IndividualServiceNoteDBT.ascx">
                            <ContentCollection>
                                <dxw:ContentControl Visible="false" ID="DBT" runat="server">
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
    </table>
<%--    <input id="HiddenField_DocumentVersions_Version" name="HiddenField_DocumentVersions_Version"
        type="hidden" value="-1" />
    <input id="HiddenField_Documents_DocumentId" name="HiddenField_Documents_DocumentId"
        type="hidden" value="0" />--%>
</asp:Panel>