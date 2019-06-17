using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ScreenModel
    {
        public int ScreenId { get; set; }
        public string ScreenName { get; set; }
        public int DocumentCodeId { get; set; }
        public string PostUpdateStoredProcedure { get; set; }
    }
}