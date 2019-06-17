<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomCrisisInterventionsDocument.ascx.cs" 
    Inherits="SHS.SmartCare.CustomCrisisInterventionsDocument" 
%>





<div>
    <table cellpadding="0" cellspacing="2" border="0" width="100%">
        <tr>
            <td>                
                <dxtc:ASPxPageControl ID="CustomFultonSchoolCrisisNoteDocumentTabPage" runat="server" Width="100%" ActiveTabIndex="0"
                    EnableHierarchyRecreation="True" CssFilePath="~/App_Themes/Styles/DevExpressTabStyles.css"
                    ContentStyle-BorderLeft-BorderWidth="0px" ContentStyle-BorderRight-BorderWidth="0px"
                    ContentStyle-Paddings-PaddingLeft="0px" ContentStyle-Paddings-PaddingRight="0px"
                    Paddings-Padding="0px" Height="250">
                   <ClientSideEvents TabClick="function(s, e) { onTabSelected(s,e); }"
                                    ActiveTabChanged="function(s, e) {
	                                    onActiveTabChanged(s,e);
                                   }" />
                    <TabPages>
                        <dxtc:TabPage Text="Crisis Assessment" Name="/Custom/WebPages/CustomCrisisInterventionsAssessment.ascx">
                            <ContentCollection>
                                <dxw:ContentControl ID="ContentControlCrisisNote" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                    </TabPages>
<%--                    <TabPages>
                        <dxtc:TabPage Text="Mental Status" Name="/ActivityPages/Harbor/Client/Detail/Documents/MedNote/MedNoteMentalStatus.ascx">
                            <ContentCollection>
                                <dxw:ContentControl ID="ContentControlMentalStatus" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                    </TabPages>
                    <TabPages>
                        <dxtc:TabPage Text="Crisis Plan" Name="/ActivityPages/Harbor/Client/Detail/Documents/CustomCrisisInterventionsPlans.ascx">
                            <ContentCollection>
                                <dxw:ContentControl ID="ContentControlCrisisPlan" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                    </TabPages>
--%>                </dxtc:ASPxPageControl>
            </td>
        </tr> 
    </table>
    <input id="HiddenField_CustomFultonSchoolCrisisNote_DocumentVersionId" name="HiddenField_CustomDocumentCrisisInterventionNotes_DocumentVersionId" type="hidden" value="-1" />
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentCrisisInterventionNotes,CustomDocumentMentalStatuses" />
    <input id="Hidden1" name="HiddenField_CustomDocumentMentalStatuses_DocumentVersionId" type="hidden" value="-1" />

</div>