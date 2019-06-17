using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Custom_Registration_WebPages_RegistrationDocumentEpisode : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public override void BindControls()
    {
        DynamicFormsEpisode.FormId = 84;
        DynamicFormsEpisode.Activate();
        Bind_Filter_States();
        Bind_Filter_ReferralType();
        Bind_Filter_ReferralSubType();
    }


    private void Bind_Filter_ReferralType()
    {
        DropDownList_CustomDocumentRegistrations_ReferralType.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomDocumentRegistrations_ReferralType.FillDropDownDropGlobalCodes();
    }

    private void Bind_Filter_ReferralSubType()
    {
        //DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes;
        //DropDownList_CustomDocumentRegistrations_ReferralSubtype.FillDropDownDropGlobalCodes();

        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes != null)
        {
            DataView dataViewReferralSubType = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes);
            if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows.Count > 0)
            {
                int GlobalSubCodeId;
                Int32.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows[0]["ReferralSubtype"].ToString(), out GlobalSubCodeId);
                if (GlobalSubCodeId > 0)
                {
                    dataViewReferralSubType.RowFilter = "ISNULL(RecordDeleted,'N') = 'N' AND Active='Y' AND GlobalSubCodeId='" + GlobalSubCodeId + "'";
                    DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataTextField = "SubCodeName";
                    DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataValueField = "GlobalSubCodeId";
                    DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataSource = dataViewReferralSubType.ToDataTable();
                    DropDownList_CustomDocumentRegistrations_ReferralSubtype.DataBind();
                }
            }
        }
    }

    private void Bind_Filter_States()
    {
        DataView dataViewStates = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.States);
        dataViewStates.Sort = "StateName";
        DropDownList_CustomDocumentRegistrations_ReferrralState.DataTextField = "StateName";
        DropDownList_CustomDocumentRegistrations_ReferrralState.DataValueField = "StateAbbreviation";
        DropDownList_CustomDocumentRegistrations_ReferrralState.DataSource = dataViewStates;
        DropDownList_CustomDocumentRegistrations_ReferrralState.DataBind();
    }

    ///<summary>
    ///<Description>This property is used to return Table used in tab
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>Aug 25,2011</CreatedOn>
    ///</summary>
    public override string[] TablesUsedInTab
    {
        get
        {
            string TableName = "";

            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms != null)
            {
                DataRow[] dr = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Forms.Select("FormId=" + 84);
                if (dr != null && dr.Length > 0)
                {
                    TableName = Convert.ToString(dr[0]["TableName"]);
                }

            }
            return new string[] { TableName };
        }
    }
}
