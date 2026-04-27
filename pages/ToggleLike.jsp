<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.placeintel.util.DBUtil" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String feedIdStr = request.getParameter("id");
    if (feedIdStr != null) {
        try (Connection conn = DBUtil.getConnection()) {
            int feedId = Integer.parseInt(feedIdStr);
            
            // Check if already liked
            String checkSql = "SELECT 1 FROM feed_likes WHERE feed_id=? AND user_id=?";
            boolean alreadyLiked = false;
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, feedId);
                checkStmt.setInt(2, userId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) alreadyLiked = true;
                }
            }
            
            if (alreadyLiked) {
                // Unlike
                String delSql = "DELETE FROM feed_likes WHERE feed_id=? AND user_id=?";
                try (PreparedStatement delStmt = conn.prepareStatement(delSql)) {
                    delStmt.setInt(1, feedId);
                    delStmt.setInt(2, userId);
                    delStmt.executeUpdate();
                }
            } else {
                // Like
                String insSql = "INSERT INTO feed_likes (feed_id, user_id) VALUES (?, ?)";
                try (PreparedStatement insStmt = conn.prepareStatement(insSql)) {
                    insStmt.setInt(1, feedId);
                    insStmt.setInt(2, userId);
                    insStmt.executeUpdate();
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }
    }
    
    response.sendRedirect("dashboard.jsp?tab=feed");
%>
