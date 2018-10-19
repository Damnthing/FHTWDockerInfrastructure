using System;
using System.Globalization;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Assignment.Models;
using System.Web.Security;
using Assignment.Core;

namespace Assignment.Controllers
{
    [Authorize]
    public class AccountController : Controller
    {
        private readonly log4net.ILog _log = log4net.LogManager.GetLogger("Web");
        //
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            return View(new LoginViewModel()
            {
                ReturnUrl = returnUrl,
                DisablePasswordCheck = LDAPAuthenticator.DisablePasswordCheck
            });
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginViewModel model, string returnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            model.Sanitize();

            if (LDAPAuthenticator.Authenticate(model.UID, model.Password).IsAuthenticated)
            {
                _log.InfoFormat("User '{0}' logged in", model.UID);
                FormsAuthentication.SetAuthCookie(model.UID, model.RememberMe);
                return RedirectToLocal(returnUrl);
            }
            else
            {
                _log.InfoFormat("Invalid login attempt for user '{0}'", model.UID);
                ModelState.AddModelError("", "Invalid login attempt.");
                return View(model);
            }
        }

        [Authorize(Roles = "Admin")]
        public ActionResult Impersonate()
        {
            return View(new ImpersonateViewModel());
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [Authorize(Roles = "Admin")]
        [ValidateAntiForgeryToken]
        public ActionResult Impersonate(ImpersonateViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            model.Sanitize();

            if (LDAPAuthenticator.GetUserParameter(model.UID).IsAuthenticated)
            {
                _log.InfoFormat("User '{0}' impersonated", model.UID);
                // ,admin indicates the impersonation. Global.asax.AuthorizeRequest will handle this
                FormsAuthentication.SetAuthCookie(model.UID + (model.AsAdmin ? ",admin" : ""), false);
                return RedirectToAction("Index", "Home");
            }
            else
            {
                _log.InfoFormat("Impersonation attempt for user '{0}'", model.UID);
                ModelState.AddModelError("", "Invalid impersonation attempt.");
                return View(model);
            }
        }


        //
        // POST: /Account/LogOff
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Home");
        }

        #region Helpers
        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Home");
        }
        #endregion
    }
}