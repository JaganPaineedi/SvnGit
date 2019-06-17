using Streamline.DataService;
using Streamline.SmartClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for TwoFactorAuthentication
/// </summary>
public class TwoFactorAuthentication
{
    public TwoFactorAuthentication()
    {
    }

    /// <summary>
    /// Authenticates the credentials of the user
    /// </summary>
    /// <param name="twofactorObject"></param>
    /// <returns></returns>
    public TwoFactorAuthenticationResponse Authenticate(TwoFactorAuthenticationRequest TwoFactorAuthenticationRequest,string EventType)
    {
        TwoFactorAuthenticationResponse TwoFactorAuthenticationResponseObject = new TwoFactorAuthenticationResponse();
        string response = string.Empty;
        try
        {
            if (TwoFactorAuthenticationRequest != null)
            {

                string parameter = string.Empty;
                string twoFactorAuthenticationServiceURL = string.Empty;
                Streamline.DataService.SharedTables objSharedTables = new Streamline.DataService.SharedTables();
                if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys != null)
                {
                    if (Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables.Count > 0)
                    {
                        twoFactorAuthenticationServiceURL = objSharedTables.GetSystemConfigurationKeys("TwoFactorAuthenticationServiceURL", Streamline.UserBusinessServices.SharedTables.DataSetSystemConfigurationKeys.Tables[0]);
                    }
                }

                WebClient client = new WebClient();
                client.Credentials = System.Net.CredentialCache.DefaultCredentials;

                client.Headers["Content-type"] = "application/json";

                MemoryStream stream = new MemoryStream();
                DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(TwoFactorAuthenticationRequest));
                serializer.WriteObject(stream, TwoFactorAuthenticationRequest);

                byte[] data = client.UploadData(twoFactorAuthenticationServiceURL + "api/authenticate/" + TwoFactorAuthenticationRequest, "POST", stream.ToArray());

                stream = new MemoryStream(data);
                serializer = new DataContractJsonSerializer(typeof(TwoFactorAuthenticationResponse));
                TwoFactorAuthenticationResponseObject = (TwoFactorAuthenticationResponse)serializer.ReadObject(stream);

                SetUserInformation(TwoFactorAuthenticationResponseObject.Passed, EventType);

            }
        }
        catch
        {

        }
        finally
        {
            
        }
        return TwoFactorAuthenticationResponseObject;
    }

    /// <summary>
    /// Set User information
    /// </summary>
    /// <param name="TwofactorPassed"></param>
    private void SetUserInformation(bool TwofactorPassed, string EventType)
    {
        string CreatedBy = ((Streamline.BaseLayer.StreamlineIdentity)HttpContext.Current.User.Identity).UserCode;
        int LoggedInStaffId = ((Streamline.BaseLayer.StreamlineIdentity)HttpContext.Current.User.Identity).UserId;
        DateTime LoggedInTimestamp = DateTime.Now;
        DateTime CreatedDate = DateTime.Now;
        DateTime ModifiedDate = DateTime.Now;
        string ModifiedBy = ((Streamline.BaseLayer.StreamlineIdentity)HttpContext.Current.User.Identity).UserCode;
        string RecordDeleted = null;
        DateTime RequestTime = DateTime.Now;
        string Username = ((Streamline.BaseLayer.StreamlineIdentity)HttpContext.Current.User.Identity).UserCode;
        string Passed = TwofactorPassed == true ? "Y" : "N";
        InsertUserLoginHistory(CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, LoggedInStaffId, RequestTime, Username, Passed, EventType);
    }

    /// <summary>
    /// Insert user log in information into database
    /// </summary>
    /// <param name="LoggedInStaffId"></param>
    /// <param name="LoggedInTimestamp"></param>
    /// <param name="Username"></param>
    /// <param name="Passed"></param>
    private void InsertUserLoginHistory(string CreatedBy, DateTime CreatedDate, string ModifiedBy, DateTime ModifiedDate, string RecordDeleted, int LoggedInStaffId, DateTime RequestTime, string Username, string Passed, string EventType)
    {
        string connectionString = ClientMedication.ConnectionString;
        string query = "INSERT INTO [dbo].[TwoFactorAuthenticationHistory]([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[LoggedInStaffId],[RequestTime],[Username],[Passed],[EventType]) VALUES(@CreatedBy,@CreatedDate,@ModifiedBy,@ModifiedDate,@RecordDeleted,@LoggedInStaffId,@RequestTime,@Username,@Passed,@EventType)";
        List<SqlParameter> parameters = new List<SqlParameter>();
        try
        {
            parameters.Add(new SqlParameter("@CreatedBy", CreatedBy));
            parameters.Add(new SqlParameter("@CreatedDate", CreatedDate));
            parameters.Add(new SqlParameter("@ModifiedBy", ModifiedBy));
            parameters.Add(new SqlParameter("@ModifiedDate", ModifiedDate));
            parameters.Add(new SqlParameter("@RecordDeleted", RecordDeleted));
            parameters.Add(new SqlParameter("@LoggedInStaffId", LoggedInStaffId));
            parameters.Add(new SqlParameter("@RequestTime", RequestTime));
            parameters.Add(new SqlParameter("@Username", Username));
            parameters.Add(new SqlParameter("@Passed", Passed));
            parameters.Add(new SqlParameter("@EventType", EventType));
            int rowsAffected = SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, query, parameters.ToArray());
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}