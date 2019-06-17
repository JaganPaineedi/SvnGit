<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SUAdmission.ascx.cs" Inherits="Custom_SUAdmission_WebPages_SUAdmission" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<script type="text/javascript" src="<%=RelativePath%>Custom/SUAdmission/Scripts/SUAdmission.js"></script>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class="content_tab_top1">
            <telerik:radtabstrip id="RadTabStrip1SUAdmissionTabPage" skin="Vista" width="832px"
                onclienttabselected="onTabSelected" onclientload="StoreTabstripClientObject"
                runat="server" multipageid="RadMultiPageSUAdmissionTabPage" selectedindex="5"
                enableembeddedscripts="False" enableembeddedskins="False">
                <Tabs>
                <telerik:RadTab Text="General" UcName="ContentControlGeneral" Path="/Custom/SUAdmission/WebPages/General.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Substance Use" UcName="ContentControlSubstanceuse" Path="/Custom/SUAdmission/WebPages/Substanceuse.ascx"
                        runat="server">
                    </telerik:RadTab>     
                     <telerik:RadTab Text="Diagnosis" UcName="ContentControlDiagnosis" Path="/Custom/SUAdmission/WebPages/Diagnosis.ascx"
                        runat="server">
                            
                    </telerik:RadTab>                                    
               
                         <telerik:RadTab Text="Infectious Disease Risk Assessment" UcName="ContentInfectiousDiseaseRiskAssessment" Path="/Custom/SUAdmission/WebPages/InfectiousDiseaseRiskAssessment.ascx"
                        runat="server">
                    </telerik:RadTab>                                    
                </Tabs>
            </telerik:radtabstrip>
            <telerik:radmultipage id="RadMultiPageSUAdmissionTabPage" enableembeddedscripts="false"
                runat="server" selectedindex="0" cssclass="pageView">
                <telerik:RadPageView ID="ContentControlGeneral" runat="server">
                </telerik:RadPageView>
                <telerik:RadPageView ID="ContentControlSubstanceuse" runat="server">
                </telerik:RadPageView> 
                 <telerik:RadPageView ID="ContentControlDiagnosis" runat="server">
                </telerik:RadPageView>  
                 <telerik:RadPageView ID="ContentInfectiousDiseaseRiskAssessment" runat="server">
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
<input type="hidden" id="HiddenField_CustomDocumentInfectiousDiseaseRiskAssessments_DocumentVersionId"
    name="HiddenField_CustomDocumentInfectiousDiseaseRiskAssessments_DocumentVersionId"
    value="-1" />
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentSUAdmissions,CustomDocumentInfectiousDiseaseRiskAssessments" />
