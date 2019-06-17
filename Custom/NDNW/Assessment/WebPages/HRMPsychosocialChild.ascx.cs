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

    public partial class ActivityPages_Client_Detail_Assessment_HRMPsychosocialChild : SHS.BaseLayer.ActivityPages.DataActivityTab
    {

        public override void BindControls()
        {
            CustomGrid.Bind(ParentDetailPageObject.ScreenId);

            using (DataView dataViewGlobalCodes = BaseCommonFunctions.FillDropDown("XPSDDRISKDUETO", true, "", "SortOrder", true))
            {
                DropDownList_CustomHRMAssessments_PsRiskLossOfPlacementDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskLossOfPlacementDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskLossOfPlacementDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskLossOfPlacementDueTo.DataBind();

                DropDownList_CustomHRMAssessments_PsRiskLossOfSupportDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskLossOfSupportDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskLossOfSupportDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskLossOfSupportDueTo.DataBind();

                DropDownList_CustomHRMAssessments_PsRiskExpulsionFromSchoolDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskExpulsionFromSchoolDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskExpulsionFromSchoolDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskExpulsionFromSchoolDueTo.DataBind();

                DropDownList_CustomHRMAssessments_PsRiskHospitalizationDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskHospitalizationDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskHospitalizationDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskHospitalizationDueTo.DataBind();

                DropDownList_CustomHRMAssessments_PsRiskCriminalJusticeSystemDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskCriminalJusticeSystemDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskCriminalJusticeSystemDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskCriminalJusticeSystemDueTo.DataBind();

                DropDownList_CustomHRMAssessments_PsRiskElopementFromHomeDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskElopementFromHomeDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskElopementFromHomeDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskElopementFromHomeDueTo.DataBind();

                DropDownList_CustomHRMAssessments_PsRiskLossOfFinancialStatusDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskLossOfFinancialStatusDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskLossOfFinancialStatusDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskLossOfFinancialStatusDueTo.DataBind();

                DropDownList_CustomHRMAssessments_PsRiskHigherLevelOfCareDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskHigherLevelOfCareDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskHigherLevelOfCareDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskHigherLevelOfCareDueTo.DataBind();

                DropDownList_CustomHRMAssessments_PsRiskOutOfCountryPlacementDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskOutOfCountryPlacementDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskOutOfCountryPlacementDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskOutOfCountryPlacementDueTo.DataBind();

                DropDownList_CustomHRMAssessments_PsRiskOutOfHomePlacementDueTo.DataTextField = "CodeName";
                DropDownList_CustomHRMAssessments_PsRiskOutOfHomePlacementDueTo.DataValueField = "GlobalCodeId";
                DropDownList_CustomHRMAssessments_PsRiskOutOfHomePlacementDueTo.DataSource = dataViewGlobalCodes;
                DropDownList_CustomHRMAssessments_PsRiskOutOfHomePlacementDueTo.DataBind();

                foreach (Control ctrl in this.Controls)
                {
                    if (ctrl is Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)
                    {
                        ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
                        ((Streamline.DotNetDropDownGlobalCodes.DropDownGlobalCodes)ctrl).FillDropDownDropGlobalCodes();
                        continue;
                    }
                }

            }
        }
    }
}