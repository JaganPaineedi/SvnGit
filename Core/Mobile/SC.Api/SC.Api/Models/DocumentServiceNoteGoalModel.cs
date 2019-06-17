using System;

namespace SC.Api.Models
{
    public partial class DocumentServiceNoteGoalModel
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
    }
}