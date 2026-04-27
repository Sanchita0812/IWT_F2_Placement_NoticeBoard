<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.placeintel.util.DBUtil" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if (name != null && email != null && password != null) {
        try (Connection conn = DBUtil.getConnection()) {
            String role = email.endsWith("@admin.com") ? "admin" : "student";
            
            String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, password);
                stmt.setString(4, role);
                
                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("login.jsp");
                } else {
                    response.sendRedirect("signup.jsp?error=Failed to register");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?error=Database Error or Email already exists");
        }
    } else {
        response.sendRedirect("signup.jsp?error=Please fill all fields");
    }
%>
