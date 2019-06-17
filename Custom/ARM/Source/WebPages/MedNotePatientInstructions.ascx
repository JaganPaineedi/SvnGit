<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MedNotePatientInstructions.ascx.cs" Inherits="ActivityPages_Harbor_Client_Detail_Documents_MedNote_MedNotePatientInstructions" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="margin-top: 5px">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td class="content_tab_left" align="left" width="30%">
                        Patient Instructions
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
        <td class="content_tab_bg" style="padding-left: 8px">
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <span class="form_label"><i>Standard Patient Instructions will always appear on the
                            printout</i></span>
                    </td>
                </tr>
                <tr>
                    <td style="height: 10px">
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="form_label">Additional Instrunctions</span>
                    </td>
                </tr>
                <tr>
                    <td class="height1">
                    </td>
                </tr>
                <tr>
                    <td>
                        <textarea rows="6" cols="160" id="TextArea_CustomDocumentMedicationReviewNotes_OtherInstructions"
                            class="form_textarea">
    </textarea>
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
