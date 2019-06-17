
//Author : Jitender Kumar Kamboj
//Purpose : This function is used to close Popup
//Date : 04 May,2010
function ProcessServiceLookupPopUp(ServiceLookupDetail) {
    parent.CloaseModalPopupWindow()
    if (ServiceLookupDetail != "")
        parent.SplitServiceLookupDetail(ServiceLookupDetail);
}


//Author : Jitender Kumar Kamboj
//Purpose : This function is used to get CodeName to Risk Assessment page
//Date:     06 May,2010
function GetOtherRiskFactorsLookupDetail(gridView) {
    var OtherRiskFactorsLookupDetail = "";
    var RiskFactor = $(window.frames["iframeWindowDialog"].document);
    var grid =RiskFactor.find("#" + gridView);
    $("input[type='checkbox']", grid).each(function() {
    if ($(this).attr("checked") == true) {
        OtherRiskFactorsLookupDetail += $(this).parent().find("input[type='hidden']:first").val() + ":";
        OtherRiskFactorsLookupDetail += $(this).parent().find("input[type='hidden']:last").val() + "||";
  
        }
    });
    OtherRiskFactorsLookupDetail = OtherRiskFactorsLookupDetail.substring(0, OtherRiskFactorsLookupDetail.length - 2);
    ProcessOtherRiskFactorsLookupPopUp(OtherRiskFactorsLookupDetail);
}

//Author : Jitender Kumar Kamboj
//Purpose : This function is used to close Popup
//Date : 06 May,2010
function ProcessOtherRiskFactorsLookupPopUp(OtherRiskFactorsLookupDetail) {
    parent.CloaseModalPopupWindow()
    if (OtherRiskFactorsLookupDetail != "")
        parent.SplitOtherRiskFactorsLookupDetail(OtherRiskFactorsLookupDetail);
}