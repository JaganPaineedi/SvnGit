using SC.Api.Models;
using SC.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SC.Api
{
    public interface IMobileStaffRepository
    {
        Task<SC.Api.Models.StaffPreferenceModel> FindMobileUser(int staffId);

        bool IsDataModified(int briefcaseTypeId, int staffId, int briefcaseType, StaffPreferences newObj,out List<KellermanSoftware.CompareNetObjects.Difference> differences);

        Task<_SCResult<Models.StaffPreferenceModel>> Save(StaffPreferences stf, int loggedInUser);

        bool IsNonStaffUser(int staffId);

        bool IsMobileUser(int StaffId);

        int RegisterForMobileNotifications(MobileRegistration mobileRegistration);
    }
}
