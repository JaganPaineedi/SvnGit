using System.Collections.Generic;
using SC.Api.Models;
using System.Threading.Tasks;

namespace SC.Api
{
    public interface IAppointmentRepository
    {
        bool IsAppointmentExists(int AppointmentId);
        bool CancelAppointment(int AppointmentId, int CancelReason);
        bool DeleteAppointment(int AppointmentId, string DeletedBy);
        object GetCacelReasons();
        AppointmentModel GetAppointment(int AppointmentId);
        IEnumerable<AppointmentModel> GetAppointments(int StaffId);
        Task<_SCResult<Models.AppointmentModel>> Save(Models.AppointmentModel appointment, int loggedInUser);
        PrimaryCareAppointmentResponseModel CreateAppointment(PrimaryCareAppointmentRequestModel requestModel);
    }
}
