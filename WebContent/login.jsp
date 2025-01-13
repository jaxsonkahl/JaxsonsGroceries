<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <header class="bg-dark text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">Jaxson's Groceries</h1>
            <nav>
                <a href="listprod.jsp" class="text-white text-decoration-none me-3">Begin Shopping</a>
                <a href="listorder.jsp" class="text-white text-decoration-none me-3">List All Orders</a>
                <a href="customer.jsp" class="text-white text-decoration-none me-3">My Profile</a>
                <a href="admin.jsp" class="text-white text-decoration-none me-3">Administrators</a>
                <a href="logout.jsp" class="text-white text-decoration-none">Log Out</a>
				<%
                    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
                    if (authenticatedUser != null) {
                %>
                    <span class="text-white ms-3">Logged in as: <strong><%= authenticatedUser %></strong></span>
                <% } %>
            </nav>
        </div>
    </header>

    <div class="container my-5">
        <h3 class="text-center mb-4">Please Login to System</h3>

        <%-- Print prior error login message if present --%>
        <% if (session.getAttribute("loginMessage") != null) { %>
            <div class="alert alert-danger text-center">
                <%= session.getAttribute("loginMessage").toString() %>
            </div>
        <% } %>

        <form name="MyForm" method="post" action="validateLogin.jsp" class="mx-auto" style="max-width: 400px;">
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" name="username" id="username" class="form-control" maxlength="10" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" name="password" id="password" class="form-control" maxlength="10" required>
            </div>
            <div class="d-grid">
                <input class="btn btn-primary" type="submit" name="Submit2" value="Log In">
            </div>
        </form>
    </div>
</body>
</html>
