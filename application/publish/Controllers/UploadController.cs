using Assignment.Core;
using Assignment.Models;
using MvcFileUploader.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ionic.Zip;

namespace Assignment.Controllers
{
    [Authorize]
    public class UploadController : Controller
    {
        private readonly Core.BL.BL _bl;
        private readonly log4net.ILog _log = log4net.LogManager.GetLogger("Web");
        private readonly log4net.ILog _logSubmission = log4net.LogManager.GetLogger("Submissions");
        private readonly Core.SubmissionStoreProvider.SubmissionStoreProviderFactory _submissionStoreFactory;
        private readonly Core.SubmissionStoreProvider.AssignmentStoreProviderFactory _assignmentStoreFactory;

        public UploadController(Core.BL.BL bl, Core.SubmissionStoreProvider.SubmissionStoreProviderFactory submissionStoreFactory, Core.SubmissionStoreProvider.AssignmentStoreProviderFactory assignmentStoreFactory)
        {
            _bl = bl;
            _submissionStoreFactory = submissionStoreFactory;
            _assignmentStoreFactory = assignmentStoreFactory;
        }

        // GET: Upload
        public ActionResult Index()
        {
            var vmdl = new UploadIndexViewModel();
            var qry = _bl.GetCourses()
                .Where(c => c.Assignments.Any())
                .OrderBy(c => c.Name)
                .ToList();
            if(!_bl.IsAdmin)
            {
                var uid = _bl.CurrentUID?.ToLower();
                if (string.IsNullOrWhiteSpace(uid))
                {
                    qry.Clear(); // Failsave
                }
                else
                {
                    qry = qry
                        .Where(c => c.UserUIDs?.ToLower().Split('\n').Select(i => i.Trim()).Any(l => l == uid) ?? false)
                        .ToList();
                }
            }
            vmdl.Courses = qry                
                .Select(i => new CourseViewModel(i) 
                { 
                    Assignments = i.Assignments.OrderBy(a => a.DueDate).ThenBy(a => a.Name).Select(a => new AssignmentItemViewModel(a))
                })
                .ToList();
            return View(vmdl);
        }

        public ActionResult Assignment(int id)
        {
            var obj = _bl.GetAssignment(id);
            if(!obj.IsActive && !_bl.IsAdmin)
            {
                return RedirectToAction("InactiveAssignment", new { id = id });
            }

            var vmdl = new UploadViewModel(obj);
            var store = _submissionStoreFactory(obj, _bl.CurrentUID);
            vmdl.CurrentContent = store.GetItems(includeHidenFiles: true).OrderBy(i => i.FilePath).Select(i => new SubmissionItemViewModel(i));
            vmdl.Commits = store.GetCommits().Select(i => new CommitItemViewModel(i));
            return View(vmdl);
        }

        public ActionResult ViewAssignment(int id)
        {
            var obj = _bl.GetAssignment(id);

            var vmdl = new ViewAssignmentViewModel(obj);
            var store = _submissionStoreFactory(obj, _bl.CurrentUID);
            vmdl.CurrentContent = store.GetItems(includeHidenFiles: true).OrderBy(i => i.FilePath).Select(i => new SubmissionItemViewModel(i));
            vmdl.Commits = store.GetCommits().Select(i => new CommitItemViewModel(i));

            if (vmdl.Assignment.ShowFiles)
            {
                var storeAssignment = _assignmentStoreFactory(obj);
                vmdl.Assignment.CurrentFileContent = storeAssignment.GetItems(/* no hidden files! */).OrderBy(i => i.FilePath).Select(i => new SubmissionItemViewModel(i));
            }

            return View(vmdl);
        }

        public ActionResult DownloadAssignment(int id, string file = null)
        {
            var assignment = _bl.GetAssignment(id);
            var store = _assignmentStoreFactory(assignment);

            if (string.IsNullOrWhiteSpace(file))
            {
                string fileName = "Assignment.zip";
                var zip = new ZipFile();
                var result = new ZipFileResult(zip, fileName);

                foreach (var item in store.GetItems())
                {
                    var s = item.GetStream();
                    zip.AddEntry(item.FilePath, s);
                    result.DisposeOnFlush(s);
                }

                return result;
            }
            else
            {
                var item = store.GetItems().Single(i => i.FilePath.ToLower() == file.ToLower());
                return File(item.GetStream(), MimeMapping.GetMimeMapping(item.FilePath), item.Name);
            }
        }

        public ActionResult DownloadSubmission(int id)
        {
            var assignment = _bl.GetAssignment(id);
            var store = _submissionStoreFactory(assignment, _bl.CurrentUID);

            string fileName = "Submission.zip";
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

        /// <summary>
        /// Upload/Files - receives the uploaded files
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ActionResult Files(int id)
        {
            JsonResult result;
            var obj = _bl.GetAssignment(id);
            if (!obj.IsActive && !_bl.IsAdmin)
            {
                result = Json(new { Error = "Inactive course" });
            }
            else
            {
                // Optimization hint: use a lock object for each repository
                // this will prevent global locks.
                lock (typeof(UploadController)) 
                {
                    var store = _submissionStoreFactory(obj, _bl.CurrentUID);

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

                    store.Commit(string.Format("{0} Files submitted", Request.Files.Count));
                    _log.InfoFormat("Upload {0}.{1} commited by {2}", obj.Course.Name, obj.Name, _bl.CurrentUID);
                    _logSubmission.InfoFormat("{0}.{1};{2};{3}", obj.Course.Name, obj.Name, _bl.CurrentUID, Request.UserHostAddress);
                }
            }


            //for IE8 which does not accept application/json
            if (Request.Headers["Accept"] != null && !Request.Headers["Accept"].Contains("application/json"))
            {
                result.ContentType = "text/plain";
            }

            return result;
        }

        [HttpPost]
        public ActionResult Delete(int id, string file)
        {
            var obj = _bl.GetAssignment(id);
            var store = _submissionStoreFactory(obj, _bl.CurrentUID);
            store.Delete(file);
            _log.InfoFormat("File(s) '{0}' deleted in {1}.{2} by {3}", file, obj.Course.Name, obj.Name, _bl.CurrentUID);
            return RedirectToAction("Assignment", new { id = id });
        }

        public ActionResult InactiveAssignment(int id)
        {
            var obj = _bl.GetAssignment(id);
            var vmdl = new AssignmentItemViewModel(obj)
            {
                Course = new CourseViewModel(obj.Course)
            };
            return View(vmdl);
        }
    }
}