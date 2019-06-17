using SC.Data;
using System.Collections.Generic;
using System.Linq;
using System;
using SC.Api.Models;

namespace SC.Api
{
    public class CommonRepository: ICommonRepository
    {
        private SCMobile _ctx;

        public CommonRepository(SCMobile ctx)
        {
            _ctx = ctx;
        }

        public List<GlobalCodeModel> GetGlobalCodes(string Category)
        {
            return _ctx.GlobalCodes
                .Where(a => a.Category == Category && a.Active == "Y" && a.RecordDeleted != "Y")
                .OrderBy(a => a.SortOrder)
                .Select(a => new GlobalCodeModel() { GlobalCodeId = a.GlobalCodeId, CodeName = a.CodeName, Category = a.Category }).ToList<GlobalCodeModel>();
        }

        /// <summary>
        /// Get Locations
        /// </summary>
        /// <returns></returns>
        public List<LocationModel> GetLocations()
        {
            return _ctx.Locations
                 .Where(a => a.Active == "Y" && a.RecordDeleted != "Y")
                 .OrderBy(a => a.LocationCode)
                 .Select(a => new LocationModel() { LocationId = a.LocationId, LocationCode = a.LocationCode, LocationName = a.LocationName })
                 .ToList<LocationModel>();
        }

        public List<ProcedureModel> GetProcedureCodes()
        {
            return _ctx.ProcedureCodes
                .Where(a => a.Active == "Y" && a.RecordDeleted != "Y")
                .OrderBy(a => a.ProcedureCodeName)
                .Select(a => new ProcedureModel() { ProcedureCodeId = a.ProcedureCodeId, ProcedureCodeName = a.ProcedureCodeName, DisplayAs = a.DisplayAs, EnteredAs = a.EnteredAs, RequiresTimeInTimeOut = a.RequiresTimeInTimeOut })
                .ToList<ProcedureModel>();
        }

        public List<ProgramModel> GetPrograms()
        {
            return _ctx.Programs
                .Where(a => a.Active == "Y" && a.RecordDeleted != "Y")
                .OrderBy(a => a.ProgramCode)
                .Select(a => new ProgramModel() { ProgramId = a.ProgramId, ProgramCode = a.ProgramCode, ProgramName = a.ProgramName })
                .ToList<ProgramModel>();
        }

        public ScreenModel GetScreenDetail(int DocumentCodeId)
        {
            return _ctx.Screens
                .Where(s => s.DocumentCodeId == DocumentCodeId)
                .Select(s => new ScreenModel() { ScreenId = s.ScreenId, ScreenName = s.ScreenName, PostUpdateStoredProcedure = s.PostUpdateStoredProcedure }).FirstOrDefault();
        }

        /// <summary>
        /// Get ScreenId based on ScreenUrl
        /// </summary>
        /// <param name="screenUrl"></param>
        /// <returns></returns>
        public int GetScreenId(string screenUrl)
        {
            return _ctx.Screens
                .Where(a => a.ScreenURL == screenUrl)
                .Select(a => a.ScreenId)
                .FirstOrDefault();
        }
    }
}