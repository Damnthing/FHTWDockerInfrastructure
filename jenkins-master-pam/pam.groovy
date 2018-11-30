import jenkins.model.*
import hudson.security.*

// get jenkins instance
def instance = Jenkins.getInstance();

// create the realm
def pamRealm = new PAMSecurityRealm("sshd");

// set the realm
instance.setSecurityRealm(pamRealm);

// save the instance
instance.save();
