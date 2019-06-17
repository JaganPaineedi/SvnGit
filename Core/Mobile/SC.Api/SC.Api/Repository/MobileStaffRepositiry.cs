using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.Entity;
using SC.Data;
using System.Reflection;
using KellermanSoftware.CompareNetObjects;
using System.Web;
using SC.Api.Models;

namespace SC.Api
{
    /// <summary>
    /// MobileStaffRepositiry used for all mypreference screen
    /// </summary>
    public class MobileStaffRepositiry : IMobileStaffRepository
    {
        private SCMobile _scEntity;
        /// <summary>
        /// Constructor of MobileStaffRepositiry
        /// </summary>
        /// <param name="ctx"></param>
        public MobileStaffRepositiry(SCMobile ctx)
        {
            _scEntity = ctx;
        }
       
        /// <summary>
        /// Returns the data from StaffPreferences table based on StaffId
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public async Task<Models.StaffPreferenceModel> FindMobileUser(int staffId)
        {
            try
            {
                var stf = await (from staffpref in _scEntity.StaffPreferences
                                 join staff in _scEntity.Staffs on staffpref.StaffId equals staff.StaffId
                                 where staffpref.StaffId == staffId
                                 select new Models.StaffPreferenceModel()
                                 {
                                     StaffPreferenceId = staffpref.StaffPreferenceId,
                                     CreatedBy = staffpref.CreatedBy,
                                     CreatedDate = staffpref.CreatedDate,
                                     ModifiedBy = staffpref.ModifiedBy,
                                     ModifiedDate = staffpref.ModifiedDate,
                                     RecordDeleted = staffpref.RecordDeleted,
                                     DeletedBy = staffpref.DeletedBy,
                                     DeletedDate = staffpref.DeletedDate,
                                     StaffId = staffpref.StaffId,
                                     DefaultMobileHomePageId = staffpref.DefaultMobileHomePageId,
                                     DefaultMobileProgramId = staffpref.DefaultMobileProgramId,
                                     MobileCalendarEventsDaysLookUpInPast = staffpref.MobileCalendarEventsDaysLookUpInPast,
                                     MobileCalendarEventsDaysLookUpInFuture = staffpref.MobileCalendarEventsDaysLookUpInFuture,
                                     StaffName = staff.LastName + ", " + staff.FirstName,
                                     ProgramName = _scEntity.Programs.Where(p => p.ProgramId == staffpref.DefaultMobileProgramId).Select(p => p.ProgramCode).FirstOrDefault()
                                 }).ToListAsync();

                return stf.FirstOrDefault();
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in MobileStaffRepositiry.FindMobileUser method." + ex.Message);
                throw excep;
            }
        }
        
        /// <summary>
        /// Function for differential merge
        /// </summary>
        /// <param name="briefcaseTypeId"></param>
        /// <param name="staffId"></param>
        /// <param name="briefcaseType"></param>
        /// <param name="newObject"></param>
        /// <param name="differences"></param>
        /// <returns></returns>
        public bool IsDataModified(int briefcaseTypeId, int staffId, int briefcaseType, Data.StaffPreferences newObject,out List<Difference> differences)
        {
            try
            {
                CompareLogic cl = new CompareLogic();
                StaffPreferences sp = CommonFunctions<StaffPreferences>.GetBriefcase(briefcaseTypeId, staffId, briefcaseType);
                ComparisonResult cr = new ComparisonResult(new ComparisonConfig() { MaxDifferences = 100 });

                cr = cl.Compare(newObject, sp);
                if (!cr.AreEqual)
                    differences = cr.Differences;
                else
                    differences = null;

                return !cr.AreEqual;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in MobileStaffRepositiry.IsDataModified method." + ex.Message);
                throw excep;
            }
        }

        /// <summary>
        /// Is Staff NonStaff User ?
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public bool IsNonStaffUser(int staffId)
        {
            return _scEntity.Staffs
                .Any(a => a.Active == "Y" && a.StaffId == staffId && a.NonStaffUser == "Y");
        }

        /// <summary>
        /// Save MyPreference Screen Data.
        /// </summary>
        /// <param name="stf"></param>
        /// <param name="loggedInUser"></param>
        /// <returns></returns>
        public async Task<_SCResult<Models.StaffPreferenceModel>> Save(StaffPreferences stf, int loggedInUser)
        {
            try
            {
                var _Ce = new _SCResult<Models.StaffPreferenceModel>();

                IBriefcaseRepository _repo = new BriefcaseRepositiry(new SCMobile());
                List<Difference> differences = new List<Difference>();
                bool modified = IsDataModified(stf.StaffPreferenceId, loggedInUser, CommonDBFunctions.GetGlobalCodeId("BRIEFCASETYPE", "MYPREFERENCE"), stf, out differences);

                if (modified)
                {
                    var original = _scEntity.StaffPreferences
                        .Where(s => s.StaffPreferenceId == stf.StaffPreferenceId).FirstOrDefault();


                    foreach (var difference in differences)
                    {
                        string[] changedPprts = difference.PropertyName.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries);

                        //Handled only objects which doesn't have sibling object
                        if (string.IsNullOrEmpty(difference.ParentPropertyName))
                        {
                            foreach (PropertyInfo propertyInfo in original.GetType().GetProperties())
                            {
                                if (changedPprts.Contains(propertyInfo.Name))
                                    propertyInfo.SetValue(original, propertyInfo.GetValue(stf, null), null);
                            }
                        }

                    }

                    _scEntity.SaveChanges();
                }
                _Ce.SavedResult = await _repo.GetMyPreference(stf.StaffId);

                _Ce.LocalstoreName = "mypreference";
                _Ce.UnsavedId = _Ce.SavedId = _Ce.SavedResult.StaffPreferenceId;
                _Ce.DeleteUnsavedChanges = true;
                _Ce.ShowDetails = false;
                _Ce.Details = null;
                _Ce.SavedResult = await FindMobileUser(stf.StaffId);

                if (stf != null)
                    CommonFunctions<Models.StaffPreferenceModel>.CreateUpdateBriefcase(stf.StaffPreferenceId, _Ce.SavedResult, loggedInUser, CommonDBFunctions.GetGlobalCodeId("BRIEFCASETYPE", "MYPREFERENCE"));

                return _Ce;
            }
            catch (Exception ex)
            {
                Exception excep = new Exception("Exception occured in MobileStaffRepositiry.Save method." + ex.Message);
                throw excep;
            }
        }
        /// <summary>
        /// To Check wheter the User has Mobile Access or Not.
        /// </summary>
        /// <param name="staffId"></param>
        /// <returns></returns>
        public bool IsMobileUser(int staffId)
        {
            return _scEntity.Staffs
                .Any(a => a.Active == "Y" && a.StaffId == staffId && a.AllowMobileAccess == "Y" && a.RecordDeleted != "Y");
        }

        /// <summary>
        /// Update RegisterForMobileNotifications flag in StaffPreferences table
        /// <returns></returns>
        public int RegisterForMobileNotifications(MobileRegistration mobileRegistration)
        {
            int affectedRows = 0;
            using (var dbTransaction = _scEntity.Database.BeginTransaction())
            {
                try
                {
                    var createdBy = HttpContext.Current.Session["CurrentStaff"] == null ? "MobileApi" : ((CurrentLoggedInStaff)HttpContext.Current.Session["CurrentStaff"]).UserCode;

                    var staff = _scEntity.StaffPreferences
                        .Where(s => s.StaffId == mobileRegistration.StaffId).FirstOrDefault();

                    staff.RegisteredForMobileNotifications = mobileRegistration.RegisteredForMobileNotifications;
                    staff.RegisteredForEmailNotifications = mobileRegistration.RegisteredForEmailNotifications;
                    staff.RegisteredForSMSNotifications = mobileRegistration.RegisteredForSMSNotifications;
                    staff.ModifiedBy = "MobileApi";
                    staff.ModifiedDate = DateTime.Now;
                    staff.RegisteredForMobileNotificationsTimeStamp = DateTime.Now;

                    if (_scEntity.MobileDevices.Any(d => d.MobileDeviceIdentifier == mobileRegistration.MobileDeviceIdentifier && d.StaffId == mobileRegistration.StaffId))
                    {
                        var mdevices = _scEntity.MobileDevices
                            .Where(d => d.MobileDeviceIdentifier == mobileRegistration.MobileDeviceIdentifier && d.StaffId == mobileRegistration.StaffId)
                            .FirstOrDefault();

                        mdevices.MobileDeviceName = mobileRegistration.MobileDeviceName;
                        mdevices.MobileSubscriptionIdentifier = mobileRegistration.MobileSubscriptionIdentifier;
                        mdevices.SubscribedForPushNotifications = mobileRegistration.SubscribedForPushNotifications;
                        mdevices.ModifiedBy = createdBy;
                        mdevices.ModifiedDate = DateTime.Now;
                    }
                    else
                    {
                        MobileDevice mobileDevice = new MobileDevice();

                        mobileDevice.MobileDeviceName = mobileRegistration.MobileDeviceName;
                        mobileDevice.MobileDeviceIdentifier = mobileRegistration.MobileDeviceIdentifier;
                        mobileDevice.MobileSubscriptionIdentifier = mobileRegistration.MobileSubscriptionIdentifier;
                        mobileDevice.SubscribedForPushNotifications = mobileRegistration.SubscribedForPushNotifications;
                        mobileDevice.StaffId = mobileRegistration.StaffId;
                        mobileDevice.CreatedBy = mobileDevice.ModifiedBy = createdBy;
                        mobileDevice.ModifiedDate = mobileDevice.CreatedDate = DateTime.Now;

                        _scEntity.MobileDevices.Add(mobileDevice);
                    }

                    affectedRows = _scEntity.SaveChanges();
                    if (affectedRows > 0)
                    {
                        dbTransaction.Commit();
                    }
                }

                catch (Exception ex)
                {
                    dbTransaction.Rollback();
                    throw ex;
                }
            }
            return affectedRows;
        }

    }
}