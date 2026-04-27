<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.placeintel.util.DBUtil" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String role = (String) session.getAttribute("userRole");

    String idStr = request.getParameter("id");
    if (idStr != null) {
        try (Connection conn = DBUtil.getConnection()) {
            int noticeId = Integer.parseInt(idStr);
            if ("admin".equals(role)) {
                String sql = "DELETE FROM notices WHERE id=?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, noticeId);
                    stmt.executeUpdate();
                }
            } else {
                String sql = "DELETE FROM notices WHERE id=? AND user_id=?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, noticeId);
                    stmt.setInt(2, userId);
                    stmt.executeUpdate();
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }
    }
    
    response.sendRedirect("dashboard.jsp?tab=notice");
%>
