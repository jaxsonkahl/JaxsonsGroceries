<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%
    // Get the product ID from the request
    String productId = request.getParameter("id");
    if (productId != null) {
        @SuppressWarnings({"unchecked"})
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
        if (productList != null) {
            productList.remove(productId);
            session.setAttribute("productList", productList);
        }
    }

    // Redirect back to the shopping cart
    response.sendRedirect("showcart.jsp");
%>
