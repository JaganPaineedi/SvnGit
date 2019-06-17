using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using SHS.BaseLayer;
using System.Text.RegularExpressions;
using System.Reflection;

public partial class Custom_InquiryDetails_WebPages_MemberInquiryDetailGeneral : SHS.BaseLayer.ActivityPages.DataActivityTab
{

    public override void BindControls()
    {
        DropDownList_CustomInquiries_InquirerRelationToMember.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_InquirerRelationToMember.FillDropDownDropGlobalCodes();


        DropDownList_CustomInquiries_SAType.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_SAType.FillDropDownDropGlobalCodes();

        using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("REFERRALTYPE", true, "", "CodeName", true))
        {

            DropDownList_CustomInquiries_ReferralType.DataTextField = "CodeName";
            DropDownList_CustomInquiries_ReferralType.DataValueField = "GlobalCodeId";
            DropDownList_CustomInquiries_ReferralType.DataSource = DataViewGlobalCodes;
            DropDownList_CustomInquiries_ReferralType.DataBind();
        }
        //using (DataView DataViewGlobalCodes = BaseCommonFunctions.FillDropDown("REFERRALTYPE", true, "", "CodeName", true))
        //{

        //    DropDownList_CustomInquiries_ReferralSubtype.DataTextField = "CodeName";
        //    DropDownList_CustomInquiries_ReferralSubtype.DataValueField = "GlobalCodeId";
        //    DropDownList_CustomInquiries_ReferralSubtype.DataSource = DataViewGlobalCodes;
        //    DropDownList_CustomInquiries_ReferralSubtype.DataBind();
        //}

        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.States != null)
        {
            DataView DataViewStatesName = SHS.BaseLayer.SharedTables.ApplicationSharedTables.States.DefaultView;
            DataViewStatesName.Sort = "StateName";
            DropDownList_CustomInquiries_State.DataTextField = "StateName";
            DropDownList_CustomInquiries_State.DataValueField = "StateAbbreviation";
            DropDownList_CustomInquiries_State.DataSource = DataViewStatesName;
            DropDownList_CustomInquiries_State.DataBind();

            DropDownList_CustomInquiries_ReferalState.DataTextField = "StateName";
            DropDownList_CustomInquiries_ReferalState.DataValueField = "StateAbbreviation";
            DropDownList_CustomInquiries_ReferalState.DataSource = DataViewStatesName;
            DropDownList_CustomInquiries_ReferalState.DataBind();
        }
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Programs != null)
        {
            DataView DataViewProgramsName = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Programs.DefaultView;
            DataViewProgramsName.RowFilter = "ISNULL(RecordDeleted,'N')='N' and  ISNULL(Active,'N')='Y'";
            DataViewProgramsName.Sort = "ProgramName";
            DropDownList_CustomInquiries_ProgramId.DataTextField = "ProgramName";
            DropDownList_CustomInquiries_ProgramId.DataValueField = "ProgramId";
            DropDownList_CustomInquiries_ProgramId.DataSource = DataViewProgramsName;
            DropDownList_CustomInquiries_ProgramId.DataBind();
        }

        DataView dataViewLocation = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.Locations);
        DropDownList_CustomInquiries_Location.DataTextField = "LocationName";
        DropDownList_CustomInquiries_Location.DataValueField = "LocationId";
        DropDownList_CustomInquiries_Location.DataSource = dataViewLocation;
        DropDownList_CustomInquiries_Location.DataBind();

        DropDownList_CustomInquiries_UrgencyLevel.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_UrgencyLevel.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_InquiryType.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_InquiryType.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_ContactType.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_ContactType.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_InitialContact.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_InitialContact.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_Facility.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_Facility.FillDropDownDropGlobalCodes();


        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff != null)
        {
            DataView DataViewStaffName = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff.DefaultView;
            DataViewStaffName.Sort = "StaffName";
            DataViewStaffName.RowFilter = "ISNULL(RecordDeleted,'N')='N' and  ISNULL(Active,'N')<>'N'";
            DropDownList_CustomInquiries_RecordedBy.DataTextField = "StaffName";
            DropDownList_CustomInquiries_RecordedBy.DataValueField = "StaffId";
            DropDownList_CustomInquiries_RecordedBy.DataSource = DataViewStaffName;
            DropDownList_CustomInquiries_RecordedBy.DataBind();

            DropDownList_CustomInquiries_GatheredBy.DataTextField = "StaffName";
            DropDownList_CustomInquiries_GatheredBy.DataValueField = "StaffId";
            DropDownList_CustomInquiries_GatheredBy.DataSource = DataViewStaffName;
            DropDownList_CustomInquiries_GatheredBy.DataBind();

            DropDownList_CustomInquiries_AssignedToStaffId.DataTextField = "StaffName";
            DropDownList_CustomInquiries_AssignedToStaffId.DataValueField = "StaffId";
            DropDownList_CustomInquiries_AssignedToStaffId.DataSource = DataViewStaffName;
            DropDownList_CustomInquiries_AssignedToStaffId.DataBind();
        }

        DropDownList_CustomInquiries_InquiryStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_InquiryStatus.FillDropDownDropGlobalCodes();

        DropDownList_CustomInquiries_EmergencyContactRelationToClient.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomInquiries_EmergencyContactRelationToClient.FillDropDownDropGlobalCodes();

        //DropDownList_CustomInquiries_PresentingPopulation.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        //DropDownList_CustomInquiries_PresentingPopulation.FillDropDownDropGlobalCodes();

        //if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.StaffLocations != null)
        //{
        //    DataView DataViewStaffLocation = SHS.BaseLayer.SharedTables.ApplicationSharedTables.StaffLocations.DefaultView;
        //    DataViewStaffLocation.Sort = "LocationName";
        //    DataViewStaffLocation.RowFilter = "StaffId=" + SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.LoggedinUserId.ToString();
        //    DropDownList_CustomInquiries_Location.DataTextField = "LocationName";
        //    DropDownList_CustomInquiries_Location.DataValueField = "LocationId";
        //    DropDownList_CustomInquiries_Location.DataSource = DataViewStaffLocation;
        //    DropDownList_CustomInquiries_Location.DataBind();
        //}


        //Adding values in the Sex dropdown
        DropDownList_CustomInquiries_Sex.Items.Add(new ListItem("", "U"));
        DropDownList_CustomInquiries_Sex.Items.Add(new ListItem("Male", "M"));
        DropDownList_CustomInquiries_Sex.Items.Add(new ListItem("Female", "F"));
        //Adding values in the Sex dropdown ends here       

        LoadDispositionControl();

        //LoadVerificationEligibiltyControl();
        Bind_Filter_ReferralSubType();

        Bind_ReferralReason();
    }

    private void Bind_ReferralReason()
    {
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes != null)
        {
            DropDownList_CustomInquiries_ReferralReason.AddBlankRow = true;
            DropDownList_CustomInquiries_ReferralReason.BlankRowText = "";
            DropDownList_CustomInquiries_ReferralReason.BlankRowValue = "";
            DataView dataViewInquiriesReferralReason = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
            dataViewInquiriesReferralReason.RowFilter = "Category='REFERRALREASON' and  (RecordDeleted IS NULL OR RecordDeleted = 'N') AND Active='Y'";
            dataViewInquiriesReferralReason.Sort = "CodeName";
            DropDownList_CustomInquiries_ReferralReason.DataTextField = "CodeName";
            DropDownList_CustomInquiries_ReferralReason.DataValueField = "GlobalCodeId";
            DropDownList_CustomInquiries_ReferralReason.DataSource = dataViewInquiriesReferralReason.ToDataTable();
            DropDownList_CustomInquiries_ReferralReason.DataBind();
        }
    }

    private void Bind_Filter_ReferralSubType()
    {
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes != null)
        {
            DataView dataViewReferralSubType = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes);
            if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomInquiries"].Rows.Count > 0)
            {
                int GlobalSubCodeId;
                Int32.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomInquiries"].Rows[0]["ReferralSubtype"].ToString(), out GlobalSubCodeId);
                if (GlobalSubCodeId > 0)
                {
                    dataViewReferralSubType.RowFilter = "ISNULL(RecordDeleted,'N') = 'N' AND Active='Y' AND GlobalSubCodeId='" + GlobalSubCodeId + "'";
                    DropDownList_CustomInquiries_ReferralSubtype.DataTextField = "SubCodeName";
                    DropDownList_CustomInquiries_ReferralSubtype.DataValueField = "GlobalSubCodeId";
                    DropDownList_CustomInquiries_ReferralSubtype.DataSource = dataViewReferralSubType.ToDataTable();
                    DropDownList_CustomInquiries_ReferralSubtype.DataBind();
                }
            }
        }
    }
    private void LoadVerificationEligibiltyControl()
    {
        //UserControl userControl = LoadUC("~/CommonUserControls/VerifyEligibility.ascx");
        //PanelVerificationEligibility.Controls.Add(userControl);
        int inquiryid;
        if (Int32.TryParse(Convert.ToString(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomInquiries"].Rows[0]["InquiryId"]), out inquiryid))
        {
            //eev1.InquiryId = inquiryid;
        }
    }

    private void LoadDispositionControl()
    {
        int inqueryId = 0;
        int.TryParse(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomInquiries"].Rows[0]["InquiryId"].ToString(), out inqueryId);
        UserControl userControl = LoadUC("~/CommonUserControls/DispositionProviderServiceType.ascx", true, inqueryId, 0);
        PanelDispositionMain.Controls.Add(userControl);
    }


    private UserControl LoadUC(string LoadUCName, params object[] constructorParameters)
    {
        System.Web.UI.UserControl userControl = null;
        string ucControlPath = string.Empty;

        ucControlPath = LoadUCName;

        List<Type> constParamTypes = new List<Type>();

        foreach (object constParam in constructorParameters)
        {
            constParamTypes.Add(constParam.GetType());
        }

        if (!string.IsNullOrEmpty(ucControlPath))
        {
            userControl = (UserControl)this.Page.LoadControl(ucControlPath);
        }

        ConstructorInfo constructor = userControl.GetType().BaseType.GetConstructor(constParamTypes.ToArray());

        //And then call the relevant constructor
        if (constructor == null)
        {
            throw new MemberAccessException("The requested constructor was not found on : " + userControl.GetType().BaseType.ToString());
        }
        else
        {
            constructor.Invoke(userControl, constructorParameters);
        }

        return userControl;
    }

}

