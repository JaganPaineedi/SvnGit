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
    
    public partial class ActiveDirectoryStaff
    {
        public int StaffId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public string DeletedBy { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public int ActiveDirectoryDomainId { get; set; }
        public string ActiveDirectoryGUID { get; set; }
        public string SynchronizeWithActiveDirectory { get; set; }
        public Nullable<System.DateTime> LastActiveDirectorySync { get; set; }
        public Nullable<System.DateTime> AttributeModifiedDate { get; set; }
        public string ActiveDirectoryAttributes { get; set; }
    
        public virtual ActiveDirectoryDomains ActiveDirectoryDomains { get; set; }
        public virtual Staff Staff { get; set; }
        public virtual ActiveDirectoryStaff ActiveDirectoryStaff1 { get; set; }
        public virtual ActiveDirectoryStaff ActiveDirectoryStaff2 { get; set; }
    }
}
