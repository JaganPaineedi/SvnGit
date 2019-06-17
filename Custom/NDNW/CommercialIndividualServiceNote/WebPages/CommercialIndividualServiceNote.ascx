<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CommercialIndividualServiceNote.ascx.cs" Inherits="Custom_CommercialIndividualServiceNote_WebPages_CommercialIndividualServiceNote" %>
<% if (HttpContext.Current == null)
   { %>
<link href="../../../../../App_Themes/Styles/smartcare_styles.css" rel="stylesheet"
    type="text/css" />
<%} %>
<input id="HiddenFieldPageTables" name="HiddenFieldPageTables" type="hidden" value="CustomDocumentCommercialIndividualServiceNotes"
    runat="server" />
<script type="text/javascript" language="javascript" src="<%=RelativePath%>Custom/CommercialIndividualServiceNote/Scripts/CommercialIndividualServiceNote.js"></script>
<div class="bottom_contanier_white_bg" style="overflow-x: hidden">
    <table border="0" cellspacing="0" cellpadding="0" class="DocumentScreen" style="width: 98%">
        <tr>
            <td colspan="3">
                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">

                                            <tr>
                                                <td class="content_tab_left" align="left" nowrap='nowrap'>Service Note
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
                                    <td class="content_tab_bg">
                                        <table border="0" cellspacing="0" cellpadding="0" style="text-align: left; padding-left: 10px;"
                                            width="100%">
                                            <tr>
                                                <td align="left">
                                                    <table cellpadding="0" cellspacing="0" border="0" width="98%">
                                                        <tr>
                                                            <td class="form_label_text" align="left" valign="top">Situation Intervention Plan 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" valign="top" width="100%" style="padding-top: 2px;">
                                                                <textarea class="form_textarea" id="TextArea_CustomDocumentCommercialIndividualServiceNotes_SituationInterventionPlan"
                                                                    name="TextArea_CustomDocumentCommercialIndividualServiceNotes_SituationInterventionPlan" style="width: 98%; height: 50px"
                                                                    spellcheck="true" tabindex="1"></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="form_label_text" align="left" valign="top">Address Progress to Goal 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="left" valign="top" width="100%" style="padding-top: 2px;">
                                                                <textarea class="form_textarea" id="TextArea_CustomDocumentCommercialIndividualServiceNotes_AddressProgressToGoal"
                                                                    name="TextArea_CustomDocumentCommercialIndividualServiceNotes_AddressProgressToGoal" style="width: 98%; height: 50px"
                                                                    spellcheck="true" tabindex="2"></textarea>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="height2"></td>
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
                </table>
            </td>
        </tr>
    </table>
</div>
