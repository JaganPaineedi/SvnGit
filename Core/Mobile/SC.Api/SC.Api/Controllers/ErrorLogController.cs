using SC.Api.Filters;
using SC.Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace SC.Api.Controllers
{
    [RoutePrefix("api/ErrorLog"), LoggingServiceFilterAttribute]
    public class ErrorLogController : ApiController
    {
        private IErrorLogRepository _repo;

        public ErrorLogController(IErrorLogRepository repo)
        {
            _repo = repo;
        }
        /// <summary>
        /// Used to log error to ErrorLog table.
        /// </summary>
        /// <param name="errorlog"></param>
        /// <param name="StaffId"></param>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi =true)]
        [AllowAnonymous]
        public async Task<IHttpActionResult> Post([FromBody]ErrorLogModel errorlog, int StaffId)
        {
            _SCResult<Models.ErrorLogModel> results = new _SCResult<Models.ErrorLogModel>();
            try
            {
                _repo.LogError(errorlog, StaffId);
                results.DeleteUnsavedChanges = true;
                results.UnsavedId = errorlog.ErrorLogId;
            }
            catch(Exception)
            {
                results.DeleteUnsavedChanges = true;
                results.UnsavedId = errorlog.ErrorLogId;             
            }

            return Ok(results);
        }
    }
}
