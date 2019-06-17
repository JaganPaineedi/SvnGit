using SC.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;
using System.Web;

namespace SC.Api.Filters
{
    /// <summary>
    /// Message Handler to handle each Http requests to API.
    /// </summary>
    public class MessageHandler : DelegatingHandler
    {
        SCMobile _ctx;
        public MessageHandler()
        {
            _ctx = new SCMobile();
        }
        protected async override Task<HttpResponseMessage> SendAsync(
         HttpRequestMessage request, CancellationToken cancellationToken)
        {
            int ? ClientId = null;
            var _repo = new CommonRepository(new SCMobile());
            //return await Task.FromResult(request.CreateResponse(HttpStatusCode.Unauthorized));

            var identity = (ClaimsIdentity)request.GetOwinContext().Authentication.User.Identity;
            CurrentLoggedInStaff cs = new CurrentLoggedInStaff();

            if (!string.IsNullOrEmpty(identity.FindFirst(ClaimTypes.Name).Value) && request.RequestUri.AbsolutePath.IndexOf("/api/") > -1)
            {
                var Id = Convert.ToInt32(identity.FindFirst(ClaimTypes.NameIdentifier).Value);
                var Name = identity.FindFirst(ClaimTypes.Name).Value;
                var requestUrl = request.RequestUri.AbsolutePath.Substring(request.RequestUri.AbsolutePath.IndexOf("/api/"), request.RequestUri.AbsolutePath.Length - request.RequestUri.AbsolutePath.IndexOf("/api/"));
                cs.StaffId = Id;
                cs.UserCode = Name;
                HttpContext.Current.Session["CurrentStaff"] = cs;
                if (request.RequestUri.AbsolutePath.IndexOf("/api/Patient") > -1 && request.RequestUri.Query.IndexOf("id=") > -1)
                {
                    var idValue = request.RequestUri.Query.Remove(0, 1).Split('&').Where(a => a.StartsWith("id=")).FirstOrDefault();
                    if (!string.IsNullOrEmpty(idValue) && idValue.Split('=').Length>0)
                    {
                        var arr = idValue.Split('=');
                        ClientId = Convert.ToInt32(arr[1]);
                    }
                }

                var screenId = _repo.GetScreenId(requestUrl);
                try
                {
                    //Log request information
                    StaffClientAccess sca = new StaffClientAccess();
                    sca.ScreenId = screenId;
                    sca.StaffId = Id;
                    sca.ClientId = ClientId;
                    sca.ActivityType = "V";
                    sca.HashValues = string.Empty.GetHashCode().ToString();// Need to change.
                    sca.CreatedBy = sca.ModifiedBy = Name;
                    sca.CreatedDate = sca.ModifiedDate = DateTime.Now;

                    _ctx.StaffClientAccess.Add(sca);
                    await _ctx.SaveChangesAsync();
                }
                catch (DbEntityValidationException e)
                {
                    string ErrorMessage = string.Empty;

                    foreach (var eve in e.EntityValidationErrors)
                    {
                        ErrorMessage += String.Format("Entity of type \"{0}\" in state \"{1}\" has the following validation errors:",
                            eve.Entry.Entity.GetType().Name, eve.Entry.State);
                        foreach (var ve in eve.ValidationErrors)
                        {
                            ErrorMessage += string.Format("- Property: \"{0}\", Error: \"{1}\"",
                                ve.PropertyName, ve.ErrorMessage);
                        }
                    }
                    Exception ex = new Exception(ErrorMessage);
                    throw ex;
                }
                catch (Exception ex) { Exception cex = new Exception("Exception occured in MessageHandler.SendAsync method." + ex.Message+ ". And the inner exception is "+ ex.InnerException.InnerException.Message); throw cex; }
            }
            return await base.SendAsync(request, cancellationToken);
        }
    }
}