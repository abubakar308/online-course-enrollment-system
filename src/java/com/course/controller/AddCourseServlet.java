package com.course.controller;

import com.course.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get Form Data
        String title = request.getParameter("title");
        String instructor = request.getParameter("instructor");
        String seatsStr = request.getParameter("seats");

        // 2. Admin Security Check
        HttpSession session = request.getSession();
        if (!"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            // 3. Insert into Courses Table
            String sql = "INSERT INTO courses (title, instructor, seats) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, instructor);
            ps.setInt(3, Integer.parseInt(seatsStr));
            
            ps.executeUpdate();
            
            // 4. Success: Back to management list
            response.sendRedirect("manageCourses.jsp?msg=added");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addCourse.jsp?error=true");
        }
    }
}