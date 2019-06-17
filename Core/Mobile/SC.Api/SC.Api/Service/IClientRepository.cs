using SC.Api.Models;
using SC.Data;

namespace SC.Api
{
    public interface IClientRepository
    {
        Client GetClientBalance(int clientId);
        int UpdatePayment(ClientPaymentModel cp);
    }
}
