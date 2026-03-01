<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="model.Event" %>
<%
  Event e = (Event) request.getAttribute("event");
  java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
  String startVal = e.getStartTime() == null ? "" : e.getStartTime().toLocalDateTime().format(fmt);
  String endVal = e.getEndTime() == null ? "" : e.getEndTime().toLocalDateTime().format(fmt);
  String error = (String) request.getAttribute("error");
%>
<html>
<head>
<title>Edit Event - EventBiz</title>
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
                    url('https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
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
            radial-gradient(circle at 20% 30%, rgba(102, 126, 234, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 80% 70%, rgba(118, 75, 162, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 40% 80%, rgba(240, 147, 251, 0.15) 0%, transparent 50%);
        animation: float 8s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .edit-event-container {
        background: rgba(255, 255, 255, 0.97);
        backdrop-filter: blur(20px);
        padding: 3rem;
        border-radius: 25px;
        box-shadow: 
            0 35px 70px rgba(0, 0, 0, 0.3),
            inset 0 1px 0 rgba(255, 255, 255, 0.5);
        border: 1px solid rgba(255, 255, 255, 0.4);
        width: 100%;
        max-width: 650px;
        position: relative;
        overflow: hidden;
        z-index: 10;
    }

    /* Royal decoration */
    .edit-event-container::after {
        content: '✏️';
        position: absolute;
        top: -25px;
        left: 50%;
        transform: translateX(-50%);
        font-size: 3rem;
        filter: drop-shadow(0 6px 12px rgba(0,0,0,0.4));
        z-index: 11;
        animation: bounce 2s ease-in-out infinite;
    }

    .edit-event-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 6px;
        background: linear-gradient(90deg, 
            #667eea 0%, 
            #764ba2 25%, 
            #f093fb 50%, 
            #4CAF50 75%, 
            #FFC107 100%);
        background-size: 400% 400%;
        animation: gradientShift 4s ease infinite, shimmer 3s ease-in-out infinite;
        box-shadow: 0 3px 15px rgba(0,0,0,0.3);
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 2.8rem;
        text-align: center;
        margin-bottom: 2rem;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
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
        background: linear-gradient(90deg, transparent, #667eea, #764ba2, #f093fb, transparent);
        border-radius: 2px;
        animation: widthPulse 3s ease-in-out infinite;
    }

    .event-info {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        padding: 1.5rem;
        border-radius: 15px;
        margin-bottom: 2rem;
        text-align: center;
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
    }

    .event-title {
        font-size: 1.4rem;
        font-weight: 700;
        margin-bottom: 0.5rem;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }

    .event-details {
        display: flex;
        justify-content: center;
        gap: 2rem;
        flex-wrap: wrap;
        margin-top: 1rem;
    }

    .event-detail {
        background: rgba(255, 255, 255, 0.2);
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 600;
        font-size: 0.9rem;
    }

    .edit-form {
        display: flex;
        flex-direction: column;
        gap: 2rem;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 0.8rem;
        position: relative;
    }

    .form-group label {
        font-weight: 700;
        color: #2D3748;
        font-size: 1rem;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        margin-left: 5px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    input[type="text"],
    input[type="number"],
    input[type="datetime-local"],
    textarea,
    select {
        padding: 16px 20px;
        border: 2px solid #E2E8F0;
        border-radius: 15px;
        font-size: 1.1rem;
        transition: all 0.4s ease;
        background: rgba(255, 255, 255, 0.95);
        font-family: 'Montserrat', sans-serif;
        box-shadow: inset 0 2px 6px rgba(0,0,0,0.08);
        color: #2D3748 !important;
        width: 100%;
    }

    /* Special styling for datetime-local inputs */
    input[type="datetime-local"] {
        min-height: 50px;
        cursor: pointer;
        position: relative;
        background: white;
    }

    /* Custom calendar icon */
    .datetime-wrapper {
        position: relative;
        display: flex;
        align-items: center;
    }

    .datetime-wrapper::after {
        content: '📅';
        position: absolute;
        right: 15px;
        pointer-events: none;
        font-size: 1.2rem;
        z-index: 2;
    }

    /* Remove default datetime-local styling issues */
    input[type="datetime-local"]::-webkit-calendar-picker-indicator {
        background: transparent;
        color: transparent;
        cursor: pointer;
        position: absolute;
        right: 0;
        top: 0;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: 1;
        opacity: 0;
    }

    input[type="datetime-local"]::-webkit-datetime-edit {
        color: #2D3748;
        padding: 0;
    }

    input[type="datetime-local"]:invalid::-webkit-datetime-edit {
        color: #A0AEC0;
    }

    /* Style select dropdown */
    select {
        appearance: none;
        background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23667eea' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
        background-repeat: no-repeat;
        background-position: right 20px center;
        background-size: 16px;
        padding-right: 50px;
    }

    input::placeholder,
    textarea::placeholder {
        color: #A0AEC0;
        font-weight: 400;
        opacity: 1;
    }

    textarea {
        min-height: 120px;
        line-height: 1.6;
        resize: vertical;
    }

    input[type="text"]:focus,
    input[type="number"]:focus,
    input[type="datetime-local"]:focus,
    textarea:focus,
    select:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 
            0 0 0 4px rgba(102, 126, 234, 0.15),
            inset 0 2px 6px rgba(0,0,0,0.05);
        transform: translateY(-2px);
        background: rgba(255, 255, 255, 1);
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1.2rem;
    }

    @media (max-width: 480px) {
        .form-row {
            grid-template-columns: 1fr;
        }
    }

    button[type="submit"] {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
        color: white;
        padding: 18px 35px;
        border: none;
        border-radius: 15px;
        font-size: 1.3rem;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.4s ease;
        text-transform: uppercase;
        letter-spacing: 2px;
        position: relative;
        overflow: hidden;
        margin-top: 1rem;
        font-family: 'Montserrat', sans-serif;
        box-shadow: 0 12px 30px rgba(102, 126, 234, 0.4);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        width: 100%;
    }

    button[type="submit"]:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 40px rgba(102, 126, 234, 0.6);
        letter-spacing: 3px;
    }

    button[type="submit"]::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
        transition: left 0.7s;
    }

    button[type="submit"]:hover::before {
        left: 100%;
    }

    .message {
        text-align: center;
        margin: 1.5rem 0;
        padding: 18px;
        border-radius: 15px;
        font-weight: 700;
        font-size: 1.1rem;
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        border: 1px solid rgba(255,255,255,0.4);
        animation: slideIn 0.5s ease-out;
    }

    .error-message {
        background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
        border-left: 6px solid #e53e3e;
        color: #742a2a;
        text-shadow: 0 1px 2px rgba(255,255,255,0.5);
    }

    .back-link {
        text-align: center;
        margin-top: 2.5rem;
        padding-top: 1.5rem;
        border-top: 2px solid #E2E8F0;
        position: relative;
    }

    .back-link a {
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

    .back-link a:hover {
        background: rgba(102, 126, 234, 0.2);
        border-color: #667eea;
        padding: 12px 30px;
        transform: translateY(-2px);
    }

    /* Status option styling */
    .status-option {
        padding: 0.5rem;
        border-radius: 8px;
        margin: 0.2rem 0;
        transition: all 0.3s ease;
    }

    .status-option:hover {
        background: rgba(102, 126, 234, 0.1);
    }

    /* Form validation styling */
    input:required, textarea:required, select:required {
        border-left: 4px solid #667eea;
    }

    input:valid, textarea:valid, select:valid {
        border-left: 4px solid #4CAF50;
    }

    input:invalid:not(:focus):not(:placeholder-shown),
    textarea:invalid:not(:focus):not(:placeholder-shown),
    select:invalid:not(:focus) {
        border-left: 4px solid #FF4081;
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

    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(-30px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    .edit-event-container {
        animation: fadeInUp 1s ease-out;
    }

    /* Responsive design */
    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .edit-event-container {
            padding: 2.5rem 2rem;
        }
        
        h2 {
            font-size: 2.2rem;
        }
        
        .event-details {
            flex-direction: column;
            gap: 1rem;
        }
    }

    @media (max-width: 480px) {
        .edit-event-container {
            padding: 2rem 1.5rem;
        }
        
        h2 {
            font-size: 1.8rem;
        }
        
        .form-group label {
            font-size: 0.9rem;
        }
        
        body {
            background-attachment: scroll;
        }
    }

    /* Ensure all inputs have consistent styling */
    input, textarea, select {
        font-size: 16px !important; /* Prevents zoom on iOS */
    }
</style>
</head>
<body>
<div class="edit-event-container">
    <h2>Edit Event</h2>
    
    <div class="event-info">
        <div class="event-title">
            🎪 <%= e.getTitle() %>
        </div>
        <div class="event-details">
            <div class="event-detail">📊 Status: <%= e.getStatus() %></div>
            <div class="event-detail">👥 Capacity: <%= e.getCapacity() %></div>
            <% if (e.getVenueId() != null) { %>
                <div class="event-detail">🏛️ Venue ID: <%= e.getVenueId() %></div>
            <% } %>
        </div>
    </div>
    
    <% if (error != null) { %>
        <div class="message error-message">
            ⚠️ <%= error %>
        </div>
    <% } %>
    
    <form method="post" action="<%=request.getContextPath()%>/event/update" class="edit-form">
        <input type="hidden" name="id" value="<%=e.getId()%>"/>
        
        <div class="form-group">
            <label for="title">📝 Event Title</label>
            <input type="text" id="title" name="title" value="<%=e.getTitle()%>" required placeholder="Enter event title"/>
        </div>
        
        <div class="form-group">
            <label for="description">📄 Description</label>
            <textarea id="description" name="description" placeholder="Describe your event..."><%=e.getDescription() != null ? e.getDescription() : ""%></textarea>
        </div>
        
        <div class="form-group">
            <label for="venue_id">🏛️ Venue ID (Optional)</label>
            <input type="text" id="venue_id" name="venue_id" value="<%= e.getVenueId() == null ? "" : e.getVenueId() %>" placeholder="Enter venue ID"/>
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label for="start_time">⏰ Start Time</label>
                <div class="datetime-wrapper">
                    <input type="datetime-local" id="start_time" name="start_time" value="<%=startVal%>" required 
                           title="Select start date and time"/>
                </div>
            </div>
            
            <div class="form-group">
                <label for="end_time">⏱️ End Time</label>
                <div class="datetime-wrapper">
                    <input type="datetime-local" id="end_time" name="end_time" value="<%=endVal%>" required 
                           title="Select end date and time"/>
                </div>
            </div>
        </div>
        
        <div class="form-group">
            <label for="capacity">👥 Capacity</label>
            <input type="number" id="capacity" name="capacity" value="<%=e.getCapacity()%>" min="0" placeholder="Enter maximum attendees"/>
        </div>
        
        <div class="form-group">
            <label for="status">📊 Event Status</label>
            <select id="status" name="status" required>
                <option value="SCHEDULED" <%= "SCHEDULED".equals(e.getStatus()) ? "selected" : "" %>>📅 SCHEDULED</option>
                <option value="ONGOING" <%= "ONGOING".equals(e.getStatus()) ? "selected" : "" %>>🟢 ONGOING</option>
                <option value="COMPLETED" <%= "COMPLETED".equals(e.getStatus()) ? "selected" : "" %>>✅ COMPLETED</option>
                <option value="CANCELLED" <%= "CANCELLED".equals(e.getStatus()) ? "selected" : "" %>>❌ CANCELLED</option>
            </select>
        </div>
        
        <button type="submit">💾 Update Event</button>
    </form>
    
    <div class="back-link">
        <a href="<%=request.getContextPath()%>/events">⬅️ Back to Events</a>
    </div>
</div>

<script>
    // Initialize datetime inputs with proper formatting
    document.addEventListener('DOMContentLoaded', function() {
        const startTimeInput = document.getElementById('start_time');
        const endTimeInput = document.getElementById('end_time');
        
        // Set current datetime as minimum
        const now = new Date();
        const localDateTime = now.toISOString().slice(0, 16);
        
        startTimeInput.min = localDateTime;
        endTimeInput.min = localDateTime;
        
        // Set initial placeholder behavior
        function setDateTimePlaceholder(input) {
            if (!input.value) {
                input.style.color = '#A0AEC0';
            }
        }
        
        setDateTimePlaceholder(startTimeInput);
        setDateTimePlaceholder(endTimeInput);
        
        // Handle focus/blur for datetime inputs
        [startTimeInput, endTimeInput].forEach(input => {
            input.addEventListener('focus', function() {
                this.style.color = '#2D3748';
            });
            
            input.addEventListener('blur', function() {
                if (!this.value) {
                    this.style.color = '#A0AEC0';
                }
            });
            
            input.addEventListener('change', function() {
                this.style.color = '#2D3748';
            });
        });
        
        // Validate end time is after start time
        startTimeInput.addEventListener('change', function() {
            endTimeInput.min = this.value;
            if (endTimeInput.value && endTimeInput.value < this.value) {
                endTimeInput.value = this.value;
            }
        });
        
        // Force calendar picker to show on click (mobile fix)
        [startTimeInput, endTimeInput].forEach(input => {
            input.addEventListener('click', function() {
                this.showPicker && this.showPicker();
            });
        });
    });

    // Fallback for browsers that don't support showPicker
    if (!HTMLInputElement.prototype.showPicker) {
        HTMLInputElement.prototype.showPicker = function() {
            // Native behavior will handle it
        };
    }
</script>
</body>
</html>