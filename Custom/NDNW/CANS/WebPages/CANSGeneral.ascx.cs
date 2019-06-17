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
using System.Linq;
using SHS.BaseLayer;
using SHS.BaseLayer.ActivityPages;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;


namespace SHS.SmartCare
{
    public partial class CANSGeneral : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
       
        public override void BindControls()
        {
            DataSet ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
            DataView dViewReviewStatus = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
            dViewReviewStatus.RowFilter = "Active = 'Y'" + "and  ISNULL(RecordDeleted, 'N') = 'N' and Category = 'XCANSDocType'";
            dViewReviewStatus.Sort = "GlobalCodeId";
            DropDownList_CustomDocumentCANSGenerals_DocumentType.DataTextField = "CodeName";
            DropDownList_CustomDocumentCANSGenerals_DocumentType.DataValueField = "GlobalCodeId";
            DropDownList_CustomDocumentCANSGenerals_DocumentType.DataSource = dViewReviewStatus;
            DropDownList_CustomDocumentCANSGenerals_DocumentType.DataBind();
            ListItem item = new ListItem(" ", "-1");
            DropDownList_CustomDocumentCANSGenerals_DocumentType.Items.Insert(0, item);
            DropDownList_CustomDocumentCANSGenerals_DocumentType.FillDropDownDropGlobalCodes();
        }
        public override string[] TablesUsedInTab
        {
            get
            {
                return new string[] { "CustomDocumentCANSGenerals" };
            }

        }
        
    }

}