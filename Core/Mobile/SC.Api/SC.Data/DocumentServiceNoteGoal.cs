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
    
    public partial class DocumentServiceNoteGoal
    {
        public int DocumentServiceNoteGoalId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public string DeletedBy { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public Nullable<int> DocumentVersionId { get; set; }
        public Nullable<int> GoalId { get; set; }
        public Nullable<decimal> GoalNumber { get; set; }
        public string GoalText { get; set; }
        public string CustomGoalActive { get; set; }
    
        public virtual DocumentVersion DocumentVersion { get; set; }
    }
}
