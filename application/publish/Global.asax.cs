using Autofac;
using Autofac.Integration.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Security.Principal;
using Assignment.Core;
using System.Web.Caching;

namespace Assignment
{
    public class MvcApplication : System.Web.HttpApplication
    {
        public override void Init()
        {
            log4net.Config.XmlConfigurator.Configure();
            base.Init();
            this.Error += MvcApplication_Error;
            this.AuthorizeRequest += MvcApplication_AuthorizeRequest;
        }

        void MvcApplication_AuthorizeRequest(object sender, EventArgs e)
        {
            var user = HttpContext.Current.User.Identity;
            if (user.IsAuthenticated)
            {
                IPrincipal principal = null;

                if (user.Name.EndsWith(",admin"))
                {
                    // Handle impersonation
                    principal = new GenericPrincipal(new GenericIdentity(user.Name.Split(',').First()), new string[] { "Admin" });
                }
                else
                {
                    var key = string.Format("roles-{0}", user.Name);
                    var roles = HttpRuntime.Cache.Get(key) as string[];
                    if (roles == null)
                    {
                        var userModel = LDAPAuthenticator.GetUserParameter(user.Name);
                        if (userModel.PersonalType == "Teacher")
                        {
                            roles = new string[] { "Admin" };
                        }
                        else
                        {
                            roles = new string[] { };
                        }
                        HttpRuntime.Cache.Insert(key, roles, null, Cache.NoAbsoluteExpiration, TimeSpan.FromHours(1));
                    }
                    principal = new GenericPrincipal(user, roles);
                }

                System.Threading.Thread.CurrentPrincipal = principal;
                HttpContext.Current.User = principal;
            }
        }

        protected void Application_Start()
        {
            BuildMasterContainer();

            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        private void BuildMasterContainer()
        {
            var builder = new ContainerBuilder();

            // Register your MVC controllers.
            builder.RegisterControllers(typeof(MvcApplication).Assembly);

            builder.RegisterModule<Core.DAL.EntityFrameworkModule>();
            builder.RegisterModule<Core.CoreModule>();

            // Set the dependency resolver to be Autofac.
            var container = builder.Build();
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
        }

        void MvcApplication_Error(object sender, EventArgs e)
        {
            try
            {
                var log = log4net.LogManager.GetLogger("Web");
                string detail = "";
                var ex = HttpContext.Current.Error;
                while (ex != null)
                {
                    log.Error("Error in webapplication" + detail, ex);
                    ex = ex.InnerException;
                    detail = ": inner exception:";
                }
            }
            catch
            {
                // IGNORE THIS
            }
        }
    }
}
