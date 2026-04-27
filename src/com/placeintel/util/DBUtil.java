package com.placeintel.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String LOCAL_URL = "jdbc:mysql://localhost:3306/placeintel_db";
    private static final String LOCAL_USER = "root";
    private static final String LOCAL_PASSWORD = "Chocolate08!";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        String dbUrl = System.getenv("JDBC_DATABASE_URL");
        if (dbUrl != null && !dbUrl.isEmpty()) {
            return DriverManager.getConnection(dbUrl);
        }
        return DriverManager.getConnection(LOCAL_URL, LOCAL_USER, LOCAL_PASSWORD);
    }
}
