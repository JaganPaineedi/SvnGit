using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SC.Api.Models
{
    [Serializable]
    public class MobileRegistration
    {
        public int StaffId { get; set; }
        public string RegisteredForMobileNotifications { get; set; }
        public string RegisteredForSMSNotifications { get; set; }
        public string RegisteredForEmailNotifications { get; set; }
        public string MobileDeviceIdentifier { get; set; }
        public string MobileDeviceName { get; set; }
        public string MobileSubscriptionIdentifier { get; set; }
        public string SubscribedForPushNotifications { get; set; }
    }
}