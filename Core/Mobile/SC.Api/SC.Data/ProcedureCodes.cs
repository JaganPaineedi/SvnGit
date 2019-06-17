//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SC.Data
{
    using System;
    using System.Collections.Generic;
    
    public partial class ProcedureCodes
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ProcedureCodes()
        {
            this.Services = new HashSet<Service>();
        }
    
        public int ProcedureCodeId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public string DeletedBy { get; set; }
        public string DisplayAs { get; set; }
        public string ProcedureCodeName { get; set; }
        public string Active { get; set; }
        public string AllowDecimals { get; set; }
        public int EnteredAs { get; set; }
        public string NotBillable { get; set; }
        public string DoesNotRequireStaffForService { get; set; }
        public string NotOnCalendar { get; set; }
        public string FaceToFace { get; set; }
        public string GroupCode { get; set; }
        public string MedicationCode { get; set; }
        public string EndDateEqualsStartDate { get; set; }
        public string RequiresTimeInTimeOut { get; set; }
        public string RequiresSignedNote { get; set; }
        public Nullable<int> AssociatedNoteId { get; set; }
        public Nullable<decimal> MinUnits { get; set; }
        public Nullable<decimal> MaxUnits { get; set; }
        public Nullable<decimal> UnitIncrements { get; set; }
        public string UnitsList { get; set; }
        public string ExternalCode1 { get; set; }
        public Nullable<int> ExternalSource1 { get; set; }
        public string ExternalCode2 { get; set; }
        public Nullable<int> ExternalSource2 { get; set; }
        public int CreditPercentage { get; set; }
        public Nullable<int> Category1 { get; set; }
        public Nullable<int> Category2 { get; set; }
        public Nullable<int> Category3 { get; set; }
        public string DisplayDocumentAsProcedureCode { get; set; }
        public string AllowModifiersOnService { get; set; }
        public string AllowAllPrograms { get; set; }
        public string AllowAllLicensesDegrees { get; set; }
        public string BedProcedureCode { get; set; }
        public string MedicationProcedureCode { get; set; }
        public string Mobile { get; set; }
        public Nullable<int> MobileAssociatedNoteId { get; set; }
        public string DoesNotRequireBillingDiagnosis { get; set; }
        public string AttendanceServiceProcedureCode { get; set; }
        public string ExternalCode3 { get; set; }
        public Nullable<int> ExternalSource3 { get; set; }
        public string AllowAttachmentsToService { get; set; }
    
        public virtual DocumentCode DocumentCodes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Service> Services { get; set; }
        public virtual DocumentCode DocumentCodes1 { get; set; }
    }
}