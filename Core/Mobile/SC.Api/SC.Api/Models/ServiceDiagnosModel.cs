using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ServiceDiagnosModel
    {
        public int ServiceDiagnosisId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public string DeletedBy { get; set; }
        public Nullable<int> ServiceId { get; set; }
        public string DSMCode { get; set; }
        public Nullable<int> DSMNumber { get; set; }
        public string DSMVCodeId { get; set; }
        public string ICD10Code { get; set; }
        public string ICD9Code { get; set; }
        public Nullable<int> Order { get; set; }
        public string Description { get; set; }

    }
}