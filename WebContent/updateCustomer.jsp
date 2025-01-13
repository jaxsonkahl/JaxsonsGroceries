<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Customer</title>
    <!-- Bootstrap for styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container my-5">
        <%
            // Retrieve customer information from the form submission
            String customerId = request.getParameter("customerId");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phonenum = request.getParameter("phonenum");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String postalCode = request.getParameter("postalCode");
            String country = request.getParameter("country");
            String password = request.getParameter("password");

            // SQL query to update the customer's information
            String sql = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ?, password = ? WHERE customerId = ?";

            try {
                // Establish a connection to the database
                getConnection();
                Statement stmt = con.createStatement();
                stmt.execute("USE orders"); // Set the database to 'orders'
                
                // Prepare the SQL statement with the customer data
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, firstName);  // Set first name
                pstmt.setString(2, lastName);   // Set last name
                pstmt.setString(3, email);      // Set email
                pstmt.setString(4, phonenum);   // Set phone number
                pstmt.setString(5, address);    // Set address
                pstmt.setString(6, city);       // Set city
                pstmt.setString(7, state);      // Set state
                pstmt.setString(8, postalCode); // Set postal code
                pstmt.setString(9, country);    // Set country
                pstmt.setString(10, password);  // Set password
                pstmt.setInt(11, Integer.parseInt(customerId)); // Set customer ID

                // Execute the update query and get the number of affected rows
                int rowsUpdated = pstmt.executeUpdate();

                // Display success or error message based on the result
                if (rowsUpdated > 0) {
        %>
                    <div class="alert alert-success">Profile and password updated successfully!</div>
        <%
                } else {
        %>
                    <div class="alert alert-danger">Failed to update profile. Please try again.</div>
        <%
                }
            } catch (SQLException ex) {
        %>
                <!-- Display SQL error if any -->
                <div class="alert alert-danger">Error: <%= ex.getMessage() %></div>
        <%
            } finally {
                // Close the database connection
                closeConnection();
            }
        %>
        <!-- Redirect the user back to the customer profile page after 3 seconds -->
        <meta http-equiv="refresh" content="3;url=customer.jsp">
    </div>
</body>
</html>
