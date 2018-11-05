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

def projectRoleCoOwnerNoSid = "CoOwnerNoSid";
def projectRoleOwnerNoSid = "OwnerNoSid";
def projectRoleAnonymous = "projectAnonymous";

def globalRoleAdmin = "admin";
def globalRole = "globalAnonymous";

def instance = Jenkins.getInstance();

RoleBasedAuthorizationStrategy roleBasedAuthenticationStrategy = new RoleBasedAuthorizationStrategy();
instance.setAuthorizationStrategy(roleBasedAuthenticationStrategy);

Constructor[] constrs = Role.class.getConstructors();
for (Constructor<?> c : constrs) {
	c.setAccessible(true);
}

// Make the method assignRole accessible
Method assignRoleMethod = RoleBasedAuthorizationStrategy.class.getDeclaredMethod("assignRole", String.class, Role.class, String.class);
assignRoleMethod.setAccessible(true);

//Create CoOwnerNoSid set of permissions
Set<Permission> coOwnerNoSidPermissions = new HashSet<Permission>();
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Read"));
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Cancel"));
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Workspace"));
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Build"));
coOwnerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Discover"));

Role coOwnerNoSidRole = new Role(projectRoleCoOwnerNoSid, coOwnerNoSidPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.PROJECT, coOwnerNoSidRole);

roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.PROJECT, coOwnerNoSidRole, "authenticated");

//Create OwnerNoSid set of permissions
Set<Permission> ownerNoSidPermissions = new HashSet<Permission>();
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Read"));
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Cancel"));
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Workspace"));
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Build"));
ownerNoSidPermissions.add(Permission.fromId("hudson.model.Item.Discover"));

Role ownerNoSidRole = new Role(projectRoleOwnerNoSid, ownerNoSidPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.PROJECT, ownerNoSidRole);

roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.PROJECT, ownerNoSidRole, "authenticated");

//Create projectAnonymous set of permissions
Set<Permission> projectAnonymousPermissions = new HashSet<Permission>();
projectAnonymousPermissions.add(Permission.fromId("hudson.model.Item.Read"));
projectAnonymousPermissions.add(Permission.fromId("hudson.model.Item.Discover"));

Role projectAnonymousRole = new Role(projectRoleAnonymous, projectAnonymousPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.PROJECT, projectAnonymousRole);

roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.PROJECT, projectAnonymousRole, "anonymous");

//Create admin set of permissions
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

Role adminRole = new Role(projectRoleAnonymous, adminPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.GLOBAL, adminRole);

roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.GLOBAL, adminRole, "kirchhof");

//Create globalAnonymous set of permissions
Set<Permission> globalAnonymousPermissions = new HashSet<Permission>();
globalAnonymousPermissions.add(Permission.fromId("hudson.model.Item.Read"));
globalAnonymousPermissions.add(Permission.fromId("hudson.model.Item.Discover"));

Role globalAnonymousRole = new Role(projectRoleAnonymous, globalAnonymousPermissions);
roleBasedAuthenticationStrategy.addRole(RoleBasedAuthorizationStrategy.GLOBAL, globalAnonymousRole);

roleBasedAuthenticationStrategy.assignRole(RoleBasedAuthorizationStrategy.GLOBAL, globalAnonymousRole, "anonymous");

instance.save();