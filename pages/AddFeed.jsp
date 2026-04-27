<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.placeintel.util.DBUtil" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String text = request.getParameter("text");
    String fileUrl = request.getParameter("fileUrl"); // Base64 or plain URL
    String fileName = request.getParameter("fileName");

    if (text != null || fileUrl != null) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "INSERT INTO feeds (user_id, text, file_url, file_name) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                stmt.setString(2, text);
                stmt.setString(3, fileUrl);
                stmt.setString(4, fileName);
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    response.sendRedirect("dashboard.jsp?tab=feed");
%>
