using SC.Data;
using System;
using System.Collections.Generic;

namespace SC.Api.Models
{
    public class BriefCaseModel
    {
        public DateTime UpdatedOn { get; set; }
        public string caseload { get; set; }
        public List<SC.Data.MobileDashboards> Dashboards { get; set; }
        public List<GlobalCode> GlobalCodes { get; set; }        
        public StaffPreferenceModel MyPreference { get; set; }
        public string TeamCalendarStaff { get; set; }
        public ServiceDropdownValuesModel ServiceDropdownValues { get; set; }
        public List<AppointmentModel> Events { get; set; }
        public List<SystemConfigurationKeyModel> Configurations { get; set; }
        public List<ClientDocumentsModel> ClientDocuments { get; set; }
    } 
}