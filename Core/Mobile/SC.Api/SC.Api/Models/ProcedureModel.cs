using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ProcedureModel
    {
        public int ProcedureCodeId { get; set; }
        public string ProcedureCodeName { get; set; }
        public string DisplayAs { get; set; }
        public int EnteredAs { get; set; }
        public string RequiresTimeInTimeOut { get; set; }
    }
}