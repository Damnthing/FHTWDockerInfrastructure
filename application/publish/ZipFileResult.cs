using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ionic.Zip;

namespace Assignment
{
    public class ZipFileResult : ActionResult
    {
        public ZipFile zip { get; set; }
        public string FileName { get; set; }

        private List<IDisposable> _disposeOnFlush;

        public ZipFileResult(ZipFile zip)
        {
            this.zip = zip;
            this.FileName = null;
        }
        public ZipFileResult(ZipFile zip, string filename)
        {
            this.zip = zip;
            this.FileName = filename;
        }

        public override void ExecuteResult(ControllerContext context)
        {
            var Response = context.HttpContext.Response;

            Response.ContentType = "application/zip";
            Response.AddHeader("Content-Disposition", "attachment;" + (string.IsNullOrEmpty(FileName) ? "" : "filename=" + FileName));
            zip.Save(Response.OutputStream);
            Response.End();

            zip.Dispose();
            if (_disposeOnFlush != null)
            {
                foreach(var obj in _disposeOnFlush)
                {
                    obj.Dispose();
                }
            }
        }

        public void DisposeOnFlush(IDisposable obj)
        {
            if(_disposeOnFlush == null)
            {
                _disposeOnFlush = new List<IDisposable>();
            }
            _disposeOnFlush.Add(obj);
        }
    }
}