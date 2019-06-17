using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ServiceDropdownConfigurationsResponseModel
    {
        public List<ProgramModel> ProgramDetails { get; set; }
        public List<ProcedureCodeModel> ProcedureDetails { get; set; }
        public List<LocationModel> LocationDetails { get; set; }
        public List<AttendingModel> AttendingDetails { get; set; }
        public List<ClinicianModel> ClinicianDetails { get; set; }
        public List<PlaceOfServiceModel> PlaceOfServiceDetails { get; set; }
        public DateTime? DateOfService { get; set; }
    }
}