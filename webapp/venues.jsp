<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, model.Venue, model.User" %>
<%
    List<Venue> venues = (List<Venue>) request.getAttribute("venues");
    model.User currentUser = (model.User) session.getAttribute("user");
%>
<html>
<head>
<title>Venues - EventBiz</title>
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
        background: linear-gradient(rgba(35, 45, 65, 0.9), rgba(55, 75, 105, 0.95)), 
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
            radial-gradient(circle at 25% 25%, rgba(139, 69, 19, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 75% 75%, rgba(205, 127, 50, 0.15) 0%, transparent 50%),
            radial-gradient(circle at 50% 50%, rgba(160, 82, 45, 0.1) 0%, transparent 50%);
        animation: float 8s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .venues-container {
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

    .venues-container::before {
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

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 3rem;
        text-align: center;
        margin-bottom: 2rem;
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        position: relative;
    }

    h2::after {
        content: '🏛️';
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
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        color: white;
        padding: 12px 25px;
        text-decoration: none;
        border-radius: 12px;
        font-weight: 700;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
        font-size: 0.95rem;
    }

    .nav-link:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(139, 69, 19, 0.5);
    }

    .nav-link.search {
        background: linear-gradient(135deg, #D2691E, #CD7F32);
    }

    .nav-link.create {
        background: linear-gradient(135deg, #A0522D, #8B4513);
    }

    .nav-link.report {
        background: linear-gradient(135deg, #8B4513, #A0522D);
    }

    .admin-actions {
        text-align: center;
        margin-bottom: 2rem;
        padding: 1.5rem;
        background: linear-gradient(135deg, rgba(139, 69, 19, 0.1), rgba(205, 127, 50, 0.1));
        border-radius: 15px;
        border-left: 4px solid #8B4513;
    }

    .admin-actions h3 {
        color: #8B4513;
        margin-bottom: 1rem;
        font-size: 1.2rem;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }

    .venues-table-container {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        margin-top: 1.5rem;
    }

    .venues-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .venues-table th {
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

    .venues-table th::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: rgba(255, 255, 255, 0.3);
    }

    .venues-table td {
        padding: 1.3rem 1.5rem;
        border-bottom: 1px solid #E2E8F0;
        transition: all 0.3s ease;
        color: #4A5568;
        vertical-align: top;
    }

    .venues-table tr:hover td {
        background: rgba(139, 69, 19, 0.05);
        transform: translateX(5px);
    }

    .venues-table tr:last-child td {
        border-bottom: none;
    }

    .venue-name {
        font-weight: 700;
        color: #2D3748;
        text-decoration: none;
        transition: all 0.3s ease;
        font-size: 1.1rem;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .venue-name:hover {
        color: #8B4513;
        text-decoration: underline;
    }

    .venue-location {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        color: #4A5568;
    }

    .venue-capacity {
        font-weight: 700;
        color: #8B4513;
        text-align: center;
        background: rgba(139, 69, 19, 0.1);
        padding: 0.5rem 1rem;
        border-radius: 20px;
        display: inline-block;
    }

    .venue-description {
        color: #718096;
        line-height: 1.5;
        max-width: 300px;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
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
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        color: white;
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    .no-venues {
        text-align: center;
        padding: 4rem 2rem;
        color: #718096;
        font-size: 1.2rem;
    }

    .no-venues h3 {
        margin-bottom: 1rem;
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
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        color: white;
        padding: 1.5rem;
        border-radius: 15px;
        text-align: center;
        box-shadow: 0 8px 25px rgba(139, 69, 19, 0.3);
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

    /* Capacity indicators */
    .capacity-small {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .capacity-medium {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
    }

    .capacity-large {
        background: linear-gradient(135deg, #F44336, #EF5350);
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

    .venues-container {
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
        .venues-container {
            padding: 2rem;
        }
        
        .venues-table {
            font-size: 0.9rem;
        }
        
        .venues-table th,
        .venues-table td {
            padding: 1rem;
        }
    }

    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .venues-container {
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
        
        .venues-table-container {
            overflow-x: auto;
        }
        
        .stats-grid {
            grid-template-columns: 1fr;
        }
        
        .admin-actions {
            padding: 1rem;
        }
    }

    @media (max-width: 480px) {
        .venues-container {
            padding: 1rem;
        }
        
        h2 {
            font-size: 1.8rem;
        }
        
        .venues-table {
            min-width: 800px;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .btn {
            justify-content: center;
        }
        
        .venue-description {
            max-width: 200px;
            -webkit-line-clamp: 2;
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
        background: linear-gradient(135deg, #8B4513, #CD7F32);
        color: white;
        padding: 0.3rem 1rem;
        border-radius: 15px;
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    /* Description tooltip effect */
    .venue-description {
        position: relative;
    }

    .venue-description:hover::after {
        content: attr(data-full-description);
        position: absolute;
        bottom: 100%;
        left: 0;
        background: rgba(0, 0, 0, 0.8);
        color: white;
        padding: 0.8rem;
        border-radius: 8px;
        font-size: 0.9rem;
        white-space: normal;
        width: 300px;
        z-index: 1000;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
    }
</style>
</head>
<body>
<div class="venues-container">
    <h2>Venues</h2>
    
    <% if (currentUser != null) { %>
        <div class="user-role">
            👋 Welcome, <strong><%= currentUser.getUsername() %></strong> 
            <span>🎭 <%= currentUser.getRole() %></span>
        </div>
    <% } %>
    
    <div class="navigation">
        <a href="<%=request.getContextPath()%>/venue/search" class="nav-link search">
            🔍 Search Availability
        </a>
    </div>

    <% if (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>
        <div class="admin-actions">
            <h3>⚡ Admin Actions</h3>
            <div class="navigation">
                <a href="<%=request.getContextPath()%>/venue/create" class="nav-link create">
                    🏗️ Create New Venue
                </a>
                <a href="<%=request.getContextPath()%>/venue/report" class="nav-link report">
                    📊 Usage Report
                </a>
            </div>
        </div>
    <% } %>

    <% 
        if (venues != null && !venues.isEmpty()) { 
        int totalVenues = venues.size();
        int totalCapacity = 0;
        for (Venue v : venues) {
            totalCapacity += v.getCapacity();
        }
        int avgCapacity = totalVenues > 0 ? totalCapacity / totalVenues : 0;
    %>
    
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-number"><%= totalVenues %></div>
            <div class="stat-label">Total Venues</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><%= totalCapacity %></div>
            <div class="stat-label">Total Capacity</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><%= avgCapacity %></div>
            <div class="stat-label">Avg Capacity</div>
        </div>
    </div>

    <div class="venues-table-container">
        <table class="venues-table">
            <thead>
                <tr>
                    <th>🏛️ Venue Name</th>
                    <th>📍 Location</th>
                    <th>👥 Capacity</th>
                    <th>📝 Description</th>
                    <th>⚡ Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for (Venue v : venues) { 
                String capacityClass = "venue-capacity";
                if (v.getCapacity() < 100) capacityClass += " capacity-small";
                else if (v.getCapacity() < 500) capacityClass += " capacity-medium";
                else capacityClass += " capacity-large";
            %>
                <tr>
                    <td>
                        <a href="<%=request.getContextPath()%>/venue/view?id=<%=v.getId()%>" class="venue-name">
                            🏛️ <%= v.getName() %>
                        </a>
                    </td>
                    <td>
                        <span class="venue-location">
                            📍 <%= v.getLocation() %>
                        </span>
                    </td>
                    <td>
                        <span class="<%= capacityClass %>">
                            👥 <%= v.getCapacity() %>
                        </span>
                    </td>
                    <td>
                        <div class="venue-description" data-full-description="<%= v.getDescription() != null ? v.getDescription() : "No description available" %>">
                            <%= v.getDescription() != null ? (v.getDescription().length() > 100 ? v.getDescription().substring(0, 100) + "..." : v.getDescription()) : "No description available" %>
                        </div>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <a href="<%=request.getContextPath()%>/venue/view?id=<%=v.getId()%>" class="btn btn-view">
                                👁️ View Details
                            </a>
                        </div>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
        <div class="no-venues">
            <h3>🏛️ No Venues Found</h3>
            <p>There are currently no venues available in the system.</p>
            <% if (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>
                <a href="<%=request.getContextPath()%>/venue/create" class="nav-link create" style="margin-top: 1rem; display: inline-block;">
                    🏗️ Add Your First Venue
                </a>
            <% } %>
        </div>
    <% } %>
</div>

<script>
    // Add hover effects and animations
    document.addEventListener('DOMContentLoaded', function() {
        // Add loading animation to table rows
        const tableRows = document.querySelectorAll('.venues-table tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.1}s`;
            row.style.animation = 'fadeInUp 0.5s ease-out forwards';
            row.style.opacity = '0';
        });

        // Add capacity tooltips
        const capacitySpans = document.querySelectorAll('.venue-capacity');
        capacitySpans.forEach(span => {
            const capacity = parseInt(span.textContent.replace('👥 ', ''));
            let size = '';
            if (capacity < 100) size = 'Small';
            else if (capacity < 500) size = 'Medium';
            else size = 'Large';
            
            span.title = `${size} capacity venue - ${capacity} people`;
        });
    });
</script>
</body>
</html>