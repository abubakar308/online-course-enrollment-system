<%@page import="java.sql.*, com.course.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role"); 
    String username = (String) session.getAttribute("username");
    if (userId == null) { response.sendRedirect("index.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile | <%= username %></title>
    <style>
        :root { --primary: #3498db; --dark: #2c3e50; --bg: #f0f2f5; --white: #ffffff; }
        body { display: flex; min-height: 100vh; background: var(--bg); margin: 0; font-family: 'Segoe UI', sans-serif; }
        .sidebar { width: 260px; background: var(--dark); color: white; display: flex; flex-direction: column; position: fixed; height: 100vh; }
        .sidebar-header { padding: 30px 20px; text-align: center; background: #1a252f; font-size: 22px; font-weight: bold; }
        .sidebar-menu { flex: 1; padding: 20px 0; }
        .menu-item { padding: 15px 25px; display: block; color: #bdc3c7; text-decoration: none; }
        .menu-item.active { background: #34495e; color: white; border-left: 4px solid var(--primary); }
        .main-content { flex: 1; margin-left: 260px; padding: 40px; display: flex; justify-content: center; }
        .profile-card { background: var(--white); width: 100%; max-width: 500px; padding: 40px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); text-align: center; height: fit-content; }
        .avatar { width: 100px; height: 100px; background: var(--primary); color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 40px; margin: 0 auto 20px; }
        .info-row { text-align: left; padding: 15px 0; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; }
        .badge { background: #e1f5fe; color: #0288d1; padding: 4px 12px; border-radius: 15px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">PORTAL</div>
        <nav class="sidebar-menu">
            <a href="dashboard.jsp" class="menu-item">📊 Dashboard</a>
            <% if("student".equals(role)) { %><a href="myEnrollment.jsp" class="menu-item">✅ My Enrollments</a><% } %>
            <a href="profile.jsp" class="menu-item active">👤 My Profile</a>
            <% if("admin".equals(role)) { %><a href="manageCourses.jsp" class="menu-item">🛠 Manage Courses</a><% } %>
            <div style="margin-top: auto; padding-bottom: 20px;"><a href="logout.jsp" class="menu-item" style="color: #e74c3c;">🚪 Logout</a></div>
        </nav>
    </div>

    <div class="main-content">
        <div class="profile-card">
            <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
            <h2 style="margin: 0;"><%= username %></h2>
            <span class="badge"><%= role %></span>
            <div style="margin-top: 30px;">
                <div class="info-row"><span>User ID</span> <strong>#<%= userId %></strong></div>
                <div class="info-row"><span>Status</span> <strong style="color: #27ae60;">Active Account</strong></div>
                <div class="info-row"><span>Access Level</span> <strong><%= "admin".equals(role) ? "High (Full Control)" : "Student (Learning)" %></strong></div>
            </div>
            <button onclick="alert('Profile Editing is disabled by Admin')" style="margin-top: 30px; width: 100%; padding: 12px; background: #eee; border: none; border-radius: 8px; cursor: pointer;">Edit Settings</button>
        </div>
    </div>
</body>
</html>