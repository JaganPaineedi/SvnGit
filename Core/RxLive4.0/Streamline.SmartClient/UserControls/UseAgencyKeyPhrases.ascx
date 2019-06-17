<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UseAgencyKeyPhrases.ascx.cs" Inherits="UserControls_UseAgencyKeyPhrases" %>
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
        var Outcomestring = $('[id$=HiddenField_UseAgencyKeyPhraseContainerJSON]').val();

        var out = Outcomestring.replace(/\\'/g, "'");
        if (checkjsonstring(out) == true) {
            var Outcomejson = $.parseJSON(out);
            if (Outcomejson.length > 0) {           
                   $("#UseAgencyKeyPhraseContainerOutcome").append($('#UseAgencyKeyPhraseContainerHTML').render(Outcomejson));
            }
        }

        var DropDownListUseAgencyKeyPhraseCategory = $('select[id$=DropDownListUseAgencyKeyPhraseCategory]');
        ChangeUseAgencyKeyPhraseCategory($(DropDownListUseAgencyKeyPhraseCategory).val());
        $(DropDownListUseAgencyKeyPhraseCategory).bind('change', function () {
            selectedCategoryAgency = $(this).val();
            ChangeUseAgencyKeyPhraseCategory(selectedCategoryAgency);
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

    function ChangeUseAgencyKeyPhraseCategory(selectedCategoryAgency) {
        var $DivGroupByCategoryAgencyHide = $('[id*=DivGroupByCategoryAgency_]');
        var $DivGroupByCategoryAgencyShow = $('[id*=DivGroupByCategoryAgency_' + selectedCategoryAgency + ']');

        if ($('select[id$=DropDownListUseAgencyKeyPhraseCategory] option:selected').text().toLowerCase() == "all") {
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

    function UseKeyPhrase(obj) {       
        var insertedHtml = '';        
        insertedHtml = $.trim($(obj).attr('title'));        
        UseAgencyKeyPhrasesSet(insertedHtml);
    }
    function UseAgencyKeyPhrasesSet(textareakey) {      
        if (parent.SelectedTextAreaObj != undefined && parent.SelectedTextAreaObj != null) {
            $(parent.SelectedTextAreaObj).val($(parent.SelectedTextAreaObj).val().trim() + textareakey.trim());
            $(parent.SelectedTextAreaObj).trigger('change');
            $(parent.SelectedTextAreaObj).trigger('mouseup');
            $(parent.SelectedTextAreaObj).focus();
        }
    }

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
                            <asp:Label ID="LabelAgencyKeyPhraseCategory" runat="server" CssClass="labelFont" Text="Category"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:DropDownList ID="DropDownListUseAgencyKeyPhraseCategory" runat="server" CssClass="ddlist" Width="170px">
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
                <UI:Heading ID="Heading1" runat="server" HeadingText="Phrase"></UI:Heading>
            </td>
        </tr>
        <tr>
            <td class="content_tab_bg">
                <table style="border-bottom: #dee7ef 3px solid; border-left: #dee7ef 3px solid; border-right: #dee7ef 3px solid; border-top: #dee7ef 3px solid; width: 100%;"
                    cellspacing="0" cellpadding="0">
                    <tr id="UseMyKeyPhraseContainer">
                        <td style="padding: 3px;">
                            <textarea id="TextArea_AgencyNodatatodisplay" name="TextArea_AgencyNodatatodisplay" rows="3" cols="21" title="Nodatatodisplay" disabled="disabled" style="display: none;">
                      No data to display
                             </textarea>
                        </td>
                        <td>
                            <table id="UseAgencyKeyPhraseContainerOutcome" border="0" width="100%">
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="hidden" id="HiddenField_UseAgencyKeyPhraseContainerJSON" name="HiddenField_UseAgencyKeyPhraseContainerJSON" runat="server" value="" />
                        </td>
                    </tr>
                </table>
        </tr>
    </table>
</div>

<script id="UseAgencyKeyPhraseContainerHTML" type="text/x-jsrender">
    <tr>
        <td>
            <div id="DivProblem_{{:AgencyKeyPhraseId}}">
                <div id="DivGroupByCategoryAgency_{{:KeyPhraseCategory}}_{{:KeyPhraseId}}">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td>
                                <textarea id="TextArea_{{:AgencyKeyPhraseId}}" name="TextArea_{{:AgencyKeyPhraseId}}" rows="3" cols="20" title="{{:PhraseText}}" style="text-align: left" disabled="disabled">{{:PhraseText.trim()}}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="font-family: Microsoft Sans Serif; font-size: 8.25pt; cursor: pointer" onclick="javascript:return UseKeyPhrase(this);" title="{{:PhraseText}}"><u>Use</u></span>
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
