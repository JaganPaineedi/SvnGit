[assembly: WebActivatorEx.PreApplicationStartMethod(typeof(SC.Api.App_Start.NinjectWebCommon), "Start")]
[assembly: WebActivatorEx.ApplicationShutdownMethodAttribute(typeof(SC.Api.App_Start.NinjectWebCommon), "Stop")]

namespace SC.Api.App_Start
{
    using System;
    using System.Web;

    using Microsoft.Web.Infrastructure.DynamicModuleHelper;

    using Ninject;
    using Ninject.Web.Common;
    using System.Web.Http;
    using Ninject.Web.WebApi;
    using Data;

    public static class NinjectWebCommon 
    {
        private static readonly Bootstrapper bootstrapper = new Bootstrapper();

        /// <summary>
        /// Starts the application
        /// </summary>
        public static void Start() 
        {
            DynamicModuleUtility.RegisterModule(typeof(OnePerRequestHttpModule));
            DynamicModuleUtility.RegisterModule(typeof(NinjectHttpModule));
            bootstrapper.Initialize(CreateKernel);
        }
        
        /// <summary>
        /// Stops the application.
        /// </summary>
        public static void Stop()
        {
            bootstrapper.ShutDown();
        }
        
        /// <summary>
        /// Creates the kernel that will manage your application.
        /// </summary>
        /// <returns>The created kernel.</returns>
        private static IKernel CreateKernel()
        {
            var kernel = new StandardKernel();
            try
            {
                kernel.Bind<Func<IKernel>>().ToMethod(ctx => () => new Bootstrapper().Kernel);
                kernel.Bind<IHttpModule>().To<HttpApplicationInitializationHttpModule>();

                RegisterServices(kernel);
                GlobalConfiguration.Configuration.DependencyResolver = new NinjectDependencyResolver(kernel);
                return kernel;
            }
            catch
            {
                kernel.Dispose();
                throw;
            }
        }

        /// <summary>
        /// Load your modules or register your services here!
        /// </summary>
        /// <param name="kernel">The kernel.</param>
        private static void RegisterServices(IKernel kernel)
        {
            kernel.Bind<IAuthRepository>().To<AuthRepository>();
            kernel.Bind<IMobileStaffRepository>().To<MobileStaffRepositiry>();
            kernel.Bind<IAppointmentRepository>().To<AppointmentRepository>();
            kernel.Bind<IBriefcaseRepository>().To<BriefcaseRepositiry>();
            kernel.Bind<IPatientRepository>().To<PatientRepository>();
            kernel.Bind<IErrorLogRepository>().To<ErrorLogRepository>();
            kernel.Bind<IClientRepository>().To<ClientRepository>();
            kernel.Bind<ICommonRepository>().To<CommonRepository>();
            kernel.Bind<IDocumentRepository>().To<DocumentRepository>();        
            kernel.Bind<IKPIReportingRepository>().To<KPIReportingRepository>();
            kernel.Bind<SCMobile>().To<SCMobile>();
        }        
    }
}
