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

public partial class ActivityPages_Harbor_Client_Detail_Documents_DiagnosticAssessment_DiagnosticNarrativeSummary : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void BindControls()
    {
        CustomAssessmentTransferServicesGrid.Bind(ParentDetailPageObject.ScreenId);
        CustomGridAssessmentReferrals.Bind(ParentDetailPageObject.ScreenId);

        DataTable datatableGlobalCodes = null;
        DataTable datatableStaff = null;
        DataView dataViewStaff = null;
        DataTable datatableService = null;
        DataView dataViewService = null;

        try
        {

            if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff != null)
            {
                //Bind Receiving Staff Dropdowns for Referral and Transfer   
                datatableStaff = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff;
                dataViewStaff = datatableStaff.DefaultView;
                dataViewStaff.Sort = "StaffName";
                dataViewStaff.RowFilter = "Active='Y'";
                //DataView dataViewStaff = SHS.BaseLayer.SharedTables.GetSharedTableStaff();
                //dataViewStaff.RowFilter = "Active='Y'";
                //dataViewStaff.Sort = "StaffName";

                DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId.DataTextField = "StaffName";
                DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId.DataValueField = "StaffId";
                DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId.DataSource = dataViewStaff;
                DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId.DataBind();
                DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId.Items.Insert(0, new ListItem("", ""));
                DropDownList_CustomDocumentAssessmentReferrals_ReceivingStaffId.SelectedIndex = 0;

                DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff.DataTextField = "StaffName";
                DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff.DataValueField = "StaffId";
                DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff.DataSource = dataViewStaff;
                DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff.DataBind();
                DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingStaff.Items.Insert(0, new ListItem("", ""));
            }
            //Modifed By : Amit Kumar Srivastava, #1979, Harbor Go Live Issues, SPECIFICATION: Fill Receiving Program Drop-Down Dyanmically
            //Bind Program and Frequency Dropdowns for Referral and Transfer 
            datatableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            //DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram.DataTableGlobalCodes = datatableGlobalCodes;
            //DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram.FillDropDownDropGlobalCodes();

            DropDownList_CustomDocumentAssessmentReferrals_ServiceFrequency.DataTableGlobalCodes = datatableGlobalCodes;
            DropDownList_CustomDocumentAssessmentReferrals_ServiceFrequency.FillDropDownDropGlobalCodes();

            //Bind Service Dropdowns for Referral and Transfer 
            //datatableService = SHS.BaseLayer.SharedTables.ApplicationSharedTables.AuthorizationCodes;
            //dataViewService = datatableService.DefaultView;
            //DropDownList_CustomDocumentAssessmentTransferServices_TransferService.DataTextField = "AuthorizationCodeName";
            //DropDownList_CustomDocumentAssessmentTransferServices_TransferService.DataValueField = "AuthorizationCodeId";
            //DropDownList_CustomDocumentAssessmentTransferServices_TransferService.DataSource = dataViewService;
            //DropDownList_CustomDocumentAssessmentTransferServices_TransferService.DataBind();
            //DropDownList_CustomDocumentAssessmentTransferServices_TransferService.Items.Insert(0, new ListItem("", ""));
            //DropDownList_CustomDocumentAssessmentTransferServices_TransferService.SelectedIndex = 0;

            //DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.DataTextField = "AuthorizationCodeName";
            //DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.DataValueField = "AuthorizationCodeId";
            //DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.DataSource = dataViewService;
            //DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.DataBind();
            //DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.Items.Insert(0, new ListItem("", ""));
            //DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.SelectedIndex = 0;

            //Service
            //Modify by :RohitK,on 06-19-2012,1796,#81 Services Drop-Downs,Harbor Go Live Issues
            //This stored procedure is designed to restrict the authorization codes available based on DocumentCodeId and ClientId
            using (SHS.UserBusinessServices.ReferralService objectReferralService = new SHS.UserBusinessServices.ReferralService())
            {
                int DocumentCodeId = Convert.ToInt32(BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet, "Documents") ? BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["Documents"].Rows[0]["DocumentCodeId"] : 0);
                DataSet datasetReferralService = objectReferralService.GetReferralService(DocumentCodeId, Convert.ToInt32(BaseCommonFunctions.ApplicationInfo.Client.ClientId));
                DataView dataViewReferralService = new DataView(datasetReferralService.Tables["AuthorizationCodes"]);
                DropDownList_CustomDocumentAssessmentTransferServices_TransferService.DataTextField = "DisplayAs";
                DropDownList_CustomDocumentAssessmentTransferServices_TransferService.DataValueField = "AuthorizationCodeId";
                DropDownList_CustomDocumentAssessmentTransferServices_TransferService.DataSource = dataViewReferralService;
                DropDownList_CustomDocumentAssessmentTransferServices_TransferService.DataBind();
                DropDownList_CustomDocumentAssessmentTransferServices_TransferService.Items.Insert(0, new ListItem("", ""));
                DropDownList_CustomDocumentAssessmentTransferServices_TransferService.SelectedIndex = 0;

                DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.DataTextField = "DisplayAs";
                DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.DataValueField = "AuthorizationCodeId";
                DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.DataSource = dataViewReferralService;
                DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.DataBind();
                DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.Items.Insert(0, new ListItem("", ""));
                DropDownList_CustomDocumentAssessmentReferrals_ServiceRecommended.SelectedIndex = 0;
            }
            //Below Code Added by Maninder (7/9/2012): Task#2007 in Harbor Go Live
            if (BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet, "CustomDocumentDiagnosticAssessments", 0) && BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentDiagnosticAssessments"].Rows[0]["TransferReceivingStaff"] != DBNull.Value)
            {
                int TransferReceivingStaff = 0;
                TransferReceivingStaff = Convert.ToInt32(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentDiagnosticAssessments"].Rows[0]["TransferReceivingStaff"]);
                using (SHS.UserBusinessServices.DiagnosticAssessment objDiagnosticAssessment = new SHS.UserBusinessServices.DiagnosticAssessment())
                {
                    DataSet DataSetRecProgramByReceivingStaff = objDiagnosticAssessment.RecProgramByReceivingStaff(TransferReceivingStaff);
                    if (BaseCommonFunctions.CheckRowExists(DataSetRecProgramByReceivingStaff,"RecProgramByReceivingStaff",0) != null)
                    {
                        DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram.DataTextField = "ProgramCode";
                        DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram.DataValueField = "Programid";
                        DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram.DataSource = DataSetRecProgramByReceivingStaff.Tables["RecProgramByReceivingStaff"];
                        DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram.DataBind();
                        DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram.Items.Insert(0, new ListItem("", ""));
                        DropDownList_CustomDocumentDiagnosticAssessments_TransferReceivingProgram.SelectedIndex = 0;
                    }
                }
            }
            //Ends
        }
        finally
        {
            if (datatableGlobalCodes != null)
                datatableGlobalCodes.Dispose();
            if (datatableService != null)
                datatableService.Dispose();
            if (datatableStaff != null)
                datatableStaff.Dispose();
        }
    }
}
