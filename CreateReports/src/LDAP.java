import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.*;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

public class LDAP {

    private static final String initialContextFactory = "com.sun.jndi.ldap.LdapCtxFactory";
    private static final String providerUrl = "ldap://ldap.technikum-wien.at:389";
    private static final String securityAuthentication = "none";

    private DirContext ctx = null;
    private Map<String, String> userMap = new HashMap<>();

    public LDAP() throws Exception {
        ctx = initLdapContext();
    }

    private DirContext initLdapContext() throws Exception {
        Hashtable env = new Hashtable();

        env.put(Context.INITIAL_CONTEXT_FACTORY, initialContextFactory);
        env.put(Context.PROVIDER_URL, providerUrl);
        env.put(Context.SECURITY_AUTHENTICATION, securityAuthentication);

        return new InitialDirContext(env);
    }

    public String resolveUser(String userId) throws Exception {
        String name = "ou=People,dc=technikum-wien,dc=at";
        String filter = "uid=" + userId;
        SearchControls ctrl = new SearchControls();
        ctrl.setSearchScope(SearchControls.SUBTREE_SCOPE);

        NamingEnumeration answer = ctx.search(name, filter, ctrl);

        SearchResult result = (SearchResult) answer.next();
        Attributes attributes = result.getAttributes();
        String userName = attributes.get("cn").get(0).toString();

        userMap.put(userId, userName);
        return userName;
    }
}
