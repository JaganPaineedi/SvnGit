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
    public partial class ActivityPages_Client_CMDocuments_General : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
        public override void BindControls()
        {
            //This Code is used to bind the RelationShip DropDown
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("RELATIONSHIP", true, "", "CodeName", true))
            {
                DropDownList_CustomAcuteServicesPrescreens_ClientRelationship.DataTextField = "CodeName";
                DropDownList_CustomAcuteServicesPrescreens_ClientRelationship.DataValueField = "GlobalCodeId";
                DropDownList_CustomAcuteServicesPrescreens_ClientRelationship.DataSource = DataViewGlobalCodes;
                DropDownList_CustomAcuteServicesPrescreens_ClientRelationship.DataBind();

            }
            //This Code is used to bind the Physician Name 

            //DataRow[] dataRowStaff = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff.Select("Active='Y'", "StaffName asc");
           // DataSet dataSetStaff = new DataSet();
            //dataSetStaff.Merge(dataRowStaff,false,MissingSchemaAction.Ignore);

            //Modified by Jitender Kumar Kamboj on 10 sep 2010
            //DropDownList_CustomAcuteServicesPrescreens_CMHStatusPrimaryClinician.DataSource = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff;
            DataView DataViewStaffName = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff.DefaultView;
            DataViewStaffName.Sort = "StaffName";
            DataViewStaffName.RowFilter = "Active='Y'";
            DropDownList_CustomAcuteServicesPrescreens_CMHStatusPrimaryClinician.DataSource = DataViewStaffName;
            DropDownList_CustomAcuteServicesPrescreens_CMHStatusPrimaryClinician.DataTextField = "StaffName";
            DropDownList_CustomAcuteServicesPrescreens_CMHStatusPrimaryClinician.DataValueField = "StaffId";
            DropDownList_CustomAcuteServicesPrescreens_CMHStatusPrimaryClinician.DataBind();
            DropDownList_CustomAcuteServicesPrescreens_CMHStatusPrimaryClinician.Items.Insert(0, new ListItem("", ""));

            //Bind The County DropDown

            int stateFips = -1;
            //Added By Vikas Vyas in ref to task #1038
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations != null)
            {
                if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations.Rows[0]["StateFips"] != DBNull.Value)
                {
                    stateFips = Convert.ToInt32(SHS.BaseLayer.SharedTables.ApplicationSharedTables.SystemConfigurations.Rows[0]["StateFips"]);
                }
            }

           
            DataView dataViewCountyOfResidence = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Counties);

            dataViewCountyOfResidence.Sort = "CountyName";
            dataViewCountyOfResidence.RowFilter = "StateFips=" + stateFips;
            if (dataViewCountyOfResidence.Count > 0)
            {


                DropDownList_CustomAcuteServicesPrescreens_ClientCounty.DataSource = dataViewCountyOfResidence;
                DropDownList_CustomAcuteServicesPrescreens_ClientCounty.DataTextField = "CountyName";
                DropDownList_CustomAcuteServicesPrescreens_ClientCounty.DataValueField = "CountyFIPS";
                DropDownList_CustomAcuteServicesPrescreens_ClientCounty.DataBind();
                DropDownList_CustomAcuteServicesPrescreens_ClientCounty.Items.Insert(0, new ListItem("", ""));
            }

        }
    }
}
