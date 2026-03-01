<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, model.User" %>
<%
    model.User admin = (model.User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
%>
<html>
<head>
<title>Manage Users - EventBiz</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@300;400;600;700&display=swap');
    
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        margin: 0;
        padding: 0;
        min-height: 100vh;
        background: linear-gradient(rgba(60, 70, 90, 0.9), rgba(80, 100, 130, 0.95)), 
                    url('https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        background-repeat: no-repeat;
        font-family: 'Montserrat', sans-serif;
        color: #333;
        padding: 20px;
    }

    /* Animated background overlay */
    body::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: 
            radial-gradient(circle at 20% 30%, rgba(156, 39, 176, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 80% 70%, rgba(33, 150, 243, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 40% 80%, rgba(76, 175, 80, 0.15) 0%, transparent 50%);
        animation: float 10s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .users-container {
        max-width: 1400px;
        margin: 0 auto;
        background: rgba(255, 255, 255, 0.97);
        backdrop-filter: blur(20px);
        padding: 3rem;
        border-radius: 25px;
        box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
        border: 1px solid rgba(255, 255, 255, 0.3);
        position: relative;
        overflow: hidden;
    }

    .users-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background: linear-gradient(90deg, #9C27B0, #673AB7, #2196F3, #4CAF50);
        background-size: 400% 400%;
        animation: gradientShift 4s ease infinite;
    }

    .header {
        text-align: center;
        margin-bottom: 3rem;
        position: relative;
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 3rem;
        background: linear-gradient(135deg, #9C27B0, #673AB7);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 1rem;
    }

    .admin-icon {
        font-size: 4rem;
        margin-bottom: 1rem;
        animation: bounce 2s ease-in-out infinite;
        display: block;
    }

    .navigation {
        display: flex;
        justify-content: center;
        gap: 1.5rem;
        margin-bottom: 2.5rem;
        flex-wrap: wrap;
    }

    .nav-link {
        background: linear-gradient(135deg, #9C27B0, #673AB7);
        color: white;
        padding: 12px 25px;
        text-decoration: none;
        border-radius: 12px;
        font-weight: 700;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 15px rgba(156, 39, 176, 0.3);
        font-size: 0.95rem;
    }

    .nav-link:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(156, 39, 176, 0.5);
    }

    .nav-link.back {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
    }

    /* Stats Section */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 3rem;
    }

    .stat-card {
        background: linear-gradient(135deg, #9C27B0, #673AB7);
        color: white;
        padding: 1.5rem;
        border-radius: 15px;
        text-align: center;
        box-shadow: 0 8px 25px rgba(156, 39, 176, 0.3);
        transition: transform 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    .stat-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
        transform: translateX(-100%);
        transition: transform 0.6s;
    }

    .stat-card:hover::before {
        transform: translateX(100%);
    }

    .stat-card:hover {
        transform: translateY(-5px);
    }

    .stat-card.total {
        background: linear-gradient(135deg, #9C27B0, #673AB7);
    }

    .stat-card.participants {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
    }

    .stat-card.organizers {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
    }

    .stat-card.admins {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
    }

    .stat-icon {
        font-size: 2.5rem;
        margin-bottom: 0.5rem;
        display: block;
    }

    .stat-number {
        font-size: 2.5rem;
        font-weight: 700;
        margin-bottom: 0.5rem;
    }

    .stat-label {
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        opacity: 0.9;
    }

    /* Users Table */
    .users-table-container {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        margin-top: 2rem;
    }

    .users-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .users-table th {
        background: linear-gradient(135deg, #9C27B0, #673AB7);
        color: white;
        padding: 1.5rem;
        text-align: left;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 0.9rem;
        position: relative;
    }

    .users-table th::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: rgba(255, 255, 255, 0.3);
    }

    .users-table td {
        padding: 1.3rem 1.5rem;
        border-bottom: 1px solid #E2E8F0;
        transition: all 0.3s ease;
        color: #4A5568;
        vertical-align: middle;
    }

    .users-table tr:hover td {
        background: rgba(156, 39, 176, 0.05);
        transform: translateX(5px);
    }

    .users-table tr:last-child td {
        border-bottom: none;
    }

    .user-id {
        font-weight: 700;
        color: #2D3748;
        font-family: 'Courier New', monospace;
    }

    .username {
        font-weight: 700;
        color: #2D3748;
    }

    .email {
        color: #718096;
        font-weight: 500;
    }

    .role-badge {
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        display: inline-block;
        text-align: center;
        min-width: 100px;
    }

    .role-participant {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .role-organizer {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
        color: white;
    }

    .role-admin {
        background: linear-gradient(135deg, #9C27B0, #BA68C8);
        color: white;
    }

    .datetime {
        font-family: 'Courier New', monospace;
        font-size: 0.9rem;
        color: #718096;
    }

    .action-buttons {
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
    }

    .role-form, .delete-form {
        display: flex;
        gap: 0.8rem;
        align-items: center;
        flex-wrap: wrap;
    }

    .role-select {
        padding: 0.5rem 1rem;
        border: 2px solid #E2E8F0;
        border-radius: 8px;
        font-weight: 600;
        font-size: 0.85rem;
        background: white;
        cursor: pointer;
        transition: all 0.3s ease;
        min-width: 140px;
    }

    .role-select:focus {
        outline: none;
        border-color: #9C27B0;
        box-shadow: 0 0 0 3px rgba(156, 39, 176, 0.1);
    }

    .btn {
        padding: 0.6rem 1.2rem;
        border: none;
        border-radius: 8px;
        font-weight: 600;
        font-size: 0.8rem;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }

    .btn-change {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
        color: white;
    }

    .btn-delete {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
        color: white;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    .no-users {
        text-align: center;
        padding: 4rem 2rem;
        color: #718096;
        font-size: 1.2rem;
        background: rgba(156, 39, 176, 0.05);
        border-radius: 15px;
        border: 2px dashed #9C27B0;
    }

    .no-users h3 {
        margin-bottom: 1rem;
        color: #4A5568;
    }

    /* Current user highlight */
    .current-user {
        background: linear-gradient(135deg, rgba(255, 193, 7, 0.1), rgba(255, 152, 0, 0.05)) !important;
        border-left: 4px solid #FFC107;
    }

    .current-user td {
        background: transparent !important;
    }

    .current-user-indicator {
        background: linear-gradient(135deg, #FFC107, #FF9800);
        color: white;
        padding: 0.3rem 0.8rem;
        border-radius: 12px;
        font-size: 0.7rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-left: 0.5rem;
    }

    /* Animations */
    @keyframes gradientShift {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    @keyframes float {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        50% { transform: translateY(-20px) rotate(1deg); }
    }

    @keyframes bounce {
        0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
        40% { transform: translateY(-10px); }
        60% { transform: translateY(-5px); }
    }

    .users-container {
        animation: fadeInUp 0.8s ease-out;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* Responsive Design */
    @media (max-width: 1024px) {
        .users-container {
            padding: 2rem;
        }
        
        .users-table {
            font-size: 0.9rem;
        }
        
        .users-table th,
        .users-table td {
            padding: 1rem;
        }
    }

    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .users-container {
            padding: 1.5rem;
        }
        
        h2 {
            font-size: 2.2rem;
        }
        
        .navigation {
            flex-direction: column;
            align-items: center;
        }
        
        .nav-link {
            width: 100%;
            justify-content: center;
        }
        
        .users-table-container {
            overflow-x: auto;
        }
        
        .stats-grid {
            grid-template-columns: repeat(2, 1fr);
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .role-form, .delete-form {
            flex-direction: column;
            align-items: stretch;
        }
    }

    @media (max-width: 480px) {
        .users-container {
            padding: 1rem;
        }
        
        h2 {
            font-size: 1.8rem;
        }
        
        .users-table {
            min-width: 800px;
        }
        
        .stats-grid {
            grid-template-columns: 1fr;
        }
        
        .btn {
            justify-content: center;
        }
    }

    /* Search and Filter */
    .search-section {
        background: linear-gradient(135deg, rgba(156, 39, 176, 0.1), rgba(103, 58, 183, 0.1));
        padding: 1.5rem;
        border-radius: 15px;
        margin-bottom: 2rem;
        border-left: 4px solid #9C27B0;
    }

    .search-form {
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
        align-items: center;
    }

    .search-input {
        padding: 0.8rem 1rem;
        border: 2px solid #E2E8F0;
        border-radius: 10px;
        font-size: 1rem;
        flex: 1;
        min-width: 250px;
        transition: all 0.3s ease;
    }

    .search-input:focus {
        outline: none;
        border-color: #9C27B0;
        box-shadow: 0 0 0 3px rgba(156, 39, 176, 0.1);
    }

    .filter-select {
        padding: 0.8rem 1rem;
        border: 2px solid #E2E8F0;
        border-radius: 10px;
        font-size: 1rem;
        background: white;
        cursor: pointer;
        transition: all 0.3s ease;
    }
</style>
</head>
<body>
<div class="users-container">
    <div class="header">
        <div class="admin-icon">👥</div>
        <h2>Manage Users</h2>
        <p style="color: #718096; font-size: 1.1rem;">Admin user management and role control</p>
    </div>

    <div class="navigation">
        <a href="<%=request.getContextPath()%>/admin/reports" class="nav-link back">
            📊 Back to Reports
        </a>
    </div>

    <% 
        if (users != null && !users.isEmpty()) { 
        int totalUsers = users.size();
        int participants = 0;
        int organizers = 0;
        int admins = 0;
        
        for (User u : users) {
            if ("PARTICIPANT".equalsIgnoreCase(u.getRole())) participants++;
            else if ("ORGANIZER".equalsIgnoreCase(u.getRole())) organizers++;
            else if ("ADMIN".equalsIgnoreCase(u.getRole())) admins++;
        }
    %>
    
    <div class="stats-grid">
        <div class="stat-card total">
            <span class="stat-icon">👥</span>
            <div class="stat-number"><%= totalUsers %></div>
            <div class="stat-label">Total Users</div>
        </div>
        <div class="stat-card participants">
            <span class="stat-icon">🎫</span>
            <div class="stat-number"><%= participants %></div>
            <div class="stat-label">Participants</div>
        </div>
        <div class="stat-card organizers">
            <span class="stat-icon">🎪</span>
            <div class="stat-number"><%= organizers %></div>
            <div class="stat-label">Organizers</div>
        </div>
        <div class="stat-card admins">
            <span class="stat-icon">⚡</span>
            <div class="stat-number"><%= admins %></div>
            <div class="stat-label">Admins</div>
        </div>
    </div>

    <div class="search-section">
        <div class="search-form">
            <input type="text" class="search-input" placeholder="🔍 Search users by name or email..." id="searchInput">
            <select class="filter-select" id="roleFilter">
                <option value="">All Roles</option>
                <option value="PARTICIPANT">Participants</option>
                <option value="ORGANIZER">Organizers</option>
                <option value="ADMIN">Admins</option>
            </select>
        </div>
    </div>

    <div class="users-table-container">
        <table class="users-table">
            <thead>
                <tr>
                    <th>🆔 User ID</th>
                    <th>👤 Username</th>
                    <th>📧 Email</th>
                    <th>🎭 Role</th>
                    <th>⏰ Created</th>
                    <th>⚡ Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (User u : users) { 
                    String roleClass = "role-" + u.getRole().toLowerCase();
                    boolean isCurrentUser = u.getId() == admin.getId();
                %>
                    <tr class="<%= isCurrentUser ? "current-user" : "" %>" data-username="<%= u.getUsername().toLowerCase() %>" data-email="<%= u.getEmail().toLowerCase() %>" data-role="<%= u.getRole() %>">
                        <td class="user-id">#<%= u.getId() %></td>
                        <td>
                            <span class="username">
                                <%= u.getUsername() %>
                                <% if (isCurrentUser) { %>
                                    <span class="current-user-indicator">YOU</span>
                                <% } %>
                            </span>
                        </td>
                        <td class="email"><%= u.getEmail() %></td>
                        <td>
                            <span class="role-badge <%= roleClass %>">
                                <%= u.getRole() %>
                            </span>
                        </td>
                        <td class="datetime"><%= u.getCreatedAt() %></td>
                        <td>
                            <div class="action-buttons">
                                <form method="post" action="<%=request.getContextPath()%>/admin/users" class="role-form">
                                    <input type="hidden" name="userId" value="<%=u.getId()%>"/>
                                    <select name="role" class="role-select">
                                        <option value="PARTICIPANT" <%= "PARTICIPANT".equals(u.getRole()) ? "selected" : "" %>>🎫 Participant</option>
                                        <option value="ORGANIZER" <%= "ORGANIZER".equals(u.getRole()) ? "selected" : "" %>>🎪 Organizer</option>
                                        <option value="ADMIN" <%= "ADMIN".equals(u.getRole()) ? "selected" : "" %>>⚡ Admin</option>
                                    </select>
                                    <button type="submit" name="action" value="changeRole" class="btn btn-change">
                                        🔄 Update
                                    </button>
                                </form>
                                <% if (!isCurrentUser) { %>
                                    <form method="post" action="<%=request.getContextPath()%>/admin/users" class="delete-form" onsubmit="return confirmDelete('<%= u.getUsername() %>')">
                                        <input type="hidden" name="userId" value="<%=u.getId()%>"/>
                                        <button type="submit" name="action" value="delete" class="btn btn-delete">
                                            🗑️ Delete
                                        </button>
                                    </form>
                                <% } else { %>
                                    <button class="btn" disabled style="background: #9E9E9E; color: white; cursor: not-allowed;">
                                        🔒 Current User
                                    </button>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
        <div class="no-users">
            <h3>👤 No Users Found</h3>
            <p>There are currently no users in the system.</p>
        </div>
    <% } %>
</div>

<script>
    // Add loading animations
    document.addEventListener('DOMContentLoaded', function() {
        const tableRows = document.querySelectorAll('.users-table tbody tr');
        tableRows.forEach(function(row, index) {
            row.style.animationDelay = (index * 0.1) + 's';
            row.style.animation = 'fadeInUp 0.5s ease-out forwards';
            row.style.opacity = '0';
        });

        // Search functionality
        const searchInput = document.getElementById('searchInput');
        const roleFilter = document.getElementById('roleFilter');
        
        function filterUsers() {
            const searchTerm = searchInput.value.toLowerCase();
            const roleValue = roleFilter.value;
            
            const rows = document.querySelectorAll('.users-table tbody tr');
            rows.forEach(function(row) {
                const username = row.getAttribute('data-username');
                const email = row.getAttribute('data-email');
                const role = row.getAttribute('data-role');
                
                const matchesSearch = username.includes(searchTerm) || email.includes(searchTerm);
                const matchesRole = !roleValue || role === roleValue;
                
                if (matchesSearch && matchesRole) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
        
        if (searchInput) {
            searchInput.addEventListener('input', filterUsers);
        }
        if (roleFilter) {
            roleFilter.addEventListener('change', filterUsers);
        }
    });

    // Enhanced confirmation for delete
    function confirmDelete(username) {
        return confirm('⚠️ Are you sure you want to delete user "' + username + '"?\n\nThis action cannot be undone and will permanently remove the user account.');
    }

    // Add confirmation for role change
    document.addEventListener('DOMContentLoaded', function() {
        const roleForms = document.querySelectorAll('.role-form');
        roleForms.forEach(function(form) {
            const select = form.querySelector('.role-select');
            const originalValue = select.value;
            
            select.addEventListener('change', function(event) {
                const currentSelect = event.target;
                if (currentSelect.value !== originalValue) {
                    const username = form.closest('tr').querySelector('.username').textContent.trim();
                    const confirmed = confirm('Change ' + username + '\'s role from ' + originalValue + ' to ' + currentSelect.value + '?');
                    if (!confirmed) {
                        currentSelect.value = originalValue;
                    }
                }
            });
        });
    });
</script>
</body>
</html>