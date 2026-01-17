package com.course.controller;

import com.course.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get parameters from the updated registration form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // 'student' or 'admin'

        // Default to student if role is somehow null
        if (role == null || role.isEmpty()) {
            role = "student";
        }

        try (Connection con = DBConnection.getConnection()) {

            // 1. Check if email already exists
            String checkSQL = "SELECT id FROM users WHERE email=?";
            PreparedStatement psCheck = con.prepareStatement(checkSQL);
            psCheck.setString(1, email);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                response.sendRedirect("register.jsp?msg=exists");
                return;
            }

            // 2. Insert new user with Role
            String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);
            ps.executeUpdate();

            // 3. Capture Generated ID and setup Session
            ResultSet generatedKeys = ps.getGeneratedKeys();
            if (generatedKeys.next()) {
                int userId = generatedKeys.getInt(1);
                HttpSession session = request.getSession();
                
                // Store essential data in session for dashboard use
                session.setAttribute("userId", userId);
                session.setAttribute("username", name);
                session.setAttribute("role", role); 
            }

            // Redirect to dashboard where the sidebar will now show links based on role
            response.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?msg=error");
        }
    }
}