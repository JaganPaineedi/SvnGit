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
public partial class Custom_IncidentReport_WebPages_Fall : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    DataSet ds;
    DataSet dsstaff;
    SqlParameter[] _ObjSqlParameter;
    public override void BindControls()
    {
        Bind_Staff();
        DataView dataViewNotes = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dataViewNotes.RowFilter = "Category='CLIENTNOTETYPE' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewNotes.Sort = "CodeName";
        DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteType.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteType.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteType.DataSource = dataViewNotes;
        DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_NoteType.DataBind();
        DataView dataViewCodeName = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        //Describe Incident
        dataViewCodeName.RowFilter = "Category='XINCIDENTREPORTTYPE' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "SortOrder,CodeName";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsDescribeIncident.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsDescribeIncident.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsDescribeIncident.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportFallDetails_FallDetailsDescribeIncident.DataBind();

        //Cause of Incident
        dataViewCodeName.RowFilter = "Category='XINCIDENCAUSEINCDENT' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "SortOrder,CodeName";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsCauseOfIncident.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsCauseOfIncident.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsCauseOfIncident.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportFallDetails_FallDetailsCauseOfIncident.DataBind();

        //Cause of Incident
        dataViewCodeName.RowFilter = "Category='XINCIDENTOCCURWHILE' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "SortOrder,CodeName";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsIncidentOccurredWhile.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsIncidentOccurredWhile.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsIncidentOccurredWhile.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportFallDetails_FallDetailsIncidentOccurredWhile.DataBind();

        //Cause of Incident
        dataViewCodeName.RowFilter = "Category='XINCIDENTFOOTWEAR' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "SortOrder,CodeName";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsFootwearAtTimeOfIncident.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsFootwearAtTimeOfIncident.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportFallDetails_FallDetailsFootwearAtTimeOfIncident.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportFallDetails_FallDetailsFootwearAtTimeOfIncident.DataBind();
    }    
    private void Bind_Staff()
    {
        ds = new DataSet();
        int Programid = 0;
        Int32.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportGenerals"].Rows[0]["GeneralProgram"].ToString(), out Programid);
        dsstaff = new DataSet();
        _ObjSqlParameter = new SqlParameter[1];
        _ObjSqlParameter[0] = new SqlParameter("@ProgramId", Programid);
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetStaff", ds, new string[] { "Staff", "Supervisors", "Administrator" });
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetStafflPrograms", dsstaff, new string[] { "Staff", "Supervisors", "Nurse", "Behaviourist", "AllStaff", "Managers" }, _ObjSqlParameter);
        if (Programid > 0)
        {
            DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury.DataTextField = dsstaff.Tables[0].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury.DataValueField = dsstaff.Tables[0].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury.DataSource = dsstaff.Tables[0];
            DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury.DataBind();

            DropDownList_CustomIncidentReportFallDetails_FallDetailsSupervisorFlaggedId.DataTextField = dsstaff.Tables[1].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFallDetails_FallDetailsSupervisorFlaggedId.DataValueField = dsstaff.Tables[1].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFallDetails_FallDetailsSupervisorFlaggedId.DataSource = dsstaff.Tables[1];
            DropDownList_CustomIncidentReportFallDetails_FallDetailsSupervisorFlaggedId.DataBind();

            DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating.DataTextField = dsstaff.Tables[0].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating.DataValueField = dsstaff.Tables[0].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating.DataSource = dsstaff.Tables[0];
            DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating.DataBind();

            DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification.DataTextField = dsstaff.Tables[4].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification.DataValueField = dsstaff.Tables[4].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification.DataSource = dsstaff.Tables[4];
            DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusStaffCompletedNotification.DataBind();

            DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpSupervisorName.DataTextField = dsstaff.Tables[1].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpSupervisorName.DataValueField = dsstaff.Tables[1].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpSupervisorName.DataSource = dsstaff.Tables[1];
            DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpSupervisorName.DataBind();

            DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification.DataTextField = dsstaff.Tables[4].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification.DataValueField = dsstaff.Tables[4].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification.DataSource = dsstaff.Tables[4];
            DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpStaffCompletedNotification.DataBind();


            DropDownList_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManager.DataTextField = dsstaff.Tables["Managers"].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManager.DataValueField = dsstaff.Tables["Managers"].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManager.DataSource = dsstaff.Tables["Managers"];
            DropDownList_CustomIncidentReportFallSupervisorFollowUps_SupervisorFollowUpManager.DataBind();

            DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpManagerId.DataTextField = dsstaff.Tables["Managers"].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpManagerId.DataValueField = dsstaff.Tables["Managers"].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpManagerId.DataSource = dsstaff.Tables["Managers"];
            DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpManagerId.DataBind(); 

            
        }
        //DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury.DataTextField = ds.Tables[0].Columns["DisplayAs"].ToString();
        //DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury.DataValueField = ds.Tables[0].Columns["StaffId"].ToString();
        //DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury.DataSource = ds.Tables[0];
        //DropDownList_CustomIncidentReportFallDetails_FallDetailsStaffNotifiedForInjury.DataBind();

        //DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating.DataTextField = ds.Tables[0].Columns["DisplayAs"].ToString();
        //DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating.DataValueField = ds.Tables[0].Columns["StaffId"].ToString();
        //DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating.DataSource = ds.Tables[0];
        //DropDownList_CustomIncidentReportFallFollowUpOfIndividualStatuses_FallFollowUpIndividualStatusNurseStaffEvaluating.DataBind();        

        DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministrator.DataTextField = ds.Tables[2].Columns["DisplayAs"].ToString();
        DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministrator.DataValueField = ds.Tables[2].Columns["StaffId"].ToString();
        DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministrator.DataSource = ds.Tables[2];
        DropDownList_CustomIncidentReportFallSupervisorFollowUps_FallSupervisorFollowUpAdministrator.DataBind();

        DropDownList_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewAdministrator.DataTextField = ds.Tables[2].Columns["DisplayAs"].ToString();
        DropDownList_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewAdministrator.DataValueField = ds.Tables[2].Columns["StaffId"].ToString();
        DropDownList_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewAdministrator.DataSource = ds.Tables[2];
        DropDownList_CustomIncidentReportFallAdministratorReviews_FallAdministratorReviewAdministrator.DataBind();

        DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministrator.DataTextField = ds.Tables[2].Columns["DisplayAs"].ToString();
        DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministrator.DataValueField = ds.Tables[2].Columns["StaffId"].ToString();
        DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministrator.DataSource = ds.Tables[2];
        DropDownList_CustomIncidentReportFallManagerFollowUps_ManagerFollowUpAdministrator.DataBind();    
        
    }

    protected void CauseOfIncidentCode(object sender, EventArgs e)
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
    protected void IncidentOccurredWhileCode(object sender, EventArgs e)
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
}
