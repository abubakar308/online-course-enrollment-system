<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Course Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-page">
    <div class="container">
        <h2>Welcome Back</h2>
        
        <% if("invalid".equals(request.getParameter("error"))) { %>
            <div class="error-box">Invalid Email or Password. Please try again.</div>
        <% } %>

        <form action="LoginServlet" method="POST">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="name@example.com" required>
            
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter your password" required>
            
            <button type="submit">Sign In</button>
        </form>

        <div class="link-text">
            Don't have an account? <a href="register.jsp">Create one for free</a>
        </div>
    </div>
</body>
</html>