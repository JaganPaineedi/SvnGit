using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ErrorLogModel
    {
        public int ErrorLogId { get; set; }
        public string ErrorMessage { get; set; }
        public string DataSetInfo { get; set; }
        public string VerboseInfo { get; set; }
        public string ErrorType { get; set; }
    }
}