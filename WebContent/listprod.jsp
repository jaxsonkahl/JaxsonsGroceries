<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Jaxson's Groceries - Browse Products</title>
    <!-- Bootstrap CSS for styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- Page Header with Navigation -->
    <header class="bg-dark text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">Jaxson's Groceries</h1>
            <nav>
                <!-- Navigation Links -->
                <a href="index.jsp" class="text-white text-decoration-none me-3">Home</a>
                <a href="login.jsp" class="text-white text-decoration-none me-3">Login</a>
                <a href="listprod.jsp" class="text-white text-decoration-none me-3">Begin Shopping</a>
                <a href="listorder.jsp" class="text-white text-decoration-none me-3">List All Orders</a>
                <a href="customer.jsp" class="text-white text-decoration-none me-3">My Profile</a>
                <a href="admin.jsp" class="text-white text-decoration-none me-3">Administrators</a>
                <a href="logout.jsp" class="text-white text-decoration-none">Log Out</a>
                <% 
                    // Display authenticated user information if logged in
                    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
                    if (authenticatedUser != null) {
                %>
                    <span class="text-white ms-3">Logged in as: <strong><%= authenticatedUser %></strong></span>
                <% } %>
            </nav>
        </div>
    </header>

    <!-- Main Content Container -->
    <main class="container my-5 p-4 bg-light rounded shadow">
        <h2 class="mb-4">Browse Products By Category and Search by Product Name:</h2>

        <!-- Search and Filter Form -->
        <form method="get" action="listprod.jsp" class="mb-4">
            <div class="row g-3">
                <!-- Dropdown for category selection -->
                <div class="col-md-4">
                    <select size="1" name="categoryName" class="form-select">
                        <option>All</option>
                        <option>Beverages</option>
                        <option>Condiments</option>
                        <option>Confections</option>
                        <option>Dairy Products</option>
                        <option>Grains/Cereals</option>
                        <option>Meat/Poultry</option>
                        <option>Produce</option>
                        <option>Seafood</option>
                    </select>
                </div>
                <!-- Input field for product name search -->
                <div class="col-md-5">
                    <input type="text" name="productName" size="50" class="form-control" placeholder="Enter product name">
                </div>
                <!-- Submit and Reset buttons -->
                <div class="col-md-3 d-flex">
                    <button type="submit" class="btn btn-primary me-2">Submit</button>
                    <button type="reset" class="btn btn-secondary">Reset</button>
                </div>
            </div>
        </form>

        <%
        // Define colors for categories to display products with distinct styling
        HashMap<String, String> colors = new HashMap<>();
        colors.put("Beverages", "#0000FF");
        colors.put("Condiments", "#FF0000");
        colors.put("Confections", "#000000");
        colors.put("Dairy Products", "#6600CC");
        colors.put("Grains/Cereals", "#55A5B3");
        colors.put("Meat/Poultry", "#FF9900");
        colors.put("Produce", "#00CC00");
        colors.put("Seafood", "#FF66CC");

        // Get search and filter parameters from the request
        String name = request.getParameter("productName");
        String category = request.getParameter("categoryName");
        boolean hasNameParam = name != null && !name.equals("");
        boolean hasCategoryParam = category != null && !category.equals("") && !category.equals("All");

        String filter = "", sql = "";

        // Determine the SQL query and filter heading based on user input
        if (hasNameParam && hasCategoryParam) {
            filter = "<h3>Products containing '" + name + "' in category: '" + category + "'</h3>";
            name = '%' + name + '%';
            sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE productName LIKE ? AND categoryName = ?";
        } else if (hasNameParam) {
            filter = "<h3>Products containing '" + name + "'</h3>";
            name = '%' + name + '%';
            sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE productName LIKE ?";
        } else if (hasCategoryParam) {
            filter = "<h3>Products in category: '" + category + "'</h3>";
            sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId WHERE categoryName = ?";
        } else {
            filter = "<h3>All Products</h3>";
            sql = "SELECT productId, productName, productPrice, categoryName FROM Product P JOIN Category C ON P.categoryId = C.categoryId";
        }

        // Display the filter heading
        out.println(filter);

        // Use a currency formatter to format product prices
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        try {
            // Connect to the database
            getConnection();
            Statement stmt = con.createStatement();
            stmt.execute("USE orders");

            // Prepare and execute the SQL query based on the filters
            PreparedStatement pstmt = con.prepareStatement(sql);
            if (hasNameParam) {
                pstmt.setString(1, name);
                if (hasCategoryParam) {
                    pstmt.setString(2, category);
                }
            } else if (hasCategoryParam) {
                pstmt.setString(1, category);
            }

            ResultSet rst = pstmt.executeQuery();

            // Generate the product table
            out.print("<table class='table table-bordered'>");
            out.print("<thead class='table-dark'><tr><th></th><th>Product Name</th><th>Category</th><th>Price</th></tr></thead><tbody>");
            while (rst.next()) {
                int id = rst.getInt(1);
                String itemCategory = rst.getString(4);
                String color = colors.getOrDefault(itemCategory, "#FFFFFF");

                // Create a row for each product with Add to Cart and product details links
                out.print("<tr>");
                out.print("<td><a href='addcart.jsp?id=" + id + "&name=" + rst.getString(2) + "&price=" + rst.getDouble(3) + "' class='btn btn-primary btn-sm'>Add to Cart</a></td>");
                out.println("<td><a href='product.jsp?id=" + id + "' style='color:" + color + "'>" + rst.getString(2) + "</a></td>");
                out.println("<td style='color:" + color + "'>" + itemCategory + "</td>");
                out.println("<td style='color:" + color + "'>" + currFormat.format(rst.getDouble(3)) + "</td>");
                out.print("</tr>");
            }
            out.println("</tbody></table>");

            // Close the connection
            closeConnection();
        } catch (SQLException ex) {
            // Display an error message in case of a SQL exception
            out.println("<p class='text-danger'>Error: " + ex.getMessage() + "</p>");
        }
        %>
    </main>
</body>
</html>
