using SC.Api.Filters;
using SC.Api.Models;
using System;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;


namespace SC.Api
{
    /// <summary>
    /// Controller for Briefcase
    /// </summary>
    [RoutePrefix("api/Briefcase"), LoggingServiceFilterAttribute]
    public class BriefcaseController : ApiController
    {
        #region Variables
        public readonly IBriefcaseRepository _repo;
        public static int currentStaffId = 0;
        public static string staffId = string.Empty;
        #endregion

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="repo"></param>
        public BriefcaseController(IBriefcaseRepository repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Returns Briefcase Data
        /// </summary>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpGet, Authorize, Route("")]
        public async Task<IHttpActionResult> Get(string staffId)
        {
            try
            {
                BriefCaseModel _briefcase = new BriefCaseModel();
                if (!String.IsNullOrWhiteSpace(staffId))
                {
                    int.TryParse(staffId, out currentStaffId);

                    _briefcase.caseload = _repo.GetCaseLoad(currentStaffId);
                    _briefcase.TeamCalendarStaff = _repo.GetTeamCalendarStaffList(currentStaffId);
                    _briefcase.ServiceDropdownValues = _repo.FillServiceDropdownValues(currentStaffId);
                    _briefcase.Events = _repo.GetCalanderEvents(currentStaffId);
                    _briefcase.UpdatedOn = DateTime.Now;
                    _briefcase.Dashboards = _repo.GetDashboards();
                    _briefcase.GlobalCodes = _repo.GetGlobalCodes();
                    _briefcase.MyPreference = await _repo.GetMyPreference(currentStaffId);
                    _briefcase.ClientDocuments = _repo.GetDocuments(currentStaffId);

                    _briefcase.Configurations = _repo.GetSystemConfigurationKeys();
                }
                return Ok(_briefcase);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>
        /// Returns Caseload Data
        /// </summary>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpGet, Authorize, Route("CaseLoad")]
        public string GetCaseLoad(string staffId)
        {
            string cl = string.Empty;

            if (!String.IsNullOrWhiteSpace(staffId))
            {
                int.TryParse(staffId, out currentStaffId);

                cl = _repo.GetCaseLoad(currentStaffId); ;
            }
            return cl;
        }

        /// <summary>
        /// Returns My Preference Data
        /// </summary>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpGet, Authorize, Route("MyPreference")]
        public async Task<Models.StaffPreferenceModel> GetMyPreference(string staffId)
        {
            if (!String.IsNullOrWhiteSpace(staffId))
            {
                int.TryParse(staffId, out currentStaffId);

                return await _repo.GetMyPreference(currentStaffId);
            }
            else return null;
        }

        /// <summary>
        /// Get Calendar Events
        /// </summary>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpGet, Authorize, Route("Events")]
        public IHttpActionResult GetCalendar(string staffId)
        {
            BriefCaseModel _briefcase = new BriefCaseModel();

            if (!String.IsNullOrWhiteSpace(staffId))
            {
                int.TryParse(staffId, out currentStaffId);
                _briefcase.Events = _repo.GetCalanderEvents(currentStaffId);
            }

            return Ok(_briefcase.Events);
        }

        /// <summary>
        /// Returns all SystemConfigurationKeys for Mobile module
        /// </summary>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpGet, Authorize, Route("Configs")]
        public IHttpActionResult GetSystemConfigurationKeys()
        {
            BriefCaseModel _briefcase = new BriefCaseModel();
            _briefcase.Configurations = _repo.GetSystemConfigurationKeys();

            return Ok(_briefcase.Configurations);
        }

        /// <summary>
        /// Get Client Current Balance
        /// </summary>
        /// <param name="clientId"></param>
        /// <returns></returns>
        [HttpGet, Route("ClientBalance")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public IHttpActionResult GetClientBalance(int clientId)
        {
            var cl = _repo.GetClientBalance(clientId);

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
    }
}
