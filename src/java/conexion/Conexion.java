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
    private static final String PASSWORD = "";

    public static Connection conectar() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // Driver no cargado en classpath, se usará respaldo en memoria
            return null;
        }

        try {
            return DriverManager.getConnection(URL_3307, USER, PASSWORD);
        } catch (SQLException e1) {
            try {
                return DriverManager.getConnection(URL_3306, USER, PASSWORD);
            } catch (SQLException e2) {
                return null;
            }
        }
    }
}
