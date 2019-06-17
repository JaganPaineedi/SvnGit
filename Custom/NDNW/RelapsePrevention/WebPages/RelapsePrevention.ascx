<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RelapsePrevention.ascx.cs"
    Inherits="Custom_RelapsePrevention_WebPages_RelapsePrevention" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<script type="text/javascript" src="<%=RelativePath%>Custom/RelapsePrevention/Scripts/RelapsePrevention.js"></script>


<input type="hidden" id="HiddenFieldLifeDomain" runat="server" />

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class="content_tab_top1">
            <telerik:radtabstrip id="RadTabStrip1RelapsePreventionMainTabPage" skin="Vista" width="832px"
                onclienttabselected="onTabSelected" onclientload="StoreTabstripClientObject"
                runat="server" multipageid="RadMultiPageRelapsePreventionMainTabPage" selectedindex="1"
                enableembeddedscripts="False" enableembeddedskins="False">
                <Tabs>
                <telerik:RadTab Text="Plan Information" UcName="ContentControlGeneral" Path="/Custom/RelapsePrevention/WebPages/RelapsePreventionplan.ascx"
                        runat="server">
                    </telerik:RadTab>                        
                      <telerik:RadTab Text="Progress Review" UcName="ContentControlLifeDomain" Path="/Custom/RelapsePrevention/WebPages/LifeDomain.ascx"
                        runat="server">
                    </telerik:RadTab>                    
                    <telerik:RadTab Text="Summary" UcName="ContentControlSummary" Path="/Custom/RelapsePrevention/WebPages/Summary.ascx"
                        runat="server">
                    </telerik:RadTab>                                               
                </Tabs>
            </telerik:radtabstrip>
            <telerik:radmultipage id="RadMultiPageRelapsePreventionMainTabPage" enableembeddedscripts="false"
                runat="server" selectedindex="0" cssclass="pageView">
                <telerik:RadPageView ID="ContentControlGeneral" runat="server">
                </telerik:RadPageView>   
                 <telerik:RadPageView ID="ContentControlLifeDomain" runat="server">
                </telerik:RadPageView>                     
                <telerik:RadPageView ID="ContentControlSummary" runat="server">
                </telerik:RadPageView>                                     
            </telerik:radmultipage>
        </td>
    </tr>
    <tr>
        <td>
        </td>
    </tr>
</table>
<input id="HiddenField_DocumentVersions_Version" name="HiddenField_DocumentVersions_Version"
    type="hidden" value="-1" />
<input id="HiddenField_Documents_DocumentId" name="HiddenField_Documents_DocumentId"
    type="hidden" value="0" />
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentRelapsePreventionPlans,CustomRelapseLifeDomains,CustomRelapseGoals,CustomRelapseObjectives,CustomRelapseActionSteps" />