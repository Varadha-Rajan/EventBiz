<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, model.User" %>
<%
    model.User admin = (model.User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login"); return;
    }
    List<User> attendees = (List<User>) request.getAttribute("attendees");
    Integer eventId = (Integer) request.getAttribute("eventId");
%>
<html><head><title>Attendees for Event <%= eventId %></title></head><body>
<h2>Attendees for Event ID: <%= eventId %></h2>
<p><a href="<%=request.getContextPath()%>/admin/reports">Back to Reports</a></p>
<table border="1" cellpadding="6">
<tr><th>ID</th><th>Username</th><th>Email</th><th>Role</th><th>Registered At</th></tr>
<% if (attendees != null) {
     for (User u : attendees) { %>
<tr>
  <td><%= u.getId() %></td>
  <td><%= u.getUsername() %></td>
  <td><%= u.getEmail() %></td>
  <td><%= u.getRole() %></td>
  <td>-</td>
</tr>
<%   }
   } else { %>
<tr><td colspan="5">No attendees found.</td></tr>
<% } %>
</table>
</body></html>
