using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SHS.BaseLayer;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;
using System.Web.Script.Serialization;
using System.IO;
using System.Xml.Serialization;
using System.Text;
public partial class Custom_IncidentReport_WebPages_Incident : SHS.BaseLayer.ActivityPages.DataActivityTab
{

    DataSet ds;
    DataSet dsstaff;
    SqlParameter[] _ObjSqlParameter;
    int ID = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId;
    //DateTime DOB;
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void BindControls()
    {
        Bind_Programs();
        Bind_Staff();
        Bind_SecondaryCategory();
        DataView dataViewNotes = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dataViewNotes.RowFilter = "Category='CLIENTNOTETYPE' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewNotes.Sort = "CodeName";
        DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_NoteType.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_NoteType.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_NoteType.DataSource = dataViewNotes;
        DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_NoteType.DataBind();
        DataView dataViewCodeName = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        //Location of incident 
        dataViewCodeName.RowFilter = "Category='XLOCATIONINCIDNET' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "CodeName";
        DropDownList_CustomIncidentReportGenerals_GeneralLocationOfIncident.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportGenerals_GeneralLocationOfIncident.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportGenerals_GeneralLocationOfIncident.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportGenerals_GeneralLocationOfIncident.DataBind();
        //Location details 
        dataViewCodeName.RowFilter = "Category='XINCIDENTLOCDETAILS' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "CodeName";
        DropDownList_CustomIncidentReportGenerals_GeneralLocationDetails.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportGenerals_GeneralLocationDetails.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportGenerals_GeneralLocationDetails.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportGenerals_GeneralLocationDetails.DataBind();
        //Incident Category
        dataViewCodeName.RowFilter = "Category='XINCIDENTCATEGORY' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "SortOrder";
        DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportGenerals_GeneralIncidentCategory.DataBind();
    }
    private void Bind_SecondaryCategory()
    {
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes != null)
        {
            DataView dataViewReferralSubType = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes);
            if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportGenerals"].Rows.Count > 0)
            {
                int GlobalCodeId;
                Int32.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportGenerals"].Rows[0]["GeneralIncidentCategory"].ToString(), out GlobalCodeId);
                if (GlobalCodeId > 0)
                {
                    dataViewReferralSubType.RowFilter = "ISNULL(RecordDeleted,'N') = 'N' AND Active='Y' AND GlobalCodeId='" + GlobalCodeId + "'";
                    DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory.DataTextField = "SubCodeName";
                    DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory.DataValueField = "GlobalSubCodeId";
                    DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory.DataSource = dataViewReferralSubType;
                    DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory.DataBind();
                    DropDownList_CustomIncidentReportGenerals_GeneralSecondaryCategory.SelectedValue = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportGenerals"].Rows[0]["GeneralSecondaryCategory"].ToString();

                }
            }
        }
    }
    private void Bind_Programs()
    {
        ds = new DataSet();
        _ObjSqlParameter = new SqlParameter[1];
        _ObjSqlParameter[0] = new SqlParameter("@ClientId", ID);
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_IndividualPrograms", ds, new string[] { "ClientPrograms" }, _ObjSqlParameter);
        DropDownList_CustomIncidentReportGenerals_GeneralProgram.DataTextField = "ProgramName";
        DropDownList_CustomIncidentReportGenerals_GeneralProgram.DataValueField = "ProgramId";
        DropDownList_CustomIncidentReportGenerals_GeneralProgram.DataSource = ds;
        DropDownList_CustomIncidentReportGenerals_GeneralProgram.DataBind();
    }
    private void Bind_Staff()
    {
        int Programid = 0;
        Int32.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportGenerals"].Rows[0]["GeneralProgram"].ToString(), out Programid);
        ds = new DataSet();
        dsstaff = new DataSet();
        _ObjSqlParameter = new SqlParameter[1];
        _ObjSqlParameter[0] = new SqlParameter("@ProgramId", Programid);
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetStaff", ds, new string[] { "Staff", "Supervisors", "Administrator" });     
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetStafflPrograms", dsstaff, new string[] { "Staff", "Supervisors","Nurse","Behaviourist","AllStaff","Managers" }, _ObjSqlParameter);
        if (Programid > 0)
        {
            DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury.DataTextField = dsstaff.Tables[0].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury.DataValueField = dsstaff.Tables[0].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury.DataSource = dsstaff.Tables[0];
            DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury.DataBind();
          //  DropDownList_CustomIncidentReportDetails_DetailsStaffNotifiedForInjury.SelectedValue = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportDetails"].Rows[0]["DetailsStaffNotifiedForInjury"].ToString();

            DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId.DataTextField = dsstaff.Tables[1].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId.DataValueField = dsstaff.Tables[1].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId.DataSource = dsstaff.Tables[1];
            DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId.DataBind();
            //DropDownList_CustomIncidentReportDetails_DetailsSupervisorFlaggedId.SelectedValue = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportDetails"].Rows[0]["DetailsSupervisorFlaggedId"].ToString();

            DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating.DataTextField = dsstaff.Tables[0].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating.DataValueField = dsstaff.Tables[0].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating.DataSource = dsstaff.Tables[0];
            DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusNurseStaffEvaluating.DataBind();        
                      
            DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification.DataTextField = dsstaff.Tables[4].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification.DataValueField = dsstaff.Tables[4].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification.DataSource = dsstaff.Tables[4];
            DropDownList_CustomIncidentReportFollowUpOfIndividualStatuses_FollowUpIndividualStatusStaffCompletedNotification.DataBind();

            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSupervisorName.DataTextField = dsstaff.Tables[1].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSupervisorName.DataValueField = dsstaff.Tables[1].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSupervisorName.DataSource = dsstaff.Tables[1];
            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpSupervisorName.DataBind();

            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification.DataTextField = dsstaff.Tables[4].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification.DataValueField = dsstaff.Tables[4].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification.DataSource = dsstaff.Tables[4];
            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpStaffCompletedNotification.DataBind();

            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManager.DataTextField = dsstaff.Tables["Managers"].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManager.DataValueField = dsstaff.Tables["Managers"].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManager.DataSource = dsstaff.Tables["Managers"];
            DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpManager.DataBind();

            DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpManagerId.DataTextField = dsstaff.Tables["Managers"].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpManagerId.DataValueField = dsstaff.Tables["Managers"].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpManagerId.DataSource = dsstaff.Tables["Managers"];
            DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpManagerId.DataBind();  
        }      

        DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministrator.DataTextField = ds.Tables[2].Columns["DisplayAs"].ToString();
        DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministrator.DataValueField = ds.Tables[2].Columns["StaffId"].ToString();
        DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministrator.DataSource = ds.Tables[2];
        DropDownList_CustomIncidentReportSupervisorFollowUps_SupervisorFollowUpAdministrator.DataBind();

        DropDownList_CustomIncidentReportAdministratorReviews_AdministratorReviewAdministrator.DataTextField = ds.Tables[2].Columns["DisplayAs"].ToString();
        DropDownList_CustomIncidentReportAdministratorReviews_AdministratorReviewAdministrator.DataValueField = ds.Tables[2].Columns["StaffId"].ToString();
        DropDownList_CustomIncidentReportAdministratorReviews_AdministratorReviewAdministrator.DataSource = ds.Tables[2];
        DropDownList_CustomIncidentReportAdministratorReviews_AdministratorReviewAdministrator.DataBind();

        DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministrator.DataTextField = ds.Tables[2].Columns["DisplayAs"].ToString();
        DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministrator.DataValueField = ds.Tables[2].Columns["StaffId"].ToString();
        DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministrator.DataSource = ds.Tables[2];
        DropDownList_CustomIncidentReportManagerFollowUps_ManagerFollowUpAdministrator.DataBind();
      
    }
    protected void GeneralIncidentCategoryCode(object sender, EventArgs e)
    {
        DropDownList ddl = sender as DropDownList;
        if (ddl != null)
        {
            foreach (ListItem li in ddl.Items)
            {
                DataRow _DataRowCurrentProgram = null;
                DataTable dataViewPrograms = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
                _DataRowCurrentProgram = dataViewPrograms.Select("GlobalCodeId = " + li.Value).FirstOrDefault();
                li.Attributes.Add("Code", _DataRowCurrentProgram["Code"].ToString());
            }
        }
    }
    protected void LocationDetailCode(object sender, EventArgs e)
    {
        DropDownList ddl = sender as DropDownList;
        if (ddl != null)
        {
            foreach (ListItem li in ddl.Items)
            {
                DataRow _DataRowCurrentProgram = null;
                DataTable dataViewPrograms = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
                _DataRowCurrentProgram = dataViewPrograms.Select("GlobalCodeId = " + li.Value).FirstOrDefault();
                li.Attributes.Add("Code", _DataRowCurrentProgram["Code"].ToString());
            }
        }
    }
    protected void GeneralSecondCategoryCode(object sender, EventArgs e)
    {
        DropDownList ddl = sender as DropDownList;
        if (ddl != null)
        {
            foreach (ListItem li in ddl.Items)
            {
                DataRow _DataRowCurrentProgram = null;
                DataTable dataViewPrograms = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalSubCodes;
                _DataRowCurrentProgram = dataViewPrograms.Select("GlobalSubCodeId = " + li.Value).FirstOrDefault();
                li.Attributes.Add("Code", _DataRowCurrentProgram["Code"].ToString());
            }
        }
    }
}