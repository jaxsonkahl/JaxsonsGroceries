<%@ page import="java.sql.*,java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Order List</title>
    <!-- Bootstrap CSS for styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Styles for the order cards */
        .order-card {
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .order-header {
            background-color: #f8f9fa;
            padding: 10px 15px;
            border-bottom: 1px solid #ddd;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }
        .order-body {
            padding: 15px;
        }
    </style>
</head>
<body>
    <!-- Page header with navigation -->
    <header class="bg-dark text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">Jaxson's Groceries</h1>
            <nav>
                <!-- Navigation links -->
                <a href="index.jsp" class="text-white text-decoration-none me-3">Home</a>
                <a href="listprod.jsp" class="text-white text-decoration-none me-3">Begin Shopping</a>
                <a href="listorder.jsp" class="text-white text-decoration-none me-3">List All Orders</a>
                <a href="customer.jsp" class="text-white text-decoration-none me-3">My Profile</a>
                <a href="admin.jsp" class="text-white text-decoration-none me-3">Administrators</a>
                <a href="logout.jsp" class="text-white text-decoration-none">Log Out</a>
                <%
                    // Display the logged-in user's information if authenticated
                    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
                    if (authenticatedUser != null) {
                %>
                    <span class="text-white ms-3">Logged in as: <strong><%= authenticatedUser %></strong></span>
                <% } %>
            </nav>
        </div>
    </header>

    <!-- Main content container -->
    <div class="container my-5">
        <h1 class="mb-4 text-center">Order List</h1>
        <%
        // SQL query to fetch order summaries along with customer details
        String sql = "SELECT orderId, O.CustomerId, totalAmount, firstName + ' ' + lastName, orderDate FROM OrderSummary O, Customer C WHERE "
                   + "O.customerId = C.customerId";

        // Format for displaying currency
        NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

        try {
            getConnection(); // Establish a connection to the database
            Statement stmt = con.createStatement();
            stmt.execute("USE orders"); // Select the database

            // Execute the query to fetch order summaries
            ResultSet rst = stmt.executeQuery(sql);

            // SQL query to fetch order details (products in each order)
            sql = "SELECT productId, quantity, price FROM OrderProduct WHERE orderId=?";
            PreparedStatement pstmt = con.prepareStatement(sql);

            // Iterate through the result set for order summaries
            while (rst.next()) {
                int orderId = rst.getInt(1); // Extract order ID
                int customerId = rst.getInt(2); // Extract customer ID
                String customerName = rst.getString(4); // Extract customer name
                String orderDate = rst.getString(5); // Extract order date
                double totalAmount = rst.getDouble(3); // Extract total amount

                // Create an order card for each order
                out.println("<div class='order-card'>");
                out.println("<div class='order-header'>");
                out.println("<h5 class='mb-0'>Order ID: " + orderId + "</h5>");
                out.println("<small>Date: " + orderDate + "</small>");
                out.println("</div>");
                out.println("<div class='order-body'>");

                // Display order summary details
                out.println("<p><strong>Customer ID:</strong> " + customerId + "</p>");
                out.println("<p><strong>Customer Name:</strong> " + customerName + "</p>");
                out.println("<p><strong>Total Amount:</strong> " + currFormat.format(totalAmount) + "</p>");

                // Fetch and display order details
                pstmt.setInt(1, orderId); // Set the order ID parameter
                ResultSet rst2 = pstmt.executeQuery();

                // Create a table for order details
                out.println("<table class='table table-sm table-bordered'>");
                out.println("<thead class='table-secondary'><tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr></thead>");
                out.println("<tbody>");
                while (rst2.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rst2.getInt(1) + "</td>"); // Display product ID
                    out.println("<td>" + rst2.getInt(2) + "</td>"); // Display quantity
                    out.println("<td>" + currFormat.format(rst2.getDouble(3)) + "</td>"); // Display price
                    out.println("</tr>");
                }
                out.println("</tbody>");
                out.println("</table>");

                out.println("</div>");
                out.println("</div>");
            }
        } catch (SQLException ex) {
            // Display an error message if a database error occurs
            out.println("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
        } finally {
            closeConnection(); // Ensure the database connection is closed
        }
        %>
    </div>
</body>
</html>
