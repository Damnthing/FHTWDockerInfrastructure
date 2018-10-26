using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace Assignment
{
    public static class ExtensionHelper
    {
        public static MvcHtmlString PlaceholderFor<TModel, TValue>(this HtmlHelper<TModel> html, Expression<Func<TModel, TValue>> expression)
        {
            var watermark = ModelMetadata.FromLambdaExpression(expression, html.ViewData).Watermark;
            var htmlEncoded = HttpUtility.HtmlEncode(watermark);
            return new MvcHtmlString(htmlEncoded);
        }

        public static MvcHtmlString SuccessMessage(this HtmlHelper helper, string msg)
        {
            if (string.IsNullOrWhiteSpace(msg))
            {
                return MvcHtmlString.Empty;
            }

            return new MvcHtmlString(string.Format("<div class=\"alert alert-success\">{0}</div>", HttpUtility.HtmlEncode(msg)));
        }

        public static MvcHtmlString WarningMessage(this HtmlHelper helper, string msg)
        {
            if (string.IsNullOrWhiteSpace(msg))
            {
                return MvcHtmlString.Empty;
            }

            return new MvcHtmlString(string.Format("<div class=\"alert alert-warning\">{0}</div>", HttpUtility.HtmlEncode(msg)));
        }

        public static IHtmlString RenderScript(this UrlHelper helper, params string[] paths)
        {
            Boolean isDockerEnvironment = (System.Configuration.ConfigurationManager.AppSettings["isDockerEnvironment"] as string ?? "false") == "true";

            if (isDockerEnvironment)
            {
                string homeDirectory = HttpContext.Current.Request.MapPath("~");
                string virtualPath = homeDirectory.Replace("-", "/");
                string[] virtualPaths = paths.Select(path => path.Replace("~", virtualPath)).ToArray();

                return System.Web.Optimization.Scripts.Render(virtualPaths);
            }

            return System.Web.Optimization.Scripts.Render(paths);
        }

        public static IHtmlString RenderStyles(this UrlHelper helper, params string[] paths)
        {
            Boolean isDockerEnvironment = (System.Configuration.ConfigurationManager.AppSettings["isDockerEnvironment"] as string ?? "false") == "true";

            if (isDockerEnvironment)
            {
                string homeDirectory = HttpContext.Current.Request.MapPath("~");
                string virtualPath = homeDirectory.Replace("-", "/");
                string[] virtualPaths = paths.Select(path => path.Replace("~", virtualPath)).ToArray();

                return System.Web.Optimization.Styles.Render(virtualPaths);
            }

            return System.Web.Optimization.Styles.Render(paths);
        }

    }
}