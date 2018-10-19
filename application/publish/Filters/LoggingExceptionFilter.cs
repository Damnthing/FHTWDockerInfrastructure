using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Assignment.Filters
{
    public class LoggingExceptionFilter : IExceptionFilter
    {
        private readonly IExceptionFilter _filter;
        private readonly log4net.ILog _log = log4net.LogManager.GetLogger("Web");

        public LoggingExceptionFilter(IExceptionFilter filter)
        {
            if (filter == null)
            {
                throw new ArgumentNullException("filter");
            }

            _filter = filter;
        }

        public void OnException(ExceptionContext filterContext)
        {
            try
            {
                string detail = "";
                var ex = filterContext.Exception;
                while (ex != null)
                {
                    _log.Error("Error in webapplication" + detail, ex);
                    ex = ex.InnerException;
                    detail = ": inner exception:";
                }
            }
            catch
            {
                // IGNORE THIS
            }
            _filter.OnException(filterContext);
        }
    }
}