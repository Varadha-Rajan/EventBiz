<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Accept either request attribute (if forward used elsewhere) or parameter (if redirect)
    Object paymentAttr = request.getAttribute("paymentId");
    Object ticketAttr  = request.getAttribute("ticketId");

    String paymentId = (paymentAttr != null) ? String.valueOf(paymentAttr) : request.getParameter("paymentId");
    String ticketId  = (ticketAttr  != null) ? String.valueOf(ticketAttr)  : request.getParameter("ticketId");

    if (paymentId != null) paymentId = paymentId.trim();
    if (ticketId  != null) ticketId  = ticketId.trim();

    String safePaymentId = (paymentId == null || paymentId.isEmpty() || "null".equalsIgnoreCase(paymentId)) ? "" : paymentId;
    String safeTicketId  = (ticketId  == null || ticketId.isEmpty()  || "null".equalsIgnoreCase(ticketId))  ? "" : ticketId;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Simulate Payment</title>
</head>
<body>
<h2>Simulated Payment</h2>
<p>This page simulates an external payment provider. Click Pay to complete.</p>

<form method="post" action="<%= request.getContextPath() %>/ticket/pay-simulate">
    <input type="hidden" name="paymentId" value="<%= safePaymentId %>" />
    <input type="hidden" name="ticketId"  value="<%= safeTicketId %>" />
    <button type="submit">Pay (Simulate Success)</button>
</form>

<!-- Debug lines while testing -->
<p><strong>Debug (server):</strong> paymentId = '<%= safePaymentId %>' | ticketId = '<%= safeTicketId %>'</p>
<p><strong>Debug (queryString):</strong> <%= request.getQueryString() %></p>
</body>
</html>
