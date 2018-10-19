using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using Assignment.Models;
using Ionic.Zip;
using MvcFileUploader.Models;

namespace Assignment.Controllers
{
    [Authorize(Roles = "Admin")]
    public class AdminCourseController : Controller
    {
        private readonly Core.BL.BL _bl;
        private readonly Core.SubmissionStoreProvider.SubmissionCollectorFactory _submissionCollectorFactory;
        private readonly Core.SubmissionStoreProvider.AssignmentStoreProviderFactory _assignmentStoreFactory;
        private readonly log4net.ILog _log = log4net.LogManager.GetLogger("Web");

        public AdminCourseController(Core.BL.BL bl, Core.SubmissionStoreProvider.SubmissionCollectorFactory submissionCollectorFactory, Core.SubmissionStoreProvider.AssignmentStoreProviderFactory assignmentStoreFactory)
        {
            _bl = bl;
            _submissionCollectorFactory = submissionCollectorFactory;
            _assignmentStoreFactory = assignmentStoreFactory;
        }

        #region Indexes
        // GET: AdminGroupWork
        public ActionResult Index(bool? withInactive)
        {
            var vmdl = new CourseIndexViewModel();
            vmdl.Courses = _bl.GetCourses(false)
                .Where(i => withInactive == true || i.IsActive)
                .OrderBy(i => i.Name)
                .ToList()
                .Select(i => new CourseViewModel(i))
                .ToList();
            vmdl.ShowWithInactiveLink = withInactive == null || withInactive == false;
            vmdl.ShowOnlyActiveLink = withInactive == true;
            return View(vmdl);
        }

        public ActionResult GroupWorks(int id)
        {
            var course = _bl.GetCourse(id);
            var vmdl = new CourseViewModel(course);
            vmdl.GroupWorks = course.GroupWorks
                .OrderBy(i => i.OwnerUID)
                .ToList()
                .Select(i => new GroupWorkViewModel(i))
                .ToList();
            return View(vmdl);
        }

        public ActionResult Assignments(int id)
        {
            var course = _bl.GetCourse(id);
            var vmdl = new CourseViewModel(course);
            vmdl.Assignments = course.Assignments
                .OrderBy(a => a.DueDate)
                .ThenBy(a => a.Name)
                .Select(a => new AssignmentItemViewModel(a));
            return View(vmdl);
        }
        #endregion

        #region Create/Edit course
        public ActionResult Create()
        {
            var vmdl = new CourseViewModel();
            return View(vmdl);
        }

        [HttpPost]
        public ActionResult Create(CourseViewModel vmdl)
        {
            if (ModelState.IsValid)
            {
                var obj = _bl.CreateCourse();
                vmdl.ApplyChanges(obj);
                _bl.SaveChanges();
                return RedirectToAction("Assignments", new { id = obj.ID });
            }
            return View(vmdl);
        }

        public ActionResult Edit(int id)
        {
            var obj = _bl.GetCourse(id);
            var vmdl = new CourseViewModel(obj);
            return View(vmdl);
        }

        [HttpPost]
        public ActionResult Edit(int id, CourseViewModel vmdl)
        {
            var obj = _bl.GetCourse(id);

            if (ModelState.IsValid)
            {
                vmdl.ApplyChanges(obj);
                _bl.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(vmdl);
        }
        #endregion

        #region Create/Edit assignment
        public ActionResult CreateAssignment(int courseID)
        {
            var vmdl = new AssignmentItemViewModel();
            vmdl.Course = new CourseViewModel(_bl.GetCourse(courseID));
            return View(vmdl);
        }

        [HttpPost]
        public ActionResult CreateAssignment(int courseID, AssignmentItemViewModel vmdl)
        {
            if (ModelState.IsValid)
            {
                var course = _bl.GetCourse(courseID);
                var obj = _bl.CreateAssignment(course);
                vmdl.ApplyChanges(obj);
                _bl.SaveChanges();
                return RedirectToAction("EditAssignment", new { id = obj.ID });
            }
            vmdl.Course = new CourseViewModel(_bl.GetCourse(courseID));
            return View(vmdl);
        }

        public ActionResult EditAssignment(int id)
        {
            var obj = _bl.GetAssignment(id);
            var vmdl = new AssignmentItemViewModel(obj);
            vmdl.Course = new CourseViewModel(_bl.GetCourse(obj.Course.ID));

            var store = _assignmentStoreFactory(obj);
            vmdl.CurrentFileContent = store.GetItems(includeHidenFiles: true).OrderBy(i => i.FilePath).Select(i => new SubmissionItemViewModel(i));
            vmdl.FileCommits = store.GetCommits().Select(i => new CommitItemViewModel(i));
            return View(vmdl);
        }

        [HttpPost]
        public ActionResult EditAssignment(int id, string action, AssignmentItemViewModel vmdl)
        {
            var obj = _bl.GetAssignment(id);
            var courseID = obj.Course.ID;
            if (action == "delete")
            {
                _bl.Delete(obj);
                _bl.SaveChanges();
                return RedirectToAction("Assignments", new { id = courseID });
            }
            else
            {
                if (ModelState.IsValid)
                {
                    vmdl.ApplyChanges(obj);
                    _bl.SaveChanges();
                    var store = _assignmentStoreFactory(obj);
                    if (store.GetItems(includeHidenFiles: true).Any(c => c.Added || c.Modified))
                    {
                        store.Commit(string.Format("New version of files", DateTime.Now));
                    }
                    return RedirectToAction("Assignments", new { id = courseID });
                }
                vmdl.Course = new CourseViewModel(_bl.GetCourse(obj.Course.ID));
                return View(vmdl);
            }
        }
        #endregion

        #region Download
        public ActionResult Download(int id)
        {
            var assignment = _bl.GetAssignment(id);

            var stores = _submissionCollectorFactory(assignment);

            string fileName = _bl.ToValidFilename(string.Format("Assignments-{0}-{1}", assignment.Course.Name, assignment.Name), ".zip");
            var zip = new ZipFile();
            var result = new ZipFileResult(zip, fileName);
            var errors = new StringBuilder();

            foreach (var store in stores)
            {
                try
                {
                    foreach (var item in store.GetItems(includeHidenFiles: true))
                    {
                        var s = item.GetStream();
                        zip.AddEntry(store.UID + "\\" + item.FilePath, s);
                        result.DisposeOnFlush(s);
                    }
                }
                catch (Exception ex)
                {
                    errors.Append($"{store?.UID}: {ex.Message}");
                }
            }

            if(errors.Length > 0)
            {
                zip.AddEntry("errors.log", errors.ToString());
            }

            return result;
        }
        #endregion

        #region AssingmentFiles
        public ActionResult AssignmentFiles(int id)
        {
            JsonResult result;
            var obj = _bl.GetAssignment(id);
            if (!obj.IsActive && !_bl.IsAdmin)
            {
                result = Json(new { Error = "Inactive course" });
            }
            else
            {
                var store = _assignmentStoreFactory(obj);

                var statusList = new List<ViewDataUploadFileResult>();
                for (var i = 0; i < Request.Files.Count; i++)
                {
                    var uploaded = Request.Files[i];

                    store.Save(uploaded.FileName, uploaded.InputStream);

                    var st = new ViewDataUploadFileResult();
                    st.name = uploaded.FileName;
                    st.Title = uploaded.FileName;
                    st.SavedFileName = uploaded.FileName;

                    st.size = uploaded.ContentLength;
                    st.type = uploaded.ContentType;

                    statusList.Add(st);
                    _log.InfoFormat("File '{0}' uploaded to {1}.{2} by {3}", uploaded.FileName, obj.Course.Name, obj.Name, _bl.CurrentUID);
                }
                result = Json(new { files = statusList });
            }

            //for IE8 which does not accept application/json
            if (Request.Headers["Accept"] != null && !Request.Headers["Accept"].Contains("application/json"))
            {
                result.ContentType = "text/plain";
            }

            return result;
        }

        public ActionResult DownloadAssignment(int id)
        {
            var assignment = _bl.GetAssignment(id);
            var store = _assignmentStoreFactory(assignment);

            string fileName = "Assignment.zip";
            var zip = new ZipFile();
            var result = new ZipFileResult(zip, fileName);

            foreach (var item in store.GetItems(includeHidenFiles: true))
            {
                var s = item.GetStream();
                zip.AddEntry(item.FilePath, s);
                result.DisposeOnFlush(s);
            }

            return result;
        }


        [HttpPost]
        public ActionResult DeleteAssignmentFile(int id, string file)
        {
            var obj = _bl.GetAssignment(id);
            var store = _assignmentStoreFactory(obj);
            store.Delete(file);
            _log.InfoFormat("File(s) '{0}' deleted in {1}.{2} by {3}", file, obj.Course.Name, obj.Name, _bl.CurrentUID);

            var vmdl = new AssignmentItemViewModel(obj);
            vmdl.Course = new CourseViewModel(_bl.GetCourse(obj.Course.ID));
            vmdl.CurrentFileContent = store.GetItems(includeHidenFiles: true).OrderBy(i => i.FilePath).Select(i => new SubmissionItemViewModel(i));
            vmdl.FileCommits = store.GetCommits().Select(i => new CommitItemViewModel(i));
            return View("_CurrentAssignmentContent", vmdl);
        }

        #endregion
    }
}