using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class DocumentListRequestModel
    {
        public int AuthorId { get; set; }
        public int DocumentCodeId { get; set; }
        [Required]
        public int id { get; set; }
        public int Status { get; set; }
        public int DueInXDays { get; set; }
        public string IncludeErrorDocument { get; set; }
        public DateTime? FromDate { set; get; }
        public DateTime? ToDate { set; get; }
    }
}