--Top 3 selling products in each city based on sales volume
WITH CTE AS(
select  p.product_id,p.product_name,t.city_name,COUNT(s.sale_id)as sales_volume,
DENSE_RANK() OVER(partition by city_name ORDER BY COUNT(s.sale_id) desc)as ranking
 from  products p
left join sales s
on p.product_id= s.product_id
left join customers c
on s.customer_id =c.customer_id
left join city t
on c.city_id = t.city_id
group by city_name,p.product_id,p.product_name


)
select *
from CTE
where ranking< 4


--Unique customers  from each city that have purchased coffe products
select COUNT(DISTINCT c.customer_id)as unique_customers,t.city_name from sales s
left join customers c
on s.customer_id = c.customer_id
 left join city t
 on c.city_id  = t.city_id
 where s.product_id IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14)
 group by t.city_name
 order by COUNT(DISTINCT s.customer_id )desc

 --find each city and ther average sales per customer and average rent per customer 
 WITH CTE AS(
 select t.city_name,t.estimated_rent ,SUM(s.total)as total_revenue,COUNT(DISTINCT s.customer_id)as total_customers, 
 (SUM(s.total)/COUNT(DISTINCT s.customer_id))as avg_sales_customer
 from sales s
left join customers c
on s.customer_id = c.customer_id
left join city t
on c.city_id= t.city_id
group by city_name,t.estimated_rent
)
SELECT (estimated_rent/total_customers)as avg_rent,city_name,avg_sales_customer,estimated_rent,
total_customers FROM CTE