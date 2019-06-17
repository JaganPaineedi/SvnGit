using System;
using System.Data;
using SHS.BaseLayer;

namespace SHS.SmartCare
{

    public partial class ActivityPages_Client_Detail_Assessment_HRMGuardianInformation : SHS.BaseLayer.ActivityPages.DataActivityPage
    {
        public string externalURL = BaseCommonFunctions.ApplicationInfo.ExternalURL.ToString();
        public string isPopUp = BaseCommonFunctions.IsPopup.ToString();

        public override string PageDataSetName
        {
            get { return "DataSetAssessment"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomHRMAssessments" }; }
        }

        public override void BindControls()
        {
            BindControl();
        }

        private void BindControl()
        {
         
            using (DataView dataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XGuardianType", true, "", "CodeName", true))
                {
                    DropDownList_CustomHRMAssessments_GuardianType.DataTextField = "CodeName";
                    DropDownList_CustomHRMAssessments_GuardianType.DataValueField = "GlobalCodeId";
                    DropDownList_CustomHRMAssessments_GuardianType.DataSource = dataViewGlobalCodes;
                    DropDownList_CustomHRMAssessments_GuardianType.DataBind();
                }

        }


        /// <summary>
        /// Author Jitender
        /// Purpose - This function will be overridden at the inherited child class
        /// Date 26 Feb 2010
        /// </summary>
        public override void PopUpButtonClicked(string buttonName)
        {
            DataSet ScreenDataset = new DataSet();
            DataSet PopUpDataSet = new DataSet();
            ScreenDataset = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();
            PopUpDataSet = SHS.BaseLayer.BaseCommonFunctions.GetPopUpScreenInfoDataSet();
            try
            {
                //ScreenDataset.Tables["ClientDisclosedRecords"].Merge(PopUpDataSet.Tables["ClientDisclosedDocumentRecords"], false, MissingSchemaAction.Ignore);
                ScreenDataset.Tables["CustomHRMAssessments"].Merge(PopUpDataSet.Tables["CustomHRMAssessments"], false, MissingSchemaAction.Ignore);
            }
            catch (Exception)
            {
                ScreenDataset.Tables["CustomHRMAssessments"].Merge(PopUpDataSet.Tables["CustomHRMAssessments"], false, MissingSchemaAction.Ignore);
            }
            SHS.BaseLayer.BaseCommonFunctions.SetScreenInfoDataSet(ScreenDataset);
        }



        public override DataSet GetData()
        {
            //Page Title property will be set at base class but same can be overridden at control level
            PageTitle = "Guardian Information";
            DataSet dataSetLatest = new DataSet();
            //dataSetLatest = SHS.BaseLayer.BaseCommonFunctions.GetPageDataSet("DataSetHRMAssesment");
            dataSetLatest = SHS.BaseLayer.BaseCommonFunctions.GetPageDataSet("DataSetAssessment");
            
            //dataSetLatest = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet(); 
            DataRow[] dr = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomHRMAssessments"].Select("DocumentVersionId Is Not Null");
            if (dr.Length > 0)
            {
                using (DataSet ds = new DataSet())
                {
                    ds.Merge(dr);
                    dataSetLatest.Tables["CustomHRMAssessments"].Merge(ds.Tables[0]);
                }
            }
            SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet = dataSetLatest;

            return dataSetLatest;
        }


    }
}
