<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RxAgencyKeyPhrases.ascx.cs" Inherits="UserControls_RxAgencyKeyPhrases" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>

<asp:ScriptManagerProxy runat="server" ID="SMP1">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/ClientMedicationOrder.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/jsrender.js" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<script type="text/javascript">
    $(document).ready(function () {
        var Outcomestring = $('[id$=HiddenField_AgencyKeyPhraseContainerJSON]').val();
        if (checkjsonstring(Outcomestring) == true) {
            var Outcomejson = $.parseJSON(Outcomestring);
            if (Outcomejson.length > 0) {
                $("#AgencyKeyPhraseContainerOutcome").append($('#AgencyKeyPhraseContainerHTML').render(Outcomejson));
            }
        }

        var DropDownListAgencyKeyPhraseCategory = $('select[id$=DropDownListAgencyKeyPhraseCategory]');
        ChangeAgencyKeyPhraseCategory($(DropDownListAgencyKeyPhraseCategory).val());
        $(DropDownListAgencyKeyPhraseCategory).bind('change', function () {
            selectedCategoryAgency = $(this).val();
            ChangeAgencyKeyPhraseCategory(selectedCategoryAgency);
        });
    });

    function checkjsonstring(str) {
        try {
            var json = JSON.parse(str);
            return true;
        }
        catch (err) {
            return false;
        }
    }

    function ChangeAgencyKeyPhraseCategory(selectedCategoryAgency) {
        var $DivGroupByCategoryAgencyHide = $('[id*=DivGroupByCategoryAgency_]');
        var $DivGroupByCategoryAgencyShow = $('[id*=DivGroupByCategoryAgency_' + selectedCategoryAgency + ']');

        if ($('select[id$=DropDownListAgencyKeyPhraseCategory] option:selected').text().toLowerCase() == "all") {
            if ($DivGroupByCategoryAgencyHide.length > 0) {
                $('#TextArea_AgencyNodatatodisplay').css({ 'display': 'none' });
                $DivGroupByCategoryAgencyHide.show();
            }
            else {
                $('#TextArea_AgencyNodatatodisplay').css({ 'display': 'block' });
            }
        }
        else {
            $DivGroupByCategoryAgencyHide.hide();
            if ($DivGroupByCategoryAgencyShow.length > 0) {
                $('#TextArea_AgencyNodatatodisplay').css({ 'display': 'none' });
                $DivGroupByCategoryAgencyShow.show();
            }
            else {
                $('#TextArea_AgencyNodatatodisplay').css({ 'display': 'block' });
            }
        }
    }

    //Added By Arjun K R
    function doMagic(obj, AgencyKeyPhraseId) {   
        var temp = {};
        var value = "N";
        if ($(obj).is(':checked') == true) {
            value = "Y";
        }
        temp["AgencyKeyId"] = AgencyKeyPhraseId;
        temp["Value"] = value;
        checkboxObj[AgencyKeyPhraseId] = temp;       
    }
    //Arjun K R Code Block End Here

</script>

<div>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td style="height: 6px" colspan="3"></td>
        </tr>

        <tr>
            <td style="padding-left: 3px">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>
                            <asp:Label ID="LabelAgencyKeyPhraseCategory" runat="server" CssClass="labelFont" Text="Category"></asp:Label>&nbsp;
                            <asp:DropDownList ID="DropDownListAgencyKeyPhraseCategory" runat="server" CssClass="ddlist" Width="170px">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 5px"></td>
        </tr>


        <tr>
            <td>
                <UI:Heading ID="Heading1" runat="server" HeadingText="Favorite Phrase"></UI:Heading>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg">
                <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;"
                    cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="width: 10%; background-color: #dce5ea;"></td>
                                    <td style="background-color: #dce5ea;">
                                        <span><u>Phrase</u></span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>                  
                        <td>
                            <table id="AgencyKeyPhraseContainerOutcome" border="0" width="100%">
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="hidden" id="HiddenField_AgencyKeyPhraseContainerJSON" name="HiddenField_AgencyKeyPhraseContainerJSON" runat="server" value="" />
                        </td>
                    </tr>
                </table>
        </tr>
    </table>
</div>

<script id="AgencyKeyPhraseContainerHTML" type="text/x-jsrender">
    <tr>
        <td>
            <div id="DivProblem_{{:AgencyKeyPhraseId}}">
                <div id="DivGroupByCategoryAgency_{{:KeyPhraseCategory}}_{{:KeyPhraseId}}">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="width:10%;text-align:center">
                                <input type="checkbox" id="CheckBox_{{:AgencyKeyPhraseId}}" name="CheckBox_{{:AgencyKeyPhraseId}}"  onchange="doMagic(this,{{:AgencyKeyPhraseId}});"
                                     {{if CheckOrUnCheck=="Y"}}
                                          checked="checked" 
                                     {{/if}}                
                                />
                            </td>
                            <td>
                                <textarea id="TextArea_{{:AgencyKeyPhraseId}}" name="TextArea_{{:AgencyKeyPhraseId}}" rows="3" cols="60" title="{{:PhraseText}}" style="text-align: left;width:98%" disabled="disabled">{{:PhraseText.trim()}}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 5px"></td>
                        </tr>
                    </table>
                </div>
            </div>
        </td>
    </tr>
</script>

