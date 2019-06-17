using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SC.Data
{
    public static class CommonFunctions<T>
    {
        static SCMobile _ctx = new SCMobile();
        /// <summary>
        /// Create/Update MobileBriefcase data
        /// </summary>
        /// <param name="objId"></param>
        /// <param name="data"></param>
        /// <param name="staffId"></param>
        /// <param name="briefcaseType"></param>
        public static void CreateUpdateBriefcase(int objId,object data, int staffId, int briefcaseType)
        {
            if (data != null)
            {
                if (!_ctx.MobileBriefcase.Any(b => b.BreifcaseTypeId == objId && b.StaffId == staffId && b.BreifcaseType == briefcaseType))
                {
                    MobileBriefcase bc = new Data.MobileBriefcase();
                    bc.BreifcaseType = briefcaseType;
                    bc.BreifcaseTypeId = objId;
                    bc.BriefcaseData = Newtonsoft.Json.JsonConvert.SerializeObject(data, Newtonsoft.Json.Formatting.Indented);
                    bc.StaffId = staffId;
                    bc.CreatedBy = GetCurrentUser(staffId);
                    bc.CreatedDate = DateTime.Now;
                    bc.ModifiedBy = GetCurrentUser(staffId);
                    bc.ModifiedDate = DateTime.Now;

                    _ctx.MobileBriefcase.Add(bc);
                    _ctx.SaveChanges();
                }
                else
                {
                    var obj = _ctx.MobileBriefcase.Where(b => b.BreifcaseTypeId == objId && b.StaffId == staffId && b.BreifcaseType == briefcaseType)
                           .FirstOrDefault();

                    obj.BriefcaseData = Newtonsoft.Json.JsonConvert.SerializeObject(data, Newtonsoft.Json.Formatting.Indented);

                    _ctx.SaveChanges();
                }
            }
        }
        /// <summary>
        /// Get Briefcase data
        /// </summary>
        /// <param name="objId"></param>
        /// <param name="staffId"></param>
        /// <param name="briefcaseType"></param>
        /// <returns></returns>
        public static T GetBriefcase(int objId, int staffId, int briefcaseType)
        {
            var obj = _ctx.MobileBriefcase.Where(b => b.BreifcaseTypeId == objId && b.StaffId == staffId && b.BreifcaseType == briefcaseType)
                .Select(a => a.BriefcaseData).FirstOrDefault();

            return Newtonsoft.Json.JsonConvert.DeserializeObject<T>(obj);
        }
        /// <summary>
        /// Get Current User
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public static string GetCurrentUser(int staffId)
        {
            return _ctx.Staffs.Where(a => a.StaffId == staffId).Select(a => a.UserCode).FirstOrDefault();
        }
    }
}
