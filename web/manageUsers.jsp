<%@page import="java.sql.*, com.course.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role"); 
    String username = (String) session.getAttribute("username");
    
    if (userId == null || !"admin".equals(role)) { 
        response.sendRedirect("dashboard.jsp?error=unauthorized"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users | Admin Portal</title>
    <style>
        :root { --primary: #3498db; --dark: #2c3e50; --bg: #f0f2f5; --white: #ffffff; --danger: #e74c3c; }
        body { display: flex; min-height: 100vh; background: var(--bg); margin: 0; font-family: 'Segoe UI', sans-serif; }
        .sidebar { width: 260px; background: var(--dark); color: white; position: fixed; height: 100vh; }
        .sidebar-header { padding: 30px 20px; text-align: center; background: #1a252f; font-weight: bold; }
        .menu-item { padding: 15px 25px; display: block; color: #bdc3c7; text-decoration: none; }
        .menu-item.active { background: #34495e; color: white; border-left: 4px solid #f1c40f; }
        .main-content { flex: 1; margin-left: 260px; padding: 40px; }
        .section-card { background: var(--white); padding: 30px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); margin-bottom: 30px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #f8f9fa; padding: 12px; text-align: left; border-bottom: 2px solid #eee; }
        td { padding: 12px; border-bottom: 1px solid #f1f1f1; }
        .badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: bold; }
        .badge-admin { background: #fff3cd; color: #856404; }
        .badge-student { background: #d1ecf1; color: #0c5460; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header">ADMIN PANEL</div>
        <a href="dashboard.jsp" class="menu-item">📊 Dashboard</a>
        <a href="manageCourses.jsp" class="menu-item">🛠 Manage Courses</a>
        <a href="manageUsers.jsp" class="menu-item active">👥 Manage Users</a>
        <a href="logout.jsp" class="menu-item" style="color: #e74c3c;">🚪 Logout</a>
    </div>

    <div class="main-content">
        <h2>User & Enrollment Management</h2>

        <div class="section-card">
            <h3 style="margin-top:0;">System Accounts</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection con = DBConnection.getConnection()) {
                            ResultSet rs = con.createStatement().executeQuery("SELECT id, name, role FROM users");
                            while(rs.next()) {
                                int uId = rs.getInt("id");
                    %>
                    <tr>
                        <td>#<%= uId %></td>
                        <td><strong><%= rs.getString("name") %></strong></td>
                        <td>
                            <span class="badge <%= rs.getString("role").equals("admin") ? "badge-admin" : "badge-student" %>">
                                <%= rs.getString("role").toUpperCase() %>
                            </span>
                        </td>
                        <td>
                            <% if (uId != userId) { %>
                                <a href="DeleteUserServlet?id=<%= uId %>" style="color:var(--danger); text-decoration:none;" onclick="return confirm('Delete user?')">Remove</a>
                            <% } else { %>
                                <small style="color:#999;">Current Session</small>
                            <% } %>
                        </td>
                    </tr>
                    <% } } catch(Exception e) { out.print(e.getMessage()); } %>
                </tbody>
            </table>
        </div>

        <div class="section-card">
            <h3 style="margin-top:0;">Active Course Enrollments</h3>
            <p style="font-size: 13px; color: #7f8c8d;">Showing which students are currently enrolled in which courses.</p>
            <table>
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Course Title</th>
                        <th>Enrollment Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection con = DBConnection.getConnection()) {
                            // This SQL joins the three tables to get the full names and titles
                            String enrollSql = "SELECT u.name, c.title, e.enroll_date " +
                                               "FROM enrollments e " +
                                               "JOIN users u ON e.user_id = u.id " +
                                               "JOIN courses c ON e.course_id = c.id " +
                                               "ORDER BY e.enroll_date DESC";
                            ResultSet rsE = con.createStatement().executeQuery(enrollSql);
                            while(rsE.next()) {
                    %>
                    <tr>
                        <td><%= rsE.getString("name") %></td>
                        <td><strong><%= rsE.getString("title") %></strong></td>
                        <td><%= rsE.getTimestamp("enroll_date") %></td>
                    </tr>
                    <% } } catch(Exception e) { out.print(e.getMessage()); } %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>