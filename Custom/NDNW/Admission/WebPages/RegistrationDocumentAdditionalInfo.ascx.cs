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
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.BaseLayer;

public partial class RegistrationDocumentAdditionalInfo : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    ///<summary>
    ///<Description>This Function is used to bind form id of DFA
    ///<Author>Jagdeep Hundal</Author>
    ///<CreatedOn>Aug 26,2011</CreatedOn>
    ///</summary>

    public override void BindControls()
    {
        //DynamicFormsAdditionalInformation.FormId = 83;
        //DynamicFormsAdditionalInformation.Activate();
        DataSet ds = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet;
        DataView dataViewPrograms = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dataViewPrograms.RowFilter = "Category='CITIZENSHIP' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_Citizenship.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_Citizenship.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_Citizenship.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_Citizenship.DataBind();

        dataViewPrograms.RowFilter = "Category='XJUSTICESYSTEMINVOLV' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_JusticeSystemInvolvement.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_JusticeSystemInvolvement.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_JusticeSystemInvolvement.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_JusticeSystemInvolvement.DataBind();

        dataViewPrograms.RowFilter = "Category='MILITARYSTATUS' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,GlobalCodeId ";
        DropDownList_CustomDocumentRegistrations_RegisteredSexOffender.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_RegisteredSexOffender.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_RegisteredSexOffender.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_RegisteredSexOffender.DataBind();

        dataViewPrograms.RowFilter = "Category='XRELIGION' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_Religion.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_Religion.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_Religion.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_Religion.DataBind();

        dataViewPrograms.RowFilter = "Category='XFORENSICTREATMENT' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_ForensicTreatment.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_ForensicTreatment.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_ForensicTreatment.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_ForensicTreatment.DataBind();

        dataViewPrograms.RowFilter = "Category='XSCREENFORMISA' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,GlobalCodeId ";
        DropDownList_CustomDocumentRegistrations_ScreenForMHSUD.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_ScreenForMHSUD.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_ScreenForMHSUD.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_ScreenForMHSUD.DataBind();

        dataViewPrograms.RowFilter = "Category='XSMOKINGSTATUS' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_SmokingStatus.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_SmokingStatus.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_SmokingStatus.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_SmokingStatus.DataBind();

        dataViewPrograms.RowFilter = "Category='EMPLOYMENTSTATUS' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_EmploymentStatus.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_EmploymentStatus.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_EmploymentStatus.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_EmploymentStatus.DataBind();

        dataViewPrograms.RowFilter = "Category='XCLIENTTYPE' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_ClientType.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_ClientType.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_ClientType.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_ClientType.DataBind();

        dataViewPrograms.RowFilter = "Category='EDUCATIONALSTATUS' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,GlobalCodeId ";
        DropDownList_CustomDocumentRegistrations_EducationalLevel.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_EducationalLevel.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_EducationalLevel.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_EducationalLevel.DataBind();

        dataViewPrograms.RowFilter = "Category='XADVANCEDIRECTIVE' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        //dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_AdvanceDirective.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_AdvanceDirective.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_AdvanceDirective.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_AdvanceDirective.DataBind();

        dataViewPrograms.RowFilter = "Category='XSCHOOLATTENDENCE' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_SchoolAttendance.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_SchoolAttendance.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_SchoolAttendance.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_SchoolAttendance.DataBind();

        dataViewPrograms.RowFilter = "Category='XSSISSDSTATUS' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_SSISSDStatus.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_SSISSDStatus.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_SSISSDStatus.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_SSISSDStatus.DataBind();

        dataViewPrograms.RowFilter = "Category='XEDUCATIONALSTATUS' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_EducationStatus.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_EducationStatus.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_EducationStatus.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_EducationStatus.DataBind();

        dataViewPrograms.RowFilter = "Category='LIVINGARRANGEMENT' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,CodeName ";
        DropDownList_CustomDocumentRegistrations_LivingArrangments.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_LivingArrangments.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_LivingArrangments.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_LivingArrangments.DataBind();

        dataViewPrograms.RowFilter = "Category='XMILITARYSERVICE' and Active='Y' and ISNULL(RecordDeleted,'N')='N'";
        dataViewPrograms.Sort = "SortOrder,GlobalCodeId ";
        DropDownList_CustomDocumentRegistrations_MilitaryService.DataTextField = "CodeName";
        DropDownList_CustomDocumentRegistrations_MilitaryService.DataValueField = "GlobalCodeId";
        DropDownList_CustomDocumentRegistrations_MilitaryService.DataSource = dataViewPrograms;
        DropDownList_CustomDocumentRegistrations_MilitaryService.DataBind();

        Bind_Filter_PrimaryCarePhysician();
    }

    private void Bind_Filter_PrimaryCarePhysician()
    {
        DataSet datasetProviders = new DataSet();
        datasetProviders = getPrimaryCarePhysician();
        DataView dataViewPrimaryCarePhysician = new DataView();
        dataViewPrimaryCarePhysician = datasetProviders.Tables[0].DefaultView;
        dataViewPrimaryCarePhysician.RowFilter = "Active='Y'";
        dataViewPrimaryCarePhysician.Sort = "Name";
        DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician.DataSource = dataViewPrimaryCarePhysician;
        DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician.DataBind();
        ListItem ListItemNewProvider = new ListItem("<Create Primary Care Physician>", "-1");
        DropDownList_CustomDocumentRegistrations_PrimaryCarePhysician.Items.Insert(1, ListItemNewProvider);
        if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows.Count > 0)
        {
            int ExternalReferralProviderId = 0;
            int.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentRegistrations"].Rows[0]["PrimaryCarePhysician"].ToString(), out ExternalReferralProviderId);
            if (ExternalReferralProviderId > 0)
            {
                DataRow[] dataRowProvider = datasetProviders.Tables[0].Select("ExternalReferralProviderId=" + ExternalReferralProviderId);
                if (dataRowProvider.Length > 0)
                {
                    Span_CustomDocumentRegistrations_Phone.InnerHtml = dataRowProvider[0]["PhoneNumber"].ToString();
                    Span_CustomDocumentRegistrations_PCPEmail.InnerHtml = dataRowProvider[0]["Email"].ToString();
                    Span_CustomDocumentRegistrations_OrganizationName.InnerHtml = dataRowProvider[0]["OrganizationName"].ToString();
                }
            }
        }
    }

    public DataSet getPrimaryCarePhysician()
    {
        DataSet dataSetClientContacts = new DataSet();
        SqlParameter[] _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@ExternalReferralProviderId", Convert.ToInt32(0));
        SqlHelper.FillDataset(SHS.DataServices.Connection.ConnectionString, CommandType.StoredProcedure, "ssp_GetExternalReferralProviders", dataSetClientContacts, new string[] { "ClientContacts" }, _objectSqlParmeters);
        return dataSetClientContacts;
    }


    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentRegistrations" };
        }
    }
}
