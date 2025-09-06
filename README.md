# SQL_Project
This repository contains some SQL project for data analyst.


# 1.Netflix_Analysis
![netflix_images](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Netflix_logo.png)

**Project Objective:**

The objective of this project is to analyze the Netflix dataset using advanced SQL techniques to extract meaningful insights about content trends, user preferences, and platform distribution. The project leverages SQL subqueries, Common Table Expressions (CTEs), and window functions to perform in-depth data analysis. This includes identifying the most frequent genres, understanding the release trends over the years, examining country-wise content distribution, and ranking shows based on duration and popularity.

To solve these problems efficiently, I used a combination of:

Subqueries for filtering and conditional analysis,

Common Table Expressions (CTEs) for improving query modularity and readability,

Window Functions to rank, group, and aggregate data dynamically across partitions.

This project aims to simulate data-driven decision-making tasks that a data analyst at Netflix might face, enhancing my SQL proficiency and business insight.


Each problem is explained with:
- **Problem Statement** 📝  
- **SQL Query** 💻  
- **Expected Output/Insight** 📈  

## 1️⃣ Count the Number of Movies vs TV Shows
```sql
SELECT type, COUNT(*) 
FROM netflix 
GROUP BY type;
```
![Netflix Q1](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q1.png)

## 2️⃣ Find the Most Common Rating for Movies and TV Shows
```sql
WITH totalcount AS (
    SELECT type, rating, COUNT(*) AS total_num
    FROM netflix
    GROUP BY 1,2
    ORDER BY total_num DESC
),
rank_count AS (
    SELECT type, rating, total_num,
           RANK() OVER(PARTITION BY type ORDER BY total_num DESC) AS rank_num
    FROM totalcount
)
SELECT type, rating 
FROM rank_count
WHERE rank_num < 2;
```
![Netflix Q2](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q2.png)

## 3️⃣ List All Movies Released in 2020
```sql
SELECT * 
FROM netflix 
WHERE type = 'Movie' 
  AND release_year = 2020;
```
![Netflix Q3](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q3.png)

## 4️⃣ Find the Top 5 Countries with the Most Content
```sql
SELECT * 
FROM (
  SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS country,
         COUNT(*) AS count_country 
  FROM netflix 
  GROUP BY country
) AS t1
WHERE country IS NOT NULL
ORDER BY count_country DESC
LIMIT 5;
```
![Netflix Q4](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q4.png)

## 5️⃣ Identify the Longest Movie
```sql
SELECT * 
FROM netflix 
WHERE type = 'Movie' 
  AND duration IS NOT NULL 
ORDER BY SPLIT_PART(duration,' ',1)::int DESC;
```
![Netflix Q5](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q5.png)

## 6️⃣ Find Content Added in the Last 5 Years
```sql
SELECT * 
FROM netflix 
WHERE TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 year';
```
![Netflix Q6](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q6.png)

## 7️⃣ Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT * 
FROM netflix 
WHERE director LIKE '%Rajiv Chilaka%';
```
![Netflix Q7](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q7.png)

## 8️⃣ List All TV Shows with More Than 5 Seasons
```sql
SELECT * 
FROM netflix 
WHERE type = 'TV Show' 
  AND SPLIT_PART(duration,' ',1)::int > 5;
```
![Netflix Q8](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q8.png)

## 9️⃣ Count the Number of Content Items in Each Genre
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;
```
![Netflix Q9](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q9.png)

## 🔟 Average Content Released Per Year in India
```sql
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```
![Netflix Q10](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q10.png)

## 1️⃣1️⃣ List All Documentaries
```sql
SELECT * 
FROM netflix 
WHERE listed_in ILIKE '%documentaries%';
```
![Netflix Q11](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q11.png)

## 1️⃣2️⃣ Find Content Without a Director
```sql
SELECT * 
FROM netflix 
WHERE director IS NULL;
```
![Netflix Q12](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q12.png)

## 1️⃣3️⃣ Movies with Actor 'Salman Khan' in the Last 10 Years
```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
![Netflix Q13](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q13.png)

## 1️⃣4️⃣ Top 10 Actors in Indian Movies
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```
![Netflix Q14](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q14.png)

## 1️⃣5️⃣ Categorize Content Based on 'Kill' and 'Violence'
```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
```
![Netflix Q15](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q15.png)

**Project Conclusion:**

Through this SQL-based Netflix data analysis project, I achieved the following:

1. Identified content distribution trends by type, genre, country, and release year.

2. Used window functions to find the longest movie and rank actors by appearances.

3. Applied subqueries and filters to analyze content with specific keywords like "Kill" and "Violence".

4. Employed CTEs for reusable logic in complex queries, such as calculating average yearly content for India or counting movies by specific actors and directors.

5. Extracted actionable insights like the most common rating, top-producing countries, and multi-season TV shows.

---
---

# 🍕 Lapinoz Pizza Sales Analysis

![lapinoz_images](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/lapinoz%20image.png)

## 📌 Project Summary
This project analyzes **Lapinose Pizza sales data** using SQL to answer key business questions.  
The dataset contains information about **orders, order details, pizzas, and pizza types**.  
The main goal is to uncover insights that can help improve **sales strategies, menu optimization, and customer behavior understanding**.

---

## 🎯 Objectives
- To calculate **total sales performance** (orders, revenue, average sales).  
- To identify **top-selling pizzas** and categories.  
- To analyze **customer order patterns** (by size, time, and quantity).  
- To calculate **revenue contribution by category** and track **cumulative revenue growth**.  
- To provide **data-driven insights** for business decision-making.  

---

## 📊 Key Insights
1. **Total Orders** – Overall demand trends can be tracked.  
2. **Total Revenue** – Clear view of overall business performance.  
3. **Highest Priced Pizza** – Helps identify premium items.  
4. **Most Common Pizza Size** – Customer preference in pizza sizing.  
5. **Top 5 Pizza Types Ordered** – Core drivers of sales volume.  
6. **Category-Wise Quantity Ordered** – Best performing categories.  
7. **Order Distribution by Hour** – Peak ordering times for better staffing & marketing.  
8. **Category-Wise Pizza Distribution** – Breadth of menu diversity.  
9. **Average Pizzas per Day** – Operational planning metric.  
10. **Top 3 Pizza Types by Revenue** – High-value pizzas.  
11. **Revenue Contribution by Category** – Most profitable categories.  
12. **Cumulative Revenue Over Time** – Growth tracking.  
13. **Top 3 Pizza Types by Revenue per Category** – Deep dive into performance.  

---

## 🗂️ SQL Queries & Solutions

## Q1. Retrieve the total number of orders placed
```sql
select count(*) as Number_of_Order from orders;
```
![lapizza q1](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q1.png)

## Q2. Calculate the total revenue generated from pizza sales
```sql
select round(sum(pizzas.price * orders_details.quantity),2) as Total_Revenue 
from orders_details 
join pizzas on pizzas.pizza_id = orders_details.pizza_id;
```
![lapizza q2](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q2.png)

## Q3. Identify the highest-priced pizza
```sql
select pizza_types.name, pizzas.price as Highest_Price 
from pizzas
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id 
order by highest_price desc 
limit 1;
```
![lapizza q3](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q3.png)

## Q4. Identify the most common pizza size ordered
```sql
select pizzas.size , sum(orders_details.quantity) as Total_orders 
from orders_details 
join pizzas on pizzas.pizza_id = orders_details.pizza_id 
group by pizzas.size 
order by total_orders desc 
limit 1;
```
![lapizza q4](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q4.png)

## Q5. List the top 5 most ordered pizza types with quantities
```sql
select pizzas.pizza_type_id, sum(orders_details.quantity) as total_pizza 
from pizzas
join orders_details on orders_details.pizza_id = pizzas.pizza_id 
group by pizzas.pizza_type_id 
order by total_pizza desc 
limit 5;
```
![lapizza q5](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q5.png)

## Q6. Total quantity of each pizza category ordered
```sql
select pizza_types.category , sum(orders_details.quantity) as total_quantity 
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category 
order by total_quantity desc;
```
![lapizza q6](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q6.png)

## Q7. Distribution of orders by hour of the day
```sql
select hour(order_time) as Hour, count(*) as Number_of_orders  
from orders
group by Hour;
```
![lapizza q7](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q7.png)

## Q8. Category-wise distribution of pizzas
```sql
select pizza_types.category , count(pizzas.pizza_id) as total_pizzas 
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.category;
```
![lapizza q8](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q8.png)

## Q9. Average number of pizzas ordered per day
```sql
with average as (
    select orders.order_date, sum(orders_details.quantity) as total_number  
    from orders
    join orders_details on orders_details.order_id = orders.order_id
    group by orders.order_date
)
select round(avg(total_number),0) as avereg_order_per_day 
from average;
```
![lapizza q9](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q9.png)

## Q10. Top 3 most ordered pizza types based on revenue
```sql
select pizzas.pizza_type_id , sum(pizzas.price * orders_details.quantity) as Revenue 
from pizzas
join orders_details on orders_details.pizza_id = pizzas.pizza_id 
group by pizzas.pizza_type_id 
order by Revenue desc 
limit 3;
```
![lapizza q10](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q10.png)

## Q11. Percentage contribution of each category to total revenue
```sql
select pizza_types.category ,
round((sum(pizzas.price*orders_details.quantity)/
       (select sum(pizzas.price * orders_details.quantity) 
        from orders_details join pizzas on pizzas.pizza_id = orders_details.pizza_id)) * 100,2) as revenue 
from pizza_types	
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category;
```
![lapizza q11](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q11.png)

## Q12. Cumulative revenue generated over time
```sql
select order_date , sum(revenue) over(order by order_date) as cum_revenue 
from (
    select orders.order_date , sum(pizzas.price*orders_details.quantity) as revenue 
    from orders
    join orders_details on orders.order_id = orders_details.order_id
    join pizzas on pizzas.pizza_id = orders_details.pizza_id
    group by orders.order_date
) as sales;
```
![lapizza q12](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q12.png)

## Q13. Top 3 most ordered pizza types by revenue for each category
```sql
with revenue_wise_category as (
    select pizza_types.pizza_type_id, pizza_types.category,
           sum(pizzas.price*orders_details.quantity) as revenue,
           dense_rank() over(partition by pizza_types.category 
                             order by sum(pizzas.price*orders_details.quantity) desc) as rank_of_value   
    from orders_details
    join pizzas on pizzas.pizza_id = orders_details.pizza_id
    join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
    group by pizza_types.category, pizza_types.pizza_type_id
)  
select pizza_type_id , category, revenue, rank_of_value  
from revenue_wise_category
where rank_of_value <= 3;
```
![lapizza q13](https://github.com/Rutvik1429/SQL_Project/blob/main/Lapinoz_pizzas_Analysis/Output%20images/lapizza%20q13.png)

---
---

# 📚 Books Store Analysis
![book image](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/book%20image.jpg)

## ✅ Project Overview
This project is an analysis of a books store database using SQL. It involves exploring data related to books, customers, and orders to uncover insights into customer behavior, sales patterns, inventory levels, and more. The analysis demonstrates the use of various SQL functions and queries to solve real-world business problem

## 🎯 Objective
- Analyze customer preferences and ordering patterns.
- Identify popular books, genres, and high-spending customers.
- Calculate total revenue and inventory status.
- Assist in making data-driven decisions for inventory and marketing.
- Showcase SQL functionalities such as joins, aggregation, filtering, and window functions.


## 📂 Dataset Description

### Books Table
| Column        | Description                     |
|---------------|---------------------------------|
| book_id       | Unique identifier for each book |
| title         | Title of the book               |
| author        | Author of the book              |
| genre         | Genre of the book               |
| published_year| Year of publication             |
| price         | Price of the book               |
| stock         | Available stock quantity       |

### Customers Table
| Column    | Description                   |
|-----------|-------------------------------|
| customer_id| Unique identifier for customer |
| name      | Name of the customer          |
| email     | Email address                 |
| phone     | Phone number                  |
| city      | City                          |
| country   | Country                       |

### Orders Table
| Column      | Description                    |
|-------------|--------------------------------|
| order_id    | Unique identifier for each order |
| customer_id | Customer placing the order     |
| book_id     | Book being ordered            |
| order_date  | Date of order                 |
| quantity    | Number of books ordered      |
| total_amount| Total cost of the order      |


## 📊 Insights Derived

✔ **Popular Genres:** Fiction and Fantasy books are most frequently ordered.

✔ **Best Selling Book:** Helps in focusing on high-demand books for better inventory planning.

✔ **High-Spending Customers:** Customers who spend over $30 or place multiple orders can be targeted for special offers.

✔ **Revenue Insights:** The total revenue helps in tracking business performance.

✔ **Inventory Control:** Knowing which books have the lowest stock helps in replenishing stock on time.

✔ **Author Performance:** Authors whose books are ordered frequently can be prioritized.

✔ **Regional Analysis:** Insights on cities with high customer spending can assist in localized marketing.


## 🚀 Tools & Techniques Used

- SQL commands: `SELECT`, `JOIN`, `GROUP BY`, `HAVING`, `ORDER BY`, `WHERE`.
- Aggregation functions: `SUM()`, `MAX()`, `MIN()`, `COUNT()`, `AVG()`.
- Window functions like `AVG() OVER()`.
- Filtering with date ranges.
- Handling nulls using `COALESCE()`.

## 🗂️ SQL Queries & Solutions

## 1 – Retrieve all books in the "Fiction" genre
```sql
SELECT * FROM books WHERE genre = 'Fiction';
```
![book q1](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q1.png)

## 2 – Find books published after the year 1950
```sql
SELECT * FROM books WHERE published_year > 1950;
```
![book q2](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q2.png)

## 3 – List all customers from Canada
```sql
SELECT * FROM customers WHERE city = 'Canada';
```
![book q3](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q3.png)

## 4 – Show orders placed in November 2023
```sql
SELECT * FROM orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';
```
![book q4](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q4.png)

## 5 – Retrieve the total stock of books available
```sql
SELECT SUM(stock) AS total_number FROM books;
```
![book q5](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q5.png)

## 6 – Find details of the most expensive book
```sql
SELECT *, (SELECT MAX(price) FROM books) FROM books ORDER BY price DESC LIMIT 1;
```
![book q6](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q6.png)

## 7 – Show all customers who ordered more than 1 quantity of a book
```sql
SELECT customers.name, orders.quantity FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE orders.quantity > 1;
```
![book q7](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q7.png)

## 8 – Retrieve all orders where the total amount exceeds $20
```sql
SELECT * FROM orders WHERE total_amount > 20;
```
![book q8](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q8.png)

## 9 – List all genres available in the books table
```sql
SELECT DISTINCT genre FROM books;
```
![book q9](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q9.png)

## 10 – Find the book with the lowest stock
```sql
SELECT *, (SELECT MIN(stock) FROM books) AS lowest_stock FROM books ORDER BY stock LIMIT 1;
```
![book q10](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q10.png)

## 11 – Calculate the total revenue generated from all orders
```sql
SELECT SUM(total_amount) AS total_revenue FROM orders;
```
![book q11](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q11.png)

## 12 – Retrieve the total number of books sold for each genre
```sql
SELECT books.genre, SUM(orders.quantity) AS total_number FROM books
JOIN orders ON orders.book_id = books.book_id
GROUP BY books.genre;
```
![book q12](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q12.png)

## 13 – Find the average price of books in the "Fantasy" genre
```sql
SELECT *, AVG(price) OVER (PARTITION BY genre) AS average FROM books WHERE genre = 'Fantasy';
```
![book q13](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q13.png)

## 14 – List customers who have placed at least 2 orders
```sql
SELECT customers.customer_id, customers.name, COUNT(orders.order_id) AS total_orders FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
GROUP BY customers.customer_id, customers.name
HAVING COUNT(orders.order_id) >= 2;
```
![book q14](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q14.png)

## 15 – Find the most frequently ordered book
```sql
SELECT books.title, COUNT(orders.order_id) AS Most_frequently FROM books
JOIN orders ON orders.book_id = books.book_id
GROUP BY books.title
ORDER BY Most_frequently DESC
LIMIT 1;
```
![book q15](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q15.png)

## 16 – Show the top 3 most expensive books of 'Fantasy' genre
```sql
SELECT * FROM books WHERE genre = 'Fantasy' ORDER BY price DESC LIMIT 3;
```
![book q16](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q16.png)

## 17 – Retrieve the total quantity of books sold by each author
```sql
SELECT books.author, SUM(orders.quantity) AS total_quantity FROM books
JOIN orders ON orders.book_id = books.book_id
GROUP BY books.author;
```
![book q17](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q17.png)

## 18 – List the cities where customers who spent over $30 are located
```sql
SELECT DISTINCT customers.city, orders.total_amount FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE total_amount > 30;
```
![book q18](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q18.png)

## 19 – Find the customer who spent the most on orders
```sql
SELECT customers.name, SUM(orders.total_amount) AS sum_of_amount FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
GROUP BY customers.name
ORDER BY sum_of_amount DESC
LIMIT 1;
```
![book q19](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q19.png)

## 20 – Calculate the stock remaining after fulfilling all orders
```sql
SELECT books.book_id, books.title, books.stock, COALESCE(SUM(orders.quantity), 0) AS order_quantity,
       books.stock - COALESCE(SUM(orders.quantity), 0) AS fulfilling_quantity
FROM books
LEFT JOIN orders ON orders.book_id = books.book_id
GROUP BY books.book_id;
```
![book q20](https://github.com/Rutvik1429/SQL_Project/blob/main/Book_Store_Analysis/Output%20images/book%20q20.png)

## 📌 Conclusion

This Books Store Analysis demonstrates how SQL can be used to answer critical business questions. The insights from this analysis can help the store optimize its operations, enhance customer experience, and improve profitability.

---
---
