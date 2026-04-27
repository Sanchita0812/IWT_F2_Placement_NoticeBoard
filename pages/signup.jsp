<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>PlaceIntel | Signup</title>
    <link rel="stylesheet" href="../assets/css/styles.css" />
</head>
<body>
    <div id="signup-page" class="auth-wrapper">
        <div class="auth-side">
            <h1>Join Nexus</h1>
            <p>Start your journey.</p>
        </div>
        <div class="auth-main">
            <div class="auth-card">
                <h2>Sign Up</h2>
                <% 
                    String errorMsg = request.getParameter("error");
                    if(errorMsg != null) {
                        out.println("<p style='color:red; font-size:14px; margin-bottom: 10px;'>" + errorMsg + "</p>");
                    }
                %>
                <form action="ProcessSignup.jsp" method="POST" id="signupForm" onsubmit="return validateAndSignup(event)">
                    <input type="text" name="name" id="signupName" placeholder="Full Name" required />
                    <input type="email" name="email" id="signupEmail" placeholder="Email Address" required />
                    <input type="password" name="password" id="signupPassword" placeholder="Password" required />
                    <button type="submit" class="btn-primary" style="width: 100%;">Create Account</button>
                </form>
                <p style="font-size: 14px; margin-top: 20px;">Already have an account? <a href="login.jsp">Login</a></p>
            </div>
        </div>
    </div>
    
    <script>
        function validateAndSignup(event) {
            const passwordInput = document.getElementById('signupPassword');
            const password = passwordInput.value;
            
            // Regex for at least 1 capital letter, 1 number, and 1 special character
            const passwordRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+$/;
            
            if (!passwordRegex.test(password)) {
                alert("Password must contain at least one capital letter, one numeric value, and one special character.");
                event.preventDefault(); // Stop form submission
                return false;
            }
            return true;
        }
    </script>
    <script src="../assets/js/app.js"></script>
</body>
</html>
