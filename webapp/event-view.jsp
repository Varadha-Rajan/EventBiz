<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="model.Event,model.User,dao.UserDAO,dao.VenueDAO,model.Venue"%>
<%
Event e=(Event)request.getAttribute("event");
int registeredCount=(Integer)(request.getAttribute("registeredCount")==null?0:request.getAttribute("registeredCount"));
Boolean regByUser=(Boolean)(request.getAttribute("registeredByUser")==null?false:request.getAttribute("registeredByUser"));
User currentUser=(User)session.getAttribute("user");
User organizer=null;String venueName="-";
try{
 if(e!=null){
  dao.UserDAO udao=new dao.UserDAO();
  organizer=udao.findById(e.getOrganizerId());
  if(e.getVenueId()!=null){
    VenueDAO vdao=new VenueDAO();
    Venue v=vdao.findById(e.getVenueId());
    if(v!=null)venueName=v.getName();
  }
 }
}catch(Exception ex){}
%>
<html>
<head>
<title><%=e.getTitle()%> - EventBiz</title>
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
                    url('https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
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
            radial-gradient(circle at 20% 30%, rgba(102, 126, 234, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 80% 70%, rgba(118, 75, 162, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 40% 80%, rgba(240, 147, 251, 0.15) 0%, transparent 50%);
        animation: float 8s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .event-container {
        max-width: 1000px;
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

    .event-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #4CAF50);
        background-size: 400% 400%;
        animation: gradientShift 4s ease infinite;
    }

    .event-header {
        text-align: center;
        margin-bottom: 3rem;
        position: relative;
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 3.5rem;
        background: linear-gradient(135deg, #667eea, #764ba2);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 1rem;
    }

    .event-icon {
        font-size: 4rem;
        margin-bottom: 1rem;
        animation: bounce 2s ease-in-out infinite;
        display: block;
    }

    .event-details-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 2rem;
        margin-bottom: 3rem;
    }

    .detail-card {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        padding: 2rem;
        border-radius: 15px;
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
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

    .capacity-info {
        background: rgba(255, 255, 255, 0.2);
        padding: 0.8rem 1.5rem;
        border-radius: 20px;
        font-weight: 700;
        font-size: 1.3rem;
        display: inline-block;
        margin-top: 0.5rem;
    }

    .registration-section {
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
        padding: 2.5rem;
        border-radius: 20px;
        margin: 3rem 0;
        text-align: center;
        border-left: 4px solid #667eea;
    }

    .registration-stats {
        display: flex;
        justify-content: center;
        gap: 3rem;
        margin-bottom: 2rem;
        flex-wrap: wrap;
    }

    .stat {
        text-align: center;
    }

    .stat-number {
        font-size: 3rem;
        font-weight: 700;
        color: #667eea;
        display: block;
    }

    .stat-label {
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: #4A5568;
        font-weight: 600;
    }

    .action-buttons {
        display: flex;
        justify-content: center;
        gap: 1.5rem;
        flex-wrap: wrap;
        margin-top: 2rem;
    }

    .btn {
        padding: 15px 30px;
        border: none;
        border-radius: 12px;
        font-weight: 700;
        font-size: 1.1rem;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    }

    .btn-register {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .btn-unregister {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
        color: white;
    }

    .btn-ticket {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
    }

    .btn-login {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
    }

    .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
    }

    .btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
        transform: none;
    }

    .organizer-info {
        background: linear-gradient(135deg, rgba(76, 175, 80, 0.1), rgba(102, 187, 106, 0.1));
        padding: 1.5rem;
        border-radius: 15px;
        margin: 2rem 0;
        border-left: 4px solid #4CAF50;
        text-align: center;
    }

    .organizer-info p {
        font-weight: 600;
        color: #2D3748;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        font-size: 1.1rem;
    }

    .venue-link {
        color: #667eea;
        text-decoration: none;
        font-weight: 600;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 5px;
    }

    .venue-link:hover {
        color: #764ba2;
        text-decoration: underline;
    }

    .status-badge {
        padding: 0.8rem 1.5rem;
        border-radius: 25px;
        font-weight: 700;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        display: inline-block;
        margin-top: 0.5rem;
    }

    .status-scheduled {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
    }

    .status-ongoing {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
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

    .navigation {
        text-align: center;
        margin-top: 3rem;
        padding-top: 2rem;
        border-top: 2px solid #E2E8F0;
    }

    .back-link {
        color: #667eea;
        text-decoration: none;
        font-weight: 700;
        position: relative;
        transition: all 0.3s ease;
        font-size: 1.1rem;
        padding: 12px 24px;
        border: 2px solid transparent;
        border-radius: 12px;
        background: rgba(102, 126, 234, 0.1);
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .back-link:hover {
        background: rgba(102, 126, 234, 0.2);
        border-color: #667eea;
        padding: 12px 30px;
        transform: translateY(-2px);
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

    .event-container {
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

    /* Progress bar for registration */
    .progress-container {
        width: 100%;
        background: rgba(255, 255, 255, 0.3);
        border-radius: 10px;
        overflow: hidden;
        margin: 1rem 0;
        height: 10px;
    }

    .progress-bar {
        height: 100%;
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        transition: width 0.5s ease;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .event-container {
            padding: 2rem;
        }
        
        h2 {
            font-size: 2.5rem;
        }
        
        .event-details-grid {
            grid-template-columns: 1fr;
        }
        
        .registration-stats {
            flex-direction: column;
            gap: 1.5rem;
        }
        
        .action-buttons {
            flex-direction: column;
            align-items: center;
        }
        
        .btn {
            width: 100%;
            justify-content: center;
        }
    }

    @media (max-width: 480px) {
        .event-container {
            padding: 1.5rem;
        }
        
        h2 {
            font-size: 2rem;
        }
        
        .detail-card {
            padding: 1.5rem;
        }
        
        .registration-section {
            padding: 1.5rem;
        }
    }

    /* Ticket price styling */
    .ticket-price {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 700;
        font-size: 1.1rem;
        display: inline-block;
        margin-left: 10px;
    }
</style>
</head>
<body>
<div class="event-container">
    <div class="event-header">
        <div class="event-icon">🎪</div>
        <h2><%=e.getTitle()%></h2>
        <div class="status-badge status-<%=e.getStatus().toLowerCase()%>">
            <%=e.getStatus()%>
        </div>
    </div>

    <div class="event-details-grid">
        <div class="detail-card">
            <h3>📝 Description</h3>
            <p><%=e.getDescription() != null ? e.getDescription() : "No description available"%></p>
        </div>
        
        <div class="detail-card">
            <h3>👤 Organizer</h3>
            <p>🎭 <%=organizer==null?"Unknown":organizer.getUsername()%></p>
        </div>
        
        <div class="detail-card">
            <h3>🏛️ Venue</h3>
            <p><%=venueName%></p>
            <% if (e.getVenueId() != null) { %>
                <a href="<%=request.getContextPath()%>/venue/view?id=<%=e.getVenueId()%>" class="venue-link">
                    🗺️ View Venue Details
                </a>
            <% } %>
        </div>
        
        <div class="detail-card">
            <h3>⏰ Event Timing</h3>
            <p>🕐 Start: <%=e.getStartTime()%></p>
            <p>🕒 End: <%=e.getEndTime()%></p>
        </div>
        
        <div class="detail-card">
            <h3>👥 Capacity</h3>
            <p>Maximum attendees</p>
            <span class="capacity-info"><%=e.getCapacity()%> people</span>
        </div>
    </div>

    <% if (organizer != null && currentUser != null && currentUser.getId() == organizer.getId()) { %>
        <div class="organizer-info">
            <p>⭐ You are the organizer of this event</p>
        </div>
    <% } %>

    <div class="registration-section">
        <div class="registration-stats">
            <div class="stat">
                <span class="stat-number"><%=registeredCount%></span>
                <span class="stat-label">Registered</span>
            </div>
            <div class="stat">
                <span class="stat-number"><%=e.getCapacity()%></span>
                <span class="stat-label">Capacity</span>
            </div>
            <div class="stat">
                <span class="stat-number"><%=e.getCapacity() - registeredCount%></span>
                <span class="stat-label">Available</span>
            </div>
        </div>

        <div class="progress-container">
            <div class="progress-bar" style="width: <%=e.getCapacity() > 0 ? (registeredCount * 100 / e.getCapacity()) : 0%>%;"></div>
        </div>

        <form method="post" action="<%=request.getContextPath()%>/event/attend" style="display: inline;">
            <input type="hidden" name="event_id" value="<%= e.getId() %>"/>
            <div class="action-buttons">
                <% if (currentUser == null) { %>
                    <a href="<%=request.getContextPath()%>/login" class="btn btn-login">
                        🔑 Login to Register
                    </a>
                <% } else if (organizer != null && currentUser.getId() == organizer.getId()) { %>
                    <button type="button" class="btn" disabled style="background: linear-gradient(135deg, #9E9E9E, #BDBDBD);">
                        ⭐ You're the Organizer
                    </button>
                <% } else { %>
                    <% if (regByUser) { %>
                        <button type="submit" name="action" value="unregister" class="btn btn-unregister">
                            ❌ Unregister from Event
                        </button>
                    <% } else { %>
                        <button type="submit" name="action" value="register" class="btn btn-register">
                            ✅ Register for Event
                        </button>
                    <% } %>
                <% } %>

                <% if(currentUser!=null && "PARTICIPANT".equalsIgnoreCase(currentUser.getRole())){ %>
                <form method="get" action="<%=request.getContextPath()%>/ticket/purchase" style="display: inline;">
                    <input type="hidden" name="event_id" value="<%=e.getId()%>"/>
                    <input type="hidden" name="price" value="100"/>
                    <button type="submit" class="btn btn-ticket">
                        🎫 Buy Ticket <span class="ticket-price">$100</span>
                    </button>
                </form>
                <% } %>
            </div>
        </form>
    </div>

    <div class="navigation">
        <a href="<%=request.getContextPath()%>/events" class="back-link">
            ⬅️ Back to All Events
        </a>
    </div>
</div>

<script>
    // Add loading animations
    document.addEventListener('DOMContentLoaded', function() {
        const detailCards = document.querySelectorAll('.detail-card');
        detailCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
            card.style.animation = 'fadeInUp 0.5s ease-out forwards';
            card.style.opacity = '0';
        });

        // Add hover effects to buttons
        const buttons = document.querySelectorAll('.btn:not(:disabled)');
        buttons.forEach(button => {
            button.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px) scale(1.05)';
            });
            button.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(-3px) scale(1)';
            });
        });
    });
</script>
</body>
</html>