<%@page import="java.sql.*, com.course.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="css/style.css">
    <title>Course Dashboard</title>
    <style>.container { max-width: 800px; }</style>
</head>
<body>
    <div class="container">
        <h2>Available Courses</h2>
        <table>
            <tr>
                <th>Course Title</th>
                <th>Instructor</th>
                <th>Available Seats</th>
                <th>Action</th>
            </tr>
            <%
                try (Connection con = DBConnection.getConnection()) {
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery("SELECT * FROM courses");
                    while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("instructor") %></td>
                <td><%= rs.getInt("seats") %></td>
                <td>
                    <form action="EnrollServlet" method="POST">
                        <input type="hidden" name="courseId" value="<%= rs.getInt("id") %>">
                        <button type="submit" style="padding: 5px 10px; font-size: 12px;">Enroll</button>
                    </form>
                </td>
            </tr>
            <%      }
                } catch(Exception e) { e.printStackTrace(); }
            %>
        </table>
    </div>
</body>
</html>