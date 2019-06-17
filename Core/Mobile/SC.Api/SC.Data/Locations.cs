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
    
    public partial class Locations
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Locations()
        {
            this.Appointments = new HashSet<Appointment>();
            this.Services = new HashSet<Service>();
            this.Staff = new HashSet<Staff>();
        }
    
        public int LocationId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public string DeletedBy { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public string LocationCode { get; set; }
        public string LocationName { get; set; }
        public string Active { get; set; }
        public string PrescribingLocation { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }
        public string PhoneNumber { get; set; }
        public Nullable<int> LocationType { get; set; }
        public Nullable<int> PlaceOfService { get; set; }
        public string Comment { get; set; }
        public string HandicapAcceess { get; set; }
        public string Adult { get; set; }
        public string Child { get; set; }
        public Nullable<System.DateTime> MondayFrom { get; set; }
        public Nullable<System.DateTime> MondayTo { get; set; }
        public string MondayClosed { get; set; }
        public Nullable<System.DateTime> TuesdayFrom { get; set; }
        public Nullable<System.DateTime> TuesdayTo { get; set; }
        public string TuesdayClosed { get; set; }
        public Nullable<System.DateTime> WednesdayFrom { get; set; }
        public Nullable<System.DateTime> WednesdayTo { get; set; }
        public string WednesdayClosed { get; set; }
        public Nullable<System.DateTime> ThursdayFrom { get; set; }
        public Nullable<System.DateTime> ThursdayTo { get; set; }
        public string ThursdayClosed { get; set; }
        public Nullable<System.DateTime> FridayFrom { get; set; }
        public Nullable<System.DateTime> FridayTo { get; set; }
        public string FridayClosed { get; set; }
        public Nullable<System.DateTime> SaturdayFrom { get; set; }
        public Nullable<System.DateTime> SaturdayTo { get; set; }
        public string SaturdayClosed { get; set; }
        public Nullable<System.DateTime> SundayFrom { get; set; }
        public Nullable<System.DateTime> SundayTo { get; set; }
        public string SundayClosed { get; set; }
        public string ExternalReferenceId { get; set; }
        public string FaxNumber { get; set; }
        public string NationalProviderId { get; set; }
        public string DefaultLocationForServiceCreationFromClaims { get; set; }
        public string AddressDisplay { get; set; }
        public System.Guid RowIdentifier { get; set; }
        public string Mobile { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Appointment> Appointments { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Service> Services { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Staff> Staff { get; set; }
    }
}
