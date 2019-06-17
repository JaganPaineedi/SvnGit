using SC.Api.Models;
using SC.Data;
using System.Collections.Generic;

namespace SC.Api
{
    public interface ICommonRepository
    {
        List<GlobalCodeModel> GetGlobalCodes(string Category);
        List<LocationModel> GetLocations();
        List<ProcedureModel> GetProcedureCodes();
        List<ProgramModel> GetPrograms();
        int GetScreenId(string screenUrl);
        ScreenModel GetScreenDetail(int DocumentCodeId);
    }
}
