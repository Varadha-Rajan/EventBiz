<%@page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>Register - EventBiz</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Montserrat:wght@300;400;600&display=swap');
    
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        margin: 0;
        padding: 0;
        min-height: 100vh;
        background: linear-gradient(rgba(25, 35, 55, 0.85), rgba(40, 60, 90, 0.9)), 
                    url('https://images.unsplash.com/photo-1531058020387-3be344556be6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        background-repeat: no-repeat;
        font-family: 'Montserrat', sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        position: relative;
    }

    /* Animated background overlay */
    body::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: 
            radial-gradient(circle at 10% 20%, rgba(74, 144, 226, 0.3) 0%, transparent 50%),
            radial-gradient(circle at 90% 80%, rgba(156, 39, 176, 0.2) 0%, transparent 50%),
            radial-gradient(circle at 60% 30%, rgba(33, 150, 243, 0.2) 0%, transparent 50%);
        animation: float 8s ease-in-out infinite;
        pointer-events: none;
    }

    .register-container {
        background: rgba(255, 255, 255, 0.97);
        backdrop-filter: blur(25px);
        padding: 4rem;
        border-radius: 25px;
        box-shadow: 
            0 30px 60px rgba(0, 0, 0, 0.3),
            inset 0 1px 0 rgba(255, 255, 255, 0.5);
        border: 1px solid rgba(255, 255, 255, 0.4);
        width: 90%;
        max-width: 500px;
        position: relative;
        overflow: hidden;
        margin: 20px;
        z-index: 10;
    }

    /* Royal decoration */
    .register-container::after {
        content: '🎪';
        position: absolute;
        top: -30px;
        left: 50%;
        transform: translateX(-50%);
        font-size: 3.5rem;
        filter: drop-shadow(0 6px 12px rgba(0,0,0,0.4));
        z-index: 11;
        animation: bounce 2s ease-in-out infinite;
    }

    .register-container::before {
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
        font-size: 3.2rem;
        text-align: center;
        margin-bottom: 2.5rem;
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
        bottom: -18px;
        left: 50%;
        transform: translateX(-50%);
        width: 180px;
        height: 4px;
        background: linear-gradient(90deg, transparent, #7C4DFF, #00BCD4, #FF4081, transparent);
        border-radius: 2px;
        animation: widthPulse 3s ease-in-out infinite;
    }

    h2::before {
        content: '⭐';
        position: absolute;
        top: -15px;
        right: -15px;
        font-size: 1.8rem;
        animation: spin 5s linear infinite;
        filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
    }

    form {
        display: flex;
        flex-direction: column;
        gap: 2.2rem;
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
    input[type="email"],
    input[type="password"],
    select {
        padding: 18px 22px;
        border: 2px solid #E2E8F0;
        border-radius: 15px;
        font-size: 1.1rem;
        transition: all 0.4s ease;
        background: rgba(255, 255, 255, 0.95);
        font-family: 'Montserrat', sans-serif;
        box-shadow: inset 0 2px 6px rgba(0,0,0,0.08);
        appearance: none;
    }

    select {
        background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23667eea' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
        background-repeat: no-repeat;
        background-position: right 20px center;
        background-size: 16px;
        padding-right: 50px;
    }

    input[type="text"]:focus,
    input[type="email"]:focus,
    input[type="password"]:focus,
    select:focus {
        outline: none;
        border-color: #7C4DFF;
        box-shadow: 
            0 0 0 4px rgba(124, 77, 255, 0.15),
            inset 0 2px 6px rgba(0,0,0,0.05);
        transform: translateY(-3px);
        background: rgba(255, 255, 255, 1);
    }

    button[type="submit"] {
        background: linear-gradient(135deg, #7C4DFF 0%, #00BCD4 50%, #FF4081 100%);
        color: white;
        padding: 20px 40px;
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
        margin-top: 2rem;
        font-family: 'Montserrat', sans-serif;
        box-shadow: 0 12px 30px rgba(124, 77, 255, 0.4);
    }

    button[type="submit"]:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 40px rgba(124, 77, 255, 0.6);
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
        padding: 20px;
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

    .login-link {
        text-align: center;
        margin-top: 2.5rem;
        padding-top: 1.5rem;
        border-top: 2px solid #E2E8F0;
        position: relative;
    }

    .login-link a {
        color: #7C4DFF;
        text-decoration: none;
        font-weight: 700;
        position: relative;
        transition: all 0.3s ease;
        font-size: 1.1rem;
        padding: 12px 24px;
        border: 2px solid transparent;
        border-radius: 12px;
        background: rgba(124, 77, 255, 0.1);
        display: inline-block;
    }

    .login-link a:hover {
        background: rgba(124, 77, 255, 0.2);
        border-color: #7C4DFF;
        padding: 12px 30px;
        transform: translateY(-2px);
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
        50% { transform: translateY(-25px) scale(1.02); }
    }

    @keyframes shimmer {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.7; }
    }

    @keyframes spin {
        from { transform: rotate(0deg) scale(1); }
        to { transform: rotate(360deg) scale(1.1); }
    }

    @keyframes bounce {
        0%, 20%, 50%, 80%, 100% { transform: translateX(-50%) translateY(0); }
        40% { transform: translateX(-50%) translateY(-10px); }
        60% { transform: translateX(-50%) translateY(-5px); }
    }

    @keyframes widthPulse {
        0%, 100% { width: 180px; }
        50% { width: 200px; }
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

    .register-container {
        animation: fadeInUp 1.2s ease-out;
    }

    /* Role selection styling */
    .role-options {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .role-label {
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 600;
        color: #4A5568;
    }

    /* Responsive design */
    @media (max-width: 480px) {
        .register-container {
            padding: 3rem 2rem;
            margin: 15px;
        }
        
        h2 {
            font-size: 2.8rem;
        }
        
        body {
            background-attachment: scroll;
        }
    }
</style>
</head>
<body>
<div class="register-container">
    <h2>EventBiz</h2>
    
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="message error-message">
            ⚠️ <%= error %>
        </div>
    <%
        }
    %>
    
    <form method="post" action="<%=request.getContextPath()%>/register">
        <div class="form-group">
            <label for="username">👤 Username</label>
            <input type="text" id="username" name="username" required placeholder="Choose your username"/>
        </div>
        
        <div class="form-group">
            <label for="email">📧 Email</label>
            <input type="email" id="email" name="email" required placeholder="Enter your email address"/>
        </div>
        
        <div class="form-group">
            <label for="password">🔒 Password</label>
            <input type="password" id="password" name="password" required placeholder="Create a strong password"/>
        </div>
        
        <div class="form-group">
            <label for="role">🎭 Select Role</label>
            <select id="role" name="role" required>
                <option value="PARTICIPANT">🎟️ Participant</option>
                <option value="ORGANIZER">📋 Organizer</option>
                <option value="ADMIN">⚡ Admin</option>
            </select>
        </div>
        
        <button type="submit">🚀 Create Account</button>
    </form>
    
    <div class="login-link">
        <a href="<%=request.getContextPath()%>/login">🔐 Already have an account? Login here</a>
    </div>
</div>
</body>
</html>