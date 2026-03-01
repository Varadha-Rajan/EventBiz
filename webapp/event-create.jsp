<%@page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>Create Event - EventBiz</title>
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
        background: linear-gradient(rgba(25, 35, 55, 0.88), rgba(45, 65, 95, 0.92)), 
                    url('https://images.unsplash.com/photo-1492684223066-81342ee5ff30?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
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
            radial-gradient(circle at 15% 25%, rgba(124, 77, 255, 0.25) 0%, transparent 50%),
            radial-gradient(circle at 85% 75%, rgba(0, 188, 212, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 50% 50%, rgba(255, 64, 129, 0.15) 0%, transparent 50%);
        animation: float 8s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .create-event-container {
        background: rgba(255, 255, 255, 0.97);
        backdrop-filter: blur(25px);
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
    .create-event-container::after {
        content: '🎭';
        position: absolute;
        top: -25px;
        left: 50%;
        transform: translateX(-50%);
        font-size: 3rem;
        filter: drop-shadow(0 6px 12px rgba(0,0,0,0.4));
        z-index: 11;
        animation: bounce 2s ease-in-out infinite;
    }

    .create-event-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 6px;
        background: linear-gradient(90deg, 
            #FF4081 0%, 
            #7C4DFF 25%, 
            #00BCD4 50%, 
            #4CAF50 75%, 
            #FFC107 100%);
        background-size: 400% 400%;
        animation: gradientShift 4s ease infinite, shimmer 3s ease-in-out infinite;
        box-shadow: 0 3px 15px rgba(0,0,0,0.3);
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 2.5rem;
        text-align: center;
        margin-bottom: 2rem;
        background: linear-gradient(135deg, #7C4DFF 0%, #00BCD4 50%, #FF4081 100%);
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
        bottom: -12px;
        left: 50%;
        transform: translateX(-50%);
        width: 180px;
        height: 4px;
        background: linear-gradient(90deg, transparent, #7C4DFF, #00BCD4, #FF4081, transparent);
        border-radius: 2px;
        animation: widthPulse 3s ease-in-out infinite;
    }

    .event-form {
        display: flex;
        flex-direction: column;
        gap: 1.8rem;
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
        font-size: 0.95rem;
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
    textarea {
        padding: 15px 18px;
        border: 2px solid #E2E8F0;
        border-radius: 12px;
        font-size: 1rem;
        transition: all 0.4s ease;
        background: rgba(255, 255, 255, 0.95);
        font-family: 'Montserrat', sans-serif;
        box-shadow: inset 0 2px 6px rgba(0,0,0,0.08);
        resize: vertical;
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

    input::placeholder,
    textarea::placeholder {
        color: #A0AEC0;
        font-weight: 400;
        opacity: 1;
    }

    textarea {
        min-height: 100px;
        line-height: 1.6;
    }

    input[type="text"]:focus,
    input[type="number"]:focus,
    input[type="datetime-local"]:focus,
    textarea:focus {
        outline: none;
        border-color: #7C4DFF;
        box-shadow: 
            0 0 0 4px rgba(124, 77, 255, 0.15),
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
        background: linear-gradient(135deg, #7C4DFF 0%, #00BCD4 50%, #FF4081 100%);
        color: white;
        padding: 16px 30px;
        border: none;
        border-radius: 12px;
        font-size: 1.2rem;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.4s ease;
        text-transform: uppercase;
        letter-spacing: 2px;
        position: relative;
        overflow: hidden;
        margin-top: 1rem;
        font-family: 'Montserrat', sans-serif;
        box-shadow: 0 12px 30px rgba(124, 77, 255, 0.4);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        width: 100%;
    }

    button[type="submit"]:hover {
        transform: translateY(-3px);
        box-shadow: 0 15px 35px rgba(124, 77, 255, 0.6);
        letter-spacing: 2.5px;
    }

    .message {
        text-align: center;
        margin: 1.5rem 0;
        padding: 16px;
        border-radius: 12px;
        font-weight: 700;
        font-size: 1rem;
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        border: 1px solid rgba(255,255,255,0.4);
        animation: slideIn 0.5s ease-out;
    }

    .error-message {
        background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
        border-left: 5px solid #e53e3e;
        color: #742a2a;
        text-shadow: 0 1px 2px rgba(255,255,255,0.5);
    }

    .back-link {
        text-align: center;
        margin-top: 2rem;
        padding-top: 1.5rem;
        border-top: 2px solid #E2E8F0;
        position: relative;
    }

    .back-link a {
        color: #7C4DFF;
        text-decoration: none;
        font-weight: 700;
        position: relative;
        transition: all 0.3s ease;
        font-size: 1rem;
        padding: 10px 20px;
        border: 2px solid transparent;
        border-radius: 10px;
        background: rgba(124, 77, 255, 0.1);
        display: inline-flex;
        align-items: center;
        gap: 8px;
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

    .create-event-container {
        animation: fadeInUp 1s ease-out;
    }

    /* Alternative datetime input styling for better compatibility */
    .datetime-input {
        position: relative;
        width: 100%;
    }

    .datetime-input input {
        padding-right: 50px !important;
    }

    /* Fallback text for unsupported browsers */
    .datetime-fallback {
        display: none;
        color: #718096;
        font-size: 0.9rem;
        margin-top: 5px;
    }

    /* Responsive design */
    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .create-event-container {
            padding: 2rem 1.5rem;
        }
        
        h2 {
            font-size: 2rem;
        }
    }

    @media (max-width: 480px) {
        .create-event-container {
            padding: 1.5rem 1rem;
        }
        
        h2 {
            font-size: 1.8rem;
        }
    }
</style>
</head>
<body>
<div class="create-event-container">
    <h2>Create Event</h2>
    
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) { 
    %>
        <div class="message error-message">
            ⚠️ <%= error %>
        </div>
    <% } %>
    
    <form method="post" action="<%=request.getContextPath()%>/event/create" class="event-form">
        <div class="form-group">
            <label for="title">📝 EVENT TITLE</label>
            <input type="text" id="title" name="title" required placeholder="Enter event title"/>
        </div>
        
        <div class="form-group">
            <label for="description">📄 DESCRIPTION</label>
            <textarea id="description" name="description" placeholder="Describe your event..."></textarea>
        </div>
        
        <div class="form-group">
            <label for="venue_id">🏛️ VENUE ID (OPTIONAL)</label>
            <input type="text" id="venue_id" name="venue_id" placeholder="Enter venue ID if available"/>
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label for="start_time">⏰ START TIME</label>
                <div class="datetime-wrapper">
                    <input type="datetime-local" id="start_time" name="start_time" required 
                           class="datetime-input"
                           pattern="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}"/>
                </div>
                <div class="datetime-fallback" id="start_fallback">
                    Format: YYYY-MM-DDTHH:MM (e.g., 2024-12-25T14:30)
                </div>
            </div>
            
            <div class="form-group">
                <label for="end_time">⏱️ END TIME</label>
                <div class="datetime-wrapper">
                    <input type="datetime-local" id="end_time" name="end_time" required 
                           class="datetime-input"
                           pattern="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}"/>
                </div>
                <div class="datetime-fallback" id="end_fallback">
                    Format: YYYY-MM-DDTHH:MM (e.g., 2024-12-25T16:30)
                </div>
            </div>
        </div>
        
        <div class="form-group">
            <label for="capacity">👥 CAPACITY</label>
            <input type="number" id="capacity" name="capacity" value="0" min="0" placeholder="Enter maximum attendees"/>
        </div>
        
        <button type="submit">🎉 CREATE EVENT</button>
    </form>
    
    <div class="back-link">
        <a href="<%=request.getContextPath()%>/events">⬅️ Back to Events</a>
    </div>
</div>

<script>
    // Enhanced datetime input handling
    document.addEventListener('DOMContentLoaded', function() {
        const startTimeInput = document.getElementById('start_time');
        const endTimeInput = document.getElementById('end_time');
        
        // Check if datetime-local is supported
        function isDateTimeLocalSupported() {
            const input = document.createElement('input');
            input.setAttribute('type', 'datetime-local');
            return input.type === 'datetime-local';
        }
        
        if (!isDateTimeLocalSupported()) {
            // Show fallback instructions
            document.querySelectorAll('.datetime-fallback').forEach(fallback => {
                fallback.style.display = 'block';
            });
        }
        
        // Set current datetime as minimum with proper formatting
        const now = new Date();
        // Format: YYYY-MM-DDTHH:MM
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        
        const minDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
        
        startTimeInput.min = minDateTime;
        endTimeInput.min = minDateTime;
        
        // Set placeholder text for empty datetime inputs
        function updateDateTimePlaceholder(input) {
            if (!input.value) {
                input.style.color = '#A0AEC0';
                // Add a pseudo placeholder for better UX
                if (!input.hasAttribute('data-placeholder-set')) {
                    input.setAttribute('data-placeholder-set', 'true');
                }
            } else {
                input.style.color = '#2D3748';
            }
        }
        
        // Initialize placeholders
        updateDateTimePlaceholder(startTimeInput);
        updateDateTimePlaceholder(endTimeInput);
        
        // Enhanced click handling for datetime inputs
        [startTimeInput, endTimeInput].forEach(input => {
            // Force show picker on click
            input.addEventListener('click', function(e) {
                e.preventDefault();
                this.focus();
                
                // Try to show native picker
                if (this.showPicker) {
                    this.showPicker();
                } else {
                    // Fallback: focus and let browser handle it
                    this.focus();
                }
            });
            
            // Handle focus for better UX
            input.addEventListener('focus', function() {
                this.style.color = '#2D3748';
                this.style.borderColor = '#7C4DFF';
            });
            
            input.addEventListener('blur', function() {
                updateDateTimePlaceholder(this);
                this.style.borderColor = '#E2E8F0';
            });
            
            // Handle input changes
            input.addEventListener('input', function() {
                updateDateTimePlaceholder(this);
            });
        });
        
        // Validate end time is after start time
        startTimeInput.addEventListener('change', function() {
            if (this.value) {
                endTimeInput.min = this.value;
                if (endTimeInput.value && endTimeInput.value < this.value) {
                    endTimeInput.value = this.value;
                }
            }
        });
        
        // Additional mobile-friendly enhancements
        function enhanceMobileDateTime() {
            if (/Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                // Add touch-friendly styles for mobile
                document.querySelectorAll('input[type="datetime-local"]').forEach(input => {
                    input.style.minHeight = '60px';
                    input.style.fontSize = '16px'; // Prevents zoom
                });
            }
        }
        
        enhanceMobileDateTime();
    });

    // Double ensure datetime inputs work
    document.addEventListener('click', function(e) {
        if (e.target.type === 'datetime-local') {
            e.target.focus();
        }
    });
</script>
</body>
</html>