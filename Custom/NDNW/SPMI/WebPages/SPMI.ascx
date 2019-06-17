<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SPMI.ascx.cs" Inherits="Custom_SPMI_WebPages_SPMI" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<script type="text/javascript" src="<%=RelativePath%>Custom/SPMI/Scripts/SPMI.js"></script>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class="content_tab_top1">
            <telerik:radtabstrip id="RadTabStrip1SPMIMainTabPage" skin="Vista" width="832px"
                onclienttabselected="onTabSelected" onclientload="StoreTabstripClientObject"
                runat="server" multipageid="RadMultiPageSPMIMainTabPage" selectedindex="1" enableembeddedscripts="False"
                enableembeddedskins="False">
                <Tabs>
                <telerik:RadTab Text="" UcName="ContentControlGeneral" Path="/Custom/SPMI/WebPages/SPMIGeneral.ascx"
                        runat="server">
                    </telerik:RadTab>                                                   
                </Tabs>
            </telerik:radtabstrip>
            <telerik:radmultipage id="RadMultiPageSPMIMainTabPage" enableembeddedscripts="false"
                runat="server" selectedindex="0" cssclass="pageView">
                <telerik:RadPageView ID="ContentControlGeneral" runat="server">
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
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentSPMIs" />
