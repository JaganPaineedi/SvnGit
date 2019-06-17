var ClientAge=0;
function SetCurrentTab(sender, e) {
    try {
        TabIndex = sender.activeTabIndex;
    }
    catch (err) { }
}

function onTabSelectedClient(sender, args) {
    onTabSelected(sender, args);
}

function onChildTabSelected(sender, arg) {
    tabobjectChild = sender;
}

function onPsychRehabChildTabSelected(sender, arg) {
    tabobjectChild = sender;
}

function disableTabClick(index, name) {
    subtabindex = index;
    subtabindexdla = index;
}

function StoreTabstripClientObject(sender) {
    try {
        tabobject = sender;
    }
    catch (err) {
        LogClientSideException(err, 'StoreTabstripClientObject');
    }
}

function SetScreenSpecificValues(dom, action) {
    try {
        if ($("input[id$=HiddenClientAge]").val() >0) {
            ClientAge = $("input[id$=HiddenClientAge]").val();
        }
        var NoDLA = $('CustomDocumentDLA20s > NoDLA', dom).text();
        if (NoDLA == "Y")
            $("#CheckBox_CustomDocumentDLA20s_NoDLA").attr("checked", true);
        else
            $("#CheckBox_CustomDocumentDLA20s_NoDLA").attr("checked", false);
        if (ClientAge < 18) {
            RefreshDLAYouthTabPage(dom);  
        }
        else if (ClientAge >=18) {
            RefreshDLATabPage(dom);
        }
    }
    catch (err) {
        LogClientSideException(err, 'SetScreenSpecificValues');
    }

}
function RefreshDLATabPage(domObject) {
   
    if ($("#DivActivityContent").length > 0 && ($.trim($("#DivActivityContent")[0].innerHTML) != "")) {
        return;
    }
    var ReturnHtml = CreateDLAControlHtml(domObject);
    $("#DivActivityContent").html(ReturnHtml);
    BindUIstepper();
    CalculateScores();
   $('.hastip').tooltipsy();
    CreateInitializationImages(domObject);
}
function RefreshDLAYouthTabPage(domObject) {   
    $('a.rtsLink').addClass('rtsSelected');    
    if ($("#DivActivityContent").length > 0 && ($.trim($("#DivActivityContent")[0].innerHTML) != "")) {
        return;
    }
    var ReturnHtml = SCDLAY.CreateDLAControlHtml(domObject);
    $("#DivActivityContent").html(ReturnHtml);
    BindUIstepper();
    SCDLAY.CalculateScores();
    $('.hastip').tooltipsy();
    CreateInitializationImages(domObject);
}