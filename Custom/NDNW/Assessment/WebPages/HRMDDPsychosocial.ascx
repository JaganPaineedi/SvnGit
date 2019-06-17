<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HRMDDPsychosocial.ascx.cs"
 Inherits="SHS.SmartCare.ActivityPages_Client_Detail_Assessment_HRMDDPsychosocial" %>
 <% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>

<div style="overflow-x:hidden" >
<table cellpadding="0" cellspacing="0" border="0" class="DocumentScreen">
 <tr>
  <td>
  
<table id="mainTable" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td class="height1">
            &nbsp;
        </td>
    </tr>
     <tr>
        <td class="padding_label1">
        
        <table id="TableMentalHealth" border="0" cellpadding="0" cellspacing="0" width="98%" Group="MentalHealth">
                <tr>
                    <td class="height1">
                    </td>
                </tr>
                <tr>
                    <td >
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" >
                           
                            <tr>
                             
                                <td  class="content_tab_left" align="left" nowrap="nowrap">
                               
                                 Mental health treatment history. List previous diagnosis, family history, treatment history/efficacy, etc. <span id="Group_MentalHealth"></span>
                                </td>
                                <td width="17">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                        width="17" height="26" alt="" />
                                </td>
                                <td class="content_tab_top" width="100%">
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                        width="7" height="26" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="padding_label1">
                                    <table cellpadding="0" cellspacing="0" border="0" >
                                       <tr class="RadioText">
                                           <td>
                                               <input  type="radio" id="RadioButton_CustomHRMAssessments_HistMentalHealthTx_Y"
                                                   name="RadioButton_CustomHRMAssessments_HistMentalHealthTx" value="Y" />
                                              <label for="RadioButton_CustomHRMAssessments_HistMentalHealthTx_Y">Yes</label>
                                                   
                                           </td>
                                           <td width="8px">&nbsp;</td>
                                           <td>
                                              <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_HistMentalHealthTx_N"
                                                   name="RadioButton_CustomHRMAssessments_HistMentalHealthTx" value="N"  />
                                              <label for="RadioButton_CustomHRMAssessments_HistMentalHealthTx_N">No history reported</label>
                                           </td>
                                           <td width="8px">&nbsp;</td>
                                           <td>
                                               <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_HistMentalHealthTx_U"
                                                   name="RadioButton_CustomHRMAssessments_HistMentalHealthTx" value="U"  />
                                              <label for="RadioButton_CustomHRMAssessments_HistMentalHealthTx_U">Unknown</label>
                                           </td>
                                           <td width="15px">&nbsp;</td>
                                           <td id="MentalHealthNeedList" NotGroup="MentalHealth">
                                             <input class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_HistMentalHealthTxNeedsList" name="Checkbox_CustomHRMAssessments_HistMentalHealthTxNeedsList" onclick="HRMNeedList('72',this,'PsychosocialDD','MentalHealthDD');"/>
                                              <label for="Checkbox_CustomHRMAssessments_HistMentalHealthTxNeedsList">Add Mental Health History to Needs List</label> 
                                              
                                           </td>
                                       </tr>
                                       
                                    </table>
                                    
                                </td>
                            </tr>

                            <tr>
                                <td colspan="7" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_label1">
                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_HistMentalHealthTxComment"
                                        name="TextArea_CustomHRMAssessments_HistMentalHealthTxComment" rows="5" spellcheck="True"
                                        cols="155" onblur="UpdateNeedsXML(72,'MentalHealthDD')"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="7" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td width="2" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                </td>
                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                        height="7" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
     <tr>
        <td class="padding_label1">
        
        <table id="TableCulturalEthnic" border="0" cellpadding="0" cellspacing="0" width="98%" Group="CulturalEthnic">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                 Are there cultural/ethnic issues that are of concern or need to be addressed? Describe cultural/ethnic values/beliefs. <span id="Group_CulturalEthnic"></span>
                                </td>
                                <td width="17">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                        width="17" height="26" alt="" />
                                </td>
                                <td class="content_tab_top" width="100%">
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                        width="7" height="26" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                
                <tr>
                    <td class="content_tab_bg">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="padding_label1">
                                    <table cellpadding="0" cellspacing="0" border="0" >
                                       <tr class="RadioText">
                                           <td>
                                               <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_Y"
                                                   name="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues" value="Y" />
                                              <label for="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_Y">Yes</label>
                                                   
                                           </td>
                                           <td width="8px">&nbsp;</td>
                                           <td>
                                              <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_N"
                                                   name="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues" value="N"  />
                                              <label for="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_N">No Concerns</label>
                                           </td>
                                           <td width="8px">&nbsp;</td>
                                           <td>
                                               <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_U"
                                                   name="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues" value="U"  />
                                              <label for="RadioButton_CustomHRMAssessments_PsCulturalEthnicIssues_U">Unknown</label>
                                           </td>
                                           <td width="15px">&nbsp;</td>
                                           <td id="CulturalEthnicNeedList" NotGroup="CulturalEthnic">
                                             <input class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsCulturalEthnicIssuesNeedsList" name="Checkbox_CustomHRMAssessments_PsCulturalEthnicIssuesNeedsList" onclick="HRMNeedList(78,this,'PsychosocialDD','CulturalEthnicityDD');" />
                                              <label for="Checkbox_CustomHRMAssessments_PsCulturalEthnicIssuesNeedsList">Add Cultural/ Ethnic Values to Needs List</label>                                               
                                           </td>
                                       </tr>
                                       
                                    </table>
                                    
                                </td>
                            </tr>

                            <tr>
                                <td colspan="7" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_label1">
                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsCulturalEthnicIssuesComment"
                                        name="TextArea_CustomHRMAssessments_PsCulturalEthnicIssuesComment" rows="5" spellcheck="True"
                                        cols="155" onblur="UpdateNeedsXML(78,'CulturalEthnicityDD')"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="7" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td width="2" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                </td>
                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                        height="7" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                
            </table>
        </td>
    </tr>
     <tr>
        <td class="padding_label1">
        
        <table id="TableSpiritualityBeliefs" border="0" cellpadding="0" cellspacing="0" width="98%" Group="SpiritualityBeliefs">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                 Are there spirituality values/beliefs that are of concern or need to be addressed? Describe spirituality values/beliefs. <span id="Group_SpiritualityBeliefs"></span>
                                </td>
                                <td width="17">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                        width="17" height="26" alt="" />
                                </td>
                                <td class="content_tab_top" width="100%">
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                        width="7" height="26" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="padding_label1">
                                    <table cellpadding="0" cellspacing="0" border="0" >
                                       <tr class="RadioText">
                                           <td>
                                               <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsSpiritualityIssues_Y"
                                                   name="RadioButton_CustomHRMAssessments_PsSpiritualityIssues" value="Y"  />
                                              <label for="RadioButton_CustomHRMAssessments_PsSpiritualityIssues_Y">Yes</label>
                                                   
                                           </td>
                                           <td width="8px">&nbsp;</td>
                                           <td>
                                              <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsSpiritualityIssues_N"
                                                   name="RadioButton_CustomHRMAssessments_PsSpiritualityIssues" value="N"  />
                                              <label for="RadioButton_CustomHRMAssessments_PsSpiritualityIssues_N">No Concerns</label>
                                           </td>
                                           <td width="8px">&nbsp;</td>
                                           <td>
                                               <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsSpiritualityIssues_U"
                                                   name="RadioButton_CustomHRMAssessments_PsSpiritualityIssues" value="U"  />
                                              <label for="RadioButton_CustomHRMAssessments_PsSpiritualityIssues_U">Unknown</label>
                                           </td>
                                           <td width="15px">&nbsp;</td>
                                           <td id="SpiritualityBeliefsNeedList" NotGroup="SpiritualityBeliefs">
                                             <input class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsSpiritualityIssuesNeedsList"  name="Checkbox_CustomHRMAssessments_PsSpiritualityIssuesNeedsList" onclick="HRMNeedList(79,this,'PsychosocialDD','SpiritualityDD');"/>
                                              <label for="Checkbox_CustomHRMAssessments_PsSpiritualityIssuesNeedsList">Add Spirituality to Needs List</label>                                              
                                           </td>
                                       </tr>
                                       
                                    </table>
                                    
                                </td>
                            </tr>

                            <tr>
                                <td colspan="7" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_label1">
                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsSpiritualityIssuesComment"
                                        name="TextArea_CustomHRMAssessments_PsSpiritualityIssuesComment" rows="5" spellcheck="True"
                                        cols="155" onblur="UpdateNeedsXML(79,'SpiritualityDD')" ></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="7" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td width="2" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                </td>
                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                        height="7" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
     <tr>
        <td class="padding_label1">
        
        <table id="TableTraumaticIncident"  border="0" cellpadding="0" cellspacing="0" width="98%" Group="TraumaticIncident">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                 Has client experienced abuse or neglect either as victim or perpetrator and / or has had a previous traumatic incident? <span id="Group_TraumaticIncident"></span>
                                </td>
                                <td width="17">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                        width="17" height="26" alt="" />
                                </td>
                                <td class="content_tab_top" width="100%">
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                        width="7" height="26" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                            <tr>
                                <td class="padding_label1">
                                    <table cellpadding="0" cellspacing="0" border="0" >
                                       <tr class="RadioText">
                                           <td>
                                               <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_Y"
                                                   name="RadioButton_CustomHRMAssessments_PsClientAbuseIssues" value="Y" 
                                                    />
                                              <label for="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_Y">Yes</label>
                                                   
                                           </td>
                                           <td width="8px">&nbsp;</td>
                                           <td>
                                              <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_N"
                                                   name="RadioButton_CustomHRMAssessments_PsClientAbuseIssues" value="N"  />
                                              <label for="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_N">No Concerns</label>
                                           </td>
                                           <td width="8px">&nbsp;</td>
                                           <td>
                                               <input class="cursor_default" type="radio" id="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_U"
                                                   name="RadioButton_CustomHRMAssessments_PsClientAbuseIssues" value="U"  />
                                              <label for="RadioButton_CustomHRMAssessments_PsClientAbuseIssues_U">Unknown</label>
                                           </td>
                                           <td width="15px">&nbsp;</td>
                                           <td id="TraumaticIncidentNeedList" NotGroup="TraumaticIncident">
                                             <input class="cursor_default" type="checkbox" id="CheckBox_CustomHRMAssessments_PsClientAbuseIssuesNeedsList" name="CheckBox_CustomHRMAssessments_PsClientAbuseIssuesNeedsList" onclick="HRMNeedList(76,this,'PsychosocialDD','AbuseDD');"/>
                                              <label for="CheckBox_CustomHRMAssessments_PsClientAbuseIssuesNeedsList">Add Abuse/ Neglect/ Trauma to Needs List</label> 
                                              
                                           </td>
                                       </tr>
                                       
                                    </table>
                                    
                                </td>
                            </tr>

                            <tr>
                                <td colspan="7" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td class="padding_label1">
                                    <textarea class="form_textareaWithoutWidth" id="TextArea_CustomHRMAssessments_PsClientAbuesIssuesComment"
                                        name="TextArea_CustomHRMAssessments_PsClientAbuesIssuesComment" rows="5" spellcheck="True"
                                        cols="155" onblur="UpdateNeedsXML(76,'AbuseDD')" ></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="7" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td width="2" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                </td>
                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                        height="7" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
     <tr>
        <td class="padding_label1">
        
        <table id="TableCustomerAtRisk" border="0" cellpadding="0" cellspacing="0" width="98%" Group="CustomerAtRisk">
                <tr>
                    <td class="height2">
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td class="content_tab_left" align="left" nowrap='nowrap'>
                                 Customer is At risk of.... <span id="Group_CustomerAtRisk"></span>
                                </td>
                                <td width="17">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                        width="17" height="26" alt="" />
                                </td>
                                <td class="content_tab_top" width="100%">
                                </td>
                                <td width="7">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                        width="7" height="26" alt="" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="content_tab_bg">
                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                            
                            <tr>
                                <td colspan="4" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr  class="RadioText" >
                            
                               <td width="35%" class="padding_label1">
                                             <input style="padding-left:11px"; class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskLossOfPlacement" name="Checkbox_CustomHRMAssessments_PsRiskLossOfPlacement" />
                                              <label for="Checkbox_CustomHRMAssessments_PsRiskLossOfPlacement">Loss/lack of placement</label> 
                                           </td>
                                            <td width="35%" align="left" valign="top"><label for="DropDownList_CustomHRMAssessments_PsRiskLossOfPlacementDueTo"> Due to: </label> <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskLossOfPlacementDueTo" runat="server"
                                                    EnableViewState="false" CssClass="form_dropdown" Width="150px">
                                                </asp:DropDownList></td>
                                                <td width="15%"></td>
                                                <td width="15%"></td>
                                                
                            </tr>
                            <tr>
                                <td colspan="4" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr  class="RadioText" >
                            
                               <td width="35%" class="padding_label1">
                                             <input style="padding-left:11px"; class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskLossOfSupport" name="Checkbox_CustomHRMAssessments_PsRiskLossOfSupport" />
                                              <label for="Checkbox_CustomHRMAssessments_PsRiskLossOfSupport">Loss of support?</label> 
                                           </td>
                                            <td width="35%" align="left" valign="top"><label for="DropDownList_CustomHRMAssessments_PsRiskLossOfSupportDueTo"> Due to: </label> <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskLossOfSupportDueTo" runat="server"
                                                    EnableViewState="false" CssClass="form_dropdown" Width="150px">
                                                </asp:DropDownList></td>
                                                <td width="15%"></td>
                                                <td width="15%"></td>
                                                
                            </tr>
                            <tr>
                                <td colspan="4" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr  class="RadioText" >
                            
                               <td width="35%" class="padding_label1">
                                             <input style="padding-left:11px"; class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskExpulsionFromSchool" name="Checkbox_CustomHRMAssessments_PsRiskExpulsionFromSchool" />
                                              <label for="Checkbox_CustomHRMAssessments_PsRiskExpulsionFromSchool">Expulsion from school?</label> 
                                           </td>
                                            <td width="35%" align="left" valign="top"><label for="DropDownList_CustomHRMAssessments_PsRiskExpulsionFromSchoolDueTo"> Due to: </label> <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskExpulsionFromSchoolDueTo" runat="server"
                                                    EnableViewState="false" CssClass="form_dropdown" Width="150px">
                                                </asp:DropDownList></td>
                                                <td width="15%"></td>
                                                <td width="15%"></td>
                                                
                            </tr>
                            <tr>
                                <td colspan="4" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr  class="RadioText" >
                            
                               <td width="35%" class="padding_label1">
                                             <input style="padding-left:11px"; class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskHospitalization" name="Checkbox_CustomHRMAssessments_PsRiskHospitalization" />
                                              <label for="Checkbox_CustomHRMAssessments_PsRiskHospitalization">Hospitalization?</label> 
                                           </td>
                                            <td width="35%" align="left" valign="top"><label for="DropDownList_CustomHRMAssessments_PsRiskHospitalizationDueTo"> Due to: </label> <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskHospitalizationDueTo" runat="server"
                                                    EnableViewState="false" CssClass="form_dropdown" Width="150px">
                                                </asp:DropDownList></td>
                                                <td width="15%"></td>
                                                <td width="15%"></td>
                                                
                            </tr>
                            <tr>
                                <td colspan="4" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr  class="RadioText" >
                               <td width="35%" class="padding_label1">
                                             <input style="padding-left:11px"; class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskCriminalJusticeSystem" name="Checkbox_CustomHRMAssessments_PsRiskCriminalJusticeSystem" />
                                              <label for="Checkbox_CustomHRMAssessments_PsRiskCriminalJusticeSystem">Involvement with the criminal justice system?</label> 
                                           </td>
                                            <td width="35%" align="left" valign="top"><label for="DropDownList_CustomHRMAssessments_PsRiskCriminalJusticeSystemDueTo"> Due to: </label> <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskCriminalJusticeSystemDueTo" runat="server"
                                                    EnableViewState="false" CssClass="form_dropdown" Width="150px">
                                                </asp:DropDownList></td>
                                                <td width="15%"></td>
                                                <td width="15%"></td>
                                                
                            </tr>
                            <tr>
                                <td colspan="4" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr  class="RadioText" >
                               <td width="35%" class="padding_label1">
                                             <input style="padding-left:11px"; class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskElopementFromHome" name="Checkbox_CustomHRMAssessments_PsRiskElopementFromHome" />
                                              <label for="Checkbox_CustomHRMAssessments_PsRiskElopementFromHome">Elopement from home?</label> 
                                           </td>
                                            <td width="35%" align="left" valign="top"><label for="DropDownList_CustomHRMAssessments_PsRiskElopementFromHomeDueTo"> Due to: </label> <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskElopementFromHomeDueTo" runat="server"
                                                    EnableViewState="false" CssClass="form_dropdown" Width="150px"> 
                                                </asp:DropDownList></td>
                                                <td width="15%"></td>
                                                <td width="15%"></td>
                                                
                            </tr>
                            <tr>
                                <td colspan="4" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr  class="RadioText" >
                               <td width="35%" class="padding_label1">
                                             <input style="padding-left:11px"; class="cursor_default" type="checkbox" id="Checkbox_CustomHRMAssessments_PsRiskLossOfFinancialStatus" name="Checkbox_CustomHRMAssessments_PsRiskLossOfFinancialStatus" />
                                              <label for="Checkbox_CustomHRMAssessments_PsRiskLossOfFinancialStatus">Loss of financial status?</label> 
                                           </td>
                                            <td width="35%" align="left" valign="top"><label for="DropDownList_CustomHRMAssessments_PsRiskLossOfFinancialStatusDueTo"> Due to: </label> <asp:DropDownList ID="DropDownList_CustomHRMAssessments_PsRiskLossOfFinancialStatusDueTo" runat="server"
                                                    EnableViewState="false" CssClass="form_dropdown" Width="150px">
                                                </asp:DropDownList></td>
                                                <td width="15%"></td>
                                                <td width="15%"></td>
                                                
                            </tr>
                            <tr>
                                <td colspan="4" class="height1">
                                    &nbsp;
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td width="2" class="right_bottom_cont_bottom_bg">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                        height="7" alt="" />
                                </td>
                                <td class="right_bottom_cont_bottom_bg" width="100%">
                                </td>
                                <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                    <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                        height="7" alt="" />
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
 </div>