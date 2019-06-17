using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web;

namespace Streamline.BaseLayer
{
    /// <summary>
    /// Summary description for StreamlinePrinciple
    /// </summary>                     
    public class StreamlinePrinciple : System.Security.Principal.IPrincipal
    {

        /* Interface methods and properties*/

        protected System.Security.Principal.IIdentity identity;
        protected Streamline.BaseLayer.Client objectClient;
        public static event getUserDetails getUserData;
        public static event getClientDetails getClientData;
        
        /// <summary>
        /// Returns the current identity of the principal
        /// and also holds the identity of the instance of IPrincipal?
        /// </summary>
        public System.Security.Principal.IIdentity Identity
        {
            get { return identity; }
            set { identity = value; }
        }
        /// <summary>
        /// Checks whether the current principal is in role
        /// </summary>
        /// <param name="role">role to check the membership for </param>
        /// <returns>true if its in role else false</returns>
        public bool IsInRole(string role)
        {
            return roleList.Contains(role);
        }

        /***********************************/
        public ArrayList roleList;
        public ArrayList permissionList;
        public Streamline.BaseLayer.DataSets.UserInfo userData;
        public DataTable ClientsList;
        //A new DataTable containing Prescribing Locations Data 
        public DataTable StaffPrescribingLocationsList;
        public DataTable _SystemReports; //#90
        //Added by Loveena in ref to Task#2954
        public DataTable StaffLocationsList;

        public DataSet ClientData;

        public Streamline.BaseLayer.Client Client
        {
            get { return objectClient; }
            set { objectClient = value; }
        }

        public ArrayList Roles
        {
            get { return roleList; }
        }

        private bool _refreshData;
        public bool RefreshUserData = false;
        public bool RefreshClientData = false;

        public bool RefreshData
        {
            get { return _refreshData; }
            set
            {
                _refreshData = value;
                RefreshUserData = true;
                RefreshClientData = true;
            }
        }


        public Streamline.BaseLayer.DataSets.UserInfo UserData
        {
            get { return userData; }
        }

        public ArrayList Permissions
        {
            get { return permissionList; }
        }

        public DataTable Clients
        {
            get { return ClientsList; }
        }

        // A new property added with reference to Task #2394
        public DataTable StaffPrescribingLocations
        {
            get { return StaffPrescribingLocationsList; }
        }

        // A new property added with reference to Task #90
        public DataTable SystemReports
        {
            get { return _SystemReports; }
        }

        // A new property added with reference to Task #2594
        public DataTable StaffLocations
        {
            get { return StaffLocationsList; }
        }

        public bool HasPermission(Streamline.BaseLayer.Permissions permission)
        {
            return permissionList.Contains((int)permission);
        }

        public StreamlinePrinciple()
        {
        }
        /// <summary>
        /// Modified by Chandan added new parameter DataRow drSystemConfig
        /// task#2378 CopyrightInfo</summary>
        /// <param name="drUser"></param>
        /// <param name="drSystemConfig"></param>
        public StreamlinePrinciple(DataRow drUser)
        {

            try
            {
                ClientData = new DataSet();
                //string copyrightInfo = drSystemConfig["CopyrightInfo"].ToString(); //Added by Chandan task#2378 CopyrightInfo                
                string copyrightInfo = "Copyright © 2001-" + DateTime.Now.Year.ToString() + " Streamline Healthcare Solutions, LLC. All Rights Reserved.";
                int userId = Convert.ToInt32(drUser["StaffId"]);
                identity = new StreamlineIdentity(drUser);
                RefreshData = true;
                UserData objUserData = new UserData(drUser);
                
                getUserData(this, objUserData);
                int ClientId = Convert.ToInt32(System.Web.HttpContext.Current.Request.QueryString["ClientId"].ToString());
                //Function Made by Sonia as ClientInformation has to be changed on changing the value of dropdown
                SetClientInformation(ClientId, true);
                //roleList = oUser.GetRoles(userId);
                // permissionList = oUser.GetPermission(userId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }


        }


        /// <summary>
        /// Modified by Chandan added new parameter DataRow drSystemConfig
        /// task#2378 CopyrightInfo</summary>
        /// <param name="drUser"></param>
        /// <param name="drSystemConfig"></param>
        public StreamlinePrinciple(DataRow drUser, int ClientId)
        {

            try
            {
                ClientData = new DataSet();
                //string copyrightInfo = drSystemConfig["CopyrightInfo"].ToString(); //Added by Chandan task#2378 CopyrightInfo                
                string copyrightInfo = "Copyright © 2001-" + DateTime.Now.Year.ToString() + " Streamline Healthcare Solutions, LLC. All Rights Reserved.";
                int userId = Convert.ToInt32(drUser["StaffId"]);
                identity = new StreamlineIdentity(drUser);
                RefreshData = true;
                UserData objUserData = new UserData(drUser);

                getUserData(this, objUserData);
                //int ClientId = Convert.ToInt32(System.Web.HttpContext.Current.Request.QueryString["ClientId"].ToString());
                //Function Made by Sonia as ClientInformation has to be changed on changing the value of dropdown
                SetClientInformation(ClientId, true);
                //roleList = oUser.GetRoles(userId);
                // permissionList = oUser.GetPermission(userId);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }

        }

        public void SetClientInformation(Int32 ClientId, bool RequirePharamcies)
        {
            UserData objClientData = new UserData(ClientId);
            getClientData(this, objClientData);
            objectClient = new Client(ClientData);
        }
                
    }
}