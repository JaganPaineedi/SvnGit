using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using SHS.BaseLayer;
using System.Reflection;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;

public partial class Custom_PsychiatricNote_WebPages_PsychiatricNoteGeneral : SHS.BaseLayer.ActivityPages.DataActivityTab
{
    UserControl userControl = null;
    string RelativePath1 = string.Empty;
    public override void BindControls()
    {
        //DropDownList_CustomDocumentPsychiatricNoteGenerals_Contraception.Items.Add(new ListItem(string.Empty, "-1"));
        //DropDownList_CustomDocumentPsychiatricNoteGenerals_Contraception.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        ////DropDownList_CustomDocumentMedicalNoteGenerals_Contraception.FillDropDownDropGlobalCodes();

        DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_Severity.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_Severity.FillDropDownDropGlobalCodes();

        DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_Duration.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_Duration.FillDropDownDropGlobalCodes();

        DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_ProblemStatus.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_ProblemStatus.FillDropDownDropGlobalCodes();

        //DropDownList_CustomPsychiatricNoteSubjective_s8s2s3s_AssociatedSignsSymptoms.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        //DropDownList_CustomPsychiatricNoteSubjective_s8s2s3s_AssociatedSignsSymptoms.FillDropDownDropGlobalCodes();

        DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_TypeOfProblem.DataTableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes;
        DropDownList_CustomPsychiatricNoteProblems_s8s2s3s_TypeOfProblem.FillDropDownDropGlobalCodes();
        RelativePath1 = Page.ResolveUrl("~/");
        //userControl = LoadUC("~/Custom/PsychiatricNote/WebPages/ServiceNoteGoalsObjectives.ascx");
        //PnlGoalsObjectives.Controls.Clear();
        //PnlGoalsObjectives.Controls.Add(userControl);
        Bind_Filter_PrimaryCarePhysician();
        CustomGridExternalReferralProviders.Bind(ParentPageObject.ScreenId);
        if (SHS.BaseLayer.SharedTables.ApplicationSharedTables.States != null)
        {
            using (DataTable datatableGlobalCodes = SHS.BaseLayer.SharedTables.ApplicationSharedTables.GlobalCodes)
            {
                DropDownList_ExternalReferralProviders_Type.DataTableGlobalCodes = datatableGlobalCodes;
                DropDownList_ExternalReferralProviders_Type.FillDropDownDropGlobalCodes();
            }
        }
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

    private void Bind_Filter_PrimaryCarePhysician()
    {
        DataSet datasetProviders = new DataSet();
        datasetProviders = getPrimaryCarePhysician();
        DataView dataViewPrimaryCarePhysician = new DataView();
        dataViewPrimaryCarePhysician = datasetProviders.Tables[0].DefaultView;
        dataViewPrimaryCarePhysician.RowFilter = "Active='Y'";
        dataViewPrimaryCarePhysician.Sort = "ExternalProviderId";
        DropDownList_ExternalReferralProviders_ExternalProviderId.DataSource = dataViewPrimaryCarePhysician;
        DropDownList_ExternalReferralProviders_ExternalProviderId.DataBind();
        ListItem ListItemNewProvider = new ListItem("<Create Provider>", "-1");
        DropDownList_ExternalReferralProviders_ExternalProviderId.Items.Insert(1, ListItemNewProvider);
        if (SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentPsychiatricNoteGenerals"].Rows.Count > 0)
        {
            int ExternalReferralProviderId = 0;
            int.TryParse(SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomDocumentPsychiatricNoteGenerals"].Rows[0]["DocumentVersionId"].ToString(), out ExternalReferralProviderId);
            if (ExternalReferralProviderId > 0)
            {
                DataRow[] dataRowProvider = datasetProviders.Tables[0].Select("ExternalReferralProviderId=" + ExternalReferralProviderId);
                if (dataRowProvider.Length > 0)
                {
                    //Span_CustomDocumentRegistrations_Phone.InnerHtml = dataRowProvider[0]["PhoneNumber"].ToString();
                    //Span_CustomDocumentRegistrations_PCPEmail.InnerHtml = dataRowProvider[0]["Email"].ToString();
                    //Span_CustomDocumentRegistrations_OrganizationName.InnerHtml = dataRowProvider[0]["OrganizationName"].ToString();
                }
            }
        }
    }

    public DataSet getPrimaryCarePhysician()
    {
        DataSet dataSetClientContacts = new DataSet();
        SqlParameter[] _objectSqlParmeters = new SqlParameter[1];
        _objectSqlParmeters[0] = new SqlParameter("@ExternalReferralProviderId", Convert.ToInt32(0));
        SqlHelper.FillDataset(SHS.DataServices.Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetExternalReferralProviders", dataSetClientContacts, new string[] { "ExternalReferralProviders" }, _objectSqlParmeters);
        return dataSetClientContacts;
    }

    public void CustomGrid_BeforeDataBound(object sender, CustomGridDataBindEventArgs args)
    {
        DataSet datasetProviders = new DataSet();
        datasetProviders = getPrimaryCarePhysician();
        DataSet DatasetParentScreen = new DataSet();
        DatasetParentScreen = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();
        for (int i = 0; i < DatasetParentScreen.Tables["ExternalReferralProviders"].Rows.Count; i++)
        {
            int tempExternalProvideId = Convert.ToInt32(DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[i]["ExternalProviderId"]);
            if (tempExternalProvideId > 0)
            {
                for (int j = 0; j < datasetProviders.Tables["ExternalReferralProviders"].Rows.Count; j++)
                {

                    DataRow[] dr = datasetProviders.Tables["ExternalReferralProviders"].Select("ExternalReferralProviderId=" + tempExternalProvideId);
                    if (dr.Length == 0)
                    {
                        DataTable DataTableExternalReferralProviders = DatasetParentScreen.Tables["ExternalReferralProviders"];
                        DataRow[] RowsWithProviderId = null;
                        RowsWithProviderId = DataTableExternalReferralProviders.Select("ExternalProviderId=" + tempExternalProvideId);
                        if (RowsWithProviderId.Length > 0)
                            DataTableExternalReferralProviders.Rows.Remove(RowsWithProviderId[0]);


                    }
                }
            }
        }
        for (int i = 0; i < DatasetParentScreen.Tables["ExternalReferralProviders"].Rows.Count; i++)
        {
            DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[i]["TempExternalProviderId"] = DatasetParentScreen.Tables["ExternalReferralProviders"].Rows[i]["ExternalProviderId"];

        }
        DatasetParentScreen.Tables["ExternalReferralProviders"].Merge(DatasetParentScreen.Tables["ExternalReferralProviders"]);
    }
}
