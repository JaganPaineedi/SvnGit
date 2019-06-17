<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomProgressTowardsISPGoal.ascx.cs"
    Inherits="SHS.SmartCare.CustomProgressTowardsISPGoal" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />
<%} %>
<%--
<%= ScriptCombiner.GetScriptTags("CustomDocumentDischarges", 3, "js", "no")%>--%>

<%--<script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/ApplicationScripts/jquery.tmpl.min.js"></script>--%>



<script type="text/javascript">
    $(document).bind('xmlchange', CustomDocumentDischargeGoals.LoadCustomDocumentDischargeGoals);
    CustomDocumentDischargeGoals.LoadCustomDocumentDischargeGoals();
</script>

<div id="divSecondTab">
    <table cellpadding="0" cellspacing="0" border="0" id="CustomDocumentDischargeTable">
    </table>
</div>
      
<%-- <asp:Table ID="CustomDocumentDischargeTable" runat="server">
    </asp:Table>--%>
<%--<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentDischargeGoals" />
--%>
                                            
<script id="CustomDocumentDischargeGoalsTmp1" type="text/x-jquery-tmpl">

     <tr class="tmplrow">
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr height="25">
                        <td class="content_tab_left" align="left" width="15%" style="padding-left:7px;">
                            Goals # <input type="text" id="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalNumber" style="border:none; background: transparent; width:20%;" bindautosaveevents="False" />
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
       <tr class="tmplrow">
            <td class="content_tab_bg">
                <table>
                    <tr>
                        <td height="25">
                            <table style="width: 100%" border="0" cellspacing="0" cellpadding="0" >
                                <tr >
                                    <td style="width: 70px;padding-left:7px;">
                                        Goals # <input type="text" id="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalNumber" style="border:none; background: transparent; width:20%;" bindautosaveevents="False" />
                                    </td>
                                    <td style="width: 70%">
                                         <textarea  id="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalText" disabled="disabled" style="background: transparent; width: 710px; height: 50px; overflow: auto;" bindautosaveevents="False" BindSetFormData="False">${GoalText}</textarea>                                         
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="width: 100%">
                        <td>
                            <table>
                                <tr>
                                    <td height="25" style="padding-left:5px;">
                                        <span id="Form_Label_ProgressGoal"><b>Rating of Progress towards Goal:</b></span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="width: 100%">
                        <td height="25">
                            <table>
                                <tr >
                                    <td width="3%" style="padding-left:7px;">
                                        <input type="radio" id="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress_D" style="cursor:default"
                                            name="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress" onclick="CustomDocumentDischargeGoals.CustomDocumentDischargeGoalsChange(this,'CustomDocumentDischargeGoals_${DischargeGoalId}_',${DischargeGoalId});"
                                            bindautosaveevents="False" value="D"/> 
                                    </td>
                                    <td width="15%">
                                    <span class="Style1">Deterioration</span>
                                    </td>
                                    
                                    <td width="2%">
                                        <input type="radio" id="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress_N" style="cursor:default"
                                            name="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress" onclick="CustomDocumentDischargeGoals.CustomDocumentDischargeGoalsChange(this,'CustomDocumentDischargeGoals_${DischargeGoalId}_',${DischargeGoalId});"
                                            bindautosaveevents="False" value="N" />
                                    </td>
                                    <td width="13%">
                                    <span id="Span2">No Change</span>
                                    </td>
                                    <td width="2%">
                                        <input type="radio" id="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress_S" style="cursor:default"
                                            name="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress" onclick="CustomDocumentDischargeGoals.CustomDocumentDischargeGoalsChange(this,'CustomDocumentDischargeGoals_${DischargeGoalId}_',${DischargeGoalId});"
                                            bindautosaveevents="False" value="S" /> 
                                    </td>
                                    <td width="20%">
                                    <span id="Span3">Some Improvement</span>
                                    </td>
                                    <td width="2%">
                                        <input type="radio" id="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress_M" style="cursor:default"
                                            name="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress" onclick="CustomDocumentDischargeGoals.CustomDocumentDischargeGoalsChange(this,'CustomDocumentDischargeGoals_${DischargeGoalId}_',${DischargeGoalId});"
                                            bindautosaveevents="False" value="M" /> 
                                    </td>
                                    <td width="23%">
                                    <span id="Span4">Moderate Improvement</span>
                                    </td>
                                    <td width="2%">
                                        <input type="radio" id="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress_A" style="cursor:default"
                                            name="CustomDocumentDischargeGoals_${DischargeGoalId}_GoalRatingProgress" onclick="CustomDocumentDischargeGoals.CustomDocumentDischargeGoalsChange(this,'CustomDocumentDischargeGoals_${DischargeGoalId}_',${DischargeGoalId});"
                                            bindautosaveevents="False" value="A"/>                                 
                                    <td width="22%">
                                   <span id="Span5">Achieved</span>       
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>

        <tr class="tmplrow">
    <td>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
<tr height="5px" class="tmplrow">
    <td>
    </td>
</tr>
 
</script>
<script type = "text/javascript">
    //CustomDocumentDischargeGoals.LoadCustomDocumentDischargeGoals();
</script>

