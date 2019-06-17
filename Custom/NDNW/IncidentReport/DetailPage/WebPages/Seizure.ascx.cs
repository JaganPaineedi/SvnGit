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
public partial class Custom_IncidentReport_WebPages_Seizure : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    DataSet ds;
    DataSet dsstaff;
    SqlParameter[] _ObjSqlParameter;
    public override void BindControls()
    {
        DataView dataViewCodeName = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dataViewCodeName.RowFilter = "Category='XINCIDENTYESNO' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "SortOrder,CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSweating.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSweating.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSweating.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSweating.DataBind();

        DataView dataViewNotes = new DataView(SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes);
        dataViewNotes.RowFilter = "Category='CLIENTNOTETYPE' and Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewNotes.Sort = "CodeName";
        DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteType.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteType.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteType.DataSource = dataViewNotes;
        DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_NoteType.DataBind();

        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsUrinaryFecalIncontinence.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsUrinaryFecalIncontinence.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsUrinaryFecalIncontinence.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsUrinaryFecalIncontinence.DataBind();

        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfArms.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfArms.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfArms.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfArms.DataBind();

        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfLegs.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfLegs.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfLegs.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsTonicStiffnessOfLegs.DataBind();

        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfArms.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfArms.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfArms.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfArms.DataBind();

        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfLegs.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfLegs.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfLegs.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsClonicTwitchingOfLegs.DataBind();

        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPupilsDilated.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPupilsDilated.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPupilsDilated.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPupilsDilated.DataBind();

        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsAnyAbnormalEyeMovements.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsAnyAbnormalEyeMovements.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsAnyAbnormalEyeMovements.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsAnyAbnormalEyeMovements.DataBind();

        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPostictalPeriod.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPostictalPeriod.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPostictalPeriod.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsPostictalPeriod.DataBind();       

        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsVagalNerveStimulator.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsVagalNerveStimulator.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsVagalNerveStimulator.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsVagalNerveStimulator.DataBind();

        dataViewCodeName.RowFilter = "Category='XINCIDENTYESNONA' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "SortOrder,CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSwipedMagnet.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSwipedMagnet.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSwipedMagnet.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsSwipedMagnet.DataBind();

        dataViewCodeName.RowFilter = "Category='XINCIDENTBREATHING' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "SortOrder,CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsBreathing.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsBreathing.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsBreathing.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsBreathing.DataBind();

        dataViewCodeName.RowFilter = "Category='XINCIDENTCOLOR' and  Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'";
        dataViewCodeName.Sort = "SortOrder,CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsColor.DataTextField = "CodeName";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsColor.DataValueField = "GlobalCodeId";
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsColor.DataSource = dataViewCodeName;
        DropDownList_CustomIncidentReportSeizureDetails_SeizureDetailsColor.DataBind();        
        Bind_Staff();
        CustomGrid.Bind(ParentDetailPageObject.ScreenId);
    }
    private void Bind_Staff()
    {
        int Programid = 0;
        Int32.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomIncidentReportGenerals"].Rows[0]["GeneralProgram"].ToString(), out Programid);
        dsstaff = new DataSet();
        _ObjSqlParameter = new SqlParameter[1];
        _ObjSqlParameter[0] = new SqlParameter("@ProgramId", Programid);
        ds = new DataSet();
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetStaff", ds, new string[] { "Staff", "Supervisors", "Administrator" });
        SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetStafflPrograms", dsstaff, new string[] { "Staff", "Supervisors", "Nurse", "Behaviourist", "AllStaff", "Managers" }, _ObjSqlParameter);
        if (Programid > 0)
        {
            DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury.DataTextField = dsstaff.Tables[0].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury.DataValueField = dsstaff.Tables[0].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury.DataSource = dsstaff.Tables[0];
            DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury.DataBind();

            DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsSupervisorFlaggedId.DataTextField = dsstaff.Tables[1].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsSupervisorFlaggedId.DataValueField = dsstaff.Tables[1].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsSupervisorFlaggedId.DataSource = dsstaff.Tables[1];
            DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsSupervisorFlaggedId.DataBind();

            DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating.DataTextField = dsstaff.Tables[0].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating.DataValueField = dsstaff.Tables[0].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating.DataSource = dsstaff.Tables[0];
            DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating.DataBind();

            DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification.DataTextField = dsstaff.Tables[4].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification.DataValueField = dsstaff.Tables[4].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification.DataSource = dsstaff.Tables[4];
            DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusStaffCompletedNotification.DataBind();

            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpSupervisorName.DataTextField = dsstaff.Tables[1].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpSupervisorName.DataValueField = dsstaff.Tables[1].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpSupervisorName.DataSource = dsstaff.Tables[1];
            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpSupervisorName.DataBind();

            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification.DataTextField = dsstaff.Tables[4].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification.DataValueField = dsstaff.Tables[4].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification.DataSource = dsstaff.Tables[4];
            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpStaffCompletedNotification.DataBind();

            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManager.DataTextField = dsstaff.Tables["Managers"].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManager.DataValueField = dsstaff.Tables["Managers"].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManager.DataSource = dsstaff.Tables["Managers"];
            DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SupervisorFollowUpManager.DataBind();

            DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpManagerId.DataTextField = dsstaff.Tables["Managers"].Columns["DisplayAs"].ToString();
            DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpManagerId.DataValueField = dsstaff.Tables["Managers"].Columns["StaffId"].ToString();
            DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpManagerId.DataSource = dsstaff.Tables["Managers"];
            DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpManagerId.DataBind(); 

        }
        //DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury.DataTextField = ds.Tables[0].Columns["DisplayAs"].ToString();
        //DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury.DataValueField = ds.Tables[0].Columns["StaffId"].ToString();
        //DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury.DataSource = ds.Tables[0];
        //DropDownList_CustomIncidentSeizureDetails_IncidentSeizureDetailsStaffNotifiedForInjury.DataBind();

        //DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating.DataTextField = ds.Tables[0].Columns["DisplayAs"].ToString();
        //DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating.DataValueField = ds.Tables[0].Columns["StaffId"].ToString();
        //DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating.DataSource = ds.Tables[0];
        //DropDownList_CustomIncidentReportSeizureFollowUpOfIndividualStatuses_SeizureFollowUpIndividualStatusNurseStaffEvaluating.DataBind();

        DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministrator.DataTextField = ds.Tables[2].Columns["DisplayAs"].ToString();
        DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministrator.DataValueField = ds.Tables[2].Columns["StaffId"].ToString();
        DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministrator.DataSource = ds.Tables[2];
        DropDownList_CustomIncidentReportSeizureSupervisorFollowUps_SeizureSupervisorFollowUpAdministrator.DataBind();

        DropDownList_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewAdministrator.DataTextField = ds.Tables[2].Columns["DisplayAs"].ToString();
        DropDownList_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewAdministrator.DataValueField = ds.Tables[2].Columns["StaffId"].ToString();
        DropDownList_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewAdministrator.DataSource = ds.Tables[2];
        DropDownList_CustomIncidentReportSeizureAdministratorReviews_SeizureAdministratorReviewAdministrator.DataBind();

        DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministrator.DataTextField = ds.Tables[2].Columns["DisplayAs"].ToString();
        DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministrator.DataValueField = ds.Tables[2].Columns["StaffId"].ToString();
        DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministrator.DataSource = ds.Tables[2];
        DropDownList_CustomIncidentReportSeizureManagerFollowUps_ManagerFollowUpAdministrator.DataBind();
    }
    public void CustomGrid_BeforeDataBound(object sender, CustomGridDataBindEventArgs args)
    {
        DataTable Clientcontactinfo = new DataTable();
        Clientcontactinfo = (DataTable)args.DataSource;
        int counter = 1;
        if (BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet != null &&
               BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.IsDataTableFound("CustomIncidentReportSeizures"))
        {
            for (int i = 0; i < Clientcontactinfo.Rows.Count; i++)
            {
                
                if (Clientcontactinfo.Rows[i]["RecordDeleted"].ToString() != "Y")
                {
                    Clientcontactinfo.Rows[i]["NoOfSeizure"] = counter++ ;
                }
                else
                {
                    Clientcontactinfo.Rows[i]["NoOfSeizure"] = counter-1;
                }
            }
        }
    }
}