<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HarborTPGoal.aspx.cs" Inherits="SHS.SmartCare.ActivityPages_Client_Detail_HarborTreatmentPlan_HarborTPGoal" %>

<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Edit Goal</title>
    <link href="../../../../App_Themes/Styles/Common.css" rel="stylesheet" type="text/css" />
    <link href="../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../../App_Themes/Styles/SmartCareStyles.css" rel="stylesheet" type="text/css" />
    <link href="../../../../App_Themes/Styles/calendar-blue2.css" rel="stylesheet" type="text/css" />
    <link href="../../../../App_Themes/Styles/spinner.css" rel="stylesheet" type="text/css" />
    <link href="../../../../App_Themes/Styles/flora.datepicker.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../../App_Themes/Styles/ui.stepper.css" rel="stylesheet" type="text/css"
        media="screen,projection" />
    <link href="../../../../App_Themes/Styles/apple.datepicker.css" rel="stylesheet"
        type="text/css" />

    <script type="text/javascript" language="javascript" src="../../../../JScripts/ApplicationScripts/CommonFunctions.js"></script>

    <script type="text/javascript" language="javascript" src="../../../../JScripts/ApplicationScripts/ApplicationCommonFunctions.js"></script>

    <script type="text/javascript" src="../../../../JScripts/SystemScripts/calendar.js"></script>

    <script type="text/javascript" src="../../../../JScripts/SystemScripts/calendar-en.js"></script>

    <script type="text/javascript" src="../../../../JScripts/SystemScripts/CalCode.js"></script>

    <script src="<%=RelativePath%>Custom/Scripts/HRMTreatmetPlan.js" type="text/javascript"></script>

    <script type="text/javascript" language="javascript" src="<%=RelativePath%>JScripts/SystemScripts/jquery-latest.js"></script>

</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" ScriptMode="Release">
    </asp:ScriptManager>
    <div class="bottom_contanier_white_bg" align="center">
        <table cellspacing="0" cellpadding="0" border="0" width="95%">
            <tbody>
                <tr>
                    <td style="padding-left: 20px;">
                        <table border="0" cellpadding="0" cellspacing="0" width="98%">
                            <tr>
                                <td class="height2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td align="center" valign="top" class="right_contanier_bgg" colspan="3">
                                                                <table style="width: 100%;" id="TableHRMTPGoalPage" cellpadding="0" cellspacing="0"
                                                                    name="TableHRMTPGoalPage" border="0">
                                                                    <tr>
                                                                        <td>
                                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                                <tr>
                                                                                    <td>
                                                                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                                                            <tbody>
                                                                                                <tr>
                                                                                                    <td align="left" nowrap='nowrap' class="content_tab_left">
                                                                                                        <%--<span id="Span_TPNeeds_GoalNumber" runat="server"></span>--%>
                                                                                                        <asp:Literal ID="Litral_TPNeeds_GoalNumber" runat="server"></asp:Literal>
                                                                                                    </td>
                                                                                                    <td width="17">
                                                                                                        <img style="vertical-align: top" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif" />
                                                                                                    </td>
                                                                                                    <td width="100%" class="content_tab_top" />
                                                                                                    <td width="7">
                                                                                                        <img style="vertical-align: top" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_right.gif" />
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td class="content_tab_bg">
                                                                                        <table border="0" cellpadding="0" cellspacing="0" width="95%">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    &nbsp; &nbsp; &nbsp;
                                                                                                    <asp:HiddenField ID="HiddenField_TPNeeds_NeedId" runat="server" />
                                                                                                    <asp:HiddenField ID="HiddenField_TPNeeds_AddEdit" runat="server" />
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <table cellpadding="10" cellspacing="0" width="100%">
                                                                                                        <tr>
                                                                                                            <td align="left" style="padding-left: 5px;">
                                                                                                                <span name="Span$$GoalDescription" class="form_label" id="Span$$GoalDescription">Goal
                                                                                                                    Text</span>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                        <tr>
                                                                                                            <td height="1px">
                                                                                                                &nbsp;
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                        <tr>
                                                                                                            <td align="center">
                                                                                                                <textarea tabindex="1" name="TextArea_CustomTPGoals_GoalText" id="TextArea_CustomTPGoals_GoalText"
                                                                                                                    rows="4" cols="10" style="width: 98%;" class="form_textarea" runat="server" spellcheck="True"></textarea>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    &nbsp; &nbsp; &nbsp;
                                                                                                </td>
                                                                                            </tr>
                                                                                            <%-- <tr>
                                                                                                <td>
                                                                                                    <table cellpadding="10" cellspacing="0" width="100%" border="0">
                                                                                                        <tr>
                                                                                                            <td style="width: 23%; padding-right: 2px; padding-left: 5px;" align="left" valign="top">
                                                                                                                <span name="Span$$StrengthsPertinenttoGoal" class="form_label" id="Span$$StrengthsPertinenttoGoal">
                                                                                                                    Strengths pertinent to this goal</span>
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <textarea tabindex="2" name="TextArea_TPNeeds_GoalStrengths" id="TextArea_TPNeeds_GoalStrengths"
                                                                                                                    rows="4" cols="10" style="width: 99%;" class="form_textarea" runat="server" spellcheck="True"></textarea>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    &nbsp; &nbsp; &nbsp;
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    &nbsp; &nbsp; &nbsp;
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <table cellpadding="10" cellspacing="0" width="100%" border="0">
                                                                                                        <tr>
                                                                                                            <td style="width: 23%; padding-left: 2px; padding-left: 5px;" align="left" valign="top">
                                                                                                                <span name="Span$$BarriersPertinenttoGoal" class="form_label" id="Span$$BarriersPertinenttoGoal">
                                                                                                                    Barriers pertinent to this goal</span>
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <textarea tabindex="3" name="TextArea_TPNeeds_GoalBarriers" id="TextArea_TPNeeds_GoalBarriers"
                                                                                                                    rows="4" cols="10" style="width: 99%;" class="form_textarea" runat="server" spellcheck="True"></textarea>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                            </tr>--%>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    &nbsp; &nbsp; &nbsp;
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <%--<table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                                <tr>
                                                                    <td style=" padding-left: 7px; width:15%;" align="left">
                                                                        <span name="Span$$GoalTarget" id="Span$$GoalTarget" class="form_label">Goal Target Date</span>
                                                                    </td>
                                                                    <td  align="left" style="width:10%;">
                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                            <tr >
                                                                                <td style="padding-left:3px;">
                                                                                    <input type="text" tabindex="8" name="Text_TPNeeds_GoalTargetDate" id="Text_TPNeeds_GoalTargetDate"
                                                                                        runat="server" datatype="Date" style="border: 1px solid #a8bac3; font-size: 11px;
                                                                                        padding: 2px; width: 70px; height: 20px;" onblur="ValidateDateValueTP(this);" />
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td>
                                                                                    <img id="imgCalenderGoalTarget" onclick="return showCalendar('Text_TPNeeds_GoalTargetDate', '%m/%d/%Y');"
                                                                                        src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" />

                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="left" style="width:20%;">
                                                                        &nbsp;
                                                                    </td>  
                                                                    <td align="left" style="width:8%;" class="height2"></td>                                                                  
                                                                    <td align="left" style="width:16%;">
                                                                        <span name="Span$$StageOfTreatment" id="Span$$StageOfTreatment" class="form_label"
                                                                            style="">Stage Of Treatment</span>
                                                                    </td>
                                                                    <td align="left">
                                                                        <asp:DropDownList ID="DropDownList_StageOfTreatment" runat="server"  Width="138px"  class="form_label">
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                            </table>--%>
                                                                                                    <table cellpadding="0" cellspacing="0" width="100%" border="0">
                                                                                                        <tr>
                                                                                                            <td style="width:10%; padding-right: 5px;" align="left">
                                                                                                                <span name="Span_GoalTarget" id="Span_GoalTarget" class="form_label" style="">Goal Target
                                                                                                                    Date</span>
                                                                                                            </td>
                                                                                                            <td style="width:70px; padding-left: 2px;" align="left">
                                                                                                                <input type="text" tabindex="8" name="Text_CustomTPGoals_TargetDate" id="Text_CustomTPGoals_TargetDate"
                                                                                                                    runat="server" datatype="Date" style="border: 1px solid #a8bac3; font-size: 11px;
                                                                                                                    padding: 2px; width: 70px; height: 20px;" onblur="ValidateDateValueTP(this);" />
                                                                                                            </td>
                                                                                                            <td align="left" style="padding-left: 5px;">
                                                                                                                <img id="imgCalenderGoalTarget" onclick="return showCalendar('Text_CustomTPGoals_TargetDate', '%m/%d/%Y');"
                                                                                                                    src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif" />
                                                                                                            </td>
                                                                                                            <td style="width: 4%" align="left">
                                                                                                                &nbsp;
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <table cellpadding="15" cellspacing="0" width="100%">
                                                                                                                <tr>
                                                                                                                    <td style="width: 10%; padding-right: 5px;" align="left">
                                                                                                                        <span name="Span_GoalCreated" class="form_label" id="Span_GoalCreated" style="">Goal
                                                                                                                           status:</span>
                                                                                                                    </td>
                                                                                                                    <td align="center">
                                                                                                                        <table cellpadding="0" cellspacing="0" width="100%">
                                                                                                                            <tr>
                                                                                                                                
                                                                                                                                <td style="width:20%">
                                                                                                                                    <input type="radio" id="Radio_CustomTPGoals_Active_Y" name="Radio_CustomTPGoals_Active"
                                                                                                                                        tabindex="0" runat="server" class="RadioText" />
                                                                                                                                    <label for="Radio_CustomTPGoals_Active_Y" class="RadioText">
                                                                                                                                        Goal is active</label>
                                                                                                                                </td>
                                                                                                                                <td style="width:20%">
                                                                                                                                    <input type="radio" id="Radio_CustomTPGoals_Active_N" name="Radio_CustomTPGoals_Active"
                                                                                                                                        tabindex="0" runat="server" class="RadioText" />
                                                                                                                                    <label for="Radio_CustomTPGoals_Active_N" class="RadioText">
                                                                                                                                        Goal is NOT active</label>
                                                                                                                                </td>
                                                                                                                                <td style="width:60%">
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="height2">
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td style="height: 10px;">
                                                                                                    &nbsp;
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
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td width="2" class="right_bottom_cont_bottom_bg">
                                                                                            <img style="vertical-align: top" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_left.gif" />
                                                                                        </td>
                                                                                        <td width="100%" class="right_bottom_cont_bottom_bg" />
                                                                                        <td align="right" width="2" class="right_bottom_cont_bottom_bg">
                                                                                            <img style="vertical-align: top" height="7" alt="" src="<%=RelativePath%>App_Themes/Includes/Images/right_bottom_cont_bottom_right.gif" />
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" align="center">
                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="4">
                                                                                <tr>
                                                                                    <td align="right" width="85%">
                                                                                        <table width="20%" border="0" cellpadding="0" cellspacing="0">
                                                                                            <tbody>
                                                                                                <tr>
                                                                                                    <td class="expandable_btn_left">
                                                                                                        <input type="button" value="Save" id="ButtonUpdate" name="ButtonUpdate" class="form_btn_left1"
                                                                                                            tabindex="13" style="width: 100%" onclick="AddEditGoalValueInDataSet();" />
                                                                                                    </td>
                                                                                                    <td class="expandable_btn_right">
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </td>
                                                                                    <td width="15%">
                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                            <tbody>
                                                                                                <tr>
                                                                                                    <td class="expandable_btn_left">
                                                                                                        <input type="button" value="Cancel" id="ButtonCancel" name="ButtonCancel" class="form_btn_left1"
                                                                                                            tabindex="14" style="width: 100%" onclick="javascript:HandleCloseEvent();" />
                                                                                                    </td>
                                                                                                    <td class="expandable_btn_right">
                                                                                                        &nbsp;
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
        <asp:HiddenField ID="HiddenFieldRelativePath" runat="server" />
    </div>
    </form>
</body>
</html>
