#!groovy
 
import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule

# get jenkins instance
def instance = Jenkins.getInstance()
 
def user = new File("$JENKINS_USER_FILE").text.trim()
def pass = new File("$JENKINS_PASSWORD_FILE").text.trim()
 
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(user, pass)
instance.setSecurityRealm(hudsonRealm)
 
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
 
Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)