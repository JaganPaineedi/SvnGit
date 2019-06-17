using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ClientDocumentsModel
    {
        public int ClientId { get; set; }
        public string ClientName { get; set; }
        public string DocumentName { get; set; }
        public DateTime EffectiveDate { get; set; }
        public string DisplayAs { get; set; }
        public int AuthorId { get; set; }
        public int DocumentId { get; set; }
        public int DocumentVersionId { get; set; }
        public string ViewHTML { get; set; }
        public int ? SignedDocumentVersionId { get; set; }
        public int DocumentCodeId { get; set; }
        public SignatureModel Signature { get; set; }
        public string SignerName { get; set; }
        public int ? RelationToClient { get; set; }
        public string IsClient { get; set; }
        public int SignatureId { get; set; }
    }
}