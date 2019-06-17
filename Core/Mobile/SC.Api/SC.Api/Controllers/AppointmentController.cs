using SC.Api.Filters;
using SC.Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace SC.Api
{
    /// <summary>
    /// Calendar Controller
    /// </summary>
    [RoutePrefix("api/calendarevent"), LoggingServiceFilterAttribute]
    public class CalendarEventController : ApiController
    {
        private IAppointmentRepository _repo;

        /// <summary>
        /// Constructor for Calendar Events
        /// </summary>
        /// <param name="repo"></param>
        public CalendarEventController(IAppointmentRepository repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Used for creating the PrimaryCare Appointment
        /// </summary>
        /// <param name="pcReqAppt"></param>
        /// <returns></returns>
        [HttpGet, Authorize, Route("CreateAppointment")]
        public async Task<IHttpActionResult> CreateAppointment([FromUri(Name = "")]PrimaryCareAppointmentRequestModel pcReqAppt)
        {
            try
            {
                var obj = _repo.CreateAppointment(pcReqAppt);

                return Ok(obj);
            }
            catch (Exception ex)
            { throw ex; }
        }

        /// <summary>
        /// Post Service or Non Service Appointments 
        /// </summary>
        /// <param name="appointments"></param>
        /// <returns></returns>
        [Authorize, ApiExplorerSettings(IgnoreApi = true)]
        public async Task<IHttpActionResult> Post([FromBody] List<Models.AppointmentModel> appointments)
        {
            int loggedInUser = 0;
            int.TryParse(GetQueryString(Request, "StaffId"), out loggedInUser);
            try
            {
                if (appointments != null)
                {
                    List<_SCResult<Models.AppointmentModel>> results = new List<_SCResult<Models.AppointmentModel>>();

                    foreach (Models.AppointmentModel appt in appointments)
                    {
                        var _Ce = await _repo.Save(appt, loggedInUser);
                        if (_Ce != null)
                            results.Add(_Ce);
                    }

                    return Ok(results);
                    //else //Commented becasue the After Delete SavedResult will be NUll.
                    //    return BadRequest("Save failed for 'Appointmentments'");
                }
                else return BadRequest("appointment object is null");
            }
            catch (System.Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Pass AppointmentId and CancelReason if any to Cancel the Appointment
        /// </summary>
        /// <param name="AppointmentId"></param>
        /// <param name="CancelReason"></param>
        /// <returns></returns>
        [HttpPost, Authorize, Route("CancelAppointment")]
        public async Task<IHttpActionResult> CancelAppointment(int AppointmentId, int CancelReason = 0)
        {
            try
            {
                if (!_repo.IsAppointmentExists(AppointmentId))
                    return NotFound();
                else
                    return Ok(_repo.CancelAppointment(AppointmentId, CancelReason));
            }
            catch (Exception ex)
            { throw ex; }
        }

        /// <summary>
        /// Get All existing Cancel Reasons
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("GetCancelReasons"), ApiExplorerSettings(IgnoreApi = true)]
        public async Task<IHttpActionResult> GetCancelReasons()
        {
            try
            {
                return Ok(_repo.GetCacelReasons());
            }
            catch (Exception ex)
            { throw ex; }
        }

        /// <summary>
        /// Get Specific Appointment
        /// </summary>
        /// <param name="AppointmentId"></param>
        /// <returns></returns>
        [HttpGet, Authorize, Route("GetAppointment")]
        public async Task<IHttpActionResult> GetAppointment(int AppointmentId)
        {
            try
            {
                if (!_repo.IsAppointmentExists(AppointmentId))
                    return NotFound();
                else
                    return Ok(_repo.GetAppointment(AppointmentId));
            }
            catch (Exception ex)
            { throw ex; }
        }

        /// <summary>
        /// Get All Appointments for the Staff.
        /// </summary>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        [HttpGet, Authorize, Route("GetServiceOrNonServiceAppointment"), ApiExplorerSettings(IgnoreApi = true)]
        public async Task<IHttpActionResult> GetServiceOrNonServiceAppointment(int StaffId)
        {
            try
            {
                return Ok(_repo.GetAppointments(StaffId));
            }
            catch (Exception ex)
            { throw ex; }
        }

        /// <summary>
        /// Delete specific appointment
        /// </summary>
        /// <param name="AppointmentId"></param>
        /// <param name="DeletedBy"></param>
        /// <returns></returns>
        [HttpDelete, Authorize, Route("DeleteAppointment"), ApiExplorerSettings(IgnoreApi = true)]
        public async Task<IHttpActionResult> DeleteAppointment(int AppointmentId, string DeletedBy)
        {
            try
            {
                return Ok(_repo.DeleteAppointment(AppointmentId, DeletedBy));
            }
            catch (Exception ex)
            { throw ex; }
        }

        /// <summary>
        /// Get Query String value based on the Key
        /// </summary>
        /// <param name="request"></param>
        /// <param name="key"></param>
        /// <returns></returns>
        private string GetQueryString(HttpRequestMessage request, string key)
        {
            var queryStrings = request.GetQueryNameValuePairs();

            if (queryStrings == null) return null;

            var match = queryStrings.FirstOrDefault(keyValue => string.Compare(keyValue.Key, key, true) == 0);

            if (string.IsNullOrEmpty(match.Value)) return null;

            return match.Value;
        }
    }
}
