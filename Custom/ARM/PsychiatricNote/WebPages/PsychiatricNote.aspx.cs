using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections.Generic;
using SHS.BaseLayer;
using System.Reflection;
using System.IO;
using System.Xml;
using SHS.BaseLayer.ActivityPages;
using System.Web.Script.Serialization;
using System.Linq;
using System.Runtime.Serialization.Json;
using System.Text;
using Microsoft.ApplicationBlocks.Data;
using SHS.DataServices;
using System.Data.SqlClient;


public partial class Custom_PsychiatricNote_WebPages_PsychiatricNote : System.Web.UI.Page
{
    string functionName = string.Empty;
    int problemCount = 0;
    private JavaScriptSerializer objectJavaScriptSerializer = null;
    protected void Page_Load(object sender, EventArgs e)
    
    {
        functionName = Request.Form["action"].ToString();
        switch (functionName.Trim())
        {
            case "getProblemSpan":
                DataSet datasetProblemSpan = null;
                datasetProblemSpan = SHS.BaseLayer.BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Copy();
                string[] service = (from pc in datasetProblemSpan.Tables["CustomPsychiatricNoteProblems"].AsEnumerable()
                                    select getProblemCount(pc.Field<int>("PsychiatricNoteProblemId").ToString())
                            ).ToArray();
                string serviceHtml = string.Join("", service);
                Response.Clear();
                Response.Write(serviceHtml.Trim());
                Response.End();
                break;
            case "bindProblems":
                int PsychiatricServiceNoteProblemId = 0;
                int.TryParse(Request.Form["PsychiatricNoteSubjectiveId"].ToString(), out PsychiatricServiceNoteProblemId);
                Response.Clear();
                Response.Write(PsychiatricServiceNoteProblemId.ToString().Trim());
                Response.End();
                break;
            case "LoadVitals":
                DataSet Vitals = new DataSet();
                Vitals = dataSetGetVitals();
                Response.Write(Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["VitalsCurrent"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["VitalsPrevious"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["ThirdPreviousVitals"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["CurreentVitalDate"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["PreviousVitalDate"].ToString() + "#8#2#3$" + Vitals.Tables["CustomDocumentPsychiatricServiceNoteExams"].Rows[0]["ThirdPreviousVitalDate"].ToString());
                Response.End();
                break;
            case "GetMedications":
                string MedicationsString = "";
                MedicationsString = getMedicationsString();
                Response.Clear();
                Response.Write(MedicationsString);
                Response.End();
                break;
            case "GetDisconMedications":
                string DisconMedicationsString = "";
                DisconMedicationsString = getNonMedicationsString();
                Response.Clear();
                Response.Write(DisconMedicationsString);
                Response.End();
                //DataSet DisconMedicationsString = new DataSet();  
                //DisconMedicationsString = getNonMedicationsString();
                //StringWriter sw = new StringWriter();
                //DisconMedicationsString.WriteXml(sw);
                //string discontinued = sw.ToString();
                //Response.Clear();
                //Response.Write(discontinued);
                //Response.End();
                break;
            case "LoadAllergirs":
                DataSet Allergies = new DataSet();
                Allergies = dataSetGetAllergies();
                StringWriter sw1 = new StringWriter();
                Allergies.WriteXml(sw1);
                string resultPIE1 = sw1.ToString();
                Response.Write(resultPIE1);
                Response.End();
                break;
            case "UpdateDiagnosis":
                string DiagnosisString = string.Empty;
                DiagnosisString = Convert.ToString(Request.Form["DiagnosisText"]);
                string[] diagResult;
                string[] stringSeparator = new string[] { "$$$" };
                diagResult = DiagnosisString.Split(stringSeparator, StringSplitOptions.None);
                string ICD10Code = diagResult[0];
                string Description = diagResult[1];
                string ICD9Code = diagResult[2];
                int ICD10CodeId = Convert.ToInt32(diagResult[4]);
                int SeverityId = Convert.ToInt32(diagResult[6]);
                string Substance = string.Empty;
                Substance = Convert.ToString(Request.Form["SourceSubstance"]);
                AddDiagnosis(ICD10Code, ICD9Code, ICD10CodeId, Description, Substance, SeverityId);
                CurrentDataSet objectCoutComeList = new CurrentDataSet();
                DataSet ds_ScreenDataset = BaseCommonFunctions.GetScreenInfoDataSet();
                objectCoutComeList.AutoSaveXml = ds_ScreenDataset.GetXml();
                Response.Clear();
                Response.Write(new JavaScriptSerializer().Serialize(objectCoutComeList));
                Response.End();
                break;
            case "RemoveDiagnosis":
                Substance = Convert.ToString(Request.Form["SourceSubstance"]);
                RemoveDiagnosis(Substance);
                CurrentDataSet objectCoutComeList1 = new CurrentDataSet();
                DataSet ds_ScreenDataset1 = BaseCommonFunctions.GetScreenInfoDataSet();
                objectCoutComeList1.AutoSaveXml = ds_ScreenDataset1.GetXml();
                Response.Clear();
                Response.Write(new JavaScriptSerializer().Serialize(objectCoutComeList1));
                Response.End();
                break;
            case "VitalsCheck":
                var DateOfService = Convert.ToString(Request.Form["DateOfService"]);
                int ServiceId = Convert.ToInt32(Request.Form["ServiceId"]);
                string strVitalsCheck = "";
                strVitalsCheck = VitalsCheck(DateOfService, ServiceId);
                Response.Clear();
                Response.Write(strVitalsCheck);
                Response.End();
                break;
            default:
                break;
        }

    }

    private void RemoveDiagnosis(string Substance)
    {
        DeleteDiagnosisOnSubstanceUnSelect(Substance);

    }


    private void DeleteDiagnosisOnSubstanceUnSelect(string Substance)
    {
        var dataSetDocument = BaseCommonFunctions.GetScreenInfoDataSet();
        if (BaseCommonFunctions.CheckRowExists(dataSetDocument, "CustomPsychiatricNoteSubstanceUses"))
        {
            DataRow[] datarowGoalRelatedObjs = dataSetDocument.Tables["CustomPsychiatricNoteSubstanceUses"].Select("SubstanceUseName='" + Substance + "' and  ISNULL(RecordDeleted,'N')='N' ");
            if (datarowGoalRelatedObjs.Length > 0)
            {
                foreach (DataRow datarowCurrent in datarowGoalRelatedObjs)
                {
                    int ICD10CodeId = (int)datarowCurrent["DocumentDiagnosisCodeId"];
                    DeletefromDocumentDiagnosisCodes(ICD10CodeId, Substance);
                    BaseCommonFunctions.UpdateRecordDeletedInformation(datarowCurrent);
                }
            }
        }
    }

    private void DeletefromDocumentDiagnosisCodes(int ICD10CodeId, string Substance)
    {
        //ArrayList drHash1 = new ArrayList();
        if (BaseCommonFunctions.GetScreenInfoDataSet().Tables.Contains("DocumentDiagnosisCodes"))
        {
            foreach (DataRow row in BaseCommonFunctions.GetScreenInfoDataSet().Tables["DocumentDiagnosisCodes"].Select("ICD10CodeId = " + ICD10CodeId))
            {
                row.BeginEdit();
                row["RecordDeleted"] = 'Y';
                row["DeletedBy"] = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                row["DeletedDate"] = DateTime.Now;
                row.EndEdit();
                //  drHash1.Add(row);
            }
        }
        string diagnosisColumn = Substance + "Diagnosis";
        int documentversionId = -1;
        var dataSetDocument = BaseCommonFunctions.GetScreenInfoDataSet();
        DataTable datatableDocumentVersions = dataSetDocument.Tables["DocumentVersions"];
        if (BaseCommonFunctions.CheckRowExists(datatableDocumentVersions, 0))
        {
            documentversionId = Convert.ToInt32(datatableDocumentVersions.Rows[0]["DocumentVersionId"]);
        }
        DataTable datatableCustomDocumentPsychiatricNoteGenerals = dataSetDocument.Tables["CustomDocumentPsychiatricNoteGenerals"];
        if (BaseCommonFunctions.CheckRowExists(datatableCustomDocumentPsychiatricNoteGenerals, 0))
        {
            foreach (DataRow row in BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomDocumentPsychiatricNoteGenerals"].Select("DocumentVersionId = " + documentversionId))
            {
                row.BeginEdit();
                row[diagnosisColumn] = "";
                row.EndEdit();
            }
        }
    }

    private static void AddDiagnosis(string ICD10Code, string ICD9Code, int ICD10CodeId, string Description, string Substance, int SeverityId)
    {

        var dataSetDocument = BaseCommonFunctions.GetScreenInfoDataSet();
        string diagnosisColumn = Substance + "Diagnosis";
        string DiagDescription = ICD10Code + " - " + Description;
        int documentversionId = -1;
        DataTable datatableDocumentVersions = dataSetDocument.Tables["DocumentVersions"];
        if (BaseCommonFunctions.CheckRowExists(datatableDocumentVersions, 0))
        {
            documentversionId = Convert.ToInt32(datatableDocumentVersions.Rows[0]["DocumentVersionId"]);
        }

        DataTable datatableCustomDocumentPsychiatricNoteGenerals = dataSetDocument.Tables["CustomDocumentPsychiatricNoteGenerals"];
        if (BaseCommonFunctions.CheckRowExists(datatableCustomDocumentPsychiatricNoteGenerals, 0))
        {
            foreach (DataRow row in BaseCommonFunctions.GetScreenInfoDataSet().Tables["CustomDocumentPsychiatricNoteGenerals"].Select("DocumentVersionId = " + documentversionId))
            {
                row.BeginEdit();
                row[diagnosisColumn] = DiagDescription;
                row.EndEdit();
            }
        }



        DataTable datatableDiagnosisCodes = dataSetDocument.Tables["DocumentDiagnosisCodes"];
        DataTable dtSubstanceUses = dataSetDocument.Tables["CustomPsychiatricNoteSubstanceUses"];
        //if (dataSetDocument.Tables["CustomPsychiatricNoteSubstanceUses"].Constraints.Contains("ForeignKey_CustomPsychiatricNoteSubstanceUses") == false)
        //{
        //    ForeignKeyConstraint fk = new ForeignKeyConstraint(
        //    "ForeignKey_CustomPsychiatricNoteSubstanceUses", datatableDiagnosisCodes.Columns["DocumentDiagnosisCodeId"], dtSubstanceUses.Columns["DocumentDiagnosisCodeId"]);
        //    dtSubstanceUses.Constraints.Add(fk);
        //    fk.DeleteRule = Rule.Cascade;
        //    fk.UpdateRule = Rule.Cascade;               
        //    fk.AcceptRejectRule = AcceptRejectRule.Cascade;
        //    dataSetDocument.EnforceConstraints = true;
        //}


        DataRow datarowNewGoal = datatableDiagnosisCodes.NewRow();
        int minGoalId = -1;
        DataRow[] datarowGoalWithMinId = datatableDiagnosisCodes.Select("DocumentDiagnosisCodeId<0");
        if (datarowGoalWithMinId.Length > 0)
        {
            minGoalId = Convert.ToInt32(datatableDiagnosisCodes.Compute("Min(DocumentDiagnosisCodeId)", "DocumentDiagnosisCodeId<0")) - 1;
        }
        datarowNewGoal["DocumentDiagnosisCodeId"] = minGoalId;
        if (datatableDiagnosisCodes.Select("ISNULL(RecordDeleted,'N')<>'Y'").Length > 0)
        {
            datarowNewGoal["DiagnosisOrder"] = Convert.ToInt32(datatableDiagnosisCodes.Compute("Max(DiagnosisOrder)", "ISNULL(RecordDeleted,'N')<>'Y'")) + 1;
        }
        else
        {
            datarowNewGoal["DiagnosisOrder"] = "1";
        }
        datarowNewGoal["ICD10CodeId"] = ICD10CodeId;
        datarowNewGoal["ICD10Code"] = ICD10Code;
        datarowNewGoal["ICD9Code"] = ICD9Code;
        datarowNewGoal["DiagnosisType"] = 142;
        datarowNewGoal["Billable"] = "Y";
        datarowNewGoal["Severity"] = SeverityId;
        datarowNewGoal["Source"] = Substance;
        datarowNewGoal["DSMDescription"] = Description;
        datarowNewGoal["DocumentVersionId"] = documentversionId;
        BaseCommonFunctions.InitRowCredentials(datarowNewGoal);
        datatableDiagnosisCodes.Rows.Add(datarowNewGoal);

        //int DocumentDiagnosisCodeId = -1;
        //if (dataSetDocument.Tables["DocumentDiagnosisCodes"].Rows.Count > 0)
        //{
        //    DocumentDiagnosisCodeId = Convert.ToInt32(dataSetDocument.Tables["DocumentDiagnosisCodes"].Compute("min([DocumentDiagnosisCodeId])", string.Empty));
        //}


        DataRow newdatarow = dtSubstanceUses.NewRow();
        SHS.BaseLayer.BaseCommonFunctions.InitRowCredentials(newdatarow);
        newdatarow["DocumentDiagnosisCodeId"] = ICD10CodeId;
        newdatarow["DocumentVersionId"] = documentversionId;
        newdatarow["SubstanceUseName"] = Substance;
        dtSubstanceUses.Rows.Add(newdatarow);


    }


   


    public string getMedicationsString()
    {
        DataSet MedicationsDataSet = new DataSet();
        int documentversionId = -1;
        string MedicationsString = string.Empty;
        SqlParameter[] _objectSqlParmeters = null;

        try
        {
            if (BaseCommonFunctions.CheckRowExists(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["DocumentVersions"], 0))
            {
                documentversionId = Convert.ToInt32(BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["DocumentVersions"].Rows[0]["DocumentVersionId"]);
            }
            string DateOfService = string.Empty;
            DateOfService = Convert.ToString(Request.Form["DateOfService"]);
            if (string.IsNullOrEmpty(DateOfService) || DateOfService == "null")
            {
                DateOfService = DateTime.Now.ToShortDateString();
            }
            _objectSqlParmeters = new SqlParameter[2];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            _objectSqlParmeters[1] = new SqlParameter("@DateOfService", DateOfService);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetPsychiatricNoteMedications", MedicationsDataSet, new string[] { "CurrentMedications", "CurrentMedicationsNotSC", "DiscontinuedMedications" }, _objectSqlParmeters);
            if (MedicationsDataSet != null)
            {
                MedicationsString = MedicationsDataSet.GetXml().ToString();
            }


            DataSet dsPPN = SHS.BaseLayer.BaseCommonFunctions.GetScreenInfoDataSet();
            if (dsPPN != null && dsPPN.Tables["CustomPsychiatricNoteMedicationHistory"] != null && dsPPN.Tables["CustomPsychiatricNoteMedicationHistory"].Rows.Count > 0)
            {
                foreach (DataRow dr in dsPPN.Tables["CustomPsychiatricNoteMedicationHistory"].Rows)
                {
                    BaseCommonFunctions.UpdateRecordDeletedInformation(dr);
                }
            }


            if (MedicationsDataSet != null && MedicationsDataSet.Tables["CurrentMedications"] != null && MedicationsDataSet.Tables["CurrentMedications"].Rows.Count > 0)
            {
                foreach (DataRow dr in MedicationsDataSet.Tables["CurrentMedications"].Rows)
                {
                    DataRow newDataRow = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomPsychiatricNoteMedicationHistory"].NewRow();
                    newDataRow["DocumentVersionId"] = documentversionId;

                    newDataRow["ClientMedicationId"] = dr["ClientMedicationId"];
                    newDataRow["CreatedBy"] = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                    newDataRow["CreatedDate"] = DateTime.Now;
                    newDataRow["ModifiedBy"] = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                    newDataRow["ModifiedDate"] = DateTime.Now;

                    newDataRow["MedicalStatus"] = 'S';
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomPsychiatricNoteMedicationHistory"].Rows.Add(newDataRow);
                   
                }
            }
            if (MedicationsDataSet != null && MedicationsDataSet.Tables["CurrentMedicationsNotSC"] != null && MedicationsDataSet.Tables["CurrentMedicationsNotSC"].Rows.Count > 0)
            {
               


                foreach (DataRow dr in MedicationsDataSet.Tables["CurrentMedicationsNotSC"].Rows)
                {

                    DataRow newDataRow = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomPsychiatricNoteMedicationHistory"].NewRow();
                        newDataRow["DocumentVersionId"] = documentversionId;
                        newDataRow["CreatedBy"] = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                        newDataRow["CreatedDate"] = DateTime.Now;
                        newDataRow["ModifiedBy"] = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                        newDataRow["ModifiedDate"] = DateTime.Now;
                        newDataRow["ClientMedicationId"] = dr["ClientMedicationId"];
                        newDataRow["MedicalStatus"] = 'N';
                        BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomPsychiatricNoteMedicationHistory"].Rows.Add(newDataRow);
                   


                }
            }
            if (MedicationsDataSet != null && MedicationsDataSet.Tables["DiscontinuedMedications"] != null && MedicationsDataSet.Tables["DiscontinuedMedications"].Rows.Count > 0)
            {
                foreach (DataRow dr in MedicationsDataSet.Tables["DiscontinuedMedications"].Rows)
                {
                    DataRow newDataRow = BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomPsychiatricNoteMedicationHistory"].NewRow();
                    newDataRow["DocumentVersionId"] = documentversionId;

                    newDataRow["ClientMedicationId"] = dr["ClientMedicationId"];
                    newDataRow["CreatedBy"] = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                    newDataRow["CreatedDate"] = DateTime.Now;
                    newDataRow["ModifiedBy"] = SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.LoggedInUser.UserCode;
                    newDataRow["ModifiedDate"] = DateTime.Now;

                    newDataRow["MedicalStatus"] = 'D';
                    BaseCommonFunctions.ScreenInfo.CurrentDocument.DocumentDataSet.Tables["CustomPsychiatricNoteMedicationHistory"].Rows.Add(newDataRow);


                }
            }


            return MedicationsString;
        }
        finally
        {
            if (MedicationsDataSet != null) MedicationsDataSet.Dispose();
            _objectSqlParmeters = null;
        }


    }

    public DataSet dataSetGetVitals()
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet datasetVitals = null;
        try
        {
            datasetVitals = new DataSet();
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetColorVitals", datasetVitals, new string[] { "CustomDocumentPsychiatricServiceNoteExams" }, _objectSqlParmeters);
            return datasetVitals;
        }
        finally
        {
            if (datasetVitals != null) datasetVitals.Dispose();
            _objectSqlParmeters = null;
        }
    }
    protected string getProblemCount(string PsychiatricServiceNoteProblemId)
    {
        string result = string.Empty;
        problemCount++;
        result = "<span id=\"span_" + PsychiatricServiceNoteProblemId + "_problem\" problemcount=\"" + problemCount + "\"></span>";
        return result;
    }
    public DataSet dataSetGetAllergies()
    {
        SqlParameter[] _objectSqlParmeters = null;
        DataSet datasetAllergies = null;
        try
        {
            datasetAllergies = new DataSet();
            _objectSqlParmeters = new SqlParameter[1];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_SCGetAllergies", datasetAllergies, new string[] { "CustomDocumentMedReviewNoteMDMs" }, _objectSqlParmeters);
            return datasetAllergies;
        }
        finally
        {
            if (datasetAllergies != null) datasetAllergies.Dispose();
            _objectSqlParmeters = null;
        }
    }

    public string getNonMedicationsString()
    {
        DataSet NonMedicationsDataSet = new DataSet();
        string NonMedicationsString = string.Empty;
        SqlParameter[] _objectSqlParmeters = null;
        try
        {
            string DateOfService = string.Empty;
            DateOfService = Convert.ToString(Request.Form["DateOfService"]);
            if (string.IsNullOrEmpty(DateOfService) || DateOfService == "null")
            {
                DateOfService = DateTime.Now.ToShortDateString();
            }
            _objectSqlParmeters = new SqlParameter[2];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            _objectSqlParmeters[1] = new SqlParameter("@DateOfService", DateOfService);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_GetPsychiatricNoteDisconMedications", NonMedicationsDataSet, new string[] { "DiscontinuedMedications" }, _objectSqlParmeters);
            if (NonMedicationsDataSet != null)
            {
                NonMedicationsString = NonMedicationsDataSet.GetXml().ToString();
            }
            return NonMedicationsString;
        }
        finally
        {
            if (NonMedicationsDataSet != null) NonMedicationsDataSet.Dispose();
            _objectSqlParmeters = null;
        }


    }

    public string VitalsCheck(string DateOfService, int ServiceId)
    {

        DataSet VitalsDataSet = new DataSet();
        string VitalString = string.Empty;
        SqlParameter[] _objectSqlParmeters = null;
        try
        {
            _objectSqlParmeters = new SqlParameter[3];
            _objectSqlParmeters[0] = new SqlParameter("@ClientId", SHS.BaseLayer.BaseCommonFunctions.ApplicationInfo.Client.ClientId);
            _objectSqlParmeters[1] = new SqlParameter("@ServiceId", ServiceId);
            _objectSqlParmeters[2] = new SqlParameter("@DateOfService", DateOfService);
            SqlHelper.FillDataset(Connection.ConnectionString, CommandType.StoredProcedure, "csp_VitalsCheck", VitalsDataSet, new string[] { "Vitals" }, _objectSqlParmeters);
            if (VitalsDataSet != null)
            {
                VitalString = VitalsDataSet.GetXml().ToString();
            }
            return VitalString;
        }
        finally
        {
            if (VitalsDataSet != null) VitalsDataSet.Dispose();
            _objectSqlParmeters = null;
        }

    }




}






[Serializable]
public class CurrentDataSet
{
    public string AutoSaveXml { get; set; }
}