using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SC.Data
{
    public static class CommonDBFunctions
    {
        static SCMobile _ctx = new SCMobile();

        public static GlobalCode GetGlobalCode(int ? GlobalCodeId)
        {
            return _ctx.GlobalCodes
                 .Where(a => a.GlobalCodeId == GlobalCodeId && a.Active == "Y")
                 .FirstOrDefault();
        }


        public static int GetGlobalCodeId(string category, string code)
        {
            return _ctx.GlobalCodes
                 .Where(a => a.Category == category && a.Active == "Y" && a.Code == code)
                 .Select(a => a.GlobalCodeId)
                 .FirstOrDefault();
        }

        public static string GetSystemConfigurationKeyValue(string key)
        {
                return _ctx.SystemConfigurationKeys
                    .Where(k => k.Key.ToLower() == key.ToLower() && (k.RecordDeleted.ToUpper() ?? "N") != "Y")
                    .DefaultIfEmpty(null)
                    .Select(k => k.Value ?? "")
                    .FirstOrDefault().ToString();
        }

        public static string GetCurrentUser(int staffId)
        {
            return _ctx.Staffs.Where(a => a.StaffId == staffId).Select(a => a.UserCode).FirstOrDefault();
        }
    }
}
