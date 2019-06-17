using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ApiDetailsModel
    {
        public string Version { get; set; }
        public string Description { get; set; }
        public string DocumentationUrl { get; set; }
        public string TermsofUseUrl { get; set; }
    }
}