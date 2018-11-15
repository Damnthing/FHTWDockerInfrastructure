public class Main {

    public static void main(String[] args) throws Exception {
        //LDAP ldap = new LDAP();
        //System.out.println(ldap.resolveUser("kirchhof"));

        SQL sql = new SQL();
        sql.rptUebungen();
        sql.rptExam();
        sql.rptResults();
    }
}
