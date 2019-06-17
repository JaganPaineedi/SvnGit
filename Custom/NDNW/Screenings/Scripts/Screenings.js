function SetCurrentTab(sender, e) {
    try {
        tabIndex = sender.activeTabIndex;
        tabIndex = objectPageResponse.SelectedTabId;

    }
    catch (err) { }

}

function TruncateUnwantedData(Object, MaxLen) {
    var Text = Object.value.substring(0, MaxLen);
    $('[id$=TextArea_CustomDocumentSubstanceAbuseScreenings_Comments]').val(Text);
    return Text;

}