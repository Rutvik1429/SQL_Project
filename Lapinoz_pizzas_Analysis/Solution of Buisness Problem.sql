select * from orders;
select * from orders_details;
select * from pizzas;
select * from pizza_types;

# q1 Retrieve the total number of orders placed.

select count(*) as Number_of_Order from orders;

# q2 Calculate the total revenue generated from pizza sales.

select round(sum(pizzas.price * orders_details.quantity),2) as Total_Revenue from orders_details 
join pizzas on pizzas.pizza_id = orders_details.pizza_id;

# q3 Identify the highest-priced pizza.

select pizza_types.name, pizzas.price as Highest_Price from pizzas
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id order by highest_price desc limit 1;

# q4 Identify the most common pizza size ordered.

select pizzas.size , sum(orders_details.quantity) as Total_orders from orders_details 
join pizzas on pizzas.pizza_id = orders_details.pizza_id group by pizzas.size order by total_orders desc limit 1;

# q5 List the top 5 most ordered pizza types along with their quantities.

select pizzas.pizza_type_id	,sum(orders_details.quantity) as total_pizza from pizzas
join orders_details on orders_details.pizza_id = pizzas.pizza_id group by pizzas.pizza_type_id order by total_pizza desc limit 5; 

# q6 Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category , sum(orders_details.quantity) as total_quantity from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category 
order by total_quantity desc;

# q7 Determine the distribution of orders by hour of the day.

 
select hour(order_time)as Hour,count(*) as Number_of_orders  from orders
group by Hour;

# q8 Join relevant tables to find the category-wise distribution of pizzas.

select pizza_types.category , count(pizzas.pizza_id) as total_pizzas from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.category;

# q9 Group the orders by date and calculate the average number of pizzas ordered per day.


with average as (select orders.order_date,sum(orders_details.quantity) as total_number  from orders
join orders_details on orders_details.order_id = orders.order_id
group by orders.order_date)
select  round(avg(total_number),0) as avereg_order_per_day from average;

# q10 Determine the top 3 most ordered pizza types based on revenue.


select pizzas.pizza_type_id , sum(pizzas.price * orders_details.quantity) as Revenue from pizzas
join orders_details on orders_details.pizza_id = pizzas.pizza_id group by pizzas.pizza_type_id order by Revenue desc limit 3;

# q11 Calculate the percentage contribution of each pizza Category to total revenue.


select pizza_types.category ,round((sum(pizzas.price*orders_details.quantity)/(select round(sum(pizzas.price * orders_details.quantity),2) as total_revenue from orders_details 
join pizzas on pizzas.pizza_id = orders_details.pizza_id)) * 100,2) as revenue from pizza_types	
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category;

# q12 Analyze the cumulative revenue generated over time.


select order_date , sum(revenue) over(order by order_date) as cum_revenue from
 (select orders.order_date , sum(pizzas.price*orders_details.quantity) as revenue from orders
join orders_details on orders.order_id = orders_details.order_id
join pizzas on pizzas.pizza_id = orders_details.pizza_id
group by orders.order_date) as sales;

# q13 Determine the top 3 most ordered pizza types based on revenue for each pizza category.


with revenue_wise_category as(select pizza_types.pizza_type_id,pizza_types.category,sum(pizzas.price*orders_details.quantity) as revenue ,dense_rank() over(partition by pizza_types.category order by sum(pizzas.price*orders_details.quantity) desc) as rank_of_value   from orders_details
join pizzas on pizzas.pizza_id = orders_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category,pizza_types.pizza_type_id)  
select pizza_type_id ,category,revenue,rank_of_value  from revenue_wise_category
where rank_of_value <= 3;