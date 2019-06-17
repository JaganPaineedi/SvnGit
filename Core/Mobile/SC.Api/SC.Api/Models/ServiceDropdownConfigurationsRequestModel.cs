using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ServiceDropdownConfigurationsRequestModel
    {
        [Required]
        public int id { get; set; }
        [Required]
        public int ClinicianId { get; set; }
        public DateTime? DateOfService { get; set; }
        public int ProgramId { get; set; }
        public int ProcedureCodeId { get; set; }
        public int LocationId { get; set; }
        public int AttendingId { get; set; }
        

    }
}