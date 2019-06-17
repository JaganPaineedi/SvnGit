using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public partial class StaffPreferenceModel
    {
        public int StaffPreferenceId { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string ModifiedBy { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public string RecordDeleted { get; set; }
        public string DeletedBy { get; set; }
        public Nullable<System.DateTime> DeletedDate { get; set; }
        public int StaffId { get; set; }
        public Nullable<int> DefaultMobileHomePageId { get; set; }
        public Nullable<int> DefaultMobileProgramId { get; set; }
        public Nullable<int> MobileCalendarEventsDaysLookUpInPast { get; set; }
        public Nullable<int> MobileCalendarEventsDaysLookUpInFuture { get; set; }
        public Nullable<int> TreatmentTeamRole { get; set; }

        public string StaffName { get; set; }
        public string ProgramName { get; set; }
    }
}