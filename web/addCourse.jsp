<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security: Only allow Admin to access this page
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Course | Admin Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-page">

    <div class="container">
        <div style="text-align: center; margin-bottom: 20px;">
            <span style="color: #27ae60; font-weight: bold; font-size: 12px; text-transform: uppercase;">Management</span>
            <h2 style="margin-top: 5px;">Create New Course</h2>
        </div>

        <%-- Dynamic Message Handling --%>
        <% if("error".equals(request.getParameter("status"))) { %>
            <div class="error-box" style="border-left-color: #e74c3c;">
                ❌ Failed to add course. Please try again.
            </div>
        <% } %>

        <form action="AddCourseServlet" method="POST">
            <label>Course Title</label>
            <input type="text" name="title" placeholder="e.g. Advanced Java Programming" required>

            <label>Instructor Name</label>
            <input type="text" name="instructor" placeholder="e.g. Dr. Smith" required>

            <label>Available Seats</label>
            <input type="number" name="seats" min="1" placeholder="e.g. 50" required>

            <button type="submit" style="background: #27ae60;">Publish Course</button>
            
            <div class="link-text">
                <a href="manageCourses.jsp" style="color: #7f8c8d;">&larr; Cancel and Return</a>
            </div>
        </form>
    </div>

</body>
</html>