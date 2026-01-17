package com.course.controller;

import com.course.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateCourseServlet")
public class UpdateCourseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String instructor = request.getParameter("instructor");
        int seats = Integer.parseInt(request.getParameter("seats"));

        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE courses SET title=?, instructor=?, seats=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, instructor);
            ps.setInt(3, seats);
            ps.setInt(4, id);
            
            ps.executeUpdate();
            response.sendRedirect("manageCourses.jsp?msg=updated");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageCourses.jsp?error=update_failed");
        }
    }
}