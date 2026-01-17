<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    session.invalidate();   // Destroy all session data
    response.sendRedirect("index.jsp?logout=success");
%>
