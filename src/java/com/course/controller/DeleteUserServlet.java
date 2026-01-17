package com.course.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.course.util.DBConnection;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer currentAdminId = (Integer) session.getAttribute("userId");
        String targetUserId = request.getParameter("id");

        // 1. Security Check
        if (currentAdminId == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("dashboard.jsp?error=Unauthorized");
            return;
        }

        if (targetUserId != null) {
            int deleteId = Integer.parseInt(targetUserId);

            // 2. Prevent Self-Deletion
            if (currentAdminId == deleteId) {
                response.sendRedirect("manageUsers.jsp?error=CannotDeleteSelf");
                return;
            }

            try (Connection con = DBConnection.getConnection()) {
                // 3. Delete from enrollments first (Foreign Key constraint)
                String deleteEnrollments = "DELETE FROM enrollments WHERE user_id = ?";
                PreparedStatement ps1 = con.prepareStatement(deleteEnrollments);
                ps1.setInt(1, deleteId);
                ps1.executeUpdate();

                // 4. Delete the user
                String deleteUser = "DELETE FROM users WHERE id = ?";
                PreparedStatement ps2 = con.prepareStatement(deleteUser);
                ps2.setInt(1, deleteId);
                
                int rows = ps2.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("manageUsers.jsp?msg=deleted");
                } else {
                    response.sendRedirect("manageUsers.jsp?msg=error");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("manageUsers.jsp?msg=error");
            }
        }
    }
}