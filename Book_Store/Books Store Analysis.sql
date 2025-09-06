drop table if exists books;

create table books (
					book_id int primary key,
					title varchar(100),
					author varchar(100),
					genre varchar(50),
					published_year int,
					price numeric(10,2),
					stock int
);
drop table if exists customers;
create table customers (
						customer_id int primary key,
						name varchar(100),
						email varchar(100),
						phone varchar(15),
						city varchar(50),
						country varchar(150)
);
drop table if exists orders;
create table orders (
					order_id int primary key,
					customer_id int references customers(customer_id),
					book_id int references books(book_id),
					order_date date,
					quantity int,
					total_amount numeric(10,2)
);

select * from books;
select * from customers;
select * from orders;

-- 1) Retrieve all books in the "Fiction" genre

select * from books where genre = 'Fiction';

-- 2) Find books published after the year 1950

select * from books where published_year > 1950;

-- 3) List all customers from the Canada

select * from customers where city = 'Canada';

-- 4) Show orders placed in November 2023

select * from orders where order_date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available

select sum(stock) as total_number from books;

-- 6) Find the details of the most expensive book

select * , (select max(price) from books) from books order by price desc limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book

select customers.name , orders.quantity from customers 
join orders on orders.customer_id = customers.customer_id
where orders.quantity >1;

-- 8) Retrieve all orders where the total amount exceeds $20

select * from orders where total_amount > 20;

-- 9) List all genres available in the Books table

select distinct genre from books;

-- 10) Find the book with the lowest stock

select * ,(select min(stock) from books) as lowest_stock from books order by stock limit 1;

-- 11) Calculate the total revenue generated from all orders

select sum(total_amount) as total_revenue from orders;

-- 12) Retrieve the total number of books sold for each genre

select books.genre , sum(orders.quantity) as total_number from books
join orders on orders.book_id = books.book_id
group by books.genre 

-- 13) Find the average price of books in the "Fantasy" genre

select *,avg(price) over(partition by genre) as averege from books where genre = 'Fantasy';

-- 14) List customers who have placed at least 2 orders

select customers.customer_id ,customers.name ,count(orders.order_id) as total_orders from customers
join orders on orders.customer_id = customers.customer_id 
group by customers.customer_id , customers.name
having count(orders.order_id) >=2;


-- 15) Find the most frequently ordered book


select books.title , count(orders.order_id) as Most_frequently from books 
join orders on orders.book_id = books.book_id
group by books.title
order by Most_frequently desc limit 1;

-- 16) Show the top 3 most expensive books of 'Fantasy' Genre

select * from books where genre = 'Fantasy' order by price desc limit 3;

-- 17) Retrieve the total quantity of books sold by each author

select books.author , sum(orders.quantity) as total_quantity from books
join orders on orders.book_id = books.book_id
group by books.author

-- 18) List the cities where customers who spent over $30 are located

select distinct customers.city,orders.total_amount from customers
join orders on orders.customer_id = customers.customer_id
where total_amount > 30;

-- 19) Find the customer who spent the most on orders


select customers.name , sum(orders.total_amount) as sum_of_amount from customers
join orders on orders.customer_id = customers.customer_id
group by customers.name 
order by sum_of_amount desc
limit 1;



-- 20) Calculate the stock remaining after fulfilling all orders

select books.book_id ,books.title ,books.stock, coalesce(sum(orders.quantity),0) as order_quantity 
, books.stock - coalesce(sum(orders.quantity),0) as fulfilling_quantity from books
left join orders on orders.book_id = books.book_id 
group by books.book_id;