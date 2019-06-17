using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;
using SHS.BaseLayer.ActivityPages;
using System.Data;

namespace SHS.SmartCare
{
    public partial class CustomDocumentDischarges : DocumentDataActivityMultiTabPage//,Iinter
    {
        private const string _prefix = "CustomDocumentDischarges";
        private const string _defaultTab = "/Custom/WebPages/CustomDischarges.ascx";
        private const string _multiTabControlName = "CustomDocumentDischargesTabPage";
        private const string _dataSetName = "DataSet" + _prefix;
        private string[] _tableNames =   {
            "CustomDocumentDischarges","CustomDocumentDischargeGoals"
        };

        public override string DefaultTab
        {
            get { return _defaultTab; }
        }

        public override string MultiTabControlName
        {
            get { return _multiTabControlName; }
        }

        public override void setTabIndex(int TabIndex, out ControlCollection ctlcollection, out string UcPath)
        {
            CustomDocumentDischargesTabPage.ActiveTabIndex = (short)TabIndex;
            ctlcollection = CustomDocumentDischargesTabPage.TabPages[TabIndex].Controls;
            UcPath = CustomDocumentDischargesTabPage.TabPages[TabIndex].Name;
            return;
        }

        public override void BindControls()
        {

        }

        public override string PageDataSetName
        {
            get { return _dataSetName; }
        }

        public override string[] TablesToBeInitialized
        {
            get
            {
                return _tableNames;
            }
        }

        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {
            DataTable tb = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentDischargeGoals"];
            #region Commented
            //Control ctrl = FindControl("CustomDocumentDischargesTabPage").FindControl("Textarea_CustomDocumentDischarges_ClientAddress");
            //int n = CustomDocumentDischargesTabPage.TabPages.Count + 1;


            //if (dataSetObject != null
            //    && dataSetObject.Tables["CustomDocumentDischargeGoals"] != null
            //    && dataSetObject.Tables["CustomDocumentDischargeGoals"].Rows.Count != 3)
            //{
            //    dataSetObject.Tables["CustomDocumentDischargeGoals"].Rows[0]["GoalNumber"] = "1";


            //    //DataTable dt1 = dataSetObject.Tables["CustomDocumentDischargeGoals"].Copy();
            //    //DataTable dt2 = dataSetObject.Tables["CustomDocumentDischargeGoals"].Copy();
            //    //string value1 = dt1.Rows[0]["DischargeGoalId"].ToString();
            //    //string value2 = dt2.Rows[0]["DischargeGoalId"].ToString();
            //    //int val1 = Convert.ToInt32(value1) + 1;
            //    //int val2 = Convert.ToInt32(value2) + 2;
            //    //dt1.Rows[0].ItemArray[0] = val1;
            //    //dt2.Rows[0].ItemArray[0] = val2;
            //    //dataSetObject.Tables["CustomDocumentDischargeGoals"].Rows.Add(dt1.Rows[0].ItemArray);
            //    //dataSetObject.Tables["CustomDocumentDischargeGoals"].Rows.Add(dt2.Rows[0].ItemArray);
            //    //dataSetObject.Tables["CustomDocumentDischargeGoals"].Rows[1]["GoalNumber"] = "2";
            //    //dataSetObject.Tables["CustomDocumentDischargeGoals"].Rows[2]["GoalNumber"] = "3";
            //    //List<string> ls = (List<string>)Session["GoalText"];
            //}
            #endregion
        }
    }

}


