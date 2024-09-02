create database Retail;
use Retail;
create table Retail_data (
			transactions_id	int primary key,
            sale_date date,
            sale_time time,
            customer_id	int,
            gender varchar(15),	
            age	int,
            category varchar(20),	
            quantiy	int,
            price_per_unit	float,
            cogs float,
            total_sale float);
            
            
show tables;
select * from retail_data;
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

 select * from retail_data where sale_date = '2022-11-05';
 
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

select transactions_id from retail_data 
where category like '%Clothing%' and quantiy >= 10 and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select sum(total_sale),category ,count(*)as total_orders from retail_data
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2),category from retail_data 
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select transactions_id from retail_data 
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select round(count(transactions_id),2)as 'total_transaction',gender,category from retail_data 
group by gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select year,month,average_sale from (
select avg(total_sale)as'average_sale',extract(YEAR from sale_date)as year,extract(MONTH from sale_date)as month,
row_number() over(partition by extract(YEAR from sale_date) order by avg(total_sale))as rnk from retail_data group by 2,3)t
where rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select * from retail_data;
select customer_id,sum(total_sale) from retail_data
group by customer_id 
order by sum(total_sale) desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct(transactions_id)),category from retail_data 
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hoursly as (
	select *,
	case when time(sale_time) <=12 then 'Morning'
	when time(sale_time) between 12 and 17 then 'afternoon'
	else 'evening' end as 'shifts' 
    from retail_data)
    select shifts,count(*) 
    from hoursly group by shifts;



WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

