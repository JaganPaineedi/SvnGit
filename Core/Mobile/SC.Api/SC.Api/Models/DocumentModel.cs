using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class DocumentModel
    {
        public int DocumentId { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public string DeletedBy { get; set; }
        public Nullable<int> ClientId { get; set; }
        public Nullable<int> ServiceId { get; set; }
        public Nullable<int> DocumentCodeId { get; set; }
        public Nullable<System.DateTime> EffectiveDate { get; set; }
        public int Status { get; set; }
        public Nullable<int> AuthorId { get; set; }
        public Nullable<int> CurrentDocumentVersionId { get; set; }
        public string SignedByAuthor { get; set; }
        public string SignedByAll { get; set; }
        public Nullable<int> InProgressDocumentVersionId { get; set; }
        public Nullable<int> CurrentVersionStatus { get; set; }
        public Nullable<int> AppointmentId { get; set; }
        public DocumentVersionModel DocumentVersion { get; set; }
    }
}