<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PsychiatricNoteMDM.ascx.cs" Inherits="Custom_PsychiatricNote_WebPages_PsychiatricNoteMDM" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc2" %>
<%@ Register assembly="DevExpress.Web.ASPxEditors.v11.2" namespace="DevExpress.Web.ASPxEditors" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.ASPxGridView.v11.2" namespace="DevExpress.Web.ASPxGridView" tagprefix="dx" %>
<% if (HttpContext.Current == null)
   { %>
<link href="<%= RelativePath%>App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralArrayHelpers.js"></script>

<script type="text/javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/GeneralFormFunctions.js"></script>

 <input runat="server" id="HiddenField_CustomDocumentConsentTreatments_AgencyName" name="HiddenField_CustomDocumentConsentTreatments_AgencyName" type="hidden" />
  <input runat="server" id="HiddenField_CustomDocumentConsentTreatments_AgencyaAbbreviation" name="HiddenField_CustomDocumentConsentTreatments_AgencyaAbbreviation" type="hidden" />
<div class="DocumentScreen">
    <div id="divPsychNoteTab" style="width: 810px;">
        <table width="810px" border="0" cellspacing="0" cellpadding="0">


            <tr>
                <td class="height2"></td>
            </tr>
            <tr>
                <td valign="top" align="left" width="100%">
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td align="left" width="100%" colspan="2">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="height1"></td>
                                    </tr>
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Data Reviewed
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" width="100%" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td class="content_tab_bg" style="padding-left: 10px">
                                <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                    <tr>
                                        <td class="height3"></td>
                                    </tr>
                                    <tr>
                                        <td align="center" style="width: 2%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewClinicalLabs"
                                                name="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewClinicalLabs" style="cursor: default" />
                                        </td>
                                        <td align="left" style="width: 18%; padding-left: 2px">
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewClinicalLabs" style="cursor: default">
                                                Review/Order Clinical Labs</label>
                                        </td>
                                        <td align="center" style="width: 2%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewRadiologyTest"
                                                name="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewRadiologyTest" style="cursor: default" />
                                        </td>
                                        <td align="left" style="width: 18%; padding-left: 2px">
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewRadiologyTest" style="cursor: default">
                                                Review/Order Radiology Test</label>
                                        </td>
                                        <td align="center" style="width: 2%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewOtherTest"
                                                name="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewOtherTest" style="cursor: default" />
                                        </td>
                                        <td align="left" style="width: 18%; padding-left: 2px">
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewOtherTest" style="cursor: default">
                                                Review/Order Other Test</label>
                                        </td>
                                        <td align="center" style="width: 2%">
                                          
                                        </td>
                                        <td align="left" style="width: 12%; padding-left: 2px">
                                          
                                        </td>

                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td align="center" style="width: 2%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_DiscussionOfTestResults"
                                                name="CheckBox_CustomDocumentPsychiatricNoteMDMs_DiscussionOfTestResults" style="cursor: default" />
                                        </td>
                                        <td align="left" style="width: 98%; padding-left: 2px" colspan="5">
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_DiscussionOfTestResults" style="cursor: default">
                                                Discussion of test results</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td align="center" style="width: 2%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_DecisionToObtainByOthers"
                                                name="CheckBox_CustomDocumentPsychiatricNoteMDMs_DecisionToObtainByOthers" style="cursor: default" />
                                        </td>
                                        <td align="left" style="width: 98%; padding-left: 2px" colspan="5">
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_DecisionToObtainByOthers" style="cursor: default">
                                                Decision to obtain records/history from someone other than the patient</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td align="center" style="width: 2%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewSummarizedOldRecords"
                                                name="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewSummarizedOldRecords" style="cursor: default" />
                                        </td>
                                        <td align="left" style="width: 98%; padding-left: 2px" colspan="5">
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_ReviewSummarizedOldRecords" style="cursor: default">
                                               Review/Summarized old records and/or obtain history from someone other than the patient, and/or discussion of case with another healthcare provider</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td align="center" style="width: 2%">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_IndependentVisualization"
                                                name="CheckBox_CustomDocumentPsychiatricNoteMDMs_IndependentVisualization" style="cursor: default" />
                                        </td>
                                        <td align="left" style="width: 98%; padding-left: 2px" colspan="5">
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_IndependentVisualization" style="cursor: default">
                                                Independent visualization of image, tracing, or specimen itself</label>
                                        </td>
                                    </tr>

                                </table>
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td class="height2"></td>
                                    </tr>
                                 
                                    <tr>
                                        <td>
                                            <table>

                                                <tr>
                                                    <td>This visit's Relevant Results
                                                    </td>
                                                    <td></td>
                                                    <td></td>
                                                    <td>Labs Ordered Last Visit
                                                    </td>

                                                </tr>
                                                <tr>
                                                    <td>
                                                        <textarea class="form_textarea" id="TextArea_CustomDocumentPsychiatricNoteMDMs_MedicalRecordsRelevantResults"
                                                            name="TextArea_CustomDocumentPsychiatricNoteMDMs_MedicalRecordsRelevantResults" rows="7" cols="80"
                                                            spellcheck="True" datatype="String"></textarea>

                                                    </td>
                                                    <td></td>
                                                    <td></td>
                                                    <td>
                                                        
                                                        <div id="MedicalRecordsLabsOrderedLastvisit" style="border: solid 1px #b1b1b1; background-color: #ffffff; overflow-y: scroll; height: 100px; width: 400px;"></div>

                                                    </td>


                                                </tr>

                                            </table>

                                        </td>

                                    </tr>

                                    <tr>
                                        <td></td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                <tr>
                                                    <td>Lab orders/results
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                          <table width="100%" cellpadding="0" cellspacing="0" border="0" >                        
                                               <dxwgv:ASPxGridView ID="GridViewLaborders"    runat="server" AutoGenerateColumns="False"  onrowdatabound="GridViewLaborders_RowDataBound" 
                                                KeyFieldName="ClientOrderId" Width="97%"   ClientInstanceName="grid" >
                                                <Settings ShowColumnHeaders="true" GridLines="None" />                                    
                                                <Styles AlternatingRow-BackColor="#f0f6f9" Header-CssClass="HeaderStyle" AlternatingRow-CssClass="" Row-CssClass=" "></Styles>
                                                <ClientSideEvents ColumnSorting="function(s, e) {                         
                                                GridSortEventClick(s,e);
                                                e.cancel=true;                                                             
                                                }" />
                                                         
                                                <Columns>
                                                        <dxwgv:GridViewDataTextColumn Caption="Effective Date" FieldName="EffectiveDate" VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                                        <DataItemTemplate>
                                                           <%# Eval("EffectiveDate")%>
                                                                                  
                                                        </DataItemTemplate>
                                                     </dxwgv:GridViewDataTextColumn>
                                                                       
                                                   <dxwgv:GridViewDataTextColumn Caption="Lab" FieldName="OrderName" VisibleIndex="1" CellStyle-HorizontalAlign="Left" CellStyle-CssClass="Color:blue;" >
                                                        <DataItemTemplate>
                                                          <%-- <%# Eval("OrderName")%>--%>
                                                          <%# "<div style=\"cursor:hand;\"  class=\"ellipsis ordertooltip\"  onclick=\"OpenPage(5761,'778','ClientOrderId=" + Eval("ClientOrderId") + "',2,'" + Page.ResolveUrl("~/") + "');\"><u>" + "<span  id =\"spnloadorderdetails\">" +  SHS.BaseLayer.BaseCommonFunctions.TrancateElementText(Eval("OrderName"), 100) +"</span>" +"</u><div id='divToolTip' style='display:none'>" + "</div>" + "</div>"%>              
                                                        </DataItemTemplate>
                                                    </dxwgv:GridViewDataTextColumn>
                                        
                                                    <dxwgv:GridViewDataTextColumn Caption="Description" FieldName="OrderDescription" VisibleIndex="1" CellStyle-HorizontalAlign="Left">
                                                        <DataItemTemplate>
                                                           <%# Eval("OrderDescription")%>
                                                                                  
                                                        </DataItemTemplate>
                                                    </dxwgv:GridViewDataTextColumn>
    
                                               </Columns>
                                   
                                                <SettingsBehavior ColumnResizeMode="NextColumn" />
                                                <SettingsBehavior AllowSort="true" />
                                                <Styles Cell-Wrap="False" ></Styles> 
                                            </dxwgv:ASPxGridView>   
                                            </table>

                                                       
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>

                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="right_bottom_cont_bottom_bg" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                        </td>
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
           
              <tr>
                <td class="height2"></td>
            </tr>

               <tr>
                <td valign="top" align="left" width="100%">
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                   <tr>
                <td class="height2"></td>
            </tr> 
            <tr>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td class="content_tab_left" align="left" nowrap='nowrap'>Plan
                            </td>
                            <td width="17">
                                <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                            </td>
                            <td class="content_tab_top" width="100%" />
                            <td width="7">
                                <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="content_tab_bg" style="padding-left: 10px">
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td class="height2"></td>
                        </tr>
                        <tr>
                            <td class="form_label_text" align="left" valign="top">Plan – Last Visit
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" width="100%" style="padding-top: 2px;">
                                <textarea id="TextArea_CustomDocumentPsychiatricNoteMDMs_PlanLastVisitMDM" class="form_textareaWithoutWidth"
                                    name="TextArea_CustomDocumentPsychiatricNoteMDMs_PlanLastVisitMDM" rows="4" style="width:95%;" disabled="disabled"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td class="height2"></td>
                        </tr>

                        <tr>
                            <td style="width: 100%; padding-left: 0px;" align="left">
                                <div>
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td align="left" style="width: 58%">
                                                <span id="Span1">Patient/Parent/Guardian voiced understanding and gave consent for the below plan.</span>
                                            </td>
                                            <td align="center" style="width: 2%">
                                                <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteMDMs_PatientConsent_Y" value="Y"
                                                    name="RadioButton_CustomDocumentPsychiatricNoteMDMs_PatientConsent" style="cursor: default" />
                                            </td>
                                            <td align="left" style="width: 4%; padding-left: 2px">
                                                <label for="RadioButton_CustomDocumentPsychiatricNoteMDMs_PatientConsent_Y" style="cursor: default">
                                                    Yes</label>
                                            </td>
                                            <td align="center" style="width: 2%">
                                                <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteMDMs_PatientConsent_N"
                                                    value="N" name="RadioButton_CustomDocumentPsychiatricNoteMDMs_PatientConsent" style="cursor: default" />
                                            </td>
                                            <td align="left" style="width: 36%; padding-left: 2px">
                                                <label for="RadioButton_CustomDocumentPsychiatricNoteMDMs_PatientConsent_N" style="cursor: default">
                                                    No</label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="height2"></td>
                        </tr>

                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td style="width:70%;" class="form_label_text" align="left" valign="top">Plan
                                        </td>
                                        <td style="width:30%;" class="form_label_text" align="left" valign="top">Next Physician's Visit
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:70%;">
                                            <textarea id="TextArea_CustomDocumentPsychiatricNoteMDMs_PlanComment" class="form_textareaWithoutWidth"
                                                name="TextArea_CustomDocumentPsychiatricNoteMDMs_PlanComment" rows="4" style="width:95%;"></textarea>
                                        </td>
                                        <td style="width:30%;">
                                            <textarea id="TextArea_CustomDocumentPsychiatricNoteMDMs_NextPhysicianVisit" class="form_textareaWithoutWidth"
                                                name="TextArea_CustomDocumentPsychiatricNoteMDMs_NextPhysicianVisit" rows="4"  style="width:95%;"></textarea>
                                        </td>
                                    </tr>
                                </table>
                            </td>

                        </tr>
                        <tr>
                            <td align="left" valign="top" width="100%" style="padding-top: 2px;"></td>
                        </tr>

                        <tr>
                            <td class="height2"></td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 100%" class="checkbox_container">
                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_MoreThanFifty"
                                    name="CheckBox_CustomDocumentPsychiatricNoteMDMs_MoreThanFifty" style="cursor: default" />
                                <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_MoreThanFifty" style="cursor: default">
                                    More than 50% of my time was spent in counselling and/or coordination of care with or on behalf of this patient.</label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td class="right_bottom_cont_bottom_bg" width="2">
                                <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                            </td>
                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                            <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

                        </table>
                    </td>
                   </tr>
            <tr>
                <td valign="top" class="height2">&nbsp;
                </td>
            </tr>
            <tr>
                <td valign="top" align="left" width="100%">
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td align="left" width="100%" colspan="2">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="height1"></td>
                                    </tr>
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Orders
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" width="100%" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" class="content_tab_bg_padding" align="left" width="100%">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td colspan="5" class="height1">&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="form_label_text" colspan="5" align="left" valign="top">Ordered Labs/Tests/Consultations
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="height2" colspan="5"></td>
                                    </tr>
                                    <tr>
                                        <td style="width: 10%; padding-left: 0px;" align="left" class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_LabOrder" name="CheckBox_CustomDocumentPsychiatricNoteMDMs_LabOrder" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_LabOrder">
                                                Labs</label>
                                        </td>
                                        <td style="width: 10%; padding-left: 0px;" align="left" class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_EKG" name="CheckBox_CustomDocumentPsychiatricNoteMDMs_EKG" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_EKG">
                                                EKG</label>
                                        </td>
                                        <td style="width: 10%; padding-left: 0px;" align="center" class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_RadiologyOrder" name="CheckBox_CustomDocumentPsychiatricNoteMDMs_RadiologyOrder" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_RadiologyOrder">
                                                Radiology</label>
                                        </td>
                                        <td style="width: 11%; padding-left: 0px;" align="left" class="checkbox_container">
                                            <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_Consultations" name="CheckBox_CustomDocumentPsychiatricNoteMDMs_Consultations" />
                                            <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_Consultations">
                                                Consultations</label>
                                        </td>
                                        <td style="width: 60%; padding-left: 110px;" align="right">
                                            <input type="button" id="Button_CustomDocumentPsychiatricNoteMDMs_PlaceOrder" name="Button_CustomDocumentPsychiatricNoteMDMs_PlaceOrder"
                                                class="more_detail_btn_120" value="Place Orders" />&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="5" class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="5" align="left" width="100%" style="padding-left: 0px;">
                                            <textarea id="TextArea_CustomDocumentPsychiatricNoteMDMs_OrdersComments" class="form_textareaWithoutWidth"
                                                name="TextArea_CustomDocumentPsychiatricNoteMDMs_OrdersComments" rows="5" style="width:95%;" spellcheck="True"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="5" class="height2"></td>
                                    </tr>
                                    <tr>
                                        <td class="form_label_text" colspan="5" align="left" valign="top">Labs Last Ordered
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="5" class="height2"></td>
                                        <tr>
                                            <td colspan="5" align="left" width="100%" style="padding-left: 0px;">
                                                <%--<textarea id="TextArea_CustomDocumentPsychiatricNoteMDMs_LabsLastOrder" class="form_textareaWithoutWidth"
                                                name="TextArea_CustomDocumentPsychiatricNoteMDMs_LabsLastOrder" rows="5" cols="159" spellcheck="True"></textarea>--%>
                                                <div id="LabsLastOrder" style="border: solid 1px #b1b1b1; background-color: #ffffff; overflow-y: scroll; height: 100px; width: 800px"></div>
                                            </td>
                                        </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="right_bottom_cont_bottom_bg" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                        </td>
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" class="height2">&nbsp;
                </td>
            </tr>
            <tr>
                <td valign="top" align="left">
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Medications
                                        </td>
                                        <td width="17">
                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                        </td>
                                        <td class="content_tab_top" width="100%" />
                                        <td width="7">
                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" class="content_tab_bg_padding" align="left">
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td valign="top" style="width: 100%; padding-left: 0px">
                                            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td colspan="2" class="form_label_text" align="left">The information displayed in the SmartCare Rx section is entered into the SmartCare
                                                    Rx module and current read only information as applicable on the date of service
                                                    is specified below.
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height1">&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" >
                                                        <table cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td style="width:25%">
                                                                    <input type="button" id="Button_CustomDocumentPsychiatricNoteMDMs_OpenSmartCareRX" name="Button_CustomDocumentPsychiatricNoteMDMs_OpenSmartCareRX"
                                                                        class="more_detail_btn_120" value="Open  SmartCare RX" />&nbsp;
                                                                </td>
                                                                <td style="padding-left: 5px;" style="width:25%">
                                                                    <table cellpadding="0" cellspacing="0">
                                                                        <tr>
                                                                            <td class="glow_lt" width="3px" align="right"></td>
                                                                            <td class="glow_mid">
                                                                                <input type="button" id="Button_CustomDocumentPsychiatricNoteMDMs_ViewMedicationHistoryReport"
                                                                                    name="Button_CustomDocumentPsychiatricNoteMDMs_ViewMedicationHistoryReport" class="Button"
                                                                                    value="View Medication History Report" />
                                                                            </td>
                                                                            <td class="glow_rt" width="3px" align="left"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td style="padding-right: 10px;width:25%" align="left" class="checkbox_container" >
                                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_OrderedMedications" name="CheckBox_CustomDocumentPsychiatricNoteMDMs_OrderedMedications" />
                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_OrderedMedications" id="Label1"
                                                                        name="SpanRisksBenefit">
                                                                        Medications Being Ordered Today</label>
                                                                </td>
                                                                 <td style="width:20%" align="left" class="checkbox_container">
                                                                    <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricNoteMDMs_MedicationReconciliation" name="CheckBox_CustomDocumentPsychiatricNoteMDMs_MedicationReconciliation" />
                                                                    <label for="CheckBox_CustomDocumentPsychiatricNoteMDMs_MedicationReconciliation" id="lblCheckBox_CustomDocumentPsychiatricNoteMDMs_MedicationReconciliation"
                                                                        name="SpanRisksBenefit">
                                                                        Medication Reconciliation</label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height1">&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 100%; padding-left: 0px;" align="left">
                                                        <div>
                                                            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                                <tr>
                                                                    <td align="left" style="width: 42%">
                                                                        <span id="Span_RisksBenefits">Risk/benefits/side effects have been discussed  with the client and understood</span>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits_Y" value="Y"
                                                                            name="RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits" onchange="NursemoniterOther();" style="cursor: default" />
                                                                    </td>
                                                                    <td align="left" style="width: 4%; padding-left: 2px">
                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits_Y" style="cursor: default">
                                                                            Yes</label>
                                                                    </td>
                                                                    <td align="center" style="width: 2%">
                                                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits_N"
                                                                            value="N" name="RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits" onchange="NursemoniterOther();" style="cursor: default" />
                                                                    </td>
                                                                    <td align="left" style="width: 4%; padding-left: 2px">
                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits_N" style="cursor: default">
                                                                            No</label>
                                                                    </td>

                                                                    <td align="center" style="width: 2%">
                                                                        <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits_A"
                                                                            value="A" name="RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits" onchange="NursemoniterOther();" style="cursor: default" />
                                                                    </td>
                                                                    <td align="left" style="width: 4%; padding-left: 2px">
                                                                        <label for="RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits_A" style="cursor: default">
                                                                            N/A</label>
                                                                    </td>

                                                                    <td align="left" style="width: 50%; padding-left: 2px">
                                                                        <input type="text" id="TextBox_CustomDocumentPsychiatricNoteMDMs_RisksBenefitscomment" name="TextBox_CustomDocumentPsychiatricNoteMDMs_RisksBenefitscomment"
                                                                            class="form_textbox" style="width: 250px" />
                                                                    </td>
                                                                  
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>

                                                <tr>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                            <tr>
                                                                <td align="left" style="width: 85%">
                                                                    <span class="form_label_text" id="SpanCurrentMedications" name="SpanCurrentMedications">Current Medications</span>
                                                                </td>
                                                                <td style="width: 20px"></td>
                                                                <td>
                                                                    <table border="0" cellspacing="0" cellpadding="0" id="TableBtn">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="glow_lt">&nbsp;
                                                                                </td>
                                                                                <td class="glow_mid">
                                                                                    <input id="MedicationNote" style="width: auto;" value="Refresh" type="button" class="Button" />
                                                                                </td>
                                                                                <td class="glow_rt">&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" align="left" style="width: 100%; padding-top: 2px;">
                                                        <div id="divCurrentMedications" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; overflow-y: scroll; height: 100px; width: 797px">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height1">&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <span class="form_label_text" id="SpanCurrentMedicationsOrderdBySC" name="SpanCurrentMedicationsOrderdBySC">Not Ordered by <%=HiddenField_CustomDocumentConsentTreatments_AgencyName.Value %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" align="left" style="width: 100%; padding-top: 2px;">
                                                        <div id="divCurrentMedicationsNotOrderdBySC" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; overflow-y: scroll; height: 100px; width: 797px">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" style="width: 100%;">
                                                        <span class="form_label_text" id="SpanMedicationsdiscontinued" name="SpanMedicationsdiscontinued">Medications Discontinued This Visit</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top" align="left" style="width: 100%; padding-top: 2px;">
                                                     
                                                        <div id="MedicationsDiscontinued" style="border: solid 1px #b1b1b1; background-color: #f5f5f5; overflow-y: scroll; height: 100px; width: 797px">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td class="height2"></td>
                                                </tr>
                                                <tr>
                                                    <td class="form_label_text" align="left" valign="top">Information and Education
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="top" width="100%" style="padding-top: 2px;">
                                                        <textarea id="TextArea_CustomDocumentPsychiatricNoteMDMs_InformationAndEducation" class="form_textareaWithoutWidth"
                                                            name="TextArea_CustomDocumentPsychiatricNoteMDMs_InformationAndEducation" rows="4" style="width:95%;"></textarea>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                    <tr>
                                        <td class="right_bottom_cont_bottom_bg" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                                        </td>
                                        <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                        <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                            <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            <tr>
                <td valign="top" class="height2">&nbsp;
                </td>
            </tr>

                           <tr>
                <td valign="top" align="left" width="100%">
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                   
            <tr>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td class="content_tab_left" align="left" nowrap='nowrap'>Level of Risk
                            </td>
                            <td width="17">
                                <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                            </td>
                            <td class="content_tab_top" width="100%" />
                            <td width="7">
                                <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="content_tab_bg" style="padding-left: 10px">
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td class="height2"></td>
                        </tr>
          
                        <tr>
                            <td style="width: 100%; padding-left: 0px;" align="left">
                                <div>
                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                        <tr>
                                            <td align="left" style="width:20%">
                                                <span id="Span2">Level of Risk</span>
                                            </td>
                                            <td align="center" style="width: 2%">
                                                <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk_M" value="M"
                                                    name="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk" style="cursor: default" />
                                            </td>
                                            <td align="left" style="width: 10%; padding-left: 2px">
                                                <label for="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk_M" style="cursor: default">
                                                    Minimal</label>
                                            </td>
                                            <td align="center" style="width: 2%">
                                                <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk_L"
                                                    value="L" name="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk" style="cursor: default" />
                                            </td>
                                            <td align="left" style="width: 10%; padding-left: 2px">
                                                <label for="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk_L" style="cursor: default">
                                                    Low</label>
                                            </td>
                                              <td align="center" style="width: 2%">
                                                <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk_O" value="O"
                                                    name="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk" style="cursor: default" />
                                            </td>
                                            <td align="left" style="width: 10%; padding-left: 2px">
                                                <label for="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk_O" style="cursor: default">
                                                    Moderate</label>
                                            </td>
                                            <td align="center" style="width: 2%">
                                                <input type="radio" id="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk_H"
                                                    value="H" name="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk" style="cursor: default" />
                                            </td>
                                            <td align="left" style="width: 10%; padding-left: 2px">
                                                <label for="RadioButton_CustomDocumentPsychiatricNoteMDMs_LevelOfRisk_H" style="cursor: default">
                                                    High</label>
                                            </td>
                                             <td align="left" style="width: 32%; padding-left: 2px">
                                                 </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="height2"></td>
                        </tr>

                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                        <tr>
                            <td class="right_bottom_cont_bottom_bg" width="2">
                                <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_left.gif" />
                            </td>
                            <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                            <td class="right_bottom_cont_bottom_bg" align="right" width="2">
                                <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

                          <tr>
                            <td class="height4"></td>
                        </tr>


                        </table>
                    </td>
                   </tr>

            <tr>
              
                <td style="visibility:hidden">
                      <div id="divProblemStatus">
                    <cc2:dropdownglobalcodes id="DropDownListCommon_CustomDocumentPsychiatricNoteMDMs_ProblemStatus"
                        name="DropDownListCommon_CustomDocumentPsychiatricNoteMDMs_ProblemStatus" runat="server"
                        cssclass="form_dropdown" width="250px" category="XPROBLEMSTATUS" addblankrow="true"
                        blankrowtext="">
                    </cc2:dropdownglobalcodes>
                     </div>
                </td>
            </tr>


        </table>
    </div>
</div>

