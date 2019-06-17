using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using SHS.BaseLayer;

namespace SHS.SmartCare
{

    public partial class ActivityPages_Harbor_Client_Detail_Documents_CustomIntegratedCarePlan :
        SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
    {
        protected string IntegratedCarePlanResponseType = "";
        protected string IntegratedCarePlanDeleteResponse = "false";
        protected string IntegratedCarePlanMessage = "Message not set";
        protected string IntegratedCarePlanOutcomeSequence = "";
        protected string IntegratedCarePlanCreatedBy = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            PanelMain.Visible = true;
            PanelDeleteResponse.Visible = false;
            PanelAjaxResponse.Visible = false;
        }

        public override void BindControls()
        {
            IntegratedCarePlanCreatedBy = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
            // Bind Screen Id to each Custom Grid
            CustomGrid_CustomDocumentHealthHomeCarePlanBHGoals.Bind(ParentDetailPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomeCarePlanOutcomes.Bind(ParentDetailPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomeCarePlanDiagnoses.Bind(ParentDetailPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomeCarePlanLongTermCareOutcomes.Bind(ParentDetailPageObject.ScreenId);
            CustomGrid_CustomDocumentHealthHomeCarePlanPESNeeds.Bind(ParentDetailPageObject.ScreenId);
            // Bind Dropdowns
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XICPNEEDS", true, "", "", false))
            {
                DataViewGlobalCodes.Sort = "SortOrder asc";
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.DataBind();
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.Items.Insert(0, new ListItem("", "0"));
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XICPLTTYPES", true, "", "", false))
            {
                DataViewGlobalCodes.Sort = "SortOrder asc";
                DropDownList_CustomDocumentHealthHomeCarePlans_AdmitToFacilityType.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCarePlans_AdmitToFacilityType.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentHealthHomeCarePlans_AdmitToFacilityType.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCarePlans_AdmitToFacilityType.DataBind();
                DropDownList_CustomDocumentHealthHomeCarePlans_AdmitToFacilityType.Items.Insert(0, new ListItem("", "0"));
            }

            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XDIAGNOSISSOURCE", true, "", "", false))
            {
                DataViewGlobalCodes.Sort = "SortOrder asc";
                DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataBind();
                DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.Items.Insert(0, new ListItem("", "0"));
            }

        }


        public override string PageDataSetName
        {
            get { return "DataSetCustomIntegratedCarePlan"; }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                return new string[]
                    {
                        "CustomDocumentHealthHomeCarePlans", 
                        "CustomDocumentHealthHomeCarePlanOutcomes",
                        "CustomDocumentHealthHomeCarePlanBHGoals",
                        "CustomDocumentHealthHomeCarePlanPESNeeds",
                        "CustomDocumentHealthHomeCarePlanDiagnoses",
                        "CustomDocumentHealthHomeCarePlanLongTermCareOutcomes"
                    };
            }
        }

        public override void CustomAjaxRequest()
        {
            PanelMain.Visible = false;
            PanelAjaxResponse.Visible = true;
            IntegratedCarePlanOutcomeSequence = "0";
            switch (GetRequestParameterValue("customajaxrequesttype"))
            {
                case "deleteresponse":
                    switch (GetRequestParameterValue("tableName").ToLower())
                    {
                        case "customdocumenthealthhomecareplanbhgoals":
                            PanelDeleteResponse.Visible = true;
                            IntegratedCarePlanResponseType = "ICPDeleteCustomDocumentHealthHomeCarePlanBHGoals";
                            IntegratedCarePlanDeleteResponse = "true";
                            IntegratedCarePlanMessage = "";
                            if (
                                BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[
                                    "CustomDocumentHealthHomeCarePlanBHGoals"] != null)
                            {
                                string primarykey = GetRequestParameterValue("primarykey");
                                if (!primarykey.IsNullOrEmpty())
                                {
                                    string selectFilter = primarykey + "=" +
                                                          GetRequestParameterValue("primarykeyvalue").Trim() +
                                                          " and SourceDocumentVersionId is not null";
                                    DataRow[] dr =
                                        BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[
                                            "CustomDocumentHealthHomeCarePlanBHGoals"].Select(selectFilter);
                                    if (dr.Count() > 0)
                                    {
                                        IntegratedCarePlanDeleteResponse = "false";
                                        IntegratedCarePlanMessage = "Behavioral Health Care record can not be deleted";
                                    }
                                }
                            }
                            break;
                    }
                    break;
                case "outcomesequenceresponse":
                    PanelOutcomeSequence.Visible = true;
                    IntegratedCarePlanOutcomeSequence = "0";
                    if (GetRequestParameterValue("tableName").ToLower().Equals("customdocumenthealthhomecareplanlongtermcareoutcomes"))
                    {
                        IntegratedCarePlanOutcomeSequence = (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[
                                "CustomDocumentHealthHomeCarePlanLongTermCareOutcomes"].Rows.Count + 1).ToString();
                    }
                    else if (GetRequestParameterValue("tableName").ToLower().Equals("customdocumenthealthhomecareplanoutcomes"))
                    {
                        IntegratedCarePlanOutcomeSequence = (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[
                                "CustomDocumentHealthHomeCarePlanOutcomes"].Rows.Count + 1).ToString();
                    }
                    break;
                case "psychosocialsupportneedsequence":
                    PanelOutcomeSequence.Visible = true;
                    IntegratedCarePlanOutcomeSequence = (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[
                                "CustomDocumentHealthHomeCarePlanPESNeeds"].Rows.Count + 1).ToString();
                    break;
                case "plandiagnosessequencenumber":
                    PanelOutcomeSequence.Visible = true;
                    IntegratedCarePlanOutcomeSequence = (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[
                                "CustomDocumentHealthHomeCarePlanDiagnoses"].Rows.Count + 1).ToString();
                    break;
                case "bhgoalsgoalnumber":
                    PanelOutcomeSequence.Visible = true;
                    IntegratedCarePlanOutcomeSequence = (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables[
                                "CustomDocumentHealthHomeCarePlanBHGoals"].Rows.Count + 1).ToString();
                    break;
            }

        }

    }
}