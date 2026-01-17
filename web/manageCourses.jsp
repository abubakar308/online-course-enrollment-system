<%@page import="java.sql.*, com.course.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Unified Session Check
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role"); 
    
    if (userId == null || !"admin".equals(role)) { 
        response.sendRedirect("dashboard.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Courses | Admin</title>
    <style>
        :root { --primary: #3498db; --dark: #2c3e50; --bg: #f0f2f5; --white: #ffffff; --success: #27ae60; --danger: #e74c3c; }
        body { display: flex; min-height: 100vh; background: var(--bg); margin: 0; font-family: 'Segoe UI', sans-serif; }
        
        .sidebar { width: 260px; background: var(--dark); color: white; display: flex; flex-direction: column; position: fixed; height: 100vh; }
        .sidebar-header { padding: 30px 20px; text-align: center; background: #1a252f; font-size: 22px; font-weight: bold; }
        .sidebar-menu { flex: 1; padding: 20px 0; }
        .menu-item { padding: 15px 25px; display: block; color: #bdc3c7; text-decoration: none; transition: 0.3s; }
        .menu-item.active { background: #34495e; color: white; border-left: 4px solid #f1c40f; }

        .main-content { flex: 1; margin-left: 260px; }
        .top-nav { background: var(--white); padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .content-body { padding: 40px; }
        
        .section-card { background: var(--white); padding: 30px; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .btn-add { background: #27ae60; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; transition: 0.3s; }
        .btn-add:hover { background: #219150; }

        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f8f9fa; color: var(--dark); font-weight: 600; }
        
        .seat-badge { padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .seat-ok { background: #e8f5e9; color: #2e7d32; }
        .seat-low { background: #ffebee; color: #c62828; }
        
        .btn-delete { color: var(--danger); text-decoration: none; font-weight: bold; }
        .btn-delete:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header">ADMIN TOOLS</div>
        <nav class="sidebar-menu">
            <a href="dashboard.jsp" class="menu-item">📊 Dashboard</a>
            <a href="profile.jsp" class="menu-item">👤 My Profile</a>
            <a href="manageCourses.jsp" class="menu-item active">🛠 Manage Courses</a>
            <a href="manageUsers.jsp" class="menu-item" style="color: #f1c40f;">👥 Manage Users</a>
            
            <div style="margin-top: auto; padding-bottom: 20px;">
                <a href="logout.jsp" class="menu-item" style="color: #e74c3c;">🚪 Logout</a>
            </div>
        </nav>
    </div>

    <div class="main-content">
        <div class="top-nav">
            <span style="font-weight: 600; font-size: 18px;">Course Catalog Management</span>
            <a href="addCourse.jsp" class="btn-add">+ Create New Course</a>
        </div>

        <div class="content-body">
            <div class="section-card">
                <h3>Global Course List</h3>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Course Title</th>
                            <th>Instructor</th>
                            <th>Available Seats</th> <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection con = DBConnection.getConnection()) {
                                // SQL selects all columns including 'seats'
                                ResultSet rs = con.createStatement().executeQuery("SELECT * FROM courses ORDER BY id DESC");
                                while(rs.next()) {
                                    int seatCount = rs.getInt("seats");
                        %>
                        <tr>
                            <td>#<%= rs.getInt("id") %></td>
                            <td><strong><%= rs.getString("title") %></strong></td>
                            <td><%= rs.getString("instructor") %></td>
                            <td>
                                <span class="seat-badge <%= seatCount <= 5 ? "seat-low" : "seat-ok" %>">
                                    <%= seatCount %> Seats Remaining
                                </span>
                            </td>
                            <td>
                                <a href="editCourse.jsp?id=<%= rs.getInt("id") %>" style="color:var(--primary); margin-right: 15px; text-decoration: none; font-weight: bold;">Edit</a>
                                <a href="DeleteCourseServlet?id=<%= rs.getInt("id") %>" class="btn-delete" onclick="return confirm('Are you sure you want to delete this course?')">Delete</a>
                            </td>
                        </tr>
                        <% 
                                } 
                            } catch(Exception e) { 
                                out.println("<tr><td colspan='5' style='color:red;'>Error loading courses: " + e.getMessage() + "</td></tr>"); 
                            } 
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>