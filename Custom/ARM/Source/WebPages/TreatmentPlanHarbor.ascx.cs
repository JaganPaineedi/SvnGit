using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;



namespace SHS.SmartCare
{
    public partial class ActivityPages_Client_Detail_HarborTreatmentPlan_TreatmentPlanHarbor : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
    {

        #region Variable/Object Declaration

        #endregion

        public override void BindControls()
        {
            UserControl_UCTxPlan.Activate();
        }

        public override string PageDataSetName
        {
            get { return "DataSetHarborTreatmentPlan"; }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                return new string[] { "CustomTreatmentPlans", "CustomTPGoals" };
            }
        }

        public DataSet GetTreatmentPlanInitial_2(int ClientId, Int32 StaffId, Int32 DocumentVersionId)
        {
            SqlParameter[] _objectSqlParmeters = null;
            DataSet dataSetTreatmentPlan = null;
            _objectSqlParmeters = new SqlParameter[3];

            _objectSqlParmeters[0] = new SqlParameter("@ClientId", ClientId);
            _objectSqlParmeters[1] = new SqlParameter("@StaffId", StaffId);
            //_objectSqlParmeters[2] = new SqlParameter("@CalledFrom", TreatmentPlan);
            _objectSqlParmeters[2] = new SqlParameter("@CurrentDocumentVersionId", DocumentVersionId);
            dataSetTreatmentPlan = new DataSet();
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_ScwebInitializeTreatmentPlanWithCustomTPNeeds", dataSetTreatmentPlan, new string[] { "CustomTPNeeds", "CustomTPQuickObjectives", "CustomTPGoalNeeds", "CustomTPObjectives", "CustomTPServices" }, _objectSqlParmeters); //"CustomTPQuickObjectives",
            return dataSetTreatmentPlan;

        }

        public override void ChangeInitializedDataSet(ref DataSet dataSetObject)
        {
            //base.ChangeInitializedDataSet(ref dataSetObject);


            int DocumentVersionId = Convert.ToInt32(dataSetObject.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"].ToString());

            //using (SHS.UserBusinessServices.HarborTreatmentPlan objHarborTreatmentPlan = new SHS.UserBusinessServices.HarborTreatmentPlan())
            //{
                int staffId = BaseCommonFunctions.GetUserIdInCaseOfMultipleDataBase();
                DataSet dataSetTreatmentPlan = GetTreatmentPlanInitial_2(BaseCommonFunctions.ApplicationInfo.Client.ClientId, staffId, DocumentVersionId);
                if (dataSetTreatmentPlan != null)
                {

                    if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlan, "CustomTPNeeds", 0))
                    {

                        //dataSetObject.Tables["CustomTPGoalNeeds"].Clear();
                        //dataSetObject.Tables["CustomTPNeeds"].Clear();
                        //try
                        //{
                        //    if (dataSetTreatmentPlan.Tables["CustomTPNeeds"] != null)
                        //        dataSetObject.Tables["CustomTPNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPNeeds"], true, MissingSchemaAction.Ignore);
                        //}
                        //catch
                        //{
                        //    if (dataSetTreatmentPlan.Tables["CustomTPNeeds"] != null)
                        //        dataSetObject.Tables["CustomTPNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPNeeds"], true, MissingSchemaAction.Ignore);
                        //}

                        //try
                        //{
                        //    if (dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"] != null)
                        //        dataSetObject.Tables["CustomTPGoalNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"], true, MissingSchemaAction.Ignore);
                        //}
                        //catch
                        //{
                        //    if (dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"] != null)
                        //        dataSetObject.Tables["CustomTPGoalNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"], true, MissingSchemaAction.Ignore);
                        //}

                       
                        //foreach (DataRow dr in dataSetObject.Tables["CustomTPGoalNeeds"].Rows)
                        //{
                        //    //if(Convert.ToInt32(dr[0])<0)
                        //    dr.SetAdded();

                        //}

                    }
                    try
                    {
                        if (dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"] != null)
                        {
                            dataSetObject.Tables["CustomTPQuickObjectives"].Clear();
                            dataSetObject.Tables["CustomTPQuickObjectives"].Merge(dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"], true, MissingSchemaAction.Ignore);
                        }
                    }
                    catch
                    {
                        if (dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"] != null)
                        {
                            dataSetObject.Tables["CustomTPQuickObjectives"].Clear();
                            dataSetObject.Tables["CustomTPQuickObjectives"].Merge(dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"], true, MissingSchemaAction.Ignore);
                        }
                    }

                    //try
                    //{
                    //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"] != null)
                    //    {
                    //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Clear();
                    //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"], true, MissingSchemaAction.Ignore);
                    //    }
                    //}
                    //catch
                    //{
                    //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"] != null)
                    //    {
                    //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Clear();
                    //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"], true, MissingSchemaAction.Ignore);
                    //    }
                    //}
                    dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].AcceptChanges();
                    dataSetObject.Tables["CustomTPGlobalQuickGoals"].AcceptChanges();
                    //try
                    //{
                    //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"] != null)
                    //    {
                    //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Clear();
                    //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"], true, MissingSchemaAction.Ignore);
                    //    }
                    //}
                    //catch
                    //{
                    //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"] != null)
                    //    {
                    //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Clear();
                    //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"], true, MissingSchemaAction.Ignore);
                    //    }
                    //}

                }

                //if (dataSetObject.Tables.Contains("CustomTPNeeds"))
                //{
                //    dataSetObject.Tables["CustomTPNeeds"].AcceptChanges();
                //}

                if (!BaseCommonFunctions.CheckRowExists(dataSetObject, "CustomTPGoals", 0))
                {
                    DataRow drCustomNeed = dataSetObject.Tables["CustomTPGoals"].NewRow();
                    drCustomNeed["TPGoalId"] = -1;
                    drCustomNeed["DocumentVersionId"] = dataSetObject.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"];
                    drCustomNeed["GoalNumber"] = 1;
                    drCustomNeed["TargeDate"] = DateTime.Now.AddYears(1);
                    BaseCommonFunctions.InitRowCredentials(drCustomNeed);

                    dataSetObject.Tables["CustomTPGoals"].Rows.Add(drCustomNeed);

                }
            //}
        }

        public override void ChangeDataSetAfterGetData()
        {
            DataSet ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            base.ChangeDataSetAfterGetData();

           
            //using (SHS.UserBusinessServices.HarborTreatmentPlan objHarborTreatmentPlan = new SHS.UserBusinessServices.HarborTreatmentPlan())
            //{
                int staffId = BaseCommonFunctions.GetUserIdInCaseOfMultipleDataBase();

                using (DataSet dataSetObject = BaseCommonFunctions.GetScreenInfoDataSet())
                {
                    int DocumentVersionId = Convert.ToInt32(dataSetObject.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"].ToString());

                    DataSet dataSetTreatmentPlan = GetTreatmentPlanInitial_2(BaseCommonFunctions.ApplicationInfo.Client.ClientId, staffId, DocumentVersionId);

                    if (dataSetTreatmentPlan != null)
                    {

                        //if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlan, "CustomTPNeeds", 0))
                        //{
                        /*
                        //dataSetObject.Tables["CustomTPGoalNeeds"].Clear();
                        //dataSetObject.Tables["CustomTPNeeds"].Clear();

                        try
                        {
                            dataSetObject.Merge(dataSetTreatmentPlan, true, MissingSchemaAction.Ignore);
                        }


                        catch
                        {
                            dataSetObject.Merge(dataSetTreatmentPlan, true, MissingSchemaAction.Ignore);
                        }
                         */

                        if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlan, "CustomTPNeeds", 0))
                        {
                            try
                            {
                                if (dataSetTreatmentPlan.Tables["CustomTPNeeds"] != null)
                                    dataSetObject.Tables["CustomTPNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPNeeds"], true, MissingSchemaAction.Ignore);
                            }
                            catch
                            {
                                if (dataSetTreatmentPlan.Tables["CustomTPNeeds"] != null)
                                    dataSetObject.Tables["CustomTPNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPNeeds"], true, MissingSchemaAction.Ignore);
                            }

                            //try
                            //{
                            //    if (dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"] != null)
                            //        dataSetObject.Tables["CustomTPGoalNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"], true, MissingSchemaAction.Ignore);
                            //}
                            //catch
                            //{
                            //    if (dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"] != null)
                            //        dataSetObject.Tables["CustomTPGoalNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"], true, MissingSchemaAction.Ignore);
                            //}

                            if (Convert.ToInt32(dataSetObject.Tables["Documents"].Rows[0]["DocumentId"]) == 0)
                            {
                                foreach (DataRow dr in dataSetObject.Tables["CustomTPGoalNeeds"].Rows)
                                {
                                    dr.AcceptChanges();
                                    dr.SetAdded();
                                }
                            }
                        }
                        try
                        {
                            if (dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"] != null)
                            {
                                dataSetObject.Tables["CustomTPQuickObjectives"].Clear();
                                dataSetObject.Tables["CustomTPQuickObjectives"].Merge(dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"], true, MissingSchemaAction.Ignore);
                            }
                        }
                        catch
                        {
                            if (dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"] != null)
                            {
                                dataSetObject.Tables["CustomTPQuickObjectives"].Clear();
                                dataSetObject.Tables["CustomTPQuickObjectives"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"], true, MissingSchemaAction.Ignore);
                            }
                        }
                        //try
                        //{
                        //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"] != null)
                        //    {
                        //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Clear();
                        //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"], true, MissingSchemaAction.Ignore);
                        //    }
                        //}
                        //catch
                        //{
                        //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"] != null)
                        //    {
                        //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Clear();
                        //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"], true, MissingSchemaAction.Ignore);
                        //    }
                        //}
                        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].AcceptChanges();
                        dataSetObject.Tables["CustomTPGlobalQuickGoals"].AcceptChanges();
                        //try
                        //{
                        //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"] != null)
                        //    {
                        //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Clear();
                        //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"], true, MissingSchemaAction.Ignore);
                        //    }
                        //}
                        //catch
                        //{
                        //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"] != null)
                        //    {
                        //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Clear();
                        //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"], true, MissingSchemaAction.Ignore);
                        //    }
                        //}
                        
                    }
                    //}

                    foreach (DataRow dr in dataSetObject.Tables["CustomTPNeeds"].Rows)
                    {
                        if (Convert.ToInt32(dr[0]) > 0 && dr.RowState == DataRowState.Added)
                        {
                            dr.AcceptChanges();
                            dr.SetModified();
                        }
                    }

                    //if (dataSetObject.Tables.Contains("CustomTPNeeds"))
                    //{
                    //    dataSetObject.Tables["CustomTPNeeds"].AcceptChanges();
                    //}
                }


                //using (DataSet dataSetObject = BaseCommonFunctions.GetScreenInfoDataSet())
                //    if (dataSetObject.Tables.Contains("CustomTPNeeds"))
                //    {
                //        foreach (DataRow dr in dataSetObject.Tables["CustomTPNeeds"].Rows)
                //        {
                //            if (Convert.ToInt32(dr[0]) > 0)
                //            {
                //                dr.AcceptChanges();
                //            }
                //        }
                //    }
            //}
        }
        /// <summary>
        /// <Author>Rohit Katoch</Author>
        /// <CreatedOn>24th-June-2011</CreatedOn>
        /// <Description>To remove the tables from dataset which need not be saved</Description>
        /// </summary>
        /// <param name="dataSetObject"></param>
        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            if (dataSetObject.Tables.Contains("CurrentDiagnoses"))
                dataSetObject.Tables.Remove("CurrentDiagnoses");
            if (dataSetObject.Tables.Contains("CustomTPQuickObjectives"))
                dataSetObject.Tables.Remove("CustomTPQuickObjectives");
            if (dataSetObject.Tables.Contains("CustomTPGlobalQuickGoals"))
                dataSetObject.Tables.Remove("CustomTPGlobalQuickGoals");
            if (dataSetObject.Tables.Contains("CustomTPGlobalQuickTransitionPlans"))
                dataSetObject.Tables.Remove("CustomTPGlobalQuickTransitionPlans");
            
            if (BaseCommonFunctions.CheckRowExists(dataSetObject, "CustomTPObjectives", 0))
            {
                DataRow[] drTPObjectives = dataSetObject.Tables["CustomTPObjectives"].Select();
                foreach (DataRow row in drTPObjectives)
                {
                    if (row["Status"].ToString() == "")
                    {
                        row["Status"] = 1;
                    }
                }
            }

           // dataSetObject.Tables["CustomTPServices"].Rows[0]["AuthorizationCodeId"]

            if (BaseCommonFunctions.CheckRowExists(dataSetObject, "CustomTPServices", 0))
            {
                DataRow[] drDeletedTPServices = dataSetObject.Tables["CustomTPServices"].Select("isnull(RecordDeleted,'N')='Y' and TPServiceId>0 and isnull(AuthorizationCodeId,-1)=-1");
                foreach (DataRow drTPServices in drDeletedTPServices)
                {
                    if ((drTPServices.RowState == DataRowState.Modified)) //&& Convert.ToString(drTPServices["RecordDeleted"]) == "Y" && (drTPServices["AuthorizationCodeId"]==DBNull.Value || Convert.ToInt32(drTPServices["AuthorizationCodeId"])<=0))
                    {
                        //if (Convert.ToInt32(drTPServices["TPServiceId"]) > 0 && drTPServices.RowState == DataRowState.Modified)
                        //{
                          drTPServices["AuthorizationCodeId"] = drTPServices["AuthorizationCodeId", DataRowVersion.Original];
                        //}
                    }
                }

                DataRow[] dataRowTPServices = dataSetObject.Tables["CustomTPServices"].Select("TPServiceId<=0 and isnull(AuthorizationCodeId,-1)=-1 and isnull(RecordDeleted,'N')='Y'");
                int i = 0;
                while (i<dataRowTPServices.Length)
                {
                    dataSetObject.Tables["CustomTPServices"].Rows.Remove(dataRowTPServices[i]);
                    i++;
                }

                
            }

        }

        public override void CustomAjaxRequest()
        {

            if (GetRequestParameterValue("CustomAjaxRequestType") == "GetCurrentDiagnosis")
            {
                Literal literalStart = new Literal();
                Literal literalHtmlText = new Literal();
                Literal literalEnd = new Literal();
                literalStart.Text = "###StartCurrentDiagnosisUc###";

                DataSet CurrentDiagnosis = new DataSet();
                string CurrentDiagnosisString = string.Empty;
                SqlParameter[] _objectSqlParmeters = null;
                try
                {
                    _objectSqlParmeters = new SqlParameter[1];
                    _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
                    SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "ssp_SCGetCurrentDiagnosis", CurrentDiagnosis, new string[] { "DocumentDiagnosisCodes", "DocumentDiagnosis" }, _objectSqlParmeters);
                    if (CurrentDiagnosis != null)
                    {
                        //PreviousDiagnosisString = PreviosDiagnosis.GetXml().ToString();
                        literalHtmlText.Text = CurrentDiagnosis.GetXml().ToString();
                    }

                }
                finally
                {
                    if (CurrentDiagnosis != null) CurrentDiagnosis.Dispose();
                    _objectSqlParmeters = null;
                }
                literalEnd.Text = "###EndCurrentDiagnosisUc###";
                PanelLoadUC.Controls.Add(literalStart);
                PanelLoadUC.Controls.Add(literalHtmlText);
                PanelLoadUC.Controls.Add(literalEnd);
            }


        }
    }
}