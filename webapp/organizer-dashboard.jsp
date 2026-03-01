<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model.Event, model.User, dao.EventDAO" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ORGANIZER".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<Event> events = (List<Event>) request.getAttribute("events");
%>
<html>
<head>
<title>Organizer Dashboard - EventBiz</title>
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
        background: linear-gradient(rgba(30, 40, 60, 0.9), rgba(50, 70, 100, 0.95)), 
                    url('https://images.unsplash.com/photo-1511578314322-379afb476865?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        background-repeat: no-repeat;
        font-family: 'Montserrat', sans-serif;
        color: #333;
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
            radial-gradient(circle at 20% 30%, rgba(124, 77, 255, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 80% 70%, rgba(0, 188, 212, 0.15) 0%, transparent 50%),
            radial-gradient(circle at 40% 80%, rgba(255, 64, 129, 0.1) 0%, transparent 50%);
        animation: float 10s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .dashboard-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 2rem;
    }

    .header {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        padding: 2.5rem;
        border-radius: 20px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        margin-bottom: 2rem;
        border: 1px solid rgba(255, 255, 255, 0.3);
        position: relative;
        overflow: hidden;
    }

    .header::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background: linear-gradient(90deg, #7C4DFF, #00BCD4, #FF4081, #4CAF50);
        background-size: 400% 400%;
        animation: gradientShift 4s ease infinite;
    }

    h1 {
        font-family: 'Playfair Display', serif;
        font-size: 3.5rem;
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 1rem;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
    }

    .welcome-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .user-info {
        font-size: 1.2rem;
        color: #4A5568;
        font-weight: 600;
    }

    .user-role {
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        color: white;
        padding: 0.5rem 1.5rem;
        border-radius: 25px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 0.9rem;
        box-shadow: 0 4px 15px rgba(124, 77, 255, 0.3);
    }

    .navigation {
        display: flex;
        gap: 1.5rem;
        margin-top: 1rem;
        flex-wrap: wrap;
    }

    .nav-link {
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        color: white;
        padding: 12px 25px;
        text-decoration: none;
        border-radius: 12px;
        font-weight: 700;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 15px rgba(124, 77, 255, 0.3);
    }

    .nav-link:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(124, 77, 255, 0.5);
    }

    .nav-link.logout {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
    }

    .events-section {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        padding: 2.5rem;
        border-radius: 20px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        border: 1px solid rgba(255, 255, 255, 0.3);
    }

    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        flex-wrap: wrap;
        gap: 1rem;
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 2.5rem;
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }

    .events-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    }

    .events-table th {
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        color: white;
        padding: 1.2rem;
        text-align: left;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 0.9rem;
    }

    .events-table td {
        padding: 1.2rem;
        border-bottom: 1px solid #E2E8F0;
        transition: all 0.3s ease;
    }

    .events-table tr:hover td {
        background: rgba(124, 77, 255, 0.05);
        transform: translateX(5px);
    }

    .events-table tr:last-child td {
        border-bottom: none;
    }

    .event-title {
        font-weight: 700;
        color: #2D3748;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .event-title:hover {
        color: #7C4DFF;
        text-decoration: underline;
    }

    .status-badge {
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 700;
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .status-active {
        background: linear-gradient(135deg, #4CAF50, #81C784);
        color: white;
    }

    .status-cancelled {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
        color: white;
    }

    .status-upcoming {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
    }

    .action-buttons {
        display: flex;
        gap: 0.8rem;
        flex-wrap: wrap;
    }

    .btn {
        padding: 0.6rem 1.2rem;
        border: none;
        border-radius: 8px;
        font-weight: 600;
        font-size: 0.85rem;
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

    .no-events {
        text-align: center;
        padding: 3rem;
        color: #718096;
        font-size: 1.2rem;
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .stat-card {
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        color: white;
        padding: 1.5rem;
        border-radius: 15px;
        text-align: center;
        box-shadow: 0 8px 25px rgba(124, 77, 255, 0.3);
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

    .dashboard-container {
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
    @media (max-width: 768px) {
        .dashboard-container {
            padding: 1rem;
        }
        
        .header, .events-section {
            padding: 1.5rem;
        }
        
        h1 {
            font-size: 2.5rem;
        }
        
        h2 {
            font-size: 2rem;
        }
        
        .events-table {
            font-size: 0.9rem;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .welcome-section {
            flex-direction: column;
            align-items: flex-start;
        }
    }

    @media (max-width: 480px) {
        .events-table {
            display: block;
            overflow-x: auto;
        }
        
        .navigation {
            flex-direction: column;
        }
        
        .nav-link {
            justify-content: center;
        }
    }
</style>
</head>
<body>
<div class="dashboard-container">
    <div class="header">
        <h1>🎪 Organizer Dashboard</h1>
        
        <div class="welcome-section">
            <div class="user-info">
                👋 Welcome, <strong><%= currentUser.getUsername() %></strong>
                <span class="user-role">🎭 <%= currentUser.getRole() %></span>
            </div>
        </div>

        <div class="navigation">
            <a href="<%=request.getContextPath()%>/event/create" class="nav-link">
                📅 Create New Event
            </a>
            <a href="<%=request.getContextPath()%>/logout" class="nav-link logout">
                🚪 Logout
            </a>
        </div>
    </div>

    <div class="events-section">
        <div class="section-header">
            <h2>📋 Your Events</h2>
        </div>

        <% if (events != null && !events.isEmpty()) { 
            int totalEvents = events.size();
            int activeEvents = 0;
            int totalRegistrations = 0;
            dao.EventDAO eventDao = new dao.EventDAO();
            
            for (Event e : events) {
                if ("ACTIVE".equalsIgnoreCase(e.getStatus())) activeEvents++;
                try { totalRegistrations += eventDao.countRegistered(e.getId()); } catch(Exception ex) {}
            }
        %>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= totalEvents %></div>
                <div class="stat-label">Total Events</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= activeEvents %></div>
                <div class="stat-label">Active Events</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalRegistrations %></div>
                <div class="stat-label">Total Registrations</div>
            </div>
        </div>

        <table class="events-table">
            <thead>
                <tr>
                    <th>🎯 ID</th>
                    <th>📝 Title</th>
                    <th>⏰ Start</th>
                    <th>⏱️ End</th>
                    <th>👥 Capacity</th>
                    <th>📊 Status</th>
                    <th>✅ Registered</th>
                    <th>⚡ Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (Event e : events) { 
                int regCount = 0;
                try { regCount = eventDao.countRegistered(e.getId()); } catch(Exception ex) { regCount = 0; }
                
                String statusClass = "status-upcoming";
                if ("ACTIVE".equalsIgnoreCase(e.getStatus())) statusClass = "status-active";
                else if ("CANCELLED".equalsIgnoreCase(e.getStatus())) statusClass = "status-cancelled";
            %>
                <tr>
                    <td><strong>#<%= e.getId() %></strong></td>
                    <td>
                        <a href="<%=request.getContextPath()%>/event/view?id=<%=e.getId()%>" class="event-title">
                            <%= e.getTitle() %>
                        </a>
                    </td>
                    <td><%= e.getStartTime() %></td>
                    <td><%= e.getEndTime() %></td>
                    <td><%= e.getCapacity() %></td>
                    <td>
                        <span class="status-badge <%= statusClass %>">
                            <%= e.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <strong><%= regCount %> / <%= e.getCapacity() %></strong>
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
                            <a href="<%=request.getContextPath()%>/event/view?id=<%=e.getId()%>" class="btn btn-view">
                                👁️ View
                            </a>
                        </div>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
            <div class="no-events">
                <h3>📭 No Events Found</h3>
                <p>You haven't created any events yet. Start by creating your first event!</p>
                <a href="<%=request.getContextPath()%>/event/create" class="nav-link" style="margin-top: 1rem; display: inline-block;">
                    🚀 Create Your First Event
                </a>
            </div>
        <% } %>
    </div>
</div>

<script>
    // Add confirmation for cancel actions
    document.addEventListener('DOMContentLoaded', function() {
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