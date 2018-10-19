using Assignment.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Assignment.Controllers
{
    [Authorize(Roles = "Admin")]
    public class AdminController : Controller
    {
        public ActionResult Logfile()
        {
            string logfile = Server.MapPath("~/App_Data/Logging/Web.txt");
            List<LogLineViewModel> lines = new List<LogLineViewModel>();
            if (System.IO.File.Exists(logfile))
            {
                using (var sr = new StreamReader(logfile))
                {
                    while (!sr.EndOfStream)
                    {
                        lines.Add(new LogLineViewModel() { Message = sr.ReadLine() });
                    }
                }
            }
            else
            {
                lines.Add(new LogLineViewModel() { Message = string.Format("[ERROR] logfile '{0}' not found!", logfile) });
            }
            return View(new LogFileViewModel() { Lines = lines });
        }

        public ActionResult SubmissionLogs()
        {
            var lst = Directory.GetFiles(Server.MapPath("~/App_Data/Logging/"), "Submissions*.*")
                        .Select(i => Path.GetFileName(i))
                        .ToList();
            return View(lst);
        }

        public ActionResult SubmissionLog(string filename)
        {
            return File(Server.MapPath("~/App_Data/Logging/" + filename), "test/csv", filename);
        }
    }
}