<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.placeintel.util.DBUtil" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String avatarUrl = request.getParameter("avatarUrl");
    String bio = request.getParameter("bio");
    String education = request.getParameter("education");
    String skills = request.getParameter("skills");

    try (Connection conn = DBUtil.getConnection()) {
        String sql = "UPDATE users SET avatar_url=?, bio=?, education=?, skills=? WHERE id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, avatarUrl);
            stmt.setString(2, bio);
            stmt.setString(3, education);
            stmt.setString(4, skills);
            stmt.setInt(5, userId);
            stmt.executeUpdate();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    response.sendRedirect("dashboard.jsp?tab=profile");
%>
