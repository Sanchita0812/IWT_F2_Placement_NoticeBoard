<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.placeintel.util.DBUtil" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String feedIdStr = request.getParameter("feedId");
    String text = request.getParameter("text");

    if (feedIdStr != null && text != null && !text.trim().isEmpty()) {
        try (Connection conn = DBUtil.getConnection()) {
            int feedId = Integer.parseInt(feedIdStr);
            String sql = "INSERT INTO feed_comments (feed_id, user_id, text) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, feedId);
                stmt.setInt(2, userId);
                stmt.setString(3, text);
                stmt.executeUpdate();
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }
    }
    
    response.sendRedirect("dashboard.jsp?tab=feed");
%>
