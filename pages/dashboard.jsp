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
    String userName = (String) session.getAttribute("userName");
    
    // Fetch profile data
    String avatarUrl = "";
    String bio = "";
    String education = "";
    String skills = "";
    try (Connection conn = DBUtil.getConnection()) {
        String sql = "SELECT avatar_url, bio, education, skills FROM users WHERE id=?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    avatarUrl = rs.getString("avatar_url");
                    bio = rs.getString("bio");
                    education = rs.getString("education");
                    skills = rs.getString("skills");
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    // Get requested tab
    String activeTab = request.getParameter("tab");
    if (activeTab == null) activeTab = "notice";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>PlaceIntel | Dashboard</title>
    <link rel="stylesheet" href="../assets/css/styles.css" />
</head>
<body>
    <div id="app-section" class="app-container">
        
        <!-- JSP Include for Sidebar -->
        <jsp:include page="includes/sidebar.jsp" />

        <main class="content">
            <!-- Noticeboard Tab -->
            <div id="tab-notice" class="hidden">
                <div class="section-header">
                    <div style="font-size: 28px; font-weight: 800;">Noticeboard</div>
                    <button id="createPostBtnNotice" class="btn-primary" onclick="openModal('uploadModal')">+ Create Post</button>
                </div>
                <div id="noticeGrid">
                    <%
                        try (Connection conn = DBUtil.getConnection();
                             Statement stmt = conn.createStatement();
                             ResultSet rs = stmt.executeQuery("SELECT id, title, description, deadline, link, user_id FROM notices ORDER BY id DESC")) {
                            while (rs.next()) {
                                int noticeId = rs.getInt("id");
                                String title = rs.getString("title");
                                String desc = rs.getString("description");
                                String deadline = rs.getString("deadline");
                                String link = rs.getString("link");
                                int noticeUserId = rs.getInt("user_id");
                    %>
                    <div class="notice-card">
                        <div style="display: flex; justify-content: space-between; align-items: start;">
                            <h3 style="margin: 0;"><%= title %></h3>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <span class="deadline-tag">Deadline: <%= deadline %></span>
                                <% if (noticeUserId == userId || "admin".equals(role)) { %>
                                <form action="DeleteNotice.jsp" method="POST" style="margin:0;" onsubmit="return confirm('Are you sure you want to delete this notice?');">
                                    <input type="hidden" name="id" value="<%= noticeId %>">
                                    <button type="submit" style="background: none; border: none; color: var(--danger); cursor: pointer; font-size: 16px;" title="Delete Post">🗑️</button>
                                </form>
                                <% } %>
                            </div>
                        </div>
                        <p style="color: var(--muted); margin: 15px 0; word-wrap: break-word;"><%= desc %></p>
                        <div class="card-footer">
                            <button class="btn-secondary" onclick="openReadMoreModal('<%= title.replace("'", "\\'") %>', '<%= desc.replace("'", "\\'").replace("\n", "\\n").replace("\r", "") %>')">Read More</button>
                            <button class="btn-primary" onclick="window.open('<%= link %>', '_blank')">Apply Now</button>
                        </div>
                    </div>
                    <%
                            }
                        } catch (SQLException e) {
                            out.println("<p>Error loading notices.</p>");
                        }
                    %>
                </div>
            </div>

            <!-- Intelligence Feed Tab -->
            <div id="tab-feed" class="hidden">
                <div style="font-size: 28px; font-weight: 800; margin-bottom: 24px;">Intelligence Feed</div>
                <div class="feed-card">
                    <form action="AddFeed.jsp" method="POST" id="feedForm">
                        <textarea name="text" id="feedInput" placeholder="Start a post..."
                            style="border: none; border-bottom: 1px solid #eee; border-radius: 0; outline: none; margin-bottom: 15px; resize: none; min-height: 60px; width:100%;"></textarea>
                        
                        <input type="hidden" name="fileUrl" id="hiddenFileUrl">
                        <input type="hidden" name="fileName" id="hiddenFileName">

                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div style="display: flex; gap: 15px;">
                                <label for="feedFile"
                                    style="cursor: pointer; color: var(--muted); font-weight: 600; display: flex; align-items: center; gap: 5px;">
                                    📎 Media
                                </label>
                                <input type="file" id="feedFile" class="hidden" accept="image/*,video/*" onchange="processFile(this)">
                                <span id="fileNameDisplay" style="font-size:12px; color:var(--cobalt);"></span>
                            </div>
                            <button type="submit" class="btn-primary" style="padding: 8px 16px; border-radius: 20px;">Post</button>
                        </div>
                    </form>
                </div>
                <div id="feedList">
                    <%
                        try (Connection conn = DBUtil.getConnection()) {
                            String feedSql = "SELECT f.id, f.user_id, f.text, f.file_url, f.file_name, u.name, " +
                                             "(SELECT COUNT(*) FROM feed_likes WHERE feed_id = f.id) AS likes_count, " +
                                             "(SELECT COUNT(*) FROM feed_likes WHERE feed_id = f.id AND user_id = ?) AS user_liked, " +
                                             "(SELECT COUNT(*) FROM feed_comments WHERE feed_id = f.id) AS comments_count " +
                                             "FROM feeds f JOIN users u ON f.user_id = u.id ORDER BY f.id DESC";
                            try (PreparedStatement stmt = conn.prepareStatement(feedSql)) {
                                stmt.setInt(1, userId);
                                try (ResultSet rs = stmt.executeQuery()) {
                                    while (rs.next()) {
                                        int feedId = rs.getInt("id");
                                        int authorId = rs.getInt("user_id");
                                        String fText = rs.getString("text");
                                        String fFileUrl = rs.getString("file_url");
                                        String fFileName = rs.getString("file_name");
                                        String authorName = rs.getString("name");
                                        int likesCount = rs.getInt("likes_count");
                                        int commentsCount = rs.getInt("comments_count");
                                        boolean userLiked = rs.getInt("user_liked") > 0;
                                        String initial = authorName != null && !authorName.isEmpty() ? authorName.substring(0, 1).toUpperCase() : "?";
                    %>
                    <div class="feed-card">
                        <div style="display: flex; justify-content: space-between; align-items: start;">
                            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
                                <div style="width: 40px; height: 40px; border-radius: 50%; background: #cbd5e0; display: flex; align-items: center; justify-content: center; font-weight: bold; color: white;">
                                    <%= initial %>
                                </div>
                                <strong><%= authorName %></strong>
                            </div>
                            <% if ("admin".equals(role)) { %>
                            <form action="DeleteFeed.jsp" method="POST" style="margin:0;" onsubmit="return confirm('Delete this post?');">
                                <input type="hidden" name="id" value="<%= feedId %>">
                                <button type="submit" style="background: none; border: none; color: var(--danger); cursor: pointer; font-size: 16px;" title="Delete Post">🗑️</button>
                            </form>
                            <% } %>
                        </div>
                        <% if (fText != null && !fText.trim().isEmpty()) { %>
                        <p style="margin: 10px 0; white-space: pre-wrap;"><%= fText %></p>
                        <% } %>
                        <% if (fFileUrl != null && !fFileUrl.isEmpty()) { %>
                            <% if (fFileUrl.startsWith("data:image")) { %>
                                <img src="<%= fFileUrl %>" style="width: 100%; border-radius: 8px; margin-top: 10px;" alt="Post image" />
                            <% } else { %>
                                <div class="attachment-pill" style="margin-top:10px;">📎 <%= fFileName %></div>
                            <% } %>
                        <% } %>
                        
                        <div style="margin-top: 10px; font-size: 13px; color: var(--muted);">
                            <%= likesCount %> Likes • <%= commentsCount %> Comments
                        </div>

                        <div style="margin-top: 10px; border-top: 1px solid #eee; padding-top: 10px; display: flex; gap: 20px;">
                            <form action="ToggleLike.jsp" method="POST" style="margin:0;">
                                <input type="hidden" name="id" value="<%= feedId %>">
                                <button type="submit" style="background: none; color: <%= userLiked ? "var(--cobalt)" : "var(--muted)" %>; font-weight: 600; display: flex; align-items: center; gap: 5px; cursor: pointer; border: none; padding: 0;">
                                    👍 <%= userLiked ? "Liked" : "Like" %>
                                </button>
                            </form>
                            <button onclick="document.getElementById('commentBox-<%= feedId %>').classList.toggle('hidden')" style="background: none; color: var(--muted); font-weight: 600; display: flex; align-items: center; gap: 5px; cursor: pointer; border: none; padding: 0;">
                                💬 Comment
                            </button>
                        </div>
                        
                        <!-- Comments Section -->
                        <div id="commentBox-<%= feedId %>" class="hidden" style="margin-top: 15px; border-top: 1px solid #eee; padding-top: 10px;">
                            <div style="max-height: 150px; overflow-y: auto; margin-bottom: 10px; font-size: 14px;">
                                <%
                                    String commentSql = "SELECT c.text, u.name FROM feed_comments c JOIN users u ON c.user_id = u.id WHERE c.feed_id = ? ORDER BY c.id ASC";
                                    try (PreparedStatement cStmt = conn.prepareStatement(commentSql)) {
                                        cStmt.setInt(1, feedId);
                                        try (ResultSet cRs = cStmt.executeQuery()) {
                                            while (cRs.next()) {
                                %>
                                <div style="margin-bottom: 8px; padding: 8px; background: #f8f9fa; border-radius: 6px;">
                                    <strong><%= cRs.getString("name") %>:</strong> <%= cRs.getString("text") %>
                                </div>
                                <%
                                            }
                                        }
                                    }
                                %>
                            </div>
                            <form action="AddComment.jsp" method="POST" style="display: flex; gap: 10px; margin: 0;">
                                <input type="hidden" name="feedId" value="<%= feedId %>">
                                <input type="text" name="text" placeholder="Add a comment..." style="flex: 1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;" required>
                                <button type="submit" class="btn-primary" style="padding: 8px 15px;">Post</button>
                            </form>
                        </div>

                    </div>
                    <%
                                    }
                                }
                            }
                        } catch (SQLException e) {
                            out.println("<p>Error loading feeds.</p>");
                        }
                    %>
                </div>
            </div>

            <!-- Profile Tab -->
            <div id="tab-profile" class="hidden">
                <div class="section-header">
                    <div style="font-size: 28px; font-weight: 800;">Your Profile</div>
                    <button class="btn-secondary" onclick="openModal('editProfileModal')">Edit Profile</button>
                </div>
                <div class="profile-header">
                    <div class="avatar-wrapper">
                        <img id="displayAvatar" class="profile-avatar" src="<%= (avatarUrl != null && !avatarUrl.isEmpty()) ? avatarUrl : "https://via.placeholder.com/100" %>" />
                    </div>
                    <div>
                        <h2 id="displayUser" style="margin: 0 0 5px 0;"><%= userName %></h2>
                        <p id="displayBio" style="color: var(--muted); margin: 0;"><%= (bio != null && !bio.isEmpty()) ? bio : "No bio added yet. Click edit to add one." %></p>
                    </div>
                </div>
                <div class="notice-card" style="margin-top: 20px;">
                    <h3>Education</h3>
                    <p id="displayEd" style="white-space: pre-wrap;"><%= (education != null && !education.isEmpty()) ? education : "Not specified." %></p>
                </div>
                <div class="notice-card" style="margin-top: 20px;">
                    <h3>Skills</h3>
                    <p id="displaySkills" style="white-space: pre-wrap;"><%= (skills != null && !skills.isEmpty()) ? skills : "Not specified." %></p>
                </div>
            </div>
        </main>
    </div>

    <!-- JSP Include for Modals -->
    <jsp:include page="includes/modals.jsp" />

    <script src="../assets/js/app.js"></script>
    <script>
        // Populate profile edit form with current DB data
        document.addEventListener("DOMContentLoaded", function() {
            document.getElementById('editAvatarUrl').value = "<%= (avatarUrl != null) ? avatarUrl.replace("\"", "&quot;") : "" %>";
            document.getElementById('editAbout').value = "<%= (bio != null) ? bio.replace("\"", "&quot;").replace("\n", "\\n") : "" %>";
            document.getElementById('editEd').value = "<%= (education != null) ? education.replace("\"", "&quot;").replace("\n", "\\n") : "" %>";
            const editSkills = document.getElementById('editSkills');
            if(editSkills) editSkills.value = "<%= (skills != null) ? skills.replace("\"", "&quot;").replace("\n", "\\n") : "" %>";
        });

        function switchTab(tab) {
            ['notice', 'feed', 'profile'].forEach(t => {
                document.getElementById('tab-' + t).classList.add('hidden');
                document.getElementById('nav-' + t).classList.remove('active');
            });
            document.getElementById('tab-' + tab).classList.remove('hidden');
            document.getElementById('nav-' + tab).classList.add('active');
        }

        function openReadMoreModal(title, desc) {
            document.getElementById('rmTitle').innerText = title;
            document.getElementById('rmBody').innerText = desc;
            openModal('readMoreModal');
        }
        
        // Handle Base64 file processing for feed
        function processFile(input) {
            const file = input.files[0];
            if (file) {
                document.getElementById('fileNameDisplay').innerText = file.name;
                document.getElementById('hiddenFileName').value = file.name;
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('hiddenFileUrl').value = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        }

        // Handle Base64 file processing for profile picture
        function processProfilePic(input) {
            const file = input.files[0];
            if (file) {
                document.getElementById('profilePicPreview').innerText = "Selected: " + file.name;
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('editAvatarUrl').value = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        }

        // Initialize active tab from parameter
        switchTab('<%= activeTab %>');
    </script>
</body>
</html>
