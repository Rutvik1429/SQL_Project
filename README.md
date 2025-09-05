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

# 🍕 Lapinose Pizza Sales Analysis (SQL Project)

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

