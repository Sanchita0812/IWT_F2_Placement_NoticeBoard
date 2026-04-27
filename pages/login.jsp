<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>PlaceIntel | Login</title>
    <link rel="stylesheet" href="../assets/css/styles.css" />
</head>
<body>
    <div id="login-page" class="auth-wrapper">
        <div class="auth-side">
            <h1>PlaceIntel</h1>
            <p>Access the Nexus.</p>
        </div>
        <div class="auth-main">
            <div class="auth-card">
                <h2>Login</h2>
                <% 
                    String errorMsg = request.getParameter("error");
                    if(errorMsg != null) {
                        out.println("<p style='color:red; font-size:14px; margin-bottom: 10px;'>" + errorMsg + "</p>");
                    }
                %>
                <form action="ProcessLogin.jsp" method="POST">
                    <input type="email" name="email" id="loginEmail" placeholder="Email (@admin.com for Admin)" required />
                    <input type="password" name="password" placeholder="Password" required />
                    <button type="submit" class="btn-primary" style="width: 100%;">Access Dashboard →</button>
                </form>
                <p style="font-size: 14px; margin-top: 20px;">No account? <a href="signup.jsp">Sign Up</a></p>
            </div>
        </div>
    </div>
</body>
</html>
