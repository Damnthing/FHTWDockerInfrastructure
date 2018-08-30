import java.lang.System
import jenkins.*
import hudson.model.*
import jenkins.model.*
// Plugins for SSH credentials
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*

// Read properties
def home_dir = System.getenv("JENKINS_HOME")

global_domain = Domain.global()
credentials_store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

creds = new BasicSSHUserPrivateKey(CredentialsScope.GLOBAL,
		"jenkins-slave-private-key",
        "jenkins-slave",
        new BasicSSHUserPrivateKey.FileOnMasterPrivateKeySource("/run/secrets/jenkins-node-private-key"),
        "",
        "Description")

credentials_store.addCredentials(global_domain, creds)
