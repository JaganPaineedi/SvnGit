<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Seizure.ascx.cs" Inherits="Custom_IncidentReport_WebPages_Seizure" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc3" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<table cellpadding="0" cellspacing="0" class="DocumentScreen" width="820px">
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                <tr>
                    <td class="height2"></td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;">
                            <tr>
                                <td style="width: 100%;">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td>
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" width="10%">
                                                            <span id="SpanDetails">General</span>
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
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" class="content_tab_bg_padding" align="left">
                                    <table width="99%" border="0" cellspacing="0" cellpadding="0" id="TableChildControl_CustomIncidentReportSeizures">
                                        <tr>
                                            <td>
                                                <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td align="middle">
                                                            <span id="Span18" class="form_label" name="SpanID" style="padding-right: 10px">Time of Seizure</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSeizures_TimeOfSeizure" id="TextBox_CustomIncidentReportSeizures_TimeOfSeizure"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' parentchildcontrols="True" />
                                                            <span id="Span1" class="form_label" name="SpanID" style="padding-left: 50px; padding-right: 10px;">Duration of Seizure</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin" id="TextBox_CustomIncidentReportSeizures_DurationOfSeizureMin"
                                                                datatype="int" style="width: 67px" class='form_textbox' parentchildcontrols="True" />
                                                            <span id="Span2" class="form_label" name="SpanID" style="padding-right: 15px">minutes</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec" id="TextBox_CustomIncidentReportSeizures_DurationOfSeizureSec"
                                                                datatype="int" style="width: 67px" class='form_textbox' parentchildcontrols="True" />
                                                            <span id="Span3" class="form_label" name="SpanID" style="padding-right: 30px">seconds</span>
                                                            <input class="parentchildbutton" type="button" value="Add" id="TableChildControl_CustomIncidentReportSeizures_ButtonInsert"
                                                                name="TableChildControl_CustomIncidentReportSeizures_ButtonInsert" baseurl="<%=ResolveUrl("~") %>"
                                                                tabindex="2" onclick="return InsertGridDataSeizures('TableChildControl_CustomIncidentReportSeizures', 'InsertGrid', 'CustomGrid', this);" />
                                                            <input type="hidden" id="HiddenField_CustomIncidentReportSeizures_NoOfSeizure" name="HiddenField_CustomIncidentReportSeizures_NoOfSeizure" parentchildcontrols="True" />
                                                            <input type="hidden" id="HiddenField_CustomIncidentReportSeizures_DurationOfSeizure" name="HiddenField_CustomIncidentReportSeizures_DurationOfSeizure" parentchildcontrols="True" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div id="InsertGrid" runat="server" style="width: 700px; height: 100%; padding-left: 65px; overflow-x: auto; overflow-y: auto;">
                                                                <uc1:CustomGrid ID="CustomGrid" runat="server" TableName="CustomIncidentReportSeizures" PrimaryKey="IncidentReportSeizureId"
                                                                    CustomGridTableName="TableChildControl_CustomIncidentReportSeizures" ColumnHeader="Seizure:Time Of Seizure:Duration of Seizure" ColumnName="NoOfSeizure:TimeOfSeizure:DurationOfSeizure"
                                                                    GridPageName="CustomIncidentReportSeizures" ColumnFormat=":Time:" ColumnWidth="10%:20%:70%" DivGridName="InsertGrid"
                                                                    DoNotDisplayRadio="true" DoNotDisplayDeleteImage="False" InsertButtonId="TableChildControl_CustomIncidentReportSeizures_ButtonInsert" />
                                                            </div>
                                                            <input type="hidden" id="HiddenField_CustomIncidentReportSeizures_IncidentReportSeizureId" name="HiddenField_CustomIncidentReportSeizures_IncidentReportSeizureId"
                                                                parentchildcontrols="True" includeinparentchildxml="True" />
                                                            <input type="hidden" id="HiddenField_CustomIncidentReportSeizures_IncidentReportSeizureDetailId" name="HiddenField_CustomIncidentReportSeizures_IncidentReportSeizureDetailId"
                                                                parentchildcontrols="True" includeinparentchildxml="True" value="-1" />
                                                            <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="IncidentReportSeizureId"
                                                                parentchildcontrols="True" />
                                                            <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="IncidentReportSeizureDetailId"
                                                                parentchildcontrols="True" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td valign="top" align="left" class="checkbox_container">
                                                <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td width="20%">
                                                            <span id="Span4" class="form_label" name="SpanID">Sweating</span>
                                                        </td>
                                                        <td width="15%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSweating" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSweating" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span5" class="form_label" name="SpanID">Urinary/Fecal Incontinence</span>
                                                        </td>
                                                        <td width="15%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsUrinaryFecalIncontinence" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsUrinaryFecalIncontinence" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span6" class="form_label" name="SpanID">(Tonic) Stiffness of Arms</span>
                                                        </td>
                                                        <td width="10%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfArms" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfArms" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%">
                                                            <span id="Span7" class="form_label" name="SpanID">(Tonic) Stiffness of Legs</span>
                                                        </td>
                                                        <td width="15%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfLegs" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfLegs" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span8" class="form_label" name="SpanID">(Clonic) Twitching of Arms</span>
                                                        </td>
                                                        <td width="15%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfArms" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfArms" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span9" class="form_label" name="SpanID">(Clonic) Twitching of Legs</span>
                                                        </td>
                                                        <td width="10%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfLegs" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfLegs" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%">
                                                            <span id="Span10" class="form_label" name="SpanID">Pupils Dilated</span>
                                                        </td>
                                                        <td width="15%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPupilsDilated" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPupilsDilated" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span11" class="form_label" name="SpanID">Any abnormal eye movements</span>
                                                        </td>
                                                        <td width="15%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsAnyAbnormalEyeMovements" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsAnyAbnormalEyeMovements" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span12" class="form_label" name="SpanID">Postictal Period</span>
                                                        </td>
                                                        <td width="10%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPostictalPeriod" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPostictalPeriod" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%">
                                                            <span id="Span13" class="form_label" name="SpanID">Vagal Nerve Stimulator (VNS)</span>
                                                        </td>
                                                        <td width="15%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsVagalNerveStimulator" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsVagalNerveStimulator" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span14" class="form_label" name="SpanID">Swiped Magnet</span>
                                                        </td>
                                                        <td width="15%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSwipedMagnet" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSwipedMagnet" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>                                                            
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span15" class="form_label" name="SpanID">Number of Swipes</span>
                                                        </td>
                                                        <td width="10%">
                                                            <input style="width: 73px;" class="form_textbox element" type="text" id="TextBox_CustomIncidentReportSeizureDetails_SeizureDetailsNumberOfSwipes"
                                                                name="TextBox_CustomIncidentReportSeizureDetails_SeizureDetailsNumberOfSwipes" onblur="NotZero();" datatype="Numeric" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%">
                                                            <span id="Span16" class="form_label" name="SpanID">Pulse Rate</span>
                                                        </td>
                                                        <td width="15%">
                                                            <input style="width: 73px;" class="form_textbox element" type="text" id="TextBox_CustomIncidentReportSeizureDetails_SeizureDetailsPulseRate"
                                                                name="TextBox_CustomIncidentReportSeizureDetails_SeizureDetailsPulseRate" datatype="Numeric" />
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span17" class="form_label" name="SpanID">Breathing</span>
                                                        </td>
                                                        <td width="15%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsBreathing" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsBreathing" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                        <td width="20%">
                                                            <span id="Span19" class="form_label" name="SpanID">Color</span>
                                                        </td>
                                                        <td width="10%">
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsColor" Width="80px"
                                                                name="DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsColor" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Seizure Action Taken
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsTurnClientsHeadSide"
                                                    name="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsTurnClientsHeadSide" />
                                                <label for="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsTurnClientsHeadSide" class="form_label" style="padding-right: 25px;">
                                                    Turn Client’s Head side
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsClientSuctioned"
                                                    name="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsClientSuctioned" />
                                                <label for="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsClientSuctioned" class="form_label" style="padding-right: 30px;">
                                                    Client Suctioned
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsClothingLoosended"
                                                    name="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsClothingLoosended" />
                                                <label for="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsClothingLoosended" class="form_label" style="padding-right: 20px;">
                                                    Clothing Loosended
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsAirwayCleared"
                                                    name="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsAirwayCleared" />
                                                <label for="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsAirwayCleared" class="form_label" style="padding-right: 20px;">
                                                    Airway Cleared
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsPlacedClientOnTheFloor"
                                                    name="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsPlacedClientOnTheFloor" />
                                                <label for="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsPlacedClientOnTheFloor" class="form_label" style="padding-right: 16px;">
                                                    Placed client on the floor
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td class="checkbox_container">
                                                
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsPutClientToBed"
                                                    name="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsPutClientToBed" />
                                                <label for="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsPutClientToBed" class="form_label" style="padding-right: 56px;">
                                                    Put client to bed
                                                </label>
                                                <input type="checkbox" id="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsAreaCleared"
                                                    name="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsAreaCleared" />
                                                <label for="CheckBox_CustomIncidentReportSeizureDetails_SeizureDetailsAreaCleared" class="form_label" style="padding-right: 25px;">
                                                    Area cleared
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height2"></td>
                                        </tr>
                                        <tr>
                                            <td>Notes/Comments (including anything observed to help identify type of seizure)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="height"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <textarea id="TextBox_CustomIncidentReportSeizureDetails_SeizureDetailsNotesComments" class="form_textareaWithoutWidth"
                                                    name="TextBox_CustomIncidentReportSeizureDetails_SeizureDetailsNotesComments" rows="4" cols="158" spellcheck="True"></textarea>
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
                            <tr>
                                <td class="content_tab_bg"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="height2"></td>
                </tr>
                <tr>
                    <td>
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;">
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="SeizureDetailsTable">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="content_tab_left" align="left" width="10%">
                                                                        <span id="Span20">Details</span>
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
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>Description of incident (List all individuals and staff involved, what happened before if applicable, what occurred after the incident if applicable)
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsDescriptionOfIncident" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsDescriptionOfIncident" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Actions taken by staff
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsActionsTakenByStaff" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsActionsTakenByStaff" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Witnesses
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsWitnesses" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsWitnesses" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="SpanDetailsStaffNotifiedForInjury" class="form_label" name="SpanDetailsStaffNotifiedForInjury" style="padding-right: 20px;">Staff notified for injury</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury" Width="157px"
                                                                name="DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="SpanDetailsDateStaffNotified" class="form_label" name="SpanDetailsDateStaffNotified" style="padding-left: 70px;">Date Staff Notified</span>
                                                            <input datatype="Date" type="text" id="TextBox__CustomIncidentSeizureDetails_IncidentSeizureDetailsDateStaffNotified"
                                                                name="TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsDateStaffNotified" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="imgDetailsDateStaffNotified" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox__CustomIncidentSeizureDetails_IncidentSeizureDetailsDateStaffNotified', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="SpanDetailsTimestaffNotified" class="form_label" name="SpanDetailsTimestaffNotified" style="padding-left: 66px;">Time staff Notified</span>
                                                            <input type="text" name="TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsTimeStaffNotified" id="TextBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsTimeStaffNotified"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <input type="checkbox" id="CheckBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsNoMedicalStaffNotified"
                                                                name="CheckBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsNoMedicalStaffNotified" />
                                                            <label for="CheckBox_CustomIncidentSeizureDetails_IncidentSeizureDetailsNoMedicalStaffNotified" style="cursor: default; padding-right: 80px;">No medical staff notified</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="Span23" class="form_label" name="SpanDetailsStaffNotifiedForInjury" style="padding-right: 8px;">Supervisor to be Flagged</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsSupervisorFlaggedId" Width="157px"
                                                                name="DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsSupervisorFlaggedId" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><span id="Span25" class="form_label" name="SpanDetailsStaffNotifiedForInjury" style="padding-right: 20px;">for Review</span>

                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonSDetailsSign" name="ButtonSDetailsSign" value="Sign" onclick="DetailsSignDocument('SeizureDetails')" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="SpanSignedBy" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="SpanSignedBySeizureDetails" class="form_label_text" name="SpanSignedBySeizureDetails"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="SpanDateSigned" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSignedSeizureDetails" class="form_label_text" name="Span_DateSignedSeizureDetails"></span>
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
                                        <tr>
                                            <td class="content_tab_bg"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="SeizureIndividualStatusTable">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Follow Up of Individual Status
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <span id="SpanNurseStaffEvaluating" name="SpanNurseStaffEvaluating" style="padding-right: 10px;">Nurse/staff evaluating</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="" onchange="GetSuffix(this);">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="SpanCredentialTitle" name="SpanCredentialTitle" style="padding-left: 222px; padding-right: 10px;">Credential/title</span>
                                                            <input type="text" name="TextBoxTime_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusCredentialTitle"
                                                                id="TextBoxTime_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusCredentialTitle" style="width: 201px;" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Details of injury/illness and treatment provided
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusDetailsOfInjury" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusDetailsOfInjury" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Comments
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusComments" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusComments" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                     <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                               
                                                            <input type="checkbox" id="CheckBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsEmergencyMedicationsGiven"
                                                                name="CheckBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsEmergencyMedicationsGiven" />
                                                            <label for="CheckBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsEmergencyMedicationsGiven" class="form_label" style="padding-right: 14px;">
                                                                Emergency medications given
                                                            </label>
                                                            <input type="checkbox" id="CheckBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsO2Given"
                                                                name="CheckBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsO2Given" onchange="ShowHideTextBox();" />
                                                            <label for="CheckBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsO2Given" class="form_label" style="padding-right: 25px;">
                                                                O2 Given
                                                            </label>
                                                            <input style="width: 50px;" class="form_textbox element" type="text" id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsLiterMin"
                                                                name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureDetailsLiterMin" />
                                                            <span id="SpanLiterMin">Liter/Min</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="Span21" class="form_label" name="SpanIndividual" style="padding-right: 20px;">Family/Guardian/Custodian notified?</span>

                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusFamilyGuardianCustodianNotified_N" style="cursor: default">
                                                                No</label>

                                                            <span id="SpanFollowUpIndividualStatusDateOfNotification" class="form_label" name="SpanFollowUpIndividualStatusDateOfNotification" style="padding-left: 71px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusDateOfNotification"
                                                                name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img3" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="SpanFollowUpIndividualStatusTimeOfNotification" class="form_label" name="SpanFollowUpIndividualStatusTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBoxTime_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusTimeOfNotification" id="TextBoxTime_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="SpanFollowUpIndividualStatusStaffCompletedNotification" class="form_label" name="SpanFollowUpIndividualStatusStaffCompletedNotification" style="padding-right: 10px;">Staff who completed Notification</span>
                                                            <%--<input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification"
                                                                name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification" />--%>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification" Width="150px"
                                                                name="DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="SpanFollowUpIndividualStatusNameOfFamilyGuardianCustodian" class="form_label" name="SpanFollowUpIndividualStatusNameOfFamilyGuardianCustodian" style="padding-left: 66px; padding-right: 11px;">Name of the family/guardian/custodian notified</span>
                                                            <input type="text" class="form_textarea" style="width: 150px;" id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNameOfFamilyGuardianCustodian"
                                                                name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNameOfFamilyGuardianCustodian" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div>
                                                                <table  width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                           <td width="40%"  style="padding-left: 117px;">
                                                                            <span id="Span_CustomIncidentReportSeizureFollowUpOfIndividualStatusesNoteType" class="form_label" name="SpanID" style="padding-right:2px">Note Type</span>
                                                                            
                                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteType" Width="149px"
                                                                                name="DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteType" runat="server" AddBlankRow="True"
                                                                                BlankRowText="" valuetype="">
                                                                            </cc3:StreamlineDropDowns>
                                                                            </td>
                                                                           <td width="30%">
                                                                               <span id="SpanFollowUpIndividualStatusNoteStart" class="form_label" name="SpanFollowUpIndividualStatusNoteStart" style="padding-left: 71px;">Note Start</span>
                                                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteStart"
                                                                                    name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteStart" style="width: 67px; height: 15px; padding-right: 2px"
                                                                                    class="form_textbox" />
                                                                                <img id="img_CustomIncidentReportSeizureFollowUpOfIndividualStatusesNoteStart" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                    onclick="return showCalendar('TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteStart', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                                    alt="Calendar" />
                                                                         </td>
                                                                        <td width="30%">
                                                                               <span id="SpanFollowUpIndividualStatusNoteEnd" class="form_label" name="SpanFollowUpIndividualStatusNoteEnd" style="padding-left: 71px;">Note End</span>
                                                                                <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteEnd"
                                                                                    name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteEnd" style="width: 67px; height: 15px; padding-right: 2px"
                                                                                    class="form_textbox" />
                                                                                <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                                    onclick="return showCalendar('TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteEnd', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                                    alt="Calendar" />
                                                                         </td>
                                                                    </tr>
                                                                    
                                                                     <tr>
                                                                        <td class="height2"  colspan="3"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="3">
                                                                        <span id="Span_NoteComment" class="form_label" name="SpanFollowUpIndividualStatusNameOfFamilyGuardianCustodian" style="padding-left: 2px; padding-right: 11px;">Note Comment</span>
                                                                        <input type="text" class="form_textarea" style="width: 660px;" id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteComment"
                                                                name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteComment" />
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
                                                        <td class="form_label">Details of Notification 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusDetailsOfNotification" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusDetailsOfNotification" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonSeizureFollowUpIndividualStatusSign" name="ButtonSeizureFollowUpIndividualStatusSign" value="Sign" onclick="DetailsSignDocument('SeizureIndividualStatus')" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="Span22" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="SpanSignedBySeizureIndividual" class="form_label_text" name="SpanSignedBySeizureIndividual"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="Span24" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSignedSeizureIndividual" class="form_label_text" name="Span_DateSignedSeizureIndividual"></span>
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
                                        <tr>
                                            <td class="content_tab_bg"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="SeizureSupervisorFollowUpTable">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Supervisor Follow Up
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <span id="SeizureSupervisorFollowUpSupervisorName" name="SeizureSupervisorFollowUpSupervisorName" style="padding-right: 20px;">Supervisor name</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpSupervisorName" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpSupervisorName" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Follow up
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFollowUp" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFollowUp" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                       <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="Span27" class="form_label" name="SpanSupervisorFollowAdministratorNotified" style="padding-right: 22px;">Manager Notified</span>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerNotified"   onchange="SameManagerDTSezuire()" style="cursor: default"  />
                                                            <label for="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerNotified_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerNotified"   onchange="SameManagerDTSezuire()" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerNotified_N" style="cursor: default">
                                                                No</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="Span29" name="SpanSupervisorFollowAdministrator" style="padding-right: 63px; padding-left: 3px;">Manager</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManager" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManager" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="Span30" class="form_label" name="SpanSupervisorFollowAdminDateOfNotification" style="padding-left: 80px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification"
                                                                name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img2" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="Span31" class="form_label" name="SpanSupervisorFollowAdminTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification"
                                                                id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManagerTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="SpanSupervisorFollowAdministratorNotified" class="form_label" name="SpanSupervisorFollowAdministratorNotified" style="padding-right: 92px;">Administrator notified</span>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSeizureSupervisorFollowUpAdministratorNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministratorNotified_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministratorNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministratorNotified_N" style="cursor: default">
                                                                No</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="SpanSupervisorFollowAdministrator" name="SpanSupervisorFollowAdministrator" style="padding-right: 40px; padding-left: 3px;">Administrator</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministrator" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministrator" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="SpanSupervisorFollowAdminDateOfNotification" class="form_label" name="SpanSupervisorFollowAdminDateOfNotification" style="padding-left: 80px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdminDateOfNotification"
                                                                name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdminDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img4" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdminDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="SpanSupervisorFollowAdminTimeOfNotification" class="form_label" name="SpanSupervisorFollowAdminTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdminTimeOfNotification"
                                                                id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdminTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="SpanSupervisorFollowFamilyGuardianCustodianNotified" class="form_label" name="SpanSupervisorFollowFamilyGuardianCustodianNotified" style="padding-right: 20px;">Family/Guardian/Custodian notified?</span>

                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFamilyGuardianCustodianNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFamilyGuardianCustodianNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFamilyGuardianCustodianNotified" style="cursor: default">
                                                                No</label>

                                                            <span id="SpanSupervisorFollowFGCDateOfNotification" class="form_label" name="SpanSupervisorFollowFGCDateOfNotification" style="padding-left: 71px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFGCDateOfNotification"
                                                                name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFGCDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img5" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFGCDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="SpanSupervisorFollowFGCTimeOfNotification" class="form_label" name="SpanSupervisorFollowFGCTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFGCTimeOfNotification" id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpFGCTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="SpanSupervisorFollowStaffCompletedNotification" class="form_label" name="SpanSupervisorFollowStaffCompletedNotification" style="padding-right: 10px;">Staff who completed Notification</span>
                                                            <%--<input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification"
                                                                name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification" />--%>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification" Width="150px"
                                                                name="DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="SpanSupervisorFollowNameOfFamilyGuardianCustodian" class="form_label" name="SpanSupervisorFollowNameOfFamilyGuardianCustodian" style="padding-left: 66px; padding-right: 11px;">Name of the family/guardian/custodian notified</span>
                                                            <input type="text" class="form_textarea" style="width: 150px;"  id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpNameOfFamilyGuardianCustodian"
                                                                name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpNameOfFamilyGuardianCustodian" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Details of Notification 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpDetailsOfNotification" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpDetailsOfNotification" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonSeizureSupervisorFollowUpSign" name="ButtonSeizureSupervisorFollowUpSign" value="Sign" onclick="DetailsSignDocument('SeizureSupervisorFollowUp');" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="Span26" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="SpanSignedBySeizureSupervisor" class="form_label_text" name="SpanSignedBySeizureSupervisor"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="Span28" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSignedSeizureSupervisor" class="form_label_text" name="Span_DateSignedSeizureSupervisor"></span>
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
                                        <tr>
                                            <td class="content_tab_bg"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                             <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="TableSeizuretManagerFollowUp">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Manager Review
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <span id="SeizureSupervisorFollowUpManagerName" name="SeizureSupervisorFollowUpSupervisorName" style="padding-right: 20px;">Manager</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpManagerId" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpManagerId" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="Span32" class="form_label" name="SpanSupervisorFollowAdministratorNotified" style="padding-right: 22px;">Administrator Notified</span>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministratorNotified_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministratorNotified" style="cursor: default"  onchange="IncidentSectionsShowHide();" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministratorNotified_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministratorNotified_N" value="N"
                                                                name="RadioButton_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministratorNotified" style="cursor: default" onchange="IncidentSectionsShowHide();" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministratorNotified_N" style="cursor: default">
                                                                No</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <span id="Span33" name="SpanSupervisorFollowAdministrator" style="padding-right: 63px; padding-left: 3px;">Administrator</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministrator" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministrator" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                            <span id="Span34" class="form_label" name="SpanSupervisorFollowAdminDateOfNotification" style="padding-left: 80px;">Date of notification</span>
                                                            <input datatype="Date" type="text" id="TextBox_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdminDateOfNotification"
                                                                name="TextBox_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdminDateOfNotification" style="width: 67px; height: 15px; padding-right: 2px"
                                                                class="form_textbox" />
                                                            <img id="img6" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                                onclick="return showCalendar('TextBox_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdminDateOfNotification', '%m/%d/%Y');" style="cursor: default; vertical-align: text-bottom;"
                                                                alt="Calendar" />
                                                            <span id="Span35" class="form_label" name="SpanSupervisorFollowAdminTimeOfNotification" style="padding-left: 70px;">Time of Notification</span>
                                                            <input type="text" name="TextBox_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdminTimeOfNotification"
                                                                id="TextBox_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdminTimeOfNotification"
                                                                onblur="TimeNotified(this)" bindautosaveevents="False" datatype="Time" style="width: 67px" class='form_textbox' />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                   
                                                    <tr>
                                                        <td>Follow up
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSeizureManagerFollowUps_ManagerReviewFollowUp" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportSeizureManagerFollowUps_ManagerReviewFollowUp" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                       
                                                  
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonSeizuretManagerFollowUpSign" name="ButtonSeizuretManagerFollowUpSign" value="Sign" onclick="DetailsSignDocument('SeizuretManagerFollowUp');" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="Span36" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="SpanSignedBySeizuretManagerFollowUp" class="form_label_text" name="SpanSignedBySeizuretManagerFollowUp"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="Span37" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSignedSeizuretManagerFollowUp" class="form_label_text" name="Span_DateSignedSeizuretManagerFollowUp"></span>
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
                                        <tr>
                                            <td class="content_tab_bg"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="height2"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-bottom: 20px;" id="SeizureAdministrator">
                                        <tr>
                                            <td style="width: 100%;">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td class="content_tab_left" align="left" nowrap='nowrap'>Administrator Review
                                                        </td>
                                                        <td width="17">
                                                            <img style="vertical-align: top;" height="26" width="17" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_sep.gif" />
                                                        </td>
                                                        <td class="content_tab_top" width="100%"></td>
                                                        <td width="7">
                                                            <img style="vertical-align: top;" height="26" width="7" alt="" src="<%=RelativePath%>App_Themes/Includes/images/content_tab_right.gif" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top" class="content_tab_bg_padding" align="left">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <span id="SpanAdministrator" name="SpanAdministrator" style="padding-right: 40px;">Administrator</span>
                                                            <cc3:StreamlineDropDowns ID="DropDownList_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewAdministrator" Width="157px"
                                                                name="DropDownList_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewAdministrator" runat="server" AddBlankRow="True"
                                                                BlankRowText="" valuetype="">
                                                            </cc3:StreamlineDropDowns>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Administrative review
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewAdministrativeReview" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewAdministrativeReview" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="checkbox_container">
                                                            <span id="Span39" class="form_label" name="SpanIndividual" style="padding-right: 20px;">Filed reportable Incident?</span>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewFiledReportableIncident_Y" value="Y"
                                                                name="RadioButton_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewFiledReportableIncident" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewFiledReportableIncident_Y" style="cursor: default; padding-right: 5px;">
                                                                Yes</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewFiledReportableIncident_N" value="N"
                                                                name="RadioButton_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewFiledReportableIncident" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewFiledReportableIncident_N" style="cursor: default; padding-right: 5px;">
                                                                No</label>
                                                            <input type="radio" id="RadioButton_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewFiledReportableIncident_O" value="O"
                                                                name="RadioButton_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewFiledReportableIncident" style="cursor: default" />
                                                            <label for="RadioButton_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewFiledReportableIncident_O" style="cursor: default">
                                                                Other</label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Comments
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <textarea id="TextBox_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewComments" class="form_textareaWithoutWidth"
                                                                name="TextBox_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewComments" rows="4" cols="158" spellcheck="True"></textarea>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="height2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td width="15%">
                                                                        <input type="button" id="ButtonSeizureAdministratorReviewSign" name="ButtonSeizureAdministratorReviewSign" value="Sign" onclick="DetailsSignDocument('SeizureAdministrators');" class="less_detail_btn_new" />
                                                                    </td>
                                                                    <td width="8%">
                                                                        <span id="Span48" class="form_label" name="SpanSignedBy">Signed By:</span>
                                                                    </td>
                                                                    <td width="50%">
                                                                        <span id="SpanSignedBySeizureAdministrator" class="form_label_text" name="SpanSignedBySeizureAdministrator"></span>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <span id="Span50" class="form_label" name="SpanDateSigned">Date Signed:</span>
                                                                    </td>
                                                                    <td width="22%">
                                                                        <span id="Span_DateSignedSeizureAdministrator" class="form_label_text" name="Span_DateSignedSeizureAdministrator"></span>
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
                                        <tr>
                                            <td class="content_tab_bg"></td>
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

