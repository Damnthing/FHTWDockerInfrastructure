using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
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

    }
}