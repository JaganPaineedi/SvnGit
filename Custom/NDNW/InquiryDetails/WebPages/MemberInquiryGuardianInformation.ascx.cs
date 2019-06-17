using System;
using System.Data;
using SHS.BaseLayer;

namespace SHS.SmartCare
{

    public partial class ActivityPages_Client_Detail_Ionia_MemberInquiryGuardianInformation : SHS.BaseLayer.ActivityPages.DataActivityPage
    {
        public string externalURL = BaseCommonFunctions.ApplicationInfo.ExternalURL.ToString();
        public string isPopUp = BaseCommonFunctions.IsPopup.ToString();

        public override string PageDataSetName
        {
            get { return "DataSetMemberInquiry"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomInquiries" }; }
        }

        public override void BindControls()
        {
            BindControl();
        }

        private void BindControl()
        {
            //try catch finally block commented by shifali in ref to task# 950 on 5 june,2010
            //try
            //{
            //using (DataView dataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XGuardianType", true, "", "CodeName", true))
            //    {
            //        //DropDownList_cu_GuardianType.DataTextField = "CodeName";
            //        //DropDownList_CustomHRMAssessments_GuardianType.DataValueField = "GlobalCodeId";
            //        //DropDownList_CustomHRMAssessments_GuardianType.DataSource = dataViewGlobalCodes;
            //        //DropDownList_CustomHRMAssessments_GuardianType.DataBind();
            //    }
            DropDownList_CustomInquiries_GuardianRelation.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomInquiries_GuardianRelation.FillDropDownDropGlobalCodes();

            //}
            //catch (Exception ex)
            //{
            //    throw ex;
            //}
        }


        /// <summary>
        /// Author Jitender
        /// Purpose - This function will be overridden at the inherited child class
        /// Date 26 Feb 2010
        /// </summary>
        public override void PopUpButtonClicked(string buttonName)
        {
            //DataSet ScreenDataset = new DataSet();
            //DataSet PopUpDataSet = new DataSet();
            //ScreenDataset = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();
            //PopUpDataSet = SHS.BaseLayer.BaseCommonFunctions.GetPopUpScreenInfoDataSet();
            //try
            //{
            //    //ScreenDataset.Tables["ClientDisclosedRecords"].Merge(PopUpDataSet.Tables["ClientDisclosedDocumentRecords"], false, MissingSchemaAction.Ignore);
            //    ScreenDataset.Tables["CustomInquiries"].Merge(PopUpDataSet.Tables["CustomInquiries"], false, MissingSchemaAction.Ignore);
            //}
            //catch (Exception)
            //{
            //    ScreenDataset.Tables["CustomInquiries"].Merge(PopUpDataSet.Tables["CustomInquiries"], false, MissingSchemaAction.Ignore);
            //}
            //SHS.BaseLayer.BaseCommonFunctions.SetScreenInfoDataSet(ScreenDataset);
        }



        public override DataSet GetData()
        {
            //Page Title property will be set at base class but same can be overridden at control level
            PageTitle = "Guardian Information";
            DataSet dataSetLatest = SHS.BaseLayer.BaseCommonFunctions.GetPageDataSet("DataSetMemberInquiry");
            dataSetLatest = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();
            //DataRow[] dr = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomInquiries"].Select("DocumentVersionId Is Not Null");
            //if (dr.Length > 0)
            //{
            //    using (DataSet ds = new DataSet())
            //    {
            //        ds.Merge(dr);
            //        dataSetLatest.Tables["CustomInquiries"].Merge(ds.Tables[0]);
            //    }
            //}
            SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet = dataSetLatest;

            return dataSetLatest;
        }


    }
}
