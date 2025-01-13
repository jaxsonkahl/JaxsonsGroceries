<!DOCTYPE html>
<html>
<head>
    <title>Jaxson's Groceries</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-image: url('grocery-store.jpg'); /* Replace with your actual background image */
            background-size: cover;
            background-position: top;
            background-repeat: no-repeat;
        }
        .overlay {
            background-color: rgba(255, 255, 255, 0.8);
            padding: 30px;
            border-radius: 8px;
            max-width: 600px;
            margin: 50px auto;
        }
        nav {
            background-color: #343a40;
            padding: 10px;
        }
        nav a {
            color: white;
            margin-right: 15px;
            text-decoration: none;
        }
        nav a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <header class="bg-dark text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">Jaxson's Groceries</h1>
            <nav class="d-flex align-items-center">
                <a href="login.jsp" class="text-white text-decoration-none me-3">Login</a>
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

    <div class="container mt-4">
        <%-- Welcome message if user is logged in --%>
        <%
            if (authenticatedUser != null) {
        %>
            <div class="alert alert-success text-center">
                <h2>Welcome back, <%= authenticatedUser %>!</h2>
                <p>We're glad to have you shopping with us.</p>
            </div>
        <% } %>

        <div class="overlay text-center">
            <h1>Welcome to Jaxson's Groceries</h1>
            <p>At Jaxson's Groceries, we strive to make online shopping effortless and enjoyable.
            Discover a wide variety of products with our intuitive platform, designed to simplify your shopping journey.</p>
            <p>Shop with us today and transform the way you stock up on groceries!</p>
            <a href="listprod.jsp" class="btn btn-primary">Begin Shopping</a>
        </div>
    </div>
</body>
</html>
