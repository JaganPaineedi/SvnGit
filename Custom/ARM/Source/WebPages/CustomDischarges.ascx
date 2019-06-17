<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomDischarges.ascx.cs"
    Inherits="SHS.SmartCare.CustomDischarges" %>
     <%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc2" %>
   <style type="text/css">
    .style1
    {
        width: 678px;
    }
    </style>    
<link href="../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet" type="text/css" />

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/Scripts/CustomDocumentDischarges.js" ></script>

<script type="text/javascript">

    function check() {
        $(function() {
            $("#CheckBox_CustomDocumentDischarges_InvoluntaryTermination").click(function() {

                if (!$(this).is(":checked")) {
                    $(".child").attr('checked', false);
                    $(".child").attr("disabled", true);
                }
                else {

                    $(".child").removeAttr("disabled");
                }
            });
        });
    }
</script>
     
<div id="DivDischargeTab" onload="check()">
<!--Missing Field in DB-->
    <table cellpadding="0" cellspacing="0" border="0"   class="LPadd8" width="100%" clearcontrol="true" parentchildcontrols="True" >  
    <tr>
        <td>              
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="content_tab_left" align="left" width="15%">
                    Client <%--<input type="text" id="CustomDocumentDischargeGoals_${SourceObjectiveID}_ObjectiveNumber" style="border:none; background: transparent; width:20%;" bindautosaveevents="False" />--%>
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
     <tr >
     <td class="content_tab_bg">
     <table>
     <tr >
            <td>
                <table width="100%">
                    <tr>
                        <td style="width:18%; padding-left: 7px;">
                            <span id="Form_Label_Client_Address" runat="server"><b>Client Address:</b></span>
                        </td>
                        <td style="width: 82%">
                            <textarea  class="form_textarea element"   cols="100" rows="5" spellcheck="True" id="Textarea_CustomDocumentDischarges_ClientAddress"
                                cols="2"></textarea>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td style="width: 18%; padding-left: 7px;font-weight:bold;">
                            <span id="Span1" runat="server">Home Phone:</span>
                        </td>
                        <td style="width:82%">
                            <input type="text" style="width: 99%" id="TextBox_CustomDocumentDischarges_HomePhone"
                                class="form_textbox element" name="TextBox_CustomDocumentDischarges_HomePhone" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td style="width:18%; padding-left: 7px;font-weight:bold;">
                            <span id="Span2" runat="server">Parent/ Guardian Name:</span>
                        </td>
                        <td style="width:82%" >
                            <input class="form_textbox element" style="width:99%" id="TextBox_CustomDocumentDischarges_ParentGuardianName"
                                runat="server" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%">
                    <tr >
                        <td style="padding-left: 7px; width:18%;font-weight:bold;">
                            <span id="SpanDateOFAdm">Date of Admission:&nbsp;&nbsp;</span>
                        </td>
                        <td style="width:10%;padding-left: 2px">
                            <input style="width:100%" tabindex="8" name="TextBox_CustomDocumentDischarges_AdmissionDate"
                                class="date_text" id="TextBox_CustomDocumentDischarges_AdmissionDate" datatype="Date" />
                        </td>
                        <td style="width:4%;text-align:center">
                            <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                onclick="return showCalendar('TextBox_CustomDocumentDischarges_AdmissionDate', '%m/%d/%Y');"
                                style="cursor: hand; vertical-align: text-bottom;" />
                        </td>
                        <td style="padding-left: 7px; width: 18%; height: 17px;font-weight:bold;">
                            <span class="Form_Label" id="Span3">Date of Last Service:&nbsp;&nbsp;</span>
                        </td>
                        <td style="width:10%">
                            <input type="text" style="width:100%" tabindex="8" name="TextBox_CustomDocumentDischarges_LastServiceDate"
                                class="date_text" id="TextBox_CustomDocumentDischarges_LastServiceDate" datatype="Date" />
                        </td>
                        <td style="width:4%;text-align:center">
                            <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                onclick="return showCalendar('TextBox_CustomDocumentDischarges_LastServiceDate', '%m/%d/%Y');"
                                style="cursor: hand; vertical-align: text-bottom;" />
                        </td>
                        <td style="padding-left: 7px; width: 16%; height: 17px;font-weight:bold;" >
                            <span class="Form_Label" id="Span4">Date of Discharge:&nbsp;&nbsp;</span>
                        </td>
                        <td style="width:10%">
                            <input type="text" style="width:100%" tabindex="8" name="TextBox_CustomDocumentDischarges_DischargeDate"
                                class="date_text" id="TextBox_CustomDocumentDischarges_DischargeDate" datatype="Date" />
                        </td>
                        <td style="width:10%;text-align:left;padding-left:4px;">
                            <img id="img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                onclick="return showCalendar('TextBox_CustomDocumentDischarges_DischargeDate', '%m/%d/%Y');"
                                style="cursor: hand; vertical-align: text-bottom;" />
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
<tr>
<td>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="content_tab_left" align="left" width="15%">
                    Discharge <%--<input type="text" id="CustomDocumentDischargeGoals_${SourceObjectiveID}_ObjectiveNumber" style="border:none; background: transparent; width:20%;" bindautosaveevents="False" />--%>
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

<table width="100%">


        
        <tr>
            <td width="100%">
                <table width="100%">
                    <tr>
                        <td class="style1" style="height:25px;font-weight:bold; padding-left: 7px;" >
                            <span id="Span5" runat="server">Transition/ Discharge Criteria:</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1" style="padding-left: 7px;">
                            <textarea  cols="100%" rows="5" spellcheck="True" id="TextArea_CustomDocumentDischarges_DischargeTransitionCriteria"
                                name="TextArea_CustomDocumentDischarges_DischargeTransitionCriteria" class="form_textarea element" ></textarea>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td class="style1" style="height:25px;font-weight:bold; padding-left: 7px;">
                            <span id="Span6" class"form_label">Services the client has participated in during this episode:</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1" style="padding-left: 7px;">
                            <textarea  cols="99" rows="5" id="TextArea_CustomDocumentDischarges_ServicesParticpated"
                            name="TextArea_CustomDocumentDischarges_ServicesParticpated"  class="form_textarea element"  spellcheck="True"></textarea>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td class="style1" style="height:25px;font-weight:bold; padding-left: 7px;">
                            <span id="Span7" class"form_label">Medication currently prescribed to the client by Harbor
                                prescribers:</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1"  style="padding-left: 7px;">
                            <textarea class="form_textarea element"  cols="99" rows="5"  name="TextArea_CustomDocumentDischarges_MedicationsPrescribed" 
                            id="TextArea_CustomDocumentDischarges_MedicationsPrescribed"  spellcheck="True"></textarea>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td class="style1" style="height:25px;font-weight:bold; padding-left: 7px;">
                            <span id="Span8" class"form_label">Presenting problem/ condition at intake:</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1"  style="padding-left: 7px;">
                            <textarea  class="form_textarea element"   cols="99" rows="5"  name="TextArea_CustomDocumentDischarges_PresentingProblem" 
                            id="TextArea_CustomDocumentDischarges_PresentingProblem"  spellcheck="True"></textarea>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%">
                    <tr>
                        <td  >
                          
                    <table style="width:100%">
                    <tr>
                        <td class="style1" style="height:25px;font-weight:bold; width:20%;padding-left: 7px;" >
                            <span id="Span9" class"form_label" >Reason for discharge:</span>
                        </td>
                        <td  style="width:80%" >
                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentDischarges_ReasonForDischargeCode" AddBlankRow="true" Width="100%"
                                                  runat="server">
                        </cc2:StreamlineDropDowns>
                        </td>
                    </tr>
                </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="style1" style="padding-left: 7px;">
                            <textarea class="form_textarea element" cols="99" rows="5"  name="TextArea_CustomDocumentDischarges_ReasonForDischarge" 
                            id="TextArea_CustomDocumentDischarges_ReasonForDischarge"  spellcheck="True"></textarea>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>         
        <tr>
            <td style="width:100%;height:25px; padding-left:7px;" >
                <table  >
                    <tr>
                        <td class="style1" style="height:25px;font-weight:bold;" colspan="6">
                            <span id="Span20" class"form_label">Client participation in decision regarding discharge:</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:2%"  >
                            <input type="radio" id="RadioButton_CustomDocumentDischarges_ClientParticpation"
                                name="RadioButton_CustomDocumentDischarges_ClientParticpation" value="1" style="cursor:default"/>
                        </td>
                        <td width="5%" align="left">
                            <label id="LabelRadioButtonAgree" for="Agree">
                                Agree&nbsp;&nbsp;&nbsp;</label>
                        </td>
                        <td style="width:2%">
                            <input type="radio" id="RadioButton_CustomDocumentDischarges_ClientParticpation" 
                                name="RadioButton_CustomDocumentDischarges_ClientParticpation" value="2" style="cursor:default" />
                        </td>
                        <td width="5%" align="left">
                            <label id="LabelRadioButtonDisagree" for="Disagree">
                                Disagree&nbsp;&nbsp;&nbsp;</label>
                        </td>
                        <td style="width:2%">
                            <input type="radio" id="RadioButton_CustomDocumentDischarges_ClientParticpation"
                                name="RadioButton_CustomDocumentDischarges_ClientParticpation" value="3" style="cursor:default" />
                        </td>
                        <td >
                            <label id="LabelRadioButtonNA" for="NA">
                                N/A Client dropped out of treatment</label>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="width:100%;height:25px;padding-left: 7px;" >
                <table>
                
                    <tr >
                        <td style="width:25%;font-weight:bold;">
                           <span id="Span10" class"form_label" >Client's status at last contact:</span> 
                        </td>
                         
                        <td style="width:3%">
                            <input type="radio" id="RadioButton_CustomDocumentDischarges_ClientStatusLastContact" 
                                name="RadioButton_CustomDocumentDischarges_ClientStatusLastContact" value="1" style="cursor:default"  />
                        </td>
                        <td width="5%" align="left">
                            <label id="Label2" for="Disagree">
                                Stable&nbsp;&nbsp;&nbsp;</label>
                        </td>
                        <td style="width:3%">
                            <input type="radio" id="RadioButton_CustomDocumentDischarges_ClientStatusLastContact"
                                name="RadioButton_CustomDocumentDischarges_ClientStatusLastContact" value="2" style="cursor:default" />
                        </td>
                        <td >
                            <label id="Label3" for="Unstable">
                                Unstable (Comment required)</label>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td  style="width:100%;padding-left: 7px;">
                <table style="width:100%">
                   <tr>
                        <td style="font-style:italic;width:10%" >
                             <span id="Span11" class"form_label" >Comment:</span>
                        </td>
                        <td style="width:90%">
                            <textarea class="form_textarea element"  cols="100" rows="5"   name="TextArea_CustomDocumentDischarges_ClientStatusComment" 
                            id="TextArea_CustomDocumentDischarges_ClientStatusComment"  spellcheck="True"></textarea>
                        </td>
                    </tr>
                </table>
          </td>
       </tr>
        <tr>
           <td style="height:25px;font-weight:bold; padding-left: 7px;"  >
                <span id="Span12" class"form_label" >Based on the client's preferences, list all outside organization(s), agency(s), or person(s) the client was referred to: </span>
           </td>
       </tr>
        <tr>
            <td style="padding-left: 7px;" >
                <table style="width:100%">
                    <tr>
                        <td style="font-style:italic;width:10%">
                            <span id="Span13" class"form_label" >Select:</span>
                        </td>
                        <td width="90%">
                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentDischarges_ReferralPreference1" AddBlankRow="true" Width="100%"
                                                  runat="server">
                        </cc2:StreamlineDropDowns>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="padding-left: 7px;">
                <table style="width:100%">
                    <tr>
                        <td style="font-style:italic;width:10%">
                            <span id="Span14" class"form_label" >Select:</span>
                        </td>
                        <td width="90%">
                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentDischarges_ReferralPreference2" AddBlankRow="true" Width="100%"
                                                  runat="server"></cc2:StreamlineDropDowns>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="padding-left: 7px;">
                <table style="width:100%">
                    <tr>
                        <td style="font-style:italic;width:10%">
                            <span id="Span15" class"form_label" >Select:</span>
                        </td>
                        <td width="90%">
                        <cc2:StreamlineDropDowns ID="DropDownList_CustomDocumentDischarges_ReferralPreference3" AddBlankRow="true" Width="100%"
                                                  runat="server">
                        </cc2:StreamlineDropDowns>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="padding-left: 7px;">
                <table style="width:100%">
                    <tr>
                        <td style="width:3%">
                            <input type="checkbox" style="width: 100%;cursor:default;" id="CheckBox_CustomDocumentDischarges_ReferralPreferenceOther"
                                class="Form_CheckBox" name="CheckBox_CustomDocumentDischarges_ReferralPreferenceOther" style="cursor:default" />
                        </td>
                         <td style="height:25px;">
                            <span id="Span16" class"form_label" >Other referral option (specify below):</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="padding-left: 7px;width:100%" >
                <textarea  class="form_textarea element" cols="100" rows="5"   name="TextArea_CustomDocumentDischarges_ReferralPreferenceComment" 
                            id="TextArea_CustomDocumentDischarges_ReferralPreferenceComment"  spellcheck="True"></textarea>
            </td>
        </tr>
        <tr>
            <td style="padding-left: 7px;">
                <table style="width:100%">
                    <tr>
                        <td style="width:3%">
                            <input type="checkbox" style="width: 100%;cursor:default;" id="CheckBox_CustomDocumentDischarges_InvoluntaryTermination"
                                class="Form_CheckBox" name="CheckBox_CustomDocumentDischarges_InvoluntaryTermination" onclick="check()" style="cursor:default"  />
                        </td>
                         <td style="height:25px;font-weight:bold;">
                            <span id="Span17" class"form_label" >This is an involuntary termination from services for  assultive or aggressive behavior:</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table style="width:100%">
                    <tr>
                        <td style="width:5%"></td>
                        <td style="width:3%">
                            <input type="checkbox" style="width: 100%;cursor:default;" id="CheckBox_CustomDocumentDischarges_ClientInformedRightAppeal"
                                class="child" name="CheckBox_CustomDocumentDischarges_ClientInformedRightAppeal" style="cursor:default" />
                        </td>
                         <td style="height:25px;">
                            <span id="Span18" class"form_label" >The client has been informed of their right to file an appeal with Client Right Advocate.</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <table style="width:100%">
                    <tr>
                        <td style="width:5%"></td>
                        <td style="width:3%">
                            <input type="checkbox" style="width: 100%;cursor:default;" id="CheckBox_CustomDocumentDischarges_StaffMemberContact72Hours"
                                class="child" name="CheckBox_CustomDocumentDischarges_StaffMemberContact72Hours" />
                        </td>
                         <td style="height:25px;">
                            <span id="Span19" class"form_label" >A clinical staff number has contacted the client, parent/ guardian within 72 hours to provide appropriate referrals.</span>
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
        
    </table>
    <input id="HiddenField_CustomDocumentDischarges_DocumentVersionId" name="HiddenField_CustomDocumentDischarges_DocumentVersionId" type="hidden" value="-1" />
    <%--<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentDischarges" />--%>    
</div>
