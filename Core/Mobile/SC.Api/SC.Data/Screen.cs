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
    
    public partial class Screen
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Screen()
        {
            this.Staffs = new HashSet<Staff>();
            this.Staffs1 = new HashSet<Staff>();
        }
    
        public int ScreenId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public string DeletedBy { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public string ScreenName { get; set; }
        public int ScreenType { get; set; }
        public string ScreenURL { get; set; }
        public string ScreenToolbarURL { get; set; }
        public int TabId { get; set; }
        public string InitializationStoredProcedure { get; set; }
        public string ValidationStoredProcedureUpdate { get; set; }
        public string ValidationStoredProcedureComplete { get; set; }
        public string WarningStoredProcedureComplete { get; set; }
        public string PostUpdateStoredProcedure { get; set; }
        public string RefreshPermissionsAfterUpdate { get; set; }
        public Nullable<int> DocumentCodeId { get; set; }
        public Nullable<int> CustomFieldFormId { get; set; }
        public string HelpURL { get; set; }
        public Nullable<int> MessageReferenceType { get; set; }
        public string PrimaryKeyName { get; set; }
        public string WarningStoreProcedureUpdate { get; set; }
        public Nullable<int> KeyPhraseCategory { get; set; }
        public string ScreenParamters { get; set; }
    
        public virtual DocumentCode DocumentCode { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Staff> Staffs { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Staff> Staffs1 { get; set; }
    }
}
