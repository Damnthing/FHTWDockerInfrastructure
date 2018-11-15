import java.lang.System
import jenkins.*
import hudson.model.*
import jenkins.model.*
// plugins for SSH credentials
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*

// read properties
def home_dir = System.getenv("JENKINS_HOME");

// get global domain
global_domain = Domain.global();

// get credentials store
credentials_store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore();

// create new credentials for jenkins-slave
creds = new BasicSSHUserPrivateKey(CredentialsScope.GLOBAL,
		"ssh-slave-private-key",
		"jenkins",
		new BasicSSHUserPrivateKey.FileOnMasterPrivateKeySource("/run/secrets/ssh-slave-private-key"),
		"",
		"Description");

// add new credentials
credentials_store.addCredentials(global_domain, creds);
