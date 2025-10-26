SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Products;

--?? Level 1: Basic Data Understanding:
--1.Display the first 10 records from each table (Customers, Orders, Products).
SELECT TOP 10 * FROM Customers;
SELECT TOP 10 * FROM Orders;
SELECT TOP 10 * FROM Products;

--2.Count the total number of customers, orders, and products.
SELECT COUNT(*) AS TotalCustomers FROM Customers;
SELECT COUNT(*) AS TotalOrders FROM Orders;
SELECT COUNT(*) AS TotalProducts FROM Products;

--3.Show all unique product categories.
SELECT DISTINCT category
FROM Products;

--4.Find the number of orders placed by each customer.
SELECT c.first_name, c.last_name, COUNT(o.OrderID) AS number_of_orders
FROM customers c
LEFT JOIN orders o
ON c.customerid = o.customerid
GROUP BY c.first_name, c.last_name
ORDER BY number_of_orders DESC;

--5.List customers who have placed more than 3 orders.
SELECT c.first_name, c.last_name, COUNT(o.OrderID) AS number_of_orders
FROM customers c
LEFT JOIN orders o
ON c.customerid = o.customerid
GROUP BY c.first_name, c.last_name
HAVING COUNT(o.OrderID) > 3
ORDER BY number_of_orders DESC;

--?? Level 2: Sales & Revenue Analysis:
--6.Calculate the total revenue generated.
SELECT SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
ON o.productid = p.productid;

--7.Find the top 5 products by total sales amount.
SELECT TOP 5 p.product_name,
       SUM(o.quantity * p.price) AS total_sales
FROM orders o
JOIN products p
ON o.productid = p.productid
GROUP BY p.product_name
ORDER BY total_sales DESC;

--8.List the total revenue per category.
SELECT p.category,
       SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
ON o.productid = p.productid
GROUP BY p.category
ORDER BY total_revenue DESC;

--9.Find the average order value (AOV) = total revenue ÷ total orders.
SELECT SUM(o.quantity * p.price) / COUNT(DISTINCT o.orderid) AS average_order_value
FROM orders o
JOIN products p
ON o.productid = p.productid;

--10.Show monthly revenue trends (Month-Year wise sales).
SELECT FORMAT(o.date_and_time_of_purchase, 'MMM-yyyy') AS month_year,
       SUM(o.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN products p
ON o.productid = p.productid
GROUP BY FORMAT(o.date_and_time_of_purchase, 'MMM-yyyy')
ORDER BY MIN(o.date_and_time_of_purchase);

--?? Level 3: Delivery & Performance Metrics
--11.Find the total number of delivered and cancelled orders.
SELECT 
    Delivery_Status,
    COUNT(orderid) AS total_orders
FROM orders
GROUP BY Delivery_Status;

--12.Calculate the cancellation rate (%):
SELECT 
    (SUM(CASE WHEN Delivery_Status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0) /
    COUNT(*) AS cancellation_rate_percentage
FROM orders;

--13.Find which state or city has the highest number of cancellations.
SELECT c.city,
    COUNT(o.orderid) AS total_cancellations
FROM orders o
JOIN customers c 
ON o.customerid = c.customerid
WHERE o.Delivery_Status = 'Cancelled'
GROUP BY c.city
ORDER BY total_cancellations DESC;

--14.Determine the average delivery success rate per city.
SELECT c.city,
    (SUM(CASE WHEN o.Delivery_Status = 'Delivered' THEN 1 ELSE 0 END) * 100.0) /
    COUNT(o.orderid) AS delivery_success_rate
FROM orders o
JOIN customers c 
ON o.customerid = c.customerid
GROUP BY c.city
ORDER BY delivery_success_rate DESC;

--15.Find the most frequently ordered product.
SELECT TOP 1 p.product_name,
    SUM(o.quantity) AS total_quantity
FROM orders o
JOIN products p 
ON o.productid = p.productid
GROUP BY p.product_name
ORDER BY total_quantity DESC;

--?? Level 4: Customer Insights
--16.List top 5 customers by total spending.
SELECT TOP 5 c.first_name, c.last_name,
    SUM(o.quantity * p.price) AS total_spending
FROM orders o
JOIN customers c 
ON o.customerid = c.customerid
JOIN products p 
ON o.productid = p.productid
GROUP BY c.first_name, c.last_name
ORDER BY total_spending DESC;


--17.Identify inactive customers (those who never placed an order).
SELECT 
    c.customerid,
    c.first_name,
    c.last_name
FROM customers c
LEFT JOIN orders o 
ON c.customerid = o.customerid
WHERE o.customerid IS NULL;
