using SC.Api.Filters;
using SC.Api.Models;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Http;
using System.Web.Http.Description;

namespace SC.Api.Controllers
{
    /// <summary>
    /// Controller for Common functionality
    /// </summary>
    [RoutePrefix("api/Common"), LoggingServiceFilterAttribute]
    public class CommonController : ApiController
    {
        private ICommonRepository _ctx;

        /// <summary>
        /// COnstructor for CommonController
        /// </summary>
        /// <param name="ctx"></param>
        public CommonController(ICommonRepository ctx)
        { _ctx = ctx; }

        /// <summary>
        /// Get GlobalCode values based on Category
        /// </summary>
        /// <param name="Category"></param>
        /// <returns></returns>
        [HttpGet,Authorize, Route("GetGlobalCodes")]
        public List<GlobalCodeModel> GetGlobalCode(string Category)
        {
            return _ctx.GetGlobalCodes(Category);
        }

        /// <summary>
        /// Get Active Locations
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("GetLocations"), ApiExplorerSettings(IgnoreApi = true)]
        public List<LocationModel> GetLocations()
        {
            return _ctx.GetLocations();
        }

        /// <summary>
        /// Get Active ProcedureCodes
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("GetProcedureCodes"), ApiExplorerSettings(IgnoreApi = true)]
        public List<ProcedureModel> GetProcedureCodes()
        {
            return _ctx.GetProcedureCodes();
        }

        /// <summary>
        /// Get Active Programs
        /// </summary>
        /// <returns></returns>
        [HttpGet, Authorize, Route("GetPrograms"), ApiExplorerSettings(IgnoreApi = true)]
        public List<ProgramModel> GetPrograms()
        {
            return _ctx.GetPrograms();
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        [HttpGet, Route("GetApiDetails")]
        public ApiDetailsModel GetApiDetails()
        {
            string _version = ConfigurationManager.AppSettings["Version"];
            string _description = ConfigurationManager.AppSettings["Description"];
            string _documentationUrl = ConfigurationManager.AppSettings["DocumentationUrl"];
            string _termsofUseUrl = ConfigurationManager.AppSettings["TermsofUseUrl"];

            return new ApiDetailsModel() { Version = _version, Description = _description, DocumentationUrl = _documentationUrl, TermsofUseUrl = _termsofUseUrl };
        }
    }
}