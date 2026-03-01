<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, dao.VenueBookingDAO.VenueUsageRow, model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    List<VenueUsageRow> rows = (List<VenueUsageRow>) request.getAttribute("reportRows");
%>
<html><head><title>Venue Usage Report</title></head><body>
<h2>Venue Usage Report</h2>
<form method="post" action="<%=request.getContextPath()%>/venue/report">
  From (yyyy-mm-dd): <input name="from_date" value="<%= request.getAttribute("from") == null ? "" : request.getAttribute("from") %>"/>
  To (yyyy-mm-dd): <input name="to_date" value="<%= request.getAttribute("to") == null ? "" : request.getAttribute("to") %>"/>
  <button type="submit">Run Report</button>
</form>

<% if (rows != null) { %>
  <table border="1">
    <tr><th>Venue</th><th>Bookings</th><th>Hours Booked</th></tr>
    <% for (VenueUsageRow r : rows) { %>
      <tr>
        <td><%= r.getVenueName() %></td>
        <td><%= r.getBookings() %></td>
        <td><%= String.format("%.2f", r.getHours()) %></td>
      </tr>
    <% } %>
  </table>
<% } %>

<p><a href="<%=request.getContextPath()%>/venues">Back to venues</a></p>
</body></html>
