<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <!-- Bootstrap CSS for consistent styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header Section -->
    <header class="bg-dark text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">Jaxson's Groceries</h1>
            <nav>
                <!-- Navigation links -->
                <a href="index.jsp" class="text-white text-decoration-none me-3">Home</a>
                <a href="listprod.jsp" class="text-white text-decoration-none me-3">Begin Shopping</a>
                <a href="listorder.jsp" class="text-white text-decoration-none me-3">List All Orders</a>
                <a href="admin.jsp" class="text-white text-decoration-none me-3">Administrators</a>
                <a href="logout.jsp" class="text-white text-decoration-none">Log Out</a>
                <%
                    // Display logged-in user's information if authenticated
                    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
                    if (authenticatedUser != null) {
                %>
                    <span class="text-white ms-3">Logged in as: <strong><%= authenticatedUser %></strong></span>
                <% } %>
            </nav>
        </div>
    </header>

    <!-- Main container -->
    <div class="container my-5">
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Customer Profile</h3>
            </div>
            <div class="card-body">
                <%
                    // Retrieve user-specific information using their session ID
                    String userName = (String) session.getAttribute("authenticatedUser");

                    // SQL queries to retrieve customer profile and order history
                    String customerSql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password FROM customer WHERE userid = ?";
                    String orderSql = "SELECT orderId, orderDate, totalAmount FROM ordersummary WHERE customerId = (SELECT customerId FROM customer WHERE userid = ?)";

                    try {
                        getConnection(); // Establish a connection to the database
                        Statement stmt = con.createStatement();
                        stmt.execute("USE orders");

                        // Fetch customer profile information
                        PreparedStatement customerStmt = con.prepareStatement(customerSql);
                        customerStmt.setString(1, userName);
                        ResultSet customerRs = customerStmt.executeQuery();

                        if (customerRs.next()) {
                %>
                            <!-- Form to display and edit customer profile -->
                            <form action="updateCustomer.jsp" method="post">
                                <table class="table table-bordered">
                                    <!-- Display customer information with editable fields -->
                                    <tr><th>ID</th><td><%= customerRs.getString("customerId") %><input type="hidden" name="customerId" value="<%= customerRs.getString("customerId") %>"></td></tr>
                                    <tr><th>First Name</th><td><input type="text" name="firstName" class="form-control" value="<%= customerRs.getString("firstName") %>"></td></tr>
                                    <tr><th>Last Name</th><td><input type="text" name="lastName" class="form-control" value="<%= customerRs.getString("lastName") %>"></td></tr>
                                    <tr><th>Email</th><td><input type="email" name="email" class="form-control" value="<%= customerRs.getString("email") %>"></td></tr>
                                    <tr><th>Phone</th><td><input type="text" name="phonenum" class="form-control" value="<%= customerRs.getString("phonenum") %>"></td></tr>
                                    <tr><th>Address</th><td><input type="text" name="address" class="form-control" value="<%= customerRs.getString("address") %>"></td></tr>
                                    <tr><th>City</th><td><input type="text" name="city" class="form-control" value="<%= customerRs.getString("city") %>"></td></tr>
                                    <tr><th>State</th><td><input type="text" name="state" class="form-control" value="<%= customerRs.getString("state") %>"></td></tr>
                                    <tr><th>Postal Code</th><td><input type="text" name="postalCode" class="form-control" value="<%= customerRs.getString("postalCode") %>"></td></tr>
                                    <tr><th>Country</th><td><input type="text" name="country" class="form-control" value="<%= customerRs.getString("country") %>"></td></tr>
                                    <tr><th>User ID</th><td><%= customerRs.getString("userid") %><input type="hidden" name="userId" value="<%= customerRs.getString("userid") %>"></td></tr>
                                    <tr><th>Password</th><td><input type="password" name="password" class="form-control" value="<%= customerRs.getString("password") %>"></td></tr>
                                </table>
                                <button type="submit" class="btn btn-success">Update Profile</button>
                            </form>
                <% 
                        } else {
                            // Display message if customer information is not found
                            out.println("<div class='alert alert-danger'>No customer information found.</div>");
                        }
                        customerStmt.close();

                        // Fetch and display the user's order history
                        PreparedStatement orderStmt = con.prepareStatement(orderSql);
                        orderStmt.setString(1, userName);
                        ResultSet orderRs = orderStmt.executeQuery();

                        if (orderRs.isBeforeFirst()) {
                            out.println("<h3 class='mt-4'>Order History</h3>");
                            out.println("<table class='table table-bordered'>");
                            out.println("<thead class='table-dark'><tr><th>Order ID</th><th>Order Date</th><th>Total Amount</th></tr></thead>");
                            out.println("<tbody>");
                            while (orderRs.next()) {
                                // Display each order in a table row
                                out.println("<tr>");
                                out.println("<td>" + orderRs.getInt("orderId") + "</td>");
                                out.println("<td>" + orderRs.getTimestamp("orderDate") + "</td>");
                                out.println("<td>$" + orderRs.getBigDecimal("totalAmount") + "</td>");
                                out.println("</tr>");
                            }
                            out.println("</tbody></table>");
                        } else {
                            // Display message if no orders are found
                            out.println("<div class='alert alert-info mt-4'>No orders found.</div>");
                        }
                        orderStmt.close();
                    } catch (SQLException ex) {
                %>
                        <!-- Display error message if any issues occur while fetching data -->
                        <div class="alert alert-danger">Error retrieving data: <%= ex.getMessage() %></div>
                <%
                    } finally {
                        closeConnection(); // Ensure the database connection is closed
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
