using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ServiceDropdownValuesModel
    {
        public List<_ProcedureCode> ProcedureCodes { get; set; }
        public List<_Location> Locations { get; set; }
        public List<_Program> Programs { get; set; }
        public List<_Attending> ServiceAttending { get; set; }
        public List<_Clinician> Clinicians { get; set; }
    }

    public class _ProcedureCode
    {
        public int ProcedureCodeId { get; set; }
        public string ProcedureCodeName { get; set; }
        public int AssociatedNoteId { get; set; }
    }

    public class _Location
    {
        public int LocationId { get; set; }
        public string LocationName { get; set; }
    }

    public class _Program
    {
        public int ProgramId { get; set; }
        public string ProgramCode { get; set; }        
    }

    public class _Attending
    {
        public int StaffId { get; set; }
        public string StaffName { get; set; }
    }

    public class _Clinician
    {
        public int StaffProgramId { get; set; }
        public int ClinicianId { get; set; }
        public string ClinicianName { get; set; }
        public int ProgramId { get; set; }
    }
}