<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.Map" %>
<%
    model.User admin = (model.User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    Map<String,Object> stats = (Map<String,Object>) request.getAttribute("stats");
    String from = (String) request.getAttribute("from");
    String to = (String) request.getAttribute("to");
%>
<html><head><title>Admin Reports</title></head><body>
<h2>Reports</h2>
<p><a href="<%=request.getContextPath()%>/admin/users">Manage Users</a> | <a href="<%=request.getContextPath()%>/admin/payments">Payments</a></p>

<form method="post" action="<%=request.getContextPath()%>/admin/reports">
  From: <input name="from" type="date" value="<%= from == null ? "" : from %>"/>
  To: <input name="to" type="date" value="<%= to == null ? "" : to %>"/>
  <button type="submit">Run</button>
</form>

<% if (stats != null) { %>
  <h3>Summary</h3>
  <p>Total users: <%= stats.get("totalUsers") %></p>
  <p>Total events: <%= stats.get("totalEvents") %></p>
  <p>Revenue (period): $<%= String.format("%.2f", (Double)stats.get("revenue")) %></p>
<% } %>

<h3>Event Attendees</h3>
<p>To view attendees for an event: <form style="display:inline" action="<%=request.getContextPath()%>/admin/event/attendees" method="get">
  Event ID: <input name="id" required/>
  <button type="submit">View</button>
</form></p>

</body></html>
