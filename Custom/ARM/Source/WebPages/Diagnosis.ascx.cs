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
    public partial class ActivityPages_Client_Detail_Documents_Diagnosis : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        private DataSet datasetScreen = null;

        /// <summary>
        /// <Author>Mohit Madaan</Author>
        /// <Description>This property is used to return the Dataset name used to get and store the values</Description>
        /// <CreatedDate>September 14,2009</CreatedDate>
        /// </summary>
        //public override string PageDataSetName
        //{
        //    get
        //    {
        //        return "DataSetDiagnosis";
        //    }
        //}
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// <Author>Mohit Madaan</Author>
        /// <Description>This function is used to bind Server side Controls (Like Dropdowns and Custom Grid)</Description>
        /// <CreatedDate>September 11,2009</CreatedDate>
        /// </summary>
        public override void BindControls()
        {
            CustomGrid.Bind(ParentDetailPageObject.ScreenId);
            CustomICDGrid.Bind(ParentDetailPageObject.ScreenId);
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("DIAGNOSISSEVERITY", true, "", "", false))
            {
                //DropDownList_DiagnosesIAndII_Severity.DataTextField = "CodeName";
                //DropDownList_DiagnosesIAndII_Severity.DataValueField = "GlobalCodeID";
                //DropDownList_DiagnosesIAndII_Severity.DataSource = DataViewGlobalCodes;
                //DropDownList_DiagnosesIAndII_Severity.DataBind();
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("DxRemissionType", true, "", "", false))
            {
                DropDownList_DiagnosesIAndII_Remission.DataTextField = "CodeName";
                DropDownList_DiagnosesIAndII_Remission.DataValueField = "GlobalCodeID";
                DropDownList_DiagnosesIAndII_Remission.DataSource = DataViewGlobalCodes;
                DropDownList_DiagnosesIAndII_Remission.DataBind();
                DropDownList_DiagnosesIAndII_Remission.Items.Insert(0, new ListItem("", ""));
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("DIAGNOSISTYPE", true, "", "", false))
            {
                DataViewGlobalCodes.Sort = "SortOrder asc";
                DropDownList_DiagnosesIAndII_DiagnosisType.DataTextField = "CodeName";
                DropDownList_DiagnosesIAndII_DiagnosisType.DataValueField = "GlobalCodeID";
                DropDownList_DiagnosesIAndII_DiagnosisType.DataSource = DataViewGlobalCodes;
                DropDownList_DiagnosesIAndII_DiagnosisType.DataBind();
                DropDownList_DiagnosesIAndII_DiagnosisType.Items.Insert(0, new ListItem("", "0"));
            }
            //DropDownList_DiagnosesIAndII_Remission.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;

        }
        //protected override void onload(eventargs e)
        //{
        //    datasetscreen = shs.baselayer.basecommonfunctions.screeninfo.currentdocument.documentdataset;
        //    if (datasetscreen != null)
        //    {
        //        for (int tablecount = 0; tablecount < datasetscreen.tables.count; tablecount++)
        //        {
        //            if (datasetscreen.tables[tablecount].tablename == "diagnosesiandii")
        //            {
        //                if (datasetscreen.tables[tablecount].columns.contains("primarycolumn"))
        //                { }
        //                else
        //                    datasetscreen.tables[tablecount].columns.add("primarycolumn", typeof(int32));
        //            }
        //        }
        //    }
        //}
        /*Added By: Amit Kumar Srivastava, 
         From: Javed Husain [mailto:jhusain@streamlinehealthcare.com]
        Sent: 30 June 2012 02:45
        To: Devinder Pal Singh
        Subject: Diagnosis Order
        Hi Devinder,
            We need to get a fix for the Diagnosis Order issue tomorrow.
            Also, I am thinking that we should display the order and also allow for duplicates so user has complete control on how they wish to order them.
        Thanks,
        */

        //Modify by jagdeep added check for PrimaryColumn
        public override void Activate()
        {
            datasetScreen = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            if (datasetScreen != null)
            {
                for (int tableCount = 0; tableCount < datasetScreen.Tables.Count; tableCount++)
                {
                    if (datasetScreen.Tables[tableCount].TableName == "DiagnosesIAndII")
                    {
                        if (datasetScreen.Tables[tableCount].Columns.Contains("PrimaryColumn"))
                        { }
                        else
                            datasetScreen.Tables[tableCount].Columns.Add("PrimaryColumn", typeof(Int32));
                        for (int i = 0; i < datasetScreen.Tables["DiagnosesIAndII"].Rows.Count; i++)
                        {
                            if (datasetScreen.Tables["DiagnosesIAndII"].Rows[i]["DiagnosisType"] != DBNull.Value)
                            {
                                if (datasetScreen.Tables["DiagnosesIAndII"].Rows[i]["DiagnosisType"].ToString() == "140")
                                {
                                    if (datasetScreen.Tables["DiagnosesIAndII"].Columns.Contains("PrimaryColumn"))
                                    {
                                        datasetScreen.Tables["DiagnosesIAndII"].Rows[i]["PrimaryColumn"] = 0;
                                    }
                                }
                                else
                                {
                                    if (datasetScreen.Tables["DiagnosesIAndII"].Columns.Contains("PrimaryColumn"))
                                    {
                                        datasetScreen.Tables["DiagnosesIAndII"].Rows[i]["PrimaryColumn"] = 1;
                                    }
                                }
                            }
                            else
                            {
                                if (datasetScreen.Tables["DiagnosesIAndII"].Columns.Contains("PrimaryColumn"))
                                {
                                    datasetScreen.Tables["DiagnosesIAndII"].Rows[i]["PrimaryColumn"] = 1;
                                }
                            }
                        }
                    }
                }
            }
            base.Activate();
        }
    }
}

