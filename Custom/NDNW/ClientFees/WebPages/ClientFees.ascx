<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ClientFees.ascx.cs" Inherits="Custom_ClientFees_WebPages_ClientFees" %>
<%@ Register Src="~/CommonUserControls/CustomGrid.ascx" TagName="CustomGrid" TagPrefix="uc1" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="cc1" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="DotNetDropDowns" %>

<script type="text/javascript" src="<%=RelativePath%>Custom/ClientFees/Scripts/jquery.multiple.select.js"></script>

<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/ClientFees/Scripts/ClientFees.js"></script>

<link href="<%=RelativePath%>Custom/ClientFees/Styles/multiple-select.css" rel="stylesheet"
    type="text/css" />
<div class="DocumentScreen">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="TableChildControl_CustomClientFees"
        parentchildcontrols="True" clearcontrol="false">
        <tr>
            <td colspan="2" class="height2">
            </td>
        </tr>
        <tr>
            <td width="100%">
                <table cellspacing="0" cellpadding="0" border="0" width="100%" class="DocumentScreen">
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="Span13">Client Fee</span>
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
                            <table border="0" cellpadding="0" cellspacing="0" style="height: 100%; width: 100%;">
                                <tr>
                                    <td width="100%" align="left" style="padding-left: 2px">
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td style="width: 10%">
                                                    <span class="form_label" id="Span2" name="ClientD">Client Fee ID</span>
                                                </td>
                                                <td style="width: 20%">
                                                    <input class="form_textarea" type="text" id="TextBox_CustomClientFees_ClientFeeId"
                                                        maxlength="25" name="TextBox_ClientFeeId" style="width: 90px" disabled="disabled"
                                                        bindautosaveevents="False" />
                                                </td>
                                                <td style="width: 8%">
                                                </td>
                                                <td width="1%">
                                                </td>
                                                <td style="width: 61%">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="form_label" id="Span3" name="ClientD">Begin Date</span>
                                                </td>
                                                <td>
                                                    <input datatype="Date" id="TextBox_CustomClientFees_StartDate" name="TextBox_CustomClientFees_StartDate"
                                                        style="width: 90px; vertical-align: middle;" class="form_textarea" type="text"
                                                        parentchildcontrols="True" />
                                                    <img id="img7" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        style="vertical-align: middle" alt="Calendar" onclick="return showCalendar('TextBox_CustomClientFees_StartDate', '%m/%d/%Y');" />
                                                </td>
                                                <td style="width: 10%; padding-left: 10px">
                                                    <span class="form_label" id="Span4" name="ClientD">End Date</span>
                                                </td>
                                                <td>
                                                </td>
                                                <td>
                                                    <input datatype="Date" id="TextBox_CustomClientFees_EndDate" name="TextBox_CustomClientFees_EndDate"
                                                        style="width: 90px; vertical-align: middle;" class="form_textarea" type="text"
                                                        parentchildcontrols="True" />
                                                    <img id="img1" src="<%=RelativePath%>App_Themes/Includes/Images/calender_grey.gif"
                                                        style="vertical-align: middle" alt="Calendar" onclick="return showCalendar('TextBox_CustomClientFees_EndDate', '%m/%d/%Y');" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="5">
                                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                        <tr>
                                                            <td width="23%">
                                                                <span class="form_label" id="Span1" name="ClientD">Charge Member % of Standard Rate</span>
                                                            </td>
                                                            <td width="7%">
                                                                <input class="form_textarea" type="text" id="TextBox_CustomClientFees_StandardRatePercentage"
                                                                    maxlength="4" name="TextBox_CustomClientFees_StandardRatePercentage" style="width: 40px"
                                                                    datatype="Decimal" size="2" autocomplete="off" parentchildcontrols="True" />%
                                                            </td>
                                                            <td width="10%" style="padding-left: 20px">
                                                                <span class="form_label" id="Span6" name="ClientD">OR </span>
                                                            </td>
                                                            <td width="1%">
                                                                $
                                                            </td>
                                                            <td width="59%">
                                                                <input class="form_textarea" type="text" id="TextBox_CustomClientFees_Rate" name="TextBox_CustomClientFees_Rate"
                                                                    style="width: 70px" datatype="Number" autocomplete="off" parentchildcontrols="True" maxlength="12"/>
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
                                                <td colspan="5">
                                                    <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                                        <tr>
                                                            <td width="10%">
                                                                <span class="form_label" id="Span8" name="ClientD">Location(s)</span>
                                                            </td>
                                                            <td width="20%">
                                                                <%--   <cc1:DropDownGlobalCodes ID="LocationDD" EnableViewState="false" AddBlankRow="false"
                                                                    BlankRowText="" runat="server" Category="XPROBLEMSTATUS" Style="width: 60%;"
                                                                    bindsetformdata="False" bindautosaveevents="False">
                                                                </cc1:DropDownGlobalCodes>--%>
                                                                <DotNetDropDowns:StreamlineDropDowns ID="LocationDD" BlankRowText="" runat="server"
                                                                    EnableViewState="false" AddBlankRow="false" bindautosaveevents="False" bindsetformdata="False"
                                                                    Style="width: 91%;">
                                                                </DotNetDropDowns:StreamlineDropDowns>
                                                            </td>
                                                            <td width="10%" style="padding-left: 10px">
                                                                <span class="form_label" id="Span9" name="ClientD">Program(s)</span>
                                                            </td>
                                                            <td width="1%">
                                                            </td>
                                                            <td width="64%">
                                                                <%--<cc1:DropDownGlobalCodes ID="ProgramDD" EnableViewState="false" AddBlankRow="false"
                                                                    BlankRowText="" runat="server" Category="XPROBLEMSTATUS" Style="width: 60%;"
                                                                    bindsetformdata="False" bindautosaveevents="False">
                                                                </cc1:DropDownGlobalCodes>--%>
                                                                <DotNetDropDowns:StreamlineDropDowns ID="ProgramDD" BlankRowText="" runat="server"
                                                                    EnableViewState="false" AddBlankRow="false" bindautosaveevents="False" bindsetformdata="False"
                                                                    Style="width: 32%;">
                                                                </DotNetDropDowns:StreamlineDropDowns>
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
                                    <td colspan="5">
                                        <span class="form_label" id="Span10" name="ClientD">Comment</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                            <tr>
                                                <td style="padding-left: 3px">
                                                    <textarea id="TextArea_CustomClientFees_Comment" runat="server" spellcheck="True"
                                                        class="form_textareaWithoutWidth" name="TextArea_CustomClientFees_Comment" rows="4"
                                                        bindautosaveevents="False" cols="160" parentchildcontrols="True"></textarea>
                                                    <%-- <input class="form_textarea" type="text" id="TextArea_CustomClientFees_Comment" name="TextArea_CustomClientFees_Comment"
                                                        cols="160" rows="4" autocomplete="off" parentchildcontrols="True" />--%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="height2">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" style="padding-right: 18px">
                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td width="60%" style="padding-right: 5px">
                                                                <input type="button" id="TableChildControl_CustomClientFees_ButtonInsert" class="parentchildbutton"
                                                                    name="TableChildControl_CustomClientFees_ButtonInsert" baseurl="<%=ResolveUrl("~") %>"
                                                                    value="Insert" />
                                                            </td>
                                                            <td width="40%" valign="top" align="left">
                                                                <input type="button" class="parentchildbutton" id="TableChildControl_CustomClientFees_ButtonClear"
                                                                    onclick="ClearTable('TableChildControl_CustomClientFees', 'TableChildControl_CustomClientFees_ButtonInsert', false);"
                                                                    name="TableChildControl_CustomClientFees_ButtonClear" value="Clear" />
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
                                    <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                        width="2">
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
            <td width="100%">
                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="DocumentScreen">
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tr>
                                    <td class="content_tab_left" align="left" nowrap='nowrap'>
                                        <span id="Span7">Fee Details</span>
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
                            <table cellpadding="0" cellspacing="0" border="0" style="width: 100%;" id="TableChildControl_CustomClientFees">
                                <tr>
                                    <td align="left" style="padding-left: 5px; padding-right: 1px; width: 100%;">
                                        <div id="InsertGridClientFees" runat="server" style="width: 100%; overflow-x: hidden;
                                            overflow-y: auto; height: 150px">
                                            <uc1:CustomGrid ID="CustomGridClientFees" style="width: 100%" runat="server" TableName="CustomClientFees"
                                                PrimaryKey="ClientFeeId" CustomGridTableName="TableChildControl_CustomClientFees"
                                                ColumnName="StartDate:EndDate:StandardRatePercentage1:LocationsText:ProgramsText:Comment:"
                                                ColumnFormat="Date:Date::" DoNotDisplayDeleteImage="false" ColumnHeader="Begin Date:End Date:%/$ of Standard Rate:Location(s):Program(s):Comment"
                                                ColumnWidth="10%:10%:15%:15%:15%:33%" DivGridName="InsertGridClientFees" DoNotDisplayRadio="false"
                                                InsertButtonId="TableChildControl_CustomClientFees_ButtonInsert" OrderByQuery="StartDate desc" />
                                        </div>
                                        <input type="hidden" id="HiddenField_CustomClientFees_ClientFeeId" name="HiddenField_CustomClientFees_ClientFeeId"
                                            parentchildcontrols="True" value="-1" />
                                        <input type="hidden" id="HiddenField_CustomClientFees_ClientId" name="HiddenField_CustomClientFees_ClientId"
                                            parentchildcontrols="True" runat="server" />
                                        <input type="hidden" id="HiddenField_CustomClientFees_StandardRatePercentage1" name="HiddenField_CustomClientFees_StandardRatePercentage1"
                                            parentchildcontrols="True" />
                                        <input type="hidden" id="HiddenField_CustomClientFees_Programs" name="HiddenField_CustomClientFees_Programs"
                                            parentchildcontrols="True" />
                                        <input type="hidden" id="HiddenField_CustomClientFees_ProgramsText" name="HiddenField_CustomClientFees_ProgramsText"
                                            parentchildcontrols="True" />
                                        <input type="hidden" id="HiddenField_CustomClientFees_Locations" name="HiddenField_CustomClientFees_Locations"
                                            parentchildcontrols="True" />
                                        <input type="hidden" id="HiddenField_CustomClientFees_LocationsText" name="HiddenField_CustomClientFees_LocationsText"
                                            parentchildcontrols="True" />
                                        <input type="hidden" id="HiddenFieldPrimaryKey" name="HiddenFieldPrimaryKey" value="ClientFeeId" />
                                        <input type="hidden" id="HiddenFieldForigenKey" name="HiddenFieldForigenKey" value="ClientId" />
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
                                    <td style="vertical-align: top;" class="right_bottom_cont_bottom_bg" align="right"
                                        width="2">
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
</div>
