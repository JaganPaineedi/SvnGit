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

    public partial class Custom_Urinalysis_WebPages_UrinalysisNotes : SHS.BaseLayer.ActivityPages.DocumentDataActivityPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public override void BindControls()
        {
            //DataView dtGlobalCodes = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
            //dtGlobalCodes.RowFilter = "Category ='XURINENOTESTAFRATING'"; 
            //dtGlobalCodes.Sort = " SortOrder ASC";
            //DropDownList_CustomDocumentUrinalysis_UrineNoteStaffRating.DataSource = dtGlobalCodes;
            //DropDownList_CustomDocumentUrinalysis_UrineNoteStaffRating.DataTextField = "CodeName";
            //DropDownList_CustomDocumentUrinalysis_UrineNoteStaffRating.DataValueField = "GlobalCodeId";
            //DropDownList_CustomDocumentUrinalysis_UrineNoteStaffRating.DataBind();

            DropDownList_CustomDocumentUrinalysis_UrineNoteStaffRating.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentUrinalysis_UrineNoteStaffRating.FillDropDownDropGlobalCodes();
        }

        public override string PageDataSetName
        {
            get { return "DataSetCustomDocumentUrinalysis"; }
        }

        public override string[] TablesToBeInitialized
        {
            get { return new string[] { "CustomDocumentUrinalysis" }; }
        }

        public override void ChangeDataSetBeforeUpdate(ref DataSet dataSetObject)
        {

            //if (dataSetObject.Tables.Contains("CustomDocumentUrinalysis") && dataSetObject.Tables["CustomDocumentUrinalysis"].Rows.Count > 0)
            //{
            //    if (dataSetObject.Tables["CustomDocumentUrinalysis"].Rows[0]["IssuesPresentedToday"].ToString() == "A")
            //    {
            //        dataSetObject.Tables["CustomDocumentUrinalysis"].Rows[0]["IssuesPresentedToday"] = DBNull.Value;
            //    }
            //}
        }

    }
}
