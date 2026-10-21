package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL_3307 =
            "jdbc:mysql://localhost:3307/bookhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";

    private static final String URL_3306 =
            "jdbc:mysql://localhost:3306/bookhub?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";

    private static final String USER = "root";
    private static final String PASSWORD = "123456789";

    public static Connection conectar() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // Driver no cargado en classpath, se usará respaldo en memoria
            return null;
        }

        String[] urls = {URL_3306, URL_3307};
        String[] passwords = {PASSWORD, ""};

        for (String url : urls) {
            for (String pass : passwords) {
                try {
                    return DriverManager.getConnection(url, USER, pass);
                } catch (SQLException ignored) {
                }
            }
        }
        return null;
    }
}
