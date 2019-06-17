using KellermanSoftware.CompareNetObjects;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

using SC.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Core.Objects;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using SC.Api.Models;
using SC.Base;
using System.Data.Entity.Validation;
using System.Web;

namespace SC.Api
{
    /// <summary>
    /// AppointmentRepository used for all appointment and Service realted functionalities
    /// </summary>
    public class AppointmentRepository : IAppointmentRepository
    {
        #region Variables
        private static SCMobile _ctx;
        object validations = null;
        DataTable dtValidations = new DataTable();
        dynamic jsonObject = new JObject();
        static SqlParameter[] _parameters = null;
        Document doc = new Document();
        Data.DocumentVersion dv = new Data.DocumentVersion();
        Data.Service service = new Data.Service();
        Data.Appointment appt = new Data.Appointment();
        GenericRepository repository = new GenericRepository();
        BriefcaseRepositiry _bcRepository;
        MyTracer tracer = new MyTracer();
        #endregion
        /// <summary>
        /// Constructor for AppointmentRepository
        /// </summary>
        /// <param name="ctx"></param>
        public AppointmentRepository(SCMobile ctx)
        {
            _ctx = ctx;
            _bcRepository = new BriefcaseRepositiry(_ctx);
        }

        /// <summary>
        /// Used for Saving Service and non service appointments
        /// </summary>
        /// <param name="appointment"></param>
        /// <param name="loggedInUser"></param>
        /// <returns></returns>
        public async Task<_SCResult<Models.AppointmentModel>> Save(Models.AppointmentModel appointment, int loggedInUser)
        {
            jsonObject = new JObject();
            var bRepo = new BriefcaseRepositiry(new SCMobile());
            var _Ce = new _SCResult<Models.AppointmentModel>();
            int appointmentId = appointment.AppointmentId;
            var briefcaseType = appointment.Service == null ? CommonDBFunctions.GetGlobalCodeId("BRIEFCASETYPE", "APPOINTMENT") : CommonDBFunctions.GetGlobalCodeId("BRIEFCASETYPE", "SERVICE");
            try
            {
                //New Entry
                if (appointmentId < 0)
                {
                    appt = ConvertToEntity(appointment);

                    #region Appointment & Services
                    appointmentId = await SaveServiceAppointment(appointment, appointmentId);
                    #endregion
                    if (appt.Service != null)
                    {
                        #region Documents
                        SaveDocuments(appointment);
                        #endregion

                        #region DocumentVersions
                        SaveDocumentVersions(appointment);
                        #endregion

                        #region Goals ,Objectives And Diagnosis
                        //SaveDiagnosisGoalsAndObjectives(appointment, dv.DocumentVersionId);
                        bool hasGoalChange = SaveGoals(appointment, dv.DocumentVersionId, ref _ctx);
                        bool hasObjectiveChange = SaveObjective(appointment, dv.DocumentVersionId, ref _ctx);
                        bool hasDiagnosisChange = SaveDiagnosis(appointment, ref _ctx);
                        if (hasGoalChange || hasObjectiveChange || hasDiagnosisChange)
                            _ctx.SaveChanges();
                        #endregion

                        #region Custom

                        #region CustomFields
                        if (appointment.Service != null && appointment.Service.CustomFields != null && appt.ServiceId > 0)
                        {
                            repository.Save(appointment.Service.CustomFields.ToString(), Convert.ToInt32(appt.ServiceId), "ServiceId");
                        }
                        #endregion

                        #region Note
                        if (appointment.Service != null && appointment.Service.Document != null
                            && appointment.Service.Document.DocumentVersion != null && appointment.Service.Document.DocumentVersion.Note != null
                            && !string.IsNullOrEmpty(appointment.Service.Document.DocumentVersion.Note.ToString()))
                        {
                            repository.Save(appointment.Service.Document.DocumentVersion.Note.ToString(), dv.DocumentVersionId, "DocumentVersionId");
                        }
                        #endregion

                        #endregion

                        #region Post Update StoredProcedure Logic
                        _ctx.Smsp_ExecutePostUpdateLogic(appt.ServiceId, loggedInUser);
                        #endregion
                    }

                    ServiceValidationAndSigning(loggedInUser, appt.AppointmentId);
                }
                //Update
                else
                {
                    List<Difference> differences = new List<Difference>();
                    JObject noteDiff = null;
                    JObject cfDiff = null;
                    bool isNoteHasDiff = false;
                    bool isCfHasDiff = false;
                    int status = 0;

                    //Check the Current status of the document. If status is 'signed' igore the change and return the datbase record.
                    if (appointment.ServiceId != null)
                    {
                        status = _ctx.Documents
                                           .Where(a => a.DocumentId == appointment.Service.Document.DocumentId && a.RecordDeleted != "Y")
                                           .Select(a => a.Status)
                                           .FirstOrDefault();

                        if (status != 22) {
                            var pc = _ctx.ProcedureCodes
                       .Where(p => p.ProcedureCodeId == appointment.Service.ProcedureCodeId)
                       .Select(p => new ProcedureModel()
                       {
                           ProcedureCodeId = p.ProcedureCodeId,
                           EnteredAs = p.EnteredAs,
                           RequiresTimeInTimeOut = p.RequiresTimeInTimeOut
                       }).FirstOrDefault();

                            appointment.StartTime = Convert.ToDateTime(appointment.Service.DateOfService);
                            if (pc.EnteredAs == 110)
                            {
                                appointment.Service.EndDateOfService = appointment.EndTime = Convert.ToDateTime(appointment.Service.DateOfService).AddMinutes(Convert.ToDouble(appointment.Service.Unit));
                            }
                            else if (pc.EnteredAs == 111)
                            {
                                appointment.Service.EndDateOfService = appointment.EndTime = appointment.Service.DateOfService.AddHours(Convert.ToDouble(appointment.Service.Unit));
                            }
                            else if (pc.EnteredAs == 112)
                            {
                                appointment.Service.EndDateOfService = appointment.EndTime = appointment.Service.DateOfService.AddDays(Convert.ToDouble(appointment.Service.Unit));
                            }
                            else
                            {
                                appointment.Service.EndDateOfService = appointment.EndTime = appointment.Service.DateOfService;
                            }
                            if (pc.RequiresTimeInTimeOut == "Y")
                            {
                                if (appointment.Service.Status == 71 || appointment.Service.Status == 75)
                                {
                                    appointment.Service.DateTimeIn = appointment.Service.DateOfService;
                                    appointment.Service.DateTimeOut = appointment.Service.EndDateOfService;
                                }
                            }
                        }
                    }

                    if (status != 22 && IsDataModified(appointment.AppointmentId, loggedInUser, briefcaseType, appointment, out differences, out noteDiff, out isNoteHasDiff, out cfDiff, out isCfHasDiff))
                    {
                        #region Other Update
                        if (differences != null && differences.Count > 0)
                        {
                            int index = 0;
                            foreach (var diff in differences)
                            {
                                var propertyName = GetParentObjectName(diff.ParentPropertyName).ToLower();


                                if (propertyName.IndexOf('[') > 0)
                                    propertyName = GetParentObjectName(diff.ParentPropertyName).ToLower().Remove(GetParentObjectName(diff.ParentPropertyName).Length - 3, 3);

                                if (GetParentObjectName(diff.PropertyName).ToLower() == "documentservicenotegoals" || GetParentObjectName(diff.PropertyName).ToLower() == "documentservicenoteobjectives")
                                    propertyName = GetParentObjectName(diff.PropertyName).ToLower();
                                switch (propertyName)
                                {
                                    //Appointment
                                    case "":
                                        {
                                            var appoint = _ctx.Appointments
                                                .Where(a => a.AppointmentId == appointment.AppointmentId && a.RecordDeleted != "Y").FirstOrDefault();
                                            CommonFunctions.SetProperty(diff.PropertyName, appoint, diff.Object1Value);
                                        }
                                        break;
                                    case "service":
                                        {
                                            var service = _ctx.Services
                                                .Where(s => s.ServiceId == appointment.ServiceId && s.RecordDeleted != "Y").FirstOrDefault();
                                            CommonFunctions.SetProperty(diff.PropertyName, service, diff.Object1Value);
                                        }
                                        break;
                                    case "diagnosis":
                                        //TODO
                                        {
                                            int.TryParse(diff.ParentPropertyName.Substring(diff.ParentPropertyName.Length - 2, 1), out index);

                                            var diagnosis = _ctx.ServiceDiagnosis
                                                .Where(s => s.ServiceId == appointment.ServiceId && s.RecordDeleted != "Y").ToList();

                                            if (diagnosis.Count > 0)
                                            {
                                                var diag = diagnosis[index];
                                                CommonFunctions.SetProperty(diff.PropertyName, diag, diff.Object1Value);
                                            }
                                        }
                                        break;
                                    case "document":
                                        {
                                            var doc = _ctx.Documents
                                           .Where(a => a.DocumentId == appointment.Service.Document.DocumentId && a.RecordDeleted != "Y").FirstOrDefault();

                                            CommonFunctions.SetProperty(diff.PropertyName, doc, diff.Object1Value);
                                        }
                                        break;
                                    case "documentversion":
                                        {
                                            var docV = _ctx.DocumentVersions
                                                .Where(dv => dv.DocumentVersionId == appointment.Service.Document.CurrentDocumentVersionId && dv.RecordDeleted != "Y").FirstOrDefault();

                                            //diff.ChildPropertyName value is "Count" mean there is a new addition to the array
                                            if (diff.ChildPropertyName == "Count" && diff.Object1TypeName.TrimEnd('[', ']') == "DocumentServiceNoteGoal")
                                            {
                                                var documentServiceNoteGoals = JsonConvert.DeserializeObject<ICollection<Data.DocumentServiceNoteGoal>>(JsonConvert.SerializeObject(appointment.Service.Document.DocumentVersion.DocumentServiceNoteGoals.Where(a => a.DocumentServiceNoteGoalId < 0)));

                                                foreach (var item in documentServiceNoteGoals)
                                                {
                                                    item.DocumentVersionId = docV.DocumentVersionId;
                                                    _ctx.DocumentServiceNoteGoals.Add(item);
                                                }

                                            }
                                            else if (diff.ChildPropertyName == "Count" && diff.Object1TypeName.TrimEnd('[', ']') == "DocumentServiceNoteObjective")
                                            {
                                                var documentServiceNoteObjectives = JsonConvert.DeserializeObject<ICollection<Data.DocumentServiceNoteObjective>>(JsonConvert.SerializeObject(appointment.Service.Document.DocumentVersion.DocumentServiceNoteObjectives.Where(a => a.DocumentServiceNoteObjectiveId < 0)));

                                                foreach (var item in documentServiceNoteObjectives)
                                                {
                                                    item.DocumentVersionId = docV.DocumentVersionId;
                                                    _ctx.DocumentServiceNoteObjectives.Add(item);
                                                }
                                            }
                                            else { CommonFunctions.SetProperty(diff.PropertyName, docV, diff.Object1Value); }

                                            //SC.Base.CommonFunctions.SetProperty(diff.PropertyName, docV, diff.Object1Value);
                                        }
                                        break;
                                    case "documentservicenotegoals":
                                        //var indGoal
                                        //SaveGoals(appointment, Convert.ToInt32(appointment.Service.Document.CurrentDocumentVersionId), ref _ctx);
                                        int.TryParse(diff.ParentPropertyName.Substring(diff.ParentPropertyName.Length - 2, 1), out index);

                                        var goals = _ctx.DocumentServiceNoteGoals
                                            .Where(s => s.DocumentVersionId == appointment.Service.Document.InProgressDocumentVersionId && s.RecordDeleted != "Y").ToList();

                                        if (goals.Count > 0)
                                        {
                                            var goal = goals[index];
                                            CommonFunctions.SetProperty(diff.PropertyName, goal, diff.Object1Value);
                                        }
                                        else
                                        {
                                            var documentServiceNoteGoals = JsonConvert.DeserializeObject<ICollection<Data.DocumentServiceNoteGoal>>(JsonConvert.SerializeObject(appointment.Service.Document.DocumentVersion.DocumentServiceNoteGoals));

                                            foreach (var item in documentServiceNoteGoals)
                                            {
                                                var sg = _ctx.DocumentServiceNoteGoals
                                                        .Where(a => a.DocumentServiceNoteGoalId == item.DocumentServiceNoteGoalId && a.DocumentVersionId == item.DocumentVersionId).FirstOrDefault();

                                                if (sg == null)
                                                {
                                                    _ctx.DocumentServiceNoteGoals.Add(item);
                                                }
                                            }
                                        }

                                        break;
                                    case "documentservicenoteobjectives":
                                        int.TryParse(diff.ParentPropertyName.Substring(diff.ParentPropertyName.Length - 2, 1), out index);

                                        var objectives = _ctx.DocumentServiceNoteObjectives
                                            .Where(s => s.DocumentVersionId == appointment.Service.Document.InProgressDocumentVersionId && s.RecordDeleted != "Y").ToList();

                                        if (objectives.Count > 0)
                                        {
                                            var objective = objectives[index];
                                            CommonFunctions.SetProperty(diff.PropertyName, objective, diff.Object1Value);
                                        }
                                        else
                                        {
                                            var documentServiceNoteObjectives = JsonConvert.DeserializeObject<ICollection<Data.DocumentServiceNoteObjective>>(JsonConvert.SerializeObject(appointment.Service.Document.DocumentVersion.DocumentServiceNoteObjectives));
                                            foreach (var item in documentServiceNoteObjectives)
                                            {
                                                var so = _ctx.DocumentServiceNoteObjectives
                                                        .Where(a => a.DocumentServiceNoteObjectiveId == item.DocumentServiceNoteObjectiveId && a.DocumentVersionId == item.DocumentVersionId).FirstOrDefault();

                                                if (so == null)
                                                {
                                                    _ctx.DocumentServiceNoteObjectives.Add(item);
                                                }
                                            }
                                        }
                                        break;
                                }
                            }
                            _ctx.SaveChanges();
                        }

                        #endregion

                        #region Note Update
                        if (isNoteHasDiff)// By default DocumentVersionId will be Present.
                        {
                            string noteJSONString = string.Empty;

                            if (noteDiff.Properties().Count() > 0)
                            {
                                var note = JsonConvert.DeserializeObject<Dictionary<string, object>>(appointment.Service.Document.DocumentVersion.Note.ToString());
                                foreach (var item in note)
                                {
                                    note[item.Key] = "[" + noteDiff.ToString() + "]";
                                    break;//Should go only once
                                }
                                noteJSONString = JsonConvert.SerializeObject(note);
                            }
                            else
                                noteJSONString = appointment.Service.Document.DocumentVersion.Note.ToString();

                            if (!string.IsNullOrEmpty(noteJSONString))
                                repository.Save(noteJSONString, appointment.Service.Document.CurrentDocumentVersionId, "DocumentVersionId");
                        }
                        #endregion

                        #region Custom Field Update
                        if (isCfHasDiff)// By default DocumentVersionId will be Present.
                        {
                            string cfJSONString = string.Empty;


                            if (noteDiff.Properties().Count() > 0)
                            {
                                var cf = JsonConvert.DeserializeObject<Dictionary<string, object>>(appointment.Service.CustomFields.ToString());
                                foreach (var item in cf)
                                {
                                    cf[item.Key] = "[" + cfDiff.ToString() + "]";
                                    break;//Should go only once
                                }
                                cfJSONString = JsonConvert.SerializeObject(cf);
                            }
                            else
                                cfJSONString = appointment.Service.CustomFields.ToString();

                            if (!string.IsNullOrEmpty(cfJSONString))
                                repository.Save(cfJSONString, appointment.Service.ServiceId, "ServiceId");
                        }
                        #endregion

                    }

                    #region Post Update StoredProcedure Logic
                    _ctx.Smsp_ExecutePostUpdateLogic(appointment.ServiceId, loggedInUser);
                    #endregion

                    if (status != 22 && status > 0)
                        ServiceValidationAndSigning(loggedInUser, appointment.AppointmentId);
                }

                //ServiceValidationAndSigning(loggedInUser, appointmentId);
                var app = bRepo.GetAppointment(appointmentId);

                if (app != null)
                {
                    jsonObject.Subject = app.Subject;
                    jsonObject.Start = app.StartTime;
                    jsonObject.End = app.EndTime;

                    if (app.Service != null)
                        jsonObject.Redirect = "#/service/" + app.AppointmentId.ToString();

                    if (validations != null)
                    {
                        app.Service.ServiceValidations = validations;
                        _Ce.DeleteUnsavedChanges = false;
                        _Ce.ShowDetails = true;
                        _Ce.ServiceValidationMessages = validations;
                    }
                    else
                    { _Ce.DeleteUnsavedChanges = true; _Ce.ShowDetails = false; }

                    _Ce.SavedId = app.AppointmentId;
                    _Ce.SavedResult = app;
                }
                else
                {
                    _Ce.ShowDetails = false;
                    _Ce.DeleteUnsavedChanges = true;
                }

                _Ce.Details = jsonObject;
                _Ce.UnsavedId = appointment.AppointmentId;
                _Ce.LocalstoreName = "calendarevent";
                _Ce.LocalName = "Service Appointment";

                if (app != null)
                    CommonFunctions<Models.StaffPreferenceModel>.CreateUpdateBriefcase(app.AppointmentId, app, loggedInUser, briefcaseType);

            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.Save method." + ex.Message);
                throw excep;
            }

            return _Ce;
        }

        /// <summary>
        /// Returns programName based on ProgramId
        /// </summary>
        /// <param name="programId"></param>
        /// <returns></returns>
        internal static string GetProgramName(int programId)
        {
            try
            {
                return _ctx.Programs.
                Where(p => p.ProgramId == programId).FirstOrDefault().ProgramName;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetProgramName method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Returns LocationName based on ProgramId
        /// </summary>
        /// <param name="locationId"></param>
        /// <returns></returns>
        internal static string GetLocationName(int? locationId)
        {
            try
            {
                return _ctx.Locations.
                Where(p => p.LocationId == locationId).FirstOrDefault().LocationName;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetLocationName method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Returns ProcedureCodeName based on ProgramId
        /// </summary>
        /// <param name="procedureCodeId"></param>
        /// <returns></returns>
        internal static string GetProcedureCodeName(int procedureCodeId)
        {
            try
            {
                return _ctx.ProcedureCodes.
                Where(p => p.ProcedureCodeId == procedureCodeId).FirstOrDefault().ProcedureCodeName;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetProcedureCodeName method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Used to save Diagnosis
        /// </summary>
        /// <param name="appointment"></param>
        /// <param name="_ctx"></param>
        /// <returns></returns>
        private bool SaveDiagnosis(Models.AppointmentModel appointment, ref SCMobile _ctx)
        {
            try
            {
                bool hasChages = false;

                #region Diagnosis
                if (appointment.Service.Diagnosis != null)
                {
                    var serviceDiagnosis = JsonConvert.DeserializeObject<ICollection<ServiceDiagnosi>>(JsonConvert.SerializeObject(appointment.Service.Diagnosis));

                    foreach (var item in serviceDiagnosis)
                    {
                        var sg = _ctx.ServiceDiagnosis
                                .Where(a => a.ServiceDiagnosisId == item.ServiceDiagnosisId).FirstOrDefault();

                        if (sg == null)
                        {
                            item.ServiceId = appt.ServiceId;
                            _ctx.ServiceDiagnosis.Add(item);
                            hasChages = true;
                        }
                        else
                        {
                            sg.Order = item.Order;
                            hasChages = true;
                        }
                    }

                }
                #endregion

                return hasChages;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.SaveDiagnosis method." + ex.Message);
                throw excep;
            }

        }

        /// <summary>
        /// Used to Save Addressed Goals
        /// </summary>
        /// <param name="appointment"></param>
        /// <param name="documentVersionId"></param>
        /// <param name="_ctx"></param>
        /// <returns></returns>
        private bool SaveGoals(Models.AppointmentModel appointment, int documentVersionId, ref SCMobile _ctx)
        {
            try
            {
                bool hasChages = false;

                #region Goal
                if (appointment.Service.Document.DocumentVersion.DocumentServiceNoteGoals != null)
                {
                    var documentServiceNoteGoals = JsonConvert.DeserializeObject<ICollection<Data.DocumentServiceNoteGoal>>(JsonConvert.SerializeObject(appointment.Service.Document.DocumentVersion.DocumentServiceNoteGoals));

                    foreach (var item in documentServiceNoteGoals)
                    {
                        var sg = _ctx.DocumentServiceNoteGoals
                                .Where(a => a.DocumentServiceNoteGoalId == item.DocumentServiceNoteGoalId && a.DocumentVersionId == documentVersionId).FirstOrDefault();

                        if (sg == null)
                        {
                            item.DocumentVersionId = documentVersionId;
                            _ctx.DocumentServiceNoteGoals.Add(item);
                            hasChages = true;
                        }
                        else
                        {
                            sg.RecordDeleted = item.RecordDeleted;
                            sg.DeletedDate = item.DeletedDate;
                            sg.DeletedBy = item.DeletedBy;
                        }
                    }
                }
                #endregion

                return hasChages;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.SaveGoals method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Used to save the Addressed Objectives
        /// </summary>
        /// <param name="appointment"></param>
        /// <param name="documentVersionId"></param>
        /// <param name="_ctx"></param>
        /// <returns></returns>
        private bool SaveObjective(Models.AppointmentModel appointment, int documentVersionId, ref SCMobile _ctx)
        {
            try
            {
                bool hasChages = false;

                #region Objective
                if (appointment.Service.Document.DocumentVersion.DocumentServiceNoteObjectives != null)
                {
                    var documentServiceNoteObjectives = JsonConvert.DeserializeObject<ICollection<Data.DocumentServiceNoteObjective>>(JsonConvert.SerializeObject(appointment.Service.Document.DocumentVersion.DocumentServiceNoteObjectives));
                    foreach (var item in documentServiceNoteObjectives)
                    {
                        var so = _ctx.DocumentServiceNoteObjectives
                                .Where(a => a.DocumentServiceNoteObjectiveId == item.DocumentServiceNoteObjectiveId && a.DocumentVersionId == documentVersionId).FirstOrDefault();

                        if (so == null)
                        {
                            item.DocumentVersionId = documentVersionId;
                            _ctx.DocumentServiceNoteObjectives.Add(item);
                            hasChages = true;
                        }
                        else
                        {
                            so.RecordDeleted = item.RecordDeleted;
                            so.DeletedDate = item.DeletedDate;
                            so.DeletedBy = item.DeletedBy;
                        }
                    }
                }
                #endregion

                return hasChages;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.SaveObjective method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get the Parent Object name for differential Merge.
        /// </summary>
        /// <param name="parentPropertyName"></param>
        /// <returns></returns>
        private string GetParentObjectName(string parentPropertyName)
        {
            try
            {
                if (!string.IsNullOrEmpty(parentPropertyName))
                    return parentPropertyName.Split('.').Last();
                else
                    return string.Empty;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetParentObjectName method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Returns validation while signing service/note
        /// </summary>
        /// <param name="loggedInUser"></param>
        /// <param name="apptId"></param>
        private void ServiceValidationAndSigning(int loggedInUser, int apptId)
        {
            try
            {
                appt = _ctx.Appointments
                .Where(a => a.AppointmentId == apptId).FirstOrDefault();

                #region Service Validations
                if (appt != null && appt.Service != null && appt.Service.Documents != null)
                {
                    if (appt.Service.Documents.Any(a => a.Status == 24))
                    {
                        dtValidations.Clear();
                        dtValidations.Merge(repository.ValidateService((int)appt.ServiceId, "ServiceId", loggedInUser));
                        dtValidations.Merge(repository.ValidateService((int)appt.Service.Documents.FirstOrDefault().DocumentId, "DocumentId", loggedInUser));

                        if (dtValidations != null && dtValidations.Rows.Count > 0)
                        {
                            var doc = _ctx.Documents
                                .Where(a => a.ServiceId == appt.ServiceId && a.Status == 24).FirstOrDefault();
                            if (doc != null)
                            {
                                doc.ToSign = "Y";
                                _ctx.SaveChanges();
                            }
                            validations = JsonConvert.DeserializeObject(JsonConvert.SerializeObject(dtValidations));
                        }
                    }
                }
                #endregion

                #region Sign Document if no validation exist
                if (appt.Service != null && validations == null)
                {
                    var doc = _ctx.Documents
                        .Where(a => a.ServiceId == appt.ServiceId && a.Status == 24).FirstOrDefault();

                    if (doc != null)
                    {
                        doc.Status = 22;
                        doc.CurrentVersionStatus = 22;
                        doc.ToSign = "N";

                        DocumentPDFGenerationQueue queue = new DocumentPDFGenerationQueue();
                        queue.DocumentPDFGenerationQueueId = -1;
                        queue.CreatedBy = "Api";
                        queue.CreatedDate = DateTime.Now;
                        queue.ModifiedBy = "Api";
                        queue.ModifiedDate = DateTime.Now;
                        queue.DocumentVersionId = Convert.ToInt32(doc.InProgressDocumentVersionId);

                        _ctx.DocumentPDFGenerationQueue.Add(queue);

                        _ctx.SaveChanges();

                        #region Post Signature StoredProcedure Logic
                        _ctx.Smsp_ExecutePostSignatureLogic(appt.ServiceId, loggedInUser);
                        #endregion
                    }
                }
                #endregion
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.ServiceValidationAndSigning method." + ex.Message);
                throw excep;
            }

        }

        /// <summary>
        /// Used to save DocumentVersions
        /// </summary>
        /// <param name="appointment"></param>
        private void SaveDocumentVersions(Models.AppointmentModel appointment)
        {
            try
            {
                var documentVersion = (from d in _ctx.Documents
                                       join dverv in _ctx.DocumentVersions on d.DocumentId equals dverv.DocumentId
                                       where d.DocumentId == doc.DocumentId
                                       select dverv).FirstOrDefault();
                if (documentVersion == null)
                {
                    dv = new Data.DocumentVersion()
                    {
                        DocumentVersionId = appointment.Service.Document.DocumentVersion.DocumentVersionId,
                        CreatedBy = appointment.Service.Document.DocumentVersion.CreatedBy != null ? appointment.Service.Document.DocumentVersion.CreatedBy : HttpContext.Current.Session["createdBy"].ToString(),
                        CreatedDate = DateTime.Now,  
                        ModifiedBy = appointment.Service.Document.DocumentVersion.ModifiedBy != null ? appointment.Service.Document.DocumentVersion.ModifiedBy : HttpContext.Current.Session["createdBy"].ToString(),
                        ModifiedDate = DateTime.Now,  
                        RecordDeleted = appointment.Service.Document.DocumentVersion.RecordDeleted,
                        DeletedDate = appointment.Service.Document.DocumentVersion.DeletedDate,
                        DeletedBy = appointment.Service.Document.DocumentVersion.DeletedBy,
                        DocumentId = doc.DocumentId,
                        Version = appointment.Service.Document.DocumentVersion.Version,
                        AuthorId = appointment.Service.Document.DocumentVersion.AuthorId,
                        EffectiveDate = appointment.Service.Document.DocumentVersion.EffectiveDate
                    };

                    _ctx.DocumentVersions.Add(dv);
                    _ctx.SaveChanges();
                    var currentDocument = _ctx.Documents.FirstOrDefault(a => a.DocumentId == dv.DocumentId);

                    currentDocument.InProgressDocumentVersionId = dv.DocumentVersionId;
                    currentDocument.CurrentDocumentVersionId = dv.DocumentVersionId;
                    _ctx.SaveChanges();
                }
                else
                {
                    dv = _ctx.DocumentVersions.FirstOrDefault(dversion => dversion.DocumentId == doc.DocumentId);
                }
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.SaveDocumentVersions method." + ex.Message);
                throw excep;
            }

        }

        /// <summary>
        /// USed to save Documents
        /// </summary>
        /// <param name="appointment"></param>
        private void SaveDocuments(Models.AppointmentModel appointment)
        {
            try
            {
                var documentExist = _ctx.Documents.Any(s => s.AppointmentId == appt.AppointmentId);

                if (!documentExist)
                {
                    doc = new Data.Document()
                    {
                        DocumentId = appointment.Service.Document.DocumentId,
                        CreatedBy = appointment.Service.Document.CreatedBy != null ? appointment.Service.Document.CreatedBy : HttpContext.Current.Session["createdBy"].ToString(),
                        CreatedDate = DateTime.Now,  
                        ModifiedBy = appointment.Service.Document.ModifiedBy !=null ? appointment.Service.Document.ModifiedBy : HttpContext.Current.Session["createdBy"].ToString(),
                        ModifiedDate = DateTime.Now, 
                        RecordDeleted = appointment.Service.Document.RecordDeleted,
                        DeletedDate = appointment.Service.Document.DeletedDate,
                        DeletedBy = appointment.Service.Document.DeletedBy,
                        ClientId = appointment.Service.Document.ClientId,
                        ServiceId = appt.ServiceId,
                        DocumentCodeId = appointment.Service.Document.DocumentCodeId,
                        EffectiveDate = appointment.Service.Document.EffectiveDate,
                        Status = appointment.Service.Document.Status,
                        AuthorId = appointment.Service.Document.AuthorId,
                        CurrentVersionStatus = appointment.Service.Document.CurrentVersionStatus,
                        AppointmentId = appt.AppointmentId,
                        SignedByAll = appointment.Service.Document.SignedByAll,
                        SignedByAuthor = appointment.Service.Document.SignedByAuthor,

                    };

                    _ctx.Documents.Add(doc);
                    _ctx.SaveChanges();
                }
                else
                {
                    doc = _ctx.Documents.FirstOrDefault(d => d.AppointmentId == appt.AppointmentId);
                    doc.Status = appointment.Service.Document.Status;
                    doc.CurrentVersionStatus = appointment.Service.Document.CurrentVersionStatus;
                    _ctx.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.SaveDocuments method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Saves Service and Appointments table
        /// </summary>
        /// <param name="appointment"></param>
        /// <param name="appointmentId"></param>
        /// <returns></returns>
        private async Task<int> SaveServiceAppointment(Models.AppointmentModel appointment, int appointmentId)
        {
            try
            {
                _ctx.Appointments.Add(appt);
                if (appointment.AppointmentId > 0)
                {
                    _ctx.Entry(appt).State = EntityState.Modified;
                    if (appt.Service != null)
                        _ctx.Entry(appt.Service).State = EntityState.Modified;
                }
                await _ctx.SaveChangesAsync();

                appointmentId = appt.AppointmentId;
                return appointmentId;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.SaveServiceAppointment method." + ex.Message);
                throw excep;
            }

        }

        /// <summary>
        /// Returns Service Diagnosis
        /// </summary>
        /// <param name="service"></param>
        /// <returns></returns>
        internal static Models.ServiceDiagnosModel[] GetDiagnosis(Data.Service service)
        {
            try
            {
                _ctx = new SCMobile();

                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx.smsp_GetServiceDiagnosis_StringReturn(service.ServiceId, OutputParamter);

                var obj = JsonConvert.DeserializeObject<Models.ServiceDiagnosModel[]>(OutputParamter.Value.ToString());
                return obj;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetDiagnosis method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Retusn Saved Addressed Goals based on DocumentVersionId
        /// </summary>
        /// <param name="documentVersionId"></param>
        /// <returns></returns>
        internal static Models.DocumentServiceNoteGoalModel[] GetDocumentServiceNoteGoals(int documentVersionId)
        {
            try
            {
                _ctx = new SCMobile();

                return _ctx.DocumentServiceNoteGoals
                    .Where(a => a.DocumentVersionId == documentVersionId && a.RecordDeleted != "Y")
                    .Select(b => new Models.DocumentServiceNoteGoalModel()
                    {
                        DocumentServiceNoteGoalId = b.DocumentServiceNoteGoalId,
                        CreatedBy = b.CreatedBy,
                        CreatedDate = b.CreatedDate,
                        ModifiedBy = b.ModifiedBy,
                        ModifiedDate = b.ModifiedDate,
                        RecordDeleted = b.RecordDeleted,
                        DeletedDate = b.DeletedDate,
                        DeletedBy = b.DeletedBy,
                        DocumentVersionId = b.DocumentVersionId,
                        GoalId = b.GoalId,
                        GoalNumber = b.GoalNumber,
                        GoalText = b.GoalText,
                        CustomGoalActive = b.CustomGoalActive
                    }).ToArray();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetDocumentServiceNoteGoals method." + ex.Message);
                throw excep;
            }

        }

        /// <summary>
        /// Retusn Saved Addressed Objectives based on DocumentVersionId
        /// </summary>
        /// <param name="documentVersionId"></param>
        /// <returns></returns>
        internal static Models.DocumentServiceNoteObjectiveModel[] GetDocumentServiceNoteObjectives(int documentVersionId)
        {
            try
            {
                _ctx = new SCMobile();
                return _ctx.DocumentServiceNoteObjectives
                                .Where(a => a.DocumentVersionId == documentVersionId && a.RecordDeleted != "Y")
                                .Select(b => new Models.DocumentServiceNoteObjectiveModel()
                                {
                                    DocumentServiceNoteObjectiveId = b.DocumentServiceNoteObjectiveId,
                                    CreatedBy = b.CreatedBy,
                                    CreatedDate = b.CreatedDate,
                                    ModifiedBy = b.ModifiedBy,
                                    ModifiedDate = b.ModifiedDate,
                                    RecordDeleted = b.RecordDeleted,
                                    DeletedDate = b.DeletedDate,
                                    DeletedBy = b.DeletedBy,
                                    DocumentVersionId = b.DocumentVersionId,
                                    GoalId = b.GoalId,
                                    ObjectiveNumber = b.ObjectiveNumber,
                                    ObjectiveText = b.ObjectiveText,
                                    CustomObjectiveActive = b.CustomObjectiveActive
                                }).ToArray();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetProgramName method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Convert to Data entity from the JSON request.
        /// </summary>
        /// <param name="appModel"></param>
        /// <returns></returns>
        public Appointment ConvertToEntity(Models.AppointmentModel appModel)
        {
            try
            {
                appt = new Data.Appointment()
                {
                    AppointmentId = appModel.AppointmentId,
                    StaffId = appModel.StaffId,
                    Subject = appModel.Subject,
                    StartTime = Convert.ToDateTime(appModel.StartTime),
                    //EndTime = Convert.ToDateTime(appModel.EndTime),
                    AppointmentType = appModel.AppointmentType,
                    Description = appModel.Description,
                    ShowTimeAs = appModel.ShowTimeAs,
                    LocationId = appModel.LocationId,
                    SpecificLocation = appModel.SpecificLocation,
                    ServiceId = appModel.ServiceId,
                    CreatedBy = appModel.CreatedBy != null ? appModel.CreatedBy : HttpContext.Current.Session["createdBy"].ToString(),
                    CreatedDate = DateTime.Now,
                    ModifiedBy = appModel.ModifiedBy != null? appModel.ModifiedBy : HttpContext.Current.Session["createdBy"].ToString(),
                    ModifiedDate = DateTime.Now,
                    RecordDeleted = appModel.RecordDeleted,
                    DeletedBy = appModel.DeletedBy,
                    DeletedDate = appModel.DeletedDate,
                    Service = getService(ref appModel),
                    EndTime = Convert.ToDateTime(appModel.EndTime),
                };

                return appt;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.ConvertToEntity method." + ex.Message);
                throw excep;
            }
        }

        public Appointment ConvertToEntityFromPCRequestModel(Models.PrimaryCareAppointmentRequestModel appModel)
        {
            try
            {
                var currentStaff = (CurrentLoggedInStaff)HttpContext.Current.Session["CurrentStaff"];
                appt = new Data.Appointment()
                {
                    AppointmentId = -1,
                    StaffId = currentStaff.StaffId,
                    Subject = appModel.Subject,
                    StartTime = Convert.ToDateTime(appModel.StartTime),
                    EndTime = Convert.ToDateTime(appModel.EndTime),
                    AppointmentType = appModel.AppointmentType,
                    Description = appModel.Description,
                    ShowTimeAs = appModel.ShowTimeAs,
                    LocationId = appModel.LocationId,
                    SpecificLocation = appModel.SpecificLocation,
                    CreatedBy = currentStaff.UserCode,
                    CreatedDate = DateTime.Now,
                    ModifiedBy = currentStaff.UserCode,
                    ModifiedDate = DateTime.Now
                };

                return appt;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.ConvertToEntityFromPCRequestModel method." + ex.Message);
                throw excep;
            }
        }

        public PrimaryCareAppointmentResponseModel ConvertToPCRequestModelFromEntity(Data.Appointment appt)
        {
            try
            {
                var pcappt = new PrimaryCareAppointmentResponseModel()
                {
                    AppointmentId = appt.AppointmentId,
                    StaffId = appt.StaffId,
                    Subject = appt.Subject,
                    StartTime = Convert.ToDateTime(appt.StartTime),
                    EndTime = Convert.ToDateTime(appt.EndTime),
                    AppointmentType = appt.AppointmentType,
                    Description = appt.Description,
                    ShowTimeAs = appt.ShowTimeAs,
                    LocationId = appt.LocationId,
                    SpecificLocation = appt.SpecificLocation
                };

                return pcappt;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.ConvertToPCRequestModelFromEntity method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Returns Service Information
        /// </summary>
        /// <param name="appModel"></param>
        /// <returns></returns>
        private Data.Service getService(ref AppointmentModel appModel)
        {
            try
            {
                if (appModel.Service != null)
                {
                    var prId = appModel.Service.ProcedureCodeId;
                    var pc = _ctx.ProcedureCodes
                        .Where(p => p.ProcedureCodeId == prId)
                        .Select(p => new ProcedureModel()
                        {
                            ProcedureCodeId = p.ProcedureCodeId,
                            EnteredAs = p.EnteredAs,
                            RequiresTimeInTimeOut = p.RequiresTimeInTimeOut
                        }).FirstOrDefault();

                   service = new Data.Service()
                   {
                       ServiceId = appModel.Service.ServiceId,
                       CreatedBy = appModel.Service.CreatedBy!=null ? appModel.Service.CreatedBy : HttpContext.Current.Session["createdBy"].ToString(),      
                       CreatedDate = DateTime.Now,
                       ModifiedBy = appModel.Service.ModifiedBy != null ? appModel.Service.ModifiedBy : HttpContext.Current.Session["createdBy"].ToString(),
                       ModifiedDate = DateTime.Now,
                       ClientId = appModel.Service.ClientId,
                       ProcedureCodeId = appModel.Service.ProcedureCodeId,
                       DateOfService = Convert.ToDateTime(appModel.Service.DateOfService),
                       EndDateOfService = Convert.ToDateTime(appModel.Service.EndDateOfService),
                       Unit = appModel.Service.Unit,
                       UnitType = pc.EnteredAs,
                       Status = appModel.Service.Status,
                       ClinicianId = appModel.Service.ClinicianId,
                       AttendingId = appModel.Service.AttendingId,
                       ProgramId = appModel.Service.ProgramId,
                       LocationId = appModel.Service.LocationId,
                       //DateTimeIn = pc.RequiresTimeInTimeOut==true ?Convert.ToDateTime(appModel.Service.DateTimeIn):null,
                       //DateTimeOut = Convert.ToDateTime(appModel.Service.DateTimeOut),
                       Billable = appModel.Service.Billable,
                       SpecificLocation = appModel.Service.SpecificLocation
                       /*ServiceDiagnosis = GetServiceDiagnosis(appModel.Service)*/
                       /*Documents = createDocumentObject(appModel.Service.Document)*/
                   };
                    appModel.StartTime = service.DateOfService;
                    if (pc.EnteredAs == 110)
                    {

                        service.EndDateOfService = appModel.EndTime = service.DateOfService.AddMinutes(Convert.ToDouble(service.Unit));
                    }
                    else if (pc.EnteredAs == 111)
                    {
                        service.EndDateOfService = appModel.EndTime = service.DateOfService.AddHours(Convert.ToDouble(service.Unit));
                    }
                    else if (pc.EnteredAs == 112)
                    {
                        service.EndDateOfService = appModel.EndTime = service.DateOfService.AddDays(Convert.ToDouble(service.Unit));
                    }
                    else
                    {
                        service.EndDateOfService = appModel.EndTime =service.DateOfService;
                    }

                    if (pc.RequiresTimeInTimeOut == "Y")
                    {
                        if (service.Status == 71 || service.Status == 75)
                        {
                            service.DateTimeIn = service.DateOfService;
                            service.DateTimeOut = service.EndDateOfService;
                        }
                    }
                }
                else
                    service = null;

                return service;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.getService method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Create Model document Object
        /// </summary>
        /// <param name="document"></param>
        /// <returns></returns>
        public static Models.DocumentModel CreateModelDocument(Document document)
        {
            try
            {
                if (document != null)
                {
                    Models.DocumentModel dc = new Models.DocumentModel()
                    {
                        DocumentId = document.DocumentId,
                        CreatedBy = document.CreatedBy,
                        CreatedDate = document.CreatedDate,
                        ModifiedBy = document.ModifiedBy,
                        ModifiedDate = document.ModifiedDate,
                        ClientId = document.ClientId,
                        ServiceId = document.ServiceId,
                        DocumentCodeId = document.DocumentCodeId,
                        EffectiveDate = document.EffectiveDate,
                        Status = document.Status,
                        AuthorId = document.AuthorId,
                        CurrentDocumentVersionId = document.CurrentDocumentVersionId,
                        SignedByAll = document.SignedByAll,
                        SignedByAuthor = document.SignedByAuthor,
                        InProgressDocumentVersionId = document.InProgressDocumentVersionId,
                        CurrentVersionStatus = document.CurrentVersionStatus,
                        AppointmentId = document.AppointmentId,
                        DocumentVersion = new Models.DocumentVersionModel()
                        {
                            DocumentVersionId = document.DocumentVersion.DocumentVersionId,
                            CreatedBy = document.DocumentVersion.CreatedBy,
                            CreatedDate = document.DocumentVersion.CreatedDate,
                            ModifiedBy = document.DocumentVersion.ModifiedBy,
                            ModifiedDate = document.DocumentVersion.ModifiedDate,
                            DocumentId = document.DocumentVersion.DocumentId,
                            Version = document.DocumentVersion.Version,
                            AuthorId = document.DocumentVersion.AuthorId,
                            EffectiveDate = document.DocumentVersion.EffectiveDate,
                            Note = GetNoteDocument(document),
                            DocumentServiceNoteGoals = GetDocumentServiceNoteGoals(document.DocumentVersion.DocumentVersionId),
                            DocumentServiceNoteObjectives = GetDocumentServiceNoteObjectives(document.DocumentVersion.DocumentVersionId)
                        }
                    };

                    return dc;
                }
                else return null;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.CreateModelDocument method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Returns Note Document
        /// </summary>
        /// <param name="document"></param>
        /// <returns></returns>
        private static object GetNoteDocument(Document document)
        {
            try
            {
                int? documentVersionId = document.CurrentDocumentVersionId;
                _ctx = new SCMobile();
                var obj = (from dc in _ctx.DocumentCodes
                           where dc.DocumentCodeId == document.DocumentCodeId && dc.Mobile == "Y"
                           select new
                           {
                               StoredProcedureName = dc.StoredProcedure,
                               TableName = dc.TableList
                           }).FirstOrDefault();
                if (obj != null)
                {
                    GenericRepository repository = new GenericRepository();
                    _parameters = new SqlParameter[1];
                    _parameters[0] = new SqlParameter("@DocumentVersionId", documentVersionId);

                    return repository.Get(Convert.ToInt32(documentVersionId), _parameters, obj.StoredProcedureName, obj.TableName);
                }
                else
                    return null;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetNoteDocument method." + ex.Message);
                throw excep;
            }

        }

        /// <summary>
        /// Returns CustomFields data
        /// </summary>
        /// <param name="service"></param>
        /// <param name="CustomFieldObjectName"></param>
        /// <returns></returns>
        public static object GetCustomFields(Data.Service service, ref string CustomFieldObjectName)
        {
            try
            {
                int serviceId = service.ServiceId;
                object cs = null;
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));
                _ctx = new SCMobile();
                _ctx.smsp_GetCustomFieldJson_StringReturn(serviceId, OutputParamter);

                if (OutputParamter.Value != null && !string.IsNullOrEmpty(OutputParamter.Value.ToString()))
                {
                    cs = JsonConvert.DeserializeObject<Dictionary<string, object>>(OutputParamter.Value.ToString());
                }
                if (cs != null)
                    return JObject.Parse(JsonConvert.SerializeObject(cs));
                else
                    return null;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetCustomFields method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Identify if the Data object Modified or Not
        /// </summary>
        /// <param name="briefcaseTypeId"></param>
        /// <param name="staffId"></param>
        /// <param name="briefcaseType"></param>
        /// <param name="newObject"></param>
        /// <param name="diff"></param>
        /// <param name="noteDiff"></param>
        /// <param name="isNoteHasDiff"></param>
        /// <param name="cfDiff"></param>
        /// <param name="isCfHasDiff"></param>
        /// <returns></returns>
        public bool IsDataModified(int briefcaseTypeId, int staffId, int briefcaseType, Models.AppointmentModel newObject, out List<Difference> diff, out JObject noteDiff, out bool isNoteHasDiff, out JObject cfDiff, out bool isCfHasDiff)
        {
            try
            {
                bool dataModified = false;
                isNoteHasDiff = false;
                isCfHasDiff = false;

                diff = null;
                noteDiff = new JObject();
                cfDiff = new JObject();

                var briefcaseData = CommonFunctions<Models.AppointmentModel>.GetBriefcase(briefcaseTypeId, staffId, briefcaseType);
                if (briefcaseData == null)
                    return true;
                else
                {
                    var config = new ComparisonConfig();
                    config.MaxDifferences = 100;
                    config.MembersToIgnore = new List<string>() { "Note", "CustomFields", "ServiceValidations" };
                    var cl = new CompareLogic(config);
                    var cr = new ComparisonResult(config);

                    cr = cl.Compare(newObject, briefcaseData);

                    if (newObject.Service != null)
                    {
                        #region Note Comparison
                        if (newObject.Service.Document.DocumentVersion.Note != null)
                        {
                            var clientNoteDict = JObject.Parse(JsonConvert.DeserializeObject<Dictionary<string, object>>(newObject.Service.Document.DocumentVersion.Note.ToString()).FirstOrDefault().Value.ToString().Trim(new char[] { '[', ']' }));
                            if (briefcaseData.Service.Document.DocumentVersion.Note != null)
                            {
                                var briefcaseNoteDict = JObject.Parse(JsonConvert.DeserializeObject<Dictionary<string, object>>(briefcaseData.Service.Document.DocumentVersion.Note.ToString()).FirstOrDefault().Value.ToString().Trim(new char[] { '[', ']' }));
                                noteDiff = CompareJObject(clientNoteDict, briefcaseNoteDict, "DocumentVersionId");

                                if (noteDiff != null && noteDiff.Properties().Count() > 0)
                                {
                                    dataModified = true;
                                    isNoteHasDiff = true;
                                }
                            }
                            else { dataModified = true; isNoteHasDiff = true; }
                        }
                        #endregion

                        #region CustomFieldComparison
                        if (newObject.Service.CustomFields != null)
                        {
                            var clientCustomFieldsDict = JObject.Parse(JsonConvert.DeserializeObject<Dictionary<string, object>>(newObject.Service.CustomFields.ToString()).FirstOrDefault().Value.ToString().Trim(new char[] { '[', ']' }));
                            if (briefcaseData.Service.CustomFields != null)
                            {
                                var briefcaseCustomFieldsDict = JObject.Parse(JsonConvert.DeserializeObject<Dictionary<string, object>>(briefcaseData.Service.CustomFields.ToString()).FirstOrDefault().Value.ToString().Trim(new char[] { '[', ']' }));
                                cfDiff = CompareJObject(clientCustomFieldsDict, briefcaseCustomFieldsDict, "ServiceId");
                                if (cfDiff != null && cfDiff.Properties().Count() > 0)
                                {
                                    dataModified = true;
                                    isCfHasDiff = true;
                                }
                            }
                            else { dataModified = true; isCfHasDiff = true; }
                        }
                        #endregion
                    }

                    if (!cr.AreEqual)
                        dataModified = true;

                    if (!cr.AreEqual)
                        diff = cr.Differences;

                    return dataModified;
                }
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.IsDataModified method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Compare Two Json Objects
        /// </summary>
        /// <param name="sourceJson"></param>
        /// <param name="targetJson"></param>
        /// <param name="primaryKeyName"></param>
        /// <returns></returns>
        public JObject CompareJObject(JObject sourceJson, JObject targetJson, string primaryKeyName)
        {
            try
            {
                JObject newObject = new JObject();
                if (!JToken.DeepEquals(sourceJson, targetJson))
                {
                    foreach (KeyValuePair<string, JToken> sourceProperty in sourceJson)
                    {
                        JProperty targetProp = targetJson.Property(sourceProperty.Key);

                        if (sourceProperty.Key == primaryKeyName && newObject[primaryKeyName] == null)
                            newObject[primaryKeyName] = sourceProperty.Value;

                        if (targetProp != null && !JToken.DeepEquals(sourceProperty.Value, targetProp.Value))
                        {
                            newObject[sourceProperty.Key] = sourceProperty.Value;
                        }
                        else if (!targetJson.Properties().Contains(targetProp))
                        {
                            newObject[sourceProperty.Key] = sourceProperty.Value;
                        }
                    }
                }

                return newObject;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.CompareJObject method." + ex.Message);
                throw excep;
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="AppointmentId"></param>
        /// <param name="CancelReason"></param>
        /// <returns></returns>
        public bool CancelAppointment(int AppointmentId, int CancelReason)
        {
            try
            {
                var appointment = _ctx.Appointments
                .Where(a => a.AppointmentId == AppointmentId && a.RecordDeleted != "Y").FirstOrDefault();

                if (appointment != null)
                {
                    appointment.Status = 8042;

                    var service = _ctx.Services
                        .Where(s => s.ServiceId == appointment.ServiceId && s.RecordDeleted != "Y").FirstOrDefault();

                    if (service != null)
                        service.Status = 73;

                    if (CancelReason > 0)
                        appointment.CancelReason = CancelReason;

                    _ctx.SaveChanges();
                    return true;
                }
                else
                    return false;

            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.CancelAppointment method." + ex.Message);
                throw excep;
            }
        }
        /// <summary>
        /// Get Appointment
        /// </summary>
        /// <param name="AppointmentId"></param>
        /// <returns></returns>
        public Models.AppointmentModel GetAppointment(int AppointmentId)
        {
            try
            {
                return _bcRepository.GetAppointment(AppointmentId);
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetApp method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Specific Appintment for the AppointementId.
        /// </summary>
        /// <param name="app"></param>
        /// <returns></returns>
        private Models.AppointmentModel GetApp(Data.Appointment app)
        {
            try
            {
                return _bcRepository.GetAppointment(app.AppointmentId);
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetApp method." + ex.Message);
                throw excep;
            }
        }
        /// <summary>
        /// Get All Appointemnts
        /// </summary>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public IEnumerable<Models.AppointmentModel> GetAppointments(int StaffId)
        {
            try
            {
                return _bcRepository.GetCalanderEvents(StaffId);
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetAppointments method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Check Appointment Exist or not
        /// </summary>
        /// <param name="AppointmentId"></param>
        /// <returns></returns>
        public bool IsAppointmentExists(int AppointmentId)
        {
            return _ctx.Appointments.Any(a => a.AppointmentId == AppointmentId && a.RecordDeleted != "Y" && a.Status != 8042);
        }

        /// <summary>
        /// Get All Cancel Reasons
        /// </summary>
        /// <returns></returns>
        public object GetCacelReasons()
        {
            try
            {
                return _ctx.GlobalCodes
                               .Where(g => g.Category == "CancelReason" && g.Active == "Y" && g.RecordDeleted != "Y")
                               .Select(g => new { GlobalCodeId = g.GlobalCodeId, CodeName = g.CodeName }).ToList();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.GetCacelReasons method." + ex.Message);
                throw excep;
            }

        }

        /// <summary>
        /// Used to Delete a service or Non Service Appointment
        /// </summary>
        /// <param name="AppointmentId"></param>
        /// <param name="DeletedBy"></param>
        /// <returns></returns>
        public bool DeleteAppointment(int AppointmentId, string DeletedBy)
        {
            try
            {
                var appointment = _ctx.Appointments
                .Where(a => a.AppointmentId == AppointmentId && a.RecordDeleted != "Y").FirstOrDefault();

                if (appointment != null)
                {
                    appointment.RecordDeleted = "Y";
                    appointment.DeletedBy = DeletedBy;
                    appointment.DeletedDate = DateTime.Now;

                    var service = _ctx.Services
                        .Where(s => s.ServiceId == appointment.ServiceId && s.RecordDeleted != "Y").FirstOrDefault();

                    if (service != null)
                    {
                        service.RecordDeleted = "Y";
                        service.DeletedBy = DeletedBy;
                        service.DeletedDate = DateTime.Now;


                        var serviceDiagnosis = _ctx.ServiceDiagnosis
                            .Where(s => s.ServiceId == service.ServiceId).ToList();

                        foreach (var sdiag in serviceDiagnosis)
                        {
                            sdiag.RecordDeleted = "Y";
                            sdiag.DeletedBy = DeletedBy;
                            sdiag.DeletedDate = DateTime.Now;
                        }

                        var document = _ctx.Documents
                        .Where(d => d.ServiceId == service.ServiceId && d.RecordDeleted != "Y").FirstOrDefault();

                        if (document != null)
                        {
                            document.RecordDeleted = "Y";
                            document.DeletedBy = DeletedBy;
                            document.DeletedDate = DateTime.Now;

                            var documentversion = _ctx.DocumentVersions
                                .Where(d => d.DocumentVersionId == document.CurrentDocumentVersionId && d.RecordDeleted != "Y").FirstOrDefault();
                            if (documentversion != null)
                            {
                                documentversion.RecordDeleted = "Y";
                                documentversion.DeletedBy = DeletedBy;
                                documentversion.DeletedDate = DateTime.Now;

                                var serviceGoals = _ctx.DocumentServiceNoteGoals
                                    .Where(g => g.DocumentVersionId == documentversion.DocumentVersionId).ToList();

                                foreach (var goal in serviceGoals)
                                {
                                    goal.RecordDeleted = "Y";
                                    goal.DeletedBy = DeletedBy;
                                    goal.DeletedDate = DateTime.Now;
                                }

                                var serviceObjectives = _ctx.DocumentServiceNoteObjectives
                                    .Where(g => g.DocumentVersionId == documentversion.DocumentVersionId).ToList();

                                foreach (var objectives in serviceObjectives)
                                {
                                    objectives.RecordDeleted = "Y";
                                    objectives.DeletedBy = DeletedBy;
                                    objectives.DeletedDate = DateTime.Now;
                                }
                            }
                        }

                    }

                    _ctx.SaveChanges();
                    return true;
                }
                else
                    return false;

            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.DeleteAppointment method." + ex.Message);
                throw excep;
            }
        }

        public PrimaryCareAppointmentResponseModel CreateAppointment(PrimaryCareAppointmentRequestModel requestModel)
        {
            try
            {
                appt = ConvertToEntityFromPCRequestModel(requestModel);

                _ctx.Appointments.Add(appt);
                _ctx.SaveChanges();

                return ConvertToPCRequestModelFromEntity(appt);
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AppointmentRepository.CreateAppointment method." + ex.Message);
                throw excep;
            }
        }

        //public AppointmentModel CreateService(APIServiceModel aPIServiceModel)
        //{
        //    appt = ConvertToEntityFromServiceRequestModel(aPIServiceModel);

        //    throw new NotImplementedException();
        //}

        //private Appointment ConvertToEntityFromServiceRequestModel(APIServiceModel aPIServiceModel)
        //{
        //    var currentStaff = (CurrentLoggedInStaff)HttpContext.Current.Session["CurrentStaff"];
        //    var clientName = _ctx.Clients
        //        .Where(c => c.ClientId == aPIServiceModel.Id)
        //        .Select(c => c.LastName + ", " + c.FirstName).FirstOrDefault();

        //    var procedureCode = _ctx.ProcedureCodes
        //        .Where(p => p.ProcedureCodeId == aPIServiceModel.ProcedureCodeId)
        //        .Select(p => new { ProcedureCodeName = p.ProcedureCodeName, EnteredAs = p.EnteredAs }).FirstOrDefault();

        //    var Subject = "Client:" + clientName + "(#" + aPIServiceModel.Id.ToString() + ") - " + procedureCode.ProcedureCodeName;

        //    Appointment appointment = new Appointment();
        //    Service service = new Service();

        //    appointment.AppointmentId = -1;
        //    appointment.StaffId = currentStaff.StaffId;
        //    appointment.Subject = Subject;
        //    appointment.StartTime = aPIServiceModel.DateOfService;
        //    appointment.EndTime = aPIServiceModel.DateOfService;
        //    appointment.AppointmentType = 4761;
        //    appointment.ShowTimeAs = 4342;
        //    appointment.LocationId = aPIServiceModel.LocationId;
        //    appointment.ServiceId = -1;
        //    appointment.CreatedBy = appointment.ModifiedBy = currentStaff.UserCode;
        //    appointment.CreatedDate = appointment.ModifiedDate = DateTime.Now;

        //    service.ServiceId = -1;
        //    service.ClientId = aPIServiceModel.Id;
        //    service.ProcedureCodeId = aPIServiceModel.ProcedureCodeId;
        //    service.DateOfService = aPIServiceModel.DateOfService;
        //    service.EndDateOfService = aPIServiceModel.DateOfService;
        //    service.UnitType = procedureCode.EnteredAs;
        //    service.Unit = aPIServiceModel.Unit;
        //    service.Status = 70;
        //    service.ClinicianId = aPIServiceModel.ClinicianId;
        //    service.AttendingId = aPIServiceModel.AttendingId;
        //    service.ProgramId = aPIServiceModel.ProgramId;
        //    service.LocationId = aPIServiceModel.LocationId;
        //    service.Billable = "Y";
        //    service.ClientWasPresent = "Y";
        //    service.AuthorizationsApproved = 0;
        //    service.AuthorizationsNeeded = 0;
        //    service.AuthorizationsRequested = 0;
        //    //service.Charge;
        //    //service.ProcedureRateId
        //    service.NoteReplacement = "N";


        //}

        //PrimaryCareAppointmentResponseModel IAppointmentRepository.CreateAppointment(PrimaryCareAppointmentRequestModel requestModel)
        //{
        //    throw new NotImplementedException();
        //}

        //public async Task<_SCResult<AppointmentModel>> ScheduleAppointment(AppointmentModel appointment, int loggedInUser)
        //{
        //    return await Save(appointment, loggedInUser);
        //}

        ///// <summary>
        ///// Get Appointment Details
        ///// </summary>
        ///// <param name="staffId"></param>
        ///// <returns></returns>
        //public List<AppointmentReadModel> GetAppointmentDetails(int staffId)
        //{
        //    var mobStaff = (from a in _ctx.StaffPreferences
        //                    where a.StaffId == staffId
        //                    select new
        //                    {
        //                        backfromCurrentDate = a.MobileCalendarEventsDaysLookUpInPast,
        //                        forwardfromCurrentDate = a.MobileCalendarEventsDaysLookUpInFuture
        //                    }).FirstOrDefault();

        //    DateTime dtStart = DateTime.Now.AddDays(-(double)mobStaff.backfromCurrentDate);
        //    DateTime dtEnd = DateTime.Now.AddDays((double)mobStaff.forwardfromCurrentDate);
        //    dtEnd = dtEnd.Date.Add(new TimeSpan(23, 59, 59));// To Consider the complete Day

        //    return _ctx.Appointments
        //        .Where(a => a.StaffId == staffId && a.RecordDeleted !="Y" && a.StartTime >= dtStart
        //                && a.EndTime <= dtEnd && a.Status != 8042)//Ignore the Cancelled Appointments
        //        .ToList()
        //        .Select(a => new AppointmentReadModel()
        //        {
        //            AppointmentId = a.AppointmentId,
        //            AppointmentStartTime = a.StartTime.ToString("dd/MM/yyyy HH:mm tt"),
        //            AppointmentEndTime = a.EndTime.ToString("dd/MM/yyyy HH:mm tt")
        //        }).ToList();               
        //}       
    }
}