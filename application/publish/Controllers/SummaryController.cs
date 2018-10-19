using Assignment.Core.DAL;
using Assignment.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Assignment.Controllers
{
    [Authorize]
    public class SummaryController : Controller
    {
        private readonly Core.BL.BL _bl;
        private readonly log4net.ILog _log = log4net.LogManager.GetLogger("Web");

        public SummaryController(Core.BL.BL bl)
        {
            _bl = bl;
        }

        // GET: Summary
        public ActionResult Index()
        {
            var vmdl = new SummaryViewModel();

            vmdl.UID = User.Identity.Name;
            vmdl.GroupWorks = _bl.GetMyGroupWorks()
                .ToList()
                .Select(i => new GroupWorkViewModel(i))
                .ToList();

            return View(vmdl);
        }

    }
}