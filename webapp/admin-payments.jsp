<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, model.Payment" %>
<%
    model.User admin = (model.User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
%>
<html><head><title>Payments</title></head><body>
<h2>All Payments</h2>
<p><a href="<%=request.getContextPath()%>/admin/reports">Back to Reports</a></p>
<table border="1" cellpadding="6">
<tr><th>ID</th><th>Ticket ID</th><th>Amount</th><th>Provider</th><th>Status</th><th>Created</th><th>Actions</th></tr>
<% if (payments != null) {
     for (Payment p : payments) { %>
<tr>
  <td><%= p.getId() %></td>
  <td><a href="<%=request.getContextPath()%>/ticket/view?id=<%= p.getTicketId() %>"><%= p.getTicketId() %></a></td>
  <td><%= p.getAmount() %> <%= p.getCurrency() %></td>
  <td><%= p.getProvider() %></td>
  <td><%= p.getStatus() %></td>
  <td><%= p.getCreatedAt() %></td>
  <td>
    <% if (!"REFUNDED".equalsIgnoreCase(p.getStatus())) { %>
      <form method="post" action="<%=request.getContextPath()%>/admin/payments" style="display:inline" onsubmit="return confirm('Process refund?');">
        <input type="hidden" name="paymentId" value="<%= p.getId() %>"/>
        <button type="submit" name="action" value="refund">Refund</button>
      </form>
    <% } else { %> - <% } %>
  </td>
</tr>
<%   }
   } else { %>
<tr><td colspan="7">No payments</td></tr>
<% } %>
</table>
</body></html>
