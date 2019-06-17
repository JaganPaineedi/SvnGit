var SCMedicalNote = function () {
    var constructor = function () {
    }
    return constructor
}();
SCMedicalNote.PsychiatricNoteProblemId = null;
SCMedicalNote.PsychiatricNoteSubstanceUseColumnName = null;
var psychiatricEvaluationProblemIdArray = [];
var tabName = '';
var isTabClicked = false;
var tab_index = '';

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
    showhideChildTab();
}
function disableTabClick(index, name) {
    subtabindex = index;
}
function StoreTabstripClientObject(sender) {
    try {
        tabobject = sender;
    }
    catch (err) { }
}

function DocumentCallbackComplete() {
    if (AutoSaveXMLDom.find("AdultChildAdolescent").text() == 'A' || AutoSaveXMLDom.find("AdultChildAdolescent").text() == '') {
        tabobject.findTabByText('Child/Adolescent').set_visible(false);
    }
    else {
        tabobject.findTabByText('Child/Adolescent').set_visible(true);
    }
}


function SetScreenSpecificValues(dom, action) {
  //  debugger;
    try {
        if (typeof tabobject == 'undefined' || tabobject == undefined || tabobject == null || tabobject == "") {
        }
        else {          
            var historytabobject = tabobject._selectedIndex;
            if (historytabobject >= 0) {
                selectedTabText = tabobject.get_selectedTab().get_text();

                if (selectedTabText == 'Exam') {
                    //debugger;
                    //var PreviousGeneralPoorlyAddresses = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralPoorlyAddresses");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralPoorlyAddresses, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyAddresses');
                    //var PreviousGeneralPoorlyGroomed = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralPoorlyGroomed");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralPoorlyGroomed, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyGroomed');
                    //var PreviousGeneralDisheveled = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralDisheveled");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralDisheveled, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDisheveled');
                    //var PreviousGeneralOdferous = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralOdferous");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralOdferous, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralOdferous');
                    //var PreviousGeneralDeformities = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralDeformities");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralDeformities, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDeformities');
                    //var PreviousGeneralPoorNutrion = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralPoorNutrion");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralPoorNutrion, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorNutrion');
                    //var PreviousGeneralRestless = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralRestless");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralRestless, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralRestless');
                    //var PreviousGeneralPsychometer = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralPsychometer");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralPsychometer, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPsychometer');
                    //var PreviousGeneralHyperActive = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralHyperActive");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralHyperActive, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHyperActive');
                    //var PreviousGeneralEvasive = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralEvasive");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralEvasive, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralEvasive');
                    //var PreviousGeneralInAttentive = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralInAttentive");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralInAttentive, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralInAttentive');
                    //var PreviousGeneralPoorEyeContact = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralPoorEyeContact");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralPoorEyeContact, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorEyeContact');
                    //var PreviousGeneralHostile = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGeneralHostile");
                    //ColorPreviouslySelectedCheckBox(PreviousGeneralHostile, 'CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHostile');
                    //var PreviousSpeechIncreased = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechIncreased");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechIncreased, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechIncreased');
                    //var PreviousSpeechDecreased = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechDecreased");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechDecreased, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechDecreased');
                    //var PreviousSpeechPaucity = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechPaucity");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechPaucity, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPaucity');
                    //var PreviousSpeechHyperverbal = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechHyperverbal");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechHyperverbal, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechHyperverbal');
                    //var PreviousSpeechPoorArticulations = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechPoorArticulations");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechPoorArticulations, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPoorArticulations');
                    //var PreviousSpeechLoud = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechLoud");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechLoud, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPoorArticulations');
                    //var PreviousSpeechSoft = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechSoft");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechSoft, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechSoft');
                    //var PreviousSpeechMute = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechMute");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechMute, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechMute');
                    //var PreviousSpeechStuttering = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechStuttering");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechStuttering, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechStuttering');
                    //var PreviousSpeechImpaired = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechImpaired");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechImpaired, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechImpaired');
                    //var PreviousSpeechPressured = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechPressured");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechPressured, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPressured');
                    //var PreviousSpeechFlight = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousSpeechFlight");
                    //ColorPreviouslySelectedCheckBox(PreviousSpeechFlight, 'CheckBox_CustomDocumentPsychiatricNoteExams_SpeechFlight');
                    //var PreviousLanguageDifficultyNaming = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousLanguageDifficultyNaming");
                    //ColorPreviouslySelectedCheckBox(PreviousLanguageDifficultyNaming, 'CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyNaming');
                    //var PreviousLanguageDifficultyRepeating = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousLanguageDifficultyRepeating");
                    //ColorPreviouslySelectedCheckBox(PreviousLanguageDifficultyRepeating, 'CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyRepeating');
                    //var PreviousMoodHappy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousMoodHappy");
                    //ColorPreviouslySelectedCheckBox(PreviousMoodHappy, 'CheckBox_CustomDocumentPsychiatricNoteExams_MoodHappy');
                    //var PreviousMoodSad = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousMoodSad");
                    //ColorPreviouslySelectedCheckBox(PreviousMoodSad, 'CheckBox_CustomDocumentPsychiatricNoteExams_MoodSad');
                    //var PreviousMoodAnxious = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousMoodAnxious");
                    //ColorPreviouslySelectedCheckBox(PreviousMoodAnxious, 'CheckBox_CustomDocumentPsychiatricNoteExams_MoodAnxious');
                    //var PreviousMoodAngry = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousMoodAngry");
                    //ColorPreviouslySelectedCheckBox(PreviousMoodAngry, 'CheckBox_CustomDocumentPsychiatricNoteExams_MoodAngry');
                    //var PreviousMoodIrritable = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousMoodIrritable");
                    //ColorPreviouslySelectedCheckBox(PreviousMoodIrritable, 'CheckBox_CustomDocumentPsychiatricNoteExams_MoodIrritable');
                    //var PreviousMoodElation = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousMoodElation");
                    //ColorPreviouslySelectedCheckBox(PreviousMoodElation, 'CheckBox_CustomDocumentPsychiatricNoteExams_MoodElation');
                    //var PreviousMoodNormal = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousMoodNormal");
                    //ColorPreviouslySelectedCheckBox(PreviousMoodNormal, 'CheckBox_CustomDocumentPsychiatricNoteExams_MoodNormal');
                    //var PreviousAffectEuthymic = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAffectEuthymic");
                    //ColorPreviouslySelectedCheckBox(PreviousAffectEuthymic, 'CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuthymic');
                    //var PreviousAffectDysphoric = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAffectDysphoric");
                    //ColorPreviouslySelectedCheckBox(PreviousAffectDysphoric, 'CheckBox_CustomDocumentPsychiatricNoteExams_AffectDysphoric');
                    //var PreviousAffectAnxious = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAffectAnxious");
                    //ColorPreviouslySelectedCheckBox(PreviousAffectAnxious, 'CheckBox_CustomDocumentPsychiatricNoteExams_AffectAnxious');
                    //var PreviousAffectIrritable = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAffectIrritable");
                    //ColorPreviouslySelectedCheckBox(PreviousAffectIrritable, 'CheckBox_CustomDocumentPsychiatricNoteExams_AffectIrritable');
                    //var PreviousAffectBlunted = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAffectBlunted");
                    //ColorPreviouslySelectedCheckBox(PreviousAffectBlunted, 'CheckBox_CustomDocumentPsychiatricNoteExams_AffectBlunted');
                    //var PreviousAffectLabile = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAffectLabile");
                    //ColorPreviouslySelectedCheckBox(PreviousAffectLabile, 'CheckBox_CustomDocumentPsychiatricNoteExams_AffectLabile');
                    //var PreviousAffectEuphoric = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAffectEuphoric");
                    //ColorPreviouslySelectedCheckBox(PreviousAffectEuphoric, 'CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuphoric');
                    //var PreviousAffectCongruent = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAffectCongruent");
                    //ColorPreviouslySelectedCheckBox(PreviousAffectCongruent, 'CheckBox_CustomDocumentPsychiatricNoteExams_AffectCongruent');
                    //var PreviousAttensionPoorConcentration = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAttensionPoorConcentration");
                    //ColorPreviouslySelectedCheckBox(PreviousAttensionPoorConcentration, 'CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorConcentration');
                    //var PreviousAttensionPoorAttension = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAttensionPoorAttension");
                    //ColorPreviouslySelectedCheckBox(PreviousAttensionPoorAttension, 'CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorAttension');
                    //var PreviousAttensionDistractible = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAttensionDistractible");
                    //ColorPreviouslySelectedCheckBox(PreviousAttensionDistractible, 'CheckBox_CustomDocumentPsychiatricNoteExams_AttensionDistractible');
                    //var PreviousTPDisOrganised = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPDisOrganised");
                    //ColorPreviouslySelectedCheckBox(PreviousTPDisOrganised, 'CheckBox_CustomDocumentPsychiatricNoteExams_TPDisOrganised');
                    //var PreviousTPBlocking = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPBlocking");
                    //ColorPreviouslySelectedCheckBox(PreviousTPDisOrganised, 'CheckBox_CustomDocumentPsychiatricNoteExams_PreviousTPBlocking');
                    //var PreviousTPPersecution = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPPersecution");
                    //ColorPreviouslySelectedCheckBox(PreviousTPPersecution, 'CheckBox_CustomDocumentPsychiatricNoteExams_TPPersecution');
                    //var PreviousTPBroadCasting = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPBroadCasting");
                    //ColorPreviouslySelectedCheckBox(PreviousTPPersecution, 'CheckBox_CustomDocumentPsychiatricNoteExams_TPBroadCasting');
                    //var PreviousTPDetrailed = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPDetrailed");
                    //ColorPreviouslySelectedCheckBox(PreviousTPDetrailed, 'CheckBox_CustomDocumentPsychiatricNoteExams_TPDetrailed');
                    //var PreviousTPThoughtinsertion = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPThoughtinsertion");
                    //ColorPreviouslySelectedCheckBox(PreviousTPThoughtinsertion, 'CheckBox_CustomDocumentPsychiatricNoteExams_TPThoughtinsertion');
                    //var PreviousTPThoughtinsertion = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPThoughtinsertion");
                    //ColorPreviouslySelectedCheckBox(PreviousTPThoughtinsertion, 'CheckBox_CustomDocumentPsychiatricNoteExams_TPThoughtinsertion');
                    //var PreviousTPIncoherent = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPIncoherent");
                    //ColorPreviouslySelectedCheckBox(PreviousTPIncoherent, 'CheckBox_CustomDocumentPsychiatricNoteExams_TPIncoherent');
                    //var PreviousTPRacing = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPRacing");
                    //ColorPreviouslySelectedCheckBox(PreviousTPRacing, 'CheckBox_CustomDocumentPsychiatricNoteExams_TPRacing');
                    //var PreviousTPIllogical = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTPIllogical");
                    //ColorPreviouslySelectedCheckBox(PreviousTPIllogical, 'CheckBox_CustomDocumentPsychiatricNoteExams_TPIllogical');
                    //var PreviousTCDelusional = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCDelusional");
                    //ColorPreviouslySelectedCheckBox(PreviousTCDelusional, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCDelusional');
                    //var PreviousTCParanoid = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCParanoid");
                    //ColorPreviouslySelectedCheckBox(PreviousTCParanoid, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCParanoid');
                    //var PreviousTCIdeas = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCIdeas");
                    //ColorPreviouslySelectedCheckBox(PreviousTCIdeas, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCIdeas');
                    //var PreviousTCThoughtInsertion = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCThoughtInsertion");
                    //ColorPreviouslySelectedCheckBox(PreviousTCThoughtInsertion, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtInsertion');
                    //var PreviousTCThoughtWithdrawal = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCThoughtWithdrawal");
                    //ColorPreviouslySelectedCheckBox(PreviousTCThoughtWithdrawal, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtWithdrawal');
                    //var PreviousTCThoughtBroadcasting = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCThoughtBroadcasting");
                    //ColorPreviouslySelectedCheckBox(PreviousTCThoughtBroadcasting, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtBroadcasting');
                    //var PreviousTCReligiosity = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCReligiosity");
                    //ColorPreviouslySelectedCheckBox(PreviousTCReligiosity, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCReligiosity');
                    //var PreviousTCGrandiosity = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCGrandiosity");
                    //ColorPreviouslySelectedCheckBox(PreviousTCGrandiosity, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCGrandiosity');
                    //var PreviousTCPerserveration = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCPerserveration");
                    //ColorPreviouslySelectedCheckBox(PreviousTCPerserveration, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCPerserveration');
                    //var PreviousTCObsessions = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCObsessions");
                    //ColorPreviouslySelectedCheckBox(PreviousTCObsessions, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCObsessions');
                    //var PreviousTCWorthlessness = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCWorthlessness");
                    //ColorPreviouslySelectedCheckBox(PreviousTCWorthlessness, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCWorthlessness');
                    //var PreviousTCLoneliness = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCLoneliness");
                    //ColorPreviouslySelectedCheckBox(PreviousTCLoneliness, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCLoneliness');
                    //var PreviousTCGuilt = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCGuilt");
                    //ColorPreviouslySelectedCheckBox(PreviousTCGuilt, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCGuilt');
                    //var PreviousTCHopelessness = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCHopelessness");
                    //ColorPreviouslySelectedCheckBox(PreviousTCHopelessness, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCHopelessness');
                    //var PreviousTCHelplessness = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousTCHelplessness");
                    //ColorPreviouslySelectedCheckBox(PreviousTCHelplessness, 'CheckBox_CustomDocumentPsychiatricNoteExams_TCHelplessness');
                    //var PreviousCAPoorKnowledget = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousCAPoorKnowledget");
                    //ColorPreviouslySelectedCheckBox(PreviousCAPoorKnowledget, 'CheckBox_CustomDocumentPsychiatricNoteExams_CAPoorKnowledget');
                    //var PreviousCAConcrete = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousCAConcrete");
                    //ColorPreviouslySelectedCheckBox(PreviousCAConcrete, 'CheckBox_CustomDocumentPsychiatricNoteExams_CAConcrete');
                    //var PreviousCAUnable = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousCAUnable");
                    //ColorPreviouslySelectedCheckBox(PreviousCAUnable, 'CheckBox_CustomDocumentPsychiatricNoteExams_CAUnable');
                    //var PreviousCAPoorComputation = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousCAPoorComputation");
                    //ColorPreviouslySelectedCheckBox(PreviousCAPoorComputation, 'CheckBox_CustomDocumentPsychiatricNoteExams_CAPoorComputation');
                    //var PreviousAssociationsLoose = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAssociationsLoose");
                    //ColorPreviouslySelectedCheckBox(PreviousAssociationsLoose, 'CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsLoose');
                    //var PreviousAssociationsClanging = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAssociationsClanging");
                    //ColorPreviouslySelectedCheckBox(PreviousAssociationsClanging, 'CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsClanging');
                    //var PreviousAssociationsWordsalad = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAssociationsWordsalad");
                    //ColorPreviouslySelectedCheckBox(PreviousAssociationsWordsalad, 'CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsWordsalad');
                    //var PreviousAssociationsCircumstantial = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAssociationsCircumstantial");
                    //ColorPreviouslySelectedCheckBox(PreviousAssociationsCircumstantial, 'CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsCircumstantial');
                    //var PreviousAssociationsTangential = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousAssociationsTangential");
                    //ColorPreviouslySelectedCheckBox(PreviousAssociationsTangential, 'CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsTangential');
                    //var PreviousPDAuditoryHallucinations = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDAuditoryHallucinations");
                    //ColorPreviouslySelectedCheckBox(PreviousPDAuditoryHallucinations, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDAuditoryHallucinations');
                    //var PreviousPDVisualHallucinations = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDVisualHallucinations");
                    //ColorPreviouslySelectedCheckBox(PreviousPDVisualHallucinations, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDVisualHallucinations');
                    //var PreviousPDCommandHallucinations = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDCommandHallucinations");
                    //ColorPreviouslySelectedCheckBox(PreviousPDCommandHallucinations, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDCommandHallucinations');
                    //var PreviousPDDelusions = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDDelusions");
                    //ColorPreviouslySelectedCheckBox(PreviousPDDelusions, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDDelusions');
                    //var PreviousPDPreoccupation = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDPreoccupation");
                    //ColorPreviouslySelectedCheckBox(PreviousPDPreoccupation, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDPreoccupation');
                    //var PreviousPDOlfactoryHallucinations = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDOlfactoryHallucinations");
                    //ColorPreviouslySelectedCheckBox(PreviousPDOlfactoryHallucinations, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDOlfactoryHallucinations');
                    //var PreviousPDGustatoryHallucinations = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDGustatoryHallucinations");
                    //ColorPreviouslySelectedCheckBox(PreviousPDGustatoryHallucinations, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDGustatoryHallucinations');
                    //var PreviousPDTactileHallucinations = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDTactileHallucinations");
                    //ColorPreviouslySelectedCheckBox(PreviousPDTactileHallucinations, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDTactileHallucinations');
                    //var PreviousPDSomaticHallucinations = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDSomaticHallucinations");
                    //ColorPreviouslySelectedCheckBox(PreviousPDSomaticHallucinations, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDSomaticHallucinations');
                    //var PreviousPDIllusions = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousPDIllusions");
                    //ColorPreviouslySelectedCheckBox(PreviousPDIllusions, 'CheckBox_CustomDocumentPsychiatricNoteExams_PDIllusions');
                    //var PreviousOrientationPerson = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousOrientationPerson");
                    //ColorPreviouslySelectedCheckBox(PreviousOrientationPerson, 'CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPerson');
                    //var PreviousOrientationPlace = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousOrientationPlace");
                    //ColorPreviouslySelectedCheckBox(PreviousOrientationPlace, 'CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPlace');
                    //var PreviousOrientationTime = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousOrientationTime");
                    //ColorPreviouslySelectedCheckBox(PreviousOrientationTime, 'CheckBox_CustomDocumentPsychiatricNoteExams_OrientationTime');
                    //var PreviousOrientationSituation = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousOrientationSituation");
                    //ColorPreviouslySelectedCheckBox(PreviousOrientationSituation, 'CheckBox_CustomDocumentPsychiatricNoteExams_OrientationSituation');
                    //var PreviousFundOfKnowledgeCurrentEvents = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousFundOfKnowledgeCurrentEvents");
                    //ColorPreviouslySelectedCheckBox(PreviousFundOfKnowledgeCurrentEvents, 'CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeCurrentEvents');
                    //var PreviousFundOfKnowledgePastHistory = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousFundOfKnowledgePastHistory");
                    //ColorPreviouslySelectedCheckBox(PreviousFundOfKnowledgePastHistory, 'CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgePastHistory');
                    //var PreviousFundOfKnowledgeVocabulary = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousFundOfKnowledgeVocabulary");
                    //ColorPreviouslySelectedCheckBox(PreviousFundOfKnowledgeVocabulary, 'CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeVocabulary');
                    //var PreviousInsightAndJudgementSubstance = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousInsightAndJudgementSubstance");
                    //ColorPreviouslySelectedCheckBox(PreviousInsightAndJudgementSubstance, 'CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementSubstance');
                    //var PreviousMuscleStrengthorToneAtrophy = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousMuscleStrengthorToneAtrophy");
                    //ColorPreviouslySelectedCheckBox(PreviousMuscleStrengthorToneAtrophy, 'CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAtrophy');
                    //var PreviousMuscleStrengthorToneAbnormal = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousMuscleStrengthorToneAbnormal");
                    //ColorPreviouslySelectedCheckBox(PreviousMuscleStrengthorToneAbnormal, 'CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAbnormal');
                    //var PreviousGaitandStationRestlessness = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGaitandStationRestlessness");
                    //ColorPreviouslySelectedCheckBox(PreviousGaitandStationRestlessness, 'CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationRestlessness');
                    //var PreviousGaitandStationStaggered = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGaitandStationStaggered");
                    //ColorPreviouslySelectedCheckBox(PreviousGaitandStationStaggered, 'CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationStaggered');
                    //var PreviousGaitandStationShuffling = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGaitandStationShuffling");
                    //ColorPreviouslySelectedCheckBox(PreviousGaitandStationShuffling, 'CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationShuffling');
                    //var PreviousGaitandStationUnstable = GetFielValueFromXMLDom(AutoSaveXMLDom, "CustomDocumentPsychiatricNoteExams", "PreviousGaitandStationUnstable");
                    //ColorPreviouslySelectedCheckBox(PreviousGaitandStationUnstable, 'CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationUnstable');
                    GetTemplatesList();
                   if ($('#divVitals').length > 0)
                        SCMedicalNote.loadVitals();
                    EnableDisable('CheckBox_CustomDocumentPsychiatricNoteExams_SelfHarmOther', 'TextBox_CustomDocumentPsychiatricNoteExams_SelfHarmOtherText');
                    EnableDisable('CheckBox_CustomDocumentPsychiatricNoteExams_HarmToOthersOther', 'TextBox_CustomDocumentPsychiatricNoteExams_HarmToOthersOtherText');
                    EnableDisable('CheckBox_CustomDocumentPsychiatricNoteExams_HarmToPropertyOther', 'TextBox_CustomDocumentPsychiatricNoteExams_HarmToPropertyOtherText');

                    EnableDisable('CheckBox_CustomDocumentPsychiatricNoteExams_SelfHarmInformed', 'TextBox_CustomDocumentPsychiatricNoteExams_SelfHarmInformedText');
                    EnableDisable('CheckBox_CustomDocumentPsychiatricNoteExams_HarmToOthersInformed', 'TextBox_CustomDocumentPsychiatricNoteExams_HarmToOthersInformedText');
                    EnableDisable('CheckBox_CustomDocumentPsychiatricNoteExams_HarmToPropertyInformed', 'TextBox_CustomDocumentPsychiatricNoteExams_HarmToPropertyInformedText');
                 
                }
                if (selectedTabText == 'General') {
                    SCMedicalNote.BindObjectiveStatus(dom);
                    SCMedicalNote.loadAllergies();
                    enableDisableHistory(dom);
                    if ($('#divProblemTemplate').length > 0)
                        appendExistingProblems(dom, 1, 0);

                    if ($('select[id$=DropDownList_ExternalReferralProviders_Type]').val()) {
                        $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').removeAttr('disabled');
                    }
                    else {
                        $('select[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').val("");
                        $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').attr('disabled', 'disabled');
                    }

                }
                if (selectedTabText == 'Medical Decision Making') {
                    $('#divProblemStatus').hide();
                    SCMedicalNote.BindMedications();
                    SCMedicalNote.BindProblemsStatus(dom);
                    //                        EnableDisableDropdown(false);
                    //                        $("#CheckBox_CustomDocumentPsychiatricNoteMDMs_Labs").bind('click', function() {
                    //                            EnableDisableDropdown(true);
                    //                        });
                    var LabsLastOrder = AutoSaveXMLDom.find("LabsLastOrder").text()
                    $('#LabsLastOrder').append(decodeText(LabsLastOrder));

                    var MedicalRecordsLabsOrderedLastvisit = AutoSaveXMLDom.find("MedicalRecordsLabsOrderedLastvisit").text()
                    $('#MedicalRecordsLabsOrderedLastvisit').append(decodeText(MedicalRecordsLabsOrderedLastvisit));
                }
                if (selectedTabText == 'Diagnosis') {
                    if (typeof SetDiagnosisIAndIIHiddenOrderField == 'function') {
                        SetDiagnosisIAndIIHiddenOrderField(dom);
                    }
                }
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'SetScreenSpecificValues');
    }
}


//ColorPreviouslySelectedCheckBox = (function (PreviouslySelected,CheckboxId) {
//    if (PreviouslySelected == 'Y') {
//        $('[id$=' + CheckboxId + ']').css('outline', '2px solid #FFFF00', 'important');
//    }
//});

EnableDisable = (function (checkboxid, textboxid) {
    if ($('#' + checkboxid + ':checked').length == 1) {
        $("#" + textboxid).removeAttr("disabled");
    }
    else {
        $("#" + textboxid).attr("disabled", "disabled");
        $("#" + textboxid).val('');
    }
});

function RefreshTabPageContents(tabControl, selectedTabTitle) {
   // debugger;
    selectedTabTitle = $.trim(selectedTabTitle);
    try {
        if (selectedTabTitle == 'Medical Decision Making') {
            SCMedicalNote.BindProblemsStatus(AutoSaveXMLDom);
        }
        else if (selectedTabTitle == 'Diagnosis') {
            RefreshParentChildGrid('DocumentDiagnosisCodeId', 'InsertGrid', 'CustomGrid', 'DocumentDiagnosisCodes', 'TableChildControl_DocumentDiagnosisCodes');

// RefreshPageData("InsertGrid", "DocumentDiagnosisCodes", "DocumentDiagnosisCodeId", "CustomGrid", "TableChildControl_DocumentDiagnosisCodes", "CustomGrid");
        }
    }
    catch (err) {
    }
}

//function LoadTabPageCallBackComplete(tabClickSender, title, tabUserControlName, selectedTabId, functionname) {
//    //debugger;
//    if (selectedTabId == 5) {
//        RefreshPageData("InsertGrid", "DocumentDiagnosisCodes", "DocumentDiagnosisCodeId", "CustomGrid", "TableChildControl_DocumentDiagnosisCodes", "CustomGrid");
//    }
//}

function showhideChildTab() {
    if ($('#RadioButton_CustomDocumentPsychiatricNoteGenerals_AdultChildAdolescent_C').is(':checked')) {
        tabobject.findTabByText('Child/Adolescent').set_visible(true);
    }
    else {
        tabobject.findTabByText('Child/Adolescent').set_visible(false);
    }

}
function AddEventHandlers() {
    NursemoniterOther();
    $('#RadioButton_CustomDocumentPsychiatricNoteGenerals_AdultChildAdolescent_A').bind('click', function () {
        showhideChildTab();
    });
    $('#RadioButton_CustomDocumentPsychiatricNoteGenerals_AdultChildAdolescent_C').bind('click', function () {
        showhideChildTab();
    });
    if ($('#divProblemTemplate').length > 0) {
        if (AutoSaveXMLDom.find("PsychiatricNoteProblemId").length > 1) {
            bindFocusEventHistory('History');
            bindHistoryTabScrollEvent();
        }
    }
    var buttonPlaceLab = $("input[type=button][id$=Button_OpenFlowSheet]");
    buttonPlaceLab.bind('click', function () {
        try {

            if (DocumentId == 0) {
                ShowHideErrorMessage("Please save the document to open vitals.", "true", "true", "Alert");
                return false;
            }
            else {
                var DateOfService = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService");
                var ServiceId = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "ServiceId");
                if (DateOfService != null)
                    DateOfService = ChangeDateFormat(DateOfService);
                $.ajax({
                    type: "POST",
                    url: GetRelativePath() + "Custom/PsychiatricNote/WebPages/PsychiatricNote.aspx",
                    data: "action=VitalsCheck&DateOfService=" + DateOfService + "&ServiceId=" + ServiceId,
                    success: function (result) {
                        //debugger;
                        if (result != '') {
                            var res = $.xmlDOM(result);
                            $(res).find('Vitals').each(function () {
                                var date = $(this).find('HealthRecordDate').text();
                                //var date = (new Date()).format("MM/dd/yyyy  hh:mm:ss tt");
                                OpenPage(5761, 716, 'HealthDataTemplateId=110' + '^HealthRecordDate=' + date + '^ClienID=' + ClientID, 2, GetRelativePath());
                            });
                        }
                    }
                })
            }
        }
        catch (ex) { }

    });

    var buttonOpenSmartCareRX = $("input[type=button][id$=Button_CustomDocumentPsychiatricNoteMDMs_OpenSmartCareRX]");
    if (buttonOpenSmartCareRX.length > 0) {
        buttonOpenSmartCareRX.bind('click', function () {
            OpenPage(5766, 105, 'DocumentNavigationName=Medications', 2, GetRelativePath());
        });
    }
    var buttonViewMedicationHistoryReport = $("input[type=button][id$=Button_CustomDocumentPsychiatricNoteMDMs_ViewMedicationHistoryReport]");
    if (buttonViewMedicationHistoryReport.length > 0) {
        buttonViewMedicationHistoryReport.bind('click', function () {
            OpenPage(5766, 105, 'DocumentNavigationName=Medications^OpenScreen=MedicationReport', 2, GetRelativePath());
        });
    }

    var buttonMedicationNote = $("input[type=button][id$=MedicationNote]");
    if (buttonMedicationNote.length > 0) {
        buttonMedicationNote.bind('click', function () {
            SCMedicalNote.BindMedications();
            SCMedicalNote.MedicationsDiscontinued();
        });
    }

    var buttonPlaceOrder = $("input[type=button][id$=Button_CustomDocumentPsychiatricNoteMDMs_PlaceOrder]");
    if (buttonPlaceOrder.length > 0) {
        buttonPlaceOrder.bind('click', function () {
            OpenPage(5763, 772, 'DocumentNavigationName=Client Order', 2, GetRelativePath(), pageActionEnum.New);
        });
    }

    //started 
    //alergies
    var buttonOpenAllergyRX = $("input[type=button][id$=Button_CustomDocumentPsychiatricNoteGenerals_Allergyopen]");
    if (buttonOpenAllergyRX.length > 0) {
        buttonOpenAllergyRX.bind('click', function () {
            OpenPage(5766, 105, 'DocumentNavigationName=Medications', 2, GetRelativePath());
        });
    }
    //end 

    //refresh 
    var buttonAllergyrefresh = $("input[type=button][id$=Button_CustomDocumentPsychiatricNoteGenerals_Allergyrefresh]");
    if (buttonAllergyrefresh.length > 0) {
        buttonAllergyrefresh.bind('click', function () {
            // SCMedicalNote.BindMedications();
            //SCMedicalNote
            //SCMedicalReviewNote
            SCMedicalNote.loadAllergies('click');
        });
    }
    //end

    //end



    if ($("input[type=button][id^=Button_CustomPsychiatricNoteProblems_]").length > 0) {
        $("input[type=button][id^=Button_CustomPsychiatricNoteProblems_]").each(
   function () {
       $(this).unbind('click');
       $(this).bind('click', function () {
           ShowProblemPopup(this);
       });
   }
  );
    }




    if (TabIndex == 0) {

        var varPrimaryCarePhysician = $('select[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').val()
        if (varPrimaryCarePhysician != "" && varPrimaryCarePhysician != "-1") {
            $('span[id$=span_modiyProviderReferral]').show();
        }
        $('[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').unbind('change');
        $('[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').change(function () {
            var selectedValueProviderType = $('select[id$=DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician]').val();
            if ($(this).val() == "-1") {
                AddNewProvider(selectedValueProviderType);
                $(this).val('');
                $('span[id$=span_modiyProviderReferral]').hide();
            } else if ($(this).val() > 0) {
                //bindChange = "DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician";
                //OpenPage(5765, 10500, 'action=ProviderInfo^ExternalReferralProviderId=' + $(this).val(), 2, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
                $('span[id$=span_modiyProviderReferral]').show();

                $.ajax({
                    type: "POST",
                    url: "../Custom/PsychiatricNote/WebPages/PsychiatricNoteAjax.aspx?functionName=UpdateProviderDetails",
                    data: 'ExternalReferralProviderId=' + $(this).val(),
                    asyn: false,
                    success: function (result) {
                        UpdateProviderDetails(result);

                    }
                });


            } else {
                $('span[id$=span_modiyProviderReferral]').hide();
            }
        });
    }

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOtherComments', 'CustomDocumentPsychiatricNoteExams', 'GeneralAppearanceOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_SpeechOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_SpeechOtherComments', 'CustomDocumentPsychiatricNoteExams', 'SpeechOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_LanguageOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_LanguageOtherComments', 'CustomDocumentPsychiatricNoteExams', 'LanguageOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_MoodOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_MoodOtherComments', 'CustomDocumentPsychiatricNoteExams', 'MoodOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_AffectOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AffectOtherComments', 'CustomDocumentPsychiatricNoteExams', 'AffectOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_AttentionSpanOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AttentionSpanOtherComments', 'CustomDocumentPsychiatricNoteExams', 'AttentionSpanOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOtherComments', 'CustomDocumentPsychiatricNoteExams', 'ThoughtProcessOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtContentOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_ThoughtContentOtherComments', 'CustomDocumentPsychiatricNoteExams', 'ThoughtContentOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOtherComments', 'CustomDocumentPsychiatricNoteExams', 'CognitiveAbnormalitiesOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AssociationsOtherComments', 'CustomDocumentPsychiatricNoteExams', 'AssociationsOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthersComments', 'CustomDocumentPsychiatricNoteExams', 'AbnormalPsychoticOthersComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_OrientationOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_OrientationOtherComments', 'CustomDocumentPsychiatricNoteExams', 'OrientationOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOtherComments', 'CustomDocumentPsychiatricNoteExams', 'FundOfKnowledgeOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOtherComments', 'CustomDocumentPsychiatricNoteExams', 'InsightAndJudgementOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_MemoryOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_MemoryOtherComments', 'CustomDocumentPsychiatricNoteExams', 'MemoryOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOtherComments', 'CustomDocumentPsychiatricNoteExams', 'MuscleStrengthOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_GaitAndStationOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_GaitAndStationOtherComments', 'CustomDocumentPsychiatricNoteExams', 'GaitAndStationOtherComments');


    $("input[GeneralAppearance='GeneralAppearance']").bind('click', function () {
        GetCheckedCheckBoxes('GeneralAppearance', 'Y');
    });

    $("input[Speech='Speech']").bind('click', function () {
        GetCheckedCheckBoxes('Speech', 'Y');
    });

    $("input[PsychiatricNoteExamLanguage='PsychiatricNoteExamLanguage']").bind('click', function () {
        GetCheckedCheckBoxes('PsychiatricNoteExamLanguage', 'Y');
    });

    $("input[MoodAndAffect='MoodAndAffect']").bind('click', function () {
        GetCheckedCheckBoxes('MoodAndAffect', 'Y');
    });

    $("input[AttensionSpanAndConcentration='AttensionSpanAndConcentration']").bind('click', function () {
        GetCheckedCheckBoxes('AttensionSpanAndConcentration', 'Y');
    });

    $("input[ThoughtContentCognision='ThoughtContentCognision']").bind('click', function () {
        GetCheckedCheckBoxes('ThoughtContentCognision', 'Y');
    });

    $("input[Associations='Associations']").bind('click', function () {
        GetCheckedCheckBoxes('Associations', 'Y');
    });

    $("input[AbnormalorPsychoticThoughts='AbnormalorPsychoticThoughts']").bind('click', function () {
        GetCheckedCheckBoxes('AbnormalorPsychoticThoughts', 'Y');
    });

    $("input[Orientation='Orientation']").bind('click', function () {
        GetCheckedCheckBoxes('Orientation', 'Y');
    });

    $("input[FundOfKnowledge='FundOfKnowledge']").bind('click', function () {
        GetCheckedCheckBoxes('FundOfKnowledge', 'Y');
    });

    $("input[InsightAndJudgement='InsightAndJudgement']").bind('click', function () {
        GetCheckedCheckBoxes('InsightAndJudgement', 'Y');
    });

    $("input[MuscleStrengthorTone='MuscleStrengthorTone']").bind('click', function () {
        GetCheckedCheckBoxes('MuscleStrengthorTone', 'Y');
    });

    $("input[GaitandStation='GaitandStation']").bind('click', function () {
        GetCheckedCheckBoxes('GaitandStation', 'Y');
    });

    $("input[Memory='Memory']").bind('click', function () {
        GetCheckedCheckBoxes('Memory', 'Y');
    });

    // Uncheck on Not Assessed checked//


    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_GeneralAppearance_N]").unbind('click').bind('click', function () {
        UncheckGeneralAppearanceCheckBoxes();
    });

    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_Speech_N]").unbind('click').bind('click', function () {
        UncheckSpeechCheckBoxes();
    });

    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_PsychiatricNoteExamLanguage_N]").unbind('click').bind('click', function () {
        UncheckLanguageCheckBoxes();
    });


    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_MoodAndAffect_N]").unbind('click').bind('click', function () {
        UncheckMoodAndAffectCheckBoxes();
    });

    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_AttensionSpanAndConcentration_N]").unbind('click').bind('click', function () {
        UncheckAttensionSpanAndConcentrationCheckBoxes();
    });


    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_ThoughtContentCognision_N]").unbind('click').bind('click', function () {
        UncheckThoughtContentCognisionCheckBoxes();
    });

    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_Associations_N]").unbind('click').bind('click', function () {
        UncheckAssociationsCheckBoxes();
    });

    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_AbnormalorPsychoticThoughts_N]").unbind('click').bind('click', function () {
        UncheckAbnormalorPsychoticThoughtsCheckBoxes();
    });

    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_Orientation_N]").unbind('click').bind('click', function () {
        UncheckOrientationCheckBoxes();
    });


    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_FundOfKnowledge_N]").unbind('click').bind('click', function () {
        UncheckFundOfKnowledgeCheckBoxes();
    });

    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgement_N]").unbind('click').bind('click', function () {
        UncheckInsightAndJudgementCheckBoxes();
    });

    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_Memory_N]").unbind('click').bind('click', function () {
        UncheckMemoryCheckBoxes();
    });

    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_MuscleStrengthorTone_N]").unbind('click').bind('click', function () {
        UncheckMuscleStrengthorToneCheckBoxes();
    });


    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_GaitandStation_N]").unbind('click').bind('click', function () {
        UncheckGaitandStationCheckBoxes();
    });

}




var GetCheckedCheckBoxes = (function (GroupName, CreateAutoSave) {
   // debugger;
    var result = $('input[' + GroupName + '=' + GroupName + ']:checked');
    //if (result.length > 0) {
    //    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_" + GroupName + "_N]").attr('disabled', 'disabled');
    //}
    //else {
    //    $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_" + GroupName + "_N]").removeAttr('disabled');
    //}
    var WNLisChecked = "";
    if (GroupName == 'GeneralAppearance') {
        WNLisChecked = $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_" + GroupName + "_G]").is(":checked");
    }
    else {
        WNLisChecked = $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_" + GroupName + "_W]").is(":checked");
    }
    if (WNLisChecked !=true)
    {
    if (result.length > 0) {
        $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_" + GroupName + "_A]").attr("checked", "checked");
        if (CreateAutoSave == 'Y') {
            CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams",GroupName, 'A');
        }
    }
    else{
        $("[id$=RadioButton_CustomDocumentPsychiatricNoteExams_"+GroupName+"_N]").attr("checked", "checked");
        if (CreateAutoSave == 'Y') {
            CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", GroupName, 'N');
        }
    }
}
  
});

function UncheckGeneralAppearanceCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyAddresses').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorlyGroomed').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDisheveled').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralOdferous').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralDeformities').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorNutrion').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralRestless').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPsychometer').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHyperActive').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralEvasive').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralInAttentive').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralPoorEyeContact').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralHostile').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOthers').attr('checked', '');


    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralPoorlyAddresses", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralPoorlyGroomed", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralDisheveled", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralOdferous", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralDeformities", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralPoorNutrion", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralRestless", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralPsychometer", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralHyperActive", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralEvasive", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralInAttentive", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralPoorEyeContact", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralHostile", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralAppearanceOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_GeneralAppearanceOtherComments', 'CustomDocumentPsychiatricNoteExams', 'GeneralAppearanceOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GeneralAppearanceOtherComments", '');
}



function UncheckSpeechCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechIncreased').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechDecreased').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPaucity').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechHyperverbal').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPoorArticulations').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechLoud').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechSoft').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechMute').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechStuttering').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechImpaired').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechPressured').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechFlight').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_SpeechOthers').attr('checked', '');


    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechIncreased", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechDecreased", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechPaucity", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechHyperverbal", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechPoorArticulations", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechLoud", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechSoft", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechMute", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechStuttering", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechImpaired", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechPressured", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechFlight", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_SpeechOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_SpeechOtherComments', 'CustomDocumentPsychiatricNoteExams', 'SpeechOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "SpeechOtherComments", '');
}


function UncheckLanguageCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyNaming').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_LanguageDifficultyRepeating').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_LanguageOthers').attr('checked', '');


    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "LanguageDifficultyNaming", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "LanguageDifficultyRepeating", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "LanguageOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_LanguageOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_LanguageOtherComments', 'CustomDocumentPsychiatricNoteExams', 'LanguageOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "LanguageOtherComments", '');
}



function UncheckMoodAndAffectCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MoodHappy').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MoodSad').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MoodAnxious').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MoodAngry').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MoodIrritable').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MoodElation').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MoodNormal').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MoodOthers').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuthymic').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AffectDysphoric').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AffectAnxious').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AffectIrritable').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AffectBlunted').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AffectLabile').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AffectEuphoric').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AffectCongruent').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AffectOthers').attr('checked', '');


    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MoodHappy", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MoodSad", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MoodAnxious", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MoodAngry", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MoodIrritable", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MoodElation", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MoodNormal", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MoodOthers", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectEuthymic", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectDysphoric", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectAnxious", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectIrritable", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectBlunted", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectLabile", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectEuphoric", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectCongruent", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_MoodOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_MoodOtherComments', 'CustomDocumentPsychiatricNoteExams', 'MoodOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_AffectOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AffectOtherComments', 'CustomDocumentPsychiatricNoteExams', 'AffectOtherComments');

    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MoodOtherComments", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AffectOtherComments", '');
}



function UncheckAttensionSpanAndConcentrationCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorConcentration').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AttensionPoorAttension').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AttensionDistractible').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AttentionSpanOthers').attr('checked', '');


    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AttensionPoorConcentration", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AttensionPoorAttension", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AttensionDistractible", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AttentionSpanOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_AttentionSpanOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AttentionSpanOtherComments', 'CustomDocumentPsychiatricNoteExams', 'AttentionSpanOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AttentionSpanOtherComments", '');
}




function UncheckThoughtContentCognisionCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TPDisOrganised').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TPBlocking').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TPPersecution').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TPBroadCasting').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TPDetrailed').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TPThoughtinsertion').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TPIncoherent').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TPRacing').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TPIllogical').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOthers').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCDelusional').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCParanoid').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCIdeas').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtInsertion').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtWithdrawal').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCThoughtBroadcasting').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCReligiosity').attr('checked', '');

    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCGrandiosity').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCPerserveration').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCObsessions').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCWorthlessness').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCLoneliness').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCGuilt').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCHopelessness').attr('checked', '');


    $('#CheckBox_CustomDocumentPsychiatricNoteExams_TCHelplessness').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtContentOthers').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_CAConcrete').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_CAUnable').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_CAPoorComputation').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOthers').attr('checked', '');
  



    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TPDisOrganised", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TPBlocking", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TPPersecution", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TPBroadCasting", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TPDetrailed", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TPThoughtinsertion", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TPIncoherent", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TPRacing", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TPIllogical", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "ThoughtProcessOthers", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCDelusional", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCParanoid", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCIdeas", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCThoughtInsertion", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCThoughtWithdrawal", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCThoughtBroadcasting", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCReligiosity", '');

    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCGrandiosity", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCPerserveration", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCObsessions", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCWorthlessness", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCLoneliness", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCGuilt", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCHopelessness", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "TCHelplessness", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "ThoughtContentOthers", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "CAConcrete", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "CAUnable", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "CAPoorComputation", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "CognitiveAbnormalitiesOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_ThoughtProcessOtherComments', 'CustomDocumentPsychiatricNoteExams', 'ThoughtProcessOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_ThoughtContentOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_ThoughtContentOtherComments', 'CustomDocumentPsychiatricNoteExams', 'ThoughtContentOtherComments');
    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_CognitiveAbnormalitiesOtherComments', 'CustomDocumentPsychiatricNoteExams', 'CognitiveAbnormalitiesOtherComments');

    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "ThoughtProcessOtherComments", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "ThoughtContentOtherComments", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "CognitiveAbnormalitiesOtherComments", '');
}


function UncheckAssociationsCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsLoose').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsClanging').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsWordsalad').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsCircumstantial').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsTangential').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsOthers').attr('checked', '');


    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AssociationsLoose", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AssociationsClanging", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AssociationsWordsalad", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AssociationsCircumstantial", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AssociationsTangential", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AssociationsOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_AssociationsOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AssociationsOtherComments', 'CustomDocumentPsychiatricNoteExams', 'AssociationsOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AssociationsOtherComments", '');
}

function UncheckAbnormalorPsychoticThoughtsCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDAuditoryHallucinations').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDVisualHallucinations').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDCommandHallucinations').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDDelusions').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDPreoccupation').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDOlfactoryHallucinations').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDGustatoryHallucinations').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDTactileHallucinations').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDSomaticHallucinations').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_PDIllusions').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthers').attr('checked', '');

    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_PsychosisOrDisturbanceOfPerception]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicideIdeation]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalIntent]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIdeation]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalIntent]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentSuicidalPlan]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_PDMeanstocarry]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_PDCurrentHomicidalPlans]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_PDMeansToCarryNew]').attr('checked', '');


    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDAuditoryHallucinations", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDVisualHallucinations", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDCommandHallucinations", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDDelusions", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDPreoccupation", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDOlfactoryHallucinations", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDGustatoryHallucinations", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDTactileHallucinations", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDSomaticHallucinations", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDIllusions", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AbnormalPsychoticOthers", '');

    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PsychosisOrDisturbanceOfPerception", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDCurrentSuicideIdeation", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDCurrentSuicidalIntent", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDCurrentHomicidalIdeation", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDCurrentHomicidalIntent", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDCurrentSuicidalPlan", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDMeanstocarry", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDCurrentHomicidalPlans", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "PDMeansToCarryNew", '');


    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_AbnormalPsychoticOthersComments', 'CustomDocumentPsychiatricNoteExams', 'AbnormalPsychoticOthersComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "AbnormalPsychoticOthersComments", '');
}


function UncheckOrientationCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPerson').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_OrientationPlace').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_OrientationTime').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_OrientationSituation').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_OrientationOthers').attr('checked', '');


    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "OrientationPerson", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "OrientationPlace", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "OrientationTime", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "OrientationSituation", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "OrientationOthers", '');
  

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_OrientationOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_OrientationOtherComments', 'CustomDocumentPsychiatricNoteExams', 'OrientationOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "OrientationOtherComments", '');
}

function UncheckFundOfKnowledgeCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeCurrentEvents').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgePastHistory').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeVocabulary').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOthers').attr('checked', '');

    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "FundOfKnowledgeCurrentEvents", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "FundOfKnowledgePastHistory", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "FundOfKnowledgeVocabulary", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "FundOfKnowledgeOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_FundOfKnowledgeOtherComments', 'CustomDocumentPsychiatricNoteExams', 'FundOfKnowledgeOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "FundOfKnowledgeOtherComments", '');
}


function UncheckInsightAndJudgementCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementSubstance').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOthers').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_InsightAndJudgementStatus]').attr('checked', '');

    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "InsightAndJudgementSubstance", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "InsightAndJudgementOthers", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "InsightAndJudgementStatus", '');

   

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_InsightAndJudgementOtherComments', 'CustomDocumentPsychiatricNoteExams', 'InsightAndJudgementOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "InsightAndJudgementOtherComments", '');
}


function UncheckMemoryCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MemoryOthers').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_MemoryImmediate]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRecent]').attr('checked', '');
    $('[name$=RadioButton_CustomDocumentPsychiatricNoteExams_MemoryRemote]').attr('checked', '');


    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MemoryOthers", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MemoryImmediate", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MemoryRecent", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MemoryRemote", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_MemoryOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_MemoryOtherComments', 'CustomDocumentPsychiatricNoteExams', 'MemoryOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MemoryOtherComments", '');
}


function UncheckMuscleStrengthorToneCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAtrophy').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthorToneAbnormal').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOthers').attr('checked', '');

    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MuscleStrengthorToneAtrophy", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MuscleStrengthorToneAbnormal", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MuscleStrengthOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_MuscleStrengthOtherComments', 'CustomDocumentPsychiatricNoteExams', 'MuscleStrengthOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "MuscleStrengthOtherComments", '');
}


function UncheckGaitandStationCheckBoxes() {
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationRestlessness').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationStaggered').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationShuffling').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GaitandStationUnstable').attr('checked', '');
    $('#CheckBox_CustomDocumentPsychiatricNoteExams_GaitAndStationOthers').attr('checked', '');

    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GaitandStationRestlessness", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GaitandStationStaggered", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GaitandStationShuffling", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GaitandStationUnstable", '');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GaitAndStationOthers", '');

    ShowCommentBoxTextArea('CheckBox_CustomDocumentPsychiatricNoteExams_GaitAndStationOthers', 'Textbox_CustomDocumentPsychiatricNoteExams_GaitAndStationOtherComments', 'CustomDocumentPsychiatricNoteExams', 'GaitAndStationOtherComments');
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteExams", "GaitAndStationOtherComments", '');
}





SCMedicalNote.loadVitals = function () {
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/PsychiatricNote/WebPages/PsychiatricNote.aspx",
            data: "action=LoadVitals",
            success: function (result) {
                if (result != '') {
                   // debugger;
                    var divVital = $("[id$=divVitals]");
                    var VitalsHtml = result.split("#8#2#3$");
                    divVital.html(SCMedicalNote.createTable(VitalsHtml));
                }
            }
        })
    }
    catch (ex) { }
}
SCMedicalNote.createTable = function (vitalhtml) {
    try {
        if (vitalhtml.length > 0) {
            var tableHeader = "<table width='750px' cellpadding='0' cellspacing='0'>";
            var tableBody = "";
            var endTable = "</table>";
            tableBody += "<tr valign='top'>";
            tableBody += "<td align='left' width='200px' style='padding-bottom:2px;padding-left:5px'><u><b><span>Current vitals: </span>" + vitalhtml[3] + "</b></u></td>";
            tableBody += "<td align='left' width='200px' style='padding-bottom:2px;padding-left:5px'><u><b><span>Previous vitals: </span>" + vitalhtml[4] + "</b></u></td>";
            tableBody += "<td align='left' width='200px' style='padding-bottom:2px;padding-left:5px'><u><b><span>Previous vitals: </span>" + vitalhtml[5] + "</b></u></td>";
            tableBody += "</tr>";
            tableBody += "<tr valign='top'>";
            tableBody += "<td align='center' width='200px' style='padding-bottom:2px;padding-left:5px'></td>";
            tableBody += "<td align='center' width='200px' style='padding-bottom:2px;padding-left:5px'></td>";
            tableBody += "<td align='center' width='200px' style='padding-bottom:2px;padding-left:5px'></td>";
            tableBody += "</tr>";
            tableBody += "<tr valign='top'>";
            tableBody += "<td align='left' width='250px' style='padding-bottom:2px;padding-left:5px'>" + vitalhtml[0] + "</td>";
            tableBody += "<td align='left' width='250px' style='padding-bottom:2px;padding-left:5px'>" + vitalhtml[1] + "</td>";
            tableBody += "<td align='left' width='250px' style='padding-bottom:2px;padding-left:5px'>" + vitalhtml[2] + "</td>";
            tableBody += "</tr>";
            return tableHeader + tableBody + endTable;
        }

    }
    catch (err) {
        LogClientSideException(err, 'LoadVitals: createTable');
    }
}
SCMedicalNote.BindObjectiveStatus = function (dom) {
    var ObjectiveStatusDropdownHtml = "";
    var ObjectiveStatusDropdown = $("select[id$=DropDownListCommon_ServiceNoteGoalsObjectives_ObjectiveStatus]");
    if (ObjectiveStatusDropdown.length > 0) {
        ObjectiveStatusDropdownHtml = ObjectiveStatusDropdown.html();
    }
    $('select[id^="DropDownList_CustomMedicalNoteObjectives_"]').each(function () {
        var ststus = this.getAttribute("objectivestatus");
        var ObjectiveStatusDropdownHtml = "";
        var ObjectiveStatusDropdown = $("select[id$=DropDownListCommon_ServiceNoteGoalsObjectives_ObjectiveStatus]").val(ststus);

        if (ObjectiveStatusDropdown.length > 0) {
            ObjectiveStatusDropdownHtml = ObjectiveStatusDropdown.html();
        }
        this.innerHTML = ObjectiveStatusDropdownHtml;
    });
}
SCMedicalNote.ChangeObjectiveStatus = function (htmldata, dropdown) {
    var vSelectedContactTable = GetAutoSaveXMLDomNode('CustomMedicalNoteObjectives');
    var items = vSelectedContactTable.length > 0 ? $(vSelectedContactTable).XMLExtract() : [];
    var vSelectedContactId = '';
    if (items.length > 0) {
        $(items).each(function () {
            if ($(this)[0].RecordDeleted != 'Y' && $(this)[0].ObjectiveNumber == htmldata) {
                vSelectedContactId = $(this)[0].MedicalNoteObjectiveId;
                return false;
            }

        });
    }
    var contactitem = ArrayHelpers.GetItem(items, vSelectedContactId, 'MedicalNoteObjectiveId');
    var selectedStatus = $(dropdown).val();
    contactitem["ObjectiveStatus"] = selectedStatus;
    CreateAutoSaveXMLObjArray('CustomMedicalNoteObjectives', 'MedicalNoteObjectiveId', contactitem, false);
}
SCMedicalNote.CheckBoxJavascriptObj = function (htmldata, chk) {
    var vSelectedContactTable = GetAutoSaveXMLDomNode('CustomMedicalNoteObjectives');
    var items = vSelectedContactTable.length > 0 ? $(vSelectedContactTable).XMLExtract() : [];
    var vSelectedContactId = '';
    if (items.length > 0) {
        $(items).each(function () {
            if ($(this)[0].RecordDeleted != 'Y' && $(this)[0].ObjectiveNumber == htmldata) {
                vSelectedContactId = $(this)[0].MedicalNoteObjectiveId;
                return false;
            }
        });
    }
    var contactitem = ArrayHelpers.GetItem(items, vSelectedContactId, 'MedicalNoteObjectiveId');
    if ($(chk).attr('checked') == true) {
        chk = "true";
        contactitem["ObjectiveSelected"] = "Y";
    }
    else {
        contactitem["ObjectiveSelected"] = "N";
    }
    CreateAutoSaveXMLObjArray('CustomMedicalNoteObjectives', 'MedicalNoteObjectiveId', contactitem, false);
}
SCMedicalNote.CheckBoxGoalJavascript = function (htmldata, row) {
    var vSelectedContactTable = GetAutoSaveXMLDomNode('CustomMedicalNoteGoals');
    var items = vSelectedContactTable.length > 0 ? $(vSelectedContactTable).XMLExtract() : [];
    var vSelectedContactId = '';
    if (items.length > 0) {
        $(items).each(function () {
            if ($(this)[0].RecordDeleted != 'Y' && $(this)[0].CarePlanGoalId == htmldata) {
                vSelectedContactId = $(this)[0].MedicalNoteGoalId;
                return false;
            }
        });
    }
    var contactitem = ArrayHelpers.GetItem(items, vSelectedContactId, 'MedicalNoteGoalId');
    //var docVersionId = $('CustomDocumentMHAContents > DocumentVersionId', dom).text();
    if ($(row).attr('checked') == true) {
        chk = "true";
        contactitem["GoalSelected"] = "Y";
        //contactitem["ProgramId"] = pgmid;
        uncheckObj(htmldata, "false");
    }
    else {
        contactitem["GoalSelected"] = "N";
        uncheckObj(htmldata, "disabled");
    }
    CreateAutoSaveXMLObjArray('CustomMedicalNoteGoals', 'MedicalNoteGoalId', contactitem, false);
}

SCMedicalNote.loadAllergies = function (from) {
    try {
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/PsychiatricNote/WebPages/PsychiatricNote.aspx",
            data: "action=LoadAllergirs",
            success: function (result) {
                if (result != '') {
                    var AllergiesDiv = $("[id$=divCurrentAllergies]");
                    AllergiesDiv.html(result);
                    if (from == 'click') {
                        CreateAutoSaveXml("CustomDocumentPsychiatricNoteGenerals", "AllergiesText", AllergiesDiv.text());
                    }
                }
            }
        })
    }
    catch (ex) { }
}

SCMedicalNote.MedicationsDiscontinued = function () {
    try {
        var DateOfService = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService");
        if (DateOfService != null)
            DateOfService = ChangeDateFormat(DateOfService);
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/PsychiatricNote/WebPages/PsychiatricNote.aspx",
            data: "action=GetDisconMedications&DateOfService=" + DateOfService,
            success: function (result) {
                if (result != '') {
                    SCMedicalNote.CreateMedicationsTables(result);
                }
            }
        })
    }
    catch (ex) { }
}

function uncheckObj(htmldata, type, pNotSaveFlag) {
    $('[#div_GoalsObj][GoalID=' + htmldata + ']').each(function () {
        if (type == "disabled") {
            $(this).attr("disabled", "disabled");
            $(this).attr("checked", false);
            if (!pNotSaveFlag)
                SCMedicalNote.CheckBoxJavascriptObj($(this).attr('ObjectiveNumber'), this, pNotSaveFlag);
        }
        else
            $(this).removeAttr("disabled");
    });
}

appendExistingProblems = (function (dom, problemcount, index) {
    try {
        if (dom.find("PsychiatricNoteProblemId").length > 0) {
            var PsychiatricNoteProblemId = dom.find("PsychiatricNoteProblemId")[index].text;

            var c = 0;
            var currentindex = index;
            start: while (true) {
                c = 0;
                var indexvalue = $.inArray(parseInt(PsychiatricNoteProblemId), psychiatricEvaluationProblemIdArray);
                if (indexvalue > -1) {
                    currentindex++;
                    PsychiatricNoteProblemId = dom.find("PsychiatricNoteProblemId")[currentindex].text;
                }
                else
                    c = 1;
                if (c < 1)
                    continue start;
                break;
            }

            if (PsychiatricNoteProblemId) {
                var problemhtml = $('#divProblemTemplate').html().replace(/s8s2s3s/g, PsychiatricNoteProblemId);
                $('#divMainProblem').append(problemhtml);
                $('#Span_' + PsychiatricNoteProblemId + '_ProblemNumber').html(problemcount);

                $("input[type=button][id^=Button_CustomPsychiatricNoteProblems_" + PsychiatricNoteProblemId + "_Problem]").unbind('click');
                $("input[type=button][id^=Button_CustomPsychiatricNoteProblems_" + PsychiatricNoteProblemId + "_Problem]").bind('click', function () {
                    ShowProblemPopup(this);
                });
                SetFieldValue(PsychiatricNoteProblemId, dom);
                var indexvalue = $.inArray(parseInt(PsychiatricNoteProblemId), psychiatricEvaluationProblemIdArray);
                if (indexvalue == -1) {
                    psychiatricEvaluationProblemIdArray.push(parseInt(PsychiatricNoteProblemId));
                    bindFocusEventHistory('table_' + PsychiatricNoteProblemId + '_Problem');
                }
            }
        }
        else {
            $('[section=AfterProblem]').show();
        }

        if (psychiatricEvaluationProblemIdArray.length == dom.find("PsychiatricNoteProblemId").length) {
            $('[section=AfterProblem]').show();
            $('[id$=General]').unbind('scroll');
        }
    }
    catch (ex) { }
});

bindHistoryTabScrollEvent = (function () {
    try {
        var objScroll = $('[id$=General]');
        if (objScroll.length > 0) {
            scrollElem = $(objScroll)[0];

            $(scrollElem).unbind('keyup');
            $(scrollElem).keyup(function (e) {
                if ($('#trAfterProblem').css('display') == 'none') {
                    $(scrollElem).unbind('scroll');
                    $(scrollElem).scroll(function () {
                        if ($(this)[0].scrollHeight == $(this).height() + $(this).scrollTop()) {
                            appendNextExistingProblems();
                        }
                        else {
                            appendNextExistingProblems();
                        }
                    });
                }
                else {
                    $(this).unbind('keyup');
                    $(this).unbind('scroll');
                }
            });

            $(scrollElem).unbind('scroll');
            $(scrollElem).scroll(function () {
                if ($(this)[0].scrollHeight == $(this).height() + $(this).scrollTop()) {
                    appendNextExistingProblems();
                }
                else {
                    appendNextExistingProblems();
                }
            });
        }
    }
    catch (ex) { }
});

appendNewProblem = (function () {
    try {
        var _PsychiatricNoteProblemId = 0;
        AutoSaveXMLDom.find("CustomPsychiatricNoteProblems").each(function () {
            $(this).children().each(function () {
                if (this.tagName == "PsychiatricNoteProblemId") {
                    if (parseInt($(this).text()) < 0 && _PsychiatricNoteProblemId <= 0 && _PsychiatricNoteProblemId > parseInt($(this).text())) {
                        _PsychiatricNoteProblemId = parseInt($(this).text());
                    }
                }
            });
        });

        if (_PsychiatricNoteProblemId == 0)
            _PsychiatricNoteProblemId = -1
        else
            _PsychiatricNoteProblemId = _PsychiatricNoteProblemId + (-1);

        var _psychiatricevaluationproblemid;
        var _createdby;
        var _createddate;
        var _modifiedby;
        var _modifieddate;
        var _documentversionid;

        var _xmltable = AutoSaveXMLDom[0].childNodes[0].appendChild(AutoSaveXMLDom[0].createElement('CustomPsychiatricNoteProblems')); //Add Table
        _psychiatricevaluationproblemid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('PsychiatricNoteProblemId')); //Add Column
        _psychiatricevaluationproblemid.text = _PsychiatricNoteProblemId;

        _createdby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedBy')); //Add Column
        _createdby.text = objectPageResponse.LoggedInUserCode;

        _createddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('CreatedDate')); //Add Column
        _createddate.text = ISODateString(new Date());

        _modifiedby = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedBy')); //Add Column
        _modifiedby.text = objectPageResponse.LoggedInUserCode;

        _modifieddate = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('ModifiedDate')); //Add Column
        _modifieddate.text = ISODateString(new Date());

        _documentversionid = _xmltable.appendChild(AutoSaveXMLDom[0].createElement('DocumentVersionId')); //Add Column
        _documentversionid.text = AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first DocumentVersionId").text();
        AddToUnsavedTables("CustomPsychiatricNoteProblems");
        CreateUnsavedInstanceOnDatasetChange();
        var problemhtml = $('#divProblemTemplate').html().replace(/s8s2s3s/g, _PsychiatricNoteProblemId);
        $('#divMainProblem').append(problemhtml);
        $('#Span_' + _PsychiatricNoteProblemId + '_ProblemNumber').html($('[section=spannumber]').length - 1);
        $("input[type=button][id^=Button_CustomPsychiatricNoteProblems_" + _PsychiatricNoteProblemId + "_Problem]").unbind('click');
        $("input[type=button][id^=Button_CustomPsychiatricNoteProblems_" + _PsychiatricNoteProblemId + "_Problem]").bind('click', function () {
            ShowProblemPopup(this);
        });
    }
    catch (ex) {

    }
});

updateProblem = (function (primarykeyvalue, obj, tablename, columnname, mode) {
    try {
        var ctrlvalue = '';
        if (mode == 'checkbox') {
            if ($(obj).attr('checked')) {
                ctrlvalue = 'Y';
                if (columnname == 'LocationOther') {
                    $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_LocationOtherText').show();
                }
            }
            else {
                ctrlvalue = 'N';
                if (columnname == 'LocationOther') {
                    $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_LocationOtherText').hide();
                    $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_LocationOtherText').val('');
                    SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricNoteProblemId", primarykeyvalue, "LocationOtherText", "", AutoSaveXMLDom[0]);
                }
            }
        }
        else {
            ctrlvalue = $(obj).val();
        }

        if (ctrlvalue == undefined || ctrlvalue == '')
            ctrlvalue = '';

        SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricNoteProblemId", primarykeyvalue, columnname, ctrlvalue, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", "PsychiatricNoteProblemId", primarykeyvalue, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", "PsychiatricNoteProblemId", primarykeyvalue, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
        if (columnname == 'AssociatedSignsSymptoms') {
            var selectedtext = $(obj).find("option:selected").text();
            if (selectedtext) {
                if (selectedtext == 'Other') {
                    $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').show();
                }
                else {
                    $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                    $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').val('');
                    SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricNoteProblemId", primarykeyvalue, "AssociatedSignsSymptomsOtherText", "", AutoSaveXMLDom[0]);
                }
            }
            else {
                $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').val('');
                SetColumnValueInXMLNodeByKeyValue(tablename, "PsychiatricNoteProblemId", primarykeyvalue, "AssociatedSignsSymptomsOtherText", "", AutoSaveXMLDom[0]);
            }
        }
        setPsycTextBox();

        CreateUnsavedInstanceOnDatasetChange();

    }
    catch (ex) {

    }
});

deleteProblem = (function (primarykeyvalue) {
    try {
        removeProblem(primarykeyvalue);
        setPsycTextBox();
        $('#table_' + primarykeyvalue + '_Problem').remove();
        var sectionobj = $('[section=spannumber]');
        for (var j = 0; j < sectionobj.length; j++) {
            if (j > 0) {
                $('[section=spannumber]')[j].innerHTML = '';
                $('[section=spannumber]')[j].innerHTML = j;
            }
        }


    }
    catch (ex) { }
});

removeProblem = (function (primarykeyvalue) {
    try {
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", "PsychiatricNoteProblemId", primarykeyvalue, "RecordDeleted", "Y", AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", "PsychiatricNoteProblemId", primarykeyvalue, "DeletedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", "PsychiatricNoteProblemId", primarykeyvalue, "DeletedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", "PsychiatricNoteProblemId", primarykeyvalue, "ModifiedBy", objectPageResponse.LoggedInUserCode, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", "PsychiatricNoteProblemId", primarykeyvalue, "ModifiedDate", ISODateString(new Date()), AutoSaveXMLDom[0]);
        CreateUnsavedInstanceOnDatasetChange();
    }
    catch (ex) {

    }
});

function SetFieldValue(primarykeyvalue, dom) {
    try {
        var controlCollection = $("select, input[type=checkbox], textarea, input[type=text]", $("table[id$='table_" + primarykeyvalue + "_Problem']")[0]);
        if (controlCollection) {
            controlCollection.each(
             function () {
                 var Names = $(this).attr('id').split('_');
                 var ColumnName = Names[3];
                 var TableName = Names[1];
                 var ControlType = this.type;
                 if (ControlType.indexOf('select') != -1) {
                     ColumnName = Names[Names.length - 1];
                     TableName = Names[Names.length - 3];
                 }
                 var control = $(this);

                 if (TableName == "" || ColumnName == "") {
                     return;
                 }
                 var newxml = dom.find("CustomPsychiatricNoteProblems PsychiatricNoteProblemId[text=" + primarykeyvalue + "]").parent();
                 var value = GetFielValueFromXMLDom($.xmlDOM(newxml[0].xml), TableName, ColumnName);
                 if (value != null) {
                     if (ControlType == "checkbox") {
                         if (value == "Y") {
                             control.attr('checked', true);
                         }
                         else {
                             control.attr('checked', false);
                         }

                         if (ColumnName == 'LocationOther') {
                             if (value == 'Y') {
                                 $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_LocationOtherText').show();
                             }
                             else {
                                 $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_LocationOtherText').hide();
                             }
                         }
                     }
                     else {
                         control.val(value);
                         if (ColumnName == 'AssociatedSignsSymptoms') {
                             var selectedtext = control.find("option:selected").text();
                             if (selectedtext) {
                                 if (selectedtext == 'Other') {
                                     $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').show();
                                 }
                                 else {
                                     $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                                 }
                             }
                             else {
                                 $('#TextBox_CustomPsychiatricNoteProblems_' + primarykeyvalue + '_AssociatedSignsSymptomsOtherText').hide();
                             }
                         }
                     }
                 }
             }
         );
        }
    }
    catch (err) {

    }
}

ISODateString = (function (dateIn) {
    var d;
    if ((typeof (dateIn) === 'date') ? true : (typeof (dateIn) === 'object') ? dateIn.constructor.toString().match(/date/i) !== null : false) {
        d = dateIn;
    } else {
        d = new Date(dateIn);
    }
    function pad(n) {
        n = parseInt(n, 10);
        return n < 10 ? '0' + n : n;
    }
    return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + 'T' +
        pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds());
});
appendNextExistingProblems = (function () {
    var index = $('[section=spannumber]').length - 1;
    if (index < AutoSaveXMLDom.find("PsychiatricNoteProblemId").length) {
        appendExistingProblems(AutoSaveXMLDom, index + 1, index);
    }
    else {
        $('[section=AfterProblem]').show();
        $("[id$=General]").unbind('scroll');
    }
});

bindFocusEventHistory = (function (controlname) {
    try {
        if ($('#trAfterProblem').css('display') == 'none') {
            var controlCollection = $("select, input[type=checkbox], textarea, input[type=text]", $("[id$=" + controlname + "]")[0]);
            if (controlCollection) {
                controlCollection.each(
                 function () {
                     $(this).unbind('focus');
                     $(this).focus(function () {
                         if ($('#trAfterProblem').css('display') == 'none') {
                             appendNextExistingProblems();

                             $("[id$=General]").unbind('scroll');
                             $("[id$=General]").scroll(function () {
                                 if ($(this)[0].scrollHeight == $(this).height() + $(this).scrollTop()) {
                                     appendNextExistingProblems();
                                 }
                                 else {
                                     appendNextExistingProblems();
                                 }
                             });
                         }
                         else {
                             $("[id$=General]").unbind('keyup');
                             $("[id$=General]").unbind('scroll');
                             var controlCollection = $("select, input[type=checkbox], textarea, input[type=text]", $("[id$=General]")[0]);
                             if (controlCollection) {
                                 controlCollection.each(
                                  function () {
                                      $(this).unbind('focus');
                                  }
                              );
                             }
                         }
                     });
                 }
             );
            }
        }
        else {
            $("[id$=General]").unbind('keyup');
            $("[id$=General]").unbind('scroll');
            var controlCollection = $("select, input[type=checkbox], textarea, input[type=text]", $("[id$=General]")[0]);
            if (controlCollection) {
                controlCollection.each(
                 function () {
                     $(this).unbind('focus');
                 }
             );
            }
        }
    }
    catch (err) {

    }
});




///////////////////////


function ShowSubstanceUsesPopup(button,ColumnName) {
   // debugger;
    var isChecked = button.checked;
    if (isChecked) {
        parent.OpenPage(5765, 60002, "Mode=" + ColumnName, null, $("input[id$=RelativePath]").val(), 'T', "dialogHeight: 350px; dialogWidth: 660px;dialogTitle:SmartCare;defaultCloseButtonID:btnClose");
       // RefreshPageData("InsertGrid", "DocumentDiagnosisCodes", "DocumentDiagnosisCodeId", "CustomGrid", "TableChildControl_DocumentDiagnosisCodes", "CustomGrid");

    }
    else{
        RemoveDiagnosis(ColumnName);
       // RefreshPageData("InsertGrid", "DocumentDiagnosisCodes", "DocumentDiagnosisCodeId", "CustomGrid", "TableChildControl_DocumentDiagnosisCodes", "CustomGrid");
    }
}

var SubUsecurrentRowId = 0;
function SubUseSelectRow() {
    try {
        if ((window.event.keyCode ? window.event.keyCode : window.event.which) == 40) {
            SubUseMarkRow(SubUsecurrentRowId + 1);
            SubUseScrollDivWithSelection(true);

        }
        else if ((window.event.keyCode ? window.event.keyCode : window.event.which) == 38) {
            SubUseMarkRow(SubUsecurrentRowId - 1);
            SubUseScrollDivWithSelection(false);

        }
        else if ((window.event.keyCode ? window.event.keyCode : window.event.which) == 13) {
            SubUseMarkRow(SubUsecurrentRowId);
            SubUseSetParentReturnValue($('[id$=HiddenPopUpName]').val(), $('[id$=HiddenPageName]').val());
        }

    }
    catch (err) {
        LogClientSideException(err, 'SubUseSelectRow');
    }
}

function SubUseScrollDivWithSelection(isDownKeyPressed) {
    var _DivToScroll = $("div #div1");
    var _checkboxItem = $("tr input[type=radio]:checked", _DivToScroll);
    var _currentScroll = _DivToScroll[0].scrollTop;
    var scrollflag = 22;
    if ($.browser.msie) { if ($.browser.version == 7) { scrollflag = 23; } }
    if (_checkboxItem.length > 0) {
        var _PositionY = $(_checkboxItem[0]).parents("tr:first")[0].offsetTop;
        if (isDownKeyPressed) {

            if (_PositionY > 265) {
                _DivToScroll.scrollTop(_currentScroll + scrollflag);
            }
        }
        else {
            if (_currentScroll >= 10)
                _DivToScroll.scrollTop(_currentScroll - scrollflag);

        }
    }

}


//Used to change the selected row for Diangosis Popup
function SubUseMarkRow(rowId) {
    try {
        if (document.getElementById(rowId) == null)
            return;
        if (document.getElementById(SubUsecurrentRowId) != null) {
            document.getElementById(SubUsecurrentRowId).style.backgroundColor = '#ffffff';
            if (rowId == 0) {
                document.getElementById(SubUsecurrentRowId).style.backgroundColor = '#ffffff';
            }
            else {//This code is added for maintain alternate color of row
                if (rowId % 2 == 0) {
                    document.getElementById(SubUsecurrentRowId).style.backgroundColor = '#f0f6f9';

                }
                else {
                    document.getElementById(SubUsecurrentRowId).style.backgroundColor = '#ffffff';
                }
            }
        }
        SubUsecurrentRowId = rowId;
        $("#buttonok").removeAttr("disabled");
        document.getElementById(rowId).style.backgroundColor = '#cccccc';
        var searchString = "title="
        var str;
        if ($('[id$=hddDisplayGridviewName]').val() != 'GridViewAxisIVLegend') {

            //if (document.getElementById('hddDisplayGridviewName').value != 'GridViewAxisIVLegend') {

            var parentobj = $("#" + rowId);
            if (parentobj.length > 0) {
                $("td>input[type=radio]", parentobj).attr("checked", "checked");
                var DSMs = $("td>span", parentobj);
                if (DSMs.length >= 4) {
                    var dsmcode = $.trim($(DSMs[0]).html());;
                    var dsmDescription = $.trim($(DSMs[1]).html());
                    var dsmAxis = $.trim($(DSMs[2]).html());
                    var dsmNumber = $.trim($(DSMs[3]).html());
                    var dsmAxisValue = $.trim($(DSMs[4]).html());
                    $("[id$=hddnretval]").val(dsmcode + "$$$" + dsmDescription + "$$$" + dsmAxis + "$$$" + dsmNumber + "$$$" + dsmAxisValue);
                }
                else if (DSMs.length == 2) {
                    $("[id$=hddnretval]").val($.trim($(DSMs[0]).html()));
                }
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'MarkRow');
    }
}
//Function : This Function is used to get the selected the values from popup 
//Description:changes form showdialog to modal popup
function SubUseGetRowValueOnSingleClick(val, rowNumber) {
    try {
        $("td>input[type=radio]", $("#" + rowNumber)).attr("checked", "checked");
        $("input[id$=buttonok]").removeAttr("disabled");
        $("input[id$=hddnretval]").val(val);

        if (val.toString().indexOf('$$$') > -1) {
            var arrayDescriptionICDCode = val.toString().split('$$$');
            $("input[id$=hiddenFieldForDescriptionICDCode]").val(arrayDescriptionICDCode[1])
        }
        //End of modificaiton

        if (SubUsecurrentRowId % 2 == 0) {
            document.getElementById(SubUsecurrentRowId).style.backgroundColor = '#ffffff';
        }
        else {
            document.getElementById(SubUsecurrentRowId).style.backgroundColor = '#f0f6f9';
        }
        SubUsecurrentRowId = rowNumber;
        document.getElementById(SubUsecurrentRowId).style.backgroundColor = '#cccccc';
        try {
            //to make ok button focus, so that scroll bar will not move
            $("$input[id$=buttonok]").focus();
        }
        catch (e)
        { }
    }
    catch (err) {
        LogClientSideException(err, 'SubUseGetRowValueOnSingleClick');
    }
}
//Function : This Function is used to get the selected the values on double click
//Description Set the desctiption information if user hit the enter key
var rowColor = false;
function SubUseGetRowValueOnDoubleClick(val) {
    try {
        $('input[id$=hddnretval]').val(val);
    }
    catch (err) {
        LogClientSideException(err, 'SubUseGetRowValueOnDoubleClick');
    }
}
//Purpose:To Check if click on any row only that color row need to be changed, to show as selected row.

function SubUseSetParentReturnValue(val, optionParam,Substance) {
    try {
      //  debugger;
        var returnValue;
        var newcount = 0;
        if (val.toString().indexOf('$$$') > -1) {
            returnValue = $("input[id$=hddnretval]").val();
        }
        else {
            returnValue = $("input[id$=hddnretval]").val() + '$$$' + $("input[id$=hiddenFieldForDescriptionICDCode]").val();
        }
        var icdDescription = "";
        var ICD10CodeId = "";
        var icd10code = "";
        if (returnValue != "") {
            var retArray = returnValue.split('$$$');
            icd10code = retArray[0];
            ICD10CodeId = retArray[4];
            icdDescription = retArray[7];
            var DiagnosisString = icd10code + ' - ' + icdDescription;
        }
        var textboxColumn = Substance+'Diagnosis';
            CreateAutoSaveXml("CustomDocumentPsychiatricNoteGenerals", textboxColumn, DiagnosisString);
            parent.CreateUnsavedInstanceOnDatasetChange();
            parent.$('#TextBox_CustomDocumentPsychiatricNoteGenerals_' + textboxColumn + '').val(DiagnosisString);
            parent.CloaseModalPopupWindow();
            parent.$('#TextBox_CustomDocumentPsychiatricNoteGenerals_' + textboxColumn + '').focus();
            addSubstanceDiagnosis(returnValue, Substance);
    }
    catch (err) {
        LogClientSideException(err, 'SubUseSetParentReturnValue');
    }
}

function RemoveDiagnosis(SourceSubstance) {
    PopupProcessing();
    $.ajax({
        type: "POST",
        url: GetRelativePath() + "Custom/PsychiatricNote/WebPages/PsychiatricNote.aspx",
        data: "action=RemoveDiagnosis&SourceSubstance=" + SourceSubstance,
        success: function (result) {
            CreateUnsavedInstanceOnDatasetChange();
            if (result != '') {
                var Outcomesjson = $.parseJSON(result);
                if (Outcomesjson != "" && Outcomesjson != null && Outcomesjson != "undefined") {
                    var AutoSave = Outcomesjson.AutoSaveXml;
                    if (AutoSave != "" && AutoSave != null && AutoSave != "undefined") {

                       // callCreateAutoSaveSeriveces(AutoSave);
                    }
                }
            }
            HidePopupProcessing();
            var textboxColumn = SourceSubstance + 'Diagnosis';
            CreateAutoSaveXml("CustomDocumentPsychiatricNoteGenerals", textboxColumn, '');
            $('#TextBox_CustomDocumentPsychiatricNoteGenerals_' + textboxColumn + '').val('');
        },
        error: function (result, err, Message) {
            HidePopupProcessing();
        }
    });
}


function addSubstanceDiagnosis(DiagnosisText,SourceSubstance) {
 //   debugger;
    PopupProcessing();
    $.ajax({
        type: "POST",
        url: GetRelativePath() + "Custom/PsychiatricNote/WebPages/PsychiatricNote.aspx",
        data: "action=UpdateDiagnosis&DiagnosisText=" + DiagnosisText+"&SourceSubstance=" + SourceSubstance,
        success: function (result) {
            if (result != '') {
                var Outcomesjson = $.parseJSON(result);
                if (Outcomesjson != "" && Outcomesjson != null && Outcomesjson != "undefined") {
                    var AutoSave = Outcomesjson.AutoSaveXml;
                    if (AutoSave != "" && AutoSave != null && AutoSave != "undefined") {

                     //   callCreateAutoSaveSeriveces(AutoSave);
                    }
                }
            }
            CreateUnsavedInstanceOnDatasetChange();
            HidePopupProcessing();
        },
        error: function (result, err, Message) {
            HidePopupProcessing();
        }
    });
}




//method to CreateAutoSaveXml
function callCreateAutoSaveSeriveces(result) {
   // debugger;
    var xmlobj = $.xmlDOM(result);
    var XMLProvidedServices = $("DocumentDiagnosisCodes", xmlobj);
    var XMLProvidedServicesitems = $(XMLProvidedServices).XMLExtract();
    var XMLProvidedServicesitemsNew = [];
    for (var i = 0; i < XMLProvidedServicesitems.length; i++) {
        if (XMLProvidedServicesitems[i].RecordDeleted !== 'Y') {
            var newitem = ArrayHelpers.GetItem(XMLProvidedServicesitems, XMLProvidedServicesitems[i].DocumentDiagnosisCodeId, 'DocumentDiagnosisCodeId');
            newitem['DocumentDiagnosisCodeId'] = XMLProvidedServicesitems[i].DocumentDiagnosisCodeId;
            newitem['CreatedDate'] = ISODateString(new Date());
            newitem['CreatedBy'] = objectPageResponse.LoggedInUserCode;
            newitem['ModifiedBy'] = objectPageResponse.LoggedInUserCode;
            newitem['ModifiedDate'] = ISODateString(new Date());
           // newitem['RecordDeleted'] = XMLProvidedServicesitems[i].RecordDeleted;
            //newitem['DeletedBy'] = objectPageResponse.LoggedInUserCode;
           // newitem['RecordDeleted'] = ISODateString(new Date());
            newitem['DocumentVersionId'] = XMLProvidedServicesitems[i].DocumentVersionId;
            newitem['ICD10CodeId'] = XMLProvidedServicesitems[i].ICD10CodeId;
            newitem['ICD10Code'] = XMLProvidedServicesitems[i].ICD10Code;
            newitem['ICD9Code'] = XMLProvidedServicesitems[i].ICD9Code;
            newitem['DiagnosisType'] = XMLProvidedServicesitems[i].DiagnosisType;
            newitem['Billable'] = XMLProvidedServicesitems[i].Billable;
            newitem['Severity'] = XMLProvidedServicesitems[i].Severity;
            newitem['DiagnosisOrder'] = XMLProvidedServicesitems[i].DiagnosisOrder;
           // newitem['Specifier'] = XMLProvidedServicesitems[i].Specifier;
           // newitem['Remission'] = XMLProvidedServicesitems[i].Remission;
            newitem['Source'] = XMLProvidedServicesitems[i].Source;
           // newitem['Comments'] = XMLProvidedServicesitems[i].Comments;
            CreateAutoSaveXMLObjArray('DocumentDiagnosisCodes', 'DocumentDiagnosisCodeId', newitem, false, 'N');
        }
    }
}

/////////////////////

function ShowProblemPopup(button) {
    SCMedicalNote.PsychiatricNoteProblemId = button.getAttribute("myvalue");
    parent.OpenPage(5765, 60001, '', null, $("input[id$=RelativePath]").val(), 'T', "dialogHeight: 350px; dialogWidth: 660px;dialogTitle:SmartCare;defaultCloseButtonID:btnClose");

}

//Purpose: To make possible navigation between gridview rows & also to select there values
var currentRowId = 0;
function SelectRow() {
    try {
        if ((window.event.keyCode ? window.event.keyCode : window.event.which) == 40) {
            MarkRow(currentRowId + 1);
            ScrollDivWithSelection(true);

        }
        else if ((window.event.keyCode ? window.event.keyCode : window.event.which) == 38) {
            MarkRow(currentRowId - 1);
            ScrollDivWithSelection(false);

        }
        else if ((window.event.keyCode ? window.event.keyCode : window.event.which) == 13) {
            MarkRow(currentRowId);
            SetParentReturnValue($('[id$=HiddenPopUpName]').val(), $('[id$=HiddenPageName]').val());
        }

    }
    catch (err) {
        LogClientSideException(err, 'SelectRow');
    }
}

function ScrollDivWithSelection(isDownKeyPressed) {
    var _DivToScroll = $("div #div1");
    var _checkboxItem = $("tr input[type=radio]:checked", _DivToScroll);
    var _currentScroll = _DivToScroll[0].scrollTop;
    var scrollflag = 22;
    if ($.browser.msie) { if ($.browser.version == 7) { scrollflag = 23; } }
    if (_checkboxItem.length > 0) {
        var _PositionY = $(_checkboxItem[0]).parents("tr:first")[0].offsetTop;
        if (isDownKeyPressed) {

            if (_PositionY > 265) {
                _DivToScroll.scrollTop(_currentScroll + scrollflag);
            }
        }
        else {
            if (_currentScroll >= 10)
                _DivToScroll.scrollTop(_currentScroll - scrollflag);

        }
    }

}


//Used to change the selected row for Diangosis Popup
function MarkRow(rowId) {
    try {
        if (document.getElementById(rowId) == null)
            return;
        if (document.getElementById(currentRowId) != null) {
            document.getElementById(currentRowId).style.backgroundColor = '#ffffff';
            if (rowId == 0) {
                document.getElementById(currentRowId).style.backgroundColor = '#ffffff';
            }
            else {//This code is added for maintain alternate color of row
                if (rowId % 2 == 0) {
                    document.getElementById(currentRowId).style.backgroundColor = '#f0f6f9';

                }
                else {
                    document.getElementById(currentRowId).style.backgroundColor = '#ffffff';
                }
            }
        }
        currentRowId = rowId;
        $("#buttonok").removeAttr("disabled");
        document.getElementById(rowId).style.backgroundColor = '#cccccc';
        var searchString = "title="
        var str;
        if ($('[id$=hddDisplayGridviewName]').val() != 'GridViewAxisIVLegend') {

            //if (document.getElementById('hddDisplayGridviewName').value != 'GridViewAxisIVLegend') {

            var parentobj = $("#" + rowId);
            if (parentobj.length > 0) {
                $("td>input[type=radio]", parentobj).attr("checked", "checked");
                var DSMs = $("td>span", parentobj);
                if (DSMs.length >= 4) {
                    var dsmcode = $.trim($(DSMs[0]).html());;
                    var dsmDescription = $.trim($(DSMs[1]).html());
                    var dsmAxis = $.trim($(DSMs[2]).html());
                    var dsmNumber = $.trim($(DSMs[3]).html());
                    var dsmAxisValue = $.trim($(DSMs[4]).html());
                    $("[id$=hddnretval]").val(dsmcode + "$$$" + dsmDescription + "$$$" + dsmAxis + "$$$" + dsmNumber + "$$$" + dsmAxisValue);
                }
                else if (DSMs.length == 2) {
                    $("[id$=hddnretval]").val($.trim($(DSMs[0]).html()));
                }
            }
        }
    }
    catch (err) {
        LogClientSideException(err, 'MarkRow');
    }
}
//Function : This Function is used to get the selected the values from popup 
//Description:changes form showdialog to modal popup
function GetRowValueOnSingleClick(val, rowNumber) {
    try {
        $("td>input[type=radio]", $("#" + rowNumber)).attr("checked", "checked");
        $("input[id$=buttonok]").removeAttr("disabled");
        $("input[id$=hddnretval]").val(val);

        if (val.toString().indexOf('$$$') > -1) {
            var arrayDescriptionICDCode = val.toString().split('$$$');
            $("input[id$=hiddenFieldForDescriptionICDCode]").val(arrayDescriptionICDCode[1])
        }
        //End of modificaiton

        if (currentRowId % 2 == 0) {
            document.getElementById(currentRowId).style.backgroundColor = '#ffffff';
        }
        else {
            document.getElementById(currentRowId).style.backgroundColor = '#f0f6f9';
        }
        currentRowId = rowNumber;
        document.getElementById(currentRowId).style.backgroundColor = '#cccccc';
        try {
            //to make ok button focus, so that scroll bar will not move
            $("$input[id$=buttonok]").focus();
        }
        catch (e)
        { }
    }
    catch (err) {
        LogClientSideException(err, 'GetRowValueOnSingleClick');
    }
}
//Function : This Function is used to get the selected the values on double click
//Description Set the desctiption information if user hit the enter key
var rowColor = false;
function GetRowValueOnDoubleClick(val) {
    try {
        $('input[id$=hddnretval]').val(val);
    }
    catch (err) {
        LogClientSideException(err, 'GetRowValueOnDoubleClick');
    }
}
//Purpose:To Check if click on any row only that color row need to be changed, to show as selected row.

var prevousRow = 0;
function ChangeRowColor(row) {
    try {
        if (prevousRow != 0) {
            prevousRow.style.backgroundColor = '';
        }
        row.style.backgroundColor = '#cccccc';
        prevousRow = row;
    }
    catch (err) {
        LogClientSideException(err, 'ChangeRowColor');
    }
}
function SetParentReturnValue(val, optionParam) {
    try {
       // debugger;
        var returnValue;
        var newcount = 0;
        if (val.toString().indexOf('$$$') > -1) {
            returnValue = $("input[id$=hddnretval]").val();
        }
        else {
            returnValue = $("input[id$=hddnretval]").val() + '$$$' + $("input[id$=hiddenFieldForDescriptionICDCode]").val();
        }
        var icdDescription = "";
        var icd10code = "";
        if (returnValue != "") {
            var retArray = returnValue.split('$$$');
            icd10code = retArray[0];
            icdDescription = retArray[4];
        }
        parent.SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", "PsychiatricNoteProblemId", parent.SCMedicalNote.PsychiatricNoteProblemId, "SubjectiveText", icdDescription, parent.AutoSaveXMLDom[0]);
        parent.SetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", "PsychiatricNoteProblemId", parent.SCMedicalNote.PsychiatricNoteProblemId, "ICD10Code", icd10code, parent.AutoSaveXMLDom[0]);
        parent.CreateUnsavedInstanceOnDatasetChange();
        parent.$('#TextArea_CustomPsychiatricNoteProblems_' + parent.SCMedicalNote.PsychiatricNoteProblemId + '_SubjectiveText').val(icdDescription);
        parent.CloaseModalPopupWindow();
        parent.$('#TextArea_CustomPsychiatricNoteProblems_' + parent.SCMedicalNote.PsychiatricNoteProblemId + '_SubjectiveText').focus();

    }
    catch (err) {
        LogClientSideException(err, 'ChangeRowColor');
    }
}

SCMedicalNote.BindMedications = function() {
    try {
        var DateOfService = GetFielValueFromXMLDom(AutoSaveXMLDom, "Services", "DateOfService");
        if (DateOfService != null)
            DateOfService = ChangeDateFormat(DateOfService);
        $.ajax({
            type: "POST",
            url: GetRelativePath() + "Custom/PsychiatricNote/WebPages/PsychiatricNote.aspx",
            data: "action=GetMedications&DateOfService=" + DateOfService,
            success: function(result) {
                if (result != '') {
                    SCMedicalNote.CreateMedicationsTables(result);
                }
            }
        })
    }
    catch (ex) { }
}

SCMedicalNote.CreateMedicationsTables = function(result) {
    var medicationResult = null;
    if (result != "") {
        medicationResult = result;
    }

    var resultCurrentMedication = "";
    var resultNotOrderdBySC = "";
    var resultDiscontinuedMedication = "";
    if (medicationResult && medicationResult.length > 0) {
        resultCurrentMedication = medicationResult;
        resultNotOrderdBySC = medicationResult;
        resultDiscontinuedMedication = medicationResult;
    }
    if (resultCurrentMedication != undefined && resultCurrentMedication.length > 0) {
        if ($(resultCurrentMedication).find('CurrentMedications').length > 0) {
            var divCurrentMedications = $('#divCurrentMedications');
            if (divCurrentMedications) {
                divCurrentMedications.html('');
            }
            divCurrentMedications.html(createMedicationsTable(resultCurrentMedication, 'O'));
        }
    }

    if (resultNotOrderdBySC != undefined && resultNotOrderdBySC.length > 0) {
        if ($(resultNotOrderdBySC).find('CurrentMedicationsNotSC').length > 0) {
            var divCurrentMedicationsNotOrderdBySC = $('#divCurrentMedicationsNotOrderdBySC');
            if (divCurrentMedicationsNotOrderdBySC) {
                divCurrentMedicationsNotOrderdBySC.html('');
            }
            divCurrentMedicationsNotOrderdBySC.html(createMedicationsTable(resultNotOrderdBySC, 'S'));
        }
    }
    if (resultDiscontinuedMedication != undefined && resultDiscontinuedMedication.length > 0) {
        var divMedicationsDiscontinued = $('#MedicationsDiscontinued');
        if (divMedicationsDiscontinued) {
            divMedicationsDiscontinued.html('');
        }
        divMedicationsDiscontinued.html(createDiscontinuedMedicationsTable(resultDiscontinuedMedication));
    }

}
function createDiscontinuedMedicationsTable(result) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<th align='left' width='20%'>Medication Name</th>";
    tableHeader += "<th align='left' width='20%'>Direction</th>";
    tableHeader += "<th align='left' width='20%'>Quantity</th>";
    tableHeader += "<th align='left' width='20%'>Refills</th>";
    tableHeader += "<th align='left' width='20%'>Prescriber Name</th>";

    tableHeader += "</tr></thead>";
    var resultClientMedications = $.xmlDOM(result);
    $(resultClientMedications).find('DiscontinuedMedications').each(function () {
        tableBody += "<tr>";
        tableBody += "<td align='left'>" + $(this).find('MedicationName').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('Direction').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('Quantity').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('Refills').text() + "</td>";
        tableBody += "<td align='left'>" + $(this).find('PrescriberName').text() + "</td>";
        tableBody += "</tr>";
    });

    tableBody += "</tbody>";
    return tableHeader + tableBody + endTable;
}
function createMedicationsTable(result, medGroup) {
    var tableHeader = "<table width='100%'><thead><tr>";
    var tableBody = "<tbody>";
    var endTable = "</table>";
    tableHeader += "<th align='left' width='13%'>Medication Name</th>";
    tableHeader += "<th align='left' width='28%'>Instruction</th>";
    tableHeader += "<th align='left' width='17%'>Prescriber</th>";
    tableHeader += "<th align='left' width='12%'>Source</th>";

    tableHeader += "<th align='left' width='10%'>Instruction Start</th>";
    tableHeader += "<th align='left' width='10%'>Rx End Date</th>";
    tableHeader += "<th align='left' width='8%'>Script</th>";
   // tableHeader += "<th align='left' width='20%'>Instruction Text</th>";

    tableHeader += "</tr></thead>";
    var resultClientMedications = $.xmlDOM(result);
    if (medGroup === 'O') {        
        $(resultClientMedications).find('CurrentMedications').each(function () {
            tableBody += "<tr>";
            tableBody += "<td align='left'>" + $(this).find('MedicationName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Instructions').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('PrescriberName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Source').text() + "</td>";

            tableBody += "<td align='left'>" + $(this).find('MedicationStartDate').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('MedicationEndDate').text() + "</td>";
            //if (medGroup === 'DC')
                tableBody += "<td align='left'>" + $(this).find('Script').text() + "</td>";
           // tableBody += "<td align='left'>" + $(this).find('InstructionsText').text() + "</td>";
            tableBody += "</tr>";
        });
    }
    if (medGroup === 'S') {
        $(resultClientMedications).find('CurrentMedicationsNotSC').each(function () {
            tableBody += "<tr>";
            tableBody += "<td align='left'>" + $(this).find('MedicationName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Instructions').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('PrescriberName').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('Source').text() + "</td>";

            tableBody += "<td align='left'>" + $(this).find('MedicationStartDate').text() + "</td>";
            tableBody += "<td align='left'>" + $(this).find('MedicationEndDate').text() + "</td>";
            //if (medGroup === 'DC')
                tableBody += "<td align='left'>" + $(this).find('Script').text() + "</td>";
           // tableBody += "<td align='left'>" + $(this).find('InstructionsText').text() + "</td>";
            tableBody += "</tr>";
        });
    }
    tableBody += "</tbody>";
    return tableHeader + tableBody + endTable;
}

SCMedicalNote.BindProblemsStatus = function (domObject) {
    var XmlProblems;
    var ProblemsLength;
    var ControlHtml = "";
    XmlProblems = domObject[0].childNodes[0].selectNodes("CustomPsychiatricNoteProblems")
    ProblemsLength = domObject[0].childNodes[0].selectNodes("CustomPsychiatricNoteProblems").length;
    ControlHtml += "<table border='0' cellspacing='0' cellpadding='0' width='100%'   style='padding-left:0px'>";

    var k = 0;
    for (var i = 0; i < ProblemsLength; i++) {
        var recorddeletedTEXT = 'N';
        if (XmlProblems[i].selectNodes("RecordDeleted")[0] != null) {
            recorddeletedTEXT = XmlProblems[i].selectNodes("RecordDeleted")[0].text;
        }
        if (recorddeletedTEXT != 'Y' && XmlProblems[i].selectNodes("SubjectiveText")[0] != null && XmlProblems[i].selectNodes("SubjectiveText").length > 0) {
            k++;
            var ProblemNumber = "Problem " + (k).toString() + ":";
            var SubjectiveText = XmlProblems[i].selectNodes("SubjectiveText")[0].text;
            var ProblemId = XmlProblems[i].selectNodes("PsychiatricNoteProblemId")[0].text;
            var ProblemStatusTEXT = '';
            if (XmlProblems[i].selectNodes("ProblemStatus")[0] != null) {
                ProblemStatusTEXT = XmlProblems[i].selectNodes("ProblemStatus")[0].text;
            }
            var ProblemMDMComments = '';
            if (XmlProblems[i].selectNodes("ProblemMDMComments")[0] != null) {
                ProblemMDMComments = XmlProblems[i].selectNodes("ProblemMDMComments")[0].text;
            }

            //var DiscussLongActingInjectable = "";
            //if (XmlProblems[i].selectNodes("DiscussLongActingInjectable")[0] != null) {
            //    DiscussLongActingInjectable = XmlProblems[i].selectNodes("DiscussLongActingInjectable")[0].text;
            //}
            //var radioCheckedYes = "";
            //var radioCheckedNo = "";
            //if (DiscussLongActingInjectable == 'Y') {
            //    radioCheckedYes = true;
            //}
            //else if (DiscussLongActingInjectable == 'N') {
            //    radioCheckedNo = true;
            //}
            var ProblemDropdownHtml = "";
            var ProblemsDropdown = $("select[id$=DropDownListCommon_CustomDocumentPsychiatricNoteMDMs_ProblemStatus]").val(ProblemStatusTEXT);
            if (ProblemsDropdown.length > 0) {
                ProblemDropdownHtml = ProblemsDropdown.html();
            }
            //var ICD10CODE = "";
            //if (XmlProblems[i].selectNodes("ICD10Code")[0] != null) {
            //    ICD10CODE = XmlProblems[i].selectNodes("ICD10Code")[0].text;
            //}
            ControlHtml += "<tr style='height: 8px;'>";
            ControlHtml += "<td style='width:100%'>";
            ControlHtml += "<div style='width:100%'>";
            ControlHtml += "<table style='width:100%'>";
            ControlHtml += "<tr>";
            ControlHtml += "<td style='width:100%' colspan='2'>";
            //var DiscussLongActingInjectabledisplay = false;
            //if (ICD10CODE != "") {
            //    DiscussLongActingInjectabledisplay = checkDiscussLongActingInjectable(ICD10CODE);
            //}
            //else {
            //    DiscussLongActingInjectabledisplay = false;
            //}
            //if (DiscussLongActingInjectabledisplay == true) {
            //    ControlHtml += "<div id ='div_" + ProblemId + "_injectable'>";
            //}
            //else {
            //ControlHtml += ProblemNumber + SubjectiveText;
            //    ControlHtml += "<div id ='div_" + ProblemId + "_injectable' style='display:none'>";
            //}
            ControlHtml += "<table  style='width:100%'>"
            ControlHtml += "<tr>"
            ControlHtml += "<td style='width:50%'>";
            ControlHtml += ProblemNumber + SubjectiveText;
            ControlHtml += "</td>"
            //ControlHtml += "<td width='32%'>"
            //ControlHtml += "Did you discuss long acting injectable with client?";
            //ControlHtml += "</td>"
            //ControlHtml += "<td  align='center' style='width: 2%'>"
            //if (radioCheckedYes == true) {
            //    ControlHtml += "<input type='radio' id='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable_Y' bindautosaveevents='False'  value='Y' name='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable' onclick=\"javascript:UpdateProblemRadio(this,'Y');\"  onclick='UpdateProblemRadio(this,'Y')'; checked = 'checked'   style='cursor: default' />";
            //}
            //else {
            //    ControlHtml += "<input type='radio' id='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable_Y'  bindautosaveevents='False' value='Y' name='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable'  onclick=\"javascript:UpdateProblemRadio(this,'Y');\"  style='cursor: default' />";
            //}
            //ControlHtml += "</td>"
            //ControlHtml += "<td align='left' style='width: 4%; padding-left: 2px'>";
            //ControlHtml += "<label for='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable_Y' style='cursor: default'>Yes</label>";
            //ControlHtml += "</td>"
            //ControlHtml += "<td  align='center' style='width: 2%'>"
            //if (radioCheckedNo == true) {
            //    ControlHtml += "<input type='radio' id='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable_N'  bindautosaveevents='False' value='N' name='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable'  onclick=\"javascript:UpdateProblemRadio(this,'N');\" checked = 'checked' style='cursor: default' />";
            //}
            //else {
            //    ControlHtml += "<input type='radio' id='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable_N'  bindautosaveevents='False' value='N' name='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable'  onclick=\"javascript:UpdateProblemRadio(this,'N');\" style='cursor: default' />";
            //}
            //ControlHtml += "</td>"
            //ControlHtml += "<td align='left' style='width: 10%; padding-left: 2px'>";
            //ControlHtml += "<label for='RadioButton_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_DiscussLongActingInjectable_N' style='cursor: default'>No</label>";
            //ControlHtml += "</td>"
            ControlHtml += "</tr>"
            ControlHtml += "</table>"
            ControlHtml += "</div>"
            ControlHtml += "</td>"
            ControlHtml += "</tr>"
            ControlHtml += "<tr>";
            ControlHtml += "<td style='width:77%'>";
            ControlHtml += "<textarea class='form_textarea' id = 'TextArea_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_ProblemMDMComments' bindautosaveevents='False' ProblemId = " + ProblemId + " onchange='UpdateProblemStatus(this)';   innerHTML = " + ProblemMDMComments + " rows='3' cols='1' style='width: 98%;' spellcheck='True' datatype='String'>";
            ControlHtml += ProblemMDMComments
            ControlHtml += "</textarea>"
            ControlHtml += "</td>"
            ControlHtml += "<td style='width:8%' align='center'>";
            ControlHtml += "<label for='DropDownList_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_ProblemStatus' style='cursor: default'>Status</label>";
            ControlHtml += "</select>"
            ControlHtml += "<td style='width:15%'>";
            ControlHtml += "<select id='DropDownList_CustomDocumentPsychiatricNoteMDMs_" + ProblemId + "_ProblemStatus' class='form_dropdown'  bindautosaveevents='False' ProblemId = " + ProblemId + " onchange='UpdateProblemStatus(this)';   innerHTML = " + ProblemDropdownHtml + " >"
            ControlHtml += "</select>"
            ControlHtml += "</td>"
            ControlHtml += "</tr>"
            ControlHtml += "</table>"
            ControlHtml += "</div>"
            ControlHtml += "</td>"
            ControlHtml += "</tr>";

        }
    }
    ControlHtml += "</table>"

    $("#ProblemsContainer").html(ControlHtml);
}

function UpdateProblemStatus(ctrl) {
    var nameArray = ctrl.id.split("_");
    var tablename = nameArray[1];
    var primaryKeyColumnName = 'PsychiatricNoteProblemId';
    var columnname = nameArray[3];
    var primaryKey = nameArray[2];
    var ctrlValue = GetControlValue(ctrl, undefined);
    var currentXMLDom = $("CustomPsychiatricNoteProblems>PsychiatricNoteProblemId[text=" + primaryKey + "]", AutoSaveXMLDom[0]).parent();
    CustomSetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", primaryKeyColumnName, primaryKey, columnname, ctrlValue, currentXMLDom);

}
function UpdateProblemRadio(ctrl, ctrlValue) {
    var nameArray = ctrl.id.split("_");
    var tablename = nameArray[1];
    var primaryKeyColumnName = 'PsychiatricNoteProblemId';
    var columnname = nameArray[3];
    var primaryKey = nameArray[2];
    var currentXMLDom = $("CustomPsychiatricNoteProblems>PsychiatricNoteProblemId[text=" + primaryKey + "]", AutoSaveXMLDom[0]).parent();
    CustomSetColumnValueInXMLNodeByKeyValue("CustomPsychiatricNoteProblems", primaryKeyColumnName, primaryKey, columnname, ctrlValue, currentXMLDom);

}

function CustomSetColumnValueInXMLNodeByKeyValue(tableName, primaryKeyColumnName, primaryKeyValue, changeColumnName, changeColumnValue, xmlDom) {
    if ($(changeColumnName, xmlDom).length == 0) {
        xmlDom[0].appendChild(AutoSaveXMLDom[0].createElement(changeColumnName));
    }
    var _xmlNode = $(changeColumnName, xmlDom);
    if (changeColumnValue == "") {
        _xmlNode.attr("xsi:nil", 'true');
    }
    _xmlNode.text(changeColumnValue);
    AddToUnsavedTables(tableName);
    CreateUnsavedInstanceOnDatasetChange();
}
//function checkDiscussLongActingInjectable(ICD10CODE) {
//    var returnvalue = false;

//    var programss = $("[id$=hiddenICDCodes]").val();
//    var programsJSON = $.parseJSON(programss);
//    for (var i = 0; i < programsJSON.length; i++) {
//        if (programsJSON[i].ICDCode == ICD10CODE) {
//            returnvalue = true;
//            break;
//        }
//    }

//    return returnvalue;
//}


function CallCustomNoteAfterDocumentCallbackComplete() {
	var ServiceProcedureCodeId = AutoSaveXMLDom.find("Services:first ProcedureCodeId").text();
    if ($('[id$=hiddenProcedureCodes]').val().indexOf(",") >= 0) {
            var PopupProcedureCodes = $('[id$=hiddenProcedureCodes]').val().split(',');
            if ($.inArray(ServiceProcedureCodeId, PopupProcedureCodes >= 0)) {
                return 'ActionNeeded';
            }
        }
	else if (($('[id$=hiddenProcedureCodes]').val() != '' || $('[id$=hiddenProcedureCodes]').val() != null) && $('[id$=hiddenProcedureCodes]').val() == ServiceProcedureCodeId) {
		return 'ActionNeeded';
	}
    else if (openNewpage == true && openNewpage != undefined) {
        EffectiveDate = $('#TextBox_DocumentInformation_EffectiveDate').val();
        var documentstatus = ValidationBeforeUpdate();
        var PastHistryCount = 0;
        var xml = GetScreenXML();
        if (documentstatus) {
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first FamilyHistory").text() == 'C' || AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first FamilyHistoryComments").text() != '') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHFamilyHistory", 'Y');
                PastHistryCount = PastHistryCount + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHFamilyHistory", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first SocialHistory").text() == 'C' || AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first SocialHistoryComments").text() != '') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHSocialHistory", 'Y');
                PastHistryCount = PastHistryCount + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHSocialHistory", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first PsychiatricHistory").text() == 'C' || AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first PsychiatricHistoryComments").text() != '') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHMedicalHistory", 'Y');
                PastHistryCount = PastHistryCount + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHMedicalHistory", 'N');
            }

            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHTotalCount", PastHistryCount);
            if (PastHistryCount == 1 || PastHistryCount == 2) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHResults", 'P');
            }
            if (PastHistryCount == 3) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryPHResults", 'C');
            }


            if (AutoSaveXMLDom.find("CustomPsychiatricNoteProblems Severity").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPISeverity", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricNoteProblems Duration").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIDuration", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricNoteProblems Intensity").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIQualityNature", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricNoteProblems AssociatedSignsSymptoms").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIAssociatedSignsSymptoms", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricNoteProblems ModifyingFactors").length == 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIModifyingFactors", 'N');
            }

            var severityFound = false;
            var durationFound = false;
            var intensityFound = false
            var timingFound = false;
            var contextFound = false;
            var signFound = false;
            var factorFound = false;
            var newProblem = false;
            var worseningCount = 0;
            var deletedRecord = 'N';
            var HistoryofPresentIllnessCount = 0;
            AutoSaveXMLDom.find("CustomPsychiatricNoteProblems").each(function () {
                $(this).children().each(function () {
                    if (this.tagName == "PsychiatricNoteProblemId") {
                        deletedRecord = GetColumnValueInXMLNodeByKeyValue('CustomPsychiatricNoteProblems', 'PsychiatricNoteProblemId', $(this).text(), 'RecordDeleted', AutoSaveXMLDom);
                    }
                    if (deletedRecord != 'Y') {
                        if (this.tagName == "Severity") {
                            if (severityFound == false) {
                                if ($(this).text() != "") {
                                    severityFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPISeverity", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPISeverity", 'N');
                                }
                            }
                        }
                        if (this.tagName == "Duration") {
                            if (durationFound == false) {
                                if ($(this).text() != "") {
                                    durationFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIDuration", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIDuration", 'N');
                                }
                            }
                        }
                        if (this.tagName == "Intensity") {
                            if (intensityFound == false) {
                                if ($(this).text() != "") {
                                    intensityFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIQualityNature", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIQualityNature", 'N');
                                }
                            }
                        }
                        //if (this.tagName == "TimeOfDayMorning" || this.tagName == "TimeOfDayNoon" || this.tagName == "TimeOfDayAfternoon" || this.tagName == "TimeOfDayEvening" || this.tagName == "TimeOfDayNight") {
                        //    if (timingFound == false) {
                        //        if ($(this).text() == "Y") {
                        //            timingFound = true;
                        //            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPITimingFrequency", 'Y');
                        //            HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                        //        }
                        //        else {
                        //            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPITimingFrequency", 'N');
                        //        }
                        //    }
                        //}

                        if (this.tagName == "TimeOfDayAllday" || this.tagName == "TimeOfDayMorning" || this.tagName == "TimeOfDayAfternoon" || this.tagName == "TimeOfDayNight") {
                            if (timingFound == false) {
                                if ($(this).text() == "Y") {
                                    timingFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPITimingFrequency", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPITimingFrequency", 'N');
                                }
                            }
                        }

                        //if (this.tagName == "LocationHome" || this.tagName == "LocationSchool" || this.tagName == "LocationWork" || this.tagName == "LocationEveryWhere" || this.tagName == "LocationOther") {
                        //    if (contextFound == false) {
                        //        if ($(this).text() == "Y") {
                        //            contextFound = true;
                        //            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPILocation", 'Y');
                        //            HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                        //        }
                        //        else {
                        //            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPILocation", 'N');
                        //        }
                        //    }
                        //}
                        if (this.tagName == "ContextText") {
                            if (contextFound == false) {
                                if ($(this).text() != '') {
                                    contextFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIContextOnset", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIContextOnset", 'N');
                                }
                            }
                        }


                        if (this.tagName == "AssociatedSignsSymptomsOtherText") {
                            if (signFound == false) {
                                if ($(this).text() != "") {
                                    signFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIAssociatedSignsSymptoms", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIAssociatedSignsSymptoms", 'N');
                                }
                            }
                        }
                        if (this.tagName == "ModifyingFactors") {
                            if (factorFound == false) {
                                if ($(this).text() != "") {
                                    factorFound = true;
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIModifyingFactors", 'Y');
                                    HistoryofPresentIllnessCount = HistoryofPresentIllnessCount + 1
                                }
                                else {
                                    CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIModifyingFactors", 'N');
                                }
                            }
                        }
                        //if (this.tagName == "ProblemStatus") {
                        //    debugger;
                        //    if (newProblem == false) {
                        //        var newstatus = $("[id$=DropDownListCommon_CustomDocumentPsychiatricNoteMDMs_ProblemStatus]").find('option[text="New"]').val();
                        //        if ($(this).text() && newstatus) {
                        //            if ($(this).text() == newstatus) {
                        //                newProblem = true;
                        //                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTONewProblem", 'Y');
                        //            }
                        //            else {
                        //                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTONewProblem", 'N');
                        //            }
                        //        }
                        //        else {
                        //            CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTONewProblem", 'N');
                        //        }
                        //    }
                        //}


                        //if (this.tagName == "ProblemStatus") {
                        //    debugger;
                        //    if (newProblem == false) {
                        //        var newstatusAdditional = $("[id$=DropDownListCommon_CustomDocumentPsychiatricNoteMDMs_ProblemStatus]").find('option[text="New - Additional Work Up"]').val();
                        //        if ($(this).text() && newstatusAdditional) {
                        //            if ($(this).text() == newstatusAdditional) {
                        //                newProblem = true;
                        //                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTONewProblem", 'Y');
                        //                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOAdditionalWorkup", 'Y');
                        //            }
                        //            else {
                        //                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTONewProblem", 'N');
                        //                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOAdditionalWorkup", 'N');
                        //            }
                        //        }
                        //        else {
                        //            CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTONewProblem", 'N');
                        //            CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOAdditionalWorkup", 'N');
                        //        }
                        //    }
                        //}
                        if (this.tagName == "ProblemStatus") {
                            var worseningstatus = $("[id$=DropDownListCommon_CustomDocumentPsychiatricNoteMDMs_ProblemStatus]").find('option[text="Worsening"]').val();
                            if ($(this).text() && worseningstatus) {
                                if ($(this).text() == worseningstatus) {
                                    worseningCount = worseningCount + 1;
                                }
                            }
                        }
                    }
                });

            });

            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPITotalCount", HistoryofPresentIllnessCount);
            if (HistoryofPresentIllnessCount > 0 && HistoryofPresentIllnessCount <= 3) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIResults", 'B');
            }
            if (HistoryofPresentIllnessCount >= 3) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryHPIResults", 'E');
            }


            var ReviewOfSymptoms = 0;
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewPsychiatric").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSPsychiatric", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSPsychiatric", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewGastrointestinal").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGastrointestinal", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGastrointestinal", 'N');
            }

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewNeurological").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSNeurological", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSNeurological", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewCardio").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSCardiovascular", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSCardiovascular", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewGenitourinary").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGenitourinary", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSGenitourinary", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewImmune").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSAllergicImmunologic", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSAllergicImmunologic", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewHemLymph").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSHematologicLymphatic", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSHematologicLymphatic", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewConstitutional").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSConstitutional", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSConstitutional", 'N');
            }

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewIntegumentary").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSSkin", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSSkin", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewEyes").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEye", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEye", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewEyes").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEarNoseMouthThroat", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEarNoseMouthThroat", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewMusculoskeletal").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSMusculoskeletal", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSMusculoskeletal", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewEndocrine").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEndocrine", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSEndocrine", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first ReviewRespiratory").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSRespiratory", 'Y');
                ReviewOfSymptoms = ReviewOfSymptoms + 1;
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSRespiratory", 'N');
            }

            CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSTotalCount", ReviewOfSymptoms);
            if (ReviewOfSymptoms == 1) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSResults", 'P');
            }
            if (ReviewOfSymptoms > 1) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSResults", 'E');
            }
            if (ReviewOfSymptoms > 9) {
                CreateAutoSaveXml("NoteEMCodeOptions", "HistoryROSResults", 'C');
            }

      


            var Examcount = 0;

            // General Appearance
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first GeneralAppearance").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first GeneralAppearance").text() == "G"){
                   Examcount = Examcount + 1;
               }
            // Speech 
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Speech").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Speech").text() == "W") {
                Examcount = Examcount + 1;
            }
            // Language 
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first PsychiatricNoteExamLanguage").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first PsychiatricNoteExamLanguage").text() == "W") {
                Examcount = Examcount + 1;
            }
            // Mood and Affect 
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodAndAffect").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodAndAffect").text() == "W") {
                Examcount = Examcount + 1;
            }
            // Attention Span and Concentration 
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AttensionSpanAndConcentration").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AttensionSpanAndConcentration").text() == "W") {
                Examcount = Examcount + 1;
            }
            // Thought Content and Process; Cognition 
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtContentCognision").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtContentCognision").text() == "W") {
                Examcount = Examcount + 1;
            }
            // Associations 
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Associations").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Associations").text() == "W") {
                Examcount = Examcount + 1;
            }
            // Abnormal/Psychotic Thoughts
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AbnormalorPsychoticThoughts").text() == "A") {
                Examcount = Examcount + 1;
            }
            // Orientation
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Orientation").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Orientation").text() == "W") {
                Examcount = Examcount + 1;
            }
            //  Fund of Knowledge
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first FundOfKnowledge").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first FundOfKnowledge").text() == "W") {
                Examcount = Examcount + 1;
            }
            //  Insight and Judgement
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first InsightAndJudgement").text() == "A" 
                ) {
                Examcount = Examcount + 1;
            }
            // Memory 
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Memory").text() == "A" ||
                AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Memory").text() == "W") {
                Examcount = Examcount + 1;
            }
            // Muscle Strength/Tone
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MuscleStrengthorTone").text() == "A" ||
               AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MuscleStrengthorTone").text() == "W") {
                Examcount = Examcount + 1;
            }
            //  Gait and Station 
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first GaitandStation").text() == "A" ||
               AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first GaitandStation").text() == "W") {
                Examcount = Examcount + 1;
            }
            
            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AlertOriented").text() == "Y" ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AlertOriented").text() == "N" ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AlertOrientedComment").text()!= "") {
            //    Examcount = Examcount + 1;
            //}



            // Exam Tab - General section 

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AlertOriented").text() == "Y" ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AlertOriented").text() == "N" ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AlertOrientedComment").text()!= "") {
            //    Examcount = Examcount + 1;
            //}

            // Exam Tab - Speech section
            
            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Speech").text() == 'R' || 
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Speech").text() == 'S' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first SpeechComment").text()!="") {
            //    Examcount = Examcount + 1;
            //}

            // Exam Tab - Psychomotor section

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Psychomotor").text() == 'N' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Psychomotor").text() == 'O' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first PsychomotorComment").text() != "") {
            //    Examcount = Examcount + 1;
            //}

            // Exam Tab - Mood section

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodEuthymic").text() == 'Y' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodLabile").text() == 'Y' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodDysphoric").text() == 'Y' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodElevated").text() == 'Y' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodAnxious").text() == 'Y' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodIrritable").text() == 'Y' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodExpansive").text() == 'Y' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodComment").text()!= '') {
            //    Examcount = Examcount + 1;
            //}

            // Exam Tab - Affect section

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AffectBroad").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AffectFlat").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AffectBlunted").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AffectConstricted").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AffectGuarded").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first AffectComment").text() != '') {
            //   Examcount = Examcount + 1;
            //}

            // Exam Tab - ThoughtProcess section

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessLogical").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessIllogical").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessCircumstantial").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessTangential").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessPreoccupied").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessAuditoryHallucinations").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessDelusions").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessVisualHallucinations").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessParanoia").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessGrandiose").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessReferential").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessPovertyOfThought").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessLooseAssociations").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessFlightOfIdeas").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcessComment").text() != '') {
            //   Examcount = Examcount + 1;
            //}

            // Exam Tab - Sucidal section

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Suicidal").text() == 'N' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Suicidal").text() == 'S' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first SuicidalIdeation").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first SuicidalIntent").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first SuicidalPlan").text() == 'Y' ||
            //   AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first SuicidalComment").text()!= '' ) {
            //   Examcount = Examcount + 1;
            //}

            // Exam Tab - Homicidal section

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Homicidal").text() == 'N' ||
            // AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Homicidal").text() == 'S' ||
            // AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first HomicidalIdeation").text() == 'Y' ||
            // AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first HomicidalIntent").text() == 'Y' ||
            // AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first HomicidalPlan").text() == 'Y' ||
            // AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first HomicidalCommnet").text() != '') {
            // Examcount = Examcount + 1;
            //}

            // Exam Tab - MemoryRecall section

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MemoryRecall").text() == 'I' ||
            // AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MemoryRecall").text() == 'S' ||
            // AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MemoryRecallComment").text() != '') {
            // Examcount = Examcount + 1;
            //}

            // Exam Tab - InsightJudgment section

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first InsightJudgment").text() == 'G' ||
            //AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first InsightJudgment").text() == 'F' ||
            //AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first InsightJudgment").text() == 'P' ||
            //AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first InsightJudgmentComment").text() != '') {
            //Examcount = Examcount + 1;
            //}

            // Exam Tab - Intelligence section

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Intelligence").text() == 'A' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Intelligence").text() == 'B' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Intelligence").text() == 'L' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Intelligence").text() == 'W' ) {
            //    Examcount = Examcount + 1;
            //}

            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MemoryAndRecall").text() == 'S') {
            //    Examcount = Examcount + 1;
            //}
            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtProcess").text() == 'S') {
            //    Examcount = Examcount + 1;
            //}
            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtContentSuicidal").text() == 'S' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtContentHomicidal").text() == 'S' ||
            //    AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first ThoughtContentPsychotic").text() == 'S') {
            //    Examcount = Examcount + 1;
            //}
            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first Psychomotor").text() == 'S') {
            //    Examcount = Examcount + 1;
            //}
            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first InsightJudgment").text() != '') {
            //    Examcount = Examcount + 1;
            //}
            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first MoodComment").text() != '') {
            //    Examcount = Examcount + 1;
            //}
            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteExams:first CognitivelyIntact").text() == 'Y') {
            //    Examcount = Examcount + 1;
            //}
            if (Examcount > 0) {
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatric", 'Y');
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatricCount", Examcount);
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatricTotalCount", 14);
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatric", 'N');
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatricCount", Examcount);
                CreateAutoSaveXml("NoteEMCodeOptions", "ExamOSPsychiatricTotalCount", 14);
            }

            // MDM
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first ReviewRadiologyTest").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRRORadiologyTest", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRRORadiologyTest", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first ReviewClinicalLabs").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRROClinicalLabs", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRROClinicalLabs", 'N');
            }

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first ReviewOtherTest").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRROOtherTest", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRROOtherTest", 'N');
            }

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first DiscussionOfTestResults").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRDiscussion", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRDiscussion", 'N');
            }

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first DecisionToObtainByOthers").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRObtainRecords", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRObtainRecords", 'N');
            }

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first ReviewSummarizedOldRecords").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRReviewSummarize", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRReviewSummarize", 'N');
            }

            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first IndependentVisualization").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRIndependentVisualization", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRIndependentVisualization", 'N');
            }

            if (AutoSaveXMLDom.find("CustomPsychiatricNoteProblems PsychiatricNoteProblemId").length == 1) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems1", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems1", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricNoteProblems PsychiatricNoteProblemId").length == 2) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems2", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems2", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricNoteProblems PsychiatricNoteProblemId").length == 3) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems3", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems3", 'N');
            }
            if (AutoSaveXMLDom.find("CustomPsychiatricNoteProblems PsychiatricNoteProblemId").length >= 4) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems4Plus", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblems4Plus", 'N');
            }

            //if (this.tagName == "DecisionMakingSchizophreniaStatus" || this.tagName == "DecisionMakingAnxietyStatus" || this.tagName == "DecisionMakingWeightLossStatus" || this.tagName == "DecisionMakingInsomniaStatus") {
            var DecisionMakingSchizophreniaStatus = $('select[id$=DropDownList_CustomDocumentPsychiatricNoteMDMs_DecisionMakingSchizophreniaStatus] option:selected').text();
            var DecisionMakingAnxietyStatus = $('select[id$=DropDownList_CustomDocumentPsychiatricNoteMDMs_DecisionMakingAnxietyStatus] option:selected').text();
            var DecisionMakingWeightLossStatus = $('select[id$=DropDownList_CustomDocumentPsychiatricNoteMDMs_DecisionMakingWeightLossStatus] option:selected').text();
            var DecisionMakingInsomniaStatus = $('select[id$=DropDownList_CustomDocumentPsychiatricNoteMDMs_DecisionMakingInsomniaStatus] option:selected').text();
            //Worsening
            if (DecisionMakingSchizophreniaStatus == "Worsening") {
                worseningCount = worseningCount + 1;
            }

            if (DecisionMakingAnxietyStatus == "Worsening") {
                worseningCount = worseningCount + 1;
            }

            if (DecisionMakingWeightLossStatus == "Worsening") {
                worseningCount = worseningCount + 1;
            }
            if (DecisionMakingInsomniaStatus == "Worsening") {
                worseningCount = worseningCount + 1;
            }

            //}




            if (worseningCount == 1) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblemWorsening1", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblemWorsening1", 'N');
            }
            if (worseningCount >= 2) {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblemWorsening2", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMDTOProblemWorsening2", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first OrderedMedications").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMRCMMMOSMedicationManagement", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "MDMRCMMMOSMedicationManagement", 'N');
            }
            if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first MoreThanFifty").text() == 'Y') {
                CreateAutoSaveXml("NoteEMCodeOptions", "ECE50PercentFaceTime", 'Y');
            }
            else {
                CreateAutoSaveXml("NoteEMCodeOptions", "ECE50PercentFaceTime", 'N');
            }
         

            //Pabitra

            //var PersonPresent = AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first PersonPresent").text();
            //if (PersonPresent != undefined && PersonPresent != null) {
            //    if (PersonPresent.length > 0) {
            //        CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRReviewSummarize", 'Y');
            //    }
            //    else if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first CollaborationOfCare").text() == 'Y') {
            //        CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRReviewSummarize", 'Y');
            //    }
            //    else {
            //        CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRReviewSummarize", 'N');
            //    }
            //}
            //else if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteMDMs:first CollaborationOfCare").text() == 'Y') {
            //    CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRReviewSummarize", 'Y');
            //}
            //else {
            //    CreateAutoSaveXml("NoteEMCodeOptions", "MDMDRReviewSummarize", 'N');
            //}


            //if (AutoSaveXMLDom.find("CustomDocumentPsychiatricNoteGenerals:first LatestDocumentVersionID").text() == '-1') {
            //    CreateAutoSaveXml("NoteEMCodeOptions", "ECETypeOfPatient", 'N');
            //}
            //else {
            //    CreateAutoSaveXml("NoteEMCodeOptions", "ECETypeOfPatient", 'Y');
            //}



            OpenEMCodingPopup = true;
            ValidateDocumentPageData();
        }
        //OpenPage(screenTypeEnum.Detail, 750, 'DocumentVersionId=' + AutoSaveXMLDom.find("Documents:first InProgressDocumentVersionId").text() + '^EffectiveDate=' + EffectiveDate + '^PageFrom=ProgressServieNote', 0, GetRelativePath(), 'T', 'dialogHeight: 550px; dialogWidth: 800px;');
    }

}

function OpenCustomPopUpAfterDocumentCallbackComplete() {
    try {
    var ServiceProcedureCodeId = AutoSaveXMLDom.find("Services:first ProcedureCodeId").text();
    if (OpenEMCodingPopup == true) {
        if ($('[id$=hiddenProcedureCodes]').val().indexOf(",") >= 0) {
            var PopupProcedureCodes = $('[id$=hiddenProcedureCodes]').val().split(',');
            if ($.inArray(ServiceProcedureCodeId, PopupProcedureCodes >= 0)) {
            }
        }
        else if (($('[id$=hiddenProcedureCodes]').val() != '' || $('[id$=hiddenProcedureCodes]').val() != null) && $('[id$=hiddenProcedureCodes]').val() == ServiceProcedureCodeId) {
        }
        else {
			openNewpage = false;
			if(objectPageResponse.ValidationInfoHTML == '')
			{
				OpenEMCodingPopup = false;
				OpenPage(screenTypeEnum.Detail, 750, 'DocumentVersionId=' + AutoSaveXMLDom.find("Documents:first InProgressDocumentVersionId").text() + '^EffectiveDate=' + EffectiveDate + '^PageFrom=ProgressServieNote', 0, GetRelativePath(), 'T', 'dialogHeight: 550px; dialogWidth: 800px;');
			}
        }
    }
    else {
        openNewpage = false;
        }
    }
    catch (err) {

    }
}


function OpenSignPopupForPsychiatricProgressNote() {
    ActionSignOrComplete = true;
    ActionValidateDocumentPageData = false;
    SavePageDataSet(AutoSaveXMLDom[0].xml);
}
function setPsycTextBox() {
    var Problems = "";
    var vSelectedContactTable = GetAutoSaveXMLDomNode('CustomPsychiatricNoteProblems');
    var items = vSelectedContactTable.length > 0 ? $(vSelectedContactTable).XMLExtract() : [];
    var vSelectedContactId = '';
    if (items.length > 0) {
        $(items).each(function () {
            if ($(this)[0].RecordDeleted != 'Y' && $(this)[0].SubjectiveText != "") {
                if (Problems != "") {
                    Problems = Problems + "," + $(this)[0].SubjectiveText;
                }
                else {
                    Problems = Problems + $(this)[0].SubjectiveText + ",";
                }
            }
        });
    }
    $('#TextArea_CustomDocumentPsychiatricNoteGenerals_PsychiatricComments').val(Problems);
    CreateAutoSaveXml("CustomDocumentPsychiatricNoteGenerals", "PsychiatricComments", Problems);
}

function enableDisableHistory(dom) {
    var initial = dom.find("CustomDocumentPsychiatricNoteGenerals:first Initial").text();
    if (initial == "Y") {
        $("[id=tableMedicalHistory]").attr("disabled", true);
        $("[id=tableFamilyHistory]").attr("disabled", true);
        $("[id=tableSocialHistory]").attr("disabled", true);
    }
    else {
        $("[id=tableMedicalHistory]").attr("disabled", false);
        $("[id=tableFamilyHistory]").attr("disabled", false);
        $("[id=tableSocialHistory]").attr("disabled", false);
    }
}
// FOR AIMS
function CalculateTotalScore(obj, TotalScoreLabelId, ControlGroup) {
    var Totalscore = 0;
    var DropdownWith2SelectedCount = 0;
    var DropdownWith3SelectedCount = 0;
    var DropdownWith4SelectedCount = 0;
    $('select[AIMS="AIMS"]').each(function () {
        Totalscore = Totalscore + parseInt(($(this).find('option:selected').text().trim() != '' ? $(this).find('option:selected').text().trim().substr(0, 1) : 0));
    });
    $('select[AIMSPN="AIMSPN"]').each(function () {
        var Value = $(this).find('option:selected').text().trim().substr(0, 1);
        if ($(this).find('option:selected').text().trim() != '' && Value == 2) {
            DropdownWith2SelectedCount = DropdownWith2SelectedCount + 1;
        }
        if ($(this).find('option:selected').text().trim() != '' && Value == 3) {
            DropdownWith3SelectedCount = DropdownWith2SelectedCount + 1;
        }
        if ($(this).find('option:selected').text().trim() != '' && Value == 4) {
            DropdownWith4SelectedCount = DropdownWith4SelectedCount + 1;
        }
    });
    var RadioP = $('[id$=RadioButton_CustomDocumentPsychiatricAIMSs_AIMSPositveNegative_P]');
    var RadioN = $('[id$=RadioButton_CustomDocumentPsychiatricAIMSs_AIMSPositveNegative_N]');
    if (DropdownWith2SelectedCount >= 2 && Totalscore > 4) {
        RadioP.attr('checked', 'checked');
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'AIMSPositveNegative', 'P');
    }
    else if (DropdownWith3SelectedCount >= 1) {
        RadioP.attr('checked', 'checked');
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'AIMSPositveNegative', 'P');
    }
    else if (DropdownWith4SelectedCount >= 1) {
        RadioP.attr('checked', 'checked');
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'AIMSPositveNegative', 'P');
    }
    else {
        RadioN.attr('checked', 'checked');
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'AIMSPositveNegative', 'N');
    }

    if ($('#RadioButton_CustomDocumentPsychiatricAIMSs_CurrentProblemsTeeth_Y[AIMS="AIMS"]').is(":checked")) {

        Totalscore = Totalscore + 1;
    }
    if ($('#RadioButton_CustomDocumentPsychiatricAIMSs_DoesPatientWearDentures_Y[AIMS="AIMS"]').is(":checked")) {

        Totalscore = Totalscore + 1;
    }

    $('[id$=' + TotalScoreLabelId + ']').text(Totalscore);
    CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'AIMSTotalScore', Totalscore);
}

function SetDefaultsOnClick(obj) {
    var objxAIMSMovements = '';
    var objxAIMSJudgments1 = '';
    var objxAIMSJudgments2 = '';
    HiddenFieldxAIMSMovements = $('[id$=HiddenFieldxAIMSMovements]').val();
    if (checkjsonstring(HiddenFieldxAIMSMovements) == true) {
        objxAIMSMovements = $.parseJSON(HiddenFieldxAIMSMovements);
        var GlobalCodeIdAIMSMovements = objxAIMSMovements[0].GlobalCodeId;
    }
    HiddenFieldxAIMSJudgments1 = $('[id$=HiddenFieldxAIMSJudgments1]').val();
    if (checkjsonstring(HiddenFieldxAIMSJudgments1) == true) {
        objxAIMSJudgments1 = $.parseJSON(HiddenFieldxAIMSJudgments1);
        var GlobalCodeIdAIMSJudgments1 = objxAIMSJudgments1[0].GlobalCodeId;
    }
    HiddenFieldxAIMSJudgments2 = $('[id$=HiddenFieldxAIMSJudgments2]').val();
    if (checkjsonstring(HiddenFieldxAIMSJudgments2) == true) {
        objxAIMSJudgments2 = $.parseJSON(HiddenFieldxAIMSJudgments2);
        var GlobalCodeIdAIMSJudgments2 = objxAIMSJudgments2[0].GlobalCodeId;
    }
    if (obj.checked == true) {
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_MuscleFacialExpression]").val(GlobalCodeIdAIMSMovements);
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_LipsPerioralArea]").val(GlobalCodeIdAIMSMovements);
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_Jaw]").val(GlobalCodeIdAIMSMovements);
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_Tongue]").val(GlobalCodeIdAIMSMovements);
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_ExtremityMovementsUpper]").val(GlobalCodeIdAIMSMovements);
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_ExtremityMovementsLower]").val(GlobalCodeIdAIMSMovements);
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_NeckShouldersHips]").val(GlobalCodeIdAIMSMovements);
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_SeverityAbnormalMovements]").val(GlobalCodeIdAIMSJudgments1);
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_IncapacitationAbnormalMovements]").val(GlobalCodeIdAIMSJudgments1);
        $("[id$=DropDownList_CustomDocumentPsychiatricAIMSs_PatientAwarenessAbnormalMovements]").val(GlobalCodeIdAIMSJudgments2);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'MuscleFacialExpression', GlobalCodeIdAIMSMovements);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'LipsPerioralArea', GlobalCodeIdAIMSMovements);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'Jaw', GlobalCodeIdAIMSMovements);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'Tongue', GlobalCodeIdAIMSMovements);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'ExtremityMovementsUpper', GlobalCodeIdAIMSMovements);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'ExtremityMovementsLower', GlobalCodeIdAIMSMovements);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'NeckShouldersHips', GlobalCodeIdAIMSMovements);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'SeverityAbnormalMovements', GlobalCodeIdAIMSJudgments1);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'IncapacitationAbnormalMovements', GlobalCodeIdAIMSJudgments1);
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'PatientAwarenessAbnormalMovements', GlobalCodeIdAIMSJudgments2);
        $('#Span_CustomDocumentPsychiatricAIMSs_AIMSTotalScore').text('0');
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'AIMSTotalScore', '0');
        var RadioTeethN = $('[id$=RadioButton_CustomDocumentPsychiatricAIMSs_CurrentProblemsTeeth_N]');
        RadioTeethN.attr('checked', 'checked');
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'CurrentProblemsTeeth', 'N');
        var RadioDenturesN = $('[id$=RadioButton_CustomDocumentPsychiatricAIMSs_DoesPatientWearDentures_N]');
        RadioDenturesN.attr('checked', 'checked');
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'DoesPatientWearDentures', 'N');
        var RadioN = $('[id$=RadioButton_CustomDocumentPsychiatricAIMSs_AIMSPositveNegative_N]');
        RadioN.attr('checked', 'checked');
        CreateAutoSaveXml('CustomDocumentPsychiatricAIMSs', 'AIMSPositveNegative', 'N');
    }

}

function SetMiscControl() {
    try {
        GetProviderDetails();
        ProviderId = $('[id$=HiddenfieldProviderId]').val();
        ModifyProvider(ProviderId);
        $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').removeAttr('disabled');


    }
    catch (err) {
        LogClientSideException(err, 'SetMiscControl');
    }
}

function LoadProvidersByType(sender) {
    if ($('select[id$=DropDownList_ExternalReferralProviders_Type]').val()) {
        $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').removeAttr('disabled');
    }
    else {
        $('select[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').val("");
        $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').attr('disabled', 'disabled');
    }
    if ($(sender).val()) {
        var ProviderType = $(sender).val();
    }
    else {
        var ProviderType = $('select[id$=DropDownList_ExternalReferralProviders_Type]').val();
    }
    if (ProviderType != '') {
        $.post(GetRelativePath() + "Custom/PsychiatricNote/WebPages/PsychiatricNoteAjax.aspx?functionName=GetProviderName&Type=" + ProviderType, null, BindProviderDropdownForType);
    }

    else { $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').attr('disabled', 'disabled'); }
}

function BindProviderDropdownForType(result) {
    try {
        var pageResponse = result;
        var start = pageResponse.indexOf("##STARTPAGERESPONSEVALUE##") + 26;
        var end = pageResponse.indexOf("##ENDPAGERESPONSEVALUE##");
        pageResponse = pageResponse.substr(start, end - start);
        if (pageResponse != undefined) {
            $("[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]").html(pageResponse);
            //HidePopupProcessing();
        }
    } catch (err) {
        LogClientSideException(err, 'BindProviderDropdownForType');
    }
}

function GetProviderDetails() {
    try {
        var ProviderId = 0;
        ProviderId = $('select[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').val();
        $("[Id$=HiddenfieldProviderId]").val(ProviderId);
        if (ProviderId == -1) {
            var selectedValueProviderType = 8126;
            OpenPage(5761, 700, 'action=' + selectedValueProviderType, 2, $("input[id$=RelativePath]").val(), 'T', 'dialogHeight: 300px; dialogWidth: 600px; dialogCrossButton: hide;dialogTitle:Add New Provider', pageActionEnum.New);

            if ($(obj).val() == "-1") {
                OpenPage(5761, 700, 'action=' + selectedValueProviderType, 2, $("input[id$=RelativePath]").val(), 'T', 'dialogHeight: 300px; dialogWidth: 600px; dialogCrossButton: hide;dialogTitle:Add New Provider', pageActionEnum.New);
                $(obj).val('');
            }
        } else {

            $.ajax({
                type: "POST",
                async: false,
                url: "../Custom/PsychiatricNote/WebPages/PsychiatricNoteAjax.aspx?functionName=GetProviderDetail&ExternalProviderId=" + ProviderId,
                data: '',
                success: function (result) {
                    if (result != null) {
                        var Split = [];
                        Split = result.split('^');
                        if (Split[0] != null && Split[0] != undefined && Split[0] != '') {
                            $("[id$=TextBox_ExternalReferralProviders_OrganizationName]").val(Split[0]);
                        }
                        if (Split[1] != null && Split[1] != undefined && Split[1] != '') {
                            $("[id$=TextBox_ExternalReferralProviders_PhoneNumber]").val(Split[1]);
                        }
                        if (Split[2] != null && Split[2] != undefined && Split[2] != '') {
                            $("[id$=TextBox_ExternalReferralProviders_Email]").val(Split[2]);
                        }
                    }
                }
            });
        }
    } catch (err) {
        LogClientSideException(err, 'Nursing Assessment-GetProviderDetail');
    }

}


function UpdateProviderDetails(result) {
    var ExternalReferralProvider = JSON.parse(result);
    $('span[id$=Span_CustomDocumentRegistrations_Phone]').html(ExternalReferralProvider.PhoneNumber); //.PhoneLog);
    $('span[id$=Span_CustomDocumentRegistrations_PCPEmail]').html(ExternalReferralProvider.Email); //EmailLog);
    $('span[id$=Span_CustomDocumentRegistrations_OrganizationName]').html(ExternalReferralProvider.OrganizationName);

}

function AddNewProvider(obj) {
    var selectedValueProviderType = 8126;
    OpenPage(5761, 700, 'action=' + selectedValueProviderType, 2, $("input[id$=RelativePath]").val(), 'T', 'dialogHeight: 270px; dialogWidth: 600px; dialogCrossButton: hide;dialogTitle:Add New Provider', pageActionEnum.New);

    if ($(obj).val() == "-1") {
        OpenPage(5761, 700, 'action=' + selectedValueProviderType, 2, $("input[id$=RelativePath]").val(), 'T', 'dialogHeight: 270px; dialogWidth: 600px; dialogCrossButton: hide;dialogTitle:Add New Provider', pageActionEnum.New);
        $(obj).val('');
    }
}

function ModifyProvider(obj) {
    var SelectedProvider = 0;
    if ($(obj).attr('id') == "span_modiyProviderReferral") {
        SelectedProvider = $('select[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').val();
    } else {
        SelectedProvider = $('select[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').val();
    }
    if (SelectedProvider > 0) {
        OpenPage(5761, 700, 'ExternalReferralProviderId=' + SelectedProvider, 2, $("input[id$=RelativePath]").val(), 'T', 'dialogHeight: 300px; dialogWidth: 600px; dialogCrossButton: hide;dialogTitle:Add New Provider', '');

    }
}

function ValidateDataForParentChildGridEventHandler() {
    try {
        if (TabIndex == 0) {
            var _ProviderType = $("[id$=DropDownList_ExternalReferralProviders_Type]").val();
            var _ProviderName = $("[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]").val();
            if (_ProviderType == -1 || _ProviderType == "") {
                ShowHideErrorMessage("Please select Provider Type.", 'true');
                $("[id$=DropDownList_ExternalReferralProviders_Type]").focus();
                return false;

            }

            if (_ProviderName == -1 || _ProviderName == "") {
                ShowHideErrorMessage("Please select Provider Name.", 'true');
                $("[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]").focus();
                return false;

            }

            var _ProviderTypeText = $('select[id$=DropDownList_ExternalReferralProviders_Type] option:selected').text()
            var _ProviderNameText = $('select[id$=DropDownList_ExternalReferralProviders_ExternalProviderId] option:selected').text()

            if (IsOverlappingCheckProviderDetails(_ProviderTypeText, _ProviderNameText)) {
                ShowHideErrorMessage('Duplicate Entry not allowed', 'true');
                return false;
            }
            else
                return true;
        }
        else
            return true;
    } catch (err) {
        LogClientSideException(err, 'ValidateDataForParentChildGridEventHandler');
    }
}

function IsOverlappingCheckProviderDetails(ProviderType, ProviderName) {
    try {
        var isOverlapping = false;
        var count = 0;
        $('table[id$=CustomGridExternalReferralProviders_GridViewInsert_DXMainTable] tr[id*=CustomGridExternalReferralProviders_GridViewInsert_DXDataRow]').each(function () {
            if ($('input[type=radio]:checked', $(this)).length == 0) {

                var previousProviderType = $('td:eq(2)', $(this)).text();
                var previousProviderName = $('td:eq(4)', $(this)).text();
                if (ProviderType == previousProviderType && ProviderName == previousProviderName) {
                    count = count + 1;
                }
                if (parseInt(count) > 0) {
                    isOverlapping = true;
                }
            }
            return isOverlapping;
        });
        return isOverlapping;
    }
    catch (err) {
        LogClientSideException(err, 'IsOverlappingCheckProviderDetails');
    }
}

function ProviderPopupCallback(objectPageResponse) {
    var ProviderId = 0;
    var _ProviderTypeText = $('select[id$=DropDownList_ExternalReferralProviders_Type] option:selected').text()
    var _ProviderNameText = $('select[id$=DropDownList_ExternalReferralProviders_ExternalProviderId] option:selected').text()
    ProviderId = $('select[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').val();
    $.post(GetRelativePath() + "Custom/PsychiatricNote/WebPages/PsychiatricNoteAjax.aspx?functionName=RefreshProvideDetail&ExternalReferralProviderId=" + ProviderId, null);
    RefreshParentChildGrid('ExternalReferralProviderId', 'InsertGridExternalReferralProviders', 'CustomGrid', 'ExternalReferralProviders', 'TableChildControl_ExternalReferralProviders', "", "CustomGridExternalReferralProviders", false);
    IsOverlappingCheckforProviderDetails(_ProviderTypeText, _ProviderNameText);
}

function IsOverlappingCheckforProviderDetails(ProviderType, ProviderName) {
    try {

        var isOverlapping = false;
        var count = 0;
        $('table[id$=CustomGridExternalReferralProviders_GridViewInsert_DXMainTable] tr[id*=CustomGridExternalReferralProviders_GridViewInsert_DXDataRow]').each(function () {
            if ($('input[type=radio]:checked', $(this)).length == 0) {
                $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').val('');
                $('[id$=DropDownList_ExternalReferralProviders_Type]').val('');
                $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').attr('disabled', 'disabled');
                $("[id$=TableChildControl_ExternalReferralProviders_ButtonInsert]").val("Insert");
                $("[id$=GridViewInsert] input[type=radio]:checked").removeAttr("checked");
            }
            $("[id$=GridViewInsert] input[type=radio]:checked").removeAttr("checked");
            return isOverlapping;
        });
        return isOverlapping;
    }
    catch (err) {
        LogClientSideException(err, 'IsOverlappingCheckforProviderDetails');
    }
}

function PopUpCloseCallBackComplete() {
    var _ProviderTypeText = $('select[id$=DropDownList_ExternalReferralProviders_Type] option:selected').text()
    var _ProviderNameText = $('select[id$=DropDownList_ExternalReferralProviders_ExternalProviderId] option:selected').text()
    IsOverlappingCheckforProviderDetails(_ProviderTypeText, _ProviderNameText);
    $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').val('');
    $('[id$=DropDownList_ExternalReferralProviders_Type]').val('');
    $('[id$=DropDownList_ExternalReferralProviders_ExternalProviderId]').attr('disabled', 'disabled');
    $("[id$=TableChildControl_ExternalReferralProviders_ButtonInsert]").val("Insert");

}

function NursemoniterOther() {
    if (tabobject.get_selectedTab().get_text() == "General") {
        //try {
        //    //OpenPage(5763, 60000, 'CustomAjaxRequestType=GetRecodeData', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
        //    $.ajax({
        //        type: "POST",
        //        url: "../Custom/PsychiatricNote/WebPages/PsychiatricNoteAjax.aspx?functionName=GetRecodeData",
        //        asyn: false,
        //        success: function (result) {
        //            debugger;
        //            if (result == "0") {
        //                //TextArea_CustomDocumentPsychiatricNoteGenerals_PersonPresent
        //                //TextArea_CustomDocumentPsychiatricNoteGenerals_PresentingProblem
        //                $('[id$=TextArea_CustomDocumentPsychiatricNoteGenerals_PresentingProblem]').removeAttr('disabled');
        //            }
        //            else {
        //                $('[id$=TextArea_CustomDocumentPsychiatricNoteGenerals_PresentingProblem]').attr('disabled', 'disabled');
        //            }

        //        }
        //    });
        //} catch (ex) { }

        if ($('#RadioButton_CustomDocumentPsychiatricNoteGenerals_SideEffects_S').attr('checked')) {
            $('[id$=TextBox_CustomDocumentPsychiatricNoteGenerals_SideEffectsComments]').show();
        }
        else {
            $('[id$=TextBox_CustomDocumentPsychiatricNoteGenerals_SideEffectsComments]').hide();
        }




        
        //try {
        //    //OpenPage(5763, 60000, 'CustomAjaxRequestType=GetRecodeData', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
        //    $.ajax({
        //        type: "POST",
        //        url: "../Custom/PsychiatricNote/WebPages/PsychiatricNoteAjax.aspx?functionName=PregnentRule",
        //        asyn: false,
        //        success: function (result) {
        //            if (result == "A") {
        //                //TextArea_CustomDocumentPsychiatricNoteGenerals_PersonPresent
        //                //TextArea_CustomDocumentPsychiatricNoteGenerals_PresentingProblem
        //                $('#RadioButton_CustomDocumentPsychiatricNoteGenerals_Pregnant_A').attr('checked',true)
        //            }
                 

        //        }
        //    });
        //} catch (ex) { }

    }

    if (tabobject.get_selectedTab().get_text() == "Medical Decision Making") {
        var _FrequencyOtherText = $('select[id$=DropDownList_CustomDocumentPsychiatricNoteMDMs_NurseMonitorFrequency] option:selected').text();

        if (_FrequencyOtherText == "other") {
            $('[id$=TextBox_CustomDocumentPsychiatricNoteMDMs_NurseMonitorFrequencyOther]').show();
        }
        else {
            $('[id$=TextBox_CustomDocumentPsychiatricNoteMDMs_NurseMonitorFrequencyOther]').hide();
        }


        if ($('#RadioButton_CustomDocumentPsychiatricNoteMDMs_RisksBenefits_N').attr('checked')) {
            $('[id$=TextBox_CustomDocumentPsychiatricNoteMDMs_RisksBenefitscomment]').show();
        }
        else {
            $('[id$=TextBox_CustomDocumentPsychiatricNoteMDMs_RisksBenefitscomment]').hide();
        }
    }

}

function ShowCommentBoxTextArea(checkbox, textbox, table, column) {
    if ($('[id$=' + checkbox + ']').attr("checked")) {
        $('[id$=' + textbox + ']').show();
    }
    else {
        $('[id$=' + textbox + ']').hide();
    }
}

function ShowCommentBox(checkbox, textbox, table, column) {
    if ($('[id$=' + checkbox + ']').attr("checked")) {
        $('[id$=' + textbox + ']').show();
    }
    else {
        $('[id$=' + textbox + ']').hide();
        $('[id$=' + textbox + ']').val('');
        CreateAutoSaveXml(table, column, "");

    }
}



//Vitals Flow SheetStart
function CustomAjaxRequestCallback(result, CustomAjaxRequest) {
   // debugger;

    var startIndexBindVitals = result.indexOf("###StartBindVitals###") + 21;
    var endIndexBindVitals = result.indexOf("###EndBindVitals###");
    var resultBindFlowSheetVitals = result.substr(startIndexBindVitals, endIndexBindVitals - startIndexBindVitals);

   
    if (resultBindFlowSheetVitals.length > 0) {

        $("#div_FlowSheetVitals").html(resultBindFlowSheetVitals);
        SetWidth();
    }

}
function SetWidth() {
  //  debugger;
    if ($("#div_DynamicFlowSheet").height() >= 409)    // If vertical scroll would be required then width added 16px for scroll bar and fixed height 275px
    {
        $("#div_DynamicFlowSheetHeader").css({ 'width': 800 });
        $("#div_DynamicFlowSheet").css({ 'height': '310' });
        $("#div_DynamicFlowSheet").css({ 'width': 800 });
    }
    else {
        $("#div_DynamicFlowSheetHeader").css({ 'width': 800 });
        $("#div_DynamicFlowSheet").css({ 'height': '310' });
        $("#div_DynamicFlowSheet").css({ 'width': 800 });
    }
}
//End







function GetTemplatesList() {
    //debugger;
    //var RecodeCategory = 'XPSYCHIATRICNOTEVITAL';
    try {
        currenttemplatename = 'GetVitals';
        currenttemplateId = 110;
        OpenPage(5763, 60000, 'templateId=' + currenttemplateId + '^pageAction=' + currenttemplatename, null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
    }
    catch (err) {
        LogClientSideException(err, 'DetoxIntake- GetTemplatesList');
    }
}


function ShowSelectedAttributeDetails(obj) {
    $("#div_Attribute_Detail").show();
    $(obj).css('border-color', 'blue');
    $("#div_Attribute_Detail").css({ 'width': '850px' });
    //$("#div_Attribute_Detail").html(obj.SelectedAttributeDetails);
    $("#div_Attribute_Detail").html(obj.getAttribute('selectedattributedetails'));
}

function HideSelectedAttributeDetails(obj) {
    $(obj).css('border-color', 'black');
    //$("#div_Attribute_Detail").hide();
}

//Vitals Flow SheetEnd

function SetTabUcPath() {
    if (selectedTabText == 'Diagnosis') {
        return Path = "/ICD10Diagnosis/Documents/ICDTenDiagnosis.ascx";
    }
}

