--SQL Retail Sales Analysis P1
create database za_project1;

--Creating the Retail Sales table
drop table if exists retail_sales;
create table retail_sales
	(
		transactions_id int primary key,
		sale_date date,
		sale_time time,
		customer_id int,
		gender varchar(10),
		age int,
		category varchar(15),
		quantity int,
		price_per_unit float,
		cogs float,
		total_sale float
	);

--Cleaning null values:
delete from retail_sales
where
	transactions_id is null
	or
	sale_time is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	category is null
	or
	quantity is null
	or price_per_unit is null
	or 
	cogs is null
	or  total_sale is null
;

--Data Exploration

--How transactions we have?
select COUNT(*) as total_sale from retail_sales;

--How many unique customers we have?
select COUNT(distinct customer_id) unique_customers from retail_sales;

--How many unique categories we have?
select distinct category unique_category from retail_sales;

--Data Analysis & Business Key Problems & Answers
--Q1) Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select
	*
from
	retail_sales
where
	sale_date = '2022-11-05'
;


--Q2) Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select
	*
from
	retail_sales
where
	category = 'Clothing'
	and
	quantity >= 4
	and
	(YEAR(sale_date) = 2022
	and
	MONTH(sale_date) = 11)
;

--Q3) Write a SQL query to calculate the total sales (total_sale) for each category.:

select
	category,
	SUM(total_sale) as grand_total,
	count(transactions_id) as total_orders
from
	retail_sales
group by
	category
order by
	category
;


--Q4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select
	AVG(age) as average_customer_age
from
	retail_sales
where
	category = 'Beauty'
;


--Q5) Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select
	*
from
	retail_sales
where
	total_sale > 1000
;


--Q6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select
	category,
	gender,
	COUNT(transactions_id) totalOrders
from
	retail_sales

group by
	category,
	gender
order by
	1 asc,2 desc
;


--Q7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

with cte_retail as(
					select
						year(sale_date) saleYear,
						MONTH(sale_date) saleMonth,
						round(AVG(total_sale),2) average_sales,
						DENSE_RANK() over(partition by year(sale_date) order by avg(total_sale) desc) sale_rank
					from
						retail_sales
					group by
						year(sale_date),
						MONTH(sale_date)
)
	select
		*
	from
		cte_retail
	where
		sale_rank = 1
	;


--Q8) Write a SQL query to find the top 5 customers based on the highest total sales **:

select
	top 5
	customer_id,
	SUM(total_sale) as total
from
	retail_sales
group by
	customer_id
order by 2 desc

--Q9) Write a SQL query to find the number of unique customers who purchased items from each category.:

select
	category,
	COUNT(distinct customer_id) as uniqueCustomers
from
	retail_sales
group by
	category
order by 1


--Q10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

select
	case
		when
		datepart(HOUR,sale_time) < 12
		then 'Morning'
		when
		datepart(HOUR,sale_time) >= 12 and datepart(HOUR,sale_time) <= 17
		then 'Afternoon'
		else
		'Evening'
	end as Shift,
	COUNT(transactions_id) as totalOrders
from
	retail_sales
group by
	case
		when
		datepart(HOUR,sale_time) < 12
		then 'Morning'
		when
		datepart(HOUR,sale_time) >= 12 and datepart(HOUR,sale_time) <= 17
		then 'Afternoon'
		else
		'Evening'
	end
;