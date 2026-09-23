package com.hotel.dao;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DBUtil {

    private static DataSource dataSource;

    // ============================================================
    // BACKEND SETUP REQUIRED — do this once before any DAO can connect:
    //
    // 1. In Servers/Tomcat v11.0 Server at localhost-config/context.xml,
    //    add inside <Context>:
    //
    //    <Resource name="jdbc/HotelDB" auth="Container"
    //              type="javax.sql.DataSource"
    //              driverClassName="com.mysql.cj.jdbc.Driver"
    //              url="jdbc:mysql://localhost:3306/hotel_reservation?useSSL=false&serverTimezone=UTC"
    //              username="root" password="YOUR_MYSQL_PASSWORD"
    //              maxTotal="20" maxIdle="10" maxWaitMillis="5000" />
    //
    // 2. In src/main/webapp/WEB-INF/web.xml, add inside <web-app>:
    //
    //    <resource-ref>
    //        <res-ref-name>jdbc/HotelDB</res-ref-name>
    //        <res-type>javax.sql.DataSource</res-type>
    //        <res-auth>Container</res-auth>
    //    </resource-ref>
    //
    // 3. mysql-connector-j-8.3.0.jar (already in WEB-INF/lib) is the driver.
    // 4. Create the "hotel_reservation" database and the USERS table
    //    (matching your ERD) before running anything that touches it.
    // ============================================================

    private DBUtil() { }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            try {
                Context ctx = new InitialContext();
                dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/HotelDB");
            } catch (NamingException e) {
                throw new SQLException("JNDI DataSource 'jdbc/HotelDB' not found. "
                        + "Check context.xml and web.xml (see DBUtil comments).", e);
            }
        }
        return dataSource.getConnection();
    }
}