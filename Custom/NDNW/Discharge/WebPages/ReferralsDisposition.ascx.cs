using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;
using SHS.DataServices;
public partial class Custom_Discharge_WebPages_ReferralsDisposition :  SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentDischarges", "CustomDischargeReferrals" };
        }
    }
    public override void BindControls()
    {
        CustomGrid.Bind(ParentDetailPageObject.ScreenId);

        DropDownList_CustomDischargeReferrals_Referral.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDischargeReferrals_Referral.FillDropDownDropGlobalCodes();

        DropDownList_CustomDocumentDischarges_ReferralDischarge.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentDischarges_ReferralDischarge.FillDropDownDropGlobalCodes();

        DataSet ds =new DataSet();
        SqlParameter[] _objectSqlParmeters;
        int ClientID = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;
        _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@clientId", ClientID);
        //ds=SqlHelper.ExecuteDataset(Connection.ConnectionString,CommandType.StoredProcedure,'',_objectSqlParmeters);
        ds=SqlHelper.ExecuteDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetClientEnrolledPrograms", _objectSqlParmeters);


        DropDownList_CustomDischargeReferrals_Program.DataSource = ds.Tables[0];
        DropDownList_CustomDischargeReferrals_Program.DataValueField = "ProgramId";
        DropDownList_CustomDischargeReferrals_Program.DataTextField = "ProgramName";
        DropDownList_CustomDischargeReferrals_Program.DataBind();
        DropDownList_CustomDischargeReferrals_Program.Items.Insert(0, new ListItem("", "-1"));
       
        //Bind_Filter_ReferralSubType();
    }


    //private void Bind_Filter_ReferralSubType()
    //{
    //    //DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes;
    //    //DropDownList_CustomDocumentRegistrations_ReferralSubtype.FillDropDownDropGlobalCodes();

    //    if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes != null)
    //    {
    //        DataView dataViewReferralSubType = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes);
    //        if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows.Count > 0)
    //        {
    //            int GlobalSubCodeId;
    //            Int32.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows[0]["ReferralSubtype"].ToString(), out GlobalSubCodeId);
    //            if (GlobalSubCodeId > 0)
    //            {
    //                dataViewReferralSubType.RowFilter = "ISNULL(RecordDeleted,'N') = 'N' AND Active='Y' AND GlobalSubCodeId='" + GlobalSubCodeId + "'";
    //                DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataTextField = "SubCodeName";
    //                DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataValueField = "GlobalSubCodeId";
    //                DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataSource = dataViewReferralSubType.ToDataTable();
    //                DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataBind();
    //            }
    //        }
    //    }
    //}
}
