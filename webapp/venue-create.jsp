<%@page contentType="text/html;charset=UTF-8" %>
<html><head><title>Create Venue</title></head><body>
<h2>Create Venue</h2>
<%
  String error = (String) request.getAttribute("error");
  if (error != null) { %><p style="color:red"><%= error %></p><% }
%>
<form method="post" action="<%=request.getContextPath()%>/venue/create">
  Name: <input name="name" required/><br/>
  Location: <input name="location"/><br/>
  Capacity: <input name="capacity" type="number" value="0"/><br/>
  Description: <textarea name="description"></textarea><br/>
  <button type="submit">Create</button>
</form>
<p><a href="<%=request.getContextPath()%>/venues">Back</a></p>
</body></html>
