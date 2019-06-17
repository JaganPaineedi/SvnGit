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
    [RoutePrefix("api/Client"), LoggingServiceFilterAttribute]
    public class ClientController : ApiController
    {
        IClientRepository _repo;
        public ClientController(IClientRepository repo)
        { _repo = repo; }

        /// <summary>
        /// Get Client Current Balance
        /// </summary>
        /// <param name="clientId"></param>
        /// <returns></returns>
        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpGet, Route("ClientBalance")]
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
        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpPost, Route("UpdatePayment")]
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
    }
}