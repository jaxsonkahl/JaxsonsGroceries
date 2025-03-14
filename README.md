# Jaxson's Groceries

## Description
Jaxson's Groceries is a web-based application designed to facilitate online grocery shopping. The application allows customers to browse products, add items to their cart, place orders, and manage their profiles. Administrators can manage products, view sales reports, and restore the database to its original state.

## Table of Contents
- [Demonstration](#demonstration)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Key Files and Their Functions](#key-files-and-their-functions)
- [Docker Setup](#docker-setup)
- [License](#license)
- [Contact Information](#contact-information)

## Demonstration

https://github.com/user-attachments/assets/9939fb2e-60ee-458a-aa6c-a781da3f0534


## Installation
1. **Clone the repository**:
    ```sh
    git clone https://github.com/jaxsonkahl/JaxsonsGroceries
    cd JaxsonsGroceries
    ```

2. **Build and run the Docker containers**:
    ```sh
    docker-compose up --build
    ```

3. **Access the application**:

   Open a web browser and navigate to `http://localhost/shop/loaddata.jsp` to load grocery data.

   Then navigate to `http://localhost/shop/index.jsp` to start using the application.

## Usage
- **Customer**:
    - Browse products, add items to the cart, and place orders.
    - View and update profile information.
    - View order history.

- **Administrator**:
    - Manage products (add, update, delete).
    - View sales reports.
    - Restore the database to its original state.

## Project Structure
  ```
    JaxsonsGroceries/
    │
    ├── docker-compose.yml
    ├── Dockerfile
    ├── WebContent/
    │   ├── addcart.jsp
    │   ├── admin.jsp               # Administrator dashboard
    │   ├── auth.jsp                # Authentication check
    │   ├── checkout.jsp            # Checkout page
    │   ├── css/
    │   │   └── bootstrap.min.css   # Bootstrap CSS
    │   ├── customer.jsp            # Customer profile page
    │   ├── ddl/
    │   │   ├── orderdb_sql.ddl     # MySQL database schema
    │   │   └── SQLServer_orderdb.ddl # SQL Server database schema
    │   ├── displayImage.jsp
    │   ├── header.jsp
    │   ├── HelloWorld.jsp
    │   ├── img/
    │   ├── index.jsp               # Home page
    │   ├── jdbc.jsp
    │   ├── listorder.jsp           # List all orders
    │   ├── listprod.jsp            # Browse products
    │   ├── loaddata.jsp
    │   ├── login.jsp               # Login page
    │   ├── logout.jsp              # Logout page
    │   ├── META-INF/
    │   ├── order.jsp               # Order processing page
    │   ├── product.jsp             # Product details page
    │   ├── removecart.jsp
    │   ├── ship.jsp
    │   ├── shop.html
    │   ├── showcart.jsp            # Shopping cart page
    │   ├── updateCustomer.jsp      # Update customer information
    │   ├── validateLogin.jsp       # Validate user login
    │   └── WEB-INF/
    ├── README.md                    # Project documentation
    └── .DS_Store

  ```

## Key Files and Their Functions

- **docker-compose.yml**: Defines the services for MySQL and SQL Server databases, and the Java application.
- **Dockerfile**: Specifies the base image and setup for the Tomcat server running the Java application.
- **WebContent/**: Contains all the web application files, including JSP pages, CSS, and SQL DDL scripts.

### JSP Pages

- **admin.jsp**: Administrator dashboard for managing products, viewing sales reports, and restoring the database.
- **auth.jsp**: Authentication check for protected pages.
- **checkout.jsp**: Checkout page for customers to complete their orders.
- **customer.jsp**: Customer profile page for viewing and updating personal information and order history.
- **index.jsp**: Home page of the application.
- **listorder.jsp**: Page for listing all orders.
- **listprod.jsp**: Page for browsing products.
- **login.jsp**: Login page for users.
- **order.jsp**: Order processing page.
- **product.jsp**: Product details page.
- **showcart.jsp**: Shopping cart page.
- **updateCustomer.jsp**: Page for updating customer information.
- **validateLogin.jsp**: Page for validating user login.

### SQL DDL Scripts

- **orderdb_sql.ddl**: SQL script for setting up the MySQL database schema and initial data.
- **SQLServer_orderdb.ddl**: SQL script for setting up the SQL Server database schema and initial data.

## Docker Setup
1. **Build and run the Docker containers**:
    ```sh
    docker-compose up --build
    ```

2. **Access the application**:
    Open a web browser and navigate to `http://localhost/shop/index.jsp`.

## License
This project is licensed under the MIT License.

## Contact Information
For any inquiries, please contact me at jaxsonkahl@gmail.com
