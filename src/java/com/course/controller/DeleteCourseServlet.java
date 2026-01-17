package com.course.controller;

import com.course.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteCourseServlet")
public class DeleteCourseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get the ID from the URL (e.g., DeleteCourseServlet?id=5)
        String courseIdStr = request.getParameter("id");
        
        // 2. Security Check: Only Admin can delete
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        if (courseIdStr != null) {
            int courseId = Integer.parseInt(courseIdStr);

            try (Connection con = DBConnection.getConnection()) {
                // START TRANSACTION: Useful if you need to delete enrollments first
                con.setAutoCommit(false);

                try {
                    // 3. Optional: Delete related enrollments first to avoid Foreign Key errors
                    String deleteEnrollments = "DELETE FROM enrollments WHERE course_id = ?";
                    PreparedStatement ps1 = con.prepareStatement(deleteEnrollments);
                    ps1.setInt(1, courseId);
                    ps1.executeUpdate();

                    // 4. Delete the actual course
                    String deleteCourse = "DELETE FROM courses WHERE id = ?";
                    PreparedStatement ps2 = con.prepareStatement(deleteCourse);
                    ps2.setInt(1, courseId);
                    ps2.executeUpdate();

                    con.commit(); // Save changes
                    response.sendRedirect("manageCourses.jsp?msg=deleted");

                } catch (SQLException e) {
                    con.rollback(); // Undo if something goes wrong
                    throw e;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("manageCourses.jsp?error=delete_failed");
            }
        }
    }
}