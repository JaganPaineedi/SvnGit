using SC.Api.Filters;
using SC.Api.Models;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Description;

namespace SC.Api
{
    [RoutePrefix("api/MyPreference"), LoggingServiceFilterAttribute]
    public class MyPreferenceController : ApiController
    {
        private IMobileStaffRepository _repo;

        /// <summary>
        /// Constructor for MyPreferenceController
        /// </summary>
        /// <param name="repo"></param>
        public MyPreferenceController(IMobileStaffRepository repo)
        {
            _repo = repo;
        }
        /// <summary>
        /// Post MyPreference Data
        /// </summary>
        /// <param name="myPreferences"></param>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [Authorize]
        public async Task<IHttpActionResult> Post([FromBody]List<SC.Data.StaffPreferences> myPreferences)
        {
            try
            {
                int loggedInUser = 0;
                int.TryParse(GetQueryString(Request, "StaffId"), out loggedInUser);
                List<_SCResult<Models.StaffPreferenceModel>> results = new List<_SCResult<Models.StaffPreferenceModel>>();

                if (myPreferences != null)
                {
                    var _Ce = await _repo.Save(myPreferences[0], loggedInUser);

                    results.Add(_Ce);

                    if (_Ce.SavedResult != null)
                        return Ok(results);
                    else
                        return BadRequest("Save failed for 'mypreference'");
                }
                else return BadRequest("myPreference object is null");
            }
            catch (System.Exception ex)
            {
                throw ex;
            }            
        }

        private string GetQueryString(HttpRequestMessage request, string key)
        {
            var queryStrings = request.GetQueryNameValuePairs();

            if (queryStrings == null) return null;

            var match = queryStrings.FirstOrDefault(keyValue => string.Compare(keyValue.Key, key, true) == 0);

            if (string.IsNullOrEmpty(match.Value)) return null;

            return match.Value;
        }

        /// <summary>
        /// Use to update the RegisterForMobileNotifications flag in StaffPreference table.
        /// </summary>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true), Authorize]
        [HttpGet, Route("RegisterForMobileNotifications")]
        public bool RegisterForMobileNotifications([FromUri(Name = "")]MobileRegistration mobileRegistration)
        {
            int staffId = 0;
            //Exception exception = new Exception();
            bool updated = false;
            if (mobileRegistration.StaffId == 0)
            {
                staffId = ((CurrentLoggedInStaff)HttpContext.Current.Session["CurrentStaff"]).StaffId;
                mobileRegistration.StaffId = staffId;
            }
            if (!_repo.IsMobileUser(mobileRegistration.StaffId))
                updated = false;
            else
            {
                var value = _repo.RegisterForMobileNotifications(mobileRegistration);
                if ((int)value > 0)
                    updated = true;
            }
            return updated;
        }
    }
}
