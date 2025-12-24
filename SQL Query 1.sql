--#coffe consuer count
--how many people in each city are estimated to consume coffee given that 25% of the population does?
select city_name,city_rank,
ROUND((population*0.25)/1000000,2)as popolation_in_millions  
FROM city
order by ROUND((population*0.25)/1000000,2)desc

--total revenue in the last quater of 2023
with CTE AS (
select sum(s.total)as total_revenue,DateName(month,s.sale_date)as month,year(sale_date)as year,t.city_name
from sales s
left join customers c
on s.customer_id= c.customer_id
left join city t
on t.city_id = c.city_id
where DateName(month,s.sale_date) IN('October','November','December') AND YEAR(sale_date)=2023
group by t.city_name,DateName(month,s.sale_date),YEAR(sale_date))
SELECT SUM(total_revenue)as total,city_name
FROM CTE
group by city_name
order by total desc

--sales count for each product
select count(s.sale_id)as sales_count,p.product_name from sales s
left join products p
on s.product_id= p.product_id
group by p.product_name
order by count(s.sale_id) desc

--AVerage sales amount per customer in each city 

select SUM(total)as SUM_Sales,t.city_name,COUNT(distinct c.customer_id)as Total_customer,
SUM(total)/COUNT(distinct c.customer_id)As avg_sales_per_customer
from sales s
left join customers c
on s.customer_id= c.customer_id
left join city t
on t.city_id = c.city_id
group by t.city_name 
order by SUM(total)desc

--city population and coffe consumers
select ROUND((t.population*0.25)/1000000,2)AS poulation_in_millions,count( DISTINCT c.customer_id)as coffe_consumers,t.city_name
from city t
left join customers c
on t.city_id= c.city_id
group by  ROUND((t.population*0.25)/1000000,2),t.city_name
order by count( DISTINCT c.customer_id) desc

