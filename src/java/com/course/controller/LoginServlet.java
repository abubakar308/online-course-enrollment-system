package com.course.controller;

import com.course.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        try (Connection con = DBConnection.getConnection()) {
            // Select all columns to ensure we get name, id, and role
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, email);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Store user details in session for application-wide use
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute("username", rs.getString("name"));

                        // CRITICAL: Capture the role from your database
                        session.setAttribute("role", rs.getString("role"));

                        response.sendRedirect("dashboard.jsp");
                        return;
                    }
                }
            }
            // If no user found, redirect back with error message
            response.sendRedirect("index.jsp?error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=server");
        }
    }
}
