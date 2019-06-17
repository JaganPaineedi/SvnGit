<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LifeDomain.ascx.cs" Inherits="Custom_RelapsePrevention_WebPages_LifeDomain" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
<div>
    <table border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <table id="ClientLifeDomainContainer" border="0" width="100%">
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: right; padding-right: 50px;">
                <a href="#" onclick="return addnewLifeDomain();" style="color: blue;"><u>Add Life Domain</u></a>
            </td>
        </tr>
        <tr>
            <td>
                <div id="DivReleaseToFromDropDown" style="visibility: hidden;">
                    <cc2:StreamlineDropDowns ID="DropDownList_CustomRelapseLifeDomains_LifeDomain" name="DropDownList_CustomRelapseLifeDomains_LifeDomain"
                        runat="server" Width="60px" parentchildcontrols="True">
                    </cc2:StreamlineDropDowns>
                </div>
            </td>
        </tr>
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td>
                <div id="DivDropDown" style="display: none;">
                    <cc2:StreamlineDropDowns ID="DropDownList_CustomRelapseGoals_RelapseGoalStatus" name="DropDownList_CustomRelapseGoals_RelapseGoalStatus"
                        runat="server" CssClass="form_dropdown" Width="100px" parentchildcontrols="True">
                    </cc2:StreamlineDropDowns>
                    <cc2:StreamlineDropDowns ID="DropDownList_CustomRelapseObjectives_ObjectiveStatus"
                        name="DropDownList_CustomRelapseObjectives_ObjectiveStatus" runat="server" CssClass="form_dropdown"
                        Width="100px" parentchildcontrols="True">
                    </cc2:StreamlineDropDowns>
                    <cc2:StreamlineDropDowns ID="DropDownList_CustomRelapseActionSteps_ActionStepStatus"
                        name="DropDownList_CustomRelapseActionSteps_ActionStepStatus" runat="server"
                        CssClass="form_dropdown" Width="100px" parentchildcontrols="True">
                    </cc2:StreamlineDropDowns>
                </div>
            </td>
        </tr>
    </table>
</div>

<script id="ClientLifeDomainHTML" type="text/x-jsrender">
<tr>
      <td>
            <div id = "DivProblem_{{:RelapseLifeDomainId}}">
                <table width="98%" border="0" align="left" cellspacing="0" cellpadding="0" >
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                    <img style="cursor: pointer" onclick="removeLifeDomain(this,{{:RelapseLifeDomainId}});" alt="" src="<%=RelativePath%>App_Themes/Includes/images/deleteIcon.gif" />
                                        Life Domain <span section="spannumber" id="Span_{{:RelapseLifeDomainId}}_LifeDomainNumber">{{:LifeDomainNumber}}</span>
                                    </td>
                                    <td width="17">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                                            width="17" height="26" alt="" />
                                    </td>
                                    <td class="content_tab_top" width="100%"></td>
                                    <td width="7">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif"
                                            width="7" height="26" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="content_tab_bg" align="center">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;padding-left:10px;">
                                            <tr>
                                                <td>Life Domain Detail <br />

                                                    <textarea class="form_textarea" id="{{:RelapseLifeDomainId}}LifeDomainDetail"
                                                        name="{{:RelapseLifeDomainId}}LifeDomainDetail"  rows="5"
                                                        cols="1" style="width: 98.5%;height: 40px" spellcheck="True" datatype="String"  onchange="CustomLifeDomainProblemsaveXMLvalue(this,'LifeDomainDetail',{{:RelapseLifeDomainId}})">{{:LifeDomainDetail}}</textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td  class="height2">
                                    </td>
                                </tr>
                                <tr>
                                <td>
                                <table>
                                <tr>                                
                                    <td style="text-align: left;padding-left:10px;"> Date&nbsp;
                                    </td>
                                    <td>                                                                                                                                          
                                         <input type="text"  id="{{:RelapseLifeDomainId}}LifeDomainDate"
                                              name="{{:RelapseLifeDomainId}}LifeDomainDate"  rows="1" value="{{:LifeDomainDate}}" 
                                              style="height: 15px" spellcheck="True" datatype="Date" class="date_text"
                                        onchange="CustomLifeDomainProblemsaveXMLvalue(this,'LifeDomainDate',{{:RelapseLifeDomainId}})"/>                                                                        
                                    </td>
                                    <td>
                                       &nbsp;
                                    </td>
                                    <td>
                                    <img id="img_CustomRelapseLifeDomains_${RelapseLifeDomainId}_LifeDomainDate"" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                         onclick="return showCalendar('{{:RelapseLifeDomainId}}LifeDomainDate', '%m/%d/%Y');" />
                                    </td>                                      
                                    <td>
                                        <table width="80%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;padding-left:10px;">
                                            <tr>
                                                <td width="8%">Life Domain&nbsp;
                                                </td>
                                                <td style="width: 24%;padding-left:11px;">                                                       
                                                        <select id="{{:RelapseLifeDomainId}}LifeDomain" name="{{:RelapseLifeDomainId}}LifeDomain"  onchange="CustomLifeDomainProblemsaveXMLvalue(this,'LifeDomain',{{:RelapseLifeDomainId}})" Class="form_dropdown" style="width: 65%">
                                                                 {{: ~GetDropDownHtmlDropdowns("LifeDomain",RelapseLifeDomainId,LifeDomain)}}                    
                                                        </select>
                                                </td>                                                
                                            </tr>
                                        </table>
                                    </td>                                    
                                </tr>
                                </table>
                                </td>                                   
                                </tr>
                                 <tr>
                                    <td  class="height2">
                                    </td>
                                </tr>                                
                                 <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;padding-left:10px;">
                                            <tr>
                                                <td>My Resources Strengths and skills <br />

                                                    <textarea class="form_textarea" id="{{:RelapseLifeDomainId}}Resources"
                                                        name="{{:RelapseLifeDomainId}}Resources"  rows="5"
                                                        cols="1" style="width: 98.5%;height: 40px" spellcheck="True" datatype="String"  onchange="CustomLifeDomainProblemsaveXMLvalue(this,'Resources',{{:RelapseLifeDomainId}})">{{:Resources}}</textarea>
                                                </td>

                                            </tr>
                                        </table>
                                    </td>
                                </tr> 
                                 <tr>
                                    <td  class="height2">
                                    </td>
                                </tr>                               
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;padding-left:10px;">
                                            <tr>
                                                <td>My barriers and challenges <br />
                                                    <textarea class="form_textarea" id="{{:RelapseLifeDomainId}}Barriers"
                                                        name="{{:RelapseLifeDomainId}}Barriers"  rows="5"
                                                        cols="1" style="width: 98.5%;height: 40px" spellcheck="True" datatype="String"  onchange="CustomLifeDomainProblemsaveXMLvalue(this,'Barriers',{{:RelapseLifeDomainId}})">{{:Barriers}}</textarea>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>                                
                                <tr>
                                <td style="width: 1060px; vertical-align: center" id="TRMainLifeDomainsChild_{{:RelapseLifeDomainId}}">
                                    {{for objectListMemberService tmpl="#GoalHTML"/}}
                                    </td>
                               </tr>                                                                
                               <tr>
                                  <td align="right" style="padding-right:10px">
                                      <span style="color: blue; font-size: 11px; cursor: hand; text-decoration: underline"
                                                       id="Span_AddService_${RelapseLifeDomainId}" name="Span_AddService_${RelapseLifeDomainId}" 
                                                       onclick = "AddNewMemberService({{:RelapseLifeDomainId}},this)";
                                                       tabindex='0' onfocus="this.style.fontWeight='bold'" onblur="this.style.fontWeight='normal'" >Add Goals</span>                                   
                                    </td>
                               </tr> 
                                
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="2" class="right_bottom_cont_bottom_bg">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif"
                                            height="7" alt="" />
                                    </td>
                                    <td class="right_bottom_cont_bottom_bg" width="100%"></td>
                                    <td width="2" class="right_bottom_cont_bottom_bg" align="right">
                                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif"
                                            height="7" alt="" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
          </td>
        </tr>
</script>

<script id="GoalHTML" type="text/x-jsrender">

<div id = "DivGoal_{{:RelapseGoalId}}">
<table width="100%" border="0" align="left" cellspacing="0" cellpadding="0" >
<tr>
  <td  class="height2">
  </td>
</tr>
<tr>
<td style="width:15%;padding-left:40px" colspan="2" align="left">
<table border="0">
<tr>
<td style="width:10%">
 <img style="cursor: pointer" onclick="removeGoal(this,{{:RelapseGoalId}});" alt="" src="<%=RelativePath%>App_Themes/Includes/images/deleteIcon.gif" />
</td>
<td valign="middle" align="left" >
       Goal #<span section="spangoalnumber" id="Span_{{:RelapseGoalId}}_GoalNumber">{{:GoalNumber}}</span>
</td>
</tr>
</table>       
</td>
</tr>
 <tr>
  <td  class="height2">
  </td>
</tr>
<tr id = "TRGoal_{{:RelapseGoalId}}">  
       <td style="width:30% style="padding-left:40px" colspan="2">    
            <table width="70%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;padding-left:10px;">
                <tr>
                    <td style="padding-left:30px;width:20%">Goal Status&nbsp;
                    </td>
                    <td align="left" style="text-align: left;width:20%">                                                                                                                    
                        <select id="{{:RelapseGoalId}}RelapseGoalStatus" name="{{:RelapseGoalId}}RelapseGoalStatus"  onchange="CustomGoalsaveXMLvalue(this,'RelapseGoalStatus',{{:RelapseGoalId}})" Class="form_dropdown" style="width: 120px">
                        {{: ~GetDropDownHtmlDropdowns("RelapseGoalStatus",RelapseGoalId,RelapseGoalStatus)}}                    
                        </select>                          
                    </td>    
                    <td style="text-align: right;width:30%;padding-right:5px">  Projected achievement date&nbsp;
                    </td>          
                    <td style="text-align: left;padding-left:5px;width:14%">                                                                                                                              
                        <input type="text"  id="{{:RelapseGoalId}}ProjectedDate"
                         name="{{:RelapseGoalId}}ProjectedDate"  rows="1"
                         class="date_text" style="height: 15px" spellcheck="True" datatype="Date" value="{{:ProjectedDate}}"
                         onchange="CustomGoalsaveXMLvalue(this,'ProjectedDate',{{:RelapseGoalId}})"/>                                                                         
                    </td>    
                    <td style="text-align: left;padding-left:5px">
                      <img id="img_CustomRelapseLifeDomains_${RelapseGoalId}_ProjectedDate"" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                      onclick="return showCalendar('{{:RelapseGoalId}}ProjectedDate', '%m/%d/%Y');" />
                   </td>                                              
             </tr>  
          </table>
       </td>
       <td align="left">
       <table>
       </tr>         
       </table>                           
       </td> 
     <tr>
        <td  class="height2">
        </td>
     </tr>       
     <tr>
       <td colspan="3" style="padding-left:40px" align="left">My Goal in this area is&nbsp;
       </td>
     </tr>
     <tr>
       <td colspan="3" style="padding-left:40px" align="left">
          <textarea class="form_textarea" id="{{:RelapseGoalId}}MyGoal"
            name="{{:RelapseGoalId}}MyGoal"  rows="5"
            cols="1" style="width: 98.5%;height: 40px" spellcheck="True" datatype="String"  onchange="CustomGoalsaveXMLvalue(this,'MyGoal',{{:RelapseGoalId}})">{{:MyGoal}}</textarea>
       </td>
    </tr>
    <tr>
        <td  class="height2">
        </td>
     </tr>   
    <tr>
       <td colspan="3" style="padding-left:40px" align="left">I will know I have achieved this goal when
       </td>
    </tr>
    <tr>
       <td colspan="3" style="padding-left:40px" align="left">
         <textarea class="form_textarea" id="{{:RelapseGoalId}}AchievedThisGoal"
          name="{{:RelapseGoalId}}AchievedThisGoal"  rows="5"
          cols="1" style="width: 98.5%;height: 40px" spellcheck="True" datatype="String"  onchange="CustomGoalsaveXMLvalue(this,'AchievedThisGoal',{{:RelapseGoalId}})">{{:AchievedThisGoal}}</textarea>
       </td>
    </tr>
</td>
</tr>

<tr>
    <td style="width: 1060px; vertical-align: center" id="TRMainGoalChild_{{:RelapseGoalId}}" colspan="3">
        {{for objectListobjectiveService tmpl="#ObjectiveHTML"/}}
        </td>
   </tr>

<tr>
   <td align="right" style="padding-right:10px" colspan="3">
          <span style="color: blue; font-size: 11px; cursor: hand; text-decoration: underline"
                           id="Span_AddObjective_${RelapseGoalId}" name="Span_AddObjective_${RelapseGoalId}" 
                           onclick = "AddNewObjectives({{:RelapseGoalId}},this)";
                           tabindex='0' onfocus="this.style.fontWeight='bold'" onblur="this.style.fontWeight='normal'" >Add Objectives</span>
        
    </td>
</tr>
</table>
</div>
</script>

<script id="ObjectiveHTML" type="text/x-jsrender">

<div id="DivObjective_{{:RelapseObjectiveId}}">
    <table width="100%" border="0" align="left" cellspacing="0" cellpadding="0">
    <tr>
      <td  class="height2">
      </td>
    </tr>
        <tr>
            <td style="width: 100%; padding-left: 60px" align="left">
            <table border="0">
            <tr>
            <td style="width:10%">
                <img style="cursor: pointer" onclick="removeobjectives(this,{{:RelapseObjectiveId}});"
                    alt="" src="<%=RelativePath%>App_Themes/Includes/images/deleteIcon.gif" />
                    </td>
                <td valign="middle" align="left" >
                Objectives # <span section="spanobjectivenumber" id="Span_{{:RelapseObjectiveId}}_ObjectivesNumber">
                    {{:ObjectivesNumber}}</span>
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
            <td style="padding-left: 60px" align="left">
                Objective&nbsp;
            </td>
        </tr>
        <tr>
            <td style="padding-left: 60px" align="left">
                <textarea class="form_textarea" id="{{:RelapseObjectiveId}}RelapseObjectives" name="{{:RelapseObjectiveId}}RelapseObjectives"
                    rows="5" cols="1" style="width: 98.5%; height: 40px" spellcheck="True" datatype="String"
                    onchange="CustomObjecivesaveXMLvalue(this,'RelapseObjectives',{{:RelapseObjectiveId}})">{{:RelapseObjectives}}</textarea>
            </td>
        </tr>
        <tr>
            <td class="height1">
            </td>
        </tr>
        <tr>
            <td style="width: 100%" style="padding-left: 60px">
                <table width="70%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;
                    padding-left: 10px;">
                    <tr>
                        <td style="width: 25%; padding-left: 50px">
                            Objective Status&nbsp;
                        </td>
                        <td style="width: 20%" align="left">
                            <select id="{{:RelapseObjectiveId}}ObjectiveStatus" name="{{:RelapseObjectiveId}}ObjectiveStatus"
                                onchange="CustomObjecivesaveXMLvalue(this,'ObjectiveStatus',{{:RelapseObjectiveId}})"
                                class="form_dropdown">
                                {{: ~GetDropDownHtmlDropdowns("ObjectiveStatus",RelapseObjectiveId,ObjectiveStatus)}}
                            </select>
                        </td>
                   
                        <td style="text-align: left;width: 20%;padding-left: 38px">
                            Create Date&nbsp;
                        </td>
                        <td style="width: 10%">
                            <input type="text" id="{{:RelapseObjectiveId}}ObjectivesCreateDate" name="{{:RelapseObjectiveId}}ObjectivesCreateDate"
                                rows="1" class="date_text" style="height: 15px" spellcheck="True" datatype="Date" value="{{:ObjectivesCreateDate}}"
                                onchange="CustomObjecivesaveXMLvalue(this,'ObjectivesCreateDate',{{:RelapseObjectiveId}})" />
                        </td>&nbsp;                       
                        <td style="padding-left: 5px">
                            <img id="img_CustomRelapseLifeDomains_${RelapseObjectiveId}_ObjectivesCreateDate"" "
                                src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('{{:RelapseObjectiveId}}ObjectivesCreateDate', '%m/%d/%Y');" />
                        </td>
                    </tr>
                </table>
            </td>     
        <tr>
            <td class="height2">
            </td>
        </tr>
        <tr>
            <td colspan="2" style="padding-left: 60px" align="left">
                I will achieved my goal by(objective)
            </td>
        </tr>
        <tr>
            <td colspan="2" style="padding-left: 60px" align="left">
                <textarea class="form_textarea" id="{{:RelapseObjectiveId}}IWillAchieve" name="{{:RelapseObjectiveId}}IWillAchieve"
                    rows="5" cols="1" style="width: 98.5%; height: 40px" spellcheck="True" datatype="String"
                    onchange="CustomObjecivesaveXMLvalue(this,'IWillAchieve',{{:RelapseObjectiveId}})">{{:IWillAchieve}}</textarea>
            </td>
        </tr>
        <tr>
            <td class="height1">
            </td>
        </tr>
        <tr>
            <td style="width: 100%" style="padding-left: 60px">
                <table width="80%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;
                    padding-left: 10px;">
                    <tr>
                        <td style="width: 27%; padding-left: 50px">
                            Expected Achieve Date&nbsp;
                        </td>
                        <td style="width: 10%" align="left">
                        <input type="text" id="{{:RelapseObjectiveId}}ExpectedAchieveDate" name="{{:RelapseObjectiveId}}ExpectedAchieveDate"
                                rows="1" class="date_text" style="height: 15px" spellcheck="True" datatype="Date" value="{{:ExpectedAchieveDate}}"
                                onchange="CustomObjecivesaveXMLvalue(this,'ExpectedAchieveDate',{{:RelapseObjectiveId}})" />
                        </td>&nbsp;                  
                        <td style="padding-left:2px;width: 3%">
                          <img id="img_CustomRelapseLifeDomains_${RelapseObjectiveId}_ExpectedAchieveDate"" "
                                src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" onclick="return showCalendar('{{:RelapseObjectiveId}}ExpectedAchieveDate', '%m/%d/%Y');" />                           
                        </td>                    
                        <td style="text-align: left;width: 18%;padding-left: 30px">
                            Resolution Date&nbsp;
                        </td>
                        <td style="width: 10%">
                         <input type="text" id="{{:RelapseObjectiveId}}ResolutionDate" name="{{:RelapseObjectiveId}}ResolutionDate"
                                rows="1" class="date_text" style="height: 15px" spellcheck="True" datatype="Date" value="{{:ResolutionDate}}"
                                onchange="CustomObjecivesaveXMLvalue(this,'ResolutionDate',{{:RelapseObjectiveId}})" />                            
                        </td>&nbsp;                       
                        <td style="padding-left: 5px">
                           <img id="img_CustomRelapseObjectives_${RelapseObjectiveId}ResolutionDate"" " src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                onclick="return showCalendar('{{:RelapseObjectiveId}}ResolutionDate', '%m/%d/%Y');" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="width: 1060px; vertical-align: center" id="TRMainObjectiveChild_{{:RelapseObjectiveId}}" colspan="3">
                {{for objectListActionService tmpl="#ObjectiveActions"/}}
            </td>
        </tr>
        <tr>
            <td align="right" style="padding-right:10px" colspan="3">
            <span style="color: blue; font-size: 11px; cursor: hand; text-decoration: underline"
                           id="Span_AddAction_${RelapseObjectiveId}" name="Span_AddAction_${RelapseObjectiveId}" 
                           onclick = "AddNewObjectiveactions({{:RelapseObjectiveId}},this)";
                           tabindex='0' onfocus="this.style.fontWeight='bold'" onblur="this.style.fontWeight='normal'" >Add Action</span>
             </td>
       </tr>
    </table>
</div>
</script>

<script id="ObjectiveActions" type="text/x-jsrender">

 <div id="DivAction_{{:RelapseActionStepId}}">
    <table width="100%" border="0" align="left" cellspacing="0" cellpadding="0">
     <tr>
      <td  class="height2">
      </td>
    </tr>
        <tr>
            <td style="width: 30%; padding-left: 80px" align="left">
            <table border="0">
            <tr>
            <td style="width:10%">
                <img style="cursor: pointer" onclick="removeactions(this,{{:RelapseActionStepId}});"
                    alt="" src="<%=RelativePath%>App_Themes/Includes/images/deleteIcon.gif" />
            </td>
            <td valign="middle" align="left" >
                Actions # <span section="spanactionnumber" id="Span_{{:RelapseActionStepId}}_ActionStepNumber">
                    {{:ActionStepNumber}}</span>
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
            <td colspan="2" style="padding-left: 80px" align="left">
                Action Steps&nbsp;
            </td>
        </tr>
        <tr>
            <td colspan="2" style="padding-left: 80px" align="left">
                <textarea class="form_textarea" id="{{:RelapseActionStepId}}RelapseActionSteps" name="{{:RelapseActionStepId}}RelapseActionSteps"
                    rows="5" cols="1" style="width: 98.5%; height: 40px" spellcheck="True" datatype="String"
                    onchange="CustomActionsaveXMLvalue(this,'RelapseActionSteps',{{:RelapseActionStepId}})">{{:RelapseActionSteps}}</textarea>
            </td>
        </tr>
        <tr>
            <td style="width: 100%" style="padding-left: 80px">
                <table width="80%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;
                    padding-left: 10px;">
                    <tr>
                        <td style="width: 27%; padding-left: 70px">
                            Action Step Status&nbsp;
                        </td>
                        <td style="width: 20%" align="left">
                            <select id="{{:RelapseActionStepId}}ActionStepStatus" name="{{:RelapseActionStepId}}ActionStepStatus"
                                onchange="CustomActionsaveXMLvalue(this,'ActionStepStatus',{{:RelapseActionStepId}})"
                                class="form_dropdown">
                                {{: ~GetDropDownHtmlDropdowns("ActionStepStatus",RelapseActionStepId,ActionStepStatus)}}
                            </select>
                        </td>
                        <td style="text-align: left; width: 15%; padding-left: 23px">
                            Create Date&nbsp;
                        </td>
                        <td style="width: 10%">
                            <input type="text" id="{{:RelapseActionStepId}}CreateDate" name="{{:RelapseActionStepId}}CreateDate"
                                rows="1" class="date_text" style="height: 15px" spellcheck="True" datatype="Date" value="{{:CreateDate}}"
                                onchange="CustomActionsaveXMLvalue(this,'CreateDate',{{:RelapseActionStepId}})" />
                        </td>
                        &nbsp;
                        <td style="padding-left: 5px">
                            <img id="img_CustomRelapseActionSteps_${RelapseActionStepId}_CreateDate"" " src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                onclick="return showCalendar('{{:RelapseActionStepId}}CreateDate', '%m/%d/%Y');" />
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
            <td colspan="2" style="padding-left: 80px" align="left">
                I achieve my goal, I will participate in the follow activities
            </td>
        </tr>
        <tr>
            <td colspan="2" style="padding-left: 80px" align="left">
                <textarea class="form_textarea" id="{{:RelapseActionStepId}}ToAchieveMyGoal" name="{{:RelapseActionStepId}}ToAchieveMyGoal"
                    rows="5" cols="1" style="width: 98.5%; height: 40px" spellcheck="True" datatype="String"
                    onchange="CustomActionsaveXMLvalue(this,'ToAchieveMyGoal',{{:RelapseActionStepId}})">{{:ToAchieveMyGoal}}</textarea>
            </td>
        </tr>
    </table>
</div>
</script>

