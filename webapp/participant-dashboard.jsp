<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, model.Event, model.User, model.Ticket, dao.TicketDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // registered events set by ParticipantDashboardServlet
    List<Event> regs = (List<Event>) request.getAttribute("registeredEvents");

    // load tickets for this user (TicketDAO.listByUser)
    List<Ticket> tickets = null;
    try {
        TicketDAO tdao = new TicketDAO();
        tickets = tdao.listByUser(user.getId());
    } catch (Exception ex) {
        tickets = null;
    }
%>
<html>
<head>
  <title>Participant Dashboard - EventBiz</title>
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
        background: linear-gradient(rgba(50, 60, 80, 0.9), rgba(70, 90, 120, 0.95)), 
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
            radial-gradient(circle at 20% 30%, rgba(76, 175, 80, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 80% 70%, rgba(33, 150, 243, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 40% 80%, rgba(156, 39, 176, 0.15) 0%, transparent 50%);
        animation: float 10s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .dashboard-container {
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

    .dashboard-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background: linear-gradient(90deg, #4CAF50, #2196F3, #9C27B0, #FF9800);
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
        background: linear-gradient(135deg, #4CAF50, #2196F3);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 1rem;
    }

    .welcome-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        flex-wrap: wrap;
        gap: 1rem;
        background: linear-gradient(135deg, rgba(76, 175, 80, 0.1), rgba(33, 150, 243, 0.1));
        padding: 1.5rem;
        border-radius: 15px;
        border-left: 4px solid #4CAF50;
    }

    .user-info {
        font-size: 1.2rem;
        color: #2D3748;
        font-weight: 600;
    }

    .user-role {
        background: linear-gradient(135deg, #4CAF50, #2196F3);
        color: white;
        padding: 0.5rem 1.5rem;
        border-radius: 25px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 0.9rem;
        box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
    }

    .navigation {
        display: flex;
        gap: 1rem;
        margin-top: 1rem;
        flex-wrap: wrap;
    }

    .nav-link {
        background: linear-gradient(135deg, #4CAF50, #2196F3);
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 10px;
        font-weight: 600;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        font-size: 0.9rem;
    }

    .nav-link:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(76, 175, 80, 0.5);
    }

    .nav-link.logout {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
    }

    .section {
        margin: 3rem 0;
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 2.5rem;
        background: linear-gradient(135deg, #4CAF50, #2196F3);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        margin-bottom: 2rem;
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .events-table-container, .tickets-table-container {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        margin-bottom: 2rem;
    }

    .events-table, .tickets-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .events-table th, .tickets-table th {
        background: linear-gradient(135deg, #4CAF50, #2196F3);
        color: white;
        padding: 1.5rem;
        text-align: left;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 0.9rem;
        position: relative;
    }

    .events-table th::after, .tickets-table th::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: rgba(255, 255, 255, 0.3);
    }

    .events-table td, .tickets-table td {
        padding: 1.3rem 1.5rem;
        border-bottom: 1px solid #E2E8F0;
        transition: all 0.3s ease;
        color: #4A5568;
        vertical-align: middle;
    }

    .events-table tr:hover td, .tickets-table tr:hover td {
        background: rgba(76, 175, 80, 0.05);
        transform: translateX(5px);
    }

    .events-table tr:last-child td, .tickets-table tr:last-child td {
        border-bottom: none;
    }

    .event-title, .ticket-link {
        font-weight: 700;
        color: #2D3748;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .event-title:hover, .ticket-link:hover {
        color: #4CAF50;
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

    .status-paid {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .status-pending {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
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

    .btn-buy {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
    }

    .btn-pay {
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
        background: rgba(76, 175, 80, 0.05);
        border-radius: 15px;
        border: 2px dashed #4CAF50;
    }

    .no-data h3 {
        margin-bottom: 1rem;
        color: #4A5568;
    }

    .qr {
        width: 100px;
        height: 100px;
        border-radius: 10px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        transition: transform 0.3s ease;
    }

    .qr:hover {
        transform: scale(1.1);
    }

    .price {
        font-weight: 700;
        color: #4CAF50;
        font-size: 1.1rem;
    }

    .ticket-code {
        font-family: 'Courier New', monospace;
        font-weight: 700;
        color: #2D3748;
        background: rgba(76, 175, 80, 0.1);
        padding: 0.3rem 0.8rem;
        border-radius: 8px;
        font-size: 0.9rem;
    }

    /* Stats Section */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 3rem;
    }

    .stat-card {
        background: linear-gradient(135deg, #4CAF50, #2196F3);
        color: white;
        padding: 1.5rem;
        border-radius: 15px;
        text-align: center;
        box-shadow: 0 8px 25px rgba(76, 175, 80, 0.3);
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
    @media (max-width: 1024px) {
        .dashboard-container {
            padding: 2rem;
        }
        
        .events-table, .tickets-table {
            font-size: 0.9rem;
        }
        
        .events-table th, .events-table td,
        .tickets-table th, .tickets-table td {
            padding: 1rem;
        }
    }

    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .dashboard-container {
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
        
        .events-table-container, .tickets-table-container {
            overflow-x: auto;
        }
        
        .stats-grid {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 480px) {
        .dashboard-container {
            padding: 1rem;
        }
        
        h1 {
            font-size: 2rem;
        }
        
        h2 {
            font-size: 1.6rem;
        }
        
        .events-table, .tickets-table {
            min-width: 800px;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .btn {
            justify-content: center;
        }
        
        .qr {
            width: 80px;
            height: 80px;
        }
    }

    /* Quick actions */
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin: 2rem 0;
    }

    .action-card {
        background: linear-gradient(135deg, #4CAF50, #2196F3);
        color: white;
        padding: 2rem;
        border-radius: 15px;
        text-align: center;
        text-decoration: none;
        transition: all 0.3s ease;
        box-shadow: 0 8px 25px rgba(76, 175, 80, 0.3);
    }

    .action-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(76, 175, 80, 0.4);
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
</style>
</head>
<body>
<div class="dashboard-container">
    <div class="header">
        <h1>🎟️ Participant Dashboard</h1>
    </div>
    
    <div class="welcome-section">
        <div class="user-info">
            👋 Welcome, <strong><%= user.getUsername() %></strong>
            <span class="user-role">🎭 <%= user.getRole() %></span>
        </div>
        
        <div class="navigation">
            <a href="<%=request.getContextPath()%>/events" class="nav-link">
                📅 Browse Events
            </a>
            <a href="<%=request.getContextPath()%>/venues" class="nav-link">
                🏛️ Browse Venues
            </a>
            <a href="<%=request.getContextPath()%>/billing" class="nav-link">
                💳 Billing / Transactions
            </a>
            <a href="<%=request.getContextPath()%>/logout" class="nav-link logout">
                🚪 Logout
            </a>
        </div>
    </div>

    <div class="quick-actions">
        <a href="<%=request.getContextPath()%>/events" class="action-card">
            <span class="action-icon">🎪</span>
            <div class="action-text">Browse Events</div>
        </a>
        <a href="<%=request.getContextPath()%>/venues" class="action-card">
            <span class="action-icon">🏛️</span>
            <div class="action-text">View Venues</div>
        </a>
        <a href="<%=request.getContextPath()%>/billing" class="action-card">
            <span class="action-icon">💳</span>
            <div class="action-text">Billing</div>
        </a>
    </div>

    <% 
        int totalRegistrations = regs != null ? regs.size() : 0;
        int totalTickets = tickets != null ? tickets.size() : 0;
        int paidTickets = 0;
        if (tickets != null) {
            for (Ticket t : tickets) {
                if ("PAID".equalsIgnoreCase(t.getStatus())) paidTickets++;
            }
        }
    %>
    
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-number"><%= totalRegistrations %></div>
            <div class="stat-label">Event Registrations</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><%= totalTickets %></div>
            <div class="stat-label">Total Tickets</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><%= paidTickets %></div>
            <div class="stat-label">Paid Tickets</div>
        </div>
    </div>

    <div class="section">
        <h2>📋 Your Event Registrations</h2>
        
        <% if (regs == null || regs.isEmpty()) { %>
            <div class="no-data">
                <h3>📭 No Event Registrations</h3>
                <p>You haven't registered for any events yet.</p>
                <a href="<%=request.getContextPath()%>/events" class="nav-link" style="margin-top: 1rem; display: inline-block;">
                    🎪 Browse Available Events
                </a>
            </div>
        <% } else { %>
            <div class="events-table-container">
                <table class="events-table">
                    <thead>
                        <tr>
                            <th>🎪 Event</th>
                            <th>⏰ Start</th>
                            <th>⏱️ End</th>
                            <th>🏛️ Venue</th>
                            <th>📊 Status</th>
                            <th>⚡ Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Event e : regs) { 
                            String statusClass = "status-scheduled";
                            if ("ACTIVE".equalsIgnoreCase(e.getStatus())) statusClass = "status-active";
                            else if ("COMPLETED".equalsIgnoreCase(e.getStatus())) statusClass = "status-completed";
                            else if ("CANCELLED".equalsIgnoreCase(e.getStatus())) statusClass = "status-cancelled";
                        %>
                            <tr>
                                <td>
                                    <a href="<%=request.getContextPath()%>/event/view?id=<%= e.getId() %>" class="event-title">
                                        <%= e.getTitle() %>
                                    </a>
                                </td>
                                <td><%= e.getStartTime() %></td>
                                <td><%= e.getEndTime() %></td>
                                <td><%= e.getVenueId() == null ? "-" : e.getVenueId() %></td>
                                <td>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= e.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<%=request.getContextPath()%>/event/view?id=<%= e.getId() %>" class="btn btn-view">
                                            👁️ View
                                        </a>
                                        <a href="<%=request.getContextPath()%>/ticket/purchase?event_id=<%= e.getId() %>&price=100" class="btn btn-buy">
                                            🎫 Buy Ticket
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <div class="section">
        <h2>🎫 Your Tickets</h2>
        
        <% if (tickets == null || tickets.isEmpty()) { %>
            <div class="no-data">
                <h3>🎟️ No Tickets Yet</h3>
                <p>You haven't purchased any tickets yet.</p>
                <a href="<%=request.getContextPath()%>/events" class="nav-link" style="margin-top: 1rem; display: inline-block;">
                    🎪 Browse Events to Get Tickets
                </a>
            </div>
        <% } else { %>
            <div class="tickets-table-container">
                <table class="tickets-table">
                    <thead>
                        <tr>
                            <th>🆔 Ticket ID</th>
                            <th>🎪 Event ID</th>
                            <th>🔒 Code</th>
                            <th>💰 Price</th>
                            <th>📊 Status</th>
                            <th>⏰ Paid At</th>
                            <th>📱 QR Code</th>
                            <th>⚡ Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Ticket t : tickets) { 
                            String statusClass = "status-pending";
                            if ("PAID".equalsIgnoreCase(t.getStatus())) statusClass = "status-paid";
                        %>
                            <tr>
                                <td><strong>#<%= t.getId() %></strong></td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/event/view?id=<%= t.getEventId() %>" class="ticket-link">
                                        #<%= t.getEventId() %>
                                    </a>
                                </td>
                                <td>
                                    <span class="ticket-code"><%= t.getTicketCode() %></span>
                                </td>
                                <td class="price">$<%= String.format("%.2f", t.getPrice()) %></td>
                                <td>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= t.getStatus() %>
                                    </span>
                                </td>
                                <td><%= t.getPaidAt() == null ? "-" : t.getPaidAt() %></td>
                                <td>
                                    <% if ("PAID".equalsIgnoreCase(t.getStatus())) { %>
                                        <img class="qr" src="<%=request.getContextPath()%>/ticket/qrcode?code=<%= t.getTicketCode() %>" alt="QR Code"/>
                                    <% } else { %>
                                        <span style="color: #718096;">-</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<%=request.getContextPath()%>/ticket/view?id=<%= t.getId() %>" class="btn btn-view">
                                            👁️ View
                                        </a>
                                        <% if (!"PAID".equalsIgnoreCase(t.getStatus())) { %>
                                            <a href="<%=request.getContextPath()%>/ticket/purchase?event_id=<%= t.getEventId() %>&price=<%= t.getPrice() %>" class="btn btn-pay">
                                                💳 Pay Now
                                            </a>
                                        <% } %>
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
        const eventRows = document.querySelectorAll('.events-table tbody tr');
        const ticketRows = document.querySelectorAll('.tickets-table tbody tr');
        
        eventRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.1}s`;
            row.style.animation = 'fadeInUp 0.5s ease-out forwards';
            row.style.opacity = '0';
        });
        
        ticketRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.1 + 0.2}s`;
            row.style.animation = 'fadeInUp 0.5s ease-out forwards';
            row.style.opacity = '0';
        });
    });
</script>
</body>
</html>