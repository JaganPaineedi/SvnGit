using System;
using System.Collections.Generic;
using System.Linq;
using SC.Api.Models;
using SC.Data;
using System.Data.SqlClient;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Core.Objects;
using System.Threading.Tasks;

namespace SC.Api
{
    /// <summary>
    /// BriefcaseRepositiry used for all the briefcase filling related functionalities
    /// </summary>
    public class BriefcaseRepositiry : IBriefcaseRepository
    {
        public SCMobile _ctx;
        /// <summary>
        /// Constructor of BriefcaseRepositiry
        /// </summary>
        /// <param name="ctx"></param>
        public BriefcaseRepositiry(SCMobile ctx)
        {
            _ctx = ctx;
        }
       
        /// <summary>
        /// It Fills the Service dropdown values (Procedure, Program,Location and attending) based on staffId
        /// </summary>
        /// <param name="currentStaffId"></param>
        /// <returns></returns>
        public ServiceDropdownValuesModel FillServiceDropdownValues(int currentStaffId)
        {
            ServiceDropdownValuesModel _serviceDropdownValues = new ServiceDropdownValuesModel();

            _ctx.Database.Initialize(force: false);

            var cmd = _ctx.Database.Connection.CreateCommand();
            cmd.CommandText = "[dbo].[smsp_GetServiceDropDownValues]";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
           
            try
            {
                _ctx.Database.Connection.Open();
                cmd.Parameters.Add(new SqlParameter("StaffId", currentStaffId));
                var reader = cmd.ExecuteReader();

                _serviceDropdownValues.ProcedureCodes = ((IObjectContextAdapter)_ctx)
                    .ObjectContext
                    .Translate<Models._ProcedureCode>(reader).ToList();

                reader.NextResult();

                _serviceDropdownValues.Programs = ((IObjectContextAdapter)_ctx)
                    .ObjectContext
                    .Translate<_Program>(reader).ToList();

                reader.NextResult();

                _serviceDropdownValues.Locations = ((IObjectContextAdapter)_ctx)
                    .ObjectContext
                    .Translate<_Location>(reader).ToList();

                reader.NextResult();

                _serviceDropdownValues.ServiceAttending = ((IObjectContextAdapter)_ctx)
                    .ObjectContext
                    .Translate<_Attending>(reader).ToList();

                reader.NextResult();

                _serviceDropdownValues.Clinicians = ((IObjectContextAdapter)_ctx)
                    .ObjectContext
                    .Translate<_Clinician>(reader).ToList();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.FillServiceDropdownValues method." + ex.Message);
                throw excep;
            }
            finally
            { _ctx.Database.Connection.Close(); }

            return _serviceDropdownValues;
        }

        /// <summary>
        /// Get All the Appointments for the staff based on MobileCalendarEventsDaysLookUpInPast and MobileCalendarEventsDaysLookUpInFuture
        /// </summary>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        public List<Models.AppointmentModel> GetCalanderEvents(int StaffId)
        {
            try
            {
                List<Models.AppointmentModel> appointments = new List<Models.AppointmentModel>();

                var mobStaff = (from a in _ctx.StaffPreferences
                                where a.StaffId == StaffId
                                select new
                                {
                                    backfromCurrentDate = a.MobileCalendarEventsDaysLookUpInPast,
                                    forwardfromCurrentDate = a.MobileCalendarEventsDaysLookUpInFuture
                                }).FirstOrDefault();
                DateTime dtStart = DateTime.Now.AddDays(-(double)mobStaff.backfromCurrentDate);
                DateTime dtEnd = DateTime.Now.AddDays((double)mobStaff.forwardfromCurrentDate);
                dtEnd = dtEnd.Date.Add(new TimeSpan(23, 59, 59));// To Consider the complete Day

                List<Models.AppointmentModel> events = GetServiceAppointments(StaffId, dtStart, dtEnd);
                appointments.AddRange(events);

                foreach (var calevent in events)
                {
                    if (calevent != null)
                    {
                        var briefcaseType = calevent.Service == null ? CommonDBFunctions.GetGlobalCodeId("BRIEFCASETYPE", "APPOINTMENT") : CommonDBFunctions.GetGlobalCodeId("BRIEFCASETYPE", "SERVICE");
                        CommonFunctions<Models.AppointmentModel>.CreateUpdateBriefcase(calevent.AppointmentId, calevent, StaffId, briefcaseType);
                    }
                }

                return appointments;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetCalanderEvents method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Get All the Appointments for the staff 
        /// </summary>
        /// <param name="StaffId"></param>
        /// <param name="dtStart"></param>
        /// <param name="dtEnd"></param>
        /// <returns></returns>
        private List<Models.AppointmentModel> GetServiceAppointments(int StaffId, DateTime dtStart, DateTime dtEnd)
        {
            try
            {
                return (from a in _ctx.Appointments
                        where a.StaffId == StaffId && a.RecordDeleted != "Y"
                        && a.StartTime >= dtStart
                        && a.EndTime <= dtEnd
                        /*&& ((a.Service == null && a.Location.Mobile == "Y")
                            || (a.Service != null && a.Service.ProcedureCodes.Mobile == "Y" &&
                               a.Service.Location.Mobile == "Y" &&
                               a.Service.Programs.Mobile == "Y"))*/
                        select a).ToList()
                                          .Select(a => new Models.AppointmentModel()
                                          {
                                              AppointmentId = a.AppointmentId,
                                              StaffId = a.StaffId,
                                              Subject = a.Subject,
                                              StartTime = a.StartTime,
                                              EndTime = a.EndTime,
                                              AppointmentType = a.AppointmentType,
                                              Description = a.Description,
                                              ShowTimeAs = a.ShowTimeAs,
                                              LocationId = a.LocationId,
                                              SpecificLocation = a.SpecificLocation,
                                              ServiceId = a.ServiceId,
                                              GroupServiceId = a.GroupServiceId,
                                              CreatedBy = a.CreatedBy,
                                              CreatedDate = a.CreatedDate,
                                              ModifiedBy = a.ModifiedBy,
                                              ModifiedDate = a.ModifiedDate,
                                              Readonly = IsReadOnly(a),
                                              Service = GetServiceInformation(a)
                                          }).ToList();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetServiceAppointments method." + ex.Message);
                throw excep;
            }
        }

        private bool IsReadOnly(Appointment a)
        {
            if ((a.ServiceId == null && a.GroupServiceId == null && a.Location != null && a.Location.Mobile == "Y")
                           || (a.Service != null && a.Service.ProcedureCodes != null && a.Service.ProcedureCodes.Mobile == "Y" && a.Service.Location != null &&
                              a.Service.Location.Mobile == "Y" && a.Service.Programs != null &&
                              a.Service.Programs.Mobile == "Y"))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        /// <summary>
        /// Get Service information based on appointmentId
        /// </summary>
        /// <param name="a"></param>
        /// <returns></returns>
        private static Models.ServiceModel GetServiceInformation(Data.Appointment a)
        {
            try
            {
                string CustomFieldObjectName = string.Empty;
                if (a.ServiceId != null)
                {
                    return new Models.ServiceModel()
                    {
                        ServiceId = a.Service.ServiceId,
                        CreatedBy = a.Service.CreatedBy,
                        CreatedDate = a.Service.CreatedDate,
                        ModifiedBy = a.Service.ModifiedBy,
                        ModifiedDate = a.Service.ModifiedDate,
                        ClientId = a.Service.ClientId,
                        ProcedureCodeId = a.Service.ProcedureCodeId,
                        DateOfService = a.Service.DateOfService,
                        EndDateOfService = a.Service.EndDateOfService,
                        Unit = a.Service.Unit,
                        UnitType = a.Service.UnitType,
                        Status = a.Service.Status,
                        ClinicianId = a.Service.ClinicianId,
                        ClinicianName = DataService.GetClinicianName((int)a.Service.ClinicianId),
                        AttendingId = a.Service.AttendingId,
                        ProgramId = a.Service.ProgramId,
                        LocationId = a.Service.LocationId,
                        Billable = a.Service.Billable,
                        SpecificLocation = a.Service.SpecificLocation,
                        DateTimeIn = a.Service.DateTimeIn,
                        DateTimeOut = a.Service.DateTimeOut,
                        Diagnosis = AppointmentRepository.GetDiagnosis(a.Service),
                        CustomFields = AppointmentRepository.GetCustomFields(a.Service, ref CustomFieldObjectName),
                        CustomFieldObjectName = CustomFieldObjectName,
                        Document = AppointmentRepository.CreateModelDocument(a.Service.Documents.FirstOrDefault()),
                        ProcedureCodeName = AppointmentRepository.GetProcedureCodeName(a.Service.ProcedureCodeId),
                        LocationName = AppointmentRepository.GetLocationName(a.Service.LocationId),
                        ProgramName = AppointmentRepository.GetProgramName(a.Service.ProgramId)
                    };
                }
                else
                    return null;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetServiceInformation method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Get Appointment based on an appointmentId
        /// </summary>
        /// <param name="appointmentId"></param>
        /// <returns></returns>
        public Models.AppointmentModel GetAppointment(int appointmentId)
        {
            try
            {
                return (from a in _ctx.Appointments
                        where a.AppointmentId == appointmentId && a.RecordDeleted != "Y"
                        select a).ToList()
                         .Select(a => new Models.AppointmentModel()
                         {
                             AppointmentId = a.AppointmentId,
                             StaffId = a.StaffId,
                             Subject = a.Subject,
                             StartTime = a.StartTime,
                             EndTime = a.EndTime,
                             AppointmentType = a.AppointmentType,
                             Description = a.Description,
                             ShowTimeAs = a.ShowTimeAs,
                             LocationId = a.LocationId,
                             SpecificLocation = a.SpecificLocation,
                             ServiceId = a.ServiceId,
                             CreatedBy = a.CreatedBy,
                             CreatedDate = a.CreatedDate,
                             ModifiedBy = a.ModifiedBy,
                             ModifiedDate = a.ModifiedDate,
                             Service = GetServiceInformation(a)
                         }).FirstOrDefault();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetAppointment method." + ex.Message);
                throw excep;
            }
           
        }
       
        /// <summary>
        /// Returns all the caseload data for the loggedin staff.
        /// </summary>
        /// <param name="currentStaffId"></param>
        /// <returns></returns>
        public string GetCaseLoad(int currentStaffId)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));

                _ctx.smsp_SCGetMyCaselod_StringReturn(currentStaffId, OutputParamter);

                return OutputParamter.Value.ToString();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetCaseLoad method." + ex.Message);
                throw excep;
            }
           
        }
       
        /// <summary>
        /// Returns all Dashboard data.
        /// </summary>
        /// <returns></returns>
        public List<MobileDashboards> GetDashboards()
        {
            try
            {
                var dashboards = (from a in _ctx.MobileDashboards
                                  where a.Active == "Y" && a.RecordDeleted != "Y"
                                  select a).ToList();

                return dashboards;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetDashboards method." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Get Configured GloabalCodes from SETMOBILEGLOBALCODES SystemConfigurationKeys.
        /// </summary>
        /// <returns></returns>
        public List<GlobalCode> GetGlobalCodes()
        {
            try
            {
                List<GlobalCode> gclist = new List<GlobalCode>();
                var categorylist = new ObjectParameter("Value", typeof(string));

                _ctx.smsp_GetSystemConfigurationKeyValue("SETMOBILEGLOBALCODES", categorylist);

                if (categorylist.Value != null && !string.IsNullOrEmpty(categorylist.Value.ToString()))
                {
                    var cgist = categorylist.Value.ToString().Split(',');

                    gclist = (from a in _ctx.GlobalCodes
                              where cgist.Contains(a.Category) && a.Active == "Y" && a.RecordDeleted != "Y"
                              select a).ToList();
                }
                return gclist;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetGlobalCodes method." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Retusn My Preference Data for the loggedin staff
        /// </summary>
        /// <param name="currentStaffId"></param>
        /// <returns></returns>
        public async Task<Models.StaffPreferenceModel> GetMyPreference(int currentStaffId)
        {
            try
            {
                var repo = new MobileStaffRepositiry(new SC.Data.SCMobile());
                var user = await repo.FindMobileUser(currentStaffId);

                if (user != null)
                    CommonFunctions<Models.StaffPreferenceModel>.CreateUpdateBriefcase(user.StaffPreferenceId, user, currentStaffId, CommonDBFunctions.GetGlobalCodeId("BRIEFCASETYPE", "MYPREFERENCE"));

                return user;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetMyPreference method." + ex.Message);
                throw excep;
            }
           
        }
       
        /// <summary>
        /// Returns Stafflist for Team calender.
        /// </summary>
        /// <param name="currentStaffId"></param>
        /// <returns></returns>
        public string GetTeamCalendarStaffList(int currentStaffId)
        {
            try
            {
                var OutputParamter = new ObjectParameter("JsonResult", typeof(string));

                _ctx.smsp_GetStaffListForTeamScheduling_StringReturn(currentStaffId, OutputParamter);

                return OutputParamter.Value.ToString();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetTeamCalendarStaffList method." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Returns all the SystemConfigurationKeys with Module Set as Mobile.
        /// </summary>
        /// <returns></returns>
        public List<Models.SystemConfigurationKeyModel> GetSystemConfigurationKeys()
        {
            try
            {
                return _ctx.SystemConfigurationKeys
               .Where(s => s.Modules == "MOBILE")
               .Select(s => new Models.SystemConfigurationKeyModel() { Key = s.Key, Value = s.Value }).ToList();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetSystemConfigurationKeys method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Get Client Balance
        /// </summary>
        /// <param name="clientId"></param>
        /// <returns></returns>
        public Client GetClientBalance(int clientId)
        {
            return _ctx.Clients
                  .Where(c => c.ClientId == clientId && c.RecordDeleted != "Y").FirstOrDefault();
        }

        public List<ClientDocumentsModel> GetDocuments(int StaffId)
        {
            List<ClientDocumentsModel> _clientDocuments = new List<ClientDocumentsModel>();

            _ctx.Database.Initialize(force: false);

            var cmd = _ctx.Database.Connection.CreateCommand();
            cmd.CommandText = "[dbo].[smsp_GetDocuments]";
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            try
            {
                _ctx.Database.Connection.Open();
                cmd.Parameters.Add(new SqlParameter("StaffId", StaffId));
                var reader = cmd.ExecuteReader();

                _clientDocuments = ((IObjectContextAdapter)_ctx)
                    .ObjectContext
                    .Translate<Models.ClientDocumentsModel>(reader).ToList();
                
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in BriefcaseRepositiry.GetDocuments method." + ex.Message);
                throw excep;
            }
            finally
            { _ctx.Database.Connection.Close(); }

            return _clientDocuments;
        }
    }
}