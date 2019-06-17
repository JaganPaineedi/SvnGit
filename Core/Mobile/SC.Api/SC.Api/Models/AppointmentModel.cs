using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    [Serializable]
    public class AppointmentModel
    {
        public int AppointmentId { get; set; }
        public int StaffId { get; set; }
        public string Subject { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public int? AppointmentType { get; set; }
        public string Description { get; set; }
        public int ShowTimeAs { get; set; }
        public int? LocationId { get; set; }
        public string SpecificLocation { get; set; }
        public int? ServiceId { get; set; }
        public int? GroupServiceId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public DateTime ? DeletedDate { get; set; }
        public string DeletedBy { get; set; }
        public bool Readonly { get; set; }
        public ServiceModel Service { get; set; }

    }

    public class AppointmentReadModel
    {
        //public string StaffName { get; set; }
        //public string Subject { get; set; }
        public int AppointmentId { get; set; }
        public string AppointmentStartTime { get; set; }
        public string AppointmentEndTime { get; set; }
        //public string ClientName { get; set; }

        //public string Duration { get; set; }
        //public string Location { get; set; }
        //public string ProcedureCode { get; set; }
        //public string Program { get; set; }
    }

    public class AppointmentRequestModel
    {
        public int Id { get; set; }
        public int ClinicianId { get; set; }
        [Required]
        public string StartTime { get; set; }
        [Required]
        public string EndTime { get; set; }
        [Required]
        public string StartDate { get; set; }
        [Required]
        public int Minutes { get; set; }
    }

    public class AppointmentSearchModel
    {
        [Required]
        public int Id { get; set; }
        public int ? ClinicianId { get; set; }
    }

    public class AppointmentResponseModel
    {
        public string ClinicianName { get; set; }
        public DateTime AvailableDateTime { get; set; }
        public int Duration { get; set; }
        public string DurationFormat { get; set; }
    }
    [Serializable]
    public class PrimaryCareAppointmentRequestModel
    {
        [Required]
        public string Subject { get; set; }
        [Required]
        public int LocationId { get; set; }
        public string SpecificLocation { get; set; }
        [Required]
        public DateTime StartTime { get; set; }
        [Required]
        public DateTime EndTime { get; set; }
        [Required]
        public int AppointmentType { get; set; }
        [Required]
        public int ShowTimeAs { get; set; }
        public string Description { get; set; }
    }
    [Serializable]
    public class PrimaryCareAppointmentResponseModel
    {
        public int AppointmentId { get; set; }
        public string Subject { get; set; }
        public int? LocationId { get; set; }
        public string SpecificLocation { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public int? AppointmentType { get; set; }
        public int ShowTimeAs { get; set; }
        public int StaffId { get; set; }
        public string StaffName { get; set; }
        public string Description { get; set; }
    }
}