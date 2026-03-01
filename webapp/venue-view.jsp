<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, model.Venue, model.VenueBooking, model.User" %>
<%
    Venue v = (Venue) request.getAttribute("venue");
    List<VenueBooking> bookings = (List<VenueBooking>) request.getAttribute("bookings");
    User currentUser = (User) session.getAttribute("user");
%>
<html>
<head>
<title><%= v.getName() %> - EventBiz</title>
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
        background: linear-gradient(rgba(40, 50, 70, 0.9), rgba(60, 80, 110, 0.95)), 
                    url('https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
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
            radial-gradient(circle at 20% 30%, rgba(139, 69, 19, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 80% 70%, rgba(205, 127, 50, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 40% 80%, rgba(160, 82, 45, 0.15) 0%, transparent 50%);
        animation: float 8s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .venue-container {
        max-width: 1200px;
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

    .venue-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background: linear-gradient(90deg, #8B4513, #CD7F32, #A0522D, #D2691E);
        background-size: 400% 400%;
        animation: gradientShift 4s ease infinite;
    }

    .venue-header {
        text-align: center;
        margin-bottom: 3rem;
        position: relative;
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 3.5rem;
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 1rem;
    }

    .venue-icon {
        font-size: 4rem;
        margin-bottom: 1rem;
        animation: bounce 2s ease-in-out infinite;
        display: block;
    }

    .venue-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 2rem;
        margin-bottom: 3rem;
    }

    .detail-card {
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        color: white;
        padding: 2rem;
        border-radius: 15px;
        box-shadow: 0 8px 25px rgba(139, 69, 19, 0.3);
        transition: transform 0.3s ease;
    }

    .detail-card:hover {
        transform: translateY(-5px);
    }

    .detail-card h3 {
        font-size: 1.2rem;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 10px;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .detail-card p {
        font-size: 1.1rem;
        line-height: 1.6;
    }

    .capacity-badge {
        background: rgba(255, 255, 255, 0.2);
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 700;
        font-size: 1.3rem;
        display: inline-block;
        margin-top: 0.5rem;
    }

    .bookings-section {
        margin-top: 3rem;
    }

    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        flex-wrap: wrap;
        gap: 1rem;
    }

    h3 {
        font-family: 'Playfair Display', serif;
        font-size: 2.2rem;
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .bookings-table-container {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        margin-bottom: 2rem;
    }

    .bookings-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .bookings-table th {
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        color: white;
        padding: 1.5rem;
        text-align: left;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 0.9rem;
        position: relative;
    }

    .bookings-table th::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: rgba(255, 255, 255, 0.3);
    }

    .bookings-table td {
        padding: 1.3rem 1.5rem;
        border-bottom: 1px solid #E2E8F0;
        transition: all 0.3s ease;
        color: #4A5568;
        vertical-align: top;
    }

    .bookings-table tr:hover td {
        background: rgba(139, 69, 19, 0.05);
        transform: translateX(5px);
    }

    .bookings-table tr:last-child td {
        border-bottom: none;
    }

    .booking-title {
        font-weight: 700;
        color: #2D3748;
        font-size: 1.1rem;
    }

    .datetime-cell {
        font-family: 'Courier New', monospace;
        font-size: 0.9rem;
        color: #4A5568;
    }

    .user-id {
        background: rgba(139, 69, 19, 0.1);
        padding: 0.3rem 0.8rem;
        border-radius: 15px;
        font-weight: 600;
        color: #8B4513;
        font-size: 0.85rem;
    }

    .no-bookings {
        text-align: center;
        padding: 4rem 2rem;
        color: #718096;
        font-size: 1.2rem;
        background: rgba(139, 69, 19, 0.05);
        border-radius: 15px;
        border: 2px dashed #8B4513;
    }

    .no-bookings h4 {
        margin-bottom: 1rem;
        color: #4A5568;
        font-size: 1.4rem;
    }

    .action-section {
        text-align: center;
        margin: 3rem 0;
        padding: 2rem;
        background: linear-gradient(135deg, rgba(139, 69, 19, 0.1), rgba(205, 127, 50, 0.1));
        border-radius: 15px;
        border-left: 4px solid #8B4513;
    }

    .book-btn {
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        color: white;
        padding: 15px 30px;
        text-decoration: none;
        border-radius: 12px;
        font-weight: 700;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
        font-size: 1.1rem;
        margin: 1rem 0;
    }

    .book-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(139, 69, 19, 0.5);
    }

    .login-prompt {
        color: #718096;
        font-style: italic;
        margin-top: 1rem;
    }

    .navigation {
        text-align: center;
        margin-top: 2rem;
        padding-top: 2rem;
        border-top: 2px solid #E2E8F0;
    }

    .back-link {
        color: #8B4513;
        text-decoration: none;
        font-weight: 700;
        position: relative;
        transition: all 0.3s ease;
        font-size: 1rem;
        padding: 10px 20px;
        border: 2px solid transparent;
        border-radius: 10px;
        background: rgba(139, 69, 19, 0.1);
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .back-link:hover {
        background: rgba(139, 69, 19, 0.2);
        border-color: #8B4513;
        padding: 10px 25px;
        transform: translateY(-2px);
    }

    /* Status indicators for bookings */
    .booking-status {
        padding: 0.4rem 0.8rem;
        border-radius: 15px;
        font-weight: 600;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        display: inline-block;
    }

    .status-upcoming {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .status-ongoing {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
        color: white;
    }

    .status-completed {
        background: linear-gradient(135deg, #9E9E9E, #BDBDBD);
        color: white;
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

    .venue-container {
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
        body {
            padding: 15px;
        }
        
        .venue-container {
            padding: 2rem;
        }
        
        h2 {
            font-size: 2.5rem;
        }
        
        h3 {
            font-size: 1.8rem;
        }
        
        .venue-details {
            grid-template-columns: 1fr;
        }
        
        .section-header {
            flex-direction: column;
            text-align: center;
        }
        
        .bookings-table {
            font-size: 0.9rem;
        }
        
        .bookings-table th,
        .bookings-table td {
            padding: 1rem;
        }
    }

    @media (max-width: 480px) {
        .venue-container {
            padding: 1.5rem;
        }
        
        h2 {
            font-size: 2rem;
        }
        
        h3 {
            font-size: 1.5rem;
        }
        
        .bookings-table-container {
            overflow-x: auto;
        }
        
        .bookings-table {
            min-width: 700px;
        }
        
        .detail-card {
            padding: 1.5rem;
        }
    }

    /* Booking timeline visualization */
    .booking-timeline {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 0.85rem;
    }

    .timeline-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: #8B4513;
    }
</style>
</head>
<body>
<div class="venue-container">
    <div class="venue-header">
        <div class="venue-icon">🏛️</div>
        <h2><%= v.getName() %></h2>
    </div>

    <div class="venue-details">
        <div class="detail-card">
            <h3>📍 Location</h3>
            <p><%= v.getLocation() %></p>
        </div>
        
        <div class="detail-card">
            <h3>👥 Capacity</h3>
            <p>Maximum attendees</p>
            <span class="capacity-badge"><%= v.getCapacity() %> people</span>
        </div>
        
        <div class="detail-card">
            <h3>📝 Description</h3>
            <p><%= v.getDescription() != null ? v.getDescription() : "No description available" %></p>
        </div>
    </div>

    <div class="bookings-section">
        <div class="section-header">
            <h3>📅 Bookings Schedule</h3>
            <div class="booking-count">
                <% if (bookings != null) { %>
                    <span style="background: #8B4513; color: white; padding: 0.5rem 1rem; border-radius: 20px; font-weight: 700;">
                        <%= bookings.size() %> Bookings
                    </span>
                <% } %>
            </div>
        </div>

        <% if (bookings == null || bookings.isEmpty()) { %>
            <div class="no-bookings">
                <h4>📭 No Bookings Yet</h4>
                <p>This venue is currently available for booking. Be the first to schedule an event!</p>
            </div>
        <% } else { %>
            <div class="bookings-table-container">
                <table class="bookings-table">
                    <thead>
                        <tr>
                            <th>📋 Event Title</th>
                            <th>⏰ Start Time</th>
                            <th>⏱️ End Time</th>
                            <th>👤 Booked By</th>
                            <th>📅 Created At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (model.VenueBooking b : bookings) { 
                            java.util.Date now = new java.util.Date();
                            java.util.Date start = b.getStartTime();
                            java.util.Date end = b.getEndTime();
                            String status = "upcoming";
                            if (now.after(start) && now.before(end)) status = "ongoing";
                            else if (now.after(end)) status = "completed";
                        %>
                            <tr>
                                <td>
                                    <div class="booking-title"><%= b.getTitle() %></div>
                                    <span class="booking-status status-<%= status %>">
                                        <%= status.toUpperCase() %>
                                    </span>
                                </td>
                                <td class="datetime-cell">
                                    <div class="booking-timeline">
                                        <div class="timeline-dot"></div>
                                        <%= b.getStartTime() %>
                                    </div>
                                </td>
                                <td class="datetime-cell">
                                    <div class="booking-timeline">
                                        <div class="timeline-dot"></div>
                                        <%= b.getEndTime() %>
                                    </div>
                                </td>
                                <td>
                                    <span class="user-id">User #<%= b.getUserId() %></span>
                                </td>
                                <td class="datetime-cell">
                                    <%= b.getCreatedAt() %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <div class="action-section">
        <% if (currentUser != null && ("ADMIN".equalsIgnoreCase(currentUser.getRole()) || "ORGANIZER".equalsIgnoreCase(currentUser.getRole()))) { %>
            <a href="<%=request.getContextPath()%>/venue/book?venueId=<%=v.getId()%>" class="book-btn">
                🗓️ Book This Venue
            </a>
            <p style="color: #718096; margin-top: 0.5rem; font-size: 0.9rem;">
                Available for organizers and administrators
            </p>
        <% } else { %>
            <h4 style="color: #8B4513; margin-bottom: 1rem;">🔒 Booking Access Required</h4>
            <p class="login-prompt">Please login as an Organizer or Administrator to book this venue.</p>
            <a href="<%=request.getContextPath()%>/login" class="book-btn" style="background: linear-gradient(135deg, #4A5568, #718096);">
                🔑 Login to Book
            </a>
        <% } %>
    </div>

    <div class="navigation">
        <a href="<%=request.getContextPath()%>/venues" class="back-link">
            ⬅️ Back to All Venues
        </a>
    </div>
</div>

<script>
    // Add loading animations to table rows
    document.addEventListener('DOMContentLoaded', function() {
        const tableRows = document.querySelectorAll('.bookings-table tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.1}s`;
            row.style.animation = 'fadeInUp 0.5s ease-out forwards';
            row.style.opacity = '0';
        });

        // Add hover effects to detail cards
        const detailCards = document.querySelectorAll('.detail-card');
        detailCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
            });
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(-5px) scale(1)';
            });
        });
    });
</script>
</body>
</html>