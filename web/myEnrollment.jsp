<%@page import="java.sql.*, com.course.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role"); 
    if (userId == null || !"student".equals(role)) { 
        response.sendRedirect("dashboard.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Learning | Course Hub</title>
    <style>
        :root { --primary: #3498db; --dark: #2c3e50; --bg: #f0f2f5; --white: #ffffff; }
        body { display: flex; min-height: 100vh; background: var(--bg); margin: 0; font-family: 'Segoe UI', sans-serif; }
        
        .sidebar { width: 260px; background: var(--dark); color: white; display: flex; flex-direction: column; position: fixed; height: 100vh; }
        .sidebar-header { padding: 30px 20px; text-align: center; background: #1a252f; font-size: 22px; font-weight: bold; }
        .sidebar-menu { flex: 1; padding: 20px 0; }
        .menu-item { padding: 15px 25px; display: block; color: #bdc3c7; text-decoration: none; transition: 0.3s; border-left: 4px solid transparent; }
        .menu-item.active { background: #34495e; color: white; border-left-color: var(--primary); }
        
        .main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .top-nav { background: var(--white); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .content-body { padding: 40px; }
        
        .section-card { background: var(--white); padding: 30px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .course-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .course-table th { background: #f8f9fa; padding: 15px; text-align: left; border-bottom: 2px solid #eee; }
        .course-table td { padding: 18px 15px; border-bottom: 1px solid #f1f1f1; }
        .status-badge { background: #e8f5e9; color: #2e7d32; padding: 4px 10px; border-radius: 5px; font-size: 12px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">COURSE HUB</div>
        <nav class="sidebar-menu">
            <a href="dashboard.jsp" class="menu-item">📊 Dashboard</a>
            <a href="myEnrollment.jsp" class="menu-item active">✅ My Enrollments</a>
            <a href="profile.jsp" class="menu-item">👤 My Profile</a>
            <div style="margin-top: auto; padding-bottom: 20px;">
                <a href="logout.jsp" class="menu-item" style="color: #e74c3c;">🚪 Logout</a>
            </div>
        </nav>
    </div>

    <div class="main-content">
        <div class="top-nav">
            <span style="font-weight: 600; color: var(--dark);">My Enrolled Courses</span>
            <div>User: <strong><%= session.getAttribute("username") %></strong></div>
        </div>

        <div class="content-body">
            <div class="section-card">
                <h3>Current Learning Path</h3>
                <table class="course-table">
                    <thead>
                        <tr>
                            <th>Course Name</th>
                            <th>Instructor</th>
                            <th>Status</th>
                            <th>Enrolled On</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection con = DBConnection.getConnection()) {
                                String sql = "SELECT c.title, c.instructor, e.enroll_date FROM courses c " +
                                             "JOIN enrollments e ON c.id = e.course_id WHERE e.user_id = ?";
                                PreparedStatement ps = con.prepareStatement(sql);
                                ps.setInt(1, userId);
                                ResultSet rs = ps.executeQuery();

                                if (!rs.isBeforeFirst()) { 
                                    out.println("<tr><td colspan='4' style='text-align:center; padding:30px; color:#999;'>No enrollments found. Go to Dashboard to join a course!</td></tr>"); 
                                }

                                while(rs.next()) {
                        %>
                        <tr>
                            <td style="font-weight: 600;"><%= rs.getString("title") %></td>
                            <td><%= rs.getString("instructor") %></td>
                            <td><span class="status-badge">Active</span></td>
                            <td style="color: #7f8c8d;"><%= rs.getTimestamp("enroll_date") %></td>
                        </tr>
                        <% } } catch(Exception e) { e.printStackTrace(); } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>