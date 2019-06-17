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

public partial class ActivityPages_Harbor_Client_Detail_Documents_PsychiatricEvaluation_PsychiatricRecommendations : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    public string ReferralTransferReferenceURL = "";
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public override void BindControls()
    {
        CustomGridPsychiatricReferrals.Bind(ParentDetailPageObject.ScreenId);
        DataTable datatableGlobalCodes = null;
        DataTable datatableStaff = null;
        DataView dataViewStaff = null;
        DataTable datatableService = null;
        DataView dataViewService = null;
        DataSet dataSetCustomConfiguration = null;
        try
        {
            SHS.UserBusinessServices.Document _documentObject = new SHS.UserBusinessServices.Document();
            dataSetCustomConfiguration=_documentObject.GetCustomConfigurtions();



            //Bind Receiving Staff Dropdowns for Referral and Transfer   
            datatableStaff = SHS.BaseLayer.SharedTables.ApplicationSharedTables.Staff;
            dataViewStaff = datatableStaff.DefaultView;
            DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId.DataTextField = "StaffName";
            DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId.DataValueField = "StaffId";
            DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId.DataSource = dataViewStaff;
            DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId.DataBind();
            DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId.Items.Insert(0, new ListItem("", ""));
            DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ReceivingStaffId.SelectedIndex = 0;

            //Bind Program and Frequency Dropdowns for Referral and Transfer 
            datatableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
            DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceFrequency.DataTableGlobalCodes = datatableGlobalCodes;
            DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceFrequency.FillDropDownDropGlobalCodes();
            //datatableService = SHS.BaseLayer.SharedTables.ApplicationSharedTables.AuthorizationCodes;
            //dataViewService = datatableService.DefaultView;
            //DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.DataTextField = "AuthorizationCodeName";
            //DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.DataValueField = "AuthorizationCodeId";
            //DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.DataSource = dataViewService;
            //DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.DataBind();
            //DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.Items.Insert(0, new ListItem("", ""));
            //DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.SelectedIndex = 0;

            //Bind Service Dropdowns for Referral and Transfer 
            //Modify by :RohitK,on 06-19-2012,1796,#81 Services Drop-Downs,Harbor Go Live Issues
            //This stored procedure is designed to restrict the authorization codes available based on DocumentCodeId and ClientId
            using (SHS.UserBusinessServices.ReferralService objectReferralService = new SHS.UserBusinessServices.ReferralService())
            {
                int DocumentCodeId = Convert.ToInt32(BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet, "Documents") ? BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["Documents"].Rows[0]["DocumentCodeId"] : 0);
                DataSet datasetReferralService = objectReferralService.GetReferralService(DocumentCodeId, Convert.ToInt32(BaseCommonFunctions.ApplicationInfo.Client.ClientId));
                DataView dataViewReferralService = new DataView(datasetReferralService.Tables["AuthorizationCodes"]);
                DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.DataTextField = "DisplayAs";
                DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.DataValueField = "AuthorizationCodeId";
                DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.DataSource = dataViewReferralService;
                DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.DataBind();
                DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.Items.Insert(0, new ListItem("", ""));
                DropDownList_CustomDocumentPsychiatricEvaluationReferrals_ServiceRecommended.SelectedIndex = 0;
            }

            if (dataSetCustomConfiguration.Tables["customconfigurations"].Rows.Count > 0)
            {
                if (dataSetCustomConfiguration.Tables["customconfigurations"].Rows[0]["ReferralTransferReferenceURL"] != DBNull.Value)
                {

                    hiddenFieldReferralTransferReferenceURL.Value  = dataSetCustomConfiguration.Tables["customconfigurations"].Rows[0]["ReferralTransferReferenceURL"].ToString();
                }

            }

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

    public override string[] TablesUsedInTab
    {
        get
        {
            return new string[] { "CustomDocumentPsychiatricEvaluations", "CustomDocumentPsychiatricEvaluationReferrals" };
        }
    }
}
