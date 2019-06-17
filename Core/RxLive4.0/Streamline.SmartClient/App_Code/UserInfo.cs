using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Collections;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for UserInfo
/// </summary>
/// 
namespace Streamline.SmartClient
{
    public class UserInfo
    {

        //Streamline.UserBusinessServices.UserInfo objUser = null;
        public UserInfo()
        {

            Streamline.BaseLayer.StreamlinePrinciple.getUserData -= new Streamline.BaseLayer.getUserDetails(StreamlinePrinciple_getUserData);
            Streamline.BaseLayer.StreamlinePrinciple.getUserData += new Streamline.BaseLayer.getUserDetails(StreamlinePrinciple_getUserData);
            Streamline.BaseLayer.StreamlinePrinciple.getClientData -= new Streamline.BaseLayer.getClientDetails(StreamlinePrinciple_getClientData);
            Streamline.BaseLayer.StreamlinePrinciple.getClientData += new Streamline.BaseLayer.getClientDetails(StreamlinePrinciple_getClientData);

        }

        void StreamlinePrinciple_getUserData(object sender, Streamline.BaseLayer.UserData e)
        {
            DataSet ClientInformation;
            DataSet DataSetStaffLocations;
            Streamline.UserBusinessServices.SharedTables objectSharedTables = null;
            objectSharedTables = new Streamline.UserBusinessServices.SharedTables();
            //Added by Loveena in ref to Task#2954
            DataSet DataSetLocations;
            try
            {
                
                ClientInformation = new DataSet();
                DataSetStaffLocations = new DataSet();
                //Added in ref to Task#2954
                DataSetLocations = new DataSet();
                Streamline.BaseLayer.StreamlinePrinciple objPrinciple = (Streamline.BaseLayer.StreamlinePrinciple)sender;

                if (objPrinciple.RefreshUserData == true)
                {
                    DataRow drUser = (DataRow)e.GetAppData;
                    Streamline.UserBusinessServices.UserInfo objUser = new Streamline.UserBusinessServices.UserInfo();

                    objPrinciple.permissionList = objUser.GetPermission(Convert.ToInt32(drUser["StaffId"].ToString()));

                    objPrinciple.ClientsList = objUser.GetSharedClients(drUser["RowIdentifier"].ToString(), Convert.ToInt32(drUser["StaffId"].ToString()));
                    DataSetStaffLocations = objectSharedTables.getLocations(Convert.ToInt32(drUser["StaffId"].ToString()));
                    //Following added with reference to Task #2394
                    objPrinciple.StaffPrescribingLocationsList = DataSetStaffLocations.Tables[0];
                    objPrinciple.RefreshUserData = false;
                    //Following commented with reference to Task #2394
                    //Streamline.UserBusinessServices.SharedTables.DataSetLocations = objectSharedTables.getLocations(Convert.ToInt32(drUser["StaffId"].ToString()));
                    objPrinciple._SystemReports = objUser.GetSystemReports(); 
                    //Added by Loveena in ref to Task#2954
                    DataSetLocations = objectSharedTables.GetAssociatedLocations(Convert.ToInt32(drUser["StaffId"].ToString()));
                    objPrinciple.StaffLocationsList = DataSetLocations.Tables[0]; 
                }

                //ClientInformation=objUser.GetClientInfo(

                // objPrinciple.objectClient=new Streamline.BaseLayer.Client();
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "StreamlinePrinciple_getUserData";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                throw (ex);

            }
            finally
            {
                DataSetStaffLocations = null;
            }



        }

        void StreamlinePrinciple_getClientData(object sender, Streamline.BaseLayer.UserData e)
        {
            DataSet ClientInformation;
            try
            {
                ClientInformation = new DataSet();
                Streamline.BaseLayer.StreamlinePrinciple objPrinciple = (Streamline.BaseLayer.StreamlinePrinciple)sender;
                if (objPrinciple.RefreshClientData == true)
                {
                    int ClientId = (Int32)e.GetAppData;
                    Streamline.UserBusinessServices.UserInfo objUser = new Streamline.UserBusinessServices.UserInfo();

                    objPrinciple.ClientData = objUser.GetClientInfo(ClientId);
                    objPrinciple.RefreshClientData = false;
                }
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = "StreamlinePrinciple_getUserData";
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = "";
                throw (ex);

            }
        }


        public ArrayList GetPermission(int userID)
        {
            Streamline.UserBusinessServices.UserInfo objUser = new Streamline.UserBusinessServices.UserInfo();
            return objUser.GetPermission(userID);
        }

        public ArrayList GetPermission(string userCode)
        {
            Streamline.UserBusinessServices.UserInfo objUser = new Streamline.UserBusinessServices.UserInfo();
            return objUser.GetPermission(userCode);
        }

        public System.Data.DataSet ValidateLogin(string userCode, string cPassword)
        {

            try
            {
                Streamline.UserBusinessServices.UserInfo objUser = new Streamline.UserBusinessServices.UserInfo();
                return objUser.ValidateLogin(userCode, cPassword);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = null;
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
        }

        public System.Data.DataSet ValidateToken(string Token)
        {

            try
            {
                Streamline.UserBusinessServices.UserInfo objUser = new Streamline.UserBusinessServices.UserInfo();
                return objUser.ValidateToken(Token);
            }
            catch (Exception ex)
            {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = null;
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

            }
        }

        public System.Data.DataSet StaffDetail(int StaffId)
            {

            try
                {
                Streamline.UserBusinessServices.UserInfo objUser = new Streamline.UserBusinessServices.UserInfo();
                return objUser.StaffDetail(StaffId);
                }
            catch (Exception ex)
                {
                if (ex.Data["CustomExceptionInformation"] == null)
                    ex.Data["CustomExceptionInformation"] = null;
                else
                    ex.Data["CustomExceptionInformation"] = "";
                if (ex.Data["DatasetInfo"] == null)
                    ex.Data["DatasetInfo"] = null;
                throw (ex);

                }
            }

    }
}