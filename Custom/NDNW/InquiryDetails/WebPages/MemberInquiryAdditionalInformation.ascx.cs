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

public partial class Custom_InquiryDetails_WebPages_MemberInquiryAdditionalInformation : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void BindControls()
    {
        DataSet ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        DropDownList_CustomInquiries_EmploymentStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_EmploymentStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_OtherDemographicsMaritalStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_OtherDemographicsMaritalStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_OtherDemographicsLegal.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_OtherDemographicsLegal.FillDropDownDropGlobalCodes();

        //DropDownList_CustomInquiries_CountyOfResidence.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        //DropDownList_CustomInquiries_CountyOfResidence.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_Living.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_Living.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_SchoolDistric.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_SchoolDistric.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_Education.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_Education.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_PrimarySpokenLanguage.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_PrimarySpokenLanguage.FillDropDownDropGlobalCodes();

        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Counties != null)
        {
            DataView DataViewStatesName = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Counties.DefaultView;
            DataViewStatesName.Sort = "CountyName";
            DataViewStatesName.RowFilter = "StateFIPS=" + SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations[0]["StateFIPS"].ToString();
            DropDownList_CustomInquiries_CountyOfResidence.DataTextField = "CountyName";
            DropDownList_CustomInquiries_CountyOfResidence.DataValueField = "CountyFIPS";
            DropDownList_CustomInquiries_CountyOfResidence.DataSource = DataViewStatesName;
            DropDownList_CustomInquiries_CountyOfResidence.DataBind();
           // DropDownList_CustomInquiries_CountyOfResidence.Items.Insert(0, new ListItem(String.Empty, String.Empty));

            //DropDownList_CustomInquiries_COFR.DataTextField = "CountyName";
            //DropDownList_CustomInquiries_COFR.DataValueField = "CountyFIPS";
            //DropDownList_CustomInquiries_COFR.DataSource = DataViewStatesName;
            //DropDownList_CustomInquiries_COFR.DataBind();
            //DropDownList_CustomInquiries_COFR.Items.Insert(0, new ListItem(String.Empty, String.Empty));

        }

        DropDownList_CustomInquiries_Race.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_Race.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_Ethnicity.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_Ethnicity.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_InterpreterNeeded.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_InterpreterNeeded.FillDropDownDropGlobalCodes();
    }

    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomInquiries" };
        }
    }
}
