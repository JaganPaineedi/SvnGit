<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DischargeMain.ascx.cs"
    Inherits="Custom_Discharge_WebPages_DischargeMain" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<script type="text/javascript" src="<%=RelativePath%>Custom/Discharge/Scripts/Discharge.js"></script>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class="content_tab_top1">
            <telerik:radtabstrip id="RadTabStrip1DischargeMainTabPage" skin="Vista" width="832px"
                onclienttabselected="onTabSelected" onclientload="StoreTabstripClientObject"
                runat="server" multipageid="RadMultiPageDischargeMainTabPage" selectedindex="5"
                enableembeddedscripts="False" enableembeddedskins="False">
                <Tabs>
                <telerik:RadTab Text="General" UcName="ContentControlGeneral" Path="/Custom/Discharge/WebPages/General.ascx"
                        runat="server">
                    </telerik:RadTab>
                   <telerik:RadTab Text="Progress Review" UcName="ContentControlProgressReview" Path="/Custom/Discharge/WebPages/ProgressReview.ascx"
                        runat="server">
                    </telerik:RadTab>     
                     <%--<telerik:RadTab Text="Demographics" UcName="ContentControlDemographics"  Path="/Custom/Discharge/WebPages/Demographics.ascx"
                        runat="server">
                    </telerik:RadTab>--%> 
                    <telerik:RadTab Text="Medications" UcName="ContentControlMedications"  Path="/Custom/Discharge/WebPages/Medications.ascx"
                        runat="server">
                    </telerik:RadTab>
                    <telerik:RadTab Text="Referrals/Disposition Plan" UcName="ContentControlReferralsDisposition"  Path="/Custom/Discharge/WebPages/ReferralsDisposition.ascx"
                        runat="server">
                    </telerik:RadTab> 
                     <telerik:RadTab Text="Diagnosis" UcName="ContentControlDiagnosis" Path="/Custom/Discharge/WebPages/Diagnosis.ascx"
                        runat="server">
                    </telerik:RadTab>                                   
                </Tabs>
            </telerik:radtabstrip>
            <telerik:radmultipage id="RadMultiPageDischargeMainTabPage" enableembeddedscripts="false"
                runat="server" selectedindex="0" cssclass="pageView">
                <telerik:RadPageView ID="ContentControlGeneral" runat="server">
                </telerik:RadPageView>
               <telerik:RadPageView ID="ContentControlProgressReview" runat="server">
                </telerik:RadPageView> 
                <%-- <telerik:RadPageView ID="ContentControlDemographics" runat="server">
                </telerik:RadPageView>--%>
                 <telerik:RadPageView ID="ContentControlMedications" runat="server">
                </telerik:RadPageView>  
                <telerik:RadPageView ID="ContentControlReferralsDisposition" runat="server">
                </telerik:RadPageView>
                  <telerik:RadPageView ID="ContentControlDiagnosis" runat="server">
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
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentDischarges,ClientPrograms,CustomDischargePrograms" />
