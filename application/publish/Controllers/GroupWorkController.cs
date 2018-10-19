using Assignment.Core;
using Assignment.Core.DAL;
using Assignment.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace Assignment.Controllers
{
    [Authorize]
    public class GroupWorkController : Controller
    {
        private readonly Core.BL.BL _bl;
        private readonly log4net.ILog _log = log4net.LogManager.GetLogger("Web");

        public GroupWorkController(Core.BL.BL bl)
        {
            _bl = bl;
        }

        // GET: Summary
        public ActionResult Index()
        {
            var vmdl = new GroupWorkIndexViewModel();

            vmdl.UID = User.Identity.Name;
            vmdl.GroupWorks = _bl.GetMyGroupWorks()
                .OrderByDescending(i => i.CreatedOn)
                .ToList()
                .Select(i => new GroupWorkViewModel(i))
                .ToList();

            return View(vmdl);
        }

        public ActionResult Join()
        {
            return View();
        }

        public ActionResult Create()
        {
            var vmdl = new GroupWorkViewModel();
            vmdl.OwnerUID = User.Identity.Name;
            vmdl.SetCourseItems(_bl.GetCourses().ToList());
            return View(vmdl);
        }

        [HttpPost]
        public ActionResult Create(GroupWorkViewModel vmdl)
        {
            Course course = null;
            if (ModelState.IsValid)
            {
                course = _bl.GetCourses().Single(c => c.Name == vmdl.Course);
                if (_bl.IsAlreadyGroupMemberInCourse(_bl.CurrentUID, course))
                {
                    ModelState.AddModelError("", "You are already managing or joined to a group work in this course");
                }
            }

            if (ModelState.IsValid)
            {
                var obj = _bl.CreateGroupWork(course);
                vmdl.ApplyChanges(obj, _bl);
                _bl.SaveChanges();
                _log.InfoFormat("Group work {0}.{1} created", obj.Course.Name, obj.OwnerUID);

                return RedirectToAction("Manage", new { id = obj.ID });
            }

            vmdl.OwnerUID = User.Identity.Name;
            vmdl.SetCourseItems(_bl.GetCourses().ToList());
            return View(vmdl);
        }

        public ActionResult Edit(int id)
        {
            var obj = _bl.GetGroupWork(id);
            var vmdl = new GroupWorkViewModel(obj);
            vmdl.SetCourseItems(_bl.GetCourses().ToList());
            vmdl.SetGroupWorkMembers(obj.Member);
            return View(vmdl);
        }

        [HttpPost]
        public ActionResult Edit(int id, GroupWorkViewModel vmdl)
        {
            var obj = _bl.GetGroupWork(id);

            if (ModelState.IsValid)
            {
                var course = _bl.GetCourses().Single(c => c.Name == vmdl.Course);
                if (vmdl.Course != obj.Course.Name && _bl.IsAlreadyGroupMemberInCourse(_bl.CurrentUID, course))
                {
                    ModelState.AddModelError("", "You are already managing or joined to a group work in this course");
                }
            }

            if (ModelState.IsValid)
            {
                vmdl.ApplyChanges(obj, _bl);
                _bl.SaveChanges();

                return RedirectToAction("Index");
            }
            vmdl.SetCourseItems(_bl.GetCourses().ToList());
            vmdl.SetGroupWorkMembers(obj.Member);
            return View(vmdl);
        }

        public ActionResult Manage(int id)
        {
            var obj = _bl.GetGroupWork(id);
            var vmdl = new ManageGroupWorkViewModel(obj);
            vmdl.GroupWork.SetGroupWorkMembers(obj.Member);
            return View(vmdl);
        }

        private static readonly Regex actionRegex = new Regex(@"(\w+)(-(\d+))?");

        [HttpPost]
        public ActionResult Manage(int id, string action, ManageGroupWorkViewModel vmdl)
        {
            var obj = _bl.GetGroupWork(id);
            vmdl.Refresh(obj);

            var matches = actionRegex.Match(action);
            action = matches.Groups[1].Value;
            int actionID;
            int.TryParse(matches.Groups[3].Value, out actionID);

            if (action == "Add" && string.IsNullOrWhiteSpace(vmdl.AddUID))
            {
                ModelState.AddModelError("AddUID", "UID is empty.");
            }

            if (ModelState.IsValid)
            {
                if (action == "Add")
                {
                    if (_bl.IsAlreadyGroupMemberInCourse(vmdl.AddUID, obj.Course))
                    {
                        ModelState.AddModelError("", "New Member is already managing or joined to a group work in this course");
                    }
                    else
                    {
                        _bl.CreateGroupWorkMember(obj, vmdl.AddUID);
                        _bl.SaveChanges();
                        _log.InfoFormat("User {0} added to group work {1}.{2}", vmdl.AddUID, obj.Course.Name, obj.OwnerUID);
                    }
                    vmdl.Refresh(obj);
                }
                else if (action == "Remove")
                {
                    var member = _bl.GetGroupWorkMember(actionID);
                    _bl.RemoveGroupWorkMember(member);
                    _bl.SaveChanges();
                    _log.InfoFormat("User {0} removed from group work {1}.{2}", member.UID, obj.Course.Name, obj.OwnerUID);
                }
            }
            vmdl.GroupWork.SetGroupWorkMembers(obj.Member);
            return View("Manage", vmdl);
        }
    }
}