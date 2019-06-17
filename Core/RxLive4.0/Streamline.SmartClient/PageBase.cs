namespace Streamline.SmartClient.UI
{
    using System;
    using System.Web;
    using System.Web.UI;
    using System.Threading;
    using System.Globalization;
    using System.Reflection;
    using System.Resources;
    using System.Runtime.InteropServices;
    using System.Security.Principal;
    using System.Web.Caching;

    using Zetafax.SystemFramework;
    using Zetafax.Common;

    /// <summary>
    /// Summary description for PageBase.
    /// </summary>
    public class PageBase : System.Web.UI.Page
    {
        private const String UNHANDLED_EXCEPTION = "Unhandled Exception:";

        public PageBase()
        {
        }

        /// <summary>
        ///     Handles errors that may be encountered when displaying this page.
        ///     <param name="e">An EventArgs that contains the event data.</param>
        /// </summary>
        protected override void OnError(EventArgs e) 
        {
            ApplicationLog.WriteError(ApplicationLog.FormatException(Server.GetLastError(), UNHANDLED_EXCEPTION));
            Session["error"] = Server.GetLastError().Message;
            ErrorPage = fPopup ? "PopupError.aspx" : "Error.aspx";
            base.OnError(e);
        }

        public void Page_Load(object sender, System.EventArgs e)
        {
            Context.User = Streamline.BaseLayer.StreamlinePrinciple();
            // log user
            ApplicationLog.WriteTrace(string.Format("Page request (for, from, as): {0}, {1}, {2}", 
                                      GetType().ToString(), Context.User.Identity.Name,  WindowsIdentity.GetCurrent().Name));
            rm = ConfigureResources(Request);
            InitZfComponents();
        }

        protected bool fPopup = false;          // is this page a popup?

        /// <summary>
        ///    Returns to popupness of this page.
        /// </summary>
        public bool IsPopup
        {
            get { return fPopup; }
        }

        #region Resources
        protected ResourceManager rm;       // the resource manager which holds our translated strings

        /// <summary>
        ///     Returns a copy of the resource manager
        /// </summary>
        public ResourceManager ResMan
        {
            get { return rm; }
        }

        /// <summary>
        ///     Configures ASP.NET so that the page is returned in the correct language.
        ///     <remarks>
        ///         The algorithm for finding the correct language is as follows:
        ///             - use forcelang override if specified (english on fail)
        ///             - for each request language try language and lang-neutral language
        ///               stop when you find the first one which loads.
        ///     </remarks>  
        /// </summary>
        public static ResourceManager ConfigureResources(HttpRequest req)
        {
            ResourceManager rmLocal = new ResourceManager("Zetafax.strings", typeof(PageBase).Assembly);

            if (ZetafaxConfiguration.ForceLangString != String.Empty)
            {
                try
                {
                    // User override of languange
                    CultureInfo cc = CultureInfo.CreateSpecificCulture(ZetafaxConfiguration.ForceLangString);
                    CultureInfo cuic = new CultureInfo(ZetafaxConfiguration.ForceLangString);
                    Thread.CurrentThread.CurrentCulture = cc;
                    Thread.CurrentThread.CurrentUICulture = cuic;
                }
                catch (Exception ex)
                {
                    // Somebody probably asked for a language we don't support. 
                    // Log it and continue.
                    ApplicationLog.WriteWarning(ApplicationLog.FormatException(ex, "Error forcing CultureInfo"));
                }
            }
            else
            {
                CultureInfo cc = CultureInfo.CurrentCulture;
                CultureInfo cuic = CultureInfo.CurrentUICulture;
                CultureInfo cen = new CultureInfo("en");

                // Set the culture and UI culture to the browser's accept language
				string[] arrLanguages = req.UserLanguages;

				// If the browser doesn't specify locale (like outlook)
				if (null == arrLanguages || 0 == arrLanguages.Length)
				{
					// Use default language if specified
					if (ZetafaxConfiguration.DefaultLangString != String.Empty)
					{
						arrLanguages = new string[] { ZetafaxConfiguration.DefaultLangString };
					}
					else
					{
						// No defualt - use english
						arrLanguages = new string[] { "en" };
					}
				}

				foreach (string strReqLang in arrLanguages)
                {
                    // truncate at ";"
                    int iSemi = strReqLang.IndexOf(';');
                    string strLang;
                    if (iSemi > 0)
                    {
                        strLang = strReqLang.Substring(0,iSemi);
                    }
                    else
                    {
                        strLang = strReqLang;
                    }

                    try
                    {
                        CultureInfo ccLocal = CultureInfo.CreateSpecificCulture(strLang);
                        if (ccLocal.Equals(cen))
                        {
                            // english culture: break
                            break;
                        }
                        ResourceSet rs = rmLocal.GetResourceSet(ccLocal, true, false);
                        if (rs == null && !ccLocal.IsNeutralCulture)
                        {
                            if (ccLocal.Parent.Equals(cen))
                            {
                                // english culture: break
                                break;
                            }
                            rs = rmLocal.GetResourceSet(ccLocal.Parent, true, false);
                        }

                        if (rs != null)
                        {
                            cc = ccLocal;
                            cuic = new CultureInfo(strLang);
                            break;
                        }
                    }
                    catch (Exception ex)
                    {
                        // Somebody probably asked for a language we don't support. 
                        // Log it and continue.
                        ApplicationLog.WriteInfo(ApplicationLog.FormatException(ex, "Error setting CultureInfo"));
                    }
                }

                Thread.CurrentThread.CurrentCulture = cc;
                Thread.CurrentThread.CurrentUICulture = cuic;
            }

            return rmLocal;
        }
        #endregion

        #region Zetafax COM objects
        // exclusive logon to stop the user logging on elsewhere and 
        // deleting items getting out item<->index mappings out of synch
        // (this would be bad if we were deleting faxes)
        private const bool   fExclusive_Logon = false;
        protected ZfLib.ZfAPI zfAPI;
        protected ZfLib.UserSession zfUserSession;

        public ZfLib.UserSession UserSession
        {
            get { return zfUserSession; }
        }

        /// <summary>
        ///     Tried to find the Zetafax API in the application cache. 
        ///     If it cannot find it it logs on to the Zetafax API as the correct user,
        ///     the stores it in the application cache.
        /// </summary>
        protected void InitZfComponents()
        {
            string strName = Context.User.Identity.Name;
			ApplicationLog.WriteInfo("InitZfComponents() for user: " + strName);
            if (ZetafaxConfiguration.EnablePageCache &&
                ZetafaxConfiguration.APICacheExpiresInMins > 0)
            {
                InitZfAPIFromCache(strName);
            }
            else
            {
                // we aren't caching objects - create new Zetafax ones.
                CreateZfAPIObject();
                zfUserSession = zfAPI.Logon(strName, fExclusive_Logon);
            }
        }

        private const string CACHE_API = "ZfAPI";
        private const string CACHE_LOG = "ZfAPILog";
        private const string CACHE_SESSION = "ZfUserSession";

        /// <summary>
        ///     Find the API objects in the cache, or create them if they don't exist.
        ///     <remarks>
        ///         We only need one instance of the API object in the cache,
        ///         but each user has their own session object.
        ///         If the main API object expires, the session objects expire as well
        ///     </remarks>
        ///     <param name="strZfName">
        ///         The Zetafax user name of the session we wish to retrieve from the cache.
        ///     </param>
        /// </summary>
        private void InitZfAPIFromCache(string strZfName)
        {
            string strFromName = string.Empty;
			zfAPI = Cache[CACHE_API] as ZfLib.ZfAPI;
            zfUserSession = Cache[CACHE_SESSION + "_" + strZfName] as ZfLib.UserSession;
			try
			{
				// proper test to see if object is valid
				strFromName = zfUserSession.FromName;
			}
			catch (Exception) {	}

            if (zfAPI != null && zfUserSession != null && strFromName != string.Empty)
            {
                // found in cache - nothing more to do!
                ApplicationLog.WriteTrace("Cache hit: " + strFromName);
                return;
            }

            ApplicationLog.WriteTrace("Cache miss: " + strZfName);

            TimeSpan ts = TimeSpan.FromMinutes(ZetafaxConfiguration.APICacheExpiresInMins);
            if (zfAPI == null)
            {
                CreateZfAPIObject();
                Cache.Insert(CACHE_API, zfAPI, null, Cache.NoAbsoluteExpiration, ts);
            }
            zfUserSession = zfAPI.Logon(strZfName, fExclusive_Logon);

            ApplicationLog.WriteTrace("Logged on: " + strZfName);

            Cache.Insert(CACHE_SESSION + "_" + strZfName, zfUserSession, 
                         new CacheDependency(null, new string[]{CACHE_API}), Cache.NoAbsoluteExpiration, ts, 
                         CacheItemPriority.Normal, new CacheItemRemovedCallback(UserSessionExpiryCallback));
        }

		/// <summary>
		///     Create and initialise a zfapi object
		/// </summary>
		private void CreateZfAPIObject()
		{
			// Create new object
			zfAPI = new ZfLib.ZfAPIClass();

			// Set up Zetafax API
			zfAPI.Escape("TRACE", IsAPILogging);
			zfAPI.Escape("APPLICATION", 0x1057);    // don't check for an API licence
			zfAPI.AutoTempDirectory = true;			// use \zfax\users\<user> for temp directory
			zfAPI.EnableImpersonation = ZetafaxConfiguration.APIImpersonation;		

			if (ZetafaxConfiguration.ZetafaxServer != String.Empty)
			{
				ApplicationLog.WriteInfo("ZfAPI directories (" + ZetafaxConfiguration.ZetafaxServer + ", "
					+ ZetafaxConfiguration.ZetafaxSystem + ", " + ZetafaxConfiguration.ZetafaxUsers + ", "
					+ ZetafaxConfiguration.ZetafaxRequest + ")");

				zfAPI.SetZetafaxDirs(ZetafaxConfiguration.ZetafaxServer,
					ZetafaxConfiguration.ZetafaxSystem,
					ZetafaxConfiguration.ZetafaxUsers,
					ZetafaxConfiguration.ZetafaxRequest);
			}
			else
			{
				ApplicationLog.WriteInfo("No Zetafax directories in web.config. Using ZETAFAX.INI");
			}
		}

        /// <summary>
        ///     Function called when a user session object is nuked from the cache.
        ///     Logs off the user.
        /// </summary>
        /// <param name="key"></param>
        /// <param name="val"></param>
        /// <param name="reason"></param>
        private static void UserSessionExpiryCallback(string key, object val, CacheItemRemovedReason reason)
        {
            try
            {
                ZfLib.UserSession zfUserSession = (ZfLib.UserSession)val;
                // we cannot user "FromName" because this function doesn't run as the Zetafax user,
                // and therefore may not have permission to access the user's files to read information
                // such as the user's from name
                string strUser = zfUserSession.UserInDir;
                int nEnd = strUser.LastIndexOf('\\', strUser.LastIndexOf('\\')-1);
                int nStart = 1 + strUser.LastIndexOf('\\', nEnd-1);
                strUser = strUser.Substring(nStart, nEnd-nStart);
                ApplicationLog.WriteTrace("Cache remove: " + strUser.ToLower());
                zfUserSession.Logoff();
            }
            catch (Exception ex)
            {
                // this error usually occurs if NT authentication is used to protect the Zetafax
                // directories and the ASPNET process doesn't have authority to release the LOK file.
                ApplicationLog.WriteTrace(ApplicationLog.FormatException(ex, "Failed to log off user session"));
            }
        }

        protected static int IsAPILogging
        {
            get
            {
                if (ApplicationConfiguration.TracingEnabled &&
                    ApplicationConfiguration.TracingTraceLevel == System.Diagnostics.TraceLevel.Verbose)
                {
                    return 1;
                }

                return 0;
            }
        }
        #endregion
    }
}
