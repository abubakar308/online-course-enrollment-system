<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Course Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-page">
    <div class="container">
        <h2>Join the Portal</h2>      
        <% 
            String msg = request.getParameter("msg");
            if("exists".equals(msg)) { %>
                <div class="error-box">Email already exists! Try logging in.</div>
            <% } else if("error".equals(msg)) { %>
                <div class="error-box">Registration failed! Check your details.</div>
        <% } %>

        <form action="RegisterServlet" method="POST">
            <label>Full Name</label>
            <input type="text" name="name" placeholder="John Doe" required>
            
            <label>Email Address</label>
            <input type="email" name="email" placeholder="name@example.com" required>
            
            <label>Password</label>
            <input type="password" name="password" placeholder="Min. 6 characters" required minlength="6">
            
            <button type="submit">Create Account</button>
        </form>

        <div class="link-text">
            Already have an account? <a href="index.jsp">Sign in here</a>
        </div>
    </div>
</body>
</html>