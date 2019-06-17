using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class ClientPaymentModel
    {
        public int ClientId { get; set; }
        public string UserId { get; set; }
        public DateTime DateReceived { get; set; }
        public string NameIfNotClient { get; set; }
        public int PaymentMethod { get; set; }
        public string ReferenceNumber { get; set; }        
        public string CardNumber { get; set; }
        public string ExpirationDate { get; set; }
        public decimal Amount { get; set; }
        public int LocationId { get; set; }
        public int PaymentSource { get; set; }
        public string Comment { get; set; }
        public int ServiceId { get; set; }
        public int TypeofPosting { get; set; }
        public string CopayAmounts { get; set; }
    }
}