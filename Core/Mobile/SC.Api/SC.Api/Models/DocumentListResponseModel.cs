using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class DocumentListResponseModel
    {
        public string DocumentName { get; set; }
        public int DocumentCodeId { get; set;}
        public DateTime EffectiveDate { get; set; }
        public string Status { get; set; }
        public string Version { get; set; }
        public DateTime? DueDate { get; set; }
        public string Author { get; set; }
        public string ToCoSign { get; set; }
        public string ClientToSign { get; set; }
        public string Shared { get; set; }
    }
}