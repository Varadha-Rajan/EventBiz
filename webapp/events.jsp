<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, model.Event, model.User, dao.VenueDAO, model.Venue" %>
<%
    List<Event> events = (List<Event>) request.getAttribute("events");
    User currentUser = (User) session.getAttribute("user");
    VenueDAO vdao = new VenueDAO();
%>
<html>
<head>
<title>Events - EventBiz</title>
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
            radial-gradient(circle at 20% 30%, rgba(124, 77, 255, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 80% 70%, rgba(0, 188, 212, 0.15) 0%, transparent 50%),
            radial-gradient(circle at 40% 80%, rgba(255, 64, 129, 0.1) 0%, transparent 50%);
        animation: float 10s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .events-container {
        max-width: 1400px;
        margin: 0 auto;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        padding: 3rem;
        border-radius: 25px;
        box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
        border: 1px solid rgba(255, 255, 255, 0.3);
        position: relative;
        overflow: hidden;
    }

    .events-container::before {
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

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 3rem;
        text-align: center;
        margin-bottom: 2rem;
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        position: relative;
    }

    h2::after {
        content: '🎪';
        position: absolute;
        top: -10px;
        right: -10px;
        font-size: 2rem;
        animation: bounce 2s ease-in-out infinite;
    }

    .navigation {
        display: flex;
        justify-content: center;
        gap: 1.5rem;
        margin-bottom: 2.5rem;
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
        font-size: 0.95rem;
    }

    .nav-link:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(124, 77, 255, 0.5);
    }

    .nav-link.create {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
    }

    .nav-link.venues {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
    }

    .events-table-container {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        margin-top: 1.5rem;
    }

    .events-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .events-table th {
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        color: white;
        padding: 1.5rem;
        text-align: left;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 0.9rem;
        position: relative;
    }

    .events-table th::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: rgba(255, 255, 255, 0.3);
    }

    .events-table td {
        padding: 1.3rem 1.5rem;
        border-bottom: 1px solid #E2E8F0;
        transition: all 0.3s ease;
        color: #4A5568;
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
        font-size: 1.1rem;
    }

    .event-title:hover {
        color: #7C4DFF;
        text-decoration: underline;
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

    .status-completed {
        background: linear-gradient(135deg, #9E9E9E, #BDBDBD);
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

    .btn-view {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
        color: white;
    }

    .btn-edit {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    .no-events {
        text-align: center;
        padding: 4rem 2rem;
        color: #718096;
        font-size: 1.2rem;
    }

    .no-events h3 {
        margin-bottom: 1rem;
        color: #4A5568;
    }

    .venue-name {
        font-weight: 600;
        color: #2D3748;
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .capacity-info {
        font-weight: 600;
        color: #2D3748;
        text-align: center;
    }

    .datetime-cell {
        font-family: 'Courier New', monospace;
        font-size: 0.9rem;
        color: #4A5568;
    }

    /* Stats Section */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2.5rem;
    }

    .stat-card {
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        color: white;
        padding: 1.5rem;
        border-radius: 15px;
        text-align: center;
        box-shadow: 0 8px 25px rgba(124, 77, 255, 0.3);
        transition: transform 0.3s ease;
    }

    .stat-card:hover {
        transform: translateY(-5px);
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

    @keyframes bounce {
        0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
        40% { transform: translateY(-10px); }
        60% { transform: translateY(-5px); }
    }

    .events-container {
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
        .events-container {
            padding: 2rem;
        }
        
        .events-table {
            font-size: 0.9rem;
        }
        
        .events-table th,
        .events-table td {
            padding: 1rem;
        }
    }

    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .events-container {
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
        
        .events-table-container {
            overflow-x: auto;
        }
        
        .stats-grid {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 480px) {
        .events-container {
            padding: 1rem;
        }
        
        h2 {
            font-size: 1.8rem;
        }
        
        .events-table {
            min-width: 800px;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .btn {
            justify-content: center;
        }
    }

    /* User role indicator */
    .user-role {
        text-align: center;
        margin-bottom: 1.5rem;
        font-weight: 600;
        color: #4A5568;
    }

    .user-role span {
        background: linear-gradient(135deg, #7C4DFF, #00BCD4);
        color: white;
        padding: 0.3rem 1rem;
        border-radius: 15px;
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 1px;
    }
</style>
</head>
<body>
<div class="events-container">
    <h2>All Events</h2>
    
    <% if (currentUser != null) { %>
        <div class="user-role">
            👋 Welcome, <strong><%= currentUser.getUsername() %></strong> 
            <span>🎭 <%= currentUser.getRole() %></span>
        </div>
    <% } %>
    
    <div class="navigation">
        <% if (currentUser != null && ("ORGANIZER".equalsIgnoreCase(currentUser.getRole()) || "ADMIN".equalsIgnoreCase(currentUser.getRole()))) { %>
            <a href="<%=request.getContextPath()%>/event/create" class="nav-link create">
                📅 Create New Event
            </a>
        <% } %>
        <a href="<%=request.getContextPath()%>/venues" class="nav-link venues">
            🏛️ View Venues
        </a>
    </div>

    <% 
        if (events != null && !events.isEmpty()) { 
        int totalEvents = events.size();
        int activeEvents = 0;
        int upcomingEvents = 0;
        
        for (Event e : events) {
            if ("ACTIVE".equalsIgnoreCase(e.getStatus())) activeEvents++;
            else if ("UPCOMING".equalsIgnoreCase(e.getStatus())) upcomingEvents++;
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
            <div class="stat-number"><%= upcomingEvents %></div>
            <div class="stat-label">Upcoming Events</div>
        </div>
    </div>

    <div class="events-table-container">
        <table class="events-table">
            <thead>
                <tr>
                    <th>📝 Event Title</th>
                    <th>⏰ Start Time</th>
                    <th>⏱️ End Time</th>
                    <th>🏛️ Venue</th>
                    <th>👥 Capacity</th>
                    <th>📊 Status</th>
                    <th>⚡ Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (Event e : events) { 
                String venueName = "-";
                try {
                    if (e.getVenueId() != null) {
                        Venue v = vdao.findById(e.getVenueId());
                        if (v != null) venueName = v.getName();
                    }
                } catch(Exception ex) { venueName = "Error"; }
                
                String statusClass = "status-upcoming";
                if ("ACTIVE".equalsIgnoreCase(e.getStatus())) statusClass = "status-active";
                else if ("CANCELLED".equalsIgnoreCase(e.getStatus())) statusClass = "status-cancelled";
                else if ("COMPLETED".equalsIgnoreCase(e.getStatus())) statusClass = "status-completed";
            %>
                <tr>
                    <td>
                        <a href="<%=request.getContextPath()%>/event/view?id=<%=e.getId()%>" class="event-title">
                            <%= e.getTitle() %>
                        </a>
                    </td>
                    <td class="datetime-cell"><%= e.getStartTime() %></td>
                    <td class="datetime-cell"><%= e.getEndTime() %></td>
                    <td>
                        <span class="venue-name">
                            🏛️ <%= venueName %>
                        </span>
                    </td>
                    <td class="capacity-info">
                        <%= e.getCapacity() %>
                    </td>
                    <td>
                        <span class="status-badge <%= statusClass %>">
                            <%= e.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <a href="<%=request.getContextPath()%>/event/view?id=<%=e.getId()%>" class="btn btn-view">
                                👁️ View
                            </a>
                            <% if (currentUser != null && ("ADMIN".equalsIgnoreCase(currentUser.getRole()) || currentUser.getId() == e.getOrganizerId())) { %>
                                <a href="<%=request.getContextPath()%>/event/update?id=<%=e.getId()%>" class="btn btn-edit">
                                    ✏️ Edit
                                </a>
                            <% } %>
                        </div>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
        <div class="no-events">
            <h3>📭 No Events Found</h3>
            <p>There are currently no events available. Check back later or create a new event!</p>
            <% if (currentUser != null && ("ORGANIZER".equalsIgnoreCase(currentUser.getRole()) || "ADMIN".equalsIgnoreCase(currentUser.getRole()))) { %>
                <a href="<%=request.getContextPath()%>/event/create" class="nav-link create" style="margin-top: 1rem; display: inline-block;">
                    🚀 Create Your First Event
                </a>
            <% } %>
        </div>
    <% } %>
</div>

<script>
    // Add hover effects and animations
    document.addEventListener('DOMContentLoaded', function() {
        // Add loading animation to table rows
        const tableRows = document.querySelectorAll('.events-table tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.1}s`;
            row.style.animation = 'fadeInUp 0.5s ease-out forwards';
            row.style.opacity = '0';
        });
    });
</script>
</body>
</html>