<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.placeintel.util.DBUtil" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if (email != null && password != null) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT id, name, role FROM users WHERE email = ? AND password = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                stmt.setString(2, password); // Note: In a real app, hash passwords!
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        // User found, set session
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute("userName", rs.getString("name"));
                        session.setAttribute("userRole", rs.getString("role"));
                        session.setAttribute("userEmail", email);
                        
                        response.sendRedirect("dashboard.jsp");
                    } else {
                        // Invalid credentials
                        response.sendRedirect("login.jsp?error=Invalid Credentials");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database Error");
        }
    } else {
        response.sendRedirect("login.jsp?error=Please enter email and password");
    }
%>
