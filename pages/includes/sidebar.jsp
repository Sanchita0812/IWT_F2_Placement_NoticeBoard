<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<aside class="sidebar">
    <h2>PlaceIntel</h2>
    <div class="nav-item active" id="nav-notice" onclick="switchTab('notice')">Noticeboard</div>
    <div class="nav-item" id="nav-feed" onclick="switchTab('feed')">Intelligence Feed</div>
    <div class="nav-item" id="nav-profile" onclick="switchTab('profile')">Profile</div>
    <div class="nav-item" onclick="window.location.href='../index.jsp?view=landing'">Home</div>
    <div class="nav-item" onclick="window.location.href='about.html'">About Us</div>
    <button class="logout-btn" onclick="window.location.href='Logout.jsp'">Logout</button>
</aside>
