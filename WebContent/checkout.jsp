<!DOCTYPE html>
<html>
<head>
    <title>Jaxson's Grocery - Checkout</title>
    <!-- Link to Bootstrap CSS for consistent styling -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Custom styles for the checkout page */
        body {
            background-color: #f8f9fa;
        }
        .checkout-container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }
        .checkout-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .btn-custom {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <!-- Header section with navigation links -->
    <header class="bg-dark text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">Jaxson's Grocery - Checkout</h1>
            <nav>
                <!-- Navigation links to various pages -->
                <a href="login.jsp" class="text-white text-decoration-none me-3">Login</a>
                <a href="listprod.jsp" class="text-white text-decoration-none me-3">Begin Shopping</a>
                <a href="listorder.jsp" class="text-white text-decoration-none me-3">List All Orders</a>
                <a href="customer.jsp" class="text-white text-decoration-none me-3">My Profile</a>
                <a href="admin.jsp" class="text-white text-decoration-none me-3">Administrators</a>
                <a href="logout.jsp" class="text-white text-decoration-none">Log Out</a>
            </nav>
        </div>
    </header>

    <!-- Main checkout container -->
    <div class="container checkout-container">
        <!-- Checkout header with title and instructions -->
        <div class="checkout-header">
            <h2>Checkout</h2>
            <p>Enter your customer ID to complete the transaction.</p>
        </div>
        <!-- Form for entering customer ID -->
        <form method="get" action="order.jsp">
            <div class="mb-3">
                <!-- Input field for customer ID -->
                <label for="customerId" class="form-label">Customer ID</label>
                <input type="text" name="customerId" id="customerId" class="form-control" required>
            </div>
            <div class="text-center">
                <!-- Submit and reset buttons -->
                <button type="submit" class="btn btn-primary btn-custom">Submit</button>
                <button type="reset" class="btn btn-secondary btn-custom">Reset</button>
            </div>
        </form>
    </div>
</body>
</html>
