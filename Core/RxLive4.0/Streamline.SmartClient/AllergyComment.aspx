<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AllergyComment.aspx.cs" Inherits="AllergyComment" %>

<%@ Register TagPrefix="UI" TagName="Heading" Src="BasePages/UI/Heading.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Comments</title>
    <link href="App_Themes/Includes/Style/Common.css?rel=3_5_x_4_1" rel="stylesheet" type="text/css" />
    <script language="JavaScript" src="App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" type="text/javascript"></script>
    <style type="text/css">
            .labelfor {
                font-family: Microsoft Sans Serif;
                font-size: 8.5pt;
                text-decoration: none;
            }
    </style>
    <script type="text/javascript" language="javascript">
    var AllergyComment = {
        closeDiv: function() {
            try {
                var DivSearch = parent.document.getElementById('DivSearch');
                DivSearch.style.display = 'none';
                    } catch(e) {
                Streamline.SmartClient.ExceptionManager.getInstance().publishException(ERROR_CODE_REGULAR, e);
            }
        },
        SaveComments: function() {
            try {               
                var AllergyId = $("#HiddenClientAllergyId").val();
                var AllergyType; // = $("#ClientAllergies_AllergyType").val();
                        if ($("#ClientAllergies_AllergyType_A")[0].checked == true) {
                    AllergyType = "A";
                        } else if ($("#ClientAllergies_AllergyType_I")[0].checked == true) {
                    AllergyType = "I";
                        } else if ($("#ClientAllergies_AllergyType_F")[0].checked == true) {
                    AllergyType = "F";
                }
                var AllergyActive = $("#ClientAllergies_IsActive")[0].checked == true ? 'Y' : 'N';
                var Comments = encodeURIComponent($("#ClientAllergies_Comment").val()).replace("'","%27");
                var FilterList = $("#HiddenClientAllergyFilterList").val();
                        AllergySearch.SaveAllergyComments(AllergyId, AllergyType, AllergyActive, Comments, FilterList);
                    } catch(ex) {
            }
        }
    }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" EnablePartialRendering="true" runat="server">
            <Services>
                <asp:ServiceReference Path="WebServices/ClientMedications.asmx" InlineScript="true" />
            </Services>
            <Scripts>
                <asp:ScriptReference Path="App_Themes/Includes/JS/AllergySearch.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
            </Scripts>
        </asp:ScriptManager>
        <div>
            <table border="0" cellpadding="0" cellspacing="0" width="98%" style="padding: 2%;">
                <tr>
                    <td colspan="3">
                        <UI:Heading ID="Heading" HeadingText="Comments" runat="server" />
                    </td>
                </tr>
                <!-- Added by Loveena in ref to Task#86 to add Comments Field!-->
                <tr>
                    <td colspan="3">
                        <textarea id="ClientAllergies_Comment" runat="server" rows="5" style="height: 100%; overflow: auto; width: 360px; border: 3px solid rgb(222, 231, 239);"></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="3" style="padding-bottom: 8px; padding-top: 10px;">
                        <div style="float: left;">

                            <label for="ClientAllergies_AllergyType_A">
                                <input runat="server" type="radio" name="ClientAllergies_AllergyType" id="ClientAllergies_AllergyType_A" value="A" /><span class="radiobtntext">Allergy</span></label>
                            <label for="ClientAllergies_AllergyType_I">
                                <input runat="server" type="radio" name="ClientAllergies_AllergyType" id="ClientAllergies_AllergyType_I" value="I" /><span class="radiobtntext">Intolerance</span></label>
                            <label for="ClientAllergies_AllergyType_F">
                                <input runat="server" type="radio" name="ClientAllergies_AllergyType" id="ClientAllergies_AllergyType_F" value="F" /><span class="radiobtntext">Failed Trial</span></label>
                        </div>
                        <div style="padding-right: 5px; text-align: right;">
                            <label for="ClientAllergies_IsActive">
                                <input runat="server" type="checkbox" name="ClientAllergies_IsActive" id="ClientAllergies_IsActive" /><span class="radiobtntext">Active</span></label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center;" colspan="3">
                        <input type="button" id="ButtonSelect" style="margin-right: 10px; padding-left: 15px; padding-right: 15px;" value="Update" class="btnimgexsmall" onclick=" AllergyComment.SaveComments(); " />
                        <input type="button" id="ButtonCancel" style="padding-left: 15px; padding-right: 15px;" value="Cancel" class="btnimgexsmall" onclick="AllergyComment.closeDiv()" />
                    </td>
                </tr>
            </table>
            <input type="hidden" id="HiddenClientAllergyId" runat="server" />
            <input type="hidden" id="HiddenClientAllergyFilterList" runat="server" />
        </div>
    </form>
</body>

</html>
