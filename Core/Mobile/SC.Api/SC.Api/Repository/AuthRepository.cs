using SC.Cryptography;
using SC.Data;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Linq;
using System.Threading.Tasks;
using System.DirectoryServices.AccountManagement;
using System;

namespace SC.Api
{
    /// <summary>
    /// AuthRepository used for all the Authentication/Authorization related functionalities
    /// </summary>
    public class AuthRepository : IAuthRepository
    {
        private SCMobile _scEntity;
        
        /// <summary>
        /// Constructor of AuthRepository
        /// </summary>
        /// <param name="ctx"></param>
        public AuthRepository(SCMobile ctx)
        {
            _scEntity = ctx;
        }
       
        /// <summary>
        /// Used to Authenticate With AD
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        private bool AuthenticateWithActiveDirectory(string userName, string password)
        {
            try
            {
                bool authenticated = false;

                string domain = _scEntity.Staffs.Where(s => s.UserCode == userName).DefaultIfEmpty(null).Select(s => s.ActiveDirectoryStaff.ActiveDirectoryDomains.DomainName ?? "").FirstOrDefault().ToString();

                if (SC.Data.CommonDBFunctions.GetSystemConfigurationKeyValue("ValidateFromWebService").ToUpper() == "Y")
                {


                    SC.Data.SHSADAuthentication.ADAuthenticationService ad = new Data.SHSADAuthentication.ADAuthenticationService();
                    ad.Credentials = System.Net.CredentialCache.DefaultCredentials;
                    ad.Url = CommonDBFunctions.GetSystemConfigurationKeyValue("AuthWebServiceURL");

                    SC.Data.SHSADAuthentication.Authentication a = new Data.SHSADAuthentication.Authentication();
                    a.TokenKey = CommonDBFunctions.GetSystemConfigurationKeyValue("WebServiceKeyToken");
                    ad.AuthenticationValue = a;

                    authenticated = ad.ValidateUser(userName.Trim(), password.Trim(), domain.Trim());
                }
                else
                {
                    using (PrincipalContext pc = new PrincipalContext(ContextType.Domain, domain))
                    {
                        authenticated = pc.ValidateCredentials(userName.Trim(), password.Trim());
                    }
                }
                return authenticated;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AuthRepository.AuthenticateWithActiveDirectory method." + ex.Message);
                throw excep;
            }
        }
      
        /// <summary>
        /// Find SmartCare user using username/password
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public async Task<Staff> FindSCUser(string userName, string password)
        {
            try
            {
                //Determine the staff's authentication type
                string activeDirectoryEnabled = "N"; // Default is No
                string staffAuthType = "S"; //Default is Standard
                IList<Staff> staff = null;


                activeDirectoryEnabled = _scEntity.SystemConfigurations.Select(b => b.EnableADAuthentication).FirstOrDefault() ?? "N";
                staffAuthType = _scEntity.Staffs.Where(b => b.UserCode == userName).DefaultIfEmpty(null).Select(b => b.AuthenticationType ?? "S").FirstOrDefault().ToString();

                //If active directory is enabled and the staff's auth type is 'A', validate against active directory
                if (activeDirectoryEnabled.ToUpper() == "Y" && staffAuthType.ToUpper() == "A")
                {
                    bool isAuthenticated = false;
                    isAuthenticated = AuthenticateWithActiveDirectory(userName, password);
                    if (isAuthenticated)
                    {
                        staff = await (from s in _scEntity.Staffs
                                       where s.UserCode == userName && s.AllowMobileAccess.ToUpper() == "Y"
                                       select s).ToListAsync();
                    }
                }
                else
                {
                    var encryptedpassword = EncryptDecrypt.Encrypt(password);

                    staff = await (from s in _scEntity.Staffs
                                   where s.UserCode == userName && s.UserPassword == encryptedpassword && s.AllowMobileAccess.ToUpper() == "Y"
                                   select s).ToListAsync();
                }

                if (staff != null)
                {
                    return staff.FirstOrDefault();
                }
                else { return null; }

            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AuthRepository.FindSCUser method." + ex.Message);
                throw excep;
            }
        }
      
        /// <summary>
        /// Find SmartCare user using username/password/smartkey
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <param name="smartKey"></param>
        /// <returns></returns>
        public async Task<Staff> FindSCUser(string userName, string password,string smartKey)
        {
            try
            {
                //Determine the staff's authentication type
                string activeDirectoryEnabled = "N"; // Default is No
                string staffAuthType = "S"; //Default is Standard
                IList<Staff> staff = null;

                var encryptedsmartKey = EncryptDecrypt.Encrypt(smartKey);
                activeDirectoryEnabled = _scEntity.SystemConfigurations.Select(b => b.EnableADAuthentication).FirstOrDefault() ?? "N";
                staffAuthType = _scEntity.Staffs.Where(b => b.UserCode == userName).DefaultIfEmpty(null).Select(b => b.AuthenticationType ?? "S").FirstOrDefault().ToString();

                //If active directory is enabled and the staff's auth type is 'A', validate against active directory
                if (activeDirectoryEnabled.ToUpper() == "Y" && staffAuthType.ToUpper() == "A")
                {
                    bool isAuthenticated = false;
                    isAuthenticated = AuthenticateWithActiveDirectory(userName, password);
                    if (isAuthenticated)
                    {

                        staff = await (from s in _scEntity.Staffs
                                       where s.UserCode.ToLower() == userName && s.AllowMobileAccess.ToUpper() == "Y" && s.MobileSmartKey == encryptedsmartKey
                                       select s).ToListAsync();
                    }
                }
                else
                {
                    staff = await (from s in _scEntity.Staffs
                                   where s.UserCode == userName && s.AllowMobileAccess.ToUpper() == "Y" && s.MobileSmartKey == encryptedsmartKey
                                   select s).ToListAsync();
                }

                if (staff != null)
                {
                    return staff.FirstOrDefault();
                }
                else { return null; }
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AuthRepository.FindSCUser method using SmartKey." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Validate SmartKey for the selected user
        /// </summary>
        /// <param name="usermodel"></param>
        /// <returns></returns>
        public async Task<Staff> ValidateSmartKey(UserModel usermodel)
        {
            try
            {
                Staff staff = await FindSCUser(usermodel.UserName, usermodel.Password, usermodel.SmartKey);
                return staff;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AuthRepository.ValidateSmartKey." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Find Requesting Client.
        /// </summary>
        /// <param name="clientId"></param>
        /// <returns></returns>
        internal MobileOrigins FindClient(string clientId)
        {
            try
            {
                var client = (from m in _scEntity.MobileOrigins
                              where m.Name == clientId
                              select m).FirstOrDefault();
                return client;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AuthRepository.FindClient." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Add refresh token for the user to MobileRefreshTokens
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        public async Task<int> AddRefreshToken(MobileRefreshTokens token)
        {
            try
            {
                var existingToken = _scEntity.MobileRefreshTokens.Where(r => r.UserCode == token.UserCode && r.ClientId == token.ClientId).SingleOrDefault();

                if (existingToken != null)
                {
                    var result = await RemoveRefreshToken(existingToken.MobileRefreshTokenId.ToString());
                }

                _scEntity.MobileRefreshTokens.Add(token);

                if (await _scEntity.SaveChangesAsync() > 0)
                    return token.MobileRefreshTokenId;
                else
                    return -1;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AuthRepository.AddRefreshToken." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Returns all RefreshTokens
        /// </summary>
        /// <returns></returns>
        public List<MobileRefreshTokens> GetAllRefreshTokens()
        {
            try
            {
                return _scEntity.MobileRefreshTokens.ToList();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AuthRepository.GetAllRefreshTokens method." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Used to Remove RefreshToken based on Token Id
        /// </summary>
        /// <param name="refreshTokenId"></param>
        /// <returns></returns>
        public async Task<bool> RemoveRefreshToken(string refreshTokenId)
        {
            try
            {
                int refTokenId = 0;

                int.TryParse(refreshTokenId, out refTokenId);

                var refreshToken = await _scEntity.MobileRefreshTokens.FindAsync(refTokenId);

                if (refreshToken != null)
                {
                    _scEntity.MobileRefreshTokens.Remove(refreshToken);
                    return await _scEntity.SaveChangesAsync() > 0;
                }

                return false;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AuthRepository.RemoveRefreshToken method." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Find RefreshToken based on refreshTokenId
        /// </summary>
        /// <param name="refreshTokenId"></param>
        /// <returns></returns>
        public async Task<MobileRefreshTokens> FindRefreshToken(string refreshTokenId)
        {
            try
            {
                int refTokenId = 0;

                int.TryParse(refreshTokenId, out refTokenId);

                var refreshToken = await _scEntity.MobileRefreshTokens.FindAsync(refTokenId);

                return refreshToken;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in AuthRepository.FindRefreshToken method." + ex.Message);
                throw excep;
            }
        }
       
        /// <summary>
        /// Method used to dispose unusable objects
        /// </summary>
        public void Dispose()
        {
            _scEntity.Dispose();
        }
    }
}