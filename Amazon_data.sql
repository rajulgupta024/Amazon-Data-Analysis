-- SQL Minicapstone Project on Amazon Data
-- Adding column timeofday beside Time Column
alter table amazon_data.amazon
add column timeofday varchar (20) after Time;

-- Updating Values in timeofday column
set sql_safe_updates = 0;

update amazon_data.amazon
	set timeofday = 
		case
			when time(time) >= '00:00:00' and time(time) < '12:00:00' then 'Morning'
			when time(time) >= '12:00:00' and time(time) < '18:00:00' then 'Afternoon'
			else 'Evening'
		end;

-- Adding column dayname beside date column
alter table amazon_data.amazon
add column dayname varchar(20) after Date;

-- updating values in dayname
update amazon_data.amazon
	set dayname =
		case dayofweek(Date)
			when 1 then 'Sun'
			when 2 then 'Mon'
			when 3 then 'Tue'
			when 4 then 'Wed'
			when 5 then 'Thu'
			when 6 then 'Fri'
			when 7 then 'Sat'
		end;

-- Adding Column monthname
alter table amazon_data.amazon
add column monthname varchar(20) after dayname;

-- Updating values in monthname column
update amazon_data.amazon
	set monthname = 
		case month(Date)
			when 1 then 'Jan'
			when 2 then 'Feb'
			when 3 then 'Mar'
			when 4 then 'Apr'
			when 5 then 'May'
			when 6 then 'Jun'
			when 7 then 'Jul'
			when 8 then 'Aug'
			when 9 then 'Sep'
			when 10 then 'Oct'
			when 11 then 'Nov'
			when 12 then 'Dec'
		end;
 
-- Business Que
-- 1. What is the count of distinct cities in the dataset?
select distinct(city) from amazon_data.amazon;

-- 2. For each branch, what is the corresponding city?
select distinct Branch,City from amazon_data.amazon;

-- 3. What is the count of distinct product lines in the dataset?
select count(distinct `Product line`) from amazon_data.amazon;

-- 4. Which payment method occurs most frequently?
select Payment, count(*) as frequency 
from amazon_data.amazon
group by Payment
order by frequency desc
limit 1;

-- 5. Which product line has the highest sales?
select `Product line`, count(*) as total_sales
from amazon_data.amazon
group by `Product line`
order by `total_sales`
desc
limit 1;

-- 6. How much revenue is generated each month?
select monthname, sum(total) as revenue 
from amazon_data.amazon
group by monthname
order by revenue desc;

-- 7. In which month did the cost of goods sold reach its peak?
select monthname, sum(cogs) as total_cogs 
from amazon_data.amazon
group by monthname
order by total_cogs desc limit 1;

-- 8. Which product line generated the highest revenue?
select `Product line`, sum(total) as highest_revenue
from amazon_data.amazon
group by `Product line`
order by highest_revenue desc limit 1;

-- 9. In which city was the highest revenue recorded?
select City, sum(Total) as highest_revenue 
from amazon_data.amazon
group by City
order by highest_revenue desc limit 1;

-- 10. Which product line incurred the highest Value Added Tax?
select `Product line`, sum(`Tax 5%`) as Total_vat 
from amazon_data.amazon
group by `Product line`
order by `Total_vat` desc limit 1;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select `Product line`, sum(Total) as total_sales,
	case
		when sum(Total) > (select avg(Total) from amazon_data.amazon) then 'Good'
		else 'Bad'
	end as sales_status 
from amazon_data.amazon
group by `Product line`
order by total_sales desc;

-- 12. Identify the branch that exceeded the average number of products sold.
select Branch, sum(Quantity) as total_quantity
from amazon_data.amazon
group by Branch
having sum(Quantity) > (select avg(Quantity) from amazon_data.amazon); 

-- 13. Which product line is most frequently associated with each gender?
select `Product line`, Gender,  count(*) as frequency
from amazon_data.amazon
group by Gender, `Product line`
order by frequency desc;

-- 14. Calculate the average rating for each product line.
select `Product line`, avg(Rating) as avg_rating
from amazon_data.amazon
group by `Product line`
order by avg_rating desc;

-- 15. Count the sales occurrences for each time of day on every weekday.
select  timeofday, dayname, count(*) as sales_occurrence
from amazon_data.amazon
where dayname in ('Mon', 'Tue', 'Wed', 'Thu', 'Fri')
group by timeofday, dayname
order by sales_occurrence desc;

-- 16. Identify the customer type contributing the highest revenue.
select `Customer type`, sum(Total) as highest_revenue
from amazon_data.amazon
group by `Customer type`
order by highest_revenue desc;

-- 17. Determine the city with the highest VAT percentage.
select City, 
sum(`Tax 5%`) as highest_vat,
sum(Total) as total_sales,
(sum(`Tax 5%`) / sum(Total)) * 100 as vat_percentage
from amazon_data.amazon
group by City
order by vat_percentage desc;

-- 18. Identify the customer type with the highest VAT payments.
select `Customer type`, sum(`Tax 5%`) as highest_vat_payments
from amazon_data.amazon
group by `Customer type`
order by highest_vat_payments desc;

-- 19. What is the count of distinct customer types in the dataset?
select count(distinct (`Customer type`)) as distinct_customers
from amazon_data.amazon;

-- 20. What is the count of distinct payment methods in the dataset?
select count(distinct(Payment)) as distinct_payment
from amazon_data.amazon;

-- 21. Which customer type occurs most frequently?
select `Customer type`, count(`Customer type`) as frequency
from amazon_data.amazon 
group by `Customer type`
order by frequency desc limit 1;

-- 22. Identify the customer type with the highest purchase frequency.
select `Customer type`, count(*) as highest_purchase
from amazon_data.amazon 
group by `Customer type`
order by highest_purchase desc limit 1;

-- 23. Determine the predominant gender among customers.
select Gender, count(*) as predominant_gender
from amazon_data.amazon
group by Gender
order by predominant_gender desc limit 1;

-- 24. Examine the distribution of genders within each branch.
select Branch, Gender, count(*) as gender_count
from amazon_data.amazon 
group by  Gender, Branch
order by gender_count desc;

-- 25. Identify the time of day when customers provide the most ratings.
select timeofday, count(Rating) as rating_count
from amazon_data.amazon 
group by timeofday
order by rating_count desc limit 1;

-- 26. Determine the time of day with the highest customer ratings for each branch.
select Branch, timeofday, avg(Rating) as average_rating
from amazon_data.amazon 
group by Branch, timeofday
order by average_rating desc;

-- 27. Identify the day of the week with the highest average ratings.
select dayname, avg(Rating) as highest_rating
from amazon_data.amazon
group by dayname
order by highest_rating desc limit 1;

-- 28. Determine the day of the week with the highest average ratings for each branch.
select Branch, dayname, avg(Rating) as avg_rating
from amazon_data.amazon 
group by Branch, dayname
order by avg_rating desc;

select * from amazon_data.amazon;
