<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="model.Ticket, model.User" %>
<%
    Ticket t = (Ticket) request.getAttribute("ticket");
    if (t == null) { response.sendRedirect(request.getContextPath()+"/"); return; }
    User user = (User) session.getAttribute("user");
%>
<html>
<head>
<title>Your Ticket - EventBiz</title>
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
                    url('https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        background-repeat: no-repeat;
        font-family: 'Montserrat', sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        position: relative;
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
            radial-gradient(circle at 20% 30%, rgba(255, 193, 7, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 80% 70%, rgba(76, 175, 80, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 40% 80%, rgba(33, 150, 243, 0.15) 0%, transparent 50%);
        animation: float 8s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .ticket-container {
        background: rgba(255, 255, 255, 0.97);
        backdrop-filter: blur(20px);
        padding: 3rem;
        border-radius: 25px;
        box-shadow: 
            0 35px 70px rgba(0, 0, 0, 0.3),
            inset 0 1px 0 rgba(255, 255, 255, 0.5);
        border: 1px solid rgba(255, 255, 255, 0.4);
        width: 100%;
        max-width: 600px;
        position: relative;
        overflow: hidden;
        z-index: 10;
    }

    /* Royal decoration */
    .ticket-container::after {
        content: '🎫';
        position: absolute;
        top: -25px;
        left: 50%;
        transform: translateX(-50%);
        font-size: 3rem;
        filter: drop-shadow(0 6px 12px rgba(0,0,0,0.4));
        z-index: 11;
        animation: bounce 2s ease-in-out infinite;
    }

    .ticket-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 6px;
        background: linear-gradient(90deg, 
            #FFC107 0%, 
            #4CAF50 25%, 
            #2196F3 50%, 
            #9C27B0 75%, 
            #FF9800 100%);
        background-size: 400% 400%;
        animation: gradientShift 4s ease infinite, shimmer 3s ease-in-out infinite;
        box-shadow: 0 3px 15px rgba(0,0,0,0.3);
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 2.8rem;
        text-align: center;
        margin-bottom: 2rem;
        background: linear-gradient(135deg, #FFC107 0%, #4CAF50 50%, #2196F3 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-shadow: 3px 3px 8px rgba(0, 0, 0, 0.15);
        position: relative;
        letter-spacing: 1.5px;
    }

    h2::after {
        content: '';
        position: absolute;
        bottom: -15px;
        left: 50%;
        transform: translateX(-50%);
        width: 200px;
        height: 4px;
        background: linear-gradient(90deg, transparent, #FFC107, #4CAF50, #2196F3, transparent);
        border-radius: 2px;
        animation: widthPulse 3s ease-in-out infinite;
    }

    .ticket-header {
        text-align: center;
        margin-bottom: 2.5rem;
    }

    .ticket-code-display {
        background: linear-gradient(135deg, #FFC107, #FF9800);
        color: white;
        padding: 1rem 2rem;
        border-radius: 15px;
        font-family: 'Courier New', monospace;
        font-size: 1.8rem;
        font-weight: 700;
        letter-spacing: 3px;
        margin: 1rem 0;
        display: inline-block;
        box-shadow: 0 8px 25px rgba(255, 193, 7, 0.3);
        border: 3px dashed rgba(255, 255, 255, 0.5);
    }

    .ticket-details {
        display: grid;
        grid-template-columns: 1fr;
        gap: 1.5rem;
        margin-bottom: 2.5rem;
    }

    .detail-card {
        background: linear-gradient(135deg, #2196F3, #21CBF3);
        color: white;
        padding: 1.5rem;
        border-radius: 15px;
        box-shadow: 0 8px 25px rgba(33, 150, 243, 0.3);
        transition: transform 0.3s ease;
    }

    .detail-card:hover {
        transform: translateY(-5px);
    }

    .detail-card h3 {
        font-size: 1.1rem;
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        gap: 10px;
        text-transform: uppercase;
        letter-spacing: 1px;
        opacity: 0.9;
    }

    .detail-card p {
        font-size: 1.3rem;
        font-weight: 700;
    }

    .detail-card.event {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
    }

    .detail-card.price {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
    }

    .detail-card.status {
        background: linear-gradient(135deg, #9C27B0, #BA68C8);
    }

    .event-link {
        color: white;
        text-decoration: none;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .event-link:hover {
        text-decoration: underline;
        transform: translateX(5px);
    }

    .price-amount {
        font-size: 2rem !important;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .status-badge {
        padding: 0.8rem 1.5rem;
        border-radius: 25px;
        font-weight: 700;
        font-size: 1rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        display: inline-block;
        background: rgba(255, 255, 255, 0.2);
        border: 2px solid rgba(255, 255, 255, 0.3);
    }

    .qr-section {
        text-align: center;
        margin: 2.5rem 0;
        padding: 2rem;
        background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
        border-radius: 20px;
        border: 2px dashed rgba(255, 193, 7, 0.3);
    }

    h3 {
        font-family: 'Playfair Display', serif;
        font-size: 2rem;
        margin-bottom: 1.5rem;
        background: linear-gradient(135deg, #FFC107, #FF9800);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }

    .qr-code {
        width: 250px;
        height: 250px;
        border-radius: 15px;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
        border: 5px solid #FFC107;
        padding: 10px;
        background: white;
        transition: all 0.3s ease;
    }

    .qr-code:hover {
        transform: scale(1.05);
        box-shadow: 0 20px 45px rgba(0, 0, 0, 0.3);
    }

    .qr-note {
        margin-top: 1rem;
        color: #718096;
        font-size: 0.9rem;
        font-style: italic;
    }

    .navigation {
        text-align: center;
        margin-top: 2.5rem;
        padding-top: 1.5rem;
        border-top: 2px solid #E2E8F0;
        position: relative;
    }

    .back-link {
        color: #2196F3;
        text-decoration: none;
        font-weight: 700;
        position: relative;
        transition: all 0.3s ease;
        font-size: 1.1rem;
        padding: 12px 24px;
        border: 2px solid transparent;
        border-radius: 12px;
        background: rgba(33, 150, 243, 0.1);
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .back-link:hover {
        background: rgba(33, 150, 243, 0.2);
        border-color: #2196F3;
        padding: 12px 30px;
        transform: translateY(-2px);
    }

    .action-buttons {
        display: flex;
        gap: 1rem;
        justify-content: center;
        margin-top: 1.5rem;
        flex-wrap: wrap;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 10px;
        font-weight: 700;
        font-size: 1rem;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    }

    .btn-print {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
    }

    .btn-download {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
    }

    /* Enhanced Animations */
    @keyframes gradientShift {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(50px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes float {
        0%, 100% { transform: translateY(0px) scale(1); }
        50% { transform: translateY(-20px) scale(1.02); }
    }

    @keyframes shimmer {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.7; }
    }

    @keyframes bounce {
        0%, 20%, 50%, 80%, 100% { transform: translateX(-50%) translateY(0); }
        40% { transform: translateX(-50%) translateY(-10px); }
        60% { transform: translateX(-50%) translateY(-5px); }
    }

    @keyframes widthPulse {
        0%, 100% { width: 200px; }
        50% { width: 220px; }
    }

    .ticket-container {
        animation: fadeInUp 1s ease-out;
    }

    /* Perforated ticket effect */
    .ticket-container {
        position: relative;
    }

    .ticket-container::before,
    .ticket-container::after {
        content: '';
        position: absolute;
        left: 20px;
        right: 20px;
        height: 15px;
        background: 
            radial-gradient(circle at 10px 50%, #FFC107 25%, transparent 26%),
            radial-gradient(circle at 30px 50%, #FFC107 25%, transparent 26%),
            radial-gradient(circle at 50px 50%, #FFC107 25%, transparent 26%),
            radial-gradient(circle at 70px 50%, #FFC107 25%, transparent 26%),
            radial-gradient(circle at 90px 50%, #FFC107 25%, transparent 26%);
        background-size: 20px 15px;
        background-repeat: repeat-x;
        z-index: 1;
    }

    .ticket-container::before {
        top: -7px;
    }

    .ticket-container::after {
        bottom: -7px;
        transform: rotate(180deg);
    }

    /* Responsive design */
    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .ticket-container {
            padding: 2.5rem 2rem;
        }
        
        h2 {
            font-size: 2.2rem;
        }
        
        h3 {
            font-size: 1.6rem;
        }
        
        .ticket-code-display {
            font-size: 1.4rem;
            padding: 0.8rem 1.5rem;
        }
        
        .qr-code {
            width: 200px;
            height: 200px;
        }
    }

    @media (max-width: 480px) {
        .ticket-container {
            padding: 2rem 1.5rem;
        }
        
        h2 {
            font-size: 1.8rem;
        }
        
        h3 {
            font-size: 1.4rem;
        }
        
        .ticket-code-display {
            font-size: 1.2rem;
            letter-spacing: 2px;
        }
        
        .qr-code {
            width: 180px;
            height: 180px;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .btn {
            justify-content: center;
        }
    }

    /* Print styles */
    @media print {
        body {
            background: white !important;
            padding: 0 !important;
        }
        
        .ticket-container {
            box-shadow: none !important;
            border: 2px solid #333 !important;
            margin: 0 !important;
            max-width: none !important;
        }
        
        .navigation, .action-buttons {
            display: none !important;
        }
    }
</style>
</head>
<body>
<div class="ticket-container">
    <div class="ticket-header">
        <h2>Your Ticket</h2>
        <div class="ticket-code-display">
            <%= t.getTicketCode() %>
        </div>
    </div>

    <div class="ticket-details">
        <div class="detail-card event">
            <h3>🎪 Event</h3>
            <p>
                <a href="<%=request.getContextPath()%>/event/view?id=<%= t.getEventId() %>" class="event-link">
                    View Event #<%= t.getEventId() %> ↗️
                </a>
            </p>
        </div>
        
        <div class="detail-card price">
            <h3>💰 Price</h3>
            <p class="price-amount">
                $<%= String.format("%.2f", t.getPrice()) %>
            </p>
        </div>
        
        <div class="detail-card status">
            <h3>📊 Status</h3>
            <p>
                <span class="status-badge">
                    <%= t.getStatus() %>
                </span>
            </p>
        </div>
    </div>

    <div class="qr-section">
        <h3>📱 QR Code</h3>
        <img src="<%=request.getContextPath()%>/ticket/qrcode?code=<%= t.getTicketCode() %>" 
             alt="QR Code for Ticket <%= t.getTicketCode() %>" 
             class="qr-code">
        <p class="qr-note">
            Present this QR code at the event entrance for scanning
        </p>
    </div>

    <div class="action-buttons">
        <button class="btn btn-print" onclick="window.print()">
            🖨️ Print Ticket
        </button>
        <button class="btn btn-download" onclick="downloadTicket()">
            💾 Download
        </button>
    </div>

    <div class="navigation">
        <a href="<%=request.getContextPath()%>/events" class="back-link">
            ⬅️ Back to Events
        </a>
    </div>
</div>

<script>
    // Add loading animations
    document.addEventListener('DOMContentLoaded', function() {
        const detailCards = document.querySelectorAll('.detail-card');
        detailCards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.2}s`;
            card.style.animation = 'fadeInUp 0.6s ease-out forwards';
            card.style.opacity = '0';
        });

        // Animate QR code
        const qrCode = document.querySelector('.qr-code');
        qrCode.style.animation = 'fadeInUp 0.8s ease-out 0.6s forwards';
        qrCode.style.opacity = '0';
    });

    // Download functionality (placeholder)
    function downloadTicket() {
        alert('💾 Download feature coming soon! Your ticket will be saved as a PDF.');
        // In a real implementation, this would generate and download a PDF ticket
    }

    // Add copy ticket code functionality
    function copyTicketCode() {
        const ticketCode = '<%= t.getTicketCode() %>';
        navigator.clipboard.writeText(ticketCode).then(function() {
            alert('✅ Ticket code copied to clipboard!');
        }, function(err) {
            console.error('Could not copy text: ', err);
        });
    }

    // Add click to copy on ticket code display
    document.addEventListener('DOMContentLoaded', function() {
        const ticketDisplay = document.querySelector('.ticket-code-display');
        ticketDisplay.style.cursor = 'pointer';
        ticketDisplay.title = 'Click to copy ticket code';
        ticketDisplay.addEventListener('click', copyTicketCode);
    });
</script>
</body>
</html>