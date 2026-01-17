package com.course.controller;

import com.course.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UnenrollServlet")
public class UnenrollServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String courseIdStr = request.getParameter("courseId");

        if (userId == null || courseIdStr == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            int courseId = Integer.parseInt(courseIdStr);

            // 1. Delete enrollment
            String deleteSql = "DELETE FROM enrollments WHERE user_id = ? AND course_id = ?";
            PreparedStatement ps1 = con.prepareStatement(deleteSql);
            ps1.setInt(1, userId);
            ps1.setInt(2, courseId);
            ps1.executeUpdate();

            // 2. Return seat to course
            String updateSql = "UPDATE courses SET seats = seats + 1 WHERE id = ?";
            PreparedStatement ps2 = con.prepareStatement(updateSql);
            ps2.setInt(1, courseId);
            ps2.executeUpdate();

            con.commit();
            response.sendRedirect("myEnrollments.jsp?msg=unrolled");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myEnrollments.jsp?error=true");
        }
    }
}