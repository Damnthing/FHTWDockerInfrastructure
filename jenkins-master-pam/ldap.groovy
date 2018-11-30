import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.*
import hudson.util.Secret

// ldap configuration
String ldap_server = 'ldap.technikum-wien.at:389';
String ldap_rootDN = 'dc=technikum-wien,dc=at';
String ldap_userSearchBase = 'ou=People';
String ldap_userSearch = 'uid={0}';
String ldap_groupSearchBase = '';
String ldap_managerPassword = '';
boolean ldap_inhibitInferRootDN = false;
boolean ldap_disableMailAddressResolver = false;
String ldap_displayNameAttributeName = 'cn';
String ldap_mailAddressAttributeName = 'mail';

// get jenkins instance
def instance = Jenkins.getInstance();

// create the realm
def ldapRealm = new LDAPSecurityRealm(
	ldap_server, //String server
	ldap_rootDN, //String rootDN
	ldap_userSearchBase, //String userSearchBase
	ldap_userSearch, //String userSearch
	(String)null, //String groupSearchBase
	(String)null, //String groupSearchFilter
	null, //LDAPGroupMembershipStrategy groupMembershipStrategy
	(String)null, //String managerDN
	Secret.fromString(ldap_managerPassword), //Secret managerPasswordSecret
	ldap_inhibitInferRootDN, //boolean inhibitInferRootDN
	ldap_disableMailAddressResolver, //boolean disableMailAddressResolver
	null, //CacheConfiguration cache
	null, //EnvironmentProperty[] environmentProperties
	ldap_displayNameAttributeName, //String displayNameAttributeName
	ldap_mailAddressAttributeName, //String mailAddressAttributeName
	IdStrategy.CASE_INSENSITIVE, //IdStrategy userIdStrategy
	IdStrategy.CASE_INSENSITIVE //IdStrategy groupIdStrategy >> defaults
);

// set the realm
instance.setSecurityRealm(ldapRealm);

// save the instance
instance.save();
