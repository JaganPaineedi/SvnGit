using SC.Api.Models;
using SC.Data;
using System;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Data.Entity.Core.Objects;
using System.Data.SqlTypes;
using System.Data;
using System.Web.Http.Description;
using SC.Api.Filters;

namespace SC.Api
{
    /// <summary>
    /// Patient Related APIs
    /// </summary>
    [RoutePrefix("api/Patient"), LoggingServiceFilterAttribute]
    public class PatientController : ApiController
    {
        #region Variables
        public readonly IPatientRepository _repo;
        public readonly IAppointmentRepository _appRepo;
        public static SCMobile _ctx;
        #endregion

        /// <summary>
        /// Constructor 
        /// </summary>
        /// <param name="repo"></param>
        public PatientController(IPatientRepository repo)
        {
            _repo = repo;
            _ctx = new SCMobile();
            _appRepo = new AppointmentRepository(_ctx);
        }

        /// <summary>
        /// Returns Id's based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("Id")]
        public string GetId([FromUri(Name = "")]PatientIdentifiers patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    return _repo.GetClientId(patientIdentifier.SSN, patientIdentifier.FirstName, patientIdentifier.LastName, patientIdentifier.DOB);
                }
                return "";
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Patient Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("Details")]
        public PatientDetailsModel GetDetails([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetPatientInformation(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Common Clinical Data Set Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("SummaryOfCareCCDXML")]
        public string GetSummaryOfCareCCDXML([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }

                    return _repo.GetSummaryOfCareCCDXML(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);

                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>
        /// Returns Patient Demographic Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("DemographicDetails")]
        public List<PatientDemographicDetailsModel> GetDemographicDetails([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetDemographicDetails(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Allergies Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("Allergies")]
        public List<AllergiesModel> GetAllergies([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetAllergies(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>
        /// Returns Current Medications Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("CurrentMedications")]
        public List<CurrentMedicationsModel> GetCurrentMedications([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetCurrentMedications(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>
        /// Returns Active Problems Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("ActiveProblems")]
        public List<ActiveProblemsModel> GetActiveProblems([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetActiveProblems(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>
        /// Returns Most Recent Encounters Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("HistoryOfEncounters")]
        public List<MostRecentEncountersModel> GetMostRecentEncounters([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetMostRecentEncounters(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Immunizations Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("Immunizations")]
        public List<ImmunizationsModel> GetImmunizations([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }

                    return _repo.GetImmunizations(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Social History Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("SocialHistory")]
        public List<SocialHistoryModel> GetSocialHistory([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetSocialHistory(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Vital Signs Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("VitalSigns")]
        public List<VitalSignsModel> GetVitalSigns([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }

                    return _repo.GetVitalSigns(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Plan Of Treatment Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("PlanOfTreatment")]
        public List<PlanOfTreatmentModel> GetPlanOfTreatment([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetPlanOfTreatment(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Goals Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("Goals")]
        public List<GoalsModel> GetGoals([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetGoals(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns History Of Procedures Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("HistoryOfProcedures")]
        public List<HistoryOfProceduresModel> GetHistoryOfProcedures([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetHistoryOfProcedures(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Studies Summary Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("StudiesSummary")]
        public List<StudiesSummaryModel> GetStudiesSummary([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetStudiesSummary(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Laboratory Test Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("LaboratoryTests")]
        public List<LaboratoryTestsModel> GetLaboratoryTests([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetLaboratoryTests(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Care Team Member(s) Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("CareTeamMembers")]
        public List<CareTeamMembersModel> GetCareTeamMembers([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetCareTeamMembers(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Unique Device Identifier(s) for a Patient’s Implantable Device(s) Data based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("UniqueDeviceIdentifier")]
        public List<UDIModel> GetUDI([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetUDI(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Health Concerns based on Identifiers
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("HealthConcerns")]
        public List<HealthConcernsModel> GetHealthConcerns([FromUri(Name = "")]PatientIdentifier patientIdentifier)
        {
            try
            {
                if (patientIdentifier != null)
                {
                    if (patientIdentifier.FromDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.FromDate = SqlDateTime.MinValue.Value;
                    }
                    if (patientIdentifier.ToDate == Convert.ToDateTime("1/1/0001 12:00:00 AM"))
                    {
                        patientIdentifier.ToDate = SqlDateTime.MaxValue.Value;
                    }
                    return _repo.GetHealthConcerns(patientIdentifier.Id, patientIdentifier.Type.ToString(), patientIdentifier.FromDate, patientIdentifier.ToDate);
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Returns Client Balance
        /// </summary>
        /// <param name="clientId"></param>
        /// <returns></returns>
        [HttpGet, Authorize, Route("Balance")]
        public IHttpActionResult GetClientBalance(int id)
        {
            var cl = _repo.GetClientBalance(id);

            if (cl == null)
            { return BadRequest("Client does not exist"); }
            else if (cl.Active == "N")
            { return BadRequest("Client is not Active"); }
            else
            {
                var balance = cl.CurrentBalance;
                if (balance == null)
                    return Ok("$ 0.00");
                else { return Ok("$ " + Convert.ToDouble(balance).ToString()); }
            }
        }

        /// <summary>
        /// Returns Primary Clinician
        /// </summary>
        /// <param name="clientId"></param>
        /// <returns></returns>
        [HttpGet, Authorize, Route("PrimaryClinician")]
        public IHttpActionResult GetPrimaryClinician(int id)
        {
            var cl = _repo.GetPrimaryClinician(id);
            if (cl == null)
                return BadRequest();
            return Ok(_repo.GetPrimaryClinician(id));
        }

        /// <summary>
        /// Get Document based on DocumentVersionId
        /// </summary>
        /// <param name="DocumentVersionId"></param>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpGet, Authorize, Route("GetDocument")]
        public async Task<IHttpActionResult> GetDocument(int DocumentVersionId)
        {
            return Ok(_repo.GetDocument(DocumentVersionId));
        }

        /// <summary>
        /// Returns Program Clinicians
        /// </summary>
        /// <param name="clientId"></param>
        /// <returns></returns>
        [HttpGet, Authorize, Route("ProgramClinicians")]
        public List<ClinicianModel> GetProgramClinicians(int id)
        {
            //var sess = HttpContext.Current.Session.SessionID;
            return _repo.GetProgramClinicians(id);
        }


        /// <summary>
        /// Returns patient documents
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("Documents")]
        public async Task<IHttpActionResult> GetDocumentList([FromUri(Name = "")]DocumentListRequestModel docRequest)
        {
            try
            {
                if (!_repo.IsNonStaffUser(docRequest.id))
                    return BadRequest("You do not have sufficient permission to access the documents");
                else
                {
                    return Ok(_repo.GetDocumentList(docRequest));
                }
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientController.GetDocumentList method." + ex.Message);
                throw ex;
            }
        }

        /// <summary>
        /// get service dropdown data
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("ServiceDropdownDetails")]
        public async Task<IHttpActionResult> GetServiceDropdownData([FromUri(Name = "")]ServiceDropdownConfigurationsRequestModel serRequest)
        {
            try
            {
                
                    return Ok(_repo.GetServiceDropdownData(serRequest));
                
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in PatientController.GetServiceDropdownData method." + ex.Message);
                throw ex;
            }
        }

        /// <summary>
        /// Update Payment
        /// </summary>
        /// <param name="payment"></param>
        /// <param name="staffId"></param>
        /// <returns></returns>
        [HttpPost, Authorize, Route("UpdatePayment")]
        public IHttpActionResult Post([FromBody]ClientPaymentModel payment, int staffId)
        {
            try
            {
                var rowAffected = _repo.UpdatePayment(payment);
                if (rowAffected > 0)
                    return Ok("Payment Updated Successfully");
                else
                    return BadRequest("Update failed");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Retutns Available Appointments
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpGet, Authorize, Route("AppointmentSearch")]
        public List<AppointmentResponseModel> AppointmentSearch([FromUri(Name = "")]AppointmentRequestModel request)
        {
            return _repo.GetAvailableAppointmentsSlots(request);
        }

        /// <summary>
        /// Get All Appointments against Client and Clinician
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpGet, Authorize, Route("GetAppointments")]
        public List<AppointmentModel> GetAppointments([FromUri(Name = "")]AppointmentSearchModel request)
        {
            List<AppointmentModel> appList = new List<Models.AppointmentModel>();

            var appIds = _repo.GetAppointmentIds(request);

            foreach (int appId in appIds)
            {
                appList.Add(_repo.GetAppointment(appId));
            }

            return appList;
        }

        /// <summary>
        /// Schedule an Appointment
        /// </summary>
        /// <param name="appointment"></param>
        /// <param name="loggedInUser"></param>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpPost, Authorize, Route("ScheduleAppointment")]
        public async Task<IHttpActionResult> ScheduleAppointment([FromBody] Models.AppointmentModel appointment, int loggedInUser)
        {
            try
            {
                if (appointment != null)
                {
                    List<_SCResult<Models.AppointmentModel>> results = new List<_SCResult<Models.AppointmentModel>>();

                    var _Ce = await _appRepo.Save(appointment, loggedInUser);
                    if (_Ce != null)
                        results.Add(_Ce);

                    return Ok(results);
                }
                else return BadRequest("appointment object is null");
            }
            catch (System.Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// Create a Service
        /// </summary>
        /// <param name="appointment"></param>
        /// <param name="service"></param>
        /// <returns></returns>
        [HttpPost, Authorize, Route("CreateService")]
        public IHttpActionResult CreateService(APIServiceModel service)
        {
            try
            {
                if (service != null)
                {
                    List<AppointmentModel> results = new List<Models.AppointmentModel>();
                    var _ce = _repo.CreateService(service);
                    if (_ce != null)
                        results.Add(_ce);
                    return Ok(results);
                }
                else
                    return BadRequest("Service object is null");
            }
            catch (System.Exception ex)
            {
                throw ex;
            }
        }
    }
}
