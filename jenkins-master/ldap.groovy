import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.*
import hudson.util.Secret

String ldap_server = 'ldap.technikum-wien.at:389'
String ldap_rootDN = 'dc=technikum-wien,dc=at'
String ldap_userSearchBase = 'ou=People'
String ldap_userSearch = 'uid={0}'
String ldap_groupSearchBase = ''
String ldap_managerPassword = '{AQAAABAAAAAQ5yEQuh/4XgviVu8SU0ARoaabXFRlyUMSTaAZUn+pt2I=}'
boolean ldap_inhibitInferRootDN = false
b ldap_disableMailAddressResolver = false
String ldap_displayNameAttributeName = 'cn'
String ldap_mailAddressAttributeName = 'mail'

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
)

instance.setSecurityRealm(ldapRealm)

// Save the state
instance.save()