function SetCurrentTab(sender, e) {
    try {
        TabIndex = sender.activeTabIndex;
    }
    catch (err) { }
}


function onTabSelectedClient(sender, args) {
    onTabSelected(sender, args, false);
}

function StoreTabstripClientObject(sender) {
    //debugger;
    tabobject = sender;
}


function disableTabClick(index, name) {
    subtabindex = index;
}


SetScreenSpecificValues = (function(dom, action) {

});


function CheckboxChange(obj, index) {

    if ($(obj).attr('checked')) {        
        if (index == 1) {
            CreateAutoSaveXml("CustomDocumentSPMIs", "Schizophrenia", 'Y');
        }
        if (index == 2) {
            CreateAutoSaveXml("CustomDocumentSPMIs", "MajorDepression", 'Y');
        }
        if (index == 3) {
            CreateAutoSaveXml("CustomDocumentSPMIs", "Anxiety", 'Y');
        }
        if (index == 4) {
            CreateAutoSaveXml("CustomDocumentSPMIs", "Personality", 'Y');
        }
        if (index == 5) {
            CreateAutoSaveXml("CustomDocumentSPMIs", "Individual", 'Y');
        }      
    }
}
