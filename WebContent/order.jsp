<%@ page import="java.sql.*,java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map,java.math.BigDecimal" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Jaxson's Grocery - Order Processing</title>
    <!-- Bootstrap for styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .order-container {
            max-width: 800px;
            margin: 50px auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }
        .table thead th {
            background-color: #f1f1f1;
        }
        .btn-custom {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <!-- Header with navigation -->
    <header class="bg-dark text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">Jaxson's Grocery - Order Summary</h1>
            <nav>
                <!-- Navigation links -->
                <a href="login.jsp" class="text-white text-decoration-none me-3">Login</a>
                <a href="listprod.jsp" class="text-white text-decoration-none me-3">Begin Shopping</a>
                <a href="listorder.jsp" class="text-white text-decoration-none me-3">List All Orders</a>
                <a href="customer.jsp" class="text-white text-decoration-none me-3">My Profile</a>
                <a href="admin.jsp" class="text-white text-decoration-none me-3">Administrators</a>
                <a href="logout.jsp" class="text-white text-decoration-none">Log Out</a>
            </nav>
        </div>
    </header>

    <div class="container order-container">
        <%
        // Retrieve customer ID and shopping cart from the session
        String custId = request.getParameter("customerId");
        @SuppressWarnings({"unchecked"})
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

        // Validate the customer ID and cart
        if (custId == null || custId.equals("")) {
            out.println("<div class='alert alert-danger'>Invalid customer ID. Please go back and try again.</div>");
        } else if (productList == null) {
            out.println("<div class='alert alert-warning'>Your shopping cart is empty!</div>");
        } else {
            // Ensure the customer ID is numeric
            int num = -1;
            try {
                num = Integer.parseInt(custId);
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Invalid customer ID. Please go back and try again.</div>");
                return;
            }

            // SQL to fetch customer details
            String sql = "SELECT customerId, firstName + ' ' + lastName FROM Customer WHERE customerId = ?";
            NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

            try {
                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders");

                // Prepare statement to retrieve customer information
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, num);
                ResultSet rst = pstmt.executeQuery();
                int orderId = 0;
                String custName = "";

                if (!rst.next()) {
                    // If no customer is found
                    out.println("<div class='alert alert-danger'>Invalid customer ID. Please go back and try again.</div>");
                } else {
                    // Fetch customer name
                    custName = rst.getString(2);

                    // Insert new order record
                    sql = "INSERT INTO OrderSummary (customerId, totalAmount, orderDate) VALUES(?, 0, ?);";

                    // Execute insert and retrieve the generated order ID
                    pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                    pstmt.setInt(1, num);
                    pstmt.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
                    pstmt.executeUpdate();
                    ResultSet keys = pstmt.getGeneratedKeys();
                    keys.next();
                    orderId = keys.getInt(1);

                    // Display the order summary
                    out.println("<h1 class='mb-4'>Your Order Summary</h1>");
                    out.println("<table class='table table-bordered'>");
                    out.println("<thead><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr></thead>");
                    out.println("<tbody>");

                    double total = 0; // Initialize order total
                    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                    while (iterator.hasNext()) {
                        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                        ArrayList<Object> product = entry.getValue();
                        String productId = (String) product.get(0);

                        // Display product details
                        out.print("<tr>");
                        out.print("<td>" + productId + "</td>");
                        out.print("<td>" + product.get(1) + "</td>");
                        out.print("<td align='center'>" + product.get(3) + "</td>");
                        String price = (String) product.get(2);
                        double pr = Double.parseDouble(price);
                        int qty = (Integer) product.get(3);
                        out.print("<td align='right'>" + currFormat.format(pr) + "</td>");
                        out.print("<td align='right'>" + currFormat.format(pr * qty) + "</td>");
                        out.println("</tr>");

                        // Update total
                        total += pr * qty;

                        // Insert order-product details
                        sql = "INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES(?, ?, ?, ?)";
                        pstmt = con.prepareStatement(sql);
                        pstmt.setInt(1, orderId);
                        pstmt.setInt(2, Integer.parseInt(productId));
                        pstmt.setInt(3, qty);
                        pstmt.setString(4, price);
                        pstmt.executeUpdate();
                    }

                    // Display total row
                    out.println("<tr><td colspan='4' align='right'><b>Order Total</b></td>");
                    out.println("<td align='right'>" + currFormat.format(total) + "</td></tr>");
                    out.println("</tbody></table>");

                    // Update the total amount in the order summary
                    sql = "UPDATE OrderSummary SET totalAmount=? WHERE orderId=?";
                    pstmt = con.prepareStatement(sql);
                    pstmt.setDouble(1, total);
                    pstmt.setInt(2, orderId);
                    pstmt.executeUpdate();

                    // Confirmation message
                    out.println("<div class='mt-4'>");
                    out.println("<h4>Order completed. Your order will be shipped soon.</h4>");
                    out.println("<p><strong>Order Reference Number:</strong> " + orderId + "</p>");
                    out.println("<p><strong>Shipping to Customer:</strong> " + custId + " (" + custName + ")</p>");
                    out.println("</div>");

                    // Link to return to shopping
                    out.println("<a href='shop.html' class='btn btn-primary btn-custom'>Return to Shopping</a>");

                    // Clear the shopping cart from the session
                    session.setAttribute("productList", null);
                }
            } catch (SQLException ex) {
                // Handle database errors
                out.println("<div class='alert alert-danger'>Error processing your order: " + ex.getMessage() + "</div>");
            } finally {
                // Ensure the connection is closed
                closeConnection();
            }
        }
        %>
    </div>
</body>
</html>
