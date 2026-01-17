<%@page import="java.sql.*, com.course.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security: Only Admins can edit courses
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) { 
        response.sendRedirect("dashboard.jsp"); 
        return; 
    }

    String id = request.getParameter("id");
    if (id == null) { response.sendRedirect("manageCourses.jsp"); return; }

    String title = "", instructor = "";
    int seats = 0;

    try (Connection con = DBConnection.getConnection()) {
        String sql = "SELECT * FROM courses WHERE id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(id));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            instructor = rs.getString("instructor");
            seats = rs.getInt("seats");
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Course | Admin</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-page"> <%-- Using auth-page class to center the card --%>
    <div class="container">
        <div style="text-align: center; margin-bottom: 20px;">
            <span style="color: var(--primary); font-weight: bold; font-size: 12px; text-transform: uppercase;">Management Mode</span>
            <h2 style="margin-top: 5px;">Edit Course</h2>
        </div>

        <form action="UpdateCourseServlet" method="POST">
            <input type="hidden" name="id" value="<%= id %>">
            
            <label>Course Title</label>
            <input type="text" name="title" value="<%= title %>" placeholder="e.g. Java Programming" required>
            
            <label>Instructor Name</label>
            <input type="text" name="instructor" value="<%= instructor %>" placeholder="e.g. Dr. Smith" required>
            
            <label>Available Seats</label>
            <input type="number" name="seats" value="<%= seats %>" min="0" required>
            
            <button type="submit">Save Changes</button>
            
            <div class="link-text">
                <a href="manageCourses.jsp" style="color: #7f8c8d;">&larr; Back to List</a>
            </div>
        </form>
    </div>
</body>
</html>