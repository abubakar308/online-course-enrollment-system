<%@page import="java.sql.Connection"%>
<%@page import="com.course.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>DB Test</title>
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <div style="margin: 50px; padding: 20px; border: 1px solid #ccc;">
            <h2>Database Connection Test</h2>
            <%
                try {
                    // This calls the connection logic you wrote earlier
                    Connection con = DBConnection.getConnection();
                    if (con != null) {
                        out.println("<h3 style='color:green;'>SUCCESS: Connected to course_db!</h3>");
                        con.close();
                    }
                } catch (Exception e) {
                    out.println("<h3 style='color:red;'>FAILURE: " + e.getMessage() + "</h3>");
                    e.printStackTrace(new java.io.PrintWriter(out));
                }
            %>
        </div>
    </body>
</html>