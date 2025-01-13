<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
    <!-- Bootstrap for responsive design and styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Custom styles for cart display */
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
        }
        .table td, .table th {
            vertical-align: middle;
        }
        .quantity-input {
            width: 60px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container my-5">
        <h1 class="text-center mb-4">Your Shopping Cart</h1>
        <%
            // Retrieve the shopping cart (product list) from the session
            @SuppressWarnings({"unchecked"})
            HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

            // Handle cart updates if the form is submitted
            if (request.getMethod().equalsIgnoreCase("POST")) {
                // Loop through all form parameters
                Map<String, String[]> parameters = request.getParameterMap();
                for (Map.Entry<String, String[]> entry : parameters.entrySet()) {
                    if (entry.getKey().startsWith("quantity_")) {
                        // Extract product ID from parameter name
                        String productId = entry.getKey().substring(9); // "quantity_" prefix removed
                        int newQuantity = Integer.parseInt(entry.getValue()[0]); // Get the updated quantity

                        // Update or remove product based on the new quantity
                        if (newQuantity > 0 && productList.containsKey(productId)) {
                            ArrayList<Object> product = productList.get(productId);
                            product.set(3, newQuantity); // Update quantity in the product list
                        } else if (newQuantity <= 0) {
                            productList.remove(productId); // Remove product if quantity is zero or less
                        }
                    }
                }
                // Save the updated product list back into the session
                session.setAttribute("productList", productList);
            }

            // Display a message if the cart is empty
            if (productList == null || productList.isEmpty()) {
        %>
            <div class="alert alert-warning text-center" role="alert">
                <h2>Your shopping cart is empty!</h2>
            </div>
        <%
            } else {
                // Format for displaying currency
                NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);
        %>
            <form method="post" action="showcart.jsp">
                <!-- Display cart items in a table -->
                <table class="table table-bordered table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th class="text-center">Quantity</th>
                            <th class="text-end">Price</th>
                            <th class="text-end">Subtotal</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
        <%
                double total = 0; // Initialize total price
                Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();

                // Loop through all items in the cart
                while (iterator.hasNext()) {
                    Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                    ArrayList<Object> product = entry.getValue();

                    int productId = Integer.parseInt(product.get(0).toString());
                    String productName = product.get(1).toString();
                    double productPrice = Double.parseDouble(product.get(2).toString());
                    int productQuantity = Integer.parseInt(product.get(3).toString());

                    double subtotal = productPrice * productQuantity; // Calculate subtotal for the product
                    total += subtotal; // Add subtotal to total
        %>
                    <tr>
                        <td><%= productId %></td>
                        <td><%= productName %></td>
                        <td class="text-center">
                            <!-- Input field for updating quantity -->
                            <input type="number" name="quantity_<%= productId %>" value="<%= productQuantity %>" min="1" class="form-control quantity-input">
                        </td>
                        <td class="text-end"><%= currFormat.format(productPrice) %></td>
                        <td class="text-end"><%= currFormat.format(subtotal) %></td>
                        <td class="text-center">
                            <!-- Link to remove the product from the cart -->
                            <a href="removecart.jsp?id=<%= productId %>" class="btn btn-danger btn-sm">Remove</a>
                        </td>
                    </tr>
        <%
                }
        %>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="4" class="text-end"><b>Order Total</b></td>
                            <td class="text-end"><b><%= currFormat.format(total) %></b></td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>

                <!-- Action buttons -->
                <div class="d-flex justify-content-between mt-4">
                    <a href="listprod.jsp" class="btn btn-secondary">Continue Shopping</a>
                    <button type="submit" class="btn btn-primary">Update Cart</button>
                    <a href="checkout.jsp" class="btn btn-success">Check Out</a>
                </div>
            </form>
        <%
            }
        %>
    </div>
</body>
</html>
