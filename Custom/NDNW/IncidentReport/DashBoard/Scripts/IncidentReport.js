function OpenCaseLoad(screenType, screenId, filterValue, tabIndex) {

    OpenPage(screenType, screenId, 'filterValues=' + filterValue, tabIndex, GetRelativePath());

}

function HandleServicesForToday(keyFieldValue, documentId, clientId, ClientName) {
    if (ClientName != null && ClientName != undefined) {
        ClientName = unescape(ClientName);
    }
   
}
function OpenClientSummary(clientId, clientName) {

    if (clientName != null && clientName != undefined) {
        clientName = unescape(clientName);
    }
  
}

function display_tool_tips(labeltext, labelSubject) {

}

function OpenMyServiceListPage(errorType) {
}


function ShowWayToolTip() {

    var borderStyle = "1px solid black";
    $('a[showToolTip$="true"]').each(function() {
        var currentAnchorTag = $(this);
        var tooltipText = currentAnchorTag.attr("tooltipText");
        ShowToolTipWithStaticTextAndStyle(currentAnchorTag, tooltipText, null, "lightyellow", "black", null, borderStyle, 0, null);
    });
}


function ShowWayToolTip1(Object) {
    var borderStyle = "1px solid black";
    var currentAnchorTag = $(Object).find('span');
    var tooltipText = currentAnchorTag.attr("NewTitle");
    ShowToolTipWithStaticTextAndStyle(currentAnchorTag, tooltipText, null, "lightyellow", "black", null, borderStyle, 0, null);

}
