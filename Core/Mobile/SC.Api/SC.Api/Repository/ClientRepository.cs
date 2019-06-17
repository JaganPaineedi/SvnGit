using System.Linq;
using SC.Api.Models;
using SC.Data;

namespace SC.Api
{
    public class ClientRepository : IClientRepository
    {
        private SCMobile _ctx;

        public ClientRepository(SCMobile ctx)
        {
            _ctx = ctx;
        }
        public Client GetClientBalance(int clientId)
        {
            return _ctx.Clients
                  .Where(c => c.ClientId == clientId && c.RecordDeleted != "Y").FirstOrDefault();
        }

        public int UpdatePayment(ClientPaymentModel cp)
        {
            return _ctx.ssp_PMUpdateClientBalance(cp.ClientId, cp.UserId, cp.DateReceived, cp.NameIfNotClient, cp.PaymentMethod,
                cp.ReferenceNumber, cp.CardNumber, cp.ExpirationDate, cp.Amount, cp.LocationId, cp.PaymentMethod,
                cp.Comment, cp.ServiceId, cp.TypeofPosting, cp.CopayAmounts);

        }
    }
}