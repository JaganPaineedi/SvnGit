using SC.Api.Filters;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace SC.Api.Controllers
{
    [RoutePrefix("api/Documents"), LoggingServiceFilterAttribute]
    public class DocumentsController : ApiController
    {
        public readonly IDocumentRepository _repo;
        public DocumentsController(IDocumentRepository repo)
        {
            _repo = repo;
        }
        /// <summary>
        /// Save Document Signature
        /// </summary>
        /// <param name="documents"></param>
        /// <returns></returns>
        [HttpPost, Authorize, ApiExplorerSettings(IgnoreApi = true)]
        public async Task<IHttpActionResult> Post([FromBody] List<Models.ClientDocumentsModel> documents)
        {
            List<_SCResult<Models.ClientDocumentsModel>> cDocuments = new List<_SCResult<Models.ClientDocumentsModel>>();
            //List<Models.ClientDocumentsModel> cDocuments = new List<Models.ClientDocumentsModel>();
            foreach (Models.ClientDocumentsModel item in documents)
            {
                cDocuments.Add(_repo.UpdateSignature(item));
            }

            return Ok(cDocuments);
        }
    }
}
