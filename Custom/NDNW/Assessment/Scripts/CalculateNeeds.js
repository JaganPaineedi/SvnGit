function CalculateNeeds() {
    DownloadScreenTabs();
    return;

}

function DownloadScreenTabs() {
    try {
        downloadAllTabs = true;
        ShowHideErrorMessage('', 'false');
        counterLoopForSpellCheck = 0;
        initiateSpellCheck = true;

        //Find the TabObject Instance
        var TabStripObject = $('div[id*=RadTabStrip1]');

        var selectedTabIndex = 0;

        if (TabStripObject.length >= 1) {
            TabsType = "Telerik";
            TabControlId = (TabStripObject[0]);
            TabComponent = $find(TabControlId.id);
            TabstoBeVisited = TabComponent.get_allTabs().length;
            if (TabComponent.get_selectedTab() != null && TabComponent.get_selectedTab().get_index() == selectedTabIndex) {
                if (TabComponent.get_allTabs()[0]._getNextVisibleTab() != null) {
                    counterLoopForSpellCheck = TabComponent.get_allTabs()[0]._getNextVisibleTab().get_index();
                    var firstTab = TabComponent.get_allTabs()[0]._getNextVisibleTab();
                    firstTab.click();
                }
                else {
                    if (typeof (TabsDownloadCompleted) == 'function') {
                        TabsDownloadCompleted(TabComponent, TabsType);
                    }
                    return;

                }

            }
            else if (TabComponent.get_selectedTab() != null && TabComponent.get_selectedTab().get_index() > 0) {
                if (TabComponent.get_allTabs()[0]._getNextVisibleTab() != null) {
                    counterLoopForSpellCheck = TabComponent.get_allTabs()[0]._getNextVisibleTab().get_index();
                    var firstTab = TabComponent.get_allTabs()[0]._getNextVisibleTab();
                    firstTab.click();
                }
                else {
                    if (typeof (TabsDownloadCompleted) == 'function') {
                        TabsDownloadCompleted(TabComponent, TabsType);
                    }
                    return;

                }
            }
            else if (TabComponent.get_selectedTab() == null) {
                if (typeof (TabsDownloadCompleted) == 'function') {
                    TabsDownloadCompleted(TabComponent, TabsType);
                }
                return;

            }


        }
        else if (MultiTabControlName != "") {
            TabsType = "DevEx";

            if ($("table[id$=_" + MultiTabControlName + "][class='dxtcControl']").length > 0) {
                var TabComponentId = $("table[id$=_" + MultiTabControlName + "][class='dxtcControl']")[0].id;
                TabComponent = eval(TabComponentId);
            }
            else
                TabComponent = eval(MultiTabControlName);


            //TabComponent = eval(MultiTabControlName);
            TabstoBeVisited = TabComponent.GetTabCount();
            if (TabComponent.HasNextVisibleTabs(0) == false) {
                if (typeof (TabsDownloadCompleted) == 'function') {
                    TabsDownloadCompleted(TabComponent, TabsType);
                }
                return;
            }
            if (TabComponent.GetTab(1) != null) {
                counterLoopForSpellCheck = counterLoopForSpellCheck + 1;

                TabComponent.RaiseTabClick(0, onTabSelected);
            }
            else {
                if (typeof (TabsDownloadCompleted) == 'function') {
                    TabsDownloadCompleted(TabComponent, TabsType);
                }
                return;

            }


        }
        else {
            if (typeof (TabsDownloadCompleted) == 'function') {
                TabsDownloadCompleted(TabComponent, TabsType);
            }
            return;
        }

    }


    catch (e) {
        HidePopupProcessing();
        //        alert(e);
    }
}
//Changes made by Vikas Kashyup- 6/Dec/2011 -Ref Task 485 - To add and remove DLA from need list according to score on tab hide and show
function clickTab(_tab) {
    _tab.click();
}


function CalculateDLA(tabObject) {
    // debugger;
    var collectionCustomDailyLivingActivityScores = $('CustomDailyLivingActivityScores', AutoSaveXMLDom);
    //Changes made by Vikas Kashyup- 17/Nov/2011 -Ref Task 305 - To add and remove DLA from need list according to score on tab hide and show 
    var _domDLAActivities = $.xmlDOM($("[id$=HiddenCustomHRMActivitiesDataTable]").val())[0];
    XmlHrmDla = _domDLAActivities.firstChild.childNodes;
    var Count = XmlHrmDla.length;
    var xmlScore = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomDailyLivingActivityScores");
    var _Xml = AutoSaveXMLDom[0];
    //Changes end here
    if (collectionCustomDailyLivingActivityScores.length > 0) {

        for (var i = 0; i < Count; i++) {

            var HRMActivityId = XmlHrmDla[i].selectNodes("HRMActivityId")[0].text;
            //Changes made by Vikas Kashyup- 17/Nov/2011 - Ref Task 305 - To add and remove cafas from need list according to score on tab hide and show 
            var HRMNeedId = XmlHrmDla[i].selectNodes("AssociatedHRMNeedId")[0].text;
            var activityIdFromCustomDailyLiving = collectionCustomDailyLivingActivityScores.find('HRMActivityId[text=' + HRMActivityId + ']');
            if (activityIdFromCustomDailyLiving.length > 0) {
                //Changes made by Vikas Kashyup- 17/Nov/2011 -Ref Task 305 - To add and remove DLA from need list according to score on tab hide and show 
                //if (parseInt(activityIdFromCustomDailyLiving.parent().find('ActivityScore').text()) > 0 && parseInt(activityIdFromCustomDailyLiving.parent().find('ActivityScore').text()) < 5) 
                //{
                var ctrlName = "TextBox_CustomDailyLivingActivityScores0_ActivityScore_" + i;
                var ctrl = $('#' + ctrlName, tabObject.get_pageView().get_element());
                if (ctrl.length > 0) {
                    executeChangeEventWithScript = true;
                    ctrl.change();
                }
                //Changes made by Vikas Kashyup- 17/Nov/2011 -Ref Task 305 - To add and remove DLA from need list according to score on tab hide and show 
                else {
                    var columnName = 'HRMActivityId:ActivityScore'.split(':');
                    var primaryKeyName = 'HRMActivityId';
                    var fieldvalue = '';
                    if (xmlScore.length > 0) {
                        var ActivityScore = $(xmlScore).find(primaryKeyName + '[text=' + HRMActivityId + ']').parent().find('ActivityScore').text();
                        var XmlHrmNeed = $("CustomHRMAssessmentNeeds", _Xml);
                        if (parseInt(ActivityScore) > 0 && parseInt(ActivityScore) < 5) {
                            XmlHrmNeed.find("HRMNeedId[text=" + HRMNeedId + "]").parent().find("RecordDeleted").text('N');
                        }
                        else {
                            XmlHrmNeed.find("HRMNeedId[text=" + HRMNeedId + "]").parent().find("RecordDeleted").text('Y');
                        }
                    }
                    AddToUnsavedTables("CustomHRMAssessmentNeeds");
                }
                //Changes End here
            }
        }
    }
    executeChangeEventWithScript = false;
}

function CalculateCafas(tabObject) {
    // debugger;
    //Changes made by Vikas Kashyup- Ref Task 305 - To add and remove cafas from need list according to score on tab hide and show 
    var ctrls = $('[id*=TextBox_CustomCAFAS2_]', tabObject.get_pageView().get_element());
    var CafasNodes = $(AutoSaveXMLDom[0]).find('CustomCAFAS2')[0];
    //Changes made by Vikas Kashyup- 6/Dec/2011 -Ref Task 485 - To add and remove CAFAS from need list according to score on tab hide and show
    if (ctrls.length > 0) {
        $.each(ctrls, function() {
            var ctrl = $(this);
            if (ctrl.val() > 0) {
                ctrl.change();
            }
        });
    }
    else {
        //Changes made by Vikas Kashyup- 6/Dec/2011 -Ref Task 485 - To add and remove CAFAS from need list according to score on tab hide and show
        if (AutoSaveXMLDom != "" && AutoSaveXMLDom != null && AutoSaveXMLDom != undefined) {
            var arr = '2,3,4,5,6,7,8,9,10,11,12,4,15,16';
            arr = arr.split(',');
            var HrmNeedId = 0;
            var nodeName = '';
            var XmlHrmNeed = $("CustomHRMAssessmentNeeds", AutoSaveXMLDom[0]);
            for (var i = 0; i < arr.length; i++) {
                HrmNeedId = arr[i];
                nodeName = '';
                switch (HrmNeedId) {
                    case "2":
                        nodeName = "SchoolPerformance";
                        break;
                    case "3":
                        nodeName = "HomePerformance";
                        break;
                    case "4":
                        nodeName = "CommunityPerformance";
                        break;
                    case "5":
                        nodeName = "BehaviorTowardsOther";
                        break;
                    case "6":
                        nodeName = "MoodsEmotion";
                        break;
                    case "7":
                        nodeName = "SelfHarmfulBehavior";
                        break;
                    case "8":
                        nodeName = "SubstanceUse";
                        break;
                    case "9":
                        nodeName = "Thinkng";
                        break;
                    case "10":
                        nodeName = "PrimaryFamilyMaterialNeeds";
                        break;
                    case "11":
                        nodeName = "PrimaryFamilySocialSupport";
                        break;
                    case "14":
                        nodeName = "NonCustodialMaterialNeeds";
                        break;
                    case "15":
                        nodeName = "NonCustodialSocialSupport";
                        break;
                    case "12":
                        nodeName = "SurrogateMaterialNeeds";
                        break;
                    case "16":
                        nodeName = "SurrogateSocialSupport";
                        break;
                }
                var NeedNode = $(XmlHrmNeed).find("HRMNeedId[text=" + HrmNeedId + "]");
                if (NeedNode != null && NeedNode != undefined && NeedNode.length > 0) {
                    var CafasScore = $(CafasNodes).find(nodeName).text();
                    if (parseInt(CafasScore) >= 20) {
                        $(NeedNode).parent().find("RecordDeleted").text('N');
                    }
                    else {
                        $(NeedNode).parent().find("RecordDeleted").text('Y');
                    }
                }
            }
            
        }
        //Changes end here
        AddToUnsavedTables("CustomHRMAssessmentNeeds");
    }
}

function TabsDownloadCompleted(TabComponent, TabsType) {

    if (TabsType == "Telerik") {


        var selectedTab = TabComponent.findTabByText('Needs List')
        if (downloadAllTabs == true) {
            downloadAllTabs = false;
            initiateSpellCheck = false;
            selectedTab.select();

            for (var index = 0; index < TabComponent._allTabs.length; index++) {

                if (TabComponent._allTabs[index].get_visible() == true) {

                    if (TabComponent._allTabs[index].get_text() == "DLA") {
                        CalculateDLA(TabComponent._allTabs[index]);
                        continue;
                    }
                    if (TabComponent._allTabs[index].get_text() == "CAFAS") {
                        CalculateCafas(TabComponent._allTabs[index]);
                        continue;
                    }
                    //tabObject=
                    var hrmNeeds = TabComponent._allTabs[index]._attributes.getAttribute("HrmNeeds");
                    var StringArrayhrmNeedsIds = hrmNeeds.split('^');
                    var needs_Length = StringArrayhrmNeedsIds.length;
                    var flagEventExecuted = false;
                    for (var k = 0; k < needs_Length; k++) {

                        var needToBeDeleted = false;
                        needToBeDeleted = NeedToDeleteHRMNeedId(StringArrayhrmNeedsIds[k], false);

                        if (needToBeDeleted == false) {

                            if (checkBoxControlName != null) {

                                var controlObject = $('#' + checkBoxControlName, TabComponent._allTabs[index].get_pageView().get_element());
                                if (controlObject.length == 0) {
                                    var ctrlName = checkBoxControlName.substring(checkBoxControlName.indexOf('_'));
                                    controlObject = $('[id$=' + ctrlName + ']', TabComponent._allTabs[index].get_pageView().get_element());
                                }

                                if (controlObject.length > 0 && controlObject.is(':checked') == true) {
                                    if (controlObject[0].onclick != null) {
                                        flagEventExecuted = true;
                                        controlObject.click();
                                        controlObject.attr("checked", true);
                                    }
                                    else {
                                        if (controlObject[0].onchange != null) {
                                            flagEventExecuted = true
                                            controlObject.change();
                                        }
                                    }
                                    if (flagEventExecuted == false)
                                        controlObject.change();





                                }
                            }
                        }
                    }
                }
            }

            BindNeedList(AutoSaveXMLDom);
        }
    }
}


function CheckForBlankNeed(ClickEvent, mainDomObject) {
    var xmlDomObject = null;
    if (mainDomObject != undefined && mainDomObject != null && mainDomObject != "")
        xmlDomObject = mainDomObject;
    else if (AutoSaveXMLDom != undefined || AutoSaveXMLDom != "")
        xmlDomObject = AutoSaveXMLDom;
    var XmlHrmNeed;
    if (xmlDomObject == undefined || xmlDomObject == "")
        return false;
    XmlHrmNeed = xmlDomObject[0].childNodes[0].selectNodes("CustomHRMAssessmentNeeds");
    if (XmlHrmNeed.length > 0) {
        if (
        (XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("NeedName").length > 0 && XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("NeedName")[0].text.trim() == "" || (XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("NeedDescription").length > 0 && XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("NeedDescription")[0].text.trim() == "")) &&
        (
            ((XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("RecordDeleted").length > 0) &&
            (XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("RecordDeleted")[0].text.trim() == "N"))
        ||
            (XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("RecordDeleted").length == 0)
        )
        ) {
            if (ClickEvent != undefined && ClickEvent == true) {
                var NeedList_tab = tabobject.findTabByText('Needs List');
                NeedList_tab.click();
            }
            return true;

        }
        else if (
        (XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("NeedName").length <= 0) &&
        (
            ((XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("RecordDeleted").length > 0) &&
            (XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("RecordDeleted")[0].text.trim() == "N"))
        ||
            (XmlHrmNeed[XmlHrmNeed.length - 1].selectNodes("RecordDeleted").length == 0)
        )
        ) {
            if (ClickEvent != undefined && ClickEvent == true) {
                var NeedList_tab = tabobject.findTabByText('Needs List');
                NeedList_tab.click();
            }
            return true;
        }
        else {
            return false;
        }
    }

    return false;
}




