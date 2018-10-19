using Assignment.Filters;
using System.Web;
using System.Web.Mvc;

namespace Assignment
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new LoggingExceptionFilter(new HandleErrorAttribute()));
        }
    }
}
