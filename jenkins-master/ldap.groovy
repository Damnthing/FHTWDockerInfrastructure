import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.*

def instance = Jenkins.getInstance()

def ldapRealm = new LDAPSecurityRealm(
	ldap_server, //String server
	ldap_rootDN, //String rootDN
	ldap_userSearchBase, //String userSearchBase
	ldap_userSearch, //String userSearch
	'', //String groupSearchBase
	'', //String groupSearchFilter
	null, //LDAPGroupMembershipStrategy groupMembershipStrategy
	'', //String managerDN
	Secret.fromString(ldap_managerPassword), //Secret managerPasswordSecret
	ldap_inhibitInferRootDN, //boolean inhibitInferRootDN
	ldap_disableMailAddressResolver, //boolean disableMailAddressResolver
	null, //CacheConfiguration cache
	null, //EnvironmentProperty[] environmentProperties
	ldap_displayNameAttributeName, //String displayNameAttributeName
	ldap_mailAddressAttributeName, //String mailAddressAttributeName
	IdStrategy.CASE_INSENSITIVE, //IdStrategy userIdStrategy
	IdStrategy.CASE_INSENSITIVE //IdStrategy groupIdStrategy >> defaults
)

instance.setSecurityRealm(ldapRealm)

// Save the state
instance.save()