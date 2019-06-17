using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace Streamline.BaseLayer
{
    /// <summary>
  
    /// </summary>
    public delegate void getUserDetails(object sender,
    UserData e);
    public delegate void getClientDetails(object sender,
    UserData e);

    /// <summary>
    /// Summary description for DataAvailableEventArgs.
    /// </summary>
    public class UserData : EventArgs
    {
        private object appData;
        public UserData(object refAppData)
        {
            appData = refAppData;
        }
        public object GetAppData { get { return appData; } }
    }

}
