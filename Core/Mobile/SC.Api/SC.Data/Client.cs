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
    
    public partial class Client
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Client()
        {
            this.Appointments = new HashSet<Appointment>();
            this.Documents = new HashSet<Document>();
            this.Services = new HashSet<Service>();
            this.Staffs = new HashSet<Staff>();
            this.StaffClientAccess = new HashSet<StaffClientAccess>();
        }
    
        public int ClientId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public string DeletedBy { get; set; }
        public string ExternalClientId { get; set; }
        public string Active { get; set; }
        public string MRN { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string Prefix { get; set; }
        public string Suffix { get; set; }
        public string SSN { get; set; }
        public string Sex { get; set; }
        public Nullable<System.DateTime> DOB { get; set; }
        public Nullable<int> PrimaryClinicianId { get; set; }
        public string CountyOfResidence { get; set; }
        public string CountyOfTreatment { get; set; }
        public Nullable<int> CorrectionStatus { get; set; }
        public string Email { get; set; }
        public string Comment { get; set; }
        public Nullable<int> LivingArrangement { get; set; }
        public Nullable<int> NumberOfBeds { get; set; }
        public string MinimumWage { get; set; }
        public string FinanciallyResponsible { get; set; }
        public Nullable<decimal> AnnualHouseholdIncome { get; set; }
        public Nullable<int> NumberOfDependents { get; set; }
        public Nullable<int> MaritalStatus { get; set; }
        public Nullable<int> EmploymentStatus { get; set; }
        public string EmploymentInformation { get; set; }
        public Nullable<int> MilitaryStatus { get; set; }
        public Nullable<int> EducationalStatus { get; set; }
        public string DoesNotSpeakEnglish { get; set; }
        public Nullable<int> PrimaryLanguage { get; set; }
        public Nullable<int> CurrentEpisodeNumber { get; set; }
        public Nullable<int> AssignedAdminStaffId { get; set; }
        public Nullable<int> InpatientCaseManager { get; set; }
        public string InformationComplete { get; set; }
        public Nullable<int> PrimaryProgramId { get; set; }
        public string LastNameSoundex { get; set; }
        public string FirstNameSoundex { get; set; }
        public Nullable<decimal> CurrentBalance { get; set; }
        public Nullable<int> CareManagementId { get; set; }
        public Nullable<int> HispanicOrigin { get; set; }
        public Nullable<System.DateTime> DeceasedOn { get; set; }
        public Nullable<System.DateTime> LastStatementDate { get; set; }
        public Nullable<int> LastPaymentId { get; set; }
        public Nullable<int> LastClientStatementId { get; set; }
        public string DoNotSendStatement { get; set; }
        public Nullable<int> DoNotSendStatementReason { get; set; }
        public string AccountingNotes { get; set; }
        public string MasterRecord { get; set; }
        public Nullable<int> ProviderPrimaryClinicianId { get; set; }
        public System.Guid RowIdentifier { get; set; }
        public string ExternalReferenceId { get; set; }
        public string DoNotOverwritePlan { get; set; }
        public Nullable<int> Disposition { get; set; }
        public string NoKnownAllergies { get; set; }
        public Nullable<int> ReminderPreference { get; set; }
        public Nullable<int> MobilePhoneProvider { get; set; }
        public string SchedulingPreferenceMonday { get; set; }
        public string SchedulingPreferenceTuesday { get; set; }
        public string SchedulingPreferenceWednesday { get; set; }
        public string SchedulingPreferenceThursday { get; set; }
        public string SchedulingPreferenceFriday { get; set; }
        public string GeographicLocation { get; set; }
        public string SchedulingComment { get; set; }
        public Nullable<int> CauseofDeath { get; set; }
        public string FosterCareLicence { get; set; }
        public Nullable<int> PrimaryPhysicianId { get; set; }
        public string AllergiesLastReviewedBy { get; set; }
        public Nullable<System.DateTime> AllergiesLastReviewedDate { get; set; }
        public Nullable<int> AllergiesReviewStatus { get; set; }
        public string HasNoMedications { get; set; }
        public Nullable<int> UserStaffId { get; set; }
        public string ProfessionalSuffix { get; set; }
        public string ClientType { get; set; }
        public string OrganizationName { get; set; }
        public string EIN { get; set; }
        public Nullable<int> GenderIdentity { get; set; }
        public Nullable<int> SexualOrientation { get; set; }
        public string InternalCollections { get; set; }
        public string ExternalCollections { get; set; }
        public Nullable<int> NoKnownAllergiesLastUpdatedBy { get; set; }
        public Nullable<System.DateTime> NoKnownAllergiesLastUpdatedDate { get; set; }
        public string SchedulingPreferenceSaturday { get; set; }
        public string SchedulingPreferenceSunday { get; set; }
        public Nullable<int> PreferredGenderPronoun { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Appointment> Appointments { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Document> Documents { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Service> Services { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Staff> Staffs { get; set; }
        public virtual Staff Staff { get; set; }
        public virtual Staff Staff1 { get; set; }
        public virtual Staff Staff2 { get; set; }
        public virtual Staff Staff3 { get; set; }
        public virtual Staff Staff4 { get; set; }
        public virtual Staff Staff5 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<StaffClientAccess> StaffClientAccess { get; set; }
    }
}
