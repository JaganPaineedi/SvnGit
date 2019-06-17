using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Custom_Registration_WebPages_RegistrationDocumentProgramEnrollment : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override void BindControls()
    {
        DynamicFormsProgramEnrollment.FormId = 85;
        DynamicFormsProgramEnrollment.Activate();
    }


    ///<summary>
    ///<Description>This property is used to return Table used in tab
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>Aug 29,2011</CreatedOn>
    ///</summary>
    public override string[] TablesUsedInTab
    {
        get
        {
            string TableName = "";

            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms != null)
            {
                DataRow[] dr = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms.Select("FormId=" + 85);
                if (dr != null && dr.Length > 0)
                {
                    TableName = Convert.ToString(dr[0]["TableName"]);
                }

            }
            return new string[] { TableName };
        }
    }
}
