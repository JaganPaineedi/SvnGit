using SC.Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SC.Api
{
    public interface IErrorLogRepository
    {
        void LogError(ErrorLogModel errorlog, int StaffId = 0);
    }
}
