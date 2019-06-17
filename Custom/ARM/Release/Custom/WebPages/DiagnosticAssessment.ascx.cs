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

public partial class ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticAssessment : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override string DefaultTab
    {
        get
        {
            return "/Custom/WebPages/DiagnosticPresentingProblem.ascx";
        }
    }

    public override string MultiTabControlName
    {
        get { return "RadMultiPage1"; }
    }
    /// <summary>
    /// <Description>This overridable function inherited from DocumentDataActivityMultiTabPage is used to set the Tab Index</Description>
    /// <Author>Ashwani</Author>
    /// <CreatedOn>27 May 2011</CreatedOn>
    /// </summary>
    public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
    {
        ctlcollection = this.RadMultiPage1.Controls[TabIndex].Controls;
        RadTabStrip1.SelectedIndex = (short)TabIndex;
        RadMultiPage1.SelectedIndex = (short)TabIndex;
        UcPath = RadTabStrip1.Tabs[TabIndex].Attributes["Path"];
    }
    /// <summary>
    /// <Description>This overridable function inherited from DocumentDataActivityMultiTabPage is used to bind controls</Description>
    /// <Author>Jagdeep Hundal</Author>
    /// <CreatedOn>03 June 2011</CreatedOn>
    /// </summary>
    public override void BindControls()
    {
        try
        {
            //Code Comment For DLA... Jagdeep 

            //SHS.UserBusinessServices.DiagnosticAssessment objDiagnosticAssessment = null;
            //objDiagnosticAssessment = new SHS.UserBusinessServices.DiagnosticAssessment();

            //using (DataSet dataSetCustomDiagnosticNeeds = objDiagnosticAssessment.GetCustomDiagnosticNeeds())
            //{
            //    HiddenCustomDiagnosticNeedsDataTable.Value = dataSetCustomDiagnosticNeeds.GetXml();
            //}

            //using (DataSet dataSetCustomDiagnosticAssessmentActivities = objDiagnosticAssessment.GetCustomDiagnosticAssessmentActivities())
            //{
            //    HiddenCustomDiagnosticActivitiesDataTable.Value = dataSetCustomDiagnosticAssessmentActivities.GetXml();
            //}

        }
        finally
        {
        }
    }

    public override string PageDataSetName
    {
        get { return "DataSetDiagnosticAssesmentNew"; }

    }

    public override string[] TablesToBeInitialized
    {
        get { return new string[] { "CustomDocumentDiagnosticAssessments,DiagnosesIII,DiagnosesIV,DiagnosesV,DiagnosesIAndII,DiagnosesIIICodes,DiagnosesIANDIIMaxOrder,CustomDocumentAssessmentNeeds,CustomDocumentAssessmentReferrals,CustomDocumentAssessmentTransferServices,CustomDocumentMentalStatuses,CustomTreatmentPlans,CustomTPGoals,CustomDocumentCrisisInterventionNotes" }; }
    }

    /// <summary>
    /// <Description>This overridable function is used to set the DataSet before updating </Description>
    /// <Author>Ashwani</Author>
    /// <CreatedOn>1 June 2011</CreatedOn>
    /// </summary>
    public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
    {


        if (dataSetObject.Tables.Contains("CustomTPQuickObjectives"))
        {
            dataSetObject.Tables["CustomTPQuickObjectives"].AcceptChanges();
        }
        if (dataSetObject.Tables.Contains("CustomTPGlobalQuickGoals"))
        {
            dataSetObject.Tables["CustomTPGlobalQuickGoals"].AcceptChanges();
        }
        if (dataSetObject.Tables.Contains("CustomTPGlobalQuickTransitionPlans"))
        {
            dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].AcceptChanges();
        }
        //added because CustomTPNeeds were duplicating
        //if (dataSetObject.Tables.Contains("CustomTPNeeds"))
        //{
        //    dataSetObject.Tables["CustomTPNeeds"].AcceptChanges();
        //}

       
        //Added By Rahul Aneja on 4 july 2012 for validate to enter the authorization code in services
        if (dataSetObject.Tables.Contains("CustomTPServices") && dataSetObject.Tables["CustomTPServices"].Rows.Count > 0)
        {
            foreach (DataRow datarowservices in dataSetObject.Tables["CustomTPServices"].Rows)
            {
                //Added By Maninder: 10/9/2012 for Task#1983 in Harbor Go Live

                if ((datarowservices["AuthorizationCodeId"] == DBNull.Value || Convert.ToInt32(datarowservices["AuthorizationCodeId"]) <= 0) && Convert.ToString(datarowservices["RecordDeleted"]) == "Y")
                {
                    if (Convert.ToInt32(datarowservices["TPServiceId"]) < 0)
                    {
                        datarowservices["AuthorizationCodeId"] = -2;   //If -2 then this row needs to be removed;
                    }
                    else
                    {
                        if ((datarowservices.RowState == DataRowState.Modified)) //&& Convert.ToString(drTPServices["RecordDeleted"]) == "Y" && (drTPServices["AuthorizationCodeId"]==DBNull.Value || Convert.ToInt32(drTPServices["AuthorizationCodeId"])<=0))
                        {
                            //if (Convert.ToInt32(drTPServices["TPServiceId"]) > 0 && drTPServices.RowState == DataRowState.Modified)
                            //{
                            datarowservices["AuthorizationCodeId"] = datarowservices["AuthorizationCodeId", DataRowVersion.Original];
                            //}
                        }
                    }
                }

                //Ends
                if (datarowservices["AuthorizationCodeId"] != DBNull.Value && Convert.ToInt32(datarowservices["AuthorizationCodeId"]) != -2 && Convert.ToInt32(datarowservices["AuthorizationCodeId"]) < 0)
                {
                    //Modified By: Amit Kumar Srivastava, #1955, Harbor Go Live Issues, DA Unsaved Changes Issues
                    //throw new CustomExceptionWithMessage("Please select the service authorization code");
                    //throw new CustomExceptionWithMessage("Please enter Authorization code in 'Initial Treatment Plan' Tab for Goal #" + Convert.ToString(Convert.ToString(datarowservices["ServiceNumber"]).Split('.')[0]) + " and Service #" + Convert.ToString(datarowservices["ServiceNumber"]));
                    throw new CustomExceptionWithMessage("Please Select Service in 'Initial Treatment Plan' Tab for Goal #" + Convert.ToString(Convert.ToString(datarowservices["ServiceNumber"]).Split('.')[0]) + " and Service #" + Convert.ToString(datarowservices["ServiceNumber"]));
                    //throw new CustomException("Please select the service authorization code", 0, null);

                }
            }

            DataRow[] drCustomTPServices = dataSetObject.Tables["CustomTPServices"].Select("AuthorizationCodeId=-2");

            for (int i = 0; i < drCustomTPServices.Length; i++)
            {
                if (Convert.ToInt32(drCustomTPServices[i]["AuthorizationCodeId"]) == -2)
                {
                    dataSetObject.Tables["CustomTPServices"].Rows.Remove(drCustomTPServices[i]);
                }
            }

            
        }


        //if (dataSetObject.Tables.Contains("CustomTreatmentPlans") && dataSetObject.Tables.Contains("CustomDocumentDiagnosticAssessments"))
        //{

        //    if (BaseCommonFunctions.CheckRowExists(dataSetObject, "CustomTreatmentPlans", 0) && BaseCommonFunctions.CheckRowExists(dataSetObject, "CustomDocumentDiagnosticAssessments", 0))
        //    {
        //        if (dataSetObject.Tables["CustomTreatmentPlans"].Rows[0]["ClientStrengths"] == DBNull.Value && dataSetObject.Tables["CustomDocumentDiagnosticAssessments"].Rows[0]["ClientStrengths"] != DBNull.Value)
        //        {
        //            dataSetObject.Tables["CustomTreatmentPlans"].Rows[0].BeginEdit();
        //            dataSetObject.Tables["CustomTreatmentPlans"].Rows[0]["ClientStrengths"] = dataSetObject.Tables["CustomDocumentDiagnosticAssessments"].Rows[0]["ClientStrengths"];
        //            BaseCommonFunctions.UpdateModifiedInformation(dataSetObject.Tables["CustomTreatmentPlans"].Rows[0]);
        //            dataSetObject.Tables["CustomTreatmentPlans"].Rows[0].EndEdit();

        //        }
        //    }
        //}

        //Added by Maninder: To Delete CustomDocumentAssessmentNeeds rows if TypeOfAssessment='E'
        if(SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetObject,"CustomDocumentDiagnosticAssessments",0))
        {
            string TypeOfAssessment = Convert.ToString(dataSetObject.Tables["CustomDocumentDiagnosticAssessments"].Rows[0]["TypeOfAssessment"]);
            if (TypeOfAssessment.ToUpper() == "E")
            {
                if (SHS.BaseLayer.BaseCommonFunctions.CheckRowExists(dataSetObject, "CustomDocumentAssessmentNeeds", 0))
                {
                    foreach (DataRow drAssessmentNeeds in dataSetObject.Tables["CustomDocumentAssessmentNeeds"].Rows)
                    {
                        drAssessmentNeeds.BeginEdit();
                        drAssessmentNeeds["RecordDeleted"] = "Y";
                        SHS.BaseLayer.BaseCommonFunctions.UpdateRecordDeletedInformation(drAssessmentNeeds);
                        drAssessmentNeeds.EndEdit();
                    }
                }
            }
        }
        //Ends

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
    }

    public override System.Collections.Generic.List<CustomParameters> customInitializationStoreProcedureParameters
    {
        get
        {

            System.Collections.Generic.List<CustomParameters> t = new List<CustomParameters>();
            string _assessmentType = GetRequestParameterValue("AssessmentScreenType");
            string _currentAuthorId = GetRequestParameterValue("CurrentAuthorId");
            t.Add(new CustomParameters("ScreenType", _assessmentType));
            t.Add(new CustomParameters("CurrentAuthorId", _currentAuthorId));
            return t;
        }
    }


    public override void AfterUpdateProcess(ref DataSet dataSetObject)
    {
        if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["DocumentVersions"].Rows.Count > 0)
        {
            int documentVersionId = Convert.ToInt32(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"]);
            CopyAssessmentNeedsPostUpdate(documentVersionId, BaseCommonFunctions.ApplicationInfo.Client.ClientId, BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode);
        }
    }

    /// <summary>
    /// <Description>This function is used to copy needs from CustomDiagnosticNeeds into CustomTPNeeds </Description>
    /// <Author>Minakshi</Author>
    /// <CreatedOn>July 14,2011</CreatedOn>
    /// </summary>
    private void CopyAssessmentNeedsPostUpdate(int documentVersionId, int clientId, string userCode)
    {
        SHS.UserBusinessServices.DiagnosticAssessment objDiagnosticAssessment;
        objDiagnosticAssessment = new SHS.UserBusinessServices.DiagnosticAssessment();
        objDiagnosticAssessment.CopyAssessmentNeedsPostUpdate(documentVersionId, clientId, userCode);
    }
    public override void ChangeInitializedDataSet(ref DataSet dataSetObject)
    {
        //base.ChangeInitializedDataSet(ref dataSetObject);


        int DocumentVersionId = Convert.ToInt32(dataSetObject.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"].ToString());

        if (GetRequestParameterValue("AssessmentScreenType").ToString() == "U" || GetRequestParameterValue("AssessmentScreenType").Trim()=="")
            return;
        using (SHS.UserBusinessServices.HarborTreatmentPlan objHarborTreatmentPlan = new SHS.UserBusinessServices.HarborTreatmentPlan())
        {
            int staffId = BaseCommonFunctions.GetUserIdInCaseOfMultipleDataBase();

            //DataSet dataSetTreatmentPlan = objHarborTreatmentPlan.GetTreatmentPlanInitial_2(BaseCommonFunctions.ApplicationInfo.Client.ClientId, staffId, "A");

            //if (dataSetTreatmentPlan != null)
            //{

            //    if (BaseCommonFunctions.CheckRowExists(dataSetTreatmentPlan, "CustomTPNeeds", 0))
            //    {

            //        //dataSetObject.Tables["CustomTPGoalNeeds"].Clear();
            //        dataSetObject.Tables["CustomTPNeeds"].Clear();
            //        try
            //        {
            //            if (dataSetTreatmentPlan.Tables["CustomTPNeeds"] != null)
            //                dataSetObject.Tables["CustomTPNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPNeeds"], true, MissingSchemaAction.Ignore);
            //        }
            //        catch
            //        {
            //            if (dataSetTreatmentPlan.Tables["CustomTPNeeds"] != null)
            //                dataSetObject.Tables["CustomTPNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPNeeds"], true, MissingSchemaAction.Ignore);
            //        }

            //        //try
            //        //{
            //        //    if (dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"] != null)
            //        //        dataSetObject.Tables["CustomTPGoalNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"], true, MissingSchemaAction.Ignore);
            //        //}
            //        //catch
            //        //{
            //        //    if (dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"] != null)
            //        //        dataSetObject.Tables["CustomTPGoalNeeds"].Merge(dataSetTreatmentPlan.Tables["CustomTPGoalNeeds"], true, MissingSchemaAction.Ignore);
            //        //}


            //        //foreach (DataRow dr in dataSetObject.Tables["CustomTPGoalNeeds"].Rows)
            //        //{
            //        //    //if(Convert.ToInt32(dr[0])<0)
            //        //    dr.SetAdded();

            //        //}

            //    }
            //    //Code commented by jagdeep to remove CustomTPQuickObjectives from unsaved changes 
            //    //Start
            //    //try
            //    //{
            //    //    if (dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"] != null)
            //    //    {
            //    //        dataSetObject.Tables["CustomTPQuickObjectives"].Clear();
            //    //        dataSetObject.Tables["CustomTPQuickObjectives"].Merge(dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"], true, MissingSchemaAction.Ignore);
            //    //    }
            //    //}
            //    //catch
            //    //{
            //    //    if (dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"] != null)
            //    //    {
            //    //        dataSetObject.Tables["CustomTPQuickObjectives"].Clear();
            //    //        dataSetObject.Tables["CustomTPQuickObjectives"].Merge(dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"], true, MissingSchemaAction.Ignore);
            //    //    }
            //    //}
            //    //End


            //    //try
            //    //{
            //    //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"] != null)
            //    //    {
            //    //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Clear();
            //    //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"], true, MissingSchemaAction.Ignore);
            //    //    }
            //    //}
            //    //catch
            //    //{
            //    //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickTransitionPlans"] != null)
            //    //    {
            //    //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Clear();
            //    //        dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"], true, MissingSchemaAction.Ignore);
            //    //    }
            //    //}

            //    //Code commented by jagdeep to remove CustomTPQuick* from unsaved changes
            //    //dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].AcceptChanges();
            //    //dataSetObject.Tables["CustomTPGlobalQuickGoals"].AcceptChanges();
            //    //end

            //    //try
            //    //{
            //    //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"] != null)
            //    //    {
            //    //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Clear();
            //    //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"], true, MissingSchemaAction.Ignore);
            //    //    }
            //    //}
            //    //catch
            //    //{
            //    //    if (dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"] != null)
            //    //    {
            //    //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Clear();
            //    //        dataSetObject.Tables["CustomTPGlobalQuickGoals"].Merge(dataSetTreatmentPlan.Tables["CustomTPGlobalQuickGoals"], true, MissingSchemaAction.Ignore);
            //    //    }
            //    //}

            //}

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
        }
    }
    public override void ChangeDataSetAfterGetData()
    {
        using (SHS.UserBusinessServices.HarborTreatmentPlan objHarborTreatmentPlan = new SHS.UserBusinessServices.HarborTreatmentPlan())
        {
            int staffId = BaseCommonFunctions.GetUserIdInCaseOfMultipleDataBase();
            string InitialOrUpdate="";
            if(BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet,"CustomDocumentDiagnosticAssessments",0))
                InitialOrUpdate=BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentDiagnosticAssessments"].Rows[0]["InitialOrUpdate"].ToString();
            if(InitialOrUpdate!="" && InitialOrUpdate=="U")
                return;

            using (DataSet dataSetObject = BaseCommonFunctions.GetScreenInfoDataSet())
            {
                //int DocumentVersionId = Convert.ToInt32(dataSetObject.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"].ToString());
                DataSet dataSetTreatmentPlan = objHarborTreatmentPlan.GetTreatmentPlanInitial_2(BaseCommonFunctions.ApplicationInfo.Client.ClientId, staffId,"A");

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
                    //Code commented by jagdeep to remove CustomTPQuick* from unsaved changes
                    //Strat
                    //try
                    //{
                    //    if (dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"] != null)
                    //    {
                    //        dataSetObject.Tables["CustomTPQuickObjectives"].Clear();
                    //        dataSetObject.Tables["CustomTPQuickObjectives"].Merge(dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"], true, MissingSchemaAction.Ignore);
                    //    }
                    //}
                    //catch
                    //{
                    //    if (dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"] != null)
                    //    {
                    //        dataSetObject.Tables["CustomTPQuickObjectives"].Clear();
                    //        dataSetObject.Tables["CustomTPQuickObjectives"].Merge(dataSetTreatmentPlan.Tables["CustomTPQuickObjectives"], true, MissingSchemaAction.Ignore);
                    //    }
                    //}
                    //end

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
                    
                    //Code commented by jagdeep to remove CustomTPQuick* from unsaved changes
                    //dataSetObject.Tables["CustomTPGlobalQuickTransitionPlans"].AcceptChanges();
                    //dataSetObject.Tables["CustomTPGlobalQuickGoals"].AcceptChanges();
                    //End

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
        }
    }
}
