using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using SHS.BaseLayer;

namespace SHS.SmartCare
{
    public partial class ActivityPages_Client_Detail_HarborTreatmentPlan_HarborTPGoal : System.Web.UI.Page
    {
        public string RelativePath;
        protected void Page_Load(object sender, EventArgs e)
        {
            RelativePath = Page.ResolveUrl("~/");
            AddEditGoal();
            HiddenFieldRelativePath.Value = Page.ResolveUrl("~/");
        }
        /// <summary>
        /// <Description>Decide on the basis of input criteria i.e do we need to add goal or edit goal</Description>
        /// <Author>Vikas Vyas</Author>
        /// <CreatedOn></CreatedOn>
        /// </summary>
        private void AddEditGoal()
        {
            switch (Request.QueryString["goalTitle"].Trim())
            {
                case "Add Goal":
                    Page.Title = "Add Goal";
                    HiddenField_TPNeeds_AddEdit.Value = "Add";
                    AddGoal();
                    break;
                case "Edit Goal":
                    Page.Title = "Edit Goal";
                    EditGoal();
                    HiddenField_TPNeeds_AddEdit.Value = "Edit";
                    break;
            }

        }
        /// <summary>
        /// <Description>Create New Row in TPNeeds table</Description>
        /// <Author>Vikas Vyas</Author>
        /// <CreatedOn>22nd-Sept-2009</CreatedOn>
        /// </summary>
        private void AddGoal()
        {
            DataRow[] dataRowTPNeed = null;
            int needId = 0;
            string filterString = string.Empty;
            string strFirstNameLastName = string.Empty;
            //try catch finally block commented by shifali in ref to task# 950 on 5 june,2010
            //try
            //{
                needId = Convert.ToInt32(Request.QueryString["needId"]);
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
                {
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                    {
                        if (dataSetTreatmentPlanHRM.Tables.Contains("TPNeeds"))
                        {
                            dataRowTPNeed = dataSetTreatmentPlanHRM.Tables["TPNeeds"].Select("Isnull(RecordDeleted,'N')<>'Y' and NeedId=" + needId);
                            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("StageOfTreatment", true, "", "SortOrder", false))
                            {
                               
                            }
                            HiddenField_TPNeeds_NeedId.Value = needId.ToString();// Convert.ToString(dataRowTPNeeds[0]["NeedId"]);
                            Litral_TPNeeds_GoalNumber.Text = "Goal " + Convert.ToString(Convert.ToInt32(dataSetTreatmentPlanHRM.Tables["TPNeeds"].Compute("Max(NeedNumber)","Isnull(RecordDeleted,'N')<>'Y'")) + 1);//"Goal " + Convert.ToString(dataRowTPNeeds["NeedNumber"]);

                            if (BaseCommonFunctions.ApplicationInfo.LoggedInUser.LastName != string.Empty)
                            {
                                strFirstNameLastName = BaseCommonFunctions.ApplicationInfo.LoggedInUser.LastName;
                            }
                            if (BaseCommonFunctions.ApplicationInfo.LoggedInUser.FirstName != string.Empty)
                            {
                                if (strFirstNameLastName != string.Empty)
                                {
                                    strFirstNameLastName = strFirstNameLastName + ", " + BaseCommonFunctions.ApplicationInfo.LoggedInUser.FirstName;
                                }
                                else
                                {
                                    strFirstNameLastName = BaseCommonFunctions.ApplicationInfo.LoggedInUser.FirstName;
                                }
                            }
                        }
                    }
                }
            
        }


        /// <summary>
        /// <Description>Edit Row in TPNeeds table</Description>
        /// <Author>Anuj Tomar</Author>
        /// <CreatedOn>24th-Sept-2009</CreatedOn>
        /// </summary>
        private void EditGoal()
        {
            DataRow[] dataRowTPNeeds = null;
            //try catch finally block commented by shifali in ref to task# 950 on 5 june,2010
            //try
            //{
                using (DataSet dataSetTreatmentPlanHRM = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet)
                {
                    if (dataSetTreatmentPlanHRM != null && dataSetTreatmentPlanHRM.Tables.Count > 0)
                    {
                        if (dataSetTreatmentPlanHRM.Tables.Contains("TPNeeds") && dataSetTreatmentPlanHRM.Tables["TPNeeds"].Rows.Count > 0)
                        {
                            HiddenField_TPNeeds_NeedId.Value = Request.QueryString["needId"].ToString();
                            dataRowTPNeeds = dataSetTreatmentPlanHRM.Tables["TPNeeds"].Select("needId=" + Convert.ToInt32(HiddenField_TPNeeds_NeedId.Value));
                            
                            string goalActive = string.Empty;
                            if (dataRowTPNeeds[0]["GoalActive"] != DBNull.Value)
                            {
                                goalActive = dataRowTPNeeds[0]["GoalActive"].ToString();
                            }
                            
                            
                            
                            Litral_TPNeeds_GoalNumber.Text = "Goal " + Convert.ToString(dataRowTPNeeds[0]["NeedNumber"]);
                        }
                    }
                }
            
        }
    }
}