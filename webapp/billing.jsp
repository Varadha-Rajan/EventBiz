<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, model.Payment" %>
<%
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
%>
<html>
<head>
<title>Billing & Transactions - EventBiz</title>
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
        background: linear-gradient(rgba(60, 70, 90, 0.9), rgba(80, 100, 130, 0.95)), 
                    url('https://images.unsplash.com/photo-1554224155-6726b3ff858f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80');
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
            radial-gradient(circle at 40% 80%, rgba(255, 152, 0, 0.15) 0%, transparent 50%);
        animation: float 10s ease-in-out infinite;
        pointer-events: none;
        z-index: -1;
    }

    .billing-container {
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

    .billing-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background: linear-gradient(90deg, #4CAF50, #2196F3, #FF9800, #9C27B0);
        background-size: 400% 400%;
        animation: gradientShift 4s ease infinite;
    }

    .header {
        text-align: center;
        margin-bottom: 3rem;
        position: relative;
    }

    h2 {
        font-family: 'Playfair Display', serif;
        font-size: 3rem;
        background: linear-gradient(135deg, #4CAF50, #2196F3);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 1rem;
    }

    .header-icon {
        font-size: 4rem;
        margin-bottom: 1rem;
        animation: bounce 2s ease-in-out infinite;
        display: block;
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

    .stat-card.total {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
    }

    .stat-card.completed {
        background: linear-gradient(135deg, #2196F3, #03A9F4);
    }

    .stat-card.pending {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
    }

    .stat-card.failed {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
    }

    .transactions-section {
        margin-top: 2rem;
    }

    .transactions-table-container {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    }

    .transactions-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    .transactions-table th {
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

    .transactions-table th::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 2px;
        background: rgba(255, 255, 255, 0.3);
    }

    .transactions-table td {
        padding: 1.3rem 1.5rem;
        border-bottom: 1px solid #E2E8F0;
        transition: all 0.3s ease;
        color: #4A5568;
        vertical-align: middle;
    }

    .transactions-table tr:hover td {
        background: rgba(76, 175, 80, 0.05);
        transform: translateX(5px);
    }

    .transactions-table tr:last-child td {
        border-bottom: none;
    }

    .payment-id {
        font-weight: 700;
        color: #2D3748;
        font-family: 'Courier New', monospace;
    }

    .ticket-link {
        font-weight: 600;
        color: #2196F3;
        text-decoration: none;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .ticket-link:hover {
        color: #1976D2;
        text-decoration: underline;
    }

    .amount {
        font-weight: 700;
        font-size: 1.1rem;
        color: #4CAF50;
    }

    .provider {
        background: rgba(33, 150, 243, 0.1);
        padding: 0.4rem 0.8rem;
        border-radius: 15px;
        font-weight: 600;
        color: #2196F3;
        font-size: 0.85rem;
        display: inline-block;
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
        min-width: 100px;
    }

    .status-completed {
        background: linear-gradient(135deg, #4CAF50, #66BB6A);
        color: white;
    }

    .status-pending {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
    }

    .status-failed {
        background: linear-gradient(135deg, #FF4081, #FF6B6B);
        color: white;
    }

    .status-refunded {
        background: linear-gradient(135deg, #9C27B0, #BA68C8);
        color: white;
    }

    .datetime {
        font-family: 'Courier New', monospace;
        font-size: 0.9rem;
        color: #718096;
    }

    .no-transactions {
        text-align: center;
        padding: 4rem 2rem;
        color: #718096;
        font-size: 1.2rem;
        background: rgba(76, 175, 80, 0.05);
        border-radius: 15px;
        border: 2px dashed #4CAF50;
    }

    .no-transactions h3 {
        margin-bottom: 1rem;
        color: #4A5568;
    }

    .navigation {
        text-align: center;
        margin-top: 3rem;
        padding-top: 2rem;
        border-top: 2px solid #E2E8F0;
    }

    .nav-link {
        color: #4CAF50;
        text-decoration: none;
        font-weight: 700;
        position: relative;
        transition: all 0.3s ease;
        font-size: 1.1rem;
        padding: 12px 24px;
        border: 2px solid transparent;
        border-radius: 12px;
        background: rgba(76, 175, 80, 0.1);
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .nav-link:hover {
        background: rgba(76, 175, 80, 0.2);
        border-color: #4CAF50;
        padding: 12px 30px;
        transform: translateY(-2px);
    }

    /* Currency styling */
    .currency {
        font-size: 0.8em;
        opacity: 0.8;
        margin-left: 2px;
    }

    /* Payment provider icons */
    .provider-stripe::before { content: "💳 "; }
    .provider-paypal::before { content: "🔵 "; }
    .provider-bank::before { content: "🏦 "; }
    .provider-card::before { content: "💳 "; }

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

    .billing-container {
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
        .billing-container {
            padding: 2rem;
        }
        
        .transactions-table {
            font-size: 0.9rem;
        }
        
        .transactions-table th,
        .transactions-table td {
            padding: 1rem;
        }
    }

    @media (max-width: 768px) {
        body {
            padding: 15px;
        }
        
        .billing-container {
            padding: 1.5rem;
        }
        
        h2 {
            font-size: 2.2rem;
        }
        
        .stats-grid {
            grid-template-columns: repeat(2, 1fr);
        }
        
        .transactions-table-container {
            overflow-x: auto;
        }
    }

    @media (max-width: 480px) {
        .billing-container {
            padding: 1rem;
        }
        
        h2 {
            font-size: 1.8rem;
        }
        
        .stats-grid {
            grid-template-columns: 1fr;
        }
        
        .transactions-table {
            min-width: 700px;
        }
        
        .header-icon {
            font-size: 3rem;
        }
    }

    /* Summary section */
    .summary-section {
        background: linear-gradient(135deg, rgba(76, 175, 80, 0.1), rgba(33, 150, 243, 0.1));
        padding: 2rem;
        border-radius: 15px;
        margin-bottom: 2rem;
        border-left: 4px solid #4CAF50;
    }

    .summary-text {
        font-size: 1.1rem;
        color: #2D3748;
        text-align: center;
        font-weight: 600;
    }

    /* Export options */
    .export-options {
        text-align: right;
        margin-bottom: 1rem;
    }

    .export-btn {
        background: linear-gradient(135deg, #FF9800, #FFB74D);
        color: white;
        padding: 8px 16px;
        border: none;
        border-radius: 8px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 5px;
        font-size: 0.9rem;
    }

    .export-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 152, 0, 0.3);
    }
</style>
</head>
<body>
<div class="billing-container">
    <div class="header">
        <div class="header-icon">💳</div>
        <h2>Billing & Transactions</h2>
        <p style="color: #718096; font-size: 1.1rem;">View your payment history and transaction details</p>
    </div>

    <% 
        if (payments != null && !payments.isEmpty()) { 
        double totalAmount = 0;
        int completedPayments = 0;
        int pendingPayments = 0;
        int failedPayments = 0;
        
        for (Payment p : payments) {
            totalAmount += p.getAmount();
            if ("COMPLETED".equalsIgnoreCase(p.getStatus())) completedPayments++;
            else if ("PENDING".equalsIgnoreCase(p.getStatus())) pendingPayments++;
            else if ("FAILED".equalsIgnoreCase(p.getStatus())) failedPayments++;
        }
    %>
    
    <div class="stats-grid">
        <div class="stat-card total">
            <div class="stat-number">$<%= String.format("%.2f", totalAmount) %></div>
            <div class="stat-label">Total Spent</div>
        </div>
        <div class="stat-card completed">
            <div class="stat-number"><%= completedPayments %></div>
            <div class="stat-label">Completed</div>
        </div>
        <div class="stat-card pending">
            <div class="stat-number"><%= pendingPayments %></div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-card failed">
            <div class="stat-number"><%= failedPayments %></div>
            <div class="stat-label">Failed</div>
        </div>
    </div>

    <div class="summary-section">
        <p class="summary-text">
            📊 You have <strong><%= payments.size() %></strong> transactions totaling 
            <strong>$<%= String.format("%.2f", totalAmount) %></strong>
        </p>
    </div>

    <div class="export-options">
        <button class="export-btn" onclick="exportToCSV()">
            📥 Export CSV
        </button>
    </div>

    <div class="transactions-section">
        <div class="transactions-table-container">
            <table class="transactions-table">
                <thead>
                    <tr>
                        <th>🆔 Payment ID</th>
                        <th>🎫 Ticket</th>
                        <th>💰 Amount</th>
                        <th>🏦 Provider</th>
                        <th>📊 Status</th>
                        <th>⏰ Date & Time</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Payment p : payments) { 
                        String statusClass = "status-pending";
                        if ("COMPLETED".equalsIgnoreCase(p.getStatus())) statusClass = "status-completed";
                        else if ("FAILED".equalsIgnoreCase(p.getStatus())) statusClass = "status-failed";
                        else if ("REFUNDED".equalsIgnoreCase(p.getStatus())) statusClass = "status-refunded";
                        
                        String providerClass = "provider-" + p.getProvider().toLowerCase();
                    %>
                        <tr>
                            <td>
                                <span class="payment-id">#<%= p.getId() %></span>
                            </td>
                            <td>
                                <a href="<%=request.getContextPath()%>/ticket/view?id=<%=p.getTicketId()%>" class="ticket-link">
                                    🎫 Ticket #<%= p.getTicketId() %>
                                </a>
                            </td>
                            <td class="amount">
                                $<%= String.format("%.2f", p.getAmount()) %>
                                <span class="currency"><%= p.getCurrency() %></span>
                            </td>
                            <td>
                                <span class="provider <%= providerClass %>">
                                    <%= p.getProvider() %>
                                </span>
                            </td>
                            <td>
                                <span class="status-badge <%= statusClass %>">
                                    <%= p.getStatus() %>
                                </span>
                            </td>
                            <td class="datetime">
                                <%= p.getCreatedAt() %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } else { %>
        <div class="no-transactions">
            <h3>💳 No Transactions Found</h3>
            <p>You haven't made any payments yet.</p>
            <p style="margin-top: 0.5rem; color: #718096;">
                Your transaction history will appear here once you start purchasing tickets.
            </p>
        </div>
    <% } %>

    <div class="navigation">
        <a href="<%=request.getContextPath()%>/events" class="nav-link">
            🎪 Browse Events
        </a>
    </div>
</div>

<script>
    // Add loading animations
    document.addEventListener('DOMContentLoaded', function() {
        const tableRows = document.querySelectorAll('.transactions-table tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.1}s`;
            row.style.animation = 'fadeInUp 0.5s ease-out forwards';
            row.style.opacity = '0';
        });

        // Add hover effects to stat cards
        const statCards = document.querySelectorAll('.stat-card');
        statCards.forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
            });
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(-5px) scale(1)';
            });
        });
    });

    // Export functionality (placeholder)
    function exportToCSV() {
        alert('📥 Export feature coming soon! Your transaction data will be downloaded as a CSV file.');
        // In a real implementation, this would generate and download a CSV file
    }
</script>
</body>
</html>