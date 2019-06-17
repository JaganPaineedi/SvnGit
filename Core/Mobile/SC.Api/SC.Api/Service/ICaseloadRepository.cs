using SC.Api.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SC.Api.Service
{
    public interface ICaseloadRepository
    {
        string GetCurrentMedications(int ClientId);
        IEnumerable<AppointmentModel> GetClientsAppointments(int ClientId);
        double GetPatientBalance(int ClientId);
    }
}
