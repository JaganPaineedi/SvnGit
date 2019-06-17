<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AIMS.ascx.cs" Inherits="Custom_PsychiatricNote_WebPages_AIMS" %>
<%@ Register Assembly="Streamline.DotNetDropDowns" Namespace="Streamline.DotNetDropDowns"
    TagPrefix="cc3" %>
<%@ Register Assembly="Streamline.DotNetDropDownGlobalCodes" Namespace="Streamline.DotNetDropDownGlobalCodes"
    TagPrefix="DropDownGlobalCodes" %>

<%--<script language="javascript" type="text/javascript" src="<%=RelativePath%>Custom/AIMS/Scripts/AIMS.js"></script>--%>

<div>
    <table border="0" cellspacing="0" cellpadding="0" class="DocumentScreen">
        <tr>
            <td colspan="3">
                <table width="820px" border="0" cellspacing="0" cellpadding="0" id="tableAIMSIdDropDown">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 10px;">
                                        <span id="AIMSS">MOVEMENT RATINGS: Rate highest severity observed. Rate movements that
                                            occur upon activation one less than those observed spontaneously. </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="height2"></td>
                                </tr>
                           <%--     <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Facial and Oral Movements
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
                                </tr>--%>

                                
                                   <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td style="width: 5%" class="content_tab_left" align="left" nowrap='nowrap'>Facial and Oral Movements
                    </td>
                    <td>
                        <img style="vertical-align: top" src="<%=RelativePath%>App_Themes/Includes/Images/content_tab_sep.gif"
                            width="17" height="26" alt="" />
                    </td>
                    <td class="content_tab_top" width="100%">
                        <div style="position: relative">
                            <div style="position: absolute; bottom: -2px;padding-left:320px;" class="checkbox_container">
                                <input type="checkbox" id="CheckBox_CustomDocumentPsychiatricAIMSs_SetDeafultForMovements" name="CheckBox_CustomDocumentPsychiatricAIMSs_SetDeafultForMovements"
                                    onclick="SetDefaultsOnClick(this)" />
                                <span class="form_label" id="Span46"> Default Score to Zero</span>
                            </div>
                        </div>
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
                                    <td class="content_tab_bg" style="text-align: left; padding-left: 10px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="checkbox_container">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                                                    <tr>
                                                                        <td style="width: 70%"></td>
                                                                        <td style="width: 15%; vertical-align: top"><span><b>Current Score</b></span></td>
                                                                        <td style="width: 15%; vertical-align: top; padding-left: 10px;"><span><b>Previous Score
                                                                          
                                                                        </b></span>
                                                                            <span id="Span_CustomDocumentPsychiatricAIMSs_PreviousEffectiveDate"></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px; text-align: left">Muscle of Facial Expression (e.g., movements of forehead,
                                                                                eyebrows, periorbital area, cheeks; </span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_MuscleFacialExpression"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>
                                                                        </td>

                                                                        <td style="width: 15%; padding-left: 10px">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousMuscleFacialExpression" disabled="True"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>


                                                                            <%-- <input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousMuscleFacialExpression"
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousMuscleFacialExpression" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>
                                                                        </td>

                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <span style="padding-right: 5px">including frowning, blinking,smiling, grimacing)</span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px">Lips and Perioral Area (e.g., puckering, pouting, smacking)</span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_LipsPerioralArea"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>
                                                                        </td>
                                                                        <td style="width: 15%; padding-left: 10px">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousLipsPerioralArea" disabled="True"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                            <%--<input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousLipsPerioralArea"
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousLipsPerioralArea" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>
                                                                        </td>

                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px">Jaw (e.g., biting, clenching, chewing, mouth opening,
                                                                                lateral movement)</span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_Jaw"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                        </td>
                                                                        <td style="width: 15%; padding-left: 10px">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousJaw" disabled="True"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                            <%--<input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousJaw"
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousJaw" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>
                                                                        </td>

                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px;">Tongue (e.g., Rate only increase in movement both in and
                                                                                 out of mouth, NOT inability to sustain </span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_Tongue"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                        </td>
                                                                        <td style="width: 15%; padding-left: 10px">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousTongue" disabled="True"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>


                                                                            <%--<input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousTongue"
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousTongue" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>
                                                                        </td>

                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"><span style="padding-right: 5px;">movement)</span></td>
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
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Extremity Movements
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
                                    <td class="content_tab_bg" style="text-align: left; padding-left: 10px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="checkbox_container">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px">Upper (arms, wrists, hands, fingers) Include choreic
                                                                                movements, (i.e. rapid, 
                                                                                objectively  </span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_ExtremityMovementsUpper"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                        </td>
                                                                        <td style="width: 15%; padding-left: 10px">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsUpper" disabled="True"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>


                                                                            <%--<input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsUpper"
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsUpper" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2">
                                                                            <span style="padding-right: 5px">purposeless,irregular, spontaneous),athetoid movements  (I.e. slow, irregular, complex,
                                                                            </span>
                                                                        </td>

                                                                    </tr>
                                                                    <%-- <tr>
                                                                        <td class="height2"><span style="padding-right: 5px;"> </span></td>
                                                                    </tr>--%>
                                                                    <tr>
                                                                        <td class="height2">
                                                                            <span style="padding-right: 5px; padding-top: 2px">serpentine)Do NOT include tremor (i.e. repetitive, regular, rhythmic)</span>

                                                                        </td>

                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px">Lower (legs, knees, ankles, toes) e.g., lateral knee
                                                                                movement, foot tapping, heel dropping, foot </span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_ExtremityMovementsLower"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                        </td>
                                                                        <td style="width: 15%; padding-left: 10px">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsLower" disabled="True"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                            <%-- <input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsLower" 
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousExtremityMovementsLower" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>
                                                                        </td>

                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span style="padding-right: 5px">squirming, inversion and eversion of foot</span>
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
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Trunk Movements
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
                                    <td class="content_tab_bg" style="text-align: left; padding-left: 10px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="checkbox_container">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px">Neck, Shoulders, hips (e.g., rocking, twisting, squirming,
                                                                                pelvic gyrations)</span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_NeckShouldersHips"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                        </td>
                                                                        <td style="width: 15%; padding-left: 10px">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousNeckShouldersHips" disabled="True"
                                                                                Category="xAIMSMovements" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>


                                                                            <%-- <input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousNeckShouldersHips"
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousNeckShouldersHips" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>

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
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Global Judgement
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
                                    <td class="content_tab_bg" style="text-align: left; padding-left: 10px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="checkbox_container">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px">Severity of Abnormal Movements</span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_SeverityAbnormalMovements"
                                                                                Category="xAIMSJudgments1" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns"  AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>
                                                                            <%-- <cc3:StreamlineDropDowns CssClass="form_dropdown" parentchildcontrols="True" ID="DropDownList_CustomDocumentPsychiatricAIMSs_SeverityAbnormalMovements"
                                                                                runat="server" Width="150px">
                                                                            </cc3:StreamlineDropDowns>--%>
                                                                        </td>
                                                                        <td style="width: 15%; padding-left: 10px">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousSeverityAbnormalMovements" disabled="True"
                                                                                Category="xAIMSJudgments1" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                            <%--<input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousSeverityAbnormalMovements"
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousSeverityAbnormalMovements" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>
                                                                        </td>



                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px">Incapacitation Due to Abnormal Movements</span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_IncapacitationAbnormalMovements"
                                                                                Category="xAIMSJudgments1" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns"  AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                        </td>
                                                                        <td style="width: 15%; padding-left: 10px;">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousIncapacitationAbnormalMovements" disabled="True"
                                                                                Category="xAIMSJudgments1" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                            <%-- <input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousIncapacitationAbnormalMovements"
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousIncapacitationAbnormalMovements" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>
                                                                        </td>

                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="width: 70%">
                                                                            <span style="padding-right: 5px">Patient’s Awareness of Abnormal Movements Rate Only
                                                                                Patient’s Report</span>
                                                                        </td>
                                                                        <td style="width: 15%">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PatientAwarenessAbnormalMovements"
                                                                                Category="xAIMSJudgments2" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns"  AIMS="AIMS" AIMSPN="AIMSPN" onchange="javascript:CalculateTotalScore(this,'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore','tableAIMSIdDropDown');">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                        </td>
                                                                        <td style="width: 15%; padding-left: 10px">
                                                                            <DropDownGlobalCodes:DropDownGlobalCodes ID="DropDownList_CustomDocumentPsychiatricAIMSs_PreviousPatientAwarenessAbnormalMovements" disabled="True"
                                                                                Category="xAIMSJudgments2" runat="server" Width="150px" AddBlankRow="true" BlankRowText=""
                                                                                CssClass="form_dropdowns" exclude="Exclude">
                                                                            </DropDownGlobalCodes:DropDownGlobalCodes>

                                                                            <%-- <input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_PreviousPatientAwarenessAbnormalMovements"
                                                                                name="TextBox_CustomDocumentPsychiatricAIMSs_PreviousPatientAwarenessAbnormalMovements" readonly="true"
                                                                                tabindex="2" maxlength="100" style="width: 150px;" />--%>
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
                                    <td class="height2"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Dental
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
                                    <td class="content_tab_bg" style="text-align: left; padding-left: 10px;">
                                        <table border="0" cellspacing="0" cellpadding="0" width="98%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="100%">
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="checkbox_container">
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <span style="padding-right: 280px">Current problems with teeth and/or dentures</span>
                                                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_CurrentProblemsTeeth_Y"
                                                                                value="Y" name="RadioButton_CustomDocumentPsychiatricAIMSs_CurrentProblemsTeeth" group="tableAIMSIdDropDown"
                                                                             AIMS="AIMS"   style="cursor: default" onclick="javascript: CalculateTotalScore(this, 'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore', 'tableAIMSIdDropDown');" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_CurrentProblemsTeeth_Y" style="cursor: default; padding-right: 5px;">
                                                                                Yes</label>
                                                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_CurrentProblemsTeeth_N"
                                                                                value="N" name="RadioButton_CustomDocumentPsychiatricAIMSs_CurrentProblemsTeeth" group="tableAIMSIdDropDown"
                                                                              AIMS="AIMS"  style="cursor: default" onclick="javascript: CalculateTotalScore(this, 'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore', 'tableAIMSIdDropDown');" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_CurrentProblemsTeeth_N" style="cursor: default">
                                                                                No</label>
                                                                            <span style="padding-right: 81px"></span>
                                                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousCurrentProblemsTeeth_Y"
                                                                                value="Y" name="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousCurrentProblemsTeeth" group="tableAIMSIdDropDown" disabled="disabled" exclude="Exclude"
                                                                                style="cursor: default" onclick="javascript: CalculateTotalScore(this, 'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore', 'tableAIMSIdDropDown');" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousCurrentProblemsTeeth_Y" style="cursor: default; padding-right: 5px;">
                                                                                Yes</label>
                                                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousCurrentProblemsTeeth_N"
                                                                                value="N" name="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousCurrentProblemsTeeth" group="tableAIMSIdDropDown" disabled="disabled" exclude="Exclude"
                                                                                style="cursor: default" onclick="javascript: CalculateTotalScore(this, 'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore', 'tableAIMSIdDropDown');" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousCurrentProblemsTeeth_N" style="cursor: default">
                                                                                No</label>

                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="height2"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <span style="padding-right: 321px">Does patient usually wear dentures?</span>
                                                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_DoesPatientWearDentures_Y" group="tableAIMSIdDropDown"
                                                                                value="Y" name="RadioButton_CustomDocumentPsychiatricAIMSs_DoesPatientWearDentures"
                                                                               AIMS="AIMS"  style="cursor: default" onclick="javascript: CalculateTotalScore(this, 'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore', 'tableAIMSIdDropDown');" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_DoesPatientWearDentures_Y"
                                                                                style="cursor: default; padding-right: 5px;">
                                                                                Yes</label>
                                                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_DoesPatientWearDentures_N" group="tableAIMSIdDropDown"
                                                                                value="N" name="RadioButton_CustomDocumentPsychiatricAIMSs_DoesPatientWearDentures"
                                                                             AIMS="AIMS"    style="cursor: default" onclick="javascript: CalculateTotalScore(this, 'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore', 'tableAIMSIdDropDown');" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_DoesPatientWearDentures_N"
                                                                                style="cursor: default">
                                                                                No</label>
                                                                            <span style="padding-right: 81px"></span>
                                                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousDoesPatientWearDentures_Y" group="tableAIMSIdDropDown" disabled="disabled" exclude="Exclude"
                                                                                value="Y" name="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousDoesPatientWearDentures"
                                                                                style="cursor: default" onclick="javascript: CalculateTotalScore(this, 'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore', 'tableAIMSIdDropDown');" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousDoesPatientWearDentures_Y"
                                                                                style="cursor: default; padding-right: 5px;">
                                                                                Yes</label>
                                                                            <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousDoesPatientWearDentures_N" group="tableAIMSIdDropDown" disabled="disabled" exclude="Exclude"
                                                                                value="N" name="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousDoesPatientWearDentures"
                                                                                style="cursor: default" onclick="javascript: CalculateTotalScore(this, 'Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore', 'tableAIMSIdDropDown');" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousDoesPatientWearDentures_N"
                                                                                style="cursor: default">
                                                                                No</label>

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
                        </td>
                    </tr>
                    <tr>
                        <td class="height2"></td>
                    </tr>
                    <tr>
                        <td style="width: 100%">
                            <%--  <table>
                                <tr>
                                <td style="width: 80%"></td>

                        <td style="width: 10%">
                            <span style="padding-left: 0px; padding-right: 7px;"><b>Total Score</b></span>
                            <span id="Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore"></span>

                        </td>
                        <td style="width: 10%">
                            <span style="padding-left: 100px; padding-right: 7px;"><b>Previous Total Score</b></span>
                          
                        </td>
                                    </tr>
                            </table>--%>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                <tr>
                                    <td style="width: 60%; padding-left: 5px">
                                        <span><b>Comments</b>&nbsp;</span>
                                        <input type="text" id="TextBox_CustomDocumentPsychiatricAIMSs_AIMSComments"
                                            name="TextBox_CustomDocumentPsychiatricAIMSs_AIMSComments" class="form_textbox" style="width: 350px" />
                                    </td>
                                    <td style="width: 20%">
                                        <span><b>Current Total Score:</b>&nbsp;</span>
                                        <span id="Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore"></span>
                                    </td>
                                    <td style="width: 20%">
                                        <span><b>Previous Total Score:</b>&nbsp;</span>
                                        <span id="Span_CustomDocumentPsychiatricAIMSs_PreviousAIMSTotalScore"></span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                     <tr>
                        <td class="height2"></td>
                    </tr>
                        <tr>
                        <td style="width: 100%">

                            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="text-align: left;">
                                <tr>
                                    <td style="width:50%; padding-left: 5px">
                                      
                                    </td>
                                     <td style="width: 8%;">
                                    <b> Current:</b> 
                                    </td>
                                    <td style="width: 8%" class="checkbox_container">
                                       <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_AIMSPositveNegative_P" group="AIMSPositveNegative"
                                                                                value="P" name="RadioButton_CustomDocumentPsychiatricAIMSs_AIMSPositveNegative"
                                                                                style="cursor: default" disabled="disabled"/>
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_AIMSPositveNegative_P"
                                                                                style="cursor: default; padding-right: 5px;">
                                                                                Positive</label>
                                    </td>
                                    <td style="width: 9%" class="checkbox_container">
                                       <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_AIMSPositveNegative_N" group="AIMSPositveNegative"
                                                                                value="N" name="RadioButton_CustomDocumentPsychiatricAIMSs_AIMSPositveNegative"
                                                                                style="cursor: default"  disabled="disabled" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_AIMSPositveNegative_N"
                                                                                style="cursor: default; padding-right: 5px;">
                                                                                Negative</label>
                                    </td>
                                      <td style="width: 8%" class="checkbox_container">
                                       <b>Previous:</b>   
                                    </td>
                                     <td style="width: 8%" class="checkbox_container">
                                       <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousAIMSPositveNegative_P" group="AIMSPositveNegative"
                                                                                value="P" name="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousAIMSPositveNegative"
                                                                                style="cursor: default" disabled="disabled"/>
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousAIMSPositveNegative_P"
                                                                                style="cursor: default; padding-right: 5px;">
                                                                                Positive</label>
                                    </td>
                                    <td style="width: 9%" class="checkbox_container">
                                       <input type="radio" id="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousAIMSPositveNegative_N" group="AIMSPositveNegative"
                                                                                value="N" name="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousAIMSPositveNegative"
                                                                                style="cursor: default"  disabled="disabled" />
                                                                            <label for="RadioButton_CustomDocumentPsychiatricAIMSs_PreviousAIMSPositveNegative_N"
                                                                                style="cursor: default; padding-right: 5px;">
                                                                                Negative</label>
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
            <td class="height2"></td>
        </tr>
          <tr>
            <td class="height2"></td>
        </tr>
          <tr>
            <td class="height2"></td>
        </tr>
    </table>
</div>
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentPsychiatricAIMSs" />
<input type="hidden" id="HiddenFieldxAIMSMovements" runat="server" />
<input type="hidden" id="HiddenFieldxAIMSJudgments1" runat="server" />
<input type="hidden" id="HiddenFieldxAIMSJudgments2" runat="server" />
