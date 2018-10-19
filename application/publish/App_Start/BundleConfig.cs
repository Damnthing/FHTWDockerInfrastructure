using System.Web;
using System.Web.Optimization;

namespace Assignment
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js",
                        "~/Scripts/jquery.unobtrusive-ajax.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/cldr.js",
                        "~/Scripts/cldr/event.js",
                        "~/Scripts/cldr/supplemental.js",
                        "~/Scripts/cldr/unresolved.js",
                        "~/Scripts/globalize.js",
                        "~/Scripts/globalize/number.js",
                        "~/Scripts/globalize/date.js",
                        "~/Scripts/jquery.validate*",
                        "~/Scripts/Site.js"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/site.css"));

            // bundles for MvcFileUpload
            // Blueimp Jquery File Upload
            bundles.Add(new ScriptBundle("~/bundles/mvcfileupload").Include(
                       "~/Scripts/mvcfileupload/blueimp/jquery.ui.widget.js",
                       "~/Scripts/mvcfileupload/blueimp/tmpl.min.js",
                       // The Load Image plugin is included for the preview images and image resizing functionality
                       "~/Scripts/mvcfileupload/blueimp/load-image.min.js",
                       // The Canvas to Blob plugin is included for image resizing functionality
                       "~/Scripts/mvcfileupload/blueimp/canvas-to-blob.min.js",
                       "~/Scripts/mvcfileupload/blueimp/jquery.iframe-transport.js",
                       "~/Scripts/mvcfileupload/blueimp/jquery.fileupload.js",
                       "~/Scripts/mvcfileupload/blueimp/jquery.fileupload-process.js",
                       "~/Scripts/mvcfileupload/blueimp/jquery.fileupload-image.js",
                       "~/Scripts/mvcfileupload/blueimp/jquery.fileupload-validate.js",
                       "~/Scripts/mvcfileupload/blueimp/jquery.fileupload-ui.js"));

            // Blueimp styles / see blueimp docs for styling requirements for jquery ui
            bundles.Add(new StyleBundle("~/styles/mvcfileupload").Include(
                        "~/Content/mvcfileupload/blueimp/jquery.fileupload.css",
                        "~/Content/mvcfileupload/blueimp/jquery.fileupload-ui.css"));
        }
    }
}
