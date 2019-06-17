using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using SHS.BaseLayer;

namespace SHS.SmartCare
{
    public partial class CustomComprehensiveHealthEvaluation : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
    {
        public override void BindControls()
        {
            DataSet dsHealthHomeDocuments = new DataSet();
            dsHealthHomeDocuments = BaseCommonFunctions.GetScreenInfoDataSet();
            DynamicFormsDiagnosticRiskAssessment.FormId = 95;
            DynamicFormsDiagnosticRiskAssessment.Activate();
            CustomGrid_CustomDocumentHealthHomeCarePlanDiagnoses.Bind(10977);
            CustomGrid_CustomDocumentHealthHomeCarePlanPESNeeds.Bind(ParentDetailPageObject.ScreenId);
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XDIAGNOSISSOURCE", true, "", "", false))
            {
                if (DataViewGlobalCodes != null)
                {
                    DataViewGlobalCodes.Sort = "SortOrder asc";
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataTextField = "CodeName";
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataValueField = "GlobalCodeID";
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataSource = DataViewGlobalCodes;
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.DataBind();
                    DropDownList_CustomDocumentHealthHomeCarePlanDiagnoses_DiagnosisSource.Items.Insert(0, new ListItem("", "0"));
                }
            }
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XICPNEEDS", true, "", "", false))
            {
                DataViewGlobalCodes.Sort = "SortOrder asc";
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.DataTextField = "CodeName";
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.DataValueField = "GlobalCodeID";
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.DataSource = DataViewGlobalCodes;
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.DataBind();
                DropDownList_CustomDocumentHealthHomeCarePlanPESNeeds_PsychosocialSupportNeedType.Items.Insert(0, new ListItem("", "0"));
            }
        }

        public override string PageDataSetName
        {
            get { return "DataSetCustomComprehensiveHealthEvaluation"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentHealthHomeHealthEvaluations" }; }
        }
        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {

        }
        public override void CustomAjaxRequest()
        {
            Literal literalStart = new Literal();
            Literal literalHtmlText = new Literal();
            Literal literalEnd = new Literal();
            literalStart.Text = "###StartUc###";
            if (GetRequestParameterValue("CustomAjaxRequestType") == "CountSequenceNumber")
            {
                DataSet dsHealthHomeDocuments = new DataSet();
                dsHealthHomeDocuments = BaseCommonFunctions.GetScreenInfoDataSet();
                int SequenceCount = 0;
                string tablename = GetRequestParameterValue("TableName");
                if (dsHealthHomeDocuments.Tables.Contains(tablename))
                {
                    if (dsHealthHomeDocuments.Tables[tablename].Rows.Count > 0)
                    {
                        SequenceCount = Convert.ToInt32(dsHealthHomeDocuments.Tables[tablename].Rows[dsHealthHomeDocuments.Tables[tablename].Rows.Count - 1]["SequenceNumber"]);
                    }
                }
                SequenceCount = SequenceCount + 1;
                literalHtmlText.Text = GetRequestParameterValue("GridDataTable") + "^" + GetRequestParameterValue("GridDivName") + "^" + GetRequestParameterValue("DataGridID") + "^" + GetRequestParameterValue("ButtonCtrl") + "^" + SequenceCount.ToString();
            }
            literalEnd.Text = "###EndUc###";
            PanelLoadUC.Controls.Add(literalStart);
            PanelLoadUC.Controls.Add(literalHtmlText);
            PanelLoadUC.Controls.Add(literalEnd);
        }
   }
}