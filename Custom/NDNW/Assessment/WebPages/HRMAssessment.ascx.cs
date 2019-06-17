using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;
using SHS.DataServices;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;

namespace SHS.SmartCare
{


    public partial class ActivityPages_Client_Detail_Assessment_HRMAssessment : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {
        DataSet datasetCustomHrmActivities = new DataSet();
        SqlParameter[] _objectSqlParmeters = null;
        DataSet datasetUpdateText = new DataSet();
        private string xml;

        public override string DefaultTab
        {
            get { return "/Custom/Assessment/WebPages/HRMInitial.ascx"; }
        }

        public override string MultiTabControlName
        {
            get { return "RadMultiPage1"; }
        }



        public override System.Collections.Generic.List<CustomParameters> customInitializationStoreProcedureParameters
        {
            get
            {

                System.Collections.Generic.List<CustomParameters> t = new List<CustomParameters>();
                string _assessmentType = GetRequestParameterValue("AssessmentScreenType");
                string _currentAuthorId = GetRequestParameterValue("CurrentAuthorId");
                string _SafetyInitialorReview = GetRequestParameterValue("SafetyInitialorReview");
                string _CrisisInitialorReview = GetRequestParameterValue("CrisisInitialorReview");
                t.Add(new CustomParameters("ScreenType", _assessmentType));
                t.Add(new CustomParameters("CurrentAuthorId", _currentAuthorId));
                t.Add(new CustomParameters("SafetyInitialorReview", _SafetyInitialorReview));
                t.Add(new CustomParameters("CrisisInitialorReview", _CrisisInitialorReview));
                return t;

            }
        }


        public override string PageDataSetName
        {
            //get { return "DataSetHRMAssesment"; }
            get { return "DataSetAssessment"; }

        }

        public override string[] TablesToBeInitialized
        {

            get { return new string[] { "CustomHRMAssessments,CustomSubstanceUseAssessments,CustomSubstanceUseHistory2,CustomHRMAssessmentLevelOfCareOptions,CustomOtherRiskFactors,CustomHRMAssessmentSupports2,CustomMentalStatuses2,CustomDocumentCRAFFTs,CustomDispositions,CustomASAMPlacements,CustomDocumentAssessmentSubstanceUses,DocumentFamilyHistory,CustomDocumentDLA20s,CustomDailyLivingActivityScores,CustomYouthDLAScores,CarePlanDomains,CarePlanDomainNeeds,CarePlanNeeds,CustomDocumentGambling,DocumentDiagnosis,DocumentDiagnosisFactors" }; }
        }

        //Added by Loveena to calculate Level Of Intensity
        public override void AfterUpdateProcess(ref DataSet dataSetObject)
        {
            if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["DocumentVersions"].Rows.Count > 0)
            {
                int documentVersionId = Convert.ToInt32(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"]);
                // CalculateAssessmentPostUpdate(documentVersionId, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode);
            }
        }
        public override void ChangeDataSetAfterGetData()
        {
            DataSet dataSetClients = new DataSet();
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.Text, "select TOP 1 DOB from Clients where ClientId=" + BaseCommonFunctions.ApplicationInfo.Client.ClientId, dataSetClients, new string[] { "Clients" });
            if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables.Contains("CustomDocumentSafetyCrisisPlans") && dataSetClients.Tables["Clients"].Rows.Count > 0)
            {
                if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentSafetyCrisisPlans"].Rows.Count > 0)
                {
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentSafetyCrisisPlans"].Rows[0]["DOB"] = dataSetClients.Tables["Clients"].Rows[0]["DOB"];
                }
            }
        }
        private void CalculateAssessmentPostUpdate(int documentVersionId, string userCode)
        {
            _objectSqlParmeters = new SqlParameter[2];
            _objectSqlParmeters[0] = new SqlParameter("@DocumentVersionId", documentVersionId);
            _objectSqlParmeters[1] = new SqlParameter("@UserCode", userCode);
            SqlHelper.ExecuteNonQuery(Connection.ConnectionString, "csp_AssessmentHRMPostUpdate", _objectSqlParmeters);
        }
        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {

            ctlcollection = this.RadMultiPage1.Controls[TabIndex].Controls;
            RadTabStrip1.SelectedIndex = (short)TabIndex;
            RadMultiPage1.SelectedIndex = (short)TabIndex;
            UcPath = RadTabStrip1.Tabs[TabIndex].Attributes["Path"];

        }

        public override void BindControls()
        {
            int clientAge = 0;
            DataSet dataSetObject = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            if (dataSetObject.Tables.Contains("CustomHRMAssessments"))
            {
                if (dataSetObject.Tables["CustomHRMAssessments"].Rows[0]["ClientAge"] != null)
                {
                    string age = Convert.ToString(dataSetObject.Tables["CustomHRMAssessments"].Rows[0]["ClientAge"]);
                    string[] ageArr = age.Split(new string[] { "Years" }, StringSplitOptions.None);
                    if (ageArr.Length == 1)
                    {
                        clientAge = 0;
                    }
                    else
                    {
                        clientAge = Convert.ToInt32(ageArr[0].Trim());
                    }
                    HiddenClientAge.Value = clientAge.ToString();
                }
                if (clientAge >= 18)
                {
                    //RadTabStrip1.Tabs[17].Visible = true;
                    //RadTabStrip1.Tabs[18].Visible = false;
                    #region DLA
                    DataSet dataSetCustoHRMctivities = null;
                    try
                    {
                        dataSetCustoHRMctivities = new DataSet();
                        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetCustomHRMActivities", dataSetCustoHRMctivities, new string[] { "CustomHRMActivities" });

                    }
                    finally
                    {
                        if (dataSetCustoHRMctivities != null)
                        {
                            dataSetCustoHRMctivities.Dispose();
                        }
                    }
                    string xml1 = dataSetCustoHRMctivities.GetXml();
                    HiddenCustomHRMActivitiesDataTable.Value = xml1;
                    #endregion
                }
                else
                {
                    //RadTabStrip1.Tabs[17].Visible = false;
                    //RadTabStrip1.Tabs[18].Visible = true;
                    #region DLA Youth
                    DataSet dataSetCustoHRMctivitiesYouth = null;
                    try
                    {
                        dataSetCustoHRMctivitiesYouth = new DataSet();
                        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetCustomDLAActivitiesYouth", dataSetCustoHRMctivitiesYouth, new string[] { "CustomDailyLivingActivities" });

                    }
                    finally
                    {
                        if (dataSetCustoHRMctivitiesYouth != null)
                        {
                            dataSetCustoHRMctivitiesYouth.Dispose();
                        }
                    }
                    string xmly = dataSetCustoHRMctivitiesYouth.GetXml();
                    HiddenCustomHRMActivitiesDataTableYouth.Value = xmly;
                    #endregion
                }
            }

            DataSet cds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            DataTable dt = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Tables["CustomHRMNeeds"].Copy();
            DataSet ds = new DataSet();
            ds.Tables.Add(dt);
            ParentDetailPageObject.SetParentScreenProperties("CustomHRMNeeds", ds.GetXml());

            if (GetRequestParameterValue("AssessmentScreenType") != null && GetRequestParameterValue("AssessmentScreenType").ToString().Trim() != "")
                ParentDetailPageObject.SetParentScreenProperties("AssessmentType", GetRequestParameterValue("AssessmentScreenType"));

            if (ParentDetailPageObject.PageAction == BaseCommonFunctions.PageActions.None || ParentDetailPageObject.PageAction == BaseCommonFunctions.PageActions.Update)
                ParentDetailPageObject.SetParentScreenProperties("DeleteCustomHrmNeeds", "False");
            HiddenCustomHRMNeedsDataTable.Value = ds.GetXml();

            //DataSet dataSetCustomHRMActivities = null;
            //try
            //{
            //    dataSetCustomHRMActivities = new DataSet();
            //    SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetCustomHRMActivities", datasetCustomHrmActivities, new string[] { "CustomHRMActivities" });
            //    //datasetCustomHrmActivities = dataSetCustomHRMActivities;
            //}
            //finally
            //{
            //    if (dataSetCustomHRMActivities != null)
            //    {
            //        dataSetCustomHRMActivities.Dispose();
            //    }
            //}

            //xml = datasetCustomHrmActivities.GetXml();
            //HiddenCustomHRMActivitiesDataTable.Value = xml;
            DataSet dataSetHrmAssesment = null;
            try
            {
                dataSetHrmAssesment = new DataSet();
                SqlHelper.FillDataset(Connection.ConnectionString, CommandType.Text, "select DOB from Clients where ClientId=" + BaseCommonFunctions.ApplicationInfo.Client.ClientId, dataSetHrmAssesment, new string[] { "Clients" }, _objectSqlParmeters);

            }
            finally
            {
                if (dataSetHrmAssesment != null)
                {
                    dataSetHrmAssesment.Dispose();
                }
            }
            using (DataSet dataSetClient = dataSetHrmAssesment)
            {
                BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomHRMAssessments"].Rows[0]["ClientDOB"] = dataSetClient.Tables["Clients"].Rows[0]["DOB"];
            }

            GetAgencyName();

        }

        public override void ChangeInitializedDataSet(ref DataSet dataSetObject)
        {
            if (dataSetObject.Tables["CustomHRMAssessments"].Rows.Count > 0)
            {

                string _assessmentType = string.Empty;
                _assessmentType = dataSetObject.Tables["CustomHRMAssessments"].Rows[0]["AssessmentType"].ToString();
                if (_assessmentType != "A")
                    dataSetObject.Tables["DocumentInitializationLog"].Clear();

                dataSetObject.Tables["CustomHRMAssessments"].Rows[0]["ClientName"] = BaseCommonFunctions.ApplicationInfo.Client.ClientName;
                //Code added by Loveena in ref to Taks#296 5.10 - HRM Assessment: Initial Tab: Adult/Child Radio buttons
                if (dataSetObject.Tables["CustomHRMAssessments"].Rows[0]["ClientDOB"] != DBNull.Value)
                {
                    string ClientDOB = Convert.ToDateTime(dataSetObject.Tables["CustomHRMAssessments"].Rows[0]["ClientDOB"]).ToString("MM/dd/yyyy");
                    dataSetObject.Tables["CustomHRMAssessments"].Rows[0]["ClientDOB"] = ClientDOB;
                }
            }

        }
        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            int ReviewSafetyPlanXDays = 0;
            int ReviewCrisisPlanXDays = 0;
            if (dataSetObject.Tables.Contains("CustomSafetyCrisisPlanReviews"))
            {
                if (dataSetObject.Tables["CustomSafetyCrisisPlanReviews"].Rows.Count > 0)
                {
                    if (dataSetObject.Tables["CustomSafetyCrisisPlanReviews"].Columns.Contains("CrisisResolvedText"))
                    {
                        dataSetObject.Tables["CustomSafetyCrisisPlanReviews"].Columns.Remove("CrisisResolvedText");
                    }
                    if (dataSetObject.Tables["CustomSafetyCrisisPlanReviews"].Rows[0]["ReviewEveryXDays"].ToString() != "")
                    {
                        ReviewSafetyPlanXDays = Convert.ToInt32(dataSetObject.Tables["CustomSafetyCrisisPlanReviews"].Rows[0]["ReviewEveryXDays"].ToString());
                        dataSetObject.Tables["CustomSafetyCrisisPlanReviews"].Rows[0]["NextSafetyPlanReviewDate"] = Convert.ToDateTime(Convert.ToDateTime(dataSetObject.Tables["Documents"].Rows[0]["EffectiveDate"]).AddDays(ReviewSafetyPlanXDays).ToShortDateString());

                    }

                }
                if (dataSetObject.Tables["CustomDocumentSafetyCrisisPlans"].Rows.Count > 0)
                {
                    if (dataSetObject.Tables["CustomDocumentSafetyCrisisPlans"].Rows[0]["ReviewCrisisPlanXDays"].ToString() != "")
                    {
                        ReviewCrisisPlanXDays = Convert.ToInt32(dataSetObject.Tables["CustomDocumentSafetyCrisisPlans"].Rows[0]["ReviewCrisisPlanXDays"].ToString());
                        dataSetObject.Tables["CustomDocumentSafetyCrisisPlans"].Rows[0]["NextCrisisPlanReviewDate"] = Convert.ToDateTime(Convert.ToDateTime(dataSetObject.Tables["Documents"].Rows[0]["EffectiveDate"]).AddDays(ReviewCrisisPlanXDays).ToShortDateString());

                    }

                }

                if (dataSetObject.Tables["CustomDocumentSafetyCrisisPlans"].Rows.Count > 0)
                {
                    if (dataSetObject.Tables["CustomDocumentSafetyCrisisPlans"].Rows[0]["InitialSafetyPlan"].ToString() == "Y")
                    {
                        if (dataSetObject.Tables["CustomSafetyCrisisPlanReviews"].Rows.Count > 0)
                        {
                            dataSetObject.Tables["CustomSafetyCrisisPlanReviews"].Rows[0]["NextSafetyPlanReviewDate"] = "";
                        }
                    }

                }

            }
            if (dataSetObject.Tables["CustomHRMAssessmentSupports2"].Rows.Count > 0)
            {
                foreach (DataRow dr in dataSetObject.Tables["CustomHRMAssessmentSupports2"].Rows)
                {
                    if (Convert.ToInt32(dr["HRMAssessmentSupportId"]) > 0)
                    {
                        //dr["ModifiedDate"] = DateTime.Now;
                        //dr["ModifiedBy"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                    }
                    else
                    {
                        BaseCommonFunctions.InitRowCredentials(dr);
                    }
                }
            }
            //if (dataSetObject.Tables["CustomDailyLivingActivityScores"].Rows.Count > 0)
            //{
            //    foreach (DataRow dr in dataSetObject.Tables["CustomDailyLivingActivityScores"].Rows)
            //    {
            //        if (Convert.ToInt32(dr["DailyLivingActivityScoreId"]) > 0)
            //        {
            //            //dr["ModifiedDate"] = DateTime.Now;
            //            //dr["ModifiedBy"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
            //        }
            //        else
            //        {
            //            BaseCommonFunctions.InitRowCredentials(dr);
            //        }
            //    }
            //}

            //if (dataSetObject.Tables["CustomHRMAssessmentRAPScores"].Rows.Count > 0)
            //{


            //    foreach (DataRow dr in dataSetObject.Tables["CustomHRMAssessmentRAPScores"].Rows)
            //    {
            //        if (Convert.ToInt32(dr["HRMAssessmentRAPQuestionId"]) > 0)
            //        {
            //            //dr["ModifiedDate"] = DateTime.Now;
            //            //dr["ModifiedBy"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
            //        }
            //        else
            //        {
            //            BaseCommonFunctions.InitRowCredentials(dr);
            //        }
            //    }

            //}



            if (dataSetObject.Tables["CustomSubstanceUseHistory2"].Rows.Count > 0)
            {
                foreach (DataRow dr in dataSetObject.Tables["CustomSubstanceUseHistory2"].Rows)
                {
                    if (Convert.ToInt32(dr["SubstanceUseHistoryId"]) > 0)
                    {
                        //dr["ModifiedDate"] = DateTime.Now;
                        //dr["ModifiedBy"] = BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                    }
                    else
                    {
                        BaseCommonFunctions.InitRowCredentials(dr);
                    }
                }

            }

            if (dataSetObject.Tables.Contains("CustomHRMActivities"))
            {
                dataSetObject.Tables.Remove("CustomHRMActivities");
            }


            // Added on August 6,2010
            string[] dataTables = new string[] { "DiagnosesIANDIIMaxOrder" };

            if (dataSetObject != null)
            {
                for (int count = 0; count < dataTables.Length; count++)
                {
                    if (dataSetObject.Tables.Contains(dataTables[count]) == true)
                    {
                        dataSetObject.Tables.Remove(dataTables[count].ToString());
                    }
                }
            }
            else
            {
                throw new ApplicationException("DataSet is Null");
            }


            //Added By Rakesh
            if (dataSetObject.Tables.Contains("CustomASAMLevelOfCares"))
            {
                dataSetObject.Tables.Remove("CustomASAMLevelOfCares");
            }
            //needs to add 
            GetNeedCreationDatafromDatasetForMHA();
            if (dataSetObject.Tables.Contains("CarePlanDomains"))
            {
                dataSetObject.Tables.Remove("CarePlanDomains");
            }
            if (dataSetObject.Tables.Contains("CarePlanDomainNeeds"))
            {
                dataSetObject.Tables.Remove("CarePlanDomainNeeds");
            }


            //int LOCId = -1;
            //int totalScore = 0;
            //if (dataSetObject.Tables.Contains("CustomHRMAssessments") && dataSetObject.Tables["CustomHRMAssessments"].Rows.Count > 0)
            //{
            //    string adultOrChild = Convert.ToString(dataSetObject.Tables["CustomHRMAssessments"].Rows[0]["AdultOrChild"]);
            //    if (adultOrChild.ToLower().Trim() == "a")
            //    {
            //        //go for DLA Score
            //        totalScore = CalculateDLAScores();
            //    }
            //    else if (adultOrChild.ToLower().Trim() == "c")
            //    {
            //        //go for CAFAS
            //        totalScore = CalculateCAFASScores();
            //    }
            //}

            //if (totalScore != 0)
            //{
            //    //calculate LOCId in CustomHRMAssessments
            //    if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Tables["CustomLOCCategories"].Rows.Count > 0)
            //    {
            //        DataTable _CustomLOCCategories = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Tables["CustomLOCCategories"];
            //        //DataRow[] drRangeFilteredRow = _CustomLOCCategories.Select("MinDeterminatorScore>=" + totalScore + "and MaxDeterminatorScore <= " + totalScore);
            //        DataRow[] drRangeFilteredRow = _CustomLOCCategories.Select("((MinDeterminatorScore>=" + totalScore + " and MaxDeterminatorScore <= " + totalScore + ") or  (MinDeterminatorScore<=" + totalScore + " and MaxDeterminatorScore >= " + totalScore + "))");

            //        if (drRangeFilteredRow.Length > 0)
            //        {
            //            LOCId = Convert.ToInt32(drRangeFilteredRow[0]["LOCId"]);
            //        }
            //    }
            //    //update locid in CustomHRMAssessments table
            //    if (dataSetObject.Tables["CustomHRMAssessments"].Rows.Count > 0)
            //    {
            //        dataSetObject.Tables["CustomHRMAssessments"].Rows[0]["LOCId"] = LOCId;
            //    }
            //}

            //New Directions - Support Go Live #971 - Added defensive code
            if (Convert.ToInt32(dataSetObject.Tables["Documents"].Rows[0]["DocumentId"]) == 0 && (!dataSetObject.Tables["DocumentVersions"].IsRowExists()))
            {
                if (!dataSetObject.Tables.Contains("DocumentVersions"))
                {
                    DataTable dt = new DataTable("DocumentVersions");
                    dt.Clear();

                    //DocumentVersionId
                    DataColumn documentVersionId = dt.Columns.Add("DocumentVersionId", typeof(int));
                    documentVersionId.AllowDBNull = false;
                    dt.PrimaryKey = new DataColumn[] { documentVersionId };

                    //CreatedBy
                    dt.Columns.Add("CreatedBy", typeof(string)).MaxLength = 30;

                    //CreatedDate
                    dt.Columns.Add("CreatedDate", typeof(DateTime));

                    //ModifiedBy
                    dt.Columns.Add("ModifiedBy", typeof(string)).MaxLength = 30;

                    //ModifiedDate
                    dt.Columns.Add("ModifiedDate", typeof(DateTime));

                    //RecordDeleted
                    dt.Columns.Add("RecordDeleted", typeof(string)).MaxLength = 1;

                    //DeletedBy
                    dt.Columns.Add("DeletedBy", typeof(string)).MaxLength = 30;

                    //DeletedDate
                    dt.Columns.Add("DeletedDate", typeof(DateTime));

                    //DocumentId
                    dt.Columns.Add("DocumentId", typeof(Int32));

                    //Version
                    dt.Columns.Add("Version", typeof(Int32));

                    //AuthorId
                    dt.Columns.Add("AuthorId", typeof(Int32));

                    //EffectiveDate
                    dt.Columns.Add("EffectiveDate", typeof(DateTime));

                    //DocumentChanges
                    dt.Columns.Add("DocumentChanges", typeof(string)).MaxLength = 2147483647;

                    //DocumentChanges
                    dt.Columns.Add("ReasonForChanges", typeof(string)).MaxLength = 2147483647;

                    //RevisionNumber
                    dt.Columns.Add("RevisionNumber", typeof(Int32));

                    //RevisionNumber
                    dt.Columns.Add("RefreshView", typeof(string)).MaxLength = 1;

                    //ReasonForNewVersion
                    dt.Columns.Add("ReasonForNewVersion", typeof(string)).MaxLength = 2147483647;

                    dataSetObject.Tables.Add(dt);


                    //Create Relationships b/w DocumentVersions and custom  table(s) contains documentversionId Column.
                    //    DataTable dataTableMaster = dataSetObject.Tables["DocumentVersions"];
                    //    foreach (DataTable dt1 in dataSetObject.Tables)
                    //    {
                    //        if (dt1.TableName != "Documents" && dt1.TableName != "DocumentVersions")
                    //        {
                    //            if (dt1.Columns.Contains("DocumentVersionId"))
                    //            {
                    //                DataRelation dataRelationDocumentVersionId;
                    //                DataColumn dataColumnPrimary = dataTableMaster.Columns["DocumentVersionId"];
                    //                dataColumnPrimary.ReadOnly = false;
                    //                DataColumn dataColumnForgien = dt1.Columns["DocumentVersionId"];
                    //                dataColumnForgien.ReadOnly = false;
                    //                dataRelationDocumentVersionId = new DataRelation("DocumentVersions_" + dt1.TableName + "_FK", dataColumnPrimary, dataColumnForgien);
                    //                dataSetObject.Relations.Add(dataRelationDocumentVersionId);
                    //            }
                    //        }
                    //    }
                }

                DataRow dataRowDocumentVersion = dataSetObject.Tables["DocumentVersions"].NewRow();
                dataRowDocumentVersion.BeginEdit();
                dataRowDocumentVersion["DocumentVersionId"] = -1;
                dataRowDocumentVersion["DocumentId"] = dataSetObject.Tables["Documents"].Rows[0]["DocumentId"];
                dataRowDocumentVersion["Version"] = 1;
                dataRowDocumentVersion["AuthorId"] = dataSetObject.Tables["Documents"].Rows[0]["AuthorId"];
                dataRowDocumentVersion["RevisionNumber"] = 1;
                BaseCommonFunctions.InitRowCredentials(dataRowDocumentVersion);
                dataRowDocumentVersion.EndEdit();
                dataSetObject.Tables["DocumentVersions"].Rows.Add(dataRowDocumentVersion);
            }

        }

        private int CalculateRAPScores()
        {
            int RAPTotalScore = 0;
            //DataSet datasetDocument = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            //if (datasetDocument.Tables.Contains("CustomHRMAssessmentRAPScores"))
            //{
            //    if (datasetDocument.Tables["CustomHRMAssessmentRAPScores"].Rows.Count > 0)
            //    {
            //        foreach (DataRow dr in datasetDocument.Tables["CustomHRMAssessmentRAPScores"].Rows)
            //        {
            //            //if (dr["ActivityScore"] != DBNull.Value)
            //            //{
            //                RAPTotalScore += Convert.ToInt32(dr["RAPAssessedValue"]);
            //            //}
            //        }
            //    }
            //}
            return RAPTotalScore;
        }

        private int CalculateDLAScores()
        {
            int DLATotalScore = 0;
            DataSet datasetDocument = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            if (datasetDocument.Tables.Contains("CustomDailyLivingActivityScores"))
            {
                if (datasetDocument.Tables["CustomDailyLivingActivityScores"].Rows.Count > 0)
                {
                    foreach (DataRow dr in datasetDocument.Tables["CustomDailyLivingActivityScores"].Rows)
                    {
                        if (dr["ActivityScore"] != DBNull.Value)
                        {
                            DLATotalScore += Convert.ToInt32(dr["ActivityScore"]);
                        }
                    }
                }
            }
            return DLATotalScore;
        }

        private int CalculateCAFASScores()
        {
            int CAFASTotalScore = 0;
            DataSet datasetDocument = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            if (datasetDocument.Tables.Contains("CustomCAFAS2"))
            {
                if (datasetDocument.Tables["CustomCAFAS2"].Rows.Count > 0)
                {
                    foreach (DataRow dr in datasetDocument.Tables["CustomCAFAS2"].Rows)
                    {
                        if (dr["SchoolPerformance"] != DBNull.Value)
                            CAFASTotalScore += Convert.ToInt32(dr["SchoolPerformance"]);

                        if (dr["HomePerformance"] != DBNull.Value)
                            CAFASTotalScore += Convert.ToInt32(dr["HomePerformance"]);

                        if (dr["CommunityPerformance"] != DBNull.Value)
                            CAFASTotalScore += Convert.ToInt32(dr["CommunityPerformance"]);

                        if (dr["BehaviorTowardsOther"] != DBNull.Value)
                            CAFASTotalScore += Convert.ToInt32(dr["BehaviorTowardsOther"]);

                        if (dr["MoodsEmotion"] != DBNull.Value)
                            CAFASTotalScore += Convert.ToInt32(dr["MoodsEmotion"]);

                        if (dr["SelfHarmfulBehavior"] != DBNull.Value)
                            CAFASTotalScore += Convert.ToInt32(dr["SelfHarmfulBehavior"]);

                        if (dr["SubstanceUse"] != DBNull.Value)
                            CAFASTotalScore += Convert.ToInt32(dr["SubstanceUse"]);

                        if (dr["Thinkng"] != DBNull.Value)
                            CAFASTotalScore += Convert.ToInt32(dr["Thinkng"]);
                    }
                }
            }
            return CAFASTotalScore;
        }
        public override void CustomAjaxRequest()
        {
            if (base.GetRequestParameterValue("Flag") == "AlterDispositionControl")
            {
                LoadDispositionDropDownControlForService();
            }
            else
                if (base.GetRequestParameterValue("Flag") == "GetDispositionDropDown")
                {
                    MainPanelUC.Controls.Clear();

                    Literal literalStart = new Literal();
                    Literal literalResult = new Literal();
                    Literal literalEnd = new Literal();
                    literalStart.Text = "###StartDispositionHTML###";
                    literalEnd.Text = "###EndDispositionHTML###";

                    string calledMethod = GetRequestParameterValue("calledMethod");
                    string key = GetRequestParameterValue("key");

                    literalResult.Text = GetDispositionDropDownsHTML(calledMethod, key);

                    MainPanelUC.Controls.Add(literalStart);
                    MainPanelUC.Controls.Add(literalResult);
                    MainPanelUC.Controls.Add(literalEnd);

                }
        }
        public string GetDispositionDropDownsHTML(string calledMethod, string key)
        {
            StringBuilder stringHTML = new StringBuilder();
            if (calledMethod == "ServiceDisposition")
            {
                int ddValue = 0;

                int.TryParse(key, out ddValue);
                stringHTML.Append("<option value='' >Select Service Type</option>");
                if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes != null)
                {
                    DataView dataViewGlobalSubCodesCodesServiceType = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes);
                    dataViewGlobalSubCodesCodesServiceType.RowFilter = "globalcodeid='" + ddValue + "'and isnull(RecordDeleted,'N')<>'Y'";

                    for (int i = 0; i < dataViewGlobalSubCodesCodesServiceType.Count; i++)
                    {
                        stringHTML.Append("<option value=" + dataViewGlobalSubCodesCodesServiceType[i]["GlobalSubCodeId"] + " title='" + Convert.ToString(dataViewGlobalSubCodesCodesServiceType[i]["SubCodeName"]) + "'>" + Convert.ToString(dataViewGlobalSubCodesCodesServiceType[i]["SubCodeName"]) + "</option>");
                    }
                }

            }
            else
                if (calledMethod == "ProviderService")
                {
                    int ddValue = 0;

                    int.TryParse(key, out ddValue);
                    stringHTML.Append("<option value='' >Select Provider/Agency</option>");

                    DataSet dataSetProgramsBasedOnServiceType = new DataSet();
                    //dataSetProgramsBasedOnServiceType = objectMemberInquiries.GetProgramsBasedOnServiceType(ddValue);
                    //DataSet dataSetProgramsBasedOnServiceType = null;
                    _objectSqlParmeters = new SqlParameter[2];
                    _objectSqlParmeters[0] = new SqlParameter("@ServiceType", ddValue);
                    dataSetProgramsBasedOnServiceType = new DataSet();
                    SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetProgramsBasedOnServiceType", dataSetProgramsBasedOnServiceType, new string[] { "ProgramsBasedOnServiceType" }, _objectSqlParmeters);


                    if (BaseCommonFunctions.CheckRowExists(dataSetProgramsBasedOnServiceType, "ProgramsBasedOnServiceType", 0))
                    {
                        foreach (DataRow dr in dataSetProgramsBasedOnServiceType.Tables["ProgramsBasedOnServiceType"].Rows)
                        {
                            stringHTML.Append("<option value=" + dr["ProgramId"] + " title='" + Convert.ToString(dr["ProgramName"]) + "'>" + Convert.ToString(dr["ProgramName"]) + "</option>");
                        }
                    }
                    // }

                }
            return stringHTML.ToString();
        }

        private void LoadDispositionDropDownControlForService()
        {
            bool IsNew = false;
            string bindControlId = base.GetRequestParameterValue("bindControlId");
            string callMethod = base.GetRequestParameterValue("callMethod");
            string operationType = base.GetRequestParameterValue("operationType");
            string operationOn = base.GetRequestParameterValue("operationOn");
            int pKey = Convert.ToInt32(base.GetRequestParameterValue("PrKey"));
            int changeValue = 0;
            int.TryParse(base.GetRequestParameterValue("changeValue"), out changeValue);
            int deleteParentKey = 0;
            int.TryParse(base.GetRequestParameterValue("PPKey"), out deleteParentKey);

            int documentVersionId = -1;
            documentVersionId = Convert.ToInt32(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"]);
            UserControl userControl = LoadUC("~/CommonUserControls/DispositionProviderServiceType.ascx", bindControlId, callMethod, operationType, operationOn, pKey, changeValue, deleteParentKey, IsNew, 0, documentVersionId);
            MainPanelUC.Controls.Clear();
            MainPanelUC.Controls.Add(userControl);
        }

        private UserControl LoadUC(string LoadUCName, params object[] constructorParameters)
        {
            System.Web.UI.UserControl userControl = null;
            string ucControlPath = string.Empty;

            ucControlPath = LoadUCName;

            List<Type> constParamTypes = new List<Type>();

            foreach (object constParam in constructorParameters)
            {
                constParamTypes.Add(constParam.GetType());
            }

            if (!string.IsNullOrEmpty(ucControlPath))
            {
                userControl = (UserControl)this.Page.LoadControl(ucControlPath);
            }

            ConstructorInfo constructor = userControl.GetType().BaseType.GetConstructor(constParamTypes.ToArray());

            //And then call the relevant constructor
            if (constructor == null)
            {
                throw new MemberAccessException("The requested constructor was not found on : " + userControl.GetType().BaseType.ToString());
            }
            else
            {
                constructor.Invoke(userControl, constructorParameters);
            }

            return userControl;
        }

        /// <summary>
        /// Added below Funtion to get the Agency Name, By Saurav Pande on 27/06/2012 with ref to task 18 in WoodLand Implementation
        /// </summary>
        public void GetAgencyName()
        {
            using (SHS.UserBusinessServices.Document objectDocument = new SHS.UserBusinessServices.Document())
            {
                HiddenAgencyName.Value = objectDocument.GetAgencyName();
            }
        }
        #region Needs

        /// <summary>
        ///<Author>Veena S Mani</Author>
        ///<CreatedOn>Jan 29,2015</CreatedOn>
        ///<Description>This function is used to get Need List creation data for MHAssessment
        /// </summary>
        /// <param name=""></param>
        private void GetNeedCreationDatafromDatasetForMHA()
        {
            DataSet dataSetMHA = null;
            int documentVersionId = 0;
            using (dataSetMHA = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
            {
            var _clientage = Convert.ToInt32(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["ClientAge"].ToString().Split(' ')[0]);
            using (dataSetMHA = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
            {
                if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA, "CustomHRMAssessments", 0))
                {
                    DataTable DataTableMHANeedDescription = new DataTable();
                    //DataTableMHANeedDescription = GetMHANeedDescriptionTable();
                    if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["DocumentVersionId"]) != string.Empty)
                    {
                        documentVersionId = Convert.ToInt32(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["DocumentVersionId"].ToString());
                    }
                    GetNeedCreationDataForUNCOPE(documentVersionId, dataSetMHA, DataTableMHANeedDescription);
                    if (dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["AdultOrChild"].ToString() == "A")
                    {
                        GetNeedCreationDataForPES(documentVersionId, dataSetMHA, DataTableMHANeedDescription);
                        GetNeedCreationDataForPSAdult(documentVersionId, dataSetMHA, DataTableMHANeedDescription);
                        //GetNeedCreationDataForDLA(documentVersionId, dataSetMHA, DataTableMHANeedDescription);
                    }
                    else if (dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["AdultOrChild"].ToString() == "C")
                    {
                        GetNeedCreationDataForPSChild(documentVersionId, dataSetMHA, DataTableMHANeedDescription);
                        GetNeedCreationDataForCAFAS(documentVersionId, dataSetMHA, DataTableMHANeedDescription);
                    }

                    if (_clientage >= 18)
                    {
                        GetNeedCreationDataForDLA(documentVersionId, dataSetMHA, DataTableMHANeedDescription);
                    }
                    if (_clientage >= 1 && _clientage < 18)
                    {
                        GetNeedCreationDataForDLAYouth(documentVersionId, dataSetMHA, DataTableMHANeedDescription);
                    }

                    GetNeedCreationDataForMentalStatus(documentVersionId, dataSetMHA, DataTableMHANeedDescription);
                    GetNeedCreationDataForRiskAssessment(documentVersionId, dataSetMHA, DataTableMHANeedDescription);


                }
            }
            }
        }

        /// <summary>
        ///<Author>Veena S Mani</Author>
        ///<CreatedOn>Jan 29,2015</CreatedOn> 
        /// </summary>
        /// <param name="ColumnName"></param>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        private string GetNeedValue(string ColumnName, DataRow[] dataRow)
        {
            string NeedValue = string.Empty;
            if (Convert.ToString(dataRow[0][ColumnName]) != string.Empty)
            {
                NeedValue = Convert.ToString(dataRow[0][ColumnName]);
                if (NeedValue.Trim() == "Y")
                {
                    return NeedValue;
                }

            }

            return NeedValue;
        }
        /// <summary>
        /// <Author>Veena S Mani</Author>
        ///<CreatedOn>Jan 29,2015</CreatedOn>
        /// </summary>
        /// <param name="ColumnName"></param>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        private string GetScoreValue(string ColumnName, DataRow[] dataRow)
        {
            int ScoreValue = 0;
            String MetExpectation = "N";
            if (Convert.ToString(dataRow[0][ColumnName]) != string.Empty)
            {
                int.TryParse(Convert.ToString(dataRow[0][ColumnName]), out ScoreValue);
                if (ScoreValue == 20 || ScoreValue == 30)
                {
                    MetExpectation = "Y";
                }

            }

            return MetExpectation;
        }
        /// <summary>
        ///<Author>Veena S Mani</Author>
        ///<CreatedOn>Jan 29,2015</CreatedOn>
        /// </summary>
        /// <param name="dataRow"></param>
        /// <param name="HRMActivityId"></param>
        /// <returns></returns>
        private string GetDLAScoreValue(DataRow[] dataRow, int HRMActivityId)
        {
            int ScoreValue = 0;
            String MetExpectation = string.Empty;
            if (dataRow.Length > 0)
            {
                for (int k = 0; k < dataRow.Length; k++)
                {
                    int ActivityId = 0;
                    int.TryParse(Convert.ToString(dataRow[k]["HRMActivityId"]), out ActivityId);
                    if (ActivityId == HRMActivityId)
                    {
                        if (Convert.ToString(dataRow[k]["ActivityScore"]) != string.Empty)
                        {
                            int.TryParse(Convert.ToString(dataRow[k]["ActivityScore"]), out ScoreValue);
                            if (ScoreValue <= 4)
                            {
                                if (Convert.ToString(dataRow[k]["ActivityComment"]) != string.Empty)
                                {
                                    MetExpectation = Convert.ToString(dataRow[k]["ActivityComment"]);
                                }
                            }

                        }
                    }
                }
            }
            return MetExpectation;
        }
        /// <summary>
        ///<Author>Veena S Mani</Author>
        ///<CreatedOn>Jan 29,2015</CreatedOn>
        /// </summary>
        /// <param name="documentVersionId"></param>
        /// <param name="dataSetMHA"></param>
        /// <param name="DataTableMHANeedDescription"></param>
        private void GetNeedCreationDataForUNCOPE(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        {
            //CustomDocumentEducations
            DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"];
            DataRow[] datarowCustomDocumentSubstanceUses = null;
            string needDescriptionSubstanceUses = string.Empty;

            string Alchohol = string.Empty;
            string Tobacco = string.Empty;
            string illicitdrugs = string.Empty;
            string Prescription = string.Empty;
            int domainNeedId = 2;
            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"], 0))
            {
                datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
                if (datarowCustomDocumentSubstanceUses.Length > 0)
                {
                    Alchohol = GetNeedValue("AlcoholAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Alchohol.Trim() == "Y")
                    {
                        if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfAlcohol"]) == "N")
                        {
                            needDescriptionSubstanceUses = "Use of Alcohol \"Never\"";
                        }
                        else if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfAlcohol"]) == "R")
                        {
                            needDescriptionSubstanceUses = "Use of Alcohol \"Rarely\"";
                        }
                        else if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfAlcohol"]) == "M")
                        {
                            needDescriptionSubstanceUses = "Use of Alcohol \"Moderate\"";
                        }
                        else if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfAlcohol"]) == "D")
                        {
                            needDescriptionSubstanceUses = "Use of Alcohol \"Daily\"";
                        }
                    }

                    Tobacco = GetNeedValue("UseOfTobaccoNicotineAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Tobacco.Trim() == "Y")
                    {
                        if (needDescriptionSubstanceUses != String.Empty)
                            needDescriptionSubstanceUses = needDescriptionSubstanceUses + "\n";
                        if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfTobaccoNicotine"]) == "N")
                        {
                            needDescriptionSubstanceUses += "Use of Tobacco \"Never\"";
                        }
                        else if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfTobaccoNicotine"]) == "P")
                        {
                            needDescriptionSubstanceUses += "Use of Tobacco \"Previously,but Quit\"";
                        }
                        else if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfTobaccoNicotine"]) == "T")
                        {
                            needDescriptionSubstanceUses += "Use of Tobacco \"Type/Frequency\"";
                        }
                        //needDescriptionSubstanceUses = needDescriptionSubstanceUses + " " + Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfTobaccoNicotineQuit"]) + " "+ Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfTobaccoNicotineTypeOfFrequency"]);
                    }

                    illicitdrugs = GetNeedValue("UseOfIllicitDrugsAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (illicitdrugs.Trim() == "Y")
                    {
                        if (needDescriptionSubstanceUses != String.Empty)
                            needDescriptionSubstanceUses = needDescriptionSubstanceUses + "\n";

                        if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfIllicitDrugs"]) == "N")
                        {
                            needDescriptionSubstanceUses += "Use of Illicit Drugs \"Never\"";
                        }
                        else if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfIllicitDrugs"]) == "Y")
                        {
                            needDescriptionSubstanceUses += "Use of Illicit Drugs \"Type/Frequency\"";
                        }
                        //  needDescriptionSubstanceUses = needDescriptionSubstanceUses + " " + Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["UseOfIllicitDrugsTypeFrequency"]);

                    }


                    Prescription = GetNeedValue("PrescriptionOTCDrugsAddtoNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Prescription.Trim() == "Y")
                    {
                        if (needDescriptionSubstanceUses != String.Empty)
                            needDescriptionSubstanceUses = needDescriptionSubstanceUses + "\n";

                        if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["PrescriptionOTCDrugs"]) == "N")
                        {
                            needDescriptionSubstanceUses += "Prescription/OTC Drugs \"Never\"";
                        }
                        else if (Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["PrescriptionOTCDrugs"]) == "Y")
                        {
                            needDescriptionSubstanceUses += "Prescription/OTC Drugs \"Type/Frequency\"";
                        }
                        // needDescriptionSubstanceUses = needDescriptionSubstanceUses + " " + Convert.ToString(dataSetMHA.Tables["CustomDocumentAssessmentSubstanceUses"].Rows[0]["PrescriptionOTCDrugsTypeFrequency"]);

                    }
                    //From  SubstanceAbuse Tab
                    string SubstanceUse = string.Empty;
                    if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomHRMAssessments"], 0))
                    {
                        datarowCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomHRMAssessments"].Select("DocumentVersionId=" + documentVersionId);
                        if (datarowCustomDocumentSubstanceUses.Length > 0)
                        {
                            SubstanceUse = GetNeedValue("SubstanceUseNeedsList", datarowCustomDocumentSubstanceUses);
                            if (SubstanceUse.Trim() == "Y")
                            {
                                if (needDescriptionSubstanceUses != String.Empty)
                                    needDescriptionSubstanceUses = needDescriptionSubstanceUses + "\n";
                                needDescriptionSubstanceUses += Convert.ToString(dataSetMHA.Tables["CustomSubstanceUseAssessments"].Rows[0]["VoluntaryAbstinenceTrial"]);
                            }
                        }
                    }

                    //From CAFAS SubstanceAbuse
                    string SchoolPerformance = string.Empty;
                    if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomCAFAS2"], 0))
                    {

                        datarowCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomCAFAS2"].Select("DocumentVersionId=" + documentVersionId);
                        if (datarowCustomDocumentSubstanceUses.Length > 0)
                        {
                            SchoolPerformance = GetScoreValue("SubstanceUse", datarowCustomDocumentSubstanceUses);
                            if (SchoolPerformance.Trim() == "Y")
                            {
                                if (needDescriptionSubstanceUses != String.Empty)
                                    needDescriptionSubstanceUses = needDescriptionSubstanceUses + "\n";
                                needDescriptionSubstanceUses += Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["SubstanceUseComment"]);
                            }
                        }
                    }
                    if (Alchohol.Trim() != "Y" && Tobacco.Trim() != "Y" && illicitdrugs.Trim() != "Y" && Prescription.Trim() != "Y" && SubstanceUse.Trim() != "Y" && SchoolPerformance.Trim() != "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                    }
                    ModifyNeeds(documentVersionId, domainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                }
            }
        }
        private void GetNeedCreationDataForPES(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        {
            //CustomDocumentEducations
            DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomDocumentPreEmploymentActivities"];
            DataRow[] datarowCustomDocumentSubstanceUses = null;
            string needDescriptionSubstanceUses = string.Empty;
            string Education = string.Empty;
            string Personal = string.Empty;
            string Employment = string.Empty;
            string Support = string.Empty;
            string Work = string.Empty;
            string GainfulEmpB = string.Empty;
            string GainfulEmp = string.Empty;
            int EdudomainNeedId = 11, PerdomainNeedId = 12, OppodomainNeedId = 13, SupportdomainNeedId = 14, WorkdomainNeedId = 15, GaindomainNeedId = 41;
            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomDocumentPreEmploymentActivities"], 0))
            {
                datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
                if (datarowCustomDocumentSubstanceUses.Length > 0)
                {
                    Education = GetNeedValue("EducationTrainingNeeds", datarowCustomDocumentSubstanceUses);
                    if (Education.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomDocumentPreEmploymentActivities"].Rows[0]["EducationTrainingNeedsComments"]);
                        ModifyNeeds(documentVersionId, EdudomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(EdudomainNeedId, documentVersionId, dataSetMHA);
                    }

                    Personal = GetNeedValue("PersonalCareerPlanningNeeds", datarowCustomDocumentSubstanceUses);
                    if (Personal.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomDocumentPreEmploymentActivities"].Rows[0]["PersonalCareerPlanningNeedsComments"]);
                        ModifyNeeds(documentVersionId, PerdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(PerdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Employment = GetNeedValue("EmploymentOpportunitiesNeeds", datarowCustomDocumentSubstanceUses);
                    if (Employment.Trim() == "Y")
                    {

                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomDocumentPreEmploymentActivities"].Rows[0]["EmploymentOpportunitiesNeedsComments"]);
                        ModifyNeeds(documentVersionId, OppodomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(OppodomainNeedId, documentVersionId, dataSetMHA);
                    }

                    Support = GetNeedValue("SupportedEmploymentNeeds", datarowCustomDocumentSubstanceUses);
                    if (Support.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomDocumentPreEmploymentActivities"].Rows[0]["SupportedEmploymentNeedsComments"]);
                        ModifyNeeds(documentVersionId, SupportdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(SupportdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Work = GetNeedValue("WorkHistoryNeeds", datarowCustomDocumentSubstanceUses);
                    if (Work.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomDocumentPreEmploymentActivities"].Rows[0]["WorkHistoryNeedsComments"]);
                        ModifyNeeds(documentVersionId, WorkdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(WorkdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    needDescriptionSubstanceUses = string.Empty;
                    GainfulEmpB = GetNeedValue("GainfulEmploymentBenefitsNeeds", datarowCustomDocumentSubstanceUses);
                    if (GainfulEmpB.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomDocumentPreEmploymentActivities"].Rows[0]["GainfulEmploymentBenefitsNeedsComments"]);
                    }

                    GainfulEmp = GetNeedValue("GainfulEmploymentNeeds", datarowCustomDocumentSubstanceUses);
                    if (GainfulEmp.Trim() == "Y")
                    {
                        if (needDescriptionSubstanceUses != String.Empty)
                            needDescriptionSubstanceUses = needDescriptionSubstanceUses + "\n";

                        needDescriptionSubstanceUses += Convert.ToString(dataSetMHA.Tables["CustomDocumentPreEmploymentActivities"].Rows[0]["GainfulEmploymentNeedsComments"]);


                    }
                    if (GainfulEmpB.Trim() != "Y" && GainfulEmp.Trim() != "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                    }
                    ModifyNeeds(documentVersionId, GaindomainNeedId, needDescriptionSubstanceUses, dataSetMHA);

                }
            }
        }
        private void GetNeedCreationDataForPSAdult(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        {
            //CustomDocumentEducations
            DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomHRMAssessments"];
            DataRow[] datarowCustomDocumentSubstanceUses = null;
            string needDescriptionSubstanceUses = string.Empty;
            string Health = string.Empty;
            string Medication = string.Empty;
            string Abuse = string.Empty;
            string Cultural = string.Empty;
            string Educational = string.Empty;
            string Mental = string.Empty;
            string Communicable = string.Empty;
            string Anxiety = string.Empty;
            string Depression = string.Empty;

            int PhydomainNeedId = 3;
            int MeddomainNeedId = 7;
            int AbusedomainNeedId = 5;
            int CultdomainNeedId = 4;
            int EducatdomainNeedId = 42;
            int MHdomainNeedId = 1;
            int CommudomainNeedId = 43;
            int AnxitdomainNeedId = 16;
            int DepresdomainNeedId = 17;
            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomHRMAssessments"], 0))
            {
                datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
                if (datarowCustomDocumentSubstanceUses.Length > 0)
                {
                    Health = GetNeedValue("PsCurrentHealthIssuesNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Health.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsCurrentHealthIssuesComment"]);
                        ModifyNeeds(documentVersionId, PhydomainNeedId, needDescriptionSubstanceUses, dataSetMHA);

                    }
                    else
                    {
                        DeleteMHANeeds(PhydomainNeedId, documentVersionId, dataSetMHA);
                    }

                    Medication = GetNeedValue("PsMedicationsNeedsList", datarowCustomDocumentSubstanceUses);
                    needDescriptionSubstanceUses = string.Empty;
                    if (Medication.Trim() == "Y" && Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsMedications"]) == "I")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsMedicationsComment"]);
                        ModifyNeeds(documentVersionId, MeddomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else if (Medication.Trim() == "Y" && Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsMedications"]) == "L")
                    {
                        if (dataSetMHA.Tables["CustomHRMAssessmentMedications"].Rows.Count > 0)
                        {
                            foreach (DataRow dr in dataSetMHA.Tables["CustomHRMAssessmentMedications"].Rows)
                            {
                                if (dr["Name"] != DBNull.Value && dr["RecordDeleted"] != "Y")
                                {
                                    needDescriptionSubstanceUses += Convert.ToString(dr["Name"]) + ", ";
                                }
                            }
                            needDescriptionSubstanceUses = needDescriptionSubstanceUses.TrimEnd(',', ' ');
                        }
                        ModifyNeeds(documentVersionId, MeddomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(MeddomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Abuse = GetNeedValue("PsClientAbuseIssuesNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Abuse.Trim() == "Y")
                    {

                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsClientAbuesIssuesComment"]);
                        ModifyNeeds(documentVersionId, AbusedomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(AbusedomainNeedId, documentVersionId, dataSetMHA);
                    }

                    Cultural = GetNeedValue("PsCulturalEthnicIssuesNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Cultural.Trim() == "Y")
                    {

                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsCulturalEthnicIssuesComment"]);
                        ModifyNeeds(documentVersionId, CultdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(CultdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Educational = GetNeedValue("PsEducationNeedsList", datarowCustomDocumentSubstanceUses);
                    needDescriptionSubstanceUses = string.Empty;
                    if (Educational.Trim() == "Y")
                    {
                        string NeedsThere = "False";
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["AutisticallyImpaired"]) == "Y")
                        {
                            needDescriptionSubstanceUses = " Autistically Impaired";
                            NeedsThere = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["CognitivelyImpaired"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Cognitively Impaired" : ", Cognitively Impaired";
                            NeedsThere = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["EmotionallyImpaired"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Emotionally Impaired" : ", Emotionally Impaired";
                            NeedsThere = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["BehavioralConcern"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Behavioral Concern" : ", Behavioral Concern";
                            NeedsThere = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["LearningDisabilities"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Learning Disabilities" : ", Learning Disabilities";
                            NeedsThere = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PhysicalImpaired"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Physical/Other Health Impaired" : ", Physical/Other Health Impaired";
                            NeedsThere = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["IEP"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "IEP" : ", IEP";
                            NeedsThere = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["ChallengesBarrier"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "No Challenges/Barriers Known" : ", No Challenges/Barriers Known";
                            NeedsThere = "True";
                        }
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + "\n" + Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsEducationComment"]);
                        if (NeedsThere == "False")
                        {
                            needDescriptionSubstanceUses = string.Empty;
                        }
                        ModifyNeeds(documentVersionId, EducatdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }

                    Mental = GetNeedValue("HistMentalHealthTxNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Mental.Trim() == "Y")
                    {

                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["HistMentalHealthTxComment"]);
                        ModifyNeeds(documentVersionId, MHdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(MHdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Communicable = GetNeedValue("CommunicableDiseaseRecommendation", datarowCustomDocumentSubstanceUses);

                    if (Communicable.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Communicable Disease Risk";
                        ModifyNeeds(documentVersionId, CommudomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(CommudomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Anxiety = GetNeedValue("DepressionAnxietyRecommendation", datarowCustomDocumentSubstanceUses);
                    if (Anxiety.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Anxiety";
                        ModifyNeeds(documentVersionId, AnxitdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(AnxitdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Depression = GetNeedValue("DepressionPHQToNeedList", datarowCustomDocumentSubstanceUses);
                    if (Depression.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Depression (PHQ-9)";
                        ModifyNeeds(documentVersionId, DepresdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(DepresdomainNeedId, documentVersionId, dataSetMHA);
                    }
                }
            }
        }
        private void GetNeedCreationDataForPSChild(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        {
            //CustomDocumentEducations
            DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomHRMAssessments"];
            DataRow[] datarowCustomDocumentSubstanceUses = null;
            string needDescriptionSubstanceUses = string.Empty;
            string Health = string.Empty;
            string Medication = string.Empty;
            string Abuse = string.Empty;
            string Cultural = string.Empty;
            string Educational = string.Empty;
            string Mental = string.Empty;
            string Communicable = string.Empty;
            string Anxiety = string.Empty;
            string Depression = string.Empty;
            string Sexual = string.Empty;
            string Immunity = string.Empty;
            string language = string.Empty;
            string visual = string.Empty;
            string intellectual = string.Empty;
            string learning = string.Empty;
            string Prenetal = string.Empty;
            string Pregnancy = string.Empty;
            string PretenalExp = string.Empty;

            string MedicationPre = string.Empty;
            string delivery = string.Empty;
            string milestones = string.Empty;
            string talkbefore = string.Empty;
            string childrelation = string.Empty;
            string housing = string.Empty;
            string guardian = string.Empty;
            string relationship = string.Empty;
            string Sexuality = string.Empty;
            int PhydomainNeedId = 3;
            int MeddomainNeedId = 7;
            int AbusedomainNeedId = 5;
            int CultdomainNeedId = 4;
            int EducatdomainNeedId = 42;
            int MHdomainNeedId = 1;
            int CommudomainNeedId = 13;
            int AnxitdomainNeedId = 16;
            int DepresdomainNeedId = 17;
            int SexDomainNeedId = 10;
            int SexualBehDomainId = 6;
            int ImmunBehDomainId = 8, FamilyDomainId = 9;
            int LanDomainId = 18, VisDomainId = 19, IntDomainId = 20, LerDomainId = 21, PreDomainId = 22, PregDomainId = 23, PreExDomainId = 24, MedicDomainId = 25, DeliDomainId = 26, MileSDomainId = 27, TalkDomainId = 28;
            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomHRMAssessments"], 0))
            {
                datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
                if (datarowCustomDocumentSubstanceUses.Length > 0)
                {
                    Sexual = GetNeedValue("PsSexualityNeedsList", datarowCustomDocumentSubstanceUses);
                    Immunity = GetNeedValue("PsImmunizationsNeedsList", datarowCustomDocumentSubstanceUses);
                    Health = GetNeedValue("PsCurrentHealthIssuesNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Health.Trim() == "Y")
                    {
                        //  needDescriptionSubstanceUses =  Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsCurrentHealthIssuesComment"]);
                        needDescriptionSubstanceUses = "There are current/past health issues";
                        ModifyNeeds(documentVersionId, PhydomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(PhydomainNeedId, documentVersionId, dataSetMHA);
                    }

                    Medication = GetNeedValue("PsMedicationsNeedsList", datarowCustomDocumentSubstanceUses);
                    needDescriptionSubstanceUses = string.Empty;
                    if (Medication.Trim() == "Y" && Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsMedications"]) == "I")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsMedicationsComment"]);
                        ModifyNeeds(documentVersionId, MeddomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else if (Medication.Trim() == "Y" && Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsMedications"]) == "L")
                    {
                        if (dataSetMHA.Tables["CustomHRMAssessmentMedications"].Rows.Count > 0)
                        {
                            foreach (DataRow dr in dataSetMHA.Tables["CustomHRMAssessmentMedications"].Rows)
                            {
                                if (dr["Name"] != DBNull.Value && dr["RecordDeleted"] != "Y")
                                {
                                    needDescriptionSubstanceUses += Convert.ToString(dr["Name"]) + ", ";
                                }
                            }
                            needDescriptionSubstanceUses = needDescriptionSubstanceUses.TrimEnd(',', ' ');
                        }
                        ModifyNeeds(documentVersionId, MeddomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(MeddomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Abuse = GetNeedValue("PsClientAbuseIssuesNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Abuse.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsClientAbuesIssuesComment"]);
                        ModifyNeeds(documentVersionId, AbusedomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(AbusedomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Sexuality = GetNeedValue("AddSexualitytoNeedList", datarowCustomDocumentSubstanceUses);

                    if (Sexuality.Trim() == "Y")
                    {

                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["SexualityComment"]);
                        ModifyNeeds(documentVersionId, SexDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(SexDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Cultural = GetNeedValue("PsCulturalEthnicIssuesNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Cultural.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsCulturalEthnicIssuesComment"]);
                        ModifyNeeds(documentVersionId, CultdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(CultdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Educational = GetNeedValue("PsEducationNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Educational.Trim() == "Y")
                    {
                        string NeedExist = "False";
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["AutisticallyImpaired"]) == "Y")
                        {
                            needDescriptionSubstanceUses = " Autistically Impaired";
                            NeedExist = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["CognitivelyImpaired"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Cognitively Impaired" : ", Cognitively Impaired";
                            NeedExist = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["EmotionallyImpaired"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Emotionally Impaired" : ", Emotionally Impaired";
                            NeedExist = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["BehavioralConcern"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Behavioral Concern" : ", Behavioral Concern";
                            NeedExist = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["LearningDisabilities"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Learning Disabilities" : ", Learning Disabilities";
                            NeedExist = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PhysicalImpaired"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Physical/Other Health Impaired" : ", Physical/Other Health Impaired";
                            NeedExist = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["IEP"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "IEP" : ", IEP";
                            NeedExist = "True";
                        }
                        if (Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["ChallengesBarrier"]) == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "No Challenges/Barriers Known" : ", No Challenges/Barriers Known";
                            NeedExist = "True";
                        }
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + "\n" + Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsEducationComment"]);
                        if (NeedExist == "False")
                        {
                            needDescriptionSubstanceUses = string.Empty;
                        }
                        ModifyNeeds(documentVersionId, EducatdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }

                    Mental = GetNeedValue("HistMentalHealthTxNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Mental.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["HistMentalHealthTxComment"]);
                        ModifyNeeds(documentVersionId, MHdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }

                    Communicable = GetNeedValue("CommunicableDiseaseRecommendation", datarowCustomDocumentSubstanceUses);
                    if (Communicable.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Communicable Disease Risk";
                        ModifyNeeds(documentVersionId, CommudomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(CommudomainNeedId, documentVersionId, dataSetMHA);
                    }

                    Anxiety = GetNeedValue("DepressionAnxietyRecommendation", datarowCustomDocumentSubstanceUses);
                    if (Anxiety.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Anxiety";
                        ModifyNeeds(documentVersionId, AnxitdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(AnxitdomainNeedId, documentVersionId, dataSetMHA);
                    }

                    Depression = GetNeedValue("DepressionPHQToNeedList", datarowCustomDocumentSubstanceUses);
                    if (Depression.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Depression (PHQ-9)";
                        ModifyNeeds(documentVersionId, DepresdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(DepresdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Sexual = GetNeedValue("PsSexualityNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Sexual.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "There are current/past sexual behaviors concerns";
                        ModifyNeeds(documentVersionId, SexualBehDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(SexualBehDomainId, documentVersionId, dataSetMHA);
                    }
                    Immunity = GetNeedValue("PsImmunizationsNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Immunity.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Immunity concerns\n" + Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["PsCurrentHealthIssuesComment"]);
                        ModifyNeeds(documentVersionId, ImmunBehDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(ImmunBehDomainId, documentVersionId, dataSetMHA);
                    }

                    language = GetNeedValue("PsLanguageFunctioningNeedsList", datarowCustomDocumentSubstanceUses);
                    if (language.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "There are concerns with Language functioning";
                        ModifyNeeds(documentVersionId, LanDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(LanDomainId, documentVersionId, dataSetMHA);
                    }
                    visual = GetNeedValue("PsVisualFunctioningNeedsList", datarowCustomDocumentSubstanceUses);
                    if (visual.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "There are concerns with Visual functioning";
                        ModifyNeeds(documentVersionId, VisDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(VisDomainId, documentVersionId, dataSetMHA);
                    }

                    intellectual = GetNeedValue("PsIntellectualFunctioningNeedsList", datarowCustomDocumentSubstanceUses);
                    if (intellectual.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "There are concerns with intellectual functioning";
                        ModifyNeeds(documentVersionId, IntDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(IntDomainId, documentVersionId, dataSetMHA);
                    }

                    learning = GetNeedValue("PsLearningAbilityNeedsList", datarowCustomDocumentSubstanceUses);
                    if (learning.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "There are concerns with learning abilities";
                        ModifyNeeds(documentVersionId, LerDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(LerDomainId, documentVersionId, dataSetMHA);
                    }
                    Prenetal = GetNeedValue("ReceivePrenatalCareNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Prenetal.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Prenatal care issues ";
                        ModifyNeeds(documentVersionId, PreDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(PreDomainId, documentVersionId, dataSetMHA);
                    }
                    Pregnancy = GetNeedValue("ProblemInPregnancyNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Pregnancy.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Pregnancy problems or issues";
                        ModifyNeeds(documentVersionId, PregDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(PregDomainId, documentVersionId, dataSetMHA);
                    }
                    PretenalExp = GetNeedValue("PrenatalExposerNeedsList", datarowCustomDocumentSubstanceUses);
                    if (PretenalExp.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Prenatal Exposures";
                        ModifyNeeds(documentVersionId, PreExDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(PreExDomainId, documentVersionId, dataSetMHA);
                    }

                    MedicationPre = GetNeedValue("WhereMedicationUsedNeedsList", datarowCustomDocumentSubstanceUses);
                    if (MedicationPre.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Medication during Pregnancy  ";
                        ModifyNeeds(documentVersionId, MedicDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(MedicDomainId, documentVersionId, dataSetMHA);
                    }
                    delivery = GetNeedValue("IssueWithDeliveryNeedsList", datarowCustomDocumentSubstanceUses);
                    if (delivery.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Issues with delivery ";
                        ModifyNeeds(documentVersionId, DeliDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(DeliDomainId, documentVersionId, dataSetMHA);
                    }
                    milestones = GetNeedValue("ChildDevelopmentalMilestonesNeedsList", datarowCustomDocumentSubstanceUses);
                    if (milestones.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Developmental milestone issues ";
                        ModifyNeeds(documentVersionId, MileSDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(MileSDomainId, documentVersionId, dataSetMHA);
                    }
                    talkbefore = GetNeedValue("TalkBeforeNeedsList", datarowCustomDocumentSubstanceUses);
                    if (talkbefore.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "Talk before walk ";
                        ModifyNeeds(documentVersionId, TalkDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(TalkDomainId, documentVersionId, dataSetMHA);
                    }
                    needDescriptionSubstanceUses = String.Empty;
                    childrelation = GetNeedValue("ParentChildRelationshipNeedsList", datarowCustomDocumentSubstanceUses);
                    string NeedReady = "False";
                    if (childrelation.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = "There are parent/child relationship issues that are of concern.";
                        NeedReady = "True";
                    }

                    housing = GetNeedValue("PsChildHousingIssuesNeedsList", datarowCustomDocumentSubstanceUses);
                    if (housing.Trim() == "Y")
                    {
                        if (needDescriptionSubstanceUses == string.Empty)
                            needDescriptionSubstanceUses = "There are current housing issues";
                        else
                            needDescriptionSubstanceUses += "\n" + "There are current housing issues";
                        NeedReady = "True";
                    }
                    guardian = GetNeedValue("PsParentalParticipationNeedsList", datarowCustomDocumentSubstanceUses);
                    if (guardian.Trim() == "Y")
                    {
                        if (needDescriptionSubstanceUses == string.Empty)
                            needDescriptionSubstanceUses = "There are parents/guardians willing to praticipate in treatment.";
                        else
                            needDescriptionSubstanceUses += "\n" + "There are parents/guardians willing to praticipate in treatment.";
                        NeedReady = "True";
                    }

                    relationship = GetNeedValue("FamilyRelationshipNeedsList", datarowCustomDocumentSubstanceUses);
                    if (relationship.Trim() == "Y")
                    {
                        if (needDescriptionSubstanceUses == string.Empty)
                            needDescriptionSubstanceUses = "There are other family relationship issues that are of concern.";
                        else
                            needDescriptionSubstanceUses += "\n" + "There are other family relationship issues that are of concern.";
                        NeedReady = "True";
                    }
                    if (NeedReady == "False")
                        needDescriptionSubstanceUses = string.Empty;
                    ModifyNeeds(documentVersionId, FamilyDomainId, needDescriptionSubstanceUses, dataSetMHA);
                }
            }
        }
        private void GetNeedCreationDataForMentalStatus(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        {
            //CustomDocumentEducations
            DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomMentalStatuses2"];
            DataRow[] datarowCustomDocumentSubstanceUses = null;
            string needDescriptionSubstanceUses = string.Empty;
            string General = string.Empty;
            string Intellectual = string.Empty;
            string Communication = string.Empty;
            string Mood = string.Empty;
            string Affect = string.Empty;
            string Speech = string.Empty;
            string Thought = string.Empty;
            string Behaviour = string.Empty;
            string Orientation = string.Empty;
            string Insight = string.Empty;
            string Memory = string.Empty;
            string Reality = string.Empty;

            int domainNeedId = 12;
            int AppeaDomainNeedId = 29, IntelDomainNeedId = 30, CommuDomainNeedId = 31, MoodDomainNeedId = 32, AffecDomainNeedId = 33, SpeechDomainNeedId = 34, ThouDomainNeedId = 35, BehavDomainNeedId = 36, OrienDomainNeedId = 37, InSigDomainId = 38, MemDomainId = 39, RealDomailId = 40;
            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomMentalStatuses2"], 0))
            {
                datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
                if (datarowCustomDocumentSubstanceUses.Length > 0)
                {
                    needDescriptionSubstanceUses = string.Empty;
                    General = GetNeedValue("AppearanceAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (General.Trim() == "Y")
                    {
                        string Needs = "False";
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("AppearanceNeatClean", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses = "neat/clean";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearancePoorHygiene", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "poor personal hygiene/self care" : ", poor personal hygiene/self care";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceWellGroomed", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "well-groomed" : ", well-groomed";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceAppropriatelyDressed", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "appropriately dressed" : ", appropriately dressed";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceYoungerThanStatedAge", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "younger than stated age" : ", younger than stated age";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceOlderThanStatedAge", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "older than stated age" : ", older than stated age";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceOverweight", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "overweight" : ", overweight";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceUnderweight", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Underweight" : ", Underweight";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceEccentric", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "eccentric" : ", eccentric";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceSeductive", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "seductive" : ", seductive";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceUnkemptDisheveled", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "unkempt/disheveled" : ", unkempt/disheveled";
                            Needs = "True";
                        }
                        if (GetNeedValue("AppearanceOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                        {
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                            Needs = "True";
                        }
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["AppearanceComment"]);
                        if (Needs == "False")
                            needDescriptionSubstanceUses = string.Empty;
                        ModifyNeeds(documentVersionId, AppeaDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(AppeaDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Intellectual = GetNeedValue("IntellectualAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Intellectual.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("IntellectualAboveAverage", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "appears above average";
                        if (GetNeedValue("IntellectualAverage", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "appears average" : ", appears average";
                        if (GetNeedValue("IntellectualBelowAverage", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "appears below average" : ", appears below average";
                        if (GetNeedValue("IntellectualPossibleMR", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "possible MR" : ", possible MR";
                        if (GetNeedValue("IntellectualDocumentedMR", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "documented MR" : ", documented MR";
                        if (GetNeedValue("IntellectualOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["IntellectualComment"]);
                        ModifyNeeds(documentVersionId, IntelDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(IntelDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Communication = GetNeedValue("CommunicationAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Communication.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("CommunicationNormal", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "normal";
                        if (GetNeedValue("CommunicationUsesSignLanguage", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "uses sign language" : ", uses sign language";
                        if (GetNeedValue("CommunicationUnableToRead", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "unable to read" : ", unable to read";
                        if (GetNeedValue("CommunicationNeedForBraille", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "need for Braille" : ", need for Braille";
                        if (GetNeedValue("CommunicationHearingImpaired", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "hearing impaired" : ", hearing impaired";
                        if (GetNeedValue("CommunicationDoesLipReading", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "does lip reading" : ", does lip reading";
                        if (GetNeedValue("CommunicationEnglishIsSecondLanguage", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "English is second language" : ", English is second language";
                        if (GetNeedValue("CommunicationTranslatorNeeded", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "translator (sign or spoken language) needed" : ", translator (sign or spoken language) needed";

                        if (GetNeedValue("CommunicationOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["CommunicationComment"]);
                        ModifyNeeds(documentVersionId, CommuDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }

                    else
                    {
                        DeleteMHANeeds(CommuDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Mood = GetNeedValue("MoodAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Mood.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("MoodUnremarkable", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "unremarkable";
                        if (GetNeedValue("MoodCooperative", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "cooperative" : ", cooperative";
                        if (GetNeedValue("MoodAnxious", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "anxious" : ", anxious";
                        if (GetNeedValue("MoodTearful", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "tearful" : ", tearful";
                        if (GetNeedValue("MoodCalm", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "calm" : ", calm";
                        if (GetNeedValue("MoodLabile", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "labile" : ", labile";
                        if (GetNeedValue("MoodPessimistic", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "pessimistic" : ", pessimistic";
                        if (GetNeedValue("MoodCheerful", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "cheerful" : ", cheerful";
                        if (GetNeedValue("MoodGuilty", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "guilty" : ", guilty";
                        if (GetNeedValue("MoodEuphoric", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "euphoric" : ", euphoric";
                        if (GetNeedValue("MoodDepressed", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "depressed" : ", depressed";
                        if (GetNeedValue("MoodHostile", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "hostile" : ", hostile";
                        if (GetNeedValue("MoodIrritable", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "irritable" : ", irritable";
                        if (GetNeedValue("MoodDramatized", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "dramatized" : ", dramatized";
                        if (GetNeedValue("MoodFearful", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "fearful" : ", fearful";
                        if (GetNeedValue("MoodSupicious", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "suspicious" : ", suspicious";
                        if (GetNeedValue("MoodOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["MoodComment"]);
                        ModifyNeeds(documentVersionId, MoodDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(MoodDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Affect = GetNeedValue("AffectAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Affect.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("AffectPrimarilyAppropriate", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "primarily appropriate";
                        if (GetNeedValue("AffectRestricted", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "restricted" : ", restricted";
                        if (GetNeedValue("AffectBlunted", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "blunted" : ", blunted";
                        if (GetNeedValue("AffectFlattened", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "flattened" : ", flattened";
                        if (GetNeedValue("AffectDetached", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "detached" : ", detached";
                        if (GetNeedValue("AffectPrimarilyInappropriate", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "primarily inappropriate" : ", primarily inappropriate";

                        if (GetNeedValue("AffectOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["AffectComment"]);
                        ModifyNeeds(documentVersionId, AffecDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(AffecDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Speech = GetNeedValue("SpeechAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Speech.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("SpeechNormal", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "normal for age & intellect";
                        if (GetNeedValue("SpeechLogicalCoherent", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "logical/coherent" : ", logical/coherent";
                        if (GetNeedValue("SpeechTangential", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "tangential" : ", tangential";
                        if (GetNeedValue("SpeechSparseSlow", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "sparse/slow" : ", sparse/slow";
                        if (GetNeedValue("SpeechRapidPressured", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "rapid/pressured" : ", rapid/pressured";
                        if (GetNeedValue("SpeechSoft", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "soft/mumbles/inaudible" : ", soft/mumbles/inaudible";
                        if (GetNeedValue("SpeechCircumstantial", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "circumstantial" : ", circumstantial";
                        if (GetNeedValue("SpeechLoud", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "loud" : ", loud";
                        if (GetNeedValue("SpeechRambling", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "rambling" : ", rambling";
                        if (GetNeedValue("SpeechOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["SpeechComment"]);
                        ModifyNeeds(documentVersionId, SpeechDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(SpeechDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Thought = GetNeedValue("ThoughtAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Thought.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("ThoughtUnremarkable", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "unremarkable";
                        if (GetNeedValue("ThoughtParanoid", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "paranoid" : ", paranoid";
                        if (GetNeedValue("ThoughtGrandiose", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "grandiose" : ", grandiose";
                        if (GetNeedValue("ThoughtObsessive", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "obsessive" : ", obsessive";
                        if (GetNeedValue("ThoughtBizarre", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "bizarre" : ", bizarre";
                        if (GetNeedValue("ThoughtFlightOfIdeas", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "flight of ideas" : ", flight of ideas";
                        if (GetNeedValue("ThoughtDisorganized", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "disorganized" : ", disorganized";
                        if (GetNeedValue("ThoughtAuditoryHallucinations", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "auditory hallucinations" : ", auditory hallucinations";
                        if (GetNeedValue("ThoughtVisualHallucinations", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "visual hallucinations" : ", visual hallucinations";
                        if (GetNeedValue("ThoughtTactileHallucinations", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "tactile hallucinations" : ", tactile hallucinations";
                        if (GetNeedValue("ThoughtOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["ThoughtComment"]);
                        ModifyNeeds(documentVersionId, ThouDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(ThouDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Behaviour = GetNeedValue("BehaviorAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Behaviour.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("BehaviorNormal", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "normal/alert";
                        if (GetNeedValue("BehaviorRestless", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "restless/overactive" : ", restless/overactive";
                        if (GetNeedValue("BehaviorPoorEyeContact", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "poor eye contact" : ", poor eye contact";
                        if (GetNeedValue("BehaviorAgitated", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "agitated/tense" : ", agitated/tense";
                        if (GetNeedValue("BehaviorPeculiar", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "peculiar mannerisms" : ", peculiar mannerisms";
                        if (GetNeedValue("BehaviorSelfDestructive", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "self-destructive" : ", self-destructive";
                        if (GetNeedValue("BehaviorSlowed", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "slowed/lethargic" : ", slowed/lethargic";
                        if (GetNeedValue("BehaviorDestructiveToOthers", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "destructive to others or property" : ", destructive to others or property";
                        if (GetNeedValue("BehaviorCompulsive", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "compulsive/repetitious" : ", compulsive/repetitious";
                        if (GetNeedValue("BehaviorTremors", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Tremors/Tics" : ", Tremors/Tics";

                        if (GetNeedValue("BehaviorOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["BehaviorComment"]);
                        ModifyNeeds(documentVersionId, BehavDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(BehavDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Orientation = GetNeedValue("OrientationAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Orientation.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("OrientationToPersonPlaceTime", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "oriented to person, place and time";
                        if (GetNeedValue("OrientationNotToPerson", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "not oriented to person" : ", not oriented to person";
                        if (GetNeedValue("OrientationNotToPlace", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "not oriented to place" : ", not oriented to place";
                        if (GetNeedValue("OrientationNotToTime", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "not oriented to time" : ", not oriented to time";

                        if (GetNeedValue("OrientationOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["OrientationComment"]);
                        ModifyNeeds(documentVersionId, OrienDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(OrienDomainNeedId, documentVersionId, dataSetMHA);
                    }
                    Insight = GetNeedValue("InsightAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Insight.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("InsightGood", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "good";
                        if (GetNeedValue("InsightFair", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "fair" : ", fair";
                        if (GetNeedValue("InsightPoor", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "poor" : ", poor";
                        if (GetNeedValue("InsightLacking", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "lacking" : ", lacking";

                        if (GetNeedValue("InsightOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["InsightComment"]);
                        ModifyNeeds(documentVersionId, InSigDomainId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(InSigDomainId, documentVersionId, dataSetMHA);
                    }
                    Memory = GetNeedValue("MemoryAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Memory.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("MemoryGoodNormal", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "good/normal";
                        if (GetNeedValue("MemoryImpairedShortTerm", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "impaired short-term" : ", impaired short-term";
                        if (GetNeedValue("MemoryImpairedLongTerm", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "impaired long-term" : ", impaired long-term";

                        if (GetNeedValue("MemoryOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["MemoryComment"]);
                        ModifyNeeds(documentVersionId, MemDomainId, needDescriptionSubstanceUses, dataSetMHA);

                    }
                    else
                    {
                        DeleteMHANeeds(MemDomainId, documentVersionId, dataSetMHA);
                    }
                    Reality = GetNeedValue("RealityOrientationAddToNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Reality.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("RealityOrientationIntact", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "intact";
                        if (GetNeedValue("RealityOrientationTenuous", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "tenuous" : ", tenuous";
                        if (GetNeedValue("RealityOrientationPoor", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "poor" : ", poor";

                        if (GetNeedValue("RealityOrientationOther", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Other / Comment" : ", Other / Comment";
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomMentalStatuses2"].Rows[0]["RealityOrientationComment"]);
                        ModifyNeeds(documentVersionId, RealDomailId, needDescriptionSubstanceUses, dataSetMHA);

                    }
                    else
                    {
                        DeleteMHANeeds(RealDomailId, documentVersionId, dataSetMHA);
                    }

                }
            }
        }
        private void GetNeedCreationDataForRiskAssessment(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        {
            //CustomDocumentEducations
            DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomHRMAssessments"];
            DataRow[] datarowCustomDocumentSubstanceUses = null;
            string needDescriptionSubstanceUses = string.Empty;

            string Suisidality = string.Empty;
            string Aggression = string.Empty;
            string Factor = string.Empty;
            string Directive = string.Empty;

            int domainNeedId = 12;
            int SuisideDomailId = 44, HomiDomailId = 45, OtherRiskDomailId = 46, AdvanceDomainId = 47;
            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomHRMAssessments"], 0))
            {
                datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
                if (datarowCustomDocumentSubstanceUses.Length > 0)
                {
                    Suisidality = GetNeedValue("SuicideNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Suisidality.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("SuicideCurrent", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "Current Suicidality / Risk to Self";
                        if (GetNeedValue("SuicidePriorAttempt", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Previous Attempts / History" : ", Previous Attempts / History";
                        if (GetNeedValue("SuicideNotPresent", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "No Current or Previous History of Suicidality / Other Risk to Self" : ", No Current or Previous History of Suicidality / Other Risk to Self";

                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["SuicideBehaviorsPastHistory"]);
                        ModifyNeeds(documentVersionId, SuisideDomailId, needDescriptionSubstanceUses, dataSetMHA);

                    }
                    else
                    {
                        DeleteMHANeeds(SuisideDomailId, documentVersionId, dataSetMHA);
                    }

                    Aggression = GetNeedValue("HomicideNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Aggression.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (GetNeedValue("HomicideCurrent", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses = "Current Physical Agression / Sexual Agression / Risk to Others";
                        if (GetNeedValue("HomicidePriorAttempt", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Prior Physical / Sexual Aggression / Risk to Others" : ", Prior Physical / Sexual Aggression / Risk to Others";
                        if (GetNeedValue("HomicideMeans", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Homicidal" : ", Homicidal";
                        if (GetNeedValue("HomicideNotPresent", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                            needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "No Current or Previous History of Physical Agression / Sexual Agression / Risk to Others" : ", No Current or Previous History of Physical Agression / Sexual Agression / Risk to Others";

                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["HomicideBehaviorsPastHistory"]);
                        ModifyNeeds(documentVersionId, HomiDomailId, needDescriptionSubstanceUses, dataSetMHA);

                    }
                    else
                    {
                        DeleteMHANeeds(HomiDomailId, documentVersionId, dataSetMHA);
                    }
                    if (datarowCustomDocumentSubstanceUses[0]["AdultOrChild"].ToString() == "A")
                    {
                        Directive = GetNeedValue("AdvanceDirectiveNeedsList", datarowCustomDocumentSubstanceUses);
                        if (Directive.Trim() == "Y")
                        {
                            needDescriptionSubstanceUses = string.Empty;
                            if (GetNeedValue("AdvanceDirectiveClientHasDirective", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                                needDescriptionSubstanceUses = "Client have a Advance Directive";
                            if (GetNeedValue("AdvanceDirectiveDesired", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                                needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Client desire a Advance Directive plan" : ", Client desire a Advance Directive plan";
                            if (GetNeedValue("AdvanceDirectiveMoreInfo", datarowCustomDocumentSubstanceUses).Trim() == "Y")
                                needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? "Client like more information about Advance Directive planning" : ", Client like more information about Advance Directive planning";

                            needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                            needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["AdvanceDirectiveNarrative"]);
                            ModifyNeeds(documentVersionId, AdvanceDomainId, needDescriptionSubstanceUses, dataSetMHA);
                        }
                    }
                    else
                    {
                        DeleteMHANeeds(AdvanceDomainId, documentVersionId, dataSetMHA);
                    }
                    Factor = GetNeedValue("RiskOtherFactorsNeedsList", datarowCustomDocumentSubstanceUses);
                    if (Factor.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomOtherRiskFactors"], 0))
                        {
                            datarowCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomOtherRiskFactors"].Select("DocumentVersionId=" + documentVersionId);
                            if (datarowCustomDocumentSubstanceUses.Length > 0)
                            {
                                for (int i = 0; i < datarowCustomDocumentSubstanceUses.Length; i++)
                                {
                                    needDescriptionSubstanceUses += string.IsNullOrEmpty(needDescriptionSubstanceUses) ? datarowCustomDocumentSubstanceUses[i]["CodeName"].ToString() : ", " + datarowCustomDocumentSubstanceUses[i]["CodeName"].ToString();
                                }
                            }
                        }
                        needDescriptionSubstanceUses = string.IsNullOrEmpty(needDescriptionSubstanceUses) ? needDescriptionSubstanceUses : "\"" + needDescriptionSubstanceUses + "\"\n";
                        needDescriptionSubstanceUses = needDescriptionSubstanceUses + Convert.ToString(dataSetMHA.Tables["CustomHRMAssessments"].Rows[0]["RiskOtherFactors"]);
                        ModifyNeeds(documentVersionId, OtherRiskDomailId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(OtherRiskDomailId, documentVersionId, dataSetMHA);
                    }
                }
            }
        }
        private void GetNeedCreationDataForCAFAS(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        {
            //CustomDocumentSchoolPerformances
            DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomCAFAS2"];
            DataRow[] datarowCustomDocumentSubstanceUses = null;
            string needDescriptionSubstanceUses = string.Empty;
            string SchoolPerformance = string.Empty;
            string Personal = string.Empty;
            string Employment = string.Empty;
            string Support = string.Empty;
            string Work = string.Empty;
            string GainfulEmpB = string.Empty;
            string GainfulEmp = string.Empty;
            int EdudomainNeedId = 48, PerdomainNeedId = 49, OppodomainNeedId = 50, SupportdomainNeedId = 51, WorkdomainNeedId = 52, GaindomainNeedId = 53, ThinkingNeedId = 54;
            int PrimaryNeedId = 55, PrimdomainNeedId = 56, NonCldomainNeedId = 57, CludomainNeedId = 58, SurgdomainNeedId = 59, SocialDomainNeedId = 60;
            string PrimaryFamilyMaterialNeeds, PrimaryFamilySocialSupport, NonCustodialMaterialNeeds, NonCustodialSocialSupport, SurrogateMaterialNeeds, SurrogateSocialSupport = string.Empty;


            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomCAFAS2"], 0))
            {
                datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
                if (datarowCustomDocumentSubstanceUses.Length > 0)
                {
                    needDescriptionSubstanceUses = string.Empty;
                    SchoolPerformance = GetScoreValue("SchoolPerformance", datarowCustomDocumentSubstanceUses);
                    if (SchoolPerformance.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["SchoolPerformanceComment"]);
                        ModifyNeeds(documentVersionId, EdudomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(EdudomainNeedId, documentVersionId, dataSetMHA);
                    }
                    needDescriptionSubstanceUses = string.Empty;
                    Personal = GetScoreValue("HomePerformance", datarowCustomDocumentSubstanceUses);
                    if (Personal.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["HomePerfomanceComment"]);
                        ModifyNeeds(documentVersionId, PerdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(PerdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    needDescriptionSubstanceUses = string.Empty;
                    Employment = GetScoreValue("CommunityPerformance", datarowCustomDocumentSubstanceUses);
                    if (Employment.Trim() == "Y")
                    {

                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["CommunityPerformanceComment"]);
                        ModifyNeeds(documentVersionId, OppodomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(OppodomainNeedId, documentVersionId, dataSetMHA);
                    }
                    needDescriptionSubstanceUses = string.Empty;
                    Support = GetScoreValue("BehaviorTowardsOther", datarowCustomDocumentSubstanceUses);
                    if (Support.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["BehaviorTowardsOtherComment"]);
                        ModifyNeeds(documentVersionId, SupportdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(SupportdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    needDescriptionSubstanceUses = string.Empty;
                    Work = GetScoreValue("MoodsEmotion", datarowCustomDocumentSubstanceUses);
                    if (Work.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["MoodsEmotionComment"]);
                        ModifyNeeds(documentVersionId, WorkdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(WorkdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    needDescriptionSubstanceUses = string.Empty;
                    GainfulEmpB = GetScoreValue("SelfHarmfulBehavior", datarowCustomDocumentSubstanceUses);
                    if (GainfulEmpB.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["SelfHarmfulBehaviorComment"]);
                        ModifyNeeds(documentVersionId, GaindomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(GaindomainNeedId, documentVersionId, dataSetMHA);
                    }

                    GainfulEmp = GetScoreValue("Thinkng", datarowCustomDocumentSubstanceUses);
                    if (GainfulEmp.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        needDescriptionSubstanceUses += Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["ThinkngComment"]);
                        ModifyNeeds(documentVersionId, ThinkingNeedId, needDescriptionSubstanceUses, dataSetMHA);

                    }
                    else
                    {
                        DeleteMHANeeds(ThinkingNeedId, documentVersionId, dataSetMHA);
                    }

                    PrimaryFamilyMaterialNeeds = GetScoreValue("PrimaryFamilyMaterialNeeds", datarowCustomDocumentSubstanceUses);
                    if (PrimaryFamilyMaterialNeeds.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["PrimaryFamilyMaterialNeedsComment"]);
                        ModifyNeeds(documentVersionId, PrimaryNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(PrimaryNeedId, documentVersionId, dataSetMHA);
                    }
                    PrimaryFamilySocialSupport = GetScoreValue("PrimaryFamilySocialSupport", datarowCustomDocumentSubstanceUses);
                    if (PrimaryFamilySocialSupport.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["PrimaryFamilySocialSupportComment"]);
                        ModifyNeeds(documentVersionId, PrimdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(PrimdomainNeedId, documentVersionId, dataSetMHA);
                    }

                    NonCustodialMaterialNeeds = GetScoreValue("NonCustodialMaterialNeeds", datarowCustomDocumentSubstanceUses);
                    if (NonCustodialMaterialNeeds.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["NonCustodialMaterialNeedsComment"]);
                        ModifyNeeds(documentVersionId, NonCldomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(NonCldomainNeedId, documentVersionId, dataSetMHA);
                    }

                    NonCustodialSocialSupport = GetScoreValue("NonCustodialSocialSupport", datarowCustomDocumentSubstanceUses);
                    if (NonCustodialSocialSupport.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["NonCustodialSocialSupportComment"]);
                        ModifyNeeds(documentVersionId, CludomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(CludomainNeedId, documentVersionId, dataSetMHA);
                    }

                    SurrogateMaterialNeeds = GetScoreValue("SurrogateMaterialNeeds", datarowCustomDocumentSubstanceUses);
                    if (SurrogateMaterialNeeds.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = string.Empty;
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["SurrogateMaterialNeedsComment"]);
                        ModifyNeeds(documentVersionId, SurgdomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(SurgdomainNeedId, documentVersionId, dataSetMHA);
                    }
                    needDescriptionSubstanceUses = string.Empty;
                    SurrogateSocialSupport = GetScoreValue("SurrogateSocialSupport", datarowCustomDocumentSubstanceUses);
                    if (SurrogateSocialSupport.Trim() == "Y")
                    {
                        needDescriptionSubstanceUses = Convert.ToString(dataSetMHA.Tables["CustomCAFAS2"].Rows[0]["SurrogateSocialSupportComment"]);
                        ModifyNeeds(documentVersionId, SocialDomainNeedId, needDescriptionSubstanceUses, dataSetMHA);
                    }
                    else
                    {
                        DeleteMHANeeds(SocialDomainNeedId, documentVersionId, dataSetMHA);
                    }


                }
            }
        }
        //private void GetNeedCreationDataForDLA(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        //{
        //    //CustomDocumentSchoolPerformances
        //    DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomDailyLivingActivityScores"];
        //    DataRow[] datarowCustomDocumentSubstanceUses = null;
        //    string needDescriptionSubstanceUses = string.Empty;

        //    if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomDailyLivingActivityScores"], 0))
        //    {
        //        datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
        //        if (datarowCustomDocumentSubstanceUses.Length > 0)
        //        {
        //            AddDLANeeds(documentVersionId, 61, dataSetMHA, 1, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 62, dataSetMHA, 2, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 63, dataSetMHA, 3, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 64, dataSetMHA, 4, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 65, dataSetMHA, 5, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 66, dataSetMHA, 6, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 67, dataSetMHA, 7, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 68, dataSetMHA, 8, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 69, dataSetMHA, 9, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 70, dataSetMHA, 10, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 71, dataSetMHA, 11, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 72, dataSetMHA, 12, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 73, dataSetMHA, 13, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 74, dataSetMHA, 14, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 75, dataSetMHA, 15, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 76, dataSetMHA, 16, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 77, dataSetMHA, 17, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 78, dataSetMHA, 18, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 79, dataSetMHA, 19, datarowCustomDocumentSubstanceUses);
        //            AddDLANeeds(documentVersionId, 80, dataSetMHA, 20, datarowCustomDocumentSubstanceUses);
        //        }
        //    }
        //}
        //private void AddDLANeeds(int documentVersionId, int DomainNeedId, DataSet DataSetMHA, int ActivityId, DataRow[] datarowCustomDocumentSubstanceUses)
        //{
        //    string needDescriptionSubstanceUses = string.Empty;
        //    needDescriptionSubstanceUses = GetDLAScoreValue(datarowCustomDocumentSubstanceUses, ActivityId);
        //    if (!string.IsNullOrEmpty(needDescriptionSubstanceUses))
        //    {
        //        ModifyNeeds(documentVersionId, DomainNeedId, needDescriptionSubstanceUses, DataSetMHA);
        //    }
        //    else
        //    {
        //        DeleteMHANeeds(DomainNeedId, documentVersionId, DataSetMHA);
        //    }

        //}

        private void GetNeedCreationDataForDLA(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        {
            //CustomDocumentSchoolPerformances
            DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomDailyLivingActivityScores"];
            DataRow[] datarowCustomDocumentSubstanceUses = null;
            string needDescriptionSubstanceUses = string.Empty;

            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomDailyLivingActivityScores"], 0))
            {
                datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
                if (datarowCustomDocumentSubstanceUses.Length > 0)
                {
                    DataRow[] ActivityId1 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=1");
                    if (ActivityId1.Length > 0)
                        AddDLANeeds(documentVersionId, 561, dataSetMHA, 1, datarowCustomDocumentSubstanceUses, ActivityId1[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId2 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=2");
                    if (ActivityId2.Length > 0)
                        AddDLANeeds(documentVersionId, 562, dataSetMHA, 2, datarowCustomDocumentSubstanceUses, ActivityId2[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId3 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=3");
                    if (ActivityId3.Length > 0)
                        AddDLANeeds(documentVersionId, 563, dataSetMHA, 3, datarowCustomDocumentSubstanceUses, ActivityId3[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId4 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=4");
                    if (ActivityId4.Length > 0)
                        AddDLANeeds(documentVersionId, 564, dataSetMHA, 4, datarowCustomDocumentSubstanceUses, ActivityId4[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId5 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=5");
                    if (ActivityId5.Length > 0)
                        AddDLANeeds(documentVersionId, 565, dataSetMHA, 5, datarowCustomDocumentSubstanceUses, ActivityId5[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId6 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=6");
                    if (ActivityId6.Length > 0)
                        AddDLANeeds(documentVersionId, 566, dataSetMHA, 6, datarowCustomDocumentSubstanceUses, ActivityId6[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId7 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=7");
                    if (ActivityId7.Length > 0)
                        AddDLANeeds(documentVersionId, 567, dataSetMHA, 7, datarowCustomDocumentSubstanceUses, ActivityId7[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId8 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=8");
                    if (ActivityId8.Length > 0)
                        AddDLANeeds(documentVersionId, 568, dataSetMHA, 8, datarowCustomDocumentSubstanceUses, ActivityId8[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId9 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=9");
                    if (ActivityId9.Length > 0)
                        AddDLANeeds(documentVersionId, 569, dataSetMHA, 9, datarowCustomDocumentSubstanceUses, ActivityId9[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId10 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=10");
                    if (ActivityId10.Length > 0)
                        AddDLANeeds(documentVersionId, 570, dataSetMHA, 10, datarowCustomDocumentSubstanceUses, ActivityId10[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId11 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=11");
                    if (ActivityId11.Length > 0)
                        AddDLANeeds(documentVersionId, 571, dataSetMHA, 11, datarowCustomDocumentSubstanceUses, ActivityId11[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId12 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=12");
                    if (ActivityId12.Length > 0)
                        AddDLANeeds(documentVersionId, 572, dataSetMHA, 12, datarowCustomDocumentSubstanceUses, ActivityId12[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId13 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=13");
                    if (ActivityId13.Length > 0)
                        AddDLANeeds(documentVersionId, 573, dataSetMHA, 13, datarowCustomDocumentSubstanceUses, ActivityId13[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId14 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=14");
                    if (ActivityId14.Length > 0)
                        AddDLANeeds(documentVersionId, 574, dataSetMHA, 14, datarowCustomDocumentSubstanceUses, ActivityId14[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId15 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=15");
                    if (ActivityId15.Length > 0)
                        AddDLANeeds(documentVersionId, 575, dataSetMHA, 15, datarowCustomDocumentSubstanceUses, ActivityId15[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId16 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=16");
                    if (ActivityId16.Length > 0)
                        AddDLANeeds(documentVersionId, 576, dataSetMHA, 16, datarowCustomDocumentSubstanceUses, ActivityId16[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId17 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=17");
                    if (ActivityId17.Length > 0)
                        AddDLANeeds(documentVersionId, 577, dataSetMHA, 17, datarowCustomDocumentSubstanceUses, ActivityId17[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId18 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=18");
                    if (ActivityId18.Length > 0)
                        AddDLANeeds(documentVersionId, 578, dataSetMHA, 18, datarowCustomDocumentSubstanceUses, ActivityId18[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId19 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=19");
                    if (ActivityId19.Length > 0)
                        AddDLANeeds(documentVersionId, 579, dataSetMHA, 19, datarowCustomDocumentSubstanceUses, ActivityId19[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId20 = datatableCustomDocumentSubstanceUses.Select("HRMActivityId=20");
                    if (ActivityId20.Length > 0)
                        AddDLANeeds(documentVersionId, 580, dataSetMHA, 20, datarowCustomDocumentSubstanceUses, ActivityId20[0]["ActivityScore"].ToString());
                }
            }
        }

        private void GetNeedCreationDataForDLAYouth(int documentVersionId, DataSet dataSetMHA, DataTable DataTableMHANeedDescription)
        {
            //CustomDocumentSchoolPerformances
            DataTable datatableCustomDocumentSubstanceUses = dataSetMHA.Tables["CustomYouthDLAScores"];
            DataRow[] datarowCustomDocumentSubstanceUses = null;
            string needDescriptionSubstanceUses = string.Empty;

            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CustomYouthDLAScores"], 0))
            {
                datarowCustomDocumentSubstanceUses = datatableCustomDocumentSubstanceUses.Select("DocumentVersionId=" + documentVersionId);
                if (datarowCustomDocumentSubstanceUses.Length > 0)
                {
                    DataRow[] ActivityId1 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=1");
                    if (ActivityId1.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 581, dataSetMHA, 1, datarowCustomDocumentSubstanceUses, ActivityId1[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId2 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=2");
                    if (ActivityId2.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 582, dataSetMHA, 2, datarowCustomDocumentSubstanceUses, ActivityId2[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId3 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=3");
                    if (ActivityId3.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 583, dataSetMHA, 3, datarowCustomDocumentSubstanceUses, ActivityId3[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId4 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=4");
                    if (ActivityId4.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 584, dataSetMHA, 4, datarowCustomDocumentSubstanceUses, ActivityId4[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId5 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=5");
                    if (ActivityId5.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 585, dataSetMHA, 5, datarowCustomDocumentSubstanceUses, ActivityId5[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId6 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=6");
                    if (ActivityId6.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 586, dataSetMHA, 6, datarowCustomDocumentSubstanceUses, ActivityId6[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId7 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=7");
                    if (ActivityId7.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 587, dataSetMHA, 7, datarowCustomDocumentSubstanceUses, ActivityId7[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId8 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=8");
                    if (ActivityId8.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 588, dataSetMHA, 8, datarowCustomDocumentSubstanceUses, ActivityId8[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId9 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=9");
                    if (ActivityId9.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 589, dataSetMHA, 9, datarowCustomDocumentSubstanceUses, ActivityId9[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId10 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=10");
                    if (ActivityId10.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 590, dataSetMHA, 10, datarowCustomDocumentSubstanceUses, ActivityId10[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId11 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=11");
                    if (ActivityId11.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 591, dataSetMHA, 11, datarowCustomDocumentSubstanceUses, ActivityId11[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId12 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=12");
                    if (ActivityId12.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 592, dataSetMHA, 12, datarowCustomDocumentSubstanceUses, ActivityId12[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId13 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=13");
                    if (ActivityId13.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 593, dataSetMHA, 13, datarowCustomDocumentSubstanceUses, ActivityId13[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId14 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=14");
                    if (ActivityId14.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 594, dataSetMHA, 14, datarowCustomDocumentSubstanceUses, ActivityId14[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId15 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=15");
                    if (ActivityId15.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 595, dataSetMHA, 15, datarowCustomDocumentSubstanceUses, ActivityId15[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId16 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=16");
                    if (ActivityId16.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 596, dataSetMHA, 16, datarowCustomDocumentSubstanceUses, ActivityId16[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId17 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=17");
                    if (ActivityId17.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 597, dataSetMHA, 17, datarowCustomDocumentSubstanceUses, ActivityId17[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId18 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=18");
                    if (ActivityId18.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 598, dataSetMHA, 18, datarowCustomDocumentSubstanceUses, ActivityId18[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId19 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=19");
                    if (ActivityId19.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 599, dataSetMHA, 19, datarowCustomDocumentSubstanceUses, ActivityId19[0]["ActivityScore"].ToString());
                    DataRow[] ActivityId20 = datatableCustomDocumentSubstanceUses.Select("DailyLivingActivityId=20");
                    if (ActivityId20.Length > 0)
                        AddDLAYouthNeeds(documentVersionId, 600, dataSetMHA, 20, datarowCustomDocumentSubstanceUses, ActivityId20[0]["ActivityScore"].ToString());
                }
            }
        }

        private void AddDLANeeds(int documentVersionId, int DomainNeedId, DataSet DataSetMHA, int ActivityId, DataRow[] datarowCustomDocumentSubstanceUses, string ActivityScore)
        {
            string needDescriptionSubstanceUses = string.Empty;
            int ActivityScores = 0;
            if (ActivityScore == "")
            {
                ActivityScores = 0;
            }
            else
            {
                ActivityScores = Convert.ToInt32(ActivityScore);
            }
            needDescriptionSubstanceUses = GetDLAScoreValue(datarowCustomDocumentSubstanceUses, ActivityId);
            if (!string.IsNullOrEmpty(needDescriptionSubstanceUses) || (ActivityScores <= 4 && ActivityScores != 0))
            {
                ModifyNeedsNew(documentVersionId, DomainNeedId, needDescriptionSubstanceUses, DataSetMHA, ActivityScores);
            }
            else
            {
                DeleteMHANeeds(DomainNeedId, documentVersionId, DataSetMHA);
            }

        }
        
        private void AddDLAYouthNeeds(int documentVersionId, int DomainNeedId, DataSet DataSetMHA, int ActivityId, DataRow[] datarowCustomDocumentSubstanceUses, string ActivityScore)
        {
            string needDescriptionSubstanceUses = string.Empty;
            int ActivityScores = 0;
            if (ActivityScore == "")
            {
                ActivityScores = 0;
            }
            else
            {
                ActivityScores = Convert.ToInt32(ActivityScore);
            }
            needDescriptionSubstanceUses = GetDLAYouthScoreValue(datarowCustomDocumentSubstanceUses, ActivityId);
            if (!string.IsNullOrEmpty(needDescriptionSubstanceUses) || (ActivityScores <= 4 && ActivityScores != 0))
            {
                ModifyNeedsNew(documentVersionId, DomainNeedId, needDescriptionSubstanceUses, DataSetMHA, ActivityScores);
            }
            else
            {
                DeleteMHANeeds(DomainNeedId, documentVersionId, DataSetMHA);
            }

        }

        private void ModifyNeedsNew(int documentVersionId, int DomainNeedId, string NeedDescrition, DataSet DataSetMHA, int Score)
        {
            if (Score <= 4)//NeedDescrition != string.Empty || 
            {
                if (CheckMHANeedExists(DomainNeedId, documentVersionId, DataSetMHA))
                {
                    UpdateMHANeeds(DomainNeedId, NeedDescrition, documentVersionId, DataSetMHA);
                }
                else
                {
                    AddMHANeeds(DomainNeedId, NeedDescrition, documentVersionId, DataSetMHA);
                }

            }
            else
            {
                DeleteMHANeeds(DomainNeedId, documentVersionId, DataSetMHA);

            }
        }


        private void DeleteMHANeeds(int domainNeedId, int documentVersionId, DataSet dataSetMHA)
        {
            DataTable datatableNeeds = dataSetMHA.Tables["CarePlanNeeds"];
            DataRow[] datarowDeleteNeed = null;
            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CarePlanNeeds"], 0))
            {
                datarowDeleteNeed = datatableNeeds.Select("CarePlanDomainNeedId=" + domainNeedId + " And  DocumentVersionId=" + documentVersionId);
                if (datarowDeleteNeed.Length > 0)
                {
                    foreach (DataRow datarowNeed in datarowDeleteNeed)
                    {
                        datarowNeed["RecordDeleted"] = "Y";
                        SHS.BaseLayer.BaseCommonFunctions.UpdateRecordDeletedInformation(datarowNeed);
                    }
                }
            }
        }

        private string GetDLAYouthScoreValue(DataRow[] dataRow, int HRMActivityId)
        {
            int ScoreValue = 0;
            String MetExpectation = string.Empty;
            if (dataRow.Length > 0)
            {
                for (int k = 0; k < dataRow.Length; k++)
                {
                    int ActivityId = 0;
                    int.TryParse(Convert.ToString(dataRow[k]["DailyLivingActivityId"]), out ActivityId);
                    if (ActivityId == HRMActivityId)
                    {
                        if (Convert.ToString(dataRow[k]["ActivityScore"]) != string.Empty)
                        {
                            int.TryParse(Convert.ToString(dataRow[k]["ActivityScore"]), out ScoreValue);
                            if (ScoreValue <= 4)
                            {
                                if (Convert.ToString(dataRow[k]["ActivityComment"]) != string.Empty)
                                {
                                    MetExpectation = Convert.ToString(dataRow[k]["ActivityComment"]);
                                }
                            }

                        }
                    }
                }
            }
            return MetExpectation;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="domainNeedId"></param>
        /// <param name="documentVersionId"></param>
        /// <param name="dataSetMHA"></param>
        /// <returns></returns>
        private bool CheckMHANeedExists(int domainNeedId, int documentVersionId, DataSet dataSetMHA)
        {
            bool isExists = false;
            DataTable datatableNeedsExists = dataSetMHA.Tables["CarePlanNeeds"];
            DataRow[] datarowNeedExists = null;
            if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CarePlanNeeds"], 0))
            {
                datarowNeedExists = datatableNeedsExists.Select("CarePlanDomainNeedId=" + domainNeedId + " And  DocumentVersionId=" + documentVersionId);
                if (datarowNeedExists.Length > 0)
                {
                    isExists = true;
                }
            }
            return isExists;
        }
        /// <summary>
        ///<Author>Jagdeep Hundal</Author>
        ///<CreatedOn>Feb 21,2012</CreatedOn>
        ///<Description>This function is used to get need text on thre basis of domainNeedId and NeedTypeId.
        /// </summary>
        /// <param name=""></param>
        private string GetMHANeedDescriptionbyDomainId(int NeedTypeId, int domainNeedId, DataTable DataTableMHANeedDescription)
        {
            string NeedDescription = string.Empty;
            if (DataTableMHANeedDescription != null && DataTableMHANeedDescription.Rows.Count > 0)
            {
                DataRow[] DataRowMHANeedDescription = DataTableMHANeedDescription.Select("DomainNeedId=" + domainNeedId + " and NeedTypeId=" + NeedTypeId);
                if (DataRowMHANeedDescription.Length > 0)
                {
                    NeedDescription = Convert.ToString(DataRowMHANeedDescription[0]["Description"]);
                }
            }
            return NeedDescription;
        }

        /// <summary>
        ///<Author>Jagdeep Hundal</Author>
        ///<CreatedOn>Jan 16,2012</CreatedOn>
        ///<Description>This function is used to get CodeName and domainNeedId  from globalcodes
        /// </summary>
        /// <param name=""></param>
        private string GetCodeNameandDomainNeedIdfromGlobalCodes(string category, int globalCodeId, out int domainNeedId)
        {
            string CodeName = string.Empty;
            domainNeedId = 0;
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables != null && SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
            {
                DataRow[] DataRowGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes.Select("Category='" + category + "' and GlobalCodeId=" + globalCodeId + " and ISNULL(RecordDeleted, 'N') = 'N'");
                if (DataRowGlobalCodes.Length > 0)
                {
                    CodeName = Convert.ToString(DataRowGlobalCodes[0]["CodeName"]);
                    if (Convert.ToString(DataRowGlobalCodes[0]["ExternalCode2"]) != string.Empty)
                    {
                        domainNeedId = Convert.ToInt32(Convert.ToString(DataRowGlobalCodes[0]["ExternalCode2"]));
                    }
                }
            }
            return CodeName;
        }
        /// <summary>
        ///<Author>Jagdeep Hundal</Author>
        ///<CreatedOn>Jan 16,2012</CreatedOn>
        ///<Description>This function is used to update CarePlanDomainNeeds dataset for need creation data of MHAssessment 
        /// </summary>
        /// <param name=""></param>
        private void AddMHANeeds(int domainNeedId, string needDescription, int documentVersionId, DataSet dataSetMHA)
        {
            if (domainNeedId > 0)
            {
                DataRow drCustomCarePlanNeeds = null;
                int DomainId = 0;
                string needName = string.Empty;
                if (dataSetMHA.Tables.Contains("CarePlanDomainNeeds"))
                {
                    DataRow[] datarowDomainNeed = dataSetMHA.Tables["CarePlanDomainNeeds"].Select(string.Format("CarePlanDomainNeedId={0}", domainNeedId));
                    if (datarowDomainNeed.Length > 0)
                    {
                        needName = Convert.ToString(datarowDomainNeed[0]["NeedName"]);
                        if (Convert.ToString(datarowDomainNeed[0]["CarePlanDomainId"]) != string.Empty)
                        {
                            DomainId = Convert.ToInt32(datarowDomainNeed[0]["CarePlanDomainId"]);
                        }
                    }
                }
                if (DomainId > 0)
                {
                    drCustomCarePlanNeeds = dataSetMHA.Tables["CarePlanNeeds"].NewRow();
                    drCustomCarePlanNeeds.BeginEdit();
                    drCustomCarePlanNeeds["CarePlanDomainNeedId"] = Convert.ToInt32(domainNeedId);
                    drCustomCarePlanNeeds["DocumentVersionId"] = documentVersionId;
                    drCustomCarePlanNeeds["AddressOnCarePlan"] = DBNull.Value;
                    drCustomCarePlanNeeds["NeedName"] = needName;
                    //drCustomCarePlanNeeds["DomainId"] = DomainId;
                    drCustomCarePlanNeeds["NeedDescription"] = needDescription.Trim();
                    drCustomCarePlanNeeds["Source"] = "M";
                    drCustomCarePlanNeeds["SourceName"] = "MHA";
                    SHS.BaseLayer.BaseCommonFunctions.InitRowCredentials(drCustomCarePlanNeeds);
                    drCustomCarePlanNeeds.EndEdit();
                    dataSetMHA.Tables["CarePlanNeeds"].Rows.Add(drCustomCarePlanNeeds);
                }
            }
        }
        /// <summary>
        ///<Author>Jagdeep Hundal</Author>
        ///<CreatedOn>Jan 16,2012</CreatedOn>
        ///<Description>This function is used to update CarePlanDomainNeeds dataset for need creation data of MHAssessment 
        /// </summary>
        /// <param name=""></param>
        private void UpdateMHANeeds(int domainNeedId, string needDescription, int documentVersionId, DataSet dataSetMHA)
        {
            if (domainNeedId > 0)
            {
                int DomainId = 0;
                string needName = string.Empty;
                if (dataSetMHA.Tables.Contains("CarePlanDomainNeeds"))
                {
                    DataRow[] datarowDomainNeed = dataSetMHA.Tables["CarePlanDomainNeeds"].Select(string.Format("CarePlanDomainNeedId={0}", domainNeedId));
                    if (datarowDomainNeed.Length > 0)
                    {
                        needName = Convert.ToString(datarowDomainNeed[0]["NeedName"]);
                        if (Convert.ToString(datarowDomainNeed[0]["CarePlanDomainId"]) != string.Empty)
                        {
                            DomainId = Convert.ToInt32(datarowDomainNeed[0]["CarePlanDomainId"]);
                        }
                    }
                }
                if (DomainId > 0)
                {
                    DataTable datatableNeedsUpdate = dataSetMHA.Tables["CarePlanNeeds"];
                    DataRow datarowUpdateNeedDiscription = null;
                    if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CarePlanNeeds"], 0))
                    {
                        datarowUpdateNeedDiscription = datatableNeedsUpdate.Select("CarePlanDomainNeedId=" + domainNeedId + " And  DocumentVersionId=" + documentVersionId)[0];
                        if (datarowUpdateNeedDiscription != null)
                        {
                            datarowUpdateNeedDiscription["NeedDescription"] = needDescription.Trim();
                        }
                    }
                }
            }
        }
        /// <summary>
        ///<Author>Jagdeep Hundal</Author>
        ///<CreatedOn>Jan 16,2012</CreatedOn>
        ///<Description>This function is used to update RecordDeleted='Y' in CarePlanDomainNeeds dataset for need creation data of MHAssessment 
        /// </summary>
        /// <param name=""></param>
        //private void DeleteMHANeeds(int domainNeedId, int documentVersionId, DataSet dataSetMHA)
        //{
        //    DataTable datatableNeeds = dataSetMHA.Tables["CarePlanNeeds"];
        //    DataRow[] datarowDeleteNeed = null;
        //    if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetMHA.Tables["CarePlanNeeds"], 0))
        //    {
        //        datarowDeleteNeed = datatableNeeds.Select("CarePlanDomainNeedId=" + domainNeedId + " And  DocumentVersionId=" + documentVersionId);
        //        if (datarowDeleteNeed.Length > 0)
        //        {
        //            foreach (DataRow datarowNeed in datarowDeleteNeed)
        //            {
        //                datarowNeed["RecordDeleted"] = "Y";
        //                SHS.BaseLayer.BaseCommonFunctions.UpdateRecordDeletedInformation(datarowNeed);
        //            }
        //        }
        //    }
        //}
        private void ModifyNeeds(int documentVersionId, int DomainNeedId, string NeedDescrition, DataSet DataSetMHA)
        {
            if (NeedDescrition != string.Empty)
            {
                if (CheckMHANeedExists(DomainNeedId, documentVersionId, DataSetMHA))
                {
                    UpdateMHANeeds(DomainNeedId, NeedDescrition, documentVersionId, DataSetMHA);
                }
                else
                {
                    AddMHANeeds(DomainNeedId, NeedDescrition, documentVersionId, DataSetMHA);
                }

            }
            else
            {
                DeleteMHANeeds(DomainNeedId, documentVersionId, DataSetMHA);

            }
        }
        #endregion
    }
}
