import com.sun.org.apache.xpath.internal.res.XPATHErrorResources;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import java.io.*;
import java.nio.file.Files;
import java.sql.*;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import static java.nio.charset.StandardCharsets.UTF_8;
import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

public class SQL {

    private static final String selectFromUebungen = "SELECT \"Timestamp\", \"Fach\", \"Uebung\", \"User\", \"Tests\", \"Succeeded\", \"Errors\", \"Failed\", \"Credits\", \"Repository\", \"UnitTestFile\", \"cmLinesOfCode\", \"cmCyclomaticComplexity\", \"qmMemErrors\", \"ProgrammingLanguage\", \"Custom1\", \"Custom2\", \"Custom3\", \"Custom4\", \"Custom5\", \"GroupOwner\" FROM dbo.\"rptUebungen\"  WHERE \"Timestamp\" >= ? ORDER BY \"Fach\", \"Uebung\", \"User\"";
    private static final String selectFromExam = "SELECT \"Timestamp\", \"Fach\", \"Uebung\", \"User\", \"Tests\", \"Succeeded\", \"Errors\", \"Failed\", \"Credits\" FROM dbo.\"rptExam\" WHERE \"Timestamp\" >= ?";
    private static final String insertIntoUnittestResult = "{call dbo.\"store_unittest_result\"(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
    private static final String connectionString = "jdbc:postgresql://127.0.0.1:5432/FH";

    private Connection connection;
    private LDAP ldap;

    public SQL() throws Exception{
        initSQLConnection();
        ldap = new LDAP();
    }

    private void initSQLConnection() throws Exception {
        connection = DriverManager.getConnection(connectionString, "postgres", "admin");
    }

    public void rptUebungen() throws Exception {
        PreparedStatement statement = connection.prepareStatement(selectFromUebungen);
        statement.setDate(1, new Date(Calendar.getInstance().getTime().getTime() - TimeUnit.DAYS.toMillis(365)));
        ResultSet resultSet = statement.executeQuery();

        String fileName = null;

        while(resultSet.next()) {
            if(fileName == null) {
                fileName = resultSet.getString(1) + "\\" + resultSet.getString(1) + "-" + resultSet.getString(2) + ".csv";
                System.out.println(fileName);
            }
            String row =
                    getDate(resultSet) + "," + //Date
                    getGroupOwner(resultSet) + "," +
                    getUserName(resultSet) + "," +
                    "\"" + getName(resultSet) + "\"" + "," +
                    getEmail(resultSet) + "," +
                    "\"" + getDisplayName(resultSet) + "\"" + "," +
                    getTests(resultSet) + "," +
                    getSucceeded(resultSet) + "," +
                    getErrors(resultSet) + "," +
                    getFailed(resultSet) + "," +
                    getCredits(resultSet) + "," +
                    getRepository(resultSet) + "," +
                    "\"" + getUnitTestFile(resultSet)  + "\"" + "," +
                    getProgrammingLanguage(resultSet) + "," +
                    getCmLinesOfCode(resultSet) + "," +
                    getCmCyclomaticComplexity(resultSet) + "," +
                    getQmMemErrors(resultSet) + "," +
                    getCustom1(resultSet) + "," +
                    getCustom2(resultSet) + "," +
                    getCustom3(resultSet) + "," +
                    getCustom4(resultSet) + "," +
                    getCustom5(resultSet);
            System.out.println(row);
        }

        resultSet.close();
        statement.close();
    }

    public void rptExam() throws Exception {
        PreparedStatement statement = connection.prepareStatement(selectFromExam);
        statement.setDate(1, new Date(Calendar.getInstance().getTime().getTime() - TimeUnit.DAYS.toMillis(365)));
        ResultSet resultSet = statement.executeQuery();

        String fileName = null;

        while(resultSet.next()) {
            if(fileName == null) {
                fileName = resultSet.getString(1) + "\\" + resultSet.getString(1) + "-" + "Exam" + ".csv";
                System.out.println(fileName);
            }
            String row =
                    getDate(resultSet) + "," + //Date
                    getGroupOwner(resultSet) + "," +
                    getUserName(resultSet) + "," +
                    "\"" + getName(resultSet) + "\"" + "," +
                    getEmail(resultSet) + "," +
                    "\"" + getDisplayName(resultSet) + "\"" + "," +
                    getTests(resultSet) + "," +
                    getSucceeded(resultSet) + "," +
                    getErrors(resultSet) + "," +
                    getFailed(resultSet) + "," +
                    getCredits(resultSet);
            System.out.println(row);
        }

        resultSet.close();
        statement.close();
    }

    public void rptResults() throws Exception {
        CallableStatement statement = connection.prepareCall(insertIntoUnittestResult);

        //String nameParts[] = System.getenv("JOB_NAME").split("-");
        String nameParts[] = "BID-WS18-GPR1-kirchhof".split("-");
        String course = nameParts[0] + "-" + nameParts[1] + "-" + nameParts[3];
        String user = nameParts[3];
        //String repository = System.getenv("JOB_NAME");
        String repository = "BID-WS18-GPR1-kirchhof";
        //String uebung = System.getenv("UEB");
        String uebung = "CUEB01_A";

        System.out.println(System.getProperty("user.dir"));

        File currentDir = new File(".");
        List<File> folders = Arrays.asList(currentDir.listFiles());
        folders = folders.stream().filter(file -> file.isDirectory() && (file.getName().equals("junit-out") || file.getName().equals("nunit-out") || file.getName().equals("custom-tests-out"))).collect(Collectors.toList());

        for(File folder : folders) {
            for(File file : folder.listFiles()) {
                if(file.getName().startsWith("results-") && file.getName().endsWith(".xml")) {
                    if(uebung == null) {
                        uebung = file.getName().substring(8, file.getName().length() - 4);
                    }

                    File original = new File(file.getName() + ".original");
                    Files.copy(file.toPath(), original.toPath(), REPLACE_EXISTING);
                    Files.write(file.toPath(), replaceASCIIControlCharacters(new String(Files.readAllBytes(original.toPath()), UTF_8)).getBytes(UTF_8));

                    FileInputStream fileInputStream = new FileInputStream(file);
                    DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
                    DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
                    Document document = documentBuilder.parse(fileInputStream);
                    XPath xpath = XPathFactory.newInstance().newXPath();

                    List<XPathExpression> expressions = Arrays.asList(xpath.compile("//testsuite"), xpath.compile("//test-results"), xpath.compile("//testsuites"));
                    Node node = null;

                    for(XPathExpression expression : expressions) {
                        if(expression.evaluate(document, XPathConstants.NODE) != null) {
                            node = (Node) expression.evaluate(document, XPathConstants.NODE);
                            break;
                        }
                    }

                    String nodeName = node.getNodeName();

                    XPathExpression totalExpression = xpath.compile("//" + nodeName + "/@total");
                    XPathExpression testsExpression = xpath.compile("//" + nodeName + "/@tests");

                    Integer tests = Integer.parseInt(totalExpression.evaluate(document) != "" ? totalExpression.evaluate(document) : "0") + Integer.parseInt(testsExpression.evaluate(document) != "" ? testsExpression.evaluate(document) : "0");
                    XPathExpression errorsExpression = xpath.compile("//" + nodeName + "/@errors");
                    Integer errors = Integer.parseInt(errorsExpression.evaluate(document));
                    XPathExpression failuresExpression = xpath.compile("//" + nodeName + "/@failures");
                    Integer failures = Integer.parseInt(failuresExpression.evaluate(document));
                    Integer succeeded = tests - errors - failures;

                    //https://stackoverflow.com/questions/19721238/callablestatement-with-parameter-names-on-postgresql
                    statement.setString(1, course);
                    statement.setString(2, user);
                    statement.setString(3, uebung);
                    statement.setString(4, repository);

                    statement.setInt(5, tests);
                    statement.setInt(6, succeeded);
                    statement.setInt(7, failures);
                    statement.setInt(8, errors);
                    statement.setInt(9, 0);

                    statement.setString(10, file.getName());
                    statement.setInt(11, Integer.parseInt(System.getenv("cmLinesOfCode") != null ? System.getenv("cmLinesOfCode") : "0"));
                    statement.setInt(12, Integer.parseInt(System.getenv("cmCyclomaticComplexity") != null ? System.getenv("cmCyclomaticComplexity") : "0"));
                    statement.setInt(13, Integer.parseInt(System.getenv("qmMemErrors") != null ? System.getenv("qmMemErrors") : "0"));

                    statement.setString(14, System.getenv("ProgrammingLanguage") != null ? System.getenv("ProgrammingLanguage") : "");
                    statement.setString(15, System.getenv("Custom1") != null ? System.getenv("Custom1") : "");
                    statement.setString(16, System.getenv("Custom2") != null ? System.getenv("Custom2") : "");
                    statement.setString(17, System.getenv("Custom3") != null ? System.getenv("Custom2") : "");
                    statement.setString(18, System.getenv("Custom4") != null ? System.getenv("Custom4") : "");
                    statement.setString(19, System.getenv("Custom5") != null ? System.getenv("Custom5") : "");

                    statement.executeQuery();
                }
            }
        }

        statement.close();
    }

    private String getDate(ResultSet resultSet) throws Exception {
        return resultSet.getDate(1).toString();
    }

    private String getGroupOwner(ResultSet resultSet) throws Exception {
        return resultSet.getString(21);
    }

    private String getUserName(ResultSet resultSet) throws Exception {
        return resultSet.getString(4);
    }

    private String getName(ResultSet resultSet) throws Exception {
        return ldap.resolveUser(getUserName(resultSet));
    }

    private String getEmail(ResultSet resultSet) throws Exception {
        return getUserName(resultSet) + "@technikum-wien.at";
    }

    private String getDisplayName(ResultSet resultSet) throws Exception {
        return getName(resultSet) + " " + "(" + getUserName(resultSet) + ")";
    }

    private int getTests(ResultSet resultSet) throws Exception {
        return resultSet.getInt(5);
    }

    private int getSucceeded(ResultSet resultSet) throws Exception {
        return resultSet.getInt(6);
    }

    private int getErrors(ResultSet resultSet) throws Exception {
        return resultSet.getInt(7);
    }

    private int getFailed(ResultSet resultSet) throws Exception {
        return resultSet.getInt(8);
    }

    private int getCredits(ResultSet resultSet) throws Exception {
        return resultSet.getInt(9);
    }

    private String getRepository(ResultSet resultSet) throws Exception {
        return resultSet.getString(10);
    }

    private String getUnitTestFile(ResultSet resultSet) throws Exception {
        return resultSet.getString(11);
    }

    private String getProgrammingLanguage(ResultSet resultSet) throws Exception {
        return resultSet.getString(15);
    }

    private int getCmLinesOfCode(ResultSet resultSet) throws Exception {
        return resultSet.getInt(12);
    }

    private int getCmCyclomaticComplexity(ResultSet resultSet) throws Exception {
        return resultSet.getInt(13);
    }

    private int getQmMemErrors(ResultSet resultSet) throws Exception {
        return resultSet.getInt(14);
    }

    private String getCustom1(ResultSet resultSet) throws Exception {
        return resultSet.getString(16);
    }

    private String getCustom2(ResultSet resultSet) throws Exception {
        return resultSet.getString(17);
    }

    private String getCustom3(ResultSet resultSet) throws Exception {
        return resultSet.getString(18);
    }

    private String getCustom4(ResultSet resultSet) throws Exception {
        return resultSet.getString(19);
    }

    private String getCustom5(ResultSet resultSet) throws Exception {
        return resultSet.getString(20);
    }

    private String replaceASCIIControlCharacters(String content) {
        content = content.replaceAll(String.valueOf((char) 1), "SOH");
        content = content.replaceAll(String.valueOf((char) 2), "STX");
        content = content.replaceAll(String.valueOf((char) 3), "ETX");
        content = content.replaceAll(String.valueOf((char) 4), "EOT");
        content = content.replaceAll(String.valueOf((char) 5), "ENQ");
        content = content.replaceAll(String.valueOf((char) 6), "ACK");
        content = content.replaceAll(String.valueOf((char) 7), "BEL");
        content = content.replaceAll(String.valueOf((char) 8), "BS");
        content = content.replaceAll(String.valueOf((char) 9), "TAB");
        content = content.replaceAll(String.valueOf((char) 11), "VT");
        content = content.replaceAll(String.valueOf((char) 12), "FF");
        content = content.replaceAll(String.valueOf((char) 14), "SO");
        content = content.replaceAll(String.valueOf((char) 15), "SI");
        content = content.replaceAll(String.valueOf((char) 16), "DLE");
        content = content.replaceAll(String.valueOf((char) 17), "DC1");
        content = content.replaceAll(String.valueOf((char) 18), "DC2");
        content = content.replaceAll(String.valueOf((char) 19), "DC3");
        content = content.replaceAll(String.valueOf((char) 20), "DC4");
        content = content.replaceAll(String.valueOf((char) 21), "NAK");
        content = content.replaceAll(String.valueOf((char) 22), "SYN");
        content = content.replaceAll(String.valueOf((char) 23), "ETB");
        content = content.replaceAll(String.valueOf((char) 24), "CAN");
        content = content.replaceAll(String.valueOf((char) 25), "EM");
        content = content.replaceAll(String.valueOf((char) 26), "SUB");
        content = content.replaceAll(String.valueOf((char) 27), "ESC");
        content = content.replaceAll(String.valueOf((char) 28), "FS");
        content = content.replaceAll(String.valueOf((char) 29), "GS");
        content = content.replaceAll(String.valueOf((char) 30), "RS");
        content = content.replaceAll(String.valueOf((char) 31), "US");

        return content;
    }
}
