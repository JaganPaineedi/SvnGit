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

    public partial class ActivityPages_Client_Detail_Assessment_HRMInitial : SHS.BaseLayer.ActivityPages.DataActivityTab
    {
       
        public override void BindControls()
        {
            //string str = Request.Form["HiddenFieldPageFilters"].ToString();
            using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("LIVINGARRANGEMENT", true, "", "CodeName", true))
            {
                //DataViewGlobalCodes.Sort = "CodeName";
                DropDownList_CustomHRMAssessments_CurrentLivingArrangement.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_CurrentLivingArrangement.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_CurrentLivingArrangement.DataSource = DataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_CurrentLivingArrangement.DataBind();
            }
            //DropDownList_CustomHRMAssessments_CurrentPrimaryCarePhysician
            //Commented by Loveena on ref to Task#201
            //using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XPrimaryPractitioner", true, "", "", true))
            //{
            //    DataViewGlobalCodes.Sort = "CodeName";
            //    DropDownList_CustomHRMAssessments_CurrentPrimaryCarePhysician.DataTextField = "CodeName";
            //    DropDownList_CustomHRMAssessments_CurrentPrimaryCarePhysician.DataValueField = "GlobalCodeId";
            //    DropDownList_CustomHRMAssessments_CurrentPrimaryCarePhysician.DataSource = DataViewGlobalCodes;
            //    DropDownList_CustomHRMAssessments_CurrentPrimaryCarePhysician.DataBind();
            //}

            using (DataView dataViewGlobalCodes = BaseCommonFunctions.FillDropDown("REFERRALTYPE", true, "", "CodeName", true))
            {
               // dataViewGlobalCodes.Sort = "SortOrder";
                DropDownList_CustomHRMAssessments_ReferralType.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_ReferralType.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_ReferralType.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_ReferralType.DataBind();
            }
            //To fill dropdown CurrentEmploymentStatus
            using (DataView dataViewGlobalCodes = BaseCommonFunctions.FillDropDown("EMPLOYMENTSTATUS", true, "", "CodeName", true))
            {
                DropDownList_CustomHRMAssessments_EmploymentStatus.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_EmploymentStatus.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_EmploymentStatus.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_EmploymentStatus.DataBind();
            }
        }
    }
}
