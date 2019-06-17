<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UseMyKeyPhrases.ascx.cs" Inherits="UserControls_UseMyKeyPhrases" %>
<%@ Register TagPrefix="UI" TagName="Heading" Src="~/UserControls/Heading.ascx" %>




<asp:ScriptManagerProxy runat="server" ID="SMP1">
    <Scripts>
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/jquery.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/CommonFunctions.js?rel=3_5_x_4_1" NotifyScriptLoaded="true" />
        <asp:ScriptReference Path="~/App_Themes/Includes/JS/jsrender.js" NotifyScriptLoaded="true" />
    </Scripts>
</asp:ScriptManagerProxy>

<script type="text/javascript">
    $(document).ready(function () {       
        var Outcomestring = $('[id$=HiddenField_UseMyKeyPhraseContainerJSON]').val();      
      
        var out = Outcomestring.replace(/\\'/g, "'");      
        if (checkjsonstring1(out) == true) {
           var Outcomejson = $.parseJSON(out);
          if (Outcomejson.length > 0) {               
              $("#UseMyKeyPhraseContainerOutcome").append($('#UseMyKeyPhraseContainerHTML').render(Outcomejson));
            }
        }

        var dropDownList_KeyPhrases_KeyPhraseCategory = $('select[id$=DropDownListUseKeyPhraseCategory]');
        ChangeUseMyKeyPhraseCategory($(dropDownList_KeyPhrases_KeyPhraseCategory).val());
        $(dropDownList_KeyPhrases_KeyPhraseCategory).bind('change', function () {
            selectedCategory = $(this).val();
            ChangeUseMyKeyPhraseCategory(selectedCategory);
        });
    });

    function checkjsonstring1(str) {       
        try {            
            JSON.parse(str);// var json =
            return true;
        }
        catch (err) {
            return false;
        }
    }

    function ChangeUseMyKeyPhraseCategory(selectedCategory) {
        var $DivCategoryHide = $('[id*=DivGroupByCategory_]');
        var $DivCategoryShow = $('[id*=DivGroupByCategory_' + selectedCategory + ']');

        if ($('select[id$=DropDownListUseKeyPhraseCategory] option:selected').text().toLowerCase() == "all") {
            $('#TextArea_Nodatatodisplay').css({ 'display': 'none' });
            if ($DivCategoryHide.length > 0) {
                $DivCategoryHide.show();
            }
            else {
                $('#TextArea_Nodatatodisplay').css({ 'display': 'block' });
            }
        }
        else {
            $DivCategoryHide.hide();
            $('#TextArea_Nodatatodisplay').css({ 'display': 'none' });
            if ($DivCategoryShow.length > 0) {
                $DivCategoryShow.show();
            }
            else {
                $('#TextArea_Nodatatodisplay').css({ 'display': 'block' });
            }
        }
    }

    function UseKeyPhrase(obj) {       
        var insertedHtml = '';        
        insertedHtml = $.trim($(obj).attr('title'));        
        UseMyKeyPhrasesSet(insertedHtml);
    }
    function UseMyKeyPhrasesSet(textareakey) {
        if (parent.SelectedTextAreaObj != undefined && parent.SelectedTextAreaObj != null) {
            var $txt = parent.SelectedTextAreaObj;
            var caretPos = $txt[0].selectionStart;
            var textAreaTxt = $txt.val();
          //  var txtToAdd = textareakey|| '';
            var txtToAdd = textareakey.trim();
            $txt.val(textAreaTxt.substring(0, caretPos) + txtToAdd + textAreaTxt.substring(caretPos));
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
                            <asp:Label ID="LabelKeyPhraseCategory" runat="server" CssClass="labelFont" Text="Category"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:DropDownList ID="DropDownListUseKeyPhraseCategory" runat="server" CssClass="ddlist" Width="170px">
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
                            <textarea id="TextArea_Nodatatodisplay" name="TextArea_Nodatatodisplay" rows="3" cols="21" title="Nodatatodisplay" disabled="disabled" style="display: none;">
                      No data to display
                             </textarea>
                        </td>
                        <td>
                            <table id="UseMyKeyPhraseContainerOutcome"  border="0" width="100%">
                            </table>
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <input type="hidden" id="HiddenField_UseMyKeyPhraseContainerJSON" name="HiddenField_UseMyKeyPhraseContainerJSON" runat="server" value="" />
                        </td>
                    </tr>
                </table>
        </tr>
    </table>
</div>
<script id="UseMyKeyPhraseContainerHTML" type="text/x-jsrender">
    <tr>
        <td>
            <div id="DivProblem_{{:KeyPhraseId}}">
                <div id="DivGroupByCategory_{{:KeyPhraseCategory}}_{{:KeyPhraseId}}">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td>
                                <textarea id="TextArea_{{:KeyPhraseId}}" name="TextArea_{{:KeyPhraseId}}" rows="3" cols="20" title="{{:PhraseText}}" disabled="disabled" style="text-align: left">{{:PhraseText.trim()}}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 3px">
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



