using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class DocumentVersionModel
    {
        public int DocumentVersionId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public string DeletedBy { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public int DocumentId { get; set; }
        public int Version { get; set; }
        public Nullable<int> AuthorId { get; set; }
        public Nullable<System.DateTime> EffectiveDate { get; set; }
        public object Note { get; set; }
        public object NoteValidations { get; set; }
        public DocumentServiceNoteGoalModel [] DocumentServiceNoteGoals { get; set; }
        public DocumentServiceNoteObjectiveModel [] DocumentServiceNoteObjectives { get; set; }
    }
}