<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List, model.Venue" %>
<%
    List<Venue> venues = (List<Venue>) request.getAttribute("venues");
    String searchStart = (String) request.getAttribute("searchStart");
    String searchEnd = (String) request.getAttribute("searchEnd");
%>
<html><head><title>Search Venues</title></head><body>
<h2>Search Venues</h2>
<form method="post" action="<%=request.getContextPath()%>/venue/search">
  Start: <input type="datetime-local" name="start_time" value="<%= searchStart == null ? "" : searchStart %>" required/>
  End: <input type="datetime-local" name="end_time" value="<%= searchEnd == null ? "" : searchEnd %>" required/>
  Min capacity: <input type="number" name="capacity" min="0"/>
  <button type="submit">Search</button>
</form>

<% if (venues != null) { %>
  <h3>Available Venues</h3>
  <table border="1">
    <tr><th>Name</th><th>Location</th><th>Capacity</th><th>Book</th></tr>
    <% for (Venue v : venues) { %>
      <tr>
        <td><%=v.getName()%></td>
        <td><%=v.getLocation()%></td>
        <td><%=v.getCapacity()%></td>
        <td><a href="<%=request.getContextPath()%>/venue/book?venueId=<%=v.getId()%>">Book</a></td>
      </tr>
    <% } %>
  </table>
<% } %>

<p><a href="<%=request.getContextPath()%>/venues">Back to all venues</a></p>
</body></html>
