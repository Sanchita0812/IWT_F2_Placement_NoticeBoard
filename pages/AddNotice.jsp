<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.placeintel.util.DBUtil" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String title = request.getParameter("title");
    String desc = request.getParameter("desc");
    String deadline = request.getParameter("deadline");
    String link = request.getParameter("link");

    if (title != null && desc != null && deadline != null && link != null) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "INSERT INTO notices (title, description, deadline, link, user_id) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, title);
                stmt.setString(2, desc);
                stmt.setString(3, deadline);
                stmt.setString(4, link);
                stmt.setInt(5, (Integer) session.getAttribute("userId"));
                
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Optional: redirect to an error page or pass an error parameter
        }
    }
    
    response.sendRedirect("dashboard.jsp");
%>
