using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using SHS.BaseLayer;
using System.Linq;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;
using SHS.DataServices;
using System.Text;
namespace SHS.SmartCare
{
    public partial class Custom_DLA_20_WebPages_DLA : SHS.BaseLayer.ActivityPages.DocumentDataActivityMultiTabPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public override string DefaultTab
        {
            get { return "/Custom/DLA-20/WebPages/DLA20.ascx"; }
        }

        public override string MultiTabControlName
        {
            get { return "RadMultiPage1"; }
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
            if (dataSetObject.Tables.Contains("CustomDocumentDLA20s"))
            {
                if (dataSetObject.Tables["CustomDocumentDLA20s"].Rows[0]["ClientAge"] != null)
                {
                    string age = Convert.ToString(dataSetObject.Tables["CustomDocumentDLA20s"].Rows[0]["ClientAge"]);
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
                    RadTabStrip1.Tabs[0].Visible = true;
                    RadTabStrip1.Tabs[1].Visible = false;
                    #region DLA
                    DataSet dataSetCustomHRMActivities = null;
                    try
                    {
                        dataSetCustomHRMActivities = new DataSet();
                        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetCustomHRMActivities", dataSetCustomHRMActivities, new string[] { "CustomHRMActivities" });

                    }
                    finally
                    {
                        if (dataSetCustomHRMActivities != null)
                        {
                            dataSetCustomHRMActivities.Dispose();
                        }
                    }
                    string xml = dataSetCustomHRMActivities.GetXml();
                    HiddenCustomHRMActivitiesDataTable.Value = xml;
                    #endregion
                }
                else
                {
                    RadTabStrip1.Tabs[0].Visible = false;
                    RadTabStrip1.Tabs[1].Visible = true;                   
                    #region DLA Youth
                    DataSet dataSetCustomHRMActivitiesYouth = null;
                    try
                    {
                        dataSetCustomHRMActivitiesYouth = new DataSet();
                        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetCustomDLAActivitiesYouth", dataSetCustomHRMActivitiesYouth, new string[] { "CustomDailyLivingActivities" });

                    }
                    finally
                    {
                        if (dataSetCustomHRMActivitiesYouth != null)
                        {
                            dataSetCustomHRMActivitiesYouth.Dispose();
                        }
                    }
                    string xmly = dataSetCustomHRMActivitiesYouth.GetXml();
                    HiddenCustomHRMActivitiesDataTableYouth.Value = xmly;
                    #endregion
                }
            }
        }

        public override string PageDataSetName
        {
            get { return "DataSetCustomDLA20"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentDLA20s" }; }
        }
        public string PageTables
        {
            get
            {
                return "CustomDocumentDLA20s,CustomDailyLivingActivityScores,CustomYouthDLAScores";
            }
        }
        public override string GetStoreProcedureName
        {
            get
            {
                return "csp_SCGetCustomDocumentDLA20";
            }
        }
        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            if (dataSetObject.Tables.Contains("CustomDocumentDLA20s") && dataSetObject.Tables["CustomDocumentDLA20s"].Columns.Contains("ClientAge"))
            {
                dataSetObject.Tables["CustomDocumentDLA20s"].Columns.Remove("ClientAge");
            }
        }
    }
}