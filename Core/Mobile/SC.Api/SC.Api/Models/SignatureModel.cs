using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    public class SignatureModel
    {
        public string SignatureString { get; set; }
        public bool IsClient { get; set; }
        public int RelationShipToClient { get; set; }
        public string  RelationShipText { get; set; }
        public string SignerName { get; set; }
        public DateTime SignatureDate { get; set; }
    }
}