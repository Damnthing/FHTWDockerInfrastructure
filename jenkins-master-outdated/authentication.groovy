import hudson.*
import hudson.model.*
import hudson.security.*
import hudson.scm.*
import jenkins.*
import jenkins.model.*
import java.util.*
import com.michelin.cio.hudson.plugins.rolestrategy.*
import com.cloudbees.plugins.credentials.CredentialsProvider.*
import com.synopsys.arc.jenkins.plugins.ownership.OwnershipPlugin.*
import java.lang.reflect.*

// define project roles
def projectRoleCoOwnerNoSid = "CoOwnerNoSid";
def projectRoleOwnerNoSid = "OwnerNoSid";
def projectRoleAnonymous = "anonymous";

// define global roles
def globalRoleAdmin = "admin";
def globalRoleAnonymous = "anonymous";

// pattern for views
def pattern = "SYS-.*|Build-Slides-.*";

// get jenkins instance
def instance = Jenkins.getInstance();

// role based authorization
RoleBasedAuthorizationStrategy roleBasedAuthenticationStrategy = new RoleBasedAuthorizationStrategy();
instance.setAuthorizationStrategy(roleBasedAuthenticationStrategy);

Constructor[] constrs = Role.class.getConstructors();
for (Constructor<?> c : constrs) {
	c.setAccessible(true);
}

// make the method assignRole accessible
Method assignRoleMethod = RoleBasedAuthorizationStrategy.class.getDeclaredMethod("assignRole", String.class, Role.class, String.class);
assignRoleMethod.setAccessible(true);

// create CoOwnerNoSid set of permissions
Set<Permission> coOwnerNoSidPermissions = new HashSet<Permission>();
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Read"));
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Cancel"));
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Workspace"));
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Build"));
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Discover"));

// create new role add and assign it
Role coOwnerNoSidRole = new Role(projectRoleCoOwnerNoSid, coOwnerNoSidPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.PROJECT, coOwnerNoSidRole);
roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.PROJECT, coOwnerNoSidRole, "authenticated");

// create OwnerNoSid set of permissions
Set<Permission> ownerNoSidPermissions = new HashSet<Permission>();
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Read"));
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Cancel"));
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Workspace"));
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Build"));
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Discover"));

// create new role add and assign it
Role ownerNoSidRole = new Role(projectRoleOwnerNoSid, ownerNoSidPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.PROJECT, ownerNoSidRole);
roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.PROJECT, ownerNoSidRole, "authenticated");

// create projectAnonymous set of permissions
Set<Permission> projectAnonymousPermissions = new HashSet<Permission>();
projectAnonymousPermissions.add(Permission.fromId("hudson.model.Item.Read"));
projectAnonymousPermissions.add(Permission.fromId("hudson.model.Item.Discover"));

// create new role add and assign it
Role projectAnonymousRole = new Role(projectRoleAnonymous, pattern, projectAnonymousPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.PROJECT, projectAnonymousRole);
roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.PROJECT, projectAnonymousRole, "anonymous");

// create admin set of permissions
Set<Permission> adminPermissions = new HashSet<Permission>();
adminPermissions.add(Permission.fromId("hudson.model.View.Delete"));
adminPermissions.add(Permission.fromId("hudson.model.Computer.Connect"));
adminPermissions.add(Permission.fromId("hudson.model.Run.Delete"));
adminPermissions.add(Permission.fromId("hudson.model.Hudson.UploadPlugins"));
adminPermissions.add(Permission.fromId("com.cloudbees.plugins.credentials.CredentialsProvider.ManageDomains"));
adminPermissions.add(Permission.fromId("hudson.model.Computer.Create"));
adminPermissions.add(Permission.fromId("hudson.model.View.Configure"));
adminPermissions.add(Permission.fromId("com.synopsys.arc.jenkins.plugins.ownership.OwnershipPlugin.Jobs"));
adminPermissions.add(Permission.fromId("hudson.model.Item.Configure"));
adminPermissions.add(Permission.fromId("hudson.model.Hudson.ConfigureUpdateCenter"));
adminPermissions.add(Permission.fromId("hudson.model.Computer.Build"));
adminPermissions.add(Permission.fromId("hudson.model.Item.Read"));
adminPermissions.add(Permission.fromId("hudson.model.Hudson.Administer"));
adminPermissions.add(Permission.fromId("hudson.model.Item.Cancel"));
adminPermissions.add(Permission.fromId("com.cloudbees.plugins.credentials.CredentialsProvider.View"));
adminPermissions.add(Permission.fromId("hudson.model.Computer.Delete"));
adminPermissions.add(Permission.fromId("hudson.model.Item.Build"));
adminPermissions.add(Permission.fromId("hudson.scm.SCM.Tag"));
adminPermissions.add(Permission.fromId("hudson.model.Item.Discover"));
adminPermissions.add(Permission.fromId("hudson.model.Hudson.Read"));
adminPermissions.add(Permission.fromId("com.cloudbees.plugins.credentials.CredentialsProvider.Update"));
adminPermissions.add(Permission.fromId("hudson.model.Item.Create"));
adminPermissions.add(Permission.fromId("hudson.model.Item.Workspace"));
adminPermissions.add(Permission.fromId("com.cloudbees.plugins.credentials.CredentialsProvider.Delete"));
adminPermissions.add(Permission.fromId("hudson.model.View.Read"));
adminPermissions.add(Permission.fromId("hudson.model.View.Create"));
adminPermissions.add(Permission.fromId("hudson.model.Hudson.RunScripts"));
adminPermissions.add(Permission.fromId("hudson.model.Item.Delete"));
adminPermissions.add(Permission.fromId("hudson.model.Computer.Configure"));
adminPermissions.add(Permission.fromId("com.cloudbees.plugins.credentials.CredentialsProvider.Create"));
adminPermissions.add(Permission.fromId("com.synopsys.arc.jenkins.plugins.ownership.OwnershipPlugin.Nodes"));
adminPermissions.add(Permission.fromId("hudson.model.Computer.Disconnect"));
adminPermissions.add(Permission.fromId("hudson.model.Run.Update"));

// create new role add and assign it
Role adminRole = new Role(globalRoleAdmin, adminPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.GLOBAL, adminRole);
roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.GLOBAL, adminRole, "TW_LKT");

// create globalAnonymous set of permissions
Set<Permission> globalAnonymousPermissions = new HashSet<Permission>();
globalAnonymousPermissions.add(Permission.fromId("hudson.model.Hudson.Read"));
globalAnonymousPermissions.add(Permission.fromId("hudson.model.Item.Discover"));

// create new role add and assign it
Role globalAnonymousRole = new Role(globalRoleAnonymous, globalAnonymousPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.GLOBAL, globalAnonymousRole);
roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.GLOBAL, globalAnonymousRole, "anonymous");

// save the instance
instance.save();
