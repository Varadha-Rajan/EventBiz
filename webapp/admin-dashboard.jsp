<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Event, model.User, dao.EventDAO" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Event> events = (List<Event>) request.getAttribute("events");
    List<User> users = (List<User>) request.getAttribute("users");
%>
<html>
<head>
<title>Admin Dashboard - EventBiz</title>
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
                    url('https://images.unsplash.com/photo-1553877522-43269d4ea984?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
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

    .admin-container {
        max-width: 1600px;
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

    .admin-container::before {
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

    h1 {
        font-family: 'Playfair Display', serif;
        font-size: 3.5rem;
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

    .welcome-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        flex-wrap: wrap;
        gap: 1rem;
        background: linear-gradient(135deg, rgba(156, 39, 176, 0.1), rgba(103, 58, 183, 0.1));
        padding: 1.5rem;
        border-radius: 15px;
        border-left: 4px solid #9C27B0;
    }

    .user-info {
        font-size: 1.2rem;
        color: #2D3748;
        font-weight: 600;
    }

    .user-role {
        background: linear-gradient(135deg, #9C27B0, #673AB7);
        color: white;
        padding: 0.5rem 1.5rem;
        border-radius: 25px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 0.9rem;
        box-shadow: 0 4px 15px rgba(156, 39, 176, 0.3);
    }

    .navigation {
        display: flex;
        gap: 1rem;
        margin-top: 1rem;
        flex-wrap: wrap;
    }

    .nav-link {
        background: linear-gradient(135deg, #9C27B0, #673AB7);
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 10px;
        font-weight: 600;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 15px rgba(156, 39, 176, 0.3);
        font-size: 0.9rem;
    }

    .nav-link:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(156, 39, 176, 0.5);
    }

    .nav-link.logout {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
    }

    /* Stats Section */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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

    .stat-card.users {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
    }

    .stat-card.events {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
    }

    .stat-card.venues {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
    }

    .stat-card.revenue {
        background: linear-gradient(135deg, #9C27B0, #BA68C8);
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

    /* Sections */
    .section {
        margin: 3rem 0;
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 2.5rem;
        background: linear-gradient(135deg, #9C27B0, #673AB7);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 2rem;
        display: flex;
        align-items: center;
        gap: 15px;
        padding-bottom: 10px;
        border-bottom: 3px solid #E2E8F0;
    }

    .table-container {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        margin-bottom: 2rem;
    }

    .users-table, .events-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .users-table th, .events-table th {
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

    .users-table th::after, .events-table th::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: rgba(255, 255, 255, 0.3);
    }

    .users-table td, .events-table td {
        padding: 1.3rem 1.5rem;
        border-bottom: 1px solid #E2E8F0;
        transition: all 0.3s ease;
        color: #4A5568;
        vertical-align: middle;
    }

    .users-table tr:hover td, .events-table tr:hover td {
        background: rgba(156, 39, 176, 0.05);
        transform: translateX(5px);
    }

    .users-table tr:last-child td, .events-table tr:last-child td {
        border-bottom: none;
    }

    .user-id, .event-id {
        font-weight: 700;
        color: #2D3748;
        font-family: 'Courier New', monospace;
    }

    .event-title {
        font-weight: 700;
        color: #2D3748;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .event-title:hover {
        color: #9C27B0;
        text-decoration: underline;
    }

    .role-badge {
        padding: 0.4rem 0.8rem;
        border-radius: 15px;
        font-weight: 600;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        display: inline-block;
    }

    .role-admin {
        background: linear-gradient(135deg, #9C27B0, #BA68C8);
        color: white;
    }

    .role-organizer {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
        color: white;
    }

    .role-participant {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .status-badge {
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        display: inline-block;
        text-align: center;
        min-width: 80px;
    }

    .status-active {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .status-scheduled {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
    }

    .status-completed {
        background: linear-gradient(135deg, #9E9E9E, #BDBDBD);
        color: white;
    }

    .status-cancelled {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
        color: white;
    }

    .action-buttons {
        display: flex;
        gap: 0.8rem;
        flex-wrap: wrap;
    }

    .btn {
        padding: 0.5rem 1rem;
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

    .btn-edit {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
        color: white;
    }

    .btn-cancel {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
        color: white;
    }

    .btn-view {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    .no-data {
        text-align: center;
        padding: 3rem;
        color: #718096;
        font-size: 1.2rem;
        background: rgba(156, 39, 176, 0.05);
        border-radius: 15px;
        border: 2px dashed #9C27B0;
    }

    .no-data h3 {
        margin-bottom: 1rem;
        color: #4A5568;
    }

    .datetime {
        font-family: 'Courier New', monospace;
        font-size: 0.9rem;
        color: #718096;
    }

    .capacity-info {
        font-weight: 600;
        color: #2D3748;
        text-align: center;
    }

    .registration-count {
        background: rgba(76, 175, 80, 0.1);
        padding: 0.4rem 0.8rem;
        border-radius: 15px;
        font-weight: 700;
        color: #4CAF50;
        font-size: 0.9rem;
    }

    /* Quick Actions */
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin: 2rem 0;
    }

    .action-card {
        background: linear-gradient(135deg, #9C27B0, #673AB7);
        color: white;
        padding: 2rem;
        border-radius: 15px;
        text-align: center;
        text-decoration: none;
        transition: all 0.3s ease;
        box-shadow: 0 8px 25px rgba(156, 39, 176, 0.3);
    }

    .action-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(156, 39, 176, 0.4);
    }

    .action-icon {
        font-size: 2.5rem;
        margin-bottom: 1rem;
        display: block;
    }

    .action-text {
        font-weight: 700;
        font-size: 1.1rem;
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

    .admin-container {
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
        .admin-container {
            padding: 2rem;
        }
        
        .users-table, .events-table {
            font-size: 0.9rem;
        }
        
        .users-table th, .users-table td,
        .events-table th, .events-table td {
            padding: 1rem;
        }
    }

    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .admin-container {
            padding: 1.5rem;
        }
        
        h1 {
            font-size: 2.5rem;
        }
        
        h2 {
            font-size: 2rem;
        }
        
        .welcome-section {
            flex-direction: column;
            text-align: center;
        }
        
        .navigation {
            justify-content: center;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        .stats-grid {
            grid-template-columns: repeat(2, 1fr);
        }
        
        .quick-actions {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 480px) {
        .admin-container {
            padding: 1rem;
        }
        
        h1 {
            font-size: 2rem;
        }
        
        h2 {
            font-size: 1.6rem;
        }
        
        .users-table, .events-table {
            min-width: 800px;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .btn {
            justify-content: center;
        }
        
        .stats-grid {
            grid-template-columns: 1fr;
        }
    }
</style>
</head>
<body>
<div class="admin-container">
    <div class="header">
        <div class="admin-icon">⚡</div>
        <h1>Admin Dashboard</h1>
    </div>
    
    <div class="welcome-section">
        <div class="user-info">
            🎯 Welcome, <strong><%= currentUser.getUsername() %></strong>
            <span class="user-role">👑 <%= currentUser.getRole() %></span>
        </div>
        
        <div class="navigation">
            <a href="<%=request.getContextPath()%>/admin/users" class="nav-link">
                👥 Manage Users
            </a>
            <a href="<%=request.getContextPath()%>/admin/payments" class="nav-link">
                💳 Manage Payments
            </a>
            <a href="<%=request.getContextPath()%>/admin/reports" class="nav-link">
                📊 Reports
            </a>
            <a href="<%=request.getContextPath()%>/venues" class="nav-link">
                🏛️ Manage Venues
            </a>
            <a href="<%=request.getContextPath()%>/logout" class="nav-link logout">
                🚪 Logout
            </a>
        </div>
    </div>

    <div class="quick-actions">
        <a href="<%=request.getContextPath()%>/admin/users" class="action-card">
            <span class="action-icon">👥</span>
            <div class="action-text">User Management</div>
        </a>
        <a href="<%=request.getContextPath()%>/admin/payments" class="action-card">
            <span class="action-icon">💳</span>
            <div class="action-text">Payment Overview</div>
        </a>
        <a href="<%=request.getContextPath()%>/admin/reports" class="action-card">
            <span class="action-icon">📊</span>
            <div class="action-text">Analytics & Reports</div>
        </a>
        <a href="<%=request.getContextPath()%>/venues" class="action-card">
            <span class="action-icon">🏛️</span>
            <div class="action-text">Venue Management</div>
        </a>
    </div>

    <% 
        int totalUsers = users != null ? users.size() : 0;
        int totalEvents = events != null ? events.size() : 0;
        int activeEvents = 0;
        int totalRegistrations = 0;
        
        if (events != null) {
            EventDAO edao = new EventDAO();
            for (Event e : events) {
                if ("ACTIVE".equalsIgnoreCase(e.getStatus())) activeEvents++;
                try { totalRegistrations += edao.countRegistered(e.getId()); } catch(Exception ex) {}
            }
        }
    %>
    
    <div class="stats-grid">
        <div class="stat-card users">
            <span class="stat-icon">👥</span>
            <div class="stat-number"><%= totalUsers %></div>
            <div class="stat-label">Total Users</div>
        </div>
        <div class="stat-card events">
            <span class="stat-icon">🎪</span>
            <div class="stat-number"><%= totalEvents %></div>
            <div class="stat-label">Total Events</div>
        </div>
        <div class="stat-card venues">
            <span class="stat-icon">🏛️</span>
            <div class="stat-number"><%= activeEvents %></div>
            <div class="stat-label">Active Events</div>
        </div>
        <div class="stat-card revenue">
            <span class="stat-icon">💰</span>
            <div class="stat-number"><%= totalRegistrations %></div>
            <div class="stat-label">Total Registrations</div>
        </div>
    </div>

    <div class="section">
        <h2>👥 Users</h2>
        
        <% if (users == null || users.isEmpty()) { %>
            <div class="no-data">
                <h3>👤 No Users Found</h3>
                <p>There are currently no users in the system.</p>
            </div>
        <% } else { %>
            <div class="table-container">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>🆔 User ID</th>
                            <th>👤 Username</th>
                            <th>📧 Email</th>
                            <th>🎭 Role</th>
                            <th>⏰ Created At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User u : users) { 
                            String roleClass = "role-" + u.getRole().toLowerCase();
                        %>
                            <tr>
                                <td class="user-id">#<%= u.getId() %></td>
                                <td><strong><%= u.getUsername() %></strong></td>
                                <td><%= u.getEmail() %></td>
                                <td>
                                    <span class="role-badge <%= roleClass %>">
                                        <%= u.getRole() %>
                                    </span>
                                </td>
                                <td class="datetime"><%= u.getCreatedAt() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <div class="section">
        <h2>🎪 Events</h2>
        
        <% if (events == null || events.isEmpty()) { %>
            <div class="no-data">
                <h3>📭 No Events Found</h3>
                <p>There are currently no events in the system.</p>
            </div>
        <% } else { %>
            <div class="table-container">
                <table class="events-table">
                    <thead>
                        <tr>
                            <th>🆔 Event ID</th>
                            <th>📝 Title</th>
                            <th>👤 Organizer ID</th>
                            <th>⏰ Start Time</th>
                            <th>⏱️ End Time</th>
                            <th>👥 Capacity</th>
                            <th>📊 Status</th>
                            <th>✅ Registered</th>
                            <th>⚡ Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            EventDAO edao = new EventDAO();
                            for (Event e : events) {
                                int regCount = 0;
                                try { regCount = edao.countRegistered(e.getId()); } catch(Exception ex) { regCount = 0; }
                                
                                String statusClass = "status-scheduled";
                                if ("ACTIVE".equalsIgnoreCase(e.getStatus())) statusClass = "status-active";
                                else if ("COMPLETED".equalsIgnoreCase(e.getStatus())) statusClass = "status-completed";
                                else if ("CANCELLED".equalsIgnoreCase(e.getStatus())) statusClass = "status-cancelled";
                        %>
                            <tr>
                                <td class="event-id">#<%= e.getId() %></td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/event/view?id=<%=e.getId()%>" class="event-title">
                                        <%= e.getTitle() %>
                                    </a>
                                </td>
                                <td class="user-id">#<%= e.getOrganizerId() %></td>
                                <td class="datetime"><%= e.getStartTime() %></td>
                                <td class="datetime"><%= e.getEndTime() %></td>
                                <td class="capacity-info"><%= e.getCapacity() %></td>
                                <td>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= e.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="registration-count">
                                        <%= regCount %>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<%=request.getContextPath()%>/event/update?id=<%=e.getId()%>" class="btn btn-edit">
                                            ✏️ Edit
                                        </a>
                                        <form method="post" action="<%=request.getContextPath()%>/event/cancel" style="display:inline">
                                            <input type="hidden" name="id" value="<%= e.getId() %>"/>
                                            <button type="submit" class="btn btn-cancel" onclick="return confirm('Are you sure you want to cancel this event?');">
                                                ❌ Cancel
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>

<script>
    // Add loading animations
    document.addEventListener('DOMContentLoaded', function() {
        // Animate table rows
        const userRows = document.querySelectorAll('.users-table tbody tr');
        const eventRows = document.querySelectorAll('.events-table tbody tr');
        
        userRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.1}s`;
            row.style.animation = 'fadeInUp 0.5s ease-out forwards';
            row.style.opacity = '0';
        });
        
        eventRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.1 + 0.2}s`;
            row.style.animation = 'fadeInUp 0.5s ease-out forwards';
            row.style.opacity = '0';
        });

        // Add confirmation for cancel actions
        const cancelButtons = document.querySelectorAll('.btn-cancel');
        cancelButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                if (!confirm('Are you sure you want to cancel this event? This action cannot be undone.')) {
                    e.preventDefault();
                }
            });
        });
    });
</script>
</body>
</html>