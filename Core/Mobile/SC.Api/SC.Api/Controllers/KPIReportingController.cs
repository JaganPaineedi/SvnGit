using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using SC.Data;

namespace SC.Api
{
    /// <summary>
    /// This KPIReportingController class.
    /// Contains method to Post array of objects.
    /// </summary>
    /// 
    [RoutePrefix("api/KPIReporting")]
    public class KPIReportingController : ApiController
    {

        private KPIReportingRepository _repo;

        /// <summary>
        /// Assigns object of KPIReportingRepository to a variable.
        /// </summary>
        public KPIReportingController(KPIReportingRepository repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Posts array of objects.
        /// </summary>
        [System.Web.Http.Description.ApiExplorerSettings(IgnoreApi = true)]
        [Authorize]
        // POST: api/KPIReporting
        public async System.Threading.Tasks.Task<IHttpActionResult> Post([FromBody]object[] data)
        {
            try
            {
                int kpid = 0;
                int.TryParse(data[1].ToString(), out kpid);
                int customerid = 0;
                int.TryParse(data[2].ToString(), out customerid);
                _repo.SaveMetricDataLogs(JsonConvert.DeserializeObject<System.Data.DataTable>(data[0].ToString()), kpid, customerid, data[3].ToString());
                return Ok("Successful");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

    }
}
