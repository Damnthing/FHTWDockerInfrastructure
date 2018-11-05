import org.kohsuke.stapler.StaplerRequest
import org.kohsuke.stapler.StaplerResponse
import hudson.markup.RawHtmlMarkupFormatter
import jenkins.model.Jenkins
import hudson.model.ListView
import java.util.*

// get Jenkins instance
def jenkins = Jenkins.getInstance();

// variables
def viewName = "Dashboard";

// create the new view
jenkins.addView(new ListView(viewName));

// get the view
def dashboardView = hudson.model.Hudson.instance.getView(viewName)

Jenkins.instance.setMarkupFormatter(new RawHtmlMarkupFormatter(false))

dashboardView.doSubmitDescription([ getParameter: { return """
	<h1>INF-SWE Jenkins Server</h1>
	<strong>Your plattform for your submissions</strong>
	<p>
		In this view you see all jobs where you have access to. You can bookmark your jobs. Consider checking &#34;Save Credentials&#34; for faster access.
	</p>
	<p>
		There is only one view, as each view will increase the page load time, see <a href="https://issues.jenkins-ci.org/browse/JENKINS-18377">https://issues.jenkins-ci.org/browse/JENKINS-18377</a> for the reason
	</p>
	"""; }] as StaplerRequest, [ sendRedirect: { return; } ]);
	
List<ListViewColumn> columns = new ArrayList<ListViewColumn>();
columns.add(new StatusColumn());
columns.add(new WeatherColumn());
columns.add(new JobColumn());
columns.add(new LastSuccessColumn());
columns.add(new LastFailureColumn());
columns.add(new LastDurationColumn());
columns.add(new BuildButtonColumn());

dashboardView.setColumns(columns);

// save current Jenkins state to disk
jenkins.save()