// JS for CANS Document

var tabobject1 = '';
var SubstanceAbuse_1 = $('#RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse_1');
var SubstanceAbuse_2 = $('#RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse_2');
var SubstanceAbuse_3 = $('#RadioButton_CustomDocumentCANSGenerals_SubstanceAbuse_3');

var AdjustmenttoTrauma_1 = $('#RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma_1');
var AdjustmenttoTrauma_2 = $('#RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma_2');
var AdjustmenttoTrauma_3 = $('#RadioButton_CustomDocumentCANSGenerals_AdjustmenttoTrauma_3');

function SetScreenSpecificValues(dom, action) {
    $("#GeneralTabTable").find("input[type=radio]").css('cursor', 'default');
    $("#YouthStrengthTabTable").find("input[type=radio]").css('cursor', 'default');
    $("#ModuleTabId").find("input[type=radio]").css('cursor', 'default');
    var i = GetFielValueFromXMLDom(dom, "CustomDocumentCANSGenerals", "SubstanceAbuse");
    var j = GetFielValueFromXMLDom(dom, "CustomDocumentCANSGenerals", "AdjustmenttoTrauma");
    showhideModules(i, j);
    showhideSubstanceAbuseModule(i);
    showhideTraumaModule(j);
}

function showhideModules(i2, j2) {

    var Modules_tab = tabobject1.findTabByText('Modules');
    var showsection1 = false;
    if (i2 == 1 || i2 == 2 || i2 == 3 || j2 == 1 || j2 == 2 || j2 == 3) {
        showsection1 = true;
    }

    if (SubstanceAbuse_1.attr('checked') || SubstanceAbuse_2.attr('checked') || SubstanceAbuse_3.attr('checked') || AdjustmenttoTrauma_1.attr('checked') || AdjustmenttoTrauma_2.attr('checked') || AdjustmenttoTrauma_3.attr('checked') || showsection1 == true) {
        showhideTab(Modules_tab, true);
    }
    else {
        showhideTab(Modules_tab, false);
    }

}


function showhideSubstanceAbuseModule(i1) {
    //    var i = GetFielValueFromXMLDom(dom2, "CustomDocumentCANSGenerals", "SubstanceAbuse");
    var showsection = false;
    if (i1 == 1 || i1 == 2 || i1 == 3) {
        showsection = true;
    }
    $SubstanceAbuseModule = $('#SubstanceAbuseModule');
    if (SubstanceAbuse_1.attr('checked') || SubstanceAbuse_2.attr('checked') || SubstanceAbuse_3.attr('checked') || showsection == true) {
        $SubstanceAbuseModule.css('display', 'block');
    }
    else {
        $SubstanceAbuseModule.css('display', 'none');
    }
}

function showhideTraumaModule(j1) {
    //    var j = GetFielValueFromXMLDom(dom3, "CustomDocumentCANSGenerals", "AdjustmenttoTrauma");
    var showsection2 = false;
    if (j1 == 1 || j1 == 2 || j1 == 3) {
        showsection2 = true;
    }

    $TraumaModule = $('#TraumaModule');
    if (AdjustmenttoTrauma_1.attr('checked') || AdjustmenttoTrauma_2.attr('checked') || AdjustmenttoTrauma_3.attr('checked') || showsection2 == true) {
        $TraumaModule.css('display', 'block');
    }
    else {
        $TraumaModule.css('display', 'none');
    }
}

function showhideTab(tabInstance, showTab) {
    if (tabInstance != null) {

        if (showTab == true) {
            tabInstance.show();
            tabInstance.set_visible(true);

        }
        else {
            tabInstance.hide();
            tabInstance.set_visible(false);

        }
    }
}

function StoreTabstripClientObject(sender) {

    tabobject1 = sender;
}
 