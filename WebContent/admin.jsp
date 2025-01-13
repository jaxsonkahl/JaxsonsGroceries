<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header Section -->
    <header class="bg-dark text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">Jaxson's Groceries - Admin Dashboard</h1>
            <nav>
                <!-- Navigation Links -->
                <a href="index.jsp" class="text-white text-decoration-none me-3">Home</a>
                <a href="listprod.jsp" class="text-white text-decoration-none me-3">Begin Shopping</a>
                <a href="listorder.jsp" class="text-white text-decoration-none me-3">List All Orders</a>
                <a href="customer.jsp" class="text-white text-decoration-none me-3">My Profile</a>
                <a href="logout.jsp" class="text-white text-decoration-none">Log Out</a>
                <% 
                    // Display authenticated user's name if logged in
                    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
                    if (authenticatedUser != null) { 
                %>
                    <span class="text-white ms-3">Logged in as: <strong><%= authenticatedUser %></strong></span>
                <% } %>
            </nav>
        </div>
    </header>

    <!-- Restore Database Section -->
    <div class="container my-3">
        <form action="loaddata.jsp" method="post" target="_blank">
            <button type="submit" class="btn btn-danger">Restore Database to Original State</button>
        </form>
    </div>

    <!-- Admin Dashboard Main Section -->
    <div class="container my-5">
        <h1 class="text-center mb-4">Administrator Dashboard</h1>

        <!-- Sales Report Section -->
        <div class="card shadow mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Sales Report by Day</h5>
            </div>
            <div class="card-body">
                <%
                    // Query to fetch sales report grouped by date
                    String salesSql = "SELECT YEAR(orderDate), MONTH(orderDate), DAY(orderDate), SUM(totalAmount) FROM OrderSummary GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate)";
                    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                    try {
                        getConnection();
                        Statement stmt = con.createStatement();
                        stmt.execute("USE orders");

                        // Execute sales report query
                        ResultSet salesRst = stmt.executeQuery(salesSql);

                        // Display sales report in a table
                        out.println("<table class='table table-bordered table-striped'>");
                        out.println("<thead class='table-secondary'><tr><th>Order Date</th><th>Total Order Amount</th></tr></thead>");
                        out.println("<tbody>");

                        while (salesRst.next()) {
                            String orderDate = salesRst.getString(1) + "-" + salesRst.getString(2) + "-" + salesRst.getString(3);
                            double totalAmount = salesRst.getDouble(4);
                            out.println("<tr><td>" + orderDate + "</td><td>" + currFormat.format(totalAmount) + "</td></tr>");
                        }

                        out.println("</tbody></table>");
                    } catch (SQLException ex) {
                        out.println("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
                    } finally {
                        closeConnection();
                    }
                %>
            </div>
        </div>

        <!-- Customer List Section -->
        <div class="card shadow">
            <div class="card-header bg-secondary text-white">
                <h5 class="mb-0">Customer List</h5>
            </div>
            <div class="card-body">
                <%
                    // Query to fetch customer details
                    String customerSql = "SELECT customerId, firstName, lastName, email, phonenum, city, country FROM Customer";

                    try {
                        getConnection();
                        Statement stmt = con.createStatement();
                        stmt.execute("USE orders");

                        // Execute customer details query
                        ResultSet customerRst = stmt.executeQuery(customerSql);

                        // Display customer list in a table
                        out.println("<table class='table table-bordered table-striped'>");
                        out.println("<thead class='table-secondary'><tr><th>ID</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone</th><th>City</th><th>Country</th></tr></thead>");
                        out.println("<tbody>");

                        while (customerRst.next()) {
                            out.println("<tr>");
                            out.println("<td>" + customerRst.getInt("customerId") + "</td>");
                            out.println("<td>" + customerRst.getString("firstName") + "</td>");
                            out.println("<td>" + customerRst.getString("lastName") + "</td>");
                            out.println("<td>" + customerRst.getString("email") + "</td>");
                            out.println("<td>" + customerRst.getString("phonenum") + "</td>");
                            out.println("<td>" + customerRst.getString("city") + "</td>");
                            out.println("<td>" + customerRst.getString("country") + "</td>");
                            out.println("</tr>");
                        }

                        out.println("</tbody></table>");
                    } catch (SQLException ex) {
                        out.println("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
                    } finally {
                        closeConnection();
                    }
                %>
            </div>
        </div>

        <!-- Product Management Section -->
        <div class="card shadow mb-4">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0">Manage Products</h5>
            </div>
            <div class="card-body">
                <!-- Add Product Form -->
                <h6>Add Product</h6>
                <form action="admin.jsp" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-3">
                        <label for="productName" class="form-label">Product Name</label>
                        <input type="text" name="productName" id="productName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="productPrice" class="form-label">Price</label>
                        <input type="number" step="0.01" name="productPrice" id="productPrice" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="productDesc" class="form-label">Description</label>
                        <textarea name="productDesc" id="productDesc" class="form-control" rows="3" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Add Product</button>
                </form>
                <hr>

                <!-- Existing Products Table -->
                <h6>Existing Products</h6>
                <%
                    // Query to fetch product details
                    String productSql = "SELECT productId, productName, productPrice, productDesc FROM product";

                    try {
                        getConnection();
                        Statement stmt = con.createStatement();
                        stmt.execute("USE orders");
                        ResultSet productRst = stmt.executeQuery(productSql);

                        // Display products in a table
                        out.println("<table class='table table-bordered table-striped'>");
                        out.println("<thead class='table-secondary'><tr><th>ID</th><th>Name</th><th>Price</th><th>Description</th><th>Actions</th></tr></thead>");
                        out.println("<tbody>");

                        while (productRst.next()) {
                            int id = productRst.getInt("productId");
                            String name = productRst.getString("productName");
                            double price = productRst.getDouble("productPrice");
                            String desc = productRst.getString("productDesc");

                            out.println("<tr>");
                            out.println("<td>" + id + "</td>");
                            out.println("<td>" + name + "</td>");
                            out.println("<td>" + price + "</td>");
                            out.println("<td>" + desc + "</td>");
                            out.println("<td>");
                            out.println("<form action='admin.jsp' method='post' class='d-inline'>");
                            out.println("<input type='hidden' name='action' value='update'>");
                            out.println("<input type='hidden' name='productId' value='" + id + "'>");
                            out.println("<input type='text' name='productName' value='" + name + "' class='form-control form-control-sm mb-1' required>");
                            out.println("<input type='number' step='0.01' name='productPrice' value='" + price + "' class='form-control form-control-sm mb-1' required>");
                            out.println("<textarea name='productDesc' class='form-control form-control-sm mb-1' required>" + desc + "</textarea>");
                            out.println("<button type='submit' class='btn btn-warning btn-sm'>Update</button>");
                            out.println("</form>");
                            out.println("<form action='admin.jsp' method='post' class='d-inline ms-2'>");
                            out.println("<input type='hidden' name='action' value='delete'>");
                            out.println("<input type='hidden' name='productId' value='" + id + "'>");
                            out.println("<button type='submit' class='btn btn-danger btn-sm'>Delete</button>");
                            out.println("</form>");
                            out.println("</td>");
                            out.println("</tr>");
                        }

                        out.println("</tbody></table>");
                    } catch (SQLException ex) {
                        out.println("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
                    } finally {
                        closeConnection();
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
