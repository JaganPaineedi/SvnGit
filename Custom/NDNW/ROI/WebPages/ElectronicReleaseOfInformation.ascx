<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ElectronicReleaseOfInformation.ascx.cs"
    Inherits="NewaygoElectronicReleaseOfInformation" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>    
    
    <script src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js" type="text/javascript"></script>
   <script src="<%=RelativePath%>Custom/ROI/Scripts/StJoeReleaseOfInformation.js"
    type="text/javascript"></script>
    <input type="hidden" id="HiddenFieldPageTables" name="HiddenFieldPageTables" value="CustomDocumentReleaseOfInformations" runat="server" />
    <input type="hidden" id="HiddenFieldRelativePath" name="HiddenFieldRelativePath" runat="server" />
    
<asp:Panel ID="PanelMainCentraWellnessROI" runat="server" CssClass="DocumentScreen">
    <table id='TableCentraWellnessROIMain' style='width: 830px;' border='0' cellpadding='0'
        cellspacing='0' bindautosaveevents='False' >
        <tr>
            <td style='width: 100%'>
                <table style="width: 100%" border="0" cellpadding="0" cellspacing="0" 
                    id="TableMainContainer">
                    <%--<tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" width="23%">
                                        Release of Information
                                    </td>
                                    <td width="1%">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="78%">
                                    </td>
                                    <td width="1%">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                            height="26" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%>
                    <tr>
                        <td >
                            <table>
                                <tr>
                                    <td>
                                        <div id="DivROIContentMain" style="padding-top: 10px;">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style='height: 15px;'>
                                    </td>
                                </tr>
                                <tr>
                                    <td align='left'>
                                        <table border='0' cellpadding='0' cellspacing='0' width='100%'>
                                            <tr>
                                                <td width='1%'>
                                                    &nbsp;
                                                </td>
                                                <td align='left'>
                                                    <span name='Span_CustomDocumentCentraWellnessROI_AddROI' id='Span_CustomDocumentCentraWellnessROI_AddROI' style='text-decoration: underline;
                                                        cursor: hand; color: Blue; font-size: 11px;' onclick = "AddNewCentraWellnessROI('ROITab',undefined)";
                                                        onkeypress="if(event.keyCode==13){ AddNewCentraWellnessROI('ROITab',undefined) }"
                                                        tabindex='0' onfocus="this.style.fontWeight='bold'" onblur="this.style.fontWeight='normal'" >Add Another Person/Entity</span>
                                                        
                                                </td>
                                                <td width='1%'>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td align='right' style="padding-right: 15px">
                                                    <span name='ClearROI_1' id='ClearROI_1' style='text-decoration: underline;cursor: hand; color: Blue; font-size: 11px' onclick = "ClearROI(0)" onfocus="this.style.fontWeight='bold'" onblur="this.style.fontWeight='normal'" >Clear</span>&nbsp;&nbsp;<span name='ShowAllROI_1' id='ShowAllROI_1' style='text-decoration: underline;
                                                        cursor: hand; color: Blue; font-size: 11px' onclick = "showALLROI()";
                                                        tabindex='0' onfocus="this.style.fontWeight='bold'" onblur="this.style.fontWeight='normal'" >ALL</span>&nbsp;&nbsp;<img id="MovePrev" alt="Prev" src="<%=RelativePath%>App_Themes/Includes/Images/blue_left_arrow.gif" style="cursor: hand;text-align: center;vertical-align:bottom;" onclick= "ShowROI('-1')" onfocus="this.style.fontWeight='bold'" onblur="this.style.fontWeight='normal'" />&nbsp;<input type="text" class="form_textbox" style="width: 20px;text-align:center;" value=""  disabled="disabled" id="ROI_CurrentNumber" name="ROI_CurrentNumber"/><b>&nbsp;of&nbsp;</b><input type="text" class="form_textbox" style="width: 20px;text-align:center;" disabled="disabled" id="ROI_TotalNumber" />&nbsp;<img  id="MoveNext" src="<%=RelativePath%>App_Themes/Includes/Images/blue_right_arrow.gif"  onclick= "ShowROI('1')" onfocus="this.style.fontWeight='bold'" onblur="this.style.fontWeight='normal'" style="cursor: hand;text-align: center;vertical-align:bottom;" alt="Next"/>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                  <%--  <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="1%" class="right_bottom_cont_bottom_bg">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                            height="7" alt="" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="98%">
                                    </td>
                                    <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%>
                </table>
            </td>
        </tr>
    </table>
    <input type="hidden" runat="server" id="HiddenField_CentraWellnessROIJSONData" />
    <div id="DivReleaseToFromDropDown" style="visibility:hidden;">
         <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentReleaseOfInformations_ReleaseToReceiveFrom"
          runat="server" Width="60px" parentchildcontrols="True">
            
        </cc2:StreamlineDropDowns>
        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentReleaseOfInformations_ReleasedState" Name="DropDownList_CustomDocumentReleaseOfInformations_ReleasedState" 
                                                                    runat="server"  Width="60px" parentchildcontrols="True">
                                                                </cc2:StreamlineDropDowns>
                                                                
     </div>
</asp:Panel>
<asp:panel id="PanelCustomAjax" runat="server">
</asp:panel>
<script id="ROITemplate"  type="text/x-jquery-tmpl">
<div id="div_TableMainCentraWellnessROIMain_${ROIId}">
   <table id="TableMainCentraWellnessROIMain_${ROIId}" width="100%" cellpadding="0" cellspacing="0" border="0">
      <tr>
         <td colspan="5" class="height16"></td>
      </tr>
      <tr>
         <td colspan="5" align="left" style="padding-right: 5px">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr>
                  <td class="content_tab_left" align="left" width="23%">
                     #${ReleaseOfInformationOrder}&nbsp;Release of Information
                  </td>
                  <td width="1%">
                     <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif" height="26" alt="" />
                  </td>
                  <td class="content_tab_top" width="78%">
                  </td>
                  <td width="1%">
                     <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif" height="26" alt="" />
                  </td>
               </tr>
            </table>
         </td>
      </tr>
      <tr>
         <td align="left" style="padding-right: 5px">
            <table cellspacing="0" cellpadding="0" border="0" width="800px">
               <tr>
                  <td align="left" style="padding-right: 5px" class="content_tab_bg_padding">
                     <table cellspacing="0" cellpadding="0" border="0" width="800px">
                        <tr>
                           <td>
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                 <tr>
                                            <td colspan="5" class="height16"></td>
                                            </tr>
                                 <tr>
                                    <td align="left" style="padding-right: 5px">
                                       <table cellspacing="0" cellpadding="0" border="0" width="800px">
                                          <tr>
                                             <td>
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                   <tr>
                                                      <td class="height16">
                                                      </td>
                                                      <td class="content_tab_left" align="left" nowrap="nowrap">
                                                         Release To/Release From
                                                      </td>
                                                      <td width="17">
                                                         <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                      </td>
                                                      <td class="content_tab_top" width="100%">
                                                      </td>
                                                      <td width="7">
                                                         <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                      </td>
                                                   </tr>
                                                </table>
                                             </td>
                                          </tr>
                                          <tr>
                                            <td  class="content_tab_bg" style="padding-right: 8px; padding-left: 4px">
                                               <table cellspacing="0" cellpadding="0" border="0"  width="800px">
                                                  <tr>
                                                     <td>
                                                        <table>
                                                           <tr>
                                                              <td width="5px" class="" style="text-align: left">
                                                                 <input type="checkbox" class="cursor_Maindefault" id="checkbox_CustomDocumentReleaseOfInformations_${ROIId}_GetInformationFrom"
                                                                 name="checkbox_CustomDocumentReleaseOfInformations_${ROIId}_GetInformationFrom" value="Y" bindautosaveevents='False'    {{if GetInformationFrom=='Y'}}
                                                                 checked='checked'
                                                                 {{/if}}/>
                                                              </td>
                                                              <td style="text-align: left; width: 120px" class="style2">
                                                                 <label for="checkbox_CustomDocumentReleaseOfInformations_${ROIId}_GetInformationFrom" class="cursor_Maindefault">
                                                                 Get information from</label>
                                                              </td>
                                                              <td style="text-align: center; width: 100px" class="style2">
                                                                 and/or
                                                              </td>
                                                              <td width="5px" class="" style="text-align: left">
                                                                 <input type="checkbox" class="cursor_Maindefault" id="checkbox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseInformationFrom"
                                                                 name="checkbox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseInformationFrom" value="Y" bindautosaveevents='False'   {{if ReleaseInformationFrom=='Y'}}
                                                                 checked='checked'
                                                                 {{/if}}/>
                                                              </td>
                                                              <td style="text-align: left; width: auto" class="style2">
                                                                 <label for="checkbox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseInformationFrom" class="form_label cursor_Maindefault">
                                                                 Release private (confidential) information to the following person(s) and/or entity</label>
                                                              </td>
                                                           </tr>
                                                        </table>
                                                     </td>
                                                  </tr>
                                                  <tr>
                                                     <td class="height2">
                                                     </td>
                                                  </tr>
                                                  <tr>
                                                     <td>
                                                        <table>
                                                           <tr>
                                                              <td width="25px" class="" style="text-align: left">
                                                                 <input type="button" class="less_detail_btn" id="button_CustomDocumentReleaseOfInformations_${ROIId}_OpenContacts" name="button_CustomDocumentReleaseOfInformations_${ROIId}_OpenContacts" onclick="OpenContacts()" bindautosaveevents="False" value="Open Contacts" />
                                                              </td>
                                                              <td style="text-align: center; width: 10px" class="style2">
                                                              </td>
                                                              <td width="5px" class="" style="text-align: left">
                                                                 <input type="button" visible="false" style='visibility:hidden' class="more_detail_btn_120" id="button_CustomDocumentReleaseOfInformations_${ROIId}_RefreshContacts" name="button_CustomDocumentReleaseOfInformations_${ROIId}_RefreshContacts" bindautosaveevents="False" value="Refresh Contacts" />
                                                              </td>
                                                              <td width="">
                                                              </td>
                                                           </tr>
                                                        </table>
                                                     </td>
                                                  </tr>
                                                  <tr>
                                                     <td class="height2">
                                                     </td>
                                                  </tr>
                                                  <tr>
                                                     <td>
                                                        <table>
                                                           <tr>
                                                              <td width="5px" class="" style="text-align: right">
                                                                 <input type="radio" bindautosaveevents='False' onclick='ShowHideContacts(${ROIId},"O")' style='cursor: default;' id="Radio_CustomDocumentReleaseOfInformations_${ROIId}_O_ReleaseContactType"
                                                                 name="Radio_CustomDocumentReleaseOfInformations_${ROIId}_O_ReleaseContactType" value='O'   {{if ReleaseContactType == 'O'}} checked='checked'
                                                                 {{/if}}/>
                                                              </td>
                                                              <td style="text-align: left; width: auto" class="style2">
                                                                 <label for="Radio_CustomDocumentReleaseOfInformations_${ROIId}_O_ReleaseContactType" class="form_label cursor_Maindefault">
                                                                 Organization</label>
                                                              </td>
                                                              <td style="text-align: center; width: 10px" class="style2">
                                                                 &nbsp; 
                                                              </td>
                                                              <td width="5px" class="" style="text-align: right">
                                                                 <input type="radio" bindautosaveevents='False'  style='cursor: default;' onclick='ShowHideContacts(${ROIId},"C")'  id="Radio_CustomDocumentReleaseOfInformations_${ROIId}_C_ReleaseContactType"
                                                                 name="radio_CustomDocumentReleaseOfInformations_${ROIId}_O_ReleaseContactType" value='C' {{if ReleaseContactType == 'C'}} checked='checked'
                                                                 {{/if}}/>
                                                              </td>
                                                              <td style="text-align: left; width: auto" class="style2">
                                                                 <label for="Radio_CustomDocumentReleaseOfInformations_${ROIId}_C_ReleaseContactType" class="form_label cursor_Maindefault">
                                                                 Contact</label>
                                                              </td>
                                                              <td width="">
                                                              </td>
                                                           </tr>
                                                        </table>
                                                     </td>
                                                  </tr>
                                                  <tr>
                                                     <td class="height2">
                                                     </td>
                                                  </tr>
                                                  <tr>
                                                     <td>
                                                        <div id="div_CentraWellnessROIContact_${ROIId}" style="display:none">
                                                           <table id="Table_CentraWellnessROIContact_${ROIId}" cellspacing="0" cellpadding="0" border="0"  width="800px">
                                                              <tr>
                                                                 <td>
                                                                    <table>
                                                                       <tr>
                                                                          <td width="140px" class="form_label" style="text-align: left">
                                                                             Name:
                                                                          </td>
                                                                          <td width="125px">
                                                                             <input type="text" bindautosaveevents="False" id="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseName" name="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseName" style="width: 150px" class="form_textbox" maxlength="100" value="${ReleaseName}" />
                                                                          </td>
                                                                          <td width="60px" class="form_label" style="text-align: left;padding-left: 10px">
                                                                             Address:
                                                                          </td>
                                                                          <td width="265px">
                                                                             <input type="text" bindautosaveevents="False" id="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseAddress" name="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseAddress" style="width: 265px" class="form_textbox" maxlength="100" value="${ReleaseAddress}" />
                                                                          </td>
                                                                       </tr>
                                                                    </table>
                                                                 </td>
                                                              </tr>
                                                              <tr>
                                                                 <td class="height2">
                                                                 </td>
                                                              </tr>
                                                              <tr>
                                                                 <td>
                                                                    <table>
                                                                       <tr>
                                                                          <td width="140px" class="form_label" style="text-align: left">
                                                                             City:
                                                                          </td>
                                                                          <td width="125px">
                                                                             <input type="text" bindautosaveevents="False" id="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseCity" name="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseCity" style="width: 150px" class="form_textbox" maxlength="30" value="${ReleaseCity}" />
                                                                          </td>
                                                                          <td width="60px" class="form_label" style="text-align: left;padding-left: 10px">
                                                                             State:
                                                                          </td>
                                                                          <td width="135px">
                                                                             <select ID="DropDownList_CustomDocumentReleaseOfInformations_${ROIId}_ReleasedState" name="DropDownList_CustomDocumentReleaseOfInformations_${ROIId}_ReleasedState" Class="form_dropdown" bindautosaveevents="False" Width="70px">
                                                                             {{html GetDropDownHtmlDropdowns("ReleaseState",ROIId,ReleasedState) }}
                                                                             </select>
                                                                          </td>
                                                                          <td width="40px" class="form_label" style="text-align: left;padding-left: 10px">
                                                                             Zip:
                                                                          </td>
                                                                          <td width="75px">
                                                                             <input type="text" id="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleasedZip" name="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleasedZip" style="width: 75px" class="form_textbox" bindautosaveevents="False" datatype="ZipCode" maxlength="12" value="${ReleasedZip}" />
                                                                          </td>
                                                                       </tr>
                                                                    </table>
                                                                 </td>
                                                              </tr>
                                                              <tr>
                                                                 <td class="height2">
                                                                 </td>
                                                              </tr>
                                                              <tr>
                                                                 <td>
                                                                    <table>
                                                                       <tr>
                                                                          <td width="140px" class="form_label" style="text-align: left">
                                                                             Phone Number:
                                                                          </td>
                                                                          <td width="150px">
                                                                             <input type="text" bindautosaveevents="False" id="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleasePhoneNumber" name="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleasePhoneNumber" style="width: 150px" class="form_textbox" datatype="PhoneNumber" maxlength="50" value="${ReleasePhoneNumber}" />
                                                                          </td>
                                                                       </tr>
                                                                    </table>
                                                                 </td>
                                                              </tr>
                                                           </table>
                                                        </div>
                                                     </td>
                                                  </tr>
                                                  <tr>
                                                     <td class="height2">
                                                     </td>
                                                  </tr>
                                                  <tr>
                                                     <td>
                                                        <table cellspacing="0" cellpadding="0" border="0"  width="800px">
                                                           <tr>
                                                              <td width="140px" class="form_label" style="text-align: left;padding-left: 5px">
                                                                 Release To/From:
                                                              </td>
                                                              <td width="160px">
                                                                 <select ID="DropDownList_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseToReceiveFrom" name="DropDownList_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseToReceiveFrom" bindautosaveevents="False" Class="form_dropdown" Width="160px">
                                                                 {{html GetDropDownHtmlDropdowns("ReleaseToReceiveFrom",ROIId,ReleaseToReceiveFrom) }}
                                                                 </select>
                                                              </td>
                                                              <td width="60px" class="form_label" style="text-align: left;padding-left: 11px">
                                                                 End Date:
                                                              </td>
                                                              <td style="padding-left: 2px">
                                                                 <table cellspacing="0" cellpadding="0" border="0" width="auto">
                                                                    <tr class="date_Container">
                                                                       <td>
                                                                          <input type="text" bindautosaveevents="False" id="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseEndDate" name="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseEndDate" class="date_text" datatype="Date" value="${ReleaseEndDate}" />
                                                                       </td>
                                                                       <td>
                                                                          &nbsp;
                                                                       </td>
                                                                       <td>
                                                                          <img id="img2" src="<%= WebsiteSettings.BaseUrl  %>App_Themes/Includes/Images/calender_grey.gif" style="cursor: pointer;" onclick="return showCalendar('TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleaseEndDate', '%m/%d/%Y');" filter="false" />
                                                                       </td>
                                                                    </tr>
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
                                             <td class="right_bottom_cont_bottom_bg" width="100%">
                                             </td>
                                             <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right" width="2">
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
                                    <td class="height2">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td align="left" style="padding-right: 5px">
                                       <table cellspacing="0" cellpadding="0" border="0" width="800px">
                                          <tr>
                                             <td>
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                   <tr>
                                                      <td class="height16">
                                                      </td>
                                                      <td class="content_tab_left" align="left" nowrap="nowrap">
                                                         Information To Be Released
                                                      </td>
                                                      <td width="17">
                                                         <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                      </td>
                                                      <td class="content_tab_top" width="100%">
                                                      </td>
                                                      <td width="7">
                                                         <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                      </td>
                                                   </tr>
                                                </table>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td class="content_tab_bg" style="padding-right: 8px; padding-left: 4px">
                                                <table cellspacing="0" cellpadding="0" border="0" width="800px">
                                                   <tr align="left">
                                                      <td>
                                                      </td>
                                                      <td colspan="4" width="100%">
                                                         <b>The information that can be obtained/disclosed under this authorization includes the following:</b>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td colspan="5" class="height2">
                                                         &nbsp;
                                                      </td>
                                                   </tr>
                                                   <tr align="left">
                                                      <td>
                                                      </td>
                                                      <td width="10px" class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_AssessmentEvaluation"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_AssessmentEvaluation"   {{if AssessmentEvaluation=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td width="350px" class="form_label">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_AssessmentEvaluation" class="form_label cursor_Maindefault">
                                                         Assessments/Evaluations</label>
                                                      </td>
                                                      <td width="10px" class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_EducationalDevelopmental"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_EducationalDevelopmental"   {{if EducationalDevelopmental=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="400px">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_EducationalDevelopmental" class="form_label cursor_Maindefault">
                                                         Educational/Developmental</label>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td colspan="5" class="height2">
                                                         &nbsp;
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td>
                                                         &nbsp;
                                                      </td>
                                                      <td class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_PersonPlan"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_PersonPlan"   {{if PersonPlan=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="350px">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_PersonPlan" class="form_label cursor_Maindefault">
                                                         Person Centered Plans/Treatment Plans</label>
                                                      </td>
                                                      <td class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_DischargeTransferRecommendation"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_DischargeTransferRecommendation"   {{if DischargeTransferRecommendation=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="350px">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_DischargeTransferRecommendation" class="form_label cursor_Maindefault">
                                                         Discharge/Transfer Recommendations</label>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td colspan="5" class="height2">
                                                         &nbsp;
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td class="checkbox_container">
                                                      </td>
                                                      <td class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_ProgressNote"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_ProgressNote"   {{if ProgressNote=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="350px">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_ProgressNote" class="form_label cursor_Maindefault">
                                                         Progress Note</label>
                                                      </td>
                                                      <td class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_InformationBenefitInsurance"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_InformationBenefitInsurance"   {{if InformationBenefitInsurance=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="350px">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_InformationBenefitInsurance" class="form_label cursor_Maindefault">
                                                         Information Related to Benefits or Insurance</label>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td colspan="5" class="height2">
                                                         &nbsp;
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td>
                                                      </td>
                                                      <td class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_PsychologicalTesting"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_PsychologicalTesting"   {{if PsychologicalTesting=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="350px">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_PsychologicalTesting" class="form_label cursor_Maindefault">
                                                         Psychological Test/Reports</label>
                                                      </td>
                                                      <td class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_WorkRelatedInformation"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_WorkRelatedInformation"   {{if WorkRelatedInformation=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="350px">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_WorkRelatedInformation" class="form_label cursor_Maindefault">
                                                         Work Related Information</label>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td colspan="5" class="height2">
                                                         &nbsp;
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td>
                                                      </td>
                                                      <td class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_PsychiatricTreatment"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_PsychiatricTreatment"   {{if PsychiatricTreatment=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="350px">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_PsychiatricTreatment" class="form_label cursor_Maindefault">
                                                         Psychiatric Evaluations/Medication Reviews/Labs</label>
                                                      </td>
                                                      <td class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_ReleasedInfoOther"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_ReleasedInfoOther"  {{if ReleasedInfoOther=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="350px">
                                                         <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                            <tr>
                                                               <td width="50px" class="form_label">
                                                                  <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_ReleasedInfoOther" class="form_label cursor_Maindefault">
                                                                  Other:</label>
                                                               </td>
                                                               <td>
                                                                  <input type="text" bindautosaveevents="False" id="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleasedInfoOtherComment" name="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_ReleasedInfoOtherComment" style="width: 200px" class="form_textbox" maxlength="500" value="${ReleasedInfoOtherComment}" />
                                                               </td>
                                                            </tr>
                                                         </table>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td colspan="5" class="height2">
                                                         &nbsp;
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td>
                                                      </td>
                                                      <td class="checkbox_container">
                                                         <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TreatmentServiceRecommendation"
                                                         name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TreatmentServiceRecommendation"   {{if TreatmentServiceRecommendation=='Y'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td class="form_label" width="350px">
                                                         <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TreatmentServiceRecommendation" class="form_label cursor_Maindefault">
                                                         Treatment/Service Recommendations</label>
                                                      </td>
                                                      <td class="checkbox_container">
                                                         &nbsp;
                                                      </td>
                                                      <td class="form_label">
                                                         &nbsp;
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td colspan="5" class="height2">
                                                         &nbsp;
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
                                                      <td class="right_bottom_cont_bottom_bg" width="100%">
                                                      </td>
                                                      <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right" width="2">
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
                                    <td class="height2">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td align="left" style="padding-right: 5px">
                                       <table cellspacing="0" cellpadding="0" border="0" width="800px%">
                                          <tr>
                                             <td>
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                   <tr>
                                                      <td class="height16">
                                                      </td>
                                                      <td class="content_tab_left" align="left" nowrap="nowrap">
                                                         Transmission Modes
                                                      </td>
                                                      <td width="17">
                                                         <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                      </td>
                                                      <td class="content_tab_top" width="100%">
                                                      </td>
                                                      <td width="7">
                                                         <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                      </td>
                                                   </tr>
                                                </table>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td class="content_tab_bg" style="padding-right: 8px; padding-left: 4px">
                                                <table cellspacing="0" cellpadding="0" border="0" width="800px">
                                                   <tr>
                                                      <td>
                                                         <table cellspacing="0" cellpadding="0" border="0" width="800px">
                                                            <tr>
                                                               <td width="5px">
                                                               </td>
                                                               <td>
                                                                  <b>The information may be released in:</b>
                                                               </td>
                                                            </tr>
                                                         </table>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td>
                                                         <table cellspacing="0" cellpadding="0" border="0" width="800px">
                                                            <tr>
                                                               <td width="5px">
                                                               </td>
                                                               <td width="10px" class="checkbox_container">
                                                                  <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesWritten"
                                                                  name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesWritten"   {{if TransmissionModesWritten=='Y'}}
                                                                  checked='checked'
                                                                  {{/if}}/>
                                                               </td>
                                                               <td width="50px" class="form_label">
                                                                  <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesWritten" class="form_label cursor_Maindefault">
                                                                  Written
                                                                  </label>
                                                               </td>
                                                               <td width="10px">
                                                                  <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesVerbal"
                                                                  name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesVerbal"   {{if TransmissionModesVerbal=='Y'}}
                                                                  checked='checked'
                                                                  {{/if}}/>
                                                               </td>
                                                               <td width="50px" class="form_label">
                                                                  <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesVerbal" class="form_label cursor_Maindefault">
                                                                  Verbal
                                                                  </label>
                                                               </td>
                                                               <td width="10px">
                                                                  <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesElectronic"
                                                                  name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesElectronic"   {{if TransmissionModesElectronic=='Y'}}
                                                                  checked='checked'
                                                                  {{/if}}/>
                                                               </td>
                                                               <td width="60px" class="form_label">
                                                                  <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesElectronic" class="form_label cursor_Maindefault">
                                                                  Electronic
                                                                  </label>
                                                               </td>
                                                               <td width="10px">
                                                                  <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesPhoto"
                                                                  name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesPhoto"   {{if TransmissionModesPhoto=='Y'}}
                                                                  checked='checked'
                                                                  {{/if}}/>
                                                               </td>
                                                               <td class="form_label" width="40px">
                                                                  <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesPhoto" class="form_label cursor_Maindefault">
                                                                  Photo
                                                                  </label>
                                                               </td>
                                                               <td class="form_label">
                                                                  <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                     <tr>
                                                                        <td class="checkbox_container" width="10px">
                                                                           <input type="checkbox" bindautosaveevents='False' id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesReleaseInOther"  name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesReleaseInOther"
                                                                           {{if TransmissionModesReleaseInOther=='Y'}}
                                                                           checked='checked'
                                                                           {{/if}}/>
                                                                        </td>
                                                                        <td width="50px" class="form_label">
                                                                           <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesReleaseInOther" class="form_label cursor_Maindefault">
                                                                           Other:</label>
                                                                        </td>
                                                                        <td>
                                                                           <input type="text" bindautosaveevents="False" id="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesReleaseInOtherComment" name="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesReleaseInOtherComment" style="width: 200px" class="form_textbox" maxlength="500" value="${TransmissionModesReleaseInOtherComment}" />
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
                                                         <table cellspacing="0" cellpadding="0" border="0" width="800px">
                                                            <tr>
                                                               <td width="10px" colspan="3" class="height2">
                                                               </td>
                                                            </tr>
                                                            <tr>
                                                               <td width="5px">
                                                               </td>
                                                               <td width="10px" class="checkbox_container">
                                                                  <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesToProvideCaseCoordination"
                                                                  name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesToProvideCaseCoordination"   {{if TransmissionModesToProvideCaseCoordination=='Y'}}
                                                                  checked='checked'
                                                                  {{/if}}/>
                                                               </td>
                                                               <td class="form_label">
                                                                  <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                     <tr>
                                                                        <td width="auto" class="form_label">
                                                                           <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesToProvideCaseCoordination" class="form_label cursor_Maindefault">
                                                                           To provide comprehensive case coordination
                                                                           </label>
                                                                        </td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                            <tr>
                                                               <td width="10px" colspan="3" class="height2">
                                                               </td>
                                                            </tr>
                                                            <tr>
                                                               <td width="5px">
                                                               </td>
                                                               <td width="10px" class="checkbox_container">
                                                                  <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesToDetermineEligibleService"
                                                                  name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesToDetermineEligibleService"   {{if TransmissionModesToDetermineEligibleService=='Y'}}
                                                                  checked='checked'
                                                                  {{/if}}/>
                                                               </td>
                                                               <td class="form_label">
                                                                  <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                     <tr>
                                                                        <td width="auto" class="form_label">
                                                                           <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesToDetermineEligibleService" class="form_label cursor_Maindefault">
                                                                           To determine eligibility for services
                                                                           </label>
                                                                        </td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                            <tr>
                                                               <td width="10px" colspan="3" class="height2">
                                                               </td>
                                                            </tr>
                                                            <tr>
                                                               <td width="5px">
                                                               </td>
                                                               <td width="10px" class="checkbox_container">
                                                                  <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesAtRequestIndividual"
                                                                  name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesAtRequestIndividual"   {{if TransmissionModesAtRequestIndividual=='Y'}}
                                                                  checked='checked'
                                                                  {{/if}}/>
                                                               </td>
                                                               <td class="form_label">
                                                                  <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                     <tr>
                                                                        <td width="auto" class="form_label">
                                                                           <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesAtRequestIndividual" class="form_label cursor_Maindefault">
                                                                           At the request of the individual
                                                                           </label>
                                                                        </td>
                                                                     </tr>
                                                                  </table>
                                                               </td>
                                                            </tr>
                                                            <tr>
                                                               <td width="10px" colspan="3" class="height2">
                                                               </td>
                                                            </tr>
                                                            <tr>
                                                               <td width="5px">
                                                               </td>
                                                               <td width="10px" class="checkbox_container">
                                                                  <input type="checkbox" bindautosaveevents='False' class="cursor_Maindefault" id="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesInOther"
                                                                  name="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesInOther"   {{if TransmissionModesInOther=='Y'}}
                                                                  checked='checked'
                                                                  {{/if}}/>
                                                               </td>
                                                               <td class="form_label">
                                                                  <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                     <tr>
                                                                        <td width="50px" class="form_label">
                                                                           <label for="Checkbox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesInOther" class="form_label cursor_Maindefault">
                                                                           Other:
                                                                           </label>
                                                                        </td>
                                                                        <td>
                                                                           <input type="text" bindautosaveevents="False" id="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesOtherComment" name="TextBox_CustomDocumentReleaseOfInformations_${ROIId}_TransmissionModesOtherComment" style="width: 200px" class="form_textbox" maxlength="500" value="${TransmissionModesOtherComment}" />
                                                                        </td>
                                                                     </tr>
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
                                                      <td class="right_bottom_cont_bottom_bg" width="100%">
                                                      </td>
                                                      <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right" width="2">
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
                                    <td class="height2">
                                    </td>
                                 </tr>
                                 <tr>
                                    <td align="left" style="padding-right: 5px">
                                       <table cellspacing="0" cellpadding="0" border="0" width="800px">
                                          <tr>
                                             <td>
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                   <tr>
                                                      <td class="height16">
                                                      </td>
                                                      <td class="content_tab_left" align="left" nowrap="nowrap">
                                                         Additional information
                                                      </td>
                                                      <td width="17">
                                                         <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                      </td>
                                                      <td class="content_tab_top" width="100%">
                                                      </td>
                                                      <td width="7">
                                                         <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                      </td>
                                                   </tr>
                                                </table>
                                             </td>
                                          </tr>
                                          <tr>
                                             <td class="content_tab_bg" style="padding-right: 8px; padding-left: 4px">
                                                <table cellspacing="0" cellpadding="0" border="0" width="800px">
                                                   <tr>
                                                      <td width="5px">
                                                      </td>
                                                      <td width="100%" class="form_label" colspan="2" style="text-align: left; padding-left: 4px">
                                                         <b>Please note</b> – The records released may contain alcohol and drug abuse information
                                                         and/or information about Human Immunodeficiency Virus (HIV), Acquired Immunodeficiency
                                                         Syndrome (AIDS), and AIDS Related Complex (ARC).
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td colspan="2" class="height2">
                                                         &nbsp;
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td width="5px">
                                                      </td>
                                                      <td width="100%" class="form_label" colspan="2" style="text-align: left; padding-left: 5px">
                                                         <b>Alcohol/Drug Abuse:</b>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                        <td width="10px" colspan="3" class="height2">
                                                        </td>
                                                   </tr>
                                                   <tr>
                                                      <td width="5px">
                                                      </td>
                                                      <td width="5px" class="" style="text-align: left; padding-left: 4px">
                                                         <input type="radio" bindautosaveevents='False' class="cursor_Maindefault" style='cursor: hand;' id="Radio_CustomDocumentReleaseOfInformations_${ROIId}_A_AlcoholDrugAbuse"
                                                         name="Radio_CustomDocumentReleaseOfInformations_${ROIId}_A_AlcoholDrugAbuse" value="A"  {{if AlcoholDrugAbuse == 'A'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td style="text-align: left ; padding-left: 4px; width: auto" class="style2">
                                                         <label for="Radio_CustomDocumentReleaseOfInformations_${ROIId}_A_AlcoholDrugAbuse" class="form_label cursor_Maindefault">
                                                         I authorize the release of information relating to referral and/or treatment for alcohol and drug abuse.</label>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                        <td width="10px" colspan="3" class="height2">
                                                        </td>
                                                   </tr>
                                                   <tr>
                                                      <td width="5px">
                                                      </td>
                                                      <td width="5px" class="" style="text-align: left ; padding-left: 4px">
                                                         <input type="radio" bindautosaveevents='False' class="cursor_Maindefault" style='cursor: hand;' id="Radio_CustomDocumentReleaseOfInformations_${ROIId}_P_AlcoholDrugAbuse"
                                                         name="Radio_CustomDocumentReleaseOfInformations_${ROIId}_A_AlcoholDrugAbuse" value="P" {{if AlcoholDrugAbuse == 'P'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td style="text-align: left; width: auto; padding-left: 4px" class="style2">
                                                         <label for="Radio_CustomDocumentReleaseOfInformations_${ROIId}_P_AlcoholDrugAbuse" class="form_label cursor_Maindefault">
                                                         I <b>PROHIBIT</b> the release of information relating to referral and/or treatment for alcohol and drug abuse.</label>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td colspan="2" class="height2">
                                                         &nbsp;
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                      <td width="5px">
                                                      </td>
                                                      <td width="100%" class="form_label" colspan="2" style="text-align: left; padding-left: 4px">
                                                         <b>HIV/AIDS/Sexually Transmitted Disease/Communicable Disease:</b>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                        <td width="10px" colspan="3" class="height2">
                                                        </td>
                                                   </tr>
                                                   <tr>
                                                      <td width="5px">
                                                      </td>
                                                      <td width="5px" class="" style="text-align: left; padding-left: 4px">
                                                         <input type="radio" bindautosaveevents='False' class="cursor_Maindefault" style='cursor: hand;' id="Radio_CustomDocumentReleaseOfInformations_${ROIId}_A_AIDSRelatedComplex"
                                                         name="Radio_CustomDocumentReleaseOfInformations_${ROIId}_A_AIDSRelatedComplex" value="A" {{if AIDSRelatedComplex == 'A'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td style="text-align: left; width: auto; padding-left: 4px" class="style2">
                                                         <label for="Radio_CustomDocumentReleaseOfInformations_${ROIId}_A_AIDSRelatedComplex" class="form_label cursor_Maindefault">
                                                         I authorize the release of information relating to HIV/AIDS/sexually transmitted disease/communicable disease.</label>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                        <td width="10px" colspan="3" class="height2">
                                                        </td>
                                                   </tr>
                                                   <tr>
                                                      <td width="5px">
                                                      </td>
                                                      <td width="5px" class="" style="text-align: left; padding-left: 4px">
                                                         <input type="radio" bindautosaveevents='False' class="cursor_Maindefault" style='cursor: hand;' id="Radio_CustomDocumentReleaseOfInformations_${ROIId}_P_AIDSRelatedComplex"
                                                         name="Radio_CustomDocumentReleaseOfInformations_${ROIId}_A_AIDSRelatedComplex" value="P" {{if AIDSRelatedComplex == 'P'}}
                                                         checked='checked'
                                                         {{/if}}/>
                                                      </td>
                                                      <td style="text-align: left; width: auto; padding-left: 4px" class="style2">
                                                         <label for="Radio_CustomDocumentReleaseOfInformations_${ROIId}_P_AIDSRelatedComplex" class="form_label cursor_Maindefault">
                                                         I <b>PROHIBIT</b> the release of information relating to HIV/AIDS/sexually transmitted disease/communicable disease. </label>
                                                      </td>
                                                   </tr>
                                                   <tr>
                                                        <td width="5px">
                                                        </td>
                                                        <td width="5px" class="" style="text-align: left">
                                                        </td>
                                                        <td style="text-align: right; width: auto" class="style2">
                                                            <span name='ClearIndROI_${ROIId}' id='ClearIndROI_${ROIId}' style='visibility:hidden;text-decoration: underline;cursor: hand; color: Blue; font-size: 11px' onclick = 'ClearROI(${ROIId})' onfocus="this.style.fontWeight='bold'" onblur="this.style.fontWeight='normal'" >Clear</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
                                                      <td class="right_bottom_cont_bottom_bg" width="100%">
                                                      </td>
                                                      <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right" width="2">
                                                         <img style="vertical-align: top;" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/right_bottom_cont_bottom_right.gif" />
                                                      </td>
                                                   </tr>
                                                </table>
                                             </td>
                                          </tr>
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
                     <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td width="1%" class="right_bottom_cont_bottom_bg">
                              <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif" height="7" alt="" />
                           </td>
                           <td class="right_bottom_cont_bottom_bg" width="98%">
                           </td>
                           <td width="1%" class="right_bottom_cont_bottom_bg" align="right">
                              <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif" height="7" alt="" />
                           </td>
                        </tr>
                     </table>
                  </td>
               </tr>
            </table>
         </td>
      </tr>
   </table>
</div>
</script>
<script type="text/javascript" language="javascript">
    var ROIData =
   {
       "ReleaseOfInformations":
       [
           {
               "ROIId": "1",
            "ReleaseOfInformationOrder": "1",
            "GetInformationFrom": "Y",
            "ReleaseInformationFrom": "Y",
            "ReleaseToReceiveFrom": "Y",
            "ReleaseEndDate": "2011-01-07 22:00:32.400",
            "ReleaseContactType": "O",
            "ReleaseName": "sanjayb",
            "ReleaseAddress": "House No 1231759, Sector 11115",
            "ReleaseCity": "MohaliAnchkula",
            "ReleasedState": "Punjab",
            "ReleasePhoneNumber": "1234567",
            "ReleasedZip": "111-111-111",
            "AssessmentEvaluation": "Y",
            "PersonPlan": "Y",
            "ProgressNote": "Y",
            "PsychologicalTesting": "N",
            "PsychiatricTreatment": "N",
            "TreatmentServiceRecommendation": "Y",
            "EducationalDevelopmental": "Y",
            "DischargeTransferRecommendation": "Y",
            "InformationBenefitInsurance": "Y",
            "WorkRelatedInformation": "asdfsdf",
            "ReleasedInfoOther": "Y",
            "ReleasedInfoOtherComment": "Yes",
            "TransmissionModesWritten": "Y",
            "TransmissionModesVerbal": "Y",
            "TransmissionModesElectronic": "Y",
            "TransmissionModesAudio": "N",
            "TransmissionModesPhoto": "Y",
            "TransmissionModesReleaseInOther": "Y",
            "TransmissionModesReleaseInOtherComment": "Yess",
            "TransmissionModesToProvideCaseCoordination": "Y",
            "TransmissionModesToDetermineEligibleService": "Y",
            "TransmissionModesAtRequestIndividual": "Y",
            "TransmissionModesInOther": "Y",
            "TransmissionModesOtherComment": "Yes",
            "AlcoholDrugAbuse": "P",
            "AIDSRelatedComplex": "A"
            }
          ]
   };

   $(function() {
       try {
//           alert($("#DivROIContentMain").html());
   //        $("#ROITemplate").tmpl(ROIData.ReleaseOfInformations).appendTo("#DivROIContentMain");
//           alert($("#DivROIContentMain").html());
       }
       catch (e) {
           alert(err.message);
       }
   });
</script>