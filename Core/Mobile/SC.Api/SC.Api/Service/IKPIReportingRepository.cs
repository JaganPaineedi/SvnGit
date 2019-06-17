using SC.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SC.Api
{
    interface IKPIReportingRepository
    {
        void SaveMetricDataLogs(System.Data.DataTable dtTable, int kpid, int customerId, string environmentType);       
    }
}
