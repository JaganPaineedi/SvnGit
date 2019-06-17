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

    public partial class ActivityPages_Client_Detail_Assessment_HRMOtherRiskFactors : SHS.BaseLayer.ActivityPages.CustomActivityPage
    {
        public string RelativePath = string.Empty;

        protected override void OnLoad(EventArgs e)
        {
            FillOtherRiskFactorsGrid();
            RelativePath = Page.ResolveUrl("~/");
        }

        #region--User Defined function
        /// <summary>
        /// <Description>Used to fill grid with active OtherRiskFactors from GlobalCodes table</Description>
        /// <Author>Jitender</Author>
        /// <CreatedOn>May 06,2010</CreatedOn>
        /// </summary>
        private void FillOtherRiskFactorsGrid()
        {
            //try catch finally block commented by shifali in ref to task# 950 on 5 june,2010
            //try
            //{
                string optionId = "";
                if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
                {
                    DataRow[] dr = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomOtherRiskFactors"].Select("DocumentVersionId Is Not Null and Isnull(RecordDeleted,'N')<>'Y'");
                    if (dr.Length > 0)
                    {
                        for (int i = 0; i < dr.Length; i++)
                        {
                            optionId = optionId + dr[i]["OtherRiskFactor"].ToString() + ",";
                        }
                        optionId = optionId.Substring(0, optionId.Length - 1);
                    }


                    DataView dataViewOtherRiskFactors = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
                    if (optionId != "")
                        dataViewOtherRiskFactors.RowFilter = "Active='Y' and Category ='XRiskFactorLookup' and GlobalCodeId not in(" + optionId + ")";
                    else
                        dataViewOtherRiskFactors.RowFilter = "Active='Y' and Category ='XRiskFactorLookup' ";
                    dataViewOtherRiskFactors.Sort = "SortOrder ASC";
                    //if (dataViewOtherRiskFactors.Count > 0)
                   // {
                        GridViewOtherRiskFactors.DataSource = dataViewOtherRiskFactors;
                        GridViewOtherRiskFactors.DataBind();
                    //}
                }
            //}
            //catch (Exception ex)
            //{
            //    //Catch Exception Here
            //}
        }
        #endregion
    }
}