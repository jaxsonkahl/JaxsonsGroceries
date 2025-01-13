<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Jaxson's Grocery - Product Information</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <header class="bg-dark text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">Jaxson's Groceries</h1>
            <nav>
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

    <div class="container my-5">
        <%

            String productId = request.getParameter("id");
            if (productId == null || productId.isEmpty()) {
                out.println("<div class='alert alert-warning'>Invalid Product ID.</div>");
                return;
            }

            authenticatedUser = (String) session.getAttribute("authenticatedUser");
            Integer customerId = (Integer) session.getAttribute("customerId");


            if (customerId == null && authenticatedUser != null) {
                try {
                    getConnection();
                    Statement stmt = con.createStatement();
                    stmt.execute("USE orders");

                    String fetchCustomerSql = "SELECT customerId FROM customer WHERE userId = ?";
                    PreparedStatement pstmtFetchCustomer = con.prepareStatement(fetchCustomerSql);
                    pstmtFetchCustomer.setString(1, authenticatedUser);
                    ResultSet rsCustomer = pstmtFetchCustomer.executeQuery();

                    if (rsCustomer.next()) {
                        customerId = rsCustomer.getInt("customerId");
                        session.setAttribute("customerId", customerId);
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Error fetching customer ID: " + e.getMessage() + "</div>");
                } finally {
                    closeConnection();
                }
            }

            // Handle review submission
            String reviewRatingStr = request.getParameter("reviewRating");
            String reviewComment = request.getParameter("reviewComment");

            if (reviewRatingStr != null && reviewComment != null) {

                if (authenticatedUser == null || customerId == null) {
                    out.println("<div class='alert alert-danger mt-4'>You need to log in to submit a review.</div>");
                } else {
                    try {
                        int reviewRating = Integer.parseInt(reviewRatingStr);
                        getConnection();
                        Statement stmt = con.createStatement();
                        stmt.execute("USE orders");

                        String insertReviewSql = "INSERT INTO review (reviewRating, reviewComment, reviewDate, customerId, productId) VALUES (?, ?, GETDATE(), ?, ?)";
                        PreparedStatement insertReviewStmt = con.prepareStatement(insertReviewSql);
                        insertReviewStmt.setInt(1, reviewRating);
                        insertReviewStmt.setString(2, reviewComment);
                        insertReviewStmt.setInt(3, customerId);
                        insertReviewStmt.setInt(4, Integer.parseInt(productId));
                        insertReviewStmt.executeUpdate();

                        out.println("<div class='alert alert-success mt-4'>Thank you for your review!</div>");
                    } catch (Exception ex) {
                        out.println("<div class='alert alert-danger'>Error submitting review: " + ex.getMessage() + "</div>");
                    } finally {
                        closeConnection();
                    }
                }
            }

            // Retrieve product details
            String sql = "SELECT productId, productName, productPrice, productDesc, productImageURL, productImage FROM product WHERE productId = ?";
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            try {
                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders");

                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(productId));

                ResultSet rst = pstmt.executeQuery();

                if (!rst.next()) {
                    out.println("<div class='alert alert-danger'>Invalid product</div>");
                } else {
                    int prodId = rst.getInt("productId");
                    String productName = rst.getString("productName");
                    double productPrice = rst.getDouble("productPrice");
                    String productDesc = rst.getString("productDesc");
                    String productImageURL = rst.getString("productImageURL");
                    String productImageBinary = rst.getString("productImage");

                    // Display product details
                    out.println("<div class='card shadow'>");
                    out.println("<div class='card-header bg-primary text-white'><h2>" + productName + "</h2></div>");
                    out.println("<div class='card-body'>");
                    out.println("<table class='table table-bordered'>");
                    out.println("<tr><th>Id</th><td>" + prodId + "</td></tr>");
                    out.println("<tr><th>Price</th><td>" + currFormat.format(productPrice) + "</td></tr>");
                    out.println("<tr><th>Description</th><td>" + (productDesc != null ? productDesc : "No description available") + "</td></tr>");
                    out.println("</table>");

                    if (productImageURL != null && !productImageURL.isEmpty()) {
                        out.println("<div class='mb-3'><img src='" + productImageURL + "' alt='Product Image' class='img-fluid'></div>");
                    }
                    if (productImageBinary != null && !productImageBinary.isEmpty()) {
                        out.println("<div class='mb-3'><img src='displayImage.jsp?id=" + prodId + "' alt='Product Image' class='img-fluid'></div>");
                    }

                    out.println("<div class='mt-3'>");
                    out.println("<a href='addcart.jsp?id=" + prodId + "&name=" + productName + "&price=" + productPrice + "' class='btn btn-success me-2'>Add to Cart</a>");
                    out.println("<a href='listprod.jsp' class='btn btn-secondary'>Continue Shopping</a>");
                    out.println("</div>");

                    out.println("<hr>");
                    out.println("<h5>Reviews</h5>");
                    String reviewSql = "SELECT R.reviewRating, R.reviewComment, C.firstName, R.reviewDate " +
                                       "FROM review R JOIN customer C ON R.customerId = C.customerId " +
                                       "WHERE R.productId = ? ORDER BY R.reviewDate DESC";
                    pstmt = con.prepareStatement(reviewSql);
                    pstmt.setInt(1, prodId);

                    ResultSet reviewRst = pstmt.executeQuery();

                    if (!reviewRst.isBeforeFirst()) {
                        out.println("<div class='alert alert-info'>No reviews yet for this product.</div>");
                    } else {
                        out.println("<table class='table table-bordered'>");
                        out.println("<thead class='table-light'><tr><th>Rating</th><th>Comment</th><th>Customer</th><th>Date</th></tr></thead>");
                        out.println("<tbody>");
                        while (reviewRst.next()) {
                            int ratingVal = reviewRst.getInt("reviewRating");
                            String commentVal = reviewRst.getString("reviewComment");
                            String customerName = reviewRst.getString("firstName");
                            Date reviewDateVal = reviewRst.getDate("reviewDate");

                            out.println("<tr>");
                            out.println("<td>" + ratingVal + "/5</td>");
                            out.println("<td>" + commentVal + "</td>");
                            out.println("<td>" + customerName + "</td>");
                            out.println("<td>" + reviewDateVal + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</tbody></table>");
                    }

                    // If user is authenticated, allow posting a new review
                    if (authenticatedUser != null && customerId != null) {
                        out.println("<hr>");
                        out.println("<h5>Leave a Review</h5>");
                        out.println("<form action='product.jsp?id=" + prodId + "' method='post'>");
                        out.println("<div class='mb-3'>");
                        out.println("<label for='reviewRating' class='form-label'>Rating (1-5)</label>");
                        out.println("<select name='reviewRating' id='reviewRating' class='form-control' required>");
                        for (int i = 1; i <= 5; i++) {
                            out.println("<option value='" + i + "'>" + i + "</option>");
                        }
                        out.println("</select>");
                        out.println("</div>");
                        out.println("<div class='mb-3'>");
                        out.println("<label for='reviewComment' class='form-label'>Comment</label>");
                        out.println("<textarea name='reviewComment' id='reviewComment' class='form-control' rows='3' required></textarea>");
                        out.println("</div>");
                        out.println("<button type='submit' class='btn btn-primary'>Submit Review</button>");
                        out.println("</form>");
                    } else {
                        out.println("<div class='alert alert-warning mt-4'>You must be logged in to leave a review.</div>");
                    }

                    out.println("</div>");
                    out.println("</div>");
                }
            } catch (SQLException ex) {
                out.println("<div class='alert alert-danger'>Error: " + ex.getMessage() + "</div>");
            } finally {
                closeConnection();
            }
        %>
    </div>
</body>
</html>
