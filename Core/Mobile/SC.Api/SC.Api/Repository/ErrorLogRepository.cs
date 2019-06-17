using SC.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SC.Api.Models;

namespace SC.Api
{
    public class ErrorLogRepository : IErrorLogRepository
    {
        private SCMobile _ctx;

        public ErrorLogRepository(SCMobile ctx)
        {
            _ctx = ctx;
        }

        public void LogError(ErrorLogModel errorlog, int StaffId = 0)
        {
            try
            {
                string usercode = string.Empty;
                if (errorlog != null)
                {
                    if (StaffId > 0)
                        usercode = _ctx.Staffs
                            .Where(s => s.StaffId == StaffId)
                            .Select(s => s.UserCode).FirstOrDefault();
                    else
                        usercode = "CommonUser";

                    _ctx.ssp_SCLogError(errorlog.ErrorMessage, errorlog.VerboseInfo, errorlog.ErrorType, usercode, DateTime.Now, errorlog.DataSetInfo);
                }
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in ErrorLogRepository.LogError method." + ex.Message);
                throw excep;
            }
        }
    }
}