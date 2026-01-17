package com.course.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.course.util.DBConnection;

@WebServlet("/EnrollServlet")
public class EnrollServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String courseIdStr = request.getParameter("courseId");

        // 1. Session Validation
        if (userId == null) {
            response.sendRedirect("index.jsp?error=SessionExpired");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            int courseId = Integer.parseInt(courseIdStr);

            // Start Transaction
            con.setAutoCommit(false); 

            try {
                // 2. CHECK: Already enrolled?
                String checkSql = "SELECT 1 FROM enrollments WHERE user_id = ? AND course_id = ?";
                PreparedStatement checkPs = con.prepareStatement(checkSql);
                checkPs.setInt(1, userId);
                checkPs.setInt(2, courseId);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    response.sendRedirect("dashboard.jsp?error=AlreadyEnrolled");
                    return;
                }

                // 3. CHECK: Are seats available?
                String seatSql = "SELECT seats FROM courses WHERE id = ?";
                PreparedStatement seatPs = con.prepareStatement(seatSql);
                seatPs.setInt(1, courseId);
                ResultSet rsSeat = seatPs.executeQuery();

                if (rsSeat.next() && rsSeat.getInt("seats") > 0) {
                    // 4. Update Seats AND Insert Enrollment
                    String updateSql = "UPDATE courses SET seats = seats - 1 WHERE id = ?";
                    PreparedStatement updatePs = con.prepareStatement(updateSql);
                    updatePs.setInt(1, courseId);
                    updatePs.executeUpdate();

                    String insertSql = "INSERT INTO enrollments (user_id, course_id, enroll_date) VALUES (?, ?, CURRENT_TIMESTAMP)";
                    PreparedStatement insertPs = con.prepareStatement(insertSql);
                    insertPs.setInt(1, userId);
                    insertPs.setInt(2, courseId);
                    insertPs.executeUpdate();

                    con.commit(); // Save changes
                    response.sendRedirect("myEnrollment.jsp?success=Enrolled");
                } else {
                    response.sendRedirect("dashboard.jsp?error=CourseFull");
                }

            } catch (Exception e) {
                con.rollback(); // Undo everything if an error occurs
                e.printStackTrace();
                response.sendRedirect("dashboard.jsp?error=EnrollmentError");
            }

        } catch (NumberFormatException | SQLException e) {
            response.sendRedirect("dashboard.jsp?error=InvalidRequest");
        }
    }
}