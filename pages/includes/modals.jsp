<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String role = (String) session.getAttribute("userRole"); %>
<!-- Modals -->
<div class="modal-bg" id="uploadModal">
    <div class="modal">
        <h2>Create Noticeboard Post</h2>
        <form action="AddNotice.jsp" method="POST">
            <p style="font-size: 12px; color: var(--danger);">* All fields are mandatory.</p>
            <input type="text" name="title" id="oppTitle" placeholder="Company Name & Role" required />
            <textarea name="desc" id="oppDesc" maxlength="300" placeholder="Description & Eligibility (Max 300 characters)" required></textarea>
            <div style="margin-bottom: 5px; font-size: 14px; font-weight: 600;">Deadline</div>
            <input type="date" name="deadline" id="oppDeadline" required />
            <input type="url" name="link" id="oppLink" placeholder="Application Link (e.g., https://site.com)" required />
            <div class="card-footer">
                <button type="submit" class="btn-primary">Upload Post</button>
                <button type="button" class="btn-secondary" onclick="closeModal('uploadModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<div id="readMoreModal" class="modal-bg">
    <div class="modal">
        <h2 id="rmTitle"></h2>
        <p id="rmBody" style="line-height: 1.6; white-space: pre-wrap;"></p>
        <button class="btn-primary" style="width: 100%; margin-top: 15px;" onclick="closeModal('readMoreModal')">Close</button>
    </div>
</div>

<div id="editProfileModal" class="modal-bg">
    <div class="modal">
        <h2>Edit Profile</h2>
        <form action="UpdateProfile.jsp" method="POST" enctype="application/x-www-form-urlencoded">
            <!-- Local file upload for profile picture -->
            <div style="margin-bottom: 15px; text-align: left;">
                <label for="editAvatarFile" style="cursor: pointer; color: var(--cobalt); font-weight: 600; display: inline-flex; align-items: center; gap: 5px;">
                    📷 Upload Profile Picture
                </label>
                <input type="file" id="editAvatarFile" class="hidden" accept="image/*" onchange="processProfilePic(this)">
                <div id="profilePicPreview" style="margin-top: 5px; font-size: 12px; color: var(--muted); word-break: break-all;">No new file selected (current avatar will be kept)</div>
                <input type="hidden" name="avatarUrl" id="editAvatarUrl" />
            </div>
            <textarea name="bio" id="editAbout" placeholder="About Me / Bio"></textarea>
            <textarea name="education" id="editEd" placeholder="Education Details"></textarea>
            <textarea name="skills" id="editSkills" placeholder="Skills"></textarea>
            <div class="card-footer">
                <button type="submit" class="btn-primary" style="width: 100%">Save Changes</button>
                <button type="button" class="btn-secondary" style="width: 100%" onclick="closeModal('editProfileModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>
