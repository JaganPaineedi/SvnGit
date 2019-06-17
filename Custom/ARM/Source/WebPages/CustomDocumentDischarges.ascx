<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomDocumentDischarges.ascx.cs"
    Inherits="SHS.SmartCare.CustomDocumentDischarges" %> 

<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.timeentry.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/Scripts/Validation.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js"></script>
<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.jec.js"></script>
<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/CustomDocumentDischarges.js" ></script>


<div>
    <table cellpadding="0" cellspacing="2" border="0" width="100%">
        <tr>
            <td>
                <dxtc:ASPxPageControl ID="CustomDocumentDischargesTabPage" runat="server" Width="100%" ActiveTabIndex="0"
                    EnableHierarchyRecreation="True" CssFilePath="~/App_Themes/Styles/DevExpressTabStyles.css"
                    ContentStyle-BorderLeft-BorderWidth="0px" ContentStyle-BorderRight-BorderWidth="0px"
                    ContentStyle-Paddings-PaddingLeft="0px" ContentStyle-Paddings-PaddingRight="0px"
                    Paddings-Padding="0px" Height="250"  EnableCallbackCompression="true">
                   <ClientSideEvents TabClick="function(s, e) { onTabSelected(s,e);}"
                                    ActiveTabChanged="function(s, e) {
	                                    onActiveTabChanged(s,e);
                                   }" ActiveTabChanging="function(s,e){ }" />
                    <TabPages>
                        <dxtc:TabPage Text="Discharge" Name="/Custom/WebPages/CustomDischarges.ascx">
                            <ContentCollection>
                                <dxw:ContentControl ID="ContentControlDischarge" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                    </TabPages>
                    <TabPages>
                        <dxtc:TabPage Text="Progress Toward ISP Goal" Name="/Custom/WebPages/CustomProgressTowardsISPGoal.ascx">
                            <ContentCollection>
                                <dxw:ContentControl ID="ContentControlProgressTowardsISPGoal" runat="server">
                                </dxw:ContentControl>
                            </ContentCollection>
                        </dxtc:TabPage>
                    </TabPages>
                </dxtc:ASPxPageControl>
            </td>
        </tr>
    </table>
    <input id="HiddenField_CustomDocumentDischarges_DocumentVersionId" name="HiddenField_CustomDocumentDischarges_DocumentVersionId"
        type="hidden" value="-1" />            
    <input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentDischarges,CustomDocumentDischargeGoals" />
</div>
