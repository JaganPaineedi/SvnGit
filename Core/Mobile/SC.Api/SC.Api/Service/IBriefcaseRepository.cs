using SC.Api.Models;
using SC.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SC.Api
{
    public interface IBriefcaseRepository
    {
        ServiceDropdownValuesModel FillServiceDropdownValues(int currentStaffId);
        string GetTeamCalendarStaffList(int currentStaffId);
        Task<Models.StaffPreferenceModel> GetMyPreference(int currentStaffId);
        string GetCaseLoad(int currentStaffId);
        List<GlobalCode> GetGlobalCodes();
        //string GetAppointments(int currentStaffId);
        List<Models.AppointmentModel> GetCalanderEvents(int StaffId);
        List<SC.Data.MobileDashboards> GetDashboards();
        List<Models.SystemConfigurationKeyModel> GetSystemConfigurationKeys();
        Client GetClientBalance(int clientId);
        List<ClientDocumentsModel> GetDocuments(int StaffId);
    }
}
