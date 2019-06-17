using System;
using System.ComponentModel.DataAnnotations;

namespace SC.Api.Models
{
    [Serializable]
    public class ServiceModel
    {
        public int ServiceId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int ClientId { get; set; }
        public int ProcedureCodeId { get; set; }
        public DateTime DateOfService { get; set; }
        public DateTime ? EndDateOfService { get; set; }
        public decimal Unit { get; set; }
        public int? UnitType { get; set; }
        public int Status { get; set; }
        public int? ClinicianId { get; set; }
        public string ClinicianName { get; set; }
        public int? AttendingId { get; set; }
        public int ProgramId { get; set; }
        public int? LocationId { get; set; }
        public DateTime? DateTimeIn { get; set; }
        public DateTime? DateTimeOut { get; set; }
        public string Billable { get; set; }
        public string SpecificLocation { get; set; }
        public string CustomFieldObjectName { get; set; }
        public object CustomFields { get; set; }
        public Models.ServiceDiagnosModel[] Diagnosis { get; set; }
        public object ServiceValidations { get; set; }
        public DocumentModel Document { get; set; }
        public string ProgramName { get; set; }
        public string LocationName { get; set; }
        public string ProcedureCodeName { get; set; }
        public int? ProcedureRateId { get; set; }
        public Decimal? Charge { get; set; }
    }

    [Serializable]
    public class APIServiceModel
    {
        [Required]
        public int Id { get; set; }
        [Required]
        public DateTime DateOfService { get; set; }
        [Required]
        public DateTime EffectiveDate { get; set; }
        [Required]
        public decimal Unit { get; set; }
        [Required]
        public int ProgramId { get; set; }
        [Required]
        public int ProcedureCodeId { get; set; }
        [Required]
        public int LocationId { get; set; }
        public string SpecificLocation { get; set; }
        [Required]
        public int ClinicianId { get; set; }
        [Required]
        public int AttendingId { get; set; }
    }
}