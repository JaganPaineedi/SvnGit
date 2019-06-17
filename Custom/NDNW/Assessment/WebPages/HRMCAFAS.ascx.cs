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
using SHS.UserBusinessServices;


namespace SHS.SmartCare
{

    public partial class ActivityPages_Client_Detail_Assessment_HRMCAFAS : SHS.BaseLayer.ActivityPages.DataActivityTab
    {

        public override void BindControls()
        {
           //BindCAFASRaterList();
            //For binding of RaterClinician dropdown which contains all those active staff where clinician='Y'
            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff != null)
            {
                //DataView dataViewStaff = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff);
                DataView dataViewStaff = SHS.BaseLayer.SharedTables.GetSharedTableStaff();
                dataViewStaff.RowFilter = "Clinician='Y'";
                dataViewStaff.Sort = "StaffName";
                DropDownList_CustomCAFAS2_RaterClinician.DataTextField = "StaffName";
                DropDownList_CustomCAFAS2_RaterClinician.DataValueField = "StaffId";
                DropDownList_CustomCAFAS2_RaterClinician.DataSource = dataViewStaff;
                DropDownList_CustomCAFAS2_RaterClinician.DataBind();
                DropDownList_CustomCAFAS2_RaterClinician.Items.Insert(0, new ListItem("", ""));


            }
            //For binding of CAFASInterval dropdown
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XCAFASINTERVAL", true, "", "CodeName", true))
            {
                DropDownList_CustomCAFAS2_CAFASInterval.DataTextField = "CodeName";
                DropDownList_CustomCAFAS2_CAFASInterval.DataValueField = "GlobalCodeId";
                DropDownList_CustomCAFAS2_CAFASInterval.DataSource = DataViewGlobalCodes;
                DropDownList_CustomCAFAS2_CAFASInterval.DataBind();
            }

        }

    }
}
