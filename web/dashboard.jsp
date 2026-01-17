<%@page import="java.sql.*, com.course.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Unified Session Check
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role"); 
    String username = (String) session.getAttribute("username");
    
    if (userId == null) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }

    int totalCourses = 0;
    int myEnrollCount = 0;
    int totalUsers = 0;

    try (Connection con = DBConnection.getConnection()) {
        // Fetch Stats
        ResultSet rs1 = con.createStatement().executeQuery("SELECT COUNT(*) FROM courses");
        if(rs1.next()) totalCourses = rs1.getInt(1);

        if("student".equals(role)) {
            PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM enrollments WHERE user_id = ?");
            ps2.setInt(1, userId);
            ResultSet rs2 = ps2.executeQuery();
            if(rs2.next()) myEnrollCount = rs2.getInt(1);
        } else if("admin".equals(role)) {
            ResultSet rsUsers = con.createStatement().executeQuery("SELECT COUNT(*) FROM users");
            if(rsUsers.next()) totalUsers = rsUsers.getInt(1);
        }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard | Learning Portal</title>
    <style>
        :root { --primary: #3498db; --dark: #2c3e50; --bg: #f0f2f5; --white: #ffffff; --success: #27ae60; --danger: #e74c3c; --disabled: #bdc3c7; }
        body { display: flex; min-height: 100vh; background: var(--bg); margin: 0; font-family: 'Segoe UI', sans-serif; }
        
        .sidebar { width: 260px; background: var(--dark); color: white; display: flex; flex-direction: column; position: fixed; height: 100vh; }
        .sidebar-header { padding: 30px 20px; text-align: center; background: #1a252f; font-size: 22px; font-weight: bold; }
        .sidebar-menu { flex: 1; padding: 20px 0; }
        .menu-item { padding: 15px 25px; display: block; color: #bdc3c7; text-decoration: none; transition: 0.3s; border-left: 4px solid transparent; }
        .menu-item:hover, .menu-item.active { background: #34495e; color: white; border-left-color: var(--primary); }

        .main-content { flex: 1; margin-left: 260px; display: flex; flex-direction: column; }
        .top-nav { background: var(--white); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .role-badge { background: var(--primary); color: white; padding: 5px 15px; border-radius: 20px; font-size: 11px; font-weight: bold; text-transform: uppercase; }
        
        .content-body { padding: 40px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: var(--white); padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); text-decoration: none; color: inherit; }
        .stat-card .value { font-size: 32px; font-weight: bold; color: var(--dark); margin-top: 10px; }

        .section-card { background: var(--white); padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); }
        .course-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .course-table th { background: #f8f9fa; padding: 12px; text-align: left; border-bottom: 2px solid #eee; }
        .course-table td { padding: 15px 12px; border-bottom: 1px solid #f1f1f1; }
        
        .btn-enroll { background: var(--primary); color: white; padding: 8px 16px; text-decoration: none; border-radius: 6px; font-size: 13px; font-weight: 600; display: inline-block; }
        .btn-enrolled { background: var(--disabled); color: #7f8c8d; cursor: default; }
        .btn-full { background: #95a5a6; color: #ffffff; cursor: not-allowed; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header">COURSE HUB</div>
        <nav class="sidebar-menu">
            <a href="dashboard.jsp" class="menu-item active">📊 Dashboard</a>
            <% if("student".equals(role)) { %>
                <a href="myEnrollment.jsp" class="menu-item">✅ My Enrollments</a>
            <% } %>
            <a href="profile.jsp" class="menu-item">👤 My Profile</a>
            
            <% if("admin".equals(role)) { %>
                <hr style="border: 0.5px solid #444; margin: 15px 25px;">
                <a href="manageCourses.jsp" class="menu-item" style="color: #f1c40f;">🛠 Manage Courses</a>
                <a href="manageUsers.jsp" class="menu-item" style="color: #f1c40f;">👥 Manage Users</a>
            <% } %>
            
            <div style="margin-top: auto; padding-bottom: 20px;">
                <a href="logout.jsp" class="menu-item" style="color: #e74c3c;">🚪 Logout</a>
            </div>
        </nav>
    </div>

    <div class="main-content">
        <div class="top-nav">
            <span style="font-weight: 600;">Learning Management System</span>
            <div>
                <span style="margin-right: 10px;">Hello, <strong><%= username %></strong></span>
                <span class="role-badge"><%= role %></span>
            </div>
        </div>

        <div class="content-body">
            <div class="stats-grid">
                <div class="stat-card">
                    <h4 style="margin:0; color:#7f8c8d; font-size:14px;">TOTAL COURSES</h4>
                    <div class="value"><%= totalCourses %></div>
                </div>
                <% if("student".equals(role)) { %>
                    <a href="myEnrollment.jsp" class="stat-card">
                        <h4 style="margin:0; color:#7f8c8d; font-size:14px;">MY ENROLLMENTS</h4>
                        <div class="value"><%= myEnrollCount %></div>
                    </a>
                <% } else { %>
                    <a href="manageUsers.jsp" class="stat-card">
                        <h4 style="margin:0; color:#7f8c8d; font-size:14px;">TOTAL USERS</h4>
                        <div class="value"><%= totalUsers %></div>
                    </a>
                <% } %>
            </div>

            <div class="section-card">
                <h3 style="margin-top:0;">Available Courses</h3>
                <table class="course-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Instructor</th>
                            <th>Available Seats</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            ResultSet rsCourses = con.createStatement().executeQuery("SELECT * FROM courses");
                            while(rsCourses.next()) {
                                int courseId = rsCourses.getInt("id");
                                int seats = rsCourses.getInt("seats");
                                boolean isEnrolled = false;

                                if ("student".equals(role)) {
                                    PreparedStatement psCheck = con.prepareStatement(
                                        "SELECT 1 FROM enrollments WHERE user_id = ? AND course_id = ?");
                                    psCheck.setInt(1, userId);
                                    psCheck.setInt(2, courseId);
                                    ResultSet rsCheck = psCheck.executeQuery();
                                    if(rsCheck.next()) isEnrolled = true;
                                }
                        %>
                        <tr>
                            <td>#<%= courseId %></td>
                            <td><strong><%= rsCourses.getString("title") %></strong></td>
                            <td><%= rsCourses.getString("instructor") %></td>
                            <td>
                                <% if(seats > 0) { %>
                                    <span style="color: var(--success); font-weight: 600;"><%= seats %> Seats Left</span>
                                <% } else { %>
                                    <span style="color: var(--danger); font-weight: 600;">Full</span>
                                <% } %>
                            </td>
                            <td>
                                <% if("student".equals(role)) { %>
                                    <% if(isEnrolled) { %>
                                        <span class="btn-enroll btn-enrolled">Enrolled</span>
                                    <% } else if(seats > 0) { %>
                                        <a href="EnrollServlet?courseId=<%= courseId %>" class="btn-enroll">Enroll</a>
                                    <% } else { %>
                                        <span class="btn-enroll btn-full">Course Full</span>
                                    <% } %>
                                <% } else { %>
                                    <a href="editCourse.jsp?id=<%= courseId %>" style="color:var(--primary); font-weight:600;">Edit</a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
<%
    } catch (Exception e) { 
        out.println("<div style='padding:40px; color:red;'>Error: " + e.getMessage() + "</div>"); 
    }
%>
</body>
</html>