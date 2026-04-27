const defaultOpportunities = [
    { id: 1, title: "Google - Software Engineer", desc: "Joining the Cloud infrastructure team. Requires 9.0+ CGPA and proficiency in Go/Python.", deadline: "2026-05-15", link: "https://google.com/careers" }
];

// Load from Local Storage
let currentUser = JSON.parse(localStorage.getItem('currentUser'));
let opportunities = JSON.parse(localStorage.getItem('opportunities'));
if (!opportunities) {
    opportunities = defaultOpportunities;
    localStorage.setItem('opportunities', JSON.stringify(opportunities));
}
let feeds = JSON.parse(localStorage.getItem('feeds')) || [];

function saveState() {
    if (currentUser) {
        localStorage.setItem('currentUser', JSON.stringify(currentUser));
    } else {
        localStorage.removeItem('currentUser');
    }
    localStorage.setItem('opportunities', JSON.stringify(opportunities));
    localStorage.setItem('feeds', JSON.stringify(feeds));
}

const isPages = window.location.pathname.includes('/pages/');
function getRoute(page) {
    if (isPages && page === 'index.jsp') return '../index.jsp';
    if (!isPages && page !== 'index.jsp') return 'pages/' + page;
    return page;
}

// Global Auth Handlers
function handleAuth(mode) {
    const email = mode === 'login' ? document.getElementById('loginEmail').value : document.getElementById('signupEmail').value;
    if (!email || !email.includes('@')) return alert("Enter a valid email address");

    let nameStr = email.split('@')[0];
    if (mode === 'signup') {
        const fullNameInput = document.getElementById('signupName');
        if (fullNameInput && fullNameInput.value) {
            nameStr = fullNameInput.value;
        }
    }

    currentUser = {
        name: nameStr,
        role: email.includes('@admin.com') ? 'admin' : 'student',
        avatarUrl: "https://via.placeholder.com/100",
        bio: "No bio added yet. Click edit to add one.",
        ed: "Not specified."
    };
    saveState();
    window.location.href = getRoute('dashboard.jsp');
}

function handleLogout() {
    currentUser = null;
    saveState();
    window.location.href = getRoute('index.jsp');
}

// Requires Auth Check
function requireAuth() {
    if (!currentUser) {
        window.location.href = getRoute('login.jsp');
    }
}

// Modal Helpers
function openModal(id) { document.getElementById(id).style.display = 'flex'; }
function closeModal(id) { document.getElementById(id).style.display = 'none'; }
